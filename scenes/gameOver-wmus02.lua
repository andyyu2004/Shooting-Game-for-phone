-- =============================================================
-- 12DTS Composer Example
-- =============================================================
-- Scene 2
-- =============================================================
local composer 		= require( "composer" )
local scene    		= composer.newScene()
local widget 		= require( "widget" )
----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Constants
local fullw = display.contentWidth
local fullh = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

----------------------------------------------------------------------
--	Scene Methods
----------------------------------------------------------------------

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view

	-- Create a simple background
	
	local options = 
	{
		parent = sceneGroup,
		text = "Game Over",     
		x = centerX,
		y = 40,
		font = native.systemFont,   
		fontSize = 32,
		align = "center"  -- Alignment parameter
	}
 
	local title = display.newText( options )
	--composer.removeHidden()
	title:setFillColor(255,0,0)
	

	
	--print"addEventListener"
	
	local function handleButtonEvent( event )
		if ( "ended" == event.phase ) then
		
			local options = {
				effect = "fade",
				time = 800
			}
			composer.gotoScene( "scenes.gameScene", options )
		end
	end
	
	
	local changeSceneButton = widget.newButton(
		{
			label = "Try Again?",
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
	changeSceneButton.y = centerY
		
			self.receiveScore = function(event)
				print("scoreRecienved")
			
			local options = {
			
				parent = sceneGroup,
				text = "Score:  "..event.score,
				x = centerX,
				y = (fullh+20-centerY)/2,
				font = native.systemFont,   
				fontSize = 20,
				align = "center"  -- Alignment parameter
			}
			
			local scoreDisplay = display.newText( options )
			
			scoreDisplay:setFillColor(1,1,1)
	
		
		end
		Runtime:addEventListener("endGameScore",  self.receiveScore)

	

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
	local prevScene = composer.getSceneName( "previous" )
	if prevScene then
		composer.removeScene( prevScene ) 
		print("removing ", prevScene)
	end
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willExit( event )
	local sceneGroup = self.view
		Runtime:removeEventListener("endGameScore",  self.receiveScore)
	
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
