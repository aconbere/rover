--[[
--            __
-- signal___ |  \_
--           |__/
--
--
-- A Circuit is a graph of CircuitItems
--
-- Signals propegate through the graph in a
-- breadth first search.
--
-- CircuitItems have inputs and outputs
--
--
-- sensorA = Sensor()
-- sensorB = Sensor()
--
-- andGate = ANDGate()
-- orGate = ANDGate()
--
-- sensorA.output.connect(orGate.input.top)
-- sensorB.output.connect(orGate.input.bottom)
-- orGate.output.connect(andGate.input.top)
--
-- sensorA.fire()
-- sensorB.fire()
--
--]]

require('class')
require('math')

Lead = class()

function Lead:init(item, offsetX, offsetY, world, mouse)
  self.item = item
  self.offsetX = offsetX
  self.offsetY = offsetY
  self.hover = false

  mouse:register("update", function(mx,my)
    if self:intersects(mx, my) then
      self.hover = true
    else
      self.hover = false
    end
  end)
end

function Lead:intersects(mx,my)
  return mx < self:getX() + 4 and mx > self:getX() - 4 and
         my < self:getY() + 4 and my > self:getY() - 4
end

function Lead:getX()
  return self.item:getX() + self.offsetX
end

function Lead:getY()
  return self.item:getY() + self.offsetY
end

function Lead:draw()
  if self.hover then
    love.graphics.setColor(255,0,0)
  else
    love.graphics.setColor(255,255,255)
  end
  love.graphics.circle("fill", self:getX(), self:getY(), 4)
  love.graphics.setColor(0,0,0)
end

CircuitItem = class({ x = nil, y = nil, image = nil })

function CircuitItem:init(x, y, world, mouse)
  print(x,y,world,mouse, self.name)
  self:setX(x)
  self:setY(y)

  self.world = world
  self.mouse = mouse

  Draggable(self, mouse)
end

function CircuitItem:height()
  return self.image:getHeight()
end

function CircuitItem:width()
  return self.image:getWidth()
end

function CircuitItem:draw()
  love.graphics.draw(self.image, self:getX(), self:getY(), 0, 1, 1, 0, 0)
  for i, lead in pairs(self.leads) do
    lead:draw()
  end
end

function CircuitItem:intersects(x, y)
  -- should be the equation for this triangle
  return x > self:getX() and x < self:getX() + self:width() and
         y > self:getY() and y < self:getY() + self:height()
end

function CircuitItem:setX(x)
  if x < 80 then
    self.__x = 80 
  elseif x > world.width then
    self.__x = world.width
  else
    self.__x = x
  end
end

function CircuitItem:setY(y)
  if y < 0 then
    self.__y = 0
  elseif y > world.height then
    self.__y = world.height
  else
    self.__y = y
  end
end

function CircuitItem:getX()
  return math.max(self.__x, 80)
end

function CircuitItem:getY()
  return self.__y
end

ANDGate = class(CircuitItem)
ANDGate.mixin({ name      = "and"
              , image     = love.graphics.newImage('and.png')
              , direction = { 1, 0 }
              })
function ANDGate:init(x, y, world, mouse)
  CircuitItem.init(self, x, y, world, mouse)

  self.leads = { output      = Lead.new(self, self:width() - 4, self:height() / 2, world, mouse) 
               , inputTop    = Lead.new(self, 4, 4, world, mouse)
               , inputBottom = Lead.new(self, 4, self:height() - 4, world, mouse)
               }
end

XORGate = class(CircuitItem)
XORGate.mixin({ name      = "xor"
              , image     = love.graphics.newImage('xor.png')
              , direction = { 1, 0 }
              })
function XORGate:init(x,y,world,mouse)
  CircuitItem.init(self, x, y, world, mouse)

  self.leads = { output      = Lead.new(self, self:width() - 4, self:height() / 2, world, mouse) 
               , inputTop    = Lead.new(self, 4, 4, world, mouse)
               , inputBottom = Lead.new(self, 4, self:height() - 4, world, mouse)
               }
end

ORGate = class(CircuitItem)
ORGate.mixin({ name      = "or"
             , image     = love.graphics.newImage('or.png')
             , direction = { 1, 0 }
             })

function ORGate:init(x, y, world, mouse)
  CircuitItem.init(self, x, y, world, mouse)

  self.leads = { output      = Lead.new(self, self:width() - 4, self:height() / 2, world, mouse) 
               , inputTop    = Lead.new(self, 4, 4, world, mouse)
               , inputBottom = Lead.new(self, 4, self:height() - 4, world, mouse)
               }
end

NOTGate = class(CircuitItem)
SPLITGate = class(CircuitItem)
FLIPFLOPGate = class(CircuitItem)
