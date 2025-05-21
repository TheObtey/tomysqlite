-- Loader file for 'tomysqlite'
if not SERVER then return end

/*
	Load core modules
*/
local root = "tomysqlite/"
local core = root .. "core/"

include(core .. "utils.lua")
include(core .. "config.lua")
include(core .. "base_driver.lua")
include(core .. "mysql_driver.lua")
include(core .. "sqlite_driver.lua")
include(core .. "handler.lua")

/*
	Load entry point
*/
include(core .. "init.lua")

print("[TOMYSQLITE] SQL middleware has been initialized successfully.")