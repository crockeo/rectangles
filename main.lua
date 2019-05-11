-- Clamps a value between two ranges.
function math.clamp(value, lower, upper)
  if value < lower then
    return lower
  elseif value > upper then
    return upper
  else
    return value
  end
end

-- Converts an HSV value (0-360, 0.0-1.0, 0.0-1.0) to an RGB value (0.0-1.0, 0.0-1.0, 0.0-1.0).
function hsv_to_rgb(h, s, v)
  local c = v * s
  local x = c * (1 - math.abs(((h / 60.0) % 2) - 1))
  local m = v - c

  local r, g, b = 0, 0,  0

  if       0 <= h and h <=  60 then r, g, b = c, x, 0
  elseif  60 <= h and h <= 120 then r, g, b = x, c, 0
  elseif 120 <= h and h <= 180 then r, g, b = 0, c, x
  elseif 180 <= h and h <= 240 then r, g, b = 0, x, c
  elseif 240 <= h and h <= 300 then r, g, b = x, 0, c
  elseif 300 <= h and h <= 360 then r, g, b = c, 0, x
  end

  return (r + m), (g + m), (b + m)
end

local width, height
local center_x, center_y

local rectangle_count
local rectangles
local angle_diff

local hue_diff
local s
local v

-- Initializing game state.
function love.load()
  width, height = love.graphics.getDimensions()
  love.window.setMode(width, height, {msaa = 4})

  center_x, center_y = width / 2, height / 2

  rectangle_count = 15
  rectangles = {}
  for i = 0, rectangle_count do
    rectangles[i] = 0
  end

  angle_diff = math.pi / 4

  hue_diff = 0
  s = 0.65
  v = 0.85
end

-- Drawing the rectangles!
function love.draw()

  hue = 0.0
  size = height * 4
  for i = 0, rectangle_count do
    love.graphics.translate(center_x, center_y)
    love.graphics.rotate(rectangles[i])
    if i % 2 == 1 then
      love.graphics.rotate(math.pi / 4)
    end

      r, g, b = hsv_to_rgb(hue, s, v)
      love.graphics.setColor(r, g, b)
      love.graphics.rectangle(
      "fill",
      -size / 2,
      -size / 2,
      size,
      size
    )

    hue = hue + hue_diff
    hue = hue % 360
    size = size / math.sqrt(2)

    love.graphics.origin()
  end
end

-- Reusable template for changing the value of some thing based on user input.
function change(value, delta, minus, plus, min, max, dt)
  local dvalue = 0
  if love.keyboard.isDown(minus) then
    dvalue = dvalue - delta
  end

  if love.keyboard.isDown(plus) then
    dvalue = dvalue + delta
  end

  return math.clamp(value + dvalue * dt, min, max)
end

-- Updating the angle of each rectangle, depending on which one they are.
function love.update(dt)
  for i = 0, rectangle_count do
    rectangles[i] = rectangles[i] + (math.pi / 2) * dt * (i / rectangle_count)
    rectangles[i] = rectangles[i] % (math.pi / 2)
  end

  hue_diff = hue_diff + 12 * dt
  hue_diff = hue_diff % 360

  hue_diff = change(hue_diff, 50, "q", "w", 0, 360, dt)
  s = change(s, 0.5, "a", "s", 0, 1, dt)
  v = change(v, 0.5, "z", "x", 0, 1, dt)

  if love.keyboard.isDown("e") then
    print(hue_diff, s, v)
  end
end
