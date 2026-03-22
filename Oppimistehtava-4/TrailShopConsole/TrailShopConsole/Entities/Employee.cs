using System;
using System.Collections.Generic;

namespace TrailShopConsole.Entities;

public partial class Employee
{
    public int EmployeeId { get; set; }

    public string FullName { get; set; } = null!;

    public string RoleTitle { get; set; } = null!;

    public DateOnly? HireDate { get; set; }

    public int StoreId { get; set; }

    public virtual Store Store { get; set; } = null!;
}
