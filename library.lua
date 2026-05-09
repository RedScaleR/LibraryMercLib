-- Modern Roblox UI Library
-- Custom lightweight library
-- Features:
-- Window
-- Tabs
-- Buttons
-- Toggles
-- Sliders
-- Modern dark style
-- Dragging
-- Tween animations

local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function Library:CreateWindow(title)

    local ScreenGui = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local Top = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local TabHolder = Instance.new("Frame")
    local ContentHolder = Instance.new("Frame")
    local UIStroke = Instance.new("UIStroke")
    local UICorner = Instance.new("UICorner")

    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "ModernLibrary"

    Main.Parent = ScreenGui
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.BackgroundColor3 = Color3.fromRGB(18,18,18)

    UICorner.Parent = Main
    UICorner.CornerRadius = UDim.new(0,16)

    UIStroke.Parent = Main
    UIStroke.Color = Color3.fromRGB(45,45,45)

    Top.Parent = Main
    Top.Size = UDim2.new(1,0,0,50)
    Top.BackgroundTransparency = 1

    Title.Parent = Top
    Title.Text = title or "Modern UI"
    Title.Size = UDim2.new(1,0,1,0)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.BackgroundTransparency = 1

    TabHolder.Parent = Main
    TabHolder.Position = UDim2.new(0,10,0,60)
    TabHolder.Size = UDim2.new(0,150,1,-70)
    TabHolder.BackgroundTransparency = 1

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabHolder
    TabList.Padding = UDim.new(0,8)

    ContentHolder.Parent = Main
    ContentHolder.Position = UDim2.new(0,170,0,60)
    ContentHolder.Size = UDim2.new(1,-180,1,-70)
    ContentHolder.BackgroundTransparency = 1

    -- Dragging

    local dragging = false
    local dragInput
    local dragStart
    local startPos

    Top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Top.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart

            TweenService:Create(Main,TweenInfo.new(0.08),{
                Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            }):Play()
        end
    end)

    local WindowFunctions = {}

    function WindowFunctions:CreateTab(name)

        local TabButton = Instance.new("TextButton")
        local TabFrame = Instance.new("ScrollingFrame")

        TabButton.Parent = TabHolder
        TabButton.Size = UDim2.new(1,0,0,40)
        TabButton.BackgroundColor3 = Color3.fromRGB(28,28,28)
        TabButton.Text = name
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.TextSize = 14
        TabButton.TextColor3 = Color3.fromRGB(255,255,255)

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.Parent = TabButton
        ButtonCorner.CornerRadius = UDim.new(0,12)

        TabFrame.Parent = ContentHolder
        TabFrame.Size = UDim2.new(1,0,1,0)
        TabFrame.Visible = false
        TabFrame.BackgroundTransparency = 1
        TabFrame.CanvasSize = UDim2.new(0,0,0,0)
        TabFrame.ScrollBarThickness = 0

        local Layout = Instance.new("UIListLayout")
        Layout.Parent = TabFrame
        Layout.Padding = UDim.new(0,10)

        TabButton.MouseButton1Click:Connect(function()
            for _,v in pairs(ContentHolder:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end

            TabFrame.Visible = true
        end)

        local TabFunctions = {}

        function TabFunctions:CreateButton(text, callback)

            local Button = Instance.new("TextButton")

            Button.Parent = TabFrame
            Button.Size = UDim2.new(1,-5,0,45)
            Button.BackgroundColor3 = Color3.fromRGB(30,30,30)
            Button.Text = text
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 14
            Button.TextColor3 = Color3.fromRGB(255,255,255)

            local Corner = Instance.new("UICorner")
            Corner.Parent = Button
            Corner.CornerRadius = UDim.new(0,12)

            Button.MouseButton1Click:Connect(function()

                TweenService:Create(Button,TweenInfo.new(0.1),{
                    BackgroundColor3 = Color3.fromRGB(45,45,45)
                }):Play()

                task.wait(0.1)

                TweenService:Create(Button,TweenInfo.new(0.1),{
                    BackgroundColor3 = Color3.fromRGB(30,30,30)
                }):Play()

                callback()
            end)
        end

        function TabFunctions:CreateToggle(text, default, callback)

            local Toggle = false
            Toggle = default

            local Button = Instance.new("TextButton")

            Button.Parent = TabFrame
            Button.Size = UDim2.new(1,-5,0,45)
            Button.BackgroundColor3 = Color3.fromRGB(30,30,30)
            Button.Text = text .. " : " .. tostring(Toggle)
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 14
            Button.TextColor3 = Color3.fromRGB(255,255,255)

            local Corner = Instance.new("UICorner")
            Corner.Parent = Button
            Corner.CornerRadius = UDim.new(0,12)

            Button.MouseButton1Click:Connect(function()

                Toggle = not Toggle
                Button.Text = text .. " : " .. tostring(Toggle)

                callback(Toggle)
            end)
        end

        return TabFunctions
    end

    return WindowFunctions
end

return Library
