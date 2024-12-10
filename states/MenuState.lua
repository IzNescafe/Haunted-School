MenuState = Class{__includes = BaseState}

function MenuState:init()
    mousepressed = false
    BUTTON_WIDTH , BUTTON_HEIGHT = 150, 80
    SPRITE_WIDTH = 150 * 2
    SPRITE_HEIGHT = BUTTON_HEIGHT
    buttonSheet = love.graphics.newImage('res/button-Sheet.png')

    buttons = {
        play = love.graphics.newImage('res/play-Sheet.png'),
        options = love.graphics.newImage('res/options-Sheet.png'),
        exit = love.graphics.newImage('res/exit-Sheet.png')
    }

    quads = {}

    for i = 1, 2 do
        quads[i] = love.graphics.newQuad(BUTTON_WIDTH, BUTTON_HEIGHT * ( i - 1 ), BUTTON_WIDTH, BUTTON_HEIGHT, SPRITE_WIDTH, SPRITE_HEIGHT)
    end
end

function MenuState:update(dt)

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function MenuState:render()
    love.graphics.draw(buttons.play, quads[1], WINDOW_WIDTH/2 - BUTTON_WIDTH, WINDOW_HEIGHT/4 - BUTTON_HEIGHT, nil, 2)
    love.graphics.draw(buttons.options, quads[1], WINDOW_WIDTH/2 - BUTTON_WIDTH, WINDOW_HEIGHT * 2/4 - BUTTON_HEIGHT - 50, nil, 2)
    love.graphics.draw(buttons.exit, quads[1], WINDOW_WIDTH/2 - BUTTON_WIDTH, WINDOW_HEIGHT * 3/4 - BUTTON_HEIGHT - 100, nil, 2)
end