
local file = loadstring(game:HttpGet("https://raw.githubusercontent.com/fayvrit/millionware/refs/heads/main/library.lua"))()
local library = file.library
local lib2 = file:import()

local window = library:window({bind = Enum.KeyCode.RightShift})
local keybindlist = library:keybindlist({title = "Keybind list", visible = false})

local page = window:page{title = "Rage"} do
	for _, v in {"Default", "Pistol", "SMG", "Rifle", "Sniper"} do
		local subpage = page:sub_page{title = v}

		local left = subpage:column()
		local right = subpage:column()

		local section = left:section{title = "Ragebot"}
			
		local elements = {}
		local isdefault = v == "Default"
		
		
		if not isdefault then 
			section:toggle{title = "Override default"}:connect(function(bool)
				for _, element in elements do
					element:set("visible", bool)
				end
			end)
		end
		
		elements.ragebot = section:toggle{title = "Enabled", visible = isdefault}
		elements.ragebot:keybind{names = "Ragebot"}
		
		elements.silentaim = section:toggle{title = "Hit Manipulation", visible = isdefault}
		elements.bodyparts = section:dropdown{title = "Body Parts", Multi = true, Options = {"Head", "Body", "Arms", "Legs"}, visible = isdefault}
		
		elements.slider = section:slider{min = 0, title = "Hitchance", float = .01, visible = isdefault}
		elements.triggerbot = section:toggle{title = "Trigger Bot", visible = isdefault}
	end
	
end

local page = window:page{title = "Settings"} do

	local left = page:column()
	local right = page:column()

	local section = right:section{title = "Menu settings"}

	local menubind = section:keybind{names = "Menu bind", modes = {}, default = library.menubind}
	local accent = section:colorpicker{color = library.accent, title = "Accent color", callback = function(color) library:set("accent", color) end}
	local keybindlist = section:toggle{title = "Show keybind list", callback = keybindlist.functions.visible}
	local unload = section:button{title = "Unload", callback = library.unload}

	menubind:connect(function(tbl)
		library:set("bind", tbl.key)
	end)

	--

	local section = left:section{title = "Configs"}
	local name = section:textbox{title = "Config name"}
	local save = section:button{title = "Save"}
	local cfgs = section:dropdown{title = "Configs", maxheight = 5, options = library.listconfigs()}
	local load = section:button{title = "Load"}
	local dele = section:button{title = "Delete"}

	cfgs:connect(function(default)
		if not default then return end

		name:set("value", default)
	end)

	save:connect(function()
		local text = string.gsub(name.value, "%s+", "")

		if text == "" then return end

		library.writeconfig(name.value)
		cfgs:set("refresh", library.listconfigs())
		cfgs:set("default", name.value)
	end)

	load:connect(function()
		local option = cfgs.default

		if not option then return end

		library.loadconfig(option)
		cfgs:set("refresh", library.listconfigs())
		cfgs:set("default", option)
	end)

	dele:connect(function()
		local option = cfgs.default

		if not option then return end

		library.deleteconfig(option)
		cfgs:set("refresh", library.listconfigs())
	end)
end

library:initialize()
