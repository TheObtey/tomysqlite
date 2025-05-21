--[[
	BaseDriver is an abstract class defining the structure of a SQL driver.
	Both MySQLDriver and SQLiteDriver inherit from this and implement all its methods.
--]]

BaseDriver = {}
BaseDriver.__index = BaseDriver

/*
	Creates a new instance of the BaseDriver class.

	@return self (BaseDriver) - A new instance of BaseDriver
*/
function BaseDriver:new()
	local self = setmetatable({}, BaseDriver)
	return self
end

/*
	Establishes a connection to the database.
	This method must be overridden by the driver
*/
function BaseDriver:connect()
	error("[TOMYSQLITE] connect() is not implemented.")
end

/*
	Executes a query.

	@param queryString (string) - The SQL query to execute
	@param params (table) - The parameters for the query (optional)
	@param callback (function) - The function to call with the result (optional)
*/
function BaseDriver:query(queryString, params, callback)
	error("[TOMYSQLITE] query() is not implemented.")
end

/*
	Executes a query and return a table of results.

	@param queryString (string) - The SQL query to execute
	@param params (table) - The parameters for the query (optionnal)
	@param callback (function) - The function to call with the result (optionnal)
*/
function BaseDriver:queryAssoc(queryString, params, callback)
	error("[TOMYSQLITE] queryAssoc() is not implemented.")
end

/*
	Escapes a value to be safely used in a query.

	@param value (string|number) - The value to escape
	@param escapedValue (string) - The escapedValue
*/
function BaseDriver:escape(value)
	error("[TOMYSQLITE] escape() is not implemented.")
end