display.setStatusBar(display.HiddenStatusBar)
local cWidth = display.contentCenterX
local cHeight = display.contentCenterY


local physics = require("physics")
physics.start()
physics.setGravity( 0,0)


local moster = display.newGroup()

local removeMonster
local removeMonster2
local createGame
local createMonster
local createMonster2
local shoot
local createGun
local newGame
local gameOver
local nextWave
local checkforProgress

local gameActive = true
local getTarget = 0
local gunMoveX = 0
local gun
local speed = 10
local shootbtn
local numMonster = 0
local monsterArray = {}
local onCollision
local score = 0
local gameovertxt
local numBullets =99999999999

local shot = audio.loadSound ("bulletM.mp3")
local wavesnd = audio.loadSound ("burstM.mp3")


	
local background = display.newImage("background.png")
background.x = cWidth
background.y = cHeight
	

textScore = display.newText("Score: "..score, 48, 10, nil, 24)

local leftArrow = display.newImage("left.png")
leftArrow.x = 30
leftArrow.y = display.contentHeight - 30
local rightArrow = display.newImage("right.png")
rightArrow.x = 80
rightArrow.y =display.contentHeight -30
	

shootbtn = display.newImage("shoot.png")
shootbtn.x = display.contentWidth -33
shootbtn.y = display.contentHeight -33
	
	local function stopGun(event)
		if event.phase == "ended" then
			gunMoveX = 0 
		end
	end
	

	local function moveGun(event)
		gun.x = gun.x + gunMoveX
	end

	function createGun()
	gun = display.newImage ("gun.png")
	physics.addBody(gun, "static", {density = 1, friction = 0, bounce = 0});
	gun.x = cWidth
	gun.y = display.contentHeight - 100
	gun.myName = "gun"
end
	
local function createWalls(event)	
		if gun.x < 0 then
			gun.x = 0
		end
		if gun.x > display.contentWidth then
			gun.x = display.contentWidth
		end
	end	

	function leftArrowtouch()
		gunMoveX = - speed
	end
	

	function rightArrowtouch()
		gunMoveX = speed
	end
	
function createMonster()
	numMonster = numMonster +1 

	print(numMonster)
			monsterArray[numMonster]  = display.newImage("monster1.png")
			physics.addBody ( monsterArray[numMonster] , {density=0.5, friction=0, bounce=0})
			monsterArray[numMonster] .myName = "monster" 
			startlocationX = math.random (0, display.contentWidth)
			monsterArray[numMonster] .x = startlocationX
			startlocationY = math.random (-500, -100)
			monsterArray[numMonster] .y = startlocationY
		
			transition.to ( monsterArray[numMonster] , { time = math.random (10000, 20000), x= math.random (0, display.contentWidth ), y=gun.y+550 } )
end


function createMonster2()
	numMonster = numMonster +1 

	print(numMonster)
			monsterArray[numMonster]  = display.newImage("monster2.png")
			physics.addBody ( monsterArray[numMonster] , {density=0.5, friction=0, bounce=0})
			monsterArray[numMonster] .myName = "monster" 
			startlocationX = math.random (0, display.contentWidth)
			monsterArray[numMonster] .x = startlocationX
			startlocationY = math.random (-500, -100)
			monsterArray[numMonster] .y = startlocationY
		
			transition.to ( monsterArray[numMonster] , { time = math.random (10000, 20000), x= math.random (0, display.contentWidth ), y=gun.y+550 } )
end

	function shoot(event)
		
		if (numBullets ~= 0) then
			numBullets = numBullets - 1
			local bullet = display.newImage("bullet.png")
			physics.addBody(bullet, "static", {density = 1, friction = 0, bounce = 0});
			bullet.x = gun.x 
			bullet.y = gun.y 
			bullet.myName = "bullet"
			transition.to ( bullet, { time = 1000, x = gun.x, y =-100} )
			audio.play(shot)
		end 
		
	end
 

function onCollision(event)

	if(event.object1.myName =="gun" and event.object2.myName =="monster") then	
			local function setgameOver()
			gameovertxt = display.newText(  "Game Over", cWidth-110, cHeight-100, "Arcade", 50 )
			gameovertxt:addEventListener("tap",  newGame)
			end
			transition.to( gun, { time=1500, xScale = 0.4, yScale = 0.4, alpha=0, onComplete=setgameOver  } )
			gameActive = false
			removeMonster()
			removeMonster2()
			audio.fadeOut(background)
			audio.rewind (background)
	end	

	if((event.object1.myName=="monster" and event.object2.myName=="bullet") or 
		(event.object1.myName=="bullet" and event.object2.myName=="")) then
			event.object1:removeSelf()
			event.object1.myName=nil
			event.object2:removeSelf()
			event.object2.myName=nil
			local burst  = display.newImage("burst.png", event.object1.x,event.object1.y)
			transition.to (burst,{time = 500, xScale=3,yScale=3,alpha=0,rotation=0})
			audio.play(wavesnd)
			score = score + 1
			textScore.text = "Score: "..score
			getTarget = getTarget + 1
			print ("getTarget "..getTarget)
			end
end

function removeMonster()
	for i =1, #monsterArray do
		if (monsterArray[i].myName ~= nil) then
		monsterArray[i]:removeSelf()
		monsterArray[i].myName = nil
		end
	end
end

function removeMonster2()
	for i =1, #monsterArray do
		if (monsterArray[i].myName ~= nil) then
		monsterArray[i]:removeSelf()
		monsterArray[i].myName = nil
		end
	end
end


function newGame(event)	
		display.remove(event.target)	
		textScore.text = "Score: 0"
		numMonster = 0
		gun.alpha = 1
		gun.xScale = 1.0
		gun.yScale = 1.0
		score = 0
		gameActive = true
		numBullets =999999
end

function Status()
	
	if gameActive then
		createMonster()
		createMonster2()
	end

	
end


function startGame()
createGun()

shootbtn:addEventListener ( "tap", shoot )
rightArrow:addEventListener ("touch", rightArrowtouch)
leftArrow:addEventListener("touch", leftArrowtouch)
Runtime:addEventListener("enterFrame", createWalls)
Runtime:addEventListener("enterFrame", moveGun)
Runtime:addEventListener("touch", stopGun)
Runtime:addEventListener("collision" , onCollision)

timer.performWithDelay(5000, Status,0)
timer.performWithDelay(300, checkforProgress,0)

end

startGame()
