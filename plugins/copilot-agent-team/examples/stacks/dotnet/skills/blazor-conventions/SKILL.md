---
name: blazor-conventions
description: "Blazor SSR patterns, component best practices, and Razor conventions"
applyTo: ["**/*.razor", "**/*.razor.cs"]
---

# Blazor & Razor Best Practices

## Render Mode Policy

### Preferred: Static Server-Side Rendering (SSR)

By default, use **static SSR** (no `@rendermode` directive). This provides:

- Fastest initial page load
- Best SEO
- Reduced server memory usage
- No WebSocket/SignalR connection overhead

```razor
@* ✅ GOOD - Static SSR (default, no directive needed) *@
@attribute [Route("/my-page")]

<h1>My Page</h1>
<p>This is static content</p>
```

### When Interactivity is Required: Use InteractiveWebAssembly

When you need client-side interactivity, only as a last resort use `InteractiveWebAssembly`:

```razor
@* ✅ GOOD - Interactive WebAssembly when needed *@
@rendermode RenderMode.InteractiveWebAssembly

<button @onclick="HandleClick">Click me</button>
```

### Avoid: InteractiveWebAssembly

Do **NOT** use `InteractiveWebAssembly` unless absolutely necessary. It:

- Requires installing the Blazor WebAssembly in the project and configuring static file hosting
- Increases initial load time due to downloading the Blazor WASM runtime

```razor
@* ❌ AVOID - InteractiveWebAssembly *@
@rendermode RenderMode.InteractiveWebAssembly
```

### Avoid: InteractiveServer

Do **NOT** use `InteractiveServer`. It:

- Requires persistent SignalR connection per user
- Increases server memory usage
- Has latency on every interaction
- Doesn't scale as well

```razor
@* ❌ AVOID - InteractiveServer *@
@rendermode RenderMode.InteractiveServer
```

---

## Component Best Practices

### 1. File Organization

Place components in feature folders:

```
Features/
└── MyFeature/
    ├── Components/
    │   └── MyComponent.razor
    ├── Pages/
    │   └── MyPage.razor
    └── Services/
        └── MyService.cs
```

### 2. Use `[Parameter]` and `[EditorRequired]` Appropriately

```razor
@code {
    // ✅ Required parameters should use EditorRequired
    [Parameter, EditorRequired]
    public string Title { get; set; } = null!;

    // ✅ Optional parameters should have defaults
    [Parameter]
    public string? Subtitle { get; set; }

    // ✅ Event callbacks for child-to-parent communication
    [Parameter]
    public EventCallback<string> OnValueChanged { get; set; }
}
```

### 3. Use `CascadingParameter` Sparingly

Only for truly cross-cutting concerns (auth state, theme, culture):

```razor
@code {
    [CascadingParameter]
    public Task<AuthenticationState>? AuthState { get; set; }
}
```

### 4. Prefer `@inject` Over Constructor Injection

```razor
@* ✅ GOOD *@
@inject IMyService MyService
@inject ILogger<MyPage> Logger

@* ❌ AVOID - Constructor injection in components *@
```

---

## Routing Best Practices

### 1. Use Route Constants

Define routes in a central location:

```csharp
public static class MyFeatureRoutes
{
    public const string MyPage = "/app/my-page";
    public const string MyPageDetail = "/app/my-page/{id:int}";
}
```

### 2. Use Route Attributes with Constants

```razor
@attribute [Route(MyFeatureRoutes.MyPage)]
@attribute [Route(MyFeatureRoutes.MyPageDetail)]

@code {
    [Parameter]
    public int? Id { get; set; }
}
```

---

## State Management

### 1. For Simple Local State

Use component fields/properties:

```razor
@code {
    private bool isLoading;
    private List<Item> items = [];
}
```

### 2. For Shared State Across Components

Use scoped services:

```csharp
// Register as scoped
services.AddScoped<IMyStateService, MyStateService>();
```

### 3. For Persisted State

Use `PersistentComponentState` for SSR → WASM handoff:

```razor
@inject PersistentComponentState ApplicationState

@code {
    private PersistingComponentStateSubscription _subscription;

    protected override async Task OnInitializedAsync()
    {
        _subscription = ApplicationState.RegisterOnPersisting(PersistData);

        if (!ApplicationState.TryTakeFromJson<MyData>("mydata", out var data))
        {
            data = await LoadDataAsync();
        }
    }
}
```

---

## Form Handling

### 1. SSR Forms with Enhanced Navigation (Preferred)

For forms with server-side processing, use `data-enhance` for SPA-like navigation without full page reloads:

```razor
@attribute [StreamRendering]

<form method="post" @formname="my-form" @onsubmit="HandleSubmit" data-enhance>
    <AntiforgeryToken />
    <input name="MyField" value="@MyField" type="text" />
    <button type="submit">Send</button>
</form>

@code {
    [SupplyParameterFromForm(FormName = "my-form")]
    private string MyField { get; set; } = string.Empty;

    private async Task HandleSubmit()
    {
        // Process form data
        await SaveDataAsync();
    }
}
```

### 2. Multiple Forms on Same Page

Use different `@formname` values and matching `FormName` in `[SupplyParameterFromForm]`:

