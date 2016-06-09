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
 
require "title"
require "game"
require "collision"
require "sound"


function love.load()
	love.graphics.setBackgroundColor(10,10,10,255)
	
	fonts = {
		default = love.graphics.newFont("data/fonts/Hanken/Hanken-Book.ttf",12),
		title = love.graphics.newFont("data/fonts/Hanken/Hanken-Book.ttf",24),
		large = love.graphics.newFont("data/fonts/Hanken/Hanken-Book.ttf",26),
	}
	love.graphics.setFont(fonts.default)
	title:init()
end


function love.draw()
	if game.mode == 0 then
		title:draw()
	else
		game:draw()
	end

	if debug then 
		love.graphics.setColor(255,255,255,255)
        love.graphics.print(game.mode == 0 and "title(0)" or "game(1)",5,5)
        love.graphics.print("mouse: "..love.mouse.getX()..","..love.mouse.getY(),5,15)
	end

end

function love.update(dt)
	if game.mode == 0 then
		title:update(dt)
	else
		game:update(dt)
	end
end

function love.keypressed(key)
	if game.mode == 0 then
		title:keypressed(key)
	else
		game:keypressed(key)
	end

	if key == "`" then
		debug = not debug
	end
end

function love.mousemoved(x,y)
	if game.mode == 0 then
		title:mousemoved(x,y)
	else
		game:mousemoved(x,y)
	end
end


function love.mousepressed(x,y,button)
	if game.mode == 0 then
		title:mousepressed(x,y,button)
	else
		game:mousepressed(x,y,button)
	end
	
end
