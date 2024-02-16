local Iris = require(script.Parent.Iris)
local Input = require(script.UserInputService)

-- Create the plugin toolbar, button and dockwidget for Iris to work in.
local widgetInfo: DockWidgetPluginGuiInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 200, 300)

local Toolbar: PluginToolbar = plugin:CreateToolbar("Iris")
local ToggleButton: PluginToolbarButton = Toolbar:CreateButton("Toggle Iris", "Toggle Iris running in a plugin window.", "rbxasset://textures/AnimationEditor/icon_checkmark.png")
local IrisWidget: DockWidgetPluginGui = plugin:CreateDockWidgetPluginGui("IrisWidget", widgetInfo)

-- defein the widget and button properties
IrisWidget.Name = "Iris"
IrisWidget.Title = "Iris"
IrisWidget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToggleButton.ClickableWhenViewportHidden = true

local IrisEnabled: boolean = false
Input.SinkFrame.Parent = IrisWidget

-- configure a few things within Iris. We need to provide our own UserInputService and change the config.
Iris.Internal._utility.UserInputService = Input
Iris.UpdateGlobalConfig({
    UseScreenGUIs = false,
})
Iris.Disabled = true

Iris.Init(IrisWidget)

-- We can start defining our code. This just uses the demo window and then forces it to be the same size
-- as the Plugin Widget. You don't have to do it this way.
Iris:Connect(function()
    local window = Iris.ShowDemoWindow()
    window.state.size:set(IrisWidget.AbsoluteSize)
    window.state.position:set(Vector2.zero)
end)

IrisWidget:BindToClose(function()
    IrisEnabled = false
    IrisWidget.Enabled = false
    Iris.Disabled = true
    ToggleButton:SetActive(false)
end)

ToggleButton.Click:Connect(function()
    IrisEnabled = not IrisEnabled
    IrisWidget.Enabled = IrisEnabled
    Iris.Disabled = not IrisEnabled
    ToggleButton:SetActive(IrisEnabled)
end)

-- This is quite important. We need to ensure Iris properly shutdowns and closes any connections.
plugin.Unloading:Connect(function()
    Iris.Shutdown()

    for _, connection in Input._connections do
        connection:Disconnect()
    end

    Input.SinkFrame:Destroy()

    IrisEnabled = false
    IrisWidget.Enabled = false
    Iris.Disabled = true
    ToggleButton:SetActive(false)
end)
