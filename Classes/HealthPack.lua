
--======================================================================--

--======================================================================--
local HealthPack = class() -- define Bullet as a class (notice the capitals)
HealthPack.__name = "HealthPack" -- give the class a name

--======================================================================--
--== Require dependant classes
--======================================================================--
--local pt = require("Classes.printTable") -- helper class to use when developint
-- pt.print_r(....) will print the contents of a table

--======================================================================--
--== Initialization / Constructor
--======================================================================--
function HealthPack:__init(group, xloc, yloc, contactHealth,r,g,b )
	-- Constructor for class
		-- Parameters:
		--	group - the group where the game should be inserted into
		self.group=group
		--	xloc, yloc - location where it will be drawn
		self.xloc=xloc
		self.yloc=yloc
		self.contactHealth = contactHealth
		self.r=r
		self.g=g
		self.b=b
		self:drawHealthPack()
end

--======================================================================--
--== Code / Methods
--======================================================================--
function HealthPack:drawHealthPack()
	if self.xloc >10 and self.xloc < display.contentWidth - 10 and self.yloc > 10 and self.yloc < display.contentHeight - 10 then -- prevents off screen spawn where it is uncollectable
		--print("healthpkack")						-- healthpacks do not fade over time as proper use of them are an integral part of getting high scores in this game, and fading would screw it up
		timer.performWithDelay (10, function()     -- cannot add physics body during the collision which triggers the drawHealthPack so timer is added.
		self.healthPack = display.newImageRect( self.group, "images/healthPack.jpg", 32, 32 )
		self.healthPack:setFillColor (self.r,self.g,self.b)
		self.healthPack.x=self.xloc
		self.healthPack.y=self.yloc
		physics.addBody(self.healthPack, dynamic)
		self.healthPack.id="healthPack"
		self.healthPack.isSensor = true -- disables physical interactions while still triggering collision events
	
		self:healthPackCollsiion()
		end) 
	end
end

function HealthPack:healthPackCollsiion()
	self.healthPack.collision = function (target, event)
		--print"healthpack"s
		if event.other.id == "player" then
			self:deconstructor()
			display.remove(self.healthPack)
		end
	end
self.healthPack:addEventListener("collision")
end 

function HealthPack:deconstructor()
	self.healthPack.finalize = function (event)
	local options = 
			{
			name = "contactHealth",
			health = self.contactHealth
			}
		Runtime:dispatchEvent(options)
	
		self.healthPack:removeEventListener("collision")
		self.healthPack=nil 
		self=nil
	end
	self.healthPack:addEventListener("finalize")
end
--======================================================================--
--== Return factory
--======================================================================--
return HealthPack