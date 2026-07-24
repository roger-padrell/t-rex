#!/bin/bash

set -euo pipefail

# Color output for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CONFIG_FILE="${CONFIG_FILE:-tests.json}"
TEMP_DIR=".cobol_tests_tmp"
EXECUTABLE_DIR="${TEMP_DIR}/bin"
DEBUG_LINES=0
SILENT_MODE=0
run_all=0

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_error() {
    print_status "${RED}" "❌ $1"
}

print_success() {
    print_status "${GREEN}" "✅ $1"
}

print_info() {
    print_status "${BLUE}" "ℹ️  $1"
}

print_warning() {
    print_status "${YELLOW}" "⚠️  $1"
}

# Function to show usage
usage() {
    cat << EOF
Usage: $0 [OPTIONS] [test_name]

OPTIONS:
    -c, --config FILE    Specify config file (default: tests.json)
    -d, --debug          Enable COBOL debugging lines
    -a, --all            Run all tests
    -s, --silent         Hide the program's output
    -l, --list           List all available tests
    -h, --help           Show this help message

EXAMPLES:
    $0 test_name
    $0 -d test_name
    $0 -s test_name
    $0 --config custom.json my_test
    $0 -l
    $0 -a
    $0 -a -d
    $0 -a -s
EOF
    exit 0
}

# Function to parse JSON using jq
parse_test() {
    local file=$1
    local test_name=$2

    if ! command -v jq &> /dev/null; then
        print_error "jq is required to parse JSON files. Please install jq."
        exit 1
    fi

    jq -r --arg name "$test_name" '.tests[] | select(.name == $name) | @json' "$file"
}

get_all_tests() {
    local file=$1

    if ! command -v jq &> /dev/null; then
        print_error "jq is required to parse JSON files. Please install jq."
        exit 1
    fi

    jq -r '.tests[].name' "$file"
}

# Function to list all tests
list_tests() {
    local file=$1

    if [[ ! -f "$file" ]]; then
        print_error "Config file not found: $file"
        exit 1
    fi

    if ! command -v jq &> /dev/null; then
        print_error "jq is required to parse JSON files. Please install jq."
        exit 1
    fi

    print_info "Available tests in $file:"
    echo ""
    jq -r '.tests[] | .name' "$file"
    echo ""
}

# Function to extract test properties from JSON string
extract_property() {
    local json_str=$1
    local property=$2
    echo "$json_str" | jq -r ".$property // empty"
}

# Function to extract array from JSON string
extract_array() {
    local json_str=$1
    local property=$2
    echo "$json_str" | jq -r ".${property}[] // empty"
}

# Function to compile COBOL program
compile_cobol() {
    local main_file=$1
    local std=$2
    local output_file=$3
    shift 3
    local modules=("$@")

    local compile_cmd="cobc -x -std=${std}"

    if [[ $DEBUG_LINES -eq 1 ]]; then
        compile_cmd+=" -fdebugging-line"
    fi

    compile_cmd+=" -o ${output_file}"
    compile_cmd+=" ${main_file}"

    for module in "${modules[@]}"; do
        compile_cmd+=" ${module}"
    done

    print_info "Compiling with: $compile_cmd"

    if eval "$compile_cmd"; then
        print_success "Compilation successful"
        return 0
    else
        print_error "Compilation failed"
        return 1
    fi
}

# Function to parse and validate tests from program output
check_tests() {
    local output="$1"

    local line
    local input=""
    local actual=""
    local expected=""

    local total=0
    local passed=0
    local failed=0

    echo ""
    print_info "Test results"
    echo ""

    while IFS= read -r line; do
        [[ $line != Input:* ]] && continue

        input="${line#Input: }"

        if ! IFS= read -r line; then
            break
        fi

        if [[ $line != Output:* ]]; then
            print_warning "Malformed test for \"$input\" (missing Output)"
            continue
        fi

        actual="${line#Output: }"

        if ! IFS= read -r line; then
            break
        fi

        if [[ $line != Expected:* ]]; then
            print_warning "Malformed test for \"$input\" (missing Expected)"
            continue
        fi

        expected="${line#Expected: }"

        ((total++))

        if [[ "$actual" == "$expected" ]]; then
            ((passed++))
            print_success "$input: $actual (expected $expected)"
        else
            ((failed++))
            print_error "$input"
            echo "    Output:   $actual"
            echo "    Expected: $expected"
            echo
        fi
    done <<< "$output"

    echo ""
    echo "========================================"
    echo "Tests run   : $total"
    print_success "Passed   : $passed"

    if [[ $failed -eq 0 ]]; then
        print_success "Failed   : $failed"
    else
        print_error "Failed   : $failed"
    fi
    echo "========================================"

    [[ $failed -eq 0 ]]
}

