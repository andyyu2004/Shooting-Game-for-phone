
--======================================================================--
--== Boundary Class factory
--======================================================================--
local Boundary = class()
Boundary.__name = "Boundary"

-- Constants
local fullw = display.contentWidth
local fullh = display.contentHeight
local centerX = display.contentCenterX
local centerY = display.contentCenterY

--======================================================================--
--== Require dependant classes
--======================================================================--
local pt = require("Classes.printTable")
-- pt.print_r(....) will print the contents of a table


--======================================================================--
--== Initialization / Constructor
--======================================================================--
function Boundary:__init(group)
	-- Constructor for class
	-- Parameters:
	-- group - the group where the game should be inserted into
	self.group = group
	self:drawBoundary()
	self:drawWall()

end

--======================================================================--
--== Code / Methods
--======================================================================--
function  Boundary:drawBoundary()
	-- draws the invisible outside borders near the edge of the screen to prevent playing from going off
	local boundary = {
		{-5,centerY,10,fullh+50, "leftWall"},
		{fullw+5,centerY,10,fullh+50, "rightWall" },
		{centerX,12,fullw,10, "topWall"},
		{centerX,fullh+20,fullw,10,"bottomWall"}
	}
	
	for i = 1,4 do
		local boundary = display.newRect(self.group, boundary[i][1],boundary[i][2],boundary[i][3],boundary[i][4])
		boundary.id = "wall" or boundary[i][5] 
		boundary.alpha = 0.0
		physics.addBody( boundary, "static" )
		boundary.collType = "boundary"
		--boundary.isSensor = true
	end
	
end

function  Boundary:drawWall()
	--draws central walls creating a simple map for the player to use
	local wall = {
		{50,centerY,15,fullh-400, "leftWall"},
		{fullw-50,centerY,15,fullh-400, "rightWall" },
		{centerX,100,fullw-200,15, "topWall"},
		{centerX,fullh-130,fullw-200,15,"bottomWall"}
	}
	

	for i = 1,4 do
		local wall = display.newRect(self.group, wall[i][1], wall[i][2],wall[i][3],wall[i][4])
		wall.id = "wall"
		wall.alpha = 1
		physics.addBody( wall, "static" )
	end
	
end

--======================================================================--
--== Return factory
--======================================================================--
return Boundary