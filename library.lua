-- [[ Swift Hub UI Library V7 (Ultimate Fixed) | Created by Pai for Zemon ]] --
local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ฟังก์ชันดึงไอคอน Lucide จาก API โดยใช้ชื่อ (รองรับทุกชื่อ)
local function GetIconUrl(name)
    return "rbxassetid://10734906040" -- Default fallback
end

-- แมพไอคอนที่ซีม่อนต้องการเป็นพิเศษ
local SpecialIcons = {
    ["equal-not"] = "rbxassetid://10734906040",
    ["expand"] = "rbxassetid://10747373176",
    ["octagon-x"] = "rbxassetid://10747383344"
}

function Library:CreateWindow(Settings)
    local WindowName = Settings.Name or "Swift Hub"
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "SwiftHubUI"
    ScreenGui.ResetOnSpawn = false

    -- [Floating Button] ปุ่มลอยเปิด/ปิด
    local FloatBtn = Instance.new("TextButton", ScreenGui)
    FloatBtn.Size = UDim2.new(0, 45, 0, 45)
    FloatBtn.Position = UDim2.new(0, 20, 0.5, -22)
    FloatBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    FloatBtn.Text = "S"
    FloatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    FloatBtn.Font = Enum.Font.GothamBold
    FloatBtn.TextSize = 18
    Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", FloatBtn).Color = Color3.fromRGB(255, 255, 255)

    -- Main Frame
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
    MainFrame.Size = UDim2.new(0, 480, 0, 320)
    MainFrame.Active = true; MainFrame.Draggable = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(40, 40, 40)

    FloatBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    -- Header
    local Header = Instance.new("Frame", MainFrame)
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel", Header)
    Title.Text = "  " .. WindowName; Title.Size = UDim2.new(1, 0, 1, 0)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.BackgroundTransparency = 1

    -- Control Icons (มุมขวาบน)
    local Controls = Instance.new("Frame", Header)
    Controls.Size = UDim2.new(0, 100, 1, 0); Controls.Position = UDim2.new(1, -110, 0, 0); Controls.BackgroundTransparency = 1
    local Layout = Instance.new("UIListLayout", Controls)
    Layout.FillDirection = Enum.FillDirection.Horizontal; Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    Layout.VerticalAlignment = Enum.VerticalAlignment.Center; Layout.Padding = UDim.new(0, 10)

    local function AddBtn(icon, cb)
        local b = Instance.new("ImageButton", Controls)
        b.Size = UDim2.new(0, 20, 0, 20); b.BackgroundTransparency = 1
        b.Image = SpecialIcons[icon] or GetIconUrl(icon)
        b.MouseButton1Click:Connect(cb)
    end

    AddBtn("equal-not", function() MainFrame.Visible = false end)
    AddBtn("expand", function() MainFrame.Size = (MainFrame.Size == UDim2.new(0, 480, 0, 320)) and UDim2.new(0, 560, 0, 400) or UDim2.new(0, 480, 0, 320) end)
    AddBtn("octagon-x", function() ScreenGui:Destroy() end)

    -- Sidebar & Page Container
    local SideBar = Instance.new("Frame", MainFrame)
    SideBar.Size = UDim2.new(0, 130, 1, -40); SideBar.Position = UDim2.new(0, 0, 0, 40); SideBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    local Sep = Instance.new("Frame", MainFrame)
    Sep.Size = UDim2.new(0, 1, 1, -50); Sep.Position = UDim2.new(0, 130, 0, 45); Sep.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Sep.BorderSizePixel = 0
    local PageHolder = Instance.new("Frame", MainFrame)
    PageHolder.Size = UDim2.new(1, -140, 1, -50); PageHolder.Position = UDim2.new(0, 140, 0, 45); PageHolder.BackgroundTransparency = 1
    
    local TabList = Instance.new("UIListLayout", SideBar)
    TabList.Padding = UDim.new(0, 5); TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local Tabs = {}
    function Tabs:CreateTab(Name)
        local Page = Instance.new("ScrollingFrame", PageHolder)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        local TBtn = Instance.new("TextButton", SideBar)
        TBtn.Size = UDim2.new(1, -10, 0, 35); TBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        TBtn.Text = Name; TBtn.TextColor3 = Color3.fromRGB(150, 150, 150); TBtn.Font = Enum.Font.Gotham; TBtn.TextSize = 13
        Instance.new("UICorner", TBtn)

        TBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PageHolder:GetChildren()) do v.Visible = false end
            for _, v in pairs(SideBar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150, 150, 150) end end
            Page.Visible = true; TBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        if #SideBar:GetChildren() == 2 then Page.Visible = true; TBtn.TextColor3 = Color3.fromRGB(255, 255, 255) end

        local Elements = {}
        function Elements:CreateSection(Text)
            local s = Instance.new("TextLabel", Page); s.Size = UDim2.new(1, -5, 0, 25); s.BackgroundColor3 = Color3.fromRGB(30,30,30)
            s.Text = "  "..Text; s.TextColor3 = Color3.fromRGB(255,255,255); s.Font = Enum.Font.GothamBold; s.TextSize = 12; s.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", s)
        end
        function Elements:CreateButton(Text, cb)
            local b = Instance.new("TextButton", Page); b.Size = UDim2.new(1, -5, 0, 35); b.BackgroundColor3 = Color3.fromRGB(25,25,25)
            b.Text = "  "..Text; b.TextColor3 = Color3.fromRGB(255,255,255); b.Font = Enum.Font.Gotham; b.TextSize = 13; b.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", b); b.MouseButton1Click:Connect(cb)
        end
        function Elements:CreateToggle(Text, def, cb)
            local t = Instance.new("TextButton", Page); t.Size = UDim2.new(1, -5, 0, 35); t.BackgroundColor3 = Color3.fromRGB(25,25,25)
            t.Text = "  "..Text; t.TextColor3 = Color3.fromRGB(255,255,255); t.Font = Enum.Font.Gotham; t.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", t); local ind = Instance.new("Frame", t); ind.Position = UDim2.new(1,-30,0.5,-8); ind.Size = UDim2.new(0,16,0,16)
            Instance.new("UICorner", ind); local s = def; ind.BackgroundColor3 = s and Color3.new(1,1,1) or Color3.fromRGB(60,60,60)
            t.MouseButton1Click:Connect(function() s = not s; ind.BackgroundColor3 = s and Color3.new(1,1,1) or Color3.fromRGB(60,60,60); cb(s) end)
        end
        function Elements:CreateSlider(Text, min, max, def, cb)
            local f = Instance.new("Frame", Page); f.Size = UDim2.new(1,-5,0,45); f.BackgroundColor3 = Color3.fromRGB(25,25,25); Instance.new("UICorner", f)
            local l = Instance.new("TextLabel", f); l.Text = "  "..Text.." : "..def; l.Size = UDim2.new(1,0,0,25); l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
            local b = Instance.new("Frame", f); b.Position = UDim2.new(0,10,0,32); b.Size = UDim2.new(1,-20,0,4); b.BackgroundColor3 = Color3.fromRGB(50,50,50)
            local fill = Instance.new("Frame", b); fill.Size = UDim2.new((def-min)/(max-min),0,1,0); fill.BackgroundColor3 = Color3.new(1,1,1)
            b.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                local move = UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                    local p = math.clamp((i.Position.X - b.AbsolutePosition.X) / b.AbsoluteSize.X, 0, 1)
                    fill.Size = UDim2.new(p,0,1,0); local v = math.floor(min+(max-min)*p); l.Text = "  "..Text.." : "..v; cb(v)
                end end)
                i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then move:Disconnect() end end)
            end end)
        end
        function Elements:CreateDropdown(Text, list, cb)
            local d = Instance.new("Frame", Page); d.Size = UDim2.new(1,-5,0,40); d.BackgroundColor3 = Color3.fromRGB(25,25,25); Instance.new("UICorner", d)
            local btn = Instance.new("TextButton", d); btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1; btn.Text = "  "..Text.." : Select..."; btn.TextColor3 = Color3.new(1,1,1); btn.TextXAlignment = Enum.TextXAlignment.Left
            local listf = Instance.new("Frame", Page); listf.Size = UDim2.new(1,-5,0,0); listf.Visible = false; listf.BackgroundColor3 = Color3.fromRGB(20,20,20); Instance.new("UIListLayout", listf); Instance.new("UICorner", listf)
            btn.MouseButton1Click:Connect(function() listf.Visible = not listf.Visible; listf.Size = listf.Visible and UDim2.new(1,-5,0,#list*32) or UDim2.new(1,-5,0,0) end)
            for _, v in pairs(list) do
                local item = Instance.new("TextButton", listf); item.Size = UDim2.new(1,0,0,32); item.BackgroundTransparency = 1; item.Text = v; item.TextColor3 = Color3.fromRGB(200,200,200)
                item.MouseButton1Click:Connect(function() btn.Text = "  "..Text.." : "..v; listf.Visible = false; listf.Size = UDim2.new(1,-5,0,0); cb(v) end)
            end
        end
        return Elements
    end
    return Tabs
end
return Library
