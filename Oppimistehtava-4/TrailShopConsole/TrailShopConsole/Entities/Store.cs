using System;
using System.Collections.Generic;

namespace TrailShopConsole.Entities;

public partial class Store
{
    public int StoreId { get; set; }

    public string Name { get; set; } = null!;

    public string Type { get; set; } = null!;

    public string? City { get; set; }

    public string? StreetAddress { get; set; }

    public virtual ICollection<Employee> Employees { get; set; } = new List<Employee>();

    public virtual ICollection<Stock> Stocks { get; set; } = new List<Stock>();
}
