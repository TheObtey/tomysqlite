--[[
    SQLHandler is the main entrey point for tomysqlite.
    It automatically selects the correct SQL driver (MySQL or SQLite) and exposes a unified interface for executing queries.
--]]

require("mysqloo")

local SQLHandler = {}
SQLHandler.__index = SQLHandler

/*
    Creates a new SQLHandler instance and set up the appropriate driver.

    @return self (SQLHandler) - A new instance with the selected driver
*/
function SQLHandler:new()
    local self = setmetatable({}, SQLHandler)

    local hasMySQL = pcall(require, "mysqloo")
    if hasMySQL then
        print("[TOMYSQLITE] mysqloo module found. Using MySQLDriver.")
        self.driver = MySQLDriver:new()
    else
        print("[TOMYSQLITE] mysqloo module not found. Falling back to SQLiteDriver.")
        self.driver = SQLiteDriver:new()
    end

    self.driver:connect()

    return self
end

/*
    Executes a raw SQL query.

    @param queryString (string) - The SQL query to execute
    @param params (table) - The parameters for the query (optional)
    @param callback (function) - The function to call with the result (optional)
*/
function SQLHandler:query(queryString, params, callback)
    return self.driver:query(queryString, params, callback)
end

/*
    Executes a query and returns a single value.

    @param queryString (string) - The SQL query to execute
    @param params (table) - The parameters for the query (optional)
    @param callback (function) - The function to call with the result (optional)
*/
function SQLHandler:queryValue(queryString, params, callback)
    return self.driver:queryValue(queryString, params, callback)
end

/*
    Executes a query and returns an associative table.

    @param queryString (string) - The SQL query to execute
    @param params (table) - The parameters for the query (optional)
    @param callback (function) - The function to call with the result (optional)
*/
function SQLHandler:queryAssoc(queryString, params, callback)
    return self.driver:queryAssoc(queryString, params, callback)
end

/*
    Escapes a value to be safely used in a query

    @param value (string|number) - The value to escape
    @return escapedValue (string) - The escaped value
*/
function SQLHandler:escape(value)
    return self.driver:escape(value)
end

return SQLHandler