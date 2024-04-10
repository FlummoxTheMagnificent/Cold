# Cold Programming Language
This is a small programming language I'm working on. I'd like to make it extremely object-oriented and add easy support for tree traversal and neural networks in the future.

## Comments
Lines starting with `#` are considered comments and will be ignored. You can also use it in the middle of a line to ignore its remainder. The `'` character can also be used for comments; it ignores everything between two of them.

## Variables
Variables are assigned using `:=` and reassigned using `=`. They can hold types int, float, string, or bool.

## If Statements
If statements have the same syntax as Python:
```
if [condition]:
	[code]
```
Else statements are optional, and can be written as:
```
if [condition]:
	[code]
else:
	[other code]
```

## While Loops
While loops, like if statements, are similar to Python:
```
while [condition]:
	[code]
```
## Built-in Functions
- `println()`: Prints the given text followed by a newline. Accepts any number of arguments, which are automatically joined.
- `print()`: Works like `println()` but without the newline.
- `typeof()`: Accepts one argument and returns the type of the given variable.
- `str()`: Converts one item to a string

# Example Programs
### Example FizzBuzz program:
```
i := 0
while i < 100:
	i = i + 1
	value := ""
	if i % 3 = 0:
		value = "Fizz"
	if i % 5 = 0:
		value = value + "Buzz"
	if value = "":
		println(i)
	else:
		println(value)
```