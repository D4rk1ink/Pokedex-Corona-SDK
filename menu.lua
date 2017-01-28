local composer = require( "composer" )
local scene = composer.newScene()
local logo
function animation(logo)
    timer.performWithDelay( 1000, function()
        transition.to( logo, { time = 500, alpha = 100 } )
        print("s")
    end)
end

function go_pokemonlist_page(event)
    options = {
        effect = "slideLeft",
        time = 500,
    }
    composer.gotoScene( "pokemon_list", options )
end

function go_credit_page(event)
    options = {
        effect = "slideLeft",
        time = 500,
    }
    composer.gotoScene( "credit", options )
end

function scene:create( event )
    local sceneGroup = self.view
    group = display.newGroup()

    bg = display.newImage( group, "img/bg4.jpg", width, height )
    bg.x = cx
    bg.y = cy
    bg:scale(0.6,0.6)
    logo = display.newImage( group, "icon/logo.png" )
    logo:scale(0.08,0.08)
    logo.x = cx
    logo.y = 30
    logo.alpha = 0
    text = {"Pokedex", "Credit"}
    text_menu = {}
    bar = {}
    ball = {}
    ball_y = 250
    time_delay = 1500

    menu_group = {display.newGroup(),display.newGroup()}

    for i=1, 2 do
        bar[i] = display.newRoundedRect( 70, ball_y, 200, 50, 10 )
        bar[i].anchorX = 0
        bar[i]:scale(0,1)

        ball[i] = display.newImage( "icon/pokeball.png" )
        ball[i]:scale(0,0)
        ball[i].x = 70
        ball[i].y = ball_y
        ball[i].alpha = 0

        text_menu[i] = display.newText( text[i], 140, ball_y, native.systemFontBold, 25)
        text_menu[i]:setFillColor(0.2,0.2,0.2)
        text_menu[i].anchorX = 0
        text_menu[i]:scale(0,1)

        menu_group[i]:insert(bar[i])
        menu_group[i]:insert(ball[i])
        menu_group[i]:insert(text_menu[i])

        group:insert(menu_group[i])

        ball_y = ball_y + 90
        timer.performWithDelay( time_delay, function()
            transition.to( ball[i], { time = 500, alpha = 100, xScale = 0.15, yScale = 0.15} )
        end)
        timer.performWithDelay( time_delay+500, function()
            transition.to( bar[i], { time = 500, xScale = 1} )
        end)

        timer.performWithDelay( time_delay+500+300, function()
            transition.to( text_menu[i], { time = 500, xScale = 1} )
        end)

        time_delay = time_delay + 300
    end

    timer.performWithDelay( 800, function()
        transition.to( logo, { time = 50000, alpha = 100} )
        transition.to( logo, { time = 500, y = 60} )
    end)
    menu_group[1]:addEventListener("touch",go_pokemonlist_page)
    menu_group[2]:addEventListener("touch",go_credit_page)
    sceneGroup:insert(group)

end

function scene:show( event )
    if(event.phase == "did") then
        display.setDefault( "background", 1 )
    end
end

function scene:hide( event )
    if(event.phase == "did") then
        --composer.removeScene("pokemon_detail")
    end
end

function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
