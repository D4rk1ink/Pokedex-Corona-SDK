local composer = require( "composer" )
local scene = composer.newScene()
local prevScene = composer.getSceneName( "previous" )
local pokemon = {}
local barheight = 30
local temp_evolution_id = nil
local evolution_scroll

function barcolor()
    return color(7, 117, 201)
end

function back_scene(event)
    if(event.phase == "ended") then
        local options = {
            effect = "slideRight",
            time = 500,
        }
        composer.gotoScene( prevScene, options )
    end
end

function evolution_scrollListener(event)
    if(event.phase == "began") then

    elseif(event.phase == "moved") then
        temp_evolution_id = nil
    elseif(event.phase == "ended") then
        if(temp_evolution_id ~= nil) then
            local options = {
                effect = "slideLeft",
                time = 500,
                params = {
                    id = temp_evolution_id
                }
            }
            temp_evolution_id = nil
            composer.gotoScene( "pokemon_detail", options )
        end
    end
end

function event_evolution(event)
    if(event.phase == "began") then
        temp_evolution_id = event.target.id
    end
end

function init()
    scrollView = widget.newScrollView({
            top = 10,
            height = height-10,
        	width = width,
            horizontalScrollDisabled = true,
            listener = scrollListener
        })
    _id = pokemon.id
    _no = pokemon.no
    _name = pokemon.name
    _generation = pokemon.generation
    _height = string.match(pokemon.height, '%((.*)%)')
    _weight = string.match(pokemon.weight, '%((.*)%)')
    _type = string.gsub(pokemon.typep,"|","/")
    _species = string.gsub(pokemon.species,"Pokémon","")
    _abilities = string.gsub(pokemon.abilities," ","#")
    _abilities = string.gsub(_abilities,"|"," ")

    group = display.newGroup()

    img = display.newImage( group, generation_sheet[_generation], _id )
    img.x = 10
    img.y = 10
    img.anchorX = 0
    img.anchorY = 0

    _textNo = display.newText( group, _no, 220, 70, native.systemFontBold, 40)
    _textNo:setFillColor(0.4,0.4,0.4)
    ------------------------------------------------------
    detail_group = display.newGroup()

    _textHeight = display.newText( detail_group, "Height : ", 20, 0, native.systemFontBold, 15)
    _textHeight.anchorX = 0
    _textHeight:setFillColor(barcolor())
    textHeight = display.newText( detail_group, _height, 80, 0, native.systemFont, 13)
    textHeight.anchorX = 0
    textHeight:setFillColor(0.2,0.2,0.2)

    _textWeight = display.newText( detail_group, "Weight : ", 20, 30, native.systemFontBold, 15)
    _textWeight.anchorX = 0
    _textWeight:setFillColor(barcolor())
    textWeight = display.newText( detail_group, _weight, 83, 30, native.systemFont, 13)
    textWeight.anchorX = 0
    textWeight:setFillColor(0.2,0.2,0.2)

    _textType = display.newText( detail_group, "Type : ", 150, 0, native.systemFontBold, 15)
    _textType.anchorX = 0
    _textType:setFillColor(barcolor())
    textType = display.newText( detail_group, _type, 200, 0, native.systemFont, 13)
    textType.anchorX = 0
    textType:setFillColor(0.2,0.2,0.2)

    _textType = display.newText( detail_group, "Species : ", 150, 30, native.systemFontBold, 15)
    _textType.anchorX = 0
    _textType:setFillColor(barcolor())
    textType = display.newText( detail_group, _species, 220, 30, native.systemFont, 13)
    textType.anchorX = 0
    textType:setFillColor(0.2,0.2,0.2)
    ------------------------------------------------------
    barabilities_group = display.newGroup()

    BarAbilities = display.newRect( barabilities_group, cx, 0, width, barheight )
    BarAbilities:setFillColor(barcolor())
    textTitleAbilities = display.newText( barabilities_group, "Abilities", 20, 0, native.systemFontBold, 20)
    textTitleAbilities.anchorX = 0

    abilities_group = display.newGroup()

    local PosX = {50,170}
    local PosY = {0,30}
    i = 0
    for value in string.gmatch(_abilities, "%S+") do
        local x = i%#PosX+1
        local y = math.round((i+1)/#PosY)
        textAbilities = display.newText( abilities_group, "- "..string.gsub(value,"#"," "), PosX[x], PosY[y], native.systemFont, 15)
        textAbilities:setFillColor(0.2,0.2,0.2)
        textAbilities.anchorX = 0
        i=i+1
    end
    ------------------------------------------------------
    barstatus_group = display.newGroup()

    BarStatus = display.newRect( barstatus_group, cx, 0, width, barheight )
    BarStatus:setFillColor(barcolor())
    textTitleStatus = display.newText( barstatus_group, "Status", 20, 0, native.systemFontBold, 20)
    textTitleStatus.anchorX = 0

    status_list = {}
    status_list[1] = { "Hp", pokemon.hp_normal }
    status_list[2] = { "Attack", pokemon.attack_normal }
    status_list[3] = { "Defense", pokemon.defense_normal }
    status_list[4] = { "SpAtk", pokemon.spatk_normal }
    status_list[5] = { "SpDef", pokemon.spdef_normal }
    status_list[6] = { "Speed", pokemon.speed_normal }

    bar_list = {}
    status_bar_width = 300
    max = 250

    bar_list[1] = (((status_list[1][2]/max)*100)/100)*status_bar_width
    bar_list[2] = (((status_list[2][2]/max)*100)/100)*status_bar_width
    bar_list[3] = (((status_list[3][2]/max)*100)/100)*status_bar_width
    bar_list[4] = (((status_list[4][2]/max)*100)/100)*status_bar_width
    bar_list[5] = (((status_list[5][2]/max)*100)/100)*status_bar_width
    bar_list[6] = (((status_list[6][2]/max)*100)/100)*status_bar_width

    status_group = display.newGroup()
    PosY_bar = 0
    for x=1, #bar_list do
        _bar = display.newRoundedRect( status_group, 105, PosY_bar, bar_list[x], 15, 2 )
        if(bar_list[x]/max > 0.6) then
            _bar:setFillColor(color(164, 201, 58))
        elseif(bar_list[x]/max > 0.3) then
            _bar:setFillColor(color(252, 208, 53))
        else
            _bar:setFillColor(color(231, 88, 50))
        end
        _bar.anchorX = 0

        textStatus = display.newText( status_group, status_list[x][1].." : "..status_list[x][2], 100, PosY_bar, native.systemFontBold, 15)
        textStatus:setFillColor(barcolor())
        textStatus.anchorX = 1

        PosY_bar = PosY_bar + 25
    end
    ------------------------------------------------------
    barevolution_group = display.newGroup()

    BarEvolution = display.newRect( barevolution_group, cx, 0, width, barheight )
    BarEvolution:setFillColor(barcolor())
    textTitleEvolution = display.newText( barevolution_group, "Evolution", 20, 0, native.systemFontBold, 20)
    textTitleEvolution.anchorX = 0

    evolution_group = display.newGroup()
    _evolution = string.gsub(pokemon.evolution,"|"," ")
    evolution_img_x = 50

    evolution_scroll = widget.newScrollView({
            height = 150,
        	width = width,
            verticalScrollDisabled = true,
            --listener = evolution_scrollListener
        })
    evolution_group:insert(evolution_scroll)
    for value in string.gmatch(_evolution, "%S+") do
        evolution_no = string.match(value, "#(%d%d%d)$")
        evolution_id = evolution_no+0
        evolution_generation = pokemon_list[evolution_id].generation
        evolution_img = display.newImage( generation_sheet[evolution_generation], evolution_id )
        evolution_img.id = evolution_id
        evolution_img.anchorY = 0
        evolution_img.x = evolution_img_x
        evolution_img_x = evolution_img_x + 130
        evolution_img:addEventListener("touch", event_evolution)
        evolution_scroll:insert(evolution_img)
    end

    ------------------------------------------------------
    detail_group.y = 140
    barabilities_group.y = 220
    abilities_group.y = 260
    barstatus_group.y = 340
    status_group.y = 380
    barevolution_group.y = 550
    evolution_group.y = 570
    group:insert(detail_group)
    group:insert(barabilities_group)
    group:insert(abilities_group)
    group:insert(barstatus_group)
    group:insert(status_group)
    group:insert(status_group)
    group:insert(barevolution_group)
    group:insert(evolution_group)
    scrollView:insert(group)

    return scrollView
end

function scene:create( event )
    local sceneGroup = self.view
    local group = display.newGroup()
    local id = event.params.id
    pokemon = pokemon_list[id]
    group:insert(init())
    group:insert(generate_topbar(pokemon.name,true))
    group:insert(generate_footbar())
    sceneGroup:insert(group)
end

function scene:show( event )
end

function scene:hide( event )
    if(event.phase == "did") then
        self.view = nil
        composer.removeScene( "pokemon_detail" )
    end
end

function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
