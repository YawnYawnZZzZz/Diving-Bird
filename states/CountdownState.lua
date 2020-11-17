CountdownState = Class{__includes = BaseState}

function CountdownState:init()
    self.count = 3
    self.timer = 0
end

function CountdownState:update(dt) 
    self.timer = self.timer + dt

    if self.timer > 1 then
        self.timer = self.timer % 1
        self.count = self.count - 1
    end

    if self.count == 0 then
        gStateMachine:change('play')
    end
end

function CountdownState:draw() 
    love.graphics.setFont(huge_font)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end