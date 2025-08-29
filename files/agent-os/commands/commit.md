# Claude Command: Commit

This command helps you create well-formatted commits with conventional commit messages by using the git-workflow agent.

## Usage

To create a commit, just type:

```
/commit
```

## What This Command Does

0. Use the git-workflow agent
1. Checks which files are staged with `git status`
2. If 0 files are staged, automatically adds all modified and new files with `git add`
3. Performs a `git diff` to understand what changes are being committed
4. Analyzes the diff to determine if multiple distinct logical changes are present
5. If multiple distinct changes are detected, suggests breaking the commit into multiple smaller commits
6. For each commit (or the single commit if not split), creates a commit message using conventional commit format

## Best Practices for Commits

- **Atomic commits**: Each commit should contain related changes that serve a single purpose
- **Split large changes**: If changes touch multiple concerns, split them into separate commits
- **Conventional commit format**: Use the format `<type>(<scope>): <description>` where scope is optional and type is one of:
  - `feat`: A new feature (correlates with MINOR in SemVer)
  - `fix`: A bug fix (correlates with PATCH in SemVer)
  - `docs`: Documentation changes
  - `style`: Code style changes (formatting, etc)
  - `refactor`: Code changes that neither fix bugs nor add features
  - `perf`: Performance improvements
  - `test`: Adding or fixing tests
  - `chore`: Changes to the build process, tools, etc.
  - `build`: Changes that affect the build system or external dependencies
  - `ci`: Changes to CI configuration files and scripts
- **Breaking changes**: Mark breaking changes with an exclamation mark after type/scope (e.g., `feat!:` or `feat(api)!:`) or add `BREAKING CHANGE:` footer (correlates with MAJOR in SemVer)
- **Present tense, imperative mood**: Write commit messages as commands (e.g., "add feature" not "added feature")
- **Concise first line**: Keep the first line under 72 characters
- **No Claude Code signature**: Do not include the Claude Code signature in the footer of the commit message

## Guidelines for Splitting Commits

When analyzing the diff, consider splitting commits based on these criteria:

1. **Different concerns**: Changes to unrelated parts of the codebase
2. **Different types of changes**: Mixing features, fixes, refactoring, etc.
3. **File patterns**: Changes to different types of files (e.g., source code vs documentation)
4. **Logical grouping**: Changes that would be easier to understand or review separately
5. **Size**: Very large changes that would be clearer if broken down
6. **Hunks**: Changes must considered by hunk, not whole file

## Examples

Good commit messages:

- feat(auth): add user authentication system
- fix: resolve memory leak in rendering process
- docs(api): update API documentation with new endpoints
- refactor: simplify error handling logic in parser
- fix(components): resolve linter warnings in component files
- chore: improve developer tooling setup process
- feat(validation): implement business logic for transaction validation
- fix: address minor styling inconsistency in header
- fix(auth): patch critical security vulnerability in auth flow
- style: reorganize component structure for better readability
- fix: remove deprecated legacy code
- feat(forms): add input validation for user registration form
- fix(ci): resolve failing CI pipeline tests
- feat(analytics): implement analytics tracking for user engagement
- fix: strengthen authentication password requirements
- feat(a11y): improve form accessibility for screen readers
- build(deps): upgrade webpack to version 5
- ci: add automated testing workflow
- feat(api)!: remove deprecated v1 endpoints

Example of splitting commits:

- First commit: feat(solc): add new solc version type definitions
- Second commit: docs: update documentation for new solc versions
- Third commit: chore: update package.json dependencies
- Fourth commit: feat(api): add type definitions for new API endpoints
- Fifth commit: feat: improve concurrency handling in worker threads
- Sixth commit: fix: resolve linting issues in new code
- Seventh commit: test(solc): add unit tests for new solc version features
- Eighth commit: fix(deps): update dependencies with security vulnerabilities

## Important Notes

- You MUST use the git-workflow agent
- If specific files are already staged, the command will only commit those files
- If no files are staged, it will automatically stage all modified and new files
- The commit message will be constructed based on the changes detected
- Before committing, the command will review the diff to identify if multiple commits would be more appropriate
- If suggesting multiple commits, it will help you stage and commit the changes separately
- Always reviews the commit diff to ensure the message matches the changes
- You **MUST NOT** include Claude Code signature or Co-Authored-By lines in commit messages

## Example of a Plan Output

I'll create 5 atomic commits to properly separate concerns:

*Commit 1: Infrastructure Updates*

**Message**: `chore: update gitignore and vscode settings`
**Files**:

- .gitignore
- .vscode/settings.json

*Commit 2: Common Error Infrastructure*

**Message:** `refactor(errors): introduce common failure types architecture`
**Files**:

- lib/app/common/data/models/failures/ (new directory structure)
- Base failure types for reuse across modules

*Commit 3: Auth Error Refactoring*

**Message:** `refactor(auth): migrate from SupabaseFailure to generic AuthFailure`
**Files**:

- lib/app/modules/auth/data/models/failures/*.dart (all auth failure files)
- lib/app/modules/auth/data/repositories/auth_repository_supabase.dart
- assets/locales/fr_FR.json (auth-related error messages only)

*Commit 4: Persons Domain Models*

**Message:** `feat(persons): add NewPerson entity and enhance domain models`
**Files**:

- lib/app/modules/persons/data/models/entities/person.dart
- lib/app/modules/persons/data/models/entities/person.dto.dart
- lib/app/modules/persons/data/models/requests/*.dart (create and update requests)

*Commit 5: Persons Repository Layer*

**Message:** `feat(persons): implement repository with comprehensive error handling`
**Files**:

- lib/app/modules/persons/data/models/failures/*.dart (all persons failure files)
- lib/app/modules/persons/data/repositories/ (new repository implementation)
- test/app/modules/persons/data/repositories/ (repository tests)

This atomic approach ensures each commit has a single, clear purpose and can be reviewed independently.
