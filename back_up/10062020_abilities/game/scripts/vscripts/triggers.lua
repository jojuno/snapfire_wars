function DashFinishTrigger(trigger)
    local ent = trigger.activator
    if not ent then return end
    --freeze players
    --announce winner
    --award chicken
    --return them to their health and position
    EmitGlobalSound("duel_end")
    GameMode:FreezePlayers()
    local winningTeamNum = ent:GetTeamNumber()
    Notifications:BottomToAll({text=string.format("%s wins!", GameMode.teamNames[winningTeamNum]), duration= 5.0, style={["font-size"] = "45px", color = "white"}})
    for playerID  = 0, GameMode.maxNumPlayers do
        if GameMode.teams[winningTeamNum][playerID] ~= nil then
          Notifications:Bottom(playerID, {text="Check your inventory", duration= 5.0, style={["font-size"] = "45px"}})
        end
    end
    GameMode.dashActive = false
    GameMode:CountDown()
    for teamNumber = 6, 13 do
        if GameMode.teams[teamNumber] ~= nil then
            for playerID  = 0, GameMode.maxNumPlayers do
                if GameMode.teams[teamNumber][playerID] ~= nil then
                    GameMode.teams[teamNumber][playerID].hero:ForceKill(false)
                    GameMode:Restore(GameMode.teams[teamNumber][playerID].hero)
                    GameMode:RemoveAllAbilities(GameMode.teams[teamNumber][playerID].hero)
                    GameMode:AddAllRegularAbilities(GameMode.teams[teamNumber][playerID].hero)
                    local item = CreateItem("item_ultimate_scepter", GameMode.teams[teamNumber][playerID].hero, GameMode.teams[teamNumber][playerID].hero)
                    GameMode.teams[teamNumber][playerID].hero:AddItem(item)
                    heroEntity:SetBaseMoveSpeed(400)
                    GameMode.teams[teamNumber][playerID].hero:AddNewModifier(nil, nil, "modifier_stunned", { duration = 4})
                    --GameMode.teams[teamNumber][playerID].hero:AddNewModifier(nil, nil, "modifier_invulnerable", { duration = 4})
                    --restore to previous position
                    GameMode.teams[teamNumber][playerID].hero:SetAbsOrigin(GameMode.teams[teamNumber][playerID].previousPosition)
                    if GameMode.teams[teamNumber][playerID].health == 0 then
                        --skip
                    else
                        --reset health
                        GameMode.teams[teamNumber][playerID].hero:SetHealth(GameMode.teams[teamNumber][playerID].health)
                    end
                    GameRules:SetHeroRespawnEnabled( true )
                    PlayerResource:SetCameraTarget(playerID, GameMode.teams[teamNumber][playerID].hero)
                    Timers:CreateTimer({
                        endTime = 0.5, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
                        callback = function()
                        PlayerResource:SetCameraTarget(playerID, nil)
                        end
                    })
                end
            end
        end
    end


    --give reward
    for playerID = 0, GameMode.maxNumPlayers do
        if GameMode.teams[winningTeamNum][playerID] ~= nil then
            Timers:CreateTimer({
                endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
                callback = function()
                    --GameMode.teams[winningTeamNum][playerID].hero:SetBaseHealthRegen(30)
                    local item = CreateItem("item_cheese", GameMode.teams[winningTeamNum][playerID].hero, GameMode.teams[winningTeamNum][playerID].hero)
                    GameMode.teams[winningTeamNum][playerID].hero:AddItem(item)
                end
            })
        end
    end
end
