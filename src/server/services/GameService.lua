local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local GameService = Knit.CreateService {
    Name = "GameService",
    Client = {},
}


function GameService:KnitStart()
    
end


function GameService:KnitInit()
    print("GameService initialized")
end


return GameService
