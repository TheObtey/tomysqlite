/*
	BaseDriver is an abstract class defining the structure of a SQL driver.
	Both MySQLDriver and SQLiteDriver inherit from this and implement all its methods.
*/

BaseDriver = {}
BaseDriver.__index = BaseDriver

/*
	Create a new instance of the BaseDriver class.

	@return self (BaseDriver) - A new instance of BaseDriver
*/
function BaseDriver:new()
	local self = setmetatable({}, BaseDriver)
	return self
end

/*
	Establishe a connection to the database.
	This method must be overridden by the driver
*/
function BaseDriver:connect()
	error("[TOMYSQLITE] connect() is not implemented.")
end

/*
	Execute a query.

	@param queryString (string) - The SQL query to execute
	@param params (table) - The parameters for the query (optionnal)
	@param callback (function) - The function to call with the result (optionnal)
*/
function BaseDriver:query(queryString, params, callback)
	error("[TOMYSQLITE] query() is not implemented.")
end

/*
	Execute a query and return a table of results.

	@param queryString (string) - The SQL query to execute
	@param params (table) - The parameters for the query (optionnal)
	@param callback (function) - The function to call with the result (optionnal)
*/
function BaseDriver:queryAssoc(queryString, params, callback)
	error("[TOMYSQLITE] queryAssoc() is not implemented.")
end

/*
	Escape a value to be safely used in a query.

	@param value (string|number) - The value to escape
	@param escapedValue (string) - The escapedValue
*/
function BaseDriver:escape(value)
	error("[TOMYSQLITE] escape() is not implemented.")
end