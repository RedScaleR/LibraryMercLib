--[[
	NeonLib - Enhanced Cyberpunk GUI Library
	Version: 3.1 (Improved Placements & Icons)
--]]

local NeonLib = {}
NeonLib.__index = NeonLib

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local Theme = {
	Accent = Color3.fromRGB(0, 255, 231),
	BG = Color3.fromRGB(7, 11, 20),
	BG2 = Color3.fromRGB(13, 18, 32),
	BG3 = Color3.fromRGB(17, 24, 39),
	TextPrimary = Color3.fromRGB(224, 248, 245),
	TextMuted = Color3.fromRGB(80, 180, 170),
	TextDim = Color3.fromRGB(40,  90,  85),
	Border = Color3.fromRGB(0, 255, 231),
	BorderDim = Color3.fromRGB(0, 80, 70),
	Pink = Color3.fromRGB(255, 45, 120),
	Yellow = Color3.fromRGB(255, 224, 0),
}

-- Tween Helper
local function tween(obj, props, t)
	TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

function NeonLib:CreateWindow(options)
	options = options or {}
	local winTitle = options.Title or "NEONLIB"
	local size = options.Size or Vector2.new(460, 500)
	local toggleKey = options.ToggleKey or Enum.KeyCode.RightShift

	local root = Instance.new("ScreenGui")
	root.Name = "NeonLib_Root"
	root.IgnoreGuiInset = true
	root.Parent = CoreGui or LocalPlayer.PlayerGui

	local win = Instance.new("Frame")
	win.Name = "Window"
	win.Size = UDim2.new(0, size.X, 0, size.Y)
	win.Position = UDim2.new(0.5, -size.X/2, 0.5, -size.Y/2)
	win.BackgroundColor3 = Theme.BG
	win.BorderSizePixel = 0
	win.ClipsDescendants = true
	win.Parent = root
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = win

	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.Border
	stroke.Thickness = 1
	stroke.Transparency = 0.4
	stroke.Parent = win

	-- Titlebar
	local titlebar = Instance.new("Frame")
	titlebar.Size = UDim2.new(1, 0, 0, 40)
	titlebar.BackgroundColor3 = Theme.BG2
	titlebar.BorderSizePixel = 0
	titlebar.Parent = win

	local titleText = Instance.new("TextLabel")
	titleText.Text = winTitle:upper()
	titleText.Size = UDim2.new(1, -120, 1, 0)
	titleText.Position = UDim2.new(0, 15, 0, 0)
	titleText.TextColor3 = Theme.Accent
	titleText.Font = Enum.Font.GothamBold
	titleText.TextSize = 14
	titleText.TextXAlignment = Enum.TextXAlignment.Left
	titleText.BackgroundTransparency = 1
	titleText.Parent = titlebar

	-- Container for Minimize/Close
	local controls = Instance.new("Frame")
	controls.Size = UDim2.new(0, 70, 1, 0)
	controls.Position = UDim2.new(1, -75, 0, 0)
	controls.BackgroundTransparency = 1
	controls.Parent = titlebar

	local list = Instance.new("UIListLayout")
	list.FillDirection = Enum.FillDirection.Horizontal
	list.HorizontalAlignment = Enum.HorizontalAlignment.Right
	list.VerticalAlignment = Enum.VerticalAlignment.Center
	list.Padding = UDim.new(0, 8)
	list.Parent = controls

	-- MINIMIZE BUTTON
	local minimized = false
	local minBtn = Instance.new("TextButton")
	minBtn.Text = "—"
	minBtn.Size = UDim2.new(0, 24, 0, 24)
	minBtn.BackgroundColor3 = Theme.BG3
	minBtn.TextColor3 = Theme.Accent
	minBtn.Font = Enum.Font.GothamBold
	minBtn.Parent = controls
	Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 4)

	minBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		local targetSize = minimized and UDim2.new(0, size.X, 0, 40) or UDim2.new(0, size.X, 0, size.Y)
		tween(win, {Size = targetSize}, 0.3)
	end)

	-- CLOSE BUTTON
	local closeBtn = Instance.new("TextButton")
	closeBtn.Text = "✕"
	closeBtn.Size = UDim2.new(0, 24, 0, 24)
	closeBtn.BackgroundColor3 = Theme.BG3
	closeBtn.TextColor3 = Theme.Pink
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.Parent = controls
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)

	closeBtn.MouseButton1Click:Connect(function()
		tween(win, {Size = UDim2.new(0, size.X, 0, 0), BackgroundTransparency = 1}, 0.3)
		task.wait(0.3)
		root:Destroy()
	end)

	-- Body & Tabs
	local body = Instance.new("Frame")
	body.Name = "Body"
	body.Size = UDim2.new(1, 0, 1, -40)
	body.Position = UDim2.new(0, 0, 0, 40)
	body.BackgroundTransparency = 1
	body.Parent = win

	local tabBar = Instance.new("Frame")
	tabBar.Size = UDim2.new(0, 120, 1, 0)
	tabBar.BackgroundColor3 = Theme.BG2
	tabBar.BorderSizePixel = 0
	tabBar.Parent = body

	local tabContainer = Instance.new("ScrollingFrame")
	tabContainer.Size = UDim2.new(1, 0, 1, -10)
	tabContainer.Position = UDim2.new(0, 0, 0, 5)
	tabContainer.BackgroundTransparency = 1
	tabContainer.ScrollBarThickness = 0
	tabContainer.Parent = tabBar
	Instance.new("UIListLayout", tabContainer).Padding = UDim.new(0, 5)

	local contentArea = Instance.new("Frame")
	contentArea.Size = UDim2.new(1, -130, 1, -10)
	contentArea.Position = UDim2.new(0, 125, 0, 5)
	contentArea.BackgroundTransparency = 1
	contentArea.Parent = body

	-- Dragging
	local dragging, dragInput, dragStart, startPos
	titlebar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = win.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	-- Toggle
	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == toggleKey then
			win.Visible = not win.Visible
		end
	end)

	local tabs = {}
	function Window:AddTab(tabOptions)
		local tName = tabOptions.Title or "Tab"
		local tIcon = tabOptions.Icon or ""

		local tabBtn = Instance.new("TextButton")
		tabBtn.Size = UDim2.new(1, -10, 0, 32)
		tabBtn.Position = UDim2.new(0, 5, 0, 0)
		tabBtn.BackgroundColor3 = Theme.BG3
		tabBtn.Text = ""
		tabBtn.Parent = tabContainer
		Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 4)

		local iconImg = Instance.new("ImageLabel")
		iconImg.Size = UDim2.new(0, 18, 0, 18)
		iconImg.Position = UDim2.new(0, 8, 0.5, -9)
		iconImg.Image = tIcon
		iconImg.BackgroundTransparency = 1
		iconImg.ImageColor3 = Theme.TextMuted
		iconImg.Parent = tabBtn

		local tabLbl = Instance.new("TextLabel")
		tabLbl.Text = tName
		tabLbl.Size = UDim2.new(1, -35, 1, 0)
		tabLbl.Position = UDim2.new(0, 30, 0, 0)
		tabLbl.TextColor3 = Theme.TextMuted
		tabLbl.Font = Enum.Font.Gotham
		tabLbl.TextSize = 12
		tabLbl.TextXAlignment = Enum.TextXAlignment.Left
		tabLbl.BackgroundTransparency = 1
		tabLbl.Parent = tabBtn

		local scroll = Instance.new("ScrollingFrame")
		scroll.Size = UDim2.new(1, 0, 1, 0)
		scroll.BackgroundTransparency = 1
		scroll.Visible = false
		scroll.ScrollBarThickness = 2
		scroll.ScrollBarImageColor3 = Theme.Accent
		scroll.Parent = contentArea
		Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 8)

		tabBtn.MouseButton1Click:Connect(function()
			for _, t in pairs(tabs) do
				t.scroll.Visible = false
				t.lbl.TextColor3 = Theme.TextMuted
				t.icon.ImageColor3 = Theme.TextMuted
			end
			scroll.Visible = true
			tabLbl.TextColor3 = Theme.Accent
			iconImg.ImageColor3 = Theme.Accent
		end)

		local tabData = {scroll = scroll, lbl = tabLbl, icon = iconImg}
		table.insert(tabs, tabData)
		if #tabs == 1 then
			scroll.Visible = true
			tabLbl.TextColor3 = Theme.Accent
			iconImg.ImageColor3 = Theme.Accent
		end

		local TabAPI = {}
		function TabAPI:AddButton(btnOptions)
			local bTitle = btnOptions.Title or "Button"
			local callback = btnOptions.Callback or function() end

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -10, 0, 35)
			btn.BackgroundColor3 = Theme.BG2
			btn.Text = bTitle
			btn.TextColor3 = Theme.TextPrimary
			btn.Font = Enum.Font.GothamMedium
			btn.TextSize = 13
			btn.Parent = scroll
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
			local bStroke = Instance.new("UIStroke", btn)
			bStroke.Color = Theme.BorderDim
			bStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

			btn.MouseButton1Click:Connect(callback)
		end
		return TabAPI
	end

	return setmetatable({}, {__index = Window})
end

return NeonLib
