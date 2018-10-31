display.setStatusBar( display.HiddenStatusBar )
local background = display.newImage('Background1.jpg')
local physics = require( "physics" )
physics.start()  -- Start the physics engine
physics.setGravity( 0, 0 )
local qx=0
local qy=0
local v=0

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
star = display.newImage('star.png', display.contentCenterX+math.random(-50, 50),
display.contentCenterY+math.random(-50, 50))
star:scale(0.1, 0.1)
physics.addBody( star, "static", { isSensor=true, radius=150 } )

blackhole = display.newImage('blackhole.png', display.contentCenterX-120, display.contentCenterY-240)
physics.addBody( blackhole, "static", { isSensor=true, radius=100 } )
blackhole:scale(0.15, 0.15)

grp = display.newGroup()
grp.x, grp.y = star.x, star.y
earth = display.newImage(grp, 'earth.png', star.x-200, star.y-200)
physics.addBody(earth, 'static', {radius=27, isSensor=true})
earth:scale(0.03, 0.03)
transition.to(grp,{ time = 10000, rotation = 360, iterations = 500 })



grp2 = display.newGroup()
grp2.x, grp2.y = star.x, star.y
mars = display.newImage(grp2, 'mars.png', star.x-150, star.y-150)
physics.addBody(mars, 'static', {radius=22, isSensor=true})
mars:scale(0.06, 0.06)
transition.to(grp2,{ time = 10000, rotation = 500, iterations = 500 })

grp3 = display.newGroup()
grp3.x, grp3.y = star.x, star.y
moon = display.newImage(grp3, 'moon.png', star.x-250, star.y-250)
physics.addBody(moon, 'static', {radius=22, isSensor=true})
moon:scale(0.06, 0.06)
transition.to(grp3,{ time = 10000, rotation = 200, iterations = 500 })



--------------------------------------------------------------------------------
--Функция гравитации солнца
local function starCollision( self, event )
    local objectToPull = event.other
    if ( event.phase == "began" and objectToPull.touchJoint == nil ) then
         timer.performWithDelay( 10,
            function()
                objectToPull.touchJoint = physics.newJoint( "touch", objectToPull, objectToPull.x, objectToPull.y )
                objectToPull.touchJoint.frequency = 0.4
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
star:addEventListener( "collision" )
blackhole:addEventListener( "collision" )
Runtime:addEventListener('touch', onPlanetMove)
