-- Countdown Timer Example

-- Initialize the countdown
timer = {}

local countdownTime = 60
local timeRemaining = countdownTime
local isTimerRunning = true

function timer.load()
    -- Set up the font for the timer display
    font = love.graphics.newFont(10)
    love.graphics.setFont(font)
end

function timer.update(dt)

    if isTimerRunning then
        -- Update the countdown every second
        timeRemaining = timeRemaining - dt
        if timeRemaining <= 0 then
            timeRemaining = 0
            isTimerRunning = false  -- Stop the countdown when it reaches 0
        end
    end

    cam:lookAt(camera.x , camera.y)
end

function timer.draw()
    -- Save the current transformation
    love.graphics.push()
    
    -- Reset the transformation to make the position fixed in the window
    love.graphics.origin()
    
    -- Set text color to white
    love.graphics.setColor(1, 1, 1)

    -- Draw the timer text at a fixed position in the window
    love.graphics.printf("Time Remaining: " .. math.ceil(timeRemaining), 50, 50, love.graphics.getWidth(), "left")
    
    -- If the timer has finished, display a "Time's Up!" message
    if not isTimerRunning then
        love.graphics.printf("Time's Up!", 50, 80, love.graphics.getWidth(), "left")
    end

    -- Restore the previous transformation
    love.graphics.pop()
end



return timer
