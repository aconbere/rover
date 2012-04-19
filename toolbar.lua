require('class')

Title = class()
function Title:init(text)
  self.text = text
end

function Title:draw()
  love.graphics.print('Tools', self.x, self.y)
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
function Toolbar:init(world, mouse, items)
  self.items = items
  self.world = world
end

function Toolbar:draw()
  love.graphics.setColorMode("replace")
  love.graphics.setColor(0, 255, 255)
  love.graphics.rectangle("fill", 0, 0, 60, self.world.height)
  love.graphics.setColor(0, 0, 0)

  for i, item in ipairs(self.items) do
    item:draw()
  end
end

function Toolbar:addItem(i)
  maxWidth = 0
  nextHeight = 0
  padding = 10
  
  for i, item in ipairs(self.items) do

  end
end

function Toolbar.circuitDesign(world, mouse)
  AND = love.graphics.newImage("and.png")
  XOR = love.graphics.newImage("xor.png")
  OR = love.graphics.newImage("or.png")

  return Toolbar.new(world, mouse, {
    Title.new("Tools"),
    Choice.new(AND:getWidth(), AND:getHeight(), AND),
    Choice.new(OR:getWidth(), OR:getHeight(), OR),
    Choice.new(XOR:getWidth(), XOR:getHeight(), XOR),
  })
end
