require('world')
require('drawable')
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

  toolbar = Toolbar.circuitDesign(world, mouse)
  andGate = ANDGate.new(20, 20, mouse)
  orGate  = ORGate.new(40, 40, mouse)
  xorGate = XORGate.new(60, 60, mouse)
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
  --toolbar:draw()
  Drawable.drawAll()
  x = love.graphics.print('ROVER', world:center())
  print(x:getWidth())
end
