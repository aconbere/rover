require('class')

World = class()

function World:init(width, height)
  self.width = width
  self.height = height
  self.objects = {}
end

function World:addObject(o)
  table.insert(self.objects, o)
  return o
end

function World:center()
  return self.width / 2, self.height / 2
end

function World:draw()
  for i, o in ipairs(self.objects) do
    o:draw()
  end
end

