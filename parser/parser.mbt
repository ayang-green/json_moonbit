pub enum Json { 
  JObject(Array[(String, Json)]) 
  JString(String) 
  JNumber(Int) 
  JBool(Bool) 
  JNull 
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