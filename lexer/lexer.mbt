pub fn tokenize(input : String) -> Array[Token] {
  let tokens = []
  let mut current = ""
  let mut in_string = false

  for ch in input {
    match ch {
      '{' => tokens.push(LBrace)
      '}' => tokens.push(RBrace)
      ':' => tokens.push(Colon)
      ',' => tokens.push(Comma)

      '"' => {
        if in_string {
          tokens.push(String(current))
          current = ""
        }
        in_string = !in_string
      }

      _ => {
        if in_string {
          current = current + ch.to_string()
        }
      }
    }
  }

  tokens
}

pub enum Token {
  LBrace
  RBrace
  Colon
  Comma
  String(String)
}

pub fn token_to_string(token : Token) -> String {
  match token {
    LBrace => "LBrace"
    RBrace => "RBrace"
    Colon => "Colon"
    Comma => "Comma"
    String(s) => "String(" + s + ")"
  }
}