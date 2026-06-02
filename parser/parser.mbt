pub enum Json { 
  JObject(Array[(String, Json)]) 
  JString(String) 
  JNumber(Int) 
  JBool(Bool) 
  JNull 
}

fn parse_object(tokens : Array[@lexer.Token]) -> Json {

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

        fields = fields + [ (key, JString(value))]

        }

     (
        TString(key),
        Colon,
        TNumber(value)
    ) => {

        fields = fields + [(key, JNumber(value))]

        }

    (
        TString(key),
        Colon,
        True
    ) => {

       fields = fields + [ (key, JBool(true))]

        }

   (
        TString(key),
       Colon,
       False
    ) => {

        fields = fields + [(key, JBool(false))]

        }

    (
        TString(key),
         Colon,
          Null
    ) => {

          fields = fields + [(key, JNull)]

        }

    _ => ()

}

    i = i + 4

  }

  JObject(fields)

}

pub fn parse(tokens : Array[@lexer.Token]) -> Json {

  if tokens.length() < 2 {

    JNull

  } else {

    match (
      tokens[0],
      tokens[tokens.length() - 1]
    ) {

      (
        LBrace,
        RBrace
      ) => parse_object(tokens)

      _ => JNull

    }

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

    JObject(obj) => {

      let mut result = "{"

      let mut i = 0

      while i < obj.length() {

       let (key, value) = obj[i]

        if i > 0 {
          result = result + ", "
        }

        result =result + key  + ": " + json_to_string(value)

        i = i + 1
      }

      result + "}"

    }
  }
}