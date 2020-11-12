Pipe = Class{}

-- since we only want the image loaded once, not per instantation, define it externally
local PIPE_IMAGE = love.graphics.newImage('pic/pipe.png')

PIPE_HEIGHT = PIPE_IMAGE:getHeight() 
PIPE_WIDTH = PIPE_IMAGE:getWidth()

function Pipe:init(orientation, x)
    self.y = VIRTUAL_HEIGHT
    -- self.x = math.random(- VIRTUAL_WIDTH * 3 / 4, - VIRTUAL_WIDTH / 2)
    self.x = x
    self.orientation = orientation
end

function Pipe:render()
    -- love.graphics.draw( drawable, x, y, 
    --      orientation(radians), 
    --      sx, sy, <- scales
    --      ox, oy, <- origin shift
    --      kx, ky ) <- shear factors
    love.graphics.draw(PIPE_IMAGE, 
        (self.orientation == 'left' and self.x or self.x + PIPE_WIDTH), self.y,
        0,
        self.orientation == 'left' and 1 or -1, 1)
end