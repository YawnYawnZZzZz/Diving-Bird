PipePair = Class{}

GAP_WIDTH = 50
local PIPE_SCROLL = -60

function PipePair:init(x)
    -- initialize pipes past the bottom of the screen
    self.y = VIRTUAL_HEIGHT + 32
    self.x = x

    self.pipes = {
        ['left'] = Pipe('left', self.x),
        -- ['right'] = Pipe('left', self.x)
        ['right'] = Pipe('right', self.x + PIPE_WIDTH + GAP_WIDTH)
    }

    -- whether this pair is ready to be removed from the scene 
    self.remove = false
end

function PipePair:update(dt)
    if self.y > -288 then
        self.y = self.y + PIPE_SCROLL * dt
        self.pipes['left'].y = self.y
        self.pipes['right'].y = self.y
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end

