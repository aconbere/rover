require('robot')
require('world')

function love.load()
  local height = love.graphics.getHeight()
  local width = love.graphics.getWidth()

  world = World:new(width, height)

  local center_x, center_y = world:center()

  robot = Robot:new({ x = center_x,
                      y = center_y,
                      speed = 100,
                      image = love.graphics.newImage('hamster.png'),
                    })
end

function love.keypressed(k)
  if k == 'escape' then
    love.event.push('q')
  end
end

function love.update(dt)
  robot:move(dt)
  --[[
  if love.keyboard.isDown('right') then
    robot.thrusters.right.on = true
    robot.thrusters.left.on = false
  elseif love.keyboard.isDown('left') then
    robot.thrusters.right.on = false
    robot.thrusters.left.on = true
  end

  if love.keyboard.isDown('down') then
    robot.thrusters.down.on = true
    robot.thrusters.up.on = false
  elseif love.keyboard.isDown('up') then
    robot.thrusters.down.on = false
    robot.thrusters.up.on = true
  end
  ]]
end

function love.draw()
  love.graphics.print('ROVER', world:center())
  robot:draw()
end
