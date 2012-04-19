require('class')

Listener = class()

function Listener:init()
  self.listeners = {}
end

function Listener:trigger(name, ...)
  if self.listeners[name] then
    for i, callback in ipairs(self.listeners[name]) do
      callback(...)
    end
  end
end

function Listener:register(event, callback)
  if not self.listeners[event] then
    self.listeners[event] = {}
  end

  table.insert(self.listeners[event], callback)
end
