--[[
  Grow A Garden - Enhanced Visual Egg Pet Randomizer UI with Server-Like Labels
  Author: Renasaix (UI Redesign and Functional Enhancements)
  Note: This UI visually simulates egg pet randomization. It does not affect game mechanics.
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
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

local labelToggles = {
    showLabels = true,
    autoRandom = true
}

-- Create GUI
local gui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 100)
frame.Position = UDim2.new(1, -230, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true
frame.Parent = gui
frame.Name = "ControlFrame"
frame.ClipsDescendants = true
frame.Parent = gui

local function createToggle(name, state, position, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, -20, 0, 35)
    toggle.Position = UDim2.new(0, 10, 0, position)
    toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextScaled = true
    toggle.Text = name .. ": " .. (state and "ON" or "OFF")
    toggle.AutoButtonColor = false
    toggle.BackgroundTransparency = 0
    toggle.BorderSizePixel = 0
    toggle.Parent = frame

    toggle.MouseButton1Click:Connect(function()
        local newState = not state
        state = newState
        toggle.Text = name .. ": " .. (newState and "ON" or "OFF")
        callback(newState)
    end)
end

createToggle("Egg Labels", labelToggles.showLabels, 10, function(val)
    labelToggles.showLabels = val
end)

createToggle("Randomized Pets", labelToggles.autoRandom, 50, function(val)
    labelToggles.autoRandom = val
end)

-- Create Billboard labels above egg models
local function assignLabelToEgg(egg)
    local eggName = egg.Name
    local pets = eggs[eggName]
    if not pets then return end

    local label = Instance.new("BillboardGui")
    label.Name = "EggLabel"
    label.Size = UDim2.new(0, 200, 0, 50)
    label.StudsOffset = Vector3.new(0, 2, 0)
    label.AlwaysOnTop = true
    label.Adornee = egg
    label.Parent = egg

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.new(1, 1, 1)
    text.TextScaled = true
    text.Font = Enum.Font.Gotham
    text.Text = eggName .. " | " .. pets[math.random(1, #pets)]
    text.Parent = label
end

-- Loop through eggs in workspace
local function updateEggLabels()
    for _, egg in pairs(Workspace:GetDescendants()) do
        if eggs[egg.Name] and not egg:FindFirstChild("EggLabel") and labelToggles.showLabels then
            assignLabelToEgg(egg)
        elseif egg:FindFirstChild("EggLabel") and not labelToggles.showLabels then
            egg:FindFirstChild("EggLabel"):Destroy()
        elseif egg:FindFirstChild("EggLabel") and labelToggles.autoRandom then
            local label = egg:FindFirstChild("EggLabel")
            local text = label and label:FindFirstChildOfClass("TextLabel")
            if text then
                local pets = eggs[egg.Name]
                text.Text = egg.Name .. " | " .. pets[math.random(1, #pets)]
            end
        end
    end
end

-- Run update loop
spawn(function()
    while true do
        updateEggLabels()
        wait(5)
    end
end)

-- Show GUI last
gui.Parent = playerGui
