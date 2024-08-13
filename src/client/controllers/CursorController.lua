local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local UserInputService = game:GetService("UserInputService")
local mouse = game.Players.LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")

local CursorController = Knit.CreateController { Name = "CursorController" }

local ColorTween = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
local SizeTween = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)


function CursorController:KnitStart()
    
end


function CursorController:KnitInit()
    self.events = {}
    self:Enable()
end

function CursorController:Enable()
    self:CreateMouse()
    self:CheckForItemsInFrontOfMouse()
    self:HandlePressing()
end

function CursorController:Disable()
    self.mouse:Destroy()
    self.mouse = nil

    for _, event in ipairs(self.events) do
        event:Disconnect()
    end
end

function CursorController:CreateMouse()
    -- hide the mouse icon and replace it with a custom one
    UserInputService.MouseIconEnabled = false

    -- create a frame to house the custom mouse icon
    local mouseFrame = Instance.new("Frame")
    mouseFrame.Name = "MouseFrame"
    mouseFrame.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main")
    mouseFrame.BackgroundTransparency = 1
    mouseFrame.Size = UDim2.new(1, 0, 1, 0)
    mouseFrame.ZIndex = 10

    -- create a custom mouse icon
    local mouseIcon = Instance.new("ImageLabel")
    mouseIcon.Name = "MouseIcon"
    mouseIcon.Parent = mouseFrame
    mouseIcon.BackgroundTransparency = 1
    mouseIcon.Size = UDim2.new(0, 6, 0, 6)
    mouseIcon.Image = "http://www.roblox.com/asset/?id=18935538766"
    -- put the mouse icon in the center of the screen
    mouseIcon.Position = UDim2.new(0.5, -16, 0.5, -16)

    self.mouse = mouseIcon
end

function CursorController:CheckForItemsInFrontOfMouse()
    local caster = RunService.RenderStepped:Connect(function()
        local ray = workspace.CurrentCamera:ScreenPointToRay(mouse.X, mouse.Y)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Include
        params.FilterDescendantsInstances = {CollectionService:GetTagged("Interactive")}
        local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
        if result then
            local tween = TweenService:Create(self.mouse, ColorTween, {ImageColor3 = Color3.new(0, 0, 0)})
            tween:Play()
        else
            local tween = TweenService:Create(self.mouse, ColorTween, {ImageColor3 = Color3.new(1, 1, 1)})
            tween:Play()
        end
    end)

    table.insert(self.events, caster)
end

function CursorController:HandlePressing()
    local mousedown = mouse.Button1Down:Connect(function()
        local tween = TweenService:Create(self.mouse, SizeTween, {Size = UDim2.new(0, 5, 0, 5)})
        tween:Play()
    end)

    local mouseup = mouse.Button1Up:Connect(function()
        local tween = TweenService:Create(self.mouse, SizeTween, {Size = UDim2.new(0, 6, 0, 6)})
        tween:Play()
    end)

    table.insert(self.events, mousedown)
    table.insert(self.events, mouseup)
end


return CursorController
