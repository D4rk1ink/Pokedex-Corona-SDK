local composer = require( "composer" )
local scene = composer.newScene()

function go_menu_main(event)
    if(event.phase == "ended") then
        local composer = require( "composer" )
        options = {
            effect = "slideRight",
            time = 500,
        }
        composer.gotoScene( "menu", options )
    end
end

function scene:create( event )
    local sceneGroup = self.view
    logo_group = display.newGroup()
    bg = display.newRect( cx, cy, width, height*2 )
    t1 = display.newText( "Programming", cx, 50, native.systemFontBold, 20)
    t2 = display.newText( "Passakorn Rattanaprapan", cx, 100, native.systemFont, 20)

    t3 = display.newText( logo_group, "Sponser", cx, 120, native.systemFontBold, 20)

    google = display.newImage( logo_group, "icon/google.png", 90, 170)
    google:scale(0.05,0.05)

    youtube = display.newImage( logo_group, "icon/youtube.png", 230, 170)
    youtube:scale(0.2,0.2)

    redbull = display.newImage( logo_group, "icon/redbull.png", 90, 230)
    redbull:scale(0.15,0.15)

    atom = display.newImage( logo_group, "icon/atom.png", 230, 230)
    atom:scale(0.07,0.07)

    corona = display.newImage( logo_group, "icon/corona.png", 160, 300)
    corona:scale(0.7,0.7)

    logo_group.y = 120

    t1:setFillColor(0)
    t2:setFillColor(0)
    t3:setFillColor(0)
    sceneGroup:insert(bg)
    sceneGroup:insert(t1)
    sceneGroup:insert(t2)
    sceneGroup:insert(logo_group)
    bg:addEventListener("touch", go_menu_main)
end

function scene:show( event )
end

function scene:hide( event )
end

function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
