# Claude Routine Interface Template

Use this section in every routine SKILL file.

## Routine Interface

### Routine Inputs
- `time_window`: scheduling window used for source selection (for example hours or days).
- `max_items`: hard cap for output entities.
- `include_debug`: optional boolean to request more logging details.

### Required MCP Tools
- `mcp__x__tool_name` — list all tools this routine must call.

### Output Sink
- Define the write destination or notification channel used to deliver results.
- Example formats:
  - PushNotification API
  - Obsidian note append/upsert

### Retry Policy
- `max_attempts`: number of execution attempts per routine run.
- `retry_on`: transient failures only (network/RPC/auth-token refresh/429/5xx).
- `backoff_seconds`: sequence to apply between retries.

### Idempotency
- Define the deterministic identifier for a given run window to avoid duplicate writes.
- Skip writes when output for the same window already exists.

### Auth Assumptions
- Runtime must have token access for each MCP server listed.
- Assume read/write scopes match the exact operations in this routine.

### Failure Behavior
- On transient failure: retry according to policy.
- On non-recoverable failure: emit a minimal failure summary to the configured output sink and stop.
