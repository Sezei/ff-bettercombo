-- lol

local tweenservice = game:GetService("TweenService")
local gameUi = game.Players.LocalPlayer.PlayerGui:FindFirstChild("GameUI")

local funny = Instance.new("TextLabel")
funny.AnchorPoint = Vector2.new(0.5, 0.5)
funny.Position = UDim2.fromScale(0.5, 0.5)
funny.Parent = gameUi
funny.BackgroundTransparency = 1
funny.TextColor3 = Color3.new(1, 1, 1)
funny.TextStrokeColor3 = Color3.new(0, 0, 0)
funny.TextStrokeTransparency = 0.5
funny.TextSize = 50
funny.Text = 0
funny.Font = Enum.Font.Arcade
funny.Visible = false
local tween = funny:Clone()
tween.Visible = true
tween.Parent = funny
tween.TextStrokeTransparency = 1
tween.TextTransparency = 1
local secondary = funny:Clone();
secondary.Visible = true
secondary.Parent = funny
secondary.Text = ""
secondary.Position = UDim2.new(0.5,0,0,40)
secondary.TextSize = 30

local prevcombo = 0
local event = game.ReplicatedStorage.RE;
local inNoMiss = false;

local function updateCombo(combo,acc,miss)
    if acc == "100.00%" then
        secondary.Text = "PFC"
    elseif inNoMiss then
        secondary.Text = "NO-MISS"
    elseif miss == 0 then
        secondary.Text = "FC"
    else
        secondary.Text = ""
    end
    
    if prevcombo >= 20 and combo < 20 then
        -- Combo Break
        tweenservice:Create(
            funny,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextColor3 = Color3.new(1, 0, 0)
            }
        ):Play()
        task.spawn(
            function()
                task.wait(0.3)
                tweenservice:Create(
                    funny,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {
                        TextTransparency = 1
                    }
                ):Play()
                task.wait(0.3)
                funny.Visible = false
                funny.TextTransparency = 0
            end
        )
    end
    prevcombo = combo
    
    if combo < 20 then
        return
    else
        funny.Visible = true
    end

    if combo >= 400 then
        funny.TextColor3 = Color3.new(1, 1, 0)
    elseif combo >= 300 then
        funny.TextColor3 = Color3.new(1, 1, 0.25)
    elseif combo >= 200 then
        funny.TextColor3 = Color3.new(1, 1, 0.5)
    elseif combo >= 100 then
        funny.TextColor3 = Color3.new(1, 1, 0.75)
    else
        funny.TextColor3 = Color3.new(1, 1, 1)
    end
    funny.Text = combo
    funny.TextSize = (combo >= 100 and 75 or 65)
    tweenservice:Create(
        funny,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            TextSize = 50
        }
    ):Play()

    if combo % 50 == 0 then
        tween.TextTransparency = 0
        tween.TextSize = 70
        tween.Text = combo
        tweenservice:Create(
            tween,
            TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextSize = 100,
                TextTransparency = 1
            }
        ):Play()
    end
end

local function SendPlay()
    inNoMiss = true;
    event:FireServer({"Server","StageManager","PlaySolo"},{});
end

gameUi.Arrows.InfoBar:GetPropertyChangedSignal("Text"):Connect(
    function()
        local t = gameUi.Arrows.InfoBar.Text
        local tt = string.split(t, " ")

        if tt[10] then
            local num = string.gsub(tt[10], "%D", "")
            updateCombo(tonumber(num),tt[2],tonumber(tt[5]))
        elseif tt[8] then
            local num = string.gsub(tt[8], "%D", "")
            updateCombo(tonumber(num),tt[2],tonumber(tt[5]))
        end
        
        if inNoMiss then
            if tonumber(tt[5]) and tonumber(tt[5]) >= 1 then
                game.Players.LocalPlayer.Character.Humanoid.Health = -100;
                inNoMiss = false;
            end
            if tt[10] then
                gameUi.Arrows.InfoBar.Text = tt[1].." "..tt[2].." | NO-MISS MODE "..(tt[10])
            end
        end
    end
)

gameUi.Arrows:GetPropertyChangedSignal("Visible"):Connect(
    function()
        if gameUi.Arrows.Visible == false then
            funny.Visible = false
            inNoMiss = false;
        end
    end
)

local c = gameUi.SongSelector.Frame.Body.Settings.Solo:Clone();
c.Parent = gameUi.SongSelector.Frame.Body.Settings
c.Name = "NoMiss"
c.SoloPlay.Text = "No-Miss";
c.SoloPlay.BackgroundColor3 = Color3.new(0.4,1,0.4);
c.SoloInfoLabel.Text = c.SoloInfoLabel.Text.." 1 MISS = DEATH!";
c.SoloPlay.MouseButton1Click:Connect(function()
    if not c.Visible and not gameUi.SongSelector.Frame.Body.Settings.Solo.SoloPlay.BackgroundColor3.R >= gameUi.SongSelector.Frame.Body.Settings.Solo.SoloPlay.BackgroundColor3.G then
        SendPlay()
    end
end)
c.Position = UDim2.new(0,500,0,0)
gameUi.SongSelector.Frame.Body.Settings.Solo:GetPropertyChangedSignal("Visible"):Connect(function() -- Don't let the people press the no-miss if it's not solo
    c.Visible = gameUi.SongSelector.Frame.Body.Settings.Solo.Visible;
)
