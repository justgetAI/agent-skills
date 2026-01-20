---
name: logging-standards
description: Our standard approach to logging. One event per request with full business context. No scattered log statements.
compatibility: Any backend framework (Hono, Express, Fastify, etc.)
---

# Logging Standards

One event per request. Full context. No more grep-ing.

## Core Principle

**Stop logging what code does. Log what happened to this request.**

```
# Bad: 17 scattered log lines
console.log("Processing order...")
console.log("Validating payment...")
console.log("Payment failed")

# Good: 1 wide event with everything
{ request_id, user_id, cart_total, payment_method, error_code, duration_ms, ... }
```

---

## Implementation Pattern

### 1. Initialize at request start

```typescript
const event = {
  request_id: generateId(),
  timestamp: new Date().toISOString(),
  method: req.method,
  path: req.path,
  service: SERVICE_NAME,
  version: SERVICE_VERSION,
};
```

### 2. Enrich throughout lifecycle

```typescript
// Add user context
event.user = { id, subscription, account_age_days, lifetime_value };

// Add business context
event.cart = { id, item_count, total_cents, coupon };

// Add operation results
event.payment = { method, provider, latency_ms, attempt };
```

### 3. Emit once at end

```typescript
finally {
  event.duration_ms = Date.now() - startTime;
  event.status_code = res.status;
  event.outcome = error ? "error" : "success";
  
  if (error) {
    event.error = { type: error.name, code: error.code, message: error.message };
  }
  
  logger.info(event);
}
```

---

## Required Fields (minimum viable)

| Field | Why |
|-------|-----|
| `request_id` | Correlate across services |
| `timestamp` | When it happened |
| `service` | Which service |
| `method` + `path` | What endpoint |
| `status_code` | Success/failure |
| `duration_ms` | Performance |
| `user_id` | Who was affected |

## High-Value Fields (add these)

| Field | Enables |
|-------|---------|
| `user.subscription` | "Are premium users affected?" |
| `user.lifetime_value` | Prioritize high-value customers |
| `feature_flags` | "Did the new feature cause this?" |
| `deployment_id` | "Which deploy broke it?" |
| `error.code` | Group errors by type |
| `*.latency_ms` | Find slow dependencies |

---

## Event Naming

Format: `{resource}_{action}_{state}`

```
checkout_payment_failed
order_created
user_session_expired
webhook_processed
```

---

## Tail-Based Sampling

Keep costs down without losing signal:

```typescript
function shouldSample(event): boolean {
  if (event.status_code >= 500) return true;      // Always keep errors
  if (event.error) return true;                    // Always keep failures
  if (event.duration_ms > P99_THRESHOLD) return true;  // Keep slow requests
  if (event.user?.subscription === "enterprise") return true;  // Keep VIPs
  return Math.random() < 0.05;  // Sample 5% of success
}
```

---

## Anti-Patterns

| Don't | Do |
|-------|-----|
| `console.log("Processing...")` | Build event, emit at end |
| `log("Error: " + message)` | `event.error = { type, code, message }` |
| Log only on errors | Log every request (sample if needed) |
| String messages | Structured JSON objects |
| Low-cardinality only | Include user_id, request_id, etc. |

---

## Debugging Queries (what you get)

```sql
-- Error rate by subscription tier
SELECT user.subscription, COUNT(*) as errors
FROM events WHERE status_code >= 500
GROUP BY user.subscription

-- Impact of feature flag
SELECT feature_flags.new_checkout, 
       AVG(duration_ms), 
       SUM(CASE WHEN error THEN 1 ELSE 0 END) as errors
FROM events GROUP BY feature_flags.new_checkout

-- Find user's journey
SELECT * FROM events 
WHERE user_id = 'user_123' 
ORDER BY timestamp DESC
```

---

## Hono/Cloudflare Example

```typescript
app.use("*", async (c, next) => {
  const event: Record<string, any> = {
    request_id: crypto.randomUUID(),
    timestamp: new Date().toISOString(),
    method: c.req.method,
    path: c.req.path,
    service: "my-worker",
  };
  
  c.set("event", event);
  const start = Date.now();
  
  try {
    await next();
    event.status_code = c.res.status;
    event.outcome = "success";
  } catch (err) {
    event.status_code = 500;
    event.outcome = "error";
    event.error = { type: err.name, message: err.message };
    throw err;
  } finally {
    event.duration_ms = Date.now() - start;
    console.log(JSON.stringify(event));
  }
});
```

---

## Migration Path

1. Add middleware that builds + emits wide event
2. In handlers, enrich `c.get("event")` with business context
3. Keep existing console.logs temporarily
4. Once wide events are verified, remove scattered logs
5. Add sampling if volume is too high
