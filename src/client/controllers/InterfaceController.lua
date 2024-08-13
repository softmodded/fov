local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local UI_FOLDER = ReplicatedStorage:WaitForChild("Interface")
local StarterGui = game:GetService("StarterGui")

local InterfaceController = Knit.CreateController { Name = "InterfaceController" }


function InterfaceController:KnitStart()
end


function InterfaceController:KnitInit()
    self:InitializeUI()
    self:HideChat()
end

function InterfaceController:HideChat()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
end

function InterfaceController:UpdateUI(stage)
    local stageFolder = self.gui:WaitForChild("states")
    for _, child in ipairs(stageFolder:GetChildren()) do
        child.Visible = false
    end

    local stageUi = stageFolder:WaitForChild(stage)
    stageUi.Visible = true

    local uiScriptFolder = Knit.Client:WaitForChild("interface")
    local stageScript = uiScriptFolder:WaitForChild(stage)
    if stageScript then
        local scr = require(stageScript)
        scr:Start()
    end

    if self.previousUi then
        local previousScript = uiScriptFolder:WaitForChild(self.previousUi)
        if previousScript then
            local scr = require(previousScript)
            scr:Destroy()
        end
    end

    self.previousUi = stage
end

function InterfaceController:InitializeUI()
    local mainUI = UI_FOLDER:WaitForChild("Main")
    local playerUi = mainUI:Clone()
    playerUi.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    playerUi.Enabled = true
    self.gui = playerUi
    print("UI initialized")
end

return InterfaceController