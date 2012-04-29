require('class')

require('circuit/circuit')

Title = class()
function Title:init(text, font)
  self.text = text
  self.font = font
  self.width = font:getWidth(self.text)
  self.height = font:getHeight()
end

function Title:draw()
  love.graphics.setColorMode("modulate")
  love.graphics.setColor(0,0,0)
  love.graphics.setFont(self.font)
  love.graphics.print('Tools', self.x, self.y)
  love.graphics.setColorMode("replace")
end

Choice = class()
function Choice:init(image, source, world, mouse)
  self.world = world
  self.width = image:getWidth() + 5
  self.height = image:getHeight() + 5
  self.image = image
  self.source = source
  self.hover = false

  mouse:register("update", function (mx, my)
    if self:intersect(mx, my) then
      self.hover = true
    else
      self.hover = false
    end
  end)

  mouse:register("mousepressed", function (mx,my,button)
    if button == "l" then
      if self:intersect(mx, my) then
        c = self.source.new(mx, my, world, mouse)
        c.__active = true
        c.__offsetX = mx - self.x
        c.__offsetY = my - self.y
        world:addObject(c)
      end
    end
  end)
end

function Choice:intersect(mx,my)
  return mx > self.x and mx < self.x + self.width and
         my > self.y and my < self.y + self.height
end

function Choice:draw()
  if self.hover then
    love.graphics.setColor(255, 255, 255)
  else
    love.graphics.setColor(255, 255, 0)
  end
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, 0, 0)
  love.graphics.setColor(0, 0, 0)
end

Toolbar = class({ name = "toolbar" })
function Toolbar:init(world, mouse)
  self.items = {}
  self.maxWidth = 0
  self.world = world
  self.mouse = mouse
end

function Toolbar:draw()
  love.graphics.setColorMode("replace")
  love.graphics.setColor(0, 255, 255)
  love.graphics.rectangle("fill", 0, 0, self.maxWidth + 20, self.world.height)
  love.graphics.setColor(0, 0, 0)

  for i, item in ipairs(self.items) do
    item:draw()
  end
end

function Toolbar:addItem(i)
  if i.width > self.maxWidth then
    self.maxWidth = i.width
  end

  table.insert(self.items, i)
end

function Toolbar:setup()
  local x = 10
  local y = 10

  local padding = 10

  for i, item in ipairs(self.items) do
    item.x = x
    item.y = y

    y = (y + item.height + padding)
  end
end

function Toolbar.circuitDesign(world, mouse, font)
  local AND = love.graphics.newImage("and.png")
  local XOR = love.graphics.newImage("xor.png")
  local OR = love.graphics.newImage("or.png")
  local font = love.graphics.newFont(24)

  local toolbar = Toolbar.new(world, mouse)
  toolbar:addItem(Title.new("Tools", font))
  toolbar:addItem(Choice.new(AND, circuit.ANDGate, world, mouse))
  toolbar:addItem(Choice.new(OR, circuit.ORGate, world, mouse))
  toolbar:addItem(Choice.new(XOR, circuit.XORGate, world, mouse))
  toolbar:setup()
  return toolbar
end
