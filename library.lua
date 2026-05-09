--[[
	NeonLib - Cyberpunk GUI Library for Roblox
	Version: 3.0
	Style: Cyberpunk / Neon
	Usage: loadstring(game:HttpGet("YOUR_RAW_URL"))()
--]]
 
local NeonLib = {}
NeonLib.__index = NeonLib
 
-- Services
local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService      = game:GetService("RunService")
local CoreGui         = game:GetService("CoreGui")
 
local LocalPlayer = Players.LocalPlayer
local Mouse       = LocalPlayer:GetMouse()
 
-- ── Palette ────────────────────────────────────────────────────────────────
local Theme = {
	Accent       = Color3.fromRGB(0,   255, 231),  -- cyan
	AccentDim    = Color3.fromRGB(0,   180, 160),
	Pink         = Color3.fromRGB(255,  45, 120),
	Yellow       = Color3.fromRGB(255, 224,   0),
	Purple       = Color3.fromRGB(179,  71, 255),
	Green        = Color3.fromRGB(0,   255, 159),
 
	BG           = Color3.fromRGB(  7,  11,  20),
	BG2          = Color3.fromRGB( 13,  18,  32),
	BG3          = Color3.fromRGB( 17,  24,  39),
 
	TextPrimary  = Color3.fromRGB(224, 248, 245),
	TextMuted    = Color3.fromRGB( 80, 180, 170),
	TextDim      = Color3.fromRGB( 40,  90,  85),
 
	Border       = Color3.fromRGB(  0, 255, 231),
	BorderDim    = Color3.fromRGB(  0,  80,  70),
}
 
-- ── Tween helper ───────────────────────────────────────────────────────────
local function tween(obj, props, t, style, dir)
	local info = TweenInfo.new(
		t or 0.2,
		style or Enum.EasingStyle.Quad,
		dir   or Enum.EasingDirection.Out
	)
	TweenService:Create(obj, info, props):Play()
end
 
-- ── Corner + stroke helpers ────────────────────────────────────────────────
local function addCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 4)
	c.Parent = parent
	return c
end
 
