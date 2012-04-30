function map (t, f)
  local results = {}
  for i, v in ipairs(t) do
    results[i] = f(v)
  end
  return results
end

function filter (t, f)
  local results = {}
  for i, v in ipairs(t) do
    if f(v) then
      table.insert(results, v)
    end
  end
  return results
end

function reduce (t, f, d)
  local result = d

  for i, v in ipairs(t) do
    result = f(result, v)
  end
  return result
end
