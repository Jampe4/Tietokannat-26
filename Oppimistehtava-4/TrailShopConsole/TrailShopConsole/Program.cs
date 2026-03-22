using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using TrailShopConsole.Data;
using TrailShopConsole.Entities;  // Adjust namespace to match your scaffolded DbContext

// --- Setup (already complete) ---
var configuration = new ConfigurationBuilder()
    .SetBasePath(Directory.GetCurrentDirectory())
    .AddJsonFile("appsettings.json", optional: false)
    .Build();

var connectionString = configuration.GetConnectionString("DefaultConnection")
    ?? throw new InvalidOperationException("Connection string 'DefaultConnection' not found.");

var options = new DbContextOptionsBuilder<TrailShopDbContext>()
    .UseNpgsql(connectionString)
    .Options;

await RunAsync();

async Task RunAsync()
{
    await using var context = new TrailShopDbContext(options);

    while (true)
    {
        Console.WriteLine("\n=== TrailShop Database Console ===");
        Console.WriteLine("1. List all orders");
        Console.WriteLine("2. List order details");
        Console.WriteLine("3. View order tracking history");
        Console.WriteLine("4. Update order status");
        Console.WriteLine("5. List customers");
        Console.WriteLine("6. List products by category");
        Console.WriteLine("7. Exit");
        Console.Write("\nChoice: ");

        var input = Console.ReadLine()?.Trim();

        switch (input)
        {
            case "1":
                await ListAllOrdersAsync(context);
                break;

            case "2":
                await ListOrderDetailsAsync(context);
                break;

            case "3":
                await ViewOrderTrackingHistoryAsync(context);
                break;

            case "4":
                await UpdateOrderStatusAsync(context);
                break;

            case "5":
                await ListCustomersAsync(context);
                break;

            case "6":
                await ListProductsByCategoryAsync(context);
                break;

            case "7":
                Console.WriteLine("\nGoodbye.");
                return;

            default:
                Console.WriteLine("Invalid choice.");
                break;
        }
    }
}

async Task ListAllOrdersAsync(TrailShopDbContext context)
{
    var orders = await context.Orders
        .Include(o => o.Customer)
        .OrderByDescending(o => o.OrderDate)
        .ToListAsync();

    if (orders.Count == 0)
    {
        Console.WriteLine("\nNo orders found.");
        return;
    }

    Console.WriteLine("\nOrders:");
    foreach (var order in orders)
    {
        Console.WriteLine(
            $"Order ID: {order.OrderId} | Date: {order.OrderDate:yyyy-MM-dd} | Customer: {order.Customer.FullName} | Status: {order.OrderStatus}");
    }
}

async Task ListOrderDetailsAsync(TrailShopDbContext context)
{
    Console.Write("\nEnter order ID: ");
    if (!int.TryParse(Console.ReadLine(), out var orderId))
    {
        Console.WriteLine("Invalid order ID.");
        return;
    }

    var order = await context.Orders
        .Include(o => o.Customer)
        .Include(o => o.OrderItems)
            .ThenInclude(oi => oi.Product)
        .FirstOrDefaultAsync(o => o.OrderId == orderId);

    if (order is null)
    {
        Console.WriteLine("Order not found.");
        return;
    }

    Console.WriteLine($"\nOrder ID: {order.OrderId}");
    Console.WriteLine($"Customer: {order.Customer.FullName}");
    Console.WriteLine($"Date: {order.OrderDate:yyyy-MM-dd}");
    Console.WriteLine($"Status: {order.OrderStatus}");

    if (order.OrderItems.Count == 0)
    {
        Console.WriteLine("No order items found.");
        return;
    }

    Console.WriteLine("\nItems:");
    foreach (var item in order.OrderItems)
    {
        Console.WriteLine(
            $"Product: {item.Product.Name} | Quantity: {item.Quantity} | Unit price: {item.UnitPrice:C}");
    }
}

