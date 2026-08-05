return function(_a1)
local _a2, _a3, _a4, _a5, _a6, _a7 = _a1.UIS, _a1.RunService, _a1.LP, _a1.LOG, _a1.log, _a1.num
local _a8, _a9, _a10, _a11, _a12, _a13 = _a1.RM, _a1.CFG, _a1.EGG_COST_CACHE, _a1.RUN, _a1.STAT, _a1.EVENT_UPGRADES
local _a14, _a15, _a16, _a17, _a18, _a19 = _a1.ctx, _a1.collectSlots, _a1.placedTowers, _a1.availableItems, _a1.cyclePlace, _a1.cycleMerchant
local _a20, _a21, _a22, _a23, _a24, _a25 = _a1.sunflowers, _a1.eventTiers, _a1.nextCost, _a1.cycleUpgrade, _a1.seedInv, _a1.bedsOf
local _a26, _a27, _a28, _a29, _a30, _a31 = _a1.isUnhatched, _a1.bedCps, _a1.cycleCrop, _a1.laneCosts, _a1.lockedBeds, _a1.cycleExpand
local _a32, _a33, _a34, _a35, _a36, _a37 = _a1.rebirthStatus, _a1.cycleRebirth, _a1.eggCost, _a1.hatchStatus, _a1.cycleHatch, _a1.LUCK_ORDER
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
_a42.stopAll()
if refreshAllSwitches then pcall(refreshAllSwitches) end
_a6("[정지] 모든 동작을 멈췄습니다")
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
_a42.refresh = _a137
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
local _a148 = _a11[_a142]
_a144.BackgroundColor3 = _a148 and _a55.good or _a55.cardHi
_a145:TweenPosition(UDim2.fromOffset(_a148 and 25 or 3, 3),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
_a145.BackgroundColor3 = _a148 and Color3.fromRGB(255, 255, 255) or _a55.dim
_a146.Text = _a148 and "ON" or "OFF"
_a146.TextColor3 = _a148 and _a55.good or _a55.dim
end
_a144.MouseButton1Click:Connect(function()
_a11[_a142] = not _a11[_a142]
if _a11[_a142] then
if _a142 == "auto" then _a42.abort = false end
_a147()
_a6("[" .. _a142 .. "] 시작")
local _a149, _a150 = pcall(_a143)
if not _a149 then _a6("[에러] " .. tostring(_a150)) end
else
if _a142 == "auto" then
_a42.stopAll()
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
local _a168, _a169 = pcall(_a166.fn, _a167)
if not _a168 then _a6("[에러] " .. tostring(_a166.label) .. " → " .. tostring(_a169)) end
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
local _a179
do
local _a180 = _a56("Frame", {
Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(13, 14, 18),
BorderSizePixel = 0, LayoutOrder = _a125(),
}, _a178)
_a63(_a180, 8)
_a66(_a180, _a55.line, 1)
local _a181 = _a56("ScrollingFrame", {
Size = UDim2.new(1, -10, 1, -10), Position = UDim2.fromOffset(5, 5),
BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4,
ScrollBarImageColor3 = _a55.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a180)
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
local _a182, _a183, _a184, _a185
_a78.InputBegan:Connect(function(_a186)
if _a186.UserInputType == Enum.UserInputType.MouseButton1
or _a186.UserInputType == Enum.UserInputType.Touch then
_a182, _a183, _a184 = true, _a186.Position, _a77.Position
_a186.Changed:Connect(function()
if _a186.UserInputState == Enum.UserInputState.End then _a182 = false end
end)
end
end)
_a78.InputChanged:Connect(function(_a187)
if _a187.UserInputType == Enum.UserInputType.MouseMovement
or _a187.UserInputType == Enum.UserInputType.Touch then _a185 = _a187 end
end)
_a2.InputChanged:Connect(function(_a188)
if _a182 and _a188 == _a185 then
local _a189 = _a188.Position - _a183
_a77.Position = UDim2.new(_a184.X.Scale, _a184.X.Offset + _a189.X,
_a184.Y.Scale, _a184.Y.Offset + _a189.Y)
end
end)
local _a190 = false
_a86.MouseButton1Click:Connect(function()
_a190 = not _a190
_a77:TweenSize(_a190 and UDim2.fromOffset(_a75, 40) or UDim2.fromOffset(_a75, _a76),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
_a86.Text = _a190 and "▢" or "—"
end)
end
local _a191 = _a3.Heartbeat:Connect(function()
if not _a1.dirty then return end
_a1.dirty = false
local _a192 = #_a5
_a179.Text = table.concat(table.move(_a5, math.max(1, _a192 - 300), _a192, 1, {}), "\n")
end)
local _a193 = _a114("dash", "대시보드", 10)
local _a194 = _a114("event", "이벤트", 20)
do
local _a195 = _a130(_a193, "전체 제어", nil)
_a160(_a195, {
{ label = "권장 전부 ON", col = _a55.good, fn = function()
for _a196, _a197 in ipairs({ "place", "merchant", "crop", "expand", "hatch" }) do
if not _a11[_a197] then
_a11[_a197] = true
if _a197 == "place"    then _a54(_a197, function() return _a9.PlaceInterval end, _a18, "배치") end
if _a197 == "merchant" then _a54(_a197, function() return _a9.MerchantInterval end, _a19, "구매") end
if _a197 == "crop"     then _a54(_a197, function() return _a9.CropInterval end, _a28, "씨앗") end
if _a197 == "expand"   then _a54(_a197, function() return _a9.ExpandInterval end, _a31, "확장") end
if _a197 == "hatch"    then _a54(_a197, function() return _a9.HatchInterval end, _a36, "뽑기") end
end
end
_a137()
_a6("[전체] 배치/구매/씨앗/확장/뽑기 ON  (업글·리버스는 따로 켜세요)")
end },
{ label = "전부 정지", col = _a55.bad, fn = function()
_a11.place, _a11.merchant, _a11.upgrade = false, false, false
_a11.towerup, _a11.crop, _a11.expand, _a11.rebirth, _a11.hatch, _a11.luck = false, false, false, false, false, false
_a11.farm, _a11.zone, _a11.mhatch, _a11.rank, _a11.mreb = false, false, false, false, false
_a137()
_a6("[전체] 정지")
end },
})
local _a198 = _a130(_a193, "현황", nil)
_a160(_a198, {
{ label = "밭 / 타워", col = _a55.accent, fn = function()
local _a199, _a200, _a201, _a202 = _a14()
_a6("")
_a6("──── 현재 상태 ────")
_a6("레인 " .. tostring(_a202) .. " / plot " .. (_a201 and "O" or "X")
.. " / world " .. (_a199 and "O" or "X"))
local _a203 = _a15(_a201, _a202)
local _a204 = _a16(_a199)
_a6("슬롯 " .. #_a203 .. " / 배치 " .. #_a204)
local _a205, _a206 = 0, {}
for _a207, _a208 in ipairs(_a204) do
_a205 += (_a208.dps or 0)
_a206[tostring(_a208.kind)] = (_a206[tostring(_a208.kind)] or 0) + 1
end
_a6("총 DPS " .. _a7(_a205))
for _a209, _a210 in pairs(_a206) do _a6("  " .. _a209 .. " × " .. _a210) end
local _a211 = _a17()
_a6("")
_a6("배치 가능 " .. #_a211 .. "종")
for _a212 = 1, math.min(10, #_a211) do
local _a213 = _a211[_a212]
_a6(("  %-22s %-7s 남은 %-3s DPS %s"):format(
tostring(_a213.id), tostring(_a213.vr or "-"), tostring(_a213.copies), _a7(_a213.dps)))
end
_a97("log")
end },
{ label = "로그 보기", col = _a55.cardHi, fn = function() _a97("log") end },
})
end
do
local _a214, _a215 = _a130(_a194, "자동 배치 / 교체", nil)
_a140(_a215, "place", function()
_a54("place", function() return _a9.PlaceInterval end, _a18, "배치")
end)
_a151(_a214, {
{ label = "주기", value = _a9.PlaceInterval, onChange = function(_a216)
local _a217 = tonumber(_a216) if _a217 and _a217 >= 3 then _a9.PlaceInterval = _a217 end
end },
{ label = "교체 배수", value = _a9.SwapMargin, onChange = function(_a218)
local _a219 = tonumber(_a218) if _a219 and _a219 >= 1 then _a9.SwapMargin = _a219 _a6("[설정] 교체 배수 " .. _a219) end
end },
{ label = "DoT 반영", value = _a9.DotFactor, onChange = function(_a220)
local _a221 = tonumber(_a220) if _a221 and _a221 >= 0 and _a221 <= 1 then _a9.DotFactor = _a221 end
end },
})
_a170(_a214, "업글 타워 보호",
function() return _a9.ProtectUpgraded end,
function(_a222) _a9.ProtectUpgraded = _a222
_a6("[설정] 업글 보호 " .. (_a222 and "ON — 업글된 건 안 건드림" or "OFF — 약하면 교체")) end)
_a160(_a214, {
{ label = "지금 1회 실행", col = _a55.accent, fn = function()
task.spawn(function() _a11.place = true _a18() _a11.place = false _a97("log") end)
end },
})
end
do
local _a223, _a224 = _a130(_a194, "머천트 자동 구매", nil)
_a140(_a224, "merchant", function()
_a54("merchant", function() return _a9.MerchantInterval end, _a19, "구매")
end)
_a151(_a223, {
{ label = "머천트 ID", value = _a9.MerchantId, onChange = function(_a225)
if _a225 ~= "" then _a9.MerchantId = _a225 _a6("[설정] 머천트 " .. _a225) end
end },
{ label = "주기", value = _a9.MerchantInterval, onChange = function(_a226)
local _a227 = tonumber(_a226) if _a227 and _a227 >= 5 then _a9.MerchantInterval = _a227 end
end },
})
_a160(_a223, {
{ label = "지금 1회 구매", col = _a55.accent, fn = function()
task.spawn(function() _a11.merchant = true _a19() _a11.merchant = false _a97("log") end)
end },
})
end
do
local _a228, _a229 = _a130(_a194, "업그레이드 머신", nil)
_a140(_a229, "upgrade", function()
_a54("upgrade", function() return _a9.UpgradeInterval end, _a23, "머신업글")
end)
_a151(_a228, {
{ label = "주기", value = _a9.UpgradeInterval, onChange = function(_a230)
local _a231 = tonumber(_a230) if _a231 and _a231 >= 5 then _a9.UpgradeInterval = _a231 end
end },
{ label = "최소 잔액", value = _a9.MinSunflowers, onChange = function(_a232)
local _a233 = tonumber(_a232) if _a233 and _a233 >= 0 then _a9.MinSunflowers = _a233
_a6("[설정] 최소 잔액 " .. _a7(_a233, 0)) end
end },
})
_a170(_a228, "가격 미상 구매",
function() return _a9.BuyUnknownCost end,
function(_a234) _a9.BuyUnknownCost = _a234 end)
_a160(_a228, {
{ label = "업글 현황 보기", col = _a55.accent, fn = function()
local _a235 = _a20()
local _a236 = _a21()
_a12.sun = _a235
_a6("")
_a6("──── 업그레이드 머신 ────")
_a6("Sunflowers = " .. _a7(_a235, 0))
local _a237 = {}
for _a238, _a239 in ipairs(_a13) do
local _a240 = _a236[_a239] or 0
_a237[#_a237 + 1] = { id = _a239, tier = _a240, cost = _a22(_a239, _a240) }
end
table.sort(_a237, function(_a241, _a242)
return (_a241.cost or math.huge) < (_a242.cost or math.huge)
end)
for _a243, _a244 in ipairs(_a237) do
_a6(("  %-22s Lv%-3s 다음 %-14s %s"):format(
_a244.id, tostring(_a244.tier), _a244.cost and _a7(_a244.cost, 0) or "?",
(_a244.cost and _a244.cost <= _a235) and "← 구매가능" or ""))
end
_a97("log")
end },
{ label = "지금 1회 업글", col = _a55.cardHi, fn = function()
task.spawn(function() _a11.upgrade = true _a23() _a11.upgrade = false _a97("log") end)
end },
})
local _a245, _a246 = _a130(_a194, "타워 개별 업글", nil)
_a140(_a246, "towerup", function()
_a54("towerup", function() return _a9.UpgradeInterval end, _a53, "타워업글")
end)
end
do
local _a247, _a248 = _a130(_a194, "자동 뽑기", nil)
_a140(_a248, "hatch", function()
_a54("hatch", function() return _a9.HatchInterval end, _a36, "뽑기")
end)
_a151(_a247, {
{ label = "주기", value = _a9.HatchInterval, onChange = function(_a249)
local _a250 = tonumber(_a249) if _a250 and _a250 >= 1 then _a9.HatchInterval = _a250 end
end },
{ label = "한 번에 최대", value = _a9.HatchMax, onChange = function(_a251)
local _a252 = tonumber(_a251) if _a252 and _a252 >= 1 then _a9.HatchMax = math.floor(_a252) end
end },
})
_a151(_a247, {
{ label = "예비금", value = _a9.HatchReserve, onChange = function(_a253)
local _a254 = tonumber(_a253) if _a254 and _a254 >= 0 then _a9.HatchReserve = _a254
_a6("[설정] 뽑기 예비금 " .. _a7(_a254, 0)) end
end },
{ label = "알 번호 (0=자동)", value = _a9.HatchEggNum, onChange = function(_a255)
local _a256 = tonumber(_a255) if _a256 and _a256 >= 0 and _a256 <= 12 then
_a9.HatchEggNum = math.floor(_a256)
table.clear(_a10)
_a6("[설정] 알 번호 " .. (_a256 == 0 and "자동" or _a256)) end
end },
})
_a160(_a247, {
{ label = "뽑기 현황 보기", col = _a55.accent, fn = function()
local _a257 = _a35()
_a12.sun = _a257.sun
_a6("")
_a6("──── 뽑기 현황 ────")
_a6("  알 등급     " .. _a257.id)
_a6("  알 uid      " .. tostring(_a257.uid))
_a6("  개당 비용   " .. (_a257.cost and _a7(_a257.cost, 0) or "?"))
_a6("  Sunflowers  " .. _a7(_a257.sun, 0))
_a6("  예비금      " .. _a7(_a9.HatchReserve, 0))
_a6("  지금 가능   " .. _a257.canBuy .. "회")
_a6("")
_a6("  월드의 알 " .. _a257.eggCount .. "개")
for _a258, _a259 in ipairs(_a257.eggs) do
if _a258 > 5 then break end
_a6(("    %s  거리 %s"):format(_a259.uid, _a7(_a259.dist)))
end
_a6("")
_a6("  누적 뽑기   " .. _a12.hatched .. "회")
_a97("log")
end },
{ label = "지금 1회 실행", col = _a55.cardHi, fn = function()
task.spawn(function() _a11.hatch = true _a36() _a11.hatch = false _a97("log") end)
end },
})
end
do
local _a260, _a261 = _a130(_a194, "럭 상시 최대 유지", nil)
_a140(_a261, "luck", function()
_a54("luck", function() return _a9.LuckInterval end, _a40, "럭")
end)
_a151(_a260, {
{ label = "주기", value = _a9.LuckInterval, onChange = function(_a262)
local _a263 = tonumber(_a262) if _a263 and _a263 >= 60 then _a9.LuckInterval = _a263 end
end },
{ label = "예비금", value = _a9.LuckReserve, onChange = function(_a264)
local _a265 = tonumber(_a264) if _a265 and _a265 >= 0 then _a9.LuckReserve = _a265 end
end },
})
_a151(_a260, {
{ label = "최소 부족분", value = _a9.LuckMinTopUp, onChange = function(_a266)
local _a267 = tonumber(_a266) if _a267 and _a267 >= 0 then _a9.LuckMinTopUp = _a267 end
end },
})
for _a268, _a269 in ipairs(_a37) do
_a170(_a260, _a269,
function() return _a9.LuckBoosts[_a269] end,
function(_a270) _a9.LuckBoosts[_a269] = _a270 end)
end
_a160(_a260, {
{ label = "럭 현황 보기", col = _a55.accent, fn = function()
local _a271 = _a38()
_a12.sun = _a271.sun
_a6("")
_a6("──── 이벤트 럭 ────")
_a6("  머신 활성   " .. (_a271.enabled and "O" or "X"))
_a6("  최대 시간   " .. _a39(_a271.maxSec))
_a6("  Sunflowers  " .. _a7(_a271.sun, 0))
_a6("")
for _a272, _a273 in ipairs(_a271.rows) do
_a6(("  %-12s %-14s 부족 %-14s 필요 %s개%s"):format(
_a273.rarity, _a39(_a273.left), _a39(_a273.deficit), _a7(_a273.need, 0),
_a273.on and "" or "   (꺼짐)"))
end
_a6("")
_a6("  효과 : 비활성 0.5배 → 활성 1.0배 (2배)")
_a97("log")
end },
{ label = "지금 1회 충전", col = _a55.cardHi, fn = function()
task.spawn(function() _a11.luck = true _a40() _a11.luck = false _a97("log") end)
end },
})
end
do
local _a274, _a275 = _a130(_a194, "자동 씨앗 교체", nil)
_a140(_a275, "crop", function()
_a54("crop", function() return _a9.CropInterval end, _a28, "씨앗")
end)
_a151(_a274, {
{ label = "주기", value = _a9.CropInterval, onChange = function(_a276)
local _a277 = tonumber(_a276) if _a277 and _a277 >= 5 then _a9.CropInterval = _a277 end
end },
{ label = "갈아엎기 배수", value = _a9.CropMargin, onChange = function(_a278)
local _a279 = tonumber(_a278) if _a279 and _a279 >= 1 then _a9.CropMargin = _a279 _a6("[설정] 작물 배수 " .. _a279) end
end },
})
_a170(_a274, "성장중 건너뛰기",
function() return _a9.SkipUnhatched end,
function(_a280) _a9.SkipUnhatched = _a280 end)
_a160(_a274, {
{ label = "밭 현황 보기", col = _a55.accent, fn = function()
local _a281, _a282 = _a14()
if not _a282 then _a6("[씨앗] 밭 없음") _a97("log") return end
local _a283, _a284 = _a25(_a282), _a24()
_a6("")
_a6("──── 밭 현황 ────")
_a6("보유 씨앗 (기대 초당수익 순)")
for _a285, _a286 in ipairs(_a284) do
_a6(("  %-10s %-8s ×%-6s  기대 %s/s"):format(
tostring(_a286.id), tostring(_a286.vr or "-"), tostring(_a286.am), _a7(_a286.exp)))
end
local _a287, _a288, _a289, _a290, _a291 = 0, 0, 0, 0, 0
local _a292 = _a284[1]
local _a293 = _a292 and _a292.exp or 0
_a6("")
_a6("심어진 작물")
local _a294 = 0
for _a295, _a296 in pairs(_a283) do
_a287 += 1
local _a297 = _a27(_a296) or 0
_a288 += _a297
if _a26(_a296) then _a290 += 1
elseif _a293 > _a297 * _a9.CropMargin then _a289 += 1
else _a291 += 1 end
_a294 += 1
if _a294 <= 20 then
_a6(("  칸%-4s %-20s %s/s%s"):format(tostring(_a295),
tostring(rawget(_a296, "sp") or "?"), _a7(_a297),
_a26(_a296) and "  (자라는 중)" or ""))
end
end
if _a287 > 20 then _a6("  ... (" .. (_a287 - 20) .. "칸 더)") end
_a6("")
_a6(("총 %d칸 / 합계 %s per sec"):format(_a287, _a7(_a288)))
_a6(("갈아엎기 대상 %d / 유지 %d / 자라는 중 %d"):format(_a289, _a291, _a290))
_a97("log")
end },
{ label = "지금 1회 실행", col = _a55.cardHi, fn = function()
task.spawn(function() _a11.crop = true _a28() _a11.crop = false _a97("log") end)
end },
})
end
do
local _a298, _a299 = _a130(_a194, "자동 확장", nil)
_a140(_a299, "expand", function()
_a54("expand", function() return _a9.ExpandInterval end, _a31, "확장")
end)
_a151(_a298, {
{ label = "주기", value = _a9.ExpandInterval, onChange = function(_a300)
local _a301 = tonumber(_a300) if _a301 and _a301 >= 5 then _a9.ExpandInterval = _a301 end
end },
{ label = "밭칸 스캔", value = _a9.MaxBedScan, onChange = function(_a302)
local _a303 = tonumber(_a302) if _a303 and _a303 >= 1 then _a9.MaxBedScan = math.floor(_a303) end
end },
})
_a160(_a298, {
{ label = "확장 현황 보기", col = _a55.accent, fn = function()
local _a304, _a305, _a306, _a307 = _a14()
if not _a305 then _a6("[확장] 밭 없음") _a97("log") return end
local _a308 = _a20()
_a12.sun = _a308
local _a309 = _a29(true)
_a6("")
_a6("──── 확장 현황 ────")
_a6("Sunflowers = " .. _a7(_a308, 0))
_a6("")
_a6("레인 " .. tostring(_a307) .. "개 열림")
local _a310 = {}
for _a311 in pairs(_a309) do _a310[#_a310 + 1] = tonumber(_a311) or _a311 end
table.sort(_a310, function(_a312, _a313) return tostring(_a312) < tostring(_a313) end)
for _a314, _a315 in ipairs(_a310) do
local _a316 = _a309[_a315] or _a309[tostring(_a315)]
local _a317 = tonumber(_a315) or 0
local _a318 = (_a317 == (tonumber(_a307) or 0) + 1)
and ((tonumber(_a316) or math.huge) <= _a308 and "  ← 지금 오픈 가능" or "  ← 다음 (돈 부족)")
or (_a317 <= (tonumber(_a307) or 0) and "  (열림)" or "")
_a6(("  레인 %-3s %s%s"):format(tostring(_a315), _a7(tonumber(_a316) or 0, 0), _a318))
end
local _a319 = _a30(_a305)
_a6("")
_a6("잠긴 밭칸 " .. #_a319 .. "개 (싼 순 8개)")
for _a320 = 1, math.min(8, #_a319) do
local _a321 = _a319[_a320]
_a6(("  칸 %-4s %s%s"):format(_a321.id, _a321.cost and _a7(_a321.cost, 0) or "?",
(_a321.cost and _a321.cost <= _a308) and "  ← 오픈 가능" or ""))
end
if #_a319 == 0 then _a6("  (전부 열려 있음)") end
_a97("log")
end },
{ label = "지금 1회 실행", col = _a55.cardHi, fn = function()
task.spawn(function() _a11.expand = true _a31() _a11.expand = false _a97("log") end)
end },
})
end
do
local _a322, _a323 = _a130(_a194, "자동 리버스", nil)
_a140(_a323, "rebirth", function()
_a54("rebirth", function() return _a9.RebirthInterval end, _a33, "리버스")
end)
_a151(_a322, {
{ label = "주기", value = _a9.RebirthInterval, onChange = function(_a324)
local _a325 = tonumber(_a324) if _a325 and _a325 >= 10 then _a9.RebirthInterval = _a325 end
end },
})
_a160(_a322, {
{ label = "리버스 현황 보기", col = _a55.accent, fn = function()
local _a326 = _a32()
_a6("")
_a6("──── 리버스 현황 ────")
if not _a326 then _a6("  밭 없음") _a97("log") return end
_a6(("  현재 리버스   %d회  (최대 %s)"):format(_a326.regrows, tostring(_a326.cap)))
_a6(("  레인          %d / 7 %s"):format(_a326.lanes, _a326.lanes >= 7 and "OK" or "부족"))
_a6(("  코인보스      %d / %d %s"):format(_a326.kills, _a326.need,
_a326.kills >= _a326.need and "OK" or "부족"))
_a6("")
_a6(_a326.ready and "  ★ 지금 리버스 가능" or ("  대기 — " .. tostring(_a326.reason)))
_a97("log")
end },
{ label = "지금 1회 리버스", col = _a55.bad, fn = function()
task.spawn(function() _a11.rebirth = true _a33() _a11.rebirth = false _a97("log") end)
end },
})
end
local _a327 = _a114("main", "메인 게임", 30)
do
local _a328, _a329 = _a130(_a327, "올 자동", nil)
local _a330 = _a56("Frame", {
Size = UDim2.new(1, 0, 0, 108), BackgroundColor3 = _a55.cardHi,
BorderSizePixel = 0, LayoutOrder = _a125(),
}, _a328)
_a63(_a330, 6)
_a70(_a330, 8)
local _a331 = _a56("TextLabel", {
Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
Font = Enum.Font.Code, TextSize = 12, TextColor3 = _a55.text,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Text = "정지", RichText = true,
}, _a330)
task.spawn(function()
while _a73 and _a73.Parent do
local _a332 = _a42.now
local _a333 = _a11.auto and "🟢" or "⚪"
local _a334 = _a332.act or "-"
if _a332.detail and _a332.detail ~= "" then _a334 = _a334 .. "  " .. _a332.detail end
_a331.Text = table.concat({
_a333 .. " " .. (_a11.auto and (_a332.step or "-") or "정지"),
"▸ " .. _a334,
"목표 " .. (_a332.goal or "-") .. (_a332.prog ~= "" and ("   " .. _a332.prog) or ""),
"1.리버스 " .. (_a42.rebNote or "-"),
"2.존해금 " .. (_a42.zoneNote or "-"),
"파밍대상 " .. tostring(_a42.farmZone or "-") .. "   현재 " .. tostring(_a42.hereZone or "-"),
}, "\n")
task.wait(0.2)
end
end)
_a140(_a329, "auto", function()
for _a335, _a336 in ipairs(_a42.STEPS) do _a11[_a336.run] = false end
for _a337, _a338 in ipairs(_a42.SIDE) do _a11[_a338.run] = false end
_a11.petspd = true
_a11.rewatch = true
_a137()
_a54("auto", function() return _a9.AutoInterval end, _a42.master, "자동")
end)
_a151(_a328, {
{ label = "주기", value = _a9.AutoInterval, onChange = function(_a339)
local _a340 = tonumber(_a339) if _a340 and _a340 >= 1 then _a9.AutoInterval = _a340 end
end },
{ label = "정체 판정(초)", value = _a9.PursueStallSec, onChange = function(_a341)
local _a342 = tonumber(_a341) if _a342 and _a342 >= 10 then _a9.PursueStallSec = _a342 end
end },
})
_a151(_a328, {
{ label = "운 퀘 최소 알 개수", value = _a9.HatchMinAfford, onChange = function(_a343)
local _a344 = tonumber(_a343) if _a344 and _a344 >= 1 then _a9.HatchMinAfford = math.floor(_a344) end
end },
{ label = "더 버는 시간(초)", value = _a9.MoneyDwell, onChange = function(_a345)
local _a346 = tonumber(_a345) if _a346 and _a346 >= 0 then _a9.MoneyDwell = _a346 end
end },
})
_a151(_a328, {
{ label = "부화 한 번에(초)", value = _a9.HatchBudget, onChange = function(_a347)
local _a348 = tonumber(_a347) if _a348 and _a348 >= 3 then _a9.HatchBudget = _a348 end
end },
})
_a151(_a328, {
{ label = "이동 방식", value = _a9.TpMode, onChange = function(_a349)
_a349 = tostring(_a349 or ""):lower()
if _a349 == "instant" or _a349 == "glide" or _a349 == "walk" then _a9.TpMode = _a349 end
end },
{ label = "glide 속도", value = _a9.TpSpeed, onChange = function(_a350)
local _a351 = tonumber(_a350) if _a351 and _a351 >= 16 then _a9.TpSpeed = _a351 end
end },
})
_a170(_a328, "차단 화면에 실제 클릭까지 시도",
function() return _a9.ScreenRealClick end,
function(_a352) _a9.ScreenRealClick = _a352 end)
_a170(_a328, "퀘스트 없을 때도 알 까기",
function() return _a9.IdleHatch end,
function(_a353) _a9.IdleHatch = _a353 end)
_a170(_a328, "존 해금·리버스는 퀘스트 끝나고",
function() return _a9.HoldZoneForQuest end,
function(_a354) _a9.HoldZoneForQuest = _a354 end)
for _a355, _a356 in ipairs(_a42.STEPS) do
local _a357 = _a356.key
_a170(_a328, "  " .. _a355 .. ". " .. _a356.label,
function() return _a9.StepOn[_a357] end,
function(_a358) _a9.StepOn[_a357] = _a358 end)
end
for _a359, _a360 in ipairs(_a42.SIDE) do
local _a361 = _a360.key
_a170(_a328, "  · " .. _a360.label .. " (순위 밖)",
function() return _a9.StepOn[_a361] end,
function(_a362) _a9.StepOn[_a361] = _a362 end)
end
_a160(_a328, {
{ label = "지금 상태", col = _a55.accent, fn = function()
_a6("")
_a6("──── 올 자동 ────")
_a6("  " .. (_a11.auto and "돌아가는 중" or "정지") ..
(_a42.step and ("   지금: " .. _a42.step) or ""))
local _a363, _a364 = _a42.bestDepActive()
_a6("  현재 존 " .. tostring(_a42.curZone()) .. " / 최고 존 " .. tostring(_a42.bestZone()))
if _a363 then
_a6("  ⏸ 존해금·리버스 보류 중 — " .. tostring(_a364 and _a364.title))
else
_a6("  존해금·리버스 진행 가능")
end
_a6("")
_a6("  먼저 (순위 밖):")
for _a365, _a366 in ipairs(_a42.SIDE) do
_a6(("      %-16s %s"):format(_a366.label, _a9.StepOn[_a366.key] and "ON" or "off"))
end
_a6("  우선순위:")
for _a367, _a368 in ipairs(_a42.STEPS) do
_a6(("    %d. %-16s %s%s"):format(_a367, _a368.label,
_a9.StepOn[_a368.key] and "ON" or "off",
_a368.hold and "   (퀘스트 붙잡는 중엔 보류)" or ""))
end
_a97("log")
end },
{ label = "화면 넘기기 진단", col = _a55.warn, fn = function()
task.spawn(function()
_a6("")
_a6("──── 보상 화면 ────")
local _a369 = _a41.Vars
_a6("  Library.Variables : " .. (_a369 and "로드됨" or "없음"))
if _a369 then
_a6("    IsRebirthing = " .. tostring(rawget(_a369, "IsRebirthing")))
_a6("    IsRankingUp  = " .. tostring(rawget(_a369, "IsRankingUp")))
_a6("    OpeningEgg   = " .. tostring(rawget(_a369, "OpeningEgg")))
end
_a6("  debug.info     : " .. tostring(type(debug) == "table" and type(debug.info) == "function"))
_a6("  getgc          : " .. tostring(type(getgc) == "function"))
_a6("  debug.setupvalue: " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
local _a370 = _a4:FindFirstChildOfClass("PlayerGui")
if _a370 then
_a6("  떠 있는 차단 화면:")
local _a371 = false
for _a372, _a373 in ipairs(_a42.BLOCKERS) do
local _a374 = _a370:FindFirstChild(_a373[1])
_a6(("    %-14s %s"):format(_a373[1],
_a374 and (_a374.Enabled and "★ 켜짐" or "꺼짐") or "없음"))
if _a374 and _a374.Enabled then _a371 = true end
end
if not _a371 then _a6("    (없음)") end
end
if type(getgc) == "function" and type(debug) == "table" and debug.info then
_a6("")
_a6("  Rebirth/RankUp 스크립트의 클로저 시그니처:")
local _a375, _a376 = {}, 0
for _a377, _a378 in ipairs({ true, false }) do
local _a379, _a380 = pcall(getgc, _a378)
if _a379 then
for _a381, _a382 in ipairs(_a380) do
if type(_a382) == "function" and _a376 < 25 then
local _a383, _a384 = pcall(debug.info, _a382, "s")
if _a383 and type(_a384) == "string"
and (_a384:find("Rebirth", 1, true) or _a384:find("Rank Up", 1, true)) then
local _a385, _a386 = pcall(debug.info, _a382, "a")
if _a385 then
local _a387 = {}
for _a388 = 1, 16 do
local _a389, _a390 = pcall(debug.getupvalue, _a382, _a388)
if not _a389 then break end
_a387[_a388] = type(_a390)
end
local _a391 = ("인자%d | %s"):format(_a386 or -1,
#_a387 > 0 and table.concat(_a387, ",") or "(없음)")
if not _a375[_a391] then
_a375[_a391] = true
_a376 += 1
_a6("    " .. _a391)
end
end
end
end
end
end
end
if _a376 == 0 then _a6("    (하나도 못 찾음)") end
end
for _a392, _a393 in ipairs({ "reward", "egg", "mastery", "card" }) do
_a42._sig = nil
local _a394 = _a42.findSignalFns(_a393)
_a6("")
_a6(("  [%s] 찾은 함수 %d개"):format(_a393, #_a394))
for _a395, _a396 in ipairs(_a394) do
_a6(("    %s%s"):format(_a396.exact and "★정확일치 " or "", tostring(_a396.src)))
_a6(("       upvalue %d개 : %s"):format(_a396.n or 0, tostring(_a396.sig)))
end
if #_a394 == 0 then
_a6("    (getgc 로 그 스크립트의 클로저를 못 찾음)")
end
local _a397, _a398 = _a42.signal(_a393)
_a6(("    upvalue 신호 : %s (%s개 세팅)"):format(tostring(_a397), tostring(_a398)))
local _a399 = _a42.SIGNAL[_a393]
_a6(("    게임내 입력발동 : %s"):format(
tostring(_a42.pressInGame(_a399 and _a399.pats or {}))))
end
_a6("")
_a6("  감시 루프 RUN.rewatch = " .. tostring(_a11.rewatch))
_a97("log")
end)
end },
{ label = "한 바퀴만", col = _a55.cardHi, fn = function()
task.spawn(function()
_a11.auto = true _a42.master() _a11.auto = false _a97("log")
end)
end },
{ label = "자동 점검", col = _a55.warn, fn = function()
task.spawn(function()
_a6("")
_a6("════ 올 자동 점검 ════")
_a6("  RUN.auto = " .. tostring(_a11.auto))
local _a400 = {}
for _a401, _a402 in ipairs(_a42.SIDE) do
_a400[#_a400 + 1] = _a402.key .. "=" .. tostring(_a9.StepOn[_a402.key])
end
for _a403, _a404 in ipairs(_a42.STEPS) do
_a400[#_a400 + 1] = _a404.key .. "=" .. tostring(_a9.StepOn[_a404.key])
end
_a6("  단계 ON/OFF : " .. table.concat(_a400, "  "))
_a6("  lockGoal    : " .. (_a42.lockGoal and tostring(_a42.lockGoal.q.title) or "없음"))
local _a405, _a406 = _a42.bestDepActive()
_a6("  보류중?     : " .. tostring(_a405) .. (_a406 and ("  ← " .. tostring(_a406.title)) or ""))
_a6("  리모트      : 존 " .. (_a41.R_Zone and "O" or "X")
.. " / 리버스 " .. (_a41.R_Reb and "O" or "X"))
_a6("")
_a6("  ── 존 해금 판정 ──")
local _a407 = _a46()
if not _a407 then
_a6("    zoneStatus() = nil  ← 다음 존을 못 구함")
local _a408 = _a41.Zone and rawget(_a41.Zone, "GetNextZone")
if _a408 then
local _a409, _a410, _a411 = pcall(_a41.Zone.GetNextZone)
_a6("    GetNextZone → ok=" .. tostring(_a409)
.. " / " .. tostring(_a410) .. " / " .. tostring(_a411))
end
if _a41.Zone and rawget(_a41.Zone, "HasCompletedNextZoneQuests") then
local _a412, _a413 = pcall(_a41.Zone.HasCompletedNextZoneQuests)
_a6("    존 퀘스트 완료? " .. (_a412 and tostring(_a413) or ("에러 " .. tostring(_a413))))
end
else
_a6("    다음 존 : " .. tostring(_a407.id))
_a6(("    가격 %s %s / 보유 %s → %s"):format(
_a7(_a407.price or 0, 0), tostring(_a407.currency), _a7(_a407.have, 0),
_a407.ok and "지금 살 수 있음" or "부족"))
end
_a6("")
_a6("  ── 리버스 판정 ──")
local _a414 = _a51()
if not _a414 then _a6("    세이브 못 읽음")
else
_a6(("    현재 %d → 다음 %d"):format(_a414.current, _a414.nextN))
_a6("    최근 사유 : " .. tostring(_a42.rebNote or "-"))
end
_a6("")
_a6("  ── 직전 바퀴 기록 ──")
if _a42.lastTrace and #_a42.lastTrace > 0 then
for _a415, _a416 in ipairs(_a42.lastTrace) do _a6("    " .. _a416) end
_a6(("    (%.0f초 전)"):format(os.clock() - (_a42.lastPassAt or os.clock())))
else
_a6("    아직 한 바퀴도 안 돌았음")
end
_a97("log")
end)
end },
})
local _a417, _a418 = _a130(_a327, "펫 이동속도", nil)
_a140(_a418, "petspd", function()
_a54("petspd", function() return 0.4 end, _a42.applyPetSpeed, "펫속도")
end)
_a151(_a417, {
{ label = "배수", value = _a9.PetSpeedMult, onChange = function(_a419)
local _a420 = tonumber(_a419) if _a420 and _a420 >= 1 then _a9.PetSpeedMult = _a420 end
end },
{ label = "기본 계수 (원래 0.45)", value = _a9.PetSpeedBase, onChange = function(_a421)
local _a422 = tonumber(_a421) if _a422 and _a422 > 0 then _a9.PetSpeedBase = _a422 end
end },
})
_a160(_a417, {
{ label = "지금 적용 / 확인", col = _a55.accent, fn = function()
local _a423, _a424 = _a42.applyPetSpeed()
_a6("")
_a6("──── 펫 이동속도 ────")
_a6("  PlayerPet 모듈 : " .. (_a41.PlayerPet and "로드됨" or "없음"))
_a6(("  적용된 펫 %d마리  (배수 %s / 계수 %s)"):format(
_a423, tostring(_a9.PetSpeedMult), tostring(_a9.PetSpeedBase)))
if _a424 then _a6("  " .. tostring(_a424)) end
if _a423 == 0 then _a6("  펫을 장착하고 다시 눌러보세요") end
_a97("log")
end },
})
_a54("petspd", function() return 0.4 end, _a42.applyPetSpeed, "펫속도")
_a54("rewatch", function() return 1 end, function()
_a42.watchTick = (_a42.watchTick or 0) + 1
if _a42.dismissBusy then return end
local _a425, _a426 = _a42.rewardScreenUp()
if _a425 and _a42.screenGaveUp and (os.clock() - _a42.screenGaveUp) < 30 then
return
end
if _a425 then
if _a42.lastBlocker ~= _a426 then
_a42.lastBlocker = _a426
_a6("[화면] " .. tostring(_a426) .. " 화면 감지 — 넘기는 중")
end
_a42.dismissRewardScreens(20)
end
end, "보상화면")
local _a427, _a428 = _a130(_a327, "자동 파밍 유지", nil)
_a140(_a428, "farm", function()
_a54("farm", function() return _a9.FarmInterval end, _a45, "파밍")
end)
_a151(_a427, {
{ label = "주기", value = _a9.FarmInterval, onChange = function(_a429)
local _a430 = tonumber(_a429) if _a430 and _a430 >= 3 then _a9.FarmInterval = _a430 end
end },
})
local _a431, _a432 = _a130(_a327, "자동 존 해금", nil)
_a140(_a432, "zone", function()
_a54("zone", function() return _a9.ZoneInterval end, _a47, "존")
end)
_a151(_a431, {
{ label = "주기", value = _a9.ZoneInterval, onChange = function(_a433)
local _a434 = tonumber(_a433) if _a434 and _a434 >= 3 then _a9.ZoneInterval = _a434 end
end },
})
_a160(_a431, {
{ label = "다음 존 보기", col = _a55.accent, fn = function()
local _a435 = _a46()
_a6("")
if not _a435 then _a6("[존] 다음 존 없음 (최대 도달?)")
else
_a6("──── 다음 존 ────")
_a6("  " .. tostring(_a435.id))
_a6("  가격 " .. _a7(_a435.price or 0, 0) .. " " .. tostring(_a435.currency))
_a6("  보유 " .. _a7(_a435.have, 0))
_a6("  " .. (_a435.ok and "지금 해금 가능" or "부족"))
end
_a97("log")
end },
{ label = "지금 1회", col = _a55.cardHi, fn = function()
task.spawn(function() _a11.zone = true _a47() _a11.zone = false _a97("log") end)
end },
})
local _a436, _a437 = _a130(_a327, "자동 부화", nil)
_a140(_a437, "mhatch", function()
_a54("mhatch", function() return _a9.MainHatchInterval end, _a50, "부화")
end)
_a151(_a436, {
{ label = "주기", value = _a9.MainHatchInterval, onChange = function(_a438)
local _a439 = tonumber(_a438) if _a439 and _a439 >= 1 then _a9.MainHatchInterval = _a439 end
end },
{ label = "한 번에 최대", value = _a9.MainHatchMax, onChange = function(_a440)
local _a441 = tonumber(_a440) if _a441 and _a441 >= 1 then _a9.MainHatchMax = math.floor(_a441) end
end },
})
_a151(_a436, {
{ label = "예비금", value = _a9.MainHatchReserve, onChange = function(_a442)
local _a443 = tonumber(_a442) if _a443 and _a443 >= 0 then _a9.MainHatchReserve = _a443 end
end },
{ label = "알 ID (비우면 자동)", value = _a9.MainEggId, onChange = function(_a444)
_a9.MainEggId = _a444 or ""
end },
})
_a151(_a436, {
{ label = "알 인식 거리", value = _a9.EggRange, onChange = function(_a445)
local _a446 = tonumber(_a445) if _a446 and _a446 >= 5 then _a9.EggRange = _a446 end
end },
})
_a170(_a436, "새 맵 열리면 잠긴 알 자동 해금",
function() return _a9.AutoUnlockEgg end,
function(_a447) _a9.AutoUnlockEgg = _a447 end)
_a170(_a436, "게임 내장 오토해치 사용 (기본 끔)",
function() return _a9.UseAutoHatch end,
function(_a448) _a9.UseAutoHatch = _a448 if not _a448 then _a42.autoHatchOff() end end)
_a170(_a436, "까는 화면 자동으로 넘기기 (신호)",
function() return _a9.HatchClick end,
function(_a449) _a9.HatchClick = _a449 end)
_a160(_a436, {
{ label = "잠긴 알 보기", col = _a55.accent, fn = function()
local _a450, _a451, _a452 = _a42.lockedEggs()
_a6("")
_a6("──── 알 해금 현황 ────")
_a6(("  해금 가능 최대 : #%d   /   현재 해금한 최대 : #%d"):format(_a451, _a452))
_a6("  해금 리모트 : " .. (_a41.R_EggUn and "있음" or "없음"))
if #_a450 == 0 then
_a6("  풀 수 있는 알이 없음 (다 풀었거나 존을 더 사야 함)")
else
_a6("  아직 안 푼 알 " .. #_a450 .. "개:")
for _a453, _a454 in ipairs(_a450) do
_a6(("    #%-3d %s"):format(_a454.num, _a454.id))
if _a453 >= 20 then _a6("    ...") break end
end
end
_a97("log")
end },
{ label = "부화 진단", col = _a55.warn, fn = function()
task.spawn(function()
_a6("")
_a6("──── 부화 진단 ────")
local _a455, _a456, _a457, _a458 = _a48()
_a6("  대상 알   : " .. tostring(_a455))
if not _a455 then _a6("  (오픈한 알이 없음)") _a97("log") return end
local _a459 = _a456 and tonumber(rawget(_a456, "eggNumber"))
_a6("  알 번호   : " .. tostring(_a459) .. "   오픈함? " .. tostring(_a42.eggUnlocked(_a459)))
_a6("  거리      : " .. (_a457 and ("%.0f (사거리 안)"):format(_a457)
or ((_a458 and ("%.0f (사거리 %d 밖)"):format(_a458, _a9.EggRange)) or "받침대 못 찾음")))
local _a460 = _a456 and rawget(_a456, "currency") or "?"
_a6("  통화      : " .. tostring(_a460) .. "   보유 " .. _a7(_a44(_a460), 0))
if type(_a41.CalcEgg) == "function" then
local _a461, _a462 = pcall(_a41.CalcEgg, _a456)
_a6("  CalcEggPricePlayer : " .. (_a461 and tostring(_a462) or ("에러 " .. tostring(_a462))))
end
if type(_a41.CalcEggB) == "function" then
local _a463, _a464 = pcall(_a41.CalcEggB, _a456)
_a6("  CalcEggPrice       : " .. (_a463 and tostring(_a464) or ("에러 " .. tostring(_a464))))
end
if _a41.Egg then
for _a465, _a466 in ipairs({ "GetMaxHatch", "ComputeDebounce", "GetHighestEggNumberAvailable" }) do
if rawget(_a41.Egg, _a466) then
local _a467, _a468 = pcall(_a41.Egg[_a466], _a456)
_a6(("  %-28s : %s"):format(_a466, _a467 and tostring(_a468) or ("에러 " .. tostring(_a468))))
end
end
end
_a6("  OpeningEgg      : " .. tostring(_a41.Vars and rawget(_a41.Vars, "OpeningEgg")))
if _a41.Hatch then
for _a469, _a470 in ipairs({ "IsHatching", "GetEggAmount" }) do
if rawget(_a41.Hatch, _a470) then
local _a471, _a472 = pcall(_a41.Hatch[_a470])
_a6(("  %-15s : %s"):format(_a470, _a471 and tostring(_a472) or ("에러 " .. tostring(_a472))))
end
end
if rawget(_a41.Hatch, "GetEggDirectory") then
local _a473, _a474 = pcall(_a41.Hatch.GetEggDirectory)
_a6("  세팅된 알       : " .. (_a473 and _a474 and tostring(rawget(_a474, "_id")) or "없음"))
end
end
_a6("  ▶ SetupEgg 시도")
_a42._ahEgg = nil
_a42.autoHatchOn(_a455, 1)
if _a41.Hatch and rawget(_a41.Hatch, "IsHatching") then
local _a475, _a476 = pcall(_a41.Hatch.IsHatching)
_a6("    IsHatching 이후 : " .. (_a475 and tostring(_a476) or ("에러 " .. tostring(_a476))))
_a6("    " .. ((_a475 and _a476) and "→ 클릭 없이 넘어갑니다"
or "→ SetupEgg 안 먹음. 클릭 대체가 필요합니다"))
end
_a6("  신호 가능 : getgc " .. tostring(type(getgc) == "function")
.. " / debug.setupvalue " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
_a6("")
_a6("  ▶ 1개로 실제 호출")
local _a477, _a478
local _a479 = pcall(function() _a477, _a478 = _a8.R_EGG:InvokeServer(_a455, 1) end)
_a6("    호출성공 : " .. tostring(_a479))
_a6("    반환1    : " .. tostring(_a477))
_a6("    반환2    : " .. tostring(_a478))
_a97("log")
end)
end },
{ label = "지금 전부 해금", col = _a55.good, fn = function()
task.spawn(function()
_a6("")
local _a480, _a481 = _a42.unlockEggs(true)
_a6(_a480 > 0 and ("[해금] %d개 완료"):format(_a480)
or ("[해금] 0개" .. (_a481 and (" — " .. tostring(_a481)) or "")))
_a97("log")
end)
end },
})
_a160(_a436, {
{ label = "알 현황 보기", col = _a55.accent, fn = function()
local _a482 = _a49()
_a6("")
if not _a482 then _a6("[부화] 알을 못 찾음")
else
_a6("──── 메인 알 ────")
_a6("  " .. tostring(_a482.id))
_a6("  가격 " .. (_a482.price and _a7(_a482.price, 0) or "?") .. " " .. tostring(_a482.currency))
_a6("  보유 " .. _a7(_a482.have, 0))
_a6("  한 번에 " .. _a482.maxN .. "개까지")
_a6("  지금 가능 " .. _a482.canBuy .. "회")
if _a482.inRange then
_a6(("  거리 %.0f 스터드 — 부화 가능"):format(_a482.dist))
else
_a6(("  사거리(%d) 안에 알 없음. 가장 가까운 알 %s스터드"):format(
_a9.EggRange, _a482.nearest and ("%.0f"):format(_a482.nearest) or "?"))
_a6("  → 알 앞으로 걸어가야 부화됩니다")
end
end
_a6("")
_a6("──── 주변 알 (가까운 순 10개) ────")
local _a483 = _a42.eggStands()
for _a484 = 1, math.min(10, #_a483) do
local _a485 = _a483[_a484]
_a6(("  %6.0f  #%-3d %-24s %s"):format(
_a485.dist, _a485.num, _a485.id, _a42.eggUnlocked(_a485.num) and "오픈함" or "잠김"))
end
if #_a483 == 0 then _a6("  (못 찾음)") end
_a97("log")
end },
{ label = "지금 1회", col = _a55.cardHi, fn = function()
task.spawn(function() _a11.mhatch = true _a50() _a11.mhatch = false _a97("log") end)
end },
})
local _a486, _a487 = _a130(_a327, "랭크 퀘스트 자동", nil)
_a140(_a487, "quest", function()
_a54("quest", function() return _a9.QuestInterval end, _a42.cycle, "퀘스트")
end)
_a151(_a486, {
{ label = "주기", value = _a9.QuestInterval, onChange = function(_a488)
local _a489 = tonumber(_a488) if _a489 and _a489 >= 5 then _a9.QuestInterval = _a489 end
end },
{ label = "포션 한 번에", value = _a9.QuestUseMax, onChange = function(_a490)
local _a491 = tonumber(_a490) if _a491 and _a491 >= 1 then _a9.QuestUseMax = math.floor(_a491) end
end },
})
_a170(_a486, "필요한 자동화 자동 ON",
function() return _a9.QuestDrive end,
function(_a492) _a9.QuestDrive = _a492 end)
_a170(_a486, "포션/인챈트 업글 퀘스트",
function() return _a9.QuestUpgrade end,
function(_a493) _a9.QuestUpgrade = _a493 end)
_a170(_a486, "포션 사용 퀘스트",
function() return _a9.QuestUsePotion end,
function(_a494) _a9.QuestUsePotion = _a494 end)
_a160(_a486, {
{ label = "퀘스트 현황 보기", col = _a55.accent, fn = function()
local _a495 = _a42.status()
_a6("")
if not _a495 then _a6("[퀘스트] 세이브 못 읽음")
else
_a6("──── 랭크 퀘스트 ────")
_a6(("  Rank %d   ★%d"):format(_a495.rank, _a495.rankStars))
if #_a495.list == 0 then _a6("  퀘스트 없음") end
for _a496, _a497 in ipairs(_a495.list) do
local _a498 = _a497.how
local _a499 =
(_a498 == "farm" and "자동 파밍") or
(_a498 == "hatch" and "자동 부화") or
(_a498 == "zone" and "자동 존") or
(_a498 == "potup" and "포션 업글") or
(_a498 == "encup" and "인챈트 업글") or
(_a498 == "potuse" and "포션 사용") or
(_a498 == "fruituse" and "과일 사용") or
(_a498 == "flaguse" and "깃발 사용") or
(_a498 == "gold" and "골드 머신") or
(_a498 == "rainbow" and "레인보우 머신") or
"수동"
local _a500 = ""
if _a497.ignored then
_a499 = "무시"
_a500 = "   → " .. _a497.ignored
elseif _a497.event then
local _a501 = _a42.findEvent(_a497.event, _a497.bestOnly)
_a500 = _a501 and ("   → %s @%s %d초"):format(_a501.name, tostring(_a501.zone), _a501.left)
or ("   → " .. _a497.event .. " 대기중")
elseif _a497.chest then
_a500 = "   → " .. _a497.chest
elseif _a497.where then
_a500 = "   → " .. _a497.where
end
_a6(("  [%d] %s"):format(_a497.stars, tostring(_a497.title)))
_a6(("       %d / %d    처리: %s   (Type %d)%s"):format(
_a497.progress, _a497.amount, _a499, _a497.type, _a500))
end
end
_a97("log")
end },
{ label = "활성 이벤트 보기", col = _a55.accent, fn = function()
local _a502 = _a42.events()
local _a503 = _a42.bestZone()
_a6("")
_a6("──── 지금 떠 있는 랜덤 이벤트 ────")
_a6("  최고 존 : " .. tostring(_a503) .. "   현재 존 : " .. tostring(_a42.curZone()))
if #_a502 == 0 then _a6("  없음 (RandomEvents_Get 응답 비어있음)") end
for _a504, _a505 in ipairs(_a502) do
_a6(("  %-12s @%-20s %4d초 남음  %s%s"):format(
_a505.kind, tostring(_a505.zone), _a505.left,
_a505.pos and ("(%.0f, %.0f, %.0f)"):format(_a505.pos.X, _a505.pos.Y, _a505.pos.Z) or "좌표없음",
_a505.zone == _a503 and "  ★최고존" or ""))
end
_a6("")
_a6("  내 소환 아이템 :")
for _a506 in pairs(_a42.SPAWN) do
local _a507 = _a42.spawnItems(_a506)
local _a508 = 0
for _a509, _a510 in ipairs(_a507) do _a508 += _a510.am end
_a6(("    %-12s %d종 %d개"):format(_a506, #_a507, _a508))
for _a511, _a512 in ipairs(_a507) do
_a6(("        %d. %-24s x%d%s"):format(
_a511, _a512.id, _a512.am, _a511 == 1 and "   ← 먼저 씀" or ""))
if _a511 >= 6 then break end
end
end
_a6("  점선 네모 안? " .. tostring(_a42.inDottedBox()))
for _a513, _a514 in ipairs({ "MiniChests", "SuperiorMiniChests" }) do
local _a515, _a516 = _a42.findChest(_a514)
_a6(("  %-20s %s"):format(_a514,
_a515 and ("가장 가까운 것 %.0f스터드"):format(_a516 or 0) or "없음"))
end
_a97("log")
end },
{ label = "포션 재고 보기", col = _a55.accent, fn = function()
_a6("")
_a6("──── 포션 / 인챈트 재고 ────")
for _a517, _a518 in ipairs({ "Potion", "Enchant" }) do
local _a519 = _a42.stacks(_a518)
table.sort(_a519, function(_a520, _a521)
if _a520.id ~= _a521.id then return _a520.id < _a521.id end
return _a520.tier < _a521.tier
end)
_a6("")
_a6(_a518 .. "  (" .. #_a519 .. "종)")
for _a522, _a523 in ipairs(_a519) do
local _a524 = _a42.perTier(_a518, _a523.tier)
local _a525 = _a524 and math.floor(_a523.am / _a524) or 0
_a6(("   %-20s T%-2d x%-6d %s"):format(
_a523.id, _a523.tier, _a523.am,
_a525 > 0 and ("→ T" .. (_a523.tier + 1) .. " " .. _a525 .. "개 제작가능") or ""))
if _a522 >= 40 then _a6("   ...") break end
end
if #_a519 == 0 then _a6("   (없음)") end
end
_a97("log")
end },
{ label = "지금 1회", col = _a55.cardHi, fn = function()
task.spawn(function() _a11.quest = true _a42.cycle() _a11.quest = false _a97("log") end)
end },
})
local _a526, _a527 = _a130(_a327, "슬롯 머신 자동 (다이아)", nil)
_a140(_a527, "slots", function()
_a54("slots", function() return _a9.SlotInterval end, _a42.cycleSlots, "슬롯")
end)
_a151(_a526, {
{ label = "주기", value = _a9.SlotInterval, onChange = function(_a528)
local _a529 = tonumber(_a528) if _a529 and _a529 >= 5 then _a9.SlotInterval = _a529 end
end },
{ label = "남길 다이아", value = _a9.SlotReserve, onChange = function(_a530)
local _a531 = tonumber(_a530) if _a531 and _a531 >= 0 then _a9.SlotReserve = _a531 end
end },
})
_a170(_a526, "펫 장착 슬롯 (Pet Equip)",
function() return _a9.SlotPet end, function(_a532) _a9.SlotPet = _a532 end)
_a170(_a526, "알 부화 슬롯 (Egg Machine)",
function() return _a9.SlotEgg end, function(_a533) _a9.SlotEgg = _a533 end)
_a160(_a526, {
{ label = "슬롯 현황 보기", col = _a55.accent, fn = function()
local _a534 = _a42.slotStatus()
_a6("")
_a6("──── 슬롯 머신 ────")
if not _a534 then _a6("  세이브 못 읽음") _a97("log") return end
_a6("  다이아 " .. _a7(_a534.dia, 0))
_a6("")
_a6(("  펫 장착 : 구매 %d / 랭크상한 %d   현재 최대장착 %s"):format(
_a534.petOwned, _a534.petMax, tostring(_a534.maxEquip)))
if _a534.petNext then
_a6(("     다음 #%d  %s 다이아  %s"):format(
_a534.petNext, _a534.petCost and _a7(_a534.petCost, 0) or "?",
(_a534.petCost and _a534.petCost <= _a534.dia - _a9.SlotReserve) and "← 지금 가능" or "부족"))
else
_a6("     랭크 상한까지 다 삼 (랭크를 올려야 더 살 수 있음)")
end
_a6("")
_a6(("  알 부화 : 구매 %d / 랭크상한 %d   한 번에 %s개"):format(
_a534.eggOwned, _a534.eggMax, tostring(_a534.maxHatch)))
if _a534.eggEnd then
_a6(("     다음 %d칸 묶음 → %d   %s 다이아  %s"):format(
_a534.eggSize, _a534.eggEnd, _a534.eggCost and _a7(_a534.eggCost, 0) or "?",
(_a534.eggCost and _a534.eggCost <= _a534.dia - _a9.SlotReserve) and "← 지금 가능" or "부족"))
else
_a6("     랭크 상한까지 다 삼")
end
_a6("")
_a6("  리모트 : 펫 " .. (_a41.R_PetSlot and "O" or "X")
.. " / 알 " .. (_a41.R_EggSlot and "O" or "X"))
_a97("log")
end },
{ label = "지금 1회", col = _a55.cardHi, fn = function()
task.spawn(function() _a11.slots = true _a42.cycleSlots() _a11.slots = false _a97("log") end)
end },
})
local _a535, _a536 = _a130(_a327, "아이템 자동 사용 (버프 유지)", nil)
_a140(_a536, "items", function()
_a54("items", function() return _a9.ItemInterval end, _a42.cycleItems, "아이템")
end)
_a151(_a535, {
{ label = "주기", value = _a9.ItemInterval, onChange = function(_a537)
local _a538 = tonumber(_a537) if _a538 and _a538 >= 5 then _a9.ItemInterval = _a538 end
end },
{ label = "포션 한 바퀴 최대", value = _a9.BuffMaxPotion, onChange = function(_a539)
local _a540 = tonumber(_a539) if _a540 and _a540 >= 1 then _a9.BuffMaxPotion = math.floor(_a540) end
end },
})
_a151(_a535, {
{ label = "남길 개수", value = _a9.ItemKeep, onChange = function(_a541)
local _a542 = tonumber(_a541) if _a542 and _a542 >= 0 then _a9.ItemKeep = math.floor(_a542) end
end },
{ label = "과일/소모품 최대", value = _a9.BuffMaxOther, onChange = function(_a543)
local _a544 = tonumber(_a543) if _a544 and _a544 >= 1 then _a9.BuffMaxOther = math.floor(_a544) end
end },
})
_a151(_a535, {
{ label = "쓸 것 (비우면 전부)", value = _a9.ItemAllow, onChange = function(_a545)
_a9.ItemAllow = _a545 or ""
end },
{ label = "제외", value = _a9.ItemBlock, onChange = function(_a546)
_a9.ItemBlock = _a546 or ""
end },
})
_a170(_a535, "포션", function() return _a9.BuffPotion end,
function(_a547) _a9.BuffPotion = _a547 end)
_a170(_a535, "과일", function() return _a9.BuffFruit end,
function(_a548) _a9.BuffFruit = _a548 end)
_a170(_a535, "얼티밋 (충전되면 발동, 무료)", function() return _a9.BuffUltimate end,
function(_a549) _a9.BuffUltimate = _a549 end)
_a170(_a535, "소모품 (Rain/Sunlight 주의)", function() return _a9.BuffConsumable end,
function(_a550) _a9.BuffConsumable = _a550 end)
_a170(_a535, "높은 티어부터 사용 (끄면 낮은 것부터)", function() return _a9.BuffHighTier end,
function(_a551) _a9.BuffHighTier = _a551 end)
_a170(_a535, "최고 존에서만 사용", function() return _a9.ItemBestZone end,
function(_a552) _a9.ItemBestZone = _a552 end)
_a170(_a535, "최고 존이 아니면 이동 후 사용", function() return _a9.ItemTp end,
function(_a553) _a9.ItemTp = _a553 end)
_a160(_a535, {
{ label = "버프 현황 보기", col = _a55.accent, fn = function()
_a6("")
_a6("──── 버프 / 아이템 ────")
_a6(("  현재 존 %s / 최고 존 %s%s"):format(
tostring(_a42.curZone()), tostring(_a42.bestZone()),
_a9.ItemBestZone and (_a42.curZone() == _a42.bestZone() and "   ← 사용 가능" or "   ← 이동 필요") or ""))
for _a554, _a555 in pairs({ Potions = "Potion", Fruits = "Fruit" }) do
local _a556 = _a42.activeBuffs(_a554)
local _a557 = {}
for _a558 in pairs(_a556) do _a557[#_a557 + 1] = _a558 end
table.sort(_a557)
_a6(("  지금 걸린 %s : %s"):format(_a554,
#_a557 > 0 and table.concat(_a557, ", ") or "없음"))
end
local _a559 = _a43()
local _a560 = _a559 and rawget(_a559, "Ultimates")
if type(_a560) == "table" then
local _a561 = {}
for _a562 in pairs(_a560) do
local _a563 = "?"
if _a41.Ult and rawget(_a41.Ult, "IsCharged") then
local _a564, _a565 = pcall(_a41.Ult.IsCharged, _a562)
_a563 = _a564 and (_a565 and "충전됨" or "충전중") or "?"
end
_a561[#_a561 + 1] = _a562 .. "(" .. _a563 .. ")"
end
_a6("  얼티밋 : " .. (#_a561 > 0 and table.concat(_a561, ", ") or "없음"))
end
_a6("")
for _a566, _a567 in ipairs({ "Potion", "Fruit", "Consumable" }) do
local _a568 = _a42.stacks(_a567)
local _a569, _a570 = 0, 0
for _a571, _a572 in ipairs(_a568) do
if _a42.itemAllowed(_a572.id) then _a569 += 1 else _a570 += 1 end
end
_a6(("  %-12s %d종 (쓸 수 있음 %d / 제외 %d)"):format(_a567, #_a568, _a569, _a570))
for _a573, _a574 in ipairs(_a568) do
_a6(("      %-20s T%-2d x%-6d %s"):format(
_a574.id, _a574.tier, _a574.am, _a42.itemAllowed(_a574.id) and "" or "제외됨"))
if _a573 >= 12 then _a6("      ...") break end
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
task.spawn(function() _a11.items = true _a42.cycleItems() _a11.items = false _a97("log") end)
end },
})
local _a575, _a576 = _a130(_a327, "맵 업그레이드 자동 (다이아)", nil)
_a140(_a576, "mapupg", function()
_a54("mapupg", function() return _a9.UpgInterval end, _a42.cycleUpg, "맵업글")
end)
_a151(_a575, {
{ label = "주기", value = _a9.UpgInterval, onChange = function(_a577)
local _a578 = tonumber(_a577) if _a578 and _a578 >= 5 then _a9.UpgInterval = _a578 end
end },
{ label = "남길 다이아", value = _a9.UpgReserve, onChange = function(_a579)
local _a580 = tonumber(_a579) if _a580 and _a580 >= 0 then _a9.UpgReserve = _a580 end
end },
})
_a170(_a575, "구매 전 그 앞으로 이동",
function() return _a9.UpgTp end,
function(_a581) _a9.UpgTp = _a581 end)
_a160(_a575, {
{ label = "업그레이드 목록", col = _a55.accent, fn = function()
local _a582 = _a42.upgList()
local _a583 = _a44("Diamonds")
_a6("")
_a6("──── 맵 업그레이드 ────")
_a6("보유 다이아 " .. _a7(_a583, 0))
if #_a582 == 0 then
_a6("  로드된 업그레이드 기둥이 없음 (해당 존에 가야 보입니다)")
end
local _a584, _a585, _a586 = 0, 0, 0
for _a587, _a588 in ipairs(_a582) do
if _a588.bought then _a585 += 1
elseif not _a588.zoneOwned then _a586 += 1
else _a584 += 1 end
end
_a6(("  구매가능 %d / 구매완료 %d / 존 미보유 %d"):format(_a584, _a585, _a586))
_a6("")
local _a589 = 0
for _a590, _a591 in ipairs(_a582) do
if _a591.buyable then
_a589 += 1
_a6(("  %-12s T%-2d %-20s %12s %-9s %s"):format(
_a591.id, _a591.tier, _a591.zone, _a591.cost and _a7(_a591.cost, 0) or "?",
tostring(_a591.cur),
(_a591.cost and _a591.cost <= _a44(_a591.cur or "Diamonds") - _a9.UpgReserve)
and "← 지금 가능" or ""))
if _a589 >= 25 then _a6("  ...") break end
end
end
_a97("log")
end },
{ label = "업글 진단", col = _a55.warn, fn = function()
task.spawn(function()
_a6("")
_a6("──── 맵 업그레이드 진단 ────")
_a6("  리모트 : " .. (_a41.R_Upg and _a41.R_Upg:GetFullName() or "없음"))
local _a592 = _a42.upgList()
_a6("  로드된 기둥 " .. #_a592 .. "개")
local _a593
for _a594, _a595 in ipairs(_a592) do
if _a595.buyable and _a595.cost then _a593 = _a595 break end
end
if not _a593 then
_a6("  살 수 있는 게 없음 (전부 구매완료거나 존 미보유)")
for _a596, _a597 in ipairs(_a592) do
_a6(("   %-12s T%-2d @%-18s 구매됨=%s 존보유=%s"):format(
_a597.id, _a597.tier, tostring(_a597.zone), tostring(_a597.bought), tostring(_a597.zoneOwned)))
if _a596 >= 8 then _a6("   ...") break end
end
_a97("log") return
end
local _a598 = _a44(_a593.cur or "Diamonds")
local _a599 = _a42.hrp()
local _a600 = (_a599 and _a593.pos) and (_a599.Position - _a593.pos).Magnitude or nil
_a6(("  대상 : %s T%d @%s"):format(_a593.id, _a593.tier, tostring(_a593.zone)))
_a6(("  가격 : %s %s / 보유 %s"):format(
_a7(_a593.cost, 0), tostring(_a593.cur), _a7(_a598, 0)))
_a6("  거리 : " .. (_a600 and ("%.0f 스터드"):format(_a600) or "좌표 없음"))
_a6("")
_a6("  ▶ 제자리에서 호출")
local _a601, _a602
local _a603 = pcall(function() _a601, _a602 = _a41.R_Upg:InvokeServer(_a593.id, _a593.zone) end)
_a6("    호출성공 " .. tostring(_a603) .. " / 반환1 " .. tostring(_a601)
.. " / 반환2 " .. tostring(_a602))
if not _a601 and _a593.pos then
_a6("")
_a6("  ▶ 기둥 앞으로 이동해서 재시도")
_a42.glideTo(_a593.pos)
task.wait(0.3)
local _a604 = _a42.hrp()
_a6("    이동후 거리 " .. (_a604 and ("%.0f"):format((_a604.Position - _a593.pos).Magnitude) or "?"))
local _a605, _a606
local _a607 = pcall(function() _a605, _a606 = _a41.R_Upg:InvokeServer(_a593.id, _a593.zone) end)
_a6("    호출성공 " .. tostring(_a607) .. " / 반환1 " .. tostring(_a605)
.. " / 반환2 " .. tostring(_a606))
_a6("")
_a6(_a605 and "  → 거리 검사 있음. 이동해야 됩니다."
or "  → 이동해도 실패. 거리 문제가 아닙니다.")
else
_a6("")
_a6(_a601 and "  → 원격으로 됩니다. 이동 불필요." or "  → 실패 (좌표 없음)")
end
_a97("log")
end)
end },
{ label = "지금 1회", col = _a55.cardHi, fn = function()
task.spawn(function() _a11.mapupg = true _a42.cycleUpg() _a11.mapupg = false _a97("log") end)
end },
})
local _a608, _a609 = _a130(_a327, "자동 리버스", nil)
_a140(_a609, "mreb", function()
_a54("mreb", function() return _a9.MainRebirthInterval end, _a52, "리버스")
end)
_a151(_a608, {
{ label = "주기", value = _a9.MainRebirthInterval, onChange = function(_a610)
local _a611 = tonumber(_a610) if _a611 and _a611 >= 10 then _a9.MainRebirthInterval = _a611 end
end },
})
_a170(_a608, "실패 이유 로그",
function() return _a9.MainRebirthVerbose end,
function(_a612) _a9.MainRebirthVerbose = _a612 end)
_a160(_a608, {
{ label = "리버스 현황 보기", col = _a55.accent, fn = function()
local _a613 = _a51()
_a6("")
if not _a613 then _a6("[리버스] 세이브 못 읽음")
else
_a6("──── 메인 리버스 ────")
_a6("  현재 " .. _a613.current .. "회 → 다음 " .. _a613.nextN)
if type(_a613.def) == "table" then
for _a614, _a615 in pairs(_a613.def) do
if type(_a615) ~= "table" and type(_a615) ~= "function" then
_a6("    " .. tostring(_a614) .. " = " .. tostring(_a615))
end
end
end
end
_a97("log")
end },
{ label = "지금 1회", col = _a55.bad, fn = function()
task.spawn(function() _a11.mreb = true _a52() _a11.mreb = false _a97("log") end)
end },
})
local _a616 = _a130(_a327, "전체 제어", nil)
_a160(_a616, {
{ label = "메인 전부 ON", col = _a55.good, fn = function()
local _a617 = {
{ "farm",   function() return _a9.FarmInterval end,       _a45,       "파밍" },
{ "zone",   function() return _a9.ZoneInterval end,       _a47,       "존" },
{ "mhatch", function() return _a9.MainHatchInterval end,  _a50,  "부화" },
{ "quest",  function() return _a9.QuestInterval end,      _a42.cycle,        "퀘스트" },
{ "mapupg", function() return _a9.UpgInterval end,        _a42.cycleUpg,     "맵업글" },
{ "items",  function() return _a9.ItemInterval end,       _a42.cycleItems,   "아이템" },
{ "slots",  function() return _a9.SlotInterval end,       _a42.cycleSlots,   "슬롯" },
}
for _a618, _a619 in ipairs(_a617) do
if not _a11[_a619[1]] then
_a11[_a619[1]] = true
_a54(_a619[1], _a619[2], _a619[3], _a619[4])
end
end
_a137()
_a6("[메인] 파밍/존/부화/랭크/퀘스트/맵업글 ON  (리버스는 따로)")
end },
{ label = "메인 전부 OFF", col = _a55.bad, fn = function()
_a42.stopAll()
_a137()
_a6("[메인] 정지")
end },
})
end
_a88.MouseButton1Click:Connect(function()
local _a620 = table.concat(_a5, "\n")
if #_a620 > 900000 then _a620 = _a620:sub(#_a620 - 900000) end
if type(setclipboard) == "function" then
pcall(setclipboard, _a620)
_a88.Text = "완료"
task.delay(1.5, function() if _a88 then _a88.Text = "복사" end end)
end
end)
_a87.MouseButton1Click:Connect(function()
table.clear(_a5)
_a1.dirty = true
end)
local function _a621()
_a11.place, _a11.merchant, _a11.upgrade = false, false, false
_a11.towerup, _a11.crop, _a11.expand, _a11.rebirth, _a11.hatch, _a11.luck = false, false, false, false, false, false
_a11.farm, _a11.zone, _a11.mhatch, _a11.rank, _a11.mreb = false, false, false, false, false
if _a191 then _a191:Disconnect() end
if _a73 then _a73:Destroy() end
_G.__PS99_GARDEN = nil
end
_a85.MouseButton1Click:Connect(_a621)
_G.__PS99_GARDEN = _a621
_a97("dash")
_a6("Garden Defenders AutoPlay")
local _a622, _a623, _a624, _a625 = _a14()
if _a622 and _a624 then
local _a626 = _a15(_a624, _a625)
_a12.slots = #_a626
_a6("레인 " .. _a625 .. " / 슬롯 " .. #_a626)
else
_a6("Garden 이벤트 안에서 실행해 주세요")
end
_a12.sun = _a20()
_a6("Sunflowers " .. _a7(_a12.sun, 0))
end
