-- [[ Swift Hub UI Library (V2: Tab System) | Created by Pai for Zemon ]] --
local Library = {}

function Library:CreateWindow(Settings)
    local WindowName = Settings.Name or "Swift Hub"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SwiftHubUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame (ปรับให้กว้างขึ้นเพื่อใส่แถบ Tab)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    MainFrame.Size = UDim2.new(0, 400, 0, 250)
    MainFrame.Active = true
    MainFrame.Draggable = true

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = MainFrame

    -- Sidebar (แถบเลือก Tab ด้านซ้าย)
    local SideBar = Instance.new("Frame")
    SideBar.Name = "SideBar"
    SideBar.Parent = MainFrame
    SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    SideBar.Size = UDim2.new(0, 100, 1, 0)
    
    local SideCorner = Instance.new("UICorner")
    SideCorner.CornerRadius = UDim.new(0, 12)
    SideCorner.Parent = SideBar

    -- Title Label
    local Title = Instance.new("TextLabel")
    Title.Parent = SideBar
    Title.Text = "Swift Hub"
    Title.TextColor3 = Color3.fromRGB(255, 105, 180) -- สีชมพูที่ซีม่อนชอบ
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = SideBar
    TabContainer.Position = UDim2.new(0, 5, 0, 45)
    TabContainer.Size = UDim2.new(1, -10, 1, -50)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContainer
    TabLayout.Padding = UDim.new(0, 5)

    -- Page Container (หน้าเมนูทางขวา)
    local PageContainer = Instance.new("Frame")
    PageContainer.Parent = MainFrame
    PageContainer.Position = UDim2.new(0, 105, 0, 10)
    PageContainer.Size = UDim2.new(1, -115, 1, -20)
    PageContainer.BackgroundTransparency = 1

    local Tabs = {}
    local FirstTab = true

    function Tabs:CreateTab(Name)
        local Page = Instance.new("ScrollingFrame")
        Page.Name = Name .. "Page"
        Page.Parent = PageContainer
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.Padding = UDim.new(0, 5)

        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabContainer
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.Text = Name
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 12
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.Parent = TabBtn

        -- ระบบสลับหน้า Tab
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PageContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(200, 200, 200) end
            end
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 105, 180)
        end)

        if FirstTab then
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 105, 180)
            FirstTab = false
        end

        -- ฟังก์ชันเพิ่มปุ่มในหน้า Tab
        local Elements = {}
        function Elements:CreateButton(Text, Callback)
            local Btn = Instance.new("TextButton")
            Btn.Parent = Page
            Btn.Size = UDim2.new(1, -5, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Btn.Text = Text
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 13
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
            Btn.MouseButton1Click:Connect(Callback)
        end
        return Elements
    end
    return Tabs
end

return Library
