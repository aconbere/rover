require('class')
require('math')

--[[
--
--  Gates have Leads which provide the connection points between Gates and Wires
--  Wires are the edges in the circuit graph.
--
--]]

SIGNAL_LIFE = 1

Sensor = class()
function Sensor:init(x, y, world, mouse)
  self.x = x
  self.y = y
  self.world = world
  self.mouse = mouse
  self.fired = false
  self.timeSince = 0

  self.world:addObject(self)
  self.lead = world:addObject(Lead.new(self, 10, 10, world, mouse))
end

function Sensor:update(dt)
  self.timeSince = self.timeSince + dt
  self.lead:update(dt)

  if self.timeSince > 6 then
    self.lead:fire(self.id)
    self.fired = true
    self.timeSince = 0
  elseif self.timeSince > SIGNAL_LIFE then
    self.fired = nil
  end
end

function Sensor:getX()
  return self.x
end

function Sensor:getY()
  return self.y
end

function Sensor:draw()
  love.graphics.setColor(0, 0, 255)
  love.graphics.rectangle("fill", self:getX(), self:getY(), 20, 20)
  love.graphics.setColor(0, 0, 0)
end


Wire = class({ type = "wire" })
function Wire:init(lead, world, mouse, active)
  self.head = lead
  self.tail = nil

  self.world = world
  self.mouse = mouse
  self.active = active
  self.timeSince = 0

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

  if self.fired then
    love.graphics.setColor(255,0,0)
  else
    love.graphics.setColor(255, 255, 255)
  end

  if self.tail then
    love.graphics.line(self.head:getX(), self.head:getY(), self.tail:getX(), self.tail:getY())
  elseif self.active then
    love.graphics.line(self.head:getX(), self.head:getY(), self.offsetX, self.offsetY)
  end

  love.graphics.setColor(0,0,0)
end

function Wire:update(dt)
  self.timeSince = self.timeSince + dt
  if self.fired and self.timeSince > SIGNAL_LIFE then
    self.fired = nil
  end
end

function Wire:fire(id)
  assert(id)
  self.fired = true
  self.timeSince = 0
  if self.head and self.head.id ~= id then
    self.head:fire(self.id)
  elseif self.tail and self.tail.id ~= id then
    self.tail:fire(self.id)
  end
end

Lead = class({ type = "lead" })

function Lead:fire(id)
  assert(id)
  self.fired = true
  self.timeSince = 0
  if self.wire and self.wire.id ~= id then
    self.wire:fire(self.id)
  end
end

