-- NeonLib v5 | Rayfield-Style Modular UI Framework
-- Features: Draggable, Closable, Tab Sidebar, Sections, Searchbar, Keybind, Dropdown, Colorpicker, Notifications

--// Roblox Studio Safe
local NeonLib = {}
NeonLib.__index = NeonLib

--// Services
local Players            = game:GetService("Players")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local RunService         = game:GetService("RunService")
local CoreGui            = game:GetService("CoreGui")
local HttpService        = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")
local Mouse       = LocalPlayer:GetMouse()

--// CoreGui safe wrapper (uses CoreGui so the UI always renders above Roblox overlays,
--// including the escape menu, chat, and the default topbar)
local function safeParent()
	local ok, result = pcall(function()
		return CoreGui
	end)
	return (ok and result) or PlayerGui
end
local UIParent = safeParent()

--// ─────────────────────────────────────────────────────────────
--//  THEME
--// ─────────────────────────────────────────────────────────────
NeonLib.Theme = {
	BG          = Color3.fromRGB(8,  10, 16),
	Panel       = Color3.fromRGB(14, 17, 27),
	Surface     = Color3.fromRGB(20, 24, 38),
	Elevated    = Color3.fromRGB(26, 31, 48),
	Accent      = Color3.fromRGB(82, 130, 255),
	AccentDark  = Color3.fromRGB(45, 80, 200),
	AccentGlow  = Color3.fromRGB(100, 160, 255),
	Text        = Color3.fromRGB(230, 235, 255),
	SubText     = Color3.fromRGB(120, 135, 175),
	Muted       = Color3.fromRGB(60,  70, 105),
	Danger      = Color3.fromRGB(255, 75,  80),
	Success     = Color3.fromRGB(50, 220, 130),
	Warning     = Color3.fromRGB(255, 190,  50),
	TabBar      = Color3.fromRGB(11, 13, 21),
	Stroke      = Color3.fromRGB(30, 36, 58),
}

--// ─────────────────────────────────────────────────────────────
--//  UTIL
--// ─────────────────────────────────────────────────────────────
local T = NeonLib.Theme

local function tween(obj, props, t, style, dir)
	TweenService:Create(obj,
		TweenInfo.new(t or 0.2,
			style or Enum.EasingStyle.Quint,
			dir   or Enum.EasingDirection.Out),
		props
	):Play()
end

local function new(class, props, parent)
	local inst = Instance.new(class)
	for k, v in pairs(props or {}) do inst[k] = v end
	if parent then inst.Parent = parent end
	return inst
end

local function corner(radius, parent)
	return new("UICorner", {CornerRadius = UDim.new(0, radius)}, parent)
end

