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
 
sound = {}

sound.red = love.audio.newSource("sound/0.wav", "static")
sound.green = love.audio.newSource("sound/1.wav", "static")
sound.blue = love.audio.newSource("sound/2.wav", "static")
sound.yellow = love.audio.newSource("sound/3.wav", "static")

function sound:play(effect)
	if effect:isPlaying() then
		effect:stop()
	end
	effect:play()
end
