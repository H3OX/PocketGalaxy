--Composer для контроля сцен
local composer = require( "composer" )
--Socket для задания интервала действий
local socket = require('socket')
--Создание новой сцены
local scene = composer.newScene()

--Обработка нажатия на кнопку
local function goToGame( event )
		socket.sleep(0.1)
		composer.gotoScene('levels')
end

--Создание начальной сцены с кнопкой и логотипом
function scene:create( event )
	local sceneGroup = self.view
	local background = display.newImage(sceneGroup, 'Background1.png', display.contentCenterX, display.contentCenterY)
	local playButton = display.newImage(sceneGroup, 'startgame.png', display.contentCenterX, display.contentCenterY+230)
	playButton:scale(0.45, 0.45)
	playButton:addEventListener('tap', goToGame)
	local logo = display.newImage(sceneGroup, 'logo.png', display.contentCenterX+75, display.contentCenterY-300)
	logo:scale(0.5, 0.5)

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
