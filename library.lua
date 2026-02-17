-- [[ Swift Hub UI Library V4 (Pro Black & White) | Created by Pai for Zemon ]] --
local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function Library:CreateWindow(Settings)
    local WindowName = Settings.Name or "Swift Hub"
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "SwiftHubUI"
    ScreenGui.ResetOnSpawn = false

    -- [Toggle Button] ปุ่มลอยสำหรับ เปิด/ปิด UI
    local ToggleButton = Instance.new("TextButton", ScreenGui)
    ToggleButton.Size = UDim2.new(0, 50, 0, 50)
    ToggleButton.Position = UDim2.new(0, 10, 0.5, -25)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ToggleButton.Text = "S"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextSize = 20
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)
    local UIStroke = Instance.new("UIStroke", ToggleButton)
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 2

    -- Main Frame
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 480, 0, 320)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(40, 40, 40)

    -- Top Bar (ปุ่มควบคุมมุมขวา)
    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundTransparency = 1

    local Controls = Instance.new("Frame", TopBar)
    Controls.Size = UDim2.new(0, 100, 1, 0)
    Controls.Position = UDim2.new(1, -110, 0, 0)
    Controls.BackgroundTransparency = 1
    Instance.new("UIListLayout", Controls).FillDirection = Enum.FillDirection.Horizontal
    Instance.new("UIListLayout", Controls).HorizontalAlignment = Enum.HorizontalAlignment.Right
    Instance.new("UIListLayout", Controls).VerticalAlignment = Enum.VerticalAlignment.Center
    Instance.new("UIListLayout", Controls).Padding = UDim.new(0, 10)

    local function CreateControl(text, color, callback)
        local btn = Instance.new("TextButton", Controls)
        btn.Size = UDim2.new(0, 20, 0, 20)
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
        btn.MouseButton1Click:Connect(callback)
    end

    CreateControl("-", Color3.fromRGB(60, 60, 60), function() 
        MainFrame.Visible = false 
    end) -- ย่อ
    CreateControl("□", Color3.fromRGB(60, 60, 60), function() 
        MainFrame.Size = (MainFrame.Size == UDim2.new(0, 480, 0, 320)) and UDim2.new(0, 550, 0, 400) or UDim2.new(0, 480, 0, 320)
    end) -- ขยาย
    CreateControl("X", Color3.fromRGB(200, 50, 50), function() 
        ScreenGui:Destroy() 
    end) -- ปิด

    ToggleButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    -- Sidebar & Page Container (เหมือนเดิมแต่ปรับสีขาวดำ)
    local SideBar = Instance.new("Frame", MainFrame)
    SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    SideBar.Size = UDim2.new(0, 140, 1, 0)
    Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 15)

    local TabContainer = Instance.new("ScrollingFrame", SideBar)
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.Size = UDim2.new(1, -20, 1, -60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 5)

    local PageContainer = Instance.new("Frame", MainFrame)
    PageContainer.Position = UDim2.new(0, 150, 0, 50)
    PageContainer.Size = UDim2.new(1, -160, 1, -60)
    PageContainer.BackgroundTransparency = 1

    local Tabs = {}
    local FirstTab = true

    function Tabs:CreateTab(Name)
        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.Text = Name; TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.Gotham; TabBtn.TextSize = 14
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PageContainer:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabContainer:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) end end
            Page.Visible = true; TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        if FirstTab then Page.Visible = true; TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255); FirstTab = false end

        local Elements = {}
        
        -- Dropdown (ใหม่!)
        function Elements:CreateDropdown(Text, List, Callback)
            local DropFrame = Instance.new("Frame", Page)
            DropFrame.Size = UDim2.new(1, -5, 0, 35)
            DropFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 8)
            
            local Label = Instance.new("TextButton", DropFrame)
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = "  " .. Text .. " : Select..."
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Font = Enum.Font.Gotham

            local ListFrame = Instance.new("Frame", Page)
            ListFrame.Size = UDim2.new(1, -5, 0, 0)
            ListFrame.Visible = false
            ListFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            ListFrame.ClipsDescendants = true
            Instance.new("UICorner", ListFrame).CornerRadius = UDim.new(0, 8)
            local ListLayout = Instance.new("UIListLayout", ListFrame)

            Label.MouseButton1Click:Connect(function()
                ListFrame.Visible = not ListFrame.Visible
                ListFrame.Size = ListFrame.Visible and UDim2.new(1, -5, 0, #List * 30) or UDim2.new(1, -5, 0, 0)
            end)

            for _, v in pairs(List) do
                local Item = Instance.new("TextButton", ListFrame)
                Item.Size = UDim2.new(1, 0, 0, 30)
                Item.BackgroundTransparency = 1
                Item.Text = v
                Item.TextColor3 = Color3.fromRGB(200, 200, 200)
                Item.Font = Enum.Font.Gotham
                Item.MouseButton1Click:Connect(function()
                    Label.Text = "  " .. Text .. " : " .. v
                    ListFrame.Visible = false
                    ListFrame.Size = UDim2.new(1, -5, 0, 0)
                    Callback(v)
                end)
            end
        end

        function Elements:CreateToggle(Text, Default, Callback)
            local Tgl = Instance.new("TextButton", Page)
            Tgl.Size = UDim2.new(1, -5, 0, 35); Tgl.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Tgl.Text = "  " .. Text; Tgl.TextColor3 = Color3.fromRGB(255, 255, 255)
            Tgl.TextXAlignment = Enum.TextXAlignment.Left; Tgl.Font = Enum.Font.Gotham
            Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 8)
            local Ind = Instance.new("Frame", Tgl)
            Ind.Position = UDim2.new(1, -30, 0.5, -8); Ind.Size = UDim2.new(0, 16, 0, 16)
            Instance.new("UICorner", Ind).CornerRadius = UDim.new(1, 0)
            local state = Default
            Ind.BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(60, 60, 60)
            Tgl.MouseButton1Click:Connect(function()
                state = not state
                Ind.BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(60, 60, 60)
                Callback(state)
            end)
        end

        function Elements:CreateSlider(Text, Min, Max, Default, Callback)
            local Sld = Instance.new("Frame", Page)
            Sld.Size = UDim2.new(1, -5, 0, 50); Sld.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Instance.new("UICorner", Sld).CornerRadius = UDim.new(0, 8)
            local Lab = Instance.new("TextLabel", Sld)
            Lab.Text = "  " .. Text .. " : " .. Default; Lab.Size = UDim2.new(1, 0, 0, 25)
            Lab.TextColor3 = Color3.fromRGB(255, 255, 255); Lab.BackgroundTransparency = 1; Lab.TextXAlignment = Enum.TextXAlignment.Left
            local Bar = Instance.new("Frame", Sld)
            Bar.Position = UDim2.new(0, 10, 0, 35); Bar.Size = UDim2.new(1, -20, 0, 4); Bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((Default-Min)/(Max-Min), 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            -- (Drag logic is standard)
            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local move = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                            local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                            Fill.Size = UDim2.new(pos, 0, 1, 0)
                            local val = math.floor(Min + (Max - Min) * pos)
                            Lab.Text = "  " .. Text .. " : " .. val; Callback(val)
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
