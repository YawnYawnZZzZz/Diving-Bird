-- The TitleScreenState is the starting screen of the game, shown on startup. 
-- It should display "Press Enter" and also our highest score.

TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function TitleScreenState:draw()
    love.graphics.setFont(flappy_font)
    -- love.graphics.printf( text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky )
    love.graphics.printf('Diving Bird', 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(medium_font)
    love.graphics.printf('Press Enter', 0, 64, VIRTUAL_WIDTH, 'center')
end