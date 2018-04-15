
# TODO: Automated Shim Creation

The current implementation uses `#Include` shims that was created manually.

In the future, create a batch script that when passed with any number of arguments, simply creates an ahk file for each argument. Where each generated ahk simply contains a `#Include …` to the given argument.

Each argument is transformed into an absolute path if they're not located in the user's AutoHotkey directory. Otherwise, they're absolute paths starts from the user's AutoHotkey directory via a built-in ahk variable (i.e., `%A_MyDocuments%\AutoHotkey\`) instead.
