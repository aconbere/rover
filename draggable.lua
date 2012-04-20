function Draggable(o, mouse)
  o.__offsetX = 0
  o.__offsetY = 0
  o.__active = false

  mouse:register("mousepressed", function (mx, my, button)
    if button == "l" then
      if o:intersects(mx, my) then
        o.__active = true
        o.__offsetX = mx - o:getX()
        o.__offsetY = my - o:getY()
        return false
      end
    end
  end)

  mouse:register("mousereleased", function (mx, my, button)
    if button == "l" then
      if o.__active then
        o.__active = false
        o.__offsetX = 0
        o.__offsetY = 0
      end
    end
  end)

  mouse:register("update", function (mx, my)
    if o.__active then
      o:setX(mx - o.__offsetX)
      o:setY(my - o.__offsetY)
    end
  end)
end
