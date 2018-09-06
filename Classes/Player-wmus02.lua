
--======================================================================--
--== Player Class factory
--======================================================================--
local Player = class() -- define Player as a class (notice the capitals)
Player.__name = "Player" -- give the class a name

--======================================================================--
--== Require dependant classes
--======================================================================--
local pt = require("Classes.printTable")-- helper class to use when developint
-- pt.print_r(....) will print the contents of a table
--pt.print_r(myTable)
local bulletClass 		= require ("Classes.Bullet") -- class for the bullet
-- create this inside the player because it 
local rocketClass 		= require ("Classes.Rocket")
healthPackClass 		= require ("Classes.HealthPack")
local bulletOK = true -- used for firing bullets, if this is true then it is OK to fire the bullet
local meleeOK = true
local rocketOK = true
local reloading=false
local yText = 3.5
local fastReload = audio.loadSound( "sounds/fastReload.mp3")
local pistolSound = audio.loadSound( "sounds/M4.mp3")
local slowReload = audio.loadSound( "sounds/slowReload.mp3")
local knife = audio.loadSound( "sounds/knife.wav")
local SMGSound = audio.loadSound( "sounds/SMG.wav")
--local SMGOK = true

--local wallTouch = false
--======================================================================--
--== Initialization / Constructor
--======================================================================--
function Player:__init(group, xloc, yloc, bulletSpeed, bulletInterval, playerMoveSpeed, ammunition, reloadTime, rocketInterval, reloadAmmunition, rocketSpeed, health)
	-- Constructor for class
	-- Parameters:
		self.group=group
		self.xloc=xloc
		self.yloc=yloc
		self.bulletSpeed=bulletSpeed
		self.bulletInterval=bulletInterval
		self.speed=playerMoveSpeed
		self.ammunition=ammunition
		self.reloadTime=reloadTime
		self.fastReloadTime=self.reloadTime*0.6
		self.reloadAmmunition=reloadAmmunition
		self.rocketInterval=rocketInterval
		self.rocketSpeed = rocketSpeed
		self.fullHealth=health
		self.currentHealth=self.fullHealth
		self.xVelocity=0
		self.yVelocity=0
		self.ammoSMG = 2000000
		self.controlSMG=0

		self:drawPlayer()
		self:drawHealth()
		
		--self.normDeltaX=1
		--self.normDeltaY=1
end

--======================================================================--
--== Code / Methods
--======================================================================--
function Player:drawPlayer()
	-- Displays the Player on the screen
	self.player = display.newCircle(self.group, self.xloc, self.yloc, 6.5)
	--self.player.x=self.xloc
	--self.player.y=self.yloc
	--self.player:scale(.3,.3)
	print("Drawing Player")
	self.player.id="player"
	physics.addBody( self.player, "dynamic" )
	--self.isFixed = true
	self:drawAmmunition()
	self:drawSMGAmmunition()
	self:sendPlayerCoordinates()
	self:modifyHealth()
	self:setVelocity()
	self:fireSMG()
	
	self.player.collision = function (target, event)
		if event.other.id == "powerUpSMG" then
			--SMGOK = true
			self.ammoSMG = self.ammoSMG + event.other.bullets -- adds ammo on contact with the SMG ammos
			self:drawSMGAmmunition()
			--print(self.ammoSMG)
		end
	--[[self.player.collision = function (target, event)
		if event.other.id == "enemyBullet" then 
			self.currentHealth = self.currentHealth - 3
		elseif event.other.id =="enemyBulletTwo" then
			self.currentHealth = self.currentHealth - 1
		elseif event.other.id =="enemy" then
			self.currentHealth = self.currentHealth - 10
		elseif event.other.id == ""
		end	
		self:drawHealth()	
	end]]
	end	
	self.player:addEventListener("collision")
end

