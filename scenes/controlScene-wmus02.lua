-- =============================================================
-- Written by Craig Briggs.  Feel free to modify and reuse in anyway.
--
-- mainMenu.lua
-- Main menu the user will be presented with
-- =============================================================

----------------------------------------------------------------------
--							Requires								--
----------------------------------------------------------------------
local composer 		= require( "composer" )
local scene    		= composer.newScene()
local widget 		= require( "widget" )
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Constants
local fullw = display.contentWidth
local fullh = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view

	-- Write title on the screen
	
	local options = 
	{
		parent = sceneGroup,
		text = "Controls",     
		x = centerX,
		y = 80,
		width = fullw,
		font = native.systemFont,   
		fontSize = 56,
		align = "center"  -- Alignment parameter
	}
 
	local title = display.newText( options )
	title:setFillColor(1,0,0)
	
	-- create a button to start the game when pressed
	local function handleButtonEvent( event )
		if ( "ended" == event.phase ) then
			local options = {
				effect = "fade",
				time = 800
			}
			composer.gotoScene( "scenes.mainMenu", options )
		end
	end
	
	
	local changeSceneButton = widget.newButton(
		{
			label = "Back",
			onEvent = handleButtonEvent,
			emboss = false,
			-- Properties for a rounded rectangle button
			shape = "roundedRect",
			width = 200,
			height = 40,
			cornerRadius = 2,
			fillColor = { default={150}, over={255,0,0} },
			strokeColor = { default={255}, over={255} },
			strokeWidth = 4
		}
	)
	sceneGroup:insert(changeSceneButton)
	-- Center the button
	changeSceneButton.x = centerX
	changeSceneButton.y = fullh - 50




		local options1 = 
	{
		parent = sceneGroup,
		text = "Move: WASD \n Pistol: Left Mouse Button \n RPG: Right Mouse Button \n SMG: Space Key \n Melee: F key\n Reload Pistol: R key \n \n Red Drops Give 100 health \n Green Drops Give 400 health \n White Drops Give 60 SMG Ammo \n \n Reloading is faster when manual!",     
		x = centerX,
		y = 120,
		width = fullw,
		font = native.systemFont,   
		fontSize = 18,
		align = "center"  -- Alignment parameter
	}
 	local controls = display.newText( options1 )

 	controls.anchorY=0
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnter( event )
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didEnter( event )
	local sceneGroup = self.view
	
	-- remove the previous scene,  so that when it is reloaded it starts fresh
	local prevScene = composer.getSceneName( "previous" )
	if prevScene then
		composer.removeScene( prevScene, true ) 
	end
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
	local sceneGroup = self.view
end
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExit( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroy( event )
	local sceneGroup = self.view
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------

---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
function scene:show( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willEnter( event )
	elseif( willDid == "did" ) then
		self:didEnter( event )
	end
end
function scene:hide( event )
	local sceneGroup 	= self.view
	local willDid 	= event.phase
	if( willDid == "will" ) then
		self:willExit( event )
	elseif( willDid == "did" ) then
		self:didExit( event )
	end
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------
return scene
