-- NeonLib v4 (Modular UI Framework - Roblox Studio Safe)

local NeonLib = {}
NeonLib.__index = NeonLib

--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// Theme
NeonLib.Theme = {
	BG = Color3.fromRGB(10, 12, 18),
	Panel = Color3.fromRGB(18, 22, 32),
	Accent = Color3.fromRGB(0, 255, 231),
	Text = Color3.fromRGB(235, 245, 245),
	Muted = Color3.fromRGB(120, 140, 140),
	Stroke = Color3.fromRGB(0, 255, 231)
}

--// Tween helper
local function tween(obj, props, t)
	TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

--// Instance helper
local function new(class, props)
	local inst = Instance.new(class)
	for k, v in pairs(props or {}) do
		inst[k] = v
	end
	return inst
end

-----------------------------------------------------
-- 🧩 COMPONENT SYSTEM
-----------------------------------------------------

NeonLib.Components = {}

-- Toggle
function NeonLib.Components.Toggle(parent, cfg)
	local state = cfg.Default or false

	local frame = new("Frame", {
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = NeonLib.Theme.Panel,
		Parent = parent
	})

	local btn = new("TextButton", {
		Size = UDim2.new(0, 40, 0, 20),
		Position = UDim2.new(1, -50, 0.5, -10),
		Text = "",
		BackgroundColor3 = state and NeonLib.Theme.Accent or Color3.fromRGB(40,40,40),
		Parent = frame
	})

	local label = new("TextLabel", {
		Text = cfg.Title or "Toggle",
		Size = UDim2.new(1, -60, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		TextColor3 = NeonLib.Theme.Text,
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame
	})

	btn.MouseButton1Click:Connect(function()
		state = not state
		tween(btn, {
			BackgroundColor3 = state and NeonLib.Theme.Accent or Color3.fromRGB(40,40,40)
		})
		if cfg.Callback then cfg.Callback(state) end
	end)

	return {
		Set = function(v)
			state = v
			btn.BackgroundColor3 = v and NeonLib.Theme.Accent or Color3.fromRGB(40,40,40)
		end,
		Get = function()
			return state
		end
	}
end

-- Button
function NeonLib.Components.Button(parent, cfg)
	local btn = new("TextButton", {
		Size = UDim2.new(1, 0, 0, 40),
		Text = cfg.Title or "Button",
		TextColor3 = NeonLib.Theme.Text,
		BackgroundColor3 = NeonLib.Theme.Panel,
		Parent = parent
	})

	btn.MouseButton1Click:Connect(function()
		if cfg.Callback then cfg.Callback() end
	end)

	return btn
end

-- Slider
function NeonLib.Components.Slider(parent, cfg)
	local min, max = cfg.Min or 0, cfg.Max or 100
	local value = cfg.Default or min

	local frame = new("Frame", {
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundColor3 = NeonLib.Theme.Panel,
		Parent = parent
	})

	local bar = new("Frame", {
		Size = UDim2.new((value-min)/(max-min), 0, 0, 4),
		Position = UDim2.new(0, 10, 0.7, 0),
		BackgroundColor3 = NeonLib.Theme.Accent,
		Parent = frame
	})

	local dragging = false

	frame.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)

	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if dragging then
			local pct = math.clamp((i.Position.X - frame.AbsolutePosition.X) / frame.AbsoluteSize.X, 0, 1)
			value = math.floor(min + (max - min) * pct)

			tween(bar, {Size = UDim2.new(pct, 0, 0, 4)}, 0.05)

			if cfg.Callback then cfg.Callback(value) end
		end
	end)

	return {
		Set = function(v)
			value = v
		end,
		Get = function()
			return value
		end
	}
end

-----------------------------------------------------
-- 🪟 WINDOW SYSTEM
-----------------------------------------------------

function NeonLib:CreateWindow(cfg)
	local self = setmetatable({}, NeonLib)

	local gui = new("ScreenGui", {
		Name = "NeonLib",
		ResetOnSpawn = false,
		Parent = PlayerGui
	})

	local main = new("Frame", {
		Size = UDim2.new(0, 520, 0, 360),
		Position = UDim2.new(0.5, -260, 0.5, -180),
		BackgroundColor3 = NeonLib.Theme.BG,
		Parent = gui
	})

	new("UICorner", {CornerRadius = UDim.new(0, 6), Parent = main})

	local top = new("Frame", {
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = NeonLib.Theme.Panel,
		Parent = main
	})

	new("TextLabel", {
		Text = cfg.Title or "NeonLib",
		Size = UDim2.new(1, 0, 1, 0),
		TextColor3 = NeonLib.Theme.Accent,
		BackgroundTransparency = 1,
		Parent = top
	})

	local tabHolder = new("Frame", {
		Size = UDim2.new(1, 0, 1, -40),
		Position = UDim2.new(0, 0, 0, 40),
		BackgroundTransparency = 1,
		Parent = main
	})

	self.Gui = gui
	self.Main = main
	self.TabHolder = tabHolder
	self.Tabs = {}

	-----------------------------------------------------
	-- 📁 TAB SYSTEM
	-----------------------------------------------------

	function self:CreateTab(name)
		local tabFrame = new("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Visible = false,
			Parent = self.TabHolder
		})

		local layout = new("UIListLayout", {
			Padding = UDim.new(0, 6),
			Parent = tabFrame
		})

		local tab = {}

		function tab:Show()
			for _, t in pairs(self.Tabs) do
				t.Frame.Visible = false
			end
			tabFrame.Visible = true
		end

		function tab:AddToggle(c)
			return NeonLib.Components.Toggle(tabFrame, c)
		end

		function tab:AddButton(c)
			return NeonLib.Components.Button(tabFrame, c)
		end

		function tab:AddSlider(c)
			return NeonLib.Components.Slider(tabFrame, c)
		end

		self.Tabs[name] = {
			Frame = tabFrame,
			API = tab
		}

		-- auto first tab
		if #self.Tabs == 1 then
			tabFrame.Visible = true
		end

		return tab
	end

	return self
end

-----------------------------------------------------
-- 🔔 NOTIFICATIONS
-----------------------------------------------------

function NeonLib:Notify(cfg)
	local gui = new("ScreenGui", {
		Name = "NeonNotify",
		Parent = CoreGui
	})

	local frame = new("Frame", {
		Size = UDim2.new(0, 250, 0, 60),
		Position = UDim2.new(1, -260, 1, -80),
		BackgroundColor3 = self.Theme.Panel,
		Parent = gui
	})

	new("TextLabel", {
		Text = cfg.Title or "Notification",
		Size = UDim2.new(1, 0, 1, 0),
		TextColor3 = self.Theme.Text,
		BackgroundTransparency = 1,
		Parent = frame
	})

	task.delay(cfg.Duration or 3, function()
		gui:Destroy()
	end)
end

return NeonLib