function Player:drawAmmunition()
	
	local options1 = {
		parent=self.group,
		text="Pistol: "..self.ammunition,
		x=display.contentWidth-50,
		y=yText,
		fontSize=15,
		font=native.systemFontBold,
		align = "left"
		}
		if self.player and self.player.removeSelf then
			if self.ammunitionCounter then
				self.ammunitionCounter.text = "Pistol: "..self.ammunition
			else
				self.ammunitionCounter=display.newText(options1)
			end
		end
	
	local options2 = {
		parent=self.group,
		text= "Reloading...",
		x=display.contentWidth-50,
		y=yText+27.5,
		fontSize=10.5,
		font=native.systemFontBold,
		align = "left"
		}
		if self.ammunition == 0 or reloading==true then
			if self.reloadNotification then 
				display.remove(self.reloadNotification)
			end
			self.reloadNotification = display.newText( options2 )
			self.reloadNotification:setTextColor(255,0,0)
		else 
			display.remove( self.reloadNotification )
		end
	--return	
end

function Player:drawRocketAmmunition()
		local options2 = {
		parent=self.group,
		text= "RPG Reload...",
		x=display.contentWidth-50,
		y=yText+37.5,
		fontSize=10.5,
		font=native.systemFontBold
		}
			if rocketOK == false then
			--print"Reload RPG"
			self.rocketReloadNotification = display.newText( options2 )
			self.rocketReloadNotification:setTextColor(255,0,0)
			else
			display.remove( self.rocketReloadNotification )
		
		end
	return
end

function Player:drawSMGAmmunition()
	
	local options1 = {
		parent=self.group,
		text="SMG: "..self.ammoSMG,
		x=display.contentWidth-50,
		y=18,
		fontSize=14.5,
		font=native.systemFontBold,
		align = "left"
		}
		if self.player and self.player.removeSelf then
			if self.ammunitionSMGCounter then
				self.ammunitionSMGCounter.text = "SMG: "..self.ammoSMG
			else
				self.ammunitionSMGCounter=display.newText(options1)
			end
		end
	
end

function Player:drawMeleeAmmunition()
	local options1 = {
		parent=self.group,
		text="Melee Charging...",
		x=display.contentWidth-50,
		y=yText + 47.5,
		fontSize=10.5,
		font=native.systemFontBold
		}
		
		if meleeOK == false then
			self.meleeReload=display.newText(options1)
			self.meleeReload:setTextColor(255,0,0)
		else
			display.remove(self.meleeReload)
		end
end

function Player:reload()
	if reloading==false then
		if self.ammunition~=self.reloadAmmunition and self.ammunition~=0 then -- prevents reload on max ammo
			bulletOK=false -- prevents shooting while reloading
			audio.play(fastReload) 
			print "Reload"
			if bulletOK==false then
				reloading = true
				self:drawAmmunition()
				timer.performWithDelay(self.fastReloadTime,
				function()
					self.ammunition=self.reloadAmmunition
					reloading=false
					self:drawAmmunition()
					bulletOK=true	
				end)
			end		
		end	
	end	
end

function Player:setVelocity()
	self.setXVelocity=function(event)
		self.xVelocity=event.xVelocity  --listens for the events dispatched by gameClass and the keypresses
		self:move()
	end
	Runtime:addEventListener("xVelocity",self.setXVelocity)

	self.setYVelocity=function(event)			-- individual X and Y velocities to enable smooth diagonal movement
		self.yVelocity=event.yVelocity
		self:move()
	end
	Runtime:addEventListener("yVelocity",self.setYVelocity)
end

--[[function Player:move()
	-- move the player
	-- parameters: speed to move
	if self.player and self.player.removeSelf then
		if self.xVelocity ~= 0 and self.yVelocity ~= 0 then -- cehcks if the player is moving diagonally
			--print(self.xVelocity)				-- the following stops the diagonal movement from being faster than the horizontal/vertical due to pythagoras' theorem
			local xDiagonalVelocity = self.xVelocity/(math.sqrt(2))    
			local yDiagonalVelocity = self.yVelocity/(math.sqrt(2))
			self.player:setLinearVelocity (xDiagonalVelocity, yDiagonalVelocity) 
			--print(math.sqrt  (math.pow(xDiagonalVelocity, 2)+(math.pow(yDiagonalVelocity,2))))  ---- equal velocity checks
			
		else
			self.player:setLinearVelocity( self.xVelocity, self.yVelocity )
			--print(math.sqrt  (math.pow(self.xVelocity, 2)+(math.pow(self.yVelocity,2))))	  check diagonal and horizontal,velocities are equal
		end
	end
end]]

