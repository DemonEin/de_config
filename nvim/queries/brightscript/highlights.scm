[
  "if"
  "else"
  "then"
  "sub"
  "function"
  "end"
  "endif"
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

(boolean_literal) @boolean

(comment) @comment

(function_declaration
    . (identifier) @function
)

(binary_operator_expression
    "."
    .
    (identifier) @field
)

(place_dot_expression
    "."
    .
    (identifier) @field
)

(function_call_expression
    .
    (identifier) @function
)
 
(function_call_expression [
    (binary_operator_expression
        "."
        .
        (identifier) @method
    )
    (place_dot_expression
        "."
        .
        (identifier) @method
    )
])

(associative_array_literal_entry
    (identifier) @field
    .
    ":"
)

(const_item
    "#const" @define
    (identifier) @constant
)

