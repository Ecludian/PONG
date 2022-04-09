-- Ball Class --

Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- these variable are for keeping track of our ball velocity
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)
end

function Ball:reset()
    self.x = V_WIDTH/2 -2
    self.y = V_HEIGHT/2 - 2
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)
end

-- applies velocity to position, scaled by deltaTime.
function Ball:update(dt)
self.x = self.x + self.dx * dt
self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Ball:collide(paddle)
    -- check to see if left edge of either box is farther to the right
    -- than the right of other
if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
    return false 
end

-- check to see if the bottom edge of either box is higher than the top 
-- edege of the other
if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
    return false
end

-- if the above aren't true,  they're overlapping
return true
end