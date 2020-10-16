



-- This function runs to save the location and particle spawn upon hero killed
function GameMode:HeroKilled(hero, attacker, ability)

    if GameMode.pregameActive then
        if GameMode.pregameBuffer == false then
            Timers:CreateTimer({
                endTime = 1, -- respawn in 1 second
                callback = function()
                    GameMode:Restore(hero)
                end
            })
        end
    elseif GameMode.type == "deathMatch" then
        --when someone is dead, check if any of the teams reached the winning number of points
        print("[GameMode:HeroKilled] in the GameMode.type == 'deathMatch' block")
        --if they did, set winner
        local respawnPosX = math.random() + math.random(-1323, 571)
        local respawnPosY = math.random() + math.random(-1011, 826)
        hero:SetRespawnPosition(Vector(respawnPosX, respawnPosY, 128))
        --check if there's a winner
        for teamNumber = 6, 13 do
            if GameMode.teams[teamNumber] ~= nil then 
                if PlayerResource:GetTeamKills(teamNumber) == GameMode.pointsToWin then
                    GameRules:SetCustomVictoryMessage(string.format("%s wins!", GameMode.teamNames[teamNumber]))
                    --end game
                    GameRules:SetGameWinner(teamNumber)
                    GameRules:SetSafeToLeave(true)
                --if they didn't, check for "wanted"
                else

                    --get kills for top two teams
                    --if their difference is 5 then
                    --set the bigger one as "wanted"
                    --local killsList = {}
                    --local killsRanking = {}
                    --for teamNumber = 6, 13 do
                    --    if GameMode.teams[teamNumber] ~= nil then
                    --        killsList[teamNumber] = PlayerResource:GetTeamKills(teamNumber)
                    --    end
                    --end
    
                    -- this uses a custom sorting function ordering by kills, descending
                    --local rank = 1
                    --for k,v in spairs(killsList, function(t,a,b) return t[b] < t[a] end) do
                    --    killsRanking[rank] = k 
                    --    rank = rank + 1
                    --end
                    --local topKills = killsList[killsRanking[1]]
                    --local secondTopKills = killsList[killsRanking[2]]
                    --if topKills - secondTopKills == 5 then
                    --    print("[GameMode:HeroKilled] in the topKills - secondTopKills == 5 block")
                    --    EmitGlobalSound('django')
                    --    Notifications:BottomToAll({text="WANTED: ", duration= 10.0, style={["font-size"] = "45px", color = "white"}})
                    --    for teamNumber = 6, 13 do
                    --        if GameMode.teams[teamNumber] ~= nil then
                    --            if killsList[teamNumber] == topKills then
                    --                Notifications:BottomToAll({text=string.format("%s", GameMode.teamNames[teamNumber]), duration= 10.0, style={["font-size"] = "45px", color = "red"}, continue = true})
                    --            end
                    --        end
                    --    end
                    --end
                    --only run once
                    --break

                end
            end
        end
        



    elseif GameMode.type == "battleRoyale" then
        --[[if GameMode.tiebreakerActive then
            --check if there is only one team remaining
            if GameMode:CheckWinningTeam() ~= 0 then
                local winningTeamNumber = GameMode:CheckWinningTeam()
                GameMode.roundActive = false
                GameMode.teams[winningTeamNumber].score = GameMode.teams[winningTeamNumber].score + 1
                GameRules:SetCustomVictoryMessage(string.format("%s wins!", GameMode.teamNames[winningTeamNumber]))
                --end game
                GameRules:SetGameWinner(winningTeamNumber)
                GameRules:SetSafeToLeave(true)
            end]]
        if GameMode.roundActive then
            print("[GameMode:HeroKilled] GameMode.roundActive")
            --we have a last team standing
            if GameMode:CheckTeamsRemaining() ~= 0 then
                print("[GameMode:HeroKilled] not GameMode:CheckTeamsRemaining() == nil")
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
                
                
                
                
                --save the top damage
                --if there's other entries with the same value, give them scores too
                -- this uses a custom sorting function ordering by damageDone, descending
                local rank = 1
                for k,v in GameMode:spairs(damageList, function(t,a,b) return t[b] < t[a] end) do
                    damageRanking[rank] = k 
                    rank = rank + 1
                end
                local topDamage = damageList[damageRanking[1]]
                --Notifications:BottomToAll({text="Most damage dealt: ", duration= 5.0, style={["font-size"] = "35px", color = "white"}})
                local firstLine = true
                for teamNumber = 6, 13 do
                    if GameMode.teams[teamNumber] ~= nil then
                        if damageList[teamNumber] == topDamage then
                            --GameMode.teams[teamNumber].score = GameMode.teams[teamNumber].score + 1
                            --Notifications:BottomToAll({text=string.format("%s    ", GameMode.teamNames[teamNumber]), duration= 5.0, style={["font-size"] = "35px", color = "red"}, continue = not firstLine})
                            --Notifications:BottomToAll({text=string.format("total: %s ", GameMode.teams[teamNumber].score), duration= 5.0, style={["font-size"] = "35px", color = "white"}, continue = true})
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
                for k,v in GameMode:spairs(killsList, function(t,a,b) return t[b] < t[a] end) do
                    killsRanking[rank] = k 
                    rank = rank + 1
                end
                local topKills = killsList[killsRanking[1]]
                --Notifications:BottomToAll({text="Most kills: ", duration= 5.0, style={["font-size"] = "35px", color = "white"}})
                firstLine = true
                for teamNumber = 6, 13 do
                    if GameMode.teams[teamNumber] ~= nil then
                        if killsList[teamNumber] == topKills then
                            --GameMode.teams[teamNumber].score = GameMode.teams[teamNumber].score + 1
                            --Notifications:BottomToAll({text=string.format("%s    ", GameMode.teamNames[teamNumber]), duration= 5.0, style={["font-size"] = "35px", color = "red"}, continue = not firstLine})
                            --Notifications:BottomToAll({text=string.format("total: %s ", GameMode.teams[teamNumber].score), duration= 5.0, style={["font-size"] = "35px", color = "white"}, continue = true})
                            firstLine = false
                        end
                    end
                end



                --one for being the last team standing
                GameMode.roundActive = false
                local remainingTeamNumber = GameMode:CheckTeamsRemaining()
                GameMode.teams[remainingTeamNumber].score = GameMode.teams[remainingTeamNumber].score + 1
                --Notifications:BottomToAll({text="Last Team Standing: ", duration= 5.0, style={["font-size"] = "35px", color = "white"}})
                Notifications:BottomToAll({text="Winner: ", duration= 5.0, style={["font-size"] = "35px", color = "white"}})
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
                --[[if numWinners > 1 then
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
                    })]]
                --one winner
                if numWinners == 1 then
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
                    for teamNumber = 6, 13 do
                        if GameMode.teams[teamNumber] ~= nil then
                            local centerVectorEnt = Entities:FindByName(nil, "island_center")
                            local centerVector = centerVectorEnt:GetAbsOrigin()
                            AddFOWViewer(teamNumber, centerVector, 10000, 5, false )
                            --for i = 1, 4 do
                            if GameMode.teams[teamNumber].sentry ~= nil then
                                GameMode.teams[teamNumber].sentry:ForceKill(false)
                                GameMode.teams[teamNumber].sentry = nil
                            end
                            --end
                        end
                    end
                    --delay 5 seconds
                    GameMode:RemoveRunes()
                    Timers:CreateTimer({
                        endTime = 5, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
                        callback = function()
                            --start the next round
                            GameMode:RoundStart(GameMode.teams)

                        end
                    })
                end
            else
       


                --check if all of the hero's teammates are dead
                local teammateAlive = false
                for playerID = 0, GameMode.maxNumPlayers do
                    if GameMode.teams[hero:GetTeamNumber()][playerID] ~= nil then
                        if GameMode.teams[hero:GetTeamNumber()][playerID].hero:IsAlive() then
                            teammateAlive = true
                        end
                    end
                end

                --if teammate not alive, run a recurring timer that gives vision
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
                            AddFOWViewer(hero:GetTeamNumber(), centerVector, 10000, 1, false )
                            return 1.0
                        end
                    else
                        return nil
                    end
                end)

                --if teammate not alive, place sentry once
                if not teammateAlive then
                    GameMode.teams[hero:GetTeamNumber()].sentry = CreateUnitByName("npc_dota_sentry_wards", Vector(-234, -45, 128), true, hero, hero, hero:GetTeamNumber())
                    --wards are not invisible by default
                    GameMode.teams[hero:GetTeamNumber()].sentry:AddNewModifier(nil, nil, "modifier_invisible", {})
                    --for playerID = 0, GameMode.maxNumPlayers do
                        --if GameMode.teams[hero:GetTeamNumber()][playerID] ~= nil then
                            --print("[GameMode:HeroKilled] about to add true_sight")
                            --GameMode.teams[hero:GetTeamNumber()][playerID].hero:AddAbility("true_sight")
                            --print("[GameMode:HeroKilled] teammateAlive false")
                            --center
                            --local sentry_unit = CreateUnitByName("dummy", Vector(-234, -45, 128), true, hero, hero, hero:GetTeamNumber())
                            --GameMode.teams[hero:GetTeamNumber()].sentries[1] = CreateItem("item_ward_sentry", sentry_unit, sentry_unit)
                            
                            --print("[GameMode:OnHeroInGame] item: " .. tostring(item))
                            --sentry_unit:AddItem(GameMode.teams[hero:GetTeamNumber()].sentries[1])
                            --top left hill
                            --center.x = -1641
                            --center.y = 1162.5
                            --center.z = 384
                            --sentry_unit:SetCursorPosition(Vector(-1637, 1154, 384))
                            --GameMode.teams[hero:GetTeamNumber()].sentries[1]:OnSpellStart()
                            --[[print("[GameMode:HeroKilled] hero's additional owned units: ")
                            PrintTable(GameMode.teams[hero:GetTeamNumber()][playerID].hero:GetAdditionalOwnedUnits())
                            GameMode.teams[hero:GetTeamNumber()].sentries[2] = CreateItem("item_ward_sentry", sentry_unit, sentry_unit)
                            --print("[GameMode:OnHeroInGame] item: " .. tostring(item))
                            sentry_unit:AddItem(GameMode.teams[hero:GetTeamNumber()].sentries[2])
                            --top right hill
                            --center.x = 914
                            --center.y = 1158
                            --center.z = 384
                            sentry_unit:SetCursorPosition(Vector(914, 1158, 384))
                            GameMode.teams[hero:GetTeamNumber()].sentries[2]:OnSpellStart()
                            GameMode.teams[hero:GetTeamNumber()].sentries[3] = CreateItem("item_ward_sentry", sentry_unit, sentry_unit)
                            --print("[GameMode:OnHeroInGame] item: " .. tostring(item))
                            sentry_unit:AddItem(GameMode.teams[hero:GetTeamNumber()].sentries[3])
                            --bottom left hill
                            --center.x = -1643
                            --center.y = -1397
                            --center.z = 384
                            sentry_unit:SetCursorPosition(Vector(-1643,-1397, 384))
                            GameMode.teams[hero:GetTeamNumber()].sentries[3]:OnSpellStart()
                            GameMode.teams[hero:GetTeamNumber()].sentries[4] = CreateItem("item_ward_sentry", sentry_unit, sentry_unit)
                            --print("[GameMode:OnHeroInGame] item: " .. tostring(item))
                            sentry_unit:AddItem(GameMode.teams[hero:GetTeamNumber()].sentries[4])
                            --bottom right hill
                            --center.x = 909
                            --center.y = -1389
                            --center.z = 384
                            sentry_unit:SetCursorPosition(Vector(909, -1389, 384))
                            GameMode.teams[hero:GetTeamNumber()].sentries[4]:OnSpellStart()
                            sentry_unit:ForceKill(false)]]
                            --place wards on four hills
                            --increase range
                            --remove duration (attribute permanent)
                            --respawn every 10000 seconds
                            --kill wards when round finishes

                            --save sentry into table for team
                            --kill by table
                            --make dummy unit invulnerable
                        --end
                    --end
                end
            end
        end
    end
end

--when someone dies
--check if teammate is alive
--if not, give vision and true sight
--check if there is a winning team