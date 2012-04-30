class = require("rover/class")
Gate = require("rover/circuit/gate")
Lead = require("rover/circuit/lead")

SPLITGate = class(Gate)
SPLITGate.mixin({ type      = "split"
                , image     = love.graphics.newImage("rover/graphics/split.png")
                , direction = { 1, 0 }
                })
function SPLITGate:init(x, y, world, mouse)
  Gate.init(self, x, y, world, mouse)

  self.leads = { input        = Lead.new(self, 4, self:height() / 2, world, mouse)
               , outputTop    = Lead.new(self, self:width() - 4, 4, world, mouse)
               , outputBottom = Lead.new(self, self:width() - 4, self:height() - 4, world, mouse)
               }

  self:attachToWorld()
end

function SPLITGate:fire(id)
  assert(id)
  self.fired = true
  self.timeSince = 0
  self.leads.outputTop:fire(self.id)
  self.leads.outputBottom:fire(self.id)
end

function SPLITGate:state()
  if self.leads.input.fired then
    return "fired"
  end
end

return SPLITGate
