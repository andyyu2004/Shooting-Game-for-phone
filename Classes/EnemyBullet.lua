--======================================================================--
--== Bullet Class factory
--======================================================================--
local EnemyBullet = class() -- define Bullet as a class (notice the capitals)
EnemyBullet.__name = "EnemyBullet" -- give the class a name

--======================================================================--
--== Require dependant classes
--======================================================================--


--======================================================================--
--== Initialization / Constructor
--======================================================================--
function EnemyBullet:__init(group, speed, xloc, yloc, normDeltaX, normDeltaY,size, damage )
	-- Constructor for class
		-- Parameters:
		--	group - the group where the game should be inserted into
		self.group=group
		self.xloc=xloc
		self.yloc=yloc
		self.speed=speed
		self.normDeltaX=normDeltaX
		self.normDeltaY=normDeltaY
		self.contactHealth=damage
		self.size=size

		self:drawBullet()
end

--======================================================================--
--== Code / Methods
--======================================================================--
function EnemyBullet:drawBullet()
	-- Displays the Bullet on the screen
	self.bullet = display.newCircle(self.group, self.xloc, self.yloc, self.size)
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
		if event.other.id == "boundary" or event.other.id == "wall" or event.other.id == "player" or event.other.id == "melee" or event.other.id == "enemyBulletTwo" then
		--if event.other.id ~= "enemy" and event.other.id ~= "bullet" and event.other.id ~= "rocket" and event.other.id~="explosion" and event.other.id ~= "enemyBullet" and event.other.id ~= "enemyBulletTwo" and event.other.id ~= "healthPack" then
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
end
--======================================================================--
--== Return factory
--======================================================================--
return EnemyBullet