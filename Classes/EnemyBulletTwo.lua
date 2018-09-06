
--======================================================================--
--== Bullet Class factory
--======================================================================--
local EnemyBullet = require ("Classes.EnemyBullet")
local EnemyBulletTwo = EnemyBullet:extends() -- inherits from standard bullet class
EnemyBulletTwo.__name = "EnemyBulletTwo" -- give the class a name

--======================================================================--
--== Require dependant classes
--======================================================================--
--local pt = require("Classes.printTable") -- helper class to use when developint
-- pt.print_r(....) will print the contents of a table

--======================================================================--
--== Initialization / Constructor
--======================================================================--
function EnemyBulletTwo:__init(group, speed, xloc, yloc, normDeltaX, normDeltaY )
	EnemyBulletTwo.super.__init (self, group, speed, xloc, yloc, normDeltaX, normDeltaY )

	self.contactHealth=1
end

--======================================================================--
--== Code / Methods
--======================================================================--
function EnemyBulletTwo:drawBullet()
	-- Displays the Bullet on the screen
	self.bullet = display.newCircle(self.group, self.xloc, self.yloc, 2)
	self.bullet:setFillColor (1,0,0)
	--self.bullet.x=self.xloc
	--self.bullet.y=self.yloc
	self.bullet.id="enemyBulletTwo"
	physics.addBody(self.bullet, dynamic)
	self.bullet.isSensor = true
	local displacementx = math.random (-100,100)/1000 -- adds x spray
	local displacementy = math.random (-100,100)/1000	-- add y spray
	self.bullet:setLinearVelocity( (self.normDeltaX+displacementx)  * self.speed, (self.normDeltaY+displacementy)  * self.speed )
	self:bulletCollision()
	-- Returns: nil
	end 

--[[function EnemyBullet:deconstructor()
	self.bullet.finalize = function (event)
		self.bullet:removeEventListener("collision")
		self.bullet=nil 
		self=nil
	end
	self.bullet:addEventListener("finalize")
end]]
--======================================================================--
--== Return factory
--======================================================================--
return EnemyBulletTwo