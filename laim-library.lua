local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LaimLib = {}
LaimLib.__index = LaimLib

function LaimLib:New(config)
	local self = setmetatable({}, LaimLib)
	self.UI = Instance.new("ScreenGui", Players.LocalPlayer:WaitForChild("PlayerGui"))
	self.UI.Name = config.Name or "LaimLib"
	self.Tabs = {}

	-- Sidebar setup
	self.Sidebar = Instance.new("Frame", self.UI)
	self.Sidebar.Size = UDim2.new(0, 260, 1, 0)
	self.Sidebar.Position = UDim2.new(0, 0, 0, 0)
	self.Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	self.Sidebar.BorderSizePixel = 0
	Instance.new("UICorner", self.Sidebar).CornerRadius = UDim.new(0, 12)

	-- Title
	local title = Instance.new("TextLabel", self.Sidebar)
	title.Size = UDim2.new(1, 0, 0, 60)
	title.Text = config.Name or "⚙️ LAIM UI"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 22
	title.BackgroundTransparency = 1

	return self
end

function LaimLib:Tab(name)
	local tab = {}
	tab.Sections = {}

	local tabFrame = Instance.new("Frame", self.Sidebar)
	tabFrame.Size = UDim2.new(1, -20, 1, -80)
	tabFrame.Position = UDim2.new(0, 10, 0, 70)
	tabFrame.BackgroundTransparency = 1
	tab.Layout = Instance.new("UIListLayout", tabFrame)
	tab.Layout.Padding = UDim.new(0, 10)
	tab.Frame = tabFrame

	function tab:Section(name)
		local section = {}
		section.Items = {}

		local frame = Instance.new("Frame", tabFrame)
		frame.Size = UDim2.new(1, 0, 0, 200)
		frame.BackgroundTransparency = 1

		local label = Instance.new("TextLabel", frame)
		label.Size = UDim2.new(1, 0, 0, 25)
		label.Text = name or "Section"
		label.TextColor3 = Color3.new(1, 1, 1)
		label.Font = Enum.Font.GothamBold
		label.TextSize = 18
		label.BackgroundTransparency = 1
		label.TextXAlignment = Enum.TextXAlignment.Left

		local layout = Instance.new("UIListLayout", frame)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Padding = UDim.new(0, 8)

		frame.Size = UDim2.new(1, 0, 0, 250)

		-- TOGGLE
		function section:Toggle(text, default, flag, callback)
			local toggleFrame = Instance.new("Frame", frame)
			toggleFrame.Size = UDim2.new(1, -10, 0, 30)
			toggleFrame.BackgroundTransparency = 1

			local label = Instance.new("TextLabel", toggleFrame)
			label.Size = UDim2.new(0.7, 0, 1, 0)
			label.Text = text
			label.TextColor3 = Color3.new(1, 1, 1)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.Gotham
			label.TextSize = 16
			label.TextXAlignment = Enum.TextXAlignment.Left

			local button = Instance.new("TextButton", toggleFrame)
			button.Size = UDim2.new(0, 50, 0, 24)
			button.Position = UDim2.new(1, -60, 0.5, -12)
			button.Text = ""
			button.BackgroundColor3 = default and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(150, 150, 150)
			button.AutoButtonColor = false
			Instance.new("UICorner", button).CornerRadius = UDim.new(1, 0)

			local knob = Instance.new("Frame", button)
			knob.Size = UDim2.new(0, 20, 0, 20)
			knob.Position = default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
			knob.BackgroundColor3 = Color3.new(1, 1, 1)
			Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

			local state = default or false
			button.MouseButton1Click:Connect(function()
				state = not state
				TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(150, 150, 150)}):Play()
				TweenService:Create(knob, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}):Play()
				if callback then callback(state) end
			end)

			return {
				Set = function(_, val)
					state = val
					button.BackgroundColor3 = val and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(150, 150, 150)
					knob.Position = val and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
				end
			}
		end

		-- SLIDER
		function section:Slider(text, def, max, min, inc, flag, callback)
			local sliderFrame = Instance.new("Frame", frame)
			sliderFrame.Size = UDim2.new(1, -10, 0, 40)
			sliderFrame.BackgroundTransparency = 1

			local label = Instance.new("TextLabel", sliderFrame)
			label.Size = UDim2.new(1, 0, 0, 20)
			label.Text = text
			label.TextColor3 = Color3.new(1, 1, 1)
			label.Font = Enum.Font.Gotham
			label.TextSize = 16
			label.BackgroundTransparency = 1

			local slider = Instance.new("Frame", sliderFrame)
			slider.Position = UDim2.new(0, 0, 0, 24)
			slider.Size = UDim2.new(1, 0, 0, 6)
			slider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

			local fill = Instance.new("Frame", slider)
			fill.BackgroundColor3 = Color3.fromRGB(50, 200, 255)
			fill.Size = UDim2.new(0, 0, 1, 0)

			local knob = Instance.new("ImageButton", slider)
			knob.Size = UDim2.new(0, 12, 0, 12)
			knob.AnchorPoint = Vector2.new(0.5, 0.5)
			knob.Position = UDim2.new(0, 0, 0.5, 0)
			knob.BackgroundColor3 = Color3.new(1, 1, 1)
			knob.Image = ""

			local dragging = false
			local value = def or 0
			local function update(x)
				local rel = math.clamp((x - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
				fill.Size = UDim2.new(rel, 0, 1, 0)
				knob.Position = UDim2.new(rel, 0, 0.5, 0)
				value = math.floor(((min or 0) + ((max or 100) - (min or 0)) * rel) / (inc or 1)) * (inc or 1)
				if callback then callback(value) end
			end

			knob.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					update(input.Position.X)
				end
			end)

			return {
				Set = function(_, val)
					local rel = math.clamp((val - min) / (max - min), 0, 1)
					fill.Size = UDim2.new(rel, 0, 1, 0)
					knob.Position = UDim2.new(rel, 0, 0.5, 0)
					callback(val)
				end
			}
		end

		-- DROPDOWN
		function section:Dropdown(text, options, default, flag, callback)
			local frame = Instance.new("Frame", frame)
			frame.Size = UDim2.new(1, -10, 0, 30 + (#options * 25))
			frame.BackgroundTransparency = 1

			local dropdown = Instance.new("TextButton", frame)
			dropdown.Size = UDim2.new(1, 0, 0, 30)
			dropdown.Text = text .. " ▼"
			dropdown.TextColor3 = Color3.new(1, 1, 1)
			dropdown.Font = Enum.Font.Gotham
			dropdown.TextSize = 16
			dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

			local open = false
			local buttons = {}

			for i, opt in ipairs(options) do
				local optBtn = Instance.new("TextButton", frame)
				optBtn.Size = UDim2.new(1, 0, 0, 25)
				optBtn.Position = UDim2.new(0, 0, 0, 30 + (i - 1) * 25)
				optBtn.Text = opt
				optBtn.Visible = false
				optBtn.TextColor3 = Color3.new(1, 1, 1)
				optBtn.Font = Enum.Font.Gotham
				optBtn.TextSize = 14
				optBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 65)

				optBtn.MouseButton1Click:Connect(function()
					dropdown.Text = text .. ": " .. opt
					for _, b in pairs(buttons) do b.Visible = false end
					open = false
					if callback then callback(opt) end
				end)

				table.insert(buttons, optBtn)
			end

			dropdown.MouseButton1Click:Connect(function()
				open = not open
				for _, b in pairs(buttons) do b.Visible = open end
			end)

			return {
				Refresh = function(_, newOptions, clear)
					if clear then
						for _, btn in ipairs(buttons) do btn:Destroy() end
						table.clear(buttons)
					end
					for _, opt in ipairs(newOptions) do
						local btn = Instance.new("TextButton", frame)
						btn.Size = UDim2.new(1, 0, 0, 25)
						btn.Text = opt
						btn.Visible = false
						btn.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
						btn.TextColor3 = Color3.new(1, 1, 1)
						btn.Font = Enum.Font.Gotham
						btn.TextSize = 14
						btn.MouseButton1Click:Connect(function()
							dropdown.Text = text .. ": " .. opt
							for _, b in pairs(buttons) do b.Visible = false end
							open = false
							if callback then callback(opt) end
						end)
						table.insert(buttons, btn)
					end
				end,

				Set = function(_, val)
					dropdown.Text = text .. ": " .. val
					if callback then callback(val) end
				end
			}
		end

		return section
	end

	table.insert(self.Tabs, tab)
	return tab
end

return LaimLib
