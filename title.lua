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

title = {}
title.buttons = {}

function title:init()
	local buttonWidth = 180
	local buttonHeight = 50

	table.insert(title.buttons, {
		name = "play",
		text = "Play",
		active = false,
		w = buttonWidth,
		h = buttonHeight,
		x = love.graphics.getWidth()/2-buttonWidth/2,
		y = love.graphics.getHeight()/2,
	})

	table.insert(title.buttons, {
		name = "exit",
		text = "Quit",
		active = false,
		w = buttonWidth,
		h = buttonHeight,
		x = love.graphics.getWidth()/2-buttonWidth/2,
		y = love.graphics.getHeight()/2+buttonHeight+10,
	})

end

function title:draw()
	love.graphics.setColor(155,0,0,255)

	for i, button in ipairs(title.buttons) do

		--background
		if button.active then
			love.graphics.setColor(40,40,40,255)
		else
			love.graphics.setColor(25,25,25,255)
		end
		love.graphics.rectangle("fill",button.x,button.y,button.w,button.h)

		--border
		love.graphics.setColor(30,30,30,255)
		love.graphics.rectangle("line",button.x,button.y,button.w,button.h)

		--text
		love.graphics.setFont(fonts.title)
		love.graphics.setColor(255,255,255,255)
		love.graphics.printf(button.text,0,button.y+button.h/4,love.graphics.getWidth(), "center")
		love.graphics.setFont(fonts.default)
	end
	love.graphics.setFont(fonts.large)
	love.graphics.setColor(255,255,255,255)
	love.graphics.printf("Simon says...", 0, 50, love.graphics.getWidth(), "center")
	love.graphics.setFont(fonts.default)
end

function title:update(dt)

end

function title:mousemoved(x,y)
	for i, button in ipairs(title.buttons) do
		if collision:check(x,y,0,0,button.x,button.y,button.w,button.h) then
			button.active = true
		else
			button.active = false
		end
	end
end

function title:mousepressed(x,y,button)
	if button == 1 then
		for i, button in ipairs(title.buttons) do
			if collision:check(x,y,0,0,button.x,button.y,button.w,button.h) then
				sound:play(sound.click)
				if button.name == "exit" then
					love.event.quit()			
				elseif button.name == "play" then
					game:init()
				end
			end
		end
	end
end

function title:keypressed(key)
	if key == "escape" then
		love.event.quit()
	elseif key == " " then
		game:init()
	end
end 