local function addStroke(parent, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color       = color       or Theme.Border
	s.Thickness   = thickness   or 1
	s.Transparency= transparency or 0.6
	s.Parent      = parent
	return s
end
 
local function addPadding(parent, top, bottom, left, right)
	local p = Instance.new("UIPadding")
	p.PaddingTop    = UDim.new(0, top    or 8)
	p.PaddingBottom = UDim.new(0, bottom or 8)
	p.PaddingLeft   = UDim.new(0, left   or 10)
	p.PaddingRight  = UDim.new(0, right  or 10)
	p.Parent        = parent
	return p
end
 
local function label(parent, text, size, color, font, xAlign)
	local l = Instance.new("TextLabel")
	l.Text              = text
	l.TextSize          = size   or 14
	l.TextColor3        = color  or Theme.TextPrimary
	l.Font              = font   or Enum.Font.GothamMedium
	l.TextXAlignment    = xAlign or Enum.TextXAlignment.Left
	l.BackgroundTransparency = 1
	l.Size              = UDim2.new(1, 0, 0, size and size + 4 or 18)
	l.Parent            = parent
	return l
end
 
-- ── Scanline animation (decorative) ───────────────────────────────────────
local function addScanline(frame)
	local line = Instance.new("Frame")
	line.Size            = UDim2.new(1, 0, 0, 2)
	line.BackgroundColor3= Theme.Accent
	line.BackgroundTransparency = 0.5
	line.BorderSizePixel = 0
	line.ZIndex          = 10
	line.Parent          = frame
 
	local go = true
	local pos = 0
	RunService.Heartbeat:Connect(function(dt)
		if not go or not line.Parent then go = false return end
		pos = pos + dt * 60
		if pos > frame.AbsoluteSize.Y + 10 then pos = -10 end
		line.Position = UDim2.new(0, 0, 0, pos)
	end)
	return line
end
 
-- ── Notification system ────────────────────────────────────────────────────
local NotifHolder
 
local function ensureNotifHolder()
	if NotifHolder and NotifHolder.Parent then return end
	NotifHolder = Instance.new("Frame")
	NotifHolder.Name              = "NeonLib_Notifs"
	NotifHolder.Size              = UDim2.new(0, 280, 1, 0)
	NotifHolder.Position          = UDim2.new(1, -295, 0, 0)
	NotifHolder.BackgroundTransparency = 1
	NotifHolder.ZIndex            = 999
	NotifHolder.Parent            = CoreGui:FindFirstChild("NeonLib_Root") or CoreGui
 
	local layout = Instance.new("UIListLayout")
	layout.SortOrder             = Enum.SortOrder.LayoutOrder
	layout.VerticalAlignment     = Enum.VerticalAlignment.Bottom
	layout.Padding               = UDim.new(0, 8)
	layout.Parent                = NotifHolder
 
	local pad = Instance.new("UIPadding")
	pad.PaddingBottom = UDim.new(0, 16)
	pad.PaddingRight  = UDim.new(0, 8)
	pad.Parent        = NotifHolder
end
 
function NeonLib:Notify(options)
	options = options or {}
	local title    = options.Title    or "NeonLib"
	local desc     = options.Content  or ""
	local duration = options.Duration or 4
	local ntype    = options.Type     or "Info"  -- "Info" | "Success" | "Warning" | "Error"
 
	ensureNotifHolder()
 
	local accentColor = Theme.Accent
	if ntype == "Success" then accentColor = Theme.Green
	elseif ntype == "Warning" then accentColor = Theme.Yellow
	elseif ntype == "Error"   then accentColor = Theme.Pink
	end
 
	local card = Instance.new("Frame")
	card.Name                = "Notif"
	card.Size                = UDim2.new(1, 0, 0, 64)
	card.BackgroundColor3    = Theme.BG2
	card.BackgroundTransparency = 0
	card.ClipsDescendants    = true
	card.Parent              = NotifHolder
	addCorner(card, 4)
	addStroke(card, accentColor, 1, 0.4)
 
	-- accent bar left
	local bar = Instance.new("Frame")
	bar.Size              = UDim2.new(0, 3, 1, 0)
	bar.BackgroundColor3  = accentColor
	bar.BorderSizePixel   = 0
	bar.ZIndex            = 2
	bar.Parent            = card
 
	local inner = Instance.new("Frame")
	inner.Size             = UDim2.new(1, -14, 1, 0)
	inner.Position         = UDim2.new(0, 14, 0, 0)
	inner.BackgroundTransparency = 1
	inner.Parent           = card
	addPadding(inner, 8, 8, 6, 6)
 
	local tTitle = label(inner, title, 13, Theme.TextPrimary, Enum.Font.GothamBold)
	tTitle.Position = UDim2.new(0, 0, 0, 0)
	tTitle.Size     = UDim2.new(1, 0, 0, 16)
 
	local tDesc = label(inner, desc, 11, Theme.TextMuted, Enum.Font.Gotham)
	tDesc.Position    = UDim2.new(0, 0, 0, 20)
	tDesc.Size        = UDim2.new(1, 0, 0, 28)
	tDesc.TextWrapped = true
 
	-- progress bar
	local pbg = Instance.new("Frame")
	pbg.Size              = UDim2.new(1, 0, 0, 2)
	pbg.Position          = UDim2.new(0, 0, 1, -2)
	pbg.BackgroundColor3  = Theme.BG3
	pbg.BorderSizePixel   = 0
	pbg.Parent            = card
 
	local pb = Instance.new("Frame")
	pb.Size              = UDim2.new(1, 0, 1, 0)
	pb.BackgroundColor3  = accentColor
	pb.BorderSizePixel   = 0
	pb.Parent            = pbg
 
	-- slide in
	card.Position = UDim2.new(1, 20, 0, 0)
	tween(card, {Position = UDim2.new(0, 0, 0, 0)}, 0.35, Enum.EasingStyle.Back)
 
	-- countdown bar
	tween(pb, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)
 
	task.delay(duration, function()
		tween(card, {Position = UDim2.new(1, 20, 0, 0)}, 0.3)
		task.delay(0.35, function() card:Destroy() end)
	end)
end
 
-- ══════════════════════════════════════════════════════════════════════════
-- CreateWindow
-- ══════════════════════════════════════════════════════════════════════════
function NeonLib:CreateWindow(options)
	options = options or {}
	local winTitle   = options.Title        or "NeonLib"
	local subtitle   = options.Subtitle     or "v3.0"
	local toggleKey  = options.ToggleKey    or Enum.KeyCode.RightShift
	local size       = options.Size         or Vector2.new(460, 560)
 
	-- Root ScreenGui
	local root = Instance.new("ScreenGui")
	root.Name                  = "NeonLib_Root"
	root.ZIndexBehavior        = Enum.ZIndexBehavior.Sibling
	root.ResetOnSpawn          = false
	root.IgnoreGuiInset        = true
	pcall(function() root.Parent = CoreGui end)
	if not root.Parent then root.Parent = LocalPlayer.PlayerGui end
 
	-- Main window frame
	local win = Instance.new("Frame")
	win.Name                = "Window"
	win.Size                = UDim2.new(0, size.X, 0, size.Y)
	win.Position            = UDim2.new(0.5, -size.X/2, 0.5, -size.Y/2)
	win.BackgroundColor3    = Theme.BG
	win.ClipsDescendants    = true
	win.Parent              = root
	addCorner(win, 4)
	addStroke(win, Theme.Border, 1, 0.35)
	addScanline(win)
 
	-- corner bracket decorations (purely cosmetic frames)
	local function makeCornerBracket(anchorX, anchorY, posX, posY)
		local g = Instance.new("Frame")
		g.Size                = UDim2.new(0, 14, 0, 14)
		g.Position            = UDim2.new(anchorX, posX, anchorY, posY)
		g.BackgroundTransparency = 1
		g.ZIndex              = 8
		g.Parent              = win
 
		local top = Instance.new("Frame")
		top.Size              = UDim2.new(1, 0, 0, 2)
		top.BackgroundColor3  = Theme.Accent
		top.BorderSizePixel   = 0
		top.Parent            = g
 
		local side = Instance.new("Frame")
		side.Size             = UDim2.new(0, 2, 1, 0)
		side.AnchorPoint      = Vector2.new(anchorX, 0)
		side.Position         = UDim2.new(anchorX, 0, 0, 0)
		side.BackgroundColor3 = Theme.Accent
		side.BorderSizePixel  = 0
		side.Parent           = g
	end
	makeCornerBracket(0, 0,  0,  0)
	makeCornerBracket(1, 0, -14,  0)
	makeCornerBracket(0, 1,  0, -14)
	makeCornerBracket(1, 1, -14, -14)
 
	-- ── Titlebar ──────────────────────────────────────────────────────────
	local titlebar = Instance.new("Frame")
	titlebar.Name             = "Titlebar"
	titlebar.Size             = UDim2.new(1, 0, 0, 44)
	titlebar.BackgroundColor3 = Theme.BG2
	titlebar.BorderSizePixel  = 0
	titlebar.ZIndex           = 5
	titlebar.Parent           = win
 
	-- bottom accent line on titlebar
	local tbLine = Instance.new("Frame")
	tbLine.Size              = UDim2.new(1, 0, 0, 1)
	tbLine.Position          = UDim2.new(0, 0, 1, -1)
	tbLine.BackgroundColor3  = Theme.Accent
	tbLine.BackgroundTransparency = 0.5
	tbLine.BorderSizePixel   = 0
	tbLine.Parent            = titlebar
 
	-- logo icon
	local logoBox = Instance.new("Frame")
	logoBox.Size             = UDim2.new(0, 28, 0, 28)
	logoBox.Position         = UDim2.new(0, 10, 0.5, -14)
	logoBox.BackgroundColor3 = Theme.BG3
	logoBox.ZIndex           = 6
	logoBox.Parent           = titlebar
	addCorner(logoBox, 4)
	addStroke(logoBox, Theme.Accent, 1, 0.3)
 
	local logoText = Instance.new("TextLabel")
	logoText.Text                = "⬡"
	logoText.Size                = UDim2.new(1, 0, 1, 0)
	logoText.BackgroundTransparency = 1
	logoText.TextColor3          = Theme.Accent
	logoText.Font                = Enum.Font.GothamBold
	logoText.TextSize            = 14
	logoText.ZIndex              = 7
	logoText.Parent              = logoBox
 
	-- title text
	local titleLbl = Instance.new("TextLabel")
	titleLbl.Text              = winTitle:upper()
	titleLbl.Size              = UDim2.new(0, 160, 0, 18)
	titleLbl.Position          = UDim2.new(0, 46, 0, 6)
	titleLbl.BackgroundTransparency = 1
	titleLbl.TextColor3        = Theme.Accent
	titleLbl.Font              = Enum.Font.GothamBold
	titleLbl.TextSize          = 14
	titleLbl.TextXAlignment    = Enum.TextXAlignment.Left
	titleLbl.ZIndex            = 6
	titleLbl.Parent            = titlebar
 
	local subLbl = Instance.new("TextLabel")
	subLbl.Text                = subtitle:upper()
	subLbl.Size                = UDim2.new(0, 160, 0, 12)
	subLbl.Position            = UDim2.new(0, 46, 0, 26)
	subLbl.BackgroundTransparency = 1
	subLbl.TextColor3          = Theme.TextDim
	subLbl.Font                = Enum.Font.Gotham
	subLbl.TextSize            = 10
	subLbl.TextXAlignment      = Enum.TextXAlignment.Left
	subLbl.ZIndex              = 6
	subLbl.Parent              = titlebar
 
	-- ── Search pill (collapses to icon) ───────────────────────────────────
	local searchFrame = Instance.new("Frame")
	searchFrame.Name            = "SearchPill"
	searchFrame.Size            = UDim2.new(0, 30, 0, 26)
	searchFrame.Position        = UDim2.new(1, -245, 0.5, -13)
	searchFrame.BackgroundColor3= Theme.BG3
	searchFrame.ClipsDescendants= true
	searchFrame.ZIndex          = 6
	searchFrame.Parent          = titlebar
	addCorner(searchFrame, 3)
	addStroke(searchFrame, Theme.BorderDim, 1, 0.3)
 
	local searchIcon = Instance.new("TextButton")
	searchIcon.Text              = "⌕"
	searchIcon.Size              = UDim2.new(0, 28, 1, 0)
	searchIcon.BackgroundTransparency = 1
	searchIcon.TextColor3        = Theme.Accent
	searchIcon.Font              = Enum.Font.GothamBold
	searchIcon.TextSize          = 16
	searchIcon.ZIndex            = 7
	searchIcon.Parent            = searchFrame
 
	local searchBox = Instance.new("TextBox")
	searchBox.PlaceholderText    = "search..."
	searchBox.Text               = ""
	searchBox.Size               = UDim2.new(1, -32, 1, 0)
	searchBox.Position           = UDim2.new(0, 28, 0, 0)
	searchBox.BackgroundTransparency = 1
	searchBox.TextColor3         = Theme.TextPrimary
	searchBox.PlaceholderColor3  = Theme.TextDim
	searchBox.Font               = Enum.Font.Gotham
	searchBox.TextSize           = 11
	searchBox.TextXAlignment     = Enum.TextXAlignment.Left
	searchBox.ClearTextOnFocus   = false
	searchBox.ZIndex             = 7
	searchBox.Parent             = searchFrame
 
	local searchOpen = false
	local function toggleSearch()
		searchOpen = not searchOpen
		if searchOpen then
			tween(searchFrame, {Size = UDim2.new(0, 160, 0, 26)}, 0.25, Enum.EasingStyle.Back)
			task.delay(0.15, function() searchBox:CaptureFocus() end)
		else
			searchBox.Text = ""
			tween(searchFrame, {Size = UDim2.new(0, 30, 0, 26)}, 0.2)
		end
	end
	searchIcon.MouseButton1Click:Connect(toggleSearch)
	searchBox.FocusLost:Connect(function()
		if searchBox.Text == "" then
			task.delay(0.1, function()
				searchOpen = false
				tween(searchFrame, {Size = UDim2.new(0, 30, 0, 26)}, 0.2)
			end)
		end
	end)
 
	-- ── Quick buttons (yellow bell, cyan minus, red X) ─────────────────────
	local function makeQBtn(icon, color, xOffset, onClick)
		local btn = Instance.new("TextButton")
		btn.Text              = icon
		btn.Size              = UDim2.new(0, 26, 0, 26)
		btn.Position          = UDim2.new(1, xOffset, 0.5, -13)
		btn.BackgroundColor3  = Theme.BG3
		btn.BackgroundTransparency = 0.6
		btn.TextColor3        = color
		btn.Font              = Enum.Font.GothamBold
		btn.TextSize          = 13
		btn.ZIndex            = 6
		btn.Parent            = titlebar
		addCorner(btn, 3)
		addStroke(btn, color, 1, 0.5)
 
		btn.MouseEnter:Connect(function()
			tween(btn, {BackgroundTransparency = 0.3}, 0.1)
		end)
		btn.MouseLeave:Connect(function()
			tween(btn, {BackgroundTransparency = 0.6}, 0.1)
		end)
		btn.MouseButton1Click:Connect(onClick)
		return btn
	end
 
	-- close (red)
	makeQBtn("✕", Theme.Pink, -10, function()
		tween(win, {Position = UDim2.new(0.5, -size.X/2, 1, 20)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		task.delay(0.4, function() win.Visible = false end)
	end)
 
	-- minimize (cyan)
	local minimized = false
	local bodyFrame -- declared below, referenced here
	makeQBtn("—", Theme.Accent, -40, function()
		minimized = not minimized
		if bodyFrame then
			tween(bodyFrame, {Size = minimized
				and UDim2.new(1, 0, 0, 0)
				or  UDim2.new(1, 0, 1, -100)
			}, 0.25)
		end
	end)
 
	-- notification bell (yellow)
	makeQBtn("🔔", Theme.Yellow, -70, function()
		NeonLib:Notify({Title="Notifications", Content="All caught up!", Duration=3})
	end)
 
	-- ── Drag titlebar ──────────────────────────────────────────────────────
	local dragging, dragStart, startPos
	titlebar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging  = true
			dragStart = input.Position
			startPos  = win.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			win.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
 
	-- ── Tab bar ────────────────────────────────────────────────────────────
	local tabBar = Instance.new("Frame")
	tabBar.Name             = "TabBar"
	tabBar.Size             = UDim2.new(1, 0, 0, 36)
	tabBar.Position         = UDim2.new(0, 0, 0, 44)
	tabBar.BackgroundColor3 = Theme.BG2
	tabBar.BorderSizePixel  = 0
	tabBar.ZIndex           = 5
	tabBar.Parent           = win
 
	local tabBarLine = Instance.new("Frame")
	tabBarLine.Size             = UDim2.new(1, 0, 0, 1)
	tabBarLine.Position         = UDim2.new(0, 0, 1, -1)
	tabBarLine.BackgroundColor3 = Theme.BorderDim
	tabBarLine.BorderSizePixel  = 0
	tabBarLine.Parent           = tabBar
 
	local tabLayout = Instance.new("UIListLayout")
	tabLayout.FillDirection     = Enum.FillDirection.Horizontal
	tabLayout.SortOrder         = Enum.SortOrder.LayoutOrder
	tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	tabLayout.Padding           = UDim.new(0, 2)
	tabLayout.Parent            = tabBar
 
	local tabPad = Instance.new("UIPadding")
	tabPad.PaddingLeft = UDim.new(0, 8)
	tabPad.Parent      = tabBar
 
	-- ── Body (scrollable content area) ────────────────────────────────────
	bodyFrame = Instance.new("Frame")
	bodyFrame.Name             = "Body"
	bodyFrame.Size             = UDim2.new(1, 0, 1, -100)
	bodyFrame.Position         = UDim2.new(0, 0, 0, 80)  -- 44 titlebar + 36 tabs
	bodyFrame.BackgroundTransparency = 1
	bodyFrame.ClipsDescendants = true
	bodyFrame.Parent           = win
 
	-- ── Status bar ─────────────────────────────────────────────────────────
	local statusBar = Instance.new("Frame")
	statusBar.Size             = UDim2.new(1, 0, 0, 20)
	statusBar.Position         = UDim2.new(0, 0, 1, -20)
	statusBar.BackgroundColor3 = Theme.BG2
	statusBar.BorderSizePixel  = 0
	statusBar.ZIndex           = 5
	statusBar.Parent           = win
 
	local statusLine = Instance.new("Frame")
	statusLine.Size            = UDim2.new(1, 0, 0, 1)
	statusLine.BackgroundColor3= Theme.BorderDim
	statusLine.BorderSizePixel = 0
	statusLine.Parent          = statusBar
 
	local statusDot = Instance.new("Frame")
	statusDot.Size             = UDim2.new(0, 6, 0, 6)
	statusDot.Position         = UDim2.new(0, 10, 0.5, -3)
	statusDot.BackgroundColor3 = Theme.Accent
	statusDot.BorderSizePixel  = 0
	statusDot.Parent           = statusBar
	addCorner(statusDot, 10)
 
	local statusLbl = Instance.new("TextLabel")
	statusLbl.Text             = "SYSTEM ONLINE"
	statusLbl.Size             = UDim2.new(0.5, 0, 1, 0)
	statusLbl.Position         = UDim2.new(0, 22, 0, 0)
	statusLbl.BackgroundTransparency = 1
	statusLbl.TextColor3       = Theme.TextDim
	statusLbl.Font             = Enum.Font.Gotham
	statusLbl.TextSize         = 10
	statusLbl.TextXAlignment   = Enum.TextXAlignment.Left
	statusLbl.ZIndex           = 6
	statusLbl.Parent           = statusBar
 
	local creditLbl = Instance.new("TextLabel")
	creditLbl.Text             = "NEONLIB · MIT"
	creditLbl.Size             = UDim2.new(0.5, -10, 1, 0)
	creditLbl.Position         = UDim2.new(0.5, 0, 0, 0)
	creditLbl.BackgroundTransparency = 1
	creditLbl.TextColor3       = Theme.TextDim
	creditLbl.Font             = Enum.Font.Gotham
	creditLbl.TextSize         = 10
	creditLbl.TextXAlignment   = Enum.TextXAlignment.Right
	creditLbl.ZIndex           = 6
	creditLbl.Parent           = statusBar
 
	-- ── Keybind toggle ─────────────────────────────────────────────────────
	UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		if input.KeyCode == toggleKey then
			win.Visible = not win.Visible
			if win.Visible then
				win.Position = UDim2.new(0.5, -size.X/2, 0.5, -size.Y/2 - 20)
				tween(win, {Position = UDim2.new(0.5, -size.X/2, 0.5, -size.Y/2)}, 0.3, Enum.EasingStyle.Back)
			end
		end
	end)
 
	-- ── Tab container & search wiring ──────────────────────────────────────
	local tabs          = {}
	local activeTab     = nil
	local allRows       = {}  -- {frame, keywords}
 
	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local q = searchBox.Text:lower()
		for _, entry in ipairs(allRows) do
			local visible = q == "" or entry.keywords:lower():find(q, 1, true)
			entry.frame.Visible = visible ~= nil
		end
	end)
 
	-- ── Window object ──────────────────────────────────────────────────────
	local Window = {}
	Window.__index = Window
 
	function Window:SetStatus(text)
		statusLbl.Text = text:upper()
	end
 
	function Window:SetAccent(color)
		Theme.Accent = color
		tbLine.BackgroundColor3    = color
		statusDot.BackgroundColor3 = color
		titleLbl.TextColor3        = color
		logoText.TextColor3        = color
	end
 
	-- ── AddTab ─────────────────────────────────────────────────────────────
	function Window:AddTab(tabOptions)
		tabOptions = tabOptions or {}
		local tabName = tabOptions.Title or ("Tab "..tostring(#tabs+1))
		local tabIcon = tabOptions.Icon  or ""  -- Roblox image asset id string, optional
 
		-- tab button
		local tabBtn = Instance.new("TextButton")
		tabBtn.Text              = tabIcon ~= "" and (tabIcon.." "..tabName) or tabName
		tabBtn.Size              = UDim2.new(0, 0, 1, 0)
		tabBtn.AutomaticSize     = Enum.AutomaticSize.X
		tabBtn.BackgroundTransparency = 1
		tabBtn.TextColor3        = Theme.TextDim
		tabBtn.Font              = Enum.Font.Gotham
		tabBtn.TextSize          = 12
		tabBtn.LayoutOrder       = #tabs + 1
		tabBtn.ZIndex            = 6
		tabBtn.Parent            = tabBar
		addPadding(tabBtn, 0, 4, 8, 8)
 
		-- active underline
		local underline = Instance.new("Frame")
		underline.Size            = UDim2.new(1, 0, 0, 2)
		underline.Position        = UDim2.new(0, 0, 1, -2)
		underline.BackgroundColor3= Theme.Accent
		underline.BackgroundTransparency = 1
		underline.BorderSizePixel = 0
		underline.Parent          = tabBtn
 
		-- scroll frame for content
		local scroll = Instance.new("ScrollingFrame")
		scroll.Name                    = "Tab_"..tabName
		scroll.Size                    = UDim2.new(1, 0, 1, 0)
		scroll.BackgroundTransparency  = 1
		scroll.BorderSizePixel         = 0
		scroll.ScrollBarThickness      = 3
		scroll.ScrollBarImageColor3    = Theme.Accent
		scroll.CanvasSize              = UDim2.new(0, 0, 0, 0)
		scroll.AutomaticCanvasSize     = Enum.AutomaticSize.Y
		scroll.Visible                 = false
		scroll.ZIndex                  = 4
		scroll.Parent                  = bodyFrame
 
		local layout = Instance.new("UIListLayout")
		layout.SortOrder   = Enum.SortOrder.LayoutOrder
		layout.Padding     = UDim.new(0, 6)
		layout.Parent      = scroll
 
		local scrollPad = Instance.new("UIPadding")
		scrollPad.PaddingTop    = UDim.new(0, 10)
		scrollPad.PaddingBottom = UDim.new(0, 10)
		scrollPad.PaddingLeft   = UDim.new(0, 10)
		scrollPad.PaddingRight  = UDim.new(0, 10)
		scrollPad.Parent        = scroll
 
		local tabData = {btn = tabBtn, scroll = scroll, underline = underline}
		table.insert(tabs, tabData)
 
		local function activate()
			-- deactivate all
			for _, t in ipairs(tabs) do
				t.btn.TextColor3 = Theme.TextDim
				tween(t.underline, {BackgroundTransparency = 1}, 0.15)
				t.scroll.Visible = false
			end
			-- activate this
			tabBtn.TextColor3 = Theme.Accent
			tween(underline, {BackgroundTransparency = 0}, 0.15)
			scroll.Visible = true
			activeTab = tabData
		end
 
		tabBtn.MouseButton1Click:Connect(activate)
 
		if #tabs == 1 then
			activate()
		end
 
		-- ── Section label ──────────────────────────────────────────────────
		local Tab = {}
		Tab.__index = Tab
		local rowOrder = 0
 
		local function nextOrder()
			rowOrder = rowOrder + 1
			return rowOrder
		end
 
		function Tab:AddSection(sectionOptions)
			sectionOptions = sectionOptions or {}
			local sName = sectionOptions.Title or "Section"
 
			local sFrame = Instance.new("Frame")
			sFrame.Size              = UDim2.new(1, 0, 0, 18)
			sFrame.BackgroundTransparency = 1
			sFrame.LayoutOrder       = nextOrder()
			sFrame.Parent            = scroll
 
			local sLbl = Instance.new("TextLabel")
			sLbl.Text              = sName:upper()
			sLbl.Size              = UDim2.new(0.6, 0, 1, 0)
			sLbl.BackgroundTransparency = 1
			sLbl.TextColor3        = Theme.TextDim
			sLbl.Font              = Enum.Font.Gotham
			sLbl.TextSize          = 9
			sLbl.TextXAlignment    = Enum.TextXAlignment.Left
			sLbl.LetterSpacing     = 4
			sLbl.Parent            = sFrame
 
			local sLine = Instance.new("Frame")
			sLine.Size             = UDim2.new(0.35, 0, 0, 1)
			sLine.Position         = UDim2.new(0.63, 0, 0.5, 0)
			sLine.BackgroundColor3 = Theme.BorderDim
			sLine.BorderSizePixel  = 0
			sLine.Parent           = sFrame
		end
 
		-- ── Row base frame ─────────────────────────────────────────────────
		local function makeRow(keywords)
			local row = Instance.new("Frame")
			row.Size             = UDim2.new(1, 0, 0, 46)
			row.BackgroundColor3 = Theme.BG2
			row.LayoutOrder      = nextOrder()
			row.Parent           = scroll
			addCorner(row, 3)
			addStroke(row, Theme.BorderDim, 1, 0.5)
 
			-- left accent bar (appears on hover)
			local accent = Instance.new("Frame")
			accent.Size              = UDim2.new(0, 3, 1, 0)
			accent.BackgroundColor3  = Theme.Accent
			accent.BackgroundTransparency = 1
			accent.BorderSizePixel   = 0
			accent.ZIndex            = 3
			accent.Parent            = row
 
			row.MouseEnter:Connect(function()
				tween(row,    {BackgroundColor3 = Theme.BG3}, 0.12)
				tween(accent, {BackgroundTransparency = 0},   0.12)
			end)
			row.MouseLeave:Connect(function()
				tween(row,    {BackgroundColor3 = Theme.BG2}, 0.12)
				tween(accent, {BackgroundTransparency = 1},   0.12)
			end)
 
			table.insert(allRows, {frame = row, keywords = keywords or ""})
			return row
		end
 
		-- label + desc helper inside a row
		local function rowLabels(parent, title, desc)
			local titleL = Instance.new("TextLabel")
			titleL.Text             = title
			titleL.Size             = UDim2.new(0.65, 0, 0, 16)
			titleL.Position         = UDim2.new(0, 12, 0, 8)
			titleL.BackgroundTransparency = 1
			titleL.TextColor3       = Theme.TextPrimary
			titleL.Font             = Enum.Font.GothamMedium
			titleL.TextSize         = 13
			titleL.TextXAlignment   = Enum.TextXAlignment.Left
			titleL.ZIndex           = 3
			titleL.Parent           = parent
 
			local descL = Instance.new("TextLabel")
			descL.Text              = "// "..desc
			descL.Size              = UDim2.new(0.65, 0, 0, 12)
			descL.Position          = UDim2.new(0, 12, 0, 26)
			descL.BackgroundTransparency = 1
			descL.TextColor3        = Theme.TextDim
			descL.Font              = Enum.Font.Gotham
			descL.TextSize          = 10
			descL.TextXAlignment    = Enum.TextXAlignment.Left
			descL.ZIndex            = 3
			descL.Parent            = parent
		end
 
		-- ══════════════════════════════════════════════════════════════════
		-- AddToggle
		-- ══════════════════════════════════════════════════════════════════
		function Tab:AddToggle(toggleOptions)
			toggleOptions = toggleOptions or {}
			local tTitle   = toggleOptions.Title    or "Toggle"
			local tDesc    = toggleOptions.Desc     or ""
			local default  = toggleOptions.Default  ~= false
			local callback = toggleOptions.Callback or function() end
 
			local row = makeRow(tTitle.." "..tDesc)
			rowLabels(row, tTitle, tDesc)
 
			local togBg = Instance.new("Frame")
			togBg.Size             = UDim2.new(0, 38, 0, 20)
			togBg.Position         = UDim2.new(1, -50, 0.5, -10)
			togBg.BackgroundColor3 = default and Theme.BG3 or Theme.BG3
			togBg.ZIndex           = 3
			togBg.Parent           = row
			addCorner(togBg, 3)
			addStroke(togBg, default and Theme.Accent or Theme.BorderDim, 1, default and 0.3 or 0.6)
 
			local togKnob = Instance.new("Frame")
			togKnob.Size             = UDim2.new(0, 12, 0, 12)
			togKnob.Position         = default
				and UDim2.new(0, 22, 0.5, -6)
				or  UDim2.new(0, 4,  0.5, -6)
			togKnob.BackgroundColor3 = default and Theme.Accent or Theme.TextDim
			togKnob.ZIndex           = 4
			togKnob.Parent           = togBg
			addCorner(togKnob, 2)
 
			local state = default
			callback(state)
 
			local togBtn = Instance.new("TextButton")
			togBtn.Size              = UDim2.new(1, 0, 1, 0)
			togBtn.BackgroundTransparency = 1
			togBtn.Text              = ""
			togBtn.ZIndex            = 5
			togBtn.Parent            = togBg
 
			togBtn.MouseButton1Click:Connect(function()
				state = not state
				tween(togKnob, {
					Position         = state and UDim2.new(0, 22, 0.5, -6) or UDim2.new(0, 4, 0.5, -6),
					BackgroundColor3 = state and Theme.Accent or Theme.TextDim
				}, 0.2, Enum.EasingStyle.Back)
				addStroke(togBg, state and Theme.Accent or Theme.BorderDim, 1, state and 0.3 or 0.6)
				callback(state)
			end)
 
			local API = {}
			function API:Set(v)
				state = v
				togKnob.Position         = v and UDim2.new(0, 22, 0.5, -6) or UDim2.new(0, 4, 0.5, -6)
				togKnob.BackgroundColor3 = v and Theme.Accent or Theme.TextDim
				callback(state)
			end
			function API:Get() return state end
			return API
		end
 
		-- ══════════════════════════════════════════════════════════════════
		-- AddSlider
		-- ══════════════════════════════════════════════════════════════════
		function Tab:AddSlider(sliderOptions)
			sliderOptions = sliderOptions or {}
			local sTitle   = sliderOptions.Title    or "Slider"
			local sDesc    = sliderOptions.Desc     or ""
			local min      = sliderOptions.Min      or 0
			local max      = sliderOptions.Max      or 100
			local default  = sliderOptions.Default  or min
			local suffix   = sliderOptions.Suffix   or ""
			local callback = sliderOptions.Callback or function() end
 
			local row = makeRow(sTitle.." "..sDesc)
			row.Size = UDim2.new(1, 0, 0, 58)
			rowLabels(row, sTitle, sDesc)
 
			local valLbl = Instance.new("TextLabel")
			valLbl.Text            = tostring(default)..suffix
			valLbl.Size            = UDim2.new(0, 60, 0, 16)
			valLbl.Position        = UDim2.new(1, -70, 0, 8)
			valLbl.BackgroundTransparency = 1
			valLbl.TextColor3      = Theme.Accent
			valLbl.Font            = Enum.Font.GothamBold
			valLbl.TextSize        = 12
			valLbl.TextXAlignment  = Enum.TextXAlignment.Right
			valLbl.ZIndex          = 3
			valLbl.Parent          = row
 
			local trackBg = Instance.new("Frame")
			trackBg.Size           = UDim2.new(1, -24, 0, 3)
			trackBg.Position       = UDim2.new(0, 12, 0, 46)
			trackBg.BackgroundColor3 = Theme.BG3
			trackBg.BorderSizePixel  = 0
			trackBg.ZIndex         = 3
			trackBg.Parent         = row
 
			local trackFill = Instance.new("Frame")
			trackFill.Size           = UDim2.new((default-min)/(max-min), 0, 1, 0)
			trackFill.BackgroundColor3 = Theme.Accent
			trackFill.BorderSizePixel  = 0
			trackFill.ZIndex         = 4
			trackFill.Parent         = trackBg
 
			local knob = Instance.new("Frame")
			knob.Size              = UDim2.new(0, 10, 0, 10)
			knob.AnchorPoint       = Vector2.new(0.5, 0.5)
			knob.Position          = UDim2.new((default-min)/(max-min), 0, 0.5, 0)
			knob.BackgroundColor3  = Theme.Accent
			knob.ZIndex            = 5
			knob.Parent            = trackBg
			addCorner(knob, 2)
 
			local value = default
			local function setValue(v)
				v = math.clamp(math.round(v), min, max)
				value = v
				local pct = (v - min) / (max - min)
				tween(trackFill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.08)
				tween(knob,      {Position = UDim2.new(pct, 0, 0.5, 0)}, 0.08)
				valLbl.Text = tostring(v)..suffix
				callback(v)
			end
 
			local sliding = false
			trackBg.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					sliding = true
				end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					sliding = false
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
					local rel = (input.Position.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X
					setValue(min + rel * (max - min))
				end
			end)
 
			local API = {}
			function API:Set(v) setValue(v) end
			function API:Get() return value end
			return API
		end
 
		-- ══════════════════════════════════════════════════════════════════
		-- AddButton
		-- ══════════════════════════════════════════════════════════════════
		function Tab:AddButton(btnOptions)
			btnOptions = btnOptions or {}
			local bTitle   = btnOptions.Title    or "Button"
			local bDesc    = btnOptions.Desc     or ""
			local bStyle   = btnOptions.Style    or "Primary" -- "Primary"|"Danger"|"Ghost"
			local callback = btnOptions.Callback or function() end
 
			local row = makeRow(bTitle.." "..bDesc)
 
			local accentCol = Theme.Accent
			if bStyle == "Danger" then accentCol = Theme.Pink
			elseif bStyle == "Ghost" then accentCol = Theme.TextDim
			end
 
			local btn = Instance.new("TextButton")
			btn.Text              = bTitle:upper()
			btn.Size              = UDim2.new(1, -24, 0, 28)
			btn.Position          = UDim2.new(0, 12, 0.5, -14)
			btn.BackgroundColor3  = Theme.BG3
			btn.TextColor3        = accentCol
			btn.Font              = Enum.Font.GothamBold
			btn.TextSize          = 12
			btn.ZIndex            = 3
			btn.Parent            = row
			addCorner(btn, 3)
			addStroke(btn, accentCol, 1, 0.4)
 
			btn.MouseEnter:Connect(function()
				tween(btn, {BackgroundColor3 = Color3.new(
					accentCol.R*0.12, accentCol.G*0.12, accentCol.B*0.12
				)}, 0.1)
			end)
			btn.MouseLeave:Connect(function()
				tween(btn, {BackgroundColor3 = Theme.BG3}, 0.1)
			end)
			btn.MouseButton1Click:Connect(function()
				tween(btn, {TextTransparency = 0.4}, 0.05)
				task.delay(0.1, function()
					tween(btn, {TextTransparency = 0}, 0.1)
				end)
				callback()
			end)
		end
 
		-- ══════════════════════════════════════════════════════════════════
		-- AddDropdown
		-- ══════════════════════════════════════════════════════════════════
		function Tab:AddDropdown(ddOptions)
			ddOptions = ddOptions or {}
			local dTitle   = ddOptions.Title    or "Dropdown"
			local dDesc    = ddOptions.Desc     or ""
			local items    = ddOptions.Items    or {}
			local default  = ddOptions.Default  or items[1]
			local callback = ddOptions.Callback or function() end
 
			local row = makeRow(dTitle.." "..dDesc)
			rowLabels(row, dTitle, dDesc)
 
			local selBtn = Instance.new("TextButton")
			selBtn.Text            = default or "Select..."
			selBtn.Size            = UDim2.new(0, 110, 0, 22)
			selBtn.Position        = UDim2.new(1, -122, 0.5, -11)
			selBtn.BackgroundColor3= Theme.BG3
			selBtn.TextColor3      = Theme.Accent
			selBtn.Font            = Enum.Font.Gotham
			selBtn.TextSize        = 11
			selBtn.ZIndex          = 3
			selBtn.Parent          = row
			addCorner(selBtn, 3)
			addStroke(selBtn, Theme.BorderDim, 1, 0.4)
 
			-- dropdown list (appears below row)
			local listFrame = Instance.new("Frame")
			listFrame.Size             = UDim2.new(0, 110, 0, 0)
			listFrame.Position         = UDim2.new(1, -122, 1, 2)
			listFrame.BackgroundColor3 = Theme.BG2
			listFrame.ZIndex           = 20
			listFrame.ClipsDescendants = true
			listFrame.Visible          = false
			listFrame.Parent           = row
			addCorner(listFrame, 3)
			addStroke(listFrame, Theme.Accent, 1, 0.4)
 
			local listLayout = Instance.new("UIListLayout")
			listLayout.SortOrder = Enum.SortOrder.LayoutOrder
			listLayout.Parent    = listFrame
 
			local selected = default
			local open     = false
 
			for _, item in ipairs(items) do
				local itemBtn = Instance.new("TextButton")
				itemBtn.Text            = item
				itemBtn.Size            = UDim2.new(1, 0, 0, 26)
				itemBtn.BackgroundTransparency = 1
				itemBtn.TextColor3      = Theme.TextPrimary
				itemBtn.Font            = Enum.Font.Gotham
				itemBtn.TextSize        = 11
				itemBtn.ZIndex          = 21
				itemBtn.Parent          = listFrame
 
				itemBtn.MouseEnter:Connect(function()
					tween(itemBtn, {BackgroundTransparency = 0.7, BackgroundColor3 = Theme.Accent}, 0.1)
				end)
				itemBtn.MouseLeave:Connect(function()
					tween(itemBtn, {BackgroundTransparency = 1}, 0.1)
				end)
				itemBtn.MouseButton1Click:Connect(function()
					selected = item
					selBtn.Text = item
					open = false
					tween(listFrame, {Size = UDim2.new(0, 110, 0, 0)}, 0.2)
					task.delay(0.2, function() listFrame.Visible = false end)
					callback(selected)
				end)
			end
 
			selBtn.MouseButton1Click:Connect(function()
				open = not open
				listFrame.Visible = open
				if open then
					tween(listFrame, {Size = UDim2.new(0, 110, 0, #items * 26)}, 0.2, Enum.EasingStyle.Back)
				else
					tween(listFrame, {Size = UDim2.new(0, 110, 0, 0)}, 0.15)
					task.delay(0.15, function() listFrame.Visible = false end)
				end
			end)
 
			local API = {}
			function API:Set(v) selected = v selBtn.Text = v callback(v) end
			function API:Get() return selected end
			return API
		end
 
		-- ══════════════════════════════════════════════════════════════════
		-- AddTextBox
		-- ══════════════════════════════════════════════════════════════════
		function Tab:AddTextBox(tbOptions)
			tbOptions = tbOptions or {}
			local tTitle    = tbOptions.Title       or "Text Input"
			local tDesc     = tbOptions.Desc        or ""
			local tPlaceholder = tbOptions.Placeholder or "Type here..."
			local callback  = tbOptions.Callback    or function() end
 
			local row = makeRow(tTitle.." "..tDesc)
			row.Size = UDim2.new(1, 0, 0, 62)
			rowLabels(row, tTitle, tDesc)
 
			local box = Instance.new("TextBox")
			box.PlaceholderText     = tPlaceholder
			box.Text                = ""
			box.Size                = UDim2.new(1, -24, 0, 24)
			box.Position            = UDim2.new(0, 12, 0, 34)
			box.BackgroundColor3    = Theme.BG3
			box.TextColor3          = Theme.TextPrimary
			box.PlaceholderColor3   = Theme.TextDim
			box.Font                = Enum.Font.Gotham
			box.TextSize            = 12
			box.TextXAlignment      = Enum.TextXAlignment.Left
			box.ClearTextOnFocus    = false
			box.ZIndex              = 3
			box.Parent              = row
			addCorner(box, 3)
			local boxStroke = addStroke(box, Theme.BorderDim, 1, 0.4)
			addPadding(box, 0, 0, 8, 8)
 
			box.Focused:Connect(function()
				boxStroke.Color        = Theme.Accent
				boxStroke.Transparency = 0.2
			end)
			box.FocusLost:Connect(function(enter)
				boxStroke.Color        = Theme.BorderDim
				boxStroke.Transparency = 0.4
				if enter then callback(box.Text) end
			end)
 
			local API = {}
			function API:Set(v) box.Text = v end
			function API:Get() return box.Text end
			return API
		end
 
		-- ══════════════════════════════════════════════════════════════════
		-- AddKeybind
		-- ══════════════════════════════════════════════════════════════════
		function Tab:AddKeybind(kbOptions)
			kbOptions = kbOptions or {}
			local kTitle   = kbOptions.Title    or "Keybind"
			local kDesc    = kbOptions.Desc     or ""
			local default  = kbOptions.Default  or Enum.KeyCode.E
			local callback = kbOptions.Callback or function() end
 
			local row = makeRow(kTitle.." "..kDesc)
			rowLabels(row, kTitle, kDesc)
 
			local kbBtn = Instance.new("TextButton")
			kbBtn.Text            = default.Name
			kbBtn.Size            = UDim2.new(0, 80, 0, 22)
			kbBtn.Position        = UDim2.new(1, -92, 0.5, -11)
			kbBtn.BackgroundColor3= Theme.BG3
			kbBtn.TextColor3      = Theme.Accent
			kbBtn.Font            = Enum.Font.GothamBold
			kbBtn.TextSize        = 11
			kbBtn.ZIndex          = 3
			kbBtn.Parent          = row
			addCorner(kbBtn, 3)
			addStroke(kbBtn, Theme.Accent, 1, 0.4)
 
			local listening = false
			local boundKey  = default
 
			kbBtn.MouseButton1Click:Connect(function()
				listening = true
				kbBtn.Text      = "..."
				kbBtn.TextColor3= Theme.Pink
				addStroke(kbBtn, Theme.Pink, 1, 0.2)
			end)
 
			UserInputService.InputBegan:Connect(function(input, processed)
				if not listening then return end
				if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
				listening = false
				boundKey = input.KeyCode
				kbBtn.Text       = input.KeyCode.Name
				kbBtn.TextColor3 = Theme.Accent
				addStroke(kbBtn, Theme.Accent, 1, 0.4)
				callback(boundKey)
			end)
 
			-- listen for the bound key globally
			UserInputService.InputBegan:Connect(function(input, processed)
				if processed then return end
				if input.KeyCode == boundKey then
					callback(boundKey)
				end
			end)
 
			local API = {}
			function API:Set(kc) boundKey = kc kbBtn.Text = kc.Name callback(kc) end
			function API:Get() return boundKey end
			return API
		end
 
		-- ══════════════════════════════════════════════════════════════════
		-- AddColorPicker (simple swatch grid)
		-- ══════════════════════════════════════════════════════════════════
		function Tab:AddColorPicker(cpOptions)
			cpOptions = cpOptions or {}
			local cTitle   = cpOptions.Title    or "Color"
			local cDesc    = cpOptions.Desc     or ""
			local default  = cpOptions.Default  or Theme.Accent
			local callback = cpOptions.Callback or function() end
 
			local row = makeRow(cTitle.." "..cDesc)
			row.Size = UDim2.new(1, 0, 0, 56)
			rowLabels(row, cTitle, cDesc)
 
			local presets = {
				Color3.fromRGB(0,255,231),
				Color3.fromRGB(255,45,120),
				Color3.fromRGB(179,71,255),
				Color3.fromRGB(255,224,0),
				Color3.fromRGB(0,255,159),
				Color3.fromRGB(255,100,0),
			}
 
			local selectedColor = default
			local swatchHolder  = Instance.new("Frame")
			swatchHolder.Size   = UDim2.new(1, -24, 0, 18)
			swatchHolder.Position = UDim2.new(0, 12, 0, 34)
			swatchHolder.BackgroundTransparency = 1
			swatchHolder.ZIndex = 3
			swatchHolder.Parent = row
 
			local swLayout = Instance.new("UIListLayout")
			swLayout.FillDirection = Enum.FillDirection.Horizontal
			swLayout.Padding       = UDim.new(0, 5)
			swLayout.Parent        = swatchHolder
 
			for _, col in ipairs(presets) do
				local sw = Instance.new("TextButton")
				sw.Size             = UDim2.new(0, 18, 0, 18)
				sw.BackgroundColor3 = col
				sw.Text             = ""
				sw.ZIndex           = 4
				sw.Parent           = swatchHolder
				addCorner(sw, 3)
 
				sw.MouseButton1Click:Connect(function()
					selectedColor = col
					callback(col)
					NeonLib:Notify({Title=cTitle, Content="Color updated", Duration=2})
				end)
			end
 
			-- preview swatch
			local preview = Instance.new("Frame")
			preview.Size            = UDim2.new(0, 18, 0, 18)
			preview.BackgroundColor3= default
			preview.ZIndex          = 4
			preview.Parent          = swatchHolder
			addCorner(preview, 3)
			addStroke(preview, Color3.new(1,1,1), 1, 0.6)
 
			local API = {}
			function API:Set(c) selectedColor = c preview.BackgroundColor3 = c callback(c) end
			function API:Get() return selectedColor end
			return API
		end
 
		-- ══════════════════════════════════════════════════════════════════
		-- AddLabel (informational / status text)
		-- ══════════════════════════════════════════════════════════════════
		function Tab:AddLabel(labelOptions)
			labelOptions = labelOptions or {}
			local lText  = labelOptions.Text  or ""
			local lColor = labelOptions.Color or Theme.TextMuted
 
			local row = makeRow(lText)
			row.Size = UDim2.new(1, 0, 0, 36)
 
			local lbl = Instance.new("TextLabel")
			lbl.Text             = lText
			lbl.Size             = UDim2.new(1, -24, 1, 0)
			lbl.Position         = UDim2.new(0, 12, 0, 0)
			lbl.BackgroundTransparency = 1
			lbl.TextColor3       = lColor
			lbl.Font             = Enum.Font.Gotham
			lbl.TextSize         = 12
			lbl.TextXAlignment   = Enum.TextXAlignment.Left
			lbl.TextWrapped      = true
			lbl.ZIndex           = 3
			lbl.Parent           = row
 
			local API = {}
			function API:Set(t, c) lbl.Text = t if c then lbl.TextColor3 = c end end
			function API:Get() return lbl.Text end
			return API
		end
 
		-- ══════════════════════════════════════════════════════════════════
		-- AddProgressBar
		-- ══════════════════════════════════════════════════════════════════
		function Tab:AddProgressBar(pbOptions)
			pbOptions  = pbOptions  or {}
			local pTitle    = pbOptions.Title    or "Progress"
			local pDesc     = pbOptions.Desc     or ""
			local default   = pbOptions.Default  or 0  -- 0-100
			local suffix    = pbOptions.Suffix   or "%"
			local barColor  = pbOptions.Color    or Theme.Accent
 
			local row = makeRow(pTitle.." "..pDesc)
			row.Size = UDim2.new(1, 0, 0, 56)
			rowLabels(row, pTitle, pDesc)
 
			local valL = Instance.new("TextLabel")
			valL.Text           = tostring(default)..suffix
			valL.Size           = UDim2.new(0, 50, 0, 14)
			valL.Position       = UDim2.new(1, -62, 0, 8)
			valL.BackgroundTransparency = 1
			valL.TextColor3     = barColor
			valL.Font           = Enum.Font.GothamBold
			valL.TextSize       = 11
			valL.TextXAlignment = Enum.TextXAlignment.Right
			valL.ZIndex         = 3
			valL.Parent         = row
 
			local trackBg = Instance.new("Frame")
			trackBg.Size            = UDim2.new(1, -24, 0, 4)
			trackBg.Position        = UDim2.new(0, 12, 0, 44)
			trackBg.BackgroundColor3= Theme.BG3
			trackBg.BorderSizePixel = 0
			trackBg.ZIndex          = 3
			trackBg.Parent          = row
 
			local fill = Instance.new("Frame")
			fill.Size             = UDim2.new(default/100, 0, 1, 0)
			fill.BackgroundColor3 = barColor
			fill.BorderSizePixel  = 0
			fill.ZIndex           = 4
			fill.Parent           = trackBg
 
			local API = {}
			function API:Set(v)
				v = math.clamp(v, 0, 100)
				valL.Text = tostring(math.round(v))..suffix
				tween(fill, {Size = UDim2.new(v/100, 0, 1, 0)}, 0.3, Enum.EasingStyle.Quad)
			end
			function API:Get() return tonumber(valL.Text:gsub(suffix,"")) end
			return API
		end
 
		return Tab
	end -- AddTab
 
	return setmetatable(Window, Window)
end -- CreateWindow
 
return NeonLib
