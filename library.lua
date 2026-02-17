-- [[ Swift Hub UI Library V9 (Table Support) | Created by Pai for Zemon ]] --
local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- รวมมิตร ID ไอคอน Lucide ของแท้ (ใช้งานได้จริง)
local Lucide = {
    ["sword"] = "rbxassetid://10723306472", -- ดาบ
    ["settings"] = "rbxassetid://10734950309", -- ฟันเฟือง
    ["user"] = "rbxassetid://10747383474", -- คน
    ["home"] = "rbxassetid://10734882772", -- บ้าน
    ["list"] = "rbxassetid://10734903332", -- รายการ
    ["zap"] = "rbxassetid://10709848574", -- สายฟ้า
    ["shield"] = "rbxassetid://10734963524", -- โล่
    ["skull"] = "rbxassetid://10734966607", -- หัวกะโหลก
    -- ไอคอนควบคุม UI
    ["equal-not"] = "rbxassetid://10734906040", -- พับจอ
    ["expand"] = "rbxassetid://10747373176", -- ขยาย
    ["octagon-x"] = "rbxassetid://10747383344" -- ปิด
}

function Library:CreateWindow(Settings)
    local WindowName = Settings.Name or "Swift Hub"
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "SwiftHubUI"
    ScreenGui.ResetOnSpawn = false

    -- [Floating Button] ปุ่มลอย
    local FloatBtn = Instance.new("TextButton", ScreenGui)
    FloatBtn.Size = UDim2.new(0, 45, 0, 45)
    FloatBtn.Position = UDim2.new(0, 20, 0.5, -22)
    FloatBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    FloatBtn.Text = "S"; FloatBtn.TextColor3 = Color3.new(1,1,1)
    FloatBtn.Font = Enum.Font.GothamBold; FloatBtn.TextSize = 18
    Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", FloatBtn).Color = Color3.new(1,1,1)

    -- Main Frame
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
    MainFrame.Size = UDim2.new(0, 480, 0, 320)
    MainFrame.Active = true; MainFrame.Draggable = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(45, 45, 45)

    FloatBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

    -- Header
    local Header = Instance.new("Frame", MainFrame)
    Header.Size = UDim2.new(1, 0, 0, 40); Header.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel", Header)
    Title.Text = "  " .. WindowName; Title.Size = UDim2.new(1, 0, 1, 0)
    Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.GothamBold; Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left; Title.BackgroundTransparency = 1

    -- Control Icons (มุมขวาบน)
    local Controls = Instance.new("Frame", Header)
    Controls.Size = UDim2.new(0, 110, 1, 0); Controls.Position = UDim2.new(1, -115, 0, 0); Controls.BackgroundTransparency = 1
    local Layout = Instance.new("UIListLayout", Controls)
    Layout.FillDirection = Enum.FillDirection.Horizontal; Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right; Layout.VerticalAlignment = Enum.VerticalAlignment.Center; Layout.Padding = UDim.new(0, 12)

    local function AddTopBtn(iconKey, cb)
        local b = Instance.new("ImageButton", Controls)
        b.Size = UDim2.new(0, 18, 0, 18); b.BackgroundTransparency = 1
        b.Image = Lucide[iconKey] or "" -- ดึงรูปจากตัวแปร Lucide โดยตรง
        b.ImageColor3 = Color3.new(1,1,1)
        b.MouseButton1Click:Connect(cb)
    end

    AddTopBtn("equal-not", function() MainFrame.Visible = false end)
    AddTopBtn("expand", function() MainFrame.Size = (MainFrame.Size == UDim2.new(0, 480, 0, 320)) and UDim2.new(0, 560, 0, 400) or UDim2.new(0, 480, 0, 320) end)
    AddTopBtn("octagon-x", function() ScreenGui:Destroy() end)

    -- Sidebar
    local SideBar = Instance.new("Frame", MainFrame)
    SideBar.Size = UDim2.new(0, 140, 1, -40); SideBar.Position = UDim2.new(0, 0, 0, 40); SideBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Instance.new("UIListLayout", SideBar).Padding = UDim.new(0, 5)

    local PageHolder = Instance.new("Frame", MainFrame)
    PageHolder.Size = UDim2.new(1, -150, 1, -50); PageHolder.Position = UDim2.new(0, 150, 0, 45); PageHolder.BackgroundTransparency = 1

    local Tabs = {}
    
    -- [[ แก้ไขฟังก์ชัน CreateTab ให้รองรับ Table ]] --
    function Tabs:CreateTab(TabSettings)
        -- เช็คว่าส่งมาเป็น Table หรือไม่ ถ้าใช่ให้ดึงค่า Name กับ Icon
        local Name, IconKey
        if type(TabSettings) == "table" then
            Name = TabSettings.Name
            IconKey = TabSettings.Icon
        else
            Name = TabSettings -- รองรับแบบเก่า (ใส่แค่ชื่อ)
        end

        local Page = Instance.new("ScrollingFrame", PageHolder)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        local TBtn = Instance.new("TextButton", SideBar)
        TBtn.Size = UDim2.new(1, -10, 0, 38); TBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        -- เว้นวรรคข้างหน้าเยอะๆ เพื่อหลบไอคอน
        TBtn.Text = "       " .. Name; TBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
        TBtn.Font = Enum.Font.Gotham; TBtn.TextSize = 13; TBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TBtn)

        -- สร้างรูปไอคอน (ถ้ามีการใส่ Icon มา)
        if IconKey and Lucide[IconKey] then
            local IconImg = Instance.new("ImageLabel", TBtn)
            IconImg.Size = UDim2.new(0, 18, 0, 18)
            IconImg.Position = UDim2.new(0, 10, 0.5, -9) -- จัดกึ่งกลางแนวตั้ง
            IconImg.BackgroundTransparency = 1
            IconImg.Image = Lucide[IconKey]
            IconImg.ImageColor3 = Color3.fromRGB(160, 160, 160)
        end

        TBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PageHolder:GetChildren()) do v.Visible = false end
            for _, v in pairs(SideBar:GetChildren()) do 
                if v:IsA("TextButton") then 
                    v.TextColor3 = Color3.fromRGB(160, 160, 160)
                    -- เปลี่ยนสีไอคอนกลับเป็นสีเทา
                    if v:FindFirstChildOfClass("ImageLabel") then
                        v:FindFirstChildOfClass("ImageLabel").ImageColor3 = Color3.fromRGB(160, 160, 160)
                    end
                end 
            end
            Page.Visible = true; TBtn.TextColor3 = Color3.new(1,1,1)
            -- เปลี่ยนสีไอคอนเป็นสีขาวตอนกดเลือก
            if TBtn:FindFirstChildOfClass("ImageLabel") then
                TBtn:FindFirstChildOfClass("ImageLabel").ImageColor3 = Color3.new(1,1,1)
            end
        end)
        
        -- เลือกหน้าแรกอัตโนมัติ
        if #SideBar:GetChildren() == 2 then 
            Page.Visible = true; TBtn.TextColor3 = Color3.new(1,1,1)
            if TBtn:FindFirstChildOfClass("ImageLabel") then
                TBtn:FindFirstChildOfClass("ImageLabel").ImageColor3 = Color3.new(1,1,1)
            end
        end

        local Elements = {}
        function Elements:CreateSection(Text)
            local s = Instance.new("TextLabel", Page); s.Size = UDim2.new(1, -5, 0, 30); s.BackgroundColor3 = Color3.fromRGB(25,25,25)
            s.Text = "  "..Text; s.TextColor3 = Color3.new(1,1,1); s.Font = Enum.Font.GothamBold; s.TextSize = 13; s.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", s)
        end
        function Elements:CreateButton(Text, cb)
            local b = Instance.new("TextButton", Page); b.Size = UDim2.new(1, -5, 0, 35); b.BackgroundColor3 = Color3.fromRGB(25,25,25)
            b.Text = "  "..Text; b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Gotham; b.TextSize = 13; b.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", b); b.MouseButton1Click:Connect(cb)
        end
        function Elements:CreateToggle(Text, def, cb)
            local t = Instance.new("TextButton", Page); t.Size = UDim2.new(1, -5, 0, 35); t.BackgroundColor3 = Color3.fromRGB(25,25,25)
            t.Text = "  "..Text; t.TextColor3 = Color3.new(1,1,1); t.Font = Enum.Font.Gotham; t.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", t); local ind = Instance.new("Frame", t); ind.Position = UDim2.new(1,-35,0.5,-10); ind.Size = UDim2.new(0,20,0,20)
            Instance.new("UICorner", ind); local s = def; ind.BackgroundColor3 = s and Color3.new(1,1,1) or Color3.fromRGB(60,60,60)
            t.MouseButton1Click:Connect(function() s = not s; ind.BackgroundColor3 = s and Color3.new(1,1,1) or Color3.fromRGB(60,60,60); cb(s) end)
        end
        function Elements:CreateSlider(Text, min, max, def, cb)
            local f = Instance.new("Frame", Page); f.Size = UDim2.new(1,-5,0,50); f.BackgroundColor3 = Color3.fromRGB(25,25,25); Instance.new("UICorner", f)
            local l = Instance.new("TextLabel", f); l.Text = "  "..Text.." : "..def; l.Size = UDim2.new(1,0,0,30); l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1; l.TextXAlignment = Enum.TextXAlignment.Left
            local b = Instance.new("Frame", f); b.Position = UDim2.new(0,10,0,35); b.Size = UDim2.new(1,-20,0,4); b.BackgroundColor3 = Color3.fromRGB(50,50,50)
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
            local d = Instance.new("Frame", Page); d.Size = UDim2.new(1,-5,0,45); d.BackgroundColor3 = Color3.fromRGB(25,25,25); Instance.new("UICorner", d)
            local btn = Instance.new("TextButton", d); btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1; btn.Text = "  "..Text.." : Select..."; btn.TextColor3 = Color3.new(1,1,1); btn.TextXAlignment = Enum.TextXAlignment.Left
            local listf = Instance.new("Frame", Page); listf.Size = UDim2.new(1,-5,0,0); listf.Visible = false; listf.BackgroundColor3 = Color3.fromRGB(20,20,20); Instance.new("UIListLayout", listf); Instance.new("UICorner", listf)
            btn.MouseButton1Click:Connect(function() listf.Visible = not listf.Visible; listf.Size = listf.Visible and UDim2.new(1,-5,0,#list*35) or UDim2.new(1,-5,0,0) end)
            for _, v in pairs(list) do
                local item = Instance.new("TextButton", listf); item.Size = UDim2.new(1,0,0,35); item.BackgroundTransparency = 1; item.Text = v; item.TextColor3 = Color3.fromRGB(200,200,200)
                item.MouseButton1Click:Connect(function() btn.Text = "  "..Text.." : "..v; listf.Visible = false; listf.Size = UDim2.new(1,-5,0,0); cb(v) end)
            end
        end
        return Elements
    end
    return Tabs
end
return Library
