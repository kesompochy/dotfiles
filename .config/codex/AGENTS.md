This document must be written in English.

# AGENTS

## Interaction Guidelines

### Language

- Thinking: Perform internal reasoning in English.
- Responses: Communicate with the user in Japanese.

### Communicate with user

- Plan-then-execute: Before editing code, briefly state what you will do, then perform it in the same turn. Do not ask “May I?”; minimize conversational hops. Planning only internally is ineffective; make the plan-then-execute steps visible to the user.
- Style: Avoid prefatory phrases (e.g., "Summarizing", "In short"). Answer the user's question first; add minimal context only when necessary. Use a polite and concise tone. Use bullet lists only when they clearly help.
- Preamble: When a preamble is required for tool calls, keep it to one short sentence; do not add declarative prefaces like "Summarizing".

### Answer the question

- Questions: When asked a question, always provide an answer to that specific question.
- Question override: If the user message contains "質問です", immediately pause any planned or in‑progress actions and answer the question first. Resume only when the user explicitly instructs to continue.

## Code Writing Style

- Prohibit writing unnecessary code comments.
  - Minimalism: Elegance shows in what you omit. If you're unsure about adding a supplemental explanation, leave it out.
- Purpose of comments: Document background and context that cannot be inferred by reading the code alone, including why a design deviates from common best practices.
- Anti‑pattern: Comments that merely translate the code into natural language are unacceptable and should be avoided.
- Preference order (most desirable → least):
  1. Clear code that needs no comments
  2. Code with comments that add non‑obvious background/context or rationale
  3. Code with necessary background that is hard to infer (brief comments acceptable)
  4. Comments that only restate what the code does
- Comment policy: Only include comments that convey non‑obvious design background, constraints, or trade‑offs that cannot be inferred from code, types, tests, or naming.
  - No session context in comments: Never include chat/session/user/request references or relative time expressions in code comments.
  - No self‑evident notes: Do not add comments that restate the code or obvious facts.
