display.setStatusBar( display.HiddenStatusBar )
widget =  require("widget")
sql = require("sqlite3")
db_file = "pokemon.db"
db_path = system.pathForFile(db_file, system.ResourceDirectory)
conn = sql.open(db_path)
cx = display.contentCenterX
cy = display.contentCenterY
height = display.contentHeight
width = display.contentWidth
pokemon_list = {}
generation_sheet = {}
generation_number = {0,0,0,0,0,0}
continue_pokemon = {
    {},
    {},
    {{17,3},{17,5}},
    {{4,3},{4,4},{4,6},{4,7},{13,2},{13,3},{13,4},{13,5},{13,6},{14,7}},
    {},
    {}
}

local topbarHeight = 70

function color(r,g,b)
	return r/255, g/255, b/255
end

function getPokemon()
    for row in conn:nrows("SELECT * FROM pokemon") do
        table.insert(pokemon_list, row)
        generation_number[row.generation] = generation_number[row.generation] + 1
    end
end

function go_pokemonlist(event)
    if(event.phase == "ended") then
        local composer = require( "composer" )
        options = {}
        if(composer.getSceneName( "current" ) == "pokemon_detail" or composer.getSceneName( "current" ) == "menu") then
            options = {
                effect = "slideRight",
                time = 500,
                params = {
                    id = pokemon_touch
                }
            }
            composer.gotoScene( "pokemon_list", options )
        elseif(composer.getSceneName( "current" ) == "pokemon_list") then
            insert_tableView()
        end
    end
end

function go_menu(event)
    if(event.phase == "ended") then
        local composer = require( "composer" )
        options = {
            effect = "slideRight",
            time = 500,
        }
        composer.gotoScene( "menu", options )
        composer.removeScene("pokemon_list")
    end
end

function continue_pokemon_img(g,r,c)
    for i=1, #continue_pokemon[g] do
        if(continue_pokemon[g][i][1] == r and continue_pokemon[g][i][2] == c) then
            return true
        end
    end
    return false
end

function generate_sheet()
    options = { frames = {} }
    PokemonIndex = 1
    for g=1, 6 do
        temp_img = display.newImage("img/g"..g..".jpg")
        imgWidth = temp_img.width
        imgHeight = temp_img.height
        imgPokemonWidth = imgWidth/8
        rowPokemon = imgHeight/imgPokemonWidth
        columnPokemon = imgWidth/imgPokemonWidth
        pointX = 0
        pointY = 0
        num = 1
        break_loop = false
        for r=1,rowPokemon do
            for c=1,columnPokemon do
                _continue = continue_pokemon_img(g,r,c)

                if(not _continue) then
                    options["frames"][PokemonIndex] = { x = pointX, y = pointY, width = imgPokemonWidth, height = imgPokemonWidth }
                    PokemonIndex = PokemonIndex+1
                    if(generation_number[g] == num) then
                        break_loop = true
                        break
                    end
                    num = num + 1
                end
                pointX = pointX + imgPokemonWidth
            end
            if(break_loop) then
                break
            end
            pointX = 0
            pointY = pointY + imgPokemonWidth
        end
        temp_img:removeSelf()
        temp_img = nil
        generation_sheet[g] = graphics.newImageSheet( "img/g"..g..".jpg", options )
    end
end



function generate_topbar(title,back)
    group = display.newGroup()
    topbar = display.newRect( group, 0, 0-20, width*2, topbarHeight )
    topbar.anchorX = 0
    topbar.x = -70
    topbar:setFillColor(color(7, 117, 201))
    topbar_title = display.newText( group, title, cx, -15, native.systemFontBold, 25)
    topbar_title:setFillColor(1)
    if(back ~= nil) then
        back_icon = display.newImage( group, "icon/back.png", 20, -15 )
        back_icon:scale(0.2,0.2)
        back_icon:addEventListener("touch",back_scene)
    else
        search_icon = display.newImage( group, "icon/search.png", width-30, topbar.y+5 )
        search_icon:scale(0.2,0.2)
        search_icon:addEventListener("touch",event_search_box)
    end

    return group
end

function generate_footbar()
    group = display.newGroup()

    footbar = display.newRect( group, 0, height+30, width*2, topbarHeight )
    footbar.anchorX = 0
    footbar:setFillColor(color(7, 117, 201))
    footbar_menu_list = display.newImage( group, "icon/list.png", cx, height+20)
    footbar_menu_list:setFillColor(1)
    footbar_menu_list:addEventListener("touch",go_pokemonlist)
    footbar_menu_list:scale(0.5,0.5)

    footbar_menu_home = display.newImage( group, "icon/home.png", 30, height+20)
    footbar_menu_home:setFillColor(1)
    footbar_menu_home:addEventListener("touch",go_menu)
    footbar_menu_home:scale(0.2,0.2)

    return group
end

function setBackground()
    bg = display.newImage("img/bg.jpg")
    bg.anchorY = 0
    bg.y = -50
    bg.x = width
    bg:scale(0.6,0.6)
    return bg
end
