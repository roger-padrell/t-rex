# T-REgeX
> A basic Regular Expression Engine in pure COBOL

Based on [this article](https://nickdrane.com/build-your-own-regex/)

## Guidelines
Input string length: 256 characters (3 digits)
REGEX length: 256 characters (3 digits)

## What works (from the article)
| **Syntax** | **Meaning**                                 | **Example** | **matches**          |
|------------|---------------------------------------------|-------------|----------------------|
| a          | Matches the specified character literal     | q           | q                    |
| *          | Matches 0 or more of the previous character | a*          | "", a, aa, aaa       |
| ?          | Matches 0 or 1 of the previous character    | a?          | "", a                |
| .          | Matches any character literal               | .           | a, b, c, d, e ...    |
| ^          | Matches the start of a string               | ^c          | c, ca, caa, cbb ...  |
| $          | Matches the end of a string                 | a$          | ba, baaa, qwerta ... |

## Usage
### Requirements
Make sure to include these in your program (ex. `cobc -x your_program.cob trex_match.cob trex_matchOne.cob trex_matchQuestion.cob trex_matchStar.cob trex_search.cob` or `cobc -x yourprogram.cob trex_*.cob`).
```
├── trex_match.cob
├── trex_matchOne.cob
├── trex_matchQuestion.cob
├── trex_matchStar.cob
└── trex_search.cob
```

### Matching an expression
Necessary variables:
```cobol
01 pattern               PIC X(256) VALUE SPACES.
01 str                   PIC x(256).
01 matches_bool          PIC 9(1).
```

- pattern: the expression to match against
- str: the string/text to test
- matches_bool: the output.
    - 1 = there is a match
    - 0 = there is no match

Call:
```cobol
CALL "trex_search" USING BY REFERENCE pattern str matches_bool.

*or, if you have line length limits
CALL "trex_search" USING BY REFERENCE pattern str
    matches_bool.
```

The `USING BY REFERENCE` is very important, as it lets the module edit the `matches_bool` variable, returning an output.

## Testing
I have created a little script `test.sh` that can run different tests suites from `tests.json`.

### Test suites
The available test suites are:
- `matchOne`: single-character matching
- `match`: general matching
- `search`: boundary searching + complete library

### Requirements
- linux
- bash
- cobc
- jq

### Options
```
-c, --config FILE    Specify config file (default: tests.json)
-d, --debug          Enable COBOL debugging lines
-s, --silent         Hide the program's output
-l, --list           List all available tests
-h, --help           Show this help messageç
```

### Examples
```bash
./test.sh test_name
./test.sh -d test_name
./test.sh -s test_name
./test.sh --config custom.json my_test
./test.sh -l
```

## Considerations
- I know that there are better ways to do a lot of things (returning from a function, string utilities...) but I prefer to use _pure_, older-standard COBOL to make it easier for other persons to use it.
- This module does not use any external tools (C, C++, Go, Java, C#...) or programs.
- I have tested the following standards (with `cobc`):
    - ibm

## Acknowledgments
- Thanks [Nick Drane](https://nickdrane.com/), the author of the [article](https://nickdrane.com/build-your-own-regex/) I have based this on.
- Thanks to the [GnuCOBOL](https://gnucobol.sourceforge.io/) team for their great open source compiler.

## License
As stated in the `LICENSE` file, this project is under the Apache-2.0 license.