local function stroke(color, thickness, parent)
	return new("UIStroke", {Color = color, Thickness = thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, parent)
end

local function padding(all, parent)
	return new("UIPadding", {
		PaddingTop    = UDim.new(0, all),
		PaddingBottom = UDim.new(0, all),
		PaddingLeft   = UDim.new(0, all),
		PaddingRight  = UDim.new(0, all),
	}, parent)
end

local function makeDraggable(frame, handle)
	local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
	handle = handle or frame

	handle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging  = true
			dragStart = i.Position
			startPos  = frame.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	handle.InputChanged:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
			dragInput = i
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if i == dragInput and dragging then
			local delta = i.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

local function ripple(btn)
	btn.MouseButton1Click:Connect(function()
		local circle = new("Frame", {
			Size = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundColor3 = Color3.fromRGB(255,255,255),
			BackgroundTransparency = 0.7,
			ZIndex = btn.ZIndex + 1,
		}, btn)
		corner(999, circle)
		tween(circle, {
			Size = UDim2.new(1.5, 0, 1.5, 0),
			BackgroundTransparency = 1,
		}, 0.4)
		task.delay(0.4, function() circle:Destroy() end)
	end)
end

--// ─────────────────────────────────────────────────────────────
--//  NOTIFICATION ENGINE
--// ─────────────────────────────────────────────────────────────
local NotifyGui = new("ScreenGui", {
	Name            = "NeonNotifications",
	ResetOnSpawn    = false,
	DisplayOrder    = 9999,
	IgnoreGuiInset  = true,
}, UIParent)

local NotifyHolder = new("Frame", {
	Size                = UDim2.new(0, 290, 1, 0),
	Position            = UDim2.new(1, -300, 0, 0),
	BackgroundTransparency = 1,
	Parent              = NotifyGui,
})
new("UIListLayout", {
	VerticalAlignment   = Enum.VerticalAlignment.Bottom,
	Padding             = UDim.new(0, 8),
	Parent              = NotifyHolder,
})
padding(10, NotifyHolder)

function NeonLib:Notify(cfg)
	local typeColors = {
		Info    = T.Accent,
		Success = T.Success,
		Warning = T.Warning,
		Error   = T.Danger,
	}
	local accentColor = typeColors[cfg.Type] or T.Accent
	local duration    = cfg.Duration or 4

	local card = new("Frame", {
		Size                = UDim2.new(1, 0, 0, 0),
		BackgroundColor3    = T.Panel,
		ClipsDescendants    = true,
		Parent              = NotifyHolder,
	})
	corner(10, card)
	stroke(T.Stroke, 1, card)

	-- left accent bar
	new("Frame", {
		Size             = UDim2.new(0, 3, 1, 0),
		BackgroundColor3 = accentColor,
		BorderSizePixel  = 0,
		Parent           = card,
	})

	local inner = new("Frame", {
		Size             = UDim2.new(1, -12, 1, 0),
		Position         = UDim2.new(0, 12, 0, 0),
		BackgroundTransparency = 1,
		Parent           = card,
	})
	padding(10, inner)

	new("TextLabel", {
		Text             = cfg.Title or "Notification",
		Size             = UDim2.new(1, 0, 0, 18),
		TextColor3       = T.Text,
		BackgroundTransparency = 1,
		Font             = Enum.Font.GothamBold,
		TextSize         = 13,
		TextXAlignment   = Enum.TextXAlignment.Left,
		Parent           = inner,
	})

	if cfg.Message then
		new("TextLabel", {
			Text             = cfg.Message,
			Size             = UDim2.new(1, 0, 0, 30),
			Position         = UDim2.new(0, 0, 0, 22),
			TextColor3       = T.SubText,
			BackgroundTransparency = 1,
			Font             = Enum.Font.Gotham,
			TextSize         = 11,
			TextXAlignment   = Enum.TextXAlignment.Left,
			TextWrapped      = true,
			Parent           = inner,
		})
	end

	-- progress bar
	local prog = new("Frame", {
		Size             = UDim2.new(1, 0, 0, 2),
		Position         = UDim2.new(0, 0, 1, -2),
		BackgroundColor3 = accentColor,
		BorderSizePixel  = 0,
		Parent           = card,
	})

	-- animate in
	tween(card, {Size = UDim2.new(1, 0, 0, cfg.Message and 70 or 46)}, 0.3)
	tween(prog, {Size = UDim2.new(0, 0, 0, 2)}, duration, Enum.EasingStyle.Linear)

	task.delay(duration, function()
		tween(card, {Size = UDim2.new(1, 0, 0, 0)}, 0.25)
		task.delay(0.3, function() card:Destroy() end)
	end)
end

--// ─────────────────────────────────────────────────────────────
--//  COMPONENTS
--// ─────────────────────────────────────────────────────────────
NeonLib.Components = {}

-- ── SECTION LABEL ──────────────────────────────────────────────
function NeonLib.Components.Section(parent, cfg)
	local frame = new("Frame", {
		Size             = UDim2.new(1, -16, 0, 28),
		BackgroundTransparency = 1,
		Parent           = parent,
	})
	new("TextLabel", {
		Text             = (cfg.Title or "Section"):upper(),
		Size             = UDim2.new(1, 0, 0, 16),
		Position         = UDim2.new(0, 0, 0, 8),
		TextColor3       = T.Accent,
		BackgroundTransparency = 1,
		Font             = Enum.Font.GothamBold,
		TextSize         = 10,
		TextXAlignment   = Enum.TextXAlignment.Left,
		Parent           = frame,
	})
	new("Frame", {
		Size             = UDim2.new(1, 0, 0, 1),
		Position         = UDim2.new(0, 0, 1, -1),
		BackgroundColor3 = T.Stroke,
		BorderSizePixel  = 0,
		Parent           = frame,
	})
	return frame
end

-- ── BUTTON ─────────────────────────────────────────────────────
function NeonLib.Components.Button(parent, cfg)
	local btn = new("TextButton", {
		Size             = UDim2.new(1, 0, 0, 38),
		BackgroundColor3 = T.Elevated,
		Text             = "",
		AutoButtonColor  = false,
		Parent           = parent,
	})
	corner(8, btn)
	stroke(T.Stroke, 1, btn)

	new("TextLabel", {
		Text             = cfg.Title or "Button",
		Size             = UDim2.new(1, -16, 1, 0),
		Position         = UDim2.new(0, 12, 0, 0),
		TextColor3       = T.Text,
		BackgroundTransparency = 1,
		Font             = Enum.Font.GothamSemibold,
		TextSize         = 13,
		TextXAlignment   = Enum.TextXAlignment.Left,
		Parent           = btn,
	})

	if cfg.Description then
		new("TextLabel", {
			Text             = cfg.Description,
			Size             = UDim2.new(1, -16, 0, 14),
			Position         = UDim2.new(0, 12, 0, 22),
			TextColor3       = T.SubText,
			BackgroundTransparency = 1,
			Font             = Enum.Font.Gotham,
			TextSize         = 10,
			TextXAlignment   = Enum.TextXAlignment.Left,
			Parent           = btn,
		})
		btn.Size = UDim2.new(1, 0, 0, 52)
	end

	-- right arrow indicator
	new("TextLabel", {
		Text             = "›",
		Size             = UDim2.new(0, 20, 1, 0),
		Position         = UDim2.new(1, -26, 0, 0),
		TextColor3       = T.Muted,
		BackgroundTransparency = 1,
		Font             = Enum.Font.GothamBold,
		TextSize         = 18,
		Parent           = btn,
	})

	btn.MouseEnter:Connect(function()
		tween(btn, {BackgroundColor3 = T.Surface}, 0.15)
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, {BackgroundColor3 = T.Elevated}, 0.15)
	end)
	btn.MouseButton1Down:Connect(function()
		tween(btn, {BackgroundColor3 = T.AccentDark}, 0.08)
	end)
	btn.MouseButton1Up:Connect(function()
		tween(btn, {BackgroundColor3 = T.Surface}, 0.08)
		if cfg.Callback then cfg.Callback() end
	end)
	ripple(btn)

	return btn
