pub enum Token {
  LBrace
  RBrace

  Colon
  Comma

  String(String)
  Number(Int)

  True
  False
  Null
}

fn string_to_int(s : String) -> Int {
  let mut result = 0

  for ch in s {
    result = result * 10 + (ch.to_int() - '0'.to_int())
  }

  result
}

pub fn tokenize(input : String) -> Array[Token] {
  let tokens = []

  let mut current = ""
  let mut in_string = false

  let mut current_number = ""
  let mut in_number = false

  let mut current_word = ""
  let mut in_word = false

  for ch in input {

    // =========================
    // STRING MODE
    // =========================

    if in_string {

      if ch == '"' {
        tokens.push(String(current))
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

        tokens.push(Number(string_to_int(current_number)))

        current_number = ""
        in_number = false

        // 这里继续处理当前字符
        match ch {
          ',' => tokens.push(Comma)
          '}' => tokens.push(RBrace)
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
          "true" => tokens.push(True)
          "false" => tokens.push(False)
          "null" => tokens.push(Null)
          _ => ()
        }

        current_word = ""
        in_word = false

        // 继续处理当前字符
        match ch {
          ',' => tokens.push(Comma)
          '}' => tokens.push(RBrace)
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
        '{' => tokens.push(LBrace)
        '}' => tokens.push(RBrace)
        ':' => tokens.push(Colon)
        ',' => tokens.push(Comma)

        // string start
        '"' => {
          in_string = true
        }

        // number start
        '0'..='9' => {
          in_number = true
          current_number = ch.to_string()
        }

        // word start
        'a'..='z' => {
          in_word = true
          current_word = ch.to_string()
        }

        _ => ()
      }

    }

  }

  // 防止数字在结尾
  if in_number {
    tokens.push(Number(string_to_int(current_number)))
  }

  // 防止单词在结尾
  if in_word {

    match current_word {
      "true" => tokens.push(True)
      "false" => tokens.push(False)
      "null" => tokens.push(Null)
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

    String(s) => "String(" + s + ")"

    Number(n) => "Number(" + n.to_string() + ")"

    True => "True"
    False => "False"
    Null => "Null"
  }
}