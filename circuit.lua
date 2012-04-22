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

Wire = class({ type = "wire" })
function Wire:init(lead, world, mouse, active)
  self.head = lead
  self.tail = nil

  self.world = world
  self.mouse = mouse
  self.active = active

  self.offsetX = 0
  self.offsetY = 0

  mouse:register("update", function (mx, my)
    if self.active then
      self.offsetX = mx
      self.offsetY = my
    end
  end)

  mouse:register("mousereleased", function (mx, my, button)
    if button == "l" then
      if self.active then
        self.active = false
        self.offsetX = 0
        self.offsetY = 0
      end
    end
  end)
end

function Wire:draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.setLineStyle("smooth")
  love.graphics.setLineWidth(2)

  if self.tail then
    love.graphics.line(self.head:getX(), self.head:getY(), self.tail:getX(), self.tail:getY())
  elseif self.active then
    love.graphics.line(self.head:getX(), self.head:getY(), self.offsetX, self.offsetY)
  end

  love.graphics.setColor(0,0,0)
end

Lead = class({ type = "lead" })

function Lead:init(item, offsetX, offsetY, world, mouse)
  self.item = item
  self.offsetX = offsetX
  self.offsetY = offsetY
  self.hover = false
  self.active = true
  self.wire = nil

  mouse:register("mousepressed", function (mx, my, button)
    if button == "l" then
      if self:intersects(mx, my) then
        self.active = true
        self.wire = world:addObject(Wire.new(self, world, mouse, true))
        return false
      end
    end
  end)

  mouse:register("update", function(mx,my)
    if self:intersects(mx, my) then
      self.hover = true
    else
      self.hover = false
    end
  end)

  mouse:register("mousereleased", function (mx, my, button)
    connected = false
    if button == "l" and self.active and self.wire then
      intersectors = world:intersects(mx, my)
      if intersectors then
        for i, inter in pairs(intersectors) do
          if inter.type == "lead" then
            connected = true
            self.wire.tail = inter
            break
          end
        end
      end
      if not connected then
        world:removeObject(self.wire.id)
        self.wire = nil
      end 
      self.active = false
    end
  end)
end

function Lead:intersects(mx,my)
  return mx < self:getX() + 4 and mx > self:getX() - 4 and
         my < self:getY() + 4 and my > self:getY() - 4
end

function Lead:connect(wire)
  wire.tail = self
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
end

function CircuitItem:intersects(x, y)
  -- should be the equation for this triangle
  for i, lead in pairs(self.leads) do
    if lead:intersects(x,y) then
      return false
    end
  end
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

function CircuitItem:attachToWorld()
  self.world:addObject(self)
  for i, l in pairs(self.leads) do
    self.world:addObject(l)
  end
end

ANDGate = class(CircuitItem)
ANDGate.mixin({ type      = "and"
              , image     = love.graphics.newImage('and.png')
              , direction = { 1, 0 }
              })
function ANDGate:init(x, y, world, mouse)
  CircuitItem.init(self, x, y, world, mouse)

  self.leads = { output      = Lead.new(self, self:width() - 4, self:height() / 2, world, mouse)
               , inputTop    = Lead.new(self, 4, 4, world, mouse)
               , inputBottom = Lead.new(self, 4, self:height() - 4, world, mouse)
               }
  self:attachToWorld()
end

XORGate = class(CircuitItem)
XORGate.mixin({ type      = "xor"
              , image     = love.graphics.newImage('xor.png')
              , direction = { 1, 0 }
              })
function XORGate:init(x,y,world,mouse)
  CircuitItem.init(self, x, y, world, mouse)

  self.leads = { output      = Lead.new(self, self:width() - 4, self:height() / 2, world, mouse)
               , inputTop    = Lead.new(self, 4, 4, world, mouse)
               , inputBottom = Lead.new(self, 4, self:height() - 4, world, mouse)
               }
  self:attachToWorld()
end

ORGate = class(CircuitItem)
ORGate.mixin({ type      = "or"
             , image     = love.graphics.newImage('or.png')
             , direction = { 1, 0 }
             })

function ORGate:init(x, y, world, mouse)
  CircuitItem.init(self, x, y, world, mouse)

  self.leads = { output      = Lead.new(self, self:width() - 4, self:height() / 2, world, mouse)
               , inputTop    = Lead.new(self, 4, 4, world, mouse)
               , inputBottom = Lead.new(self, 4, self:height() - 4, world, mouse)
               }
  self:attachToWorld()
end

NOTGate = class(CircuitItem)
SPLITGate = class(CircuitItem)
FLIPFLOPGate = class(CircuitItem)
