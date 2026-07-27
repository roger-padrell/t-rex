# T-REgeX
> A basic Regular Expression Engine in pure COBOL

Based on [this article](https://nickdrane.com/build-your-own-regex/)

## Guidelines
Input string length: 256 characters (3 digits)
REGEX length: 256 characters (3 digits)

## What works
Features:
- String validation with the regex syntax defined in the following section.
- Match extraction from a string with a regex expression: **\[THIS FEATURE IS STILL IN DEVELOPMENT, IT DOES NOT WORK PROPERLY AND BEHAVES RANDOMLY\]**
    - ex. expression: "a*b", string: "ccaaabdd"  -> "aaab"

### Regex
What regex features are implemented
| **Syntax** | **Meaning**                                 | **Example** | **matches**          |
|------------|---------------------------------------------|-------------|----------------------|
| a                | Matches the specified character literal     | q           | q                    |
| *                | Matches 0 or more of the previous character/group | a*          | "", a, aa, aaa       |
| ?                | Matches 0 or 1 of the previous character/group    | a?          | "", a                |
| +                | Matches 1 or more of the previous character/group| a+| a, aa, aaa...|
| {x,y}            | Matches from x to y of the previous character/group| a{2,4} | ~~a~~, aa, aaa, aaaa, ~~aaaaa~~|
| .                | Matches any character literal               | .           | a, b, c, d, e ...    |
| ^                | Matches the start of a string               | ^c          | c, ca, caa, cbb ...  |
| $                | Matches the end of a string                 | a$          | ba, baaa, qwerta ... |
| [a-z]            | Matches any lower-case character            | [a-z]       | a, b, c...           |
| [A-Z]            | Matches any upper-case character            | [A-Z]       | A, B, C...           |
| [a-Z] / [a-zA-Z] | Matches any lower or upper case character   |[a-Z][a-zA-Z]| a, B, c, D...        |
| [0-9]            | Matches any digit                           | [0-9]       | 1, 2, 3...           |
| [0-9aaa]         | Matching for a specific char or other values| [0-9aaa]    | 3, 5, a              |
| [^0-9]           | Matches any non-digit (also works with other ranges)| [^0-9]| a, B, !...|
| \a               | Escapes a character or symbol so it can be literally matches | \\* | '*' |
| \a              | The classic regex shorcuts  | \w \W \d \D \S (only negates spaces)|
> If you are reading the markdown directly, both \a examples are incorrect, as they have double backslash so they can be seen when rendered.

> When matching for a specific character in these group matches you must repeat the character three times so it does not get confused ([0-9a-z___] => any digit, any lowercase character, the '_' symbol)


## Usage
### Requirements
Make sure to include all `trex_*.cob` files as modules in your program (`cobc -x yourprogram.cob trex_*.cob`) or compile trex as a library and then add it to your program.

### Matching an expression
Necessary variables:
```cobol
01 pattern               PIC X(256) VALUE SPACES.
01 str                   PIC x(256).
01 matches_bool          PIC 9(1).
01 str_from              PIC 9(3).
01 str_to                PIC 9(3).
```

- pattern: the expression to match against
- str: the string/text to test
- matches_bool: the output.
    - 1 = there is a match
    - 0 = there is no match
- str_from and str_to: range in where the match was found
    - if matches_bool is 0, this may contain random data, do not check only this

Call:
```cobol
CALL "trex_search" USING BY REFERENCE pattern str matches_bool str_from str_to.

*or, if you have line length limits
CALL "trex_search" USING BY REFERENCE pattern str
    matches_bool str_from str_to.
```

Get the match itself:
```cobol
CALL "trex_search" USING BY REFERENCE pattern str
    matches_bool str_from str_to.
DISPLAY str(str_from : str_to - str_from + 1).
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
- It is VERY recommended to use `^` at the start of your pattern and `$` at the end to match the start and end of the validated string (if you are matching the whole string).

## Acknowledgments
- Thanks [Nick Drane](https://nickdrane.com/), the author of the [article](https://nickdrane.com/build-your-own-regex/) I have based this on.
- Thanks to the [GnuCOBOL](https://gnucobol.sourceforge.io/) team for their great open source compiler.

## License
As stated in the `LICENSE` file, this project is under the Apache-2.0 license.