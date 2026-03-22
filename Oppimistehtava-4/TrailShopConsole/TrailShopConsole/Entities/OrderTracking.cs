using System;
using System.Collections.Generic;
using System.Text;

namespace TrailShopConsole.Entities;

public class OrderTracking
{
    public int TrackingId { get; set; }
    public int OrderId { get; set; }
    public string Status { get; set; } = string.Empty;
    public DateTime RecordedAt { get; set; }
    public string? Notes { get; set; }

    public Order Order { get; set; } = null!;
}
