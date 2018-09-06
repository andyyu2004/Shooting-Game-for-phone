--======================================================================--r
--== Enemy Class factory
--======================================================================--

local Enemy = require( "Classes.Enemy" )
local EnemyThree = Enemy:extends() -- inherits
EnemyThree.__name = "EnemyThree" 

--======================================================================--
--== Require dependant classes
--======================================================================--
local pt = require("Classes.printTable")
local healthPackClass = require ("Classes.HealthPack")
--local enemyBulletClass	= require ("Classes.enemyBullet")
--local bulletClass = require ("Classes.Bullet")
--local scoreClass = require ("Classes.Score")
--local drawBullets = true
--======================================================================--
--== Initialization / Constructor
--======================================================================--
function EnemyThree:__init( group, xloc, yloc, enemyBulletSpeed, health, enemyBulletIntervalMin, enemyBulletIntervalMax, speed)
	EnemyThree.super.__init( self, group, xloc, yloc, enemyBulletSpeed, health, enemyBulletIntervalMin, enemyBulletIntervalMax, speed)
	--self:drawEnemyTwo()
	self.scoreValue = 500
	self.contactHealth=200
	self.fullHealth=3
	self.health=self.fullHealth
end

--======================================================================--
--== Code / Methods
--======================================================================--
function EnemyThree:drawEnemy()
	--print("drawing enemy2")
	local ranNum = math.random (0,999)	-- has equal chance to spawn in any one of four possible locations
	local offsetX = math.random (20, 150)
	local offsetY = math.random (20,150)
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

	self.enemy = display.newCircle(self.group, self.xloc, self.yloc, 8.5)
	self.enemy:setFillColor( 1, 0.5, 0.0, 1)
	physics.addBody( self.enemy, "dynamic" )
	self.enemy.id = "enemy"
	self:enemyCollision()
	self:drawBullet()
end


function EnemyThree:enemyCollision()	
	self.enemy.preCollision = function (target, event) -- allows enemies to move past the outer boundaries
		if event.contact==nil then -- weird error prevention
			print ("event.contact = nil error") 
			elseif (event.other.collType == "boundary") then
				event.contact.isEnabled = false 
				--self.drawBullets = true
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
					self.healthPack = healthPackClass:new(self.group, self.enemy.x, self.enemy.y,-100,1,0,0) 
					self:deconstructor()
					display.remove(self.enemy)
				elseif event.other.id == "player" then
					Runtime:dispatchEvent(options)
					self:deconstructor()
					display.remove(self.enemy)
				elseif event.other.id == "bullet" or event.other.id == "rocket" then
					self.health = self.health-1
					self.enemy.alpha=self.enemy.alpha-0.30
					if self.health == 0 then
						local ranNum = math.random(0,1000)
						print(ranNum)
						if ranNum >=400 then
							self.healthPack = healthPackClass:new(self.group, self.enemy.x, self.enemy.y,-100,1,0,0)
						end
						self:setScore()
						self:deconstructor()
						display.remove(self.enemy)
				elseif event.other.id == "melee" then
					local ranNum = math.random(0,1000)
					--print(ranNum)
						if ranNum <900 then
							self.healthPack = healthPackClass:new(self.group, self.enemy.x, self.enemy.y,-100,1,0,0)
						end
						self:setScore()
						self:deconstructor()
						display.remove(self.enemy)
					end
				end
			end
		end
	self.enemy:addEventListener("collision")
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
return EnemyThree