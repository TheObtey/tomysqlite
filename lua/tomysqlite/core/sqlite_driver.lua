--[[
    SQLiteDriver handles database interactions using the built-in GMod SQLite engine.
    It is used as a fallback when mysqloo is not available.
--]]

SQLiteDriver = {}
SQLiteDriver.__index = SQLiteDriver

/*
    Creates a new SQLiteDriver instance.

    @return self (SQLiteDriver) - A new instance of SQLiteDriver
*/
function SQLiteDriver:new()
    local self = setmetatable({}, SQLiteDriver)
    return self
end

/*
    Initializes the SQLiteDriver (no actual connection needed).
*/
function SQLiteDriver:connect()
    print("[TOMYSQLITE] Using internal SQLite database")
end

/*
    Executes a SQL query

    @param queryString (string) - The SQL query to execute
    @param params (table) - The parameters of the query (optional)
    @param callback (function) - The function to call with the result (optional)
*/
function SQLiteDriver:query(queryString, params, callback)
    local finalQuery = self:buildQuery(queryString, params)
    local result = sql.Query(finalQuery)

    if result == false then
        local err = sql.LastError()
        print("[TOMYSQLITE] SQLite query error: " .. err)
        if callback then callback(nil, err) end
        return
    end

    if callback then callback(result) end
end

/*
    Executes a query and returns a single value.

    @param queryString (string) - The SQL query to execute
    @param params (table) - The parameters of the query (optional)
    @param callback (function) - The function to call with the result (optional)    
*/
function SQLiteDriver:queryValue(queryString, params, callback)
    self:query(queryString, params, function(data, err)
        if not data or not data[1] then return callback(nil, err) end
        
        local firstRow = data[1]
        for _, value in pairs(firstRow) do
            return callback(value)
        end
    end)
end

/*
    Executes a query and returns a full result set.

    @param queryString (string) - The SQL query to execute
    @param params (table) - The parameters of the query (optional)
    @param callback (function) - The function to call with the result (optional)    
*/
function SQLiteDriver:queryAssoc(queryString, params, callback)
    self:query(queryString, params, callback)
end

/*
    Escapes a value to be safely used in a query

    @param value (string|number) - The value to escape
    @return escapedValue (string) - The escaped value
*/
function SQLiteDriver:escape(value)
    return sql.SQLStr(tostring(value), true)
end

/*
    Builds the final query string with optional parameters.

    @param queryString (string) - The query with placeholders ("?")
    @param params (table) - Values to insert into the query
    @return finalQuery (string) - The completed query
*/
function SQLiteDriver:buildQuery(queryString, params)
    if not params or #params == 0 then return queryString end

    local i = 0
    local formatted = queryString:gsub("?", function()
        i = i + 1
        local v = params[i]
        if type(v) == "number" then return tostring(v) end
        return self:escape(tostring(v))
    end)
end