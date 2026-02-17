-- [[ Swift Hub UI Library V8 (Icon Masters) | Created by Pai for Zemon ]] --
local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ระบบแมพไอคอน Lucide (ใช้ Image ID ที่แน่นอนเพื่อความชัวร์ค่ะซีม่อน)
local IconList = {
    ["sword"] = "rbxassetid://10723306472",
    ["settings"] = "rbxassetid://10734950309",
    ["user"] = "rbxassetid://10747383474",
    ["home"] = "rbxassetid://10734882772",
    ["equal-not"] = "rbxassetid://10734906040",
    ["expand"] = "rbxassetid://10747373176",
    ["octagon-x"] = "rbxassetid://10747383344",
    ["activity"] = "rbxassetid://10723303114"
}

function Library:CreateWindow(Settings)
    local WindowName = Settings.Name or "Swift Hub"
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "SwiftHubUI"
    ScreenGui.ResetOnSpawn = false

    -- [Floating Button] ปุ่มเปิด/ปิด
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

    -- Control Icons (มุมขวาบน) - แก้ไขให้ขึ้นแน่นอนค่ะ!
    local Controls = Instance.new("Frame", Header)
    Controls.Size = UDim2.new(0, 110, 1, 0); Controls.Position = UDim2.new(1, -115, 0, 0); Controls.BackgroundTransparency = 1
    local Layout = Instance.new("UIListLayout", Controls)
    Layout.FillDirection = Enum.FillDirection.Horizontal; Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right; Layout.VerticalAlignment = Enum.VerticalAlignment.Center; Layout.Padding = UDim.new(0, 12)

    local function AddTopBtn(iconName, cb)
        local b = Instance.new("ImageButton", Controls)
        b.Size = UDim2.new(0, 18, 0, 18); b.BackgroundTransparency = 1
        b.Image = IconList[iconName] or ""
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
    function Tabs:CreateTab(Name, IconName)
        local Page = Instance.new("ScrollingFrame", PageHolder)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        local TBtn = Instance.new("TextButton", SideBar)
        TBtn.Size = UDim2.new(1, -10, 0, 38); TBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        TBtn.Text = "      " .. Name; TBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
        TBtn.Font = Enum.Font.Gotham; TBtn.TextSize = 13; TBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TBtn)

        -- ไอคอนหน้าชื่อ Tab
        if IconName and IconList[IconName] then
            local TIcon = Instance.new("ImageLabel", TBtn)
            TIcon.Size = UDim2.new(0, 16, 0, 16); TIcon.Position = UDim2.new(0, 8, 0.5, -8)
            TIcon.BackgroundTransparency = 1; TIcon.Image = IconList[IconName]
            TIcon.ImageColor3 = Color3.fromRGB(160, 160, 160)
        end

        TBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PageHolder:GetChildren()) do v.Visible = false end
            for _, v in pairs(SideBar:GetChildren()) do 
                if v:IsA("TextButton") then 
                    v.TextColor3 = Color3.fromRGB(160, 160, 160)
                    if v:FindFirstChildOfClass("ImageLabel") then v:FindFirstChildOfClass("ImageLabel").ImageColor3 = Color3.fromRGB(160, 160, 160) end
                end 
            end
            Page.Visible = true; TBtn.TextColor3 = Color3.new(1,1,1)
            if TBtn:FindFirstChildOfClass("ImageLabel") then TBtn:FindFirstChildOfClass("ImageLabel").ImageColor3 = Color3.new(1,1,1) end
        end)
        
        if #SideBar:GetChildren() == 2 then Page.Visible = true; TBtn.TextColor3 = Color3.new(1,1,1) end

        local Elements = {}
        function Elements:CreateSection(Text)
            local s = Instance.new("TextLabel", Page); s.Size = UDim2.new(1, -5, 0, 30); s.BackgroundColor3 = Color3.fromRGB(25,25,25)
            s.Text = "  "..Text; s.TextColor3 = Color3.new(1,1,1); s.Font = Enum.Font.GothamBold; s.TextSize = 13; s.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", s)
        end
        -- (ฟังก์ชัน Button, Toggle, Slider, Dropdown ใส่ต่อจากตรงนี้ได้เลยค่ะ)
        return Elements
    end
    return Tabs
end
return Library
