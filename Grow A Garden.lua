--[[
  Grow A Garden - Enhanced Visual Egg Pet Randomizer UI
  Author: Renasaix (UI Redesign and Functional Enhancements)
  Note: This UI visually simulates egg pet randomization. It does not affect game mechanics.
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local eggs = {
    ["Common Egg"] = {"Dog", "Bunny", "Golden Lab"},
    ["Uncommon Egg"] = {"Black Bunny", "Chicken", "Cat", "Deer"},
    ["Rare Egg"] = {"Orange Tabby", "Spotted Deer", "Pig", "Monkey"},
    ["Legendary Egg"] = {"Cow", "Sea Otter", "Turtle", "Polar Bear"},
    ["Bug Egg"] = {"Snail", "Giant Ant", "Caterpillar", "Dragonfly"},
    ["Mythical Egg"] = {"Grey Mouse", "Brown Mouse", "Squirrel", "Red Giant Ant", "Red Fox"},
    ["Common Summer Egg"] = {"Starfish", "Seagull", "Crab"},
    ["Rare Summer Egg"] = {"Sea Turtle", "Toucan", "Flamingo", "Seal", "Orangutan"},
    ["Paradise Egg"] = {"Ostrich", "Peacock", "Capybara", "Scarlet Macaw", "Mimic Octopus"},
    ["Oasis Egg"] = {"Meerkat", "Sand Snake", "Axolotl", "Hyacinth Macaw", "Fennec Fox"},
}

local selectedEgg = "Bug Egg"
local autoRandomize = true
local autoStop = false
local countdown = 5

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "EggVisualizerUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Main Frame (Draggable)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 400)
frame.Position = UDim2.new(0.5, -175, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🥚 Egg Pet Visualizer 🐾"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = frame

-- Dropdown Egg Selector
local selector = Instance.new("TextButton")
selector.Size = UDim2.new(1, -20, 0, 30)
selector.Position = UDim2.new(0, 10, 0, 50)
selector.Text = "Select Egg: " .. selectedEgg
selector.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
selector.TextColor3 = Color3.new(1, 1, 1)
selector.Font = Enum.Font.GothamSemibold
selector.TextScaled = true
selector.Parent = frame

-- Egg Selection Menu
local menu = Instance.new("ScrollingFrame")
menu.Size = UDim2.new(1, -20, 0, 130)
menu.Position = UDim2.new(0, 10, 0, 90)
menu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
menu.ScrollBarThickness = 6
menu.CanvasSize = UDim2.new(0, 0, 0, 25 * #eggs)
menu.Parent = frame

local y = 0
for eggName, _ in pairs(eggs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 25)
    btn.Position = UDim2.new(0, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gothamtn.TextScaled = true
    btn.Text = eggName
    btn.Parent = menu
    btn.MouseButton1Click:Connect(function()
        selectedEgg = eggName
        selector.Text = "Select Egg: " .. selectedEgg
    end)
    y = y + 25
end

-- Pet Visual Output
local output = Instance.new("TextLabel")
output.Size = UDim2.new(1, -20, 0, 60)
output.Position = UDim2.new(0, 10, 0, 230)
output.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
output.TextColor3 = Color3.new(1, 1, 1)
output.Font = Enum.Font.GothamBold
output.TextScaled = true
output.Text = "Random Pet: ???"
output.Parent = frame

-- Controls
local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(0.48, -5, 0, 30)
autoBtn.Position = UDim2.new(0, 10, 0, 300)
autoBtn.Text = "Auto: ON"
autoBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
autoBtn.TextColor3 = Color3.new(1, 1, 1)
autoBtn.Font = Enum.Font.Gotham
autoBtn.TextScaled = true
autoBtn.Parent = frame
autoBtn.MouseButton1Click:Connect(function()
    autoRandomize = not autoRandomize
    autoBtn.Text = "Auto: " .. (autoRandomize and "ON" or "OFF")
end)

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.48, -5, 0, 30)
stopBtn.Position = UDim2.new(0.52, 0, 0, 300)
stopBtn.Text = "Auto Stop: OFF"
stopBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.Font = Enum.Font.Gotham
stopBtn.TextScaled = true
stopBtn.Parent = frame
stopBtn.MouseButton1Click:Connect(function()
    autoStop = not autoStop
    stopBtn.Text = "Auto Stop: " .. (autoStop and "ON" or "OFF")
end)

-- Countdown Timer (slider)
local countdownLabel = Instance.new("TextLabel")
countdownLabel.Size = UDim2.new(1, -20, 0, 25)
countdownLabel.Position = UDim2.new(0, 10, 0, 340)
countdownLabel.BackgroundTransparency = 1
countdownLabel.Text = "Timer: " .. countdown .. "s"
countdownLabel.TextColor3 = Color3.new(1, 1, 1)
countdownLabel.Font = Enum.Font.Gotham
countdownLabel.TextScaled = true
countdownLabel.Parent = frame

local countdownBtn = Instance.new("TextButton")
countdownBtn.Size = UDim2.new(1, -20, 0, 25)
countdownBtn.Position = UDim2.new(0, 10, 0, 370)
countdownBtn.Text = "Increase Timer (Current: ".. countdown .."s)"
countdownBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
countdownBtn.TextColor3 = Color3.new(1, 1, 1)
countdownBtn.Font = Enum.Font.Gotham
countdownBtn.TextScaled = true
countdownBtn.Parent = frame
countdownBtn.MouseButton1Click:Connect(function()
    countdown = countdown + 1
    countdownLabel.Text = "Timer: " .. countdown .. "s"
    countdownBtn.Text = "Increase Timer (Current: ".. countdown .."s)"
end)

-- Randomizer Loop
spawn(function()
    while true do
        if autoRandomize then
            local pets = eggs[selectedEgg] or {}
            if #pets > 0 then
                local randomPet = pets[math.random(1, #pets)]
                output.Text = "Random Pet: " .. randomPet
            else
                output.Text = "No pets for selected egg"
            end
            if autoStop then autoRandomize = false end
        end
        wait(countdown)
    end
end)
