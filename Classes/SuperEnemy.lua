--======================================================================--r
--== Enemy Class factory
--======================================================================--
--local SuperEnemy = class() -- define SuperEnemy as a class (notice the capitals)
local Enemy = require( "Classes.Enemy" )
local SuperEnemy = Enemy:extends()
SuperEnemy.__name = "SuperEnemy" -- give the class a name

--======================================================================--
--== Require dependant classes
--======================================================================--
local pt = require("Classes.printTable")
local healthPackClass = require ("Classes.HealthPack")
local enemyBulletClass	= require ("Classes.EnemyBullet")
--local bulletClass = require ("Classes.Bullet")
--local scoreClass = require ("Classes.Score")
--local drawBullets = true
--======================================================================--
--== Initialization / Constructor
--======================================================================--
function SuperEnemy:__init( group, xloc, yloc, enemyBulletSpeed, health, enemyBulletIntervalMin, enemyBulletIntervalMax, speed)
	SuperEnemy.super.__init( self, group, xloc, yloc, enemyBulletSpeed, health, enemyBulletIntervalMin, enemyBulletIntervalMax, speed)
	--self:drawEnemyTwo()
	self.scoreValue = 5000
	self.contactHealth=200
	self.fullHealth=25
	self.currentHealth=self.fullHealth
	self.enemyBulletIntervalMin=500
	self.enemyBulletIntervalMax=2000
	self.enemyBulletSpeed=enemyBulletSpeed*0.8
	self.speed=speed * 0.78
	self:drawHealth()
end

--======================================================================--
--== Code / Methods
--======================================================================--
function SuperEnemy:drawEnemy()
	--print("drawing enemy2")
	local ranNum = math.random (0,999)
	local offsetX = math.random (40, 150)
	local offsetY = math.random (40,150)
	if ranNum <250 then 
		self.xloc = -offsetX
		self.yloc = -offsetY
	elseif ranNum <500 then
		self.xloc = -offsetY
		self.yloc = display.contentHeight + offsetX
	elseif ranNum <750 then
		self.xloc = display.contentWidth + offsetX
		self.yloc = display.contentHeight + offsetY
	else
		self.xloc = -offsetX
		self.yloc = display.contentWidth + offsetY
	end

	self.enemy = display.newCircle(self.group, self.xloc, self.yloc, 10)
	self.enemy:setFillColor( 1, 0.5, 0.0, 1)
	physics.addBody( self.enemy, "dynamic" )
	self.enemy.id = "enemy"
	self:enemyCollision()
	self:drawBullet()
end

function SuperEnemy:drawHealth()
	--print(self.currentHealth)
	self.drawHealth = function()
		
			if self.currentHealth<0 then
				self.currentHealth=0
				self.healthPack = healthPackClass:new(self.group, self.enemy.x, self.enemy.y, -400, 0, 1, 0)
				self:setScore()
				self:deconstructor()
				display.remove(self.healthBar)
				display.remove(self.enemy)

				--self.currentHealth=self.fullHealth
			end
			self.healthPercentage = self.currentHealth/self.fullHealth
			display.remove ( self.healthBar )
		if self.enemy and self.enemy.removeSelf then	
			self.healthBar = display.newRect(self.group, self.enemy.x, self.enemy.y - 13, 60*self.healthPercentage, 5)
			self.healthBar:setFillColor(1,0,0)
		end	
	end
	Runtime:addEventListener("enterFrame", self.drawHealth)
end

function SuperEnemy:enemyCollision()	
	self.enemy.preCollision = function (target, event) -- allows enemies to move past the outer boundaries
		if event.contact==nil then -- weird error prevention
			print ("event.contact = nil error") 
			elseif (event.other.collType == "boundary") then
				event.contact.isEnabled = false 
				self.drawBullets = true
			end
		end
	self.enemy:addEventListener("preCollision")
	
	self.enemy.collision = function (target, event)
		if event.other.id ~= "enemyBulletTwo" and event.other.id ~= "enemy" and event.other.id ~= "boundary" and event.other.id ~= "wall" and event.other.id ~= "enemyBullet" and event.other.id ~= "healthPack" then 
		local options = {
				name = "contactHealth",
				health = self.contactHealth
				}
			if event.other.id == "melee" then
				self.currentHealth = self.currentHealth-10
			elseif event.other.id == "player" then
				Runtime:dispatchEvent(options)
				self:deconstructor()
				self:setScore()
				display.remove(self.enemy)
				display.remove(self.healthBar)
			elseif event.other.id == "bullet" or event.other.id == "rocket" then
				self.currentHealth = self.currentHealth-1
			end	
		end
	end
	self.enemy:addEventListener("collision")
end

function SuperEnemy:drawBullet()
	local function createBullet(self)
		local randomnumber = math.random(self.enemyBulletIntervalMin, self.enemyBulletIntervalMax)
			self.timer = timer.performWithDelay (randomnumber, 
				function()
					if self.enemy and self.enemy.removeSelf then
						if self.drawBullets == true then
					--self:setEnemyDirection()
							self.enemyBullet = enemyBulletClass:new(self.group, self.enemyBulletSpeed, self.enemy.x, self.enemy.y, self.normDeltaX, self.normDeltaY, 8, 75)
					--print"yay"
						end
					createBullet(self)
				end
			end)
		end
	createBullet(self)
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


--[[function EnemyThree:deconstructor()
	-- a finalize event is called when a display object is removed.
	-- we can use this to remove events or cancel timers that were dsassociated with the object
	-- in this case when the enemy is removed we will remove event listeners and cancel the timer.
	-- we should then nil out the display object and instance (for good memory management)
	local options = {
		name="enemyN",
		modifier="1"
		}
	Runtime:dispatchEvent(options)
	
	self.enemy.finalize = function()
		self.enemy:removeEventListener("preCollision", self.enemy.preCollision)
		Runtime:removeEventListener("playerLocation", self.enemyDirection)
		self.enemy:removeEventListener("collision", self.enemy.collision)
		--timer.cancel(self.timer)
		self.enemy = nil
		self = nil
	end
	self.enemy:addEventListener("finalize")
end]]
--======================================================================--
--== Return factory
--======================================================================--
return SuperEnemy