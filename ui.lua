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
if not _a12[_a197] then
_a12[_a197] = true
if _a197 == "place"    then _a54(_a197, function() return _a10.PlaceInterval end, _a19, "배치") end
if _a197 == "merchant" then _a54(_a197, function() return _a10.MerchantInterval end, _a20, "구매") end
if _a197 == "crop"     then _a54(_a197, function() return _a10.CropInterval end, _a29, "씨앗") end
if _a197 == "expand"   then _a54(_a197, function() return _a10.ExpandInterval end, _a32, "확장") end
if _a197 == "hatch"    then _a54(_a197, function() return _a10.HatchInterval end, _a36, "뽑기") end
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
local _a198 = _a130(_a193, "현황", nil)
_a160(_a198, {
{ label = "밭 / 타워", col = _a55.accent, fn = function()
local _a199, _a200, _a201, _a202 = _a15()
_a6("")
_a6("──── 현재 상태 ────")
_a6("레인 " .. tostring(_a202) .. " / plot " .. (_a201 and "O" or "X")
.. " / world " .. (_a199 and "O" or "X"))
local _a203 = _a16(_a201, _a202)
local _a204 = _a17(_a199)
_a6("슬롯 " .. #_a203 .. " / 배치 " .. #_a204)
local _a205, _a206 = 0, {}
for _a207, _a208 in ipairs(_a204) do
_a205 += (_a208.dps or 0)
_a206[tostring(_a208.kind)] = (_a206[tostring(_a208.kind)] or 0) + 1
end
_a6("총 DPS " .. _a7(_a205))
for _a209, _a210 in pairs(_a206) do _a6("  " .. _a209 .. " × " .. _a210) end
local _a211 = _a18()
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
_a54("place", function() return _a10.PlaceInterval end, _a19, "배치")
end)
_a151(_a214, {
{ label = "주기", value = _a10.PlaceInterval, onChange = function(_a216)
local _a217 = tonumber(_a216) if _a217 and _a217 >= 3 then _a10.PlaceInterval = _a217 end
end },
{ label = "교체 배수", value = _a10.SwapMargin, onChange = function(_a218)
local _a219 = tonumber(_a218) if _a219 and _a219 >= 1 then _a10.SwapMargin = _a219 _a6("[설정] 교체 배수 " .. _a219) end
end },
{ label = "DoT 반영", value = _a10.DotFactor, onChange = function(_a220)
local _a221 = tonumber(_a220) if _a221 and _a221 >= 0 and _a221 <= 1 then _a10.DotFactor = _a221 end
end },
})
_a170(_a214, "업글 타워 보호",
function() return _a10.ProtectUpgraded end,
function(_a222) _a10.ProtectUpgraded = _a222
_a6("[설정] 업글 보호 " .. (_a222 and "ON — 업글된 건 안 건드림" or "OFF — 약하면 교체")) end)
_a160(_a214, {
{ label = "지금 1회 실행", col = _a55.accent, fn = function()
task.spawn(function() _a12.place = true _a19() _a12.place = false _a97("log") end)
end },
})
end
do
local _a223, _a224 = _a130(_a194, "머천트 자동 구매", nil)
_a140(_a224, "merchant", function()
_a54("merchant", function() return _a10.MerchantInterval end, _a20, "구매")
end)
_a151(_a223, {
{ label = "머천트 ID", value = _a10.MerchantId, onChange = function(_a225)
if _a225 ~= "" then _a10.MerchantId = _a225 _a6("[설정] 머천트 " .. _a225) end
end },
{ label = "주기", value = _a10.MerchantInterval, onChange = function(_a226)
local _a227 = tonumber(_a226) if _a227 and _a227 >= 5 then _a10.MerchantInterval = _a227 end
end },
})
_a160(_a223, {
{ label = "지금 1회 구매", col = _a55.accent, fn = function()
task.spawn(function() _a12.merchant = true _a20() _a12.merchant = false _a97("log") end)
end },
})
end
do
local _a228, _a229 = _a130(_a194, "업그레이드 머신", nil)
_a140(_a229, "upgrade", function()
_a54("upgrade", function() return _a10.UpgradeInterval end, _a24, "머신업글")
end)
_a151(_a228, {
{ label = "주기", value = _a10.UpgradeInterval, onChange = function(_a230)
local _a231 = tonumber(_a230) if _a231 and _a231 >= 5 then _a10.UpgradeInterval = _a231 end
end },
{ label = "최소 잔액", value = _a10.MinSunflowers, onChange = function(_a232)
local _a233 = tonumber(_a232) if _a233 and _a233 >= 0 then _a10.MinSunflowers = _a233
_a6("[설정] 최소 잔액 " .. _a7(_a233, 0)) end
end },
})
_a170(_a228, "가격 미상 구매",
function() return _a10.BuyUnknownCost end,
function(_a234) _a10.BuyUnknownCost = _a234 end)
_a160(_a228, {
{ label = "업글 현황 보기", col = _a55.accent, fn = function()
local _a235 = _a21()
local _a236 = _a22()
_a13.sun = _a235
_a6("")
_a6("──── 업그레이드 머신 ────")
_a6("Sunflowers = " .. _a7(_a235, 0))
local _a237 = {}
for _a238, _a239 in ipairs(_a14) do
local _a240 = _a236[_a239] or 0
_a237[#_a237 + 1] = { id = _a239, tier = _a240, cost = _a23(_a239, _a240) }
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
task.spawn(function() _a12.upgrade = true _a24() _a12.upgrade = false _a97("log") end)
end },
})
local _a245, _a246 = _a130(_a194, "타워 개별 업글", nil)
_a140(_a246, "towerup", function()
_a54("towerup", function() return _a10.UpgradeInterval end, _a53, "타워업글")
end)
end
do
local _a247, _a248 = _a130(_a194, "자동 뽑기", nil)
_a140(_a248, "hatch", function()
_a54("hatch", function() return _a10.HatchInterval end, _a36, "뽑기")
end)
_a151(_a247, {
{ label = "주기", value = _a10.HatchInterval, onChange = function(_a249)
local _a250 = tonumber(_a249) if _a250 and _a250 >= 1 then _a10.HatchInterval = _a250 end
end },
{ label = "한 번에 최대", value = _a10.HatchMax, onChange = function(_a251)
local _a252 = tonumber(_a251) if _a252 and _a252 >= 1 then _a10.HatchMax = math.floor(_a252) end
end },
})
_a151(_a247, {
{ label = "예비금", value = _a10.HatchReserve, onChange = function(_a253)
local _a254 = tonumber(_a253) if _a254 and _a254 >= 0 then _a10.HatchReserve = _a254
_a6("[설정] 뽑기 예비금 " .. _a7(_a254, 0)) end
end },
{ label = "알 번호 (0=자동)", value = _a10.HatchEggNum, onChange = function(_a255)
local _a256 = tonumber(_a255) if _a256 and _a256 >= 0 and _a256 <= 12 then
_a10.HatchEggNum = math.floor(_a256)
table.clear(_a11)
_a6("[설정] 알 번호 " .. (_a256 == 0 and "자동" or _a256)) end
end },
})
_a160(_a247, {
{ label = "뽑기 현황 보기", col = _a55.accent, fn = function()
local _a257 = _a35()
_a13.sun = _a257.sun
_a6("")
_a6("──── 뽑기 현황 ────")
_a6("  알 등급     " .. _a257.id)
_a6("  알 uid      " .. tostring(_a257.uid))
_a6("  개당 비용   " .. (_a257.cost and _a7(_a257.cost, 0) or "?"))
_a6("  Sunflowers  " .. _a7(_a257.sun, 0))
_a6("  예비금      " .. _a7(_a10.HatchReserve, 0))
_a6("  지금 가능   " .. _a257.canBuy .. "회")
_a6("")
_a6("  월드의 알 " .. _a257.eggCount .. "개")
for _a258, _a259 in ipairs(_a257.eggs) do
if _a258 > 5 then break end
_a6(("    %s  거리 %s"):format(_a259.uid, _a7(_a259.dist)))
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
local _a260, _a261 = _a130(_a194, "럭 상시 최대 유지", nil)
_a140(_a261, "luck", function()
_a54("luck", function() return _a10.LuckInterval end, _a40, "럭")
end)
_a151(_a260, {
{ label = "주기", value = _a10.LuckInterval, onChange = function(_a262)
local _a263 = tonumber(_a262) if _a263 and _a263 >= 60 then _a10.LuckInterval = _a263 end
end },
{ label = "예비금", value = _a10.LuckReserve, onChange = function(_a264)
local _a265 = tonumber(_a264) if _a265 and _a265 >= 0 then _a10.LuckReserve = _a265 end
end },
})
_a151(_a260, {
{ label = "최소 부족분", value = _a10.LuckMinTopUp, onChange = function(_a266)
local _a267 = tonumber(_a266) if _a267 and _a267 >= 0 then _a10.LuckMinTopUp = _a267 end
end },
})
for _a268, _a269 in ipairs(_a37) do
_a170(_a260, _a269,
function() return _a10.LuckBoosts[_a269] end,
function(_a270) _a10.LuckBoosts[_a269] = _a270 end)
end
_a160(_a260, {
{ label = "럭 현황 보기", col = _a55.accent, fn = function()
local _a271 = _a38()
_a13.sun = _a271.sun
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
task.spawn(function() _a12.luck = true _a40() _a12.luck = false _a97("log") end)
end },
})
end
do
local _a274, _a275 = _a130(_a194, "자동 씨앗 교체", nil)
_a140(_a275, "crop", function()
_a54("crop", function() return _a10.CropInterval end, _a29, "씨앗")
end)
_a151(_a274, {
{ label = "주기", value = _a10.CropInterval, onChange = function(_a276)
local _a277 = tonumber(_a276) if _a277 and _a277 >= 5 then _a10.CropInterval = _a277 end
end },
{ label = "갈아엎기 배수", value = _a10.CropMargin, onChange = function(_a278)
local _a279 = tonumber(_a278) if _a279 and _a279 >= 1 then _a10.CropMargin = _a279 _a6("[설정] 작물 배수 " .. _a279) end
end },
})
_a170(_a274, "성장중 건너뛰기",
function() return _a10.SkipUnhatched end,
function(_a280) _a10.SkipUnhatched = _a280 end)
_a160(_a274, {
{ label = "밭 현황 보기", col = _a55.accent, fn = function()
local _a281, _a282 = _a15()
if not _a282 then _a6("[씨앗] 밭 없음") _a97("log") return end
local _a283, _a284 = _a26(_a282), _a25()
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
local _a297 = _a28(_a296) or 0
_a288 += _a297
if _a27(_a296) then _a290 += 1
elseif _a293 > _a297 * _a10.CropMargin then _a289 += 1
else _a291 += 1 end
_a294 += 1
if _a294 <= 20 then
_a6(("  칸%-4s %-20s %s/s%s"):format(tostring(_a295),
tostring(rawget(_a296, "sp") or "?"), _a7(_a297),
_a27(_a296) and "  (자라는 중)" or ""))
end
end
if _a287 > 20 then _a6("  ... (" .. (_a287 - 20) .. "칸 더)") end
_a6("")
_a6(("총 %d칸 / 합계 %s per sec"):format(_a287, _a7(_a288)))
_a6(("갈아엎기 대상 %d / 유지 %d / 자라는 중 %d"):format(_a289, _a291, _a290))
_a97("log")
end },
{ label = "지금 1회 실행", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.crop = true _a29() _a12.crop = false _a97("log") end)
end },
})
end
do
local _a298, _a299 = _a130(_a194, "자동 확장", nil)
_a140(_a299, "expand", function()
_a54("expand", function() return _a10.ExpandInterval end, _a32, "확장")
end)
_a151(_a298, {
{ label = "주기", value = _a10.ExpandInterval, onChange = function(_a300)
local _a301 = tonumber(_a300) if _a301 and _a301 >= 5 then _a10.ExpandInterval = _a301 end
end },
{ label = "밭칸 스캔", value = _a10.MaxBedScan, onChange = function(_a302)
local _a303 = tonumber(_a302) if _a303 and _a303 >= 1 then _a10.MaxBedScan = math.floor(_a303) end
end },
})
_a160(_a298, {
{ label = "확장 현황 보기", col = _a55.accent, fn = function()
local _a304, _a305, _a306, _a307 = _a15()
if not _a305 then _a6("[확장] 밭 없음") _a97("log") return end
local _a308 = _a21()
_a13.sun = _a308
local _a309 = _a30(true)
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
local _a319 = _a31(_a305)
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
task.spawn(function() _a12.expand = true _a32() _a12.expand = false _a97("log") end)
end },
})
end
do
local _a322, _a323 = _a130(_a194, "자동 리버스", nil)
_a140(_a323, "rebirth", function()
_a54("rebirth", function() return _a10.RebirthInterval end, _a34, "리버스")
end)
_a151(_a322, {
{ label = "주기", value = _a10.RebirthInterval, onChange = function(_a324)
local _a325 = tonumber(_a324) if _a325 and _a325 >= 10 then _a10.RebirthInterval = _a325 end
end },
})
_a160(_a322, {
{ label = "리버스 현황 보기", col = _a55.accent, fn = function()
local _a326 = _a33()
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
task.spawn(function() _a12.rebirth = true _a34() _a12.rebirth = false _a97("log") end)
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
local _a332 = _a42.ctl.now
local _a333 = _a12.auto and "🟢" or "⚪"
local _a334 = _a332.act or "-"
if _a332.detail and _a332.detail ~= "" then _a334 = _a334 .. "  " .. _a332.detail end
_a331.Text = table.concat({
_a333 .. " " .. (_a12.auto and (_a332.step or "-") or "정지"),
"▸ " .. _a334,
"목표 " .. (_a332.goal or "-") .. (_a332.prog ~= "" and ("   " .. _a332.prog) or ""),
"1.리버스 " .. (_a42.auto.rebNote or "-"),
"2.존해금 " .. (_a42.auto.zoneNote or "-"),
"파밍대상 " .. tostring(_a42.auto.farmZone or "-") .. "   현재 " .. tostring(_a42.auto.hereZone or "-"),
}, "\n")
task.wait(0.2)
end
end)
function _a42.auto.start()
for _a335, _a336 in ipairs(_a42.auto.STEPS) do _a12[_a336.run] = false end
for _a337, _a338 in ipairs(_a42.auto.SIDE) do _a12[_a338.run] = false end
_a12.petspd = true
_a12.rewatch = true
_a137()
_a54("auto", function() return _a10.AutoInterval end, _a42.auto.master, "자동")
end
_a140(_a329, "auto", _a42.auto.start)
_a151(_a328, {
{ label = "주기", value = _a10.AutoInterval, onChange = function(_a339)
local _a340 = tonumber(_a339) if _a340 and _a340 >= 1 then _a10.AutoInterval = _a340 end
end },
{ label = "정체 판정(초)", value = _a10.PursueStallSec, onChange = function(_a341)
local _a342 = tonumber(_a341) if _a342 and _a342 >= 10 then _a10.PursueStallSec = _a342 end
end },
})
_a151(_a328, {
{ label = "운 퀘 최소 알 개수", value = _a10.HatchMinAfford, onChange = function(_a343)
local _a344 = tonumber(_a343) if _a344 and _a344 >= 1 then _a10.HatchMinAfford = math.floor(_a344) end
end },
{ label = "더 버는 시간(초)", value = _a10.MoneyDwell, onChange = function(_a345)
local _a346 = tonumber(_a345) if _a346 and _a346 >= 0 then _a10.MoneyDwell = _a346 end
end },
})
_a151(_a328, {
{ label = "부화 한 번에(초)", value = _a10.HatchBudget, onChange = function(_a347)
local _a348 = tonumber(_a347) if _a348 and _a348 >= 3 then _a10.HatchBudget = _a348 end
end },
})
_a151(_a328, {
{ label = "이동 방식", value = _a10.TpMode, onChange = function(_a349)
_a349 = tostring(_a349 or ""):lower()
if _a349 == "instant" or _a349 == "glide" or _a349 == "walk" then _a10.TpMode = _a349 end
end },
{ label = "glide 속도", value = _a10.TpSpeed, onChange = function(_a350)
local _a351 = tonumber(_a350) if _a351 and _a351 >= 16 then _a10.TpSpeed = _a351 end
end },
})
_a170(_a328, "차단 화면에 실제 클릭까지 시도",
function() return _a10.ScreenRealClick end,
function(_a352) _a10.ScreenRealClick = _a352 end)
_a170(_a328, "퀘스트 없을 때도 알 까기",
function() return _a10.IdleHatch end,
function(_a353) _a10.IdleHatch = _a353 end)
_a170(_a328, "존 해금·리버스는 퀘스트 끝나고",
function() return _a10.HoldZoneForQuest end,
function(_a354) _a10.HoldZoneForQuest = _a354 end)
for _a355, _a356 in ipairs(_a42.auto.STEPS) do
local _a357 = _a356.key
_a170(_a328, "  " .. _a355 .. ". " .. _a356.label,
function() return _a10.StepOn[_a357] end,
function(_a358) _a10.StepOn[_a357] = _a358 end)
end
for _a359, _a360 in ipairs(_a42.auto.SIDE) do
local _a361 = _a360.key
_a170(_a328, "  · " .. _a360.label .. " (순위 밖)",
function() return _a10.StepOn[_a361] end,
function(_a362) _a10.StepOn[_a361] = _a362 end)
end
_a160(_a328, {
{ label = "지금 상태", col = _a55.accent, fn = function()
_a6("")
_a6("──── 올 자동 ────")
_a6("  " .. (_a12.auto and "돌아가는 중" or "정지") ..
(_a42.auto.step and ("   지금: " .. _a42.auto.step) or ""))
local _a363, _a364 = _a42.quest.bestDepActive()
_a6("  현재 존 " .. tostring(_a42.move.curZone()) .. " / 최고 존 " .. tostring(_a42.move.bestZone()))
if _a363 then
_a6("  ⏸ 존해금·리버스 보류 중 — " .. tostring(_a364 and _a364.title))
else
_a6("  존해금·리버스 진행 가능")
end
_a6("")
_a6("  먼저 (순위 밖):")
for _a365, _a366 in ipairs(_a42.auto.SIDE) do
_a6(("      %-16s %s"):format(_a366.label, _a10.StepOn[_a366.key] and "ON" or "off"))
end
_a6("  우선순위:")
for _a367, _a368 in ipairs(_a42.auto.STEPS) do
_a6(("    %d. %-16s %s%s"):format(_a367, _a368.label,
_a10.StepOn[_a368.key] and "ON" or "off",
_a368.hold and "   (퀘스트 붙잡는 중엔 보류)" or ""))
end
_a6("")
_a6("  세이브")
local _a369 = _a8.Save
_a6("    Library.Client.Save : " .. (_a369 and "로드됨" or "★ 없음"))
if _a369 then
local _a370, _a371 = pcall(_a369.Get)
_a6("    Get()        : " .. (_a370 and type(_a371) or ("에러 " .. tostring(_a371))))
local _a372, _a373 = pcall(_a369.Get, _a4)
_a6("    Get(LP)      : " .. (_a372 and type(_a373) or ("에러 " .. tostring(_a373))))
if rawget(_a369, "GetSaves") then
local _a374, _a375 = pcall(_a369.GetSaves)
if _a374 and type(_a375) == "table" then
local _a376 = 0
for _a377 in pairs(_a375) do
_a376 += 1
if _a376 <= 3 then _a6("      키: " .. tostring(_a377)
.. (_a377 == _a4 and "   ← 내 LocalPlayer" or "")) end
end
_a6("    GetSaves()   : " .. _a376 .. "개")
else
_a6("    GetSaves()   : 에러 " .. tostring(_a375))
end
end
local _a378 = _a43()
if _a378 then
local _a379 = rawget(_a378, "Goals")
_a6("    → 읽기 성공. Rebirths " .. tostring(rawget(_a378, "Rebirths"))
.. " / Goals " .. (type(_a379) == "table" and #_a379 or "없음"))
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
for _a380, _a381 in ipairs(_a42.auto.lastTrace or {}) do _a6("    " .. _a381) end
_a97("log")
end },
{ label = "화면 넘기기 진단", col = _a55.warn, fn = function()
task.spawn(function()
_a6("")
_a6("──── 보상 화면 ────")
local _a382 = _a41.Vars
_a6("  Library.Variables : " .. (_a382 and "로드됨" or "없음"))
if _a382 then
_a6("    IsRebirthing = " .. tostring(rawget(_a382, "IsRebirthing")))
_a6("    IsRankingUp  = " .. tostring(rawget(_a382, "IsRankingUp")))
_a6("    OpeningEgg   = " .. tostring(rawget(_a382, "OpeningEgg")))
end
_a6("  debug.info     : " .. tostring(type(debug) == "table" and type(debug.info) == "function"))
_a6("  getgc          : " .. tostring(type(getgc) == "function"))
_a6("  debug.setupvalue: " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
local _a383 = _a4:FindFirstChildOfClass("PlayerGui")
if _a383 then
_a6("  떠 있는 차단 화면:")
local _a384 = false
for _a385, _a386 in ipairs(_a42.screen.BLOCKERS) do
local _a387 = _a383:FindFirstChild(_a386[1])
_a6(("    %-14s %s"):format(_a386[1],
_a387 and (_a387.Enabled and "★ 켜짐" or "꺼짐") or "없음"))
if _a387 and _a387.Enabled then _a384 = true end
end
if not _a384 then _a6("    (없음)") end
end
if type(getgc) == "function" and type(debug) == "table" and debug.info then
_a6("")
_a6("  Rebirth/RankUp 스크립트의 클로저 시그니처:")
local _a388, _a389 = {}, 0
for _a390, _a391 in ipairs({ true, false }) do
local _a392, _a393 = pcall(getgc, _a391)
if _a392 then
for _a394, _a395 in ipairs(_a393) do
if type(_a395) == "function" and _a389 < 25 then
local _a396, _a397 = pcall(debug.info, _a395, "s")
if _a396 and type(_a397) == "string"
and (_a397:find("Rebirth", 1, true) or _a397:find("Rank Up", 1, true)) then
local _a398, _a399 = pcall(debug.info, _a395, "a")
if _a398 then
local _a400 = {}
for _a401 = 1, 16 do
local _a402, _a403 = pcall(debug.getupvalue, _a395, _a401)
if not _a402 then break end
_a400[_a401] = type(_a403)
end
local _a404 = ("인자%d | %s"):format(_a399 or -1,
#_a400 > 0 and table.concat(_a400, ",") or "(없음)")
if not _a388[_a404] then
_a388[_a404] = true
_a389 += 1
_a6("    " .. _a404)
end
end
end
end
end
end
end
if _a389 == 0 then _a6("    (하나도 못 찾음)") end
end
for _a405, _a406 in ipairs({ "reward", "egg", "mastery", "card" }) do
_a42.screen._sig = nil
local _a407 = _a42.screen.findSignalFns(_a406)
_a6("")
_a6(("  [%s] 찾은 함수 %d개"):format(_a406, #_a407))
for _a408, _a409 in ipairs(_a407) do
_a6(("    %s%s"):format(_a409.exact and "★정확일치 " or "", tostring(_a409.src)))
_a6(("       upvalue %d개 : %s"):format(_a409.n or 0, tostring(_a409.sig)))
end
if #_a407 == 0 then
_a6("    (getgc 로 그 스크립트의 클로저를 못 찾음)")
end
local _a410, _a411 = _a42.screen.signal(_a406)
_a6(("    upvalue 신호 : %s (%s개 세팅)"):format(tostring(_a410), tostring(_a411)))
local _a412 = _a42.screen.SIGNAL[_a406]
_a6(("    게임내 입력발동 : %s"):format(
tostring(_a42.screen.pressInGame(_a412 and _a412.pats or {}))))
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
local _a413 = {}
for _a414, _a415 in ipairs(_a42.auto.SIDE) do
_a413[#_a413 + 1] = _a415.key .. "=" .. tostring(_a10.StepOn[_a415.key])
end
for _a416, _a417 in ipairs(_a42.auto.STEPS) do
_a413[#_a413 + 1] = _a417.key .. "=" .. tostring(_a10.StepOn[_a417.key])
end
_a6("  단계 ON/OFF : " .. table.concat(_a413, "  "))
_a6("  lockGoal    : " .. (_a42.ctl.lockGoal and tostring(_a42.ctl.lockGoal.q.title) or "없음"))
local _a418, _a419 = _a42.quest.bestDepActive()
_a6("  보류중?     : " .. tostring(_a418) .. (_a419 and ("  ← " .. tostring(_a419.title)) or ""))
_a6("  리모트      : 존 " .. (_a41.R_Zone and "O" or "X")
.. " / 리버스 " .. (_a41.R_Reb and "O" or "X"))
_a6("")
_a6("  ── 존 해금 판정 ──")
local _a420 = _a46()
if not _a420 then
_a6("    zoneStatus() = nil  ← 다음 존을 못 구함")
local _a421 = _a41.Zone and rawget(_a41.Zone, "GetNextZone")
if _a421 then
local _a422, _a423, _a424 = pcall(_a41.Zone.GetNextZone)
_a6("    GetNextZone → ok=" .. tostring(_a422)
.. " / " .. tostring(_a423) .. " / " .. tostring(_a424))
end
if _a41.Zone and rawget(_a41.Zone, "HasCompletedNextZoneQuests") then
local _a425, _a426 = pcall(_a41.Zone.HasCompletedNextZoneQuests)
_a6("    존 퀘스트 완료? " .. (_a425 and tostring(_a426) or ("에러 " .. tostring(_a426))))
end
else
_a6("    다음 존 : " .. tostring(_a420.id))
_a6(("    가격 %s %s / 보유 %s → %s"):format(
_a7(_a420.price or 0, 0), tostring(_a420.currency), _a7(_a420.have, 0),
_a420.ok and "지금 살 수 있음" or "부족"))
end
_a6("")
_a6("  ── 리버스 판정 ──")
local _a427 = _a51()
if not _a427 then _a6("    세이브 못 읽음")
else
_a6(("    현재 %d → 다음 %d"):format(_a427.current, _a427.nextN))
_a6("    최근 사유 : " .. tostring(_a42.auto.rebNote or "-"))
end
_a6("")
_a6("  ── 직전 바퀴 기록 ──")
if _a42.auto.lastTrace and #_a42.auto.lastTrace > 0 then
for _a428, _a429 in ipairs(_a42.auto.lastTrace) do _a6("    " .. _a429) end
_a6(("    (%.0f초 전)"):format(os.clock() - (_a42.auto.lastPassAt or os.clock())))
else
_a6("    아직 한 바퀴도 안 돌았음")
end
_a97("log")
end)
end },
})
local _a430, _a431 = _a130(_a327, "펫 이동속도", nil)
_a140(_a431, "petspd", function()
_a54("petspd", function() return 0.4 end, _a42.item.applyPetSpeed, "펫속도")
end)
_a151(_a430, {
{ label = "배수", value = _a10.PetSpeedMult, onChange = function(_a432)
local _a433 = tonumber(_a432) if _a433 and _a433 >= 1 then _a10.PetSpeedMult = _a433 end
end },
{ label = "기본 계수 (원래 0.45)", value = _a10.PetSpeedBase, onChange = function(_a434)
local _a435 = tonumber(_a434) if _a435 and _a435 > 0 then _a10.PetSpeedBase = _a435 end
end },
})
_a160(_a430, {
{ label = "지금 적용 / 확인", col = _a55.accent, fn = function()
local _a436, _a437 = _a42.item.applyPetSpeed()
_a6("")
_a6("──── 펫 이동속도 ────")
_a6("  PlayerPet 모듈 : " .. (_a41.PlayerPet and "로드됨" or "없음"))
_a6(("  적용된 펫 %d마리  (배수 %s / 계수 %s)"):format(
_a436, tostring(_a10.PetSpeedMult), tostring(_a10.PetSpeedBase)))
if _a437 then _a6("  " .. tostring(_a437)) end
if _a436 == 0 then _a6("  펫을 장착하고 다시 눌러보세요") end
_a97("log")
end },
})
_a54("petspd", function() return 0.4 end, _a42.item.applyPetSpeed, "펫속도")
_a54("rewatch", function() return 1 end, function()
_a42.screen.watchTick = (_a42.screen.watchTick or 0) + 1
_a42.egg.watchStuck()
if _a42.screen.dismissBusy then return end
local _a438, _a439 = _a42.screen.rewardScreenUp()
if _a438 and _a42.screen.screenGaveUp and (os.clock() - _a42.screen.screenGaveUp) < 30 then
return
end
if _a438 then
if _a42.screen.lastBlocker ~= _a439 then
_a42.screen.lastBlocker = _a439
_a6("[화면] " .. tostring(_a439) .. " 화면 감지 — 넘기는 중")
end
_a42.screen.dismissRewardScreens(20)
end
end, "보상화면")
local _a440, _a441 = _a130(_a327, "자동 파밍 유지", nil)
_a140(_a441, "farm", function()
_a54("farm", function() return _a10.FarmInterval end, _a45, "파밍")
end)
_a151(_a440, {
{ label = "주기", value = _a10.FarmInterval, onChange = function(_a442)
local _a443 = tonumber(_a442) if _a443 and _a443 >= 3 then _a10.FarmInterval = _a443 end
end },
})
local _a444, _a445 = _a130(_a327, "자동 존 해금", nil)
_a140(_a445, "zone", function()
_a54("zone", function() return _a10.ZoneInterval end, _a47, "존")
end)
_a151(_a444, {
{ label = "주기", value = _a10.ZoneInterval, onChange = function(_a446)
local _a447 = tonumber(_a446) if _a447 and _a447 >= 3 then _a10.ZoneInterval = _a447 end
end },
})
_a160(_a444, {
{ label = "다음 존 보기", col = _a55.accent, fn = function()
local _a448 = _a46()
_a6("")
if not _a448 then _a6("[존] 다음 존 없음 (최대 도달?)")
else
_a6("──── 다음 존 ────")
_a6("  " .. tostring(_a448.id))
_a6("  가격 " .. _a7(_a448.price or 0, 0) .. " " .. tostring(_a448.currency))
_a6("  보유 " .. _a7(_a448.have, 0))
_a6("  " .. (_a448.ok and "지금 해금 가능" or "부족"))
end
_a97("log")
end },
{ label = "지금 1회", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.zone = true _a47() _a12.zone = false _a97("log") end)
end },
})
local _a449, _a450 = _a130(_a327, "자동 부화", nil)
_a140(_a450, "mhatch", function()
_a54("mhatch", function() return _a10.MainHatchInterval end, _a50, "부화")
end)
_a151(_a449, {
{ label = "주기", value = _a10.MainHatchInterval, onChange = function(_a451)
local _a452 = tonumber(_a451) if _a452 and _a452 >= 1 then _a10.MainHatchInterval = _a452 end
end },
{ label = "한 번에 최대", value = _a10.MainHatchMax, onChange = function(_a453)
local _a454 = tonumber(_a453) if _a454 and _a454 >= 1 then _a10.MainHatchMax = math.floor(_a454) end
end },
})
_a151(_a449, {
{ label = "예비금", value = _a10.MainHatchReserve, onChange = function(_a455)
local _a456 = tonumber(_a455) if _a456 and _a456 >= 0 then _a10.MainHatchReserve = _a456 end
end },
{ label = "알 ID (비우면 자동)", value = _a10.MainEggId, onChange = function(_a457)
_a10.MainEggId = _a457 or ""
end },
})
_a151(_a449, {
{ label = "알 인식 거리", value = _a10.EggRange, onChange = function(_a458)
local _a459 = tonumber(_a458) if _a459 and _a459 >= 5 then _a10.EggRange = _a459 end
end },
})
_a170(_a449, "새 맵 열리면 잠긴 알 자동 해금",
function() return _a10.AutoUnlockEgg end,
function(_a460) _a10.AutoUnlockEgg = _a460 end)
_a170(_a449, "게임 내장 오토해치 사용 (기본 끔)",
function() return _a10.UseAutoHatch end,
function(_a461) _a10.UseAutoHatch = _a461 if not _a461 then _a42.egg.autoHatchOff() end end)
_a170(_a449, "까는 화면 자동으로 넘기기 (신호)",
function() return _a10.HatchClick end,
function(_a462) _a10.HatchClick = _a462 end)
_a160(_a449, {
{ label = "잠긴 알 보기", col = _a55.accent, fn = function()
local _a463, _a464, _a465 = _a42.egg.lockedEggs()
_a6("")
_a6("──── 알 해금 현황 ────")
_a6(("  해금 가능 최대 : #%d   /   현재 해금한 최대 : #%d"):format(_a464, _a465))
_a6("  해금 리모트 : " .. (_a41.R_EggUn and "있음" or "없음"))
if #_a463 == 0 then
_a6("  풀 수 있는 알이 없음 (다 풀었거나 존을 더 사야 함)")
else
_a6("  아직 안 푼 알 " .. #_a463 .. "개:")
for _a466, _a467 in ipairs(_a463) do
_a6(("    #%-3d %s"):format(_a467.num, _a467.id))
if _a466 >= 20 then _a6("    ...") break end
end
end
_a97("log")
end },
{ label = "부화 진단", col = _a55.warn, fn = function()
task.spawn(function()
_a6("")
_a6("──── 부화 진단 ────")
local _a468, _a469, _a470, _a471 = _a48()
_a6("  대상 알   : " .. tostring(_a468))
if not _a468 then _a6("  (오픈한 알이 없음)") _a97("log") return end
local _a472 = _a469 and tonumber(rawget(_a469, "eggNumber"))
_a6("  알 번호   : " .. tostring(_a472) .. "   오픈함? " .. tostring(_a42.egg.eggUnlocked(_a472)))
_a6("  거리      : " .. (_a470 and ("%.0f (사거리 안)"):format(_a470)
or ((_a471 and ("%.0f (사거리 %d 밖)"):format(_a471, _a10.EggRange)) or "받침대 못 찾음")))
local _a473 = _a469 and rawget(_a469, "currency") or "?"
_a6("  통화      : " .. tostring(_a473) .. "   보유 " .. _a7(_a44(_a473), 0))
if type(_a41.CalcEgg) == "function" then
local _a474, _a475 = pcall(_a41.CalcEgg, _a469)
_a6("  CalcEggPricePlayer : " .. (_a474 and tostring(_a475) or ("에러 " .. tostring(_a475))))
end
if type(_a41.CalcEggB) == "function" then
local _a476, _a477 = pcall(_a41.CalcEggB, _a469)
_a6("  CalcEggPrice       : " .. (_a476 and tostring(_a477) or ("에러 " .. tostring(_a477))))
end
if _a41.Egg then
for _a478, _a479 in ipairs({ "GetMaxHatch", "ComputeDebounce", "GetHighestEggNumberAvailable" }) do
if rawget(_a41.Egg, _a479) then
local _a480, _a481 = pcall(_a41.Egg[_a479], _a469)
_a6(("  %-28s : %s"):format(_a479, _a480 and tostring(_a481) or ("에러 " .. tostring(_a481))))
end
end
end
_a6("  OpeningEgg      : " .. tostring(_a41.Vars and rawget(_a41.Vars, "OpeningEgg")))
if _a41.Hatch then
for _a482, _a483 in ipairs({ "IsHatching", "GetEggAmount" }) do
if rawget(_a41.Hatch, _a483) then
local _a484, _a485 = pcall(_a41.Hatch[_a483])
_a6(("  %-15s : %s"):format(_a483, _a484 and tostring(_a485) or ("에러 " .. tostring(_a485))))
end
end
if rawget(_a41.Hatch, "GetEggDirectory") then
local _a486, _a487 = pcall(_a41.Hatch.GetEggDirectory)
_a6("  세팅된 알       : " .. (_a486 and _a487 and tostring(rawget(_a487, "_id")) or "없음"))
end
end
_a6("  ▶ SetupEgg 시도")
_a42.egg._ahEgg = nil
_a42.egg.autoHatchOn(_a468, 1)
if _a41.Hatch and rawget(_a41.Hatch, "IsHatching") then
local _a488, _a489 = pcall(_a41.Hatch.IsHatching)
_a6("    IsHatching 이후 : " .. (_a488 and tostring(_a489) or ("에러 " .. tostring(_a489))))
_a6("    " .. ((_a488 and _a489) and "→ 클릭 없이 넘어갑니다"
or "→ SetupEgg 안 먹음. 클릭 대체가 필요합니다"))
end
_a6("  신호 가능 : getgc " .. tostring(type(getgc) == "function")
.. " / debug.setupvalue " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
_a6("")
_a6("  ▶ 1개로 실제 호출")
local _a490, _a491
local _a492 = pcall(function() _a490, _a491 = _a9.R_EGG:InvokeServer(_a468, 1) end)
_a6("    호출성공 : " .. tostring(_a492))
_a6("    반환1    : " .. tostring(_a490))
_a6("    반환2    : " .. tostring(_a491))
_a97("log")
end)
end },
{ label = "지금 전부 해금", col = _a55.good, fn = function()
task.spawn(function()
_a6("")
local _a493, _a494 = _a42.egg.unlockEggs(true)
_a6(_a493 > 0 and ("[해금] %d개 완료"):format(_a493)
or ("[해금] 0개" .. (_a494 and (" — " .. tostring(_a494)) or "")))
_a97("log")
end)
end },
})
_a160(_a449, {
{ label = "알 현황 보기", col = _a55.accent, fn = function()
local _a495 = _a49()
_a6("")
if not _a495 then _a6("[부화] 알을 못 찾음")
else
_a6("──── 메인 알 ────")
_a6("  " .. tostring(_a495.id))
_a6("  가격 " .. (_a495.price and _a7(_a495.price, 0) or "?") .. " " .. tostring(_a495.currency))
_a6("  보유 " .. _a7(_a495.have, 0))
_a6("  한 번에 " .. _a495.maxN .. "개까지")
_a6("  지금 가능 " .. _a495.canBuy .. "회")
if _a495.inRange then
_a6(("  거리 %.0f 스터드 — 부화 가능"):format(_a495.dist))
else
_a6(("  사거리(%d) 안에 알 없음. 가장 가까운 알 %s스터드"):format(
_a10.EggRange, _a495.nearest and ("%.0f"):format(_a495.nearest) or "?"))
_a6("  → 알 앞으로 걸어가야 부화됩니다")
end
end
_a6("")
_a6("──── 주변 알 (가까운 순 10개) ────")
local _a496 = _a42.egg.eggStands()
for _a497 = 1, math.min(10, #_a496) do
local _a498 = _a496[_a497]
_a6(("  %6.0f  #%-3d %-24s %s"):format(
_a498.dist, _a498.num, _a498.id, _a42.egg.eggUnlocked(_a498.num) and "오픈함" or "잠김"))
end
if #_a496 == 0 then _a6("  (못 찾음)") end
_a97("log")
end },
{ label = "지금 1회", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.mhatch = true _a50() _a12.mhatch = false _a97("log") end)
end },
})
local _a499, _a500 = _a130(_a327, "랭크 퀘스트 자동", nil)
_a140(_a500, "quest", function()
_a54("quest", function() return _a10.QuestInterval end, _a42.quest.cycle, "퀘스트")
end)
_a151(_a499, {
{ label = "주기", value = _a10.QuestInterval, onChange = function(_a501)
local _a502 = tonumber(_a501) if _a502 and _a502 >= 5 then _a10.QuestInterval = _a502 end
end },
{ label = "포션 한 번에", value = _a10.QuestUseMax, onChange = function(_a503)
local _a504 = tonumber(_a503) if _a504 and _a504 >= 1 then _a10.QuestUseMax = math.floor(_a504) end
end },
})
_a170(_a499, "필요한 자동화 자동 ON",
function() return _a10.QuestDrive end,
function(_a505) _a10.QuestDrive = _a505 end)
_a170(_a499, "포션/인챈트 업글 퀘스트",
function() return _a10.QuestUpgrade end,
function(_a506) _a10.QuestUpgrade = _a506 end)
_a170(_a499, "포션 사용 퀘스트",
function() return _a10.QuestUsePotion end,
function(_a507) _a10.QuestUsePotion = _a507 end)
_a160(_a499, {
{ label = "퀘스트 현황 보기", col = _a55.accent, fn = function()
local _a508 = _a42.quest.status()
_a6("")
if not _a508 then _a6("[퀘스트] 세이브 못 읽음")
else
_a6("──── 랭크 퀘스트 ────")
_a6(("  Rank %d   ★%d"):format(_a508.rank, _a508.rankStars))
if #_a508.list == 0 then _a6("  퀘스트 없음") end
for _a509, _a510 in ipairs(_a508.list) do
local _a511 = _a510.how
local _a512 =
(_a511 == "farm" and "자동 파밍") or
(_a511 == "hatch" and "자동 부화") or
(_a511 == "zone" and "자동 존") or
(_a511 == "potup" and "포션 업글") or
(_a511 == "encup" and "인챈트 업글") or
(_a511 == "potuse" and "포션 사용") or
(_a511 == "fruituse" and "과일 사용") or
(_a511 == "flaguse" and "깃발 사용") or
(_a511 == "gold" and "골드 머신") or
(_a511 == "rainbow" and "레인보우 머신") or
"수동"
local _a513 = ""
if _a510.ignored then
_a512 = "무시"
_a513 = "   → " .. _a510.ignored
elseif _a510.event then
local _a514 = _a42.ev.findEvent(_a510.event, _a510.bestOnly)
_a513 = _a514 and ("   → %s @%s %d초"):format(_a514.name, tostring(_a514.zone), _a514.left)
or ("   → " .. _a510.event .. " 대기중")
elseif _a510.chest then
_a513 = "   → " .. _a510.chest
elseif _a510.where then
_a513 = "   → " .. _a510.where
end
_a6(("  [%d] %s"):format(_a510.stars, tostring(_a510.title)))
_a6(("       %d / %d    처리: %s   (Type %d)%s"):format(
_a510.progress, _a510.amount, _a512, _a510.type, _a513))
end
end
_a97("log")
end },
{ label = "활성 이벤트 보기", col = _a55.accent, fn = function()
local _a515 = _a42.ev.events()
local _a516 = _a42.move.bestZone()
_a6("")
_a6("──── 지금 떠 있는 랜덤 이벤트 ────")
_a6("  최고 존 : " .. tostring(_a516) .. "   현재 존 : " .. tostring(_a42.move.curZone()))
if #_a515 == 0 then _a6("  없음 (RandomEvents_Get 응답 비어있음)") end
for _a517, _a518 in ipairs(_a515) do
_a6(("  %-12s @%-20s %4d초 남음  %s%s"):format(
_a518.kind, tostring(_a518.zone), _a518.left,
_a518.pos and ("(%.0f, %.0f, %.0f)"):format(_a518.pos.X, _a518.pos.Y, _a518.pos.Z) or "좌표없음",
_a518.zone == _a516 and "  ★최고존" or ""))
end
_a6("")
_a6("  내 소환 아이템 :")
for _a519 in pairs(_a42.ev.SPAWN) do
local _a520 = _a42.ev.spawnItems(_a519)
local _a521 = 0
for _a522, _a523 in ipairs(_a520) do _a521 += _a523.am end
_a6(("    %-12s %d종 %d개"):format(_a519, #_a520, _a521))
for _a524, _a525 in ipairs(_a520) do
_a6(("        %d. %-24s x%d%s"):format(
_a524, _a525.id, _a525.am, _a524 == 1 and "   ← 먼저 씀" or ""))
if _a524 >= 6 then break end
end
end
_a6("  점선 네모 안? " .. tostring(_a42.move.inDottedBox()))
for _a526, _a527 in ipairs({ "MiniChests", "SuperiorMiniChests" }) do
local _a528, _a529 = _a42.ev.findChest(_a527)
_a6(("  %-20s %s"):format(_a527,
_a528 and ("가장 가까운 것 %.0f스터드"):format(_a529 or 0) or "없음"))
end
_a97("log")
end },
{ label = "포션 재고 보기", col = _a55.accent, fn = function()
_a6("")
_a6("──── 포션 / 인챈트 재고 ────")
for _a530, _a531 in ipairs({ "Potion", "Enchant" }) do
local _a532 = _a42.item.stacks(_a531)
table.sort(_a532, function(_a533, _a534)
if _a533.id ~= _a534.id then return _a533.id < _a534.id end
return _a533.tier < _a534.tier
end)
_a6("")
_a6(_a531 .. "  (" .. #_a532 .. "종)")
for _a535, _a536 in ipairs(_a532) do
local _a537 = _a42.item.perTier(_a531, _a536.tier)
local _a538 = _a537 and math.floor(_a536.am / _a537) or 0
_a6(("   %-20s T%-2d x%-6d %s"):format(
_a536.id, _a536.tier, _a536.am,
_a538 > 0 and ("→ T" .. (_a536.tier + 1) .. " " .. _a538 .. "개 제작가능") or ""))
if _a535 >= 40 then _a6("   ...") break end
end
if #_a532 == 0 then _a6("   (없음)") end
end
_a97("log")
end },
{ label = "지금 1회", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.quest = true _a42.quest.cycle() _a12.quest = false _a97("log") end)
end },
})
local _a539, _a540 = _a130(_a327, "슬롯 머신 자동 (다이아)", nil)
_a140(_a540, "slots", function()
_a54("slots", function() return _a10.SlotInterval end, _a42.mach.cycleSlots, "슬롯")
end)
_a151(_a539, {
{ label = "주기", value = _a10.SlotInterval, onChange = function(_a541)
local _a542 = tonumber(_a541) if _a542 and _a542 >= 5 then _a10.SlotInterval = _a542 end
end },
{ label = "남길 다이아", value = _a10.SlotReserve, onChange = function(_a543)
local _a544 = tonumber(_a543) if _a544 and _a544 >= 0 then _a10.SlotReserve = _a544 end
end },
})
_a170(_a539, "펫 장착 슬롯 (Pet Equip)",
function() return _a10.SlotPet end, function(_a545) _a10.SlotPet = _a545 end)
_a170(_a539, "알 부화 슬롯 (Egg Machine)",
function() return _a10.SlotEgg end, function(_a546) _a10.SlotEgg = _a546 end)
_a160(_a539, {
{ label = "슬롯 현황 보기", col = _a55.accent, fn = function()
local _a547 = _a42.mach.slotStatus()
_a6("")
_a6("──── 슬롯 머신 ────")
if not _a547 then _a6("  세이브 못 읽음") _a97("log") return end
_a6("  다이아 " .. _a7(_a547.dia, 0))
_a6("")
_a6(("  펫 장착 : 구매 %d / 랭크상한 %d   현재 최대장착 %s"):format(
_a547.petOwned, _a547.petMax, tostring(_a547.maxEquip)))
if _a547.petNext then
_a6(("     다음 #%d  %s 다이아  %s"):format(
_a547.petNext, _a547.petCost and _a7(_a547.petCost, 0) or "?",
(_a547.petCost and _a547.petCost <= _a547.dia - _a10.SlotReserve) and "← 지금 가능" or "부족"))
else
_a6("     랭크 상한까지 다 삼 (랭크를 올려야 더 살 수 있음)")
end
_a6("")
_a6(("  알 부화 : 구매 %d / 랭크상한 %d   한 번에 %s개"):format(
_a547.eggOwned, _a547.eggMax, tostring(_a547.maxHatch)))
if _a547.eggEnd then
_a6(("     다음 %d칸 묶음 → %d   %s 다이아  %s"):format(
_a547.eggSize, _a547.eggEnd, _a547.eggCost and _a7(_a547.eggCost, 0) or "?",
(_a547.eggCost and _a547.eggCost <= _a547.dia - _a10.SlotReserve) and "← 지금 가능" or "부족"))
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
local _a548, _a549 = _a130(_a327, "아이템 자동 사용 (버프 유지)", nil)
_a140(_a549, "items", function()
_a54("items", function() return _a10.ItemInterval end, _a42.item.cycleItems, "아이템")
end)
_a151(_a548, {
{ label = "주기", value = _a10.ItemInterval, onChange = function(_a550)
local _a551 = tonumber(_a550) if _a551 and _a551 >= 5 then _a10.ItemInterval = _a551 end
end },
{ label = "포션 한 바퀴 최대", value = _a10.BuffMaxPotion, onChange = function(_a552)
local _a553 = tonumber(_a552) if _a553 and _a553 >= 1 then _a10.BuffMaxPotion = math.floor(_a553) end
end },
})
_a151(_a548, {
{ label = "남길 개수", value = _a10.ItemKeep, onChange = function(_a554)
local _a555 = tonumber(_a554) if _a555 and _a555 >= 0 then _a10.ItemKeep = math.floor(_a555) end
end },
{ label = "과일/소모품 최대", value = _a10.BuffMaxOther, onChange = function(_a556)
local _a557 = tonumber(_a556) if _a557 and _a557 >= 1 then _a10.BuffMaxOther = math.floor(_a557) end
end },
})
_a151(_a548, {
{ label = "쓸 것 (비우면 전부)", value = _a10.ItemAllow, onChange = function(_a558)
_a10.ItemAllow = _a558 or ""
end },
{ label = "제외", value = _a10.ItemBlock, onChange = function(_a559)
_a10.ItemBlock = _a559 or ""
end },
})
_a170(_a548, "포션", function() return _a10.BuffPotion end,
function(_a560) _a10.BuffPotion = _a560 end)
_a170(_a548, "과일", function() return _a10.BuffFruit end,
function(_a561) _a10.BuffFruit = _a561 end)
_a170(_a548, "얼티밋 (충전되면 발동, 무료)", function() return _a10.BuffUltimate end,
function(_a562) _a10.BuffUltimate = _a562 end)
_a170(_a548, "소모품 (Rain/Sunlight 주의)", function() return _a10.BuffConsumable end,
function(_a563) _a10.BuffConsumable = _a563 end)
_a170(_a548, "높은 티어부터 사용 (끄면 낮은 것부터)", function() return _a10.BuffHighTier end,
function(_a564) _a10.BuffHighTier = _a564 end)
_a170(_a548, "최고 존에서만 사용", function() return _a10.ItemBestZone end,
function(_a565) _a10.ItemBestZone = _a565 end)
_a170(_a548, "최고 존이 아니면 이동 후 사용", function() return _a10.ItemTp end,
function(_a566) _a10.ItemTp = _a566 end)
_a160(_a548, {
{ label = "버프 현황 보기", col = _a55.accent, fn = function()
_a6("")
_a6("──── 버프 / 아이템 ────")
_a6(("  현재 존 %s / 최고 존 %s%s"):format(
tostring(_a42.move.curZone()), tostring(_a42.move.bestZone()),
_a10.ItemBestZone and (_a42.move.curZone() == _a42.move.bestZone() and "   ← 사용 가능" or "   ← 이동 필요") or ""))
for _a567, _a568 in pairs({ Potions = "Potion", Fruits = "Fruit" }) do
local _a569 = _a42.item.activeBuffs(_a567)
local _a570 = {}
for _a571 in pairs(_a569) do _a570[#_a570 + 1] = _a571 end
table.sort(_a570)
_a6(("  지금 걸린 %s : %s"):format(_a567,
#_a570 > 0 and table.concat(_a570, ", ") or "없음"))
end
local _a572 = _a43()
local _a573 = _a572 and rawget(_a572, "Ultimates")
if type(_a573) == "table" then
local _a574 = {}
for _a575 in pairs(_a573) do
local _a576 = "?"
if _a41.Ult and rawget(_a41.Ult, "IsCharged") then
local _a577, _a578 = pcall(_a41.Ult.IsCharged, _a575)
_a576 = _a577 and (_a578 and "충전됨" or "충전중") or "?"
end
_a574[#_a574 + 1] = _a575 .. "(" .. _a576 .. ")"
end
_a6("  얼티밋 : " .. (#_a574 > 0 and table.concat(_a574, ", ") or "없음"))
end
_a6("")
for _a579, _a580 in ipairs({ "Potion", "Fruit", "Consumable" }) do
local _a581 = _a42.item.stacks(_a580)
local _a582, _a583 = 0, 0
for _a584, _a585 in ipairs(_a581) do
if _a42.item.itemAllowed(_a585.id) then _a582 += 1 else _a583 += 1 end
end
_a6(("  %-12s %d종 (쓸 수 있음 %d / 제외 %d)"):format(_a580, #_a581, _a582, _a583))
for _a586, _a587 in ipairs(_a581) do
_a6(("      %-20s T%-2d x%-6d %s"):format(
_a587.id, _a587.tier, _a587.am, _a42.item.itemAllowed(_a587.id) and "" or "제외됨"))
if _a586 >= 12 then _a6("      ...") break end
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
local _a588, _a589 = _a130(_a327, "맵 업그레이드 자동 (다이아)", nil)
_a140(_a589, "mapupg", function()
_a54("mapupg", function() return _a10.UpgInterval end, _a42.mach.cycleUpg, "맵업글")
end)
_a151(_a588, {
{ label = "주기", value = _a10.UpgInterval, onChange = function(_a590)
local _a591 = tonumber(_a590) if _a591 and _a591 >= 5 then _a10.UpgInterval = _a591 end
end },
{ label = "남길 다이아", value = _a10.UpgReserve, onChange = function(_a592)
local _a593 = tonumber(_a592) if _a593 and _a593 >= 0 then _a10.UpgReserve = _a593 end
end },
})
_a170(_a588, "구매 전 그 앞으로 이동",
function() return _a10.UpgTp end,
function(_a594) _a10.UpgTp = _a594 end)
_a160(_a588, {
{ label = "업그레이드 목록", col = _a55.accent, fn = function()
local _a595 = _a42.mach.upgList()
local _a596 = _a44("Diamonds")
_a6("")
_a6("──── 맵 업그레이드 ────")
_a6("보유 다이아 " .. _a7(_a596, 0))
if #_a595 == 0 then
_a6("  로드된 업그레이드 기둥이 없음 (해당 존에 가야 보입니다)")
end
local _a597, _a598, _a599 = 0, 0, 0
for _a600, _a601 in ipairs(_a595) do
if _a601.bought then _a598 += 1
elseif not _a601.zoneOwned then _a599 += 1
else _a597 += 1 end
end
_a6(("  구매가능 %d / 구매완료 %d / 존 미보유 %d"):format(_a597, _a598, _a599))
_a6("")
local _a602 = 0
for _a603, _a604 in ipairs(_a595) do
if _a604.buyable then
_a602 += 1
_a6(("  %-12s T%-2d %-20s %12s %-9s %s"):format(
_a604.id, _a604.tier, _a604.zone, _a604.cost and _a7(_a604.cost, 0) or "?",
tostring(_a604.cur),
(_a604.cost and _a604.cost <= _a44(_a604.cur or "Diamonds") - _a10.UpgReserve)
and "← 지금 가능" or ""))
if _a602 >= 25 then _a6("  ...") break end
end
end
_a97("log")
end },
{ label = "업글 진단", col = _a55.warn, fn = function()
task.spawn(function()
_a6("")
_a6("──── 맵 업그레이드 진단 ────")
_a6("  리모트 : " .. (_a41.R_Upg and _a41.R_Upg:GetFullName() or "없음"))
local _a605 = _a42.mach.upgList()
_a6("  로드된 기둥 " .. #_a605 .. "개")
local _a606
for _a607, _a608 in ipairs(_a605) do
if _a608.buyable and _a608.cost then _a606 = _a608 break end
end
if not _a606 then
_a6("  살 수 있는 게 없음 (전부 구매완료거나 존 미보유)")
for _a609, _a610 in ipairs(_a605) do
_a6(("   %-12s T%-2d @%-18s 구매됨=%s 존보유=%s"):format(
_a610.id, _a610.tier, tostring(_a610.zone), tostring(_a610.bought), tostring(_a610.zoneOwned)))
if _a609 >= 8 then _a6("   ...") break end
end
_a97("log") return
end
local _a611 = _a44(_a606.cur or "Diamonds")
local _a612 = _a42.move.hrp()
local _a613 = (_a612 and _a606.pos) and (_a612.Position - _a606.pos).Magnitude or nil
_a6(("  대상 : %s T%d @%s"):format(_a606.id, _a606.tier, tostring(_a606.zone)))
_a6(("  가격 : %s %s / 보유 %s"):format(
_a7(_a606.cost, 0), tostring(_a606.cur), _a7(_a611, 0)))
_a6("  거리 : " .. (_a613 and ("%.0f 스터드"):format(_a613) or "좌표 없음"))
_a6("")
_a6("  ▶ 제자리에서 호출")
local _a614, _a615
local _a616 = pcall(function() _a614, _a615 = _a41.R_Upg:InvokeServer(_a606.id, _a606.zone) end)
_a6("    호출성공 " .. tostring(_a616) .. " / 반환1 " .. tostring(_a614)
.. " / 반환2 " .. tostring(_a615))
if not _a614 and _a606.pos then
_a6("")
_a6("  ▶ 기둥 앞으로 이동해서 재시도")
_a42.move.glideTo(_a606.pos)
task.wait(0.3)
local _a617 = _a42.move.hrp()
_a6("    이동후 거리 " .. (_a617 and ("%.0f"):format((_a617.Position - _a606.pos).Magnitude) or "?"))
local _a618, _a619
local _a620 = pcall(function() _a618, _a619 = _a41.R_Upg:InvokeServer(_a606.id, _a606.zone) end)
_a6("    호출성공 " .. tostring(_a620) .. " / 반환1 " .. tostring(_a618)
.. " / 반환2 " .. tostring(_a619))
_a6("")
_a6(_a618 and "  → 거리 검사 있음. 이동해야 됩니다."
or "  → 이동해도 실패. 거리 문제가 아닙니다.")
else
_a6("")
_a6(_a614 and "  → 원격으로 됩니다. 이동 불필요." or "  → 실패 (좌표 없음)")
end
_a97("log")
end)
end },
{ label = "지금 1회", col = _a55.cardHi, fn = function()
task.spawn(function() _a12.mapupg = true _a42.mach.cycleUpg() _a12.mapupg = false _a97("log") end)
end },
})
local _a621, _a622 = _a130(_a327, "자동 리버스", nil)
_a140(_a622, "mreb", function()
_a54("mreb", function() return _a10.MainRebirthInterval end, _a52, "리버스")
end)
_a151(_a621, {
{ label = "주기", value = _a10.MainRebirthInterval, onChange = function(_a623)
local _a624 = tonumber(_a623) if _a624 and _a624 >= 10 then _a10.MainRebirthInterval = _a624 end
end },
})
_a170(_a621, "실패 이유 로그",
function() return _a10.MainRebirthVerbose end,
function(_a625) _a10.MainRebirthVerbose = _a625 end)
_a160(_a621, {
{ label = "리버스 현황 보기", col = _a55.accent, fn = function()
local _a626 = _a51()
_a6("")
if not _a626 then _a6("[리버스] 세이브 못 읽음")
else
_a6("──── 메인 리버스 ────")
_a6("  현재 " .. _a626.current .. "회 → 다음 " .. _a626.nextN)
if type(_a626.def) == "table" then
for _a627, _a628 in pairs(_a626.def) do
if type(_a628) ~= "table" and type(_a628) ~= "function" then
_a6("    " .. tostring(_a627) .. " = " .. tostring(_a628))
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
local _a629 = _a130(_a327, "전체 제어", nil)
_a160(_a629, {
{ label = "메인 전부 ON", col = _a55.good, fn = function()
local _a630 = {
{ "farm",   function() return _a10.FarmInterval end,       _a45,       "파밍" },
{ "zone",   function() return _a10.ZoneInterval end,       _a47,       "존" },
{ "mhatch", function() return _a10.MainHatchInterval end,  _a50,  "부화" },
{ "quest",  function() return _a10.QuestInterval end,      _a42.quest.cycle,        "퀘스트" },
{ "mapupg", function() return _a10.UpgInterval end,        _a42.mach.cycleUpg,     "맵업글" },
{ "items",  function() return _a10.ItemInterval end,       _a42.item.cycleItems,   "아이템" },
{ "slots",  function() return _a10.SlotInterval end,       _a42.mach.cycleSlots,   "슬롯" },
}
for _a631, _a632 in ipairs(_a630) do
if not _a12[_a632[1]] then
_a12[_a632[1]] = true
_a54(_a632[1], _a632[2], _a632[3], _a632[4])
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
local _a633 = table.concat(_a5, "\n")
if #_a633 > 900000 then _a633 = _a633:sub(#_a633 - 900000) end
if type(setclipboard) == "function" then
pcall(setclipboard, _a633)
_a88.Text = "완료"
task.delay(1.5, function() if _a88 then _a88.Text = "복사" end end)
end
end)
_a87.MouseButton1Click:Connect(function()
table.clear(_a5)
_a1.dirty = true
end)
local function _a634()
_a12.place, _a12.merchant, _a12.upgrade = false, false, false
_a12.towerup, _a12.crop, _a12.expand, _a12.rebirth, _a12.hatch, _a12.luck = false, false, false, false, false, false
_a12.farm, _a12.zone, _a12.mhatch, _a12.rank, _a12.mreb = false, false, false, false, false
if _a191 then _a191:Disconnect() end
if _a73 then _a73:Destroy() end
_G.__PS99_GARDEN = nil
end
_a85.MouseButton1Click:Connect(_a634)
_G.__PS99_GARDEN = _a634
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
local _a635, _a636 = pcall(_a42.auto.start)
if _a635 then
_a6("[자동] 시작됨")
else
_a12.auto = false
_a6("[자동] 시작 실패: " .. tostring(_a636))
if _a42.auto.refresh then pcall(_a42.auto.refresh) end
end
end)
else
_a12.auto = false
_a6("[자동] QS.auto.start 가 없습니다 — 메인 게임 탭이 안 만들어짐")
end
end
pcall(function()
local _a637, _a638, _a639, _a640 = _a15()
if _a637 and _a639 then
local _a641 = _a16(_a639, _a640)
_a13.slots = #_a641
_a6("레인 " .. _a640 .. " / 슬롯 " .. #_a641)
else
_a6("가든 이벤트 밖입니다 (이벤트 탭은 이벤트 안에서만 동작)")
end
_a13.sun = _a21()
_a6("Sunflowers " .. _a7(_a13.sun, 0))
end)
end
