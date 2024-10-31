menu = {}

BUTTON_HEIHGT = 64

local function newButton(text, fn)
  return{
    text = text,
    fn = fn,

    now = false,
    last = false
  }
end

local buttons = {}
local font = nil

function menu.load()
  font = love.graphcis.newFont(32)

  table.insert(buttons, newButton(
      "Start Game", 
      function()
        print("Starting Game!") --story.load(), chooseCharacter.load(), choseCharacter.update(), play.load(), play.update(), play.draw()
      end))

  table.insert(buttons, newButton(
      "Setings", 
      function()
        print("Going to Setting Menu")
      end))

  table.insert(buttons, newButton(
      "Exit",
      function()
        love.event.quit(0)
      end))
end

function menu.update(dt)

end

function menu.draw()
  local ww = love.graphics.getWidth()
  local wh = love.graphics.getHeight()

  local buton_width = ww * (1/3)
  local margin = 16

  local total_height = (BUTTON_HEIGHT + margin) * #buttons

  local cursor_y = 0

  for i, button in ipairs(buttons) do
    button.last = button.now

    local bx = ( ww * 0.5 ) - ( button_width * 0.5 )
    local by = ( wh * 0.5 ) - ( total_height * 0.5 ) + cursor_y

    local color = { 0.4, 0.4, 0.5, 1.0 }
    local mx, my = love.mouse.getPosition()

    local hot = mx > bx and mx < bx + button_width and my > by and my < by + BUTTON_HEIGHT

    if hot then
      color = { 0.8, 0.8, 0.9, 1.0 }
    end

    button.now = love.mouse.isDown(1)

    if button.now and not button.last and hot then
      button.fn()
    end

    love.graphics.setColor(unpack(color))
    love.graphics.rectangle(bx, by, button_width, BUTTON_HEIGHT)

    love.graphics.setColor(0, 0, 0, 1)

    local textW = font:getWidth(button.text)
    local textH = font:getHeight(button.text)

    love.graphics.print(
      button.text, 
      font, 
      (ww * 0.5 ) - textW * 0.5,
      by + textH * 0.5
    )
    cursor_y = curosr_y + (BUTTON_HEIGHT + margin)
  end
end

return menu
  
