--Pong remake based on classic Atari nes game

WIDTH = 1280
HEIGHT = 720

-- https://github.com/Ulydev/push
push = require 'push'
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

require 'Paddle'
require 'Ball'

V_WIDTH = 432
V_HEIGHT = 243

paddleSpeed = 200

--Load when the game start, once, used to initialize the game
function love.load()

    love.window.setTitle('Pong')
    -- Graphisc & Texture Filtering
    -- nearest-neightbor filtering on upscaling and downscaling to prevent text blurry
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())
    -- create font object
    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- set LOVE2D's active font to the same font we choose
    love.graphics.setFont(smallFont)

    sounds = {
        ['paddles_Hit'] = love.audio.newSource('sounds/Paddles_Hit.wav', 'static'),
        ['wall_Hit'] = love.audio.newSource('sounds/Wall_Hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/Score.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory_stage.ogg', 'static')
    }

    -- Replace with push function instead
    --[[  love.window.setMode(WIDTH, HEIGHT,{
         fullscreen = false,
         vsync = true,
         resizable = false
        
    })]]

    push:setupScreen(V_WIDTH, V_HEIGHT, WIDTH, HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
    --[[ REPLACED WITH BALL CLASS
         ballX = V_WIDTH/2 -2
         ballY = V_HEIGHT/2 - 2
    ]]
    -- Ball Class
    ball = Ball(V_WIDTH / 2 - 2, V_HEIGHT / 2 - 2, 4, 4)
   
    --[[ REPLACED WITH BALL CLASS
        ballDX = math.random(2) == 1 and 100 or -100
        ballDY = math.random(-50, 50)
    ]]
   

    --Initialize score variable
    player1Score = 0
    player2Score = 0

    servingPlayer = 1

    --[[ REPLACED WITH PADDLE CLASS
        player1Y = 30
        player2Y = V_HEIGHT - 50
    ]]

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(V_WIDTH - 15, V_HEIGHT - 30, 5, 20)
  

    gamestate = 'start'
end

function love.resize(w, h)
    push:resize(w, h)
end

-- Runs every frame with "dt" or deltaTime in second since the last frame.
function love.update(dt)

    if gamestate == 'serve' then
        -- initialize ball's velocity based on player who last scored
        ball.dy = math.random(-50 ,50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end

    elseif gamestate == 'play' then
        --[[ REPLACED WITH BALL CLASS
            ballX = ballX + ballDX * dt
            ballY = ballY + ballDY * dt
        ]]
    
        if ball:collide(player1) then
            -- detect the ball collision with paddles, reverse dx if its true
            -- slightly increase it, then altering the dy based on position
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            -- keep the velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['paddles_Hit']:play()
        end
        if ball:collide(player2) then
            -- detect the ball collision with paddles, reverse dx if its true
            -- slightly increase it, then altering the dy based on position
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            -- keep the velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds['paddles_Hit']:play()
        end

        -- detect upper and lower boundary og the screen and reverse it  y velocity
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_Hit']:play()
        end

        if ball.y >= V_HEIGHT - 4 then
            ball.y = V_HEIGHT - 4
            ball.dy = -ball.dy
            sounds['wall_Hit']:play()
        end

        --THE SCORE--
        -- if the ball reach the left or right edge of the screen
        -- go back to start and update the score

        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            sounds['score']:play()

            if player2Score == 10 then
                winningPlayer = 2
                gamestate = 'done'
                sounds['victory']:play()
            else
                gamestate = 'serve'
                ball:reset()
            end
        end


        if ball.x > V_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            sounds['score']:play()

            if player1Score == 10 then
                winningPlayer = 1
                gamestate = 'done'
                sounds['victory']:play()
            else
                gamestate = 'serve'
                ball:reset()
            end
        end
    end
        
        --player 1 paddle control
        if love.keyboard.isDown('w')then
            --player1Y = math.max(0, player1Y + -paddleSpeed * dt) (REPLACED WITH player1 USING PADDLE CLASS)
            player1.dy = -paddleSpeed
        elseif love.keyboard.isDown('s')then
            --player1Y = math.min(V_HEIGHT-20, player1Y + paddleSpeed * dt)
            player1.dy = paddleSpeed
        else
            player1.dy = 0
        end
            
        --player 2 paddle control
        if love.keyboard.isDown('up')then
            --player2Y = math.max(0, player2Y + -paddleSpeed * dt) (REPLACE WITH player2 USING PADDLE CLASS)
            player2.dy = -paddleSpeed
        elseif love.keyboard.isDown('down')then
            --player2Y = math.min(V_HEIGHT-20, player2Y + paddleSpeed * dt)
            player2.dy = paddleSpeed
        else
            player2.dy = 0
                
        end

        if gamestate == 'play' then
            ball:update(dt)
        end

    player1:update(dt)
    player2:update(dt)

end

-- Keyboard Handling
function love.keypressed(key)
    --keys can be accessed by string name
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gamestate == 'start' then
            gamestate = 'serve'
        elseif gamestate == 'serve' then
            gamestate = 'play'
        elseif  gamestate == 'done' then
            gamestate = 'serve'

            ball:reset()

            -- reset scores to 0
            player1Score = 0
            player2Score = 0

            -- decide which player who serve according to opposite of winning player
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
            
            --[[ REPLACED WITH BALL CLASS
                --start the ball in the middle of the screen
                ballX = V_WIDTH/2-2
                ballY = V_HEIGHT/2-2
            
                --give ball x and y velocity a random starting number
                ballDX = math.random(2) == 1 and 100 or -100
                ballDY = math.random(-50, 50) * 1.5
            ]]
            --ball's new reset method
            --ball:reset()
        end
    end
end


function love.draw()
    -- begin rendering at virtual resolutin
    push:apply('start')
   -- clear the screen with a sepcific color
   love.graphics.clear(40/255, 45/255, 52/255, 255/255)
   
   displayScore()

    love.graphics.setFont(smallFont)
    if gamestate == 'start' then
    love.graphics.printf(
        'Welcome to Pong!', -- text to ender
        0,             --  starting x (center)
        --replace heihgt and width with virtual one
        20,            -- starting y (half of the screen)
        V_WIDTH,       -- number of pixels to center within
        'center'       -- alignment mode, center, left, or right
        
    )
    love.graphics.printf('Press ENTER to begin!', 0, 35, V_WIDTH, 'center')
    elseif gamestate == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s Serve",0, 10, V_WIDTH, 'center')
    love.graphics.printf('Press ENTER to serve!', 0, 20, V_WIDTH, 'center')
    elseif gamestate == 'play' then
    love.graphics.printf('PLAY', 0, 20, V_WIDTH, 'center')

    elseif  gamestate == 'done' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' Wins!',0,10, V_WIDTH, 'center' )
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 30, V_WIDTH, 'center')
        

    end


    -- draw net
    --.graphics.rectangle('fill', V_WIDTH/2, V_HEIGHT/2, 1, 4)

    --PADDLES & BALL

    -- Left paddles
    --love.graphics.rectangle('fill', 10, player1Y, 5, 20)(REPLACED WITH PADDLE CLASS)
    --new Paddle's render method
    player1:render()
    -- Right paddles
    --love.graphics.rectangle('fill', V_WIDTH - 15, player2Y, 5, 20)(REPALACED WITH PADDLE CLASS)
     --new Paddle's render method
     player2:render()
    -- BALL
    --love.graphics.rectangle('fill', ballX, ballY, 4, 4)(REPLACED WITH BALL CLASS)
    --new Ball's renders method
    ball:render()
    displayFPS()
    push:apply('end')
    
end
function displayScore()
-- set score to use scroefont
love.graphics.setFont(scoreFont)
-- draw the score
love.graphics.print(tostring(player1Score), V_WIDTH/2 - 50, V_HEIGHT/3)
love.graphics.print(tostring(player2Score), V_WIDTH/2 + 30, V_HEIGHT/3)

end
function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255 ,0, 255)
    love.graphics.print('FPS: '.. tostring(love.timer.getFPS()), 10, 10)
end