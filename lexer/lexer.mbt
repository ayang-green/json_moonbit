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

pub fn tokenize(input : String) -> Array[@type.Token] {

  //let tokens = []
  let tokens : Array[@type.Token] = []

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

        tokens.push(@type.Token::Str(current))

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

        tokens.push(
          @type.Token::Num(
            string_to_int(current_number)
          )
        )

        current_number = ""
        in_number = false

        match ch {
          ',' => tokens.push(@type.Token::Comma)
          '}' => tokens.push(@type.Token::RBrace)
          ':' => tokens.push(@type.Token::Colon)
          '{' => tokens.push(@type.Token::LBrace)
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

          "true" => tokens.push(@type.Token::True)

          "false" => tokens.push(@type.Token::False)

          "null" => tokens.push(@type.Token::Null)

          _ => ()

        }

        current_word = ""
        in_word = false

        match ch {
          ',' => tokens.push(@type.Token::Comma)
          '}' => tokens.push(@type.Token::RBrace)
          ':' => tokens.push(@type.Token::Colon)
          '{' => tokens.push(@type.Token::LBrace)
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
        '{' => tokens.push(@type.Token::LBrace)
        '}' => tokens.push(@type.Token::RBrace)
        ':' => tokens.push(@type.Token::Colon)
        ',' => tokens.push(@type.Token::Comma)

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
    tokens.push(
      @type.Token::Num(
        string_to_int(current_number)
      )
    )
  }

  // =========================
  // flush word
  // =========================
  if in_word {

    match current_word {

      "true" => tokens.push(@type.Token::True)
      "false" => tokens.push(@type.Token::False)
      "null" => tokens.push(@type.Null)
      _ => ()

    }

  }

  tokens
}

pub fn token_to_string(token : @type.Token) -> String {

  match token {

    @type.LBrace => "LBrace"
    @type.RBrace => "RBrace"
    @type.Colon => "Colon"
    @type.Comma => "Comma"

    @type.Str(s) => "String(" + s + ")"

    @type.Num(n) =>
      "Number(" + n.to_string() + ")"

    @type.True => "True"
    @type.False => "False"
    @type.Null => "Null"
  }
}