-- This function runs to save the location and particle spawn upon hero killed
function GameMode:HeroKilled(hero, attacker, ability)
    if GameMode.pregameActive then
        if GameMode.pregameBuffer == false then
            Timers:CreateTimer({
                endTime = 1, -- respawn in 1 second
                callback = function()
                    --start the next round
                    GameMode:Restore(hero)
                end
            })
        end
    elseif GameMode.tiebreakerActive then
        --check if there is only one team remaining
        if GameMode:CheckWinningTeam() ~= 0 then
            local winningTeamNumber = GameMode:CheckWinningTeam()
            GameMode.roundActive = false
            GameMode.teams[winningTeamNumber].score = GameMode.teams[winningTeamNumber].score + 1
            GameRules:SetCustomVictoryMessage(string.format("%s wins!", GameMode.teamNames[winningTeamNumber]))
            --end game
            GameRules:SetGameWinner(winningTeamNumber)
            GameRules:SetSafeToLeave(true)
        end
    elseif GameMode.roundActive then
        print("[GameMode:HeroKilled] GameMode.roundActive")
        if GameMode:CheckWinningTeam() ~= 0 then
            print("[GameMode:HeroKilled] GameMode:CheckWinningTeam() ~= 0")
            local damageList = {}
            local damageRanking = {}
            --assign scores
            --one for most damage dealt
            --make a list of damage dealt for every team for the round
            for teamNumber = 6, 13 do
                if GameMode.teams[teamNumber] ~= nil then
                    local teamDamageDoneTotal = 0
                    local teamDamageDoneThisRound = 0
                    for playerID = 0, GameMode.maxNumPlayers do
                        if GameMode.teams[teamNumber][playerID] ~= nil then
                            local playerDamageDoneTotal = 0
                            local playerDamageDonePrev = 0 
                            local playerDamageDoneThisRound = 0
                            playerDamageDonePrev = GameMode.teams[teamNumber][playerID].totalDamageDealt
                            --calculate the damage dealt for every team against each other
                            --damage dealt for pregame
                            for victimTeamNumber = 6, 13 do
                                if GameMode.teams[victimTeamNumber] ~= nil then
                                    if victimTeamNumber == teamNumber then goto continue
                                    else
                                        for victimID = 0, GameMode.maxNumPlayers do
                                            if GameMode.teams[victimTeamNumber][victimID] ~= nil then
                                                playerDamageDoneTotal = playerDamageDoneTotal + PlayerResource:GetDamageDoneToHero(playerID, victimID)
                                            end
                                        end
                                    end
                                    ::continue::
                                end
                            end
                            --playerDamageDoneThisRound = playerDamageDoneTotal - playerDamageDonePrev
                            --assign playerDamageDoneTotal to GameMode.teams[teamNumber][playerID].totalDamageDealt
                            --add playerDamageDoneTotal to teamDamageDoneTotal
                            --add playerDamageDoneThisRound to teamDamageDoneThisRound
                            playerDamageDoneThisRound = playerDamageDoneTotal - playerDamageDonePrev
                            GameMode.teams[teamNumber][playerID].totalDamageDealt = playerDamageDoneTotal
                            teamDamageDoneTotal = teamDamageDoneTotal + playerDamageDoneTotal
                            teamDamageDoneThisRound = teamDamageDoneThisRound + playerDamageDoneThisRound
                        end
                    end    
                    --assign teamDamageDoneTotal to GameMode.teams[teamNumber].totalDamageDealt
                    GameMode.teams[teamNumber].totalDamageDealt = teamDamageDoneTotal
                    damageList[teamNumber] = teamDamageDoneThisRound
                end
            end
            
            function spairs(t, order)
                -- collect the keys
                local keys = {}
                for k in pairs(t) do keys[#keys+1] = k end
        
                -- if order function given, sort by it by passing the table and keys a and b
                -- otherwise just sort the keys 
                if order then
                    table.sort(keys, function(a,b) return order(t, a, b) end)
                else
                    table.sort(keys)
                end
        
                -- return the iterator function
                local i = 0
                return function()
                    i = i + 1
                    if keys[i] then
                        return keys[i], t[keys[i]]
                    end
                end
            end
            
            
            --save the top damage
            --if there's other entries with the same value, give them scores too
            -- this uses a custom sorting function ordering by damageDone, descending
            local rank = 1
            for k,v in spairs(damageList, function(t,a,b) return t[b] < t[a] end) do
                damageRanking[rank] = k 
                rank = rank + 1
            end
            local topDamage = damageList[damageRanking[1]]
            Notifications:BottomToAll({text="Most damage dealt: ", duration= 5.0, style={["font-size"] = "35px", color = "white"}})
            local firstLine = true
            for teamNumber = 6, 13 do
                if GameMode.teams[teamNumber] ~= nil then
                    if damageList[teamNumber] == topDamage then
                        GameMode.teams[teamNumber].score = GameMode.teams[teamNumber].score + 1
                        Notifications:BottomToAll({text=string.format("%s, ", GameMode.teamNames[teamNumber]), duration= 5.0, style={["font-size"] = "35px", color = "red"}, continue = not firstLine})
                        Notifications:BottomToAll({text=string.format("total: %s ", GameMode.teams[teamNumber].score), duration= 5.0, style={["font-size"] = "35px", color = "white"}, continue = true})
                        firstLine = false
                    end
                end
            end




            --one for most kills
            local killsList = {}
            local killsRanking = {}
            for teamNumber = 6, 13 do
                if GameMode.teams[teamNumber] ~= nil then
                    local teamKillsTotal = 0
                    local teamKillsThisRound = 0
                    for playerID  = 0, GameMode.maxNumPlayers do
                        if GameMode.teams[teamNumber][playerID] ~= nil then
                            local playerKillsTotal = 0
                            local playerKillsPrev = 0 
                            local playerKillsThisRound = 0
                            playerKillsPrev = GameMode.teams[teamNumber][playerID].totalKills
                            --playerDamageDoneThisRound = playerDamageDoneTotal - playerDamageDonePrev
                            --assign playerDamageDoneTotal to GameMode.teams[teamNumber][playerID].totalDamageDealt
                            --add playerDamageDoneTotal to teamDamageDoneTotal
                            --add playerDamageDoneThisRound to teamDamageDoneThisRound
                            playerKillsThisRound = PlayerResource:GetKills(playerID) - playerKillsPrev
                            GameMode.teams[teamNumber][playerID].totalKills = PlayerResource:GetKills(playerID)
                            teamKillsTotal = teamKillsTotal + PlayerResource:GetKills(playerID)
                            teamKillsThisRound = teamKillsThisRound + playerKillsThisRound
                        end
                    end
                    --assign teamDamageDoneTotal to GameMode.teams[teamNumber].totalDamageDealt
                    GameMode.teams[teamNumber].totalKills = teamKillsTotal
                    killsList[teamNumber] = teamKillsThisRound
                end
            end

            -- this uses a custom sorting function ordering by kills, descending
            local rank = 1
            for k,v in spairs(killsList, function(t,a,b) return t[b] < t[a] end) do
                killsRanking[rank] = k 
                rank = rank + 1
            end
            local topKills = killsList[killsRanking[1]]
            Notifications:BottomToAll({text="Most kills: ", duration= 5.0, style={["font-size"] = "35px", color = "white"}})
            firstLine = true
            for teamNumber = 6, 13 do
                if GameMode.teams[teamNumber] ~= nil then
                    if killsList[teamNumber] == topKills then
                        GameMode.teams[teamNumber].score = GameMode.teams[teamNumber].score + 1
                        Notifications:BottomToAll({text=string.format("%s, ", GameMode.teamNames[teamNumber]), duration= 5.0, style={["font-size"] = "35px", color = "red"}, continue = not firstLine})
                        Notifications:BottomToAll({text=string.format("total: %s ", GameMode.teams[teamNumber].score), duration= 5.0, style={["font-size"] = "35px", color = "white"}, continue = true})
                        firstLine = false
                    end
                end
            end



            --one for being the last team standing
            GameMode.roundActive = false
            local remainingTeamNumber = GameMode:CheckWinningTeam()
            GameMode.teams[remainingTeamNumber].score = GameMode.teams[remainingTeamNumber].score + 1
            Notifications:BottomToAll({text="Last Team Standing: ", duration= 5.0, style={["font-size"] = "35px", color = "white"}})
            Notifications:BottomToAll({text=string.format("%s, ", GameMode.teamNames[remainingTeamNumber]), duration= 5.0, style={["font-size"] = "35px", color = "red"}})
            Notifications:BottomToAll({text=string.format("total: %s", GameMode.teams[remainingTeamNumber].score), duration= 5.0, style={["font-size"] = "35px", color = "white"}, continue = true})

            local winners = {}
            local numWinners = 0
            for teamNumber = 6, 13 do
                if GameMode.teams[teamNumber] ~= nil then
                    if GameMode.teams[teamNumber].score >= GameMode.pointsToWin then
                        winners[teamNumber] = GameMode.teams[teamNumber]
                        numWinners = numWinners + 1
                    end
                end
            end

            --[[for teamNumber = 6, 13 do
                if GameMode.teams[teamNumber] ~= nil then
                    for playerID  = 0, 7 do
                        if GameMode.teams[teamNumber][playerID] ~= nil then
                            GameMode.teams[teamNumber][playerID].hero:AddParticle(ACT_DOTA_TAUNT)
                        end
                    end
                end
            end]]

            --tiebreaker
            if numWinners > 1 then
                Notifications:BottomToAll({text="There's a tie!", duration= 5.0, style={["font-size"] = "45px", color = "red"}})
                for playerID = 0, GameMode.maxNumPlayers do
                    if PlayerResource:IsValidPlayerID(playerID) then
                      heroEntity = PlayerResource:GetSelectedHeroEntity(playerID)
                      heroEntity:ForceKill(true)
                    end
                end

                --GameMode.numTeams = numWinners
                --delay 5 seconds
                GameMode.tiebreakerActive = true
                Timers:CreateTimer({
                    endTime = 5, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
                    callback = function()
                        --start the next round
                        GameMode:RoundStart(winners)
                    end
                })
            --one winner
            elseif numWinners == 1 then
                for teamNumber = 6, 13 do
                    if winners[teamNumber] ~= nil then
                        GameRules:SetCustomVictoryMessage(string.format("%s wins!", GameMode.teamNames[teamNumber]))
                        --end game
                        GameRules:SetGameWinner(teamNumber)
                        GameRules:SetSafeToLeave(true)
                    end
                end
            --no winners
            else
                --delay 5 seconds
                Timers:CreateTimer({
                    endTime = 5, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
                    callback = function()
                        --start the next round
                        GameMode:RoundStart(GameMode.teams)
                    end
                })
            end
        end
    end
    -- A timer running every second that starts 5 seconds in the future, respects pauses
    -- if hero:HasAbility("true_sight") then
    --     print("[GameMode:HeroKilled] this hero has true_sight")
    -- else
    --     print("[GameMode:HeroKilled] this hero does not have true_sight")
    -- end

    --check if all of the hero's teammates are dead
    local teammateAlive = false
    for playerID = 0, GameMode.maxNumPlayers do
        if GameMode.teams[hero:GetTeamNumber()][playerID] ~= nil then
            if GameMode.teams[hero:GetTeamNumber()][playerID].hero:IsAlive() then
                teammateAlive = true
            end
        end
    end


    --reset true_sight if everyone's dead
    Timers:CreateTimer({
                callback = function()
                    if teammateAlive then
                        
                    else
                        for playerID = 0, GameMode.maxNumPlayers do
                            if GameMode.teams[hero:GetTeamNumber()][playerID] ~= nil then
                                print("[GameMode:HeroKilled] 1, about to add true_sight")
                                GameMode.teams[hero:GetTeamNumber()][playerID].hero:AddAbility("true_sight")
                            end
                        end
                    end
                end
    })

    Timers:CreateTimer(0, function()
        --check if the hero is alive because this process will continue indefinitely unless stopped
        if hero:IsAlive() == false then
        --[[local teammateAlive = false
        if hero:IsAlive() == false then
            for playerID = 0, GameMode.maxNumPlayers do
                if GameMode.teams[hero:GetTeamNumber()][playerID] ~= nil then
                    if GameMode.teams[hero:GetTeamNumber()][playerID].hero:IsAlive() then
                        teammateAlive = true
                    end
                end
            end]]
            if teammateAlive then
                return nil
            else
                local centerVectorEnt = Entities:FindByName(nil, "island_center")
                local centerVector = centerVectorEnt:GetAbsOrigin()
                hero:SetAbsOrigin(centerVector)
                AddFOWViewer(hero:GetTeamNumber(), hero:GetAbsOrigin(), 10000, 1, false )
                --[[for playerID = 0, GameMode.maxNumPlayers do
                    if GameMode.teams[hero:GetTeamNumber()][playerID] ~= nil then
                        print("[GameMode:HeroKilled] about to add true_sight")
                        GameMode.teams[hero:GetTeamNumber()][playerID].hero:AddAbility("true_sight")
                    end
                end]]
                return 1.0
            end
        end
    end)
end