function Lead:init(item, offsetX, offsetY, world, mouse)
  self.item = item
  self.offsetX = offsetX
  self.offsetY = offsetY
  self.hover = false
  self.active = false
  self.fired = nil
  self.timeSince = 0
  self.wire = nil

  mouse:register("mousepressed", function (mx, my, button)
    if not self.wire then
      if button == "l" then
        if self:intersects(mx, my) then
          self.active = true
          self.wire = world:addObject(Wire.new(self, world, mouse, true))
          return false
        end
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
      -- the world keeps a list of intersectable objects
      -- check it to see if we're dropping on a lead
      intersectors = world:intersects(mx, my)
      if intersectors then
        for i, inter in pairs(intersectors) do
          if inter.type == "lead" then
            connected = true
            self.wire.tail = inter
            inter.wire = self.wire
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

function Lead:update(dt)
  self.timeSince = self.timeSince + dt
  if self.fired and self.timeSince > SIGNAL_LIFE then
    self.fired = nil
  end

  if self.wire then
    self.wire:update(dt)
  end
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
  elseif self.fired then
    love.graphics.setColor(255,0,0)
  else
    love.graphics.setColor(255,255,255)
  end

  love.graphics.circle("fill", self:getX(), self:getY(), 4)
  love.graphics.setColor(0,0,0)
end

Gate = class({ x = nil, y = nil, image = nil })

function Gate:init(x, y, world, mouse)
  self:setX(x)
  self:setY(y)

  self.world = world
  self.mouse = mouse
  self.timeSince = 0

  Draggable(self, mouse)
end

function Gate:update(dt)
  self.timeSince = self.timeSince + dt

  if self.timeSince > SIGNAL_LIFE then
    self.fired = nil
    self.timeSince = 0
  end

  for _, lead in pairs(self.leads) do
    lead:update(dt)
  end
end

function Gate:fire(dt)
  self.timeSince = 0
  self.leads.output:fire(dt)
end

function Gate:height()
  return self.image:getHeight()
end

function Gate:width()
  return self.image:getWidth()
end

function Gate:draw()
  love.graphics.draw(self.image, self:getX(), self:getY(), 0, 1, 1, 0, 0)
end

function Gate:intersects(x, y)
  -- should be the equation for this triangle
  for i, lead in pairs(self.leads) do
    if lead:intersects(x,y) then
      return false
    end
  end
  return x > self:getX() and x < self:getX() + self:width() and
         y > self:getY() and y < self:getY() + self:height()
end

function Gate:setX(x)
  if x < 80 then
    self.__x = 80 
  elseif x > world.width then
    self.__x = world.width
  else
    self.__x = x
  end
end

function Gate:setY(y)
  if y < 0 then
    self.__y = 0
  elseif y > world.height then
    self.__y = world.height
  else
    self.__y = y
  end
end

function Gate:getX()
  return math.max(self.__x, 80)
end

function Gate:getY()
  return self.__y
end

function Gate:attachToWorld()
  self.world:addObject(self)
  for i, l in pairs(self.leads) do
    self.world:addObject(l)
  end
end

ANDGate = class(Gate)
ANDGate.mixin({ type      = "and"
              , image     = love.graphics.newImage('and.png')
              , direction = { 1, 0 }
              })
function ANDGate:init(x, y, world, mouse)
  Gate.init(self, x, y, world, mouse)

  self.leads = { output      = Lead.new(self, self:width() - 4, self:height() / 2, world, mouse)
               , inputTop    = Lead.new(self, 4, 4, world, mouse)
               , inputBottom = Lead.new(self, 4, self:height() - 4, world, mouse)
               }
  self:attachToWorld()
end

function ANDGate:state()
  if self.leads.inputTop.fired and self.leads.inputBottom.fired then
    return "fired"
  end
end

XORGate = class(Gate)
XORGate.mixin({ type      = "xor"
              , image     = love.graphics.newImage('xor.png')
              , direction = { 1, 0 }
              })
function XORGate:init(x,y,world,mouse)
  Gate.init(self, x, y, world, mouse)

  self.leads = { output      = Lead.new(self, self:width() - 4, self:height() / 2, world, mouse)
               , inputTop    = Lead.new(self, 4, 4, world, mouse)
               , inputBottom = Lead.new(self, 4, self:height() - 4, world, mouse)
               }

  self:attachToWorld()
end

function XORGate:state()
  if self.leads.inputTop.fired and not self.leads.inputBottom.fired then
    return "fired"
  elseif self.leads.inputBottom.fired and not self.leads.inputTop.fired then
    return "fired"
  end
end

ORGate = class(Gate)
ORGate.mixin({ type      = "or"
             , image     = love.graphics.newImage('or.png')
             , direction = { 1, 0 }
             })

function ORGate:init(x, y, world, mouse)
  Gate.init(self, x, y, world, mouse)

  self.leads = { output      = Lead.new(self, self:width() - 4, self:height() / 2, world, mouse)
               , inputTop    = Lead.new(self, 4, 4, world, mouse)
               , inputBottom = Lead.new(self, 4, self:height() - 4, world, mouse)
               }
  self:attachToWorld()
end

function ORGate:state()
  if self.leads.inputTop.fired or self.leads.inputBottom.fired then
    return "fired"
  end
end

NOTGate = class(Gate)

SPLITGate = class(Gate)
SPLITGate.mixin({ type      = "split"
                , image     = love.graphics.newImage("split.png")
                , direction = { 1, 0 }
                })
function SPLITGate:init(x, y, world, mouse)
  Gate.init(self, x, y, world, mouse)

  self.leads = { input        = Lead.new(self, 4, self:height() / 2, world, mouse)
               , outputTop    = Lead.new(self, self:width() - 4, 4, world, mouse)
               , outputBottom = Lead.new(self, self:width() - 4, self:height() - 4, world, mouse)
               }

  self:attachToWorld()
end

function SPLITGate:fire(id)
  assert(id)
  self.fired = true
  self.timeSince = 0
  self.leads.outputTop:fire(self.id)
  self.leads.outputBottom:fire(self.id)
end

function SPLITGate:state()
  if self.leads.input.fired then
    return "fired"
  end
end


FLIPFLOPGate = class(Gate)
