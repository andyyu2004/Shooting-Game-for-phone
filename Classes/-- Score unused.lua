-- =============================================================
-- Written by Craig Briggs.  Feel free to modify and reuse in anyway.
--
-- Score.lua
-- Score class,  creates teh boundaries that surround the screen
--======================================================================--
--== Score Class factory
--======================================================================--
local Score = class() -- define Score as a class (notice the capitals)
Score.__name = "Score" -- give the class a name


-- Constants
local fullw = display.contentWidth
local fullh = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

--======================================================================--
--== Require dependant classes
--======================================================================--
local pt = require("Classes.printTable") -- helper class to use when developint
-- pt.print_r(....) will print the contents of a table


--======================================================================--
--== Initialization / Constructor
--======================================================================--
function Score:__init(group)
	-- Constructor for class
	-- Parameters:
	-- group - the group where the game should be inserted into
	self.group = group
	self.scoreValue=0
	
	--self:drawScore()
	--self:setScore()
	
end

--======================================================================--
--== Code / Methods
--======================================================================--
function  Score: setScore()
	self.setScore = function(event)
		self.scoreValue = self.scoreValue + event.score
		--print(self.score)
		self:drawScore()
		--print(event.score)
		end
	self:deconstructor()
	Runtime:addEventListener ("setScore", self.setScore)
end
	

function  Score:drawScore()
	-- Displays the Score on the screen
	-- Receives: nil
	-- Returns: nil
	local options1 = {
		parent=self.group,
		text="Score: "..self.scoreValue,
		x=50,
		y=2.5,
		fontSize=16,
		font=native.systemFontBold
		}
		if self.score then
		self:deconstructor()
		display.remove( self.score )
		end
	self.score=display.newText(options1)
end

function Score:deconstructor()
	self.score.finalize = function ()
		local options = {
			name = "score",
			score= "self.score"
			}
		Runtime:dispatchEvent(options)
		
		Runtime:removeEventListener("setScore", self.setScore)
		print"remove score lsitener"
	end
self.score:addEventListener("finalize")
end

--======================================================================--
--== Return factory
--======================================================================--
return Score