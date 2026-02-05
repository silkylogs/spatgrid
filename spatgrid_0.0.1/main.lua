function love.load()
    img = love.graphics.newImage("cube.png")
    font = love.graphics.getFont()
    mouse_x = 0
    mouse_y = 0
    imgcoords = {}
    status = "Spatgrid 0.0.1. Save directory is \"" .. love.filesystem.getAppdataDirectory() .. "\""
end

function love.update()
    mouse_x = love.mouse.getX()
    mouse_y = love.mouse.getY()
    if love.mouse.isDown(1) then
        table.insert(imgcoords, {mouse_x, mouse_y})
        status = "Progress unsaved. Coord count: " .. #imgcoords
    end
end

function love.keypressed(key, scancode, isrepeat)
    -- Save
    if key == "s" then
        local timestamp = os.time(os.date("!*t"))
        local file = "img_" .. timestamp .. ".txt"

        local data = ""
        for i=1,#imgcoords do
            local x = imgcoords[i][1]
            local y = imgcoords[i][2]
            data = data .. x .. " " .. y .. "\n"
        end

        local success, message = love.filesystem.write(file, data)
        if success then
            status = file.. ": Saved to disk"
        else
            status = file..": Save not successful: " .. message
        end
    end

    -- Erase status bar
    if key == "e" then
        status = ""
    end

    -- Clear everything
    if key == "escape" then
        imgcoords = {}
    end
end

-- Load file
function love.filedropped(file)
    -- imgcoords = {}
    file:open("r")

    for line in file:lines() do
        local x = "%d+"
        local y = " %d+"
        local function substr(line, pattern)
            return string.sub(line, string.find(line, pattern))
        end
        local x = tonumber(substr(line, x))
        local y = tonumber(substr(line, y))
        table.insert(imgcoords, {x, y})
    end


    status = "Loaded file: \"" .. file:getFilename() .. "\""
end

function love.draw()
    local cube = function(x, y)
        love.graphics.draw(img, x, y, 0, 0.25, 0.25, 128, 128)
    end

    for i=1,#imgcoords do
        local x = imgcoords[i][1]
        local y = imgcoords[i][2]
        cube(x, y)
    end
    cube(mouse_x, mouse_y)

    love.graphics.draw(love.graphics.newText(font, status))
end