require('class')

Draggable = class({ diffX = nil, diffY = nil, active = false})
Draggable.__items__ = {}
Draggable.__active__ = nil
Draggable.__offset__ = { x = 0, y = 0}

function Draggable.register(i)
  table.insert(Draggable.__items__, i)
end

function Draggable.mousepressed(x, y, button)
  if button == "l" then
    print(x,y)
    for i, d in ipairs(Draggable.__items__) do
      if d:intersects(x,y) then
        Draggable.__active__ = d
        Draggable.__offset__.x = x - d.x
        Draggable.__offset__.y = y - d.y
        break
      end
    end
  end
end

function Draggable.update(x, y)
  a = Draggable.__active__
  if a then
    a.x = x - Draggable.__offset__.x
    a.y = y - Draggable.__offset__.y
  end
end

function Draggable.mousereleased(x, y, button)
  if button == "l" then
    Draggable.__active__ = nil
    Draggable.__offset__.x = 0
    Draggable.__offset__.y = 0
  end
end
