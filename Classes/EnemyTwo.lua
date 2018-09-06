--======================================================================--r
--== Enemy Class factory
--======================================================================--
--local SuperEnemy = class() -- define SuperEnemy as a class (notice the capitals)
local Enemy = require( "Classes.Enemy" )
local EnemyTwo = Enemy:extends()
EnemyTwo.__name = "EnemyTwo" -- give the class a name
local enemyBulletTwo = require ("Classes.EnemyBulletTwo")
--======================================================================--
--== Require dependant classes
--======================================================================--
local pt = require("Classes.printTable")
--local enemyBulletClass	= require ("Classes.enemyBullet")
--local bulletClass = require ("Classes.Bullet")
--local scoreClass = require ("Classes.Score")
--local drawBullets = true
--======================================================================--
--== Initialization / Constructor
--======================================================================--
function EnemyTwo:__init( group, xloc, yloc, enemyBulletSpeed, health, enemyBulletIntervalMin, enemyBulletIntervalMax, speed)
	EnemyTwo.super.__init( self, group, xloc, yloc, enemyBulletSpeed, health, enemyBulletIntervalMin, enemyBulletIntervalMax, speed)
	--self:drawEnemyTwo()
	self.scoreValue = 200
	self.contactHealth = 50

end

--======================================================================--
--== Code / Methods
--======================================================================--
function EnemyTwo:drawEnemy()
	--print("drawing enemy2")
	ranNum = math.random (0,999)
	local offset = math.random (100, 300)
	if ranNum <250 then 
		self.xloc = -offset
		self.yloc = -offset
	elseif ranNum <500 then
		self.xloc = -offset
		self.yloc = display.contentHeight + offset
	elseif ranNum <750 then
		self.xloc = display.contentWidth + offset
		self.yloc = display.contentHeight + offset
	else
		self.xloc = -offset
		self.yloc = display.contentWidth + offset
	end

	self.enemy = display.newCircle(self.group, self.xloc, self.yloc, 4.5)
	self.enemy:setFillColor( 1, 0, 0, 1)
	physics.addBody( self.enemy, "dynamic" )
	self.enemy.id = "enemy"
	self:enemyCollision()
	self:drawBullet()
	
end

--[[function Enemy:moveEnemy()
	if self.count == 15 then
		local randomX = math.random(-0.6,0.5)
		local randomY = math.random(-0.5,0.3)
		self.enemy:setLinearVelocity ((self.normDeltaX + randomX) * self.speed, (self.normDeltaY + randomY) * self.speed)
		self.count = 0
	end
	self.count = self.count + 1
end]]

function EnemyTwo:drawBullet()
	local function createBullet(self)
	--	local randomnumber = math.random(self.enemyBulletIntervalMin, self.enemyBulletIntervalMax)
		self.timer = timer.performWithDelay (40, 
			function()
				if self.enemy and self.enemy.removeSelf then
					if self.drawBullets == true then
				--self:setEnemyDirection()
					self.enemyBulletTwo = enemyBulletTwo:new(self.group, self.enemyBulletSpeed, self.enemy.x, self.enemy.y, self.normDeltaX, self.normDeltaY)
				--print"yay"
					end
					createBullet(self)
				end
			end)
		end
	createBullet(self)
end


--[[function EnemyTwo:deconstructor()

		name="enemyN",
		modifier="1"
		}
	Runtime:dispatchEvent(options)
	
	self.enemy.finalize = function()
		self.enemy:removeEventListener("preCollision", self.enemy.preCollision)
		Runtime:removeEventListener("playerLocation", self.enemyDirection)
		self.enemy:removeEventListener("collision", self.enemy.collision)
		timer.cancel(self.timer)
		self.enemy = nil
		self = nil
	end
	self.enemy:addEventListener("finalize")
end]]
--======================================================================--
--== Return factory
--======================================================================--
return EnemyTwo