--[[
    CyberUI Interface Suite
    Cyber / Hologram Style UI Library
    Rayfield-compatible API
    
    Usage:
        local CyberUI = loadstring(game:HttpGet('YOUR_RAW_URL'))()
        local Window = CyberUI:CreateWindow({ ... })
        local Tab = Window:CreateTab("Tab Name")
        ...
        CyberUI:LoadConfiguration()
]]

-- Services
local function getService(name)
    local s = game:GetService(name)
    return if cloneref then cloneref(s) else s
end

local UserInputService = getService("UserInputService")
local TweenService     = getService("TweenService")
local RunService       = getService("RunService")
local Players          = getService("Players")
local CoreGui          = getService("CoreGui")
local HttpService      = getService("HttpService")

-- ============================================================
-- THEME SYSTEM
-- ============================================================
local CyberUI = { Flags = {} }

CyberUI.Theme = {
    Cyber = {
        -- Core
        Background            = Color3.fromRGB(8,   12,  20),
        Topbar                = Color3.fromRGB(10,  16,  28),
        Shadow                = Color3.fromRGB(0,   210, 255),
        TextColor             = Color3.fromRGB(0,   230, 255),
        AccentColor           = Color3.fromRGB(0,   210, 255),
        AccentColorDim        = Color3.fromRGB(0,   100, 140),

        -- Tabs
        TabBackground         = Color3.fromRGB(12,  20,  35),
        TabStroke             = Color3.fromRGB(0,   80,  120),
        TabBackgroundSelected = Color3.fromRGB(0,   40,  70),
        TabTextColor          = Color3.fromRGB(0,   170, 210),
        SelectedTabTextColor  = Color3.fromRGB(0,   230, 255),

        -- Elements
        ElementBackground     = Color3.fromRGB(10,  18,  30),
        ElementBackgroundHover= Color3.fromRGB(14,  26,  44),
        ElementStroke         = Color3.fromRGB(0,   120, 160),
        SecondaryElementBackground = Color3.fromRGB(8, 14, 24),
        SecondaryElementStroke     = Color3.fromRGB(0, 80, 110),

        -- Slider
        SliderBackground      = Color3.fromRGB(0,   40,  60),
        SliderProgress        = Color3.fromRGB(0,   210, 255),
        SliderStroke          = Color3.fromRGB(0,   180, 230),

        -- Toggle
        ToggleBackground      = Color3.fromRGB(8,   14,  24),
        ToggleEnabled         = Color3.fromRGB(0,   210, 255),
        ToggleDisabled        = Color3.fromRGB(30,  50,  70),
        ToggleEnabledStroke   = Color3.fromRGB(0,   240, 255),
        ToggleDisabledStroke  = Color3.fromRGB(20,  50,  70),
        ToggleEnabledOuterStroke  = Color3.fromRGB(0, 160, 200),
        ToggleDisabledOuterStroke = Color3.fromRGB(20, 40, 60),

        -- Dropdown
        DropdownSelected   = Color3.fromRGB(0,   40,  70),
        DropdownUnselected = Color3.fromRGB(10,  18,  30),

        -- Input
        InputBackground    = Color3.fromRGB(6,   12,  22),
        InputStroke        = Color3.fromRGB(0,   120, 160),
        PlaceholderColor   = Color3.fromRGB(0,   120, 160),

        -- Notifications
        NotificationBackground        = Color3.fromRGB(8,  14, 24),
        NotificationActionsBackground = Color3.fromRGB(0, 200, 255),
    },

    Neon = {
        Background            = Color3.fromRGB(5,   0,   15),
        Topbar                = Color3.fromRGB(10,  0,   25),
        Shadow                = Color3.fromRGB(180, 0,   255),
        TextColor             = Color3.fromRGB(220, 120, 255),
        AccentColor           = Color3.fromRGB(180, 0,   255),
        AccentColorDim        = Color3.fromRGB(80,  0,   120),

        TabBackground         = Color3.fromRGB(14,  0,   30),
        TabStroke             = Color3.fromRGB(80,  0,   120),
        TabBackgroundSelected = Color3.fromRGB(40,  0,   80),
        TabTextColor          = Color3.fromRGB(160, 60,  220),
        SelectedTabTextColor  = Color3.fromRGB(220, 120, 255),

        ElementBackground     = Color3.fromRGB(12,  0,   25),
        ElementBackgroundHover= Color3.fromRGB(20,  0,   40),
        ElementStroke         = Color3.fromRGB(100, 0,   160),
        SecondaryElementBackground = Color3.fromRGB(8, 0, 18),
        SecondaryElementStroke     = Color3.fromRGB(60, 0, 100),

        SliderBackground      = Color3.fromRGB(30,  0,   60),
        SliderProgress        = Color3.fromRGB(180, 0,   255),
        SliderStroke          = Color3.fromRGB(150, 0,   220),

        ToggleBackground      = Color3.fromRGB(10,  0,   22),
        ToggleEnabled         = Color3.fromRGB(180, 0,   255),
        ToggleDisabled        = Color3.fromRGB(50,  0,   80),
        ToggleEnabledStroke   = Color3.fromRGB(200, 50,  255),
        ToggleDisabledStroke  = Color3.fromRGB(40,  0,   70),
        ToggleEnabledOuterStroke  = Color3.fromRGB(140, 0, 200),
        ToggleDisabledOuterStroke = Color3.fromRGB(30, 0, 55),

        DropdownSelected   = Color3.fromRGB(40,  0,   80),
        DropdownUnselected = Color3.fromRGB(12,  0,   25),

        InputBackground    = Color3.fromRGB(6,   0,   15),
        InputStroke        = Color3.fromRGB(100, 0,   160),
        PlaceholderColor   = Color3.fromRGB(100, 40,  160),

        NotificationBackground        = Color3.fromRGB(10, 0, 22),
        NotificationActionsBackground = Color3.fromRGB(180, 0, 255),
    },

    Matrix = {
        Background            = Color3.fromRGB(0,   10,  0),
        Topbar                = Color3.fromRGB(0,   16,  0),
        Shadow                = Color3.fromRGB(0,   255, 70),
        TextColor             = Color3.fromRGB(0,   230, 60),
        AccentColor           = Color3.fromRGB(0,   200, 50),
        AccentColorDim        = Color3.fromRGB(0,   80,  20),

        TabBackground         = Color3.fromRGB(0,   18,  0),
        TabStroke             = Color3.fromRGB(0,   80,  20),
        TabBackgroundSelected = Color3.fromRGB(0,   40,  10),
        TabTextColor          = Color3.fromRGB(0,   170, 40),
        SelectedTabTextColor  = Color3.fromRGB(0,   230, 60),

        ElementBackground     = Color3.fromRGB(0,   14,  0),
        ElementBackgroundHover= Color3.fromRGB(0,   22,  5),
        ElementStroke         = Color3.fromRGB(0,   120, 30),
        SecondaryElementBackground = Color3.fromRGB(0, 10, 0),
        SecondaryElementStroke     = Color3.fromRGB(0, 70, 15),

        SliderBackground      = Color3.fromRGB(0,   30,  5),
        SliderProgress        = Color3.fromRGB(0,   200, 50),
        SliderStroke          = Color3.fromRGB(0,   170, 40),

        ToggleBackground      = Color3.fromRGB(0,   12,  0),
        ToggleEnabled         = Color3.fromRGB(0,   200, 50),
        ToggleDisabled        = Color3.fromRGB(0,   45,  10),
        ToggleEnabledStroke   = Color3.fromRGB(0,   230, 60),
        ToggleDisabledStroke  = Color3.fromRGB(0,   35,  8),
        ToggleEnabledOuterStroke  = Color3.fromRGB(0, 150, 35),
        ToggleDisabledOuterStroke = Color3.fromRGB(0, 30, 6),

        DropdownSelected   = Color3.fromRGB(0,   40,  10),
        DropdownUnselected = Color3.fromRGB(0,   14,  0),

        InputBackground    = Color3.fromRGB(0,   8,   0),
        InputStroke        = Color3.fromRGB(0,   120, 30),
        PlaceholderColor   = Color3.fromRGB(0,   100, 25),

        NotificationBackground        = Color3.fromRGB(0, 12, 0),
        NotificationActionsBackground = Color3.fromRGB(0, 200, 50),
    },
}

-- ============================================================
-- INTERNAL STATE
-- ============================================================
local SelectedTheme  = CyberUI.Theme.Cyber
local Hidden         = false
local Minimised      = false
local Debounce       = false
local CEnabled       = false
local CFileName      = nil
local globalLoaded   = false
local rayfieldDestroyed = false
local searchOpen     = false
local keybindConns   = {}

local RayfieldFolder       = "CyberUI"
local ConfigurationFolder  = RayfieldFolder .. "/Configurations"
local ConfigurationExtension = ".cyui"

-- ============================================================
-- UTILITY
-- ============================================================
local function callSafely(func, ...)
    if func then
        local ok, r = pcall(func, ...)
        if not ok then warn("CyberUI | Error: ", r) return false end
        return r
    end
end

local function ensureFolder(path)
    if isfolder and not callSafely(isfolder, path) then
        callSafely(makefolder, path)
    end
end

local function tween(obj, info, props)
    TweenService:Create(obj, info, props):Play()
end

local fast  = TweenInfo.new(0.25, Enum.EasingStyle.Exponential)
local med   = TweenInfo.new(0.45, Enum.EasingStyle.Exponential)
local slow  = TweenInfo.new(0.65, Enum.EasingStyle.Exponential)

