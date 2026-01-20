# Logging Standards

Our standard approach to application logging.

## Core Principle

**One event per request. Full context. No scattered log statements.**

## Quick Example

```typescript
// ❌ Don't: scattered, uncorrelated logs
console.log("Processing checkout...");
console.log("Payment failed");
console.log("Error: card_declined");

// ✅ Do: one event with full context
{
  "request_id": "req_abc123",
  "user_id": "user_456",
  "user_subscription": "premium",
  "path": "/api/checkout",
  "cart_total_cents": 15999,
  "payment_method": "card",
  "status_code": 500,
  "error_code": "card_declined",
  "duration_ms": 1247
}
```

## Key Rules

1. **One event per request** — build throughout, emit at end
2. **Include business context** — user tier, cart value, feature flags
3. **High cardinality fields** — user_id, request_id, session_id
4. **Structured JSON** — not string messages
5. **Tail sampling** — keep errors + slow, sample success

## See Also

- [SKILL.md](SKILL.md) — Full implementation guide
