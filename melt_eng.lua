-- melt_eng.lua

local function auto_segmentation(menu)
  local segments = {}
  local start = 1
  local i = 1
  while i <= #menu.candies do
    local candy = menu.candies[i]
    local len = utf8.len(candy.text)
    if len == 1 then
      if start < i then
        table.insert(segments, menu.candies[start:i-1])
      end
      table.insert(segments, candy)
      start = i + 1
    end
    i = i + 1
  end
  if start <= #menu.candies then
    table.insert(segments, menu.candies[start:])
  end
  return segments
end

local function translator_func(input, seg)
  if not seg.type then
    seg.type = "sentence"
  end
  local menu = seg:get_menu()
  local segments = auto_segmentation(menu)
  seg.select_start = 0
  seg.select_end = #segments
  for i, s in ipairs(segments) do
    s.type = "word"
    menu:push_back(s)
  end
  return segments
end

return {
  init = function(env)
    env.engine.translators["2free_eng_index"] = translator_func
  end
}