-- [[ Swift Hub UI Library (V3: Pro Edition) | Created by Pai for Zemon ]] --
local Library = {}
local TweenService = game:GetService("TweenService")

function Library:CreateWindow(Settings)
    local WindowName = Settings.Name or "Swift Hub"
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "SwiftHubUI"

    -- Main Frame
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 450, 0, 300)
    MainFrame.Active = true
    MainFrame.Draggable = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

    -- Sidebar
    local SideBar = Instance.new("Frame", MainFrame)
    SideBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    SideBar.Size = UDim2.new(0, 120, 1, 0)
    Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel", SideBar)
    Title.Text = "Swift Hub"
    Title.TextColor3 = Color3.fromRGB(255, 105, 180)
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16

    local TabContainer = Instance.new("ScrollingFrame", SideBar)
    TabContainer.Position = UDim2.new(0, 5, 0, 50)
    TabContainer.Size = UDim2.new(1, -10, 1, -60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    local TabLayout = Instance.new("UIListLayout", TabContainer)
    TabLayout.Padding = UDim.new(0, 5)

    -- Page Container
    local PageContainer = Instance.new("Frame", MainFrame)
    PageContainer.Position = UDim2.new(0, 125, 0, 10)
    PageContainer.Size = UDim2.new(1, -135, 1, -20)
    PageContainer.BackgroundTransparency = 1

    local Tabs = {}
    local FirstTab = true

    function Tabs:CreateTab(Name)
        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.Text = Name
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 13
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabContainer:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(200, 200, 200) end end
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 105, 180)
        end)

        if FirstTab then Page.Visible = true; TabBtn.TextColor3 = Color3.fromRGB(255, 105, 180); FirstTab = false end

        local Elements = {}

        -- Section (กรอบพื้นหลังเล็กๆ)
        function Elements:CreateSection(Text)
            local SectionLabel = Instance.new("TextLabel", Page)
            SectionLabel.Size = UDim2.new(1, 0, 0, 20)
            SectionLabel.Text = "  " .. Text
            SectionLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextSize = 14
            SectionLabel.BackgroundTransparency = 1
        end

        -- Button
        function Elements:CreateButton(Text, Callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1, -5, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Btn.Text = "  " .. Text
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 13
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
            Btn.MouseButton1Click:Connect(Callback)
        end

        -- Toggle
        function Elements:CreateToggle(Text, Default, Callback)
            local TglFrame = Instance.new("TextButton", Page)
            TglFrame.Size = UDim2.new(1, -5, 0, 35)
            TglFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            TglFrame.Text = "  " .. Text
            TglFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
            TglFrame.Font = Enum.Font.Gotham
            TglFrame.TextSize = 13
            TglFrame.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", TglFrame).CornerRadius = UDim.new(0, 6)

            local Status = Default
            local Indicator = Instance.new("Frame", TglFrame)
            Indicator.Position = UDim2.new(1, -30, 0.5, -8)
            Indicator.Size = UDim2.new(0, 16, 0, 16)
            Indicator.BackgroundColor3 = Status and Color3.fromRGB(255, 105, 180) or Color3.fromRGB(50, 50, 50)
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

            TglFrame.MouseButton1Click:Connect(function()
                Status = not Status
                TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = Status and Color3.fromRGB(255, 105, 180) or Color3.fromRGB(50, 50, 50)}):Play()
                Callback(Status)
            end)
        end

        -- Slider
        function Elements:CreateSlider(Text, Min, Max, Default, Callback)
            local SldFrame = Instance.new("Frame", Page)
            SldFrame.Size = UDim2.new(1, -5, 0, 45)
            SldFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Instance.new("UICorner", SldFrame).CornerRadius = UDim.new(0, 6)

            local SldLabel = Instance.new("TextLabel", SldFrame)
            SldLabel.Text = "  " .. Text
            SldLabel.Size = UDim2.new(1, 0, 0, 25)
            SldLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SldLabel.BackgroundTransparency = 1
            SldLabel.TextXAlignment = Enum.TextXAlignment.Left
            SldLabel.Font = Enum.Font.Gotham

            local Bar = Instance.new("Frame", SldFrame)
            Bar.Position = UDim2.new(0, 10, 0, 30)
            Bar.Size = UDim2.new(1, -50, 0, 4)
            Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((Default-Min)/(Max-Min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(255, 105, 180)

            local ValLabel = Instance.new("TextLabel", SldFrame)
            ValLabel.Text = tostring(Default)
            ValLabel.Position = UDim2.new(1, -35, 0, 25)
            ValLabel.Size = UDim2.new(0, 30, 0, 15)
            ValLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValLabel.BackgroundTransparency = 1

            -- (Simplified Drag Logic for Mobile)
            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local move = game:GetService("UserInputService").InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                            local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                            Fill.Size = UDim2.new(pos, 0, 1, 0)
                            local val = math.floor(Min + (Max - Min) * pos)
                            ValLabel.Text = tostring(val)
                            Callback(val)
                        end
                    end)
                    input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then move:Disconnect() end end)
                end
            end)
        end

        return Elements
    end
    return Tabs
end

return Library
