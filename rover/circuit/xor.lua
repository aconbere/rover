local class = require("rover/class")
local Gate = require("rover/circuit/gate")
local Lead = require("rover/circuit/lead")

XORGate = class(Gate)
XORGate.mixin({ type      = "xor"
              , image     = love.graphics.newImage('rover/graphics/xor.png')
              , direction = { 1, 0 }
              })

function XORGate:init(x,y,world,mouse)
  Gate.init(self, x, y, world, mouse)

  self.leads = { output      = Lead.new(self, self:width() - 4, self:height() / 2, world, mouse)
               , inputTop    = Lead.new(self, 4, 4, world, mouse)
               , inputBottom = Lead.new(self, 4, self:height() - 4, world, mouse)
               }

  self:attachToWorld()
end

function XORGate:state()
  if self.leads.inputTop.fired and not self.leads.inputBottom.fired then
    return "fired"
  elseif self.leads.inputBottom.fired and not self.leads.inputTop.fired then
    return "fired"
  end
end

return XORGate
