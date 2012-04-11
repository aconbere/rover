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
--]]



CircuitItem = class({ __ids = 0 })

function CircuitItem.nextId()
  local n = CircuitItem.__ids
  CircuitItem.__ids = CircuitItem.__ids + 1
  return n
end

function CircuitItem:init(edges)
  self.id = CircuitItem.nextId()
end

ANDGate = class(CircuitItem)
XORGate = class(CircuitItem)
ORGate = class(CircuitItem)
NOTGate = class(CircuitItem)
SPLITGate = class(CircuitItem)
FLIPFLOPGate = class(CircuitItem)

Circuit = class()
Circuit.__item_id = 0

function Circuit:nextId()
  local n = self.__item_id
  self._item_id = self._item_id + 1
  return n
end

function Circuit:init() end
function Circuit:insert(item)

end
function Circuit:remove() end

function Circuit:register(name, sensor)
  self.sensors[name] = sensor
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

function Sensor:signal(object)
  if self.signal_type then
    if self.signal_type == object.__type then
      self:fire()
    end
  end
end

function Sensor:fire()
  cb()
end

