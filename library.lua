--[[
    NovaUI Interface Suite
    Original aesthetic - sidebar navigation, deep purple accents
    Rayfield-compatible API surface

    Usage:
        local NovaUI = loadstring(game:HttpGet('YOUR_RAW_GITHUB_URL'))()
        local Window = NovaUI:CreateWindow({ Name = "My Script", Theme = "PurpleDusk" })
        local Tab = Window:CreateTab("Main")
        Tab:CreateToggle({ Name = "Speed", CurrentValue = false, Flag = "spd", Callback = function(v) end })
        NovaUI:LoadConfiguration()
]]

-- ============================================================
-- SERVICES
-- ============================================================
local function svc(n)
    local s = game:GetService(n)
    return cloneref and cloneref(s) or s
end

local UIS   = svc("UserInputService")
local TS    = svc("TweenService")
local RS    = svc("RunService")
local PL    = svc("Players")
local CG    = svc("CoreGui")
local HTTP  = svc("HttpService")

-- ============================================================
-- THEMES
-- ============================================================
local NovaUI = { Flags = {} }

NovaUI.Theme = {
    PurpleDusk = {
        WindowBg        = Color3.fromRGB(14,  13,  18),
        SidebarBg       = Color3.fromRGB(11,  10,  15),
        TopbarBg        = Color3.fromRGB(14,  13,  18),
        ContentBg       = Color3.fromRGB(14,  13,  18),
        PanelBg         = Color3.fromRGB(20,  19,  28),
        PanelHover      = Color3.fromRGB(26,  24,  37),
        BorderColor     = Color3.fromRGB(36,  34,  50),
        BorderStrong    = Color3.fromRGB(55,  45,  85),
        Accent          = Color3.fromRGB(168, 85,  247),
        AccentDim       = Color3.fromRGB(80,  35,  120),
        AccentSoft      = Color3.fromRGB(30,  15,  50),
        TextPrimary     = Color3.fromRGB(220, 215, 235),
        TextSecondary   = Color3.fromRGB(110, 105, 130),
        TextMuted       = Color3.fromRGB(65,  62,  80),
        ToggleOn        = Color3.fromRGB(168, 85,  247),
        ToggleOff       = Color3.fromRGB(35,  33,  48),
        ToggleKnobOn    = Color3.fromRGB(230, 200, 255),
        ToggleKnobOff   = Color3.fromRGB(70,  65,  90),
        SliderFill      = Color3.fromRGB(168, 85,  247),
        SliderTrack     = Color3.fromRGB(25,  23,  35),
        InputBg         = Color3.fromRGB(11,  10,  17),
        InputBorder     = Color3.fromRGB(40,  37,  58),
        DropSelected    = Color3.fromRGB(30,  15,  50),
        NotifBg         = Color3.fromRGB(17,  16,  22),
        NotifBorder     = Color3.fromRGB(36,  34,  50),
        NotifAccent     = Color3.fromRGB(168, 85,  247),
    },

    Midnight = {
        WindowBg        = Color3.fromRGB(10,  12,  16),
        SidebarBg       = Color3.fromRGB(8,   10,  14),
        TopbarBg        = Color3.fromRGB(10,  12,  16),
        ContentBg       = Color3.fromRGB(10,  12,  16),
        PanelBg         = Color3.fromRGB(15,  18,  25),
        PanelHover      = Color3.fromRGB(20,  24,  34),
        BorderColor     = Color3.fromRGB(28,  34,  46),
        BorderStrong    = Color3.fromRGB(45,  80,  130),
        Accent          = Color3.fromRGB(56,  145, 255),
        AccentDim       = Color3.fromRGB(20,  60,  120),
        AccentSoft      = Color3.fromRGB(10,  25,  55),
        TextPrimary     = Color3.fromRGB(210, 220, 235),
        TextSecondary   = Color3.fromRGB(95,  110, 135),
        TextMuted       = Color3.fromRGB(55,  65,  80),
        ToggleOn        = Color3.fromRGB(56,  145, 255),
        ToggleOff       = Color3.fromRGB(25,  30,  42),
        ToggleKnobOn    = Color3.fromRGB(200, 225, 255),
        ToggleKnobOff   = Color3.fromRGB(60,  70,  90),
        SliderFill      = Color3.fromRGB(56,  145, 255),
        SliderTrack     = Color3.fromRGB(18,  22,  32),
        InputBg         = Color3.fromRGB(8,   10,  16),
        InputBorder     = Color3.fromRGB(32,  40,  56),
        DropSelected    = Color3.fromRGB(10,  30,  60),
        NotifBg         = Color3.fromRGB(12,  14,  20),
        NotifBorder     = Color3.fromRGB(28,  34,  46),
        NotifAccent     = Color3.fromRGB(56,  145, 255),
    },

    Ember = {
        WindowBg        = Color3.fromRGB(17,  12,  10),
        SidebarBg       = Color3.fromRGB(14,  10,  8),
        TopbarBg        = Color3.fromRGB(17,  12,  10),
        ContentBg       = Color3.fromRGB(17,  12,  10),
        PanelBg         = Color3.fromRGB(24,  17,  14),
        PanelHover      = Color3.fromRGB(32,  22,  17),
        BorderColor     = Color3.fromRGB(46,  30,  22),
        BorderStrong    = Color3.fromRGB(90,  50,  30),
        Accent          = Color3.fromRGB(245, 120, 50),
        AccentDim       = Color3.fromRGB(100, 45,  15),
        AccentSoft      = Color3.fromRGB(45,  20,  10),
        TextPrimary     = Color3.fromRGB(235, 220, 205),
        TextSecondary   = Color3.fromRGB(130, 105, 90),
        TextMuted       = Color3.fromRGB(75,  58,  48),
        ToggleOn        = Color3.fromRGB(245, 120, 50),
        ToggleOff       = Color3.fromRGB(38,  26,  20),
        ToggleKnobOn    = Color3.fromRGB(255, 210, 170),
        ToggleKnobOff   = Color3.fromRGB(80,  60,  48),
        SliderFill      = Color3.fromRGB(245, 120, 50),
        SliderTrack     = Color3.fromRGB(26,  18,  14),
        InputBg         = Color3.fromRGB(13,  9,   7),
        InputBorder     = Color3.fromRGB(50,  33,  24),
        DropSelected    = Color3.fromRGB(45,  20,  10),
        NotifBg         = Color3.fromRGB(20,  14,  11),
        NotifBorder     = Color3.fromRGB(46,  30,  22),
        NotifAccent     = Color3.fromRGB(245, 120, 50),
    },

    Slate = {
        WindowBg        = Color3.fromRGB(240, 240, 245),
        SidebarBg       = Color3.fromRGB(228, 228, 236),
        TopbarBg        = Color3.fromRGB(240, 240, 245),
        ContentBg       = Color3.fromRGB(240, 240, 245),
        PanelBg         = Color3.fromRGB(255, 255, 255),
        PanelHover      = Color3.fromRGB(245, 245, 252),
        BorderColor     = Color3.fromRGB(210, 210, 222),
        BorderStrong    = Color3.fromRGB(150, 120, 200),
        Accent          = Color3.fromRGB(110, 60,  200),
        AccentDim       = Color3.fromRGB(175, 145, 220),
        AccentSoft      = Color3.fromRGB(230, 220, 248),
        TextPrimary     = Color3.fromRGB(30,  28,  40),
        TextSecondary   = Color3.fromRGB(100, 95,  120),
        TextMuted       = Color3.fromRGB(160, 155, 175),
        ToggleOn        = Color3.fromRGB(110, 60,  200),
        ToggleOff       = Color3.fromRGB(195, 192, 210),
        ToggleKnobOn    = Color3.fromRGB(255, 255, 255),
        ToggleKnobOff   = Color3.fromRGB(255, 255, 255),
        SliderFill      = Color3.fromRGB(110, 60,  200),
        SliderTrack     = Color3.fromRGB(210, 210, 222),
        InputBg         = Color3.fromRGB(252, 252, 255),
        InputBorder     = Color3.fromRGB(200, 198, 215),
        DropSelected    = Color3.fromRGB(230, 220, 248),
        NotifBg         = Color3.fromRGB(255, 255, 255),
        NotifBorder     = Color3.fromRGB(210, 210, 222),
        NotifAccent     = Color3.fromRGB(110, 60,  200),
    },
}

-- ============================================================
-- STATE
-- ============================================================
local T              = NovaUI.Theme.PurpleDusk
local Hidden         = false
local Minimised      = false
local Debounce       = false
local CEnabled       = false
local CFileName      = nil
local globalLoaded   = false
local UIDestroyed    = false
local keybindConns   = {}
local ConfigFolder   = "NovaUI/Configurations"
local RootFolder     = "NovaUI"

-- ============================================================
-- HELPERS
-- ============================================================
local function safe(fn, ...)
    if not fn then return end
    local ok, r = pcall(fn, ...)
    if not ok then warn("NovaUI |", r) return false end
    return r
end

local function folder(p)
    if isfolder and not safe(isfolder, p) then safe(makefolder, p) end
