-- =============================================================
-- Written by Craig Briggs.  Feel free to modify and reuse in anyway.
-- main.lua
-- main file where teh environment is set up, and points in the direction of first scene
-- =============================================================

----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
-- http://docs.coronalabs.com/daily/api/library/composer/index.html
local composer 	= require "composer" 
system.activate( "multitouch" )
-- library that adds OOP functionality
require("Classes.30logglobal")

-- set up physics environment
local physics = require( "physics" )
physics.start()
--physics.setDrawMode("hybrid")  -- can be used for debugging purposes
physics.setGravity( 0, 0 ) -- set the gravity to 0, we want to use physics, but gravity is not needed
----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------
-- Turn on debug output for composer + Various other settings
--
composer.isDebug = true

composer.gotoScene( "scenes.mainMenu" )	-- goto the menu
--composer.gotoScene( "scenes.gameScene" )