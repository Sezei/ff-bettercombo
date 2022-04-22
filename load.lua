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

local prevcombo = 0

function updateCombo(combo)
    if prevcombo > 20 and combo < 20 then
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

    if combo >= 100 then
        funny.TextColor3 = Color3.new(1, 1, 0.7)
    else
        funny.TextColor3 = Color3.new(1, 1, 1)
    end
    funny.Text = combo
    funny.TextSize = 60
    tweenservice:Create(
        funny,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {
            TextSize = 50
        }
    ):Play()

    if combo % 50 == 0 then
        tween.TextTransparency = 0
        tween.TextSize = 60
        tween.Text = combo
        tweenservice:Create(
            tween,
            TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                TextSize = 100,
                TextTransparency = 1
            }
        ):Play()
    end
end

gameUi.Arrows.InfoBar:GetPropertyChangedSignal("Text"):Connect(
    function()
        local t = gameUi.Arrows.InfoBar.Text
        local tt = string.split(t, " ")
        if tt[10] then
            local num = string.gsub(tt[10], "%D", "")
            updateCombo(tonumber(num))
        else
            local num = string.gsub(tt[8], "%D", "")
            updateCombo(tonumber(num))
        end
    end
)

gameUi.Arrows.InfoBar:GetPropertyChangedSignal("Visible"):Connect(
    function()
        if gameUi.Arrows.InfoBar.Visible == false then
            funny.Visible = false
        end
    end
)