end

local function tw(obj, t, props)
    TS:Create(obj, t, props):Play()
end

local Q  = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local M  = TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local S  = TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

-- ============================================================
-- BUILD ROOT GUI
-- ============================================================
local Root = Instance.new("ScreenGui")
Root.Name = "NovaUI"
Root.ResetOnSpawn = false
Root.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Root.DisplayOrder = 120

if gethui then
    Root.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(Root)
    Root.Parent = CG
elseif CG:FindFirstChild("RobloxGui") then
    Root.Parent = CG.RobloxGui
else
    Root.Parent = CG
end

-- Notification container (bottom-right)
local NotifContainer = Instance.new("Frame")
NotifContainer.Name = "Notifs"
NotifContainer.Size = UDim2.new(0, 290, 1, 0)
NotifContainer.Position = UDim2.new(1, -300, 0, 0)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = Root

local notifList = Instance.new("UIListLayout")
notifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifList.SortOrder = Enum.SortOrder.LayoutOrder
notifList.Padding = UDim.new(0, 6)
notifList.Parent = NotifContainer

-- ============================================================
-- WINDOW FRAME
-- ============================================================
local Win = Instance.new("Frame")
Win.Name = "Window"
Win.Size = UDim2.new(0, 560, 0, 440)
Win.Position = UDim2.new(0.5, 0, 0.5, 0)
Win.AnchorPoint = Vector2.new(0.5, 0.5)
Win.BackgroundColor3 = T.WindowBg
Win.BorderSizePixel = 0
Win.Visible = false
Win.ClipsDescendants = true
Win.Parent = Root

do
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,10); c.Parent = Win
    local s = Instance.new("UIStroke"); s.Color = T.BorderColor; s.Thickness = 1; s.Parent = Win
    Win:SetAttribute("_stroke", true)
end

-- Topbar
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 42)
Topbar.BackgroundColor3 = T.TopbarBg
Topbar.BorderSizePixel = 0
Topbar.ZIndex = 5
Topbar.Parent = Win

local TBDiv = Instance.new("Frame")
TBDiv.Size = UDim2.new(1, 0, 0, 1)
TBDiv.Position = UDim2.new(0,0,1,-1)
TBDiv.BackgroundColor3 = T.BorderColor
TBDiv.BorderSizePixel = 0
TBDiv.Parent = Topbar

local TBTitle = Instance.new("TextLabel")
TBTitle.Size = UDim2.new(1,-130,1,0)
TBTitle.Position = UDim2.new(0,14,0,0)
TBTitle.BackgroundTransparency = 1
TBTitle.Text = "NovaUI"
TBTitle.TextColor3 = T.TextPrimary
TBTitle.TextSize = 13
TBTitle.Font = Enum.Font.GothamBold
TBTitle.TextXAlignment = Enum.TextXAlignment.Left
TBTitle.Parent = Topbar

local TBVersion = Instance.new("TextLabel")
TBVersion.Size = UDim2.new(0,50,0,18)
TBVersion.Position = UDim2.new(0,0,0.5,0)
TBVersion.AnchorPoint = Vector2.new(0,0.5)
TBVersion.BackgroundColor3 = T.AccentSoft
TBVersion.BorderSizePixel = 0
TBVersion.Text = "v1.0"
TBVersion.TextColor3 = T.Accent
TBVersion.TextSize = 9
TBVersion.Font = Enum.Font.GothamBold
TBVersion.Parent = Topbar
do
    local vx = Instance.new("UICorner"); vx.CornerRadius = UDim.new(1,0); vx.Parent = TBVersion
    local vs = Instance.new("UIStroke"); vs.Color = T.AccentDim; vs.Thickness = 1; vs.Parent = TBVersion
end
TBVersion.Position = UDim2.new(0, TBTitle.TextBounds.X + 22, 0.5, 0)

-- Topbar control buttons
local function topBtn(label, xOff)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,26,0,26)
    b.Position = UDim2.new(1, xOff, 0.5, 0)
    b.AnchorPoint = Vector2.new(1,0.5)
    b.BackgroundColor3 = T.PanelBg
    b.BorderSizePixel = 0
    b.Text = label
    b.TextColor3 = T.TextSecondary
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = false
    b.Parent = Topbar

    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = b
    local s = Instance.new("UIStroke"); s.Color = T.BorderColor; s.Thickness = 1; s.Parent = b

    b.MouseEnter:Connect(function()
        tw(b, Q, {BackgroundColor3 = T.PanelHover, TextColor3 = T.Accent})
    end)
    b.MouseLeave:Connect(function()
        tw(b, Q, {BackgroundColor3 = T.PanelBg, TextColor3 = T.TextSecondary})
    end)
    return b
end

local BtnClose  = topBtn("x", -10)
local BtnMin    = topBtn("-", -40)
local BtnSearch = topBtn("~", -70)

-- Sidebar
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 155, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = T.SidebarBg
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 0
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
Sidebar.CanvasSize = UDim2.new(0,0,0,0)
Sidebar.Parent = Win

local SBDiv = Instance.new("Frame")
SBDiv.Size = UDim2.new(0,1,1,0)
SBDiv.Position = UDim2.new(1,-1,0,0)
SBDiv.BackgroundColor3 = T.BorderColor
SBDiv.BorderSizePixel = 0
SBDiv.Parent = Sidebar

local SBLayout = Instance.new("UIListLayout")
SBLayout.SortOrder = Enum.SortOrder.LayoutOrder
SBLayout.Padding = UDim.new(0,2)
SBLayout.Parent = Sidebar

local SBPad = Instance.new("UIPadding")
SBPad.PaddingTop    = UDim.new(0,8)
SBPad.PaddingBottom = UDim.new(0,8)
SBPad.PaddingLeft   = UDim.new(0,6)
SBPad.PaddingRight  = UDim.new(0,6)
SBPad.Parent = Sidebar

-- Content area
local ContentArea = Instance.new("Frame")
ContentArea.Name = "Content"
ContentArea.Size = UDim2.new(1,-155,1,-42)
ContentArea.Position = UDim2.new(0,155,0,42)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.Parent = Win

local PageLayout = Instance.new("UIPageLayout")
PageLayout.FillDirection = Enum.FillDirection.Horizontal
PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
PageLayout.TweenTime = 0.28
PageLayout.EasingStyle = Enum.EasingStyle.Quart
PageLayout.EasingDirection = Enum.EasingDirection.Out
PageLayout.ScrollWheelInputEnabled = false
PageLayout.GamepadInputEnabled = false
PageLayout.TouchInputEnabled = false
PageLayout.Animated = true
PageLayout.Parent = ContentArea

-- Search overlay
local SearchOverlay = Instance.new("Frame")
SearchOverlay.Name = "SearchOverlay"
SearchOverlay.Size = UDim2.new(1,-155,1,-42)
SearchOverlay.Position = UDim2.new(0,155,0,42)
SearchOverlay.BackgroundColor3 = T.WindowBg
SearchOverlay.BackgroundTransparency = 0.06
SearchOverlay.BorderSizePixel = 0
SearchOverlay.ZIndex = 20
SearchOverlay.Visible = false
SearchOverlay.Parent = Win

local SearchBar = Instance.new("Frame")
SearchBar.Size = UDim2.new(1,-20,0,36)
SearchBar.Position = UDim2.new(0,10,0,12)
SearchBar.BackgroundColor3 = T.InputBg
SearchBar.BorderSizePixel = 0
SearchBar.ZIndex = 21
SearchBar.Parent = SearchOverlay

do
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,7); c.Parent = SearchBar
    local s = Instance.new("UIStroke"); s.Color = T.Accent; s.Thickness = 1; s.Parent = SearchBar
end

local SearchInput = Instance.new("TextBox")
SearchInput.Size = UDim2.new(1,-16,1,0)
SearchInput.Position = UDim2.new(0,10,0,0)
SearchInput.BackgroundTransparency = 1
SearchInput.PlaceholderText = "Search..."
SearchInput.PlaceholderColor3 = T.TextMuted
SearchInput.TextColor3 = T.TextPrimary
SearchInput.TextSize = 13
SearchInput.Font = Enum.Font.Gotham
SearchInput.TextXAlignment = Enum.TextXAlignment.Left
SearchInput.ClearTextOnFocus = false
SearchInput.ZIndex = 22
SearchInput.Parent = SearchBar

local SearchResultsFrame = Instance.new("ScrollingFrame")
SearchResultsFrame.Size = UDim2.new(1,-20,1,-64)
SearchResultsFrame.Position = UDim2.new(0,10,0,58)
SearchResultsFrame.BackgroundTransparency = 1
SearchResultsFrame.BorderSizePixel = 0
SearchResultsFrame.ScrollBarThickness = 2
SearchResultsFrame.ScrollBarImageColor3 = T.Accent
SearchResultsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
SearchResultsFrame.CanvasSize = UDim2.new(0,0,0,0)
SearchResultsFrame.ZIndex = 21
SearchResultsFrame.Parent = SearchOverlay

