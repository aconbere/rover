local class = require("rover/class")
local Set = require("rover/set")

local Graph = class()

function Graph:init()
  self.edges = {}
end

function Graph:add_edge(a, b)
  if not self.edges[a] then
    self.edges[a] = Set()
  end
  self.edges[a].add(b)
end

function Graph:remove_edge(a, b)
  if self.edges[a] then
    self.edges[a].remove(b)
  end
end

function Graph:walk(start, f, visited)
  -- impliments a depth first search calling f on each n

  local visited = visited or Set()

  if not self.edges[start] or visited.includes(start) then
    return nil
  else
    f(start)
    visited.add(start)
  end

  for e, _ in pairs(self.edges[n]) do
    self.walk(e, f, visited)
  end
end
