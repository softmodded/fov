local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Camera = workspace.CurrentCamera

local CameraController = Knit.CreateController { Name = "CameraController" }


function CameraController:KnitStart()
    
end


function CameraController:KnitInit()
    -- lock the player in first person
    local player = game.Players.LocalPlayer
    player.CameraMaxZoomDistance = 0
    player.CameraMinZoomDistance = 0
    Camera.DiagonalFieldOfView = 150

    task.wait(1)
    self:DoBreathing()
end

function CameraController:DoBreathing()
    local camera = workspace.CurrentCamera
    local player = game.Players.LocalPlayer
    local humanoid = player.Character:WaitForChild("Humanoid") 

    local function lerp(a, b, t)
        return a + (b - a) * t
    end

    local function breathing()
        local time = 0
        local amplitude = 0.25
        local frequency = 1
        local offset = 0

        while true do
            local dt = task.wait()
            time = time + dt
            offset = lerp(offset, math.sin(time * frequency) * amplitude, 0.1)
            humanoid.CameraOffset = Vector3.new(0, offset, 0)
        end
    end

    coroutine.wrap(breathing)()
end

return CameraController
