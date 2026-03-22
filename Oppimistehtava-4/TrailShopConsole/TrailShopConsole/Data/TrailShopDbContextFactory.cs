using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.Configuration;

namespace TrailShopConsole.Data;

public class TrailShopDbContextFactory : IDesignTimeDbContextFactory<TrailShopDbContext>
{
    public TrailShopDbContext CreateDbContext(string[] args)
    {
        var configuration = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json", optional: false)
            .Build();

        var connectionString = configuration.GetConnectionString("DefaultConnection")
            ?? throw new InvalidOperationException("Connection string 'DefaultConnection' not found.");

        var optionsBuilder = new DbContextOptionsBuilder<TrailShopDbContext>();
        optionsBuilder.UseNpgsql(connectionString);

        return new TrailShopDbContext(optionsBuilder.Options);
    }
}
