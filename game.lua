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
	buttonMaxOpacity = 255,
	buttonMinOpacity = 50,
	buttonSpeed = 2000,
	playbackCycle = 0.5,
	playbackDelay = 0.5,
	playbackPos = 0,
}



function game:init()
	self.mode = 1

	self.buttons = {}

	self.score = 0
	self.playback = true
	self.input = {}
	self.pattern = {}

	game.buttons = {
		w = 100,
		h = 100,
		padding = 10,
	}

	self.buttons.canvas = love.graphics.newCanvas( 
		self.buttons.w*2+self.buttons.padding,
		self.buttons.h*2+self.buttons.padding 
	)

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
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Score: ".. game.score, love.graphics.getWidth()-200,10)

	love.graphics.setCanvas(self.buttons.canvas)
	self.buttons.canvas:clear(0,0,0,255)
	
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
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(
		self.buttons.canvas, 
		self.buttons.x,
		self.buttons.y
	)

	if self.playback then
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("Simon Says...", love.graphics.getWidth()/2, love.graphics.getHeight()/5)
	end
	
	if debug then
		
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("pattern: ".. table.concat(game.pattern, ", "),5,200)
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("input: ".. table.concat(game.input, ", "),5,215)
	end
end


function game:update(dt)

	--check if our input matches the sequenced pattern
	if #game.input > 0 then
		for n=0, #game.input do
			if not (game.input[n] == game.pattern[n]) then
				print("LOSE")
				game.mode = 0
			end
		end
		
		if (#game.pattern == #game.input) then
				game.score = game.score + #game.pattern 
				game.playback = true
				game.input = {}
				print ("WIN!")		
			
		end
	end


	--let the computer chose the next sequence
	if game.playback then
		
		--start a timer
		self.playbackCycle = math.max(0, self.playbackCycle - dt)
		
		if self.playbackCycle <= 0 then	
			self.playbackCycle = self.playbackDelay
			
			--if we've just started to playback the sequence, append to it
			if self.playbackPos == 0 then
				math.randomseed(os.time())
				game.pattern[#game.pattern+1] = math.random(0,3)
			end
			
			
			self.playbackPos = self.playbackPos+1
			
			--animate the button when playing back sequence
			for i, pattern in ipairs(game.pattern) do
				if i == self.playbackPos then
					game:animbutton(pattern)
				end
			end

			--reach the end of playback (allow player to input sequence)
			if self.playbackPos == #self.pattern then
				self.playbackPos = 0
				game.playback = false
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
		game.mode = 0
	end	
end

function game:mousemoved(x,y)
end


function game:mousepressed(x,y,button)
	if game.playback then return end

	--check if we clicked a button
    if button == "l" then
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
					game.input[#game.input+1] = button.value
					
				end
        end
    end



end
