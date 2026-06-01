///|
/// Entry point for the CLI or runnable program in this template.
/// Keep main focused; move logic into the library package.
/// Run with `moon run cmd/main` from the project root.
fn main {
  // let input = 
  //   "{\"name\":\"abc\",\"age\":18,\"ok\":true,\"data\":null}"

  // let tokens = @lexer.tokenize(input)

  // for token in tokens {
  //   println(@lexer.token_to_string(token))
  // }

  let input = "{\"name\":\"abc\",\"age\":18}"

  let tokens = @lexer.tokenize(input)

  let ast = @parser.parse(tokens)
  println(@parser.json_to_string(ast))
}