return function(_a1)
local _a2, _a3, _a4, _a5, _a6, _a7 = _a1.RS, _a1.LP, _a1.log, _a1.num, _a1.req, _a1.LB
local _a8, _a9, _a10, _a11, _a12, _a13 = _a1.ff, _a1.RM, _a1.CFG, _a1.VARIANT, _a1.EGG_COST_CACHE, _a1.RUN
local _a14 = _a1.STAT
local _a15
local _a16 = {
"GardenMoreDamage", "GardenFasterAttacks", "GardenMoreCoins",
"GardenBetterEggs", "GardenBetterLuck", "GardenBiggerHarvest",
"GardenFasterCrops", "GardenMoreSeeds",
}
local _a17
local function _a18()
if _a17 then return _a17 end
_a17 = {}
local _a19 = _a2:FindFirstChild("__DIRECTORY")
_a19 = _a19 and _a19:FindFirstChild("TowerDefenseTowers")
if _a19 then
for _a20, _a21 in ipairs(_a19:GetDescendants()) do
if _a21:IsA("ModuleScript") then
local _a22, _a23 = pcall(require, _a21)
if _a22 and type(_a23) == "table" then _a17[rawget(_a23, "_id") or _a21.Name] = _a23 end
end
end
end
return _a17
end
local function _a24(_a25, _a26, _a27)
local _a28 = _a18()[_a25]
if type(_a28) ~= "table" then return 0 end
local _a29 = tonumber(rawget(_a28, "AttackDamage")) or 0
local _a30 = tonumber(rawget(_a28, "AttackSpeed")) or 0
local _a31, _a32 = _a29 * _a30, 0
local _a33 = rawget(_a28, "Projectile")
if type(_a33) == "table" then
local _a34 = rawget(_a33, "ApplyDots")
if type(_a34) == "table" then
for _a35, _a36 in pairs(_a34) do
if type(_a36) == "table" then
local _a37  = tonumber(rawget(_a36, "Duration")) or 0
local _a38 = tonumber(rawget(_a36, "TickDelta")) or 0
local _a39  = tonumber(rawget(_a36, "DamageMult")) or 1
local _a40   = tonumber(rawget(_a36, "Probability")) or 1
if _a38 > 0 and _a37 > 0 and _a30 > 0 then
_a32 += (_a29 * _a39 * _a40 / _a38) * math.min(1, _a37 * _a30) * _a10.DotFactor
end
end
end
end
local _a41 = tonumber(rawget(_a33, "LingerDuration")) or 0
if _a41 > 0 and _a30 > 0 then _a32 += _a31 * math.min(1, _a41 * _a30) * 0.5 * _a10.DotFactor end
end
local _a42 = (_a31 + _a32) * (_a11[_a26 or ""] or 1)
return (_a42 ~= _a42) and 0 or _a42
end
local function _a43(_a44, _a45)
if type(_a44) ~= "string" then return nil end
return string.match(_a44, '"' .. _a45 .. '"%s*:%s*"([^"]*)"')
end
local function _a46(_a47)
if type(_a47) ~= "table" and typeof(_a47) ~= "userdata" then return nil, nil end
local _a48, _a49
pcall(function() _a48 = rawget(_a47, "_stackKey") end)
pcall(function() _a49 = rawget(_a47, "_exactStackKey") end)
if not _a48 then pcall(function() _a48 = _a47._stackKey end) end
if not _a49 then pcall(function() _a49 = _a47._exactStackKey end) end
local _a50 = _a43(_a48, "id") or _a43(_a49, "id")
local _a51 = _a43(_a48, "vr") or _a43(_a49, "vr")
return _a50, _a51
end
local function _a52(_a53)
local _a54
if _a7.GardenDefenders and _a7.GardenDefenders.UnitKey then
pcall(function() _a54 = _a7.GardenDefenders.UnitKey(_a53) end)
end
if _a54 ~= nil then return tostring(_a54) end
local _a55, _a56 = _a46(_a53)
return tostring(_a55) .. "|" .. tostring(_a56 or "")
end
local function _a57()
local _a58 = {}
if not _a7.Save then return _a58 end
local _a59, _a60 = pcall(_a7.Save.Get)
if not _a59 or type(_a60) ~= "table" then return _a58 end
local _a61 = _a60.Inventory and _a60.Inventory.Tower
if type(_a61) ~= "table" then return _a58 end
for _a62, _a63 in pairs(_a61) do
if type(_a63) == "table" then _a58[_a62] = { id = _a63.id, vr = _a63.vr } end
end
return _a58
end
local function _a64()
local _a65 = _a7.ClientTowerDefense and _a7.ClientTowerDefense.GetLocal and _a7.ClientTowerDefense.GetLocal()
local _a66  = _a7.ClientPlot and _a7.ClientPlot.GetLocal and _a7.ClientPlot.GetLocal()
local _a67
if _a66 then pcall(function() _a67 = _a66:GetModel() end) end
local _a68 = 0
if _a7.LaneUnlock and _a66 then
local _a69, _a70 = pcall(_a7.LaneUnlock.UnlockedFor, _a66)
if _a69 then _a68 = tonumber(_a70) or 0 end
end
return _a65, _a66, _a67, _a68
end
local function _a71(_a72, _a73)
local _a74 = {}
local _a75 = _a72 and _a72:FindFirstChild("Lanes")
if not _a75 then return _a74 end
for _a76, _a77 in ipairs(_a75:GetChildren()) do
local _a78 = tonumber(_a77.Name)
if _a78 and _a78 <= _a73 then
local _a79 = _a77:FindFirstChild("Slots")
if _a79 then
for _a80, _a81 in ipairs(_a79:GetChildren()) do
if _a81:IsA("BasePart") then
_a74[#_a74 + 1] = {
part = _a81, lane = _a78,
pos = _a81.Position + Vector3.new(0, _a81.Size.Y / 2, 0),
}
end
end
end
end
end
return _a74
end
local function _a82(_a83)
local _a84
pcall(function() _a84 = _a83:GetUpgrade() end)
if type(_a84) == "number" then return _a84 end
pcall(function()
local _a85 = rawget(_a83, "State")
local _a86 = _a85 and rawget(_a85, "Upgrade")
_a84 = _a86 and rawget(_a86, "Value")
end)
return tonumber(_a84) or 0
end
local function _a87(_a88)
local _a89
pcall(function() _a89 = _a88:GetId() end)
if type(_a89) == "number" then return _a89 end
pcall(function() _a89 = rawget(_a88, "Id") end)
return tonumber(_a89)
end
local function _a90(_a91)
local _a92 = {}
if not (_a91 and _a7.ClientTower) then return _a92 end
local _a93
pcall(function() _a93 = _a7.ClientTower.All(_a91) end)
if type(_a93) ~= "table" then return _a92 end
local _a94 = _a57()
for _a95, _a96 in ipairs(_a93) do
local _a97, _a98, _a99
pcall(function() _a97 = _a96:GetItem() end)
pcall(function() _a98 = _a96:GetCFrame() end)
if _a97 then pcall(function() _a99 = _a97:GetOptionalUID() end) end
local _a100, _a101 = _a46(_a97)
if not _a100 then
local _a102 = _a94[_a99 or ""] or {}
_a100, _a101 = _a102.id, _a102.vr
end
local _a103 = _a82(_a96)
_a92[#_a92 + 1] = {
tower = _a96, item = _a97, uid = _a99, cf = _a98,
id = _a87(_a96), kind = _a100, vr = _a101, up = _a103,
dps = _a24(_a100, _a101, _a103),
}
end
return _a92
end
local function _a104()
local _a105 = {}
if not (_a7.TowerItem and _a7.EntityPlacement) then return _a105 end
local _a106
if not pcall(function() _a106 = _a7.TowerItem:All() end) or type(_a106) ~= "table" then return _a105 end
local _a107 = _a57()
local _a108 = {}
for _a109, _a110 in pairs(_a106) do
local _a111
pcall(function() _a111 = _a110:GetOptionalUID() end)
if _a111 then
local _a112 = _a52(_a110)
if not _a108[_a112] then
local _a113 = 0
pcall(function() _a113 = _a7.EntityPlacement.AvailableCopies(_a110) or 0 end)
if _a113 > 0 then
local _a114, _a115 = _a46(_a110)
if not _a114 then
local _a116 = _a107[_a111] or {}
_a114, _a115 = _a116.id, _a116.vr
end
_a108[_a112] = {
item = _a110, uid = _a111, key = _a112, id = _a114, vr = _a115,
copies = _a113, dps = _a24(_a114, _a115, 0),
}
else
_a108[_a112] = false
end
end
end
end
for _a117, _a118 in pairs(_a108) do
if _a118 then _a105[#_a105 + 1] = _a118 end
end
table.sort(_a105, function(_a119, _a120)
if (_a119.dps or 0) == (_a120.dps or 0) then return tostring(_a119.key) < tostring(_a120.key) end
return (_a119.dps or 0) > (_a120.dps or 0)
end)
return _a105
end
local function _a121(_a122)
local _a123
pcall(function() _a123 = _a7.GardenLaneFacing.ForSlot(_a122.pos, _a122.part) end)
return _a123
end
local function _a124(_a125, _a126)
local _a127 = _a121(_a125)
if not _a127 then return false end
local _a128 = false
pcall(function() _a128 = _a7.EntityPlacement.Validate(_a126, _a127) end)
return _a128 and true or false, _a127
end
local function _a129(_a130, _a131, _a132)
local _a133 = _a121(_a131)
if not _a133 then return false, "facing 실패" end
local _a134, _a135 = _a130.item, _a130.uid
if _a7.EntityPlacement and type(rawget(_a7.EntityPlacement, "FirstFreeCopy")) == "function" then
local _a136, _a137 = pcall(_a7.EntityPlacement.FirstFreeCopy, _a130.item)
if _a136 and _a137 then
_a134 = _a137
pcall(function() _a135 = _a137:GetUID() end)
end
end
if not _a135 then return false, "쓸 수 있는 스택 없음" end
local _a138 = _a132.CFrame:ToObjectSpace(_a133)
local _a139, _a140, _a141
if not pcall(function() _a139, _a140, _a141 = _a9.R_ATTACH:InvokeServer(_a135, _a138) end) then
return false, "호출 실패"
end
return _a139 and true or false, _a140, _a141
end
local function _a142(_a143)
if not (_a9.R_DETACH and _a143) then return false end
local _a144
pcall(function() _a144 = _a9.R_DETACH:InvokeServer(_a143) end)
return _a144 and true or false
end
local function _a145()
local _a146, _a147, _a148, _a149 = _a64()
if not (_a146 and _a148) then
_a4("[배치] 밭/월드 준비 안 됨 — Garden 안에 있는지 확인")
return
end
local _a150 = _a71(_a148, _a149)
_a14.slots = #_a150
if #_a150 == 0 then _a4("[배치] 슬롯 없음 (잠금해제 레인 " .. _a149 .. ")") return end
local _a151 = _a90(_a146)
local _a152 = _a104()
if #_a152 == 0 then
_a4("[배치] 배치 가능한 타워 없음 (종류별 최대치 도달)")
end
local _a153 = _a151
local _a154, _a155, _a156, _a157 = 0, 0, 0, 0
local _a158 = {}
local _a159 = {}
local function _a160(_a161)
return tostring(_a161 and _a161.key or (tostring(_a161 and _a161.id) .. "|" .. tostring(_a161 and _a161.vr or "")))
end
for _a162 = #_a152, 1, -1 do
if _a159[_a160(_a152[_a162])] then table.remove(_a152, _a162) end
end
local function _a163(_a164)
for _a165, _a166 in ipairs(_a153) do
if _a166.cf then
local _a167 = Vector2.new(_a166.cf.X - _a164.pos.X, _a166.cf.Z - _a164.pos.Z).Magnitude
if _a167 < 2 then return _a166 end
end
end
return nil
end
for _a168, _a169 in ipairs(_a150) do
if not _a13.place then break end
local _a170 = _a163(_a169)
if _a170 then _a154 += 1 else _a155 += 1 end
local _a171 = _a152[1]
if not _a171 then break end
if not _a170 then
local _a172, _a173, _a174 = _a129(_a171, _a169, _a146)
if _a172 then
_a156 += 1
_a14.placed += 1
_a4(("  ▸ 배치  레인%s  %s %s  DPS %s"):format(
_a169.lane, tostring(_a171.id), tostring(_a171.vr or "-"), _a5(_a171.dps)))
_a153 = _a90(_a146)
_a152 = _a104()
for _a175 = #_a152, 1, -1 do
if _a159[_a160(_a152[_a175])] then table.remove(_a152, _a175) end
end
else
_a158[tostring(_a173)] = (_a158[tostring(_a173)] or 0) + 1
if tostring(_a173):find("copies") then _a159[_a160(_a171)] = true end
table.remove(_a152, 1)
end
task.wait(_a10.ActionGap)
elseif (_a171.dps or 0) > (_a170.dps or 0) * _a10.SwapMargin then
if _a10.ProtectUpgraded and (_a170.up or 0) > 0 then
else
if _a142(_a170.id) then
task.wait(0.5)
local _a176 = _a104()
local _a177, _a178 = false, nil
for _a179 = 1, math.min(10, #_a176) do
local _a180 = _a176[_a179]
if not _a159[_a160(_a180)] then
local _a181, _a182 = _a129(_a180, _a169, _a146)
if _a181 then
_a177, _a178 = true, _a180
break
end
_a158[tostring(_a182)] = (_a158[tostring(_a182)] or 0) + 1
if tostring(_a182):find("copies") then _a159[_a160(_a180)] = true end
task.wait(0.15)
end
end
if _a177 and _a178 then
if _a178.id == _a170.kind and (_a178.vr or "") == (_a170.vr or "") then
_a4("  · 레인" .. _a169.lane .. " 같은 종류로 되돌림 (더 나은 게 없음)")
else
_a157 += 1
_a14.swapped += 1
_a4(("  ⇄ 교체  레인%s   %s%s(Lv%s) DPS %s  →  %s %s DPS %s"):format(
_a169.lane,
tostring(_a170.kind), _a170.vr and (" " .. _a170.vr) or "",
tostring(_a170.up), _a5(_a170.dps),
tostring(_a178.id), tostring(_a178.vr or "-"), _a5(_a178.dps)))
end
else
_a4("  ! 레인" .. _a169.lane .. " 아무것도 못 놓음 — 칸이 비었습니다")
end
_a153 = _a90(_a146)
_a152 = _a104()
for _a183 = #_a152, 1, -1 do
if _a159[_a160(_a152[_a183])] then table.remove(_a152, _a183) end
end
task.wait(_a10.ActionGap)
end
end
end
end
_a14.filled, _a14.empty = _a154, _a155
local _a184 = ("[배치] 슬롯 %d (찬칸 %d / 빈칸 %d)  이번에 배치 %d, 교체 %d")
:format(#_a150, _a154, _a155, _a156, _a157)
_a4(_a184)
if next(_a158) then
for _a185, _a186 in pairs(_a158) do _a4("    실패 " .. _a186 .. "회: " .. _a185) end
end
end
local function _a187()
if not _a9.R_BUY then _a4("[구매] 리모트 없음") return end
local _a188, _a189 = 0, 0
for _a190 = 1, _a10.MerchantSlots do
if not _a13.merchant then break end
local _a191
pcall(function() _a191 = _a9.R_BUY:InvokeServer(_a10.MerchantId, _a190) end)
if _a191 ~= nil and _a191 ~= false then _a188 += 1 else _a189 += 1 end
task.wait(0.3)
end
_a14.bought += _a188
_a4(("[구매] %s  성공 %d / 실패 %d"):format(_a10.MerchantId, _a188, _a189))
end
local function _a192()
if not _a7.Save then return 0 end
local _a193, _a194 = pcall(_a7.Save.Get)
if not _a193 or type(_a194) ~= "table" then return 0 end
local _a195 = _a194.Inventory and _a194.Inventory.Currency
if type(_a195) ~= "table" then return 0 end
for _a196, _a197 in pairs(_a195) do
if type(_a197) == "table" and rawget(_a197, "id") == "Sunflowers" then
return tonumber(rawget(_a197, "_am")) or 0
end
end
return 0
end
local function _a198()
local _a199 = {}
if not _a7.Save then return _a199 end
local _a200, _a201 = pcall(_a7.Save.Get)
if not _a200 or type(_a201) ~= "table" then return _a199 end
local _a202 = rawget(_a201, "EventUpgrades")
if type(_a202) == "table" then
for _a203, _a204 in pairs(_a202) do _a199[_a203] = tonumber(_a204) or 0 end
end
return _a199
end
local _a205
local function _a206()
if _a205 then return _a205 end
_a205 = {}
local _a207 = _a2:FindFirstChild("__DIRECTORY")
_a207 = _a207 and _a207:FindFirstChild("EventUpgrades")
if _a207 then
for _a208, _a209 in ipairs(_a207:GetDescendants()) do
if _a209:IsA("ModuleScript") then
local _a210, _a211 = pcall(require, _a209)
if _a210 and type(_a211) == "table" then
_a205[rawget(_a211, "_id") or _a209.Name] = _a211
end
end
end
end
return _a205
end
local _a212, _a213
local function _a214()
if _a212 ~= nil then return _a212 end
_a212 = false
local _a215 = {
_a6("Library", "Util", "GardenUpgradeCurve"),
_a6("Library", "Util", "GardenUpgradeBoosts"),
_a7.EventUpgradeCmds,
}
for _a216, _a217 in ipairs(_a215) do
if type(_a217) == "table" then
for _a218, _a219 in pairs(_a217) do
local _a220 = tostring(_a218):lower()
if type(_a219) == "function" and (_a220:find("cost") or _a220:find("price")) then
for _a221, _a222 in ipairs({
{ "GardenMoreDamage", 1 }, { "GardenMoreDamage", 2 },
{ 1 }, { 2 }, { "GardenMoreDamage" },
}) do
local _a223, _a224 = pcall(_a219, table.unpack(_a222))
if _a223 and type(_a224) == "number" and _a224 > 0 then
_a212 = _a219
_a213 = (#_a222 == 2) and "id_tier" or
(type(_a222[1]) == "number" and "tier" or "id")
return _a212
end
end
end
end
end
end
return _a212
end
local function _a225(_a226)
if _a226 == nil then return nil end
if type(_a226) == "number" then return _a226 end
if type(_a226) == "table" then
local _a227 = rawget(_a226, "_data")
if type(_a227) == "table" then
return tonumber(rawget(_a227, "_am")) or 1
end
end
local _a228, _a229 = pcall(function() return _a226:GetAmount() end)
if _a228 and type(_a229) == "number" then return _a229 end
return nil
end
local function _a230(_a231, _a232)
local _a233 = _a206()[_a231]
if type(_a233) == "table" then
for _a234, _a235 in ipairs({ "TierCosts", "Costs", "Prices", "TierPrices" }) do
local _a236 = rawget(_a233, _a235)
if type(_a236) == "table" then
local _a237 = _a225(_a236[(tonumber(_a232) or 0) + 1])
if _a237 then return _a237 end
end
end
end
local _a238 = _a214()
if _a238 then
local _a239 = (tonumber(_a232) or 0) + 1
local _a240
if _a213 == "id_tier" then _a240 = { { _a231, _a239 }, { _a231, _a232 } }
elseif _a213 == "tier" then _a240 = { { _a239 }, { _a232 } }
else _a240 = { { _a231 } } end
for _a241, _a242 in ipairs(_a240) do
local _a243, _a244 = pcall(_a238, table.unpack(_a242))
if _a243 and type(_a244) == "number" and _a244 > 0 then return _a244 end
end
end
return nil
end
local function _a245(_a246)
if _a7.EventUpgradeCmds and type(rawget(_a7.EventUpgradeCmds, "Purchase")) == "function" then
local _a247, _a248 = pcall(_a7.EventUpgradeCmds.Purchase, _a246)
if _a247 and _a248 ~= nil and _a248 ~= false then return true, _a248 end
if _a247 then return false, _a248 end
end
if _a9.R_EVUP then
local _a249
local _a250 = pcall(function() _a249 = _a9.R_EVUP:InvokeServer(_a246) end)
if _a250 then return (_a249 ~= nil and _a249 ~= false), _a249 end
end
return false, "호출 실패"
end
local function _a251()
if not (_a9.R_EVUP or _a7.EventUpgradeCmds) then _a4("[머신업글] API 없음") return end
local _a252, _a253 = 0, 0
while _a13.upgrade and _a252 < 40 do
_a252 += 1
local _a254 = _a192()
_a14.sun = _a254
local _a255 = _a198()
local _a256 = {}
for _a257, _a258 in ipairs(_a16) do
local _a259 = _a255[_a258] or 0
local _a260 = _a230(_a258, _a259)
_a256[#_a256 + 1] = { id = _a258, tier = _a259, cost = _a260 }
end
table.sort(_a256, function(_a261, _a262)
local _a263 = _a261.cost or math.huge
local _a264 = _a262.cost or math.huge
if _a263 == _a264 then return _a261.id < _a262.id end
return _a263 < _a264
end)
local _a265 = false
for _a266, _a267 in ipairs(_a256) do
if not _a13.upgrade then break end
local _a268 = _a267.cost and (_a254 - _a267.cost >= _a10.MinSunflowers)
if _a267.cost == nil then _a268 = _a10.BuyUnknownCost end
if _a268 then
local _a269 = _a254
local _a270, _a271 = _a245(_a267.id)
if _a270 then
_a253 += 1
_a14.upgraded += 1
_a265 = true
task.wait(0.4)
local _a272 = _a192()
_a4(("  ▲ %s  Lv%s → Lv%s   비용 %s   잔액 %s"):format(
_a267.id, tostring(_a267.tier), tostring(_a267.tier + 1),
_a5(_a269 - _a272, 0), _a5(_a272, 0)))
break
end
end
end
if not _a265 then break end
end
local _a273 = _a192()
_a14.sun = _a273
local _a274 = _a198()
if _a253 > 0 then
_a4(("[머신업글] %d건 구매 / 잔액 %s"):format(_a253, _a5(_a273, 0)))
else
local _a275, _a276 = math.huge, nil
for _a277, _a278 in ipairs(_a16) do
local _a279 = _a230(_a278, _a274[_a278] or 0)
if _a279 and _a279 < _a275 then _a275, _a276 = _a279, _a278 end
end
if _a276 then
_a4(("[머신업글] 살 수 있는 게 없음 — 잔액 %s / 최저 %s (%s)")
:format(_a5(_a273, 0), _a5(_a275, 0), _a276))
else
_a4("[머신업글] 구매 실패 (비용표를 못 읽음)")
end
end
end
local _a280, _a281
local function _a282()
if _a280 then return _a280 end
_a280 = {}
local _a283 = _a2:FindFirstChild("__DIRECTORY")
_a283 = _a283 and _a283:FindFirstChild("CropSeeds")
if _a283 then
for _a284, _a285 in ipairs(_a283:GetDescendants()) do
if _a285:IsA("ModuleScript") then
local _a286, _a287 = pcall(require, _a285)
if _a286 and type(_a287) == "table" then _a280[rawget(_a287, "_id") or _a285.Name] = _a287 end
end
end
end
return _a280
end
local function _a288()
if _a281 then return _a281 end
_a281 = {}
local _a289 = _a2:FindFirstChild("__DIRECTORY")
_a289 = _a289 and _a289:FindFirstChild("GardenCrops")
if _a289 then
for _a290, _a291 in ipairs(_a289:GetDescendants()) do
if _a291:IsA("ModuleScript") then
local _a292, _a293 = pcall(require, _a291)
if _a292 and type(_a293) == "table" then _a281[rawget(_a293, "_id") or _a291.Name] = _a293 end
end
end
end
return _a281
end
local function _a294(_a295)
local _a296 = _a288()[_a295]
return _a296 and tonumber(rawget(_a296, "CoinsPerSec")) or 0
end
local _a297 = {}
local function _a298(_a299)
if _a297[_a299] then return _a297[_a299] end
local _a300 = _a282()[_a299]
local _a301 = _a300 and rawget(_a300, "SpeciesWeights")
local _a302, _a303 = 0, 0
if type(_a301) == "table" then
for _a304, _a305 in pairs(_a301) do
local _a306 = tonumber(_a305) or 0
_a302 += _a306
_a303 += _a306 * _a294(_a304)
end
end
local _a307 = (_a302 > 0) and (_a303 / _a302) or 0
_a297[_a299] = _a307
return _a307
end
local function _a308()
local _a309 = {}
if not _a7.Save then return _a309 end
local _a310, _a311 = pcall(_a7.Save.Get)
if not _a310 or type(_a311) ~= "table" then return _a309 end
local _a312 = _a311.Inventory and _a311.Inventory.CropSeed
if type(_a312) ~= "table" then return _a309 end
for _a313, _a314 in pairs(_a312) do
if type(_a314) == "table" then
local _a315 = tonumber(rawget(_a314, "_am")) or 1
if _a315 > 0 then
_a309[#_a309 + 1] = {
uid = _a313, id = rawget(_a314, "id"), vr = rawget(_a314, "vr"),
am = _a315, exp = _a298(rawget(_a314, "id")),
}
end
end
end
table.sort(_a309, function(_a316, _a317)
if (_a316.exp or 0) == (_a317.exp or 0) then return (_a316.am or 0) > (_a317.am or 0) end
return (_a316.exp or 0) > (_a317.exp or 0)
end)
return _a309
end
local function _a318(_a319)
if not _a319 then return {} end
local _a320
pcall(function() _a320 = _a319:Save("PvC_Beds") end)
return type(_a320) == "table" and _a320 or {}
end
local function _a321(_a322, _a323)
if not (_a7.GardenPlots and _a322) then return true end
local _a324, _a325 = pcall(_a7.GardenPlots.IsBedUnlocked, _a322, _a323)
if _a324 then return _a325 and true or false end
return true
end
local function _a326(_a327)
if not (_a7.PvCropGrowth and type(_a327) == "table") then return false end
local _a328, _a329 = pcall(_a7.PvCropGrowth.IsUnhatched, _a327)
return _a328 and _a329 and true or false
end
local function _a330(_a331)
if type(_a331) ~= "table" then return nil end
local _a332 = tonumber(rawget(_a331, "cps"))
if _a332 then return _a332 end
local _a333 = rawget(_a331, "sp")
if _a333 then return _a294(_a333) end
return nil
end
local function _a334()
local _a335, _a336 = _a64()
if not _a336 then _a4("[씨앗] 밭 없음") return end
local _a337 = _a318(_a336)
local _a338 = _a308()
if #_a338 == 0 then _a4("[씨앗] 인벤에 씨앗 없음") return end
local _a339, _a340 = {}, {}
for _a341 in pairs(_a337) do
if not _a340[tostring(_a341)] then _a340[tostring(_a341)] = true _a339[#_a339 + 1] = _a341 end
end
for _a342 = 1, 80 do
local _a343 = tostring(_a342)
if not _a340[_a343] and _a321(_a336, _a343) then _a340[_a343] = true _a339[#_a339 + 1] = _a343 end
end
local _a344, _a345, _a346, _a347 = 0, 0, 0, 0
local _a348 = 1
for _a349, _a350 in ipairs(_a339) do
if not _a13.crop then break end
local _a351 = _a338[_a348]
while _a351 and _a351.am <= 0 do
_a348 += 1
_a351 = _a338[_a348]
end
if not _a351 then break end
local _a352 = _a337[_a350]
local _a353 = _a330(_a352)
if _a352 == nil then
local _a354
pcall(function() _a354 = _a336:Invoke("SD_Insert", _a350, _a351.uid) end)
if _a354 ~= false then
_a345 += 1
_a14.replant += 1
_a351.am -= 1
_a4(("  ▸ 심기  칸%s  %s 씨앗 (기대 %s/s)"):format(tostring(_a350), tostring(_a351.id), _a5(_a351.exp)))
task.wait(_a10.ActionGap)
end
elseif _a10.SkipUnhatched and _a326(_a352) then
_a347 += 1
elseif _a353 and (_a351.exp or 0) > _a353 * _a10.CropMargin then
local _a355
pcall(function() _a355 = _a336:Invoke("SD_Purge", _a350) end)
if _a355 ~= false then
task.wait(0.4)
local _a356
pcall(function() _a356 = _a336:Invoke("SD_Insert", _a350, _a351.uid) end)
if _a356 ~= false then
_a344 += 1
_a14.replant += 1
_a351.am -= 1
_a4(("  ⇄ 갈아엎기  칸%s  %s(%s/s) → %s 씨앗(기대 %s/s)"):format(
tostring(_a350), tostring(rawget(_a352, "sp") or "?"), _a5(_a353),
tostring(_a351.id), _a5(_a351.exp)))
else
_a4("  ! 칸" .. tostring(_a350) .. " 파냈는데 심기 실패")
end
task.wait(_a10.ActionGap)
end
else
_a346 += 1
end
end
_a4(("[씨앗] 심기 %d / 갈아엎기 %d / 유지 %d / 성장중 %d")
:format(_a345, _a344, _a346, _a347))
end
local function _a357(_a358)
if _a15 and not _a358 then return _a15 end
if _a9.R_JC then
local _a359, _a360 = pcall(function() return _a9.R_JC:InvokeServer() end)
if _a359 and type(_a360) == "table" then _a15 = _a360 end
end
return _a15 or {}
end
local function _a361(_a362)
if not (_a7.GardenPlots and rawget(_a7.GardenPlots, "PlotCost")) then return nil end
local _a363, _a364 = pcall(_a7.GardenPlots.PlotCost, tonumber(_a362))
return (_a363 and type(_a364) == "number") and _a364 or nil
end
local function _a365(_a366)
local _a367 = {}
if not _a366 then return _a367 end
for _a368 = 1, _a10.MaxBedScan do
local _a369 = tostring(_a368)
if not _a321(_a366, _a369) then
_a367[#_a367 + 1] = { id = _a369, n = _a368, cost = _a361(_a368) }
end
end
table.sort(_a367, function(_a370, _a371)
return (_a370.cost or math.huge) < (_a371.cost or math.huge)
end)
return _a367
end
local function _a372()
local _a373, _a374, _a375, _a376 = _a64()
if not _a374 then _a4("[확장] 밭 없음") return end
local _a377, _a378 = 0, 0
local _a379 = _a192()
local _a380 = _a357(true)
local _a381 = 0
while _a13.expand and _a381 < 12 do
_a381 += 1
local _a382 = (tonumber(_a376) or 0) + 1
local _a383 = tonumber(_a380[_a382]) or tonumber(_a380[tostring(_a382)])
if _a383 and (_a379 - _a383) < _a10.MinSunflowers then
_a4(("[확장] 레인%d 비용 %s / 잔액 %s — 부족"):format(_a382, _a5(_a383, 0), _a5(_a379, 0)))
break
end
if not _a383 and not _a10.BuyUnknownCost then
_a4("[확장] 레인" .. _a382 .. " 비용을 못 읽음 — 건너뜀")
break
end
if not _a9.R_WIDEN then break end
local _a384 = _a379
local _a385, _a386, _a387
pcall(function() _a385, _a386, _a387 = _a9.R_WIDEN:InvokeServer() end)
task.wait(0.5)
_a379 = _a192()
if _a385 then
_a377 += 1
_a378 += (_a384 - _a379)
_a376 = tonumber(_a387) or (_a376 + 1)
_a4(("  ▣ 레인 오픈 → %s개   비용 %s   잔액 %s"):format(
tostring(_a376), _a5(_a384 - _a379, 0), _a5(_a379, 0)))
task.wait(_a10.ActionGap)
else
if _a386 then _a4("[확장] 레인 실패: " .. tostring(_a386)) end
break
end
end
local _a388 = _a365(_a374)
for _a389, _a390 in ipairs(_a388) do
if not _a13.expand then break end
if _a390.cost and (_a379 - _a390.cost) < _a10.MinSunflowers then break end
if not _a390.cost and not _a10.BuyUnknownCost then break end
local _a391 = _a379
local _a392
pcall(function() _a392 = _a374:Invoke("BD_Acquire", _a390.id) end)
task.wait(0.4)
_a379 = _a192()
if _a392 ~= false and _a379 < _a391 then
_a377 += 1
_a378 += (_a391 - _a379)
_a4(("  ▣ 밭칸 %s 오픈   비용 %s   잔액 %s"):format(
_a390.id, _a5(_a391 - _a379, 0), _a5(_a379, 0)))
task.wait(_a10.ActionGap)
else
break
end
end
_a14.sun = _a379
if _a377 > 0 then
_a4(("[확장] %d개 오픈 / 총 %s 소비"):format(_a377, _a5(_a378, 0)))
else
local _a393 = (tonumber(_a376) or 0) + 1
local _a394 = _a380[_a393] or _a380[tostring(_a393)]
local _a395 = _a388[1]
_a4(("[확장] 오픈할 것 없음 — 잔액 %s / 다음 레인%d %s / 다음 밭칸 %s"):format(
_a5(_a379, 0), _a393, _a394 and _a5(_a394, 0) or "?",
_a395 and (_a395.id .. " " .. (_a395.cost and _a5(_a395.cost, 0) or "?")) or "없음"))
end
end
local function _a396()
local _a397, _a398 = _a64()
if not _a398 then return nil end
local function _a399(_a400)
local _a401
pcall(function() _a401 = _a398:Save(_a400) end)
return _a401
end
local _a402 = tonumber(_a399("PvC_Regrows")) or 0
local _a403   = tonumber(_a399("PvC_UnlockedLanes")) or 1
local _a404   = tonumber(_a399("PvC_RunBossKills")) or 0
local _a405     = _a8("PvC_RegrowCap") or math.huge
local _a406    = _a8("PvC_RegrowBossBase") or 1
local _a407    = _a8("PvC_RegrowBossStep") or 1
local _a408  = math.min(_a402, _a405)
local _a409    = math.ceil(_a406 * (_a407 ^ _a408))
local _a410   = (_a405 <= _a408)
return {
regrows = _a402, lanes = _a403, kills = _a404, need = _a409,
cap = _a405, maxed = _a410,
ready = (not _a410) and _a403 >= 7 and _a404 >= _a409,
reason = _a410 and "최대 리버스 도달"
or (_a403 < 7 and ("레인 %d/7"):format(_a403))
or (_a404 < _a409 and ("코인보스 %d/%d"):format(_a404, _a409))
or nil,
}
end
local function _a411()
if not _a9.R_WK then _a4("[리버스] WK_Reclaim 리모트 없음") return end
local _a412 = _a396()
if not _a412 then _a4("[리버스] 밭 없음") return end
if not _a412.ready then
_a4(("[리버스] 대기 — %s   (리버스 %d회)"):format(tostring(_a412.reason), _a412.regrows))
return
end
_a4(("[리버스] 조건 충족 (레인 %d, 보스 %d/%d) — 실행"):format(_a412.lanes, _a412.kills, _a412.need))
local _a413, _a414, _a415
pcall(function() _a413, _a414, _a415 = _a9.R_WK:InvokeServer() end)
task.wait(1.5)
if _a413 then
_a14.sun = _a192()
_a15 = nil
_a4(("  ★ 리버스 성공 → %s회   (레인/밭칸/작물 초기화됨)"):format(tostring(_a415 or (_a412.regrows + 1))))
_a4("  자동 확장이 켜져 있으면 레인/밭칸을 다시 엽니다")
else
_a4("  ✗ 리버스 실패: " .. tostring(_a414))
end
end
local _a416 = _a6("Library", "Util", "GardenEggs")
local _a417    = _a6("Library", "Directory", "Eggs")
local _a418= _a6("Library", "Balancing", "CalcEggPricePlayer")
local _a419  = _a6("Library", "Balancing", "CalcEggPrice")
local function _a420()
if _a10.HatchEggNum and _a10.HatchEggNum >= 1 then
return math.floor(_a10.HatchEggNum)
end
local _a421, _a422 = _a64()
if _a416 and rawget(_a416, "CurrentEggNum") then
local _a423, _a424 = pcall(_a416.CurrentEggNum, _a422)
if _a423 and tonumber(_a424) then return math.floor(tonumber(_a424)) end
end
if _a7.EventUpgradeCmds and rawget(_a7.EventUpgradeCmds, "GetPower") then
local _a425, _a426 = pcall(_a7.EventUpgradeCmds.GetPower, "GardenBetterEggs")
if _a425 and tonumber(_a426) then return math.clamp(1 + math.floor(tonumber(_a426)), 1, 12) end
end
return 1
end
local function _a427(_a428)
return ("Garden Egg %d"):format(_a428 or _a420())
end
local function _a429(_a430)
if type(_a417) == "table" then
local _a431 = rawget(_a417, _a430)
if _a431 then return _a431 end
end
local _a432 = _a2:FindFirstChild("__DIRECTORY")
_a432 = _a432 and _a432:FindFirstChild("Eggs")
if _a432 then
for _a433, _a434 in ipairs(_a432:GetDescendants()) do
if _a434:IsA("ModuleScript") then
local _a435, _a436 = pcall(require, _a434)
if _a435 and type(_a436) == "table" and rawget(_a436, "_id") == _a430 then return _a436 end
end
end
end
return nil
end
table.clear(_a12)
local function _a437(_a438)
if _a12[_a438] then return _a12[_a438] end
local _a439 = _a429(_a438)
if not _a439 then return nil end
for _a440, _a441 in ipairs({ _a418, _a419 }) do
if type(_a441) == "function" then
local _a442, _a443 = pcall(_a441, _a439)
if _a442 and tonumber(_a443) and tonumber(_a443) > 0 then
_a12[_a438] = tonumber(_a443)
return _a12[_a438]
end
end
end
local _a444 = tonumber(rawget(_a439, "overrideCost"))
if _a444 then
local _a445 = _a8("PvC_EggCostMult")
if not _a445 or _a445 <= 0 then _a445 = 1 end
local _a446 = math.max(1, math.round(_a444 * _a445))
_a12[_a438] = _a446
return _a446
end
return nil
end
local _a447 = _a6("Library", "Client", "CustomEggsCmds")
local function _a448()
local _a449 = {}
local _a450 = workspace:FindFirstChild("__THINGS")
_a450 = _a450 and _a450:FindFirstChild("CustomEggs")
if not _a450 then return _a449 end
local _a451 = _a3.Character and _a3.Character:FindFirstChild("HumanoidRootPart")
for _a452, _a453 in ipairs(_a450:GetChildren()) do
local _a454
pcall(function()
if _a453:IsA("Model") then _a454 = _a453:GetPivot().Position
elseif _a453:IsA("BasePart") then _a454 = _a453.Position end
end)
_a449[#_a449 + 1] = {
uid = _a453.Name, inst = _a453,
dist = (_a454 and _a451) and (_a454 - _a451.Position).Magnitude or math.huge,
}
end
table.sort(_a449, function(_a455, _a456) return _a455.dist < _a456.dist end)
return _a449
end
local function _a457()
if _a10.HatchUid and _a10.HatchUid ~= "" then return _a10.HatchUid end
local _a458 = _a448()
return _a458[1] and _a458[1].uid or nil
end
local function _a459()
if type(_a447) == "table" then
local _a460 = rawget(_a447, "GetMaxEggCount")
if type(_a460) == "function" then
local _a461, _a462 = pcall(_a460)
if _a461 and tonumber(_a462) and tonumber(_a462) >= 1 then return math.floor(tonumber(_a462)) end
end
end
return _a10.HatchMax
end
local function _a463()
local _a464 = _a420()
local _a465 = _a427(_a464)
local _a466 = _a437(_a465)
local _a467 = _a192()
local _a468 = math.max(0, _a467 - (_a10.HatchReserve or 0))
local _a469 = _a448()
return {
num = _a464, id = _a465, cost = _a466, sun = _a467,
uid = _a457(), eggCount = #_a469, eggs = _a469,
canBuy = (_a466 and _a466 > 0) and math.floor(_a468 / _a466) or 0,
}
end
local function _a470()
if not _a9.R_CEGG then _a4("[뽑기] CustomEggs_Hatch 리모트 없음") return end
local _a471 = _a463()
_a14.sun = _a471.sun
if not _a471.uid then
_a4("[뽑기] 알을 못 찾음 — 알 근처로 가주세요 (workspace.__THINGS.CustomEggs 비어있음)")
return
end
if not _a471.cost then
_a4("[뽑기] " .. _a471.id .. " 비용을 못 읽음")
return
end
if _a471.canBuy < 1 then
return
end
local _a472 = math.min(_a10.HatchMax, _a459())
local _a473, _a474 = 0, 0
local _a475 = math.min(_a471.canBuy, _a472)
while _a13.hatch and _a475 >= 1 and _a474 < 20 do
_a474 += 1
local _a476, _a477
pcall(function() _a476, _a477 = _a9.R_CEGG:InvokeServer(_a471.uid, _a475) end)
if _a476 then
_a473 += _a475
_a14.hatched += _a475
task.wait(0.4)
local _a478 = _a192()
_a14.sun = _a478
local _a479 = math.max(0, _a478 - (_a10.HatchReserve or 0))
local _a480 = math.floor(_a479 / _a471.cost)
if _a480 < 1 then break end
_a475 = math.min(_a480, _a472)
else
local _a481 = tostring(_a477)
if _a481:find("quickly") then
task.wait(2.5)
elseif _a475 > 1 then
_a475 = math.floor(_a475 / 2)
else
if _a477 then _a4("[뽑기] 실패: " .. _a481) end
break
end
end
end
if _a473 > 0 then
_a4(("[뽑기] %s × %d   (개당 %s)   잔액 %s"):format(
_a471.id, _a473, _a5(_a471.cost, 0), _a5(_a192(), 0)))
end
end
local _a482 = _a6("Library", "Client", "GardenChanceMachineCmds")
local _a483 = _a6("Library", "Types", "GardenChanceMachine")
local _a484 = { "Huge", "Titanic", "Gargantuan" }
local function _a485()
if _a482 and rawget(_a482, "GetMaxBoostSeconds") then
local _a486, _a487 = pcall(_a482.GetMaxBoostSeconds)
if _a486 and tonumber(_a487) then return tonumber(_a487) end
end
return (_a483 and tonumber(rawget(_a483, "MaxSecondsDefault"))) or 21600
end
local function _a488(_a489)
if _a482 and rawget(_a482, "GetPerTokenSecondsForBoost") then
local _a490, _a491 = pcall(_a482.GetPerTokenSecondsForBoost, _a489)
if _a490 and tonumber(_a491) and tonumber(_a491) > 0 then return tonumber(_a491) end
end
local _a492 = (_a483 and _a483.TokensToMaxDefault
and tonumber(_a483.TokensToMaxDefault[_a489])) or 5000
return _a485() / _a492
end
local function _a493(_a494)
if _a482 and rawget(_a482, "GetBoostTime") then
local _a495, _a496 = pcall(_a482.GetBoostTime, _a494)
if _a495 and tonumber(_a496) then return tonumber(_a496) end
end
return 0
end
local function _a497()
if _a482 and rawget(_a482, "IsEnabled") then
local _a498, _a499 = pcall(_a482.IsEnabled)
if _a498 then return _a499 and true or false end
end
return true
end
local function _a500()
local _a501 = _a485()
local _a502 = {}
for _a503, _a504 in ipairs(_a484) do
local _a505 = _a493(_a504)
local _a506 = _a488(_a504)
local _a507 = math.max(0, _a501 - _a505)
_a502[#_a502 + 1] = {
rarity = _a504, left = _a505, per = _a506, deficit = _a507,
need = (_a506 > 0) and math.ceil(_a507 / _a506) or 0,
on = _a10.LuckBoosts[_a504] and true or false,
}
end
return { maxSec = _a501, rows = _a502, enabled = _a497(), sun = _a192() }
end
local function _a508(_a509)
_a509 = math.max(0, math.floor(tonumber(_a509) or 0))
local _a510 = math.floor(_a509 / 3600)
local _a511 = math.floor((_a509 % 3600) / 60)
return ("%d시간 %d분"):format(_a510, _a511)
end
local function _a512()
if not _a9.R_LUCK then _a4("[럭] GardenChanceMachine_AddTime 리모트 없음") return end
if not _a497() then _a4("[럭] 이 서버에서 비활성") return end
local _a513 = _a500()
_a14.sun = _a513.sun
local _a514 = _a513.sun
local _a515 = 0
for _a516, _a517 in ipairs(_a513.rows) do
if not _a13.luck then break end
if _a517.on and _a517.deficit >= _a10.LuckMinTopUp and _a517.need >= 1 then
local _a518 = math.max(0, _a514 - _a10.LuckReserve)
local _a519 = math.min(_a517.need, math.floor(_a518))
if _a519 >= 1 then
local _a520 = _a514
local _a521, _a522
pcall(function()
_a521, _a522 = _a9.R_LUCK:InvokeServer(_a517.rarity, "Slot1", _a519)
end)
task.wait(0.4)
_a514 = _a192()
_a14.sun = _a514
if _a521 then
_a515 += 1
_a14.luck += 1
_a4(("  ✦ 럭 %s  +%s  (%s → %s)  비용 %s"):format(
_a517.rarity, _a508(_a519 * _a517.per),
_a508(_a517.left), _a508(math.min(_a513.maxSec, _a517.left + _a519 * _a517.per)),
_a5(_a520 - _a514, 0)))
else
_a4(("  ✗ 럭 %s 실패: %s"):format(_a517.rarity, tostring(_a522)))
end
task.wait(_a10.ActionGap)
end
end
end
if _a515 == 0 then
local _a523 = {}
for _a524, _a525 in ipairs(_a513.rows) do
if _a525.on then
_a523[#_a523 + 1] = ("%s %s"):format(_a525.rarity, _a508(_a525.left))
end
end
if #_a523 > 0 then
_a4("[럭] 유지 중 — " .. table.concat(_a523, " / "))
end
end
end
_a1.EVENT_UPGRADES, _a1.ctx, _a1.collectSlots, _a1.placedTowers, _a1.availableItems, _a1.cyclePlace = _a16, _a64, _a71, _a90, _a104, _a145
_a1.cycleMerchant, _a1.sunflowers, _a1.eventTiers, _a1.nextCost, _a1.cycleUpgrade, _a1.seedInv = _a187, _a192, _a198, _a230, _a251, _a308
_a1.bedsOf, _a1.isUnhatched, _a1.bedCps, _a1.cycleCrop, _a1.laneCosts, _a1.lockedBeds = _a318, _a326, _a330, _a334, _a357, _a365
_a1.cycleExpand, _a1.rebirthStatus, _a1.cycleRebirth, _a1.eggCost, _a1.hatchStatus, _a1.cycleHatch = _a372, _a396, _a411, _a437, _a463, _a470
_a1.LUCK_ORDER, _a1.luckStatus, _a1.fmtDur, _a1.cycleLuck = _a484, _a500, _a508, _a512
end
