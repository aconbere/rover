local class = require("class")
local config = require("config")
local Wire = require("circuit/wire")

local Lead = class({ type = "lead" })

function Lead:fire(id)
  assert(id)
  self.fired = true
  self.timeSince = 0
  if self.wire and self.wire.id ~= id then
    self.wire:fire(self.id)
  end
end

function Lead:init(item, offsetX, offsetY, world, mouse)
  self.item = item
  self.offsetX = offsetX
  self.offsetY = offsetY
  self.hover = false
  self.active = false
  self.fired = nil
  self.timeSince = 0
  self.wire = nil

  mouse:register("mousepressed", function (mx, my, button)
    if not self.wire then
      if button == "l" then
        if self:intersects(mx, my) then
          self.active = true
          self.wire = world:addObject(Wire.new(self, world, mouse, true))
          return false
        end
      end
    end
  end)

  mouse:register("update", function(mx,my)
    if self:intersects(mx, my) then
      self.hover = true
    else
      self.hover = false
    end
  end)

  mouse:register("mousereleased", function (mx, my, button)
    connected = false
    if button == "l" and self.active and self.wire then
      -- the world keeps a list of intersectable objects
      -- check it to see if we're dropping on a lead
      intersectors = world:intersects(mx, my)
      if intersectors then
        for i, inter in pairs(intersectors) do
          if inter.type == "lead" then
            connected = true
            self.wire.tail = inter
            inter.wire = self.wire
            break
          end
        end
      end
      if not connected then
        world:removeObject(self.wire.id)
        self.wire = nil
      end 
      self.active = false
    end
  end)
end

function Lead:update(dt)
  self.timeSince = self.timeSince + dt
  if self.fired and self.timeSince > config.SIGNAL_LIFE then
    self.fired = nil
  end

  if self.wire then
    self.wire:update(dt)
  end
end

function Lead:intersects(mx,my)
  return mx < self:getX() + 4 and mx > self:getX() - 4 and
         my < self:getY() + 4 and my > self:getY() - 4
end

function Lead:connect(wire)
  wire.tail = self
end

function Lead:getX()
  return self.item:getX() + self.offsetX
end

function Lead:getY()
  return self.item:getY() + self.offsetY
end

function Lead:draw()
  if self.hover then
    love.graphics.setColor(255,0,0)
  elseif self.fired then
    love.graphics.setColor(255,0,0)
  else
    love.graphics.setColor(255,255,255)
  end

  love.graphics.circle("fill", self:getX(), self:getY(), 4)
  love.graphics.setColor(0,0,0)
end

return Lead
