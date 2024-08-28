local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Iris.Types)

return function(parent: GuiObject)
    local Iris: Types.Iris = require(ReplicatedStorage.Iris)
    local Input = require(script.Parent.UserInputService)

    Input.SinkFrame.Parent = parent

    Iris.Internal._utility.UserInputService = Input
    Iris.UpdateGlobalConfig({
        UseScreenGUIs = false,
    })
    Iris.Internal._utility.GuiOffset = Input.SinkFrame.AbsolutePosition
    Iris.Internal._utility.MouseOffset = Input.SinkFrame.AbsolutePosition
    Input.SinkFrame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        Iris.Internal._utility.GuiOffset = Input.SinkFrame.AbsolutePosition
        Iris.Internal._utility.MouseOffset = Input.SinkFrame.AbsolutePosition
    end)

    Iris.Init(parent)

    -- Actual Iris code here:
    Iris:Connect(Iris.ShowDemoWindow)
    --[[Iris:Connect(function()
        Iris.Window({`Strategies X - {#shared.t}`})
            Iris.Text({"Version: 0.3.7"})
            for i,v in next, shared.t do
                Iris.Text({v})
            end
        Iris.End()
    end)]]

    return function()
        Iris.Shutdown()

        for _, connection in Input._connections do
            connection:Disconnect()
        end

        Input.SinkFrame:Destroy()
    end
end
