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
local _a212 = _a114("event", "이벤트", 20)
do
local _a213, _a214 = _a130(_a212, "자동 배치 / 교체", nil)
_a140(_a214, "place", function()
_a54("place", function() return _a10.PlaceInterval end, _a19, "배치")
end)
_a151(_a213, {
{ label = "주기", value = _a10.PlaceInterval, onChange = function(_a215)
local _a216 = tonumber(_a215) if _a216 and _a216 >= 3 then _a10.PlaceInterval = _a216 end
end },
{ label = "교체 배수", value = _a10.SwapMargin, onChange = function(_a217)
local _a218 = tonumber(_a217) if _a218 and _a218 >= 1 then _a10.SwapMargin = _a218 _a6("[설정] 교체 배수 " .. _a218) end
end },
{ label = "DoT 반영", value = _a10.DotFactor, onChange = function(_a219)
local _a220 = tonumber(_a219) if _a220 and _a220 >= 0 and _a220 <= 1 then _a10.DotFactor = _a220 end
end },
})
_a170(_a213, "업글 타워 보호",
function() return _a10.ProtectUpgraded end,
function(_a221) _a10.ProtectUpgraded = _a221
_a6("[설정] 업글 보호 " .. (_a221 and "ON — 업글된 건 안 건드림" or "OFF — 약하면 교체")) end)
_a160(_a213, {
{ label = "지금 1회 실행", col = _a55.accent, fn = function()
task.spawn(function() _a12.place = true _a19() _a12.place = false _a97("log") end)
end },
})
end
do
local _a222, _a223 = _a130(_a212, "머천트 자동 구매", nil)
_a140(_a223, "merchant", function()
_a54("merchant", function() return _a10.MerchantInterval end, _a20, "구매")
end)
_a151(_a222, {
{ label = "머천트 ID", value = _a10.MerchantId, onChange = function(_a224)
if _a224 ~= "" then _a10.MerchantId = _a224 _a6("[설정] 머천트 " .. _a224) end
end },
{ label = "주기", value = _a10.MerchantInterval, onChange = function(_a225)
local _a226 = tonumber(_a225) if _a226 and _a226 >= 5 then _a10.MerchantInterval = _a226 end
end },
})
_a160(_a222, {
{ label = "지금 1회 구매", col = _a55.accent, fn = function()
task.spawn(function() _a12.merchant = true _a20() _a12.merchant = false _a97("log") end)
end },
})
end
do
local _a227, _a228 = _a130(_a212, "업그레이드 머신", nil)
_a140(_a228, "upgrade", function()
_a54("upgrade", function() return _a10.UpgradeInterval end, _a24, "머신업글")
end)
_a151(_a227, {
{ label = "주기", value = _a10.UpgradeInterval, onChange = function(_a229)
local _a230 = tonumber(_a229) if _a230 and _a230 >= 5 then _a10.UpgradeInterval = _a230 end
end },
{ label = "최소 잔액", value = _a10.MinSunflowers, onChange = function(_a231)
local _a232 = tonumber(_a231) if _a232 and _a232 >= 0 then _a10.MinSunflowers = _a232
_a6("[설정] 최소 잔액 " .. _a7(_a232, 0)) end
end },
})
_a170(_a227, "가격 미상 구매",
function() return _a10.BuyUnknownCost end,
function(_a233) _a10.BuyUnknownCost = _a233 end)
_a160(_a227, {
{ label = "업글 현황 보기", col = _a55.accent, fn = function()
local _a234 = _a21()
local _a235 = _a22()
_a13.sun = _a234
_a6("")
_a6("──── 업그레이드 머신 ────")
_a6("Sunflowers = " .. _a7(_a234, 0))
local _a236 = {}
for _a237, _a238 in ipairs(_a14) do
local _a239 = _a235[_a238] or 0
_a236[#_a236 + 1] = { id = _a238, tier = _a239, cost = _a23(_a238, _a239) }
end
table.sort(_a236, function(_a240, _a241)
return (_a240.cost or math.huge) < (_a241.cost or math.huge)
end)
for _a242, _a243 in ipairs(_a236) do
_a6(("  %-22s Lv%-3s 다음 %-14s %s"):format(
_a243.id, tostring(_a243.tier), _a243.cost and _a7(_a243.cost, 0) or "?",
(_a243.cost and _a243.cost <= _a234) and "← 구매가능" or ""))
end
_a97("log")
end },
{ label = "지금 1회 업글", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.upgrade = true _a24() _a12.upgrade = false _a97("log") end)
end },
})
local _a244, _a245 = _a130(_a212, "타워 개별 업글", nil)
_a140(_a245, "towerup", function()
_a54("towerup", function() return _a10.UpgradeInterval end, _a53, "타워업글")
end)
end
do
local _a246, _a247 = _a130(_a212, "자동 뽑기", nil)
_a140(_a247, "hatch", function()
_a54("hatch", function() return _a10.HatchInterval end, _a36, "뽑기")
end)
_a151(_a246, {
{ label = "주기", value = _a10.HatchInterval, onChange = function(_a248)
local _a249 = tonumber(_a248) if _a249 and _a249 >= 1 then _a10.HatchInterval = _a249 end
end },
{ label = "한 번에 최대", value = _a10.HatchMax, onChange = function(_a250)
local _a251 = tonumber(_a250) if _a251 and _a251 >= 1 then _a10.HatchMax = math.floor(_a251) end
end },
})
_a151(_a246, {
{ label = "예비금", value = _a10.HatchReserve, onChange = function(_a252)
local _a253 = tonumber(_a252) if _a253 and _a253 >= 0 then _a10.HatchReserve = _a253
_a6("[설정] 뽑기 예비금 " .. _a7(_a253, 0)) end
end },
{ label = "알 번호 (0=자동)", value = _a10.HatchEggNum, onChange = function(_a254)
local _a255 = tonumber(_a254) if _a255 and _a255 >= 0 and _a255 <= 12 then
_a10.HatchEggNum = math.floor(_a255)
table.clear(_a11)
_a6("[설정] 알 번호 " .. (_a255 == 0 and "자동" or _a255)) end
end },
})
_a160(_a246, {
{ label = "뽑기 현황 보기", col = _a55.accent, fn = function()
local _a256 = _a35()
_a13.sun = _a256.sun
_a6("")
_a6("──── 뽑기 현황 ────")
_a6("  알 등급     " .. _a256.id)
_a6("  알 uid      " .. tostring(_a256.uid))
_a6("  개당 비용   " .. (_a256.cost and _a7(_a256.cost, 0) or "?"))
_a6("  Sunflowers  " .. _a7(_a256.sun, 0))
_a6("  예비금      " .. _a7(_a10.HatchReserve, 0))
_a6("  지금 가능   " .. _a256.canBuy .. "회")
_a6("")
_a6("  월드의 알 " .. _a256.eggCount .. "개")
for _a257, _a258 in ipairs(_a256.eggs) do
if _a257 > 5 then break end
_a6(("    %s  거리 %s"):format(_a258.uid, _a7(_a258.dist)))
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
local _a259, _a260 = _a130(_a212, "럭 상시 최대 유지", nil)
_a140(_a260, "luck", function()
_a54("luck", function() return _a10.LuckInterval end, _a40, "럭")
end)
_a151(_a259, {
{ label = "주기", value = _a10.LuckInterval, onChange = function(_a261)
local _a262 = tonumber(_a261) if _a262 and _a262 >= 60 then _a10.LuckInterval = _a262 end
end },
{ label = "예비금", value = _a10.LuckReserve, onChange = function(_a263)
local _a264 = tonumber(_a263) if _a264 and _a264 >= 0 then _a10.LuckReserve = _a264 end
end },
})
_a151(_a259, {
{ label = "최소 부족분", value = _a10.LuckMinTopUp, onChange = function(_a265)
local _a266 = tonumber(_a265) if _a266 and _a266 >= 0 then _a10.LuckMinTopUp = _a266 end
end },
})
for _a267, _a268 in ipairs(_a37) do
_a170(_a259, _a268,
function() return _a10.LuckBoosts[_a268] end,
function(_a269) _a10.LuckBoosts[_a268] = _a269 end)
end
_a160(_a259, {
{ label = "럭 현황 보기", col = _a55.accent, fn = function()
local _a270 = _a38()
_a13.sun = _a270.sun
_a6("")
_a6("──── 이벤트 럭 ────")
_a6("  머신 활성   " .. (_a270.enabled and "O" or "X"))
_a6("  최대 시간   " .. _a39(_a270.maxSec))
_a6("  Sunflowers  " .. _a7(_a270.sun, 0))
_a6("")
for _a271, _a272 in ipairs(_a270.rows) do
_a6(("  %-12s %-14s 부족 %-14s 필요 %s개%s"):format(
_a272.rarity, _a39(_a272.left), _a39(_a272.deficit), _a7(_a272.need, 0),
_a272.on and "" or "   (꺼짐)"))
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
local _a273, _a274 = _a130(_a212, "자동 씨앗 교체", nil)
_a140(_a274, "crop", function()
_a54("crop", function() return _a10.CropInterval end, _a29, "씨앗")
end)
_a151(_a273, {
{ label = "주기", value = _a10.CropInterval, onChange = function(_a275)
local _a276 = tonumber(_a275) if _a276 and _a276 >= 5 then _a10.CropInterval = _a276 end
end },
{ label = "갈아엎기 배수", value = _a10.CropMargin, onChange = function(_a277)
local _a278 = tonumber(_a277) if _a278 and _a278 >= 1 then _a10.CropMargin = _a278 _a6("[설정] 작물 배수 " .. _a278) end
end },
})
_a170(_a273, "성장중 건너뛰기",
function() return _a10.SkipUnhatched end,
function(_a279) _a10.SkipUnhatched = _a279 end)
_a160(_a273, {
{ label = "밭 현황 보기", col = _a55.accent, fn = function()
local _a280, _a281 = _a15()
if not _a281 then _a6("[씨앗] 밭 없음") _a97("log") return end
local _a282, _a283 = _a26(_a281), _a25()
_a6("")
_a6("──── 밭 현황 ────")
_a6("보유 씨앗 (기대 초당수익 순)")
for _a284, _a285 in ipairs(_a283) do
_a6(("  %-10s %-8s ×%-6s  기대 %s/s"):format(
tostring(_a285.id), tostring(_a285.vr or "-"), tostring(_a285.am), _a7(_a285.exp)))
end
local _a286, _a287, _a288, _a289, _a290 = 0, 0, 0, 0, 0
local _a291 = _a283[1]
local _a292 = _a291 and _a291.exp or 0
_a6("")
_a6("심어진 작물")
local _a293 = 0
for _a294, _a295 in pairs(_a282) do
_a286 += 1
local _a296 = _a28(_a295) or 0
_a287 += _a296
if _a27(_a295) then _a289 += 1
elseif _a292 > _a296 * _a10.CropMargin then _a288 += 1
else _a290 += 1 end
_a293 += 1
if _a293 <= 20 then
_a6(("  칸%-4s %-20s %s/s%s"):format(tostring(_a294),
tostring(rawget(_a295, "sp") or "?"), _a7(_a296),
_a27(_a295) and "  (자라는 중)" or ""))
end
end
if _a286 > 20 then _a6("  ... (" .. (_a286 - 20) .. "칸 더)") end
_a6("")
_a6(("총 %d칸 / 합계 %s per sec"):format(_a286, _a7(_a287)))
_a6(("갈아엎기 대상 %d / 유지 %d / 자라는 중 %d"):format(_a288, _a290, _a289))
_a97("log")
end },
{ label = "지금 1회 실행", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.crop = true _a29() _a12.crop = false _a97("log") end)
end },
})
end
do
local _a297, _a298 = _a130(_a212, "자동 확장", nil)
_a140(_a298, "expand", function()
_a54("expand", function() return _a10.ExpandInterval end, _a32, "확장")
end)
_a151(_a297, {
{ label = "주기", value = _a10.ExpandInterval, onChange = function(_a299)
local _a300 = tonumber(_a299) if _a300 and _a300 >= 5 then _a10.ExpandInterval = _a300 end
end },
{ label = "밭칸 스캔", value = _a10.MaxBedScan, onChange = function(_a301)
local _a302 = tonumber(_a301) if _a302 and _a302 >= 1 then _a10.MaxBedScan = math.floor(_a302) end
end },
})
_a160(_a297, {
{ label = "확장 현황 보기", col = _a55.accent, fn = function()
local _a303, _a304, _a305, _a306 = _a15()
if not _a304 then _a6("[확장] 밭 없음") _a97("log") return end
local _a307 = _a21()
_a13.sun = _a307
local _a308 = _a30(true)
_a6("")
_a6("──── 확장 현황 ────")
_a6("Sunflowers = " .. _a7(_a307, 0))
_a6("")
_a6("레인 " .. tostring(_a306) .. "개 열림")
local _a309 = {}
for _a310 in pairs(_a308) do _a309[#_a309 + 1] = tonumber(_a310) or _a310 end
table.sort(_a309, function(_a311, _a312) return tostring(_a311) < tostring(_a312) end)
for _a313, _a314 in ipairs(_a309) do
local _a315 = _a308[_a314] or _a308[tostring(_a314)]
local _a316 = tonumber(_a314) or 0
local _a317 = (_a316 == (tonumber(_a306) or 0) + 1)
and ((tonumber(_a315) or math.huge) <= _a307 and "  ← 지금 오픈 가능" or "  ← 다음 (돈 부족)")
or (_a316 <= (tonumber(_a306) or 0) and "  (열림)" or "")
_a6(("  레인 %-3s %s%s"):format(tostring(_a314), _a7(tonumber(_a315) or 0, 0), _a317))
end
local _a318 = _a31(_a304)
_a6("")
_a6("잠긴 밭칸 " .. #_a318 .. "개 (싼 순 8개)")
for _a319 = 1, math.min(8, #_a318) do
local _a320 = _a318[_a319]
_a6(("  칸 %-4s %s%s"):format(_a320.id, _a320.cost and _a7(_a320.cost, 0) or "?",
(_a320.cost and _a320.cost <= _a307) and "  ← 오픈 가능" or ""))
end
if #_a318 == 0 then _a6("  (전부 열려 있음)") end
_a97("log")
end },
{ label = "지금 1회 실행", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.expand = true _a32() _a12.expand = false _a97("log") end)
end },
})
end
do
local _a321, _a322 = _a130(_a212, "자동 리버스", nil)
_a140(_a322, "rebirth", function()
_a54("rebirth", function() return _a10.RebirthInterval end, _a34, "리버스")
end)
_a151(_a321, {
{ label = "주기", value = _a10.RebirthInterval, onChange = function(_a323)
local _a324 = tonumber(_a323) if _a324 and _a324 >= 10 then _a10.RebirthInterval = _a324 end
end },
})
_a160(_a321, {
{ label = "리버스 현황 보기", col = _a55.accent, fn = function()
local _a325 = _a33()
_a6("")
_a6("──── 리버스 현황 ────")
if not _a325 then _a6("  밭 없음") _a97("log") return end
_a6(("  현재 리버스   %d회  (최대 %s)"):format(_a325.regrows, tostring(_a325.cap)))
_a6(("  레인          %d / 7 %s"):format(_a325.lanes, _a325.lanes >= 7 and "OK" or "부족"))
_a6(("  코인보스      %d / %d %s"):format(_a325.kills, _a325.need,
_a325.kills >= _a325.need and "OK" or "부족"))
_a6("")
_a6(_a325.ready and "  ★ 지금 리버스 가능" or ("  대기 — " .. tostring(_a325.reason)))
_a97("log")
end },
{ label = "지금 1회 리버스", col = _a55.bad, fn = function()
task.spawn(function() _a12.rebirth = true _a34() _a12.rebirth = false _a97("log") end)
end },
})
end
local _a326 = _a114("main", "메인 게임", 30)
do
local _a327, _a328 = _a130(_a326, "올 자동", nil)
local _a329 = _a56("Frame", {
Size = UDim2.new(1, 0, 0, 108), BackgroundColor3 = _a55.cardHi,
BorderSizePixel = 0, LayoutOrder = _a125(),
}, _a327)
_a63(_a329, 6)
_a70(_a329, 8)
local _a330 = _a56("TextLabel", {
Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
Font = Enum.Font.Code, TextSize = 12, TextColor3 = _a55.text,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Text = "정지", RichText = true,
}, _a329)
task.spawn(function()
while _a73 and _a73.Parent do
local _a331 = _a42.ctl.now
local _a332 = _a12.auto and "🟢" or "⚪"
local _a333 = _a331.act or "-"
if _a331.detail and _a331.detail ~= "" then _a333 = _a333 .. "  " .. _a331.detail end
_a330.Text = table.concat({
_a332 .. " " .. (_a12.auto and (_a331.step or "-") or "정지"),
"▸ " .. _a333,
"목표 " .. (_a331.goal or "-") .. (_a331.prog ~= "" and ("   " .. _a331.prog) or ""),
"1.리버스 " .. (_a42.auto.rebNote or "-"),
"2.존해금 " .. (_a42.auto.zoneNote or "-"),
"파밍대상 " .. tostring(_a42.auto.farmZone or "-") .. "   현재 " .. tostring(_a42.auto.hereZone or "-"),
}, "\n")
task.wait(0.2)
end
end)
function _a42.auto.start()
for _a334, _a335 in ipairs(_a42.auto.STEPS) do _a12[_a335.run] = false end
for _a336, _a337 in ipairs(_a42.auto.SIDE) do _a12[_a337.run] = false end
_a12.petspd = true
_a12.rewatch = true
_a137()
_a54("auto", function() return _a10.AutoInterval end, _a42.auto.master, "자동")
end
_a140(_a328, "auto", _a42.auto.start)
_a151(_a327, {
{ label = "주기", value = _a10.AutoInterval, onChange = function(_a338)
local _a339 = tonumber(_a338) if _a339 and _a339 >= 1 then _a10.AutoInterval = _a339 end
end },
{ label = "정체 판정(초)", value = _a10.PursueStallSec, onChange = function(_a340)
local _a341 = tonumber(_a340) if _a341 and _a341 >= 10 then _a10.PursueStallSec = _a341 end
end },
})
_a151(_a327, {
{ label = "운 퀘 최소 알 개수", value = _a10.HatchMinAfford, onChange = function(_a342)
local _a343 = tonumber(_a342) if _a343 and _a343 >= 1 then _a10.HatchMinAfford = math.floor(_a343) end
end },
{ label = "더 버는 시간(초)", value = _a10.MoneyDwell, onChange = function(_a344)
local _a345 = tonumber(_a344) if _a345 and _a345 >= 0 then _a10.MoneyDwell = _a345 end
end },
})
_a151(_a327, {
{ label = "부화 한 번에(초)", value = _a10.HatchBudget, onChange = function(_a346)
local _a347 = tonumber(_a346) if _a347 and _a347 >= 3 then _a10.HatchBudget = _a347 end
end },
})
_a151(_a327, {
{ label = "이동 방식", value = _a10.TpMode, onChange = function(_a348)
_a348 = tostring(_a348 or ""):lower()
if _a348 == "instant" or _a348 == "glide" or _a348 == "walk" then _a10.TpMode = _a348 end
end },
{ label = "glide 속도", value = _a10.TpSpeed, onChange = function(_a349)
local _a350 = tonumber(_a349) if _a350 and _a350 >= 16 then _a10.TpSpeed = _a350 end
end },
})
_a170(_a327, "차단 화면에 실제 클릭까지 시도",
function() return _a10.ScreenRealClick end,
function(_a351) _a10.ScreenRealClick = _a351 end)
_a170(_a327, "퀘스트 없을 때도 알 까기",
function() return _a10.IdleHatch end,
function(_a352) _a10.IdleHatch = _a352 end)
_a170(_a327, "존 해금·리버스는 퀘스트 끝나고",
function() return _a10.HoldZoneForQuest end,
function(_a353) _a10.HoldZoneForQuest = _a353 end)
for _a354, _a355 in ipairs(_a42.auto.STEPS) do
local _a356 = _a355.key
_a170(_a327, "  " .. _a354 .. ". " .. _a355.label,
function() return _a10.StepOn[_a356] end,
function(_a357) _a10.StepOn[_a356] = _a357 end)
end
for _a358, _a359 in ipairs(_a42.auto.SIDE) do
local _a360 = _a359.key
_a170(_a327, "  · " .. _a359.label .. " (순위 밖)",
function() return _a10.StepOn[_a360] end,
function(_a361) _a10.StepOn[_a360] = _a361 end)
end
_a160(_a327, {
{ label = "지금 상태", col = _a55.accent, fn = function()
_a6("")
_a6("──── 올 자동 ────")
_a6("  " .. (_a12.auto and "돌아가는 중" or "정지") ..
(_a42.auto.step and ("   지금: " .. _a42.auto.step) or ""))
local _a362, _a363 = _a42.quest.bestDepActive()
_a6("  현재 존 " .. tostring(_a42.move.curZone()) .. " / 최고 존 " .. tostring(_a42.move.bestZone()))
if _a362 then
_a6("  ⏸ 존해금·리버스 보류 중 — " .. tostring(_a363 and _a363.title))
else
_a6("  존해금·리버스 진행 가능")
end
_a6("")
_a6("  먼저 (순위 밖):")
for _a364, _a365 in ipairs(_a42.auto.SIDE) do
_a6(("      %-16s %s"):format(_a365.label, _a10.StepOn[_a365.key] and "ON" or "off"))
end
_a6("  우선순위:")
for _a366, _a367 in ipairs(_a42.auto.STEPS) do
_a6(("    %d. %-16s %s%s"):format(_a366, _a367.label,
_a10.StepOn[_a367.key] and "ON" or "off",
_a367.hold and "   (퀘스트 붙잡는 중엔 보류)" or ""))
end
_a6("")
_a6("  세이브")
local _a368 = _a8.Save
_a6("    Library.Client.Save : " .. (_a368 and "로드됨" or "★ 없음"))
if _a368 then
local _a369, _a370 = pcall(_a368.Get)
_a6("    Get()        : " .. (_a369 and type(_a370) or ("에러 " .. tostring(_a370))))
local _a371, _a372 = pcall(_a368.Get, _a4)
_a6("    Get(LP)      : " .. (_a371 and type(_a372) or ("에러 " .. tostring(_a372))))
if rawget(_a368, "GetSaves") then
local _a373, _a374 = pcall(_a368.GetSaves)
if _a373 and type(_a374) == "table" then
local _a375 = 0
for _a376 in pairs(_a374) do
_a375 += 1
if _a375 <= 3 then _a6("      키: " .. tostring(_a376)
.. (_a376 == _a4 and "   ← 내 LocalPlayer" or "")) end
end
_a6("    GetSaves()   : " .. _a375 .. "개")
else
_a6("    GetSaves()   : 에러 " .. tostring(_a374))
end
end
local _a377 = _a43()
if _a377 then
local _a378 = rawget(_a377, "Goals")
_a6("    → 읽기 성공. Rebirths " .. tostring(rawget(_a377, "Rebirths"))
.. " / Goals " .. (type(_a378) == "table" and #_a378 or "없음"))
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
for _a379, _a380 in ipairs(_a42.auto.lastTrace or {}) do _a6("    " .. _a380) end
_a97("log")
end },
{ label = "화면 넘기기 진단", col = _a55.warn, fn = function()
task.spawn(function()
_a6("")
_a6("──── 보상 화면 ────")
local _a381 = _a41.Vars
_a6("  Library.Variables : " .. (_a381 and "로드됨" or "없음"))
if _a381 then
_a6("    IsRebirthing = " .. tostring(rawget(_a381, "IsRebirthing")))
_a6("    IsRankingUp  = " .. tostring(rawget(_a381, "IsRankingUp")))
_a6("    OpeningEgg   = " .. tostring(rawget(_a381, "OpeningEgg")))
end
_a6("  debug.info     : " .. tostring(type(debug) == "table" and type(debug.info) == "function"))
_a6("  getgc          : " .. tostring(type(getgc) == "function"))
_a6("  debug.setupvalue: " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
local _a382 = _a4:FindFirstChildOfClass("PlayerGui")
if _a382 then
_a6("  떠 있는 차단 화면:")
local _a383 = false
for _a384, _a385 in ipairs(_a42.screen.BLOCKERS) do
local _a386 = _a382:FindFirstChild(_a385[1])
_a6(("    %-14s %s"):format(_a385[1],
_a386 and (_a386.Enabled and "★ 켜짐" or "꺼짐") or "없음"))
if _a386 and _a386.Enabled then _a383 = true end
end
if not _a383 then _a6("    (없음)") end
end
if type(getgc) == "function" and type(debug) == "table" and debug.info then
_a6("")
_a6("  Rebirth/RankUp 스크립트의 클로저 시그니처:")
local _a387, _a388 = {}, 0
for _a389, _a390 in ipairs({ true, false }) do
local _a391, _a392 = pcall(getgc, _a390)
if _a391 then
for _a393, _a394 in ipairs(_a392) do
if type(_a394) == "function" and _a388 < 25 then
local _a395, _a396 = pcall(debug.info, _a394, "s")
if _a395 and type(_a396) == "string"
and (_a396:find("Rebirth", 1, true) or _a396:find("Rank Up", 1, true)) then
local _a397, _a398 = pcall(debug.info, _a394, "a")
if _a397 then
local _a399 = {}
for _a400 = 1, 16 do
local _a401, _a402 = pcall(debug.getupvalue, _a394, _a400)
if not _a401 then break end
_a399[_a400] = type(_a402)
end
local _a403 = ("인자%d | %s"):format(_a398 or -1,
#_a399 > 0 and table.concat(_a399, ",") or "(없음)")
if not _a387[_a403] then
_a387[_a403] = true
_a388 += 1
_a6("    " .. _a403)
end
end
end
end
end
end
end
if _a388 == 0 then _a6("    (하나도 못 찾음)") end
end
for _a404, _a405 in ipairs({ "reward", "egg", "mastery", "card" }) do
_a42.screen._sig = nil
local _a406 = _a42.screen.findSignalFns(_a405)
_a6("")
_a6(("  [%s] 찾은 함수 %d개"):format(_a405, #_a406))
for _a407, _a408 in ipairs(_a406) do
_a6(("    %s%s"):format(_a408.exact and "★정확일치 " or "", tostring(_a408.src)))
_a6(("       upvalue %d개 : %s"):format(_a408.n or 0, tostring(_a408.sig)))
end
if #_a406 == 0 then
_a6("    (getgc 로 그 스크립트의 클로저를 못 찾음)")
end
local _a409, _a410 = _a42.screen.signal(_a405)
_a6(("    upvalue 신호 : %s (%s개 세팅)"):format(tostring(_a409), tostring(_a410)))
local _a411 = _a42.screen.SIGNAL[_a405]
_a6(("    게임내 입력발동 : %s"):format(
tostring(_a42.screen.pressInGame(_a411 and _a411.pats or {}))))
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
local _a412 = {}
for _a413, _a414 in ipairs(_a42.auto.SIDE) do
_a412[#_a412 + 1] = _a414.key .. "=" .. tostring(_a10.StepOn[_a414.key])
end
for _a415, _a416 in ipairs(_a42.auto.STEPS) do
_a412[#_a412 + 1] = _a416.key .. "=" .. tostring(_a10.StepOn[_a416.key])
end
_a6("  단계 ON/OFF : " .. table.concat(_a412, "  "))
_a6("  lockGoal    : " .. (_a42.ctl.lockGoal and tostring(_a42.ctl.lockGoal.q.title) or "없음"))
local _a417, _a418 = _a42.quest.bestDepActive()
_a6("  보류중?     : " .. tostring(_a417) .. (_a418 and ("  ← " .. tostring(_a418.title)) or ""))
_a6("  리모트      : 존 " .. (_a41.R_Zone and "O" or "X")
.. " / 리버스 " .. (_a41.R_Reb and "O" or "X"))
_a6("")
_a6("  ── 존 해금 판정 ──")
local _a419 = _a46()
if not _a419 then
_a6("    zoneStatus() = nil  ← 다음 존을 못 구함")
local _a420 = _a41.Zone and rawget(_a41.Zone, "GetNextZone")
if _a420 then
local _a421, _a422, _a423 = pcall(_a41.Zone.GetNextZone)
_a6("    GetNextZone → ok=" .. tostring(_a421)
.. " / " .. tostring(_a422) .. " / " .. tostring(_a423))
end
if _a41.Zone and rawget(_a41.Zone, "HasCompletedNextZoneQuests") then
local _a424, _a425 = pcall(_a41.Zone.HasCompletedNextZoneQuests)
_a6("    존 퀘스트 완료? " .. (_a424 and tostring(_a425) or ("에러 " .. tostring(_a425))))
end
else
_a6("    다음 존 : " .. tostring(_a419.id))
_a6(("    가격 %s %s / 보유 %s → %s"):format(
_a7(_a419.price or 0, 0), tostring(_a419.currency), _a7(_a419.have, 0),
_a419.ok and "지금 살 수 있음" or "부족"))
end
_a6("")
_a6("  ── 리버스 판정 ──")
local _a426 = _a51()
if not _a426 then _a6("    세이브 못 읽음")
else
_a6(("    현재 %d → 다음 %d"):format(_a426.current, _a426.nextN))
_a6("    최근 사유 : " .. tostring(_a42.auto.rebNote or "-"))
end
_a6("")
_a6("  ── 직전 바퀴 기록 ──")
if _a42.auto.lastTrace and #_a42.auto.lastTrace > 0 then
for _a427, _a428 in ipairs(_a42.auto.lastTrace) do _a6("    " .. _a428) end
_a6(("    (%.0f초 전)"):format(os.clock() - (_a42.auto.lastPassAt or os.clock())))
else
_a6("    아직 한 바퀴도 안 돌았음")
end
_a97("log")
end)
end },
})
local _a429, _a430 = _a130(_a326, "펫 이동속도", nil)
_a140(_a430, "petspd", function()
_a54("petspd", function() return 0.4 end, _a42.item.applyPetSpeed, "펫속도")
end)
_a151(_a429, {
{ label = "배수", value = _a10.PetSpeedMult, onChange = function(_a431)
local _a432 = tonumber(_a431) if _a432 and _a432 >= 1 then _a10.PetSpeedMult = _a432 end
end },
{ label = "기본 계수 (원래 0.45)", value = _a10.PetSpeedBase, onChange = function(_a433)
local _a434 = tonumber(_a433) if _a434 and _a434 > 0 then _a10.PetSpeedBase = _a434 end
end },
})
_a160(_a429, {
{ label = "지금 적용 / 확인", col = _a55.accent, fn = function()
local _a435, _a436 = _a42.item.applyPetSpeed()
_a6("")
_a6("──── 펫 이동속도 ────")
_a6("  PlayerPet 모듈 : " .. (_a41.PlayerPet and "로드됨" or "없음"))
_a6(("  적용된 펫 %d마리  (배수 %s / 계수 %s)"):format(
_a435, tostring(_a10.PetSpeedMult), tostring(_a10.PetSpeedBase)))
if _a436 then _a6("  " .. tostring(_a436)) end
if _a435 == 0 then _a6("  펫을 장착하고 다시 눌러보세요") end
_a97("log")
end },
})
_a54("petspd", function() return 0.4 end, _a42.item.applyPetSpeed, "펫속도")
_a54("rewatch", function() return 1 end, function()
_a42.screen.watchTick = (_a42.screen.watchTick or 0) + 1
_a42.egg.watchStuck()
if _a42.screen.dismissBusy then return end
local _a437, _a438 = _a42.screen.rewardScreenUp()
if _a437 and _a42.screen.screenGaveUp and (os.clock() - _a42.screen.screenGaveUp) < 30 then
return
end
if _a437 then
if _a42.screen.lastBlocker ~= _a438 then
_a42.screen.lastBlocker = _a438
_a6("[화면] " .. tostring(_a438) .. " 화면 감지 — 넘기는 중")
end
_a42.screen.dismissRewardScreens(20)
end
end, "보상화면")
local _a439, _a440 = _a130(_a326, "자동 파밍 유지", nil)
_a140(_a440, "farm", function()
_a54("farm", function() return _a10.FarmInterval end, _a45, "파밍")
end)
_a151(_a439, {
{ label = "주기", value = _a10.FarmInterval, onChange = function(_a441)
local _a442 = tonumber(_a441) if _a442 and _a442 >= 3 then _a10.FarmInterval = _a442 end
end },
})
local _a443, _a444 = _a130(_a326, "자동 존 해금", nil)
_a140(_a444, "zone", function()
_a54("zone", function() return _a10.ZoneInterval end, _a47, "존")
end)
_a151(_a443, {
{ label = "주기", value = _a10.ZoneInterval, onChange = function(_a445)
local _a446 = tonumber(_a445) if _a446 and _a446 >= 3 then _a10.ZoneInterval = _a446 end
end },
})
_a160(_a443, {
{ label = "다음 존 보기", col = _a55.accent, fn = function()
local _a447 = _a46()
_a6("")
if not _a447 then _a6("[존] 다음 존 없음 (최대 도달?)")
else
_a6("──── 다음 존 ────")
_a6("  " .. tostring(_a447.id))
_a6("  가격 " .. _a7(_a447.price or 0, 0) .. " " .. tostring(_a447.currency))
_a6("  보유 " .. _a7(_a447.have, 0))
_a6("  " .. (_a447.ok and "지금 해금 가능" or "부족"))
end
_a97("log")
end },
{ label = "지금 1회", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.zone = true _a47() _a12.zone = false _a97("log") end)
end },
})
local _a448, _a449 = _a130(_a326, "자동 부화", nil)
_a140(_a449, "mhatch", function()
_a54("mhatch", function() return _a10.MainHatchInterval end, _a50, "부화")
end)
_a151(_a448, {
{ label = "주기", value = _a10.MainHatchInterval, onChange = function(_a450)
local _a451 = tonumber(_a450) if _a451 and _a451 >= 1 then _a10.MainHatchInterval = _a451 end
end },
{ label = "한 번에 최대", value = _a10.MainHatchMax, onChange = function(_a452)
local _a453 = tonumber(_a452) if _a453 and _a453 >= 1 then _a10.MainHatchMax = math.floor(_a453) end
end },
})
_a151(_a448, {
{ label = "예비금", value = _a10.MainHatchReserve, onChange = function(_a454)
local _a455 = tonumber(_a454) if _a455 and _a455 >= 0 then _a10.MainHatchReserve = _a455 end
end },
{ label = "알 ID (비우면 자동)", value = _a10.MainEggId, onChange = function(_a456)
_a10.MainEggId = _a456 or ""
end },
})
_a151(_a448, {
{ label = "알 인식 거리", value = _a10.EggRange, onChange = function(_a457)
local _a458 = tonumber(_a457) if _a458 and _a458 >= 5 then _a10.EggRange = _a458 end
end },
})
_a170(_a448, "새 맵 열리면 잠긴 알 자동 해금",
function() return _a10.AutoUnlockEgg end,
function(_a459) _a10.AutoUnlockEgg = _a459 end)
_a170(_a448, "게임 내장 오토해치 사용 (기본 끔)",
function() return _a10.UseAutoHatch end,
function(_a460) _a10.UseAutoHatch = _a460 if not _a460 then _a42.egg.autoHatchOff() end end)
_a170(_a448, "까는 화면 자동으로 넘기기 (신호)",
function() return _a10.HatchClick end,
function(_a461) _a10.HatchClick = _a461 end)
_a160(_a448, {
{ label = "잠긴 알 보기", col = _a55.accent, fn = function()
local _a462, _a463, _a464 = _a42.egg.lockedEggs()
_a6("")
_a6("──── 알 해금 현황 ────")
_a6(("  해금 가능 최대 : #%d   /   현재 해금한 최대 : #%d"):format(_a463, _a464))
_a6("  해금 리모트 : " .. (_a41.R_EggUn and "있음" or "없음"))
if #_a462 == 0 then
_a6("  풀 수 있는 알이 없음 (다 풀었거나 존을 더 사야 함)")
else
_a6("  아직 안 푼 알 " .. #_a462 .. "개:")
for _a465, _a466 in ipairs(_a462) do
_a6(("    #%-3d %s"):format(_a466.num, _a466.id))
if _a465 >= 20 then _a6("    ...") break end
end
end
_a97("log")
end },
{ label = "부화 진단", col = _a55.warn, fn = function()
task.spawn(function()
_a6("")
_a6("──── 부화 진단 ────")
local _a467, _a468, _a469, _a470 = _a48()
_a6("  대상 알   : " .. tostring(_a467))
if not _a467 then _a6("  (오픈한 알이 없음)") _a97("log") return end
local _a471 = _a468 and tonumber(rawget(_a468, "eggNumber"))
_a6("  알 번호   : " .. tostring(_a471) .. "   오픈함? " .. tostring(_a42.egg.eggUnlocked(_a471)))
_a6("  거리      : " .. (_a469 and ("%.0f (사거리 안)"):format(_a469)
or ((_a470 and ("%.0f (사거리 %d 밖)"):format(_a470, _a10.EggRange)) or "받침대 못 찾음")))
local _a472 = _a468 and rawget(_a468, "currency") or "?"
_a6("  통화      : " .. tostring(_a472) .. "   보유 " .. _a7(_a44(_a472), 0))
if type(_a41.CalcEgg) == "function" then
local _a473, _a474 = pcall(_a41.CalcEgg, _a468)
_a6("  CalcEggPricePlayer : " .. (_a473 and tostring(_a474) or ("에러 " .. tostring(_a474))))
end
if type(_a41.CalcEggB) == "function" then
local _a475, _a476 = pcall(_a41.CalcEggB, _a468)
_a6("  CalcEggPrice       : " .. (_a475 and tostring(_a476) or ("에러 " .. tostring(_a476))))
end
if _a41.Egg then
for _a477, _a478 in ipairs({ "GetMaxHatch", "ComputeDebounce", "GetHighestEggNumberAvailable" }) do
if rawget(_a41.Egg, _a478) then
local _a479, _a480 = pcall(_a41.Egg[_a478], _a468)
_a6(("  %-28s : %s"):format(_a478, _a479 and tostring(_a480) or ("에러 " .. tostring(_a480))))
end
end
end
_a6("  OpeningEgg      : " .. tostring(_a41.Vars and rawget(_a41.Vars, "OpeningEgg")))
if _a41.Hatch then
for _a481, _a482 in ipairs({ "IsHatching", "GetEggAmount" }) do
if rawget(_a41.Hatch, _a482) then
local _a483, _a484 = pcall(_a41.Hatch[_a482])
_a6(("  %-15s : %s"):format(_a482, _a483 and tostring(_a484) or ("에러 " .. tostring(_a484))))
end
end
if rawget(_a41.Hatch, "GetEggDirectory") then
local _a485, _a486 = pcall(_a41.Hatch.GetEggDirectory)
_a6("  세팅된 알       : " .. (_a485 and _a486 and tostring(rawget(_a486, "_id")) or "없음"))
end
end
_a6("  ▶ SetupEgg 시도")
_a42.egg._ahEgg = nil
_a42.egg.autoHatchOn(_a467, 1)
if _a41.Hatch and rawget(_a41.Hatch, "IsHatching") then
local _a487, _a488 = pcall(_a41.Hatch.IsHatching)
_a6("    IsHatching 이후 : " .. (_a487 and tostring(_a488) or ("에러 " .. tostring(_a488))))
_a6("    " .. ((_a487 and _a488) and "→ 클릭 없이 넘어갑니다"
or "→ SetupEgg 안 먹음. 클릭 대체가 필요합니다"))
end
_a6("  신호 가능 : getgc " .. tostring(type(getgc) == "function")
.. " / debug.setupvalue " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
_a6("")
_a6("  ▶ 1개로 실제 호출")
local _a489, _a490
local _a491 = pcall(function() _a489, _a490 = _a9.R_EGG:InvokeServer(_a467, 1) end)
_a6("    호출성공 : " .. tostring(_a491))
_a6("    반환1    : " .. tostring(_a489))
_a6("    반환2    : " .. tostring(_a490))
_a97("log")
end)
end },
{ label = "지금 전부 해금", col = _a55.good, fn = function()
task.spawn(function()
_a6("")
local _a492, _a493 = _a42.egg.unlockEggs(true)
_a6(_a492 > 0 and ("[해금] %d개 완료"):format(_a492)
or ("[해금] 0개" .. (_a493 and (" — " .. tostring(_a493)) or "")))
_a97("log")
end)
end },
})
_a160(_a448, {
{ label = "알 현황 보기", col = _a55.accent, fn = function()
local _a494 = _a49()
_a6("")
if not _a494 then _a6("[부화] 알을 못 찾음")
else
_a6("──── 메인 알 ────")
_a6("  " .. tostring(_a494.id))
_a6("  가격 " .. (_a494.price and _a7(_a494.price, 0) or "?") .. " " .. tostring(_a494.currency))
_a6("  보유 " .. _a7(_a494.have, 0))
_a6("  한 번에 " .. _a494.maxN .. "개까지")
_a6("  지금 가능 " .. _a494.canBuy .. "회")
if _a494.inRange then
_a6(("  거리 %.0f 스터드 — 부화 가능"):format(_a494.dist))
else
_a6(("  사거리(%d) 안에 알 없음. 가장 가까운 알 %s스터드"):format(
_a10.EggRange, _a494.nearest and ("%.0f"):format(_a494.nearest) or "?"))
_a6("  → 알 앞으로 걸어가야 부화됩니다")
end
end
_a6("")
_a6("──── 주변 알 (가까운 순 10개) ────")
local _a495 = _a42.egg.eggStands()
for _a496 = 1, math.min(10, #_a495) do
local _a497 = _a495[_a496]
_a6(("  %6.0f  #%-3d %-24s %s"):format(
_a497.dist, _a497.num, _a497.id, _a42.egg.eggUnlocked(_a497.num) and "오픈함" or "잠김"))
end
if #_a495 == 0 then _a6("  (못 찾음)") end
_a97("log")
end },
{ label = "지금 1회", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.mhatch = true _a50() _a12.mhatch = false _a97("log") end)
end },
})
local _a498, _a499 = _a130(_a326, "랭크 퀘스트 자동", nil)
_a140(_a499, "quest", function()
_a54("quest", function() return _a10.QuestInterval end, _a42.quest.cycle, "퀘스트")
end)
_a151(_a498, {
{ label = "주기", value = _a10.QuestInterval, onChange = function(_a500)
local _a501 = tonumber(_a500) if _a501 and _a501 >= 5 then _a10.QuestInterval = _a501 end
end },
{ label = "포션 한 번에", value = _a10.QuestUseMax, onChange = function(_a502)
local _a503 = tonumber(_a502) if _a503 and _a503 >= 1 then _a10.QuestUseMax = math.floor(_a503) end
end },
})
_a170(_a498, "필요한 자동화 자동 ON",
function() return _a10.QuestDrive end,
function(_a504) _a10.QuestDrive = _a504 end)
_a170(_a498, "포션/인챈트 업글 퀘스트",
function() return _a10.QuestUpgrade end,
function(_a505) _a10.QuestUpgrade = _a505 end)
_a170(_a498, "포션 사용 퀘스트",
function() return _a10.QuestUsePotion end,
function(_a506) _a10.QuestUsePotion = _a506 end)
_a160(_a498, {
{ label = "퀘스트 현황 보기", col = _a55.accent, fn = function()
local _a507 = _a42.quest.status()
_a6("")
if not _a507 then _a6("[퀘스트] 세이브 못 읽음")
else
_a6("──── 랭크 퀘스트 ────")
_a6(("  Rank %d   ★%d"):format(_a507.rank, _a507.rankStars))
if #_a507.list == 0 then _a6("  퀘스트 없음") end
for _a508, _a509 in ipairs(_a507.list) do
local _a510 = _a509.how
local _a511 =
(_a510 == "farm" and "자동 파밍") or
(_a510 == "hatch" and "자동 부화") or
(_a510 == "zone" and "자동 존") or
(_a510 == "potup" and "포션 업글") or
(_a510 == "encup" and "인챈트 업글") or
(_a510 == "potuse" and "포션 사용") or
(_a510 == "fruituse" and "과일 사용") or
(_a510 == "flaguse" and "깃발 사용") or
(_a510 == "gold" and "골드 머신") or
(_a510 == "rainbow" and "레인보우 머신") or
"수동"
local _a512 = ""
if _a509.ignored then
_a511 = "무시"
_a512 = "   → " .. _a509.ignored
elseif _a509.event then
local _a513 = _a42.ev.findEvent(_a509.event, _a509.bestOnly)
_a512 = _a513 and ("   → %s @%s %d초"):format(_a513.name, tostring(_a513.zone), _a513.left)
or ("   → " .. _a509.event .. " 대기중")
elseif _a509.chest then
_a512 = "   → " .. _a509.chest
elseif _a509.where then
_a512 = "   → " .. _a509.where
end
_a6(("  [%d] %s"):format(_a509.stars, tostring(_a509.title)))
_a6(("       %d / %d    처리: %s   (Type %d)%s"):format(
_a509.progress, _a509.amount, _a511, _a509.type, _a512))
end
end
_a97("log")
end },
{ label = "활성 이벤트 보기", col = _a55.accent, fn = function()
local _a514 = _a42.ev.events()
local _a515 = _a42.move.bestZone()
_a6("")
_a6("──── 지금 떠 있는 랜덤 이벤트 ────")
_a6("  최고 존 : " .. tostring(_a515) .. "   현재 존 : " .. tostring(_a42.move.curZone()))
if #_a514 == 0 then _a6("  없음 (RandomEvents_Get 응답 비어있음)") end
for _a516, _a517 in ipairs(_a514) do
_a6(("  %-12s @%-20s %4d초 남음  %s%s"):format(
_a517.kind, tostring(_a517.zone), _a517.left,
_a517.pos and ("(%.0f, %.0f, %.0f)"):format(_a517.pos.X, _a517.pos.Y, _a517.pos.Z) or "좌표없음",
_a517.zone == _a515 and "  ★최고존" or ""))
end
_a6("")
_a6("  내 소환 아이템 :")
for _a518 in pairs(_a42.ev.SPAWN) do
local _a519 = _a42.ev.spawnItems(_a518)
local _a520 = 0
for _a521, _a522 in ipairs(_a519) do _a520 += _a522.am end
_a6(("    %-12s %d종 %d개"):format(_a518, #_a519, _a520))
for _a523, _a524 in ipairs(_a519) do
_a6(("        %d. %-24s x%d%s"):format(
_a523, _a524.id, _a524.am, _a523 == 1 and "   ← 먼저 씀" or ""))
if _a523 >= 6 then break end
end
end
_a6("  점선 네모 안? " .. tostring(_a42.move.inDottedBox()))
for _a525, _a526 in ipairs({ "MiniChests", "SuperiorMiniChests" }) do
local _a527, _a528 = _a42.ev.findChest(_a526)
_a6(("  %-20s %s"):format(_a526,
_a527 and ("가장 가까운 것 %.0f스터드"):format(_a528 or 0) or "없음"))
end
_a97("log")
end },
{ label = "포션 재고 보기", col = _a55.accent, fn = function()
_a6("")
_a6("──── 포션 / 인챈트 재고 ────")
for _a529, _a530 in ipairs({ "Potion", "Enchant" }) do
local _a531 = _a42.item.stacks(_a530)
table.sort(_a531, function(_a532, _a533)
if _a532.id ~= _a533.id then return _a532.id < _a533.id end
return _a532.tier < _a533.tier
end)
_a6("")
_a6(_a530 .. "  (" .. #_a531 .. "종)")
for _a534, _a535 in ipairs(_a531) do
local _a536 = _a42.item.perTier(_a530, _a535.tier)
local _a537 = _a536 and math.floor(_a535.am / _a536) or 0
_a6(("   %-20s T%-2d x%-6d %s"):format(
_a535.id, _a535.tier, _a535.am,
_a537 > 0 and ("→ T" .. (_a535.tier + 1) .. " " .. _a537 .. "개 제작가능") or ""))
if _a534 >= 40 then _a6("   ...") break end
end
if #_a531 == 0 then _a6("   (없음)") end
end
_a97("log")
end },
{ label = "지금 1회", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.quest = true _a42.quest.cycle() _a12.quest = false _a97("log") end)
end },
})
local _a538, _a539 = _a130(_a326, "슬롯 머신 자동 (다이아)", nil)
_a140(_a539, "slots", function()
_a54("slots", function() return _a10.SlotInterval end, _a42.mach.cycleSlots, "슬롯")
end)
_a151(_a538, {
{ label = "주기", value = _a10.SlotInterval, onChange = function(_a540)
local _a541 = tonumber(_a540) if _a541 and _a541 >= 5 then _a10.SlotInterval = _a541 end
end },
{ label = "남길 다이아", value = _a10.SlotReserve, onChange = function(_a542)
local _a543 = tonumber(_a542) if _a543 and _a543 >= 0 then _a10.SlotReserve = _a543 end
end },
})
_a170(_a538, "펫 장착 슬롯 (Pet Equip)",
function() return _a10.SlotPet end, function(_a544) _a10.SlotPet = _a544 end)
_a170(_a538, "알 부화 슬롯 (Egg Machine)",
function() return _a10.SlotEgg end, function(_a545) _a10.SlotEgg = _a545 end)
_a160(_a538, {
{ label = "슬롯 현황 보기", col = _a55.accent, fn = function()
local _a546 = _a42.mach.slotStatus()
_a6("")
_a6("──── 슬롯 머신 ────")
if not _a546 then _a6("  세이브 못 읽음") _a97("log") return end
_a6("  다이아 " .. _a7(_a546.dia, 0))
_a6("")
_a6(("  펫 장착 : 구매 %d / 랭크상한 %d   현재 최대장착 %s"):format(
_a546.petOwned, _a546.petMax, tostring(_a546.maxEquip)))
if _a546.petNext then
_a6(("     다음 #%d  %s 다이아  %s"):format(
_a546.petNext, _a546.petCost and _a7(_a546.petCost, 0) or "?",
(_a546.petCost and _a546.petCost <= _a546.dia - _a10.SlotReserve) and "← 지금 가능" or "부족"))
else
_a6("     랭크 상한까지 다 삼 (랭크를 올려야 더 살 수 있음)")
end
_a6("")
_a6(("  알 부화 : 구매 %d / 랭크상한 %d   한 번에 %s개"):format(
_a546.eggOwned, _a546.eggMax, tostring(_a546.maxHatch)))
if _a546.eggEnd then
_a6(("     다음 %d칸 묶음 → %d   %s 다이아  %s"):format(
_a546.eggSize, _a546.eggEnd, _a546.eggCost and _a7(_a546.eggCost, 0) or "?",
(_a546.eggCost and _a546.eggCost <= _a546.dia - _a10.SlotReserve) and "← 지금 가능" or "부족"))
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
local _a547, _a548 = _a130(_a326, "아이템 자동 사용 (버프 유지)", nil)
_a140(_a548, "items", function()
_a54("items", function() return _a10.ItemInterval end, _a42.item.cycleItems, "아이템")
end)
_a151(_a547, {
{ label = "주기", value = _a10.ItemInterval, onChange = function(_a549)
local _a550 = tonumber(_a549) if _a550 and _a550 >= 5 then _a10.ItemInterval = _a550 end
end },
{ label = "포션 한 바퀴 최대", value = _a10.BuffMaxPotion, onChange = function(_a551)
local _a552 = tonumber(_a551) if _a552 and _a552 >= 1 then _a10.BuffMaxPotion = math.floor(_a552) end
end },
})
_a151(_a547, {
{ label = "남길 개수", value = _a10.ItemKeep, onChange = function(_a553)
local _a554 = tonumber(_a553) if _a554 and _a554 >= 0 then _a10.ItemKeep = math.floor(_a554) end
end },
{ label = "과일/소모품 최대", value = _a10.BuffMaxOther, onChange = function(_a555)
local _a556 = tonumber(_a555) if _a556 and _a556 >= 1 then _a10.BuffMaxOther = math.floor(_a556) end
end },
})
_a151(_a547, {
{ label = "쓸 것 (비우면 전부)", value = _a10.ItemAllow, onChange = function(_a557)
_a10.ItemAllow = _a557 or ""
end },
{ label = "제외", value = _a10.ItemBlock, onChange = function(_a558)
_a10.ItemBlock = _a558 or ""
end },
})
_a170(_a547, "포션", function() return _a10.BuffPotion end,
function(_a559) _a10.BuffPotion = _a559 end)
_a170(_a547, "과일", function() return _a10.BuffFruit end,
function(_a560) _a10.BuffFruit = _a560 end)
_a170(_a547, "얼티밋 (충전되면 발동, 무료)", function() return _a10.BuffUltimate end,
function(_a561) _a10.BuffUltimate = _a561 end)
_a170(_a547, "소모품 (Rain/Sunlight 주의)", function() return _a10.BuffConsumable end,
function(_a562) _a10.BuffConsumable = _a562 end)
_a170(_a547, "높은 티어부터 사용 (끄면 낮은 것부터)", function() return _a10.BuffHighTier end,
function(_a563) _a10.BuffHighTier = _a563 end)
_a170(_a547, "최고 존에서만 사용", function() return _a10.ItemBestZone end,
function(_a564) _a10.ItemBestZone = _a564 end)
_a170(_a547, "최고 존이 아니면 이동 후 사용", function() return _a10.ItemTp end,
function(_a565) _a10.ItemTp = _a565 end)
_a160(_a547, {
{ label = "버프 현황 보기", col = _a55.accent, fn = function()
_a6("")
_a6("──── 버프 / 아이템 ────")
_a6(("  현재 존 %s / 최고 존 %s%s"):format(
tostring(_a42.move.curZone()), tostring(_a42.move.bestZone()),
_a10.ItemBestZone and (_a42.move.curZone() == _a42.move.bestZone() and "   ← 사용 가능" or "   ← 이동 필요") or ""))
for _a566, _a567 in pairs({ Potions = "Potion", Fruits = "Fruit" }) do
local _a568 = _a42.item.activeBuffs(_a566)
local _a569 = {}
for _a570 in pairs(_a568) do _a569[#_a569 + 1] = _a570 end
table.sort(_a569)
_a6(("  지금 걸린 %s : %s"):format(_a566,
#_a569 > 0 and table.concat(_a569, ", ") or "없음"))
end
local _a571 = _a43()
local _a572 = _a571 and rawget(_a571, "Ultimates")
if type(_a572) == "table" then
local _a573 = {}
for _a574 in pairs(_a572) do
local _a575 = "?"
if _a41.Ult and rawget(_a41.Ult, "IsCharged") then
local _a576, _a577 = pcall(_a41.Ult.IsCharged, _a574)
_a575 = _a576 and (_a577 and "충전됨" or "충전중") or "?"
end
_a573[#_a573 + 1] = _a574 .. "(" .. _a575 .. ")"
end
_a6("  얼티밋 : " .. (#_a573 > 0 and table.concat(_a573, ", ") or "없음"))
end
_a6("")
for _a578, _a579 in ipairs({ "Potion", "Fruit", "Consumable" }) do
local _a580 = _a42.item.stacks(_a579)
local _a581, _a582 = 0, 0
for _a583, _a584 in ipairs(_a580) do
if _a42.item.itemAllowed(_a584.id) then _a581 += 1 else _a582 += 1 end
end
_a6(("  %-12s %d종 (쓸 수 있음 %d / 제외 %d)"):format(_a579, #_a580, _a581, _a582))
for _a585, _a586 in ipairs(_a580) do
_a6(("      %-20s T%-2d x%-6d %s"):format(
_a586.id, _a586.tier, _a586.am, _a42.item.itemAllowed(_a586.id) and "" or "제외됨"))
if _a585 >= 12 then _a6("      ...") break end
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
local _a587, _a588 = _a130(_a326, "맵 업그레이드 자동 (다이아)", nil)
_a140(_a588, "mapupg", function()
_a54("mapupg", function() return _a10.UpgInterval end, _a42.mach.cycleUpg, "맵업글")
end)
_a151(_a587, {
{ label = "주기", value = _a10.UpgInterval, onChange = function(_a589)
local _a590 = tonumber(_a589) if _a590 and _a590 >= 5 then _a10.UpgInterval = _a590 end
end },
{ label = "남길 다이아", value = _a10.UpgReserve, onChange = function(_a591)
local _a592 = tonumber(_a591) if _a592 and _a592 >= 0 then _a10.UpgReserve = _a592 end
end },
})
_a170(_a587, "구매 전 그 앞으로 이동",
function() return _a10.UpgTp end,
function(_a593) _a10.UpgTp = _a593 end)
_a160(_a587, {
{ label = "업그레이드 목록", col = _a55.accent, fn = function()
local _a594 = _a42.mach.upgList()
local _a595 = _a44("Diamonds")
_a6("")
_a6("──── 맵 업그레이드 ────")
_a6("보유 다이아 " .. _a7(_a595, 0))
if #_a594 == 0 then
_a6("  로드된 업그레이드 기둥이 없음 (해당 존에 가야 보입니다)")
end
local _a596, _a597, _a598 = 0, 0, 0
for _a599, _a600 in ipairs(_a594) do
if _a600.bought then _a597 += 1
elseif not _a600.zoneOwned then _a598 += 1
else _a596 += 1 end
end
_a6(("  구매가능 %d / 구매완료 %d / 존 미보유 %d"):format(_a596, _a597, _a598))
_a6("")
local _a601 = 0
for _a602, _a603 in ipairs(_a594) do
if _a603.buyable then
_a601 += 1
_a6(("  %-12s T%-2d %-20s %12s %-9s %s"):format(
_a603.id, _a603.tier, _a603.zone, _a603.cost and _a7(_a603.cost, 0) or "?",
tostring(_a603.cur),
(_a603.cost and _a603.cost <= _a44(_a603.cur or "Diamonds") - _a10.UpgReserve)
and "← 지금 가능" or ""))
if _a601 >= 25 then _a6("  ...") break end
end
end
_a97("log")
end },
{ label = "업글 진단", col = _a55.warn, fn = function()
task.spawn(function()
_a6("")
_a6("──── 맵 업그레이드 진단 ────")
_a6("  리모트 : " .. (_a41.R_Upg and _a41.R_Upg:GetFullName() or "없음"))
local _a604 = _a42.mach.upgList()
_a6("  로드된 기둥 " .. #_a604 .. "개")
local _a605
for _a606, _a607 in ipairs(_a604) do
if _a607.buyable and _a607.cost then _a605 = _a607 break end
end
if not _a605 then
_a6("  살 수 있는 게 없음 (전부 구매완료거나 존 미보유)")
for _a608, _a609 in ipairs(_a604) do
_a6(("   %-12s T%-2d @%-18s 구매됨=%s 존보유=%s"):format(
_a609.id, _a609.tier, tostring(_a609.zone), tostring(_a609.bought), tostring(_a609.zoneOwned)))
if _a608 >= 8 then _a6("   ...") break end
end
_a97("log") return
end
local _a610 = _a44(_a605.cur or "Diamonds")
local _a611 = _a42.move.hrp()
local _a612 = (_a611 and _a605.pos) and (_a611.Position - _a605.pos).Magnitude or nil
_a6(("  대상 : %s T%d @%s"):format(_a605.id, _a605.tier, tostring(_a605.zone)))
_a6(("  가격 : %s %s / 보유 %s"):format(
_a7(_a605.cost, 0), tostring(_a605.cur), _a7(_a610, 0)))
_a6("  거리 : " .. (_a612 and ("%.0f 스터드"):format(_a612) or "좌표 없음"))
_a6("")
_a6("  ▶ 제자리에서 호출")
local _a613, _a614
local _a615 = pcall(function() _a613, _a614 = _a41.R_Upg:InvokeServer(_a605.id, _a605.zone) end)
_a6("    호출성공 " .. tostring(_a615) .. " / 반환1 " .. tostring(_a613)
.. " / 반환2 " .. tostring(_a614))
if not _a613 and _a605.pos then
_a6("")
_a6("  ▶ 기둥 앞으로 이동해서 재시도")
_a42.move.glideTo(_a605.pos)
task.wait(0.3)
local _a616 = _a42.move.hrp()
_a6("    이동후 거리 " .. (_a616 and ("%.0f"):format((_a616.Position - _a605.pos).Magnitude) or "?"))
local _a617, _a618
local _a619 = pcall(function() _a617, _a618 = _a41.R_Upg:InvokeServer(_a605.id, _a605.zone) end)
_a6("    호출성공 " .. tostring(_a619) .. " / 반환1 " .. tostring(_a617)
.. " / 반환2 " .. tostring(_a618))
_a6("")
_a6(_a617 and "  → 거리 검사 있음. 이동해야 됩니다."
or "  → 이동해도 실패. 거리 문제가 아닙니다.")
else
_a6("")
_a6(_a613 and "  → 원격으로 됩니다. 이동 불필요." or "  → 실패 (좌표 없음)")
end
_a97("log")
end)
end },
{ label = "지금 1회", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.mapupg = true _a42.mach.cycleUpg() _a12.mapupg = false _a97("log") end)
end },
})
local _a620, _a621 = _a130(_a326, "자동 리버스", nil)
_a140(_a621, "mreb", function()
_a54("mreb", function() return _a10.MainRebirthInterval end, _a52, "리버스")
end)
_a151(_a620, {
{ label = "주기", value = _a10.MainRebirthInterval, onChange = function(_a622)
local _a623 = tonumber(_a622) if _a623 and _a623 >= 10 then _a10.MainRebirthInterval = _a623 end
end },
})
_a170(_a620, "실패 이유 로그",
function() return _a10.MainRebirthVerbose end,
function(_a624) _a10.MainRebirthVerbose = _a624 end)
_a160(_a620, {
{ label = "리버스 현황 보기", col = _a55.accent, fn = function()
local _a625 = _a51()
_a6("")
if not _a625 then _a6("[리버스] 세이브 못 읽음")
else
_a6("──── 메인 리버스 ────")
_a6("  현재 " .. _a625.current .. "회 → 다음 " .. _a625.nextN)
if type(_a625.def) == "table" then
for _a626, _a627 in pairs(_a625.def) do
if type(_a627) ~= "table" and type(_a627) ~= "function" then
_a6("    " .. tostring(_a626) .. " = " .. tostring(_a627))
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
local _a628 = _a130(_a326, "전체 제어", nil)
_a160(_a628, {
{ label = "메인 전부 ON", col = _a55.good, fn = function()
local _a629 = {
{ "farm",   function() return _a10.FarmInterval end,       _a45,       "파밍" },
{ "zone",   function() return _a10.ZoneInterval end,       _a47,       "존" },
{ "mhatch", function() return _a10.MainHatchInterval end,  _a50,  "부화" },
{ "quest",  function() return _a10.QuestInterval end,      _a42.quest.cycle,        "퀘스트" },
{ "mapupg", function() return _a10.UpgInterval end,        _a42.mach.cycleUpg,     "맵업글" },
{ "items",  function() return _a10.ItemInterval end,       _a42.item.cycleItems,   "아이템" },
{ "slots",  function() return _a10.SlotInterval end,       _a42.mach.cycleSlots,   "슬롯" },
}
for _a630, _a631 in ipairs(_a629) do
if not _a12[_a631[1]] then
_a12[_a631[1]] = true
_a54(_a631[1], _a631[2], _a631[3], _a631[4])
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
local _a632 = table.concat(_a5, "\n")
if #_a632 > 900000 then _a632 = _a632:sub(#_a632 - 900000) end
if type(setclipboard) == "function" then
pcall(setclipboard, _a632)
_a88.Text = "완료"
task.delay(1.5, function() if _a88 then _a88.Text = "복사" end end)
end
end)
_a87.MouseButton1Click:Connect(function()
table.clear(_a5)
_a182.top = nil
_a1.dirty = true
end)
local function _a633()
_a12.place, _a12.merchant, _a12.upgrade = false, false, false
_a12.towerup, _a12.crop, _a12.expand, _a12.rebirth, _a12.hatch, _a12.luck = false, false, false, false, false, false
_a12.farm, _a12.zone, _a12.mhatch, _a12.rank, _a12.mreb = false, false, false, false, false
if _a202 then _a202:Disconnect() end
if _a73 then _a73:Destroy() end
_G.__PS99_GARDEN = nil
end
_a85.MouseButton1Click:Connect(_a633)
_G.__PS99_GARDEN = _a633
_a97("main")
_a6("PS99 자동")
if _a1.lpWait then
_a6(("[진단] LocalPlayer 가 늦게 잡혔습니다 — %.1f초 대기, 결과 %s")
:format(_a1.lpWait, _a1.lpFail and "★ 실패" or "성공"))
end
if _a1.lpFail then
_a6("[진단] ★ LocalPlayer 를 못 잡아 이동·부화가 전부 안 됩니다.")
_a6("        게임이 완전히 로드된 뒤에 다시 실행해 주세요.")
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
local _a634, _a635 = pcall(_a42.auto.start)
if _a634 then
_a6("[자동] 시작됨")
else
_a12.auto = false
_a6("[자동] 시작 실패: " .. tostring(_a635))
if _a42.auto.refresh then pcall(_a42.auto.refresh) end
end
end)
else
_a12.auto = false
_a6("[자동] QS.auto.start 가 없습니다 — 메인 게임 탭이 안 만들어짐")
end
end
pcall(function()
local _a636, _a637, _a638, _a639 = _a15()
if _a636 and _a638 then
local _a640 = _a16(_a638, _a639)
_a13.slots = #_a640
_a6("레인 " .. _a639 .. " / 슬롯 " .. #_a640)
else
_a6("가든 이벤트 밖입니다 (이벤트 탭은 이벤트 안에서만 동작)")
end
_a13.sun = _a21()
_a6("Sunflowers " .. _a7(_a13.sun, 0))
end)
end
