-- https://github.com/Ulydev/push
push = require 'push'
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'


-- physical screen dimensions
WINDOW_HEIGHT = 720
WINDOW_WIDTH = 405

-- virtual resolution dimensions
VIRTUAL_HEIGHT = 512
VIRTUAL_WIDTH = 288

local background = love.graphics.newImage('pic/background.png')
local background_scroll = 0

local ground = love.graphics.newImage('pic/ground.png')
local ground_scroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413

-- global variable we can use to scroll the map
scrolling = true

-- our bird sprite
local bird = Bird()
local pipes = {}

-- our timer for spawning Pipes
local spawnTimer = 0
-- initialize our last recorded X value for a gap placement to base other gaps off of
local lastX = -PIPE_WIDTH + VIRTUAL_WIDTH / 2 + GAP_WIDTH / 2 + math.random(10)

function love.load()
    -- initialize our nearest-neighbour filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seed the RNG
    math.randomseed(os.time())

    -- app window title
    love.window.setTitle('Diving Bird')

    -- initialize our nice-looking retro text fonts
    small_font = love.graphics.newFont('font/font.ttf', 8)
    medium_font = love.graphics.newFont('font/flappy.ttf', 14)
    flappy_font = love.graphics.newFont('font/flappy.ttf', 28)
    huge_font = love.graphics.newFont('font/flappy.ttf', 56)
    love.graphics.setFont(flappy_font)

    -- initialize our table of sounds
    sounds = {
        ['jump'] = love.audio.newSource('sound/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('sound/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('sound/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('sound/score.wav', 'static'),

        -- https://freesound.org/people/xsgianni/sounds/388079/
        ['music'] = love.audio.newSource('sound/marios_way.mp3', 'static')
    }

    -- kick off music
    sounds['music']: setLooping(true)
    sounds['music']: play()

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initialize input table 
    keys_pressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    keys_pressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return keys_pressed[key]
end

function love.update(dt)
    if not scrolling then 
        return 
    end
    
    -- scroll background by present speed * dt, lopping back to 0 after the looping point 
    background_scroll = (background_scroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUND_LOOPING_POINT

    -- scroll ground by present speed * dt, looping back to 0 after the screen height passes
    ground_scroll = (ground_scroll + GROUND_SCROLL_SPEED * dt)
        % VIRTUAL_HEIGHT

    bird:update(dt)

    -- reset input table
    keys_pressed = {}

    -- spawn a new Pipe if the time is past 2 seconds
    spawnTimer = spawnTimer + dt
    if spawnTimer > 2 then
        local x = math.max(20-PIPE_WIDTH, math.min(lastX + math.random(-20, 20), VIRTUAL_WIDTH - GAP_WIDTH - 20 - PIPE_WIDTH))
        lastX = x

        table.insert(pipes, PipePair(x))
        spawnTimer = 0
    end

    -- for every pipe in the scene...
    for k, pair in pairs(pipes) do
        pair:update(dt)

        for l, pipe in pairs(pair.pipes) do
            if bird:collides(pipe) then
                scrolling = false
            end
        end

        if pair.remove then
            table.remove(pipes, k)
        end
    end
end

-- Callback function used to draw on the screen every frame.
function love.draw()
    push:start()

    -- draw the background
    love.graphics.draw(background, 0, -background_scroll)

    for k, pair in pairs(pipes) do
        pair:render()
    end

    bird:render()

    -- draw the ground on top of the background, towards the bottom of the screen
    love.graphics.draw(ground, 0, -ground_scroll)


    push:finish()
end


