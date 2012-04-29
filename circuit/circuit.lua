module("circuit", package.seeall)

require('class')
require('math')

--[[
--
--  Gates have Leads which provide the connection points between Gates and Wires
--  Wires are the edges in the circuit graph.
--
--]]

SIGNAL_LIFE = 1

NOTGate = class(Gate)
FLIPFLOPGate = class(Gate)
