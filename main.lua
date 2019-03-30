local angle = 0

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

function love.draw()
  width, height = love.graphics.getDimensions()
  center_x = width / 2
  center_y = height / 2

  love.graphics.translate(center_x, center_y)

  hue = 0.0
  size = height * 4
  love.graphics.rotate(angle)
  for i = 0,15 do
    r, g, b = hsv_to_rgb(hue, 0.7, 1)

    love.graphics.setColor(r, g, b)
    love.graphics.rectangle(
      "fill",
      -size / 2,
      -size / 2,
      size,
      size
    )

    hue = hue + 45
    hue = hue % 360
    size = size / math.sqrt(2)
    love.graphics.rotate(math.pi / 4)
  end
end

function love.update(dt)
  angle = angle + (math.pi / 4) * dt
  angle = angle % (math.pi / 2)
end
