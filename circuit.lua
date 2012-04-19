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
require('drawable')

Lead = class(Drawable)

function Lead:init(circuitItem)
  self.input = circuitItem
  self.output = nil
end

function Lead:connect(circuitItem)
  self.output = circuitItem
end

function Lead:trigger()
  self.output:trigger()
end

function Lead:draw(x,y)
  love.graphics.circle()
end

CircuitItem = class(Drawable)

function CircuitItem:intersects(x, y)
  return x > self.x and x < self.x + self:width() - 5 and
         y > self.y + 5 and y < self.y + self:height() - 5
end

function CircuitItem.init(o, x, y, mouse)
  o.x = x
  o.y = y
  o.__offsetX = 0
  o.__offsetY = 0
  o.__active = false
  o.mouse = mouse

  o.mouse:register("mousepressed", function (mx, my, button)
    if button == "l" then
      if o:intersects(mx, my) then
        o.__active = true
        o.__offsetX = mx - o.x
        o.__offsetY = my - o.y
      end
    end
  end)

  o.mouse:register("mousereleased", function (mx, my, button)
    if button == "l" then
      if o.__active then
        o.__active = false
        o.__offsetX = 0
        o.__offsetY = 0
      end
    end
  end)

  o.mouse:register("update", function (mx, my)
    if o.__active then
      o.x = mx - o.__offsetX
      o.y = my - o.__offsetY
    end
  end)
end

ANDGate = class(CircuitItem)
ANDGate.mixin({ name = "and",
                image = love.graphics.newImage('and.png'),
                direction = { 1, 0 },
              })
function ANDGate:init(x, y, mouse)
  CircuitItem.init(self, x, y, mouse)

  Drawable.register(self)

  self.output = { Lead.new(self) }
  self.input = { top = Lead.new(self), bottom = Lead.new(self) }
end

XORGate = class(CircuitItem)
XORGate.mixin({ name = "xor",
                image = love.graphics.newImage('xor.png'),
                direction = { 1, 0 },
              })
function XORGate:init(x,y,mouse)
  CircuitItem.init(self, x, y, mouse)

  Drawable.register(self)
  self.output = { Lead.new(self) }
  self.input = { top = Lead.new(self), bottom = Lead.new(self) }
end

ORGate = class(CircuitItem)
ORGate.mixin({ name = "or",
               image = love.graphics.newImage('or.png'),
               direction = { 1, 0 },
              })
function ORGate:init(x, y, mouse)
  CircuitItem.init(self, x, y, mouse)

  Drawable.register(self)

  self.output = { Lead.new(self) }
  self.input = { top = Lead.new(self), bottom = Lead.new(self) }
end

NOTGate = class(CircuitItem)
function NOTGate:init()
  self.output = { Lead.new(self) }
  self.input = { Lead.new(self) }
end

SPLITGate = class(CircuitItem)
function SPLITGate:init()
  self.output = { top = Lead.new(self), bottom = Lead.new(self) }
  self.input = { Lead.new(self) }
end

FLIPFLOPGate = class(CircuitItem)
function FLIPFLOPGate:init()
  self.output = { top = Lead.new(self), bottom = Lead.new(self) }
  self.input = { top = Lead.new(self), bottom = Lead.new(self) }
end

Thruster = class()

function Thruster:init(on)
  self.on = on
end

Sensor = class()

function Sensor:init(t, cb)
  self.cb = cb
  self.signal_type = t
end

function Sensor:trigger(object)
  if self.signal_type then
    if self.signal_type == object.__type then
      self:fire()
    end
  end
end

function Sensor:fire()
  cb()
end

