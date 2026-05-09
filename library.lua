-- ModernUILib.lua
local ModernUILib = {}

ModernUILib.__index = ModernUILib

-- =========================
-- THEME
-- =========================
ModernUILib.Theme = {
	Bg = Color3.fromRGB(18, 18, 24),
	Surface = Color3.fromRGB(26, 26, 35),
	Primary = Color3.fromRGB(0, 188, 212),
	Text = Color3.fromRGB(230, 230, 240),
	TextMuted = Color3.fromRGB(140, 140, 155),
	Border = Color3.fromRGB(45, 45, 60),
}

-- =========================
-- CORE WINDOW
-- =========================
function ModernUILib:CreateWindow(title)
	local self = setmetatable({}, ModernUILib)

	local player = game.Players.LocalPlayer
	local gui = Instance.new("ScreenGui")
	gui.Name = "ModernUILib"
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local main = Instance.new("Frame")
	main.Size = UDim2.new(0, 700, 0, 450)
	main.Position = UDim2.new(0.5, -350, 0.5, -225)
	main.BackgroundColor3 = self.Theme.Bg
	main.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = main

	local titleBar = Instance.new("TextLabel")
	titleBar.Size = UDim2.new(1, 0, 0, 40)
	titleBar.BackgroundColor3 = self.Theme.Surface
	titleBar.Text = title
	titleBar.TextColor3 = self.Theme.Text
	titleBar.Font = Enum.Font.GothamBold
	titleBar.TextSize = 16
	titleBar.Parent = main

	local tabsHolder = Instance.new("Frame")
	tabsHolder.Size = UDim2.new(0, 150, 1, -40)
	tabsHolder.Position = UDim2.new(0, 0, 0, 40)
	tabsHolder.BackgroundTransparency = 1
	tabsHolder.Parent = main

	local contentHolder = Instance.new("Frame")
	contentHolder.Size = UDim2.new(1, -150, 1, -40)
	contentHolder.Position = UDim2.new(0, 150, 0, 40)
	contentHolder.BackgroundTransparency = 1
	contentHolder.Parent = main

	self.Gui = gui
	self.Window = main
	self.TabsHolder = tabsHolder
	self.ContentHolder = contentHolder
	self.Tabs = {}

	return self
end

-- =========================
-- TAB SYSTEM
-- =========================
function ModernUILib:CreateTab(name)
	local tabButton = Instance.new("TextButton")
	tabButton.Size = UDim2.new(1, -10, 0, 35)
	tabButton.BackgroundColor3 = self.Theme.Surface
	tabButton.Text = name
	tabButton.TextColor3 = self.Theme.Text
	tabButton.Font = Enum.Font.Gotham
	tabButton.TextSize = 14
	tabButton.Parent = self.TabsHolder

	local tabPage = Instance.new("Frame")
	tabPage.Size = UDim2.new(1, 0, 1, 0)
	tabPage.BackgroundTransparency = 1
	tabPage.Visible = false
	tabPage.Parent = self.ContentHolder

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.Parent = tabPage

	local tab = {
		Button = tabButton,
		Page = tabPage
	}

	table.insert(self.Tabs, tab)

	tabButton.MouseButton1Click:Connect(function()
		for _, t in ipairs(self.Tabs) do
			t.Page.Visible = false
		end
		tabPage.Visible = true
	end)

	return tab
end

-- =========================
-- BUTTON
-- =========================
function ModernUILib:CreateButton(tab, text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 35)
	btn.BackgroundColor3 = self.Theme.Primary
	btn.Text = text
	btn.TextColor3 = self.Theme.Text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Parent = tab.Page

	btn.MouseButton1Click:Connect(function()
		if callback then callback() end
	end)

	return btn
end

-- =========================
-- TOGGLE
-- =========================
function ModernUILib:CreateToggle(tab, text, callback)
	local state = false

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 35)
	btn.BackgroundColor3 = self.Theme.Surface
	btn.Text = text .. " [OFF]"
	btn.TextColor3 = self.Theme.Text
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Parent = tab.Page

	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = text .. (state and " [ON]" or " [OFF]")
		if callback then callback(state) end
	end)

	return btn
end

-- =========================
-- NOTIFICATION
-- =========================
function ModernUILib:Notify(text)
	local notif = Instance.new("TextLabel")
	notif.Size = UDim2.new(0, 250, 0, 40)
	notif.Position = UDim2.new(1, -260, 1, -60)
	notif.BackgroundColor3 = self.Theme.Surface
	notif.Text = text
	notif.TextColor3 = self.Theme.Text
	notif.Font = Enum.Font.Gotham
	notif.TextSize = 14
	notif.Parent = self.Gui

	task.delay(3, function()
		notif:Destroy()
	end)
end

return ModernUILib
