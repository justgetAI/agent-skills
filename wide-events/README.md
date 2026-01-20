# Wide Events

A skill for implementing wide events (canonical log lines) — the modern approach to application logging.

## What are Wide Events?

Instead of scattered log statements throughout your code, emit **one comprehensive event per request** containing everything you need for debugging.

## Key Concepts

- **One event per request** — not 17 scattered log lines
- **High cardinality** — include user_id, request_id, session_id
- **Business context** — subscription tier, cart value, feature flags
- **Emit at end** — build the event throughout, log once when done
- **Tail sampling** — keep errors + slow requests, sample success

## Quick Example

```typescript
// ❌ Old way: scattered, uncorrelated logs
console.log("Processing checkout...");
console.log("Payment failed");
console.log("Error: card_declined");

// ✅ Wide event: one event with full context
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

## See Also

- [SKILL.md](SKILL.md) — Full implementation guide
- [Stripe's Canonical Log Lines](https://stripe.com/blog/canonical-log-lines)
- [Honeycomb's Wide Events](https://www.honeycomb.io/blog/wide-events)
