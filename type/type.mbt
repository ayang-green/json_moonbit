pub enum Token {
  LBrace
  RBrace
  Colon
  Comma

  Str(String)
  Num(Int)

  True
  False
  Null
}

pub enum Json {
  JObject(Array[(String, Json)])
  JString(String)
  JNumber(Int)
  JBool(Bool)
  JNull
}