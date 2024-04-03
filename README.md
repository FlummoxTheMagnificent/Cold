# Cold Programming Language
This is a small programming language I'm working on. I'd like to make it extremely object-oriented and add easy support for tree traversal and neural networks in the future.

## Comments
Lines starting with `#` are considered comments and will be ignored. You can also use it in the middle of a line to ignore its remainder. The `'` character can also be used for comments; it ignores everything between two of them.

## Variables
Variables are assigned using `:=` and reassigned using `=`. They can hold types int (`i64`), float (`float`), or string (`i8*`).

## Built-in Functions
- `println()`: Prints the given text followed by a newline. Accepts any number of arguments, which are automatically joined.
- `print()`: Works like `println()` but without the newline.
- `typeof()`: Accepts one argument and returns the type of the given variable.