async Task ViewOrderTrackingHistoryAsync(TrailShopDbContext context)
{
    Console.Write("\nEnter order ID: ");
    if (!int.TryParse(Console.ReadLine(), out var orderId))
    {
        Console.WriteLine("Invalid order ID.");
        return;
    }

    var orderExists = await context.Orders.AnyAsync(o => o.OrderId == orderId);
    if (!orderExists)
    {
        Console.WriteLine("Order not found.");
        return;
    }

    var trackingEntries = await context.OrderTrackings
        .Where(t => t.OrderId == orderId)
        .OrderBy(t => t.RecordedAt)
        .ToListAsync();

    if (trackingEntries.Count == 0)
    {
        Console.WriteLine("No tracking history found for this order.");
        return;
    }

    Console.WriteLine($"\nTracking history for order {orderId}:");
    foreach (var entry in trackingEntries)
    {
        Console.WriteLine(
            $"Status: {entry.Status} | Recorded at: {entry.RecordedAt:yyyy-MM-dd HH:mm:ss} | Notes: {entry.Notes}");
    }
}

async Task UpdateOrderStatusAsync(TrailShopDbContext context)
{
    Console.Write("\nEnter order ID: ");
    if (!int.TryParse(Console.ReadLine(), out var orderId))
    {
        Console.WriteLine("Invalid order ID.");
        return;
    }

    var order = await context.Orders.FirstOrDefaultAsync(o => o.OrderId == orderId);
    if (order is null)
    {
        Console.WriteLine("Order not found.");
        return;
    }

    Console.WriteLine("\nAllowed statuses:");
    Console.WriteLine("PENDING, CONFIRMED, PROCESSING, SHIPPED, DELIVERED, CANCELLED");
    Console.Write("Enter new status: ");
    var newStatus = Console.ReadLine()?.Trim().ToUpper();

    var allowedStatuses = new[]
    {
        "PENDING", "CONFIRMED", "PROCESSING", "SHIPPED", "DELIVERED", "CANCELLED"
    };

    if (string.IsNullOrWhiteSpace(newStatus) || !allowedStatuses.Contains(newStatus))
    {
        Console.WriteLine("Invalid status.");
        return;
    }

    Console.Write("Enter notes (optional): ");
    var notes = Console.ReadLine();

    order.OrderStatus = newStatus;

    var trackingEntry = new OrderTracking
    {
        OrderId = order.OrderId,
        Status = newStatus,
        RecordedAt = DateTime.UtcNow,
        Notes = string.IsNullOrWhiteSpace(notes) ? null : notes
    };

    context.OrderTrackings.Add(trackingEntry);
    await context.SaveChangesAsync();

    Console.WriteLine("Order status updated and tracking entry added.");
}

async Task ListCustomersAsync(TrailShopDbContext context)
{
    var customers = await context.Customers
        .OrderBy(c => c.CustomerId)
        .ToListAsync();

    if (customers.Count == 0)
    {
        Console.WriteLine("\nNo customers found.");
        return;
    }

    Console.WriteLine("\nCustomers:");
    foreach (var customer in customers)
    {
        Console.WriteLine(
            $"Customer ID: {customer.CustomerId} | Name: {customer.FullName} | Email: {customer.Email}");
    }
}

async Task ListProductsByCategoryAsync(TrailShopDbContext context)
{
    var products = await context.Products
        .Include(p => p.Category)
        .OrderBy(p => p.Category.Name)
        .ThenBy(p => p.Name)
        .ToListAsync();

    if (products.Count == 0)
    {
        Console.WriteLine("\nNo products found.");
        return;
    }

    Console.WriteLine("\nProducts by category:");
    string? currentCategory = null;

    foreach (var product in products)
    {
        if (currentCategory != product.Category.Name)
        {
            currentCategory = product.Category.Name;
            Console.WriteLine($"\nCategory: {currentCategory}");
        }

        Console.WriteLine($"  Product ID: {product.Id} | Name: {product.Name} | Price: {product.Price:C}");
    }
}