```razor
<form method="post" @formname="form-a" @onsubmit="HandleFormA" data-enhance>
    <AntiforgeryToken />
    <input name="FieldA" value="@FieldA" />
    <button type="submit">Submit A</button>
</form>

<form method="post" @formname="form-b" @onsubmit="HandleFormB" data-enhance>
    <AntiforgeryToken />
    <input name="FieldB" value="@FieldB" />
    <button type="submit">Submit B</button>
</form>

@code {
    [SupplyParameterFromForm(FormName = "form-a")]
    private string FieldA { get; set; } = string.Empty;

    [SupplyParameterFromForm(FormName = "form-b")]
    private string FieldB { get; set; } = string.Empty;
}
```

### 3. Inline Delete/Action Forms

For row-level actions (like delete buttons in tables), use inline forms with hidden fields:

```razor
@foreach (var item in Items)
{
    <form method="post" @formname="@($"delete-{item.Id}")" @onsubmit="DeleteItem" data-enhance class="inline">
        <AntiforgeryToken />
        <input type="hidden" name="ItemIdToDelete" value="@item.Id" />
        <button type="submit" class="text-red-600">🗑️ Delete</button>
    </form>
}

@code {
    [SupplyParameterFromForm]
    private int ItemIdToDelete { get; set; }

    private async Task DeleteItem()
    {
        // Delete using ItemIdToDelete
    }
}
```

### 4. Stream Rendering for Loading States

Use `[StreamRendering]` attribute for pages that load data asynchronously:

```razor
@attribute [StreamRendering]

@if (IsLoading)
{
    <div>Loading data...</div>
}
else
{
    @* Show content *@
}

@code {
    private bool IsLoading { get; set; } = true;

    protected override async Task OnInitializedAsync()
    {
        await LoadDataAsync();
        IsLoading = false;
    }
}
```

### 5. EditForm with Model Binding (Interactive Components Only)

Only use `EditForm` when you have an interactive render mode:

```razor
@rendermode InteractiveWebAssembly

<EditForm Model="@model" OnValidSubmit="HandleSubmit">
    <DataAnnotationsValidator />
    <ValidationSummary />

    <InputText @bind-Value="model.Name" />
    <ValidationMessage For="() => model.Name" />

    <button type="submit">Save</button>
</EditForm>
```

---

## Performance Tips

### 1. Use `@key` for Lists

```razor
@foreach (var item in items)
{
    <ItemComponent @key="item.Id" Item="item" />
}
```

### 2. Avoid Expensive Operations in Render

```razor
@* ❌ AVOID - Computation in render *@
<p>@(items.Where(x => x.IsActive).Sum(x => x.Value))</p>

@* ✅ GOOD - Pre-compute in code *@
<p>@activeTotal</p>

@code {
    private decimal activeTotal;

    protected override void OnParametersSet()
    {
        activeTotal = items.Where(x => x.IsActive).Sum(x => x.Value);
    }
}
```

### 3. Use `ShouldRender()` for Expensive Components

```razor
@code {
    private bool shouldRender = true;

    protected override bool ShouldRender() => shouldRender;
}
```

### 4. Virtualize Long Lists

```razor
<Virtualize Items="@largeList" Context="item">
    <ItemComponent Item="item" />
</Virtualize>
```

---

## Error Handling

### 1. Use Error Boundaries

```razor
<ErrorBoundary>
    <ChildContent>
        <MyComponent />
    </ChildContent>
    <ErrorContent Context="ex">
        <p class="text-red-600">Something went wrong: @ex.Message</p>
    </ErrorContent>
</ErrorBoundary>
```

### 2. Handle Async Errors Gracefully

```razor
@code {
    private string? errorMessage;

    private async Task LoadDataAsync()
    {
        try
        {
            errorMessage = null;
            data = await service.GetDataAsync();
        }
        catch (Exception ex)
        {
            Logger.LogError(ex, "Error loading data");
            errorMessage = "Could not load data. Please try again later.";
        }
    }
}
```

---

## Authorization

### 1. Use Policy-Based Authorization

```razor
@attribute [Authorize(Policy = Policies.AdminUsers)]
```

### 2. Use AuthorizeView for Conditional Content

```razor
<AuthorizeView Policy="@Policies.AdminContent">
    <Authorized>
        <AdminPanel />
    </Authorized>
    <NotAuthorized>
        <p>You do not have access to this content.</p>
    </NotAuthorized>
</AuthorizeView>
```

---

## Naming Conventions

| Type         | Convention      | Example               |
| ------------ | --------------- | --------------------- |
| Pages        | `*Page.razor`   | `MyFeaturePage.razor` |
| Components   | `*.razor`       | `MyComponent.razor`   |
| Layouts      | `*Layout.razor` | `MainLayout.razor`    |
| Routes class | `*Routes.cs`    | `MyFeatureRoutes.cs`  |

---

## Database Access in SSR Pages

For SSR pages needing database access, inject the factory and create short-lived contexts:

```razor
@inject IDbContextFactory<AppDbContext> DbContextFactory

@code {
    protected override async Task OnInitializedAsync()
    {
        await using var context = await DbContextFactory.CreateDbContextAsync();
        data = await context.Set<MyEntity>().ToListAsync();
    }
}
```
