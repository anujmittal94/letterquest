--! file: letter.lua

-- letter class creates the letter box

Letter = Object:extend()

function Letter:new(x, y, width, height, letter)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.letter = letter
    self.recolor = {math.random()/1.5, math.random()/1.5, math.random()/1.5}
    self.lecolor = {0.9, 0.9, 0.8}
    self.visible = true

end

function Letter:draw()
    love.graphics.setColor(self.recolor[1], self.recolor[2], self.recolor[3])
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.width/5, self.height/5)
    love.graphics.setColor(self.lecolor[1], self.lecolor[2], self.lecolor[3])
    love.graphics.printf(self.letter,self.x, self.y + 10, self.width, 'center')
end
