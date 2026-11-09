using Microsoft.Data.Sqlite;

var db = args.Length > 0
    ? args[0]
    : Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "..", "..", "Rinoleggio.db"));

using var c = new SqliteConnection($"Data Source={db}");
c.Open();

static object? Scalar(SqliteConnection conn, string sql)
{
    using var cmd = conn.CreateCommand();
    cmd.CommandText = sql;
    return cmd.ExecuteScalar();
}

var hasJobs = Scalar(c, "SELECT name FROM sqlite_master WHERE type='table' AND name='AbpBackgroundJobs'");
var users = Scalar(c, "SELECT COUNT(*) FROM AbpUsers");
var listingsTable = Scalar(c, "SELECT name FROM sqlite_master WHERE type='table' AND name LIKE '%Listing%' LIMIT 1");
object? listingsCount = null;
if (listingsTable is string lt)
{
    listingsCount = Scalar(c, $"SELECT COUNT(*) FROM \"{lt}\"");
}

var tables = Scalar(c, "SELECT COUNT(*) FROM sqlite_master WHERE type='table'");
Console.WriteLine($"path={db}");
Console.WriteLine($"AbpBackgroundJobs={hasJobs ?? "MISSING"}");
Console.WriteLine($"AbpUsers={users}");
Console.WriteLine($"listings_table={listingsTable ?? "none"} count={listingsCount}");
Console.WriteLine($"table_count={tables}");
