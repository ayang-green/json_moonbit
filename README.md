# moonbit-json

A lightweight JSON parser written in MoonBit.

## Status

Work in progress.
Basic token definitions and lexer skeleton have been added.
Basic JSON symbol tokenization is now supported.
MoonBit project initialization and local compilation are completed.
String tokenization is now supported.
Integer number tokenization has been added.
A functional JSON lexer is now implemented.
Basic JSON AST support has been added.
Initial JSON object parsing is now supported.

## Current Features
### Supported JSON Tokens

- `{`
- `}`
- `:`
- `,`
- String
- Integer Number
- `true`
- `false`
- `null`

### Lexer Features

- String tokenization
- Integer number tokenization
- JSON keyword tokenization
- Simple lexer state machine

### Parser Features

- JSON AST definition
- JSON object parsing
- String value parsing
- Integer value parsing
- Boolean value parsing
- Null value parsing
- Multiple object field support

## Example

Input:

{
  "name": "abc",
  "age": 18
}

Output:

{name: JString(abc), age: JNumber(18)}
