Bird = Class{}

function overlaps(xmin, ymin, xmax, ymax, amin, bmin, amax, bmax, leeway)
    leeway = leeway or 0
    return not (xmin + leeway > amax 
        or ymin + leeway > bmax 
        or xmax < amin + leeway 
        or ymax < bmin + leeway)
end

function Bird:init()
    -- load bird image from disk and assign its width and height
    self.image = love.graphics.newImage('pic/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- position bird in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

end

function Bird:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update()
    if love.keyboard.wasPressed('left') or love.keyboard.isDown('left') then
        sounds['jump']:play()
        self.x = self.x - 5
    elseif love.keyboard.wasPressed('right') or love.keyboard.isDown('right') then
        sounds['jump']:play()
        self.x = self.x + 5
    end
end

function Bird:collides(pipe)
    -- 2: leeway with the collision
    return overlaps(self.x, self.y, self.x + self.width, self.y + self.height,
        pipe.x, pipe.y, pipe.x + PIPE_WIDTH, pipe.y + PIPE_HEIGHT, 
        2)
end