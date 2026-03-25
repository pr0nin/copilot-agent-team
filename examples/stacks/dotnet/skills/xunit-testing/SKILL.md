---
name: xunit-testing
description: "xUnit testing patterns, AAA structure, mocking, and test data best practices"
applyTo: ["**/*Tests.cs", "**/*Test.cs", "**/*.Tests/**/*.cs"]
---

# Testing Guidelines

## Framework & Tools

- **xUnit** for test framework
- **FakeItEasy** or **NSubstitute** for mocking
- **FluentAssertions** for readable assertions (optional)

## Test Naming

```
MethodName_Scenario_ExpectedResult
```

**Examples:**
- `GetCustomer_WithValidId_ReturnsCustomer`
- `GetCustomer_WithNullId_ThrowsArgumentNullException`
- `Calculate_WhenAmountIsNegative_ReturnsZero`

## Test Structure (AAA)

```csharp
[Fact]
public void MethodName_Scenario_ExpectedResult()
{
    // Arrange
    var sut = new CustomerService(fakeDependency);

    // Act
    var result = sut.GetCustomer(customerId);

    // Assert
    Assert.NotNull(result);
}
```

## Mocking

```csharp
// FakeItEasy
var fakeRepo = A.Fake<ICustomerRepository>();
A.CallTo(() => fakeRepo.Find(customerId)).Returns(expectedCustomer);

// NSubstitute
var subRepo = Substitute.For<ICustomerRepository>();
subRepo.Find(customerId).Returns(expectedCustomer);
```

## What to Test

✅ **Do test:**
- Business logic and calculations
- Validation rules
- Edge cases and error handling
- Public API contracts

❌ **Don't test:**
- Framework code (EF Core, ASP.NET)
- Private methods directly
- Simple DTOs/models without logic
- Third-party libraries

## Best Practices

- One assertion concept per test (multiple related asserts OK)
- Tests should be independent — no shared state
- Use descriptive variable names (`expectedCustomer`, `invalidId`)
- Prefer real objects over mocks when simple
- Keep tests fast — mock external dependencies

## Test Data

- **Use synthetic test data only** — never use real production or domain-specific data
- Good test data: `"TestUser_001"`, `"SampleEntity_Alpha"`, `"TestOrder_Beta"`, `"MockAccount_003"`
- Bad test data: actual production values, real user names, or sensitive domain data
- Generate test data programmatically with no relation to real values
