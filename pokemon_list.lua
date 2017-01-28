local composer = require( "composer" )
local scene = composer.newScene()
local list_table = nil
local rowHeight = 120
local tableView
--local mask = graphics.newMask( "img/maskcircle.png" )
local topbar_title = "Pokemon List"
local backindex = 0
local generation_index = 0
local pokemon_touch
local search_group = nil
local textfield_search = nil
local search_box_hide = true
local search_group

function barcolor()
    return color(7, 117, 201)
end

function touch_p(event)
    if(event.phase == "began") then
        pokemon_touch = event.target.id
    end
end

function event_search_box(event)
    function hidesearch_group(b)
        search_group.isVisible = b
    end

    if(event.phase == "ended") then

        if(search_box_hide) then
            search_box_hide = false
            hidesearch_group(true)
            transition.to(search_group,{ time = 300, y = 0 })
        else
            search_box_hide = true
            transition.to(search_group,{ time = 300, y = 50, onComplete =
                function()
                    hidesearch_group(true)
                end
            })
        end
    end
end

function submit_search(event)
    if(event.phase == "ended") then
        insert_tableView(textfield_search.text)
        event_search_box({ phase = "ended" })
    end
end

function rowRender(event)
    row = event.row
    margin = 20
    x = { (row.width/2)-120+margin, row.width/2+1, (row.width/2)+120-margin }
    for i=1, 3 do
        index = row.id + i - 1
        if(list_table[index] ~= nil and list_table[index].type == "pokemon") then
                _id = list_table[index].id
                _no = list_table[index].no
                _name = list_table[index].name
                _generation = list_table[index].generation
                group = display.newGroup()

                img = display.newImage( generation_sheet[_generation], _id )
                img.y = 0
                img.anchorY = 0

                rowBarTopHeight = 10

                rowBarTitleHeight = 30
                rowBarTitle = display.newRoundedRect( 0, img.height-rowBarTitleHeight/3, img.width, rowBarTitleHeight, 5 )
                rowBarTitle:setFillColor(barcolor())
                rowBarTitle.anchorY = 0

                rowTitle = display.newText( _name, 0, rowBarTitle.y+rowBarTitleHeight/3+2)
                rowTitle.anchorY = 0

                group:insert(rowBarTitle)
                group:insert(rowTitle)
                group:insert(img)
                group.x = x[i]
                group:scale(0.7,0.7)
                group.id = _id
                group:addEventListener("touch",touch_p)
                row:insert(group)
                if(list_table[index+1] ~= nil and list_table[index+1].type == "generation") then
                    break
                end
        elseif(list_table[index] ~= nil and  list_table[index].type == "generation") then
            name = list_table[index].name
            text = "Generation "..name
            rowBar = display.newRoundedRect(row, row.width/2, 20, row.width+margin, 30, 10 )
            rowBar:setFillColor(barcolor())
            rowTitle = display.newText(row, text,30,20, native.systemFontBold, 18)
            rowTitle.anchorX = 0
            break
        end
    end
end

function rowTouch(event)
    if(event.phase == "tap" and pokemon_touch ~= nil) then
        local options = {
            effect = "slideLeft",
            time = 500,
            params = {
                id = pokemon_touch
            }
        }
        composer.gotoScene( "pokemon_detail", options )
    end
    pokemon_touch = nil
end

function generate_tableView()
    tableView = widget.newTableView{
        top = 20,
    	height = height-27,
    	width = width,
    	onRowRender = rowRender,
    	onRowTouch = rowTouch,
        backgroundColor = { 1, 1, 1, 0},
        listener = scrollListener
    }
end

function insert_tableView(search_text)
    tableView:deleteAllRows()
    list_table = nil
    list_table = {}
    ------------ generate list table -------------

    if(search_text ~= nil) then
        search_id = string.match(search_text, "#(%d%d%d)$")
        if(search_id ~= nil) then
            search_id = search_id+0
            table.insert(list_table,{ type = "generation", name = pokemon_list[search_id].generation })
            pokemon_list[search_id]["type"] = "pokemon"
            table.insert(list_table, pokemon_list[search_id])
        else
            for i, row in ipairs(pokemon_list) do
                f = string.find(string.lower(row.name),string.lower(search_text))
                if(f ~= nil) then
                    if(#list_table == 0 or row.generation > list_table[#list_table].generation) then
                        table.insert(list_table,{ type = "generation", name = row.generation })
                    end
                    row["type"] = "pokemon"
                    table.insert(list_table, row)
                end
            end
        end
    else
        for i, row in ipairs(pokemon_list) do
            if(#list_table == 0 or row.generation > list_table[#list_table].generation) then
                table.insert(list_table,{ type = "generation", name = row.generation })
            end
            row["type"] = "pokemon"
            table.insert(list_table, row)
        end
    end

    ------------ insert table -------------
    i = 1
    while i <= #list_table do
        _height = rowHeight

        if(list_table[i]["type"] == "generation") then
            _height = 50
        end

        tableView:insertRow({
            isCategory = false,
            rowWidth = 50,
            rowHeight = _height,
            rowColor = { default = {1, 1, 1, 0}, over = {1, 1, 1, 0} },
            lineColor = {1, 1, 1, 0},
            id = i
        })
        if(list_table[i]["type"] == "pokemon") then
            for x=1, 2 do
                i=i+1
                if(i <= #list_table and list_table[i]["type"] == "generation") then
                    i=i-1
                    break
                end
            end
        end
        i=i+1
    end
end

function init()
    local y = height+20
    local h = 50
    search_group = display.newGroup()
    bar_search = display.newRect( 0, y, width+5, h )
    bar_search.anchorX = 0
    bar_search:setFillColor(color(15, 130, 220))

    submit_search_icon = display.newImage( "icon/submit.png", width-15, y )
    submit_search_icon:scale(0.2,0.2)
    submit_search_icon:addEventListener("touch",submit_search)

    textfield_search = native.newTextField( height+100,y,width-40,35)
    textfield_search.anchorX = 0
    textfield_search.x = 10

    --search_group.isVisible = false
    search_group:insert(bar_search)
    search_group:insert(submit_search_icon)
    search_group:insert(textfield_search)
    search_group.x = 0
    search_group.y = 50
end

function scene:create( event )
    local sceneGroup = self.view
    local group = display.newGroup()
    generate_tableView()
    insert_tableView(search_text)
    init()

    group:insert(setBackground())
    group:insert(tableView)
    group:insert(generate_topbar(topbar_title))
    group:insert(generate_footbar())
    group:insert(search_group)
    sceneGroup:insert(group)
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
