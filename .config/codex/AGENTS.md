# AGENTS

## Interaction Guidelines

- Thinking: Perform internal reasoning in English.
- Responses: Communicate with the user in Japanese.
- Before proposing code edits, first explicitly state the plan in natural language.

## Code Writing Style

- Purpose of comments: Document background and context that cannot be inferred by reading the code alone, including why a design deviates from common best practices.
- Anti‑pattern: Comments that merely translate the code into natural language are unacceptable and should be avoided.
- Preference order (most desirable → least):
  1. Clear code that needs no comments
  2. Code with comments that add non‑obvious background/context or rationale
  3. Code where the background is difficult to infer
  4. Comments that only restate what the code does
