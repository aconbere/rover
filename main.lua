local World         = require('rover/world')
local Robot         = require('rover/robot')
local Toolbar       = require('rover/toolbar')
local Sensor        = require('rover/circuit/sensor')
local ANDGate       = require('rover/circuit/and')
local ORGate        = require('rover/circuit/or')
local XORGate       = require('rover/circuit/xor')
local SPLITGate     = require('rover/circuit/split')
local EventListener = require('rover/events')

Rover = { world   = nil
        , mouse   = nil
        , toolbar = nil
        , sensors = {}
        , gates   = {}
        }

function love.load()
  local height = love.graphics.getHeight()
  local width = love.graphics.getWidth()

  Rover.world = World.new(width, height)
  Rover.mouse = EventListener.new()

  Rover.sensors = { Sensor.new(80,180, Rover.world, Rover.mouse)
                  , Sensor.new(80,80, Rover.world, Rover.mouse)
                  }

  Rover.toolbar = Rover.world:addObject(Toolbar.circuitDesign(Rover.world, Rover.mouse))

  Rover.gates = { ANDGate.new(120, 20, Rover.world, Rover.mouse)
                , ORGate.new(140, 60, Rover.world, Rover.mouse)
                , XORGate.new(160, 100, Rover.world, Rover.mouse)
                , SPLITGate.new(200, 100, Rover.world, Rover.mouse)
                }
end

function love.keypressed(k)
  if k == 'escape' then
    love.event.push('q')
  end
end

function love.update(dt)
  Rover.mouse:trigger("update", love.mouse.getX(), love.mouse.getY())
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
  Rover.mouse:trigger("mousepressed", x,y, button)
end

function love.mousereleased(x,y,button)
  Rover.mouse:trigger("mousereleased", x,y, button)
end

function simulate(dt)
  for i, gate in ipairs(Rover.gates) do
    gate:update(dt)
  end

  for i, sensor in ipairs(Rover.sensors) do
    sensor:update(dt)
  end

  for i, gate in ipairs(Rover.gates) do
    if gate:state() == "fired" then
      gate:fire(dt)
    end
  end
end

function love.draw()
  Rover.world:draw()
  love.graphics.print('ROVER', Rover.world:center())
  love.graphics.setColor(0,0,0)
end
