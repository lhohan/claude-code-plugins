---
description: Split text into Bluesky thread messages with intelligent breaks and suggestions
---

You are tasked with splitting text into Bluesky-compatible thread messages. Bluesky has a 300 character limit per post.

The user input below is either a file path or raw text:

{{prompt}}

## Task Instructions

1. **Detect Input Type**:
   - If input starts with `@`, it's a Claude Code file reference - convert to absolute path and read it
   - Check if the input is a file path (absolute paths or paths ending with common extensions like .txt, .md, etc.)
   - If it looks like a file path, use the Read tool to load the file content
   - If a file path is provided but doesn't have an extension (like LICENSE), still try to read it as a file
   - Otherwise, treat the entire input as the text to split

2. **Split Algorithm**:
   - Target: 300 characters per message (use ~280-290 character soft limit to leave room for thread numbering like "[1/5] ")
   - Split at natural boundaries in this order of preference:
     1. Paragraph breaks (empty lines)
     2. Sentence endings (periods, question marks, exclamation marks)
     3. Clause boundaries (commas, semicolons)
     4. Word boundaries (last resort)
   - Never split mid-word or mid-sentence unless absolutely necessary
   - Preserve leading/trailing whitespace handling for readability

3. **Output Format**:
   - Start with a header showing total message count: `=� This will create X messages for your Bluesky thread:`
   - Separate each message clearly with a visual divider
   - For each message, show:
     - Message label: `[N/TOTAL]`
     - Character count: `(NNN chars)` - count includes the "[N/TOTAL] " prefix
     - The actual message text with the `[N/TOTAL] ` prefix included
   - Include empty lines between messages for readability

4. **Suggested Improvements** (only if improvements are actually applicable):
   - After all messages, add a "=� Suggested improvements:" section
   - Suggest alternative thread break points that improve narrative flow or pacing
   - Propose minor clarity edits that maintain tone and content (grammar, awkward phrasing, etc.)
   - Format: `- [Message N] Suggestion here` or `- [Overall] Suggestion here`
   - Only include suggestions that genuinely improve the content

## Example Output Format

```
=� This will create 2 messages for your Bluesky thread:

 Message 1/2 
[1/2] Your first message text here that fits within 300 characters. This is the content that will be posted as the first message in the thread.

 Message 2/2 
[2/2] Your second message continues the thread. Make sure the content flows naturally from the first message and maintains the overall tone.

=� Suggested improvements:
- Consider a line break earlier in message 1 for better pacing
- Message 2: "continues the thread" � "continues naturally" (slightly more concise)
```

Now proceed with splitting the user's text according to these instructions.