function Player:angularMove(x, y)
	--local x = math.cos(math.rad(direction))
	--local y = math.sin(math.rad(direction))
	self.player:setLinearVelocity(x * self.speed, y * self.speed)
	
end

function Player:sendPlayerCoordinates()
	if self.player and self.player.removeSelf then --sends enemy class and whoever else might need it the coordinates of player so they can do the necessary calculations to move towards and fire towards player etc... as the self.player.x/y are not accessible from other classes.
		self.sendPlayerCoordinates = function()
			local customEvent = {
				name = "playerLocation",
				x = self.player.x,
				y = self.player.y
				}
				Runtime:dispatchEvent(customEvent)
				--print("dispatchEvent")
		end
	end
	Runtime:addEventListener("enterFrame", self.sendPlayerCoordinates)
end

function Player:setBulletDirection(mouseX, mouseY)  
	if self.player and self.player.removeSelf then    -- following calculates for the x and y vectors for the bullets to move towards the cursor
		local deltaX = mouseX - self.player.x
		local deltaY = mouseY - self.player.y
		self.normDeltaX = deltaX / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))
		self.normDeltaY = deltaY / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))
		--print("setBulletDirection")
		--local normDeltaX = deltaX / math.sqrt(math.pow(deltaX,2) + math.pow(deltaY,2))
		--print("deltaX = "..deltaX)
		--print("deltaY = "..deltaY)
		--print("normX = "..self.normDeltaX)
		--print("normY = "..self.normDeltaY)
		--return normDeltaX
	end
end
	
function Player:fireBullet()
	-- fire the bullet
	if self.player ~= nil then
	--if fire==true then
		if bulletOK then
			if self.ammunition>0 then -- checks there is sufficient ammunition to fire
					--local xloc, yloc = self.getLocation()
					bulletOK = false -- prevents firing while shooting
					self.ammunition=self.ammunition-1 
					-- healthPackClass:new(self.group, 11, display.contentCenterY, -400, 0, 1, 0)
					--print(self.ammunition)
					self:drawAmmunition() -- redraws ammunition values
					self.bullet = bulletClass:new(self.group, self.bulletSpeed, self.player.x, self.player.y,self.normDeltaX,self.normDeltaY)
					audio.play(pistolSound) 
					self.bulletIntervalTimer = timer.performWithDelay(self.bulletInterval, function()
						if self.ammunition==0 then -- automatic reload
							audio.play(slowReload) 
							self.reloadTimer=timer.performWithDelay(self.reloadTime, -- slow reload when ammo is 0
							function()
							self.ammunition=self.reloadAmmunition
							self:drawAmmunition()
						end)
					end
				bulletOK=true
				end)
			end 
		end
	end
end

function Player:fireRocket()
	if self.player ~= nil and self.player.removeSelf then
		--if fire==true then
		--print("fire Rocket")
		if rocketOK then
		rocketOK = false
		self:drawRocketAmmunition()
		self.rocket = rocketClass:new(self.group, self.rocketSpeed, self.player.x, self.player.y,self.normDeltaX,self.normDeltaY)
			timer.performWithDelay(self.rocketInterval,
			function()
				rocketOK=true
				self:drawRocketAmmunition()
			end)
		end
	end
end
function Player:fireRocketAngular(normDeltaX, normDeltaY)
	if self.player ~= nil and self.player.removeSelf then
		--if fire==true then
		--print("fire Rocket")
		if rocketOK then
		rocketOK = false
		self:drawRocketAmmunition()
		self.rocket = rocketClass:new(self.group, self.rocketSpeed, self.player.x, self.player.y,normDeltaX,normDeltaY)
			timer.performWithDelay(self.rocketInterval,
			function()
				rocketOK=true
				self:drawRocketAmmunition()
			end)
		end
	end
end

