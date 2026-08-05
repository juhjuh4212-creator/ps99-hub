return function(_a1)
local _a2, _a3, _a4, _a5, _a6, _a7, _a8 = _a1.UIS, _a1.RunService, _a1.LP, _a1.LOG, _a1.log, _a1.num, _a1.LB
local _a9, _a10, _a11, _a12, _a13, _a14 = _a1.RM, _a1.CFG, _a1.EGG_COST_CACHE, _a1.RUN, _a1.STAT, _a1.EVENT_UPGRADES
local _a15, _a16, _a17, _a18, _a19, _a20 = _a1.ctx, _a1.collectSlots, _a1.placedTowers, _a1.availableItems, _a1.cyclePlace, _a1.cycleMerchant
local _a21, _a22, _a23, _a24, _a25, _a26 = _a1.sunflowers, _a1.eventTiers, _a1.nextCost, _a1.cycleUpgrade, _a1.seedInv, _a1.bedsOf
local _a27, _a28, _a29, _a30, _a31, _a32 = _a1.isUnhatched, _a1.bedCps, _a1.cycleCrop, _a1.laneCosts, _a1.lockedBeds, _a1.cycleExpand
local _a33, _a34, _a35, _a36, _a37 = _a1.rebirthStatus, _a1.cycleRebirth, _a1.hatchStatus, _a1.cycleHatch, _a1.LUCK_ORDER
local _a38, _a39, _a40, _a41, _a42, _a43 = _a1.luckStatus, _a1.fmtDur, _a1.cycleLuck, _a1.MG, _a1.QS, _a1.saveGet
local _a44, _a45, _a46, _a47, _a48, _a49 = _a1.currencyAmount, _a1.cycleFarm, _a1.zoneStatus, _a1.cycleZone, _a1.bestMainEgg, _a1.mainHatchStatus
local _a50, _a51, _a52, _a53, _a54 = _a1.cycleMainHatch, _a1.mainRebirthStatus, _a1.cycleMainRebirth, _a1.cycleTowerUp, _a1.startLoop
local _a55 = {
bg      = Color3.fromRGB(18, 19, 24),
panel   = Color3.fromRGB(26, 28, 35),
card    = Color3.fromRGB(32, 35, 43),
cardHi  = Color3.fromRGB(38, 42, 52),
line    = Color3.fromRGB(52, 57, 70),
text    = Color3.fromRGB(232, 236, 243),
dim     = Color3.fromRGB(138, 146, 163),
accent  = Color3.fromRGB(94, 156, 255),
good    = Color3.fromRGB(72, 199, 132),
warn    = Color3.fromRGB(240, 176, 64),
bad     = Color3.fromRGB(238, 92, 92),
sun     = Color3.fromRGB(255, 205, 84),
}
local function _a56(_a57, _a58, _a59)
local _a60 = Instance.new(_a57)
for _a61, _a62 in pairs(_a58) do _a60[_a61] = _a62 end
if _a59 then _a60.Parent = _a59 end
return _a60
end
local function _a63(_a64, _a65) _a56("UICorner", { CornerRadius = UDim.new(0, _a65 or 8) }, _a64) end
local function _a66(_a67, _a68, _a69)
_a56("UIStroke", { Color = _a68 or _a55.line, Thickness = _a69 or 1,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, _a67)
end
local function _a70(_a71, _a72)
_a56("UIPadding", {
PaddingTop = UDim.new(0, _a72), PaddingBottom = UDim.new(0, _a72),
PaddingLeft = UDim.new(0, _a72), PaddingRight = UDim.new(0, _a72),
}, _a71)
end
local _a73 = _a56("ScreenGui", {
Name = "PS99GardenAuto", ResetOnSpawn = false,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
IgnoreGuiInset = true, DisplayOrder = 9999,
})
local _a74 = false
if type(gethui) == "function" then _a74 = pcall(function() _a73.Parent = gethui() end) end
if not _a74 then _a74 = pcall(function() _a73.Parent = game:GetService("CoreGui") end) end
if not _a74 then _a73.Parent = _a4:WaitForChild("PlayerGui") end
local _a75, _a76 = 780, 520
local _a77 = _a56("Frame", {
Size = UDim2.fromOffset(_a75, _a76), Position = UDim2.new(0.5, -_a75 / 2, 0.5, -_a76 / 2),
BackgroundColor3 = _a55.bg, BorderSizePixel = 0, Active = true, ClipsDescendants = true,
}, _a73)
_a63(_a77, 12)
_a66(_a77, Color3.fromRGB(60, 66, 82), 1)
local _a78 = _a56("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = _a55.panel, BorderSizePixel = 0,
}, _a77)
_a63(_a78, 12)
_a56("Frame", {
Size = UDim2.new(1, 0, 0, 12), Position = UDim2.new(0, 0, 1, -12),
BackgroundColor3 = _a55.panel, BorderSizePixel = 0,
}, _a78)
_a56("Frame", {
Size = UDim2.fromOffset(10, 10), Position = UDim2.fromOffset(14, 15),
BackgroundColor3 = _a55.good, BorderSizePixel = 0,
}, _a78).Name = "Dot"
_a63(_a78:FindFirstChild("Dot"), 5)
_a56("TextLabel", {
Size = UDim2.new(0, 320, 1, 0), Position = UDim2.fromOffset(32, 0),
BackgroundTransparency = 1, Text = "Garden Defenders  AutoPlay",
TextColor3 = _a55.text, TextSize = 14, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a78)
local function _a79(_a80, _a81, _a82, _a83)
local _a84 = _a56("TextButton", {
Size = UDim2.new(0, _a83, 0, 24), Position = UDim2.new(1, _a82, 0, 8),
BackgroundColor3 = _a81, BorderSizePixel = 0, Text = _a80,
TextColor3 = _a55.text, TextSize = 12, Font = Enum.Font.GothamMedium,
AutoButtonColor = true,
}, _a78)
_a63(_a84, 6)
return _a84
end
local _a85 = _a79("✕", _a55.bad, -38, 28)
local _a86   = _a79("—", _a55.card, -70, 28)
local _a87 = _a79("지우기", _a55.card, -132, 58)
local _a88  = _a79("복사", _a55.accent, -190, 54)
local _a89  = _a79("정지", _a55.bad, -252, 58)
_a89.MouseButton1Click:Connect(function()
task.spawn(function()
_a42.ctl.stopAll()
if _a42.auto.refresh then pcall(_a42.auto.refresh) end
_a6("[정지] 모든 동작을 멈췄습니다")
end)
end)
local _a90 = _a56("ScrollingFrame", {
Size = UDim2.new(0, 152, 1, -92), Position = UDim2.fromOffset(10, 48),
BackgroundColor3 = _a55.panel, BorderSizePixel = 0,
ScrollBarThickness = 3, ScrollBarImageColor3 = _a55.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a77)
_a63(_a90, 8)
_a56("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, _a90)
_a56("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }, _a90)
local _a91 = _a56("Frame", {
Size = UDim2.new(1, -182, 1, -92), Position = UDim2.fromOffset(172, 48),
BackgroundTransparency = 1,
}, _a77)
local _a92, _a93 = {}, nil
local _a94, _a95 = {}, {}
local _a96 = {}
local function _a97(_a98)
_a93 = _a98
for _a99, _a100 in pairs(_a92) do _a100.Visible = (_a99 == _a98) end
for _a101, _a102 in pairs(_a94) do
local _a103 = (_a101 == _a98)
_a102.BackgroundColor3 = _a103 and _a55.accent or _a55.panel
_a102.TextColor3 = _a103 and Color3.fromRGB(255, 255, 255) or _a55.dim
end
local _a104 = _a95[_a98]
if _a104 and _a96[_a104] and not _a96[_a104].open then _a96[_a104].toggle() end
end
local function _a105(_a106, _a107, _a108)
local _a109 = { open = true, kids = {} }
local _a110 = _a56("TextButton", {
Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = _a55.bg, BorderSizePixel = 0,
Text = "", TextColor3 = _a55.dim, TextSize = 11,
Font = Enum.Font.GothamBold, LayoutOrder = _a108, AutoButtonColor = false,
}, _a90)
_a63(_a110, 5)
local _a111 = _a56("TextLabel", {
Size = UDim2.fromOffset(14, 26), Position = UDim2.fromOffset(6, 0),
BackgroundTransparency = 1, Text = "▾", TextColor3 = _a55.dim,
TextSize = 10, Font = Enum.Font.GothamBold,
}, _a110)
_a56("TextLabel", {
Size = UDim2.new(1, -22, 1, 0), Position = UDim2.fromOffset(20, 0),
BackgroundTransparency = 1, Text = _a107, TextColor3 = _a55.dim,
TextSize = 11, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a110)
function _a109.toggle()
_a109.open = not _a109.open
_a111.Text = _a109.open and "▾" or "▸"
for _a112, _a113 in ipairs(_a109.kids) do _a113.Visible = _a109.open end
end
_a110.MouseButton1Click:Connect(_a109.toggle)
_a96[_a106] = _a109
return _a109
end
local function _a114(_a115, _a116, _a117, _a118)
local _a119 = _a118 and 14 or 6
local _a120 = _a56("TextButton", {
Size = UDim2.new(1, 0, 0, 27), BackgroundColor3 = _a55.panel, BorderSizePixel = 0,
Text = "", TextColor3 = _a55.dim, TextSize = 12,
Font = Enum.Font.GothamMedium, LayoutOrder = _a117, AutoButtonColor = false,
}, _a90)
_a63(_a120, 5)
local _a121 = _a56("TextLabel", {
Size = UDim2.new(1, -_a119 - 4, 1, 0), Position = UDim2.fromOffset(_a119, 0),
BackgroundTransparency = 1, Text = _a116, TextColor3 = _a55.dim,
TextSize = 12, Font = Enum.Font.GothamMedium,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a120)
_a94[_a115] = _a120
if _a118 then
_a95[_a115] = _a118
local _a122 = _a96[_a118]
if _a122 then
table.insert(_a122.kids, _a120)
_a120.Visible = _a122.open
end
end
local _a123 = _a56("ScrollingFrame", {
Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false,
BorderSizePixel = 0, ScrollBarThickness = 4,
ScrollBarImageColor3 = _a55.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a91)
_a56("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, _a123)
_a56("UIPadding", { PaddingRight = UDim.new(0, 8) }, _a123)
_a92[_a115] = _a123
_a120.MouseButton1Click:Connect(function() _a97(_a115) end)
_a120.MouseEnter:Connect(function()
if _a93 ~= _a115 then _a120.BackgroundColor3 = _a55.card end
end)
_a120.MouseLeave:Connect(function()
if _a93 ~= _a115 then _a120.BackgroundColor3 = _a55.panel end
end)
_a120:GetPropertyChangedSignal("TextColor3"):Connect(function()
_a121.TextColor3 = _a120.TextColor3
end)
return _a123
end
local _a124 = 0
local function _a125()
_a124 += 1
return _a124
end
local function _a126(_a127, _a128)
local _a129 = _a56("Frame", {
Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, LayoutOrder = _a125(),
}, _a127)
_a56("Frame", {
Size = UDim2.fromOffset(3, 14), Position = UDim2.fromOffset(0, 7),
BackgroundColor3 = _a55.accent, BorderSizePixel = 0,
}, _a129)
_a56("TextLabel", {
Size = UDim2.new(1, -12, 1, 0), Position = UDim2.fromOffset(10, 0),
BackgroundTransparency = 1, Text = _a128, TextColor3 = _a55.text,
TextSize = 13, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a129)
return _a129
end
local function _a130(_a131, _a132, _a133)
local _a134 = _a56("Frame", {
Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundColor3 = _a55.card, BorderSizePixel = 0, LayoutOrder = _a125(),
}, _a131)
_a63(_a134, 8)
_a66(_a134, _a55.line, 1)
_a70(_a134, 12)
_a56("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, _a134)
if _a132 then
local _a135 = _a56("Frame", {
Size = UDim2.new(1, 0, 0, _a133 and 32 or 22), BackgroundTransparency = 1,
LayoutOrder = 0,
}, _a134)
_a56("TextLabel", {
Size = UDim2.new(1, -70, 0, 16), BackgroundTransparency = 1, Text = _a132,
TextColor3 = _a55.text, TextSize = 13, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a135)
if _a133 then
_a56("TextLabel", {
Size = UDim2.new(1, -70, 0, 13), Position = UDim2.fromOffset(0, 17),
BackgroundTransparency = 1, Text = _a133, TextColor3 = _a55.dim,
TextSize = 11, Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
}, _a135)
end
_a134:SetAttribute("HeadHeight", _a133 and 32 or 18)
return _a134, _a135
end
return _a134
end
local _a136 = {}
local function _a137()
for _a138, _a139 in pairs(_a136) do pcall(_a139) end
end
_a42.auto.refresh = _a137
local function _a140(_a141, _a142, _a143)
local _a144 = _a56("TextButton", {
Size = UDim2.fromOffset(46, 24), Position = UDim2.new(1, -46, 0, 0),
BackgroundColor3 = _a55.cardHi, BorderSizePixel = 0, Text = "",
AutoButtonColor = false,
}, _a141)
_a63(_a144, 12)
local _a145 = _a56("Frame", {
Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(3, 3),
BackgroundColor3 = _a55.dim, BorderSizePixel = 0,
}, _a144)
_a63(_a145, 9)
local _a146 = _a56("TextLabel", {
Size = UDim2.fromOffset(46, 12), Position = UDim2.fromOffset(0, 26),
BackgroundTransparency = 1, Text = "OFF", TextColor3 = _a55.dim,
TextSize = 10, Font = Enum.Font.GothamBold,
}, _a144)
local function _a147()
local _a148 = _a12[_a142]
_a144.BackgroundColor3 = _a148 and _a55.good or _a55.cardHi
_a145:TweenPosition(UDim2.fromOffset(_a148 and 25 or 3, 3),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
_a145.BackgroundColor3 = _a148 and Color3.fromRGB(255, 255, 255) or _a55.dim
_a146.Text = _a148 and "ON" or "OFF"
_a146.TextColor3 = _a148 and _a55.good or _a55.dim
end
_a144.MouseButton1Click:Connect(function()
_a12[_a142] = not _a12[_a142]
if _a12[_a142] then
if _a142 == "auto" then _a42.ctl.abort = false end
_a147()
_a6("[" .. _a142 .. "] 시작")
task.spawn(function()
local _a149, _a150 = pcall(_a143)
if not _a149 then _a6("[에러] " .. tostring(_a150)) end
end)
else
if _a142 == "auto" then
_a42.ctl.stopAll()
_a6("[정지] 모든 동작을 멈췄습니다")
end
_a147()
end
end)
_a147()
_a136[_a142] = _a147
return _a144, _a147
end
local function _a151(_a152, _a153)
local _a154 = _a56("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, LayoutOrder = _a125(),
}, _a152)
local _a155 = #_a153
for _a156, _a157 in ipairs(_a153) do
local _a158 = _a56("Frame", {
Size = UDim2.new(1 / _a155, -6, 1, 0), Position = UDim2.new((_a156 - 1) / _a155, 3, 0, 0),
BackgroundTransparency = 1,
}, _a154)
_a56("TextLabel", {
Size = UDim2.new(1, 0, 0, 13), BackgroundTransparency = 1, Text = _a157.label,
TextColor3 = _a55.dim, TextSize = 10, Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a158)
local _a159 = _a56("TextBox", {
Size = UDim2.new(1, 0, 0, 24), Position = UDim2.fromOffset(0, 15),
BackgroundColor3 = _a55.bg, BorderSizePixel = 0, Text = tostring(_a157.value),
TextColor3 = _a55.text, TextSize = 12, Font = Enum.Font.Code,
ClearTextOnFocus = false,
}, _a158)
_a63(_a159, 5)
_a66(_a159, _a55.line, 1)
_a159.FocusLost:Connect(function() _a157.onChange(_a159.Text, _a159) end)
end
return _a154
end
local function _a160(_a161, _a162)
local _a163 = _a56("Frame", {
Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = _a125(),
}, _a161)
local _a164 = #_a162
for _a165, _a166 in ipairs(_a162) do
local _a167 = _a56("TextButton", {
Size = UDim2.new(1 / _a164, -5, 1, 0), Position = UDim2.new((_a165 - 1) / _a164, 2.5, 0, 0),
BackgroundColor3 = _a166.col or _a55.cardHi, BorderSizePixel = 0, Text = _a166.label,
TextColor3 = _a55.text, TextSize = 12, Font = Enum.Font.GothamMedium,
}, _a163)
_a63(_a167, 6)
_a167.MouseButton1Click:Connect(function()
task.spawn(function()
local _a168, _a169 = pcall(_a166.fn, _a167)
if not _a168 then _a6("[에러] " .. tostring(_a166.label) .. " → " .. tostring(_a169)) end
end)
end)
end
return _a163
end
local function _a170(_a171, _a172, _a173, _a174)
local _a175 = _a56("TextButton", {
Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = _a55.cardHi, BorderSizePixel = 0,
Text = "", TextColor3 = _a55.text, TextSize = 12, Font = Enum.Font.GothamMedium,
LayoutOrder = _a125(),
}, _a171)
_a63(_a175, 6)
local function _a176()
local _a177 = _a173()
_a175.Text = _a172 .. "   " .. (_a177 and "ON" or "OFF")
_a175.BackgroundColor3 = _a177 and Color3.fromRGB(40, 78, 58) or _a55.cardHi
_a175.TextColor3 = _a177 and _a55.good or _a55.dim
end
_a175.MouseButton1Click:Connect(function()
_a174(not _a173())
_a176()
end)
_a176()
return _a175
end
local _a178 = _a114("log", "로그", 90)
local _a179, _a180, _a181
local _a182 = { size = 140, top = nil }
do
local _a183 = _a56("Frame", {
Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(13, 14, 18),
BorderSizePixel = 0, LayoutOrder = _a125(),
}, _a178)
_a63(_a183, 8)
_a66(_a183, _a55.line, 1)
local _a184 = _a56("Frame", {
Size = UDim2.new(1, -10, 0, 24), Position = UDim2.fromOffset(5, 5),
BackgroundTransparency = 1,
}, _a183)
_a180 = _a56("TextLabel", {
Size = UDim2.new(1, -250, 1, 0), BackgroundTransparency = 1,
Text = "", TextColor3 = _a55.dim, TextSize = 11, Font = Enum.Font.Code,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a184)
local function _a185(_a186, _a187, _a188, _a189)
local _a190 = _a56("TextButton", {
Size = UDim2.new(0, _a187, 0, 22), Position = UDim2.new(1, _a186, 0, 1),
BackgroundColor3 = _a55.cardHi, BorderSizePixel = 0, AutoButtonColor = true,
Text = _a188, TextColor3 = _a55.text, TextSize = 11, Font = Enum.Font.GothamBold,
}, _a184)
_a63(_a190, 5)
_a190.MouseButton1Click:Connect(function()
task.spawn(function() pcall(_a189) _a1.dirty = true end)
end)
return _a190
end
local function _a191()
return _a182.top or math.max(1, #_a5 - _a182.size + 1)
end
_a185(-244, 56, "맨 위",  function() _a182.top = 1 end)
_a185(-186, 40, "▲",     function() _a182.top = math.max(1, _a191() - _a182.size) end)
_a185(-144, 40, "▼",     function()
local _a192 = _a191() + _a182.size
if _a192 >= math.max(1, #_a5 - _a182.size + 1) then _a182.top = nil else _a182.top = _a192 end
end)
_a185(-102, 100, "최신 따라가기", function() _a182.top = nil end)
_a181 = _a56("ScrollingFrame", {
Size = UDim2.new(1, -10, 1, -36), Position = UDim2.fromOffset(5, 31),
BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 6,
ScrollBarImageColor3 = _a55.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a183)
_a179 = _a56("TextLabel", {
Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1, Text = "", TextColor3 = Color3.fromRGB(196, 208, 196),
TextSize = 11, Font = Enum.Font.Code,
TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
TextWrapped = true,
}, _a181)
_a178.AutomaticCanvasSize = Enum.AutomaticSize.None
_a178.CanvasSize = UDim2.new()
end
do
local _a193, _a194, _a195, _a196
_a78.InputBegan:Connect(function(_a197)
if _a197.UserInputType == Enum.UserInputType.MouseButton1
or _a197.UserInputType == Enum.UserInputType.Touch then
_a193, _a194, _a195 = true, _a197.Position, _a77.Position
_a197.Changed:Connect(function()
if _a197.UserInputState == Enum.UserInputState.End then _a193 = false end
end)
end
end)
_a78.InputChanged:Connect(function(_a198)
if _a198.UserInputType == Enum.UserInputType.MouseMovement
or _a198.UserInputType == Enum.UserInputType.Touch then _a196 = _a198 end
end)
_a2.InputChanged:Connect(function(_a199)
if _a193 and _a199 == _a196 then
local _a200 = _a199.Position - _a194
_a77.Position = UDim2.new(_a195.X.Scale, _a195.X.Offset + _a200.X,
_a195.Y.Scale, _a195.Y.Offset + _a200.Y)
end
end)
local _a201 = false
_a86.MouseButton1Click:Connect(function()
_a201 = not _a201
_a77:TweenSize(_a201 and UDim2.fromOffset(_a75, 40) or UDim2.fromOffset(_a75, _a76),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
_a86.Text = _a201 and "▢" or "—"
end)
end
local _a202 = _a3.Heartbeat:Connect(function()
if not _a1.dirty then return end
_a1.dirty = false
local _a203 = #_a5
local _a204 = math.max(1, _a203 - _a182.size + 1)
local _a205 = (_a182.top == nil)
local _a206 = math.max(1, math.min(_a182.top or _a204, _a204))
local _a207 = math.min(_a203, _a206 + _a182.size - 1)
local _a208, _a209 = {}, 0
for _a210 = _a206, _a207 do
local _a211 = _a5[_a210] or ""
if #_a211 > 400 then _a211 = _a211:sub(1, 400) .. " …" end
_a209 += #_a211 + 1
if _a209 > 12000 then
_a208[#_a208 + 1] = "…  (이 창에 다 못 담아 잘랐습니다. ▲ 로 나눠서 보세요)"
_a207 = _a210 - 1
break
end
_a208[#_a208 + 1] = _a211
end
_a179.Text = table.concat(_a208, "\n")
_a180.Text = ("%d-%d / %d 줄    %s")
:format(_a206, _a207, _a203, _a205 and "최신 따라가는 중" or "▲▼ 로 이동  ·  멈춤")
if _a205 then
task.defer(function()
if _a181 and _a181.Parent then
_a181.CanvasPosition = Vector2.new(0, _a181.AbsoluteCanvasSize.Y)
end
end)
end
end)
local _a212 = _a114("dash", "대시보드", 10)
local _a213 = _a114("event", "이벤트", 20)
do
local _a214 = _a130(_a212, "전체 제어", nil)
_a160(_a214, {
{ label = "권장 전부 ON", col = _a55.good, fn = function()
for _a215, _a216 in ipairs({ "place", "merchant", "crop", "expand", "hatch" }) do
if not _a12[_a216] then
_a12[_a216] = true
if _a216 == "place"    then _a54(_a216, function() return _a10.PlaceInterval end, _a19, "배치") end
if _a216 == "merchant" then _a54(_a216, function() return _a10.MerchantInterval end, _a20, "구매") end
if _a216 == "crop"     then _a54(_a216, function() return _a10.CropInterval end, _a29, "씨앗") end
if _a216 == "expand"   then _a54(_a216, function() return _a10.ExpandInterval end, _a32, "확장") end
if _a216 == "hatch"    then _a54(_a216, function() return _a10.HatchInterval end, _a36, "뽑기") end
end
end
_a137()
_a6("[전체] 배치/구매/씨앗/확장/뽑기 ON  (업글·리버스는 따로 켜세요)")
end },
{ label = "전부 정지", col = _a55.bad, fn = function()
_a12.place, _a12.merchant, _a12.upgrade = false, false, false
_a12.towerup, _a12.crop, _a12.expand, _a12.rebirth, _a12.hatch, _a12.luck = false, false, false, false, false, false
_a12.farm, _a12.zone, _a12.mhatch, _a12.rank, _a12.mreb = false, false, false, false, false
_a137()
_a6("[전체] 정지")
end },
})
local _a217 = _a130(_a212, "현황", nil)
_a160(_a217, {
{ label = "밭 / 타워", col = _a55.accent, fn = function()
local _a218, _a219, _a220, _a221 = _a15()
_a6("")
_a6("──── 현재 상태 ────")
_a6("레인 " .. tostring(_a221) .. " / plot " .. (_a220 and "O" or "X")
.. " / world " .. (_a218 and "O" or "X"))
local _a222 = _a16(_a220, _a221)
local _a223 = _a17(_a218)
_a6("슬롯 " .. #_a222 .. " / 배치 " .. #_a223)
local _a224, _a225 = 0, {}
for _a226, _a227 in ipairs(_a223) do
_a224 += (_a227.dps or 0)
_a225[tostring(_a227.kind)] = (_a225[tostring(_a227.kind)] or 0) + 1
end
_a6("총 DPS " .. _a7(_a224))
for _a228, _a229 in pairs(_a225) do _a6("  " .. _a228 .. " × " .. _a229) end
local _a230 = _a18()
_a6("")
_a6("배치 가능 " .. #_a230 .. "종")
for _a231 = 1, math.min(10, #_a230) do
local _a232 = _a230[_a231]
_a6(("  %-22s %-7s 남은 %-3s DPS %s"):format(
tostring(_a232.id), tostring(_a232.vr or "-"), tostring(_a232.copies), _a7(_a232.dps)))
end
_a97("log")
end },
{ label = "로그 보기", col = _a55.cardHi, fn = function() _a97("log") end },
})
end
do
local _a233, _a234 = _a130(_a213, "자동 배치 / 교체", nil)
_a140(_a234, "place", function()
_a54("place", function() return _a10.PlaceInterval end, _a19, "배치")
end)
_a151(_a233, {
{ label = "주기", value = _a10.PlaceInterval, onChange = function(_a235)
local _a236 = tonumber(_a235) if _a236 and _a236 >= 3 then _a10.PlaceInterval = _a236 end
end },
{ label = "교체 배수", value = _a10.SwapMargin, onChange = function(_a237)
local _a238 = tonumber(_a237) if _a238 and _a238 >= 1 then _a10.SwapMargin = _a238 _a6("[설정] 교체 배수 " .. _a238) end
end },
{ label = "DoT 반영", value = _a10.DotFactor, onChange = function(_a239)
local _a240 = tonumber(_a239) if _a240 and _a240 >= 0 and _a240 <= 1 then _a10.DotFactor = _a240 end
end },
})
_a170(_a233, "업글 타워 보호",
function() return _a10.ProtectUpgraded end,
function(_a241) _a10.ProtectUpgraded = _a241
_a6("[설정] 업글 보호 " .. (_a241 and "ON — 업글된 건 안 건드림" or "OFF — 약하면 교체")) end)
_a160(_a233, {
{ label = "지금 1회 실행", col = _a55.accent, fn = function()
task.spawn(function() _a12.place = true _a19() _a12.place = false _a97("log") end)
end },
})
end
do
local _a242, _a243 = _a130(_a213, "머천트 자동 구매", nil)
_a140(_a243, "merchant", function()
_a54("merchant", function() return _a10.MerchantInterval end, _a20, "구매")
end)
_a151(_a242, {
{ label = "머천트 ID", value = _a10.MerchantId, onChange = function(_a244)
if _a244 ~= "" then _a10.MerchantId = _a244 _a6("[설정] 머천트 " .. _a244) end
end },
{ label = "주기", value = _a10.MerchantInterval, onChange = function(_a245)
local _a246 = tonumber(_a245) if _a246 and _a246 >= 5 then _a10.MerchantInterval = _a246 end
end },
})
_a160(_a242, {
{ label = "지금 1회 구매", col = _a55.accent, fn = function()
task.spawn(function() _a12.merchant = true _a20() _a12.merchant = false _a97("log") end)
end },
})
end
do
local _a247, _a248 = _a130(_a213, "업그레이드 머신", nil)
_a140(_a248, "upgrade", function()
_a54("upgrade", function() return _a10.UpgradeInterval end, _a24, "머신업글")
end)
_a151(_a247, {
{ label = "주기", value = _a10.UpgradeInterval, onChange = function(_a249)
local _a250 = tonumber(_a249) if _a250 and _a250 >= 5 then _a10.UpgradeInterval = _a250 end
end },
{ label = "최소 잔액", value = _a10.MinSunflowers, onChange = function(_a251)
local _a252 = tonumber(_a251) if _a252 and _a252 >= 0 then _a10.MinSunflowers = _a252
_a6("[설정] 최소 잔액 " .. _a7(_a252, 0)) end
end },
})
_a170(_a247, "가격 미상 구매",
function() return _a10.BuyUnknownCost end,
function(_a253) _a10.BuyUnknownCost = _a253 end)
_a160(_a247, {
{ label = "업글 현황 보기", col = _a55.accent, fn = function()
local _a254 = _a21()
local _a255 = _a22()
_a13.sun = _a254
_a6("")
_a6("──── 업그레이드 머신 ────")
_a6("Sunflowers = " .. _a7(_a254, 0))
local _a256 = {}
for _a257, _a258 in ipairs(_a14) do
local _a259 = _a255[_a258] or 0
_a256[#_a256 + 1] = { id = _a258, tier = _a259, cost = _a23(_a258, _a259) }
end
table.sort(_a256, function(_a260, _a261)
return (_a260.cost or math.huge) < (_a261.cost or math.huge)
end)
for _a262, _a263 in ipairs(_a256) do
_a6(("  %-22s Lv%-3s 다음 %-14s %s"):format(
_a263.id, tostring(_a263.tier), _a263.cost and _a7(_a263.cost, 0) or "?",
(_a263.cost and _a263.cost <= _a254) and "← 구매가능" or ""))
end
_a97("log")
end },
{ label = "지금 1회 업글", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.upgrade = true _a24() _a12.upgrade = false _a97("log") end)
end },
})
local _a264, _a265 = _a130(_a213, "타워 개별 업글", nil)
_a140(_a265, "towerup", function()
_a54("towerup", function() return _a10.UpgradeInterval end, _a53, "타워업글")
end)
end
do
local _a266, _a267 = _a130(_a213, "자동 뽑기", nil)
_a140(_a267, "hatch", function()
_a54("hatch", function() return _a10.HatchInterval end, _a36, "뽑기")
end)
_a151(_a266, {
{ label = "주기", value = _a10.HatchInterval, onChange = function(_a268)
local _a269 = tonumber(_a268) if _a269 and _a269 >= 1 then _a10.HatchInterval = _a269 end
end },
{ label = "한 번에 최대", value = _a10.HatchMax, onChange = function(_a270)
local _a271 = tonumber(_a270) if _a271 and _a271 >= 1 then _a10.HatchMax = math.floor(_a271) end
end },
})
_a151(_a266, {
{ label = "예비금", value = _a10.HatchReserve, onChange = function(_a272)
local _a273 = tonumber(_a272) if _a273 and _a273 >= 0 then _a10.HatchReserve = _a273
_a6("[설정] 뽑기 예비금 " .. _a7(_a273, 0)) end
end },
{ label = "알 번호 (0=자동)", value = _a10.HatchEggNum, onChange = function(_a274)
local _a275 = tonumber(_a274) if _a275 and _a275 >= 0 and _a275 <= 12 then
_a10.HatchEggNum = math.floor(_a275)
table.clear(_a11)
_a6("[설정] 알 번호 " .. (_a275 == 0 and "자동" or _a275)) end
end },
})
_a160(_a266, {
{ label = "뽑기 현황 보기", col = _a55.accent, fn = function()
local _a276 = _a35()
_a13.sun = _a276.sun
_a6("")
_a6("──── 뽑기 현황 ────")
_a6("  알 등급     " .. _a276.id)
_a6("  알 uid      " .. tostring(_a276.uid))
_a6("  개당 비용   " .. (_a276.cost and _a7(_a276.cost, 0) or "?"))
_a6("  Sunflowers  " .. _a7(_a276.sun, 0))
_a6("  예비금      " .. _a7(_a10.HatchReserve, 0))
_a6("  지금 가능   " .. _a276.canBuy .. "회")
_a6("")
_a6("  월드의 알 " .. _a276.eggCount .. "개")
for _a277, _a278 in ipairs(_a276.eggs) do
if _a277 > 5 then break end
_a6(("    %s  거리 %s"):format(_a278.uid, _a7(_a278.dist)))
end
_a6("")
_a6("  누적 뽑기   " .. _a13.hatched .. "회")
_a97("log")
end },
{ label = "지금 1회 실행", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.hatch = true _a36() _a12.hatch = false _a97("log") end)
end },
})
end
do
local _a279, _a280 = _a130(_a213, "럭 상시 최대 유지", nil)
_a140(_a280, "luck", function()
_a54("luck", function() return _a10.LuckInterval end, _a40, "럭")
end)
_a151(_a279, {
{ label = "주기", value = _a10.LuckInterval, onChange = function(_a281)
local _a282 = tonumber(_a281) if _a282 and _a282 >= 60 then _a10.LuckInterval = _a282 end
end },
{ label = "예비금", value = _a10.LuckReserve, onChange = function(_a283)
local _a284 = tonumber(_a283) if _a284 and _a284 >= 0 then _a10.LuckReserve = _a284 end
end },
})
_a151(_a279, {
{ label = "최소 부족분", value = _a10.LuckMinTopUp, onChange = function(_a285)
local _a286 = tonumber(_a285) if _a286 and _a286 >= 0 then _a10.LuckMinTopUp = _a286 end
end },
})
for _a287, _a288 in ipairs(_a37) do
_a170(_a279, _a288,
function() return _a10.LuckBoosts[_a288] end,
function(_a289) _a10.LuckBoosts[_a288] = _a289 end)
end
_a160(_a279, {
{ label = "럭 현황 보기", col = _a55.accent, fn = function()
local _a290 = _a38()
_a13.sun = _a290.sun
_a6("")
_a6("──── 이벤트 럭 ────")
_a6("  머신 활성   " .. (_a290.enabled and "O" or "X"))
_a6("  최대 시간   " .. _a39(_a290.maxSec))
_a6("  Sunflowers  " .. _a7(_a290.sun, 0))
_a6("")
for _a291, _a292 in ipairs(_a290.rows) do
_a6(("  %-12s %-14s 부족 %-14s 필요 %s개%s"):format(
_a292.rarity, _a39(_a292.left), _a39(_a292.deficit), _a7(_a292.need, 0),
_a292.on and "" or "   (꺼짐)"))
end
_a6("")
_a6("  효과 : 비활성 0.5배 → 활성 1.0배 (2배)")
_a97("log")
end },
{ label = "지금 1회 충전", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.luck = true _a40() _a12.luck = false _a97("log") end)
end },
})
end
do
local _a293, _a294 = _a130(_a213, "자동 씨앗 교체", nil)
_a140(_a294, "crop", function()
_a54("crop", function() return _a10.CropInterval end, _a29, "씨앗")
end)
_a151(_a293, {
{ label = "주기", value = _a10.CropInterval, onChange = function(_a295)
local _a296 = tonumber(_a295) if _a296 and _a296 >= 5 then _a10.CropInterval = _a296 end
end },
{ label = "갈아엎기 배수", value = _a10.CropMargin, onChange = function(_a297)
local _a298 = tonumber(_a297) if _a298 and _a298 >= 1 then _a10.CropMargin = _a298 _a6("[설정] 작물 배수 " .. _a298) end
end },
})
_a170(_a293, "성장중 건너뛰기",
function() return _a10.SkipUnhatched end,
function(_a299) _a10.SkipUnhatched = _a299 end)
_a160(_a293, {
{ label = "밭 현황 보기", col = _a55.accent, fn = function()
local _a300, _a301 = _a15()
if not _a301 then _a6("[씨앗] 밭 없음") _a97("log") return end
local _a302, _a303 = _a26(_a301), _a25()
_a6("")
_a6("──── 밭 현황 ────")
_a6("보유 씨앗 (기대 초당수익 순)")
for _a304, _a305 in ipairs(_a303) do
_a6(("  %-10s %-8s ×%-6s  기대 %s/s"):format(
tostring(_a305.id), tostring(_a305.vr or "-"), tostring(_a305.am), _a7(_a305.exp)))
end
local _a306, _a307, _a308, _a309, _a310 = 0, 0, 0, 0, 0
local _a311 = _a303[1]
local _a312 = _a311 and _a311.exp or 0
_a6("")
_a6("심어진 작물")
local _a313 = 0
for _a314, _a315 in pairs(_a302) do
_a306 += 1
local _a316 = _a28(_a315) or 0
_a307 += _a316
if _a27(_a315) then _a309 += 1
elseif _a312 > _a316 * _a10.CropMargin then _a308 += 1
else _a310 += 1 end
_a313 += 1
if _a313 <= 20 then
_a6(("  칸%-4s %-20s %s/s%s"):format(tostring(_a314),
tostring(rawget(_a315, "sp") or "?"), _a7(_a316),
_a27(_a315) and "  (자라는 중)" or ""))
end
end
if _a306 > 20 then _a6("  ... (" .. (_a306 - 20) .. "칸 더)") end
_a6("")
_a6(("총 %d칸 / 합계 %s per sec"):format(_a306, _a7(_a307)))
_a6(("갈아엎기 대상 %d / 유지 %d / 자라는 중 %d"):format(_a308, _a310, _a309))
_a97("log")
end },
{ label = "지금 1회 실행", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.crop = true _a29() _a12.crop = false _a97("log") end)
end },
})
end
do
local _a317, _a318 = _a130(_a213, "자동 확장", nil)
_a140(_a318, "expand", function()
_a54("expand", function() return _a10.ExpandInterval end, _a32, "확장")
end)
_a151(_a317, {
{ label = "주기", value = _a10.ExpandInterval, onChange = function(_a319)
local _a320 = tonumber(_a319) if _a320 and _a320 >= 5 then _a10.ExpandInterval = _a320 end
end },
{ label = "밭칸 스캔", value = _a10.MaxBedScan, onChange = function(_a321)
local _a322 = tonumber(_a321) if _a322 and _a322 >= 1 then _a10.MaxBedScan = math.floor(_a322) end
end },
})
_a160(_a317, {
{ label = "확장 현황 보기", col = _a55.accent, fn = function()
local _a323, _a324, _a325, _a326 = _a15()
if not _a324 then _a6("[확장] 밭 없음") _a97("log") return end
local _a327 = _a21()
_a13.sun = _a327
local _a328 = _a30(true)
_a6("")
_a6("──── 확장 현황 ────")
_a6("Sunflowers = " .. _a7(_a327, 0))
_a6("")
_a6("레인 " .. tostring(_a326) .. "개 열림")
local _a329 = {}
for _a330 in pairs(_a328) do _a329[#_a329 + 1] = tonumber(_a330) or _a330 end
table.sort(_a329, function(_a331, _a332) return tostring(_a331) < tostring(_a332) end)
for _a333, _a334 in ipairs(_a329) do
local _a335 = _a328[_a334] or _a328[tostring(_a334)]
local _a336 = tonumber(_a334) or 0
local _a337 = (_a336 == (tonumber(_a326) or 0) + 1)
and ((tonumber(_a335) or math.huge) <= _a327 and "  ← 지금 오픈 가능" or "  ← 다음 (돈 부족)")
or (_a336 <= (tonumber(_a326) or 0) and "  (열림)" or "")
_a6(("  레인 %-3s %s%s"):format(tostring(_a334), _a7(tonumber(_a335) or 0, 0), _a337))
end
local _a338 = _a31(_a324)
_a6("")
_a6("잠긴 밭칸 " .. #_a338 .. "개 (싼 순 8개)")
for _a339 = 1, math.min(8, #_a338) do
local _a340 = _a338[_a339]
_a6(("  칸 %-4s %s%s"):format(_a340.id, _a340.cost and _a7(_a340.cost, 0) or "?",
(_a340.cost and _a340.cost <= _a327) and "  ← 오픈 가능" or ""))
end
if #_a338 == 0 then _a6("  (전부 열려 있음)") end
_a97("log")
end },
{ label = "지금 1회 실행", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.expand = true _a32() _a12.expand = false _a97("log") end)
end },
})
end
do
local _a341, _a342 = _a130(_a213, "자동 리버스", nil)
_a140(_a342, "rebirth", function()
_a54("rebirth", function() return _a10.RebirthInterval end, _a34, "리버스")
end)
_a151(_a341, {
{ label = "주기", value = _a10.RebirthInterval, onChange = function(_a343)
local _a344 = tonumber(_a343) if _a344 and _a344 >= 10 then _a10.RebirthInterval = _a344 end
end },
})
_a160(_a341, {
{ label = "리버스 현황 보기", col = _a55.accent, fn = function()
local _a345 = _a33()
_a6("")
_a6("──── 리버스 현황 ────")
if not _a345 then _a6("  밭 없음") _a97("log") return end
_a6(("  현재 리버스   %d회  (최대 %s)"):format(_a345.regrows, tostring(_a345.cap)))
_a6(("  레인          %d / 7 %s"):format(_a345.lanes, _a345.lanes >= 7 and "OK" or "부족"))
_a6(("  코인보스      %d / %d %s"):format(_a345.kills, _a345.need,
_a345.kills >= _a345.need and "OK" or "부족"))
_a6("")
_a6(_a345.ready and "  ★ 지금 리버스 가능" or ("  대기 — " .. tostring(_a345.reason)))
_a97("log")
end },
{ label = "지금 1회 리버스", col = _a55.bad, fn = function()
task.spawn(function() _a12.rebirth = true _a34() _a12.rebirth = false _a97("log") end)
end },
})
end
local _a346 = _a114("main", "메인 게임", 30)
do
local _a347, _a348 = _a130(_a346, "올 자동", nil)
local _a349 = _a56("Frame", {
Size = UDim2.new(1, 0, 0, 108), BackgroundColor3 = _a55.cardHi,
BorderSizePixel = 0, LayoutOrder = _a125(),
}, _a347)
_a63(_a349, 6)
_a70(_a349, 8)
local _a350 = _a56("TextLabel", {
Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
Font = Enum.Font.Code, TextSize = 12, TextColor3 = _a55.text,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Text = "정지", RichText = true,
}, _a349)
task.spawn(function()
while _a73 and _a73.Parent do
local _a351 = _a42.ctl.now
local _a352 = _a12.auto and "🟢" or "⚪"
local _a353 = _a351.act or "-"
if _a351.detail and _a351.detail ~= "" then _a353 = _a353 .. "  " .. _a351.detail end
_a350.Text = table.concat({
_a352 .. " " .. (_a12.auto and (_a351.step or "-") or "정지"),
"▸ " .. _a353,
"목표 " .. (_a351.goal or "-") .. (_a351.prog ~= "" and ("   " .. _a351.prog) or ""),
"1.리버스 " .. (_a42.auto.rebNote or "-"),
"2.존해금 " .. (_a42.auto.zoneNote or "-"),
"파밍대상 " .. tostring(_a42.auto.farmZone or "-") .. "   현재 " .. tostring(_a42.auto.hereZone or "-"),
}, "\n")
task.wait(0.2)
end
end)
function _a42.auto.start()
for _a354, _a355 in ipairs(_a42.auto.STEPS) do _a12[_a355.run] = false end
for _a356, _a357 in ipairs(_a42.auto.SIDE) do _a12[_a357.run] = false end
_a12.petspd = true
_a12.rewatch = true
_a137()
_a54("auto", function() return _a10.AutoInterval end, _a42.auto.master, "자동")
end
_a140(_a348, "auto", _a42.auto.start)
_a151(_a347, {
{ label = "주기", value = _a10.AutoInterval, onChange = function(_a358)
local _a359 = tonumber(_a358) if _a359 and _a359 >= 1 then _a10.AutoInterval = _a359 end
end },
{ label = "정체 판정(초)", value = _a10.PursueStallSec, onChange = function(_a360)
local _a361 = tonumber(_a360) if _a361 and _a361 >= 10 then _a10.PursueStallSec = _a361 end
end },
})
_a151(_a347, {
{ label = "운 퀘 최소 알 개수", value = _a10.HatchMinAfford, onChange = function(_a362)
local _a363 = tonumber(_a362) if _a363 and _a363 >= 1 then _a10.HatchMinAfford = math.floor(_a363) end
end },
{ label = "더 버는 시간(초)", value = _a10.MoneyDwell, onChange = function(_a364)
local _a365 = tonumber(_a364) if _a365 and _a365 >= 0 then _a10.MoneyDwell = _a365 end
end },
})
_a151(_a347, {
{ label = "부화 한 번에(초)", value = _a10.HatchBudget, onChange = function(_a366)
local _a367 = tonumber(_a366) if _a367 and _a367 >= 3 then _a10.HatchBudget = _a367 end
end },
})
_a151(_a347, {
{ label = "이동 방식", value = _a10.TpMode, onChange = function(_a368)
_a368 = tostring(_a368 or ""):lower()
if _a368 == "instant" or _a368 == "glide" or _a368 == "walk" then _a10.TpMode = _a368 end
end },
{ label = "glide 속도", value = _a10.TpSpeed, onChange = function(_a369)
local _a370 = tonumber(_a369) if _a370 and _a370 >= 16 then _a10.TpSpeed = _a370 end
end },
})
_a170(_a347, "차단 화면에 실제 클릭까지 시도",
function() return _a10.ScreenRealClick end,
function(_a371) _a10.ScreenRealClick = _a371 end)
_a170(_a347, "퀘스트 없을 때도 알 까기",
function() return _a10.IdleHatch end,
function(_a372) _a10.IdleHatch = _a372 end)
_a170(_a347, "존 해금·리버스는 퀘스트 끝나고",
function() return _a10.HoldZoneForQuest end,
function(_a373) _a10.HoldZoneForQuest = _a373 end)
for _a374, _a375 in ipairs(_a42.auto.STEPS) do
local _a376 = _a375.key
_a170(_a347, "  " .. _a374 .. ". " .. _a375.label,
function() return _a10.StepOn[_a376] end,
function(_a377) _a10.StepOn[_a376] = _a377 end)
end
for _a378, _a379 in ipairs(_a42.auto.SIDE) do
local _a380 = _a379.key
_a170(_a347, "  · " .. _a379.label .. " (순위 밖)",
function() return _a10.StepOn[_a380] end,
function(_a381) _a10.StepOn[_a380] = _a381 end)
end
_a160(_a347, {
{ label = "지금 상태", col = _a55.accent, fn = function()
_a6("")
_a6("──── 올 자동 ────")
_a6("  " .. (_a12.auto and "돌아가는 중" or "정지") ..
(_a42.auto.step and ("   지금: " .. _a42.auto.step) or ""))
local _a382, _a383 = _a42.quest.bestDepActive()
_a6("  현재 존 " .. tostring(_a42.move.curZone()) .. " / 최고 존 " .. tostring(_a42.move.bestZone()))
if _a382 then
_a6("  ⏸ 존해금·리버스 보류 중 — " .. tostring(_a383 and _a383.title))
else
_a6("  존해금·리버스 진행 가능")
end
_a6("")
_a6("  먼저 (순위 밖):")
for _a384, _a385 in ipairs(_a42.auto.SIDE) do
_a6(("      %-16s %s"):format(_a385.label, _a10.StepOn[_a385.key] and "ON" or "off"))
end
_a6("  우선순위:")
for _a386, _a387 in ipairs(_a42.auto.STEPS) do
_a6(("    %d. %-16s %s%s"):format(_a386, _a387.label,
_a10.StepOn[_a387.key] and "ON" or "off",
_a387.hold and "   (퀘스트 붙잡는 중엔 보류)" or ""))
end
_a6("")
_a6("  세이브")
local _a388 = _a8.Save
_a6("    Library.Client.Save : " .. (_a388 and "로드됨" or "★ 없음"))
if _a388 then
local _a389, _a390 = pcall(_a388.Get)
_a6("    Get()        : " .. (_a389 and type(_a390) or ("에러 " .. tostring(_a390))))
local _a391, _a392 = pcall(_a388.Get, _a4)
_a6("    Get(LP)      : " .. (_a391 and type(_a392) or ("에러 " .. tostring(_a392))))
if rawget(_a388, "GetSaves") then
local _a393, _a394 = pcall(_a388.GetSaves)
if _a393 and type(_a394) == "table" then
local _a395 = 0
for _a396 in pairs(_a394) do
_a395 += 1
if _a395 <= 3 then _a6("      키: " .. tostring(_a396)
.. (_a396 == _a4 and "   ← 내 LocalPlayer" or "")) end
end
_a6("    GetSaves()   : " .. _a395 .. "개")
else
_a6("    GetSaves()   : 에러 " .. tostring(_a394))
end
end
local _a397 = _a43()
if _a397 then
local _a398 = rawget(_a397, "Goals")
_a6("    → 읽기 성공. Rebirths " .. tostring(rawget(_a397, "Rebirths"))
.. " / Goals " .. (type(_a398) == "table" and #_a398 or "없음"))
else
_a6("    → ★ 어떤 방법으로도 못 읽음")
end
end
_a6("")
_a6("  마지막 바퀴 (" .. tostring(_a42.auto.passN or 0) .. "번째)")
if _a42.auto.lastPassAt then
_a6(("    %.0f초 전"):format(os.clock() - _a42.auto.lastPassAt))
else
_a6("    아직 한 바퀴도 안 돎 — 루프가 안 돌고 있습니다")
end
for _a399, _a400 in ipairs(_a42.auto.lastTrace or {}) do _a6("    " .. _a400) end
_a97("log")
end },
{ label = "화면 넘기기 진단", col = _a55.warn, fn = function()
task.spawn(function()
_a6("")
_a6("──── 보상 화면 ────")
local _a401 = _a41.Vars
_a6("  Library.Variables : " .. (_a401 and "로드됨" or "없음"))
if _a401 then
_a6("    IsRebirthing = " .. tostring(rawget(_a401, "IsRebirthing")))
_a6("    IsRankingUp  = " .. tostring(rawget(_a401, "IsRankingUp")))
_a6("    OpeningEgg   = " .. tostring(rawget(_a401, "OpeningEgg")))
end
_a6("  debug.info     : " .. tostring(type(debug) == "table" and type(debug.info) == "function"))
_a6("  getgc          : " .. tostring(type(getgc) == "function"))
_a6("  debug.setupvalue: " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
local _a402 = _a4:FindFirstChildOfClass("PlayerGui")
if _a402 then
_a6("  떠 있는 차단 화면:")
local _a403 = false
for _a404, _a405 in ipairs(_a42.screen.BLOCKERS) do
local _a406 = _a402:FindFirstChild(_a405[1])
_a6(("    %-14s %s"):format(_a405[1],
_a406 and (_a406.Enabled and "★ 켜짐" or "꺼짐") or "없음"))
if _a406 and _a406.Enabled then _a403 = true end
end
if not _a403 then _a6("    (없음)") end
end
if type(getgc) == "function" and type(debug) == "table" and debug.info then
_a6("")
_a6("  Rebirth/RankUp 스크립트의 클로저 시그니처:")
local _a407, _a408 = {}, 0
for _a409, _a410 in ipairs({ true, false }) do
local _a411, _a412 = pcall(getgc, _a410)
if _a411 then
for _a413, _a414 in ipairs(_a412) do
if type(_a414) == "function" and _a408 < 25 then
local _a415, _a416 = pcall(debug.info, _a414, "s")
if _a415 and type(_a416) == "string"
and (_a416:find("Rebirth", 1, true) or _a416:find("Rank Up", 1, true)) then
local _a417, _a418 = pcall(debug.info, _a414, "a")
if _a417 then
local _a419 = {}
for _a420 = 1, 16 do
local _a421, _a422 = pcall(debug.getupvalue, _a414, _a420)
if not _a421 then break end
_a419[_a420] = type(_a422)
end
local _a423 = ("인자%d | %s"):format(_a418 or -1,
#_a419 > 0 and table.concat(_a419, ",") or "(없음)")
if not _a407[_a423] then
_a407[_a423] = true
_a408 += 1
_a6("    " .. _a423)
end
end
end
end
end
end
end
if _a408 == 0 then _a6("    (하나도 못 찾음)") end
end
for _a424, _a425 in ipairs({ "reward", "egg", "mastery", "card" }) do
_a42.screen._sig = nil
local _a426 = _a42.screen.findSignalFns(_a425)
_a6("")
_a6(("  [%s] 찾은 함수 %d개"):format(_a425, #_a426))
for _a427, _a428 in ipairs(_a426) do
_a6(("    %s%s"):format(_a428.exact and "★정확일치 " or "", tostring(_a428.src)))
_a6(("       upvalue %d개 : %s"):format(_a428.n or 0, tostring(_a428.sig)))
end
if #_a426 == 0 then
_a6("    (getgc 로 그 스크립트의 클로저를 못 찾음)")
end
local _a429, _a430 = _a42.screen.signal(_a425)
_a6(("    upvalue 신호 : %s (%s개 세팅)"):format(tostring(_a429), tostring(_a430)))
local _a431 = _a42.screen.SIGNAL[_a425]
_a6(("    게임내 입력발동 : %s"):format(
tostring(_a42.screen.pressInGame(_a431 and _a431.pats or {}))))
end
_a6("")
_a6("  감시 루프 RUN.rewatch = " .. tostring(_a12.rewatch))
_a97("log")
end)
end },
{ label = "한 바퀴만", col = _a55.cardHi, fn = function()
task.spawn(function()
_a12.auto = true _a42.auto.master() _a12.auto = false _a97("log")
end)
end },
{ label = "자동 점검", col = _a55.warn, fn = function()
task.spawn(function()
_a6("")
_a6("════ 올 자동 점검 ════")
_a6("  RUN.auto = " .. tostring(_a12.auto))
local _a432 = {}
for _a433, _a434 in ipairs(_a42.auto.SIDE) do
_a432[#_a432 + 1] = _a434.key .. "=" .. tostring(_a10.StepOn[_a434.key])
end
for _a435, _a436 in ipairs(_a42.auto.STEPS) do
_a432[#_a432 + 1] = _a436.key .. "=" .. tostring(_a10.StepOn[_a436.key])
end
_a6("  단계 ON/OFF : " .. table.concat(_a432, "  "))
_a6("  lockGoal    : " .. (_a42.ctl.lockGoal and tostring(_a42.ctl.lockGoal.q.title) or "없음"))
local _a437, _a438 = _a42.quest.bestDepActive()
_a6("  보류중?     : " .. tostring(_a437) .. (_a438 and ("  ← " .. tostring(_a438.title)) or ""))
_a6("  리모트      : 존 " .. (_a41.R_Zone and "O" or "X")
.. " / 리버스 " .. (_a41.R_Reb and "O" or "X"))
_a6("")
_a6("  ── 존 해금 판정 ──")
local _a439 = _a46()
if not _a439 then
_a6("    zoneStatus() = nil  ← 다음 존을 못 구함")
local _a440 = _a41.Zone and rawget(_a41.Zone, "GetNextZone")
if _a440 then
local _a441, _a442, _a443 = pcall(_a41.Zone.GetNextZone)
_a6("    GetNextZone → ok=" .. tostring(_a441)
.. " / " .. tostring(_a442) .. " / " .. tostring(_a443))
end
if _a41.Zone and rawget(_a41.Zone, "HasCompletedNextZoneQuests") then
local _a444, _a445 = pcall(_a41.Zone.HasCompletedNextZoneQuests)
_a6("    존 퀘스트 완료? " .. (_a444 and tostring(_a445) or ("에러 " .. tostring(_a445))))
end
else
_a6("    다음 존 : " .. tostring(_a439.id))
_a6(("    가격 %s %s / 보유 %s → %s"):format(
_a7(_a439.price or 0, 0), tostring(_a439.currency), _a7(_a439.have, 0),
_a439.ok and "지금 살 수 있음" or "부족"))
end
_a6("")
_a6("  ── 리버스 판정 ──")
local _a446 = _a51()
if not _a446 then _a6("    세이브 못 읽음")
else
_a6(("    현재 %d → 다음 %d"):format(_a446.current, _a446.nextN))
_a6("    최근 사유 : " .. tostring(_a42.auto.rebNote or "-"))
end
_a6("")
_a6("  ── 직전 바퀴 기록 ──")
if _a42.auto.lastTrace and #_a42.auto.lastTrace > 0 then
for _a447, _a448 in ipairs(_a42.auto.lastTrace) do _a6("    " .. _a448) end
_a6(("    (%.0f초 전)"):format(os.clock() - (_a42.auto.lastPassAt or os.clock())))
else
_a6("    아직 한 바퀴도 안 돌았음")
end
_a97("log")
end)
end },
})
local _a449, _a450 = _a130(_a346, "펫 이동속도", nil)
_a140(_a450, "petspd", function()
_a54("petspd", function() return 0.4 end, _a42.item.applyPetSpeed, "펫속도")
end)
_a151(_a449, {
{ label = "배수", value = _a10.PetSpeedMult, onChange = function(_a451)
local _a452 = tonumber(_a451) if _a452 and _a452 >= 1 then _a10.PetSpeedMult = _a452 end
end },
{ label = "기본 계수 (원래 0.45)", value = _a10.PetSpeedBase, onChange = function(_a453)
local _a454 = tonumber(_a453) if _a454 and _a454 > 0 then _a10.PetSpeedBase = _a454 end
end },
})
_a160(_a449, {
{ label = "지금 적용 / 확인", col = _a55.accent, fn = function()
local _a455, _a456 = _a42.item.applyPetSpeed()
_a6("")
_a6("──── 펫 이동속도 ────")
_a6("  PlayerPet 모듈 : " .. (_a41.PlayerPet and "로드됨" or "없음"))
_a6(("  적용된 펫 %d마리  (배수 %s / 계수 %s)"):format(
_a455, tostring(_a10.PetSpeedMult), tostring(_a10.PetSpeedBase)))
if _a456 then _a6("  " .. tostring(_a456)) end
if _a455 == 0 then _a6("  펫을 장착하고 다시 눌러보세요") end
_a97("log")
end },
})
_a54("petspd", function() return 0.4 end, _a42.item.applyPetSpeed, "펫속도")
_a54("rewatch", function() return 1 end, function()
_a42.screen.watchTick = (_a42.screen.watchTick or 0) + 1
_a42.egg.watchStuck()
if _a42.screen.dismissBusy then return end
local _a457, _a458 = _a42.screen.rewardScreenUp()
if _a457 and _a42.screen.screenGaveUp and (os.clock() - _a42.screen.screenGaveUp) < 30 then
return
end
if _a457 then
if _a42.screen.lastBlocker ~= _a458 then
_a42.screen.lastBlocker = _a458
_a6("[화면] " .. tostring(_a458) .. " 화면 감지 — 넘기는 중")
end
_a42.screen.dismissRewardScreens(20)
end
end, "보상화면")
local _a459, _a460 = _a130(_a346, "자동 파밍 유지", nil)
_a140(_a460, "farm", function()
_a54("farm", function() return _a10.FarmInterval end, _a45, "파밍")
end)
_a151(_a459, {
{ label = "주기", value = _a10.FarmInterval, onChange = function(_a461)
local _a462 = tonumber(_a461) if _a462 and _a462 >= 3 then _a10.FarmInterval = _a462 end
end },
})
local _a463, _a464 = _a130(_a346, "자동 존 해금", nil)
_a140(_a464, "zone", function()
_a54("zone", function() return _a10.ZoneInterval end, _a47, "존")
end)
_a151(_a463, {
{ label = "주기", value = _a10.ZoneInterval, onChange = function(_a465)
local _a466 = tonumber(_a465) if _a466 and _a466 >= 3 then _a10.ZoneInterval = _a466 end
end },
})
_a160(_a463, {
{ label = "다음 존 보기", col = _a55.accent, fn = function()
local _a467 = _a46()
_a6("")
if not _a467 then _a6("[존] 다음 존 없음 (최대 도달?)")
else
_a6("──── 다음 존 ────")
_a6("  " .. tostring(_a467.id))
_a6("  가격 " .. _a7(_a467.price or 0, 0) .. " " .. tostring(_a467.currency))
_a6("  보유 " .. _a7(_a467.have, 0))
_a6("  " .. (_a467.ok and "지금 해금 가능" or "부족"))
end
_a97("log")
end },
{ label = "지금 1회", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.zone = true _a47() _a12.zone = false _a97("log") end)
end },
})
local _a468, _a469 = _a130(_a346, "자동 부화", nil)
_a140(_a469, "mhatch", function()
_a54("mhatch", function() return _a10.MainHatchInterval end, _a50, "부화")
end)
_a151(_a468, {
{ label = "주기", value = _a10.MainHatchInterval, onChange = function(_a470)
local _a471 = tonumber(_a470) if _a471 and _a471 >= 1 then _a10.MainHatchInterval = _a471 end
end },
{ label = "한 번에 최대", value = _a10.MainHatchMax, onChange = function(_a472)
local _a473 = tonumber(_a472) if _a473 and _a473 >= 1 then _a10.MainHatchMax = math.floor(_a473) end
end },
})
_a151(_a468, {
{ label = "예비금", value = _a10.MainHatchReserve, onChange = function(_a474)
local _a475 = tonumber(_a474) if _a475 and _a475 >= 0 then _a10.MainHatchReserve = _a475 end
end },
{ label = "알 ID (비우면 자동)", value = _a10.MainEggId, onChange = function(_a476)
_a10.MainEggId = _a476 or ""
end },
})
_a151(_a468, {
{ label = "알 인식 거리", value = _a10.EggRange, onChange = function(_a477)
local _a478 = tonumber(_a477) if _a478 and _a478 >= 5 then _a10.EggRange = _a478 end
end },
})
_a170(_a468, "새 맵 열리면 잠긴 알 자동 해금",
function() return _a10.AutoUnlockEgg end,
function(_a479) _a10.AutoUnlockEgg = _a479 end)
_a170(_a468, "게임 내장 오토해치 사용 (기본 끔)",
function() return _a10.UseAutoHatch end,
function(_a480) _a10.UseAutoHatch = _a480 if not _a480 then _a42.egg.autoHatchOff() end end)
_a170(_a468, "까는 화면 자동으로 넘기기 (신호)",
function() return _a10.HatchClick end,
function(_a481) _a10.HatchClick = _a481 end)
_a160(_a468, {
{ label = "잠긴 알 보기", col = _a55.accent, fn = function()
local _a482, _a483, _a484 = _a42.egg.lockedEggs()
_a6("")
_a6("──── 알 해금 현황 ────")
_a6(("  해금 가능 최대 : #%d   /   현재 해금한 최대 : #%d"):format(_a483, _a484))
_a6("  해금 리모트 : " .. (_a41.R_EggUn and "있음" or "없음"))
if #_a482 == 0 then
_a6("  풀 수 있는 알이 없음 (다 풀었거나 존을 더 사야 함)")
else
_a6("  아직 안 푼 알 " .. #_a482 .. "개:")
for _a485, _a486 in ipairs(_a482) do
_a6(("    #%-3d %s"):format(_a486.num, _a486.id))
if _a485 >= 20 then _a6("    ...") break end
end
end
_a97("log")
end },
{ label = "부화 진단", col = _a55.warn, fn = function()
task.spawn(function()
_a6("")
_a6("──── 부화 진단 ────")
local _a487, _a488, _a489, _a490 = _a48()
_a6("  대상 알   : " .. tostring(_a487))
if not _a487 then _a6("  (오픈한 알이 없음)") _a97("log") return end
local _a491 = _a488 and tonumber(rawget(_a488, "eggNumber"))
_a6("  알 번호   : " .. tostring(_a491) .. "   오픈함? " .. tostring(_a42.egg.eggUnlocked(_a491)))
_a6("  거리      : " .. (_a489 and ("%.0f (사거리 안)"):format(_a489)
or ((_a490 and ("%.0f (사거리 %d 밖)"):format(_a490, _a10.EggRange)) or "받침대 못 찾음")))
local _a492 = _a488 and rawget(_a488, "currency") or "?"
_a6("  통화      : " .. tostring(_a492) .. "   보유 " .. _a7(_a44(_a492), 0))
if type(_a41.CalcEgg) == "function" then
local _a493, _a494 = pcall(_a41.CalcEgg, _a488)
_a6("  CalcEggPricePlayer : " .. (_a493 and tostring(_a494) or ("에러 " .. tostring(_a494))))
end
if type(_a41.CalcEggB) == "function" then
local _a495, _a496 = pcall(_a41.CalcEggB, _a488)
_a6("  CalcEggPrice       : " .. (_a495 and tostring(_a496) or ("에러 " .. tostring(_a496))))
end
if _a41.Egg then
for _a497, _a498 in ipairs({ "GetMaxHatch", "ComputeDebounce", "GetHighestEggNumberAvailable" }) do
if rawget(_a41.Egg, _a498) then
local _a499, _a500 = pcall(_a41.Egg[_a498], _a488)
_a6(("  %-28s : %s"):format(_a498, _a499 and tostring(_a500) or ("에러 " .. tostring(_a500))))
end
end
end
_a6("  OpeningEgg      : " .. tostring(_a41.Vars and rawget(_a41.Vars, "OpeningEgg")))
if _a41.Hatch then
for _a501, _a502 in ipairs({ "IsHatching", "GetEggAmount" }) do
if rawget(_a41.Hatch, _a502) then
local _a503, _a504 = pcall(_a41.Hatch[_a502])
_a6(("  %-15s : %s"):format(_a502, _a503 and tostring(_a504) or ("에러 " .. tostring(_a504))))
end
end
if rawget(_a41.Hatch, "GetEggDirectory") then
local _a505, _a506 = pcall(_a41.Hatch.GetEggDirectory)
_a6("  세팅된 알       : " .. (_a505 and _a506 and tostring(rawget(_a506, "_id")) or "없음"))
end
end
_a6("  ▶ SetupEgg 시도")
_a42.egg._ahEgg = nil
_a42.egg.autoHatchOn(_a487, 1)
if _a41.Hatch and rawget(_a41.Hatch, "IsHatching") then
local _a507, _a508 = pcall(_a41.Hatch.IsHatching)
_a6("    IsHatching 이후 : " .. (_a507 and tostring(_a508) or ("에러 " .. tostring(_a508))))
_a6("    " .. ((_a507 and _a508) and "→ 클릭 없이 넘어갑니다"
or "→ SetupEgg 안 먹음. 클릭 대체가 필요합니다"))
end
_a6("  신호 가능 : getgc " .. tostring(type(getgc) == "function")
.. " / debug.setupvalue " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
_a6("")
_a6("  ▶ 1개로 실제 호출")
local _a509, _a510
local _a511 = pcall(function() _a509, _a510 = _a9.R_EGG:InvokeServer(_a487, 1) end)
_a6("    호출성공 : " .. tostring(_a511))
_a6("    반환1    : " .. tostring(_a509))
_a6("    반환2    : " .. tostring(_a510))
_a97("log")
end)
end },
{ label = "지금 전부 해금", col = _a55.good, fn = function()
task.spawn(function()
_a6("")
local _a512, _a513 = _a42.egg.unlockEggs(true)
_a6(_a512 > 0 and ("[해금] %d개 완료"):format(_a512)
or ("[해금] 0개" .. (_a513 and (" — " .. tostring(_a513)) or "")))
_a97("log")
end)
end },
})
_a160(_a468, {
{ label = "알 현황 보기", col = _a55.accent, fn = function()
local _a514 = _a49()
_a6("")
if not _a514 then _a6("[부화] 알을 못 찾음")
else
_a6("──── 메인 알 ────")
_a6("  " .. tostring(_a514.id))
_a6("  가격 " .. (_a514.price and _a7(_a514.price, 0) or "?") .. " " .. tostring(_a514.currency))
_a6("  보유 " .. _a7(_a514.have, 0))
_a6("  한 번에 " .. _a514.maxN .. "개까지")
_a6("  지금 가능 " .. _a514.canBuy .. "회")
if _a514.inRange then
_a6(("  거리 %.0f 스터드 — 부화 가능"):format(_a514.dist))
else
_a6(("  사거리(%d) 안에 알 없음. 가장 가까운 알 %s스터드"):format(
_a10.EggRange, _a514.nearest and ("%.0f"):format(_a514.nearest) or "?"))
_a6("  → 알 앞으로 걸어가야 부화됩니다")
end
end
_a6("")
_a6("──── 주변 알 (가까운 순 10개) ────")
local _a515 = _a42.egg.eggStands()
for _a516 = 1, math.min(10, #_a515) do
local _a517 = _a515[_a516]
_a6(("  %6.0f  #%-3d %-24s %s"):format(
_a517.dist, _a517.num, _a517.id, _a42.egg.eggUnlocked(_a517.num) and "오픈함" or "잠김"))
end
if #_a515 == 0 then _a6("  (못 찾음)") end
_a97("log")
end },
{ label = "지금 1회", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.mhatch = true _a50() _a12.mhatch = false _a97("log") end)
end },
})
local _a518, _a519 = _a130(_a346, "랭크 퀘스트 자동", nil)
_a140(_a519, "quest", function()
_a54("quest", function() return _a10.QuestInterval end, _a42.quest.cycle, "퀘스트")
end)
_a151(_a518, {
{ label = "주기", value = _a10.QuestInterval, onChange = function(_a520)
local _a521 = tonumber(_a520) if _a521 and _a521 >= 5 then _a10.QuestInterval = _a521 end
end },
{ label = "포션 한 번에", value = _a10.QuestUseMax, onChange = function(_a522)
local _a523 = tonumber(_a522) if _a523 and _a523 >= 1 then _a10.QuestUseMax = math.floor(_a523) end
end },
})
_a170(_a518, "필요한 자동화 자동 ON",
function() return _a10.QuestDrive end,
function(_a524) _a10.QuestDrive = _a524 end)
_a170(_a518, "포션/인챈트 업글 퀘스트",
function() return _a10.QuestUpgrade end,
function(_a525) _a10.QuestUpgrade = _a525 end)
_a170(_a518, "포션 사용 퀘스트",
function() return _a10.QuestUsePotion end,
function(_a526) _a10.QuestUsePotion = _a526 end)
_a160(_a518, {
{ label = "퀘스트 현황 보기", col = _a55.accent, fn = function()
local _a527 = _a42.quest.status()
_a6("")
if not _a527 then _a6("[퀘스트] 세이브 못 읽음")
else
_a6("──── 랭크 퀘스트 ────")
_a6(("  Rank %d   ★%d"):format(_a527.rank, _a527.rankStars))
if #_a527.list == 0 then _a6("  퀘스트 없음") end
for _a528, _a529 in ipairs(_a527.list) do
local _a530 = _a529.how
local _a531 =
(_a530 == "farm" and "자동 파밍") or
(_a530 == "hatch" and "자동 부화") or
(_a530 == "zone" and "자동 존") or
(_a530 == "potup" and "포션 업글") or
(_a530 == "encup" and "인챈트 업글") or
(_a530 == "potuse" and "포션 사용") or
(_a530 == "fruituse" and "과일 사용") or
(_a530 == "flaguse" and "깃발 사용") or
(_a530 == "gold" and "골드 머신") or
(_a530 == "rainbow" and "레인보우 머신") or
"수동"
local _a532 = ""
if _a529.ignored then
_a531 = "무시"
_a532 = "   → " .. _a529.ignored
elseif _a529.event then
local _a533 = _a42.ev.findEvent(_a529.event, _a529.bestOnly)
_a532 = _a533 and ("   → %s @%s %d초"):format(_a533.name, tostring(_a533.zone), _a533.left)
or ("   → " .. _a529.event .. " 대기중")
elseif _a529.chest then
_a532 = "   → " .. _a529.chest
elseif _a529.where then
_a532 = "   → " .. _a529.where
end
_a6(("  [%d] %s"):format(_a529.stars, tostring(_a529.title)))
_a6(("       %d / %d    처리: %s   (Type %d)%s"):format(
_a529.progress, _a529.amount, _a531, _a529.type, _a532))
end
end
_a97("log")
end },
{ label = "활성 이벤트 보기", col = _a55.accent, fn = function()
local _a534 = _a42.ev.events()
local _a535 = _a42.move.bestZone()
_a6("")
_a6("──── 지금 떠 있는 랜덤 이벤트 ────")
_a6("  최고 존 : " .. tostring(_a535) .. "   현재 존 : " .. tostring(_a42.move.curZone()))
if #_a534 == 0 then _a6("  없음 (RandomEvents_Get 응답 비어있음)") end
for _a536, _a537 in ipairs(_a534) do
_a6(("  %-12s @%-20s %4d초 남음  %s%s"):format(
_a537.kind, tostring(_a537.zone), _a537.left,
_a537.pos and ("(%.0f, %.0f, %.0f)"):format(_a537.pos.X, _a537.pos.Y, _a537.pos.Z) or "좌표없음",
_a537.zone == _a535 and "  ★최고존" or ""))
end
_a6("")
_a6("  내 소환 아이템 :")
for _a538 in pairs(_a42.ev.SPAWN) do
local _a539 = _a42.ev.spawnItems(_a538)
local _a540 = 0
for _a541, _a542 in ipairs(_a539) do _a540 += _a542.am end
_a6(("    %-12s %d종 %d개"):format(_a538, #_a539, _a540))
for _a543, _a544 in ipairs(_a539) do
_a6(("        %d. %-24s x%d%s"):format(
_a543, _a544.id, _a544.am, _a543 == 1 and "   ← 먼저 씀" or ""))
if _a543 >= 6 then break end
end
end
_a6("  점선 네모 안? " .. tostring(_a42.move.inDottedBox()))
for _a545, _a546 in ipairs({ "MiniChests", "SuperiorMiniChests" }) do
local _a547, _a548 = _a42.ev.findChest(_a546)
_a6(("  %-20s %s"):format(_a546,
_a547 and ("가장 가까운 것 %.0f스터드"):format(_a548 or 0) or "없음"))
end
_a97("log")
end },
{ label = "포션 재고 보기", col = _a55.accent, fn = function()
_a6("")
_a6("──── 포션 / 인챈트 재고 ────")
for _a549, _a550 in ipairs({ "Potion", "Enchant" }) do
local _a551 = _a42.item.stacks(_a550)
table.sort(_a551, function(_a552, _a553)
if _a552.id ~= _a553.id then return _a552.id < _a553.id end
return _a552.tier < _a553.tier
end)
_a6("")
_a6(_a550 .. "  (" .. #_a551 .. "종)")
for _a554, _a555 in ipairs(_a551) do
local _a556 = _a42.item.perTier(_a550, _a555.tier)
local _a557 = _a556 and math.floor(_a555.am / _a556) or 0
_a6(("   %-20s T%-2d x%-6d %s"):format(
_a555.id, _a555.tier, _a555.am,
_a557 > 0 and ("→ T" .. (_a555.tier + 1) .. " " .. _a557 .. "개 제작가능") or ""))
if _a554 >= 40 then _a6("   ...") break end
end
if #_a551 == 0 then _a6("   (없음)") end
end
_a97("log")
end },
{ label = "지금 1회", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.quest = true _a42.quest.cycle() _a12.quest = false _a97("log") end)
end },
})
local _a558, _a559 = _a130(_a346, "슬롯 머신 자동 (다이아)", nil)
_a140(_a559, "slots", function()
_a54("slots", function() return _a10.SlotInterval end, _a42.mach.cycleSlots, "슬롯")
end)
_a151(_a558, {
{ label = "주기", value = _a10.SlotInterval, onChange = function(_a560)
local _a561 = tonumber(_a560) if _a561 and _a561 >= 5 then _a10.SlotInterval = _a561 end
end },
{ label = "남길 다이아", value = _a10.SlotReserve, onChange = function(_a562)
local _a563 = tonumber(_a562) if _a563 and _a563 >= 0 then _a10.SlotReserve = _a563 end
end },
})
_a170(_a558, "펫 장착 슬롯 (Pet Equip)",
function() return _a10.SlotPet end, function(_a564) _a10.SlotPet = _a564 end)
_a170(_a558, "알 부화 슬롯 (Egg Machine)",
function() return _a10.SlotEgg end, function(_a565) _a10.SlotEgg = _a565 end)
_a160(_a558, {
{ label = "슬롯 현황 보기", col = _a55.accent, fn = function()
local _a566 = _a42.mach.slotStatus()
_a6("")
_a6("──── 슬롯 머신 ────")
if not _a566 then _a6("  세이브 못 읽음") _a97("log") return end
_a6("  다이아 " .. _a7(_a566.dia, 0))
_a6("")
_a6(("  펫 장착 : 구매 %d / 랭크상한 %d   현재 최대장착 %s"):format(
_a566.petOwned, _a566.petMax, tostring(_a566.maxEquip)))
if _a566.petNext then
_a6(("     다음 #%d  %s 다이아  %s"):format(
_a566.petNext, _a566.petCost and _a7(_a566.petCost, 0) or "?",
(_a566.petCost and _a566.petCost <= _a566.dia - _a10.SlotReserve) and "← 지금 가능" or "부족"))
else
_a6("     랭크 상한까지 다 삼 (랭크를 올려야 더 살 수 있음)")
end
_a6("")
_a6(("  알 부화 : 구매 %d / 랭크상한 %d   한 번에 %s개"):format(
_a566.eggOwned, _a566.eggMax, tostring(_a566.maxHatch)))
if _a566.eggEnd then
_a6(("     다음 %d칸 묶음 → %d   %s 다이아  %s"):format(
_a566.eggSize, _a566.eggEnd, _a566.eggCost and _a7(_a566.eggCost, 0) or "?",
(_a566.eggCost and _a566.eggCost <= _a566.dia - _a10.SlotReserve) and "← 지금 가능" or "부족"))
else
_a6("     랭크 상한까지 다 삼")
end
_a6("")
_a6("  리모트 : 펫 " .. (_a41.R_PetSlot and "O" or "X")
.. " / 알 " .. (_a41.R_EggSlot and "O" or "X"))
_a97("log")
end },
{ label = "지금 1회", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.slots = true _a42.mach.cycleSlots() _a12.slots = false _a97("log") end)
end },
})
local _a567, _a568 = _a130(_a346, "아이템 자동 사용 (버프 유지)", nil)
_a140(_a568, "items", function()
_a54("items", function() return _a10.ItemInterval end, _a42.item.cycleItems, "아이템")
end)
_a151(_a567, {
{ label = "주기", value = _a10.ItemInterval, onChange = function(_a569)
local _a570 = tonumber(_a569) if _a570 and _a570 >= 5 then _a10.ItemInterval = _a570 end
end },
{ label = "포션 한 바퀴 최대", value = _a10.BuffMaxPotion, onChange = function(_a571)
local _a572 = tonumber(_a571) if _a572 and _a572 >= 1 then _a10.BuffMaxPotion = math.floor(_a572) end
end },
})
_a151(_a567, {
{ label = "남길 개수", value = _a10.ItemKeep, onChange = function(_a573)
local _a574 = tonumber(_a573) if _a574 and _a574 >= 0 then _a10.ItemKeep = math.floor(_a574) end
end },
{ label = "과일/소모품 최대", value = _a10.BuffMaxOther, onChange = function(_a575)
local _a576 = tonumber(_a575) if _a576 and _a576 >= 1 then _a10.BuffMaxOther = math.floor(_a576) end
end },
})
_a151(_a567, {
{ label = "쓸 것 (비우면 전부)", value = _a10.ItemAllow, onChange = function(_a577)
_a10.ItemAllow = _a577 or ""
end },
{ label = "제외", value = _a10.ItemBlock, onChange = function(_a578)
_a10.ItemBlock = _a578 or ""
end },
})
_a170(_a567, "포션", function() return _a10.BuffPotion end,
function(_a579) _a10.BuffPotion = _a579 end)
_a170(_a567, "과일", function() return _a10.BuffFruit end,
function(_a580) _a10.BuffFruit = _a580 end)
_a170(_a567, "얼티밋 (충전되면 발동, 무료)", function() return _a10.BuffUltimate end,
function(_a581) _a10.BuffUltimate = _a581 end)
_a170(_a567, "소모품 (Rain/Sunlight 주의)", function() return _a10.BuffConsumable end,
function(_a582) _a10.BuffConsumable = _a582 end)
_a170(_a567, "높은 티어부터 사용 (끄면 낮은 것부터)", function() return _a10.BuffHighTier end,
function(_a583) _a10.BuffHighTier = _a583 end)
_a170(_a567, "최고 존에서만 사용", function() return _a10.ItemBestZone end,
function(_a584) _a10.ItemBestZone = _a584 end)
_a170(_a567, "최고 존이 아니면 이동 후 사용", function() return _a10.ItemTp end,
function(_a585) _a10.ItemTp = _a585 end)
_a160(_a567, {
{ label = "버프 현황 보기", col = _a55.accent, fn = function()
_a6("")
_a6("──── 버프 / 아이템 ────")
_a6(("  현재 존 %s / 최고 존 %s%s"):format(
tostring(_a42.move.curZone()), tostring(_a42.move.bestZone()),
_a10.ItemBestZone and (_a42.move.curZone() == _a42.move.bestZone() and "   ← 사용 가능" or "   ← 이동 필요") or ""))
for _a586, _a587 in pairs({ Potions = "Potion", Fruits = "Fruit" }) do
local _a588 = _a42.item.activeBuffs(_a586)
local _a589 = {}
for _a590 in pairs(_a588) do _a589[#_a589 + 1] = _a590 end
table.sort(_a589)
_a6(("  지금 걸린 %s : %s"):format(_a586,
#_a589 > 0 and table.concat(_a589, ", ") or "없음"))
end
local _a591 = _a43()
local _a592 = _a591 and rawget(_a591, "Ultimates")
if type(_a592) == "table" then
local _a593 = {}
for _a594 in pairs(_a592) do
local _a595 = "?"
if _a41.Ult and rawget(_a41.Ult, "IsCharged") then
local _a596, _a597 = pcall(_a41.Ult.IsCharged, _a594)
_a595 = _a596 and (_a597 and "충전됨" or "충전중") or "?"
end
_a593[#_a593 + 1] = _a594 .. "(" .. _a595 .. ")"
end
_a6("  얼티밋 : " .. (#_a593 > 0 and table.concat(_a593, ", ") or "없음"))
end
_a6("")
for _a598, _a599 in ipairs({ "Potion", "Fruit", "Consumable" }) do
local _a600 = _a42.item.stacks(_a599)
local _a601, _a602 = 0, 0
for _a603, _a604 in ipairs(_a600) do
if _a42.item.itemAllowed(_a604.id) then _a601 += 1 else _a602 += 1 end
end
_a6(("  %-12s %d종 (쓸 수 있음 %d / 제외 %d)"):format(_a599, #_a600, _a601, _a602))
for _a605, _a606 in ipairs(_a600) do
_a6(("      %-20s T%-2d x%-6d %s"):format(
_a606.id, _a606.tier, _a606.am, _a42.item.itemAllowed(_a606.id) and "" or "제외됨"))
if _a605 >= 12 then _a6("      ...") break end
end
end
_a6("")
_a6("  리모트 : 포션 " .. (_a41.R_PotUse and "O" or "X")
.. " / 과일 " .. (_a41.R_Fruit and "O" or "X")
.. " / 소모품 " .. (_a41.R_Cons and "O" or "X")
.. " / 얼티밋 " .. (_a41.R_Ult and "O" or "X"))
_a97("log")
end },
{ label = "지금 1회", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.items = true _a42.item.cycleItems() _a12.items = false _a97("log") end)
end },
})
local _a607, _a608 = _a130(_a346, "맵 업그레이드 자동 (다이아)", nil)
_a140(_a608, "mapupg", function()
_a54("mapupg", function() return _a10.UpgInterval end, _a42.mach.cycleUpg, "맵업글")
end)
_a151(_a607, {
{ label = "주기", value = _a10.UpgInterval, onChange = function(_a609)
local _a610 = tonumber(_a609) if _a610 and _a610 >= 5 then _a10.UpgInterval = _a610 end
end },
{ label = "남길 다이아", value = _a10.UpgReserve, onChange = function(_a611)
local _a612 = tonumber(_a611) if _a612 and _a612 >= 0 then _a10.UpgReserve = _a612 end
end },
})
_a170(_a607, "구매 전 그 앞으로 이동",
function() return _a10.UpgTp end,
function(_a613) _a10.UpgTp = _a613 end)
_a160(_a607, {
{ label = "업그레이드 목록", col = _a55.accent, fn = function()
local _a614 = _a42.mach.upgList()
local _a615 = _a44("Diamonds")
_a6("")
_a6("──── 맵 업그레이드 ────")
_a6("보유 다이아 " .. _a7(_a615, 0))
if #_a614 == 0 then
_a6("  로드된 업그레이드 기둥이 없음 (해당 존에 가야 보입니다)")
end
local _a616, _a617, _a618 = 0, 0, 0
for _a619, _a620 in ipairs(_a614) do
if _a620.bought then _a617 += 1
elseif not _a620.zoneOwned then _a618 += 1
else _a616 += 1 end
end
_a6(("  구매가능 %d / 구매완료 %d / 존 미보유 %d"):format(_a616, _a617, _a618))
_a6("")
local _a621 = 0
for _a622, _a623 in ipairs(_a614) do
if _a623.buyable then
_a621 += 1
_a6(("  %-12s T%-2d %-20s %12s %-9s %s"):format(
_a623.id, _a623.tier, _a623.zone, _a623.cost and _a7(_a623.cost, 0) or "?",
tostring(_a623.cur),
(_a623.cost and _a623.cost <= _a44(_a623.cur or "Diamonds") - _a10.UpgReserve)
and "← 지금 가능" or ""))
if _a621 >= 25 then _a6("  ...") break end
end
end
_a97("log")
end },
{ label = "업글 진단", col = _a55.warn, fn = function()
task.spawn(function()
_a6("")
_a6("──── 맵 업그레이드 진단 ────")
_a6("  리모트 : " .. (_a41.R_Upg and _a41.R_Upg:GetFullName() or "없음"))
local _a624 = _a42.mach.upgList()
_a6("  로드된 기둥 " .. #_a624 .. "개")
local _a625
for _a626, _a627 in ipairs(_a624) do
if _a627.buyable and _a627.cost then _a625 = _a627 break end
end
if not _a625 then
_a6("  살 수 있는 게 없음 (전부 구매완료거나 존 미보유)")
for _a628, _a629 in ipairs(_a624) do
_a6(("   %-12s T%-2d @%-18s 구매됨=%s 존보유=%s"):format(
_a629.id, _a629.tier, tostring(_a629.zone), tostring(_a629.bought), tostring(_a629.zoneOwned)))
if _a628 >= 8 then _a6("   ...") break end
end
_a97("log") return
end
local _a630 = _a44(_a625.cur or "Diamonds")
local _a631 = _a42.move.hrp()
local _a632 = (_a631 and _a625.pos) and (_a631.Position - _a625.pos).Magnitude or nil
_a6(("  대상 : %s T%d @%s"):format(_a625.id, _a625.tier, tostring(_a625.zone)))
_a6(("  가격 : %s %s / 보유 %s"):format(
_a7(_a625.cost, 0), tostring(_a625.cur), _a7(_a630, 0)))
_a6("  거리 : " .. (_a632 and ("%.0f 스터드"):format(_a632) or "좌표 없음"))
_a6("")
_a6("  ▶ 제자리에서 호출")
local _a633, _a634
local _a635 = pcall(function() _a633, _a634 = _a41.R_Upg:InvokeServer(_a625.id, _a625.zone) end)
_a6("    호출성공 " .. tostring(_a635) .. " / 반환1 " .. tostring(_a633)
.. " / 반환2 " .. tostring(_a634))
if not _a633 and _a625.pos then
_a6("")
_a6("  ▶ 기둥 앞으로 이동해서 재시도")
_a42.move.glideTo(_a625.pos)
task.wait(0.3)
local _a636 = _a42.move.hrp()
_a6("    이동후 거리 " .. (_a636 and ("%.0f"):format((_a636.Position - _a625.pos).Magnitude) or "?"))
local _a637, _a638
local _a639 = pcall(function() _a637, _a638 = _a41.R_Upg:InvokeServer(_a625.id, _a625.zone) end)
_a6("    호출성공 " .. tostring(_a639) .. " / 반환1 " .. tostring(_a637)
.. " / 반환2 " .. tostring(_a638))
_a6("")
_a6(_a637 and "  → 거리 검사 있음. 이동해야 됩니다."
or "  → 이동해도 실패. 거리 문제가 아닙니다.")
else
_a6("")
_a6(_a633 and "  → 원격으로 됩니다. 이동 불필요." or "  → 실패 (좌표 없음)")
end
_a97("log")
end)
end },
{ label = "지금 1회", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.mapupg = true _a42.mach.cycleUpg() _a12.mapupg = false _a97("log") end)
end },
})
local _a640, _a641 = _a130(_a346, "자동 리버스", nil)
_a140(_a641, "mreb", function()
_a54("mreb", function() return _a10.MainRebirthInterval end, _a52, "리버스")
end)
_a151(_a640, {
{ label = "주기", value = _a10.MainRebirthInterval, onChange = function(_a642)
local _a643 = tonumber(_a642) if _a643 and _a643 >= 10 then _a10.MainRebirthInterval = _a643 end
end },
})
_a170(_a640, "실패 이유 로그",
function() return _a10.MainRebirthVerbose end,
function(_a644) _a10.MainRebirthVerbose = _a644 end)
_a160(_a640, {
{ label = "리버스 현황 보기", col = _a55.accent, fn = function()
local _a645 = _a51()
_a6("")
if not _a645 then _a6("[리버스] 세이브 못 읽음")
else
_a6("──── 메인 리버스 ────")
_a6("  현재 " .. _a645.current .. "회 → 다음 " .. _a645.nextN)
if type(_a645.def) == "table" then
for _a646, _a647 in pairs(_a645.def) do
if type(_a647) ~= "table" and type(_a647) ~= "function" then
_a6("    " .. tostring(_a646) .. " = " .. tostring(_a647))
end
end
end
end
_a97("log")
end },
{ label = "지금 1회", col = _a55.bad, fn = function()
task.spawn(function() _a12.mreb = true _a52() _a12.mreb = false _a97("log") end)
end },
})
local _a648 = _a130(_a346, "전체 제어", nil)
_a160(_a648, {
{ label = "메인 전부 ON", col = _a55.good, fn = function()
local _a649 = {
{ "farm",   function() return _a10.FarmInterval end,       _a45,       "파밍" },
{ "zone",   function() return _a10.ZoneInterval end,       _a47,       "존" },
{ "mhatch", function() return _a10.MainHatchInterval end,  _a50,  "부화" },
{ "quest",  function() return _a10.QuestInterval end,      _a42.quest.cycle,        "퀘스트" },
{ "mapupg", function() return _a10.UpgInterval end,        _a42.mach.cycleUpg,     "맵업글" },
{ "items",  function() return _a10.ItemInterval end,       _a42.item.cycleItems,   "아이템" },
{ "slots",  function() return _a10.SlotInterval end,       _a42.mach.cycleSlots,   "슬롯" },
}
for _a650, _a651 in ipairs(_a649) do
if not _a12[_a651[1]] then
_a12[_a651[1]] = true
_a54(_a651[1], _a651[2], _a651[3], _a651[4])
end
end
_a137()
_a6("[메인] 파밍/존/부화/랭크/퀘스트/맵업글 ON  (리버스는 따로)")
end },
{ label = "메인 전부 OFF", col = _a55.bad, fn = function()
_a42.ctl.stopAll()
_a137()
_a6("[메인] 정지")
end },
})
end
_a88.MouseButton1Click:Connect(function()
local _a652 = table.concat(_a5, "\n")
if #_a652 > 900000 then _a652 = _a652:sub(#_a652 - 900000) end
if type(setclipboard) == "function" then
pcall(setclipboard, _a652)
_a88.Text = "완료"
task.delay(1.5, function() if _a88 then _a88.Text = "복사" end end)
end
end)
_a87.MouseButton1Click:Connect(function()
table.clear(_a5)
_a182.top = nil
_a1.dirty = true
end)
local function _a653()
_a12.place, _a12.merchant, _a12.upgrade = false, false, false
_a12.towerup, _a12.crop, _a12.expand, _a12.rebirth, _a12.hatch, _a12.luck = false, false, false, false, false, false
_a12.farm, _a12.zone, _a12.mhatch, _a12.rank, _a12.mreb = false, false, false, false, false
if _a202 then _a202:Disconnect() end
if _a73 then _a73:Destroy() end
_G.__PS99_GARDEN = nil
end
_a85.MouseButton1Click:Connect(_a653)
_G.__PS99_GARDEN = _a653
_a97("dash")
_a6("PS99 자동")
if _a1.lpWait then
_a6(("[진단] LocalPlayer 가 늦게 잡혔습니다 — %.1f초 대기, 결과 %s")
:format(_a1.lpWait, _a1.lpFail and "실패 (기능 대부분 못 씀)" or "성공"))
end
if _a1.libWait then
_a6(("[진단] 게임 모듈(Library/Network)도 늦게 잡혔습니다 — %.1f초 대기")
:format(_a1.libWait))
end
if _a1.libFail then
_a6("[진단] ★ " .. _a1.libFail .. " 를 못 찾았습니다 — 게임 로드 후 다시 실행하세요")
end
if _a12.auto then
if _a42.auto.start then
_a6("[자동] 올 자동 켜짐 — 1초 뒤 시작합니다")
task.spawn(function()
task.wait(1)
_a42.ctl.abort = false
local _a654, _a655 = pcall(_a42.auto.start)
if _a654 then
_a6("[자동] 시작됨")
else
_a12.auto = false
_a6("[자동] 시작 실패: " .. tostring(_a655))
if _a42.auto.refresh then pcall(_a42.auto.refresh) end
end
end)
else
_a12.auto = false
_a6("[자동] QS.auto.start 가 없습니다 — 메인 게임 탭이 안 만들어짐")
end
end
pcall(function()
local _a656, _a657, _a658, _a659 = _a15()
if _a656 and _a658 then
local _a660 = _a16(_a658, _a659)
_a13.slots = #_a660
_a6("레인 " .. _a659 .. " / 슬롯 " .. #_a660)
else
_a6("가든 이벤트 밖입니다 (이벤트 탭은 이벤트 안에서만 동작)")
end
_a13.sun = _a21()
_a6("Sunflowers " .. _a7(_a13.sun, 0))
end)
end
