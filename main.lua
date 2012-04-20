require('world')
require('draggable')
require('robot')
require('circuit')
require('toolbar')
require('events')

function love.load()
  local height = love.graphics.getHeight()
  local width = love.graphics.getWidth()

  world = World.new(width, height)
  mouse = Listener.new()

  print(world, mouse)

  toolbar = world:addObject(Toolbar.circuitDesign(world, mouse))

  andGate = world:addObject(ANDGate.new(20, 20, world, mouse))
  orGate  = world:addObject(ORGate.new(40, 40, world, mouse))
  xorGate = world:addObject(XORGate.new(60, 60, world, mouse))
end

function love.keypressed(k)
  if k == 'escape' then
    love.event.push('q')
  end
end

function love.update(dt)
  mouse:trigger("update", love.mouse.getX(), love.mouse.getY())
  --Draggable.update(love.mouse.getX(), love.mouse.getY())

  --robot:move(dt)
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

function love.mousepressed(x,y,button)
  mouse:trigger("mousepressed", x,y, button)
end

function love.mousereleased(x,y,button)
  mouse:trigger("mousereleased", x,y, button)
end

function love.draw()
  world:draw()
  love.graphics.print('ROVER', world:center())
  local image = love.graphics.newImage('or.png')
  local x = 300
  local y = 300
  love.graphics.draw(image, x, y)
  love.graphics.setColor(255,255,255)
  love.graphics.circle("fill", x + 4, y + 4, 4)
  love.graphics.circle("fill", x + 4, y + image:getHeight() - 4, 4)
  love.graphics.circle("fill", x + image:getWidth() - 4, y + (image:getHeight()/2), 4)
  love.graphics.setColor(0,0,0)
end