function Player:drawHealth()
	--print(self.currentHealth)
	if self.currentHealth>1000 then 
	self.currentHealth=self.fullHealth -- prevents overheal from healthPacks
	elseif self.currentHealth<=0 then -- prevents negative health values which would screw up health bar
		self.currentHealth=0	-- kills player when health hits less than 0
		self:deconstructor()
		display.remove(self.player)
		--self.currentHealth=self.fullHealth
	end
	self.healthPercentage = self.currentHealth/self.fullHealth --creates a percentage to use to scale the healthBar
	if self.healthBar or self.healthDisplay then -- removes old health bar and redraws new one whenever health changes
		display.remove( self.healthBar )
		display.remove (self.healthDisplay )
	end
	local options = {
		parent = self.group,
		text = self.currentHealth,
		x = display.contentCenterX,
		y = 2.5,
		font = native.systemFontBold,
		fontSize = 14
		}
	self.healthBar = display.newRect(self.group, display.contentCenterX, 2.5, 100*self.healthPercentage, 15)
	self.healthDisplay = display.newText(options)
	self.healthBar:setFillColor(1,0,0)
end

function Player:modifyHealth()
	self.modifyHealth = function (event) -- recieves the contact health events and applies it and redraws healthbar
		self.currentHealth = self.currentHealth - event.health
		self:drawHealth()
		--print(self.currentHealth)
		--print(event.health)
	end
	Runtime:addEventListener("contactHealth", self.modifyHealth)
end

function Player:meleeAttack()
	if self.player and self.player.removeSelf then
		if meleeOK == true then
			meleeOK=false
			self.melee = display.newCircle(self.group, self.player.x, self.player.y, 50)
			audio.play(knife) 
			self.melee.id="melee"
			self.melee:setFillColor(218)
			physics.addBody( self.melee, "dynamic" )
			self.melee.isSensor=true
				timer.performWithDelay(25, function()
					display.remove(self.melee)
					self:drawMeleeAmmunition()
				timer.performWithDelay(3500, function()
					meleeOK = true
					self:drawMeleeAmmunition()
				end)
			end)
		end
	end
end

function Player:fireSMG()
	self.SMGOK = false
	--print"middle click reieved"78
	self.fireSMG = function (target, event)
		if self.SMGOK == true then
			if self.player and self.player.removeSelf then
				self.controlSMG = self.controlSMG+1
				if self.controlSMG == 2 then	
					--if SMGOK == true then
					if self.ammoSMG>0 then 
					--local xloc, yloc = self.getLocation()
						--SMGOK = false
							if self.normDeltaX then
								self.ammoSMG = self.ammoSMG-1
								--print(self.ammoSMG)
								self:drawSMGAmmunition()
								randomX = math.random (-50,50)/1000
								randomY = math.random (-50,50)/1000
								self.bullet = bulletClass:new(self.group, self.bulletSpeed, self.player.x, self.player.y,self.normDeltaX+randomX,self.normDeltaY+randomY)
								audio.play(SMGSound) 
							end
							--self.timerSMG = timer.performWithDelay(120,
							--function()
								--SMGOK=true
						--	end)	
						end
					--print(self.controlSMG)
					self.controlSMG=0
				end		
			end
		end
	end
	Runtime:addEventListener("enterFrame", self.fireSMG)
end

function Player:SMGStatus(status)
	self.SMGOK = status
end 



function Player:deconstructor()
	--Runtime:removeEventListener( "keyPressed", self.touchListener )
	self.player.finalize = function()
		if self.player ~= nil then
			Runtime:removeEventListener("enterFrame", self.sendPlayerCoordinates)
			Runtime:removeEventListener("contactHealth", self.modifyHealth)
			Runtime:removeEventListener("yVelocity",self.setYVelocity)
			Runtime:removeEventListener("xVelocity",self.setXVelocity)
			Runtime:addEventListener("enterFrame", self.fireSMG)
			--Runtime:removeEventListener("SMG", self.setSMG)
			--self.player:removeEventListener("collision", self.listener)
			--timer.cancel(self.reloadTimer)
			--timer.cancel(self.bulletIntervalTime
			if self.timerSMG then
				timer.cancel(self.timerSMG)
			end
		self.player = nil
		self = nil
		print("Deconstructed Player")

		--self.group:removeSelf()
		
		local options = {
		name="gameOver"
		}
		Runtime:dispatchEvent(options) --ends the game and changes scenes
		print"dispatch Gameover"
		end
	end
	self.player:addEventListener("finalize")

end
--======================================================================--
--== Return factory
--======================================================================--
return Player