
--======================================================================--
--== Bullet Class factory
--======================================================================--
local Bullet = class() 
Bullet.__name = "Bullet"

--======================================================================--
--== Require dependant classes
--======================================================================--
local pt = require("Classes.printTable") 
--======================================================================--
--== Initialization / Constructor
--======================================================================--
function Bullet:__init(group, speed, xloc, yloc,normDeltaX, normDeltaY )
	-- Constructor for class
		-- Parameters:
		self.group=group
		self.xloc=xloc
		self.yloc=yloc
		self.speed=speed
		self.normDeltaX=normDeltaX
		self.normDeltaY=normDeltaY

		self:drawBullet()
end

--======================================================================--
--== Code / Methods
--======================================================================--
function Bullet:drawBullet()
	if self.normDeltaX~=nil then
		self.bullet = display.newCircle(self.group, self.xloc, self.yloc, 3.5)
		--self.bullet.x=self.xloc
		--self.bullet.y=self.yloc
		self.bullet.id="bullet"
		--print(self.bullet.removeSelf)
		physics.addBody(self.bullet, dynamic)
		self.bullet.isSensor = true -- stops physical interactions with other objects
		self.bullet:setLinearVelocity( (self.normDeltaX) * self.speed, (self.normDeltaY)  * self.speed )

		self.bullet.collision = function (target, event)
			if event.other.id == "boundary" or event.other.id == "wall" or event.other.id == "enemy" then -- makes bullet only collide with the correct objects
			--if event.other.id ~= "player" and event.other.id ~= "healthPack" and event.other.id ~= "bullet" and event.other.id ~= "enemyBulletTwo" and event.other.id ~= "enemyBullet" and event.other ~="rocket" and event.other.id~="explosion" then
			self:deconstructor()
			end
		end
	self.bullet:addEventListener("collision")
	end
end 

function Bullet:deconstructor()
	self.bullet:removeEventListener("collision")
	--print(self.bullet.removeSelf)
	display.remove(self.bullet)
	self.bullet=nil 

end
--======================================================================--
--== Return factory
--======================================================================--
return Bullet