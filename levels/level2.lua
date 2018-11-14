display.setStatusBar( display.HiddenStatusBar )
local background = display.newImage('Background1.png')
background.x = display.contentCenterX
background.y = display.contentCenterY
local physics = require( "physics" )
physics.start()  -- Start the physics engine
physics.setGravity( 0, 0 )

local qx=0
local qy=0
local v=0
local music = audio.loadStream('music.mp3')
local playMusic = audio.play(music, {loops = -1})
local composer = require('composer')
local scene = composer.newScene()


--------------------------------------------------------------------------------
--Запуск планеты
local function onPlanetMove (event)
    local phase = event.phase
    if('began' == phase) then
        display.currentStage:setFocus(background)
        planet = display.newImage('planett.png', event.x, event.y)
        planet:scale(0.2, 0.2)
        physics.addBody(planet, 'dynamic', {radius=40})
        planet:applyTorque(-0.05, 0.05)
        x1 = event.x
        y1 = event.y
    elseif('moved' == phase) then
        x2 = event.x
        y2 = event.y
    elseif('ended' or 'cancelled') then
        local distance = math.sqrt(math.pow(math.abs(x1-x2),2)+math.pow(math.abs(y1-y2),2))
        if (x2>=x1) then
            if (y2>=y1) then
                qx=-1
                qy=-1
            else
                qx=-1
                qy=1
            end
        elseif (y2>=y1) then
            qx=1
            qy=-1
        else
            qx=1
            qy=1
        end

        if (distance>0) then
            v = distance * 1.5
        end
    local speedx=(math.abs(x2-x1)/distance*qx*v)
    local speedy=(math.abs(y2-y1)/distance*qy*v)
    planet:setLinearVelocity( speedx, speedy )
    end
end
--------------------------------------------------------------------------------
--Создание солнца, черной дыры, и планет
star = display.newImage('star.png', display.contentCenterX+math.random(-40, 40),
display.contentCenterY+math.random(-80, 80))
star:scale(0.2, 0.2)
physics.addBody( star, "kinematic", { isSensor=true, radius=270 } )

blackhole = display.newImage('blackhole.png', display.contentCenterX+math.random(-100, 100), display.contentCenterY-530)
physics.addBody( blackhole, "static", { isSensor=true, radius=220 } )
blackhole:scale(0.2, 0.2)

grp = display.newGroup()
grp.x, grp.y = star.x+math.random(-10, 15), star.y+math.random(15, 20)
earth = display.newImage(grp, 'earth.png', star.x-350, star.y-350)
physics.addBody(earth, 'kinematic', {radius=27, isSensor=true})
earth:scale(0.03, 0.03)
star.angularVelocity = 50
transition.to(grp,{ time = 100000, rotation = 10000, iterations = -1 })



grp2 = display.newGroup()
grp2.x, grp2.y = star.x+math.random(-10, 15), star.y+math.random(-5, 10)
mars = display.newImage(grp2, 'mars.png', star.x-320, star.y-320)
physics.addBody(mars, 'kinematic', {radius=22, isSensor=true})
mars:scale(0.08, 0.08)
transition.to(grp2,{ time = 100000, rotation = 5000, iterations = -1 })



grp3 = display.newGroup()
grp3.x, grp3.y = star.x-math.random(10, 15), star.y+math.random(-5, 15)
moon = display.newImage(grp3, 'moon.png', star.x-370, star.y-370)
physics.addBody(moon, 'kinematic', {radius=22, isSensor=true})
moon:scale(0.09, 0.09)
transition.to(grp3,{ time = 100000, rotation = 12000, iterations = -1})

grp4 = display.newGroup()
grp4.x, grp4.y = star.x+15, star.y+15
saturn = display.newImage(grp4, 'saturn.png', star.x-250, star.y-390)
physics.addBody(saturn, 'kinematic', {radius=22, isSensor=true})
saturn:scale(0.05, 0.05)
transition.to(grp4,{ time = 100000, rotation = 19000, iterations = -1})

--------------------------------------------------------------------------------
--Функция гравитации солнца
local function starCollision( self, event )
    local objectToPull = event.other
    if ( event.phase == "began" and objectToPull.touchJoint == nil ) then
         timer.performWithDelay( 100,
            function()
                objectToPull.touchJoint = physics.newJoint( "touch", objectToPull, objectToPull.x, objectToPull.y )
                objectToPull.touchJoint.frequency = 0.5
                objectToPull.touchJoint.dampingRatio = 0.0
                objectToPull.touchJoint:setTarget( self.x, self.y )
            end
        )
      elseif (event.phase == "ended" and objectToPull.touchJoint ~= nil) then
      objectToPull.touchJoint:removeSelf()
      objectToPull.touchJoint = nil
    end
end

--------------------------------------------------------------------------------
--Функция гравитации черной дыры
local function blackholeCollision( self, event )
    local objectToPull = event.other
    if ( event.phase == "began" and objectToPull.touchJoint == nil ) then
         timer.performWithDelay( 10,
            function()
                objectToPull.touchJoint = physics.newJoint( "touch", objectToPull, objectToPull.x, objectToPull.y )
                objectToPull.touchJoint.frequency = 1.1
                objectToPull.touchJoint.dampingRatio = 0.3
                objectToPull.touchJoint:setTarget( self.x, self.y )
            end
        )
      elseif (event.phase == "ended" and objectToPull.touchJoint ~= nil) then
      objectToPull.touchJoint:removeSelf()
      objectToPull.touchJoint = nil
    end
end









star.collision = starCollision
blackhole.collision = blackholeCollision
star:addEventListener( "collision" )
blackhole:addEventListener( "collision" )
Runtime:addEventListener('touch', onPlanetMove)
return scene
