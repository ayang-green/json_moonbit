pub enum Json { 
  JObject(Array[(String, Json)]) 
  JString(String) 
  JNumber(Int) 
  JBool(Bool) 
  JNull 
}

fn parse_value(tokens : Array[@lexer.Token], start : Int) -> (Json, Int) {

  match tokens[start] {

    TString(s) => (
      JString(s),
      start + 1
    )

    TNumber(n) => (
      JNumber(n),
      start + 1
    )

    True => (
      JBool(true),
      start + 1
    )

    False => (
      JBool(false),
      start + 1
    )

    Null => (
      JNull,
      start + 1
    )

    LBrace => {
      let (obj, next) = parse_object_from(tokens, start)
      (obj, next)
    }

    _ => (
      JNull,
      start + 1
    )
  }
}

fn parse_object_from(tokens : Array[@lexer.Token], start : Int) -> (Json, Int) {

  let mut fields = []
  let mut i = start + 1

  while i < tokens.length() {

    match tokens[i] {

      RBrace => {
        return (
          JObject(fields),
          i + 1
        )
      }


      TString(key) => {

        match tokens[i + 1] {

          Colon => {

            let (value, next) =
              parse_value(tokens, i + 2)


            fields =
              fields + [
                (key, value)
              ]


            i = next


            if i < tokens.length() {

              match tokens[i] {
                Comma => i = i + 1
                _ => ()
              }

            }

          }


          _ => {
            i = i + 1
          }

        }

      }


      _ => {
        i = i + 1
      }

    }

  }


  (
    JObject(fields),
    i
  )
}

// fn parse_object(tokens : Array[@lexer.Token]) -> Json {

//   let mut fields = []

//   let mut i = 1

//   while i < tokens.length() - 1 {

//     match (
//       tokens[i],
//       tokens[i + 1],
//       tokens[i + 2]
//     ) {

//       (
//        TString(key),
//        Colon,
//        TString(value)
//       ) => {

//         fields = fields + [ (key, JString(value))]

//         }

//      (
//         TString(key),
//         Colon,
//         TNumber(value)
//     ) => {

//         fields = fields + [(key, JNumber(value))]

//         }

//     (
//         TString(key),
//         Colon,
//         True
//     ) => {

//        fields = fields + [ (key, JBool(true))]

//         }

//    (
//         TString(key),
//        Colon,
//        False
//     ) => {

//         fields = fields + [(key, JBool(false))]

//         }

//     (
//         TString(key),
//          Colon,
//           Null
//     ) => {

//           fields = fields + [(key, JNull)]

//         }

//     _ => ()

// }

//     i = i + 4

//   }

//   JObject(fields)

// }

pub fn parse(tokens : Array[@lexer.Token]) -> Json {

  if tokens.length() < 2 {

    JNull

  } else {

    match tokens[0] {

      LBrace => {
        let (json, _) = parse_object_from(tokens, 0)
        json
      }

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