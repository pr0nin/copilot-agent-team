---
name: dotnet-conventions
description: "C#/.NET coding standards, SOLID principles, and feature patterns for clean architecture"
applyTo: ["**/*.cs"]
---

# C# Coding Standards

## Language Features

- Use latest stable **.NET** and **C#** features
  - When creating new projects and solutions, check what the current LTS version is and target that version of .NET
- Modern constructs: file-scoped namespaces, records, pattern matching, primary constructors, collection expressions
- Use `Span<T>` for performance-critical code

## Design Principles

- Follow **SOLID principles**
- Prefer explicit, dependency-injected designs
- Keep code self-documenting — minimize comments, refactor for clarity

## Naming Conventions

| Element | Style | Example |
|---------|-------|---------|
| Classes/Interfaces | PascalCase | `CustomerService`, `ICustomerRepository` |
| Methods/Properties | PascalCase | `Execute`, `CustomerId` |
| Parameters/Locals | camelCase | `customerId`, `result` |
| Private fields | camelCase | `customer`, `logger` |
| Constants | PascalCase | `MaxRetryCount` |
| Async methods | **No** "Async" suffix | `GetCustomer()` not `GetCustomerAsync()` |

## Nullability

- Enable **nullable reference types** in all projects
- Use `string?` for nullable, `string` for non-nullable
- Use null-forgiving (`!`) sparingly — prefer null checks

## Exception Handling

- Validate inputs at public API boundaries — fail fast
- Throw meaningful exceptions (`ArgumentNullException`, `InvalidOperationException`)
- Catch at application boundaries when you can handle/recover
- **Never** swallow exceptions or use them for control flow

## Logging

- Use **structured logging** with message templates:
  ```csharp
  _logger.LogInformation("Customer {CustomerId} retrieved", customerId);
  ```
- **Never log** passwords, tokens, PII, or secrets
- Use IDs in log messages instead of names or display values: `{EntityId}` not `{EntityName}`
- Reference data generically when necessary

## CancellationToken Guidelines

**Use when:**
- External API calls (unpredictable latency)
- User-cancellable operations (search, file uploads)
- Long-running background work

**Skip when:**
- Simple CRUD/database queries
- Fast operations (<1s)
- Operations that should complete atomically

Keep it simple — don't add CancellationToken unless it provides clear value.

---

# Feature Pattern

## Core Principles

1. **Single Responsibility** — one feature, one purpose
2. **One Public Method** — always named `Execute`
3. **Features NEVER call other Features** — use services/domain for composition
4. **Public interface, internal implementation**

## Structure

```csharp
// Interface - exactly one Execute method
public interface IGetCustomerFeature
{
    Task<Customer?> Execute(CustomerId id);
}

// Implementation - internal class with primary constructor
internal class GetCustomerFeature(IDbContextFactory<AppDbContext> dbFactory)
    : IGetCustomerFeature
{
    public async Task<Customer?> Execute(CustomerId id)
    {
        await using var db = await dbFactory.CreateDbContextAsync();
        return await db.Customers
            .AsNoTracking()
            .SingleOrDefaultAsync(x => x.Id == id);
    }
}
```

## Naming

| Type | Convention | Example |
|------|------------|---------|
| Query | `IGet{Entity}Feature` | `IGetCustomerFeature` |
| List | `IGet{Entities}Feature` | `IGetCustomersFeature` |
| Command | `I{Action}{Entity}Feature` | `ICreateOrderFeature` |
| Validation | `IValidate{Entity}Feature` | `IValidateOrderFeature` |

## Read Features

- Inject `IDbContextFactory<TContext>`
- Use `AsNoTracking()` for read-only queries
- Use `AsSplitQuery()` when including multiple collections

## Write Features

- Load entity → apply domain logic → save changes
- Use domain methods for business rules
- Return created/updated entity or result type

## Registration

```csharp
services.AddScoped<IGetCustomerFeature, GetCustomerFeature>();
```

## ❌ Anti-Patterns

```csharp
// BAD: Feature calling another feature
internal class CreateOrderFeature(IGetCustomerFeature getCustomer) { }

// BAD: Multiple public methods
public interface IBadFeature
{
    Task<Customer> GetById(int id);
    Task<List<Customer>> GetAll();  // Split into separate features!
}

// BAD: Named something other than Execute
public Task<Customer> GetCustomer(int id);  // Should be Execute()

// BAD: Logging sensitive or domain-specific data
internal class GetEntityFeature(ILogger<GetEntityFeature> logger)
{
    public async Task<Entity> Execute(string entityId)
    {
        // NEVER: log display names or sensitive domain values
        logger.LogInformation("Entity retrieved: {EntityName}", entity.DisplayName);
        // INSTEAD: log identifiers only
        logger.LogInformation("Entity retrieved: {EntityId}", entity.Id);
        return entity;
    }
}
```