-- ============================================================
-- BUILD GUI
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CyberUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 120

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif CoreGui:FindFirstChild("RobloxGui") then
    ScreenGui.Parent = CoreGui:FindFirstChild("RobloxGui")
else
    ScreenGui.Parent = CoreGui
end

-- Notification holder
local NotifHolder = Instance.new("Frame")
NotifHolder.Name = "Notifications"
NotifHolder.BackgroundTransparency = 1
NotifHolder.Size = UDim2.new(0, 300, 1, 0)
NotifHolder.Position = UDim2.new(1, -310, 0, 0)
NotifHolder.Parent = ScreenGui
local notifLayout = Instance.new("UIListLayout")
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.Padding = UDim.new(0, 8)
notifLayout.Parent = NotifHolder

-- Main window frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 520, 0, 480)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = SelectedTheme.Background
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 6)
mainCorner.Parent = Main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = SelectedTheme.AccentColor
mainStroke.Thickness = 1
mainStroke.Transparency = 0.5
mainStroke.Parent = Main

-- Topbar
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 46)
Topbar.Position = UDim2.new(0, 0, 0, 0)
Topbar.BackgroundColor3 = SelectedTheme.Topbar
Topbar.BorderSizePixel = 0
Topbar.Parent = Main

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 6)
topCorner.Parent = Topbar

-- Topbar repair (covers bottom-left/right round corners)
local topRepair = Instance.new("Frame")
topRepair.Size = UDim2.new(1, 0, 0.5, 0)
topRepair.Position = UDim2.new(0, 0, 0.5, 0)
topRepair.BackgroundColor3 = SelectedTheme.Topbar
topRepair.BorderSizePixel = 0
topRepair.Parent = Topbar

local topStroke = Instance.new("UIStroke")
topStroke.Color = SelectedTheme.AccentColor
topStroke.Thickness = 1
topStroke.Transparency = 0.6
topStroke.Parent = Topbar

-- Topbar title
local TopTitle = Instance.new("TextLabel")
TopTitle.Name = "Title"
TopTitle.Size = UDim2.new(1, -160, 1, 0)
TopTitle.Position = UDim2.new(0, 14, 0, 0)
TopTitle.BackgroundTransparency = 1
TopTitle.Text = "CyberUI"
TopTitle.TextColor3 = SelectedTheme.TextColor
TopTitle.TextSize = 14
TopTitle.Font = Enum.Font.GothamBold
TopTitle.TextXAlignment = Enum.TextXAlignment.Left
TopTitle.Parent = Topbar

-- Topbar divider line
local TopDivider = Instance.new("Frame")
TopDivider.Name = "Divider"
TopDivider.Size = UDim2.new(1, 0, 0, 1)
TopDivider.Position = UDim2.new(0, 0, 1, -1)
TopDivider.BackgroundColor3 = SelectedTheme.AccentColor
TopDivider.BackgroundTransparency = 0.7
TopDivider.BorderSizePixel = 0
TopDivider.Parent = Topbar

-- Topbar buttons (Hide, Minimise)
local function makeTopBtn(name, symbol, xOffset)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 28, 0, 28)
    btn.Position = UDim2.new(1, xOffset, 0.5, 0)
    btn.AnchorPoint = Vector2.new(1, 0.5)
    btn.BackgroundColor3 = SelectedTheme.ElementBackground
    btn.BorderSizePixel = 0
    btn.Text = symbol
    btn.TextColor3 = SelectedTheme.AccentColor
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Topbar

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = btn

    local s = Instance.new("UIStroke")
    s.Color = SelectedTheme.AccentColor
    s.Thickness = 1
    s.Transparency = 0.6
    s.Parent = btn

    btn.MouseEnter:Connect(function()
        tween(btn, fast, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover})
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, fast, {BackgroundColor3 = SelectedTheme.ElementBackground})
    end)

    return btn
end

local HideBtn = makeTopBtn("Hide", "X", -10)
local MinBtn  = makeTopBtn("Minimise", "-", -44)

-- Search button
local SearchBtn = makeTopBtn("Search", "~", -78)

-- Tab list (horizontal scroll at top)
local TabListFrame = Instance.new("ScrollingFrame")
TabListFrame.Name = "TabList"
TabListFrame.Size = UDim2.new(1, -20, 0, 36)
TabListFrame.Position = UDim2.new(0, 10, 0, 50)
TabListFrame.BackgroundTransparency = 1
TabListFrame.BorderSizePixel = 0
TabListFrame.ScrollBarThickness = 0
TabListFrame.ScrollingDirection = Enum.ScrollingDirection.X
TabListFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
TabListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
TabListFrame.Parent = Main

local tabListLayout = Instance.new("UIListLayout")
tabListLayout.FillDirection = Enum.FillDirection.Horizontal
tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabListLayout.Padding = UDim.new(0, 6)
tabListLayout.Parent = TabListFrame

-- Search bar
local SearchFrame = Instance.new("Frame")
SearchFrame.Name = "SearchFrame"
SearchFrame.Size = UDim2.new(1, -20, 0, 32)
SearchFrame.Position = UDim2.new(0, 10, 0, 90)
SearchFrame.BackgroundColor3 = SelectedTheme.InputBackground
SearchFrame.BorderSizePixel = 0
SearchFrame.Visible = false
SearchFrame.Parent = Main

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 4)
searchCorner.Parent = SearchFrame

local searchStroke = Instance.new("UIStroke")
searchStroke.Color = SelectedTheme.AccentColor
searchStroke.Thickness = 1
searchStroke.Transparency = 0.5
searchStroke.Parent = SearchFrame

local SearchInput = Instance.new("TextBox")
SearchInput.Size = UDim2.new(1, -12, 1, 0)
SearchInput.Position = UDim2.new(0, 10, 0, 0)
SearchInput.BackgroundTransparency = 1
SearchInput.PlaceholderText = "Search elements..."
SearchInput.PlaceholderColor3 = SelectedTheme.PlaceholderColor
SearchInput.TextColor3 = SelectedTheme.TextColor
SearchInput.TextSize = 13
SearchInput.Font = Enum.Font.Gotham
SearchInput.TextXAlignment = Enum.TextXAlignment.Left
SearchInput.ClearTextOnFocus = false
SearchInput.Parent = SearchFrame

-- Elements page container
local ElementsContainer = Instance.new("Frame")
ElementsContainer.Name = "Elements"
ElementsContainer.Size = UDim2.new(1, 0, 1, -92)
ElementsContainer.Position = UDim2.new(0, 0, 0, 92)
ElementsContainer.BackgroundTransparency = 1
ElementsContainer.ClipsDescendants = true
ElementsContainer.Parent = Main

local PageLayout = Instance.new("UIPageLayout")
PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
PageLayout.FillDirection = Enum.FillDirection.Horizontal
PageLayout.EasingStyle = Enum.EasingStyle.Exponential
PageLayout.EasingDirection = Enum.EasingDirection.Out
PageLayout.TweenTime = 0.35
PageLayout.ScrollWheelInputEnabled = false
PageLayout.GamepadInputEnabled = false
PageLayout.TouchInputEnabled = false
PageLayout.Parent = ElementsContainer

-- Loading Frame
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = SelectedTheme.Background
LoadingFrame.BorderSizePixel = 0
LoadingFrame.ZIndex = 10
LoadingFrame.Parent = Main

local loadCorner = Instance.new("UICorner")
loadCorner.CornerRadius = UDim.new(0, 6)
loadCorner.Parent = LoadingFrame

local LoadTitle = Instance.new("TextLabel")
LoadTitle.Size = UDim2.new(1, 0, 0, 40)
LoadTitle.Position = UDim2.new(0, 0, 0.4, 0)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "CYBERUI"
LoadTitle.TextColor3 = SelectedTheme.AccentColor
LoadTitle.TextSize = 26
LoadTitle.Font = Enum.Font.GothamBold
LoadTitle.TextXAlignment = Enum.TextXAlignment.Center
LoadTitle.TextTransparency = 1
LoadTitle.Parent = LoadingFrame

local LoadSubtitle = Instance.new("TextLabel")
LoadSubtitle.Size = UDim2.new(1, 0, 0, 24)
LoadSubtitle.Position = UDim2.new(0, 0, 0.4, 44)
LoadSubtitle.BackgroundTransparency = 1
LoadSubtitle.Text = "Interface Suite"
LoadSubtitle.TextColor3 = SelectedTheme.TextColor
LoadSubtitle.TextSize = 13
LoadSubtitle.Font = Enum.Font.Gotham
LoadSubtitle.TextXAlignment = Enum.TextXAlignment.Center
LoadSubtitle.TextTransparency = 1
LoadSubtitle.Parent = LoadingFrame

-- Animated scan line for hologram effect
local ScanLine = Instance.new("Frame")
ScanLine.Size = UDim2.new(1, 0, 0, 2)
ScanLine.Position = UDim2.new(0, 0, 0, 0)
ScanLine.BackgroundColor3 = SelectedTheme.AccentColor
ScanLine.BackgroundTransparency = 0.6
ScanLine.BorderSizePixel = 0
ScanLine.ZIndex = 20
ScanLine.Parent = Main

-- Animate scan line
task.spawn(function()
    while not rayfieldDestroyed do
        TweenService:Create(ScanLine, TweenInfo.new(2.5, Enum.EasingStyle.Linear), {Position = UDim2.new(0, 0, 1, 0)}):Play()
        task.wait(2.5)
        ScanLine.Position = UDim2.new(0, 0, 0, 0)
        task.wait(0.1)
    end
end)

