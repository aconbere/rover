require('class')

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
function Choice:init(width, height, image)
  self.width = width
  self.height = height
  self.image = image
end

function Choice:draw()
  love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, 0, 0)
end

Toolbar = class()
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
  toolbar:addItem(Choice.new(AND:getWidth(), AND:getHeight(), AND))
  toolbar:addItem(Choice.new(OR:getWidth(), OR:getHeight(), OR))
  toolbar:addItem(Choice.new(XOR:getWidth(), XOR:getHeight(), XOR))
  toolbar:setup()
  return toolbar
end
