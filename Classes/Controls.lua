--======================================================================--
--== Controls Class factory
--======================================================================--
local Controls = class() -- define Controls as a class (notice the capitals)
Controls.__name = "Controls" -- give the class a name

--======================================================================--
--== Require dependant classes
--======================================================================--
local pt = require("Classes.printTable")


--======================================================================--
--== Private functions
--======================================================================--
local function onTouch (target, event)
	--======================================================================--
	-- generic function handle the touch of the arrow
	-- Receives:
		-- target	- a reference to the actual event being touched
		-- event 	- detailed information about the event e.g. x and y location, phase etc
	-- returns nil
	--======================================================================--

	-- check for the began phase of the touch
	if event.phase == "began" then
		display.getCurrentStage():setFocus(target,event.id)
		target.isFocus = true	
		-- change the color
		target.arrowRect:setFillColor( 1, 0, 0 )
		-- create a runtime listener that dispatches a custom event that the key is being pressed
		target.enterFrame = function(event)
			-- dispatch the custom event
			local customEvent = {
				name = "keyPressed",
				key = event.id,
				phase = "began"
			}
			Runtime:dispatchEvent( customEvent )
		end
		Runtime:addEventListener( "enterFrame", target )
		return true

		-- check for the ended phase of the touchd
	--elseif( target.isFocus ) then
		

		-- remove the runtime listener that dispatches a custom event that the key is being pressed
	elseif event.phase == "ended" or event.phase == "cancelled" then
		display.getCurrentStage():setFocus(target,nil)
		target.isFocus = false		

		-- change the color back
		target.arrowRect:setFillColor( 0)
		local customEvent = {
			name = "keyPressed",
			key = event.id,
			phase = "ended"
		}
		Runtime:dispatchEvent( customEvent )
		Runtime:removeEventListener( "enterFrame", target )
		return true
	end
		
	--end
	return false
end

--======================================================================--
--== Initialization / Constructor
--======================================================================--
function Controls:__init(group, xloc, yloc, image, rotation, key)
	self.group = group
	self.xloc =  xloc
	self.yloc =  yloc
	self.key = key
	self.image = image
	self.rotation = rotation
	
	-- call the method to draw the controls
	self:drawControls()
end

--======================================================================--
--== Code / Methods
--======================================================================--

function  Controls:drawControls()
	-- Displays the Controls on the screen
	-- Receives: nil
	-- Returns: nil
	
	self.control = display.newGroup()
	self.group:insert(self.control)
	self.control.x = self.xloc
	self.control.y = self.yloc
	
	self.control.arrowRect = display.newRoundedRect(self.control, 0,0, 35, 35, 6 )
	self.control.arrowRect.strokeWidth = 2
	self.control.arrowRect:setFillColor( 0, 0, 0, 0.1 )
	self.control.arrowRect.image = display.newImageRect(self.control, self.image, 27, 27 )
	self.control.arrowRect.image.rotation = self.rotation
	
	self.control.id = self.key
	self.control.touch = onTouch -- assign a touch attribute
	self.control:addEventListener( "touch" ) -- add a touch listener to the arrow
	
	self:deconstuctor()
	self:addKeyboard()
end

-- Set up keyboard inputs to trigger buttons (for debug only)
--
-- This works as follows:
--   1. I listen for 'key' events on these keys: left,right,up,down
--   2. I ignore all other key inputs.
--   3. I convert the 'event' record for key inputs into an acceptable touch event.
--   4. I call the touch method on leftButton, rightButton, jumpButton, or fireButton depending on the key touched.
--   5. I pass the modified event into the touch method I'm calling.
--   6. The touch code does the rest of the lifting.  Done!
--

function  Controls:addKeyboard()
	-- This table will be used to convert key phases to touch phases
	local phaseConvert = {}
	phaseConvert.down = "began"
	phaseConvert.up   = "ended"

	self.control.key = function (target,  event )
		if( not (event.descriptor == self.key ) ) then
			return false
		end
		-- Verify button is still valid
		if( self.control and self.control.removeSelf ~= nil and self.control.touch ) then
			-- Convert this key event into a useable touch event

			event.target = self.control
			event.x = self.control.x
			event.y = self.control.y
			event.phase = phaseConvert[event.phase]
			if self.control.oldPhase ~= event.phase then
				self.control:touch( event )
				self.control.oldPhase = event.phase
			end
		end
		return true
	end
	Runtime:addEventListener( "key", self.control )
end

function Controls:deconstuctor()
	self.control.finalize = function()
		Runtime:removeEventListener( "key", self.control )
		self.control:removeEventListener( "touch" ) 
		self.control = nil
		self = nil
	end
	self.control:addEventListener("finalize")
end
--======================================================================--
--== Return factory
--======================================================================--
return Controls