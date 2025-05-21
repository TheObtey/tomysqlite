--[[
    MySQLDriver handle database interactions using the mysqloo module.
    It connects to a MySQL server and implements all the required SQL methods.
--]]

require("mysqloo")

MySQLDriver = {}
MySQLDriver.__index = MySQLDriver

/*
    Creates a new MySQLDriver instance.

    @return self (MySQLDriver) - A new instance of MySQLDriver
*/
function MySQLDriver:new()
    local self = setmetatable({}, MySQLDriver)

    self.config = MySQLiteConfig or {
        host = "127.0.0.1",
        username = "root",
        password = "",
        database = "garrysmod",
        port = 3306
    }

    self.connection = nil
    self.queryQueue = {}
    self.isConnected = false

    return self
end

/*
    Establishes a connection to the MySQL database
*/
function MySQLDriver:connect()
    self.connection = mysqloo.connect(
        self.config.host,
        self.config.username,
        self.config.password,
        self.config.database,
        self.config.port
    )

    function self.connection:onConnected()
        self.isConnected = true 
        print("[TOMYSQLITE] Successfully connected to MySQL database.")

        for _, queuedQuery in ipairs(self.queryQueue) do
            queuedQuery()
        end

        self.queryQueue = {}
    end

    function self.connection:onConnectionFailed(err)
        print("[TOMYSQLITE] MySQL connection failed: " .. err)
    end

    self.connection:connect()
end

/*
    Executes a SQL query

    @param queryString (string) - The SQL query to execute
    @param params (table) - The parameters for the query (optional)
    @param callback (function) - The function to call with the result (optional)
*/
function MySQLDriver:query(queryString, params, callback)
    local function runQuery()
        local finalQuery = self:buildQuery(queryString, params)
        local query = self.connection:query(finalQuery)

        function query:onSuccess(data)
            if callback then callback(data) end
        end
        
        function query:onError(err)
            print("[TOMYSQLITE] MySQL query error: " .. err)
            if callback then callback(nil, err) end
        end

        query:start()
    end

    if self.isConnected then
        runQuery()
    else
        table.insert(self.queryQueue, runQuery)
    end
end

/*
    Executes a query and returns a single value.

    @param queryString (string) - The SQL query to execute
    @param params (table) - The parameters for the query (optional)
    @param callback (function) - The function to call with the result (optional)
*/
function MySQLDriver:queryValue(queryString, params, callback)
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
    @param params (table) - The parameters for the query (optional)
    @param callback (function) - The function to call with the result (optional)
*/
function MySQLDriver:queryAssoc(queryString, params, callback)
    self:query(queryString, params, callback)
end

/*
    Escapes a value to be safely used in a query

    @param value (string|value) - The value to escape
    @return escapedValue (string) - The escaped value
*/
function MySQLDriver:escape(value)
    return self.connection:escape(value)
end

/*
    Builds the final query string with optional parameters.

    @param queryString (string) - The query with placeholders ("?")
    @param params (table) - Values to insert into the query
    @return finalQuery (string) - The completed query
*/
function MySQLDriver:buildQuery(queryString, params)
    if not params or #params == 0 then return queryString end

    local i = 0
    local formatted = queryString:gsub("?", function()
        i = i + 1
        local v = params[i]
        if type(v) == "number" then return tostring(v) end
        return "'" .. self:escape(tostring(v)) .. "'"
    end)

    return formatted
end