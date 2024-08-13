local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

local CharacterController = Knit.CreateController { Name = "CharacterController" }

local Keybinds = {
    ["Crouch"] = Enum.KeyCode.LeftControl,
    ["Sprint"] = Enum.KeyCode.LeftShift
}

local CameraTween = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

function CharacterController:KnitStart()
    
end


function CharacterController:KnitInit()
    self.CameraController = Knit.GetController("CameraController")
    self:KeybindHandler()
end


function CharacterController:KeybindHandler()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end

        if input.KeyCode == Keybinds.Crouch then
            self:Crouch()
        end

        if input.KeyCode == Keybinds.Sprint then
            self:StartSprinting()
        end
    end)

    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end

        if input.KeyCode == Keybinds.Crouch then
            self:Uncrouch()
        end

        if input.KeyCode == Keybinds.Sprint then
            self:StopSprinting()
        end
    end)
end

function CharacterController:Crouch()
    local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")

    self.originalCameraOffset = humanoid.CameraOffset

    local tween = TweenService:Create(humanoid, CameraTween, {CameraOffset = Vector3.new(0, -1, 0)})
    tween:Play()

    humanoid.WalkSpeed = 8
    humanoid.JumpPower = humanoid.JumpPower / 2
end

function CharacterController:Uncrouch()
    local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")

    local tween = TweenService:Create(humanoid, CameraTween, {CameraOffset = self.originalCameraOffset})
    tween:Play()

    humanoid.WalkSpeed = 16
    humanoid.JumpPower = humanoid.JumpPower * 2
end

function CharacterController:StartSprinting()
    local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = 24

    local tween = TweenService:Create(Camera, CameraTween, {DiagonalFieldOfView = 160})
    tween:Play()
end

function CharacterController:StopSprinting()
    local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = 16

    local tween = TweenService:Create(Camera, CameraTween, {DiagonalFieldOfView = 150})
    tween:Play()

end

return CharacterController
