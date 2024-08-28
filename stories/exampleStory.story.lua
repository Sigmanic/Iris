local ReplicatedStorage = game:GetService("ReplicatedStorage")

return function(parent: GuiObject)
    local Iris = require(ReplicatedStorage.Iris)
    local Input = require(script.Parent.UserInputService)

    Input.SinkFrame.Parent = parent

    Iris.Internal._utility.UserInputService = Input
    Iris.UpdateGlobalConfig({
        UseScreenGUIs = false,
    })
    --[[_G.t = {
        [1] = "1",
        [2] = "2",
        [3] = "3",
    }]]

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
