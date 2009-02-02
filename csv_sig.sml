signature CSV = 
sig
  datatype token = Tok of string

  val parse : string -> token list
end
