function love.load()
    w = love.graphics.getWidth()
    h = love.graphics.getHeight()

    love.graphics.setDefaultFilter("nearest", "nearest")

    marker = {
        x = w / 2,
        y = h / 2,
        sprite = love.graphics.newImage("marker.png"),
        dx = 0,
        dy = 0,
        speed = 100,
        drawRadius = 8,
        size = 3,
        color = { 0, 0, 0 }
    }
    mouseMode = false
    randMoveTimer = 0
    overloadDots = false
    time = 0
    dots = {}
    dotnumber = 1
    dotRemoveTimer = 65
    dotLimit = 165000
end

local function spawnDot(x, y)
    table.insert(dots, {
        x = x,
        y = y,
        size = marker.drawRadius,
        color = marker.color,
        number = dotnumber,
    })
end

local function getRandomColor()
    local r = math.random()
    local g = math.random()
    local b = math.random()
    return { r, g, b }
end

function love.update(dt)
    deltaTime = dt
    time = time + dt
    -- marker.dx, marker.dy = 0, 0

    randMoveTimer = randMoveTimer + dt

    if #dots > dotLimit then
        time = 0
        overloadDots = true
    else
        overloadDots = false
    end

    if randMoveTimer > 3 then
        randMoveTimer = 0
        marker.color = getRandomColor()
    end

    if love.keyboard.isDown("left") then
        marker.dx = marker.speed * -1
    end
    if love.keyboard.isDown("right") then
        marker.dx = marker.speed * 1
    end
    if love.keyboard.isDown("up") then
        marker.dy = marker.speed * -1
    end
    if love.keyboard.isDown("down") then
        marker.dy = marker.speed * 1
    end

    if mouseMode then
        marker.x, marker.y = love.mouse.getPosition()
    end
    if mouseMode then
        if love.mouse.isDown(1) then
            spawnDot(marker.x, marker.y)
        end
    else
        spawnDot(marker.x, marker.y)
    end
    if overloadDots then
        table.remove(dots, dotnumber)
    end

    if marker.x < 0 then
        marker.dx = math.abs(marker.dx)
    end
    if marker.x > w then
        marker.dx = -math.abs(marker.dx)
    end
    if marker.y < 0 then
        marker.dy = math.abs(marker.dx)
    end
    if marker.y > h then
        marker.dy = -math.abs(marker.dx)
    end

    marker.x = marker.x + marker.dx * dt
    marker.y = marker.y + marker.dy * dt
    dotLimit = math.floor(1 / deltaTime * 100)
end

function love.keypressed(key)
    if key == "m" then
        mouseMode = not mouseMode
    end
    if key == "c" then
        dots = {}
        overloadDots = false
    end
    if key == "escape" then
        love.event.quit()
    end
end

function love.draw()
    love.graphics.setColor(.9, .9, .9)
    love.graphics.rectangle("fill", 0, 0, w, h)

    for _, dot in ipairs(dots) do -- dot drawing loop
        love.graphics.setColor(dot.color[1], dot.color[2], dot.color[3])
        love.graphics.circle("fill", dot.x, dot.y, dot.size)
    end
    love.graphics.draw(marker.sprite, marker.x, marker.y, nil, marker.size, marker.size)

    love.graphics.print(math.floor(1 / deltaTime), 10, 10)
    love.graphics.print(love.timer.getFPS(), 10, 25)
end
