--
--
--  Created by Tilmann Hars
--  Copyright (c) 2014 Headchant. All rights reserved.
--

-- Set Library Folders
_LIBRARYPATH = "libs"
_LIBRARYPATH = _LIBRARYPATH .. "/"

requireLibrary = function(name)
	return require(_LIBRARYPATH..name)
end

-- Get the libs manually
local strict    = requireLibrary("strict")
local slam      = requireLibrary("slam")
local Terebi    = requireLibrary("terebi")
local Gamestate = requireLibrary("hump/gamestate")

-- Declare Global Variables
screen = nil
class_commons = nil
common = nil
no_game_code = nil

-- fonts
font_HelvetiPixel = nil
font_TimesNewPixel = nil

-- Global Functions inspired by picolove https://github.com/gamax92/picolove/blob/master/api.lua
function all(a)
	if a==nil or #a==0 then
		return function() end
	end
	local i, li=1
	return function()
		if (a[i] == li) then 
			i = i + 1 
		end
		while(a[i] == nil and i<=#a) do
			i = i + 1 
		end
		li = a[i]
		return a[i]
	end
end

function add(a, v)
	if a == nil then
		return
	end
	a[#a+1] = v
end

function del(a, dv)
	if a == nil then
		return
	end
	for i=1, #a do
		if a[i] == dv then
			table.remove(a, i)
			return
		end
	end
end

function rnd()
	return math.random()
end

--[[
require("tests.tests")
--]]

-- Creates a proxy via rawset.
-- Credit goes to vrld: https://github.com/vrld/Princess/blob/master/main.lua
-- easier, faster access and caching of resources like images and sound
-- or on demand resource loading
local function Proxy(f)
	return setmetatable({}, {__index = function(self, k)
		local v = f(k)
		rawset(self, k, v)
		return v
	end})
end

-- Standard proxies
Image   = Proxy(function(k) return love.graphics.newImage('img/' .. k .. '.png') end)
Sfx     = Proxy(function(k) return love.audio.newSource('sfx/' .. k .. '.ogg', 'static') end)
Music   = Proxy(function(k) return love.audio.newSource('music/' .. k .. '.ogg', 'stream') end)

--[[ examples:
    love.graphics.draw(Image.background)
-- or    
    Sfx.explosion:play()
--]]
    
-- Require all files in a folder and its subfolders, this way we do not have to require every new file
local function recursiveRequire(folder, tree)
    local tree = tree or {}
    for i,file in ipairs(love.filesystem.getDirectoryItems(folder)) do
        local filename = folder.."/"..file
        if love.filesystem.isDirectory(filename) then
            recursiveRequire(filename)
        elseif file ~= ".DS_Store" then
            require(filename:gsub(".lua",""))
        end
    end
    return tree
end



local function extractFileName(str)
	return string.match(str, "(.-)([^\\/]-%.?([^%.\\/]*))$")
end

-- Initialization
function love.load(arg)
	math.randomseed(os.time())
	love.graphics.setDefaultFilter("nearest", "nearest")
	-- love.mouse.setVisible(false)
    -- print "Require Sources:"
	recursiveRequire("src")
	Gamestate.registerEvents()
	Gamestate.switch(Game)

  -- Set nearest-neighbour scaling. Calling this is optional.
  Terebi.initializeLoveDefaults()

  -- Parameters: game width, game height, starting scale factor
  screen = Terebi.newScreen(320, 180, 3)
    -- This color will used for fullscreen letterboxing when content doesn't fit exactly. (Optional)
    :setBackgroundColor(64, 64, 64)


	font_HelvetiPixel = love.graphics.newFont("fonts/HelvetiPixel.ttf", 16)
	font_TimesNewPixel = love.graphics.newFont("fonts/TimesNewPixel.ttf", 16)
end

-- Logic
function love.update( dt )
	
end




-- Rendering
function love.draw()
end

-- Input
function love.keypressed(key)
  if     key == 'i' then
    screen:increaseScale()
  elseif key == 'd' then
    screen:decreaseScale()
  elseif key == 'f' then
    screen:toggleFullscreen()
  end	
end

function love.keyreleased()
	
end

function love.mousepressed()
	
end

function love.mousereleased()
	
end

function love.joystickpressed()
	
end

function love.joystickreleased()
	
end

-- Get console output working with sublime text
io.stdout:setvbuf("no")
