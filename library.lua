-- [[ Swift Hub UI Library (Mobile Edition) | Created by Pai for Zemon ]] --
local Library = {}

function Library:CreateWindow(Settings)
    local WindowName = Settings.Name or "Swift Hub"
    
    -- สร้าง ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SwiftHubUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame (ปรับขนาดให้พอดีมือถือ)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    MainFrame.Size = UDim2.new(0, 300, 0, 200)
    MainFrame.Active = true
    MainFrame.Draggable = true -- ให้ซีม่อนลากจอมือถือไปมาได้

    -- มุมโค้งมน (UICorner)
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = MainFrame

    -- หัวข้อ (Title)
    local Title = Instance.new("TextLabel")
    Title.Parent = MainFrame
    Title.Text = WindowName .. " | By Zemon"
    Title.TextColor3 = Color3.fromRGB(255, 105, 180) -- สีชมพูหวานๆ แบบปาย
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16

    -- Container สำหรับปุ่มต่างๆ
    local Container = Instance.new("ScrollingFrame")
    Container.Parent = MainFrame
    Container.Position = UDim2.new(0, 10, 0, 35)
    Container.Size = UDim2.new(1, -20, 1, -45)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 2

    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Container
    Layout.Padding = UDim.new(0, 5)

    -- ฟังชั่นเพิ่มปุ่ม (Button)
    local Elements = {}
    function Elements:CreateButton(Text, Callback)
        local Btn = Instance.new("TextButton")
        Btn.Parent = Container
        Btn.Size = UDim2.new(1, 0, 0, 35)
        Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Btn.Text = Text
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 14
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.Parent = Btn

        Btn.MouseButton1Click:Connect(function()
            Callback()
        end)
    end

    return Elements
end

return Library
