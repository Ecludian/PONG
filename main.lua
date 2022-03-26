--Pong remake based on classic Atari nes game

WIDTH = 1280
HEIGHT = 720

--Load when the game start, once, used to initialize the game
function love.load()
    love.window.setMode(WIDTH, HEIGHT,{
         fullscreen = false,
         vsync = true,
         resizable = false
    })
end

function love.draw()
    love.graphics.printf(
        'Hello Pong!', -- text to ender
        0,             --  starting x (center)
        HEIGHT/2-6,    -- starting y (half of the screen)
        WIDTH,         -- number of pixels to center within
        'center'       -- alignment mode, center, left, or right
    )
end