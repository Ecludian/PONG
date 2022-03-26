--Pong remake based on classic Atari nes game

WIDTH = 1280
HEIGHT = 720

-- https://github.com/Ulydev/push
push = require 'push'

V_WIDTH = 432
V_HEIGHT = 243

--Load when the game start, once, used to initialize the game
function love.load()

    -- Graphisc & Texture Filtering
    -- nearest-neightbor filtering on upscaling and downscaling to prevent text blurry
    love.graphics.setDefaultFilter('nearest', 'nearest')

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
  
end

-- Keyboard Handling
function love.keypressed(key)
    --keys can be accessed by string name
    if key == 'escape' then
        love.event.quit()
    end
end


function love.draw()
    -- begin rendering at virtual resolutin
    push:apply('start')

    love.graphics.printf(
        'Hello Pong!', -- text to ender
        0,             --  starting x (center)
        --replace heihgt and width with virtual one
        V_HEIGHT/2-6,    -- starting y (half of the screen)
        V_WIDTH,         -- number of pixels to center within
        'center'       -- alignment mode, center, left, or right
    )
    push:apply('end')
end