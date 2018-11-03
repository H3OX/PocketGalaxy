local background = display.newImage('Background1.jpg')
background:scale(1.2, 1.2)
background.x = display.contentCenterX
background.y = display.contentCenterY
local physics = require( "physics" )
physics.start()  -- Start the physics engine
physics.setGravity( 0, 0 )
local qx=0
local qy=0
local v=0
local music = audio.loadStream('music5.mp3')
local playMusic = audio.play(music, {loops = -1})



--------------------------------------------------------------------------------
--Запуск планеты
local function onPlanetMove (event)
    local phase = event.phase
    if('began' == phase) then
        display.currentStage:setFocus(background)
        planet = display.newImage('planett.png', event.x, event.y)
        planet:scale(0.15, 0.15)
        physics.addBody(planet, 'dynamic', {radius=20})
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
star = display.newImage('star.png', display.contentCenterX+math.random(-20, 20),
display.contentCenterY+math.random(-20, 20))
star:scale(0.1, 0.1)
physics.addBody( star, "kinematic", { isSensor=true, radius=230 } )



blackhole = display.newImage('blackhole.png', display.contentCenterX+math.random(-200, 200), display.contentCenterY-340)
physics.addBody( blackhole, "static", { isSensor=true, radius=100 } )
blackhole:scale(0.15, 0.15)



blackhole2 = display.newImage('blackhole.png', display.contentCenterX+math.random(-300, 400), display.contentCenterY+math.random(-300, 300))
physics.addBody( blackhole2, "static", { isSensor=true, radius=200 } )
blackhole2:scale(0.18, 0.18)



grp = display.newGroup()
grp.x, grp.y = star.x+math.random(-40, 55), star.y+math.random(45, 60)
earth = display.newImage(grp, 'earth.png', star.x-350, star.y-350)
physics.addBody(earth, 'kinematic', {radius=27, isSensor=true})
earth:scale(0.03, 0.03)
star.angularVelocity = 50
transition.to(grp,{ time = 100000, rotation = 10000, iterations = -1 })



grp2 = display.newGroup()
grp2.x, grp2.y = star.x+math.random(-30, 65), star.y+math.random(-55, 80)
mars = display.newImage(grp2, 'mars.png', star.x-320, star.y-320)
physics.addBody(mars, 'kinematic', {radius=22, isSensor=true})
mars:scale(0.06, 0.06)
transition.to(grp2,{ time = 100000, rotation = 5000, iterations = -1 })



grp3 = display.newGroup()
grp3.x, grp3.y = star.x-math.random(10, 15), star.y+math.random(-5, 15)
moon = display.newImage(grp3, 'moon.png', star.x-300, star.y-300)
physics.addBody(moon, 'kinematic', {radius=22, isSensor=true})
moon:scale(0.06, 0.06)
transition.to(grp3,{ time = 100000, rotation = 12000, iterations = -1})



grp4 = display.newGroup()
grp4.x, grp4.y = star.x+15, star.y+15
saturn = display.newImage(grp4, 'saturn.png', star.x-380, star.y-380)
physics.addBody(saturn, 'kinematic', {radius=22, isSensor=true})
saturn:scale(0.04, 0.04)
transition.to(grp4,{ time = 100000, rotation = 19000, iterations = -1})



--------------------------------------------------------------------------------
--Функция гравитации солнца
local function starCollision( self, event )
    local objectToPull = event.other
    if ( event.phase == "began" and objectToPull.touchJoint == nil ) then
         timer.performWithDelay( 100,
            function()
                objectToPull.touchJoint = physics.newJoint( "touch", objectToPull, objectToPull.x, objectToPull.y )
                objectToPull.touchJoint.frequency = 0.4
                objectToPull.touchJoint.dampingRatio = 0.05
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
                objectToPull.touchJoint.frequency = 0.6
                objectToPull.touchJoint.dampingRatio = 0.0
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
blackhole2.collision = blackholeCollision
star:addEventListener( "collision" )
blackhole:addEventListener( "collision" )
blackhole2:addEventListener( "collision" )
Runtime:addEventListener('touch', onPlanetMove)
