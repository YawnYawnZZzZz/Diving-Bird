ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:draw()
    love.graphics.setFont(huge_font)
    -- love.graphics.printf( text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky )
    love.graphics.printf('Score ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(medium_font)
    love.graphics.printf('Press Enter to Play Again', 0, 64, VIRTUAL_WIDTH, 'center')
end
