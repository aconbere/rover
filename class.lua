function class (base)
  local c = {}

  if base then
    c = base
  end

  local mt = { __index = c }

  function c.new(...)
    local o = {}
    setmetatable(o, mt)

    if o.init then
      o:init(...)
    end

    return o
  end

  return c
end

A = class()

function A:init(x, y)
  print(x,y)
  self.x = x
  self.y = y
end

function A:print()
  print(self.x, self.y)
end

function A.distance(a1, a2)
  return math.sqrt((a1.x - a2.x)^2 + (a1.y - a2.y)^2)
end

a = A.new(10, 20)
print(a.x, a.y)

a2 = A.new(5, 6)

print(A.distance(a, a2))

B = class(A)

b = B.new(1,2)
b:print()
