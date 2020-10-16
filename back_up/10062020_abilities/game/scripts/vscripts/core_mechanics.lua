--block that loops through every player in the game
--[[for teamNumber = 6, 13 do
    if GameMode.teams[teamNumber] ~= nil then
        for playerID  = 0, GameMode.maxNumPlayers do
            if GameMode.teams[teamNumber][playerID] ~= nil then
                --do something
            end
        end
    end
end]]

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

-- This function runs to save the location and particle spawn upon hero killed
function GameMode:HeroKilled(hero, attacker, ability)
    --killing spree announcer
    --first blood
    --spree
    --multiple
    --ownage
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
        print("[GameMode:HeroKilled] GameMode.type == 'deathMatch'")
        --check if cookie off is active
        if GameMode.cookieOffActive then
            print("[GameMode:HeroKilled] GameMode.cookieOffActive")
            ---------------------------------------------------------------------------------------------------------------
            ----------------------------------------for top and bottom teams-----------------------------------------------
            ---------------------------------------------------------------------------------------------------------------
            --countdown
            --display "winner!" on winners of bets
            --apply buff
            --place bets for 10 seconds when "cookie off!" is announced
            --make stun longer
            --return players to their previous positions upon end

            --if someone from the top team died, check if top team is alive
            --else, check if bottom team is alive
            --[[if hero:GetTeamNumber() == GameMode.cookieOffTopTeamNum then
                local topTeamAlive = false
                for playerID = 0, GameMode.maxNumPlayers do
                    if GameMode.teams[GameMode.cookieOffTopTeamNum][playerID] ~= nil then
                        if GameMode.teams[GameMode.cookieOffTopTeamNum][playerID].hero:IsAlive() then
                            topTeamAlive = true
                        end
                    end
                end
                if not topTeamAlive then
                    GameMode.cookieOffActive = false

                    --announce bottom team won
                    Notifications:BottomToAll({text=string.format("%s won!", GameMode.teamNames[GameMode.cookieOffBottomTeamNum]), duration= 5.0, style={["font-size"] = "45px", color = "white"}})
                    --display "winner!" on players who won the bet
                    --apply buff
                    for playerID = 0, GameMode.maxNumPlayers do
                        if GameMode.teams[GameMode.cookieOffBottomTeamNum][playerID] ~= nil then
                            Timers:CreateTimer({
                                endTime = 4, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
                                callback = function()
                                    GameMode.teams[GameMode.cookieOffBottomTeamNum][playerID].hero:SetBaseHealthRegen(30)
                                end
                              })
                            
                            Timers:CreateTimer({
                                endTime = 14, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
                                callback = function()
                                    GameMode.teams[GameMode.cookieOffBottomTeamNum][playerID].hero:SetBaseHealthRegen(0)
                                end
                              })
                        end
                    end
                    --return to the arena
                    --restore health to the previous amount
                    --stun for 5 seconds
                    --countdown
                    --enable hero respawn
                    Timers:CreateTimer({
                        endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
                        callback = function()
                            GameMode:CountDown()
                            for teamNumber = 6, 13 do
                                if GameMode.teams[teamNumber] ~= nil then
                                    for playerID  = 0, GameMode.maxNumPlayers do
                                        if GameMode.teams[teamNumber][playerID] ~= nil then
                                            GameMode.teams[teamNumber][playerID].hero:ForceKill(false)
                                            GameMode:Restore(GameMode.teams[teamNumber][playerID].hero)
                                            GameMode:RemoveAllAbilities(GameMode.teams[teamNumber][playerID].hero)
                                            GameMode:AddAllRegularAbilities(GameMode.teams[teamNumber][playerID].hero)
                                            GameMode.teams[teamNumber][playerID].hero:AddNewModifier(nil, nil, "modifier_stunned", { duration = 4})
                                            if GameMode.teams[teamNumber][playerID].health == 0 then
                                                --skip
                                            else
                                                --reset health and previous position
                                                GameMode.teams[teamNumber][playerID].hero:SetHealth(GameMode.teams[teamNumber][playerID].health)
                                                GameMode.teams[teamNumber][playerID].hero:SetAbsOrigin(GameMode.teams[teamNumber][playerID].previousPosition)
                                            end
                                            
                                            Timers:CreateTimer({
                                                --a second before the stuns end
                                                endTime = 3, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
                                                callback = function()
                                                    GameRules:SetHeroRespawnEnabled( true )
                                                end
                                            })
                                        end
                                    end
                                end
                            end
                        end
                    })
                else
                    --skip
                end
            elseif hero:GetTeamNumber() == GameMode.cookieOffBottomTeamNum then
                local bottomTeamAlive = false
                for playerID = 0, GameMode.maxNumPlayers do
                    if GameMode.teams[GameMode.cookieOffBottomTeamNum][playerID] ~= nil then
                        if GameMode.teams[GameMode.cookieOffBottomTeamNum][playerID].hero:IsAlive() then
                            bottomTeamAlive = true
                        end
                    end
                end
                if not bottomTeamAlive then
                    GameMode.cookieOffActive = false

                    --announce top team won
                    Notifications:BottomToAll({text=string.format("%s won!", GameMode.teamNames[GameMode.cookieOffTopTeamNum]), duration= 5.0, style={["font-size"] = "45px", color = "white"}})
                    --display "winner!" on players who won the bet
                    --don't apply buff
                    --reset cookieOffTop & BottomTeamNum
                    Timers:CreateTimer({
                        endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
                        callback = function()
                            GameMode:CountDown()
                            for teamNumber = 6, 13 do
                                if GameMode.teams[teamNumber] ~= nil then
                                    for playerID  = 0, GameMode.maxNumPlayers do
                                        if GameMode.teams[teamNumber][playerID] ~= nil then
                                            GameMode.teams[teamNumber][playerID].hero:ForceKill(false)
                                            GameMode:Restore(GameMode.teams[teamNumber][playerID].hero)
                                            GameMode:RemoveAllAbilities(GameMode.teams[teamNumber][playerID].hero)
                                            GameMode:AddAllRegularAbilities(GameMode.teams[teamNumber][playerID].hero)
                                            GameMode.teams[teamNumber][playerID].hero:AddNewModifier(nil, nil, "modifier_stunned", { duration = 4})
                                            if GameMode.teams[teamNumber][playerID].health == 0 then
                                                --skip
                                            else
                                                --reset health and previous position
                                                GameMode.teams[teamNumber][playerID].hero:SetHealth(GameMode.teams[teamNumber][playerID].health)
                                                GameMode.teams[teamNumber][playerID].hero:SetAbsOrigin(GameMode.teams[teamNumber][playerID].previousPosition)
                                            end
                                            
                                            Timers:CreateTimer({
                                                --a second before the stuns end
                                                endTime = 3, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
                                                callback = function()
                                                    GameRules:SetHeroRespawnEnabled( true )
                                                end
                                            })
                                        end
                                    end
                                end
                            end
                        end
                    })
                    GameMode.cookieOffTopTeamNum = nil
                    GameMode.cookieOffBottomTeamNum = nil
                else
                    --skip
                end
            end]]
            ---------------------------------------------------------------------------------------------------------------
            ----------------------------------------for all teams-----------------------------------------------
            ---------------------------------------------------------------------------------------------------------------
            --kill everybody
            --move them
            --respawn them

            --cookie off
            --heroes killed in the set up
            --winner declared and players reset
            
            if GameMode:CheckWinningTeam() ~= 0 then
                EmitGlobalSound("duel_end")
                local winningTeamNum = GameMode:CheckWinningTeam()
                Notifications:BottomToAll({text=string.format("%s wins!", GameMode.teamNames[GameMode:CheckWinningTeam()]), duration= 5.0, style={["font-size"] = "45px", color = "white"}})
                for playerID  = 0, GameMode.maxNumPlayers do
                    if GameMode.teams[winningTeamNum][playerID] ~= nil then
                      Notifications:Bottom(playerID, {text="Check your inventory", duration= 5.0, style={["font-size"] = "45px"}})
                    end
                end
                GameMode.cookieOffActive = false
                Timers:CreateTimer({
                    endTime = 0.1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
                    callback = function()
                        GameMode:CountDown()
                        for teamNumber = 6, 13 do
                            if GameMode.teams[teamNumber] ~= nil then
                                for playerID  = 0, GameMode.maxNumPlayers do
                                    if GameMode.teams[teamNumber][playerID] ~= nil then
                                        GameMode.teams[teamNumber][playerID].hero:ForceKill(false)
                                        GameMode:Restore(GameMode.teams[teamNumber][playerID].hero)
                                        GameMode:RemoveAllAbilities(GameMode.teams[teamNumber][playerID].hero)
                                        GameMode:AddAllRegularAbilities(GameMode.teams[teamNumber][playerID].hero)
                                        GameMode.teams[teamNumber][playerID].hero:AddNewModifier(nil, nil, "modifier_stunned", { duration = 4})
                                        --GameMode.teams[teamNumber][playerID].hero:AddNewModifier(nil, nil, "modifier_invulnerable", { duration = 4})
                                        --restore to previous position (random for player that died)
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
                    end
                })
                --apply buff
                for playerID = 0, GameMode.maxNumPlayers do
                    if GameMode.teams[winningTeamNum][playerID] ~= nil then
                        local item = CreateItem("item_cheese", GameMode.teams[winningTeamNum][playerID].hero, GameMode.teams[winningTeamNum][playerID].hero)
                        GameMode.teams[winningTeamNum][playerID].hero:AddItem(item)
                    end
                end
            end



        --handle button mash
        --no one dies in that mode so there's no need to do this
        --elseif GameMode.buttonMashActive then
            
        --when someone is dead, check if any of the teams reached the winning number of points
        --print("[GameMode:HeroKilled] in the GameMode.type == 'deathMatch' block")
        --if they did, set winner
        else
            --spawn randomly in the center
            print("[GameMode:HeroKilled] not GameMode.cookieOffActive")
            local respawnPosX = math.random() + math.random(-1323, 571)
            local respawnPosY = math.random() + math.random(-1011, 826)
            hero:SetRespawnPosition(Vector(respawnPosX, respawnPosY, 128))
            hero.previousPosition = Vector(respawnPosX, respawnPosY, 128)
            for teamNumber = 6, 13 do
                if GameMode.teams[teamNumber] ~= nil then 
                    if PlayerResource:GetTeamKills(teamNumber) == GameMode.pointsToWin then
                        GameRules:SetCustomVictoryMessage(string.format("%s wins!", GameMode.teamNames[teamNumber]))
                        --end game
                        GameRules:SetGameWinner(teamNumber)
                        GameRules:SetSafeToLeave(true)
                    --if they didn't, check for "wanted"
                    --cookie off
                    end
                end
            end
            --if cookie off is not in cooldown, check if it should be activated
            if not GameMode.specialGameCooldown then
                print("[GameMode:HeroKilled] not GameMode.specialGameCooldown")
                --get kills for top two teams
                --if their difference is 5 then
                --set the bigger one as "wanted"
                local killsList = {}
                local killsRanking = {}
                for teamNumber = 6, 13 do
                    if GameMode.teams[teamNumber] ~= nil then
                    killsList[teamNumber] = PlayerResource:GetTeamKills(teamNumber)
                    end
                end

                -- this uses a custom sorting function ordering by kills, descending
                local rank = 1
                for k,v in spairs(killsList, function(t,a,b) return t[b] < t[a] end) do
                    killsRanking[rank] = k 
                    rank = rank + 1
                end
                local topKills = killsList[killsRanking[1]]
                local secondTopKills = killsList[killsRanking[2]]
                local bottomKills = killsList[killsRanking[#killsRanking]]
                if topKills - secondTopKills >= 3 then
                    EmitGlobalSound('duel_start')
                    Notifications:BottomToAll({text="PARTY TIME!", duration= 5.0, style={["font-size"] = "45px", color = "white"}})
                    --set respawn disabled
                    --set up cookie off
                    --take the top team and the bottom team
                    --cookie off cooldown
                    --[[for teamNumber = 6, 13 do
                        if GameMode.teams[teamNumber] ~= nil then
                            if killsList[teamNumber] == topKills then
                                Notifications:BottomToAll({text=string.format("%s ", GameMode.teamNames[teamNumber]), duration= 5.0, style={["font-size"] = "45px", color = "red"}})
                                GameMode.cookieOffTopTeamNum = teamNumber
                            elseif killsList[teamNumber] == bottomKills then
                                Notifications:BottomToAll({text=string.format("vs. %s", GameMode.teamNames[teamNumber]), duration= 5.0, style={["font-size"] = "45px", color = "red"}, continue = true})
                                GameMode.cookieOffBottomTeamNum = teamNumber
                            end
                        end
                        if GameMode.cookieOffTopTeamNum and GameMode.cookieOffBottomTeamNum then break
                        end
                    end]]
                    --other teams play button mash
                    --second highest team vs. the rest
                    --second highest team is the monster
                    --the rest is the attacker
                    --attackers get buffed based on how much damage they deal
                    --only run once
                    GameMode:FreezePlayers()
                    for teamNumber = 6, 13 do
                        if GameMode.teams[teamNumber] ~= nil then
                            for playerID  = 0, GameMode.maxNumPlayers do
                                if GameMode.teams[teamNumber][playerID] ~= nil then
                                    GameMode.teams[teamNumber][playerID].hero:AddNewModifier(nil, nil, "modifier_invulnerable", { duration = 4})
                                end
                            end
                        end
                    end
                    GameRules:SetHeroRespawnEnabled( false )
                    --kill everybody
                    --[[for teamNumber = 6, 13 do
                        if GameMode.teams[teamNumber] ~= nil then
                            for playerID  = 0, GameMode.maxNumPlayers do
                                if GameMode.teams[teamNumber][playerID] ~= nil then
                                    GameMode.teams[teamNumber][playerID].hero:ForceKill(false)
                                end
                            end
                        end
                    end]]
                    Timers:CreateTimer({
                        endTime = 5, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
                        callback = function()
                            --for top and bottom teams
                            --GameMode:CookieOff(GameMode.cookieOffTopTeamNum, GameMode.cookieOffBottomTeamNum)
                            --for all teams
                            --random int, choose between cookie off and button mash
                            --GameMode.specialGame = math.random(4)
                            if GameMode.specialGame == 1 then
                                GameMode:CookieOffAll()
                                Notifications:BottomToAll({text="COOKIE OFF", duration= 5.0, style={["font-size"] = "45px", color = "white"}})
                                Notifications:BottomToAll({text="Feed your opponents a cookie, not your friends.", duration= 5.0, style={["font-size"] = "45px", color = "white"}})
                            elseif GameMode.specialGame==2 then
                                GameMode:ButtonMashAll()
                                Notifications:BottomToAll({text="SCATTERBLAST MASH", duration= 5.0, style={["font-size"] = "45px", color = "white"}})
                                Notifications:BottomToAll({text="QQQQQQQQ", duration= 5.0, style={["font-size"] = "45px", color = "white"}})
                            elseif GameMode.specialGame==3 then
                                GameMode:MazeAll()
                                Notifications:BottomToAll({text="MAZE", duration= 5.0, style={["font-size"] = "45px", color = "white"}})
                                Notifications:BottomToAll({text="Find and kill the golem", duration= 5.0, style={["font-size"] = "45px", color = "white"}})
                            else
                                GameMode:DashAll()
                                Notifications:BottomToAll({text="100M DASH", duration= 5.0, style={["font-size"] = "45px", color = "white"}})
                                Notifications:BottomToAll({text="MOVE MOVE MOVE!", duration= 5.0, style={["font-size"] = "45px", color = "white"}})
                            end
                            GameMode.specialGame = GameMode.specialGame + 1
                            if GameMode.specialGame == 5 then
                                GameMode.specialGame = 1
                            end
                            GameMode:CountDown()
                            --[[Timers:CreateTimer({
                                endTime = 1, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
                                callback = function()
                                    GameMode.cookieOffActive = true
                                end
                            })]]
                        end
                    })
                    GameMode.specialGameCooldown = true
                    --store players' positions and health
                    for teamNumber = 6, 13 do
                        if GameMode.teams[teamNumber] ~= nil then
                            for playerID  = 0, GameMode.maxNumPlayers do
                                if GameMode.teams[teamNumber][playerID] ~= nil then
                                    GameMode.teams[teamNumber][playerID].health = GameMode.teams[teamNumber][playerID].hero:GetHealth()
                                    GameMode.teams[teamNumber][playerID].previousPosition = GameMode.teams[teamNumber][playerID].hero:GetAbsOrigin()
                                end
                            end
                        end
                    end
                    Timers:CreateTimer({
                        endTime = 20, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
                        callback = function()
                            --depends on which game we're playing
                            GameMode.specialGameCooldown = false
                        end
                        })

                end
            end
        end
        



    elseif GameMode.type == "battleRoyale" then
        if GameMode.tiebreakerActive then
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
            --we have a last team standing
            if GameMode:CheckWinningTeam() ~= 0 then
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
                            GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_CUSTOM_1, 10)
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
end