-- ============================================================
-- THEME APPLICATION
-- ============================================================
local function ApplyTheme(theme)
    if type(theme) == "string" then
        SelectedTheme = CyberUI.Theme[theme] or CyberUI.Theme.Cyber
    elseif type(theme) == "table" then
        SelectedTheme = theme
    end

    Main.BackgroundColor3           = SelectedTheme.Background
    mainStroke.Color                = SelectedTheme.AccentColor
    Topbar.BackgroundColor3         = SelectedTheme.Topbar
    topRepair.BackgroundColor3      = SelectedTheme.Topbar
    topStroke.Color                 = SelectedTheme.AccentColor
    TopDivider.BackgroundColor3     = SelectedTheme.AccentColor
    TopTitle.TextColor3             = SelectedTheme.TextColor
    ScanLine.BackgroundColor3       = SelectedTheme.AccentColor

    for _, btn in ipairs({HideBtn, MinBtn, SearchBtn}) do
        btn.BackgroundColor3 = SelectedTheme.ElementBackground
        btn.TextColor3       = SelectedTheme.AccentColor
    end

    SearchFrame.BackgroundColor3 = SelectedTheme.InputBackground
    searchStroke.Color           = SelectedTheme.AccentColor
    SearchInput.TextColor3       = SelectedTheme.TextColor
    SearchInput.PlaceholderColor3 = SelectedTheme.PlaceholderColor
end

-- ============================================================
-- DRAGGING
-- ============================================================
local function makeDraggable(frame, handle)
    local dragging, rel = false, nil
    local offset = Vector2.zero
    local sg = frame:FindFirstAncestorWhichIsA("ScreenGui")
    if sg and sg.IgnoreGuiInset then
        offset = offset + getService("GuiService"):GetGuiInset()
    end

    handle.InputBegan:Connect(function(input, processed)
        if processed then return end
        local t = input.UserInputType.Name
        if t == "MouseButton1" or t == "Touch" then
            dragging = true
            rel = frame.AbsolutePosition + frame.AbsoluteSize * frame.AnchorPoint - UserInputService:GetMouseLocation()
        end
    end)

    local endConn = UserInputService.InputEnded:Connect(function(input)
        local t = input.UserInputType.Name
        if t == "MouseButton1" or t == "Touch" then dragging = false end
    end)

    local stepConn = RunService.RenderStepped:Connect(function()
        if dragging then
            local pos = UserInputService:GetMouseLocation() + rel + offset
            frame.Position = UDim2.fromOffset(pos.X, pos.Y)
        end
    end)

    frame.Destroying:Connect(function()
        endConn:Disconnect()
        stepConn:Disconnect()
    end)
end

makeDraggable(Main, Topbar)

-- ============================================================
-- ELEMENT FACTORY HELPERS
-- ============================================================
local function makeLabel(parent, text, size, xAlign, font, color, zindex)
    local l = Instance.new("TextLabel")
    l.Size = size or UDim2.new(1, -10, 0, 20)
    l.BackgroundTransparency = 1
    l.Text = text or ""
    l.TextColor3 = color or SelectedTheme.TextColor
    l.TextSize = 13
    l.Font = font or Enum.Font.Gotham
    l.TextXAlignment = xAlign or Enum.TextXAlignment.Left
    if zindex then l.ZIndex = zindex end
    l.Parent = parent
    return l
end

local function makeFrame(parent, size, pos, color, transparent)
    local f = Instance.new("Frame")
    f.Size = size or UDim2.new(1, -10, 0, 44)
    f.Position = pos or UDim2.new(0, 5, 0, 0)
    f.BackgroundColor3 = color or SelectedTheme.ElementBackground
    f.BackgroundTransparency = transparent or 0
    f.BorderSizePixel = 0
    f.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = f
    local s = Instance.new("UIStroke")
    s.Color = SelectedTheme.ElementStroke
    s.Thickness = 1
    s.Transparency = 0.3
    s.Parent = f
    return f, s
end

local function makeButton(parent, size, pos, color)
    local b = Instance.new("TextButton")
    b.Size = size or UDim2.new(1, -10, 0, 44)
    b.Position = pos or UDim2.new(0, 5, 0, 0)
    b.BackgroundColor3 = color or SelectedTheme.ElementBackground
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = b
    return b
end

local function makeInput(parent, size, pos, placeholder)
    local box = Instance.new("TextBox")
    box.Size = size or UDim2.new(1, -10, 1, 0)
    box.Position = pos or UDim2.new(0, 8, 0, 0)
    box.BackgroundTransparency = 1
    box.PlaceholderText = placeholder or ""
    box.PlaceholderColor3 = SelectedTheme.PlaceholderColor
    box.TextColor3 = SelectedTheme.TextColor
    box.TextSize = 13
    box.Font = Enum.Font.Gotham
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false
    box.Parent = parent
    return box
end

-- ============================================================
-- NOTIFY
-- ============================================================
function CyberUI:Notify(data)
    task.spawn(function()
        local notif = Instance.new("Frame")
        notif.Name = data.Title or "Notif"
        notif.Size = UDim2.new(1, 0, 0, 0)
        notif.BackgroundColor3 = SelectedTheme.NotificationBackground
        notif.BorderSizePixel = 0
        notif.BackgroundTransparency = 1
        notif.Parent = NotifHolder

        local nc = Instance.new("UICorner")
        nc.CornerRadius = UDim.new(0, 5)
        nc.Parent = notif

        local ns = Instance.new("UIStroke")
        ns.Color = SelectedTheme.AccentColor
        ns.Thickness = 1
        ns.Transparency = 0.4
        ns.Parent = notif

        local npad = Instance.new("UIPadding")
        npad.PaddingLeft   = UDim.new(0, 10)
        npad.PaddingRight  = UDim.new(0, 10)
        npad.PaddingTop    = UDim.new(0, 8)
        npad.PaddingBottom = UDim.new(0, 8)
        npad.Parent = notif

        local nTitle = Instance.new("TextLabel")
        nTitle.Size = UDim2.new(1, 0, 0, 18)
        nTitle.BackgroundTransparency = 1
        nTitle.Text = data.Title or "Notice"
        nTitle.TextColor3 = SelectedTheme.AccentColor
        nTitle.TextSize = 13
        nTitle.Font = Enum.Font.GothamBold
        nTitle.TextXAlignment = Enum.TextXAlignment.Left
        nTitle.TextTransparency = 1
        nTitle.Parent = notif

        local nContent = Instance.new("TextLabel")
        nContent.Size = UDim2.new(1, 0, 0, 0)
        nContent.Position = UDim2.new(0, 0, 0, 22)
        nContent.BackgroundTransparency = 1
        nContent.Text = data.Content or ""
        nContent.TextColor3 = SelectedTheme.TextColor
        nContent.TextSize = 12
        nContent.Font = Enum.Font.Gotham
        nContent.TextXAlignment = Enum.TextXAlignment.Left
        nContent.TextWrapped = true
        nContent.AutomaticSize = Enum.AutomaticSize.Y
        nContent.TextTransparency = 1
        nContent.Parent = notif

        task.wait()
        notif.Visible = true

        local targetH = 20 + nContent.TextBounds.Y + 24
        tween(notif, med, {Size = UDim2.new(1, 0, 0, math.max(targetH, 58)), BackgroundTransparency = 0.2})
        task.wait(0.15)
        tween(nTitle, fast, {TextTransparency = 0})
        task.wait(0.05)
        tween(nContent, fast, {TextTransparency = 0.1})

        local wait = data.Duration or math.clamp(#(data.Content or "") * 0.06 + 2.5, 3, 10)
        task.wait(wait)

        tween(notif, med, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0)})
        tween(nTitle,   fast, {TextTransparency = 1})
        tween(nContent, fast, {TextTransparency = 1})
        tween(ns, fast, {Transparency = 1})
        task.wait(0.5)
        notif:Destroy()
    end)
end

-- ============================================================
-- SHOW / HIDE
-- ============================================================
local function showUI()
    Hidden = false
    Main.Visible = true
    tween(Main, med, {BackgroundTransparency = 0})
    tween(mainStroke, med, {Transparency = 0.5})
end

local function hideUI(notify)
    Hidden = true
    tween(Main, med, {BackgroundTransparency = 1})
    task.wait(0.45)
    Main.Visible = false
    if notify then
        CyberUI:Notify({Title = "Interface Hidden", Content = "Press the configured key to restore the interface.", Duration = 5})
    end
end

local function minimiseUI()
    Minimised = true
    ElementsContainer.Visible = false
    TabListFrame.Visible = false
    tween(Main, med, {Size = UDim2.new(0, 520, 0, 48)})
    MinBtn.Text = "+"
end

local function maximiseUI()
    Minimised = false
    tween(Main, med, {Size = UDim2.new(0, 520, 0, 480)})
    task.wait(0.3)
    TabListFrame.Visible = true
    ElementsContainer.Visible = true
    MinBtn.Text = "-"
end

MinBtn.MouseButton1Click:Connect(function()
    if Debounce then return end
    if Minimised then maximiseUI() else minimiseUI() end
end)

HideBtn.MouseButton1Click:Connect(function()
    if Debounce then return end
    if Hidden then showUI() else hideUI(true) end
end)

-- Search
local function openSearch()
    searchOpen = true
    SearchFrame.Visible = true
    SearchFrame.BackgroundTransparency = 1
    tween(SearchFrame, fast, {BackgroundTransparency = 0})
    SearchInput:CaptureFocus()
end

