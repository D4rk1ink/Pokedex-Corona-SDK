require "component"

local composer = require( "composer" )
local imgShow
display.setStatusBar( display.HiddenStatusBar )
display.setDefault( "background", 0 )
local options = {
    effect = "fade",
    time = 500
}
getPokemon()
generate_sheet()

function show(i)
    if(not (i <= 3)) then composer.gotoScene( "menu", options ) return false end
    if(imgShow ~= nil) then
        imgShow:removeSelf()
        imgShow = nil
    end
    imgShow = display.newImage( "img/show"..i..".jpg" )
    imgShow.x = cx
    imgShow.y = cy
    imgShow:scale(0.5,0.5)
    print(i)
    imgShow.alpha = 0

    transition.to( imgShow, { time = 1000, alpha = 1, onComplete =
        function()
            timer.performWithDelay( 1000 ,
                function()
                    transition.to( imgShow, { time = 1000, alpha = 0, onComplete =
                        function()
                            timer.performWithDelay( 1000, show(i+1) )
                        end
                     } )
                end
            )
        end
     } )
end

timer.performWithDelay( 1000 , function() show(1) end)
--composer.gotoScene( "menu", options )
--composer.gotoScene( "pokemon_list", options )
