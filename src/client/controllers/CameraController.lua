local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local Camera = workspace.CurrentCamera
local CameraShaker = require(ReplicatedStorage.CameraShaker)
local RunService = game:GetService("RunService")
local CameraController = Knit.CreateController { Name = "CameraController" }
local Player = game.Players.LocalPlayer;
local Character = Player.Character or Player.CharacterAdded:Wait();
local Head = Character:WaitForChild("Head");


function CameraController:KnitStart()
    
end


local FPMaximumDistance = 0.6; -- For scalability, but keep it at 0.6 since it is the right distance.
local FirstPersonLocalTransparency = 0.8;
local ThirdPresonLocalTransparency = 0.8;
local lowestAngle = -45

local function SetCharacterLocalTransparency(transparency)
    for i,v in pairs(Character:GetChildren()) do
       if (v:IsA("BasePart")) then -- Only baseparts have a LocalTransparencyModifier property.
          v.LocalTransparencyModifier = transparency;
       end
    end
end


local function ShakeCamera(shakeCf)
	Camera.CFrame = Camera.CFrame * shakeCf
end

local renderPriority = Enum.RenderPriority.Camera.Value + 1
local camShake = CameraShaker.new(renderPriority, ShakeCamera)
camShake:Start()

function CameraController:KnitInit()
    -- lock the player in first person
    local player = game.Players.LocalPlayer
    player.CameraMaxZoomDistance = 0
    player.CameraMinZoomDistance = 0
    Camera.DiagonalFieldOfView = 140

    task.wait(1)
    self:StartBreathing()
    self:StartBobbing()

    RunService.RenderStepped:Connect(function()
        local isfirstperson = (Head.CFrame.Position - Camera.CFrame.Position).Magnitude < FPMaximumDistance; -- Determine wether we are in first person
        if (isfirstperson) then
           SetCharacterLocalTransparency(FirstPersonLocalTransparency);
        else
           SetCharacterLocalTransparency(ThirdPresonLocalTransparency);
        end

        Head.Transparency = 1;

        -- force the camera a little forward and a little up
        Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, -0.4) * CFrame.new(0, 0.4, 0)  	
        local _, _, _, m00, m01, m02, _, _, m12, _, _, m22 = Camera.CFrame:GetComponents()
        local x = math.atan2(math.max(-m12, math.rad(lowestAngle)), m22)
        Camera.CFrame = CFrame.new(Camera.CFrame.Position) * CFrame.Angles(x, math.asin(m02), math.atan2(-m01, m00))
     end)
end

function CameraController:StartBreathing()
	camShake:ShakeSustain(CameraShaker.Presets.HandheldCamera)
end

function CameraController:StopBreathing()
    camShake:StopSustained(0.5)
end

function CameraController:StartBobbing()
    local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
    RunService.RenderStepped:Connect(function()
        local CT = tick()
        if humanoid.MoveDirection.Magnitude > 0 then
            local BobbleX = math.cos(CT*10)*0.15
            local BobbleY = math.abs(math.sin(CT*10))*0.55
            local Bobble = Vector3.new(BobbleX,BobbleY,0)
            humanoid.CameraOffset = humanoid.CameraOffset:lerp(Bobble, 0.25)
        else
            humanoid.CameraOffset = humanoid.CameraOffset * 0.75
        end
    end)
end

return CameraController
