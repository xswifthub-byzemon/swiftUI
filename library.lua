-- [[ Swift Hub UI Library V5 (The Ultimate Pro) | Created by Pai for Zemon ]] --
local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ฟังก์ชันสร้าง Icon จาก SVG (Lucide Style)
local function CreateIcon(name, parent)
    local icons = {
        ["equal-not"] = "rbxassetid://10734906040", -- พับ
        ["expand"] = "rbxassetid://10747373176",    -- ขยาย
        ["octagon-x"] = "rbxassetid://10747383344"  -- ปิด
    }
    local icon = Instance.new("ImageLabel", parent)
    icon.Size = UDim2.new(0, 16, 0, 16)
    icon.BackgroundTransparency = 1
    icon.Image = icons[name] or ""
    icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    return icon
end

function Library:CreateWindow(Settings)
    local WindowName = Settings.Name or "Swift Hub"
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "SwiftHubUI"
    ScreenGui.ResetOnSpawn = false

    -- [Floating Button] ปุ่มเปิด/ปิด
    local FloatBtn = Instance.new("TextButton", ScreenGui)
    FloatBtn.Size = UDim2.new(0, 45, 0, 45)
    FloatBtn.Position = UDim2.new(0, 20, 0.5, -22)
    FloatBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    FloatBtn.Text = "S"
    FloatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    FloatBtn.Font = Enum.Font.GothamBold
    FloatBtn.TextSize = 18
    Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", FloatBtn).Color = Color3.fromRGB(255, 255, 255)

    -- Main Frame
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    MainFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
    MainFrame.Size = UDim2.new(0, 480, 0, 320)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(35, 35, 35)
    MainStroke.Thickness = 1.5

    -- Top Header Section
    local Header = Instance.new("Frame", MainFrame)
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel", Header)
    Title.Text = "  " .. WindowName
    Title.Size = UDim2.new(0.5, 0, 1, 0)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 15
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    -- Controls Corner (มุมบนขวา)
    local ControlGroup = Instance.new("Frame", Header)
    ControlGroup.Size = UDim2.new(0, 110, 1, 0)
    ControlGroup.Position = UDim2.new(1, -115, 0, 0)
    ControlGroup.BackgroundTransparency = 1
    local ControlLayout = Instance.new("UIListLayout", ControlGroup)
    ControlLayout.FillDirection = Enum.FillDirection.Horizontal
    ControlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ControlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ControlLayout.Padding = UDim.new(0, 12)

    local function MakeBtn(iconName, callback)
        local b = Instance.new("ImageButton", ControlGroup)
        b.Size = UDim2.new(0, 20, 0, 20)
        b.BackgroundTransparency = 1
        local img = CreateIcon(iconName, b)
        img.Position = UDim2.new(0.5, -8, 0.5, -8)
        b.MouseButton1Click:Connect(callback)
    end

    MakeBtn("equal-not", function() MainFrame.Visible = false end)
    MakeBtn("expand", function() 
        MainFrame.Size = (MainFrame.Size == UDim2.new(0, 480, 0, 320)) and UDim2.new(0, 560, 0, 400) or UDim2.new(0, 480, 0, 320)
    end)
    MakeBtn("octagon-x", function() ScreenGui:Destroy() end)

    FloatBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

    -- Layout Setup
    local SideBar = Instance.new("Frame", MainFrame)
    SideBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    SideBar.Position = UDim2.new(0, 0, 0, 45)
    SideBar.Size = UDim2.new(0, 140, 1, -45)

    -- ขีดกั้นแนวตั้ง (Vertical Separator)
    local Separator = Instance.new("Frame", MainFrame)
    Separator.Position = UDim2.new(0, 140, 0, 55)
    Separator.Size = UDim2.new(0, 1, 1, -65)
    Separator.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Separator.BorderSizePixel = 0

    local TabScroll = Instance.new("ScrollingFrame", SideBar)
    TabScroll.Size = UDim2.new(1, -10, 1, -10)
    TabScroll.Position = UDim2.new(0, 5, 0, 5)
    TabScroll.BackgroundTransparency = 1
    TabScroll.ScrollBarThickness = 0
    Instance.new("UIListLayout", TabScroll).Padding = UDim.new(0, 6)

    local PageHolder = Instance.new("Frame", MainFrame)
    PageHolder.Position = UDim2.new(0, 150, 0, 55)
    PageHolder.Size = UDim2.new(1, -160, 1, -65)
    PageHolder.BackgroundTransparency = 1

    local Tabs = {}
    local CurrentPage = nil

    function Tabs:CreateTab(Name)
        local Page = Instance.new("ScrollingFrame", PageHolder)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 12)

        local TBtn = Instance.new("TextButton", TabScroll)
        TBtn.Size = UDim2.new(1, 0, 0, 38)
        TBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TBtn.Text = Name; TBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
        TBtn.Font = Enum.Font.Gotham; TBtn.TextSize = 13
        Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", TBtn).Color = Color3.fromRGB(35, 35, 35)

        TBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PageHolder:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabScroll:GetChildren()) do 
                if v:IsA("TextButton") then 
                    v.TextColor3 = Color3.fromRGB(160, 160, 160)
                    v.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                end 
            end
            Page.Visible = true
            TBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        end)
        if not CurrentPage then Page.Visible = true; TBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CurrentPage = Page end

        local Elements = {}

        -- Dropdown
        function Elements:CreateDropdown(Text, List, Callback)
            local DFrame = Instance.new("Frame", Page)
            DFrame.Size = UDim2.new(1, 0, 0, 40)
            DFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Instance.new("UICorner", DFrame).CornerRadius = UDim.new(0, 8)
            local DBtn = Instance.new("TextButton", DFrame)
            DBtn.Size = UDim2.new(1, 0, 1, 0); DBtn.BackgroundTransparency = 1
            DBtn.Text = "  " .. Text .. " : Select..."; DBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            DBtn.TextXAlignment = Enum.TextXAlignment.Left; DBtn.Font = Enum.Font.Gotham

            local ListF = Instance.new("Frame", Page)
            ListF.Size = UDim2.new(1, 0, 0, 0); ListF.Visible = false; ListF.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Instance.new("UIListLayout", ListF)
            Instance.new("UICorner", ListF).CornerRadius = UDim.new(0, 8)

            DBtn.MouseButton1Click:Connect(function()
                ListF.Visible = not ListF.Visible
                ListF.Size = ListF.Visible and UDim2.new(1, 0, 0, #List * 32) or UDim2.new(1, 0, 0, 0)
            end)

            for _, v in pairs(List) do
                local Item = Instance.new("TextButton", ListF)
                Item.Size = UDim2.new(1, 0, 0, 32); Item.BackgroundTransparency = 1; Item.Text = v
                Item.TextColor3 = Color3.fromRGB(180, 180, 180); Item.Font = Enum.Font.Gotham
                Item.MouseButton1Click:Connect(function()
                    DBtn.Text = "  " .. Text .. " : " .. v; ListF.Visible = false; ListF.Size = UDim2.new(1, 0, 0, 0)
                    Callback(v)
                end)
            end
        end

        function Elements:CreateToggle(Text, Default, Callback)
            local Tgl = Instance.new("TextButton", Page)
            Tgl.Size = UDim2.new(1, 0, 0, 40); Tgl.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Tgl.Text = "  " .. Text; Tgl.TextColor3 = Color3.fromRGB(255, 255, 255); Tgl.TextXAlignment = Enum.TextXAlignment.Left; Tgl.Font = Enum.Font.Gotham
            Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 8)
            local Ind = Instance.new("Frame", Tgl)
            Ind.Position = UDim2.new(1, -35, 0.5, -10); Ind.Size = UDim2.new(0, 20, 0, 20)
            Instance.new("UICorner", Ind).CornerRadius = UDim.new(1, 0)
            local state = Default
            Ind.BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(50, 50, 50)
            Tgl.MouseButton1Click:Connect(function()
                state = not state; Ind.BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(50, 50, 50); Callback(state)
            end)
        end

        function Elements:CreateSlider(Text, Min, Max, Default, Callback)
            local Sld = Instance.new("Frame", Page)
            Sld.Size = UDim2.new(1, 0, 0, 55); Sld.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Instance.new("UICorner", Sld).CornerRadius = UDim.new(0, 8)
            local Lab = Instance.new("TextLabel", Sld)
            Lab.Text = "  " .. Text .. " : " .. Default; Lab.Size = UDim2.new(1, 0, 0, 30); Lab.TextColor3 = Color3.fromRGB(255, 255, 255); Lab.BackgroundTransparency = 1; Lab.TextXAlignment = Enum.TextXAlignment.Left
            local Bar = Instance.new("Frame", Sld)
            Bar.Position = UDim2.new(0, 15, 0, 38); Bar.Size = UDim2.new(1, -30, 0, 5); Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((Default-Min)/(Max-Min), 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
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