local function closeSearch()
    searchOpen = false
    tween(SearchFrame, fast, {BackgroundTransparency = 1})
    task.wait(0.25)
    SearchFrame.Visible = false
    SearchInput.Text = ""
end

SearchBtn.MouseButton1Click:Connect(function()
    if searchOpen then closeSearch() else openSearch() end
end)

SearchInput.FocusLost:Connect(function()
    if #SearchInput.Text == 0 then
        task.wait(0.12)
        closeSearch()
    end
end)

SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower(SearchInput.Text)
    local currentPage = PageLayout.CurrentPage
    if not currentPage then return end
    for _, el in ipairs(currentPage:GetChildren()) do
        if el:IsA("Frame") and el.Name ~= "Placeholder" and el.Name ~= "SectionTitle" then
            if #q == 0 then
                el.Visible = true
            else
                el.Visible = string.find(string.lower(el.Name), q, 1, true) ~= nil
            end
        end
    end
end)

-- ============================================================
-- SAVE / LOAD CONFIG
-- ============================================================
local function SaveConfiguration()
    if not CEnabled or not globalLoaded then return end
    local data = {}
    for i, v in pairs(CyberUI.Flags) do
        if v.Type == "ColorPicker" then
            data[i] = {R = v.Color.R * 255, G = v.Color.G * 255, B = v.Color.B * 255}
        else
            data[i] = v.CurrentValue or v.CurrentKeybind or v.CurrentOption or v.Color
        end
    end
    callSafely(writefile, ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension, HttpService:JSONEncode(data))
end

local function LoadConfigurationData(raw)
    local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok then warn("CyberUI | Config decode error") return end
    for flag, val in pairs(data) do
        local el = CyberUI.Flags[flag]
        if el and el.Set then
            task.spawn(function()
                if el.Type == "ColorPicker" then
                    el:Set(Color3.fromRGB(val.R, val.G, val.B))
                else
                    el:Set(val)
                end
            end)
        end
    end
    return true
end

