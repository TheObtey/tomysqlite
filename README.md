# tomysqlite

**tomysqlite** is a lightweight SQL middleware for Garry's Mod, designed to simplify database interactions and provide automatic fallback from MySQL (via `mysqloo`) to SQLite when needed.

## 🚀 Features

* Automatic detection of `mysqloo` support.
* Transparent fallback to SQLite when MySQL is unavailable.
* Object-oriented internal structure (Lua-style metatables).
* Safe parameterized queries.
* Utility methods for escaping, querying single values, and full result sets.
* Query queuing until MySQL connection is ready.
* Fully documented methods using doc-style comments.

## 📦 Installation

1. Clone or download the repository.
2. Place the `tomysqlite` folder inside your Garry's Mod addon directory.

## 🧠 Usage Example

```lua
MySQLite:query("SELECT * FROM users WHERE id = ?", {1}, function(data)
    PrintTable(data)
end)

MySQLite:queryValue("SELECT COUNT(*) FROM bans", nil, function(count)
    print("There are " .. count .. " bans.")
end)
```

## 📁 File Structure

```
tomysqlite/
└── lua/
    ├── autorun/
    │   └── tomysqlite_load.lua
    └── tomysqlite/
        ├── init.lua
        ├── config.lua
        ├── core/
        │   ├── base_driver.lua
        │   ├── mysql_driver.lua
        │   ├── sqlite_driver.lua
        │   ├── handler.lua
        │   └── utils.lua
```

## 🛠 Planned Improvements

* Console commands for debugging and status reports
* Automatic reconnection attempts
* Caching system for frequently used queries
* Query profiler (debug mode)

## 💬 Credits

Inspired by the original `MySQLite` by FPtje. Rewritten and expanded by TheObtey with modern practices and an object-oriented approach.

---

> Made with Lua, ☕, and ❤️ by TheObtey
