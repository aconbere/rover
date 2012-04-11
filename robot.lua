require('class')

directions = { up = {0, -1},
               down = {0, 1},
               left = {-1, 0},
               right = {1, 0},
             }

Robot = class()

function Robot:init(arg)
  self.x = arg.x
  self.y = arg.y
  self.speed        = arg.speed
  self.image        = arg.image
  self.image_x      = self.image:getWidth()
  self.image_y      = self.image:getHeight()

  self.thrusters = { up    = Thruster:new(false),
                     down  = Thruster:new(false),
                     left  = Thruster:new(false),
                     right = Thruster:new(false),
                   }

  self.sensors = { up    = Sensor:new(),
                   down  = Sensor:new(),
                   left  = Sensor:new(),
                   right = Sensor:new(),
                   }
end

function Robot:image_center()
  return self.image_x / 2, self.image_y / 2
end

function Robot:direction()
  local direction = {0, 0}

  for dir, thruster in pairs(self.thrusters) do
    if thruster.on then
      v = directions[dir]
      direction[1] = direction[1] + v[1]
      direction[2] = direction[2] + v[2]
    end
  end

  return direction
end

function Robot:move(dt)
  v = self:direction()
  self.x = self.x + (v[1] * self.speed * dt)
  self.y = self.y + (v[2] * self.speed * dt)
end

function Robot:draw()
  love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self:image_center())
end
