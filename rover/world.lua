local class = require('rover/class')

local World = class()

function World:init(width, height)
  self.width = width
  self.height = height
  self.objects = {}
  self._id = 0
end

function World:addObject(o)
  local nextId = self._id + 1
  self.objects[nextId] = o
  o.id = nextId
  self._id = nextId
  --return nextId
  return o
end

function World:addObjectAbove(o1, o2)
  -- puts o2 above o1
  
  newTable = {}
  for i = 1, o1.id - 1 do
    table.insert(newTable, self.objects[i])
  end
  table.insert(newTable, o2)

  for i = o1.id, #self.objects do
    table.insert(newTable, self.objects[i])
  end
  self.objects = newTable
end

function World:center()
  return self.width / 2, self.height / 2
end

function World:draw()
  for i, o in pairs(self.objects) do
    if o then
      o:draw()
    end
  end
end

function World:intersects(mx, my)
  intersectors = {}
  for i, o in pairs(self.objects) do
    if o and o.intersects and o:intersects(mx, my) then
      table.insert(intersectors, o)
    end
  end
  return intersectors
end

function World:removeObject(id)
  self.objects[id] = nil
end

return World
