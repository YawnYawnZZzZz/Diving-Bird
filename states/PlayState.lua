-- The PlayState class is the bulk of the game, where the player actually controls the bird and
-- avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
-- we then go back to the main menu.

PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 288
PIPE_HEIGHT = 70

BIRD_WIDTH = 24
BIRD_HEIGHT = 38

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.spawnTimer = 0
    self.score = 0

    self.lastX = -PIPE_WIDTH + VIRTUAL_WIDTH / 2 + GAP_WIDTH / 2 + math.random(10)
end

function PlayState:update(dt)
    -- spawn a new Pipe if the time is past 2 seconds
    self.spawnTimer = self.spawnTimer + dt
    if self.spawnTimer > 2 then
        local x = math.max(20-PIPE_WIDTH, math.min(self.lastX + math.random(-20, 20), VIRTUAL_WIDTH - GAP_WIDTH - 20 - PIPE_WIDTH))
        self.lastX = x

        table.insert(self.pipePairs, PipePair(x))
        self.spawnTimer = 0
    end

    self.bird:update(dt)

    -- detect if bird touches sky or ground
    if self.bird.x < 15 or self.bird.x + self.bird.width > VIRTUAL_WIDTH then
        sounds['explosion']:play()
        sounds['hurt']:play()
        gStateMachine:change('score', {
            score = self.score
        })
    end

    -- for every pipe in the scene...
    for k, pair in pairs(self.pipePairs) do
        pair:update(dt)

        if not pair.scored and pair.y + PIPE_HEIGHT < self.bird.y then
            self.score = self.score + 1
            sounds['score']:play()
            pair.scored = true
        end
    end

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end
end

function PlayState:draw()
    for k, pair in pairs(self.pipePairs) do
        pair:draw()
    end

    love.graphics.setFont(flappy_font)
    love.graphics.print('Score: ' .. tostring(self.score), 16, 8)

    self.bird:draw()
end
