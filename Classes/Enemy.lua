--======================================================================--
--== Enemy Class factory
--======================================================================--
local Enemy = class() -- define Enemy as a class (notice the capitals)
Enemy.__name = "Enemy" -- give the class a name

--======================================================================--
--== Require dependant classes
--======================================================================--
local pt = require("Classes.printTable")
local enemyBulletClass	= require ("Classes.EnemyBullet")
local bulletClass = require ("Classes.Bullet")
local PowerUpSMG 	=	 require ("Classes.PowerUpSMG")

--======================================================================--
--== Initialization / Constructor
--======================================================================--
function Enemy:__init( group, xloc, yloc, enemyBulletSpeed, health, enemyBulletIntervalMin, enemyBulletIntervalMax, speed)
	self.group = group
	self.xloc = xloc
	self.yloc = yloc
	self.size = size
	self.health = health
	self.speed=speed
	self.randomx = math.random(-50,50)
	self.randomy = math.random(-50,50)
	self.count=0
	self.enemyBulletIntervalMin=enemyBulletIntervalMin
	self.enemyBulletIntervalMax=enemyBulletIntervalMax
	self.enemyBulletSpeed=enemyBulletSpeed
	self.normDeltaX=0
	self.normDeltaY=0
	self.scoreValue = 100
	self.drawBullets = false
	self.contactHealth = 30

	self:drawEnemy()
	self:setPlayerCoordinates()
end

--======================================================================--
--== Code / Methods
--======================================================================--
function  Enemy:drawEnemy()
	--print("draw normal enemy")
	self.enemy = display.newCircle(self.group, self.xloc, self.yloc, 5.5)
	self.enemy:setFillColor( 0, 1, 0, 1)
	physics.addBody( self.enemy, "dynamic" )
	self.enemy.id = "enemy"
	--self.enemy.isSensor = true
	--self:moveEnemy()
	self:enemyCollision()
	self:drawBullet()
end	

function Enemy:enemyCollision()	--seperated into new function to be easier to manage instead of all piling into drawEnemy()
	self.enemy.preCollision = function (target, event) -- allows enemies to move past the outer boundaries
		if event.contact==nil then -- weird error prevention
			print ("event.contact = nil") -- still not sure why this occurs...
		elseif (event.other.collType == "boundary") then
			event.contact.isEnabled = false -- allows enemies to move past the outside boundaries despite being static and having no isSensor enabled
			self.drawBullets = true -- only starts shooting after going through the wall as their bullets do not go past the wall, and if they did prevents enemies off screen from hitting the player
		end
	end
	self.enemy:addEventListener("preCollision")
	
	self.enemy.collision = function (target, event)
		if event.other.id == "player" or event.other.id == "melee" or event.other.id == "bullet" or event.other.id == "rocket" then
			--if event.other.id ~= "enemyBulletTwo" and event.other.id ~= "enemy" and event.other.id ~= "boundary" and event.other.id ~= "wall" and event.other.id ~= "enemyBullet" and event.other.id ~= "healthPack" then 
			--self:setScore()
			self:deconstructor()
			self.enemy:removeSelf()
			local options = {
				name = "contactHealth",
				health = self.contactHealth
				}
			if event.other.id == "player" then
				Runtime:dispatchEvent(options) -- on collision with player makes player lose health
			end
			--local options = {
			--name=
			--elseif event.other.id == "boundary" then
			-- event.contact.isEnabled = false
		end
	end
	self.enemy:addEventListener("collision")
end

function Enemy:setPlayerCoordinates()
	self.setPlayerCoordinates = function (event) -- this receives the co-ordinates the player constantly passes over and stores it in self to provide the enemies information where to move and shoot
		--if self.enemy.x then
			self.playerX=event.x 
			self.playerY=event.y
			--print(self.playerX..)
		--end
			self:setEnemyDirection()
		--self:drawBullet() 
	end
	Runtime:addEventListener("playerLocation", self.setPlayerCoordinates)
--return
end

function Enemy:setEnemyDirection()
	--print(self.playerX)
	if self.enemy and  self.enemy.removeSelf  then -- the following sets the direction of the enemies using vectoral mathematics as this is a much better way to move compared to transitions as this will have a controllable speed where transitions are set by time instead of linear velocity
		local deltaX = self.playerX - self.enemy.x
		local deltaY = self.playerY - self.enemy.y
		self.normDeltaX = deltaX / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))
		self.normDeltaY = deltaY / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))
		self:moveEnemy()
	end
	--print("deltaX = "..deltaX)
end
	
function Enemy:moveEnemy()
	--self.countValue = math.random(20,60)
	if self.count == 30 then -- randomises enemy movement as to not move completely straight towards player
		local randomX = math.random(-0.6,0.7)
		local randomY = math.random(-0.6,0.5)
		self.enemy:setLinearVelocity ((self.normDeltaX + randomX) * self.speed, (self.normDeltaY + randomY) * self.speed)
		self.count = 0
	end
	self.count = self.count + 1 
end

function Enemy:drawBullet()
	local function createBullet(self)
		local randomnumber = math.random(self.enemyBulletIntervalMin, self.enemyBulletIntervalMax)
		self.timer = timer.performWithDelay (randomnumber, function()
			if self.enemy and self.enemy.removeSelf then
				if self.drawBullets == true then
					--self:setEnemyDirection()
					self.enemyBullet = enemyBulletClass:new(self.group, self.enemyBulletSpeed, self.enemy.x, self.enemy.y, self.normDeltaX, self.normDeltaY, 2, 10)
				end
				createBullet(self)
			end
		end)
	end
	createBullet(self)
end

function Enemy:setScore()
	--print"setting score"
	local options = {
		name = "setScore",
		score=self.scoreValue -- allows for each enemy class to give different score with the same code
		}	
	Runtime:dispatchEvent(options)
	--print"dispatch score"
end


function Enemy:deconstructor()
	
	local options = {    -- allows for wave control and controls when to spawn
		name="enemyN",
		modifier="1"
		}
		Runtime:dispatchEvent(options)
	
	self.enemy.finalize = function()
		local ranNum = math.random(0,10000)
		if ranNum <=800 then    -- gives chance to spawn the smg powerups which provide smg ammunition
			PowerUpSMG:new(self.group, self.enemy.x, self.enemy.y, 60)
		end
		self:setScore() -- passes over score to game class
		--self.enemy:removeEventListener("preCollision", self.enemy.preCollision)
		Runtime:removeEventListener("playerLocation", self.setPlayerCoordinates) 
		Runtime:removeEventListener("enterFrame", self.drawHealth)
		--self.enemy:removeEventListener("collision", self.enemy.collision)
		timer.cancel(self.timer)
		self.drawBullets = false -- may prevent error for enemyTwo who has large firerate
		self.enemy = nil
		self = nil
		--print("deconstuted enemy")
	end
	self.enemy:addEventListener("finalize")
end
--======================================================================--
--== Return factory
--======================================================================--
return Enemy