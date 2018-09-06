
local PowerUpSMG = class() -- define Bullet as a class (notice the capitals)
PowerUpSMG.__name = "PowerUpSMG" -- give the class a name

--======================================================================--
--== Require dependant classes
--======================================================================--
--local pt = require("Classes.printTable") -- helper class to use when developint
-- pt.print_r(....) will print the contents of a table

--======================================================================--
--== Initialization / Constructor
--======================================================================--
function PowerUpSMG:__init(group, xloc, yloc, bullets)
	-- Constructor for class
		-- Parameters:
		--	group - the group where the game should be inserted into
		self.group=group
		--	xloc, yloc - location where it will be drawn
		self.xloc=xloc
		self.yloc=yloc
		self.bullets = bullets

		self:drawPowerUpSMG()
end

--======================================================================--
--== Code / Methods
--======================================================================--
function PowerUpSMG:drawPowerUpSMG()
	-- Displays the Bullet on the screen
	if self.xloc >10 and self.xloc < display.contentWidth - 10 and self.yloc > 10 and self.yloc < display.contentHeight - 10 then
		timer.performWithDelay (10, function()
		self.powerUpSMG = display.newImageRect( self.group, "images/healthPack.jpg", 32, 32 )
		self.powerUpSMG:setFillColor (1,1,1,1)
		self.powerUpSMG.x=self.xloc
		self.powerUpSMG.y=self.yloc
		physics.addBody(self.powerUpSMG, dynamic)
		self.powerUpSMG.id="powerUpSMG"
		self.powerUpSMG.bullets = self.bullets
		self.powerUpSMG.isSensor = true
		self:powerUpSMGCollsiion()
		end)
	end
end

function PowerUpSMG:powerUpSMGCollsiion()
	self.powerUpSMG.collision = function (target, event)
		--print"heaklthpack"
		if event.other.id == "player" then
			self:deconstructor()
			display.remove(self.powerUpSMG)
		end
	end
self.powerUpSMG:addEventListener("collision")
end 

function PowerUpSMG:deconstructor()
	self.powerUpSMG.finalize = function (event)
		self.powerUpSMG:removeEventListener("collision")
		self.powerUpSMG=nil 
		self=nil
	end
	self.powerUpSMG:addEventListener("finalize")
end
--======================================================================--
--== Return factory
--======================================================================--
return PowerUpSMG