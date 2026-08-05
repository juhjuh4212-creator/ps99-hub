return function(_a1)
local _a2, _a3, _a4, _a5, _a6, _a7 = _a1.UIS, _a1.RunService, _a1.LP, _a1.LOG, _a1.log, _a1.num
local _a8, _a9, _a10, _a11, _a12, _a13 = _a1.RM, _a1.CFG, _a1.EGG_COST_CACHE, _a1.RUN, _a1.STAT, _a1.EVENT_UPGRADES
local _a14, _a15, _a16, _a17, _a18, _a19 = _a1.ctx, _a1.collectSlots, _a1.placedTowers, _a1.availableItems, _a1.cyclePlace, _a1.cycleMerchant
local _a20, _a21, _a22, _a23, _a24, _a25 = _a1.sunflowers, _a1.eventTiers, _a1.nextCost, _a1.cycleUpgrade, _a1.seedInv, _a1.bedsOf
local _a26, _a27, _a28, _a29, _a30, _a31 = _a1.isUnhatched, _a1.bedCps, _a1.cycleCrop, _a1.laneCosts, _a1.lockedBeds, _a1.cycleExpand
local _a32, _a33, _a34, _a35, _a36 = _a1.rebirthStatus, _a1.cycleRebirth, _a1.hatchStatus, _a1.cycleHatch, _a1.LUCK_ORDER
local _a37, _a38, _a39, _a40, _a41, _a42 = _a1.luckStatus, _a1.fmtDur, _a1.cycleLuck, _a1.MG, _a1.QS, _a1.saveGet
local _a43, _a44, _a45, _a46, _a47, _a48 = _a1.currencyAmount, _a1.cycleFarm, _a1.zoneStatus, _a1.cycleZone, _a1.bestMainEgg, _a1.mainHatchStatus
local _a49, _a50, _a51, _a52, _a53 = _a1.cycleMainHatch, _a1.mainRebirthStatus, _a1.cycleMainRebirth, _a1.cycleTowerUp, _a1.startLoop
local _a54 = {
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
local function _a55(_a56, _a57, _a58)
local _a59 = Instance.new(_a56)
for _a60, _a61 in pairs(_a57) do _a59[_a60] = _a61 end
if _a58 then _a59.Parent = _a58 end
return _a59
end
local function _a62(_a63, _a64) _a55("UICorner", { CornerRadius = UDim.new(0, _a64 or 8) }, _a63) end
local function _a65(_a66, _a67, _a68)
_a55("UIStroke", { Color = _a67 or _a54.line, Thickness = _a68 or 1,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, _a66)
end
local function _a69(_a70, _a71)
_a55("UIPadding", {
PaddingTop = UDim.new(0, _a71), PaddingBottom = UDim.new(0, _a71),
PaddingLeft = UDim.new(0, _a71), PaddingRight = UDim.new(0, _a71),
}, _a70)
end
local _a72 = _a55("ScreenGui", {
Name = "PS99GardenAuto", ResetOnSpawn = false,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
IgnoreGuiInset = true, DisplayOrder = 9999,
})
local _a73 = false
if type(gethui) == "function" then _a73 = pcall(function() _a72.Parent = gethui() end) end
if not _a73 then _a73 = pcall(function() _a72.Parent = game:GetService("CoreGui") end) end
if not _a73 then _a72.Parent = _a4:WaitForChild("PlayerGui") end
local _a74, _a75 = 780, 520
local _a76 = _a55("Frame", {
Size = UDim2.fromOffset(_a74, _a75), Position = UDim2.new(0.5, -_a74 / 2, 0.5, -_a75 / 2),
BackgroundColor3 = _a54.bg, BorderSizePixel = 0, Active = true, ClipsDescendants = true,
}, _a72)
_a62(_a76, 12)
_a65(_a76, Color3.fromRGB(60, 66, 82), 1)
local _a77 = _a55("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = _a54.panel, BorderSizePixel = 0,
}, _a76)
_a62(_a77, 12)
_a55("Frame", {
Size = UDim2.new(1, 0, 0, 12), Position = UDim2.new(0, 0, 1, -12),
BackgroundColor3 = _a54.panel, BorderSizePixel = 0,
}, _a77)
_a55("Frame", {
Size = UDim2.fromOffset(10, 10), Position = UDim2.fromOffset(14, 15),
BackgroundColor3 = _a54.good, BorderSizePixel = 0,
}, _a77).Name = "Dot"
_a62(_a77:FindFirstChild("Dot"), 5)
_a55("TextLabel", {
Size = UDim2.new(0, 320, 1, 0), Position = UDim2.fromOffset(32, 0),
BackgroundTransparency = 1, Text = "Garden Defenders  AutoPlay",
TextColor3 = _a54.text, TextSize = 14, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a77)
local function _a78(_a79, _a80, _a81, _a82)
local _a83 = _a55("TextButton", {
Size = UDim2.new(0, _a82, 0, 24), Position = UDim2.new(1, _a81, 0, 8),
BackgroundColor3 = _a80, BorderSizePixel = 0, Text = _a79,
TextColor3 = _a54.text, TextSize = 12, Font = Enum.Font.GothamMedium,
AutoButtonColor = true,
}, _a77)
_a62(_a83, 6)
return _a83
end
local _a84 = _a78("✕", _a54.bad, -38, 28)
local _a85   = _a78("—", _a54.card, -70, 28)
local _a86 = _a78("지우기", _a54.card, -132, 58)
local _a87  = _a78("복사", _a54.accent, -190, 54)
local _a88  = _a78("정지", _a54.bad, -252, 58)
_a88.MouseButton1Click:Connect(function()
_a41.ctl.stopAll()
if _a41.auto.refresh then pcall(_a41.auto.refresh) end
_a6("[정지] 모든 동작을 멈췄습니다")
end)
local _a89 = _a55("ScrollingFrame", {
Size = UDim2.new(0, 152, 1, -92), Position = UDim2.fromOffset(10, 48),
BackgroundColor3 = _a54.panel, BorderSizePixel = 0,
ScrollBarThickness = 3, ScrollBarImageColor3 = _a54.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a76)
_a62(_a89, 8)
_a55("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, _a89)
_a55("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }, _a89)
local _a90 = _a55("Frame", {
Size = UDim2.new(1, -182, 1, -92), Position = UDim2.fromOffset(172, 48),
BackgroundTransparency = 1,
}, _a76)
local _a91, _a92 = {}, nil
local _a93, _a94 = {}, {}
local _a95 = {}
local function _a96(_a97)
_a92 = _a97
for _a98, _a99 in pairs(_a91) do _a99.Visible = (_a98 == _a97) end
for _a100, _a101 in pairs(_a93) do
local _a102 = (_a100 == _a97)
_a101.BackgroundColor3 = _a102 and _a54.accent or _a54.panel
_a101.TextColor3 = _a102 and Color3.fromRGB(255, 255, 255) or _a54.dim
end
local _a103 = _a94[_a97]
if _a103 and _a95[_a103] and not _a95[_a103].open then _a95[_a103].toggle() end
end
local function _a104(_a105, _a106, _a107)
local _a108 = { open = true, kids = {} }
local _a109 = _a55("TextButton", {
Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = _a54.bg, BorderSizePixel = 0,
Text = "", TextColor3 = _a54.dim, TextSize = 11,
Font = Enum.Font.GothamBold, LayoutOrder = _a107, AutoButtonColor = false,
}, _a89)
_a62(_a109, 5)
local _a110 = _a55("TextLabel", {
Size = UDim2.fromOffset(14, 26), Position = UDim2.fromOffset(6, 0),
BackgroundTransparency = 1, Text = "▾", TextColor3 = _a54.dim,
TextSize = 10, Font = Enum.Font.GothamBold,
}, _a109)
_a55("TextLabel", {
Size = UDim2.new(1, -22, 1, 0), Position = UDim2.fromOffset(20, 0),
BackgroundTransparency = 1, Text = _a106, TextColor3 = _a54.dim,
TextSize = 11, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a109)
function _a108.toggle()
_a108.open = not _a108.open
_a110.Text = _a108.open and "▾" or "▸"
for _a111, _a112 in ipairs(_a108.kids) do _a112.Visible = _a108.open end
end
_a109.MouseButton1Click:Connect(_a108.toggle)
_a95[_a105] = _a108
return _a108
end
local function _a113(_a114, _a115, _a116, _a117)
local _a118 = _a117 and 14 or 6
local _a119 = _a55("TextButton", {
Size = UDim2.new(1, 0, 0, 27), BackgroundColor3 = _a54.panel, BorderSizePixel = 0,
Text = "", TextColor3 = _a54.dim, TextSize = 12,
Font = Enum.Font.GothamMedium, LayoutOrder = _a116, AutoButtonColor = false,
}, _a89)
_a62(_a119, 5)
local _a120 = _a55("TextLabel", {
Size = UDim2.new(1, -_a118 - 4, 1, 0), Position = UDim2.fromOffset(_a118, 0),
BackgroundTransparency = 1, Text = _a115, TextColor3 = _a54.dim,
TextSize = 12, Font = Enum.Font.GothamMedium,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a119)
_a93[_a114] = _a119
if _a117 then
_a94[_a114] = _a117
local _a121 = _a95[_a117]
if _a121 then
table.insert(_a121.kids, _a119)
_a119.Visible = _a121.open
end
end
local _a122 = _a55("ScrollingFrame", {
Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false,
BorderSizePixel = 0, ScrollBarThickness = 4,
ScrollBarImageColor3 = _a54.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a90)
_a55("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, _a122)
_a55("UIPadding", { PaddingRight = UDim.new(0, 8) }, _a122)
_a91[_a114] = _a122
_a119.MouseButton1Click:Connect(function() _a96(_a114) end)
_a119.MouseEnter:Connect(function()
if _a92 ~= _a114 then _a119.BackgroundColor3 = _a54.card end
end)
_a119.MouseLeave:Connect(function()
if _a92 ~= _a114 then _a119.BackgroundColor3 = _a54.panel end
end)
_a119:GetPropertyChangedSignal("TextColor3"):Connect(function()
_a120.TextColor3 = _a119.TextColor3
end)
return _a122
end
local _a123 = 0
local function _a124()
_a123 += 1
return _a123
end
local function _a125(_a126, _a127)
local _a128 = _a55("Frame", {
Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, LayoutOrder = _a124(),
}, _a126)
_a55("Frame", {
Size = UDim2.fromOffset(3, 14), Position = UDim2.fromOffset(0, 7),
BackgroundColor3 = _a54.accent, BorderSizePixel = 0,
}, _a128)
_a55("TextLabel", {
Size = UDim2.new(1, -12, 1, 0), Position = UDim2.fromOffset(10, 0),
BackgroundTransparency = 1, Text = _a127, TextColor3 = _a54.text,
TextSize = 13, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a128)
return _a128
end
local function _a129(_a130, _a131, _a132)
local _a133 = _a55("Frame", {
Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundColor3 = _a54.card, BorderSizePixel = 0, LayoutOrder = _a124(),
}, _a130)
_a62(_a133, 8)
_a65(_a133, _a54.line, 1)
_a69(_a133, 12)
_a55("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, _a133)
if _a131 then
local _a134 = _a55("Frame", {
Size = UDim2.new(1, 0, 0, _a132 and 32 or 22), BackgroundTransparency = 1,
LayoutOrder = 0,
}, _a133)
_a55("TextLabel", {
Size = UDim2.new(1, -70, 0, 16), BackgroundTransparency = 1, Text = _a131,
TextColor3 = _a54.text, TextSize = 13, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a134)
if _a132 then
_a55("TextLabel", {
Size = UDim2.new(1, -70, 0, 13), Position = UDim2.fromOffset(0, 17),
BackgroundTransparency = 1, Text = _a132, TextColor3 = _a54.dim,
TextSize = 11, Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
}, _a134)
end
_a133:SetAttribute("HeadHeight", _a132 and 32 or 18)
return _a133, _a134
end
return _a133
end
local _a135 = {}
local function _a136()
for _a137, _a138 in pairs(_a135) do pcall(_a138) end
end
_a41.auto.refresh = _a136
local function _a139(_a140, _a141, _a142)
local _a143 = _a55("TextButton", {
Size = UDim2.fromOffset(46, 24), Position = UDim2.new(1, -46, 0, 0),
BackgroundColor3 = _a54.cardHi, BorderSizePixel = 0, Text = "",
AutoButtonColor = false,
}, _a140)
_a62(_a143, 12)
local _a144 = _a55("Frame", {
Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(3, 3),
BackgroundColor3 = _a54.dim, BorderSizePixel = 0,
}, _a143)
_a62(_a144, 9)
local _a145 = _a55("TextLabel", {
Size = UDim2.fromOffset(46, 12), Position = UDim2.fromOffset(0, 26),
BackgroundTransparency = 1, Text = "OFF", TextColor3 = _a54.dim,
TextSize = 10, Font = Enum.Font.GothamBold,
}, _a143)
local function _a146()
local _a147 = _a11[_a141]
_a143.BackgroundColor3 = _a147 and _a54.good or _a54.cardHi
_a144:TweenPosition(UDim2.fromOffset(_a147 and 25 or 3, 3),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
_a144.BackgroundColor3 = _a147 and Color3.fromRGB(255, 255, 255) or _a54.dim
_a145.Text = _a147 and "ON" or "OFF"
_a145.TextColor3 = _a147 and _a54.good or _a54.dim
end
_a143.MouseButton1Click:Connect(function()
_a11[_a141] = not _a11[_a141]
if _a11[_a141] then
if _a141 == "auto" then _a41.ctl.abort = false end
_a146()
_a6("[" .. _a141 .. "] 시작")
local _a148, _a149 = pcall(_a142)
if not _a148 then _a6("[에러] " .. tostring(_a149)) end
else
if _a141 == "auto" then
_a41.ctl.stopAll()
_a6("[정지] 모든 동작을 멈췄습니다")
end
_a146()
end
end)
_a146()
_a135[_a141] = _a146
return _a143, _a146
end
local function _a150(_a151, _a152)
local _a153 = _a55("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, LayoutOrder = _a124(),
}, _a151)
local _a154 = #_a152
for _a155, _a156 in ipairs(_a152) do
local _a157 = _a55("Frame", {
Size = UDim2.new(1 / _a154, -6, 1, 0), Position = UDim2.new((_a155 - 1) / _a154, 3, 0, 0),
BackgroundTransparency = 1,
}, _a153)
_a55("TextLabel", {
Size = UDim2.new(1, 0, 0, 13), BackgroundTransparency = 1, Text = _a156.label,
TextColor3 = _a54.dim, TextSize = 10, Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a157)
local _a158 = _a55("TextBox", {
Size = UDim2.new(1, 0, 0, 24), Position = UDim2.fromOffset(0, 15),
BackgroundColor3 = _a54.bg, BorderSizePixel = 0, Text = tostring(_a156.value),
TextColor3 = _a54.text, TextSize = 12, Font = Enum.Font.Code,
ClearTextOnFocus = false,
}, _a157)
_a62(_a158, 5)
_a65(_a158, _a54.line, 1)
_a158.FocusLost:Connect(function() _a156.onChange(_a158.Text, _a158) end)
end
return _a153
end
local function _a159(_a160, _a161)
local _a162 = _a55("Frame", {
Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = _a124(),
}, _a160)
local _a163 = #_a161
for _a164, _a165 in ipairs(_a161) do
local _a166 = _a55("TextButton", {
Size = UDim2.new(1 / _a163, -5, 1, 0), Position = UDim2.new((_a164 - 1) / _a163, 2.5, 0, 0),
BackgroundColor3 = _a165.col or _a54.cardHi, BorderSizePixel = 0, Text = _a165.label,
TextColor3 = _a54.text, TextSize = 12, Font = Enum.Font.GothamMedium,
}, _a162)
_a62(_a166, 6)
_a166.MouseButton1Click:Connect(function()
local _a167, _a168 = pcall(_a165.fn, _a166)
if not _a167 then _a6("[에러] " .. tostring(_a165.label) .. " → " .. tostring(_a168)) end
end)
end
return _a162
end
local function _a169(_a170, _a171, _a172, _a173)
local _a174 = _a55("TextButton", {
Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = _a54.cardHi, BorderSizePixel = 0,
Text = "", TextColor3 = _a54.text, TextSize = 12, Font = Enum.Font.GothamMedium,
LayoutOrder = _a124(),
}, _a170)
_a62(_a174, 6)
local function _a175()
local _a176 = _a172()
_a174.Text = _a171 .. "   " .. (_a176 and "ON" or "OFF")
_a174.BackgroundColor3 = _a176 and Color3.fromRGB(40, 78, 58) or _a54.cardHi
_a174.TextColor3 = _a176 and _a54.good or _a54.dim
end
_a174.MouseButton1Click:Connect(function()
_a173(not _a172())
_a175()
end)
_a175()
return _a174
end
local _a177 = _a113("log", "로그", 90)
local _a178
do
local _a179 = _a55("Frame", {
Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(13, 14, 18),
BorderSizePixel = 0, LayoutOrder = _a124(),
}, _a177)
_a62(_a179, 8)
_a65(_a179, _a54.line, 1)
local _a180 = _a55("ScrollingFrame", {
Size = UDim2.new(1, -10, 1, -10), Position = UDim2.fromOffset(5, 5),
BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4,
ScrollBarImageColor3 = _a54.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a179)
_a178 = _a55("TextLabel", {
Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1, Text = "", TextColor3 = Color3.fromRGB(196, 208, 196),
TextSize = 11, Font = Enum.Font.Code,
TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
TextWrapped = true,
}, _a180)
_a177.AutomaticCanvasSize = Enum.AutomaticSize.None
_a177.CanvasSize = UDim2.new()
end
do
local _a181, _a182, _a183, _a184
_a77.InputBegan:Connect(function(_a185)
if _a185.UserInputType == Enum.UserInputType.MouseButton1
or _a185.UserInputType == Enum.UserInputType.Touch then
_a181, _a182, _a183 = true, _a185.Position, _a76.Position
_a185.Changed:Connect(function()
if _a185.UserInputState == Enum.UserInputState.End then _a181 = false end
end)
end
end)
_a77.InputChanged:Connect(function(_a186)
if _a186.UserInputType == Enum.UserInputType.MouseMovement
or _a186.UserInputType == Enum.UserInputType.Touch then _a184 = _a186 end
end)
_a2.InputChanged:Connect(function(_a187)
if _a181 and _a187 == _a184 then
local _a188 = _a187.Position - _a182
_a76.Position = UDim2.new(_a183.X.Scale, _a183.X.Offset + _a188.X,
_a183.Y.Scale, _a183.Y.Offset + _a188.Y)
end
end)
local _a189 = false
_a85.MouseButton1Click:Connect(function()
_a189 = not _a189
_a76:TweenSize(_a189 and UDim2.fromOffset(_a74, 40) or UDim2.fromOffset(_a74, _a75),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
_a85.Text = _a189 and "▢" or "—"
end)
end
local _a190 = _a3.Heartbeat:Connect(function()
if not _a1.dirty then return end
_a1.dirty = false
local _a191 = #_a5
_a178.Text = table.concat(table.move(_a5, math.max(1, _a191 - 300), _a191, 1, {}), "\n")
end)
local _a192 = _a113("dash", "대시보드", 10)
local _a193 = _a113("event", "이벤트", 20)
do
local _a194 = _a129(_a192, "전체 제어", nil)
_a159(_a194, {
{ label = "권장 전부 ON", col = _a54.good, fn = function()
for _a195, _a196 in ipairs({ "place", "merchant", "crop", "expand", "hatch" }) do
if not _a11[_a196] then
_a11[_a196] = true
if _a196 == "place"    then _a53(_a196, function() return _a9.PlaceInterval end, _a18, "배치") end
if _a196 == "merchant" then _a53(_a196, function() return _a9.MerchantInterval end, _a19, "구매") end
if _a196 == "crop"     then _a53(_a196, function() return _a9.CropInterval end, _a28, "씨앗") end
if _a196 == "expand"   then _a53(_a196, function() return _a9.ExpandInterval end, _a31, "확장") end
if _a196 == "hatch"    then _a53(_a196, function() return _a9.HatchInterval end, _a35, "뽑기") end
end
end
_a136()
_a6("[전체] 배치/구매/씨앗/확장/뽑기 ON  (업글·리버스는 따로 켜세요)")
end },
{ label = "전부 정지", col = _a54.bad, fn = function()
_a11.place, _a11.merchant, _a11.upgrade = false, false, false
_a11.towerup, _a11.crop, _a11.expand, _a11.rebirth, _a11.hatch, _a11.luck = false, false, false, false, false, false
_a11.farm, _a11.zone, _a11.mhatch, _a11.rank, _a11.mreb = false, false, false, false, false
_a136()
_a6("[전체] 정지")
end },
})
local _a197 = _a129(_a192, "현황", nil)
_a159(_a197, {
{ label = "밭 / 타워", col = _a54.accent, fn = function()
local _a198, _a199, _a200, _a201 = _a14()
_a6("")
_a6("──── 현재 상태 ────")
_a6("레인 " .. tostring(_a201) .. " / plot " .. (_a200 and "O" or "X")
.. " / world " .. (_a198 and "O" or "X"))
local _a202 = _a15(_a200, _a201)
local _a203 = _a16(_a198)
_a6("슬롯 " .. #_a202 .. " / 배치 " .. #_a203)
local _a204, _a205 = 0, {}
for _a206, _a207 in ipairs(_a203) do
_a204 += (_a207.dps or 0)
_a205[tostring(_a207.kind)] = (_a205[tostring(_a207.kind)] or 0) + 1
end
_a6("총 DPS " .. _a7(_a204))
for _a208, _a209 in pairs(_a205) do _a6("  " .. _a208 .. " × " .. _a209) end
local _a210 = _a17()
_a6("")
_a6("배치 가능 " .. #_a210 .. "종")
for _a211 = 1, math.min(10, #_a210) do
local _a212 = _a210[_a211]
_a6(("  %-22s %-7s 남은 %-3s DPS %s"):format(
tostring(_a212.id), tostring(_a212.vr or "-"), tostring(_a212.copies), _a7(_a212.dps)))
end
_a96("log")
end },
{ label = "로그 보기", col = _a54.cardHi, fn = function() _a96("log") end },
})
end
do
local _a213, _a214 = _a129(_a193, "자동 배치 / 교체", nil)
_a139(_a214, "place", function()
_a53("place", function() return _a9.PlaceInterval end, _a18, "배치")
end)
_a150(_a213, {
{ label = "주기", value = _a9.PlaceInterval, onChange = function(_a215)
local _a216 = tonumber(_a215) if _a216 and _a216 >= 3 then _a9.PlaceInterval = _a216 end
end },
{ label = "교체 배수", value = _a9.SwapMargin, onChange = function(_a217)
local _a218 = tonumber(_a217) if _a218 and _a218 >= 1 then _a9.SwapMargin = _a218 _a6("[설정] 교체 배수 " .. _a218) end
end },
{ label = "DoT 반영", value = _a9.DotFactor, onChange = function(_a219)
local _a220 = tonumber(_a219) if _a220 and _a220 >= 0 and _a220 <= 1 then _a9.DotFactor = _a220 end
end },
})
_a169(_a213, "업글 타워 보호",
function() return _a9.ProtectUpgraded end,
function(_a221) _a9.ProtectUpgraded = _a221
_a6("[설정] 업글 보호 " .. (_a221 and "ON — 업글된 건 안 건드림" or "OFF — 약하면 교체")) end)
_a159(_a213, {
{ label = "지금 1회 실행", col = _a54.accent, fn = function()
task.spawn(function() _a11.place = true _a18() _a11.place = false _a96("log") end)
end },
})
end
do
local _a222, _a223 = _a129(_a193, "머천트 자동 구매", nil)
_a139(_a223, "merchant", function()
_a53("merchant", function() return _a9.MerchantInterval end, _a19, "구매")
end)
_a150(_a222, {
{ label = "머천트 ID", value = _a9.MerchantId, onChange = function(_a224)
if _a224 ~= "" then _a9.MerchantId = _a224 _a6("[설정] 머천트 " .. _a224) end
end },
{ label = "주기", value = _a9.MerchantInterval, onChange = function(_a225)
local _a226 = tonumber(_a225) if _a226 and _a226 >= 5 then _a9.MerchantInterval = _a226 end
end },
})
_a159(_a222, {
{ label = "지금 1회 구매", col = _a54.accent, fn = function()
task.spawn(function() _a11.merchant = true _a19() _a11.merchant = false _a96("log") end)
end },
})
end
do
local _a227, _a228 = _a129(_a193, "업그레이드 머신", nil)
_a139(_a228, "upgrade", function()
_a53("upgrade", function() return _a9.UpgradeInterval end, _a23, "머신업글")
end)
_a150(_a227, {
{ label = "주기", value = _a9.UpgradeInterval, onChange = function(_a229)
local _a230 = tonumber(_a229) if _a230 and _a230 >= 5 then _a9.UpgradeInterval = _a230 end
end },
{ label = "최소 잔액", value = _a9.MinSunflowers, onChange = function(_a231)
local _a232 = tonumber(_a231) if _a232 and _a232 >= 0 then _a9.MinSunflowers = _a232
_a6("[설정] 최소 잔액 " .. _a7(_a232, 0)) end
end },
})
_a169(_a227, "가격 미상 구매",
function() return _a9.BuyUnknownCost end,
function(_a233) _a9.BuyUnknownCost = _a233 end)
_a159(_a227, {
{ label = "업글 현황 보기", col = _a54.accent, fn = function()
local _a234 = _a20()
local _a235 = _a21()
_a12.sun = _a234
_a6("")
_a6("──── 업그레이드 머신 ────")
_a6("Sunflowers = " .. _a7(_a234, 0))
local _a236 = {}
for _a237, _a238 in ipairs(_a13) do
local _a239 = _a235[_a238] or 0
_a236[#_a236 + 1] = { id = _a238, tier = _a239, cost = _a22(_a238, _a239) }
end
table.sort(_a236, function(_a240, _a241)
return (_a240.cost or math.huge) < (_a241.cost or math.huge)
end)
for _a242, _a243 in ipairs(_a236) do
_a6(("  %-22s Lv%-3s 다음 %-14s %s"):format(
_a243.id, tostring(_a243.tier), _a243.cost and _a7(_a243.cost, 0) or "?",
(_a243.cost and _a243.cost <= _a234) and "← 구매가능" or ""))
end
_a96("log")
end },
{ label = "지금 1회 업글", col = _a54.cardHi, fn = function()
task.spawn(function() _a11.upgrade = true _a23() _a11.upgrade = false _a96("log") end)
end },
})
local _a244, _a245 = _a129(_a193, "타워 개별 업글", nil)
_a139(_a245, "towerup", function()
_a53("towerup", function() return _a9.UpgradeInterval end, _a52, "타워업글")
end)
end
do
local _a246, _a247 = _a129(_a193, "자동 뽑기", nil)
_a139(_a247, "hatch", function()
_a53("hatch", function() return _a9.HatchInterval end, _a35, "뽑기")
end)
_a150(_a246, {
{ label = "주기", value = _a9.HatchInterval, onChange = function(_a248)
local _a249 = tonumber(_a248) if _a249 and _a249 >= 1 then _a9.HatchInterval = _a249 end
end },
{ label = "한 번에 최대", value = _a9.HatchMax, onChange = function(_a250)
local _a251 = tonumber(_a250) if _a251 and _a251 >= 1 then _a9.HatchMax = math.floor(_a251) end
end },
})
_a150(_a246, {
{ label = "예비금", value = _a9.HatchReserve, onChange = function(_a252)
local _a253 = tonumber(_a252) if _a253 and _a253 >= 0 then _a9.HatchReserve = _a253
_a6("[설정] 뽑기 예비금 " .. _a7(_a253, 0)) end
end },
{ label = "알 번호 (0=자동)", value = _a9.HatchEggNum, onChange = function(_a254)
local _a255 = tonumber(_a254) if _a255 and _a255 >= 0 and _a255 <= 12 then
_a9.HatchEggNum = math.floor(_a255)
table.clear(_a10)
_a6("[설정] 알 번호 " .. (_a255 == 0 and "자동" or _a255)) end
end },
})
_a159(_a246, {
{ label = "뽑기 현황 보기", col = _a54.accent, fn = function()
local _a256 = _a34()
_a12.sun = _a256.sun
_a6("")
_a6("──── 뽑기 현황 ────")
_a6("  알 등급     " .. _a256.id)
_a6("  알 uid      " .. tostring(_a256.uid))
_a6("  개당 비용   " .. (_a256.cost and _a7(_a256.cost, 0) or "?"))
_a6("  Sunflowers  " .. _a7(_a256.sun, 0))
_a6("  예비금      " .. _a7(_a9.HatchReserve, 0))
_a6("  지금 가능   " .. _a256.canBuy .. "회")
_a6("")
_a6("  월드의 알 " .. _a256.eggCount .. "개")
for _a257, _a258 in ipairs(_a256.eggs) do
if _a257 > 5 then break end
_a6(("    %s  거리 %s"):format(_a258.uid, _a7(_a258.dist)))
end
_a6("")
_a6("  누적 뽑기   " .. _a12.hatched .. "회")
_a96("log")
end },
{ label = "지금 1회 실행", col = _a54.cardHi, fn = function()
task.spawn(function() _a11.hatch = true _a35() _a11.hatch = false _a96("log") end)
end },
})
end
do
local _a259, _a260 = _a129(_a193, "럭 상시 최대 유지", nil)
_a139(_a260, "luck", function()
_a53("luck", function() return _a9.LuckInterval end, _a39, "럭")
end)
_a150(_a259, {
{ label = "주기", value = _a9.LuckInterval, onChange = function(_a261)
local _a262 = tonumber(_a261) if _a262 and _a262 >= 60 then _a9.LuckInterval = _a262 end
end },
{ label = "예비금", value = _a9.LuckReserve, onChange = function(_a263)
local _a264 = tonumber(_a263) if _a264 and _a264 >= 0 then _a9.LuckReserve = _a264 end
end },
})
_a150(_a259, {
{ label = "최소 부족분", value = _a9.LuckMinTopUp, onChange = function(_a265)
local _a266 = tonumber(_a265) if _a266 and _a266 >= 0 then _a9.LuckMinTopUp = _a266 end
end },
})
for _a267, _a268 in ipairs(_a36) do
_a169(_a259, _a268,
function() return _a9.LuckBoosts[_a268] end,
function(_a269) _a9.LuckBoosts[_a268] = _a269 end)
end
_a159(_a259, {
{ label = "럭 현황 보기", col = _a54.accent, fn = function()
local _a270 = _a37()
_a12.sun = _a270.sun
_a6("")
_a6("──── 이벤트 럭 ────")
_a6("  머신 활성   " .. (_a270.enabled and "O" or "X"))
_a6("  최대 시간   " .. _a38(_a270.maxSec))
_a6("  Sunflowers  " .. _a7(_a270.sun, 0))
_a6("")
for _a271, _a272 in ipairs(_a270.rows) do
_a6(("  %-12s %-14s 부족 %-14s 필요 %s개%s"):format(
_a272.rarity, _a38(_a272.left), _a38(_a272.deficit), _a7(_a272.need, 0),
_a272.on and "" or "   (꺼짐)"))
end
_a6("")
_a6("  효과 : 비활성 0.5배 → 활성 1.0배 (2배)")
_a96("log")
end },
{ label = "지금 1회 충전", col = _a54.cardHi, fn = function()
task.spawn(function() _a11.luck = true _a39() _a11.luck = false _a96("log") end)
end },
})
end
do
local _a273, _a274 = _a129(_a193, "자동 씨앗 교체", nil)
_a139(_a274, "crop", function()
_a53("crop", function() return _a9.CropInterval end, _a28, "씨앗")
end)
_a150(_a273, {
{ label = "주기", value = _a9.CropInterval, onChange = function(_a275)
local _a276 = tonumber(_a275) if _a276 and _a276 >= 5 then _a9.CropInterval = _a276 end
end },
{ label = "갈아엎기 배수", value = _a9.CropMargin, onChange = function(_a277)
local _a278 = tonumber(_a277) if _a278 and _a278 >= 1 then _a9.CropMargin = _a278 _a6("[설정] 작물 배수 " .. _a278) end
end },
})
_a169(_a273, "성장중 건너뛰기",
function() return _a9.SkipUnhatched end,
function(_a279) _a9.SkipUnhatched = _a279 end)
_a159(_a273, {
{ label = "밭 현황 보기", col = _a54.accent, fn = function()
local _a280, _a281 = _a14()
if not _a281 then _a6("[씨앗] 밭 없음") _a96("log") return end
local _a282, _a283 = _a25(_a281), _a24()
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
local _a296 = _a27(_a295) or 0
_a287 += _a296
if _a26(_a295) then _a289 += 1
elseif _a292 > _a296 * _a9.CropMargin then _a288 += 1
else _a290 += 1 end
_a293 += 1
if _a293 <= 20 then
_a6(("  칸%-4s %-20s %s/s%s"):format(tostring(_a294),
tostring(rawget(_a295, "sp") or "?"), _a7(_a296),
_a26(_a295) and "  (자라는 중)" or ""))
end
end
if _a286 > 20 then _a6("  ... (" .. (_a286 - 20) .. "칸 더)") end
_a6("")
_a6(("총 %d칸 / 합계 %s per sec"):format(_a286, _a7(_a287)))
_a6(("갈아엎기 대상 %d / 유지 %d / 자라는 중 %d"):format(_a288, _a290, _a289))
_a96("log")
end },
{ label = "지금 1회 실행", col = _a54.cardHi, fn = function()
task.spawn(function() _a11.crop = true _a28() _a11.crop = false _a96("log") end)
end },
})
end
do
local _a297, _a298 = _a129(_a193, "자동 확장", nil)
_a139(_a298, "expand", function()
_a53("expand", function() return _a9.ExpandInterval end, _a31, "확장")
end)
_a150(_a297, {
{ label = "주기", value = _a9.ExpandInterval, onChange = function(_a299)
local _a300 = tonumber(_a299) if _a300 and _a300 >= 5 then _a9.ExpandInterval = _a300 end
end },
{ label = "밭칸 스캔", value = _a9.MaxBedScan, onChange = function(_a301)
local _a302 = tonumber(_a301) if _a302 and _a302 >= 1 then _a9.MaxBedScan = math.floor(_a302) end
end },
})
_a159(_a297, {
{ label = "확장 현황 보기", col = _a54.accent, fn = function()
local _a303, _a304, _a305, _a306 = _a14()
if not _a304 then _a6("[확장] 밭 없음") _a96("log") return end
local _a307 = _a20()
_a12.sun = _a307
local _a308 = _a29(true)
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
local _a318 = _a30(_a304)
_a6("")
_a6("잠긴 밭칸 " .. #_a318 .. "개 (싼 순 8개)")
for _a319 = 1, math.min(8, #_a318) do
local _a320 = _a318[_a319]
_a6(("  칸 %-4s %s%s"):format(_a320.id, _a320.cost and _a7(_a320.cost, 0) or "?",
(_a320.cost and _a320.cost <= _a307) and "  ← 오픈 가능" or ""))
end
if #_a318 == 0 then _a6("  (전부 열려 있음)") end
_a96("log")
end },
{ label = "지금 1회 실행", col = _a54.cardHi, fn = function()
task.spawn(function() _a11.expand = true _a31() _a11.expand = false _a96("log") end)
end },
})
end
do
local _a321, _a322 = _a129(_a193, "자동 리버스", nil)
_a139(_a322, "rebirth", function()
_a53("rebirth", function() return _a9.RebirthInterval end, _a33, "리버스")
end)
_a150(_a321, {
{ label = "주기", value = _a9.RebirthInterval, onChange = function(_a323)
local _a324 = tonumber(_a323) if _a324 and _a324 >= 10 then _a9.RebirthInterval = _a324 end
end },
})
_a159(_a321, {
{ label = "리버스 현황 보기", col = _a54.accent, fn = function()
local _a325 = _a32()
_a6("")
_a6("──── 리버스 현황 ────")
if not _a325 then _a6("  밭 없음") _a96("log") return end
_a6(("  현재 리버스   %d회  (최대 %s)"):format(_a325.regrows, tostring(_a325.cap)))
_a6(("  레인          %d / 7 %s"):format(_a325.lanes, _a325.lanes >= 7 and "OK" or "부족"))
_a6(("  코인보스      %d / %d %s"):format(_a325.kills, _a325.need,
_a325.kills >= _a325.need and "OK" or "부족"))
_a6("")
_a6(_a325.ready and "  ★ 지금 리버스 가능" or ("  대기 — " .. tostring(_a325.reason)))
_a96("log")
end },
{ label = "지금 1회 리버스", col = _a54.bad, fn = function()
task.spawn(function() _a11.rebirth = true _a33() _a11.rebirth = false _a96("log") end)
end },
})
end
local _a326 = _a113("main", "메인 게임", 30)
do
local _a327, _a328 = _a129(_a326, "올 자동", nil)
local _a329 = _a55("Frame", {
Size = UDim2.new(1, 0, 0, 108), BackgroundColor3 = _a54.cardHi,
BorderSizePixel = 0, LayoutOrder = _a124(),
}, _a327)
_a62(_a329, 6)
_a69(_a329, 8)
local _a330 = _a55("TextLabel", {
Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
Font = Enum.Font.Code, TextSize = 12, TextColor3 = _a54.text,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Text = "정지", RichText = true,
}, _a329)
task.spawn(function()
while _a72 and _a72.Parent do
local _a331 = _a41.ctl.now
local _a332 = _a11.auto and "🟢" or "⚪"
local _a333 = _a331.act or "-"
if _a331.detail and _a331.detail ~= "" then _a333 = _a333 .. "  " .. _a331.detail end
_a330.Text = table.concat({
_a332 .. " " .. (_a11.auto and (_a331.step or "-") or "정지"),
"▸ " .. _a333,
"목표 " .. (_a331.goal or "-") .. (_a331.prog ~= "" and ("   " .. _a331.prog) or ""),
"1.리버스 " .. (_a41.auto.rebNote or "-"),
"2.존해금 " .. (_a41.auto.zoneNote or "-"),
"파밍대상 " .. tostring(_a41.auto.farmZone or "-") .. "   현재 " .. tostring(_a41.auto.hereZone or "-"),
}, "\n")
task.wait(0.2)
end
end)
function _a41.auto.start()
for _a334, _a335 in ipairs(_a41.auto.STEPS) do _a11[_a335.run] = false end
for _a336, _a337 in ipairs(_a41.auto.SIDE) do _a11[_a337.run] = false end
_a11.petspd = true
_a11.rewatch = true
_a136()
_a53("auto", function() return _a9.AutoInterval end, _a41.auto.master, "자동")
end
_a139(_a328, "auto", _a41.auto.start)
_a150(_a327, {
{ label = "주기", value = _a9.AutoInterval, onChange = function(_a338)
local _a339 = tonumber(_a338) if _a339 and _a339 >= 1 then _a9.AutoInterval = _a339 end
end },
{ label = "정체 판정(초)", value = _a9.PursueStallSec, onChange = function(_a340)
local _a341 = tonumber(_a340) if _a341 and _a341 >= 10 then _a9.PursueStallSec = _a341 end
end },
})
_a150(_a327, {
{ label = "운 퀘 최소 알 개수", value = _a9.HatchMinAfford, onChange = function(_a342)
local _a343 = tonumber(_a342) if _a343 and _a343 >= 1 then _a9.HatchMinAfford = math.floor(_a343) end
end },
{ label = "더 버는 시간(초)", value = _a9.MoneyDwell, onChange = function(_a344)
local _a345 = tonumber(_a344) if _a345 and _a345 >= 0 then _a9.MoneyDwell = _a345 end
end },
})
_a150(_a327, {
{ label = "부화 한 번에(초)", value = _a9.HatchBudget, onChange = function(_a346)
local _a347 = tonumber(_a346) if _a347 and _a347 >= 3 then _a9.HatchBudget = _a347 end
end },
})
_a150(_a327, {
{ label = "이동 방식", value = _a9.TpMode, onChange = function(_a348)
_a348 = tostring(_a348 or ""):lower()
if _a348 == "instant" or _a348 == "glide" or _a348 == "walk" then _a9.TpMode = _a348 end
end },
{ label = "glide 속도", value = _a9.TpSpeed, onChange = function(_a349)
local _a350 = tonumber(_a349) if _a350 and _a350 >= 16 then _a9.TpSpeed = _a350 end
end },
})
_a169(_a327, "차단 화면에 실제 클릭까지 시도",
function() return _a9.ScreenRealClick end,
function(_a351) _a9.ScreenRealClick = _a351 end)
_a169(_a327, "퀘스트 없을 때도 알 까기",
function() return _a9.IdleHatch end,
function(_a352) _a9.IdleHatch = _a352 end)
_a169(_a327, "존 해금·리버스는 퀘스트 끝나고",
function() return _a9.HoldZoneForQuest end,
function(_a353) _a9.HoldZoneForQuest = _a353 end)
for _a354, _a355 in ipairs(_a41.auto.STEPS) do
local _a356 = _a355.key
_a169(_a327, "  " .. _a354 .. ". " .. _a355.label,
function() return _a9.StepOn[_a356] end,
function(_a357) _a9.StepOn[_a356] = _a357 end)
end
for _a358, _a359 in ipairs(_a41.auto.SIDE) do
local _a360 = _a359.key
_a169(_a327, "  · " .. _a359.label .. " (순위 밖)",
function() return _a9.StepOn[_a360] end,
function(_a361) _a9.StepOn[_a360] = _a361 end)
end
_a159(_a327, {
{ label = "지금 상태", col = _a54.accent, fn = function()
_a6("")
_a6("──── 올 자동 ────")
_a6("  " .. (_a11.auto and "돌아가는 중" or "정지") ..
(_a41.auto.step and ("   지금: " .. _a41.auto.step) or ""))
local _a362, _a363 = _a41.quest.bestDepActive()
_a6("  현재 존 " .. tostring(_a41.move.curZone()) .. " / 최고 존 " .. tostring(_a41.move.bestZone()))
if _a362 then
_a6("  ⏸ 존해금·리버스 보류 중 — " .. tostring(_a363 and _a363.title))
else
_a6("  존해금·리버스 진행 가능")
end
_a6("")
_a6("  먼저 (순위 밖):")
for _a364, _a365 in ipairs(_a41.auto.SIDE) do
_a6(("      %-16s %s"):format(_a365.label, _a9.StepOn[_a365.key] and "ON" or "off"))
end
_a6("  우선순위:")
for _a366, _a367 in ipairs(_a41.auto.STEPS) do
_a6(("    %d. %-16s %s%s"):format(_a366, _a367.label,
_a9.StepOn[_a367.key] and "ON" or "off",
_a367.hold and "   (퀘스트 붙잡는 중엔 보류)" or ""))
end
_a6("")
_a6("  마지막 바퀴 (" .. tostring(_a41.auto.passN or 0) .. "번째)")
if _a41.auto.lastPassAt then
_a6(("    %.0f초 전"):format(os.clock() - _a41.auto.lastPassAt))
else
_a6("    아직 한 바퀴도 안 돎 — 루프가 안 돌고 있습니다")
end
for _a368, _a369 in ipairs(_a41.auto.lastTrace or {}) do _a6("    " .. _a369) end
_a96("log")
end },
{ label = "화면 넘기기 진단", col = _a54.warn, fn = function()
task.spawn(function()
_a6("")
_a6("──── 보상 화면 ────")
local _a370 = _a40.Vars
_a6("  Library.Variables : " .. (_a370 and "로드됨" or "없음"))
if _a370 then
_a6("    IsRebirthing = " .. tostring(rawget(_a370, "IsRebirthing")))
_a6("    IsRankingUp  = " .. tostring(rawget(_a370, "IsRankingUp")))
_a6("    OpeningEgg   = " .. tostring(rawget(_a370, "OpeningEgg")))
end
_a6("  debug.info     : " .. tostring(type(debug) == "table" and type(debug.info) == "function"))
_a6("  getgc          : " .. tostring(type(getgc) == "function"))
_a6("  debug.setupvalue: " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
local _a371 = _a4:FindFirstChildOfClass("PlayerGui")
if _a371 then
_a6("  떠 있는 차단 화면:")
local _a372 = false
for _a373, _a374 in ipairs(_a41.screen.BLOCKERS) do
local _a375 = _a371:FindFirstChild(_a374[1])
_a6(("    %-14s %s"):format(_a374[1],
_a375 and (_a375.Enabled and "★ 켜짐" or "꺼짐") or "없음"))
if _a375 and _a375.Enabled then _a372 = true end
end
if not _a372 then _a6("    (없음)") end
end
if type(getgc) == "function" and type(debug) == "table" and debug.info then
_a6("")
_a6("  Rebirth/RankUp 스크립트의 클로저 시그니처:")
local _a376, _a377 = {}, 0
for _a378, _a379 in ipairs({ true, false }) do
local _a380, _a381 = pcall(getgc, _a379)
if _a380 then
for _a382, _a383 in ipairs(_a381) do
if type(_a383) == "function" and _a377 < 25 then
local _a384, _a385 = pcall(debug.info, _a383, "s")
if _a384 and type(_a385) == "string"
and (_a385:find("Rebirth", 1, true) or _a385:find("Rank Up", 1, true)) then
local _a386, _a387 = pcall(debug.info, _a383, "a")
if _a386 then
local _a388 = {}
for _a389 = 1, 16 do
local _a390, _a391 = pcall(debug.getupvalue, _a383, _a389)
if not _a390 then break end
_a388[_a389] = type(_a391)
end
local _a392 = ("인자%d | %s"):format(_a387 or -1,
#_a388 > 0 and table.concat(_a388, ",") or "(없음)")
if not _a376[_a392] then
_a376[_a392] = true
_a377 += 1
_a6("    " .. _a392)
end
end
end
end
end
end
end
if _a377 == 0 then _a6("    (하나도 못 찾음)") end
end
for _a393, _a394 in ipairs({ "reward", "egg", "mastery", "card" }) do
_a41.screen._sig = nil
local _a395 = _a41.screen.findSignalFns(_a394)
_a6("")
_a6(("  [%s] 찾은 함수 %d개"):format(_a394, #_a395))
for _a396, _a397 in ipairs(_a395) do
_a6(("    %s%s"):format(_a397.exact and "★정확일치 " or "", tostring(_a397.src)))
_a6(("       upvalue %d개 : %s"):format(_a397.n or 0, tostring(_a397.sig)))
end
if #_a395 == 0 then
_a6("    (getgc 로 그 스크립트의 클로저를 못 찾음)")
end
local _a398, _a399 = _a41.screen.signal(_a394)
_a6(("    upvalue 신호 : %s (%s개 세팅)"):format(tostring(_a398), tostring(_a399)))
local _a400 = _a41.screen.SIGNAL[_a394]
_a6(("    게임내 입력발동 : %s"):format(
tostring(_a41.screen.pressInGame(_a400 and _a400.pats or {}))))
end
_a6("")
_a6("  감시 루프 RUN.rewatch = " .. tostring(_a11.rewatch))
_a96("log")
end)
end },
{ label = "한 바퀴만", col = _a54.cardHi, fn = function()
task.spawn(function()
_a11.auto = true _a41.auto.master() _a11.auto = false _a96("log")
end)
end },
{ label = "자동 점검", col = _a54.warn, fn = function()
task.spawn(function()
_a6("")
_a6("════ 올 자동 점검 ════")
_a6("  RUN.auto = " .. tostring(_a11.auto))
local _a401 = {}
for _a402, _a403 in ipairs(_a41.auto.SIDE) do
_a401[#_a401 + 1] = _a403.key .. "=" .. tostring(_a9.StepOn[_a403.key])
end
for _a404, _a405 in ipairs(_a41.auto.STEPS) do
_a401[#_a401 + 1] = _a405.key .. "=" .. tostring(_a9.StepOn[_a405.key])
end
_a6("  단계 ON/OFF : " .. table.concat(_a401, "  "))
_a6("  lockGoal    : " .. (_a41.ctl.lockGoal and tostring(_a41.ctl.lockGoal.q.title) or "없음"))
local _a406, _a407 = _a41.quest.bestDepActive()
_a6("  보류중?     : " .. tostring(_a406) .. (_a407 and ("  ← " .. tostring(_a407.title)) or ""))
_a6("  리모트      : 존 " .. (_a40.R_Zone and "O" or "X")
.. " / 리버스 " .. (_a40.R_Reb and "O" or "X"))
_a6("")
_a6("  ── 존 해금 판정 ──")
local _a408 = _a45()
if not _a408 then
_a6("    zoneStatus() = nil  ← 다음 존을 못 구함")
local _a409 = _a40.Zone and rawget(_a40.Zone, "GetNextZone")
if _a409 then
local _a410, _a411, _a412 = pcall(_a40.Zone.GetNextZone)
_a6("    GetNextZone → ok=" .. tostring(_a410)
.. " / " .. tostring(_a411) .. " / " .. tostring(_a412))
end
if _a40.Zone and rawget(_a40.Zone, "HasCompletedNextZoneQuests") then
local _a413, _a414 = pcall(_a40.Zone.HasCompletedNextZoneQuests)
_a6("    존 퀘스트 완료? " .. (_a413 and tostring(_a414) or ("에러 " .. tostring(_a414))))
end
else
_a6("    다음 존 : " .. tostring(_a408.id))
_a6(("    가격 %s %s / 보유 %s → %s"):format(
_a7(_a408.price or 0, 0), tostring(_a408.currency), _a7(_a408.have, 0),
_a408.ok and "지금 살 수 있음" or "부족"))
end
_a6("")
_a6("  ── 리버스 판정 ──")
local _a415 = _a50()
if not _a415 then _a6("    세이브 못 읽음")
else
_a6(("    현재 %d → 다음 %d"):format(_a415.current, _a415.nextN))
_a6("    최근 사유 : " .. tostring(_a41.auto.rebNote or "-"))
end
_a6("")
_a6("  ── 직전 바퀴 기록 ──")
if _a41.auto.lastTrace and #_a41.auto.lastTrace > 0 then
for _a416, _a417 in ipairs(_a41.auto.lastTrace) do _a6("    " .. _a417) end
_a6(("    (%.0f초 전)"):format(os.clock() - (_a41.auto.lastPassAt or os.clock())))
else
_a6("    아직 한 바퀴도 안 돌았음")
end
_a96("log")
end)
end },
})
local _a418, _a419 = _a129(_a326, "펫 이동속도", nil)
_a139(_a419, "petspd", function()
_a53("petspd", function() return 0.4 end, _a41.item.applyPetSpeed, "펫속도")
end)
_a150(_a418, {
{ label = "배수", value = _a9.PetSpeedMult, onChange = function(_a420)
local _a421 = tonumber(_a420) if _a421 and _a421 >= 1 then _a9.PetSpeedMult = _a421 end
end },
{ label = "기본 계수 (원래 0.45)", value = _a9.PetSpeedBase, onChange = function(_a422)
local _a423 = tonumber(_a422) if _a423 and _a423 > 0 then _a9.PetSpeedBase = _a423 end
end },
})
_a159(_a418, {
{ label = "지금 적용 / 확인", col = _a54.accent, fn = function()
local _a424, _a425 = _a41.item.applyPetSpeed()
_a6("")
_a6("──── 펫 이동속도 ────")
_a6("  PlayerPet 모듈 : " .. (_a40.PlayerPet and "로드됨" or "없음"))
_a6(("  적용된 펫 %d마리  (배수 %s / 계수 %s)"):format(
_a424, tostring(_a9.PetSpeedMult), tostring(_a9.PetSpeedBase)))
if _a425 then _a6("  " .. tostring(_a425)) end
if _a424 == 0 then _a6("  펫을 장착하고 다시 눌러보세요") end
_a96("log")
end },
})
_a53("petspd", function() return 0.4 end, _a41.item.applyPetSpeed, "펫속도")
_a53("rewatch", function() return 1 end, function()
_a41.screen.watchTick = (_a41.screen.watchTick or 0) + 1
if _a41.screen.dismissBusy then return end
local _a426, _a427 = _a41.screen.rewardScreenUp()
if _a426 and _a41.screen.screenGaveUp and (os.clock() - _a41.screen.screenGaveUp) < 30 then
return
end
if _a426 then
if _a41.screen.lastBlocker ~= _a427 then
_a41.screen.lastBlocker = _a427
_a6("[화면] " .. tostring(_a427) .. " 화면 감지 — 넘기는 중")
end
_a41.screen.dismissRewardScreens(20)
end
end, "보상화면")
local _a428, _a429 = _a129(_a326, "자동 파밍 유지", nil)
_a139(_a429, "farm", function()
_a53("farm", function() return _a9.FarmInterval end, _a44, "파밍")
end)
_a150(_a428, {
{ label = "주기", value = _a9.FarmInterval, onChange = function(_a430)
local _a431 = tonumber(_a430) if _a431 and _a431 >= 3 then _a9.FarmInterval = _a431 end
end },
})
local _a432, _a433 = _a129(_a326, "자동 존 해금", nil)
_a139(_a433, "zone", function()
_a53("zone", function() return _a9.ZoneInterval end, _a46, "존")
end)
_a150(_a432, {
{ label = "주기", value = _a9.ZoneInterval, onChange = function(_a434)
local _a435 = tonumber(_a434) if _a435 and _a435 >= 3 then _a9.ZoneInterval = _a435 end
end },
})
_a159(_a432, {
{ label = "다음 존 보기", col = _a54.accent, fn = function()
local _a436 = _a45()
_a6("")
if not _a436 then _a6("[존] 다음 존 없음 (최대 도달?)")
else
_a6("──── 다음 존 ────")
_a6("  " .. tostring(_a436.id))
_a6("  가격 " .. _a7(_a436.price or 0, 0) .. " " .. tostring(_a436.currency))
_a6("  보유 " .. _a7(_a436.have, 0))
_a6("  " .. (_a436.ok and "지금 해금 가능" or "부족"))
end
_a96("log")
end },
{ label = "지금 1회", col = _a54.cardHi, fn = function()
task.spawn(function() _a11.zone = true _a46() _a11.zone = false _a96("log") end)
end },
})
local _a437, _a438 = _a129(_a326, "자동 부화", nil)
_a139(_a438, "mhatch", function()
_a53("mhatch", function() return _a9.MainHatchInterval end, _a49, "부화")
end)
_a150(_a437, {
{ label = "주기", value = _a9.MainHatchInterval, onChange = function(_a439)
local _a440 = tonumber(_a439) if _a440 and _a440 >= 1 then _a9.MainHatchInterval = _a440 end
end },
{ label = "한 번에 최대", value = _a9.MainHatchMax, onChange = function(_a441)
local _a442 = tonumber(_a441) if _a442 and _a442 >= 1 then _a9.MainHatchMax = math.floor(_a442) end
end },
})
_a150(_a437, {
{ label = "예비금", value = _a9.MainHatchReserve, onChange = function(_a443)
local _a444 = tonumber(_a443) if _a444 and _a444 >= 0 then _a9.MainHatchReserve = _a444 end
end },
{ label = "알 ID (비우면 자동)", value = _a9.MainEggId, onChange = function(_a445)
_a9.MainEggId = _a445 or ""
end },
})
_a150(_a437, {
{ label = "알 인식 거리", value = _a9.EggRange, onChange = function(_a446)
local _a447 = tonumber(_a446) if _a447 and _a447 >= 5 then _a9.EggRange = _a447 end
end },
})
_a169(_a437, "새 맵 열리면 잠긴 알 자동 해금",
function() return _a9.AutoUnlockEgg end,
function(_a448) _a9.AutoUnlockEgg = _a448 end)
_a169(_a437, "게임 내장 오토해치 사용 (기본 끔)",
function() return _a9.UseAutoHatch end,
function(_a449) _a9.UseAutoHatch = _a449 if not _a449 then _a41.egg.autoHatchOff() end end)
_a169(_a437, "까는 화면 자동으로 넘기기 (신호)",
function() return _a9.HatchClick end,
function(_a450) _a9.HatchClick = _a450 end)
_a159(_a437, {
{ label = "잠긴 알 보기", col = _a54.accent, fn = function()
local _a451, _a452, _a453 = _a41.egg.lockedEggs()
_a6("")
_a6("──── 알 해금 현황 ────")
_a6(("  해금 가능 최대 : #%d   /   현재 해금한 최대 : #%d"):format(_a452, _a453))
_a6("  해금 리모트 : " .. (_a40.R_EggUn and "있음" or "없음"))
if #_a451 == 0 then
_a6("  풀 수 있는 알이 없음 (다 풀었거나 존을 더 사야 함)")
else
_a6("  아직 안 푼 알 " .. #_a451 .. "개:")
for _a454, _a455 in ipairs(_a451) do
_a6(("    #%-3d %s"):format(_a455.num, _a455.id))
if _a454 >= 20 then _a6("    ...") break end
end
end
_a96("log")
end },
{ label = "부화 진단", col = _a54.warn, fn = function()
task.spawn(function()
_a6("")
_a6("──── 부화 진단 ────")
local _a456, _a457, _a458, _a459 = _a47()
_a6("  대상 알   : " .. tostring(_a456))
if not _a456 then _a6("  (오픈한 알이 없음)") _a96("log") return end
local _a460 = _a457 and tonumber(rawget(_a457, "eggNumber"))
_a6("  알 번호   : " .. tostring(_a460) .. "   오픈함? " .. tostring(_a41.egg.eggUnlocked(_a460)))
_a6("  거리      : " .. (_a458 and ("%.0f (사거리 안)"):format(_a458)
or ((_a459 and ("%.0f (사거리 %d 밖)"):format(_a459, _a9.EggRange)) or "받침대 못 찾음")))
local _a461 = _a457 and rawget(_a457, "currency") or "?"
_a6("  통화      : " .. tostring(_a461) .. "   보유 " .. _a7(_a43(_a461), 0))
if type(_a40.CalcEgg) == "function" then
local _a462, _a463 = pcall(_a40.CalcEgg, _a457)
_a6("  CalcEggPricePlayer : " .. (_a462 and tostring(_a463) or ("에러 " .. tostring(_a463))))
end
if type(_a40.CalcEggB) == "function" then
local _a464, _a465 = pcall(_a40.CalcEggB, _a457)
_a6("  CalcEggPrice       : " .. (_a464 and tostring(_a465) or ("에러 " .. tostring(_a465))))
end
if _a40.Egg then
for _a466, _a467 in ipairs({ "GetMaxHatch", "ComputeDebounce", "GetHighestEggNumberAvailable" }) do
if rawget(_a40.Egg, _a467) then
local _a468, _a469 = pcall(_a40.Egg[_a467], _a457)
_a6(("  %-28s : %s"):format(_a467, _a468 and tostring(_a469) or ("에러 " .. tostring(_a469))))
end
end
end
_a6("  OpeningEgg      : " .. tostring(_a40.Vars and rawget(_a40.Vars, "OpeningEgg")))
if _a40.Hatch then
for _a470, _a471 in ipairs({ "IsHatching", "GetEggAmount" }) do
if rawget(_a40.Hatch, _a471) then
local _a472, _a473 = pcall(_a40.Hatch[_a471])
_a6(("  %-15s : %s"):format(_a471, _a472 and tostring(_a473) or ("에러 " .. tostring(_a473))))
end
end
if rawget(_a40.Hatch, "GetEggDirectory") then
local _a474, _a475 = pcall(_a40.Hatch.GetEggDirectory)
_a6("  세팅된 알       : " .. (_a474 and _a475 and tostring(rawget(_a475, "_id")) or "없음"))
end
end
_a6("  ▶ SetupEgg 시도")
_a41.egg._ahEgg = nil
_a41.egg.autoHatchOn(_a456, 1)
if _a40.Hatch and rawget(_a40.Hatch, "IsHatching") then
local _a476, _a477 = pcall(_a40.Hatch.IsHatching)
_a6("    IsHatching 이후 : " .. (_a476 and tostring(_a477) or ("에러 " .. tostring(_a477))))
_a6("    " .. ((_a476 and _a477) and "→ 클릭 없이 넘어갑니다"
or "→ SetupEgg 안 먹음. 클릭 대체가 필요합니다"))
end
_a6("  신호 가능 : getgc " .. tostring(type(getgc) == "function")
.. " / debug.setupvalue " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
_a6("")
_a6("  ▶ 1개로 실제 호출")
local _a478, _a479
local _a480 = pcall(function() _a478, _a479 = _a8.R_EGG:InvokeServer(_a456, 1) end)
_a6("    호출성공 : " .. tostring(_a480))
_a6("    반환1    : " .. tostring(_a478))
_a6("    반환2    : " .. tostring(_a479))
_a96("log")
end)
end },
{ label = "지금 전부 해금", col = _a54.good, fn = function()
task.spawn(function()
_a6("")
local _a481, _a482 = _a41.egg.unlockEggs(true)
_a6(_a481 > 0 and ("[해금] %d개 완료"):format(_a481)
or ("[해금] 0개" .. (_a482 and (" — " .. tostring(_a482)) or "")))
_a96("log")
end)
end },
})
_a159(_a437, {
{ label = "알 현황 보기", col = _a54.accent, fn = function()
local _a483 = _a48()
_a6("")
if not _a483 then _a6("[부화] 알을 못 찾음")
else
_a6("──── 메인 알 ────")
_a6("  " .. tostring(_a483.id))
_a6("  가격 " .. (_a483.price and _a7(_a483.price, 0) or "?") .. " " .. tostring(_a483.currency))
_a6("  보유 " .. _a7(_a483.have, 0))
_a6("  한 번에 " .. _a483.maxN .. "개까지")
_a6("  지금 가능 " .. _a483.canBuy .. "회")
if _a483.inRange then
_a6(("  거리 %.0f 스터드 — 부화 가능"):format(_a483.dist))
else
_a6(("  사거리(%d) 안에 알 없음. 가장 가까운 알 %s스터드"):format(
_a9.EggRange, _a483.nearest and ("%.0f"):format(_a483.nearest) or "?"))
_a6("  → 알 앞으로 걸어가야 부화됩니다")
end
end
_a6("")
_a6("──── 주변 알 (가까운 순 10개) ────")
local _a484 = _a41.egg.eggStands()
for _a485 = 1, math.min(10, #_a484) do
local _a486 = _a484[_a485]
_a6(("  %6.0f  #%-3d %-24s %s"):format(
_a486.dist, _a486.num, _a486.id, _a41.egg.eggUnlocked(_a486.num) and "오픈함" or "잠김"))
end
if #_a484 == 0 then _a6("  (못 찾음)") end
_a96("log")
end },
{ label = "지금 1회", col = _a54.cardHi, fn = function()
task.spawn(function() _a11.mhatch = true _a49() _a11.mhatch = false _a96("log") end)
end },
})
local _a487, _a488 = _a129(_a326, "랭크 퀘스트 자동", nil)
_a139(_a488, "quest", function()
_a53("quest", function() return _a9.QuestInterval end, _a41.quest.cycle, "퀘스트")
end)
_a150(_a487, {
{ label = "주기", value = _a9.QuestInterval, onChange = function(_a489)
local _a490 = tonumber(_a489) if _a490 and _a490 >= 5 then _a9.QuestInterval = _a490 end
end },
{ label = "포션 한 번에", value = _a9.QuestUseMax, onChange = function(_a491)
local _a492 = tonumber(_a491) if _a492 and _a492 >= 1 then _a9.QuestUseMax = math.floor(_a492) end
end },
})
_a169(_a487, "필요한 자동화 자동 ON",
function() return _a9.QuestDrive end,
function(_a493) _a9.QuestDrive = _a493 end)
_a169(_a487, "포션/인챈트 업글 퀘스트",
function() return _a9.QuestUpgrade end,
function(_a494) _a9.QuestUpgrade = _a494 end)
_a169(_a487, "포션 사용 퀘스트",
function() return _a9.QuestUsePotion end,
function(_a495) _a9.QuestUsePotion = _a495 end)
_a159(_a487, {
{ label = "퀘스트 현황 보기", col = _a54.accent, fn = function()
local _a496 = _a41.quest.status()
_a6("")
if not _a496 then _a6("[퀘스트] 세이브 못 읽음")
else
_a6("──── 랭크 퀘스트 ────")
_a6(("  Rank %d   ★%d"):format(_a496.rank, _a496.rankStars))
if #_a496.list == 0 then _a6("  퀘스트 없음") end
for _a497, _a498 in ipairs(_a496.list) do
local _a499 = _a498.how
local _a500 =
(_a499 == "farm" and "자동 파밍") or
(_a499 == "hatch" and "자동 부화") or
(_a499 == "zone" and "자동 존") or
(_a499 == "potup" and "포션 업글") or
(_a499 == "encup" and "인챈트 업글") or
(_a499 == "potuse" and "포션 사용") or
(_a499 == "fruituse" and "과일 사용") or
(_a499 == "flaguse" and "깃발 사용") or
(_a499 == "gold" and "골드 머신") or
(_a499 == "rainbow" and "레인보우 머신") or
"수동"
local _a501 = ""
if _a498.ignored then
_a500 = "무시"
_a501 = "   → " .. _a498.ignored
elseif _a498.event then
local _a502 = _a41.ev.findEvent(_a498.event, _a498.bestOnly)
_a501 = _a502 and ("   → %s @%s %d초"):format(_a502.name, tostring(_a502.zone), _a502.left)
or ("   → " .. _a498.event .. " 대기중")
elseif _a498.chest then
_a501 = "   → " .. _a498.chest
elseif _a498.where then
_a501 = "   → " .. _a498.where
end
_a6(("  [%d] %s"):format(_a498.stars, tostring(_a498.title)))
_a6(("       %d / %d    처리: %s   (Type %d)%s"):format(
_a498.progress, _a498.amount, _a500, _a498.type, _a501))
end
end
_a96("log")
end },
{ label = "활성 이벤트 보기", col = _a54.accent, fn = function()
local _a503 = _a41.ev.events()
local _a504 = _a41.move.bestZone()
_a6("")
_a6("──── 지금 떠 있는 랜덤 이벤트 ────")
_a6("  최고 존 : " .. tostring(_a504) .. "   현재 존 : " .. tostring(_a41.move.curZone()))
if #_a503 == 0 then _a6("  없음 (RandomEvents_Get 응답 비어있음)") end
for _a505, _a506 in ipairs(_a503) do
_a6(("  %-12s @%-20s %4d초 남음  %s%s"):format(
_a506.kind, tostring(_a506.zone), _a506.left,
_a506.pos and ("(%.0f, %.0f, %.0f)"):format(_a506.pos.X, _a506.pos.Y, _a506.pos.Z) or "좌표없음",
_a506.zone == _a504 and "  ★최고존" or ""))
end
_a6("")
_a6("  내 소환 아이템 :")
for _a507 in pairs(_a41.ev.SPAWN) do
local _a508 = _a41.ev.spawnItems(_a507)
local _a509 = 0
for _a510, _a511 in ipairs(_a508) do _a509 += _a511.am end
_a6(("    %-12s %d종 %d개"):format(_a507, #_a508, _a509))
for _a512, _a513 in ipairs(_a508) do
_a6(("        %d. %-24s x%d%s"):format(
_a512, _a513.id, _a513.am, _a512 == 1 and "   ← 먼저 씀" or ""))
if _a512 >= 6 then break end
end
end
_a6("  점선 네모 안? " .. tostring(_a41.move.inDottedBox()))
for _a514, _a515 in ipairs({ "MiniChests", "SuperiorMiniChests" }) do
local _a516, _a517 = _a41.ev.findChest(_a515)
_a6(("  %-20s %s"):format(_a515,
_a516 and ("가장 가까운 것 %.0f스터드"):format(_a517 or 0) or "없음"))
end
_a96("log")
end },
{ label = "포션 재고 보기", col = _a54.accent, fn = function()
_a6("")
_a6("──── 포션 / 인챈트 재고 ────")
for _a518, _a519 in ipairs({ "Potion", "Enchant" }) do
local _a520 = _a41.item.stacks(_a519)
table.sort(_a520, function(_a521, _a522)
if _a521.id ~= _a522.id then return _a521.id < _a522.id end
return _a521.tier < _a522.tier
end)
_a6("")
_a6(_a519 .. "  (" .. #_a520 .. "종)")
for _a523, _a524 in ipairs(_a520) do
local _a525 = _a41.item.perTier(_a519, _a524.tier)
local _a526 = _a525 and math.floor(_a524.am / _a525) or 0
_a6(("   %-20s T%-2d x%-6d %s"):format(
_a524.id, _a524.tier, _a524.am,
_a526 > 0 and ("→ T" .. (_a524.tier + 1) .. " " .. _a526 .. "개 제작가능") or ""))
if _a523 >= 40 then _a6("   ...") break end
end
if #_a520 == 0 then _a6("   (없음)") end
end
_a96("log")
end },
{ label = "지금 1회", col = _a54.cardHi, fn = function()
task.spawn(function() _a11.quest = true _a41.quest.cycle() _a11.quest = false _a96("log") end)
end },
})
local _a527, _a528 = _a129(_a326, "슬롯 머신 자동 (다이아)", nil)
_a139(_a528, "slots", function()
_a53("slots", function() return _a9.SlotInterval end, _a41.mach.cycleSlots, "슬롯")
end)
_a150(_a527, {
{ label = "주기", value = _a9.SlotInterval, onChange = function(_a529)
local _a530 = tonumber(_a529) if _a530 and _a530 >= 5 then _a9.SlotInterval = _a530 end
end },
{ label = "남길 다이아", value = _a9.SlotReserve, onChange = function(_a531)
local _a532 = tonumber(_a531) if _a532 and _a532 >= 0 then _a9.SlotReserve = _a532 end
end },
})
_a169(_a527, "펫 장착 슬롯 (Pet Equip)",
function() return _a9.SlotPet end, function(_a533) _a9.SlotPet = _a533 end)
_a169(_a527, "알 부화 슬롯 (Egg Machine)",
function() return _a9.SlotEgg end, function(_a534) _a9.SlotEgg = _a534 end)
_a159(_a527, {
{ label = "슬롯 현황 보기", col = _a54.accent, fn = function()
local _a535 = _a41.mach.slotStatus()
_a6("")
_a6("──── 슬롯 머신 ────")
if not _a535 then _a6("  세이브 못 읽음") _a96("log") return end
_a6("  다이아 " .. _a7(_a535.dia, 0))
_a6("")
_a6(("  펫 장착 : 구매 %d / 랭크상한 %d   현재 최대장착 %s"):format(
_a535.petOwned, _a535.petMax, tostring(_a535.maxEquip)))
if _a535.petNext then
_a6(("     다음 #%d  %s 다이아  %s"):format(
_a535.petNext, _a535.petCost and _a7(_a535.petCost, 0) or "?",
(_a535.petCost and _a535.petCost <= _a535.dia - _a9.SlotReserve) and "← 지금 가능" or "부족"))
else
_a6("     랭크 상한까지 다 삼 (랭크를 올려야 더 살 수 있음)")
end
_a6("")
_a6(("  알 부화 : 구매 %d / 랭크상한 %d   한 번에 %s개"):format(
_a535.eggOwned, _a535.eggMax, tostring(_a535.maxHatch)))
if _a535.eggEnd then
_a6(("     다음 %d칸 묶음 → %d   %s 다이아  %s"):format(
_a535.eggSize, _a535.eggEnd, _a535.eggCost and _a7(_a535.eggCost, 0) or "?",
(_a535.eggCost and _a535.eggCost <= _a535.dia - _a9.SlotReserve) and "← 지금 가능" or "부족"))
else
_a6("     랭크 상한까지 다 삼")
end
_a6("")
_a6("  리모트 : 펫 " .. (_a40.R_PetSlot and "O" or "X")
.. " / 알 " .. (_a40.R_EggSlot and "O" or "X"))
_a96("log")
end },
{ label = "지금 1회", col = _a54.cardHi, fn = function()
task.spawn(function() _a11.slots = true _a41.mach.cycleSlots() _a11.slots = false _a96("log") end)
end },
})
local _a536, _a537 = _a129(_a326, "아이템 자동 사용 (버프 유지)", nil)
_a139(_a537, "items", function()
_a53("items", function() return _a9.ItemInterval end, _a41.item.cycleItems, "아이템")
end)
_a150(_a536, {
{ label = "주기", value = _a9.ItemInterval, onChange = function(_a538)
local _a539 = tonumber(_a538) if _a539 and _a539 >= 5 then _a9.ItemInterval = _a539 end
end },
{ label = "포션 한 바퀴 최대", value = _a9.BuffMaxPotion, onChange = function(_a540)
local _a541 = tonumber(_a540) if _a541 and _a541 >= 1 then _a9.BuffMaxPotion = math.floor(_a541) end
end },
})
_a150(_a536, {
{ label = "남길 개수", value = _a9.ItemKeep, onChange = function(_a542)
local _a543 = tonumber(_a542) if _a543 and _a543 >= 0 then _a9.ItemKeep = math.floor(_a543) end
end },
{ label = "과일/소모품 최대", value = _a9.BuffMaxOther, onChange = function(_a544)
local _a545 = tonumber(_a544) if _a545 and _a545 >= 1 then _a9.BuffMaxOther = math.floor(_a545) end
end },
})
_a150(_a536, {
{ label = "쓸 것 (비우면 전부)", value = _a9.ItemAllow, onChange = function(_a546)
_a9.ItemAllow = _a546 or ""
end },
{ label = "제외", value = _a9.ItemBlock, onChange = function(_a547)
_a9.ItemBlock = _a547 or ""
end },
})
_a169(_a536, "포션", function() return _a9.BuffPotion end,
function(_a548) _a9.BuffPotion = _a548 end)
_a169(_a536, "과일", function() return _a9.BuffFruit end,
function(_a549) _a9.BuffFruit = _a549 end)
_a169(_a536, "얼티밋 (충전되면 발동, 무료)", function() return _a9.BuffUltimate end,
function(_a550) _a9.BuffUltimate = _a550 end)
_a169(_a536, "소모품 (Rain/Sunlight 주의)", function() return _a9.BuffConsumable end,
function(_a551) _a9.BuffConsumable = _a551 end)
_a169(_a536, "높은 티어부터 사용 (끄면 낮은 것부터)", function() return _a9.BuffHighTier end,
function(_a552) _a9.BuffHighTier = _a552 end)
_a169(_a536, "최고 존에서만 사용", function() return _a9.ItemBestZone end,
function(_a553) _a9.ItemBestZone = _a553 end)
_a169(_a536, "최고 존이 아니면 이동 후 사용", function() return _a9.ItemTp end,
function(_a554) _a9.ItemTp = _a554 end)
_a159(_a536, {
{ label = "버프 현황 보기", col = _a54.accent, fn = function()
_a6("")
_a6("──── 버프 / 아이템 ────")
_a6(("  현재 존 %s / 최고 존 %s%s"):format(
tostring(_a41.move.curZone()), tostring(_a41.move.bestZone()),
_a9.ItemBestZone and (_a41.move.curZone() == _a41.move.bestZone() and "   ← 사용 가능" or "   ← 이동 필요") or ""))
for _a555, _a556 in pairs({ Potions = "Potion", Fruits = "Fruit" }) do
local _a557 = _a41.item.activeBuffs(_a555)
local _a558 = {}
for _a559 in pairs(_a557) do _a558[#_a558 + 1] = _a559 end
table.sort(_a558)
_a6(("  지금 걸린 %s : %s"):format(_a555,
#_a558 > 0 and table.concat(_a558, ", ") or "없음"))
end
local _a560 = _a42()
local _a561 = _a560 and rawget(_a560, "Ultimates")
if type(_a561) == "table" then
local _a562 = {}
for _a563 in pairs(_a561) do
local _a564 = "?"
if _a40.Ult and rawget(_a40.Ult, "IsCharged") then
local _a565, _a566 = pcall(_a40.Ult.IsCharged, _a563)
_a564 = _a565 and (_a566 and "충전됨" or "충전중") or "?"
end
_a562[#_a562 + 1] = _a563 .. "(" .. _a564 .. ")"
end
_a6("  얼티밋 : " .. (#_a562 > 0 and table.concat(_a562, ", ") or "없음"))
end
_a6("")
for _a567, _a568 in ipairs({ "Potion", "Fruit", "Consumable" }) do
local _a569 = _a41.item.stacks(_a568)
local _a570, _a571 = 0, 0
for _a572, _a573 in ipairs(_a569) do
if _a41.item.itemAllowed(_a573.id) then _a570 += 1 else _a571 += 1 end
end
_a6(("  %-12s %d종 (쓸 수 있음 %d / 제외 %d)"):format(_a568, #_a569, _a570, _a571))
for _a574, _a575 in ipairs(_a569) do
_a6(("      %-20s T%-2d x%-6d %s"):format(
_a575.id, _a575.tier, _a575.am, _a41.item.itemAllowed(_a575.id) and "" or "제외됨"))
if _a574 >= 12 then _a6("      ...") break end
end
end
_a6("")
_a6("  리모트 : 포션 " .. (_a40.R_PotUse and "O" or "X")
.. " / 과일 " .. (_a40.R_Fruit and "O" or "X")
.. " / 소모품 " .. (_a40.R_Cons and "O" or "X")
.. " / 얼티밋 " .. (_a40.R_Ult and "O" or "X"))
_a96("log")
end },
{ label = "지금 1회", col = _a54.cardHi, fn = function()
task.spawn(function() _a11.items = true _a41.item.cycleItems() _a11.items = false _a96("log") end)
end },
})
local _a576, _a577 = _a129(_a326, "맵 업그레이드 자동 (다이아)", nil)
_a139(_a577, "mapupg", function()
_a53("mapupg", function() return _a9.UpgInterval end, _a41.mach.cycleUpg, "맵업글")
end)
_a150(_a576, {
{ label = "주기", value = _a9.UpgInterval, onChange = function(_a578)
local _a579 = tonumber(_a578) if _a579 and _a579 >= 5 then _a9.UpgInterval = _a579 end
end },
{ label = "남길 다이아", value = _a9.UpgReserve, onChange = function(_a580)
local _a581 = tonumber(_a580) if _a581 and _a581 >= 0 then _a9.UpgReserve = _a581 end
end },
})
_a169(_a576, "구매 전 그 앞으로 이동",
function() return _a9.UpgTp end,
function(_a582) _a9.UpgTp = _a582 end)
_a159(_a576, {
{ label = "업그레이드 목록", col = _a54.accent, fn = function()
local _a583 = _a41.mach.upgList()
local _a584 = _a43("Diamonds")
_a6("")
_a6("──── 맵 업그레이드 ────")
_a6("보유 다이아 " .. _a7(_a584, 0))
if #_a583 == 0 then
_a6("  로드된 업그레이드 기둥이 없음 (해당 존에 가야 보입니다)")
end
local _a585, _a586, _a587 = 0, 0, 0
for _a588, _a589 in ipairs(_a583) do
if _a589.bought then _a586 += 1
elseif not _a589.zoneOwned then _a587 += 1
else _a585 += 1 end
end
_a6(("  구매가능 %d / 구매완료 %d / 존 미보유 %d"):format(_a585, _a586, _a587))
_a6("")
local _a590 = 0
for _a591, _a592 in ipairs(_a583) do
if _a592.buyable then
_a590 += 1
_a6(("  %-12s T%-2d %-20s %12s %-9s %s"):format(
_a592.id, _a592.tier, _a592.zone, _a592.cost and _a7(_a592.cost, 0) or "?",
tostring(_a592.cur),
(_a592.cost and _a592.cost <= _a43(_a592.cur or "Diamonds") - _a9.UpgReserve)
and "← 지금 가능" or ""))
if _a590 >= 25 then _a6("  ...") break end
end
end
_a96("log")
end },
{ label = "업글 진단", col = _a54.warn, fn = function()
task.spawn(function()
_a6("")
_a6("──── 맵 업그레이드 진단 ────")
_a6("  리모트 : " .. (_a40.R_Upg and _a40.R_Upg:GetFullName() or "없음"))
local _a593 = _a41.mach.upgList()
_a6("  로드된 기둥 " .. #_a593 .. "개")
local _a594
for _a595, _a596 in ipairs(_a593) do
if _a596.buyable and _a596.cost then _a594 = _a596 break end
end
if not _a594 then
_a6("  살 수 있는 게 없음 (전부 구매완료거나 존 미보유)")
for _a597, _a598 in ipairs(_a593) do
_a6(("   %-12s T%-2d @%-18s 구매됨=%s 존보유=%s"):format(
_a598.id, _a598.tier, tostring(_a598.zone), tostring(_a598.bought), tostring(_a598.zoneOwned)))
if _a597 >= 8 then _a6("   ...") break end
end
_a96("log") return
end
local _a599 = _a43(_a594.cur or "Diamonds")
local _a600 = _a41.move.hrp()
local _a601 = (_a600 and _a594.pos) and (_a600.Position - _a594.pos).Magnitude or nil
_a6(("  대상 : %s T%d @%s"):format(_a594.id, _a594.tier, tostring(_a594.zone)))
_a6(("  가격 : %s %s / 보유 %s"):format(
_a7(_a594.cost, 0), tostring(_a594.cur), _a7(_a599, 0)))
_a6("  거리 : " .. (_a601 and ("%.0f 스터드"):format(_a601) or "좌표 없음"))
_a6("")
_a6("  ▶ 제자리에서 호출")
local _a602, _a603
local _a604 = pcall(function() _a602, _a603 = _a40.R_Upg:InvokeServer(_a594.id, _a594.zone) end)
_a6("    호출성공 " .. tostring(_a604) .. " / 반환1 " .. tostring(_a602)
.. " / 반환2 " .. tostring(_a603))
if not _a602 and _a594.pos then
_a6("")
_a6("  ▶ 기둥 앞으로 이동해서 재시도")
_a41.move.glideTo(_a594.pos)
task.wait(0.3)
local _a605 = _a41.move.hrp()
_a6("    이동후 거리 " .. (_a605 and ("%.0f"):format((_a605.Position - _a594.pos).Magnitude) or "?"))
local _a606, _a607
local _a608 = pcall(function() _a606, _a607 = _a40.R_Upg:InvokeServer(_a594.id, _a594.zone) end)
_a6("    호출성공 " .. tostring(_a608) .. " / 반환1 " .. tostring(_a606)
.. " / 반환2 " .. tostring(_a607))
_a6("")
_a6(_a606 and "  → 거리 검사 있음. 이동해야 됩니다."
or "  → 이동해도 실패. 거리 문제가 아닙니다.")
else
_a6("")
_a6(_a602 and "  → 원격으로 됩니다. 이동 불필요." or "  → 실패 (좌표 없음)")
end
_a96("log")
end)
end },
{ label = "지금 1회", col = _a54.cardHi, fn = function()
task.spawn(function() _a11.mapupg = true _a41.mach.cycleUpg() _a11.mapupg = false _a96("log") end)
end },
})
local _a609, _a610 = _a129(_a326, "자동 리버스", nil)
_a139(_a610, "mreb", function()
_a53("mreb", function() return _a9.MainRebirthInterval end, _a51, "리버스")
end)
_a150(_a609, {
{ label = "주기", value = _a9.MainRebirthInterval, onChange = function(_a611)
local _a612 = tonumber(_a611) if _a612 and _a612 >= 10 then _a9.MainRebirthInterval = _a612 end
end },
})
_a169(_a609, "실패 이유 로그",
function() return _a9.MainRebirthVerbose end,
function(_a613) _a9.MainRebirthVerbose = _a613 end)
_a159(_a609, {
{ label = "리버스 현황 보기", col = _a54.accent, fn = function()
local _a614 = _a50()
_a6("")
if not _a614 then _a6("[리버스] 세이브 못 읽음")
else
_a6("──── 메인 리버스 ────")
_a6("  현재 " .. _a614.current .. "회 → 다음 " .. _a614.nextN)
if type(_a614.def) == "table" then
for _a615, _a616 in pairs(_a614.def) do
if type(_a616) ~= "table" and type(_a616) ~= "function" then
_a6("    " .. tostring(_a615) .. " = " .. tostring(_a616))
end
end
end
end
_a96("log")
end },
{ label = "지금 1회", col = _a54.bad, fn = function()
task.spawn(function() _a11.mreb = true _a51() _a11.mreb = false _a96("log") end)
end },
})
local _a617 = _a129(_a326, "전체 제어", nil)
_a159(_a617, {
{ label = "메인 전부 ON", col = _a54.good, fn = function()
local _a618 = {
{ "farm",   function() return _a9.FarmInterval end,       _a44,       "파밍" },
{ "zone",   function() return _a9.ZoneInterval end,       _a46,       "존" },
{ "mhatch", function() return _a9.MainHatchInterval end,  _a49,  "부화" },
{ "quest",  function() return _a9.QuestInterval end,      _a41.quest.cycle,        "퀘스트" },
{ "mapupg", function() return _a9.UpgInterval end,        _a41.mach.cycleUpg,     "맵업글" },
{ "items",  function() return _a9.ItemInterval end,       _a41.item.cycleItems,   "아이템" },
{ "slots",  function() return _a9.SlotInterval end,       _a41.mach.cycleSlots,   "슬롯" },
}
for _a619, _a620 in ipairs(_a618) do
if not _a11[_a620[1]] then
_a11[_a620[1]] = true
_a53(_a620[1], _a620[2], _a620[3], _a620[4])
end
end
_a136()
_a6("[메인] 파밍/존/부화/랭크/퀘스트/맵업글 ON  (리버스는 따로)")
end },
{ label = "메인 전부 OFF", col = _a54.bad, fn = function()
_a41.ctl.stopAll()
_a136()
_a6("[메인] 정지")
end },
})
end
_a87.MouseButton1Click:Connect(function()
local _a621 = table.concat(_a5, "\n")
if #_a621 > 900000 then _a621 = _a621:sub(#_a621 - 900000) end
if type(setclipboard) == "function" then
pcall(setclipboard, _a621)
_a87.Text = "완료"
task.delay(1.5, function() if _a87 then _a87.Text = "복사" end end)
end
end)
_a86.MouseButton1Click:Connect(function()
table.clear(_a5)
_a1.dirty = true
end)
local function _a622()
_a11.place, _a11.merchant, _a11.upgrade = false, false, false
_a11.towerup, _a11.crop, _a11.expand, _a11.rebirth, _a11.hatch, _a11.luck = false, false, false, false, false, false
_a11.farm, _a11.zone, _a11.mhatch, _a11.rank, _a11.mreb = false, false, false, false, false
if _a190 then _a190:Disconnect() end
if _a72 then _a72:Destroy() end
_G.__PS99_GARDEN = nil
end
_a84.MouseButton1Click:Connect(_a622)
_G.__PS99_GARDEN = _a622
_a96("dash")
_a6("PS99 자동")
if _a1.lpWait then
_a6(("[진단] LocalPlayer 가 늦게 잡혔습니다 — %.1f초 대기, 결과 %s")
:format(_a1.lpWait, _a1.lpFail and "실패 (기능 대부분 못 씀)" or "성공"))
end
if _a11.auto then
if _a41.auto.start then
_a6("[자동] 올 자동 켜짐 — 1초 뒤 시작합니다")
task.spawn(function()
task.wait(1)
_a41.ctl.abort = false
local _a623, _a624 = pcall(_a41.auto.start)
if _a623 then
_a6("[자동] 시작됨")
else
_a11.auto = false
_a6("[자동] 시작 실패: " .. tostring(_a624))
if _a41.auto.refresh then pcall(_a41.auto.refresh) end
end
end)
else
_a11.auto = false
_a6("[자동] QS.auto.start 가 없습니다 — 메인 게임 탭이 안 만들어짐")
end
end
pcall(function()
local _a625, _a626, _a627, _a628 = _a14()
if _a625 and _a627 then
local _a629 = _a15(_a627, _a628)
_a12.slots = #_a629
_a6("레인 " .. _a628 .. " / 슬롯 " .. #_a629)
else
_a6("가든 이벤트 밖입니다 (이벤트 탭은 이벤트 안에서만 동작)")
end
_a12.sun = _a20()
_a6("Sunflowers " .. _a7(_a12.sun, 0))
end)
end
