require('class')

Drawable = class({ x = nil, y = nil, image = nil })
Drawable.__items__ = {}

function Drawable.drawAll()
  for _, d in ipairs(Drawable.__items__) do
    d:draw()
  end
end

function Drawable.register(i)
  table.insert(Drawable.__items__, i)
end

function Drawable:draw()
  image_x = self.image:getWidth()
  image_y = self.image:getHeight()
  love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, image_x, image_y)
end

function Drawable:height()
  return self.image:getHeight()
end

function Drawable:width()
  return self.image:getWidth()
end
