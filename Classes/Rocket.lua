
local Rocket = class() -- define Bullet as a class (notice the capitals)
Rocket.__name = "Rocket" -- give the class a name

--======================================================================--
--== Require dependant classes
--======================================================================--
local pt = require("Classes.printTable") -- helper class to use when developint
-- pt.print_r(....) will print the contents of a table
local fireRocket = audio.loadSound( "sounds/fireRocket.mp3")
local explosionSound = audio.loadSound( "sounds/explosion.mp3")
--======================================================================--
--== Initialization / Constructor
--======================================================================--
function Rocket:__init(group, speed, xloc, yloc,normDeltaX, normDeltaY )
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
		self:drawRocket()
end

--======================================================================--
--== Code / Methods
--======================================================================--
function Rocket:drawRocket()
	-- Displays the Bullet on the screen
	self.rocket = display.newImageRect(self.group,"images/explosion.png", 15, 15)
	self.rocket.x = self.xloc
	self.rocket.y = self.yloc
	audio.play(fireRocket) 
	self.rocket:setFillColor(1,1,0)
	--self.rocket.x=self.xloc
	--self.rocket.y=self.yloc
	self.rocket.id = "rocket"
	physics.addBody(self.rocket, dynamic)
	self.rocket.isSensor = true
	self.rocket:setLinearVelocity( self.normDeltaX  * self.speed, self.normDeltaY  * self.speed )

	self.rocket.collision = function (target, event)
	--if event.other.id == "player" and event.other.id=="wall" then
	if event.other.id == "boundary" or event.other.id == "wall" then
		self:rocketDeconstructor()
		self.rocket:removeSelf()
		--print "boudnary hit"
		elseif event.other.id == "enemy" then
			--elseif event.other.id ~= "player" and event.other.id ~= "boundary" and event.other.id ~= "enemyBulletTwo" and event.other.id ~= "rocket" and event.other.id~="bullet" and event.other.id ~= "enemyBullet" and event.other.id ~= "healthPack" then
			self:drawExplosion()
			self:rocketDeconstructor()
			self.rocket:removeSelf()
		end
	end
	
	self.rocket:addEventListener("collision")
	-- Receives: nil
	-- Returns: nil
end

function Rocket:drawExplosion()
self.explosion = display.newImageRect(self.group,"images/explosion.png", 135, 135)
		self.explosion.x = self.rocket.x
		self.explosion.y = self.rocket.y
		audio.play(explosionSound) 
		self.timer = timer.performWithDelay(1,
		function()
			physics.addBody(self.explosion, dynamic)
			self.explosion:setFillColor(1,1,0 )
			self.explosion.id = "rocket"
			self.explosion.isSensor=true
			timer.performWithDelay(45,
		function()
			--self:explosionDeconstructor()
			display.remove( self.explosion )
			self.explosion=nil
		end)
	end)
end

function Rocket:rocketDeconstructor()
	self.rocket.finalize = function()
		self.rocket:removeEventListener("collision")
		--timer.cancel(self.timer)
		self.rocket=nil 
		self=nil
	end
	self.rocket:addEventListener("finalize")
	--self.explosion.removeSelf()
	--self.explosion=nil

end

--[[function Rocket: explosionDeconstructor()
	self.explosion.finalize = function()
		self.explosion=nil 
		self=nil
	end	
	self.explosion:addEventListener("finalize")
end]]
--======================================================================--
--== Return factory
--======================================================================--
return Rocket