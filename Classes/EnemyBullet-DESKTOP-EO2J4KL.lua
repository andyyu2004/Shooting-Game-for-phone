-- =============================================================
-- Written by Craig Briggs.  Feel free to modify and reuse in anyway.
--
-- Bullet.lua
-- Bullet class,  creates the bullet that the player fires
--======================================================================--
--== Bullet Class factory
--======================================================================--
local EnemyBullet = class() -- define Bullet as a class (notice the capitals)
EnemyBullet.__name = "EnemyBullet" -- give the class a name

--======================================================================--
--== Require dependant classes
--======================================================================--
--local pt = require("Classes.printTable") -- helper class to use when developint
-- pt.print_r(....) will print the contents of a table

--======================================================================--
--== Initialization / Constructor
--======================================================================--
function EnemyBullet:__init(group, speed, xloc, yloc, normDeltaX, normDeltaY )
	-- Constructor for class
		-- Parameters:
		--	group - the group where the game should be inserted into
		self.group=group
		--	xloc, yloc - location where it will be drawn
		self.xloc=xloc
		self.yloc=yloc
		--  speed - speed at which it will move
		self.speed=speed
		self.normDeltaX=normDeltaX
		self.normDeltaY=normDeltaY
		self.contactHealth=5
		
		self:drawBullet()
end

--======================================================================--
--== Code / Methods
--======================================================================--
function EnemyBullet:drawBullet()
	-- Displays the Bullet on the screen
	self.bullet = display.newCircle(self.group, self.xloc, self.yloc, 3)
	self.bullet:setFillColor (1,0,0)
	--self.bullet.x=self.xloc
	--self.bullet.y=self.yloc
	self.bullet.id="enemyBullet"
	physics.addBody(self.bullet, dynamic)
	self.bullet.isSensor = true
	self.bullet:setLinearVelocity( self.normDeltaX  * self.speed, self.normDeltaY  * self.speed )
	self:bulletCollision()
end

function EnemyBullet:bulletCollision()
	self.bullet.collision = function (target, event)
		if event.other.id ~= "enemy" and event.other.id ~= "bullet" and event.other ~="rocket" and event.other.id~="explosion" and event.other.id ~= "enemyBullet" and event.other.id ~= "enemyBulletTwo" and event.other.id ~= "healthPack" then
		self:deconstructor()
		self.bullet:removeSelf()
		local options = {
					name = "contactHealth",
					health = self.contactHealth
					}
				if event.other.id == "player" then
					Runtime:dispatchEvent(options)
				end
		end
	-- Receives: nil
	-- Returns: nil
	end
	self.bullet:addEventListener("collision")
end
function EnemyBullet:deconstructor()
	self.bullet.finalize = function (event)
		self.bullet:removeEventListener("collision")
		self.bullet=nil 
		self=nil
	end
	self.bullet:addEventListener("finalize")
	-- a finalize event is called when a display object is removed.
	-- we can use this to remove events or cancel timers that were associated with the object
	-- in this case when the bullet is removed we will remove collision event listeners (not technically needed).
	-- we should then nil out the display object and instance (for good memory management)
end
--======================================================================--
--== Return factory
--======================================================================--
return EnemyBullet