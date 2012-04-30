local World = require('world')
local Robot = require('robot')

require('draggable')

local EventListener = require('events')
local Toolbar = require('toolbar')
local Sensor = require('circuit/sensor')
local ANDGate = require('circuit/and')
local ORGate = require('circuit/or')
local XORGate = require('circuit/xor')
local SPLITGate = require('circuit/split')

function love.load()
  local height = love.graphics.getHeight()
  local width = love.graphics.getWidth()

  world = World.new(width, height)
  mouse = EventListener.new()

  sensors = { Sensor.new(80,180, world, mouse)
            , Sensor.new(80,80, world, mouse)
            }

  toolbar = world:addObject(Toolbar.circuitDesign(world, mouse))

  gates = { ANDGate.new(120, 20, world, mouse)
          , ORGate.new(140, 60, world, mouse)
          , XORGate.new(160, 100, world, mouse)
          , SPLITGate.new(200, 100, world, mouse)
          }
end

function love.keypressed(k)
  if k == 'escape' then
    love.event.push('q')
  end
end

function love.update(dt)
  mouse:trigger("update", love.mouse.getX(), love.mouse.getY())
  simulate(dt)
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

function simulate(dt)
  -- fake sensor fires in our simulation
  for i, gate in ipairs(gates) do
    gate:update(dt)
  end

  for i, sensor in ipairs(sensors) do
    sensor:update(dt)
  end

  for i, gate in ipairs(gates) do
    if gate:state() == "fired" then
      gate:fire(dt)
    end
  end
end

function love.draw()
  world:draw()
  love.graphics.print('ROVER', world:center())
  love.graphics.setColor(0,0,0)
end
