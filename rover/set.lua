local class = require("rover/class")

local Set = class()

function Set:init(t)
  for _, i in pairs(t) do
    self.set[i] = true
  end
end

function Set:add(a)
  self.set[a] = true
end

function Set:remove(a)
  self.set[a] = nil
end

function Set:includes(a)
  return self.set[a]
end

return Set