end

-- ── TOGGLE ─────────────────────────────────────────────────────
function NeonLib.Components.Toggle(parent, cfg)
	local state = cfg.Default or false

	local frame = new("Frame", {
		Size             = UDim2.new(1, 0, 0, 42),
		BackgroundColor3 = T.Elevated,
		Parent           = parent,
	})
	corner(8, frame)
	stroke(T.Stroke, 1, frame)

	new("TextLabel", {
		Text             = cfg.Title or "Toggle",
		Size             = UDim2.new(1, -70, 1, 0),
		Position         = UDim2.new(0, 12, 0, 0),
		TextColor3       = T.Text,
		BackgroundTransparency = 1,
		Font             = Enum.Font.GothamSemibold,
		TextSize         = 13,
		TextXAlignment   = Enum.TextXAlignment.Left,
		Parent           = frame,
	})

	-- pill track
	local track = new("Frame", {
		Size             = UDim2.new(0, 44, 0, 22),
		Position         = UDim2.new(1, -56, 0.5, -11),
		BackgroundColor3 = state and T.Accent or T.Muted,
		Parent           = frame,
	})
	corner(999, track)

	-- knob
	local knob = new("Frame", {
		Size             = UDim2.new(0, 16, 0, 16),
		Position         = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Parent           = track,
	})
	corner(999, knob)

	local function setState(v)
		state = v
		tween(track, {BackgroundColor3 = v and T.Accent or T.Muted}, 0.2)
		tween(knob, {Position = v and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}, 0.2)
		if cfg.Callback then cfg.Callback(v) end
	end

	local clickable = new("TextButton", {
		Size             = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text             = "",
		Parent           = frame,
	})
	clickable.MouseButton1Click:Connect(function()
		setState(not state)
	end)

	return {
		Set = setState,
		Get = function() return state end,
	}
end

-- ── SLIDER ─────────────────────────────────────────────────────
function NeonLib.Components.Slider(parent, cfg)
	local min   = cfg.Min     or 0
	local max   = cfg.Max     or 100
	local value = cfg.Default or min
	local suffix = cfg.Suffix or ""

	local frame = new("Frame", {
		Size             = UDim2.new(1, 0, 0, 56),
		BackgroundColor3 = T.Elevated,
		Parent           = parent,
	})
	corner(8, frame)
	stroke(T.Stroke, 1, frame)

	local titleLbl = new("TextLabel", {
		Text             = cfg.Title or "Slider",
		Size             = UDim2.new(1, -70, 0, 18),
		Position         = UDim2.new(0, 12, 0, 8),
		TextColor3       = T.Text,
		BackgroundTransparency = 1,
		Font             = Enum.Font.GothamSemibold,
		TextSize         = 13,
		TextXAlignment   = Enum.TextXAlignment.Left,
		Parent           = frame,
	})

	local valueLbl = new("TextLabel", {
		Text             = tostring(value) .. suffix,
		Size             = UDim2.new(0, 60, 0, 18),
		Position         = UDim2.new(1, -72, 0, 8),
		TextColor3       = T.Accent,
		BackgroundTransparency = 1,
		Font             = Enum.Font.GothamBold,
		TextSize         = 13,
		TextXAlignment   = Enum.TextXAlignment.Right,
		Parent           = frame,
	})

	-- track bg
	local trackBG = new("Frame", {
		Size             = UDim2.new(1, -24, 0, 4),
		Position         = UDim2.new(0, 12, 0, 38),
		BackgroundColor3 = T.Muted,
		Parent           = frame,
	})
	corner(999, trackBG)

	-- fill
	local fill = new("Frame", {
		Size             = UDim2.new((value-min)/(max-min), 0, 1, 0),
		BackgroundColor3 = T.Accent,
		Parent           = trackBG,
	})
	corner(999, fill)

	-- knob
	local thumb = new("Frame", {
		Size             = UDim2.new(0, 14, 0, 14),
		Position         = UDim2.new((value-min)/(max-min), -7, 0.5, -7),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		ZIndex           = 5,
		Parent           = trackBG,
	})
	corner(999, thumb)
	stroke(T.Accent, 2, thumb)

	local dragging = false

	local function updateValue(inputX)
		local pct = math.clamp((inputX - trackBG.AbsolutePosition.X) / trackBG.AbsoluteSize.X, 0, 1)
		value = math.floor(min + (max - min) * pct + 0.5)
		local p = (value - min) / (max - min)
		tween(fill,  {Size     = UDim2.new(p, 0, 1, 0)}, 0.05)
		tween(thumb, {Position = UDim2.new(p, -7, 0.5, -7)}, 0.05)
		valueLbl.Text = tostring(value) .. suffix
		if cfg.Callback then cfg.Callback(value) end
	end

	trackBG.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			updateValue(i.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement) then
			updateValue(i.Position.X)
		end
	end)

	return {
		Set = function(v)
			value = math.clamp(v, min, max)
			local p = (value - min) / (max - min)
			fill.Size     = UDim2.new(p, 0, 1, 0)
			thumb.Position = UDim2.new(p, -7, 0.5, -7)
			valueLbl.Text = tostring(value) .. suffix
		end,
		Get = function() return value end,
	}
