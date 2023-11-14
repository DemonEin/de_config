[
  "if"
  "else"
  "then"
  "sub"
  "function"
  "end"
  "stop"
  "goto"
  "return"
  "for"
  "to"
  "each"
  "in"
  "while"
  "exit"
  "continue"
  "try"
  "catch"
  "throw"
] @keyword

[
  "("
  ")"
  "{"
  "}"
  ","
  ";"
  ":"
  "as"
] @punctuation

[
  "."
  "["
  "]"
  "?"
  "?."
  "?@"
  "^"
  "*"
  "/"
  "\\"
  "mod"
  "+"
  "-"
  "<<"
  ">>"
  "<"
  ">"
  "="
  "-="
  "+="
  "<>"
  "<="
  ">="
  "and"
  "or"
] @operator

[
  "print"
] @function

(type) @type

(string_literal) @string

(number_literal) @number

(comment) @comment

(function_declaration
    . (identifier) @function
)

(function_call_expression
    . (identifier) @function
)
