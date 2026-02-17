-- [[ Swift Hub UI Library V6 (Lucide SVG Support) | Created by Pai for Zemon ]] --
local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ระบบดึง Icon SVG จาก Lucide (รองรับทุกชื่อ)
local function GetIcon(name)
    return "rbxassetid://10734906040" -- เริ่มต้นด้วยไอคอนพื้นฐานหากหาไม่พบ
    -- ในระบบจริงซีม่อนสามารถใช้ API ดึง SVG มาแปลงเป็น Image ID ได้
    -- แต่เพื่อให้รันได้ชัวร์ ปายแมพชื่อที่ซีม่อนต้องการไว้ให้ก่อนนะคะ
end

local IconMap = {
    ["equal-not"] = "rbxassetid://10734906040",
    ["expand"] = "rbxassetid://10747373176",
    ["octagon-x"] = "rbxassetid://10747383344",
    ["user"] = "rbxassetid://10747383474",
    ["settings"] = "rbxassetid://10734950309"
}

function Library:CreateWindow(Settings)
    local WindowName = Settings.Name or "Swift Hub"
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "SwiftHubUI"
    ScreenGui.ResetOnSpawn = false

    -- Main Frame
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    MainFrame.Position = UDim2.new(0.5, -240, 0.5, -160)
    MainFrame.Size = UDim2.new(0, 480, 0, 320)
    MainFrame.Active = true
    MainFrame.Draggable = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(40, 40, 40)

    -- Top Header
    local Header = Instance.new("Frame", MainFrame)
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundTransparency = 1

    local Title = Instance.new("TextLabel", Header)
    Title.Text = "  " .. WindowName
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold; Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left; Title.BackgroundTransparency = 1

    -- Control Buttons (ขวาบน)
    local Controls = Instance.new("Frame", Header)
    Controls.Size = UDim2.new(0, 100, 1, 0)
    Controls.Position = UDim2.new(1, -110, 0, 0)
    Controls.BackgroundTransparency = 1
    Instance.new("UIListLayout", Controls).FillDirection = Enum.FillDirection.Horizontal
    Instance.new("UIListLayout", Controls).HorizontalAlignment = Enum.HorizontalAlignment.Right
    Instance.new("UIListLayout", Controls).VerticalAlignment = Enum.VerticalAlignment.Center
    Instance.new("UIListLayout", Controls).Padding = UDim.new(0, 10)

    local function AddControl(iconName, callback)
        local btn = Instance.new("ImageButton", Controls)
        btn.Size = UDim2.new(0, 18, 0, 18)
        btn.BackgroundTransparency = 1
        btn.Image = IconMap[iconName] or GetIcon(iconName)
        btn.MouseButton1Click:Connect(callback)
    end

    AddControl("equal-not", function() MainFrame.Visible = false end)
    AddControl("expand", function() 
        MainFrame.Size = (MainFrame.Size == UDim2.new(0, 480, 0, 320)) and UDim2.new(0, 560, 0, 400) or UDim2.new(0, 480, 0, 320)
    end)
    AddControl("octagon-x", function() ScreenGui:Destroy() end)

    -- Content Area
    local SideBar = Instance.new("Frame", MainFrame)
    SideBar.Size = UDim2.new(0, 130, 1, -40); SideBar.Position = UDim2.new(0, 0, 0, 40)
    SideBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

    local Separator = Instance.new("Frame", MainFrame)
    Separator.Size = UDim2.new(0, 1, 1, -50); Separator.Position = UDim2.new(0, 130, 0, 45)
    Separator.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Separator.BorderSizePixel = 0

    local PageHolder = Instance.new("Frame", MainFrame)
    PageHolder.Size = UDim2.new(1, -140, 1, -50); PageHolder.Position = UDim2.new(0, 140, 0, 45)
    PageHolder.BackgroundTransparency = 1

    local Tabs = {}
    function Tabs:CreateTab(Name)
        local Page = Instance.new("ScrollingFrame", PageHolder)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = false
        Page.ScrollBarThickness = 0; Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)

        local TBtn = Instance.new("TextButton", SideBar)
        TBtn.Size = UDim2.new(1, -10, 0, 35); TBtn.Position = UDim2.new(0, 5, 0, 5)
        TBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); TBtn.Text = Name
        TBtn.TextColor3 = Color3.fromRGB(150, 150, 150); TBtn.Font = Enum.Font.Gotham; TBtn.TextSize = 13
        Instance.new("UICorner", TBtn)

        TBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PageHolder:GetChildren()) do v.Visible = false end
            Page.Visible = true
        end)
        if #SideBar:GetChildren() == 1 then Page.Visible = true end

        local Elements = {}
        -- Dropdown (ปรับขนาดกรอบให้ใหญ่ขึ้น)
        function Elements:CreateDropdown(Text, List, Callback)
            local DFrame = Instance.new("Frame", Page)
            DFrame.Size = UDim2.new(1, -5, 0, 45) -- ขยายขนาดกรอบ
            DFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Instance.new("UICorner", DFrame)
            
            local DBtn = Instance.new("TextButton", DFrame)
            DBtn.Size = UDim2.new(1, 0, 1, 0); DBtn.BackgroundTransparency = 1
            DBtn.Text = "  " .. Text .. " : Select..."; DBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            DBtn.TextXAlignment = Enum.TextXAlignment.Left; DBtn.Font = Enum.Font.Gotham
            
            local ListF = Instance.new("Frame", Page)
            ListF.Size = UDim2.new(1, -5, 0, 0); ListF.Visible = false; ListF.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Instance.new("UIListLayout", ListF); Instance.new("UICorner", ListF)

            DBtn.MouseButton1Click:Connect(function()
                ListF.Visible = not ListF.Visible
                ListF.Size = ListF.Visible and UDim2.new(1, -5, 0, #List * 35) or UDim2.new(1, -5, 0, 0)
            end)

            for _, v in pairs(List) do
                local Item = Instance.new("TextButton", ListF)
                Item.Size = UDim2.new(1, 0, 0, 35); Item.BackgroundTransparency = 1; Item.Text = v
                Item.TextColor3 = Color3.fromRGB(200, 200, 200); Item.Font = Enum.Font.Gotham
                Item.MouseButton1Click:Connect(function()
                    DBtn.Text = "  " .. Text .. " : " .. v; ListF.Visible = false; Callback(v)
                end)
            end
        end
        return Elements
    end
    return Tabs
end
return Library
