[
  "if"
  "else"
  "then"
  "sub"
  "function"
  "endsub"
  "endfunction"
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
  "not"
  "++"
  "--"
] @operator

[
  "print"
] @function

(type) @type

(string_literal) @string

(number_literal) @number

(boolean_literal) @boolean

(invalid_literal) @constant.builtin

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

(const_if_block
    [
        "#if"
        "#else"
        "#end"
        "if"
    ] @define
)

(const_else_block
    [
        "#else"
    ] @define
)

(const_else_if_block
    [
        "#else"
        "if"
    ] @define
)

