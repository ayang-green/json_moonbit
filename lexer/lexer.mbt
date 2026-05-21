pub enum Token {
  LBrace
  RBrace
  Colon
  Comma

  TString(String)
  TNumber(Int)

  True
  False
  Null
}

fn string_to_int(s : String) -> Int {
  let mut result = 0

  let chars = s.to_array()
  let mut i = 0

  while i < chars.length() {
    let ch = chars[i]
    i = i + 1

    result = result * 10 + (ch.to_int() - '0'.to_int())
  }

  result
}

pub fn tokenize(input : String) -> Array[Token] {

  //let tokens = []
  let mut tokens : Array[Token] = []

  let chars = input.to_array()
  let mut i = 0

  let mut current = ""
  let mut in_string = false

  let mut current_number = ""
  let mut in_number = false

  let mut current_word = ""
  let mut in_word = false

  while i < chars.length() {

    let ch = chars[i]
    i = i + 1

    // =========================
    // STRING MODE
    // =========================
    if in_string {

      if ch == '"' {

        tokens = tokens + [TString(current)]

        current = ""
        in_string = false

      } else {

        current = current + ch.to_string()

      }

    }

    // =========================
    // NUMBER MODE
    // =========================
    else if in_number {

      if ch >= '0' && ch <= '9' {

        current_number = current_number + ch.to_string()

      } else {

        tokens = tokens + [TNumber(string_to_int(current_number))]

        current_number = ""
        in_number = false

        match ch {
          ',' => tokens = tokens + [Comma]
          '}' => tokens = tokens + [RBrace]
          ':' => tokens = tokens + [Colon]
          '{' => tokens = tokens + [LBrace]
          _ => ()
        }

      }

    }

    // =========================
    // WORD MODE
    // =========================
    else if in_word {

      if ch >= 'a' && ch <= 'z' {

        current_word = current_word + ch.to_string()

      } else {

        match current_word {

          "true" => tokens = tokens + [True]

          "false" => tokens = tokens + [False]

          "null" => tokens = tokens + [Null]

          _ => ()

        }

        current_word = ""
        in_word = false

        match ch {
          ',' => {tokens = tokens + [Comma]}
          '}' => {tokens = tokens + [RBrace]}
          ':' => {tokens = tokens + [Colon]}
          '{' => {tokens = tokens + [LBrace]}
          _ => ()
        }

      }

    }

    // =========================
    // NORMAL MODE
    // =========================
    else {

      match ch {

        // whitespace
        ' ' => ()
        '\n' => ()
        '\t' => ()
        '\r' => ()

        // symbols
        '{' => {tokens = tokens + [LBrace]}
        '}' => {tokens = tokens + [RBrace]}
        ':' => {tokens = tokens + [Colon]}
        ',' => {tokens = tokens + [Comma]}

        // string
        '"' => {
          in_string = true
        }

        // number
        '0'..='9' => {
          in_number = true
          current_number = ch.to_string()
        }

        // word
        'a'..='z' => {
          in_word = true
          current_word = ch.to_string()
        }

        _ => ()

      }

    }

  }

  // =========================
  // flush number
  // =========================
  if in_number {
    tokens = tokens + [TNumber(string_to_int(current_number))]
  }

  // =========================
  // flush word
  // =========================
  if in_word {

    match current_word {

      "true" => {tokens = tokens + [True]}
      "false" => {tokens = tokens + [False]}
      "null" => {tokens = tokens + [Null]}
      _ => ()

    }

  }

  tokens
}

pub fn token_to_string(token : Token) -> String {

  match token {

    LBrace => "LBrace"
    RBrace => "RBrace"
    Colon => "Colon"
    Comma => "Comma"

    TString(s) => "String(" + s + ")"

    TNumber(n) =>
      "Number(" + n.to_string() + ")"

    True => "True"
    False => "False"
    Null => "Null"
  }
}