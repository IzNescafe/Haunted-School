Class = require 'libraries/class'
push = require 'libraries/push'
require 'helpers/StateMachine'
require 'states/MenuState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Haunted School')

    push:setupScreen(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['menu'] = function() return MenuState() end,
        ['play'] = function() return PlayState() end,
        ['pause'] = function() return PauseState() end
    }

    gStateMachine:change('menu')

    love.keyboard.keysPressed = {}

    love.mouse.buttonsPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    gStateMachine:update(dt)
    
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()

    love.graphics.clear(255/255, 207/255, 245/255)
    gStateMachine:render()

    push:finish()
end