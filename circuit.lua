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
require('draggable')

Lead = class()
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

CircuitItem = class(Drawable)
CircuitItem.mixin(Draggable)

function CircuitItem:intersects(x, y)
  return x > self.x and x < self.x + self:width() - 5 and
         y > self.y + 5 and y < self.y + self:height() - 5
end

ANDGate = class(CircuitItem)
ANDGate.mixin({ name = "and",
                image = love.graphics.newImage('and.png')
              })
function ANDGate:init(args)
  Drawable.register(self)
  Draggable.register(self)

  self.x = args.x
  self.y = args.y

  self.output = { Lead.new(self) }
  self.input = { top = Lead.new(self), bottom = Lead.new(self) }
end

XORGate = class(CircuitItem)
XORGate.mixin({ name = "xor",
                image = love.graphics.newImage('xor.png')
              })
function XORGate:init(args)
  Drawable.register(self)
  Draggable.register(self)
  self.x = args.x
  self.y = args.y
  self.output = { Lead.new(self) }
  self.input = { top = Lead.new(self), bottom = Lead.new(self) }
end

ORGate = class(CircuitItem)
ORGate.mixin({ name = "or",
               image = love.graphics.newImage('or.png')
              })
function ORGate:init(args)
  Drawable.register(self)
  Draggable.register(self)

  self.x = args.x
  self.y = args.y

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

