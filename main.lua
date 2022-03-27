--Pong remake based on classic Atari nes game

WIDTH = 1280
HEIGHT = 720

-- https://github.com/Ulydev/push
push = require 'push'

V_WIDTH = 432
V_HEIGHT = 243

paddleSpeed = 200

--Load when the game start, once, used to initialize the game
function love.load()

    -- Graphisc & Texture Filtering
    -- nearest-neightbor filtering on upscaling and downscaling to prevent text blurry
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())
    -- create font object
    smallFont = love.graphics.newFont('font.ttf', 8)

    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- set LOVE2D's active font to the same font we choose
    love.graphics.setFont(smallFont)

    -- Replace with push function instead
    --[[  love.window.setMode(WIDTH, HEIGHT,{
         fullscreen = false,
         vsync = true,
         resizable = false
        
    })]]

    push:setupScreen(V_WIDTH, V_HEIGHT, WIDTH, HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    ballX = V_WIDTH/2 -2
    ballY = V_HEIGHT/2 - 2

    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)

    --Initialize score variable
    player1Score = 0
    player2Score = 0

    player1Y = 30
    player2Y = V_HEIGHT - 50
  

    gamestate = 'start'
end

function love.update(dt)
    --player 1 paddle control
    if love.keyboard.isDown('w')then
        player1Y = math.max(0, player1Y + -paddleSpeed * dt)
    elseif love.keyboard.isDown('s')then
        player1Y = math.min(V_HEIGHT-20, player1Y + paddleSpeed * dt)
    end
        
    --player 2 paddle control
    if love.keyboard.isDown('up')then
        player2Y = math.max(0, player2Y + -paddleSpeed * dt)
    elseif love.keyboard.isDown('down')then
        player2Y = math.min(V_HEIGHT-20, player2Y + paddleSpeed * dt)
    end

    if gamestate == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end

end

-- Keyboard Handling
function love.keypressed(key)
    --keys can be accessed by string name
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gamestate == 'start' then
            gamestate = 'play'
        else
            gamestate = 'start'
            
            --start the ball in the middle of the screen
            ballX = V_WIDTH/2-2
            ballY = V_HEIGHT/2-2
            
            --give ball x and y velocity a random starting number
            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50) * 1.5
        end
    end
end


function love.draw()
    -- begin rendering at virtual resolutin
    push:apply('start')
   -- clear the screen with a sepcific color
   love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    love.graphics.setFont(smallFont)
    if gamestate == 'start' then
    love.graphics.printf(
        'Hello Pong!', -- text to ender
        0,             --  starting x (center)
        --replace heihgt and width with virtual one
        20,            -- starting y (half of the screen)
        V_WIDTH,       -- number of pixels to center within
        'center'       -- alignment mode, center, left, or right
    )
    else
    love.graphics.printf('PLAY', 0, 20, V_WIDTH, 'center')
    end

    -- set score to use scroefont
    love.graphics.setFont(scoreFont)
    -- draw the score
    love.graphics.print(tostring(player1Score), V_WIDTH/2 - 50, V_HEIGHT/3)
    love.graphics.print(tostring(player2Score), V_WIDTH/2 + 30, V_HEIGHT/3)


    -- draw net
    --.graphics.rectangle('fill', V_WIDTH/2, V_HEIGHT/2, 1, 4)

    --PADDLES & BALL

    -- Left paddles
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)
    -- Right paddles
    love.graphics.rectangle('fill', V_WIDTH - 15, player2Y, 5, 20)
    -- BALL
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)
 
    push:apply('end')
    
end