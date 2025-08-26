# Claude Command: Lint

This command runs linting checks using Just if a Justfile is present in the current project.

## Usage

To run linting checks, just type:

```
/lint
```

## What This Command Does

1. Checks if a `Justfile` exists in the current directory or any parent directory
2. If a Justfile is found, runs `just lint` to execute linting checks
3. If no Justfile is found, informs you that no Justfile was detected
4. If linting failures are detected, provides a summary of the issues
5. Asks if you want Claude to propose fixes for the detected issues

## How It Works

The command will:
- Search for a `Justfile` starting from the current directory and walking up the directory tree
- Execute `just lint` if a Justfile is found
- Parse the output to identify any linting errors or warnings
- Summarize the issues in a clear, actionable format
- Offer to help fix the detected problems

## Examples

Successful linting:
```
✓ Linting completed successfully - no issues found
```

Linting with issues:
```
Found 3 linting issues:
- src/main.py:42: E501 line too long (87 > 79 characters)
- src/utils.py:15: F401 'os' imported but unused
- src/config.py:8: W292 no newline at end of file

Would you like me to propose fixes for these issues?
```

No Justfile found:
```
No Justfile found in current directory or parent directories.
```

## Benefits

- Quick way to check code quality before committing
- Integrated with your existing Just-based workflow
- Provides actionable feedback on linting issues
- Offers automated fix suggestions
- Works with any linting tools configured in your Justfile
