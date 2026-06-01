pub enum Json { 
  JObject(Array[(String, Json)]) 
  JString(String) 
  JNumber(Int) 
  JBool(Bool) 
  JNull 
}

fn parse_object(
  tokens : Array[@lexer.Token]
) -> Json {

  let mut fields = []

  let mut i = 1

  while i < tokens.length() - 1 {

    match (
      tokens[i],
      tokens[i + 1],
      tokens[i + 2]
    ) {

      (
        TString(key),
        Colon,
        TString(value)
      ) => {

        fields = fields + [
          (key, JString(value))
        ]

      }

      (
        TString(key),
        Colon,
        TNumber(value)
      ) => {

        fields = fields + [
          (key, JNumber(value))
        ]

      }

      _ => ()

    }

    i = i + 4

  }

  JObject(fields)

}

pub fn parse(tokens : Array[@lexer.Token]) -> Json {
  if tokens.length() == 5 {
    match (
      tokens[0],
      tokens[1],
      tokens[2],
      tokens[3],
      tokens[4]
    ) {
      (
        LBrace,
        TString(key),
        Colon,
        TString(value),
        RBrace
      ) => {
        JObject([
          (key, JString(value))
        ])
      }

      _ => JNull
    }
  } else {
    JNull
  }
}

pub fn json_to_string(json : Json) -> String {
  match json {
    JNull => "JNull"

    JString(s) =>
      "JString(" + s + ")"

    JNumber(n) =>
      "JNumber(" + n.to_string() + ")"

    JBool(b) =>
      "JBool(" + b.to_string() + ")"

    JObject(_obj) =>
      "JObject(...)"
  }
}