local srLayout = Instance.new("UIListLayout")
srLayout.Padding = UDim.new(0,4)
srLayout.SortOrder = Enum.SortOrder.LayoutOrder
srLayout.Parent = SearchResultsFrame

-- Loading screen
local LoadScreen = Instance.new("Frame")
LoadScreen.Name = "LoadScreen"
LoadScreen.Size = UDim2.new(1,0,1,0)
LoadScreen.BackgroundColor3 = T.WindowBg
LoadScreen.BorderSizePixel = 0
LoadScreen.ZIndex = 50
LoadScreen.Parent = Win

do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,10); c.Parent = LoadScreen end

local LoadTitle = Instance.new("TextLabel")
LoadTitle.Size = UDim2.new(1,0,0,38)
LoadTitle.Position = UDim2.new(0,0,0.38,0)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "NOVAUI"
LoadTitle.TextColor3 = T.Accent
LoadTitle.TextSize = 28
LoadTitle.Font = Enum.Font.GothamBlack
LoadTitle.TextXAlignment = Enum.TextXAlignment.Center
LoadTitle.TextTransparency = 1
LoadTitle.ZIndex = 51
LoadTitle.Parent = LoadScreen

local LoadSub = Instance.new("TextLabel")
LoadSub.Size = UDim2.new(1,0,0,20)
LoadSub.Position = UDim2.new(0,0,0.38,42)
LoadSub.BackgroundTransparency = 1
LoadSub.Text = "Interface Suite"
LoadSub.TextColor3 = T.TextSecondary
LoadSub.TextSize = 12
LoadSub.Font = Enum.Font.Gotham
LoadSub.TextXAlignment = Enum.TextXAlignment.Center
LoadSub.TextTransparency = 1
LoadSub.ZIndex = 51
LoadSub.Parent = LoadScreen

-- Thin accent bar at top of load screen
local LoadBar = Instance.new("Frame")
LoadBar.Size = UDim2.new(0,0,0,2)
LoadBar.Position = UDim2.new(0,0,0,0)
LoadBar.BackgroundColor3 = T.Accent
LoadBar.BorderSizePixel = 0
LoadBar.ZIndex = 52
LoadBar.Parent = LoadScreen

-- ============================================================
-- THEME APPLICATION
-- ============================================================
local allElements = {}  -- track elements for theme updates

local function ApplyTheme(theme)
    if type(theme) == "string" then
        T = NovaUI.Theme[theme] or NovaUI.Theme.PurpleDusk
    elseif type(theme) == "table" then
        T = theme
    end
    -- Core window
    Win.BackgroundColor3             = T.WindowBg
    Topbar.BackgroundColor3          = T.TopbarBg
    TBDiv.BackgroundColor3           = T.BorderColor
    TBTitle.TextColor3               = T.TextPrimary
    TBVersion.BackgroundColor3       = T.AccentSoft
    TBVersion.TextColor3             = T.Accent
    Sidebar.BackgroundColor3         = T.SidebarBg
    SBDiv.BackgroundColor3           = T.BorderColor
    SearchOverlay.BackgroundColor3   = T.WindowBg
    SearchBar.BackgroundColor3       = T.InputBg
    SearchInput.TextColor3           = T.TextPrimary
    SearchInput.PlaceholderColor3    = T.TextMuted
    LoadScreen.BackgroundColor3      = T.WindowBg
    LoadTitle.TextColor3             = T.Accent
    LoadSub.TextColor3               = T.TextSecondary
    LoadBar.BackgroundColor3         = T.Accent

    for _, b in ipairs({BtnClose, BtnMin, BtnSearch}) do
        b.BackgroundColor3 = T.PanelBg
        b.TextColor3       = T.TextSecondary
    end
end

-- ============================================================
-- DRAGGING (topbar)
-- ============================================================
do
    local dragging, rel = false, nil
    local offset = Vector2.zero
    local sg = Win:FindFirstAncestorWhichIsA("ScreenGui")
    if sg and sg.IgnoreGuiInset then
        offset = offset + svc("GuiService"):GetGuiInset()
    end

    Topbar.InputBegan:Connect(function(i, p)
        if p then return end
        if i.UserInputType.Name == "MouseButton1" or i.UserInputType.Name == "Touch" then
            dragging = true
            rel = Win.AbsolutePosition + Win.AbsoluteSize * Win.AnchorPoint - UIS:GetMouseLocation()
        end
    end)

    local de = UIS.InputEnded:Connect(function(i)
        if i.UserInputType.Name == "MouseButton1" or i.UserInputType.Name == "Touch" then
            dragging = false
        end
    end)
    local rs = RS.RenderStepped:Connect(function()
        if dragging then
            local p = UIS:GetMouseLocation() + rel + offset
            Win.Position = UDim2.fromOffset(p.X, p.Y)
        end
    end)
    Win.Destroying:Connect(function() de:Disconnect(); rs:Disconnect() end)
end

-- ============================================================
-- NOTIFY
-- ============================================================
function NovaUI:Notify(data)
    task.spawn(function()
        local f = Instance.new("Frame")
        f.Name = "Notif"
        f.Size = UDim2.new(1,0,0,0)
        f.BackgroundColor3 = T.NotifBg
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.LayoutOrder = #NotifContainer:GetChildren()
        f.Parent = NotifContainer

        local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(0,8); fc.Parent = f
        local fs = Instance.new("UIStroke"); fs.Color = T.NotifBorder; fs.Thickness = 1; fs.Parent = f
        local fa = Instance.new("Frame")
        fa.Size = UDim2.new(0,3,1,-16)
        fa.Position = UDim2.new(0,0,0,8)
        fa.BackgroundColor3 = T.NotifAccent
        fa.BorderSizePixel = 0
        fa.Parent = f
        local fac = Instance.new("UICorner"); fac.CornerRadius = UDim.new(0,2); fac.Parent = fa

        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0,14); pad.PaddingRight = UDim.new(0,10)
        pad.PaddingTop = UDim.new(0,10); pad.PaddingBottom = UDim.new(0,10)
        pad.Parent = f

        local fLayout = Instance.new("UIListLayout")
        fLayout.SortOrder = Enum.SortOrder.LayoutOrder
        fLayout.Padding = UDim.new(0,3)
        fLayout.Parent = f

        local fTitle = Instance.new("TextLabel")
        fTitle.Size = UDim2.new(1,0,0,16)
        fTitle.BackgroundTransparency = 1
        fTitle.Text = data.Title or "Notice"
        fTitle.TextColor3 = T.NotifAccent
        fTitle.TextSize = 12
        fTitle.Font = Enum.Font.GothamBold
        fTitle.TextXAlignment = Enum.TextXAlignment.Left
        fTitle.TextTransparency = 1
        fTitle.LayoutOrder = 1
        fTitle.Parent = f

        local fContent = Instance.new("TextLabel")
        fContent.Size = UDim2.new(1,0,0,0)
        fContent.AutomaticSize = Enum.AutomaticSize.Y
        fContent.BackgroundTransparency = 1
        fContent.Text = data.Content or ""
        fContent.TextColor3 = T.TextSecondary
        fContent.TextSize = 11
        fContent.Font = Enum.Font.Gotham
        fContent.TextXAlignment = Enum.TextXAlignment.Left
        fContent.TextWrapped = true
        fContent.TextTransparency = 1
        fContent.LayoutOrder = 2
        fContent.Parent = f

        task.wait()
        f.Visible = true
        local targetH = 16 + fContent.TextBounds.Y + 28
        tw(f, M, {Size = UDim2.new(1,0,0,math.max(targetH,56)), BackgroundTransparency = 0.05})
        task.wait(0.1)
        tw(fTitle,   Q, {TextTransparency = 0})
        tw(fContent, Q, {TextTransparency = 0.1})

        local dur = data.Duration or math.clamp(#(data.Content or "") * 0.055 + 2.5, 3, 10)
        task.wait(dur)

        tw(f,        M, {BackgroundTransparency = 1, Size = UDim2.new(1,0,0,0)})
        tw(fTitle,   Q, {TextTransparency = 1})
        tw(fContent, Q, {TextTransparency = 1})
        tw(fs, Q, {Transparency = 1})
        task.wait(0.35)
        f:Destroy()
    end)
end

-- ============================================================
-- SHOW / HIDE / MINIMISE
-- ============================================================
local function showWin()
    Hidden = false
    Win.Visible = true
    tw(Win, M, {BackgroundTransparency = 0})
end

local function hideWin(notify)
    Hidden = true
    tw(Win, M, {BackgroundTransparency = 1})
    task.wait(0.32)
    Win.Visible = false
    if notify then
        NovaUI:Notify({Title = "UI Hidden", Content = "Press the toggle key to restore the interface.", Duration = 4})
    end
end

local function minimise()
    Minimised = true
    ContentArea.Visible = false
    Sidebar.Visible = false
    tw(Win, M, {Size = UDim2.new(0, 560, 0, 42)})
    BtnMin.Text = "+"
end

local function maximise()
    Minimised = false
    tw(Win, M, {Size = UDim2.new(0, 560, 0, 440)})
    task.wait(0.22)
    Sidebar.Visible = true
    ContentArea.Visible = true
    BtnMin.Text = "-"
