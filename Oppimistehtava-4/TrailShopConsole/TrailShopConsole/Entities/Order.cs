using System;
using System.Collections.Generic;

namespace TrailShopConsole.Entities;

public partial class Order
{
    public int OrderId { get; set; }

    public int CustomerId { get; set; }

    public DateOnly OrderDate { get; set; }

    public virtual Customer Customer { get; set; } = null!;

    public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();

    public string OrderStatus { get; set; } = "PENDING";

    public ICollection<OrderTracking> OrderTrackings { get; set; } = new List<OrderTracking>();
}
