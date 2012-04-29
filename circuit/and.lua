local class = require("class").class
local Gate  = require("circuit/gate")
local Lead  = require("circuit/lead")

local ANDGate = class(Gate)

ANDGate.mixin({ type      = "and"
              , image     = love.graphics.newImage('and.png')
              , direction = { 1, 0 }
              })
function ANDGate:init(x, y, world, mouse)
  Gate.init(self, x, y, world, mouse)

  self.leads = { output      = Lead.new(self, self:width() - 4, self:height() / 2, world, mouse)
               , inputTop    = Lead.new(self, 4, 4, world, mouse)
               , inputBottom = Lead.new(self, 4, self:height() - 4, world, mouse)
               }
  self:attachToWorld()
end

function ANDGate:state()
  if self.leads.inputTop.fired and self.leads.inputBottom.fired then
    return "fired"
  end
end

return ANDGate