end

BtnMin.MouseButton1Click:Connect(function()
    if Debounce then return end
    if Minimised then maximise() else minimise() end
end)

BtnClose.MouseButton1Click:Connect(function()
    if Debounce then return end
    if Hidden then showWin() else hideWin(true) end
end)

-- Search
local searchActive = false
local function openSearch()
    searchActive = true
    SearchOverlay.Visible = true
    SearchOverlay.BackgroundTransparency = 1
    tw(SearchOverlay, Q, {BackgroundTransparency = 0.06})
    SearchInput:CaptureFocus()
end

local function closeSearch()
    searchActive = false
    tw(SearchOverlay, Q, {BackgroundTransparency = 1})
    task.wait(0.18)
    SearchOverlay.Visible = false
    SearchInput.Text = ""
    for _, c in ipairs(SearchResultsFrame:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
end

BtnSearch.MouseButton1Click:Connect(function()
    if searchActive then closeSearch() else openSearch() end
end)

SearchInput.FocusLost:Connect(function()
    if #SearchInput.Text == 0 then
        task.wait(0.14)
        closeSearch()
    end
end)

-- ============================================================
-- CONFIG SAVE / LOAD
-- ============================================================
local function SaveConfig()
    if not CEnabled or not globalLoaded then return end
    local data = {}
    for flag, el in pairs(NovaUI.Flags) do
        if el.Type == "ColorPicker" then
            local c = el.Color
            data[flag] = {R = math.floor(c.R*255+.5), G = math.floor(c.G*255+.5), B = math.floor(c.B*255+.5)}
        else
            data[flag] = el.CurrentValue or el.CurrentKeybind or el.CurrentOption or el.Color
        end
    end
    safe(writefile, ConfigFolder .. "/" .. CFileName .. ".nova", HTTP:JSONEncode(data))
end

local function LoadConfigData(raw)
    local ok, data = pcall(function() return HTTP:JSONDecode(raw) end)
    if not ok then return end
    for flag, val in pairs(data) do
        local el = NovaUI.Flags[flag]
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
-- ELEMENT PRIMITIVES
-- ============================================================
local function makePanelFrame(parent, name, h)
    local f = Instance.new("Frame")
    f.Name = name or "Panel"
    f.Size = UDim2.new(1,0,0,h or 44)
    f.BackgroundColor3 = T.PanelBg
    f.BorderSizePixel = 0
    f.LayoutOrder = 9999
    f.Parent = parent

    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,7); c.Parent = f
    local s = Instance.new("UIStroke"); s.Color = T.BorderColor; s.Thickness = 1; s.Transparency = 0.2; s.Parent = f

    local leftBar = Instance.new("Frame")
    leftBar.Size = UDim2.new(0,2,0.55,0)
    leftBar.Position = UDim2.new(0,0,0.225,0)
    leftBar.BackgroundColor3 = T.AccentDim
    leftBar.BorderSizePixel = 0
    leftBar.Parent = f
    do local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0,2); bc.Parent = leftBar end

    f.MouseEnter:Connect(function()
        tw(f, Q, {BackgroundColor3 = T.PanelHover})
        tw(leftBar, Q, {BackgroundColor3 = T.Accent})
    end)
    f.MouseLeave:Connect(function()
        tw(f, Q, {BackgroundColor3 = T.PanelBg})
        tw(leftBar, Q, {BackgroundColor3 = T.AccentDim})
    end)

    return f, s, leftBar
end

local function makeText(parent, text, size, pos, color, font, tsize, xalign, zindex)
    local l = Instance.new("TextLabel")
    l.Size = size or UDim2.new(1,-10,0,20)
    l.Position = pos or UDim2.new(0,10,0,0)
    l.BackgroundTransparency = 1
    l.Text = text or ""
    l.TextColor3 = color or T.TextPrimary
    l.TextSize = tsize or 13
    l.Font = font or Enum.Font.Gotham
    l.TextXAlignment = xalign or Enum.TextXAlignment.Left
    if zindex then l.ZIndex = zindex end
    l.Parent = parent
    return l
end

local function makeInteract(parent, h)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,h or 44)
    b.Position = UDim2.new(0,0,0,0)
    b.BackgroundTransparency = 1
    b.Text = ""
    b.AutoButtonColor = false
    b.ZIndex = 10
    b.Parent = parent
    return b
end

local function makeInputBox(parent, size, pos, placeholder)
    local f = Instance.new("Frame")
    f.Size = size or UDim2.new(0,130,0,28)
    f.Position = pos or UDim2.new(1,-140,0.5,0)
    f.AnchorPoint = Vector2.new(1,0.5)
    f.BackgroundColor3 = T.InputBg
    f.BorderSizePixel = 0
    f.Parent = parent
    do
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,5); c.Parent = f
        local s = Instance.new("UIStroke"); s.Color = T.InputBorder; s.Thickness = 1; s.Parent = f
    end

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1,-10,1,0)
    box.Position = UDim2.new(0,7,0,0)
    box.BackgroundTransparency = 1
    box.PlaceholderText = placeholder or ""
    box.PlaceholderColor3 = T.TextMuted
    box.TextColor3 = T.TextPrimary
    box.TextSize = 12
    box.Font = Enum.Font.Gotham
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false
    box.Parent = f
    return f, box
end

