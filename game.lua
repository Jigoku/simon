--[[
 * Copyright (C) 2016 Ricky K. Thomson
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * u should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 --]]
 

game = {
	mode = 0,
}



function game:init()
	self.mode = 1
	
	self.buttonMaxOpacity = 255
	self.buttonMinOpacity = 50
	self.buttonSpeed = 2000
	self.playbackCycle = 0.5
	self.playbackDelay = 0.5
	self.playbackPos = 0
	
	self.input = {}
	self.sequence = {}
	self.buttons = {
		w = 120,
		h = 100,
		padding = 10,
	}

	self.score = 0
	self.playback = true
	self.endgame = false
	
	self.msgstr = "Simon says..."
	
	self.buttons.canvas = love.graphics.newCanvas( 
		self.buttons.w*2+self.buttons.padding,
		self.buttons.h*2+self.buttons.padding 
	)

	self.buttons.a = 255
	self.buttons.x = love.graphics.getWidth()/2-self.buttons.canvas:getWidth()/2
	self.buttons.y = love.graphics.getHeight()/2-self.buttons.canvas:getHeight()/2

	--create the main game buttons
	table.insert(game.buttons, {
		value = 0,
		active = false,
		speed = self.buttonSpeed,
		w = self.buttons.w,
		h = self.buttons.h,
		x = 0,
		y = 0,
		r = 255,
		g = 0,
		b = 0,
		a = self.buttonMinOpacity,
		sound = sound.red,
	})


	table.insert(game.buttons, {
		value = 1,
		active = false,
		speed = self.buttonSpeed,
		w = self.buttons.w,
		h = self.buttons.h,
		x = 0+self.buttons.w+self.buttons.padding,
		y = 0,
		r = 0,
		g = 255,
		b = 0,
		a = self.buttonMinOpacity,
		sound = sound.green,
	})


	table.insert(game.buttons, {
		value = 2,
		active = false,
		speed = self.buttonSpeed,
		w = self.buttons.w,
		h = self.buttons.h,
		x = 0,
		y = 0+self.buttons.h+self.buttons.padding,
		r = 0,
		g = 0,
		b = 255,
		a = self.buttonMinOpacity,
		sound = sound.blue,
	})


	table.insert(game.buttons, {
		value = 3,
		active = false,
		speed = self.buttonSpeed,
		w = self.buttons.w,
		h = self.buttons.h,
		x = 0+self.buttons.w+self.buttons.padding,
		y = 0+self.buttons.h+self.buttons.padding,
		r = 255,
		g = 255,
		b = 0,
		a = self.buttonMinOpacity,
		sound = sound.yellow,
	})
end

function game:draw()
	love.graphics.setFont(fonts.large)
	love.graphics.setColor(255,255,255,255)
	love.graphics.printf("Score: ".. game.score, 0,love.graphics.getHeight()-100,love.graphics.getWidth(),"center")
	love.graphics.setFont(fonts.default)
	
	love.graphics.setCanvas(self.buttons.canvas)
	love.graphics.clear(10,10,10,255)
	
    for i, button in ipairs(game.buttons) do
		love.graphics.setColor(button.r,button.g,button.b,button.a)
		love.graphics.rectangle("fill", button.x,button.y,button.w,button.h)
		love.graphics.setColor(button.r,button.g,button.b,button.a)
		love.graphics.rectangle("line", button.x,button.y,button.w,button.h)
		if debug then
			love.graphics.setColor(255,255,255,255)
			love.graphics.rectangle("line", 0,0, self.buttons.canvas:getWidth(), self.buttons.canvas:getHeight())
			love.graphics.print(button.value, button.x,button.y)
		end
	end
	
	love.graphics.setCanvas()
	love.graphics.setColor(255,255,255,self.buttons.a)
	love.graphics.draw(
		self.buttons.canvas, 
		self.buttons.x,
		self.buttons.y
	)

	if self.playback or self.endgame then
		love.graphics.setFont(fonts.large)
		love.graphics.setColor(255,255,255,255)
		love.graphics.printf(self.msgstr, 0, 50, love.graphics.getWidth(), "center")
		love.graphics.setFont(fonts.default)
	end
	
	if debug then
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("sequence: ".. table.concat(self.sequence, ", "),5,50)
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("input: ".. table.concat(self.input, ", "),5,65)
	end
end

			
function game:update(dt)
	
	if self.endgame then
		self.buttons.a = self.buttons.a - 100 *dt
		if self.buttons.a <= 0 then self.mode = 0 end
		return
	end
	
	--check if our input matches the sequence
	if #self.input > 0 then
		for n=0, #self.input do
			if not (self.input[n] == self.sequence[n]) then
				self:lose()
			end
		end
		
		if (#self.sequence == #self.input) then	
			self:win()
		end
	end




	--let the computer chose the next sequence
	if self.playback then
		
		--start a timer
		self.playbackCycle = math.max(0, self.playbackCycle - dt)
		
		if self.playbackCycle <= 0 then	
			self.playbackCycle = self.playbackDelay
			
			--if we've just started to playback the sequence, append to it
			if self.playbackPos == 0 then
				math.randomseed(os.time())
				game.sequence[#game.sequence+1] = math.random(0,3)
			end
			
			self.playbackPos = self.playbackPos+1
			
			--animate the button when playing back sequence
			for i, sequence in ipairs(game.sequence) do
				if i == self.playbackPos then
					game:animbutton(sequence)
				end
			end

			--reach the end of playback (allow player to input sequence)
			if self.playbackPos == #self.sequence then
				self.playbackPos = 0
				self.playback = false
			end
		end		
	end


	--animates the buttons
	for i, button in ipairs(game.buttons) do
		if button.active then
			button.a = button.a + button.speed *dt			
			
			--light up the button
			if button.a > self.buttonMaxOpacity then
				button.a = self.buttonMaxOpacity
				button.speed = -button.speed
			--dim the button
			elseif button.a < self.buttonMinOpacity then
				button.a = self.buttonMinOpacity
				button.speed = -button.speed
				button.active = false
			end
		
		end
	end

end


function game:lose()
	sound:play(sound.lose)
	self.msgstr = "Game Over!"
	self.endgame = true
end

function game:win()
	--increase score
	self.score = self.score + #self.sequence
	self.playback = true
	self.input = {}
end	


function game:animbutton(n)
	--triggers the animation/sound for a button
	for i,button in ipairs(game.buttons) do
		if button.value == n then
			button.a = self.buttonMinOpacity
			button.active = true
			sound:play(button.sound)
		end
	end
end


function game:keypressed(key)
	if key == "escape" then
		self.mode = 0
	end	
end

function game:mousemoved(x,y)
end


function game:mousepressed(x,y,button)
	if self.playback then return end

	--check if we clicked a button
	if button == 1 and not self.endgame then
		for i, button in ipairs(game.buttons) do

			if collision:check(
				x,y,
				0,0,
				button.x+self.buttons.x,
				button.y+self.buttons.y,
				button.w,button.h
			) then
				self:animbutton(button.value)
				--add the button to our input queue
				self.input[#game.input+1] = button.value	
								
			end
		end
	end
end
