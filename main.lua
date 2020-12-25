--! file: main.lua

-- required files
Object = require "classic"
push = require 'push'
require "letter"
require "player"

-- virtual resolution
VIRTUAL_WIDTH = 800
VIRTUAL_HEIGHT = 600
-- deafult window resolution
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

-- music = love.audio.newSource( 'sounds/music.mp3', 'stream' )
-- music:setVolume(0.5)
-- music:setLooping( true ) --so it doesnt stop
-- music:play()


gameState = "start"
letterState = "uppercase"

-- makes upscaling look pixel-y instead of blurry
love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()
  -- randomise every game
  math.randomseed(os.time())

  -- screen setup
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
      fullscreen = false,
      resizable = true
  })

  --icon
    icon = love.graphics.newImage("icon.png")
  -- sounds
  sounds = {
          ['gobble'] = love.audio.newSource('sounds/gobble.wav', 'static'),
          ['reset'] = love.audio.newSource('sounds/reset.wav', 'static'),
      }

  font = love.graphics.newFont("font.ttf",20)
  -- initial loading
  if gameState == "play" then
    if letterState == "uppercase" then
      letters = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
    else
      letters = {"a","b","c","d","e","f","g","h","i","j","k","k","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}
    end
    letters = letterShuffle(letters)
    letter_boxes = {}
    for i, v in ipairs(letters) do
      table.insert(letter_boxes, Letter((i*100)%700 + 50, (i*100)%400 + 100, 50, 50, v))
    end
    player = Player(50,100,15,15)
    letters_gobbled = {}
  end
end

function love.update(dt)
  if gameState == "play" then
    player:update(dt)
    for i,v in ipairs(letter_boxes) do
      if v.visible == true then
        if checkCollision(player, v) then
          v.visible = false
          table.insert(letters_gobbled, v.letter)
          sounds['gobble']:play()
        end
      end
    end
  end
end

function love.draw()
  -- begin virtual resolution drawing
  push:apply('start')

  -- background and font
  love.graphics.clear(0, 0.41, 0.58,1)
  love.graphics.setFont(font)

  if gameState == "play" then
    love.graphics.setColor(0.9, 0.9, 0.8)
    love.graphics.printf("Control the letter gobbler with the arrow keys.", 0, 10, VIRTUAL_WIDTH, 'center')
    player:draw()
    for i,v in ipairs(letter_boxes) do
      if v.visible == true then
        v:draw()
      end
    end
    love.graphics.setColor(0.9, 0.9, 0.8)
    love.graphics.print("Letters Gobbled:", 30, 475)
    for i,v in ipairs(letters_gobbled) do
      love.graphics.print(v, 220 + i*30, 475)
    end
    love.graphics.printf("Press space to reset.", 0, 520, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press escape to exit.", 0, 550, VIRTUAL_WIDTH, 'center')
  else
    love.graphics.setColor(0.9, 0.9, 0.8)
    love.graphics.printf("Welcome to Letter Quest!", 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.draw(icon, 300, 150)
    love.graphics.printf("Press 1 for uppercase letters.", 0, 300, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press 2 for lowercase letters.", 0, 330, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press escape to exit.", 0, 500, VIRTUAL_WIDTH, 'center')
  end
  -- end virtual resolution
  push:apply('end')
end


-- check collision for two rectangles
function checkCollision(a, b)
  local a_left = a.x
  local a_right = a.x + a.width
  local a_top = a.y
  local a_bottom = a.y + a.height

  local b_left = b.x
  local b_right = b.x + b.width
  local b_top = b.y
  local b_bottom = b.y + b.height

  if a_right > b_left and
  a_left < b_right and
  a_bottom > b_top and
  a_top < b_bottom then
      return true
  else
      return false
  end
end

-- shuffle letters array
function letterShuffle(letters)
  new_letters = {}
  for  i = 1, 26 do
    index = math.random(1, #letters)
    table.insert(new_letters, letters[index])
    table.remove(letters, index)
  end
  return new_letters
end

-- key functionality
function love.keypressed(key)
  if key == "1" and gameState == "start" then
    sounds['reset']:play()
    gameState = "play"
    letterState = "uppercase"
    love.load()
  end
  if key == "2" and gameState == "start" then
    sounds['reset']:play()
    gameState = "play"
    letterState = "lowercase"
    love.load()
  end
  if key == "space" and gameState == "play" then
    sounds['reset']:play()
    gameState = "start"
    letterState = "uppercase"
    love.load()
  end
  if key == "escape" then
    love.event.quit()
  end
end

-- called whenever window is resized
function love.resize(w, h)
    push:resize(w, h)
end
