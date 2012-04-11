require('class')

World = class()

function World:init(width, height)
  self.width = width
  self.height = height
end

function World:center()
  return self.width / 2, self.height / 2
end

