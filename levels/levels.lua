--Composer для контроля сцен
local composer = require( "composer" )
--Socket для задания интервала действий
local socket = require('socket')
--Создание новой сцены
local scene = composer.newScene()


function scene:create( event )
	local sceneGroup = self.view
  local background = display.newImage(sceneGroup, 'Background1.png', display.contentCenterX, display.contentCenterY)
  local level1 = display.newImage('level1button.png', display.contentCenterX, display.contentCenterY-500)
  local level2 = display.newImage('level2button.png', display.contentCenterX, display.contentCenterY-250)
  local level3 = display.newImage('level3button.png', display.contentCenterX, display.contentCenterY)
  local text = display.newText('More levels will be added in the future', display.contentCenterX, display.contentCenterY+300)
  level1:addEventListener('tap', onTap1)
  level2:addEventListener('tap', onTap2)
  level3:addEventListener('tap', onTap3)
end

function onTap1()
  socket.sleep(0.1)
  composer.gotoScene('level1')
end

function onTap2()
  socket.sleep(0.1)
  composer.gotoScene('level2')
end

function onTap3()
  socket.sleep(0.1)
  composer.gotoScene('level3')
end





-------------------------------------------------------------------------------
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
	elseif ( phase == "did" ) then
	end
end


function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
	elseif ( phase == "did" ) then
	end
end



function scene:destroy( event )
	local sceneGroup = self.view
end

--Ивенты для фаз сцен
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
