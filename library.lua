--// SAIF UI LIBRARY V2
--// Modern Advanced UI
--// Glassmorphism + Smooth Animations + Sections

local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function Library:CreateWindow(cfg)

    cfg = cfg or {}

    local TitleText = cfg.Name or "Saif UI"

    local ScreenGui = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local Topbar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local Glow = Instance.new("ImageLabel")
    local TabsHolder = Instance.new("Frame")
    local ContentHolder = Instance.new("Frame")

    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = "SaifUI"

    Main.Parent = ScreenGui
    Main.Size = UDim2.new(0, 760, 0, 460)
    Main.Position = UDim2.new(0.5,-380,0.5,-230)
    Main.BackgroundColor3 = Color3.fromRGB(15,15,18)
    Main.ClipsDescendants = true

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(45,45,50)
    Stroke.Thickness = 1.2

    Glow.Parent = Main
    Glow.BackgroundTransparency = 1
    Glow.Size = UDim2.new(1,200,1,200)
    Glow.Position = UDim2.new(0,-100,0,-100)
    Glow.Image = "rbxassetid://5028857084"
    Glow.ImageTransparency = 0.85
    Glow.ImageColor3 = Color3.fromRGB(0,170,255)

    Topbar.Parent = Main
    Topbar.Size = UDim2.new(1,0,0,58)
    Topbar.BackgroundTransparency = 1

    Title.Parent = Topbar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0,20,0,0)
    Title.Size = UDim2.new(1,0,1,0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = TitleText
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Divider = Instance.new("Frame")
    Divider.Parent = Main
    Divider.Position = UDim2.new(0,0,0,58)
    Divider.Size = UDim2.new(1,0,0,1)
    Divider.BackgroundColor3 = Color3.fromRGB(40,40,45)
    Divider.BorderSizePixel = 0

    TabsHolder.Parent = Main
    TabsHolder.BackgroundTransparency = 1
    TabsHolder.Position = UDim2.new(0,12,0,72)
    TabsHolder.Size = UDim2.new(0,170,1,-84)

    local TabsLayout = Instance.new("UIListLayout", TabsHolder)
    TabsLayout.Padding = UDim.new(0,8)

    ContentHolder.Parent = Main
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Position = UDim2.new(0,195,0,72)
    ContentHolder.Size = UDim2.new(1,-208,1,-84)

    -- Dragging

    local dragging = false
    local dragStart
    local startPos

    Topbar.InputBegan:Connect(function(input)
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

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then

            local delta = input.Position - dragStart

            TweenService:Create(Main,TweenInfo.new(
                0.08,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ),{
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

    function WindowFunctions:CreateTab(tabName)

        local TabButton = Instance.new("TextButton")
        local TabFrame = Instance.new("ScrollingFrame")

        TabButton.Parent = TabsHolder
        TabButton.Size = UDim2.new(1,0,0,42)
        TabButton.BackgroundColor3 = Color3.fromRGB(22,22,26)
        TabButton.Text = "   "..tabName
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.TextSize = 14
        TabButton.TextColor3 = Color3.fromRGB(220,220,220)
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.AutoButtonColor = false

        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0,12)

        local TabStroke = Instance.new("UIStroke", TabButton)
        TabStroke.Color = Color3.fromRGB(35,35,40)

        TabFrame.Parent = ContentHolder
        TabFrame.Visible = false
        TabFrame.BackgroundTransparency = 1
        TabFrame.Size = UDim2.new(1,0,1,0)
        TabFrame.ScrollBarThickness = 0
        TabFrame.CanvasSize = UDim2.new(0,0,0,0)

        local Layout = Instance.new("UIListLayout", TabFrame)
        Layout.Padding = UDim.new(0,12)

        TabButton.MouseEnter:Connect(function()

            TweenService:Create(TabButton,TweenInfo.new(
                0.2,
                Enum.EasingStyle.Quint
            ),{
                BackgroundColor3 = Color3.fromRGB(28,28,34)
            }):Play()

        end)

        TabButton.MouseLeave:Connect(function()

            TweenService:Create(TabButton,TweenInfo.new(
                0.2,
                Enum.EasingStyle.Quint
            ),{
                BackgroundColor3 = Color3.fromRGB(22,22,26)
            }):Play()

        end)

        TabButton.MouseButton1Click:Connect(function()

            for _,v in pairs(ContentHolder:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end

            TabFrame.Visible = true

            for _,b in pairs(TabsHolder:GetChildren()) do
                if b:IsA("TextButton") then
                    TweenService:Create(b,TweenInfo.new(0.2),{
                        BackgroundColor3 = Color3.fromRGB(22,22,26)
                    }):Play()
                end
            end

            TweenService:Create(TabButton,TweenInfo.new(0.25),{
                BackgroundColor3 = Color3.fromRGB(0,170,255)
            }):Play()

        end)

        local TabFunctions = {}

        function TabFunctions:CreateSection(sectionName)

            local Section = Instance.new("Frame")
            local SectionTitle = Instance.new("TextLabel")
            local Holder = Instance.new("Frame")

            Section.Parent = TabFrame
            Section.Size = UDim2.new(1,-4,0,200)
            Section.BackgroundColor3 = Color3.fromRGB(20,20,24)

            Instance.new("UICorner", Section).CornerRadius = UDim.new(0,16)

            local SectionStroke = Instance.new("UIStroke", Section)
            SectionStroke.Color = Color3.fromRGB(40,40,45)

            SectionTitle.Parent = Section
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0,16,0,12)
            SectionTitle.Size = UDim2.new(1,0,0,20)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = sectionName
            SectionTitle.TextColor3 = Color3.fromRGB(255,255,255)
            SectionTitle.TextSize = 15
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

            local Line = Instance.new("Frame")
            Line.Parent = Section
            Line.Position = UDim2.new(0,16,0,42)
            Line.Size = UDim2.new(1,-32,0,1)
            Line.BackgroundColor3 = Color3.fromRGB(35,35,40)
            Line.BorderSizePixel = 0

            Holder.Parent = Section
            Holder.BackgroundTransparency = 1
            Holder.Position = UDim2.new(0,14,0,54)
            Holder.Size = UDim2.new(1,-28,1,-66)

            local HolderLayout = Instance.new("UIListLayout", Holder)
            HolderLayout.Padding = UDim.new(0,10)

            local SectionFunctions = {}

            function SectionFunctions:CreateButton(name,callback)

                local Btn = Instance.new("TextButton")

                Btn.Parent = Holder
                Btn.Size = UDim2.new(1,0,0,42)
                Btn.BackgroundColor3 = Color3.fromRGB(28,28,32)
                Btn.Text = name
                Btn.Font = Enum.Font.GothamMedium
                Btn.TextSize = 14
                Btn.TextColor3 = Color3.fromRGB(255,255,255)
                Btn.AutoButtonColor = false

                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,12)

                Btn.MouseEnter:Connect(function()

                    TweenService:Create(Btn,TweenInfo.new(
                        0.15,
                        Enum.EasingStyle.Quint
                    ),{
                        BackgroundColor3 = Color3.fromRGB(36,36,42)
                    }):Play()

                end)

                Btn.MouseLeave:Connect(function()

                    TweenService:Create(Btn,TweenInfo.new(
                        0.15,
                        Enum.EasingStyle.Quint
                    ),{
                        BackgroundColor3 = Color3.fromRGB(28,28,32)
                    }):Play()

                end)

                Btn.MouseButton1Click:Connect(function()

                    TweenService:Create(Btn,TweenInfo.new(
                        0.08
                    ),{
                        Size = UDim2.new(0.98,0,0,40)
                    }):Play()

                    task.wait(0.08)

                    TweenService:Create(Btn,TweenInfo.new(
                        0.12
                    ),{
                        Size = UDim2.new(1,0,0,42)
                    }):Play()

                    callback()

                end)

            end

            return SectionFunctions
        end

        return TabFunctions
    end

    return WindowFunctions
end

return Library