end

-- ── DROPDOWN ───────────────────────────────────────────────────
function NeonLib.Components.Dropdown(parent, cfg)
	local options  = cfg.Options or {}
	local selected = cfg.Default or options[1] or "Select..."
	local open     = false

	local wrap = new("Frame", {
		Size             = UDim2.new(1, 0, 0, 42),
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		Parent           = parent,
	})

	local header = new("TextButton", {
		Size             = UDim2.new(1, 0, 0, 42),
		BackgroundColor3 = T.Elevated,
		Text             = "",
		AutoButtonColor  = false,
		Parent           = wrap,
	})
	corner(8, header)
	stroke(T.Stroke, 1, header)

	new("TextLabel", {
		Text             = cfg.Title or "Dropdown",
		Size             = UDim2.new(0.5, -8, 1, 0),
		Position         = UDim2.new(0, 12, 0, 0),
		TextColor3       = T.Text,
		BackgroundTransparency = 1,
		Font             = Enum.Font.GothamSemibold,
		TextSize         = 13,
		TextXAlignment   = Enum.TextXAlignment.Left,
		Parent           = header,
	})

	local selLbl = new("TextLabel", {
		Text             = selected,
		Size             = UDim2.new(0.5, -30, 1, 0),
		Position         = UDim2.new(0.5, 0, 0, 0),
		TextColor3       = T.Accent,
		BackgroundTransparency = 1,
		Font             = Enum.Font.GothamSemibold,
		TextSize         = 12,
		TextXAlignment   = Enum.TextXAlignment.Right,
		Parent           = header,
	})

	local arrow = new("TextLabel", {
		Text             = "⌄",
		Size             = UDim2.new(0, 20, 1, 0),
		Position         = UDim2.new(1, -24, 0, 0),
		TextColor3       = T.Muted,
		BackgroundTransparency = 1,
		Font             = Enum.Font.GothamBold,
		TextSize         = 14,
		Parent           = header,
	})

	-- dropdown list
	local listFrame = new("Frame", {
		Size             = UDim2.new(1, 0, 0, 0),
		Position         = UDim2.new(0, 0, 1, 4),
		BackgroundColor3 = T.Panel,
		ClipsDescendants = true,
		ZIndex           = 10,
		Visible          = false,
		Parent           = wrap,
	})
	corner(8, listFrame)
	stroke(T.Stroke, 1, listFrame)

	local listLayout = new("UIListLayout", {
		Padding     = UDim.new(0, 2),
		Parent      = listFrame,
	})
	padding(4, listFrame)

	local itemHeight = 32
	local listItems  = {}

	local function buildList()
		for _, child in ipairs(listFrame:GetChildren()) do
			if child:IsA("TextButton") then child:Destroy() end
		end
		listItems = {}
		for _, opt in ipairs(options) do
			local item = new("TextButton", {
				Size             = UDim2.new(1, 0, 0, itemHeight),
				BackgroundColor3 = selected == opt and T.Elevated or Color3.fromRGB(0,0,0),
				BackgroundTransparency = selected == opt and 0 or 1,
				Text             = opt,
				TextColor3       = selected == opt and T.Text or T.SubText,
				Font             = Enum.Font.GothamSemibold,
				TextSize         = 12,
				TextXAlignment   = Enum.TextXAlignment.Left,
				ZIndex           = 11,
				AutoButtonColor  = false,
				Parent           = listFrame,
			})
			corner(6, item)
			padding(8, item)

			item.MouseEnter:Connect(function()
				tween(item, {BackgroundTransparency = 0, BackgroundColor3 = T.Surface}, 0.1)
			end)
			item.MouseLeave:Connect(function()
				tween(item, {
					BackgroundTransparency = selected == opt and 0 or 1,
					BackgroundColor3 = selected == opt and T.Elevated or T.Surface,
				}, 0.1)
			end)
			item.MouseButton1Click:Connect(function()
				selected = opt
				selLbl.Text = opt
				if cfg.Callback then cfg.Callback(opt) end
				-- close
				open = false
				tween(listFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
				task.delay(0.2, function() listFrame.Visible = false end)
				tween(arrow, {Rotation = 0}, 0.2)
				buildList()
			end)
			table.insert(listItems, item)
		end
	end
	buildList()

	header.MouseButton1Click:Connect(function()
		open = not open
		if open then
			listFrame.Visible = true
			local h = math.min(#options * (itemHeight + 2) + 10, 160)
			tween(listFrame, {Size = UDim2.new(1, 0, 0, h)}, 0.25)
			tween(arrow, {Rotation = 180}, 0.2)
		else
			tween(listFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
			task.delay(0.2, function() listFrame.Visible = false end)
			tween(arrow, {Rotation = 0}, 0.2)
		end
	end)

	return {
		Set = function(v)
			selected = v
			selLbl.Text = v
			buildList()
		end,
		Get = function() return selected end,
		Refresh = function(newOpts)
			options = newOpts
			buildList()
		end,
	}
end

-- ── TEXT INPUT ─────────────────────────────────────────────────
function NeonLib.Components.Input(parent, cfg)
	local frame = new("Frame", {
		Size             = UDim2.new(1, 0, 0, 52),
		BackgroundColor3 = T.Elevated,
		Parent           = parent,
	})
	corner(8, frame)
	local frameStroke = stroke(T.Stroke, 1, frame)

	new("TextLabel", {
		Text             = cfg.Title or "Input",
		Size             = UDim2.new(1, -16, 0, 18),
		Position         = UDim2.new(0, 12, 0, 6),
		TextColor3       = T.Text,
		BackgroundTransparency = 1,
		Font             = Enum.Font.GothamSemibold,
		TextSize         = 12,
		TextXAlignment   = Enum.TextXAlignment.Left,
		Parent           = frame,
	})

	local box = new("TextBox", {
		Size             = UDim2.new(1, -24, 0, 22),
		Position         = UDim2.new(0, 12, 0, 26),
		BackgroundTransparency = 1,
		Text             = cfg.Default or "",
		PlaceholderText  = cfg.Placeholder or "Type here...",
		TextColor3       = T.Text,
		PlaceholderColor3 = T.Muted,
		Font             = Enum.Font.Gotham,
		TextSize         = 12,
		TextXAlignment   = Enum.TextXAlignment.Left,
		ClearTextOnFocus = cfg.ClearOnFocus ~= nil and cfg.ClearOnFocus or false,
		Parent           = frame,
	})

	box.Focused:Connect(function()
		tween(frame,       {BackgroundColor3 = T.Surface}, 0.15)
		tween(frameStroke, {Color = T.Accent}, 0.15)
	end)
	box.FocusLost:Connect(function(enter)
		tween(frame,       {BackgroundColor3 = T.Elevated}, 0.15)
		tween(frameStroke, {Color = T.Stroke}, 0.15)
		if cfg.Callback then cfg.Callback(box.Text, enter) end
	end)

	return {
		Set = function(v) box.Text = v end,
		Get = function() return box.Text end,
	}
end

-- ── KEYBIND ────────────────────────────────────────────────────
function NeonLib.Components.Keybind(parent, cfg)
	local bound   = cfg.Default or Enum.KeyCode.RightShift
	local binding = false

	local frame = new("Frame", {
		Size             = UDim2.new(1, 0, 0, 42),
		BackgroundColor3 = T.Elevated,
		Parent           = parent,
	})
	corner(8, frame)
	stroke(T.Stroke, 1, frame)

	new("TextLabel", {
		Text             = cfg.Title or "Keybind",
		Size             = UDim2.new(1, -100, 1, 0),
		Position         = UDim2.new(0, 12, 0, 0),
		TextColor3       = T.Text,
		BackgroundTransparency = 1,
		Font             = Enum.Font.GothamSemibold,
		TextSize         = 13,
		TextXAlignment   = Enum.TextXAlignment.Left,
		Parent           = frame,
	})

	local keyBtn = new("TextButton", {
		Size             = UDim2.new(0, 80, 0, 26),
		Position         = UDim2.new(1, -90, 0.5, -13),
		BackgroundColor3 = T.Surface,
		Text             = bound.Name,
		TextColor3       = T.Accent,
		Font             = Enum.Font.GothamBold,
		TextSize         = 11,
		AutoButtonColor  = false,
		Parent           = frame,
	})
	corner(6, keyBtn)

	keyBtn.MouseButton1Click:Connect(function()
		binding = true
		keyBtn.Text = "..."
		keyBtn.TextColor3 = T.Warning
	end)

	UserInputService.InputBegan:Connect(function(i, gp)
		if gp then return end
		if binding and i.UserInputType == Enum.UserInputType.Keyboard then
			bound = i.KeyCode
			binding = false
			keyBtn.Text = bound.Name
			keyBtn.TextColor3 = T.Accent
			if cfg.Callback then cfg.Callback(bound) end
		end
	end)

	return {
		Get = function() return bound end,
	}
end

-- ── COLOR PICKER ───────────────────────────────────────────────
function NeonLib.Components.ColorPicker(parent, cfg)
	local color  = cfg.Default or Color3.fromRGB(82, 130, 255)
	local open   = false

	local frame = new("Frame", {
		Size             = UDim2.new(1, 0, 0, 42),
		BackgroundColor3 = T.Elevated,
		ClipsDescendants = false,
		Parent           = parent,
	})
	corner(8, frame)
	stroke(T.Stroke, 1, frame)

	new("TextLabel", {
		Text             = cfg.Title or "Color",
		Size             = UDim2.new(1, -80, 1, 0),
		Position         = UDim2.new(0, 12, 0, 0),
		TextColor3       = T.Text,
		BackgroundTransparency = 1,
		Font             = Enum.Font.GothamSemibold,
		TextSize         = 13,
		TextXAlignment   = Enum.TextXAlignment.Left,
		Parent           = frame,
	})

	local preview = new("TextButton", {
		Size             = UDim2.new(0, 48, 0, 24),
		Position         = UDim2.new(1, -58, 0.5, -12),
		BackgroundColor3 = color,
		Text             = "",
		AutoButtonColor  = false,
		Parent           = frame,
	})
	corner(6, preview)
	stroke(T.Stroke, 1, preview)

	-- hue/saturation panel (simple HSV)
	local panel = new("Frame", {
		Size             = UDim2.new(1, 0, 0, 0),
		Position         = UDim2.new(0, 0, 1, 4),
		BackgroundColor3 = T.Panel,
		ZIndex           = 20,
		ClipsDescendants = true,
		Visible          = false,
		Parent           = frame,
	})
	corner(8, panel)
	stroke(T.Stroke, 1, panel)

	-- Hue bar
	local hueBar = new("Frame", {
		Size             = UDim2.new(1, -20, 0, 16),
		Position         = UDim2.new(0, 10, 0, 10),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		ZIndex           = 21,
		Parent           = panel,
	})
	corner(4, hueBar)

	-- gradient over hue bar
	local hueGrad = new("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 0,   0)),
			ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
			ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255,   0)),
			ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,   0, 255)),
			ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
			ColorSequenceKeypoint.new(1,    Color3.fromRGB(255, 0,   0)),
		}),
		Parent = hueBar,
	})

	local h, s, v = Color3.toHSV(color)
	local hueKnob = new("Frame", {
		Size             = UDim2.new(0, 8, 1, 4),
		Position         = UDim2.new(h, -4, 0, -2),
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		ZIndex           = 22,
		Parent           = hueBar,
	})
	corner(3, hueKnob)
	stroke(T.BG, 1, hueKnob)

	-- SV box
	local svBox = new("Frame", {
		Size             = UDim2.new(1, -20, 0, 80),
		Position         = UDim2.new(0, 10, 0, 34),
		ZIndex           = 21,
		Parent           = panel,
	})
	corner(4, svBox)

	local svColor = new("Frame", {
		Size             = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromHSV(h, 1, 1),
		ZIndex           = 21,
		Parent           = svBox,
	})
	corner(4, svColor)

	new("UIGradient", {
		Color       = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(0,0,0)),
		Transparency = NumberSequence.new(0, 1),
		Rotation    = 0,
		Parent      = svColor,
	})

	local svOverlay = new("Frame", {
		Size             = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(0,0,0),
		ZIndex           = 22,
		Parent           = svBox,
	})
	corner(4, svOverlay)
	new("UIGradient", {
		Color        = ColorSequence.new(Color3.fromRGB(0,0,0), Color3.fromRGB(0,0,0)),
		Transparency = NumberSequence.new(1, 0),
		Rotation     = 90,
		Parent       = svOverlay,
	})

	local svKnob = new("Frame", {
		Size             = UDim2.new(0, 10, 0, 10),
		Position         = UDim2.new(s, -5, 1-v, -5),
		BackgroundColor3 = Color3.fromRGB(255,255,255),
		ZIndex           = 23,
		Parent           = svBox,
	})
	corner(999, svKnob)
	stroke(T.BG, 1.5, svKnob)

	local function updateColor()
		color = Color3.fromHSV(h, s, v)
		preview.BackgroundColor3 = color
		svColor.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
		hueKnob.Position         = UDim2.new(h, -4, 0, -2)
		svKnob.Position          = UDim2.new(s, -5, 1-v, -5)
		if cfg.Callback then cfg.Callback(color) end
	end

	local draggingHue, draggingSV = false, false

	hueBar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingHue = true
			h = math.clamp((i.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
			updateColor()
		end
	end)
	svBox.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingSV = true
			s = math.clamp((i.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
			v = 1 - math.clamp((i.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
			updateColor()
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingHue = false
			draggingSV  = false
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseMovement then
			if draggingHue then
				h = math.clamp((i.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
				updateColor()
			end
			if draggingSV then
				s = math.clamp((i.Position.X - svBox.AbsolutePosition.X)  / svBox.AbsoluteSize.X,  0, 1)
				v = 1 - math.clamp((i.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
				updateColor()
			end
		end
	end)

	preview.MouseButton1Click:Connect(function()
		open = not open
		if open then
			panel.Visible = true
			tween(panel, {Size = UDim2.new(1, 0, 0, 130)}, 0.25)
		else
			tween(panel, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
			task.delay(0.2, function() panel.Visible = false end)
		end
	end)

	return {
		Set = function(c)
			color = c
			h, s, v = Color3.toHSV(c)
			preview.BackgroundColor3 = c
			updateColor()
		end,
		Get = function() return color end,
	}
end

--// ─────────────────────────────────────────────────────────────
--//  WINDOW
--// ─────────────────────────────────────────────────────────────
function NeonLib:CreateWindow(cfg)
	local win = setmetatable({}, NeonLib)
	win.Tabs = {}
	win._activeTab = nil

	local gui = new("ScreenGui", {
		Name            = "NeonLib_" .. (cfg.Name or "Window"),
		ResetOnSpawn    = false,
		DisplayOrder    = 9998,
		IgnoreGuiInset  = true,
		Parent          = UIParent,
	})

	-- ── MAIN FRAME ──────────────────────────────────────────────
	local main = new("Frame", {
		Size             = UDim2.new(0, 580, 0, 400),
		Position         = UDim2.new(0.5, -290, 0.5, -200),
		BackgroundColor3 = T.BG,
		Parent           = gui,
	})
	corner(12, main)
	stroke(T.Stroke, 1.5, main)

	-- subtle inner glow
	local shadow = new("ImageLabel", {
		Size             = UDim2.new(1, 40, 1, 40),
		Position         = UDim2.new(0, -20, 0, -20),
		BackgroundTransparency = 1,
		Image            = "rbxassetid://6015897843",
		ImageColor3      = T.Accent,
		ImageTransparency = 0.92,
		ScaleType        = Enum.ScaleType.Slice,
		SliceCenter      = Rect.new(49, 49, 450, 450),
		ZIndex           = 0,
		Parent           = main,
	})

	-- ── TOPBAR ──────────────────────────────────────────────────
	local topBar = new("Frame", {
		Size             = UDim2.new(1, 0, 0, 48),
		BackgroundColor3 = T.Panel,
		Parent           = main,
	})
	corner(12, topBar)

	-- patch bottom corners of topbar
	new("Frame", {
		Size             = UDim2.new(1, 0, 0, 12),
		Position         = UDim2.new(0, 0, 1, -12),
		BackgroundColor3 = T.Panel,
		BorderSizePixel  = 0,
		Parent           = topBar,
	})

	-- logo dot
	local dot = new("Frame", {
		Size             = UDim2.new(0, 8, 0, 8),
		Position         = UDim2.new(0, 14, 0.5, -4),
		BackgroundColor3 = T.Accent,
		Parent           = topBar,
	})
	corner(999, dot)

	new("TextLabel", {
		Text             = cfg.Name or "NeonLib",
		Size             = UDim2.new(0, 200, 1, 0),
		Position         = UDim2.new(0, 28, 0, 0),
		TextColor3       = T.Text,
		BackgroundTransparency = 1,
		Font             = Enum.Font.GothamBold,
		TextSize         = 14,
		TextXAlignment   = Enum.TextXAlignment.Left,
		Parent           = topBar,
	})

	if cfg.Subtitle then
		new("TextLabel", {
			Text             = cfg.Subtitle,
			Size             = UDim2.new(0, 200, 1, 0),
			Position         = UDim2.new(0, 28, 0, 16),
			TextColor3       = T.SubText,
			BackgroundTransparency = 1,
			Font             = Enum.Font.Gotham,
			TextSize         = 10,
			TextXAlignment   = Enum.TextXAlignment.Left,
			Parent           = topBar,
		})
	end

	-- minimize / close buttons
	local closeBtn = new("TextButton", {
		Size             = UDim2.new(0, 28, 0, 28),
		Position         = UDim2.new(1, -38, 0.5, -14),
		BackgroundColor3 = T.Danger,
		Text             = "✕",
		TextColor3       = Color3.fromRGB(255,255,255),
		Font             = Enum.Font.GothamBold,
		TextSize         = 12,
		AutoButtonColor  = false,
		Parent           = topBar,
	})
	corner(999, closeBtn)

	local minBtn = new("TextButton", {
		Size             = UDim2.new(0, 28, 0, 28),
		Position         = UDim2.new(1, -72, 0.5, -14),
		BackgroundColor3 = T.Warning,
		Text             = "–",
		TextColor3       = Color3.fromRGB(0,0,0),
		Font             = Enum.Font.GothamBold,
		TextSize         = 14,
		AutoButtonColor  = false,
		Parent           = topBar,
	})
	corner(999, minBtn)

	local minimized = false
	local bodyFrame  -- defined below

	closeBtn.MouseButton1Click:Connect(function()
		tween(main, {Size = UDim2.new(0, 580, 0, 0)}, 0.3)
		task.delay(0.32, function() gui:Destroy() end)
	end)

	-- ── BODY ────────────────────────────────────────────────────
	bodyFrame = new("Frame", {
		Size             = UDim2.new(1, 0, 1, -48),
		Position         = UDim2.new(0, 0, 0, 48),
		BackgroundTransparency = 1,
		Parent           = main,
	})

	minBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			tween(main, {Size = UDim2.new(0, 580, 0, 48)}, 0.3)
			minBtn.Text = "□"
		else
			tween(main, {Size = UDim2.new(0, 580, 0, 400)}, 0.3)
			minBtn.Text = "–"
		end
	end)

	-- ── TAB SIDEBAR ─────────────────────────────────────────────
	local sidebar = new("Frame", {
		Size             = UDim2.new(0, 130, 1, -8),
		Position         = UDim2.new(0, 4, 0, 4),
		BackgroundColor3 = T.TabBar,
		Parent           = bodyFrame,
	})
	corner(10, sidebar)

	local tabList = new("UIListLayout", {
		Padding = UDim.new(0, 4),
		Parent  = sidebar,
	})
	padding(6, sidebar)

	-- ── CONTENT AREA ────────────────────────────────────────────
	local contentArea = new("Frame", {
		Size             = UDim2.new(1, -142, 1, -8),
		Position         = UDim2.new(0, 138, 0, 4),
		BackgroundTransparency = 1,
		Parent           = bodyFrame,
	})

	-- ── DRAGGABLE ───────────────────────────────────────────────
	makeDraggable(main, topBar)

	-- ── TAB CREATOR ─────────────────────────────────────────────
	function win:CreateTab(cfg2)
		local tabName = type(cfg2) == "string" and cfg2 or (cfg2.Name or "Tab")
		local tabIcon = type(cfg2) == "table"  and cfg2.Icon or nil

		-- sidebar button
		local tabBtn = new("TextButton", {
			Size             = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = T.TabBar,
			Text             = (tabIcon and (tabIcon .. "  ") or "") .. tabName,
			TextColor3       = T.SubText,
			Font             = Enum.Font.GothamSemibold,
			TextSize         = 12,
			TextXAlignment   = Enum.TextXAlignment.Left,
			AutoButtonColor  = false,
			Parent           = sidebar,
		})
		corner(8, tabBtn)
		padding(10, tabBtn)

		local indicator = new("Frame", {
			Size             = UDim2.new(0, 3, 0.6, 0),
			Position         = UDim2.new(0, 0, 0.2, 0),
			BackgroundColor3 = T.Accent,
			Visible          = false,
			Parent           = tabBtn,
		})
		corner(999, indicator)

		-- scroll content
		local scroll = new("ScrollingFrame", {
			Size                 = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			ScrollBarThickness   = 3,
			ScrollBarImageColor3 = T.Muted,
			Visible              = false,
			CanvasSize           = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize  = Enum.AutomaticSize.Y,
			Parent               = contentArea,
		})

		local contentLayout = new("UIListLayout", {
			Padding  = UDim.new(0, 6),
			Parent   = scroll,
		})
		padding(8, scroll)

		local tab = {_scroll = scroll}

		local function activate()
			-- deactivate all
			for _, t in pairs(win.Tabs) do
				t._scroll.Visible = false
				if t._btn then
					tween(t._btn, {BackgroundColor3 = T.TabBar, TextColor3 = T.SubText}, 0.15)
				end
				if t._indicator then t._indicator.Visible = false end
			end
			-- activate this
			scroll.Visible        = true
			indicator.Visible     = true
			tween(tabBtn, {BackgroundColor3 = T.Surface, TextColor3 = T.Text}, 0.15)
			win._activeTab = tab
		end

		tab._btn       = tabBtn
		tab._indicator = indicator
		tab._activate  = activate

		tabBtn.MouseButton1Click:Connect(activate)
		tabBtn.MouseEnter:Connect(function()
			if win._activeTab ~= tab then
				tween(tabBtn, {BackgroundColor3 = T.Elevated}, 0.1)
			end
		end)
		tabBtn.MouseLeave:Connect(function()
			if win._activeTab ~= tab then
				tween(tabBtn, {BackgroundColor3 = T.TabBar}, 0.1)
			end
		end)

		-- Component helpers
		function tab:AddSection(c)    return NeonLib.Components.Section(scroll, c) end
		function tab:AddButton(c)     return NeonLib.Components.Button(scroll, c) end
		function tab:AddToggle(c)     return NeonLib.Components.Toggle(scroll, c) end
		function tab:AddSlider(c)     return NeonLib.Components.Slider(scroll, c) end
		function tab:AddDropdown(c)   return NeonLib.Components.Dropdown(scroll, c) end
		function tab:AddInput(c)      return NeonLib.Components.Input(scroll, c) end
		function tab:AddKeybind(c)    return NeonLib.Components.Keybind(scroll, c) end
		function tab:AddColorPicker(c) return NeonLib.Components.ColorPicker(scroll, c) end

		win.Tabs[tabName] = tab

		-- auto-select first tab
		if not win._activeTab then activate() end

		return tab
	end

	win.Gui  = gui
	win.Main = main

	-- open animation
	main.Size = UDim2.new(0, 580, 0, 0)
	tween(main, {Size = UDim2.new(0, 580, 0, 400)}, 0.4, Enum.EasingStyle.Back)

	return win
end

return NeonLib
