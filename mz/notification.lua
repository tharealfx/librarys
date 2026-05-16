-- DEVELOPNMENT

local mz = {}
local TweenService = game:GetService("TweenService")
local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local sg = playerGui:FindFirstChild("mzNotifications")
if not sg then
	sg = Instance.new("ScreenGui")
	sg.ResetOnSpawn = false
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	sg.Name = "mzNotifications"
	sg.Parent = playerGui
end

if not _G.mzHolders then
	_G.mzHolders = {}
end

local function getHolder(hPos, vPos)
	local key = hPos .. "_" .. vPos
	if _G.mzHolders[key] and _G.mzHolders[key].holder.Parent then
		return _G.mzHolders[key].holder, _G.mzHolders[key].list
	end

	local anchorX = hPos == "Left" and 0 or hPos == "Right" and 1 or 0.5
	local anchorY = vPos == "Top" and 0 or 1
	local offsetY  = vPos == "Top" and 7 or -7

	local holder = Instance.new("Frame")
	holder.AnchorPoint = Vector2.new(anchorX, anchorY)
	holder.BackgroundTransparency = 1
	holder.BorderSizePixel = 0
	holder.Position = UDim2.new(anchorX, 0, anchorY, offsetY)
	holder.Size = UDim2.new(1, -20, 1, -14)
	holder.Parent = sg

	local list = Instance.new("UIListLayout")
	list.HorizontalAlignment = hPos == "Left"
		and Enum.HorizontalAlignment.Left
		or hPos == "Right"
		and Enum.HorizontalAlignment.Right
		or Enum.HorizontalAlignment.Center
	list.VerticalAlignment = vPos == "Top"
		and Enum.VerticalAlignment.Top
		or Enum.VerticalAlignment.Bottom
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0, 4)
	list.Parent = holder

	_G.mzHolders[key] = { holder = holder, list = list }
	return holder, list
end

local function getTextHeight(text, fontSize, width, font)
	local ts = game:GetService("TextService")
	local size = ts:GetTextSize(text, fontSize, font, Vector2.new(width - 20, 9999))
	return size.Y
end

function mz:Notification(c)
	local BG = c.Theme.BackroundColor
	local TC = c.Theme.TitleColor
	local CC = c.Theme.ContentColor
	local LC = c.Theme.LineColor
	local SC = c.Theme.StrokeColor

	local hPos = c.Position[1]
	local vPos = c.Position[2]

	local holder = getHolder(hPos, vPos)

	local notifWidth = 350
	local titleHeight = 24
	local contentTextHeight = getTextHeight(c.Desc, 15, notifWidth, c.ContentFont)
	local padding = 16
	local minHeight = 50
	local totalHeight = math.max(minHeight, titleHeight + contentTextHeight + padding)

	local n = Instance.new("Frame")
	n.AnchorPoint = hPos == "Left" and Vector2.new(0, 0)
		or hPos == "Right" and Vector2.new(1, 0)
		or Vector2.new(0.5, 0)
	n.BackgroundColor3 = Color3.fromRGB(BG[1], BG[2], BG[3])
	n.BorderSizePixel = 0
	n.ClipsDescendants = false
	n.Size = UDim2.new(0, notifWidth, 0, 0)
	n.Parent = holder

	local uc = Instance.new("UICorner")
	uc.CornerRadius = UDim.new(0, 5)
	uc.Parent = n

	if c.Stroke then
		local s = Instance.new("UIStroke")
		s.Color = Color3.fromRGB(SC[1], SC[2], SC[3])
		s.Thickness = 1.5
		s.Parent = n
	end

	local title = Instance.new("TextLabel")
	title.AnchorPoint = Vector2.new(1, 0)
	title.BackgroundTransparency = 1
	title.BorderSizePixel = 0
	title.Position = UDim2.new(1, 0, 0, 0)
	title.Size = UDim2.new(1, 0, 0, titleHeight)
	title.Font = c.TitleFont
	title.Text = c.Title
	title.TextColor3 = Color3.fromRGB(TC[1], TC[2], TC[3])
	title.TextSize = 20
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextWrapped = true
	title.Parent = n

	local tp = Instance.new("UIPadding")
	tp.PaddingLeft = UDim.new(0, 10)
	tp.PaddingTop = UDim.new(0, 5)
	tp.Parent = title

	local content = Instance.new("TextLabel")
	content.AnchorPoint = Vector2.new(1, 1)
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.Position = UDim2.new(1, 0, 1, 0)
	content.Size = UDim2.new(1, 0, 0, contentTextHeight + 8)
	content.Font = c.ContentFont
	content.Text = c.Desc
	content.TextColor3 = Color3.fromRGB(CC[1], CC[2], CC[3])
	content.TextSize = 15
	content.TextXAlignment = Enum.TextXAlignment.Right
	content.TextYAlignment = Enum.TextYAlignment.Bottom
	content.TextWrapped = true
	content.Parent = n

	local cp = Instance.new("UIPadding")
	cp.PaddingBottom = UDim.new(0, 8)
	cp.PaddingRight = UDim.new(0, 10)
	cp.Parent = content

	if c.Line then
		local line = Instance.new("Frame")
		line.BackgroundColor3 = Color3.fromRGB(LC[1], LC[2], LC[3])
		line.BorderSizePixel = 0
		line.Parent = n
		Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)

		if c.LineSide == "Right" then
			line.AnchorPoint = Vector2.new(1, 0.5)
			line.Position = UDim2.new(1, 0, 0.5, 0)
			line.Size = UDim2.new(0, 3, 1, 0)
		elseif c.LineSide == "Left" then
			line.AnchorPoint = Vector2.new(0, 0.5)
			line.Position = UDim2.new(0, 0, 0.5, 0)
			line.Size = UDim2.new(0, 3, 1, 0)
		elseif c.LineSide == "Top" then
			line.AnchorPoint = Vector2.new(0.5, 0)
			line.Position = UDim2.new(0.5, 0, 0, 0)
			line.Size = UDim2.new(1, 0, 0, 3)
		elseif c.LineSide == "Bottom" then
			line.AnchorPoint = Vector2.new(0.5, 1)
			line.Position = UDim2.new(0.5, 0, 1, 0)
			line.Size = UDim2.new(1, 0, 0, 3)
		end
	end

	TweenService:Create(n, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, notifWidth, 0, totalHeight)
	}):Play()

	task.wait(0.05)

	local slideIn, slideOut, startPos
	if hPos == "Left" then
		startPos = UDim2.new(0, -(notifWidth + 20), 0, 0)
		slideIn  = UDim2.new(0, 0, 0, 0)
		slideOut = UDim2.new(0, -(notifWidth + 20), 0, 0)
	elseif hPos == "Right" then
		startPos = UDim2.new(1, notifWidth + 20, 0, 0)
		slideIn  = UDim2.new(1, 0, 0, 0)
		slideOut = UDim2.new(1, notifWidth + 20, 0, 0)
	else
		startPos = UDim2.new(0.5, 0, 0, 0)
		slideIn  = UDim2.new(0.5, 0, 0, 0)
		slideOut = UDim2.new(0.5, 0, 0, 0)
	end

	n.Position = startPos
	TweenService:Create(n, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = slideIn
	}):Play()

	task.delay(c.Time, function()
		local t = TweenService:Create(n, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Position = slideOut
		})
		t:Play()
		TweenService:Create(n, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Size = UDim2.new(0, notifWidth, 0, 0)
		}):Play()
		t.Completed:Connect(function()
			n:Destroy()
		end)
	end)
end

return mz