# Function to run compiled program
run_program() {
    local executable=$1

    print_info "Running: $executable"
    echo ""

    local output=""
    local exit_code=0

    output="$("$executable")" || exit_code=$?

    # Show the raw program output first
    if [[ $SILENT_MODE -eq 0 ]]; then
        echo "$output"
    fi

    # Then analyze the tests
    if ! check_tests "$output"; then
        return 1
    fi

    if [[ $exit_code -eq 0 ]]; then
        print_success "Program executed successfully"
    else
        print_warning "Program exited with code: $exit_code"
    fi

    return $exit_code
}

# Function to cleanup temporary files
cleanup() {
    if [[ -d "$TEMP_DIR" ]]; then
        print_info "Cleaning up temporary files..."
        rm -rf "$TEMP_DIR"
    fi
}

# Setup trap to cleanup on exit
trap cleanup EXIT

run_test() {
    local test_name=$1

    print_info "Looking for test: $test_name"

    # Validate config file exists
    if [[ ! -f "$CONFIG_FILE" ]]; then
        print_error "Config file not found: $CONFIG_FILE"
        return 1
    fi

    # Get test configuration
    local test_json
    test_json=$(parse_test "$CONFIG_FILE" "$test_name")

    if [[ -z "$test_json" ]]; then
        print_error "Test not found: $test_name"
        list_tests "$CONFIG_FILE"
        return 1
    fi

    # Extract test properties
    local main_file
    local std
    local modules=()

    main_file=$(extract_property "$test_json" "main")
    std=$(extract_property "$test_json" "std")

    # Default to ibm if not specified
    std="${std:-ibm}"

    # Extract modules into array
    while IFS= read -r module; do
        [[ -n "$module" ]] && modules+=("$module")
    done < <(extract_array "$test_json" "modules")

    # Validate main file exists
    if [[ ! -f "$main_file" ]]; then
        print_error "Main file not found: $main_file"
        return 1
    fi

    # Validate modules exist
    for module in "${modules[@]}"; do
        if [[ ! -f "$module" ]]; then
            print_error "Module file not found: $module"
            return 1
        fi
    done

    print_success "Test configuration loaded"
    echo "  Name:       $test_name"
    echo "  Main file:  $main_file"
    echo "  Standard:   $std"
    echo "  Debugging:  $([[ $DEBUG_LINES -eq 1 ]] && echo "Enabled" || echo "Disabled")"

    if [[ ${#modules[@]} -gt 0 ]]; then
        echo "  Modules:"
        for module in "${modules[@]}"; do
            echo "    - $module"
        done
    fi
    echo ""

    # Create temporary directory
    mkdir -p "$EXECUTABLE_DIR"

    # Compile
    local executable="${EXECUTABLE_DIR}/${test_name}"

    if ! compile_cobol "$main_file" "$std" "$executable" "${modules[@]}"; then
        return 1
    fi

    echo ""

    # Run
    if ! run_program "$executable"; then
        return 1
    fi
}

# Main function
main() {
    local test_name=""
    local list_mode=0

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                ;;
            -l|--list)
                list_mode=1
                shift
                ;;
            -d|--debug)
                DEBUG_LINES=1
                shift
                ;;
            -a|--all)
                run_all=1
                shift
                ;;
            -c|--config)
                CONFIG_FILE="$2"
                shift 2
                ;;
            -s|--silent)
                SILENT_MODE=1
                shift
                ;;
            -*)
                print_error "Unknown option: $1"
                usage
                ;;
            *)
                test_name="$1"
                shift
                ;;
        esac
    done

    # List tests if requested
    if [[ $list_mode -eq 1 ]]; then
        list_tests "$CONFIG_FILE"
        return 0
    fi

    if [[ $run_all -eq 1 ]]; then
        local total=0
        local passed=0
        local failed=0

        while IFS= read -r test; do
            [[ -z "$test" ]] && continue

            echo ""
            echo "=================================================="
            print_info "Running test: $test"
            echo "=================================================="

            ((total++))

            if run_test "$test"; then
                ((passed++))
            else
                ((failed++))
            fi
        done < <(get_all_tests "$CONFIG_FILE")

        echo ""
        echo "=================================================="
        echo "Overall summary"
        echo "=================================================="
        echo "Tests : $total"

        if [[ $passed -gt 0 ]]; then
            print_success "Passed : $passed"
        else
            echo "Passed : 0"
        fi

        if [[ $failed -eq 0 ]]; then
            print_success "Failed : 0"
        else
            print_error "Failed : $failed"
        fi

        [[ $failed -eq 0 ]]
        return
    fi

    # Require test name
    if [[ -z "$test_name" ]]; then
        print_error "Test name is required"
        echo ""
        usage
    fi

    run_test "$test_name"
}

# Run main function
main "$@"