-- ============================================================
-- CREATE WINDOW
-- ============================================================
function NovaUI:CreateWindow(Settings)
    Settings = Settings or {}

    if Settings.Theme then ApplyTheme(Settings.Theme) end

    TBTitle.Text = Settings.Name or "NovaUI"
    LoadTitle.Text = Settings.LoadingTitle or "NOVAUI"
    LoadSub.Text   = Settings.LoadingSubtitle or "Interface Suite"

    local toggleKey = "RightControl"
    if Settings.ToggleUIKeybind then
        local k = Settings.ToggleUIKeybind
        toggleKey = type(k) == "string" and string.upper(k) or (typeof(k) == "EnumItem" and k.Name or toggleKey)
    end

    local hkConn = UIS.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode[toggleKey] then
            if Hidden then showWin() else hideWin(false) end
        end
    end)
    table.insert(keybindConns, hkConn)

    pcall(function()
        if Settings.ConfigurationSaving then
            CEnabled     = Settings.ConfigurationSaving.Enabled == true
            CFileName    = Settings.ConfigurationSaving.FileName or tostring(game.PlaceId)
            if Settings.ConfigurationSaving.FolderName then
                ConfigFolder = Settings.ConfigurationSaving.FolderName .. "/Configurations"
                RootFolder   = Settings.ConfigurationSaving.FolderName
            end
            if CEnabled then
                folder(RootFolder)
                folder(ConfigFolder)
            end
        end
    end)

    -- Loading animation
    Win.Visible = true
    Win.BackgroundTransparency = 0
    LoadScreen.Visible = true
    LoadScreen.BackgroundTransparency = 0
    ContentArea.Visible = false
    Sidebar.Visible = false
    Topbar.Visible = false

    tw(LoadBar, TweenInfo.new(1.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0.65,0,0,2)})
    task.wait(0.3)
    tw(LoadTitle, M, {TextTransparency = 0})
    task.wait(0.15)
    tw(LoadSub,   M, {TextTransparency = 0})
    task.wait(0.95)
    tw(LoadTitle,    Q, {TextTransparency = 1})
    tw(LoadSub,      Q, {TextTransparency = 1})
    tw(LoadBar,      Q, {Size = UDim2.new(1,0,0,2)})
    task.wait(0.22)
    tw(LoadScreen, M, {BackgroundTransparency = 1})
    task.wait(0.32)
    LoadScreen.Visible = false

    Topbar.Visible = true
    Sidebar.Visible = true
    ContentArea.Visible = true

    -- --------------------------------------------------------
    -- WINDOW OBJECT
    -- --------------------------------------------------------
    local Window = {}
    local firstTab = nil
    local allTabButtons = {}

    function Window:ModifyTheme(newTheme)
        ApplyTheme(newTheme)
        NovaUI:Notify({Title = "Theme Changed", Content = "Theme applied successfully.", Duration = 3})
    end

    -- ---- Search population (called after elements are registered)
    local allRegisteredElements = {}  -- {name, page}

    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        for _, c in ipairs(SearchResultsFrame:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end
        local q = string.lower(SearchInput.Text)
        if #q == 0 then return end

        for _, entry in ipairs(allRegisteredElements) do
            if string.find(string.lower(entry.name), q, 1, true) then
                local rf = Instance.new("Frame")
                rf.Size = UDim2.new(1,0,0,36)
                rf.BackgroundColor3 = T.PanelBg
                rf.BorderSizePixel = 0
                rf.ZIndex = 22
                rf.Parent = SearchResultsFrame

                do
                    local rc = Instance.new("UICorner"); rc.CornerRadius = UDim.new(0,6); rc.Parent = rf
                    local rs2 = Instance.new("UIStroke"); rs2.Color = T.BorderColor; rs2.Thickness = 1; rs2.Parent = rf
                end

                makeText(rf, entry.name, UDim2.new(0.6,0,1,0), UDim2.new(0,12,0,0), T.TextPrimary, Enum.Font.GothamBold, 12, Enum.TextXAlignment.Left, 23)
                makeText(rf, entry.tab, UDim2.new(0.35,0,1,0), UDim2.new(1,-10,0,0), T.TextMuted, Enum.Font.Gotham, 10, Enum.TextXAlignment.Right, 23)
            end
        end
    end)

    -- ---- CreateTab ----
    function Window:CreateTab(Name, _Image, Ext)
        -- Sidebar button
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = Name
        tabBtn.Size = UDim2.new(1,0,0,34)
        tabBtn.BackgroundColor3 = T.SidebarBg
        tabBtn.BackgroundTransparency = 1
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = ""
        tabBtn.AutoButtonColor = false
        tabBtn.LayoutOrder = Ext and 1000 or #Sidebar:GetChildren()
        tabBtn.Visible = not Ext
        tabBtn.Parent = Sidebar

        do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,6); c.Parent = tabBtn end

        -- Active indicator bar (left edge)
        local activeBar = Instance.new("Frame")
        activeBar.Size = UDim2.new(0,2,0.5,0)
        activeBar.Position = UDim2.new(0,0,0.25,0)
        activeBar.BackgroundColor3 = T.Accent
        activeBar.BorderSizePixel = 0
        activeBar.BackgroundTransparency = 1
        activeBar.Parent = tabBtn
        do local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,2); c.Parent = activeBar end

        local tabLabel = makeText(tabBtn, Name,
            UDim2.new(1,-10,1,0), UDim2.new(0,12,0,0),
            T.TextSecondary, Enum.Font.Gotham, 12)

        table.insert(allTabButtons, {btn = tabBtn, bar = activeBar, lbl = tabLabel})

        -- Tab page (scrolling content)
        local tabPage = Instance.new("ScrollingFrame")
        tabPage.Name = Name
        tabPage.Size = UDim2.new(1,0,1,0)
        tabPage.BackgroundTransparency = 1
        tabPage.BorderSizePixel = 0
        tabPage.ScrollBarThickness = 2
        tabPage.ScrollBarImageColor3 = T.Accent
        tabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabPage.CanvasSize = UDim2.new(0,0,0,0)
        tabPage.LayoutOrder = Ext and 10000 or #ContentArea:GetChildren()
        tabPage.Parent = ContentArea

        local pgLayout = Instance.new("UIListLayout")
        pgLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pgLayout.Padding = UDim.new(0,5)
        pgLayout.Parent = tabPage

        local pgPad = Instance.new("UIPadding")
        pgPad.PaddingLeft   = UDim.new(0,10)
        pgPad.PaddingRight  = UDim.new(0,10)
        pgPad.PaddingTop    = UDim.new(0,8)
        pgPad.PaddingBottom = UDim.new(0,8)
        pgPad.Parent = tabPage

        -- First tab auto-select
        if not firstTab and not Ext then
            firstTab = tabPage
            PageLayout.Animated = false
            PageLayout:JumpTo(tabPage)
            PageLayout.Animated = true
            tabBtn.BackgroundTransparency = 0
            tabLabel.TextColor3    = T.TextPrimary
            tabLabel.Font          = Enum.Font.GothamBold
            activeBar.BackgroundTransparency = 0
        end

        local function selectTab()
            PageLayout:JumpTo(tabPage)
            for _, entry in ipairs(allTabButtons) do
                entry.btn.BackgroundTransparency = 1
                tw(entry.lbl, Q, {TextColor3 = T.TextSecondary})
                entry.lbl.Font = Enum.Font.Gotham
                entry.bar.BackgroundTransparency = 1
            end
            tabBtn.BackgroundTransparency = 0
            tabBtn.BackgroundColor3 = T.AccentSoft
            tw(tabLabel, Q, {TextColor3 = T.Accent})
            tabLabel.Font = Enum.Font.GothamBold
            activeBar.BackgroundTransparency = 0
        end

        tabBtn.MouseButton1Click:Connect(function()
            if Minimised then return end
            selectTab()
        end)

        tabBtn.MouseEnter:Connect(function()
            if PageLayout.CurrentPage ~= tabPage then
                tw(tabBtn, Q, {BackgroundTransparency = 0.5})
                tabBtn.BackgroundColor3 = T.PanelBg
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if PageLayout.CurrentPage ~= tabPage then
                tw(tabBtn, Q, {BackgroundTransparency = 1})
            end
        end)

        -- --------------------------------------------------------
        -- TAB OBJECT
        -- --------------------------------------------------------
        local Tab = {}

        local function registerElement(name)
            table.insert(allRegisteredElements, {name = name, tab = Name})
        end

        -- ---- Section ----
        function Tab:CreateSection(SectionName)
            local sec = Instance.new("Frame")
            sec.Name = "Section"
            sec.Size = UDim2.new(1,0,0,24)
            sec.BackgroundTransparency = 1
            sec.LayoutOrder = #tabPage:GetChildren()
            sec.Parent = tabPage

            local secLine = Instance.new("Frame")
            secLine.Size = UDim2.new(1,0,0,1)
            secLine.Position = UDim2.new(0,0,1,-1)
            secLine.BackgroundColor3 = T.BorderColor
            secLine.BorderSizePixel = 0
            secLine.Parent = sec

            makeText(sec, string.upper(SectionName),
                UDim2.new(1,0,1,0), UDim2.new(0,0,0,0),
                T.TextMuted, Enum.Font.GothamBold, 9)

            local val = {}
            function val:Set(n)
                sec:FindFirstChildWhichIsA("TextLabel").Text = string.upper(n)
            end
            return val
        end

        -- ---- Divider ----
        function Tab:CreateDivider()
            local d = Instance.new("Frame")
            d.Size = UDim2.new(1,0,0,1)
            d.BackgroundColor3 = T.BorderColor
            d.BorderSizePixel = 0
            d.LayoutOrder = #tabPage:GetChildren()
            d.Parent = tabPage
            local val = {}
            function val:Set(v) d.Visible = v end
            return val
        end

        -- ---- Label ----
        function Tab:CreateLabel(text, _icon, color)
            local f, s, bar = makePanelFrame(tabPage, "Label_"..text, 36)
            f.BackgroundColor3 = color and T.AccentSoft or T.PanelBg

            makeText(f, text,
                UDim2.new(1,-20,1,0), UDim2.new(0,12,0,0),
                color and T.Accent or T.TextSecondary,
                Enum.Font.GothamBold, 12)

            local val = {}
            function val:Set(n)
                local l = f:FindFirstChildWhichIsA("TextLabel")
                if l then l.Text = n end
            end
            return val
        end

        -- ---- Paragraph ----
        function Tab:CreateParagraph(data)
            local container = Instance.new("Frame")
            container.Name = data.Title or "Para"
            container.Size = UDim2.new(1,0,0,0)
            container.AutomaticSize = Enum.AutomaticSize.Y
            container.BackgroundColor3 = T.PanelBg
            container.BorderSizePixel = 0
            container.LayoutOrder = #tabPage:GetChildren()
            container.Parent = tabPage

            do
                local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,7); c.Parent = container
                local s = Instance.new("UIStroke"); s.Color = T.BorderColor; s.Thickness = 1; s.Parent = container
            end

            local innerPad = Instance.new("UIPadding")
            innerPad.PaddingLeft = UDim.new(0,12); innerPad.PaddingRight = UDim.new(0,12)
            innerPad.PaddingTop = UDim.new(0,10);  innerPad.PaddingBottom = UDim.new(0,10)
            innerPad.Parent = container

            local ll = Instance.new("UIListLayout")
            ll.SortOrder = Enum.SortOrder.LayoutOrder
            ll.Padding = UDim.new(0,4)
            ll.Parent = container

            local ptitle = Instance.new("TextLabel")
            ptitle.Size = UDim2.new(1,0,0,16)
            ptitle.BackgroundTransparency = 1
            ptitle.Text = data.Title or ""
            ptitle.TextColor3 = T.Accent
            ptitle.TextSize = 12
            ptitle.Font = Enum.Font.GothamBold
            ptitle.TextXAlignment = Enum.TextXAlignment.Left
            ptitle.LayoutOrder = 1
            ptitle.Parent = container

            local pcontent = Instance.new("TextLabel")
            pcontent.Size = UDim2.new(1,0,0,0)
            pcontent.AutomaticSize = Enum.AutomaticSize.Y
            pcontent.BackgroundTransparency = 1
            pcontent.Text = data.Content or ""
            pcontent.TextColor3 = T.TextSecondary
            pcontent.TextSize = 12
            pcontent.Font = Enum.Font.Gotham
            pcontent.TextXAlignment = Enum.TextXAlignment.Left
            pcontent.TextWrapped = true
            pcontent.LayoutOrder = 2
            pcontent.Parent = container

            local val = {}
            function val:Set(d) ptitle.Text = d.Title or ""; pcontent.Text = d.Content or "" end
            return val
        end

        -- ---- Button ----
        function Tab:CreateButton(ButtonSettings)
            registerElement(ButtonSettings.Name)
            local f, s, bar = makePanelFrame(tabPage, ButtonSettings.Name)

            makeText(f, ButtonSettings.Name,
                UDim2.new(1,-110,1,0), UDim2.new(0,12,0,0),
                T.TextPrimary, Enum.Font.GothamBold, 13)

            -- Right-side run pill
            local pill = Instance.new("TextLabel")
            pill.Size = UDim2.new(0,62,0,24)
            pill.Position = UDim2.new(1,-72,0.5,0)
            pill.AnchorPoint = Vector2.new(1,0.5)
            pill.BackgroundColor3 = T.AccentSoft
            pill.BorderSizePixel = 0
            pill.Text = "run"
            pill.TextColor3 = T.Accent
            pill.TextSize = 10
            pill.Font = Enum.Font.GothamBold
            pill.TextXAlignment = Enum.TextXAlignment.Center
            pill.Parent = f
            do
                local pc = Instance.new("UICorner"); pc.CornerRadius = UDim.new(0,5); pc.Parent = pill
                local ps = Instance.new("UIStroke"); ps.Color = T.AccentDim; ps.Thickness = 1; ps.Parent = pill
            end

            local interact = makeInteract(f)
            interact.MouseButton1Click:Connect(function()
                tw(f, Q, {BackgroundColor3 = T.AccentSoft})
                tw(pill, Q, {BackgroundColor3 = T.AccentDim})
                task.wait(0.08)
                local ok, err = pcall(ButtonSettings.Callback)
                tw(f, M, {BackgroundColor3 = T.PanelBg})
                tw(pill, M, {BackgroundColor3 = T.AccentSoft})
                if not ok then
                    warn("NovaUI | Button callback error:", err)
                    local lbl = f:FindFirstChildWhichIsA("TextLabel")
                    if lbl then
                        local orig = lbl.Text
                        lbl.Text = "Error"
                        lbl.TextColor3 = Color3.fromRGB(220,80,80)
                        task.delay(1.2, function()
                            lbl.Text = orig
                            lbl.TextColor3 = T.TextPrimary
                        end)
                    end
                end
                if not ButtonSettings.Ext then SaveConfig() end
            end)

            local val = {}
            function val:Set(n)
                local l = f:FindFirstChildWhichIsA("TextLabel")
                if l then l.Text = n end
            end
            return val
        end

        -- ---- Toggle ----
        function Tab:CreateToggle(ToggleSettings)
            registerElement(ToggleSettings.Name)
            local f, s, bar = makePanelFrame(tabPage, ToggleSettings.Name)

            makeText(f, ToggleSettings.Name,
                UDim2.new(1,-80,1,0), UDim2.new(0,12,0,0),
                T.TextPrimary, Enum.Font.GothamBold, 13)

            -- Track
            local track = Instance.new("Frame")
            track.Size = UDim2.new(0,40,0,20)
            track.Position = UDim2.new(1,-50,0.5,0)
            track.AnchorPoint = Vector2.new(1,0.5)
            track.BackgroundColor3 = ToggleSettings.CurrentValue and T.ToggleOn or T.ToggleOff
            track.BorderSizePixel = 0
            track.Parent = f
            do
                local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(1,0); tc.Parent = track
                local ts = Instance.new("UIStroke")
                ts.Color = ToggleSettings.CurrentValue and T.Accent or T.BorderColor
                ts.Thickness = 1; ts.Parent = track
                track:SetAttribute("_stroke", ts)
            end

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0,14,0,14)
            knob.AnchorPoint = Vector2.new(0.5,0.5)
            knob.Position = ToggleSettings.CurrentValue and UDim2.new(1,-10,0.5,0) or UDim2.new(0,10,0.5,0)
            knob.BackgroundColor3 = ToggleSettings.CurrentValue and T.ToggleKnobOn or T.ToggleKnobOff
            knob.BorderSizePixel = 0
            knob.Parent = track
            do local kc = Instance.new("UICorner"); kc.CornerRadius = UDim.new(1,0); kc.Parent = knob end

            local function setState(val, runCb)
                ToggleSettings.CurrentValue = val
                tw(track, M, {BackgroundColor3 = val and T.ToggleOn or T.ToggleOff})
                tw(knob,  M, {
                    Position = val and UDim2.new(1,-10,0.5,0) or UDim2.new(0,10,0.5,0),
                    BackgroundColor3 = val and T.ToggleKnobOn or T.ToggleKnobOff,
                })
                local ts = track:GetAttribute("_stroke")
                if runCb then
                    local ok, err = pcall(ToggleSettings.Callback, val)
                    if not ok then warn("NovaUI | Toggle error:", err) end
                end
                if not ToggleSettings.Ext then SaveConfig() end
            end

            makeInteract(f).MouseButton1Click:Connect(function()
                setState(not ToggleSettings.CurrentValue, true)
            end)

            function ToggleSettings:Set(val) setState(val, true) end

            if not ToggleSettings.Ext and Settings.ConfigurationSaving
                and Settings.ConfigurationSaving.Enabled and ToggleSettings.Flag then
                NovaUI.Flags[ToggleSettings.Flag] = ToggleSettings
            end

            return ToggleSettings
        end

        -- ---- Slider ----
        function Tab:CreateSlider(SliderSettings)
            registerElement(SliderSettings.Name)
            local f, s, bar = makePanelFrame(tabPage, SliderSettings.Name, 56)

            local nameLabel = makeText(f, SliderSettings.Name,
                UDim2.new(0.6,0,0,22), UDim2.new(0,12,0,6),
                T.TextPrimary, Enum.Font.GothamBold, 13)

            local function fmtVal(v)
                return tostring(v) .. (SliderSettings.Suffix and (" " .. SliderSettings.Suffix) or "")
            end

            local valLabel = makeText(f, fmtVal(SliderSettings.CurrentValue),
                UDim2.new(0.35,0,0,22), UDim2.new(1,-130,0,6),
                T.Accent, Enum.Font.GothamBold, 12, Enum.TextXAlignment.Right)

            -- Track
            local trackBg = Instance.new("Frame")
            trackBg.Size = UDim2.new(1,-24,0,5)
            trackBg.Position = UDim2.new(0,12,0,36)
            trackBg.BackgroundColor3 = T.SliderTrack
            trackBg.BorderSizePixel = 0
            trackBg.Parent = f
            do
                local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(1,0); tc.Parent = trackBg
                local ts = Instance.new("UIStroke"); ts.Color = T.BorderColor; ts.Thickness = 1; ts.Transparency = 0.5; ts.Parent = trackBg
            end

            local pct0 = (SliderSettings.CurrentValue - SliderSettings.Range[1])
                / (SliderSettings.Range[2] - SliderSettings.Range[1])

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(math.clamp(pct0,0,1),0,1,0)
            fill.BackgroundColor3 = T.SliderFill
            fill.BorderSizePixel = 0
            fill.Parent = trackBg
            do local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(1,0); fc.Parent = fill end

            -- Thumb
            local thumb = Instance.new("Frame")
            thumb.Size = UDim2.new(0,12,0,12)
            thumb.AnchorPoint = Vector2.new(0.5,0.5)
            thumb.Position = UDim2.new(math.clamp(pct0,0,1),0,0.5,0)
            thumb.BackgroundColor3 = T.Accent
            thumb.BorderSizePixel = 0
            thumb.Parent = trackBg
            do
                local thc = Instance.new("UICorner"); thc.CornerRadius = UDim.new(1,0); thc.Parent = thumb
                local ths = Instance.new("UIStroke"); ths.Color = T.AccentDim; ths.Thickness = 2; ths.Parent = thumb
            end

            local interact = Instance.new("TextButton")
            interact.Size = UDim2.new(1,0,0,18)
            interact.Position = UDim2.new(0,0,0.5,-9)
            interact.BackgroundTransparency = 1
            interact.Text = ""
            interact.ZIndex = 12
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

            local rConn = RS.RenderStepped:Connect(function()
                if not dragging then return end
                local mouse = UIS:GetMouseLocation()
                local rel = math.clamp((mouse.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X, 0, 1)
                local raw = SliderSettings.Range[1] + rel * (SliderSettings.Range[2] - SliderSettings.Range[1])
                local snapped = math.floor(raw / SliderSettings.Increment + 0.5) * SliderSettings.Increment
                snapped = math.clamp(snapped, SliderSettings.Range[1], SliderSettings.Range[2])
                local p = (snapped - SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])
                fill.Size  = UDim2.new(p, 0, 1, 0)
                thumb.Position = UDim2.new(p, 0, 0.5, 0)
                valLabel.Text = fmtVal(snapped)
                if SliderSettings.CurrentValue ~= snapped then
                    SliderSettings.CurrentValue = snapped
                    pcall(SliderSettings.Callback, snapped)
                    if not SliderSettings.Ext then SaveConfig() end
                end
            end)
            f.Destroying:Connect(function() rConn:Disconnect() end)

            function SliderSettings:Set(val)
                val = math.clamp(val, SliderSettings.Range[1], SliderSettings.Range[2])
                SliderSettings.CurrentValue = val
                local p = (val - SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])
                tw(fill,  Q, {Size = UDim2.new(p,0,1,0)})
                tw(thumb, Q, {Position = UDim2.new(p,0,0.5,0)})
                valLabel.Text = fmtVal(val)
                pcall(SliderSettings.Callback, val)
                if not SliderSettings.Ext then SaveConfig() end
            end

            if Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled and SliderSettings.Flag then
                NovaUI.Flags[SliderSettings.Flag] = SliderSettings
            end
            return SliderSettings
        end

        -- ---- Input ----
        function Tab:CreateInput(InputSettings)
            registerElement(InputSettings.Name)
            local f, s, bar = makePanelFrame(tabPage, InputSettings.Name)

            makeText(f, InputSettings.Name,
                UDim2.new(0.45,0,1,0), UDim2.new(0,12,0,0),
                T.TextPrimary, Enum.Font.GothamBold, 13)

            local ifFrame, box = makeInputBox(f, UDim2.new(0.48,0,0,28),
                UDim2.new(1,-10,0.5,0), InputSettings.PlaceholderText or "")
            ifFrame.AnchorPoint = Vector2.new(1,0.5)
            box.Text = InputSettings.CurrentValue or ""

            box.Focused:Connect(function()
                tw(f, Q, {BackgroundColor3 = T.PanelHover})
            end)

            box.FocusLost:Connect(function()
                tw(f, Q, {BackgroundColor3 = T.PanelBg})
                InputSettings.CurrentValue = box.Text
                local ok, err = pcall(InputSettings.Callback, box.Text)
                if not ok then warn("NovaUI | Input error:", err) end
                if InputSettings.RemoveTextAfterFocusLost then box.Text = "" end
                if not InputSettings.Ext then SaveConfig() end
            end)

            function InputSettings:Set(text)
                box.Text = text
                InputSettings.CurrentValue = text
                pcall(InputSettings.Callback, text)
                if not InputSettings.Ext then SaveConfig() end
            end

            if Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled and InputSettings.Flag then
                NovaUI.Flags[InputSettings.Flag] = InputSettings
            end
            return InputSettings
        end

        -- ---- Dropdown ----
        function Tab:CreateDropdown(DropdownSettings)
            registerElement(DropdownSettings.Name)

            DropdownSettings.CurrentOption = DropdownSettings.CurrentOption or {}
            if type(DropdownSettings.CurrentOption) == "string" then
                DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption}
            end
            if not DropdownSettings.MultipleOptions then
                DropdownSettings.CurrentOption = {DropdownSettings.CurrentOption[1]}
            end

            local f, s, bar = makePanelFrame(tabPage, DropdownSettings.Name)
            f.ClipsDescendants = true

            local function selectedText()
                if #DropdownSettings.CurrentOption == 0 then return "None"
                elseif #DropdownSettings.CurrentOption == 1 then return DropdownSettings.CurrentOption[1]
                else return "Various" end
            end

            makeText(f, DropdownSettings.Name,
                UDim2.new(0.45,0,0,44), UDim2.new(0,12,0,0),
                T.TextPrimary, Enum.Font.GothamBold, 13)

            local selLabel = makeText(f, selectedText(),
                UDim2.new(0.4,0,0,44), UDim2.new(1,-120,0,0),
                T.Accent, Enum.Font.GothamBold, 12, Enum.TextXAlignment.Right)

            local chevron = makeText(f, "v", UDim2.new(0,20,0,44),
                UDim2.new(1,-24,0,0), T.TextMuted, Enum.Font.GothamBold, 11, Enum.TextXAlignment.Center)

            -- Options list
            local listFrame = Instance.new("Frame")
            listFrame.Size = UDim2.new(1,0,0,0)
            listFrame.Position = UDim2.new(0,0,0,44)
            listFrame.BackgroundTransparency = 1
            listFrame.BorderSizePixel = 0
            listFrame.Visible = false
            listFrame.Parent = f

            local listLayout2 = Instance.new("UIListLayout")
            listLayout2.SortOrder = Enum.SortOrder.LayoutOrder
            listLayout2.Padding = UDim.new(0,3)
            listLayout2.Parent = listFrame

            local listPad = Instance.new("UIPadding")
            listPad.PaddingLeft = UDim.new(0,8); listPad.PaddingRight = UDim.new(0,8)
            listPad.PaddingBottom = UDim.new(0,6)
            listPad.Parent = listFrame

            local opened = false

            local function buildOptions()
                for _, c in ipairs(listFrame:GetChildren()) do
                    if c:IsA("Frame") then c:Destroy() end
                end
                for _, opt in ipairs(DropdownSettings.Options) do
                    local optF = Instance.new("Frame")
                    optF.Name = opt
                    optF.Size = UDim2.new(1,0,0,30)
                    optF.BackgroundColor3 = table.find(DropdownSettings.CurrentOption, opt)
                        and T.DropSelected or T.InputBg
                    optF.BorderSizePixel = 0
                    optF.Parent = listFrame
                    do
                        local oc = Instance.new("UICorner"); oc.CornerRadius = UDim.new(0,5); oc.Parent = optF
                        local os = Instance.new("UIStroke"); os.Color = T.BorderColor; os.Thickness = 1; os.Parent = optF
                    end
                    makeText(optF, opt, UDim2.new(1,-16,1,0), UDim2.new(0,10,0,0),
                        table.find(DropdownSettings.CurrentOption, opt) and T.Accent or T.TextSecondary,
                        Enum.Font.Gotham, 12)

                    local optBtn = makeInteract(optF, 30)
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
                        selLabel.Text = selectedText()
                        -- Refresh option colors
                        for _, c in ipairs(listFrame:GetChildren()) do
                            if c:IsA("Frame") then
                                local sel = table.find(DropdownSettings.CurrentOption, c.Name) ~= nil
                                c.BackgroundColor3 = sel and T.DropSelected or T.InputBg
                                local l = c:FindFirstChildWhichIsA("TextLabel")
                                if l then l.TextColor3 = sel and T.Accent or T.TextSecondary end
                            end
                        end
                        pcall(DropdownSettings.Callback, DropdownSettings.CurrentOption)
                        if not DropdownSettings.MultipleOptions then
                            opened = false
                            listFrame.Visible = false
                            tw(f, M, {Size = UDim2.new(1,0,0,44)})
                            chevron.Text = "v"
                        end
                        if not DropdownSettings.Ext then SaveConfig() end
                    end)
                end
                listFrame.Size = UDim2.new(1,0,0,#DropdownSettings.Options * 33 + 6)
            end

            buildOptions()

            local topInteract = makeInteract(f)
            topInteract.MouseButton1Click:Connect(function()
                if Debounce then return end
                opened = not opened
                if opened then
                    listFrame.Visible = true
                    tw(f, M, {Size = UDim2.new(1,0,0,44 + #DropdownSettings.Options * 33 + 10)})
                    chevron.Text = "^"
                else
                    tw(f, M, {Size = UDim2.new(1,0,0,44)})
                    chevron.Text = "v"
                    task.wait(0.3)
                    listFrame.Visible = false
                end
            end)

            function DropdownSettings:Set(opt)
                if type(opt) == "string" then opt = {opt} end
                DropdownSettings.CurrentOption = opt
                selLabel.Text = selectedText()
                for _, c in ipairs(listFrame:GetChildren()) do
                    if c:IsA("Frame") then
                        local sel = table.find(DropdownSettings.CurrentOption, c.Name) ~= nil
                        c.BackgroundColor3 = sel and T.DropSelected or T.InputBg
                        local l = c:FindFirstChildWhichIsA("TextLabel")
                        if l then l.TextColor3 = sel and T.Accent or T.TextSecondary end
                    end
                end
                pcall(DropdownSettings.Callback, opt)
                if not DropdownSettings.Ext then SaveConfig() end
            end

            function DropdownSettings:Refresh(optTable)
                DropdownSettings.Options = optTable
                buildOptions()
            end

            if Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled and DropdownSettings.Flag then
                NovaUI.Flags[DropdownSettings.Flag] = DropdownSettings
            end
            return DropdownSettings
        end

        -- ---- Keybind ----
        function Tab:CreateKeybind(KeybindSettings)
            registerElement(KeybindSettings.Name)
            local f, s, bar = makePanelFrame(tabPage, KeybindSettings.Name)

            makeText(f, KeybindSettings.Name,
                UDim2.new(0.55,0,1,0), UDim2.new(0,12,0,0),
                T.TextPrimary, Enum.Font.GothamBold, 13)

            local kbFrame = Instance.new("Frame")
            kbFrame.Size = UDim2.new(0,72,0,26)
            kbFrame.Position = UDim2.new(1,-82,0.5,0)
            kbFrame.AnchorPoint = Vector2.new(1,0.5)
            kbFrame.BackgroundColor3 = T.InputBg
            kbFrame.BorderSizePixel = 0
            kbFrame.Parent = f
            do
                local kc = Instance.new("UICorner"); kc.CornerRadius = UDim.new(0,5); kc.Parent = kbFrame
                local ks = Instance.new("UIStroke"); ks.Color = T.InputBorder; ks.Thickness = 1; ks.Parent = kbFrame
            end

            local kbBox = Instance.new("TextBox")
            kbBox.Size = UDim2.new(1,-6,1,0)
            kbBox.Position = UDim2.new(0,4,0,0)
            kbBox.BackgroundTransparency = 1
            kbBox.Text = KeybindSettings.CurrentKeybind or "None"
            kbBox.TextColor3 = T.Accent
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

            local conn = UIS.InputBegan:Connect(function(input, processed)
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
                    if not KeybindSettings.Ext then SaveConfig() end
                elseif not checkingKey and not processed and KeybindSettings.CurrentKeybind
                    and not KeybindSettings.CallOnChange then
                    if input.KeyCode == Enum.KeyCode[KeybindSettings.CurrentKeybind] then
                        pcall(KeybindSettings.Callback)
                    end
                end
            end)
            table.insert(keybindConns, conn)

            function KeybindSettings:Set(key)
                kbBox.Text = tostring(key)
                KeybindSettings.CurrentKeybind = tostring(key)
                if KeybindSettings.CallOnChange then pcall(KeybindSettings.Callback, key) end
                if not KeybindSettings.Ext then SaveConfig() end
            end

            if Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled and KeybindSettings.Flag then
                NovaUI.Flags[KeybindSettings.Flag] = KeybindSettings
            end
            return KeybindSettings
        end

        -- ---- ColorPicker ----
        function Tab:CreateColorPicker(CPSettings)
            registerElement(CPSettings.Name)
            CPSettings.Type = "ColorPicker"

            local f, s, bar = makePanelFrame(tabPage, CPSettings.Name)
            f.ClipsDescendants = true

            makeText(f, CPSettings.Name,
                UDim2.new(1,-80,0,44), UDim2.new(0,12,0,0),
                T.TextPrimary, Enum.Font.GothamBold, 13)

            local display = Instance.new("Frame")
            display.Size = UDim2.new(0,36,0,20)
            display.Position = UDim2.new(1,-46,0.5,0)
            display.AnchorPoint = Vector2.new(1,0.5)
            display.BackgroundColor3 = CPSettings.Color or Color3.fromRGB(168,85,247)
            display.BorderSizePixel = 0
            display.Parent = f
            do
                local dc = Instance.new("UICorner"); dc.CornerRadius = UDim.new(0,4); dc.Parent = display
                local ds = Instance.new("UIStroke"); ds.Color = T.BorderColor; ds.Thickness = 1; ds.Parent = display
            end

            -- Expanded area
            local picker = Instance.new("Frame")
            picker.Size = UDim2.new(1,0,0,130)
            picker.Position = UDim2.new(0,0,0,44)
            picker.BackgroundTransparency = 1
            picker.Visible = false
            picker.Parent = f

            local svArea = Instance.new("Frame")
            svArea.Size = UDim2.new(1,-20,0,78)
            svArea.Position = UDim2.new(0,10,0,6)
            svArea.BorderSizePixel = 0
            svArea.Parent = picker
            do
                local svc2 = Instance.new("UICorner"); svc2.CornerRadius = UDim.new(0,5); svc2.Parent = svArea
                local svs = Instance.new("UIStroke"); svs.Color = T.BorderColor; svs.Thickness = 1; svs.Parent = svArea
            end

            local hueBar = Instance.new("Frame")
            hueBar.Size = UDim2.new(1,-20,0,12)
            hueBar.Position = UDim2.new(0,10,0,92)
            hueBar.BorderSizePixel = 0
            hueBar.Parent = picker
            do
                local hbc = Instance.new("UICorner"); hbc.CornerRadius = UDim.new(0,3); hbc.Parent = hueBar
                local grad = Instance.new("UIGradient")
                grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,    Color3.fromRGB(255,0,0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
                    ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(0,255,255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
                    ColorSequenceKeypoint.new(1,    Color3.fromRGB(255,0,0)),
                })
                grad.Parent = hueBar
            end

            local hexF = Instance.new("Frame")
            hexF.Size = UDim2.new(0,100,0,20)
            hexF.Position = UDim2.new(0,10,0,110)
            hexF.BackgroundColor3 = T.InputBg
            hexF.BorderSizePixel = 0
            hexF.Parent = picker
            do
                local hxc = Instance.new("UICorner"); hxc.CornerRadius = UDim.new(0,4); hxc.Parent = hexF
                local hxs = Instance.new("UIStroke"); hxs.Color = T.InputBorder; hxs.Thickness = 1; hxs.Parent = hexF
            end
            local hexBox = Instance.new("TextBox")
            hexBox.Size = UDim2.new(1,-8,1,0)
            hexBox.Position = UDim2.new(0,5,0,0)
            hexBox.BackgroundTransparency = 1
            hexBox.TextColor3 = T.TextPrimary
            hexBox.TextSize = 11
            hexBox.Font = Enum.Font.Code
            hexBox.TextXAlignment = Enum.TextXAlignment.Left
            hexBox.ClearTextOnFocus = false
            hexBox.Parent = hexF

            local h2, sv, vv = (CPSettings.Color or Color3.fromRGB(168,85,247)):ToHSV()
            CPSettings.Color = CPSettings.Color or Color3.fromRGB(168,85,247)

            local function updateUI()
                local col = Color3.fromHSV(h2, sv, vv)
                display.BackgroundColor3 = col
                svArea.BackgroundColor3  = Color3.fromHSV(h2,1,1)
                hexBox.Text = string.format("#%02X%02X%02X",
                    math.floor(col.R*255+.5), math.floor(col.G*255+.5), math.floor(col.B*255+.5))
                CPSettings.Color = col
                pcall(CPSettings.Callback, col)
            end

            local svDrag, hueDrag = false, false
            local svBtn = makeInteract(svArea, 78)
            local hueBtn = makeInteract(hueBar, 12)

            svBtn.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then svDrag = true end
            end)
            svBtn.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then svDrag = false end
            end)
            hueBtn.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then hueDrag = true end
            end)
            hueBtn.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then hueDrag = false end
            end)

            local cpConn = RS.RenderStepped:Connect(function()
                local mouse = UIS:GetMouseLocation()
                if svDrag then
                    sv = math.clamp((mouse.X - svArea.AbsolutePosition.X) / svArea.AbsoluteSize.X, 0, 1)
                    vv = 1 - math.clamp((mouse.Y - svArea.AbsolutePosition.Y) / svArea.AbsoluteSize.Y, 0, 1)
                    updateUI()
                    if not CPSettings.Ext then SaveConfig() end
                end
                if hueDrag then
                    h2 = math.clamp((mouse.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                    updateUI()
                    if not CPSettings.Ext then SaveConfig() end
                end
            end)
            f.Destroying:Connect(function() cpConn:Disconnect() end)

            hexBox.FocusLost:Connect(function()
                local hex = hexBox.Text:gsub("#","")
                local r, g, b = hex:match("^(%x%x)(%x%x)(%x%x)$")
                if r then
                    local col = Color3.fromRGB(tonumber(r,16), tonumber(g,16), tonumber(b,16))
                    h2, sv, vv = col:ToHSV()
                    updateUI()
                end
                if not CPSettings.Ext then SaveConfig() end
            end)

            local topInter = makeInteract(f)
            local openedCP = false
            topInter.MouseButton1Click:Connect(function()
                openedCP = not openedCP
                picker.Visible = openedCP
                tw(f, M, {Size = UDim2.new(1,0,0, openedCP and 180 or 44)})
            end)

            updateUI()

            function CPSettings:Set(color)
                CPSettings.Color = color
                h2, sv, vv = color:ToHSV()
                updateUI()
            end

            if Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled and CPSettings.Flag then
                NovaUI.Flags[CPSettings.Flag] = CPSettings
            end
            return CPSettings
        end

        return Tab
    end -- CreateTab

    return Window
end -- CreateWindow

-- ============================================================
-- GLOBAL API
-- ============================================================
function NovaUI:SetVisibility(v)
    if v then showWin() else hideWin(false) end
end

function NovaUI:IsVisible()
    return not Hidden
end

function NovaUI:Destroy()
    UIDestroyed = true
    for _, c in ipairs(keybindConns) do c:Disconnect() end
    Root:Destroy()
end

function NovaUI:LoadConfiguration()
    if CEnabled then
        local ok, result = pcall(function()
            if isfile and safe(isfile, ConfigFolder .. "/" .. CFileName .. ".nova") then
                local raw = safe(readfile, ConfigFolder .. "/" .. CFileName .. ".nova")
                if raw then
                    local loaded = LoadConfigData(raw)
                    if loaded then
                        NovaUI:Notify({
                            Title   = "Configuration Loaded",
                            Content = "Your saved configuration has been restored.",
                            Duration = 4
                        })
                    end
                end
            end
        end)
        if not ok then warn("NovaUI | Config load error:", result) end
    end
    globalLoaded = true
end

return NovaUI
