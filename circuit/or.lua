local class = require("class")
local Gate = require("circuit/gate")

local ORGate = class(Gate)
ORGate.mixin({ type      = "or"
             , image     = love.graphics.newImage('or.png')
             , direction = { 1, 0 }
             })

function ORGate:init(x, y, world, mouse)
  Gate.init(self, x, y, world, mouse)

  self.leads = { output      = Lead.new(self, self:width() - 4, self:height() / 2, world, mouse)
               , inputTop    = Lead.new(self, 4, 4, world, mouse)
               , inputBottom = Lead.new(self, 4, self:height() - 4, world, mouse)
               }
  self:attachToWorld()
end

function ORGate:state()
  if self.leads.inputTop.fired or self.leads.inputBottom.fired then
    return "fired"
  end
end

return ORGate
