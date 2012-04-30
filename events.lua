local class = require('class')

local EventListener = class()

function EventListener:init()
  self.listeners = {}
end

function EventListener:trigger(name, ...)
  if self.listeners[name] then
    for i, callback in ipairs(self.listeners[name]) do
      if callback(...) == false then
        break
      end
    end
  end
end

function EventListener:register(event, callback)
  if not self.listeners[event] then
    self.listeners[event] = {}
  end

  table.insert(self.listeners[event], callback)
end

return EventListener
