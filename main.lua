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
        drawRadius = 5,
        size = 3,
        color = { 0, 0, 0 }
    }
    mouseMode = false
    randMoveTimer = 0
    time = 0
    dots = {}
end

local function spawnDot(x, y)
    table.insert(dots, {
        x = x,
        y = y,
        size = marker.drawRadius,
        color = marker.color,
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
    marker.dx, marker.dy = 0, 0
    if mouseMode then
        marker.x, marker.y = love.mouse.getPosition()
    end

    randMoveTimer = randMoveTimer + dt

    if time > 55 then
        time = 0
        love.keypressed("c")
    end

    if randMoveTimer > 3 then
        randMoveTimer = 0
        marker.color = getRandomColor()
    end

    if dir == "up" then
        marker.dy = marker.speed * -1
    elseif dir == "down" then
        marker.dy = marker.speed * 1
    elseif dir == "left" then
        marker.dx = marker.speed * -1
    elseif dir == "right" then
        marker.dx = marker.speed * 1
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

    spawnDot(marker.x, marker.y)

    marker.x = marker.x + marker.dx * dt
    marker.y = marker.y + marker.dy * dt
end

function love.keypressed(key)
    if key == "m" then
        mouseMode = not mouseMode
    end
    if key == "c" then
        time = 0
        dots = {}
    end
end

function love.draw()
    love.graphics.setColor(.9, .9, .9)
    love.graphics.rectangle("fill", 0, 0, w, h)

    for _, dot in ipairs(dots) do
        love.graphics.setColor(dot.color[1], dot.color[2], dot.color[3])
        love.graphics.circle("fill", dot.x, dot.y, dot.size)
    end
    love.graphics.setColor(marker.color[1], marker.color[2], marker.color[3])
    love.graphics.draw(marker.sprite, marker.x, marker.y, nil, marker.size, marker.size)
    love.graphics.print(math.floor(1 / deltaTime), 10, 10)
end