-- ============================================================
-- CREATE WINDOW
-- ============================================================
function CyberUI:CreateWindow(Settings)
    Settings = Settings or {}

    -- Apply theme
    if Settings.Theme then
        ApplyTheme(Settings.Theme)
    end

    -- Title
    TopTitle.Text = Settings.Name or "CyberUI"
    LoadTitle.Text = Settings.LoadingTitle or "CYBERUI"
    LoadSubtitle.Text = Settings.LoadingSubtitle or "Interface Suite"

    -- Config
    pcall(function()
        if Settings.ConfigurationSaving then
            CEnabled   = Settings.ConfigurationSaving.Enabled == true
            CFileName  = Settings.ConfigurationSaving.FileName or tostring(game.PlaceId)
            ConfigurationFolder = Settings.ConfigurationSaving.FolderName or ConfigurationFolder
            if CEnabled then
                ensureFolder(RayfieldFolder)
                ensureFolder(ConfigurationFolder)
            end
        end
    end)

    -- Keybind override
    local toggleKey = "RightControl"
    if Settings.ToggleUIKeybind then
        if type(Settings.ToggleUIKeybind) == "string" then
            toggleKey = string.upper(Settings.ToggleUIKeybind)
        elseif typeof(Settings.ToggleUIKeybind) == "EnumItem" then
            toggleKey = Settings.ToggleUIKeybind.Name
        end
    end

    -- Global keybind
    local hkConn = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode[toggleKey] then
            if Hidden then showUI() else hideUI(false) end
        end
    end)
    table.insert(keybindConns, hkConn)

    -- Show loading animation
    Main.Visible = true
    Main.BackgroundTransparency = 1
    LoadingFrame.Visible = true
    LoadingFrame.BackgroundTransparency = 0
    ElementsContainer.Visible = false
    TabListFrame.Visible = false
    Topbar.Visible = false

    tween(Main, slow, {BackgroundTransparency = 0})
    tween(Main, slow, {Size = UDim2.new(0, 520, 0, 480)})

    task.wait(0.4)
    tween(LoadTitle,    med, {TextTransparency = 0})
    task.wait(0.15)
    tween(LoadSubtitle, med, {TextTransparency = 0})

    task.wait(1.2)
    tween(LoadTitle,    fast, {TextTransparency = 1})
    tween(LoadSubtitle, fast, {TextTransparency = 1})
    task.wait(0.25)
    tween(LoadingFrame, fast, {BackgroundTransparency = 1})
    task.wait(0.2)
    LoadingFrame.Visible = false

    Topbar.Visible = true
    Topbar.BackgroundTransparency = 1
    tween(Topbar, med, {BackgroundTransparency = 0})
    task.wait(0.1)
    TabListFrame.Visible = true
    task.wait(0.1)
    ElementsContainer.Visible = true

    -- --------------------------------------------------------
    -- WINDOW OBJECT
    -- --------------------------------------------------------
    local Window = {}

    function Window:ModifyTheme(newTheme)
        ApplyTheme(newTheme)
        CyberUI:Notify({Title = "Theme Changed", Content = "Theme has been updated.", Duration = 3})
    end

    -- --------------------------------------------------------
    -- CREATE TAB
    -- --------------------------------------------------------
    local firstTab = nil

    function Window:CreateTab(Name, _Image)
        -- Tab button
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = Name
        tabBtn.AutomaticSize = Enum.AutomaticSize.X
        tabBtn.Size = UDim2.new(0, 0, 1, 0)
        tabBtn.BackgroundColor3 = SelectedTheme.TabBackground
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = Name
        tabBtn.TextColor3 = SelectedTheme.TabTextColor
        tabBtn.TextSize = 12
        tabBtn.Font = Enum.Font.GothamBold
        tabBtn.BackgroundTransparency = 0.4
        tabBtn.Parent = TabListFrame

        local tabBtnCorner = Instance.new("UICorner")
        tabBtnCorner.CornerRadius = UDim.new(0, 4)
        tabBtnCorner.Parent = tabBtn

        local tabBtnStroke = Instance.new("UIStroke")
        tabBtnStroke.Color = SelectedTheme.TabStroke
        tabBtnStroke.Thickness = 1
        tabBtnStroke.Transparency = 0.4
        tabBtnStroke.Parent = tabBtn

        local tabBtnPad = Instance.new("UIPadding")
        tabBtnPad.PaddingLeft  = UDim.new(0, 12)
        tabBtnPad.PaddingRight = UDim.new(0, 12)
        tabBtnPad.Parent = tabBtn

        -- Tab page
        local tabPage = Instance.new("ScrollingFrame")
        tabPage.Name = Name
        tabPage.Size = UDim2.new(1, 0, 1, 0)
        tabPage.BackgroundTransparency = 1
        tabPage.BorderSizePixel = 0
        tabPage.ScrollBarThickness = 2
        tabPage.ScrollBarImageColor3 = SelectedTheme.AccentColor
        tabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabPage.LayoutOrder = #ElementsContainer:GetChildren()
        tabPage.Parent = ElementsContainer

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 5)
        pageLayout.Parent = tabPage

        local pagePad = Instance.new("UIPadding")
        pagePad.PaddingLeft   = UDim.new(0, 8)
        pagePad.PaddingRight  = UDim.new(0, 8)
        pagePad.PaddingTop    = UDim.new(0, 6)
        pagePad.PaddingBottom = UDim.new(0, 6)
        pagePad.Parent = tabPage

        if not firstTab then
            firstTab = tabPage
            PageLayout.Animated = false
            PageLayout:JumpTo(tabPage)
            PageLayout.Animated = true
            tabBtn.BackgroundTransparency = 0
            tabBtn.TextColor3 = SelectedTheme.SelectedTabTextColor
            tabBtnStroke.Transparency = 0.1
        end

        tabBtn.MouseButton1Click:Connect(function()
            if Minimised then return end
            PageLayout:JumpTo(tabPage)
            for _, tb in ipairs(TabListFrame:GetChildren()) do
                if tb:IsA("TextButton") then
                    tween(tb, fast, {
                        BackgroundTransparency = 0.4,
                        TextColor3 = SelectedTheme.TabTextColor
                    })
                end
            end
            tween(tabBtn, fast, {
                BackgroundTransparency = 0,
                TextColor3 = SelectedTheme.SelectedTabTextColor
            })
            tabBtnStroke.Transparency = 0.1
        end)

        tabBtn.MouseEnter:Connect(function()
            if PageLayout.CurrentPage ~= tabPage then
                tween(tabBtn, fast, {BackgroundTransparency = 0.2})
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if PageLayout.CurrentPage ~= tabPage then
                tween(tabBtn, fast, {BackgroundTransparency = 0.4})
            end
        end)

        -- --------------------------------------------------------
        -- TAB ELEMENTS
        -- --------------------------------------------------------
        local Tab = {}

        -- Helper: standard element frame
        local function makeElement(name)
            local el, stroke = makeFrame(tabPage, UDim2.new(1, 0, 0, 44), UDim2.new(0, 0, 0, 0), SelectedTheme.ElementBackground)
            el.Name = name
            el.LayoutOrder = #tabPage:GetChildren()
            el.BackgroundTransparency = 0

            -- Glitch scan effect on hover
            el.MouseEnter:Connect(function()
                tween(el, fast, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover})
                tween(stroke, fast, {Transparency = 0})
            end)
            el.MouseLeave:Connect(function()
                tween(el, fast, {BackgroundColor3 = SelectedTheme.ElementBackground})
                tween(stroke, fast, {Transparency = 0.3})
            end)

            return el, stroke
        end

        -- ---- Section ----
        function Tab:CreateSection(SectionName)
            local sec = Instance.new("Frame")
            sec.Name = "SectionTitle"
            sec.Size = UDim2.new(1, 0, 0, 22)
            sec.BackgroundTransparency = 1
            sec.LayoutOrder = #tabPage:GetChildren()
            sec.Parent = tabPage

            local secLine = Instance.new("Frame")
            secLine.Size = UDim2.new(1, 0, 0, 1)
            secLine.Position = UDim2.new(0, 0, 1, -1)
            secLine.BackgroundColor3 = SelectedTheme.AccentColor
            secLine.BackgroundTransparency = 0.6
            secLine.BorderSizePixel = 0
            secLine.Parent = sec

            local secTitle = Instance.new("TextLabel")
            secTitle.Size = UDim2.new(1, 0, 1, 0)
            secTitle.BackgroundTransparency = 1
            secTitle.Text = string.upper(SectionName)
            secTitle.TextColor3 = SelectedTheme.AccentColor
            secTitle.TextSize = 11
            secTitle.Font = Enum.Font.GothamBold
            secTitle.TextXAlignment = Enum.TextXAlignment.Left
            secTitle.Parent = sec

            local val = {}
            function val:Set(n) secTitle.Text = string.upper(n) end
            return val
        end

        -- ---- Divider ----
        function Tab:CreateDivider()
            local div = Instance.new("Frame")
            div.Name = "Divider"
            div.Size = UDim2.new(1, 0, 0, 1)
            div.BackgroundColor3 = SelectedTheme.AccentColor
            div.BackgroundTransparency = 0.7
            div.BorderSizePixel = 0
            div.LayoutOrder = #tabPage:GetChildren()
            div.Parent = tabPage

            local val = {}
            function val:Set(v) div.Visible = v end
            return val
        end

        -- ---- Label ----
        function Tab:CreateLabel(text)
            local el, stroke = makeElement("Label_" .. text)
            el.Size = UDim2.new(1, 0, 0, 36)

            local lbl = makeLabel(el, text, UDim2.new(1, -16, 1, 0), Enum.TextXAlignment.Left)
            lbl.Position = UDim2.new(0, 10, 0, 0)
            lbl.TextColor3 = SelectedTheme.AccentColor
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12

            local val = {}
            function val:Set(n) lbl.Text = n end
            return val
        end

        -- ---- Paragraph ----
        function Tab:CreateParagraph(data)
            local container = Instance.new("Frame")
            container.Name = data.Title or "Paragraph"
            container.Size = UDim2.new(1, 0, 0, 0)
            container.AutomaticSize = Enum.AutomaticSize.Y
            container.BackgroundColor3 = SelectedTheme.SecondaryElementBackground
            container.BorderSizePixel = 0
            container.LayoutOrder = #tabPage:GetChildren()
            container.Parent = tabPage

            local pCorner = Instance.new("UICorner")
            pCorner.CornerRadius = UDim.new(0, 5)
            pCorner.Parent = container

            local pStroke = Instance.new("UIStroke")
            pStroke.Color = SelectedTheme.SecondaryElementStroke
            pStroke.Thickness = 1
            pStroke.Transparency = 0.3
            pStroke.Parent = container

            local pPad = Instance.new("UIPadding")
            pPad.PaddingLeft   = UDim.new(0, 10)
            pPad.PaddingRight  = UDim.new(0, 10)
            pPad.PaddingTop    = UDim.new(0, 8)
            pPad.PaddingBottom = UDim.new(0, 8)
            pPad.Parent = container

            local pLayout = Instance.new("UIListLayout")
            pLayout.SortOrder = Enum.SortOrder.LayoutOrder
            pLayout.Padding = UDim.new(0, 4)
            pLayout.Parent = container

            local pTitle = Instance.new("TextLabel")
            pTitle.Size = UDim2.new(1, 0, 0, 18)
            pTitle.BackgroundTransparency = 1
            pTitle.Text = data.Title or ""
            pTitle.TextColor3 = SelectedTheme.AccentColor
            pTitle.TextSize = 13
            pTitle.Font = Enum.Font.GothamBold
            pTitle.TextXAlignment = Enum.TextXAlignment.Left
            pTitle.LayoutOrder = 1
            pTitle.Parent = container

            local pContent = Instance.new("TextLabel")
            pContent.Size = UDim2.new(1, 0, 0, 0)
            pContent.AutomaticSize = Enum.AutomaticSize.Y
            pContent.BackgroundTransparency = 1
            pContent.Text = data.Content or ""
            pContent.TextColor3 = SelectedTheme.TextColor
            pContent.TextSize = 12
            pContent.Font = Enum.Font.Gotham
            pContent.TextXAlignment = Enum.TextXAlignment.Left
            pContent.TextWrapped = true
            pContent.LayoutOrder = 2
            pContent.Parent = container

            local val = {}
            function val:Set(d)
                pTitle.Text = d.Title or ""
                pContent.Text = d.Content or ""
            end
            return val
        end

        -- ---- Button ----
        function Tab:CreateButton(ButtonSettings)
            local el, stroke = makeElement(ButtonSettings.Name)

            -- Cyber accent bar left
            local accentBar = Instance.new("Frame")
            accentBar.Size = UDim2.new(0, 2, 0.6, 0)
            accentBar.Position = UDim2.new(0, 0, 0.2, 0)
            accentBar.BackgroundColor3 = SelectedTheme.AccentColor
            accentBar.BorderSizePixel = 0
            accentBar.Parent = el

            local titleLabel = makeLabel(el, ButtonSettings.Name, UDim2.new(1, -80, 1, 0))
            titleLabel.Position = UDim2.new(0, 14, 0, 0)
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextSize = 13

            local execLabel = makeLabel(el, "[ EXECUTE ]", UDim2.new(0, 80, 1, 0), Enum.TextXAlignment.Right)
            execLabel.Position = UDim2.new(1, -90, 0, 0)
            execLabel.TextColor3 = SelectedTheme.AccentColor
            execLabel.TextSize = 11
            execLabel.Font = Enum.Font.GothamBold

            local interact = makeButton(el, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0))
            interact.BackgroundTransparency = 1
            interact.ZIndex = 5

            interact.MouseButton1Click:Connect(function()
                tween(el, fast, {BackgroundColor3 = SelectedTheme.AccentColorDim})
                tween(accentBar, fast, {BackgroundTransparency = 0.4})
                task.wait(0.08)
                local ok, err = pcall(ButtonSettings.Callback)
                tween(el, med, {BackgroundColor3 = SelectedTheme.ElementBackground})
                tween(accentBar, med, {BackgroundTransparency = 0})
                if not ok then
                    titleLabel.Text = "ERROR"
                    task.delay(1.2, function() titleLabel.Text = ButtonSettings.Name end)
                    warn("CyberUI | Button error:", err)
                end
                if not ButtonSettings.Ext then SaveConfiguration() end
            end)

            local val = {}
            function val:Set(n) titleLabel.Text = n end
            return val
        end

        -- ---- Toggle ----
        function Tab:CreateToggle(ToggleSettings)
            local el, stroke = makeElement(ToggleSettings.Name)

            local accentBar = Instance.new("Frame")
            accentBar.Size = UDim2.new(0, 2, 0.6, 0)
            accentBar.Position = UDim2.new(0, 0, 0.2, 0)
            accentBar.BackgroundColor3 = SelectedTheme.AccentColor
            accentBar.BorderSizePixel = 0
            accentBar.Parent = el

            local titleLabel = makeLabel(el, ToggleSettings.Name, UDim2.new(1, -60, 1, 0))
            titleLabel.Position = UDim2.new(0, 14, 0, 0)
            titleLabel.Font = Enum.Font.GothamBold

            -- Toggle switch
            local switchBg = Instance.new("Frame")
            switchBg.Size = UDim2.new(0, 42, 0, 20)
            switchBg.Position = UDim2.new(1, -54, 0.5, 0)
            switchBg.AnchorPoint = Vector2.new(1, 0.5)
            switchBg.BackgroundColor3 = SelectedTheme.ToggleBackground
            switchBg.BorderSizePixel = 0
            switchBg.Parent = el

            local swCorner = Instance.new("UICorner")
            swCorner.CornerRadius = UDim.new(0, 10)
            swCorner.Parent = switchBg

            local swStroke = Instance.new("UIStroke")
            swStroke.Color = ToggleSettings.CurrentValue and SelectedTheme.ToggleEnabledOuterStroke or SelectedTheme.ToggleDisabledOuterStroke
            swStroke.Thickness = 1
            swStroke.Parent = switchBg

            local indicator = Instance.new("Frame")
            indicator.Size = UDim2.new(0, 14, 0, 14)
            indicator.AnchorPoint = Vector2.new(0.5, 0.5)
            indicator.Position = ToggleSettings.CurrentValue and UDim2.new(1, -10, 0.5, 0) or UDim2.new(0, 10, 0.5, 0)
            indicator.BackgroundColor3 = ToggleSettings.CurrentValue and SelectedTheme.ToggleEnabled or SelectedTheme.ToggleDisabled
            indicator.BorderSizePixel = 0
            indicator.Parent = switchBg

            local indCorner = Instance.new("UICorner")
            indCorner.CornerRadius = UDim.new(0, 7)
            indCorner.Parent = indicator

            local indStroke = Instance.new("UIStroke")
            indStroke.Color = ToggleSettings.CurrentValue and SelectedTheme.ToggleEnabledStroke or SelectedTheme.ToggleDisabledStroke
            indStroke.Thickness = 1
            indStroke.Parent = indicator

            local interact = makeButton(el, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0))
            interact.BackgroundTransparency = 1
            interact.ZIndex = 5

            local function setState(val, runCallback)
                ToggleSettings.CurrentValue = val
                tween(indicator, med, {
                    Position = val and UDim2.new(1, -10, 0.5, 0) or UDim2.new(0, 10, 0.5, 0),
                    BackgroundColor3 = val and SelectedTheme.ToggleEnabled or SelectedTheme.ToggleDisabled,
                })
                tween(indStroke, fast, {Color = val and SelectedTheme.ToggleEnabledStroke or SelectedTheme.ToggleDisabledStroke})
                tween(swStroke,  fast, {Color = val and SelectedTheme.ToggleEnabledOuterStroke or SelectedTheme.ToggleDisabledOuterStroke})
                tween(accentBar, fast, {BackgroundColor3 = val and SelectedTheme.AccentColor or SelectedTheme.AccentColorDim})

                if runCallback then
                    local ok, err = pcall(ToggleSettings.Callback, val)
                    if not ok then warn("CyberUI | Toggle error:", err) end
                end
                if not ToggleSettings.Ext then SaveConfiguration() end
            end

            interact.MouseButton1Click:Connect(function()
                setState(not ToggleSettings.CurrentValue, true)
            end)

            function ToggleSettings:Set(val)
                setState(val, true)
            end

            if not ToggleSettings.Ext and Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled and ToggleSettings.Flag then
                CyberUI.Flags[ToggleSettings.Flag] = ToggleSettings
            end

            return ToggleSettings
        end

        -- ---- Slider ----
        function Tab:CreateSlider(SliderSettings)
            local el, stroke = makeElement(SliderSettings.Name)
            el.Size = UDim2.new(1, 0, 0, 54)

            local accentBar = Instance.new("Frame")
            accentBar.Size = UDim2.new(0, 2, 0.6, 0)
            accentBar.Position = UDim2.new(0, 0, 0.2, 0)
            accentBar.BackgroundColor3 = SelectedTheme.AccentColor
            accentBar.BorderSizePixel = 0
            accentBar.Parent = el

            local titleLabel = makeLabel(el, SliderSettings.Name, UDim2.new(1, -70, 0, 20))
            titleLabel.Position = UDim2.new(0, 14, 0, 6)
            titleLabel.Font = Enum.Font.GothamBold

            local valLabel = makeLabel(el, tostring(SliderSettings.CurrentValue) .. (SliderSettings.Suffix and " " .. SliderSettings.Suffix or ""),
                UDim2.new(0, 60, 0, 20), Enum.TextXAlignment.Right)
            valLabel.Position = UDim2.new(1, -70, 0, 6)
            valLabel.TextColor3 = SelectedTheme.AccentColor
            valLabel.Font = Enum.Font.GothamBold

            local trackBg = Instance.new("Frame")
            trackBg.Size = UDim2.new(1, -28, 0, 6)
            trackBg.Position = UDim2.new(0, 14, 0, 34)
            trackBg.BackgroundColor3 = SelectedTheme.SliderBackground
            trackBg.BorderSizePixel = 0
            trackBg.Parent = el

            local tkCorner = Instance.new("UICorner")
            tkCorner.CornerRadius = UDim.new(0, 3)
            tkCorner.Parent = trackBg

            local tkStroke = Instance.new("UIStroke")
            tkStroke.Color = SelectedTheme.SliderStroke
            tkStroke.Thickness = 1
            tkStroke.Transparency = 0.3
            tkStroke.Parent = trackBg

            local fill = Instance.new("Frame")
            local pct = (SliderSettings.CurrentValue - SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])
            fill.Size = UDim2.new(math.clamp(pct, 0, 1), 0, 1, 0)
            fill.BackgroundColor3 = SelectedTheme.SliderProgress
            fill.BorderSizePixel = 0
            fill.Parent = trackBg

            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0, 3)
            fillCorner.Parent = fill

            local interact = Instance.new("TextButton")
            interact.Size = UDim2.new(1, 0, 0, 16)
            interact.Position = UDim2.new(0, 0, 0, -5)
            interact.BackgroundTransparency = 1
            interact.Text = ""
            interact.ZIndex = 5
            interact.Parent = trackBg

            local dragging = false
            interact.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            interact.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            local stepConn = RunService.RenderStepped:Connect(function()
                if dragging then
                    local mouse = UserInputService:GetMouseLocation()
                    local rel = math.clamp((mouse.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
                    local raw = SliderSettings.Range[1] + rel * (SliderSettings.Range[2] - SliderSettings.Range[1])
                    local snapped = math.floor(raw / SliderSettings.Increment + 0.5) * SliderSettings.Increment
                    snapped = math.clamp(snapped, SliderSettings.Range[1], SliderSettings.Range[2])

                    local newPct = (snapped - SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])
                    fill.Size = UDim2.new(newPct, 0, 1, 0)
                    valLabel.Text = tostring(snapped) .. (SliderSettings.Suffix and " " .. SliderSettings.Suffix or "")

                    if SliderSettings.CurrentValue ~= snapped then
                        SliderSettings.CurrentValue = snapped
                        pcall(SliderSettings.Callback, snapped)
                        if not SliderSettings.Ext then SaveConfiguration() end
                    end
                end
            end)

            el.Destroying:Connect(function() stepConn:Disconnect() end)

            function SliderSettings:Set(val)
                val = math.clamp(val, SliderSettings.Range[1], SliderSettings.Range[2])
                SliderSettings.CurrentValue = val
                local p = (val - SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])
                tween(fill, fast, {Size = UDim2.new(p, 0, 1, 0)})
                valLabel.Text = tostring(val) .. (SliderSettings.Suffix and " " .. SliderSettings.Suffix or "")
                pcall(SliderSettings.Callback, val)
                if not SliderSettings.Ext then SaveConfiguration() end
            end

            if Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled and SliderSettings.Flag then
                CyberUI.Flags[SliderSettings.Flag] = SliderSettings
            end

            return SliderSettings
        end

        -- ---- Input ----
        function Tab:CreateInput(InputSettings)
            local el, stroke = makeElement(InputSettings.Name)

            local accentBar = Instance.new("Frame")
            accentBar.Size = UDim2.new(0, 2, 0.6, 0)
            accentBar.Position = UDim2.new(0, 0, 0.2, 0)
            accentBar.BackgroundColor3 = SelectedTheme.AccentColor
            accentBar.BorderSizePixel = 0
            accentBar.Parent = el

            local titleLabel = makeLabel(el, InputSettings.Name, UDim2.new(0.45, 0, 1, 0))
            titleLabel.Position = UDim2.new(0, 14, 0, 0)
            titleLabel.Font = Enum.Font.GothamBold

            local inputFrame = Instance.new("Frame")
            inputFrame.Size = UDim2.new(0.5, -10, 0, 28)
            inputFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            inputFrame.AnchorPoint = Vector2.new(0, 0.5)
            inputFrame.BackgroundColor3 = SelectedTheme.InputBackground
            inputFrame.BorderSizePixel = 0
            inputFrame.Parent = el

            local ifCorner = Instance.new("UICorner")
            ifCorner.CornerRadius = UDim.new(0, 4)
            ifCorner.Parent = inputFrame

            local ifStroke = Instance.new("UIStroke")
            ifStroke.Color = SelectedTheme.InputStroke
            ifStroke.Thickness = 1
            ifStroke.Transparency = 0.3
            ifStroke.Parent = inputFrame

            local box = makeInput(inputFrame, UDim2.new(1, -8, 1, 0), UDim2.new(0, 6, 0, 0), InputSettings.PlaceholderText or "")
            box.Text = InputSettings.CurrentValue or ""

            box.Focused:Connect(function()
                tween(ifStroke, fast, {Transparency = 0})
                tween(el, fast, {BackgroundColor3 = SelectedTheme.ElementBackgroundHover})
            end)

            box.FocusLost:Connect(function()
                tween(ifStroke, fast, {Transparency = 0.3})
                tween(el, fast, {BackgroundColor3 = SelectedTheme.ElementBackground})
                InputSettings.CurrentValue = box.Text
                local ok, err = pcall(InputSettings.Callback, box.Text)
                if not ok then warn("CyberUI | Input error:", err) end
                if InputSettings.RemoveTextAfterFocusLost then box.Text = "" end
                if not InputSettings.Ext then SaveConfiguration() end
            end)

            function InputSettings:Set(text)
                box.Text = text
                InputSettings.CurrentValue = text
                pcall(InputSettings.Callback, text)
                if not InputSettings.Ext then SaveConfiguration() end
            end

            if Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled and InputSettings.Flag then
                CyberUI.Flags[InputSettings.Flag] = InputSettings
            end

            return InputSettings
        end

        -- ---- Dropdown ----
        function Tab:CreateDropdown(DropdownSettings)
            local el, stroke = makeElement(DropdownSettings.Name)
            el.Size = UDim2.new(1, 0, 0, 44)
            el.ClipsDescendants = true

            DropdownSettings.CurrentOption = DropdownSettings.CurrentOption or {}
            if type(DropdownSettings.CurrentOption) == "string" then
                DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption}
            end
            if not DropdownSettings.MultipleOptions then
                DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption[1]}
            end

            local accentBar = Instance.new("Frame")
            accentBar.Size = UDim2.new(0, 2, 0.6, 0)
            accentBar.Position = UDim2.new(0, 0, 0.2, 0)
            accentBar.BackgroundColor3 = SelectedTheme.AccentColor
            accentBar.BorderSizePixel = 0
            accentBar.Parent = el

            local titleLabel = makeLabel(el, DropdownSettings.Name, UDim2.new(0.45, 0, 0, 44))
            titleLabel.Position = UDim2.new(0, 14, 0, 0)
            titleLabel.Font = Enum.Font.GothamBold

            local function getSelectedText()
                if #DropdownSettings.CurrentOption == 0 then return "None"
                elseif #DropdownSettings.CurrentOption == 1 then return DropdownSettings.CurrentOption[1]
                else return "Various" end
            end

            local selectedLabel = makeLabel(el, getSelectedText(), UDim2.new(0.45, -50, 0, 44), Enum.TextXAlignment.Right)
            selectedLabel.Position = UDim2.new(0.55, -50, 0, 0)
            selectedLabel.TextColor3 = SelectedTheme.AccentColor
            selectedLabel.Font = Enum.Font.GothamBold
            selectedLabel.TextSize = 12

            local chevron = makeLabel(el, "v", UDim2.new(0, 20, 0, 44), Enum.TextXAlignment.Center)
            chevron.Position = UDim2.new(1, -26, 0, 0)
            chevron.TextColor3 = SelectedTheme.AccentColor
            chevron.Font = Enum.Font.GothamBold
            chevron.TextSize = 11

            -- Option list
            local listHolder = Instance.new("Frame")
            listHolder.Size = UDim2.new(1, 0, 0, 0)
            listHolder.Position = UDim2.new(0, 0, 0, 44)
            listHolder.BackgroundColor3 = SelectedTheme.ElementBackground
            listHolder.BorderSizePixel = 0
            listHolder.Visible = false
            listHolder.Parent = el

            local listLayout = Instance.new("UIListLayout")
            listLayout.SortOrder = Enum.SortOrder.LayoutOrder
            listLayout.Parent = listHolder

            local opened = false

            local function buildOptions()
                for _, c in ipairs(listHolder:GetChildren()) do
                    if c:IsA("Frame") then c:Destroy() end
                end

                for _, opt in ipairs(DropdownSettings.Options) do
                    local optFrame = Instance.new("Frame")
                    optFrame.Name = opt
                    optFrame.Size = UDim2.new(1, 0, 0, 32)
                    optFrame.BackgroundColor3 = table.find(DropdownSettings.CurrentOption, opt)
                        and SelectedTheme.DropdownSelected or SelectedTheme.DropdownUnselected
                    optFrame.BorderSizePixel = 0
                    optFrame.Parent = listHolder

                    local optLabel = makeLabel(optFrame, opt, UDim2.new(1, -20, 1, 0))
                    optLabel.Position = UDim2.new(0, 12, 0, 0)
                    optLabel.TextColor3 = SelectedTheme.TextColor
                    optLabel.TextSize = 12

                    local optBtn = makeButton(optFrame, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0))
                    optBtn.BackgroundTransparency = 1
                    optBtn.ZIndex = 10

                    optBtn.MouseButton1Click:Connect(function()
                        if not DropdownSettings.MultipleOptions then
                            DropdownSettings.CurrentOption = {opt}
                        else
                            if table.find(DropdownSettings.CurrentOption, opt) then
                                table.remove(DropdownSettings.CurrentOption, table.find(DropdownSettings.CurrentOption, opt))
                            else
                                table.insert(DropdownSettings.CurrentOption, opt)
                            end
                        end

                        selectedLabel.Text = getSelectedText()

                        for _, c in ipairs(listHolder:GetChildren()) do
                            if c:IsA("Frame") then
                                c.BackgroundColor3 = table.find(DropdownSettings.CurrentOption, c.Name)
                                    and SelectedTheme.DropdownSelected or SelectedTheme.DropdownUnselected
                            end
                        end

                        local ok, err = pcall(DropdownSettings.Callback, DropdownSettings.CurrentOption)
                        if not ok then warn("CyberUI | Dropdown error:", err) end
                        if not DropdownSettings.MultipleOptions then
                            opened = false
                            listHolder.Visible = false
                            tween(el, med, {Size = UDim2.new(1, 0, 0, 44)})
                            chevron.Text = "v"
                        end
                        if not DropdownSettings.Ext then SaveConfiguration() end
                    end)
                end

                local totalH = #DropdownSettings.Options * 32
                listHolder.Size = UDim2.new(1, 0, 0, totalH)
            end

            buildOptions()

            local interact = makeButton(el, UDim2.new(1, 0, 0, 44), UDim2.new(0, 0, 0, 0))
            interact.BackgroundTransparency = 1
            interact.ZIndex = 5

            interact.MouseButton1Click:Connect(function()
                if Debounce then return end
                opened = not opened
                if opened then
                    listHolder.Visible = true
                    local totalH = #DropdownSettings.Options * 32
                    tween(el, med, {Size = UDim2.new(1, 0, 0, 44 + totalH)})
                    chevron.Text = "^"
                else
                    tween(el, med, {Size = UDim2.new(1, 0, 0, 44)})
                    chevron.Text = "v"
                    task.wait(0.4)
                    listHolder.Visible = false
                end
            end)

            function DropdownSettings:Set(option)
                if type(option) == "string" then option = {option} end
                DropdownSettings.CurrentOption = option
                selectedLabel.Text = getSelectedText()
                for _, c in ipairs(listHolder:GetChildren()) do
                    if c:IsA("Frame") then
                        c.BackgroundColor3 = table.find(DropdownSettings.CurrentOption, c.Name)
                            and SelectedTheme.DropdownSelected or SelectedTheme.DropdownUnselected
                    end
                end
                pcall(DropdownSettings.Callback, option)
                if not DropdownSettings.Ext then SaveConfiguration() end
            end

            function DropdownSettings:Refresh(optTable)
                DropdownSettings.Options = optTable
                buildOptions()
            end

            if Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled and DropdownSettings.Flag then
                CyberUI.Flags[DropdownSettings.Flag] = DropdownSettings
            end

            return DropdownSettings
        end

        -- ---- Keybind ----
        function Tab:CreateKeybind(KeybindSettings)
            local el, stroke = makeElement(KeybindSettings.Name)

            local accentBar = Instance.new("Frame")
            accentBar.Size = UDim2.new(0, 2, 0.6, 0)
            accentBar.Position = UDim2.new(0, 0, 0.2, 0)
            accentBar.BackgroundColor3 = SelectedTheme.AccentColor
            accentBar.BorderSizePixel = 0
            accentBar.Parent = el

            local titleLabel = makeLabel(el, KeybindSettings.Name, UDim2.new(0.55, 0, 1, 0))
            titleLabel.Position = UDim2.new(0, 14, 0, 0)
            titleLabel.Font = Enum.Font.GothamBold

            local kbFrame = Instance.new("Frame")
            kbFrame.Size = UDim2.new(0, 80, 0, 28)
            kbFrame.Position = UDim2.new(1, -90, 0.5, 0)
            kbFrame.AnchorPoint = Vector2.new(1, 0.5)
            kbFrame.BackgroundColor3 = SelectedTheme.InputBackground
            kbFrame.BorderSizePixel = 0
            kbFrame.Parent = el

            local kfCorner = Instance.new("UICorner")
            kfCorner.CornerRadius = UDim.new(0, 4)
            kfCorner.Parent = kbFrame

            local kfStroke = Instance.new("UIStroke")
            kfStroke.Color = SelectedTheme.InputStroke
            kfStroke.Thickness = 1
            kfStroke.Transparency = 0.3
            kfStroke.Parent = kbFrame

            local kbBox = Instance.new("TextBox")
            kbBox.Size = UDim2.new(1, -8, 1, 0)
            kbBox.Position = UDim2.new(0, 4, 0, 0)
            kbBox.BackgroundTransparency = 1
            kbBox.Text = KeybindSettings.CurrentKeybind or "None"
            kbBox.TextColor3 = SelectedTheme.AccentColor
            kbBox.TextSize = 12
            kbBox.Font = Enum.Font.GothamBold
            kbBox.TextXAlignment = Enum.TextXAlignment.Center
            kbBox.ClearTextOnFocus = false
            kbBox.Parent = kbFrame

            local checkingKey = false

            kbBox.Focused:Connect(function()
                checkingKey = true
                kbBox.Text = "..."
            end)

            kbBox.FocusLost:Connect(function()
                checkingKey = false
                if kbBox.Text == "..." or kbBox.Text == "" then
                    kbBox.Text = KeybindSettings.CurrentKeybind or "None"
                end
            end)

            local conn = UserInputService.InputBegan:Connect(function(input, processed)
                if checkingKey and input.KeyCode ~= Enum.KeyCode.Unknown then
                    local parts = string.split(tostring(input.KeyCode), ".")
                    local keyName = parts[3]
                    kbBox.Text = keyName
                    KeybindSettings.CurrentKeybind = keyName
                    kbBox:ReleaseFocus()
                    checkingKey = false
                    if KeybindSettings.CallOnChange then
                        pcall(KeybindSettings.Callback, keyName)
                    end
                    if not KeybindSettings.Ext then SaveConfiguration() end
                elseif not checkingKey and not processed and KeybindSettings.CurrentKeybind then
                    if input.KeyCode == Enum.KeyCode[KeybindSettings.CurrentKeybind] and not KeybindSettings.CallOnChange then
                        pcall(KeybindSettings.Callback)
                    end
                end
            end)
            table.insert(keybindConns, conn)

            function KeybindSettings:Set(key)
                kbBox.Text = tostring(key)
                KeybindSettings.CurrentKeybind = tostring(key)
                if KeybindSettings.CallOnChange then pcall(KeybindSettings.Callback, key) end
                if not KeybindSettings.Ext then SaveConfiguration() end
            end

            if Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled and KeybindSettings.Flag then
                CyberUI.Flags[KeybindSettings.Flag] = KeybindSettings
            end

            return KeybindSettings
        end

        -- ---- ColorPicker (inline HSV) ----
        function Tab:CreateColorPicker(CPSettings)
            CPSettings.Type = "ColorPicker"
            local el, stroke = makeElement(CPSettings.Name)
            el.Size = UDim2.new(1, 0, 0, 44)
            el.ClipsDescendants = true

            local accentBar = Instance.new("Frame")
            accentBar.Size = UDim2.new(0, 2, 0.6, 0)
            accentBar.Position = UDim2.new(0, 0, 0.2, 0)
            accentBar.BackgroundColor3 = SelectedTheme.AccentColor
            accentBar.BorderSizePixel = 0
            accentBar.Parent = el

            local titleLabel = makeLabel(el, CPSettings.Name, UDim2.new(1, -60, 0, 44))
            titleLabel.Position = UDim2.new(0, 14, 0, 0)
            titleLabel.Font = Enum.Font.GothamBold

            local display = Instance.new("Frame")
            display.Size = UDim2.new(0, 34, 0, 20)
            display.Position = UDim2.new(1, -44, 0.5, 0)
            display.AnchorPoint = Vector2.new(1, 0.5)
            display.BackgroundColor3 = CPSettings.Color or Color3.fromRGB(255, 255, 255)
            display.BorderSizePixel = 0
            display.Parent = el

            local dispCorner = Instance.new("UICorner")
            dispCorner.CornerRadius = UDim.new(0, 3)
            dispCorner.Parent = display

            local dispStroke = Instance.new("UIStroke")
            dispStroke.Color = SelectedTheme.ElementStroke
            dispStroke.Thickness = 1
            dispStroke.Parent = display

            -- Expanded picker
            local pickerFrame = Instance.new("Frame")
            pickerFrame.Size = UDim2.new(1, 0, 0, 130)
            pickerFrame.Position = UDim2.new(0, 0, 0, 44)
            pickerFrame.BackgroundTransparency = 1
            pickerFrame.Visible = false
            pickerFrame.Parent = el

            -- SV canvas (simplified gradient display)
            local svCanvas = Instance.new("Frame")
            svCanvas.Size = UDim2.new(1, -20, 0, 80)
            svCanvas.Position = UDim2.new(0, 10, 0, 4)
            svCanvas.BorderSizePixel = 0
            svCanvas.Parent = pickerFrame

            local svCorner = Instance.new("UICorner")
            svCorner.CornerRadius = UDim.new(0, 4)
            svCorner.Parent = svCanvas

            local svStroke = Instance.new("UIStroke")
            svStroke.Color = SelectedTheme.ElementStroke
            svStroke.Thickness = 1
            svStroke.Parent = svCanvas

            -- Hue slider
            local hueTrack = Instance.new("Frame")
            hueTrack.Size = UDim2.new(1, -20, 0, 14)
            hueTrack.Position = UDim2.new(0, 10, 0, 92)
            hueTrack.BorderSizePixel = 0
            hueTrack.Parent = pickerFrame

            local hCorner = Instance.new("UICorner")
            hCorner.CornerRadius = UDim.new(0, 3)
            hCorner.Parent = hueTrack

            -- Rainbow gradient
            local grad = Instance.new("UIGradient")
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0,   Color3.fromRGB(255,0,0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
                ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(0,255,255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
                ColorSequenceKeypoint.new(1,   Color3.fromRGB(255,0,0)),
            })
            grad.Parent = hueTrack

            local hueBtn = makeButton(hueTrack, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0))
            hueBtn.BackgroundTransparency = 1
            hueBtn.ZIndex = 8

            -- Hex input
            local hexFrame = Instance.new("Frame")
            hexFrame.Size = UDim2.new(0, 100, 0, 22)
            hexFrame.Position = UDim2.new(0, 10, 0, 110)
            hexFrame.BackgroundColor3 = SelectedTheme.InputBackground
            hexFrame.BorderSizePixel = 0
            hexFrame.Parent = pickerFrame

            local hxCorner = Instance.new("UICorner")
            hxCorner.CornerRadius = UDim.new(0, 3)
            hxCorner.Parent = hexFrame

            local hxStroke = Instance.new("UIStroke")
            hxStroke.Color = SelectedTheme.InputStroke
            hxStroke.Thickness = 1
            hxStroke.Parent = hexFrame

            local hexBox = Instance.new("TextBox")
            hexBox.Size = UDim2.new(1, -8, 1, 0)
            hexBox.Position = UDim2.new(0, 6, 0, 0)
            hexBox.BackgroundTransparency = 1
            hexBox.TextColor3 = SelectedTheme.TextColor
            hexBox.TextSize = 11
            hexBox.Font = Enum.Font.Code
            hexBox.TextXAlignment = Enum.TextXAlignment.Left
            hexBox.ClearTextOnFocus = false
            hexBox.Parent = hexFrame

            local h, s, v = (CPSettings.Color or Color3.fromRGB(255,255,255)):ToHSV()
            CPSettings.Color = CPSettings.Color or Color3.fromRGB(255,255,255)

            local function updateDisplay()
                local col = Color3.fromHSV(h, s, v)
                display.BackgroundColor3 = col
                svCanvas.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                hexBox.Text = string.format("#%02X%02X%02X", math.floor(col.R*255), math.floor(col.G*255), math.floor(col.B*255))
                CPSettings.Color = col
                pcall(CPSettings.Callback, col)
            end

            -- SV dragging
            local svDragging = false
            local svBtn = makeButton(svCanvas, UDim2.new(1,0,1,0), UDim2.new(0,0,0,0))
            svBtn.BackgroundTransparency = 1
            svBtn.ZIndex = 8

            svBtn.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then svDragging = true end
            end)
            svBtn.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then svDragging = false end
            end)

            local hueDragging = false
            hueBtn.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then hueDragging = true end
            end)
            hueBtn.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then hueDragging = false end
            end)

            local cpConn = RunService.RenderStepped:Connect(function()
                local mouse = UserInputService:GetMouseLocation()
                if svDragging then
                    local rx = math.clamp((mouse.X - svCanvas.AbsolutePosition.X) / svCanvas.AbsoluteSize.X, 0, 1)
                    local ry = math.clamp((mouse.Y - svCanvas.AbsolutePosition.Y) / svCanvas.AbsoluteSize.Y, 0, 1)
                    s = rx; v = 1 - ry
                    updateDisplay()
                    if not CPSettings.Ext then SaveConfiguration() end
                end
                if hueDragging then
                    h = math.clamp((mouse.X - hueTrack.AbsolutePosition.X) / hueTrack.AbsoluteSize.X, 0, 1)
                    updateDisplay()
                    if not CPSettings.Ext then SaveConfiguration() end
                end
            end)

            el.Destroying:Connect(function() cpConn:Disconnect() end)

            hexBox.FocusLost:Connect(function()
                local hex = hexBox.Text:gsub("#","")
                local r, g, b = hex:match("^(%x%x)(%x%x)(%x%x)$")
                if r then
                    local col = Color3.fromRGB(tonumber(r,16), tonumber(g,16), tonumber(b,16))
                    h, s, v = col:ToHSV()
                    updateDisplay()
                end
                if not CPSettings.Ext then SaveConfiguration() end
            end)

            local opened = false
            local interactTop = makeButton(el, UDim2.new(1, 0, 0, 44), UDim2.new(0, 0, 0, 0))
            interactTop.BackgroundTransparency = 1
            interactTop.ZIndex = 6

            interactTop.MouseButton1Click:Connect(function()
                opened = not opened
                pickerFrame.Visible = opened
                tween(el, med, {Size = UDim2.new(1, 0, 0, opened and 180 or 44)})
            end)

            updateDisplay()

            function CPSettings:Set(color)
                CPSettings.Color = color
                h, s, v = color:ToHSV()
                updateDisplay()
            end

            if Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled and CPSettings.Flag then
                CyberUI.Flags[CPSettings.Flag] = CPSettings
            end

            return CPSettings
        end

        return Tab
    end -- CreateTab

    return Window
end -- CreateWindow

-- ============================================================
-- VISIBILITY HELPERS
-- ============================================================
function CyberUI:SetVisibility(v)
    if v then showUI() else hideUI(false) end
end

function CyberUI:IsVisible()
    return not Hidden
end

function CyberUI:Destroy()
    rayfieldDestroyed = true
    for _, c in ipairs(keybindConns) do c:Disconnect() end
    ScreenGui:Destroy()
end

-- ============================================================
-- LOAD CONFIGURATION (called by developer after CreateWindow)
-- ============================================================
function CyberUI:LoadConfiguration()
    if CEnabled then
        local ok, result = pcall(function()
            if isfile and callSafely(isfile, ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension) then
                local raw = callSafely(readfile, ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension)
                if raw then
                    local loaded = LoadConfigurationData(raw)
                    if loaded then
                        CyberUI:Notify({Title = "Configuration Loaded", Content = "Your saved configuration has been applied.", Duration = 4})
                    end
                end
            end
        end)
        if not ok then
            warn("CyberUI | Config load error:", result)
        end
    end
    globalLoaded = true
end

return CyberUI
