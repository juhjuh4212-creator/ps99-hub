local _a1 = {}
local _a2  = game:GetService("ReplicatedStorage")
local _a3 = game:GetService("UserInputService")
local _a4 = game:GetService("RunService")
local _a5 = game:GetService("Players").LocalPlayer
if not _a5 then
local _a6 = os.clock()
repeat
task.wait(0.1)
_a5 = game:GetService("Players").LocalPlayer
until _a5 or (os.clock() - _a6) > 10
_a1.lpWait = os.clock() - _a6
_a1.lpFail = (_a5 == nil)
end
do
local _a7 = os.clock()
for _a8, _a9 in ipairs({ "Library", "Network" }) do
local _a10 = pcall(function() _a2:WaitForChild(_a9, 30) end)
if not _a10 or not _a2:FindFirstChild(_a9) then
_a1.libFail = (_a1.libFail and (_a1.libFail .. ", ") or "") .. _a9
end
end
local _a11 = os.clock() - _a7
if _a11 > 0.2 then _a1.libWait = _a11 end
end
if _G.__PS99_GARDEN then pcall(_G.__PS99_GARDEN) end
local _a12, _a13 = {}, 3000
local function _a14(_a15)
_a12[#_a12 + 1] = tostring(_a15)
if #_a12 > _a13 then table.remove(_a12, 1) end
_a1.dirty = true
end
local function _a16(_a17, _a18)
if type(_a17) ~= "number" then return tostring(_a17) end
if _a17 ~= _a17 then return "0" end
return string.format("%." .. (_a18 or 1) .. "f", _a17)
end
local function _a19(...)
local _a20 = _a2
for _a21, _a22 in ipairs({ ... }) do
if not _a20 then return nil end
local _a23 = _a20:FindFirstChild(_a22)
if not _a23 then
local _a24, _a25 = pcall(function() return _a20:WaitForChild(_a22, 2) end)
_a23 = _a24 and _a25 or nil
end
_a20 = _a23
end
if not _a20 then return nil end
local _a26, _a27 = pcall(require, _a20)
return _a26 and _a27 or nil
end
local _a28 = {
EntityPlacement = _a19("Library", "Client", "PvCombatCmds", "EntityPlacement"),
ClientTowerDefense = _a19("Library", "Client", "PvCombatCmds", "ClientTowerDefense"),
ClientPlot = _a19("Library", "Client", "PlotCmds", "ClientPlot"),
LaneUnlock = _a19("Library", "Client", "PvCombatCmds", "LaneUnlock"),
ClientTower = _a19("Library", "Client", "PvCombatCmds", "ClientTowerDefense", "EntityRegistry", "ClientTower"),
GardenLaneFacing = _a19("Library", "Util", "GardenLaneFacing"),
GardenDefenders = _a19("Library", "Util", "GardenDefenders"),
TowerItem = _a19("Library", "Items", "TowerItem"),
Save = _a19("Library", "Client", "Save"),
EventUpgradeCmds = _a19("Library", "Client", "EventUpgradeCmds"),
GardenPlots = _a19("Library", "Util", "GardenPlots"),
PvCropGrowth = _a19("Library", "PvCropGrowth"),
FFlagsM = _a19("Library", "Universal", "FFlags"),
}
local function _a29(_a30)
if type(_a28.FFlagsM) ~= "table" then return nil end
local _a31 = rawget(_a28.FFlagsM, "Keys")
local _a32 = _a31 and _a31[_a30]
if _a32 == nil then return nil end
local _a33, _a34 = pcall(_a28.FFlagsM.GetNumber, _a32)
return _a33 and tonumber(_a34) or nil
end
local _a35      = _a2:WaitForChild("Network")
local _a36 = {
R_ATTACH = _a35:FindFirstChild("WD_Attach"),
R_DETACH = _a35:FindFirstChild("OR_Detach"),
R_PROMO = _a35:FindFirstChild("EK_Promote"),
R_BUY = _a35:FindFirstChild("Merchant_RequestPurchase"),
R_EVUP = _a35:FindFirstChild("EventUpgrades: Purchase"),
R_WIDEN = _a35:FindFirstChild("PG_Widen"),
R_JC = _a35:FindFirstChild("JC_Manifest"),
R_WK = _a35:FindFirstChild("WK_Reclaim"),
R_EGG = _a35:FindFirstChild("Eggs_RequestPurchase"),
R_CEGG = _a35:FindFirstChild("CustomEggs_Hatch"),
R_LUCK = _a35:FindFirstChild("GardenChanceMachine_AddTime"),
}
if not (_a28.EntityPlacement and _a28.ClientTowerDefense and _a28.ClientPlot and _a28.GardenLaneFacing and _a28.TowerItem and _a36.R_ATTACH) then
warn("[PS99 Garden] 필수 모듈 로드 실패 — Garden 이벤트 안에서 실행해 주세요")
end
local _a37 = {
PlaceInterval    = 15,
MerchantInterval = 20,
UpgradeInterval  = 15,
MerchantId       = "FarmingMerchant",
MerchantSlots    = 6,
SwapMargin       = 1.0,
ProtectUpgraded  = false,
DotFactor        = 1.0,
ActionGap        = 0.1,
}
local _a38 = { Shiny = 1.5, Gold = 2, Rainbow = 4 }
local _a39 = {}
local _a40 = { place = false, merchant = false, upgrade = false, towerup = false,
crop = false, expand = false, rebirth = false, hatch = false, luck = false,
farm = false, zone = false, mhatch = false, rank = false, mreb = false,
quest = false, mapupg = false, items = false, slots = false,
auto = true, petspd = true, rewatch = true }
local _a41 = { slots = 0, filled = 0, empty = 0, placed = 0, swapped = 0, bought = 0,
upgraded = 0, sun = 0, replant = 0, hatched = 0, luck = 0,
farm = 0, zone = 0, mhatch = 0, rank = 0, mreb = 0,
quest = 0, potup = 0, potuse = 0, mapupg = 0, items = 0, mslot = 0 }
_a37.CropInterval = 20
_a37.CropMargin   = 1.5
_a37.SkipUnhatched = true
_a37.MinSunflowers  = 0
_a37.BuyUnknownCost = false
_a37.ExpandInterval  = 20
_a37.RebirthInterval = 30
_a37.HatchInterval = 5
_a37.HatchMax      = 100
_a37.HatchReserve  = 0
_a37.HatchEggNum   = 0
_a37.HatchUid      = ""
_a37.LuckInterval  = 3600
_a37.LuckReserve   = 0
_a37.LuckMinTopUp  = 600
_a37.LuckBoosts    = { Huge = true, Titanic = true, Gargantuan = true }
_a37.FarmInterval        = 10
_a37.ZoneInterval        = 10
_a37.MainHatchInterval   = 1
_a37.MainHatchMax        = 100
_a37.MainHatchReserve    = 0
_a37.MainEggId           = ""
_a37.RankInterval        = 30
_a37.MainRebirthInterval = 60
_a37.MainRebirthVerbose  = false
_a37.MaxBedScan     = 80
_a37.QuestInterval  = 10
_a37.QuestUpgrade   = true
_a37.QuestUsePotion = true
_a37.QuestDrive     = true
_a37.QuestUseMax    = 20
_a37.EggRange       = 40
_a37.QuestTp        = true
_a37.TpMode     = "instant"
_a37.TpSpeed    = 160
_a37.TpHeight   = 0
_a37.ArriveDist = 12
_a37.ZoneArriveDist = 90
_a37.QuestLock  = true
_a37.SpawnPerCycle = 1
_a37.EventStayDist = 45
_a37.AutoInterval = 5
_a37.HoldZoneForQuest = true
_a37.HatchBudget  = 25
_a37.ScreenTryMax   = 8
_a37.ScreenRealClick = true
_a37.PursueStallSec = 60
_a37.HatchMinAfford = 10
_a37.MoneyDwell     = 60
_a37.IdleHatch      = false
_a37.PetSpeedMult = 50
_a37.PetSpeedBase = 4
_a37.TpGameFallback = false
_a37.TpCooldown = 2.5
_a37.HatchAutoTp = true
_a37.AutoUnlockEgg = true
_a37.UseAutoHatch  = true
_a37.HatchClick    = true
_a37.HatchClickAfter = 0.6
_a37.TpToBreakables = true
_a37.UpgInterval  = 30
_a37.UpgReserve   = 0
_a37.UpgTp        = true
_a37.SlotInterval = 30
_a37.SlotReserve  = 0
_a37.SlotPet      = true
_a37.SlotEgg      = true
_a37.ItemInterval  = 20
_a37.BuffPotion    = true
_a37.BuffFruit     = true
_a37.BuffUltimate  = true
_a37.BuffConsumable = false
_a37.BuffHighTier  = true
_a37.ItemKeep      = 0
_a37.ItemAllow     = ""
_a37.ItemBlock     = "Rain, Sunlight"
_a37.ItemBestZone  = true
_a37.ItemTp        = false
_a37.BuffMaxPotion = 5
_a37.BuffMaxOther  = 2
_a1.RS, _a1.UIS, _a1.RunService, _a1.LP, _a1.LOG, _a1.log = _a2, _a3, _a4, _a5, _a12, _a14
_a1.num, _a1.req, _a1.LB, _a1.ff, _a1.NET, _a1.RM = _a16, _a19, _a28, _a29, _a35, _a36
_a1.CFG, _a1.VARIANT, _a1.EGG_COST_CACHE, _a1.RUN, _a1.STAT = _a37, _a38, _a39, _a40, _a41
;(function(_a42)
local _a43, _a44, _a45, _a46, _a47, _a48 = _a42.RS, _a42.LP, _a42.log, _a42.num, _a42.req, _a42.LB
local _a49, _a50, _a51, _a52, _a53, _a54 = _a42.ff, _a42.RM, _a42.CFG, _a42.VARIANT, _a42.EGG_COST_CACHE, _a42.RUN
local _a55 = _a42.STAT
local _a56
local _a57 = {
"GardenMoreDamage", "GardenFasterAttacks", "GardenMoreCoins",
"GardenBetterEggs", "GardenBetterLuck", "GardenBiggerHarvest",
"GardenFasterCrops", "GardenMoreSeeds",
}
local _a58
local function _a59()
if _a58 then return _a58 end
_a58 = {}
local _a60 = _a43:FindFirstChild("__DIRECTORY")
_a60 = _a60 and _a60:FindFirstChild("TowerDefenseTowers")
if _a60 then
for _a61, _a62 in ipairs(_a60:GetDescendants()) do
if _a62:IsA("ModuleScript") then
local _a63, _a64 = pcall(require, _a62)
if _a63 and type(_a64) == "table" then _a58[rawget(_a64, "_id") or _a62.Name] = _a64 end
end
end
end
return _a58
end
local function _a65(_a66, _a67, _a68)
local _a69 = _a59()[_a66]
if type(_a69) ~= "table" then return 0 end
local _a70 = tonumber(rawget(_a69, "AttackDamage")) or 0
local _a71 = tonumber(rawget(_a69, "AttackSpeed")) or 0
local _a72, _a73 = _a70 * _a71, 0
local _a74 = rawget(_a69, "Projectile")
if type(_a74) == "table" then
local _a75 = rawget(_a74, "ApplyDots")
if type(_a75) == "table" then
for _a76, _a77 in pairs(_a75) do
if type(_a77) == "table" then
local _a78  = tonumber(rawget(_a77, "Duration")) or 0
local _a79 = tonumber(rawget(_a77, "TickDelta")) or 0
local _a80  = tonumber(rawget(_a77, "DamageMult")) or 1
local _a81   = tonumber(rawget(_a77, "Probability")) or 1
if _a79 > 0 and _a78 > 0 and _a71 > 0 then
_a73 += (_a70 * _a80 * _a81 / _a79) * math.min(1, _a78 * _a71) * _a51.DotFactor
end
end
end
end
local _a82 = tonumber(rawget(_a74, "LingerDuration")) or 0
if _a82 > 0 and _a71 > 0 then _a73 += _a72 * math.min(1, _a82 * _a71) * 0.5 * _a51.DotFactor end
end
local _a83 = (_a72 + _a73) * (_a52[_a67 or ""] or 1)
return (_a83 ~= _a83) and 0 or _a83
end
local function _a84(_a85, _a86)
if type(_a85) ~= "string" then return nil end
return string.match(_a85, '"' .. _a86 .. '"%s*:%s*"([^"]*)"')
end
local function _a87(_a88)
if type(_a88) ~= "table" and typeof(_a88) ~= "userdata" then return nil, nil end
local _a89, _a90
pcall(function() _a89 = rawget(_a88, "_stackKey") end)
pcall(function() _a90 = rawget(_a88, "_exactStackKey") end)
if not _a89 then pcall(function() _a89 = _a88._stackKey end) end
if not _a90 then pcall(function() _a90 = _a88._exactStackKey end) end
local _a91 = _a84(_a89, "id") or _a84(_a90, "id")
local _a92 = _a84(_a89, "vr") or _a84(_a90, "vr")
return _a91, _a92
end
local function _a93(_a94)
local _a95
if _a48.GardenDefenders and _a48.GardenDefenders.UnitKey then
pcall(function() _a95 = _a48.GardenDefenders.UnitKey(_a94) end)
end
if _a95 ~= nil then return tostring(_a95) end
local _a96, _a97 = _a87(_a94)
return tostring(_a96) .. "|" .. tostring(_a97 or "")
end
local function _a98()
local _a99 = {}
if not _a48.Save then return _a99 end
local _a100, _a101 = pcall(_a48.Save.Get)
if not _a100 or type(_a101) ~= "table" then return _a99 end
local _a102 = _a101.Inventory and _a101.Inventory.Tower
if type(_a102) ~= "table" then return _a99 end
for _a103, _a104 in pairs(_a102) do
if type(_a104) == "table" then _a99[_a103] = { id = _a104.id, vr = _a104.vr } end
end
return _a99
end
local function _a105()
local _a106, _a107
pcall(function()
_a106 = _a48.ClientTowerDefense and _a48.ClientTowerDefense.GetLocal and _a48.ClientTowerDefense.GetLocal()
end)
pcall(function()
_a107 = _a48.ClientPlot and _a48.ClientPlot.GetLocal and _a48.ClientPlot.GetLocal()
end)
local _a108
if _a107 then pcall(function() _a108 = _a107:GetModel() end) end
local _a109 = 0
if _a48.LaneUnlock and _a107 then
local _a110, _a111 = pcall(_a48.LaneUnlock.UnlockedFor, _a107)
if _a110 then _a109 = tonumber(_a111) or 0 end
end
return _a106, _a107, _a108, _a109
end
local function _a112(_a113, _a114)
local _a115 = {}
local _a116 = _a113 and _a113:FindFirstChild("Lanes")
if not _a116 then return _a115 end
for _a117, _a118 in ipairs(_a116:GetChildren()) do
local _a119 = tonumber(_a118.Name)
if _a119 and _a119 <= _a114 then
local _a120 = _a118:FindFirstChild("Slots")
if _a120 then
for _a121, _a122 in ipairs(_a120:GetChildren()) do
if _a122:IsA("BasePart") then
_a115[#_a115 + 1] = {
part = _a122, lane = _a119,
pos = _a122.Position + Vector3.new(0, _a122.Size.Y / 2, 0),
}
end
end
end
end
end
return _a115
end
local function _a123(_a124)
local _a125
pcall(function() _a125 = _a124:GetUpgrade() end)
if type(_a125) == "number" then return _a125 end
pcall(function()
local _a126 = rawget(_a124, "State")
local _a127 = _a126 and rawget(_a126, "Upgrade")
_a125 = _a127 and rawget(_a127, "Value")
end)
return tonumber(_a125) or 0
end
local function _a128(_a129)
local _a130
pcall(function() _a130 = _a129:GetId() end)
if type(_a130) == "number" then return _a130 end
pcall(function() _a130 = rawget(_a129, "Id") end)
return tonumber(_a130)
end
local function _a131(_a132)
local _a133 = {}
if not (_a132 and _a48.ClientTower) then return _a133 end
local _a134
pcall(function() _a134 = _a48.ClientTower.All(_a132) end)
if type(_a134) ~= "table" then return _a133 end
local _a135 = _a98()
for _a136, _a137 in ipairs(_a134) do
local _a138, _a139, _a140
pcall(function() _a138 = _a137:GetItem() end)
pcall(function() _a139 = _a137:GetCFrame() end)
if _a138 then pcall(function() _a140 = _a138:GetOptionalUID() end) end
local _a141, _a142 = _a87(_a138)
if not _a141 then
local _a143 = _a135[_a140 or ""] or {}
_a141, _a142 = _a143.id, _a143.vr
end
local _a144 = _a123(_a137)
_a133[#_a133 + 1] = {
tower = _a137, item = _a138, uid = _a140, cf = _a139,
id = _a128(_a137), kind = _a141, vr = _a142, up = _a144,
dps = _a65(_a141, _a142, _a144),
}
end
return _a133
end
local function _a145()
local _a146 = {}
if not (_a48.TowerItem and _a48.EntityPlacement) then return _a146 end
local _a147
if not pcall(function() _a147 = _a48.TowerItem:All() end) or type(_a147) ~= "table" then return _a146 end
local _a148 = _a98()
local _a149 = {}
for _a150, _a151 in pairs(_a147) do
local _a152
pcall(function() _a152 = _a151:GetOptionalUID() end)
if _a152 then
local _a153 = _a93(_a151)
if not _a149[_a153] then
local _a154 = 0
pcall(function() _a154 = _a48.EntityPlacement.AvailableCopies(_a151) or 0 end)
if _a154 > 0 then
local _a155, _a156 = _a87(_a151)
if not _a155 then
local _a157 = _a148[_a152] or {}
_a155, _a156 = _a157.id, _a157.vr
end
_a149[_a153] = {
item = _a151, uid = _a152, key = _a153, id = _a155, vr = _a156,
copies = _a154, dps = _a65(_a155, _a156, 0),
}
else
_a149[_a153] = false
end
end
end
end
for _a158, _a159 in pairs(_a149) do
if _a159 then _a146[#_a146 + 1] = _a159 end
end
table.sort(_a146, function(_a160, _a161)
if (_a160.dps or 0) == (_a161.dps or 0) then return tostring(_a160.key) < tostring(_a161.key) end
return (_a160.dps or 0) > (_a161.dps or 0)
end)
return _a146
end
local function _a162(_a163)
local _a164
pcall(function() _a164 = _a48.GardenLaneFacing.ForSlot(_a163.pos, _a163.part) end)
return _a164
end
local function _a165(_a166, _a167)
local _a168 = _a162(_a166)
if not _a168 then return false end
local _a169 = false
pcall(function() _a169 = _a48.EntityPlacement.Validate(_a167, _a168) end)
return _a169 and true or false, _a168
end
local function _a170(_a171, _a172, _a173)
local _a174 = _a162(_a172)
if not _a174 then return false, "facing 실패" end
local _a175, _a176 = _a171.item, _a171.uid
if _a48.EntityPlacement and type(rawget(_a48.EntityPlacement, "FirstFreeCopy")) == "function" then
local _a177, _a178 = pcall(_a48.EntityPlacement.FirstFreeCopy, _a171.item)
if _a177 and _a178 then
_a175 = _a178
pcall(function() _a176 = _a178:GetUID() end)
end
end
if not _a176 then return false, "쓸 수 있는 스택 없음" end
local _a179 = _a173.CFrame:ToObjectSpace(_a174)
local _a180, _a181, _a182
if not pcall(function() _a180, _a181, _a182 = _a50.R_ATTACH:InvokeServer(_a176, _a179) end) then
return false, "호출 실패"
end
return _a180 and true or false, _a181, _a182
end
local function _a183(_a184)
if not (_a50.R_DETACH and _a184) then return false end
local _a185
pcall(function() _a185 = _a50.R_DETACH:InvokeServer(_a184) end)
return _a185 and true or false
end
local function _a186()
local _a187, _a188, _a189, _a190 = _a105()
if not (_a187 and _a189) then
_a45("[배치] 밭/월드 준비 안 됨 — Garden 안에 있는지 확인")
return
end
local _a191 = _a112(_a189, _a190)
_a55.slots = #_a191
if #_a191 == 0 then _a45("[배치] 슬롯 없음 (잠금해제 레인 " .. _a190 .. ")") return end
local _a192 = _a131(_a187)
local _a193 = _a145()
if #_a193 == 0 then
_a45("[배치] 배치 가능한 타워 없음 (종류별 최대치 도달)")
end
local _a194 = _a192
local _a195, _a196, _a197, _a198 = 0, 0, 0, 0
local _a199 = {}
local _a200 = {}
local function _a201(_a202)
return tostring(_a202 and _a202.key or (tostring(_a202 and _a202.id) .. "|" .. tostring(_a202 and _a202.vr or "")))
end
for _a203 = #_a193, 1, -1 do
if _a200[_a201(_a193[_a203])] then table.remove(_a193, _a203) end
end
local function _a204(_a205)
for _a206, _a207 in ipairs(_a194) do
if _a207.cf then
local _a208 = Vector2.new(_a207.cf.X - _a205.pos.X, _a207.cf.Z - _a205.pos.Z).Magnitude
if _a208 < 2 then return _a207 end
end
end
return nil
end
for _a209, _a210 in ipairs(_a191) do
if not _a54.place then break end
local _a211 = _a204(_a210)
if _a211 then _a195 += 1 else _a196 += 1 end
local _a212 = _a193[1]
if not _a212 then break end
if not _a211 then
local _a213, _a214, _a215 = _a170(_a212, _a210, _a187)
if _a213 then
_a197 += 1
_a55.placed += 1
_a45(("  ▸ 배치  레인%s  %s %s  DPS %s"):format(
_a210.lane, tostring(_a212.id), tostring(_a212.vr or "-"), _a46(_a212.dps)))
_a194 = _a131(_a187)
_a193 = _a145()
for _a216 = #_a193, 1, -1 do
if _a200[_a201(_a193[_a216])] then table.remove(_a193, _a216) end
end
else
_a199[tostring(_a214)] = (_a199[tostring(_a214)] or 0) + 1
if tostring(_a214):find("copies") then _a200[_a201(_a212)] = true end
table.remove(_a193, 1)
end
task.wait(_a51.ActionGap)
elseif (_a212.dps or 0) > (_a211.dps or 0) * _a51.SwapMargin then
if _a51.ProtectUpgraded and (_a211.up or 0) > 0 then
else
if _a183(_a211.id) then
task.wait(0.5)
local _a217 = _a145()
local _a218, _a219 = false, nil
for _a220 = 1, math.min(10, #_a217) do
local _a221 = _a217[_a220]
if not _a200[_a201(_a221)] then
local _a222, _a223 = _a170(_a221, _a210, _a187)
if _a222 then
_a218, _a219 = true, _a221
break
end
_a199[tostring(_a223)] = (_a199[tostring(_a223)] or 0) + 1
if tostring(_a223):find("copies") then _a200[_a201(_a221)] = true end
task.wait(0.15)
end
end
if _a218 and _a219 then
if _a219.id == _a211.kind and (_a219.vr or "") == (_a211.vr or "") then
_a45("  · 레인" .. _a210.lane .. " 같은 종류로 되돌림 (더 나은 게 없음)")
else
_a198 += 1
_a55.swapped += 1
_a45(("  ⇄ 교체  레인%s   %s%s(Lv%s) DPS %s  →  %s %s DPS %s"):format(
_a210.lane,
tostring(_a211.kind), _a211.vr and (" " .. _a211.vr) or "",
tostring(_a211.up), _a46(_a211.dps),
tostring(_a219.id), tostring(_a219.vr or "-"), _a46(_a219.dps)))
end
else
_a45("  ! 레인" .. _a210.lane .. " 아무것도 못 놓음 — 칸이 비었습니다")
end
_a194 = _a131(_a187)
_a193 = _a145()
for _a224 = #_a193, 1, -1 do
if _a200[_a201(_a193[_a224])] then table.remove(_a193, _a224) end
end
task.wait(_a51.ActionGap)
end
end
end
end
_a55.filled, _a55.empty = _a195, _a196
local _a225 = ("[배치] 슬롯 %d (찬칸 %d / 빈칸 %d)  이번에 배치 %d, 교체 %d")
:format(#_a191, _a195, _a196, _a197, _a198)
_a45(_a225)
if next(_a199) then
for _a226, _a227 in pairs(_a199) do _a45("    실패 " .. _a227 .. "회: " .. _a226) end
end
end
local function _a228()
if not _a50.R_BUY then _a45("[구매] 리모트 없음") return end
local _a229, _a230 = 0, 0
for _a231 = 1, _a51.MerchantSlots do
if not _a54.merchant then break end
local _a232
pcall(function() _a232 = _a50.R_BUY:InvokeServer(_a51.MerchantId, _a231) end)
if _a232 ~= nil and _a232 ~= false then _a229 += 1 else _a230 += 1 end
task.wait(0.3)
end
_a55.bought += _a229
_a45(("[구매] %s  성공 %d / 실패 %d"):format(_a51.MerchantId, _a229, _a230))
end
local function _a233()
if not _a48.Save then return 0 end
local _a234, _a235 = pcall(_a48.Save.Get)
if not _a234 or type(_a235) ~= "table" then return 0 end
local _a236 = _a235.Inventory and _a235.Inventory.Currency
if type(_a236) ~= "table" then return 0 end
for _a237, _a238 in pairs(_a236) do
if type(_a238) == "table" and rawget(_a238, "id") == "Sunflowers" then
return tonumber(rawget(_a238, "_am")) or 0
end
end
return 0
end
local function _a239()
local _a240 = {}
if not _a48.Save then return _a240 end
local _a241, _a242 = pcall(_a48.Save.Get)
if not _a241 or type(_a242) ~= "table" then return _a240 end
local _a243 = rawget(_a242, "EventUpgrades")
if type(_a243) == "table" then
for _a244, _a245 in pairs(_a243) do _a240[_a244] = tonumber(_a245) or 0 end
end
return _a240
end
local _a246
local function _a247()
if _a246 then return _a246 end
_a246 = {}
local _a248 = _a43:FindFirstChild("__DIRECTORY")
_a248 = _a248 and _a248:FindFirstChild("EventUpgrades")
if _a248 then
for _a249, _a250 in ipairs(_a248:GetDescendants()) do
if _a250:IsA("ModuleScript") then
local _a251, _a252 = pcall(require, _a250)
if _a251 and type(_a252) == "table" then
_a246[rawget(_a252, "_id") or _a250.Name] = _a252
end
end
end
end
return _a246
end
local _a253, _a254
local function _a255()
if _a253 ~= nil then return _a253 end
_a253 = false
local _a256 = {
_a47("Library", "Util", "GardenUpgradeCurve"),
_a47("Library", "Util", "GardenUpgradeBoosts"),
_a48.EventUpgradeCmds,
}
for _a257, _a258 in ipairs(_a256) do
if type(_a258) == "table" then
for _a259, _a260 in pairs(_a258) do
local _a261 = tostring(_a259):lower()
if type(_a260) == "function" and (_a261:find("cost") or _a261:find("price")) then
for _a262, _a263 in ipairs({
{ "GardenMoreDamage", 1 }, { "GardenMoreDamage", 2 },
{ 1 }, { 2 }, { "GardenMoreDamage" },
}) do
local _a264, _a265 = pcall(_a260, table.unpack(_a263))
if _a264 and type(_a265) == "number" and _a265 > 0 then
_a253 = _a260
_a254 = (#_a263 == 2) and "id_tier" or
(type(_a263[1]) == "number" and "tier" or "id")
return _a253
end
end
end
end
end
end
return _a253
end
local function _a266(_a267)
if _a267 == nil then return nil end
if type(_a267) == "number" then return _a267 end
if type(_a267) == "table" then
local _a268 = rawget(_a267, "_data")
if type(_a268) == "table" then
return tonumber(rawget(_a268, "_am")) or 1
end
end
local _a269, _a270 = pcall(function() return _a267:GetAmount() end)
if _a269 and type(_a270) == "number" then return _a270 end
return nil
end
local function _a271(_a272, _a273)
local _a274 = _a247()[_a272]
if type(_a274) == "table" then
for _a275, _a276 in ipairs({ "TierCosts", "Costs", "Prices", "TierPrices" }) do
local _a277 = rawget(_a274, _a276)
if type(_a277) == "table" then
local _a278 = _a266(_a277[(tonumber(_a273) or 0) + 1])
if _a278 then return _a278 end
end
end
end
local _a279 = _a255()
if _a279 then
local _a280 = (tonumber(_a273) or 0) + 1
local _a281
if _a254 == "id_tier" then _a281 = { { _a272, _a280 }, { _a272, _a273 } }
elseif _a254 == "tier" then _a281 = { { _a280 }, { _a273 } }
else _a281 = { { _a272 } } end
for _a282, _a283 in ipairs(_a281) do
local _a284, _a285 = pcall(_a279, table.unpack(_a283))
if _a284 and type(_a285) == "number" and _a285 > 0 then return _a285 end
end
end
return nil
end
local function _a286(_a287)
if _a48.EventUpgradeCmds and type(rawget(_a48.EventUpgradeCmds, "Purchase")) == "function" then
local _a288, _a289 = pcall(_a48.EventUpgradeCmds.Purchase, _a287)
if _a288 and _a289 ~= nil and _a289 ~= false then return true, _a289 end
if _a288 then return false, _a289 end
end
if _a50.R_EVUP then
local _a290
local _a291 = pcall(function() _a290 = _a50.R_EVUP:InvokeServer(_a287) end)
if _a291 then return (_a290 ~= nil and _a290 ~= false), _a290 end
end
return false, "호출 실패"
end
local function _a292()
if not (_a50.R_EVUP or _a48.EventUpgradeCmds) then _a45("[머신업글] API 없음") return end
local _a293, _a294 = 0, 0
while _a54.upgrade and _a293 < 40 do
_a293 += 1
local _a295 = _a233()
_a55.sun = _a295
local _a296 = _a239()
local _a297 = {}
for _a298, _a299 in ipairs(_a57) do
local _a300 = _a296[_a299] or 0
local _a301 = _a271(_a299, _a300)
_a297[#_a297 + 1] = { id = _a299, tier = _a300, cost = _a301 }
end
table.sort(_a297, function(_a302, _a303)
local _a304 = _a302.cost or math.huge
local _a305 = _a303.cost or math.huge
if _a304 == _a305 then return _a302.id < _a303.id end
return _a304 < _a305
end)
local _a306 = false
for _a307, _a308 in ipairs(_a297) do
if not _a54.upgrade then break end
local _a309 = _a308.cost and (_a295 - _a308.cost >= _a51.MinSunflowers)
if _a308.cost == nil then _a309 = _a51.BuyUnknownCost end
if _a309 then
local _a310 = _a295
local _a311, _a312 = _a286(_a308.id)
if _a311 then
_a294 += 1
_a55.upgraded += 1
_a306 = true
task.wait(0.4)
local _a313 = _a233()
_a45(("  ▲ %s  Lv%s → Lv%s   비용 %s   잔액 %s"):format(
_a308.id, tostring(_a308.tier), tostring(_a308.tier + 1),
_a46(_a310 - _a313, 0), _a46(_a313, 0)))
break
end
end
end
if not _a306 then break end
end
local _a314 = _a233()
_a55.sun = _a314
local _a315 = _a239()
if _a294 > 0 then
_a45(("[머신업글] %d건 구매 / 잔액 %s"):format(_a294, _a46(_a314, 0)))
else
local _a316, _a317 = math.huge, nil
for _a318, _a319 in ipairs(_a57) do
local _a320 = _a271(_a319, _a315[_a319] or 0)
if _a320 and _a320 < _a316 then _a316, _a317 = _a320, _a319 end
end
if _a317 then
_a45(("[머신업글] 살 수 있는 게 없음 — 잔액 %s / 최저 %s (%s)")
:format(_a46(_a314, 0), _a46(_a316, 0), _a317))
else
_a45("[머신업글] 구매 실패 (비용표를 못 읽음)")
end
end
end
local _a321, _a322
local function _a323()
if _a321 then return _a321 end
_a321 = {}
local _a324 = _a43:FindFirstChild("__DIRECTORY")
_a324 = _a324 and _a324:FindFirstChild("CropSeeds")
if _a324 then
for _a325, _a326 in ipairs(_a324:GetDescendants()) do
if _a326:IsA("ModuleScript") then
local _a327, _a328 = pcall(require, _a326)
if _a327 and type(_a328) == "table" then _a321[rawget(_a328, "_id") or _a326.Name] = _a328 end
end
end
end
return _a321
end
local function _a329()
if _a322 then return _a322 end
_a322 = {}
local _a330 = _a43:FindFirstChild("__DIRECTORY")
_a330 = _a330 and _a330:FindFirstChild("GardenCrops")
if _a330 then
for _a331, _a332 in ipairs(_a330:GetDescendants()) do
if _a332:IsA("ModuleScript") then
local _a333, _a334 = pcall(require, _a332)
if _a333 and type(_a334) == "table" then _a322[rawget(_a334, "_id") or _a332.Name] = _a334 end
end
end
end
return _a322
end
local function _a335(_a336)
local _a337 = _a329()[_a336]
return _a337 and tonumber(rawget(_a337, "CoinsPerSec")) or 0
end
local _a338 = {}
local function _a339(_a340)
if _a338[_a340] then return _a338[_a340] end
local _a341 = _a323()[_a340]
local _a342 = _a341 and rawget(_a341, "SpeciesWeights")
local _a343, _a344 = 0, 0
if type(_a342) == "table" then
for _a345, _a346 in pairs(_a342) do
local _a347 = tonumber(_a346) or 0
_a343 += _a347
_a344 += _a347 * _a335(_a345)
end
end
local _a348 = (_a343 > 0) and (_a344 / _a343) or 0
_a338[_a340] = _a348
return _a348
end
local function _a349()
local _a350 = {}
if not _a48.Save then return _a350 end
local _a351, _a352 = pcall(_a48.Save.Get)
if not _a351 or type(_a352) ~= "table" then return _a350 end
local _a353 = _a352.Inventory and _a352.Inventory.CropSeed
if type(_a353) ~= "table" then return _a350 end
for _a354, _a355 in pairs(_a353) do
if type(_a355) == "table" then
local _a356 = tonumber(rawget(_a355, "_am")) or 1
if _a356 > 0 then
_a350[#_a350 + 1] = {
uid = _a354, id = rawget(_a355, "id"), vr = rawget(_a355, "vr"),
am = _a356, exp = _a339(rawget(_a355, "id")),
}
end
end
end
table.sort(_a350, function(_a357, _a358)
if (_a357.exp or 0) == (_a358.exp or 0) then return (_a357.am or 0) > (_a358.am or 0) end
return (_a357.exp or 0) > (_a358.exp or 0)
end)
return _a350
end
local function _a359(_a360)
if not _a360 then return {} end
local _a361
pcall(function() _a361 = _a360:Save("PvC_Beds") end)
return type(_a361) == "table" and _a361 or {}
end
local function _a362(_a363, _a364)
if not (_a48.GardenPlots and _a363) then return true end
local _a365, _a366 = pcall(_a48.GardenPlots.IsBedUnlocked, _a363, _a364)
if _a365 then return _a366 and true or false end
return true
end
local function _a367(_a368)
if not (_a48.PvCropGrowth and type(_a368) == "table") then return false end
local _a369, _a370 = pcall(_a48.PvCropGrowth.IsUnhatched, _a368)
return _a369 and _a370 and true or false
end
local function _a371(_a372)
if type(_a372) ~= "table" then return nil end
local _a373 = tonumber(rawget(_a372, "cps"))
if _a373 then return _a373 end
local _a374 = rawget(_a372, "sp")
if _a374 then return _a335(_a374) end
return nil
end
local function _a375()
local _a376, _a377 = _a105()
if not _a377 then _a45("[씨앗] 밭 없음") return end
local _a378 = _a359(_a377)
local _a379 = _a349()
if #_a379 == 0 then _a45("[씨앗] 인벤에 씨앗 없음") return end
local _a380, _a381 = {}, {}
for _a382 in pairs(_a378) do
if not _a381[tostring(_a382)] then _a381[tostring(_a382)] = true _a380[#_a380 + 1] = _a382 end
end
for _a383 = 1, 80 do
local _a384 = tostring(_a383)
if not _a381[_a384] and _a362(_a377, _a384) then _a381[_a384] = true _a380[#_a380 + 1] = _a384 end
end
local _a385, _a386, _a387, _a388 = 0, 0, 0, 0
local _a389 = 1
for _a390, _a391 in ipairs(_a380) do
if not _a54.crop then break end
local _a392 = _a379[_a389]
while _a392 and _a392.am <= 0 do
_a389 += 1
_a392 = _a379[_a389]
end
if not _a392 then break end
local _a393 = _a378[_a391]
local _a394 = _a371(_a393)
if _a393 == nil then
local _a395
pcall(function() _a395 = _a377:Invoke("SD_Insert", _a391, _a392.uid) end)
if _a395 ~= false then
_a386 += 1
_a55.replant += 1
_a392.am -= 1
_a45(("  ▸ 심기  칸%s  %s 씨앗 (기대 %s/s)"):format(tostring(_a391), tostring(_a392.id), _a46(_a392.exp)))
task.wait(_a51.ActionGap)
end
elseif _a51.SkipUnhatched and _a367(_a393) then
_a388 += 1
elseif _a394 and (_a392.exp or 0) > _a394 * _a51.CropMargin then
local _a396
pcall(function() _a396 = _a377:Invoke("SD_Purge", _a391) end)
if _a396 ~= false then
task.wait(0.4)
local _a397
pcall(function() _a397 = _a377:Invoke("SD_Insert", _a391, _a392.uid) end)
if _a397 ~= false then
_a385 += 1
_a55.replant += 1
_a392.am -= 1
_a45(("  ⇄ 갈아엎기  칸%s  %s(%s/s) → %s 씨앗(기대 %s/s)"):format(
tostring(_a391), tostring(rawget(_a393, "sp") or "?"), _a46(_a394),
tostring(_a392.id), _a46(_a392.exp)))
else
_a45("  ! 칸" .. tostring(_a391) .. " 파냈는데 심기 실패")
end
task.wait(_a51.ActionGap)
end
else
_a387 += 1
end
end
_a45(("[씨앗] 심기 %d / 갈아엎기 %d / 유지 %d / 성장중 %d")
:format(_a386, _a385, _a387, _a388))
end
local function _a398(_a399)
if _a56 and not _a399 then return _a56 end
if _a50.R_JC then
local _a400, _a401 = pcall(function() return _a50.R_JC:InvokeServer() end)
if _a400 and type(_a401) == "table" then _a56 = _a401 end
end
return _a56 or {}
end
local function _a402(_a403)
if not (_a48.GardenPlots and rawget(_a48.GardenPlots, "PlotCost")) then return nil end
local _a404, _a405 = pcall(_a48.GardenPlots.PlotCost, tonumber(_a403))
return (_a404 and type(_a405) == "number") and _a405 or nil
end
local function _a406(_a407)
local _a408 = {}
if not _a407 then return _a408 end
for _a409 = 1, _a51.MaxBedScan do
local _a410 = tostring(_a409)
if not _a362(_a407, _a410) then
_a408[#_a408 + 1] = { id = _a410, n = _a409, cost = _a402(_a409) }
end
end
table.sort(_a408, function(_a411, _a412)
return (_a411.cost or math.huge) < (_a412.cost or math.huge)
end)
return _a408
end
local function _a413()
local _a414, _a415, _a416, _a417 = _a105()
if not _a415 then _a45("[확장] 밭 없음") return end
local _a418, _a419 = 0, 0
local _a420 = _a233()
local _a421 = _a398(true)
local _a422 = 0
while _a54.expand and _a422 < 12 do
_a422 += 1
local _a423 = (tonumber(_a417) or 0) + 1
local _a424 = tonumber(_a421[_a423]) or tonumber(_a421[tostring(_a423)])
if _a424 and (_a420 - _a424) < _a51.MinSunflowers then
_a45(("[확장] 레인%d 비용 %s / 잔액 %s — 부족"):format(_a423, _a46(_a424, 0), _a46(_a420, 0)))
break
end
if not _a424 and not _a51.BuyUnknownCost then
_a45("[확장] 레인" .. _a423 .. " 비용을 못 읽음 — 건너뜀")
break
end
if not _a50.R_WIDEN then break end
local _a425 = _a420
local _a426, _a427, _a428
pcall(function() _a426, _a427, _a428 = _a50.R_WIDEN:InvokeServer() end)
task.wait(0.5)
_a420 = _a233()
if _a426 then
_a418 += 1
_a419 += (_a425 - _a420)
_a417 = tonumber(_a428) or (_a417 + 1)
_a45(("  ▣ 레인 오픈 → %s개   비용 %s   잔액 %s"):format(
tostring(_a417), _a46(_a425 - _a420, 0), _a46(_a420, 0)))
task.wait(_a51.ActionGap)
else
if _a427 then _a45("[확장] 레인 실패: " .. tostring(_a427)) end
break
end
end
local _a429 = _a406(_a415)
for _a430, _a431 in ipairs(_a429) do
if not _a54.expand then break end
if _a431.cost and (_a420 - _a431.cost) < _a51.MinSunflowers then break end
if not _a431.cost and not _a51.BuyUnknownCost then break end
local _a432 = _a420
local _a433
pcall(function() _a433 = _a415:Invoke("BD_Acquire", _a431.id) end)
task.wait(0.4)
_a420 = _a233()
if _a433 ~= false and _a420 < _a432 then
_a418 += 1
_a419 += (_a432 - _a420)
_a45(("  ▣ 밭칸 %s 오픈   비용 %s   잔액 %s"):format(
_a431.id, _a46(_a432 - _a420, 0), _a46(_a420, 0)))
task.wait(_a51.ActionGap)
else
break
end
end
_a55.sun = _a420
if _a418 > 0 then
_a45(("[확장] %d개 오픈 / 총 %s 소비"):format(_a418, _a46(_a419, 0)))
else
local _a434 = (tonumber(_a417) or 0) + 1
local _a435 = _a421[_a434] or _a421[tostring(_a434)]
local _a436 = _a429[1]
_a45(("[확장] 오픈할 것 없음 — 잔액 %s / 다음 레인%d %s / 다음 밭칸 %s"):format(
_a46(_a420, 0), _a434, _a435 and _a46(_a435, 0) or "?",
_a436 and (_a436.id .. " " .. (_a436.cost and _a46(_a436.cost, 0) or "?")) or "없음"))
end
end
local function _a437()
local _a438, _a439 = _a105()
if not _a439 then return nil end
local function _a440(_a441)
local _a442
pcall(function() _a442 = _a439:Save(_a441) end)
return _a442
end
local _a443 = tonumber(_a440("PvC_Regrows")) or 0
local _a444   = tonumber(_a440("PvC_UnlockedLanes")) or 1
local _a445   = tonumber(_a440("PvC_RunBossKills")) or 0
local _a446     = _a49("PvC_RegrowCap") or math.huge
local _a447    = _a49("PvC_RegrowBossBase") or 1
local _a448    = _a49("PvC_RegrowBossStep") or 1
local _a449  = math.min(_a443, _a446)
local _a450    = math.ceil(_a447 * (_a448 ^ _a449))
local _a451   = (_a446 <= _a449)
return {
regrows = _a443, lanes = _a444, kills = _a445, need = _a450,
cap = _a446, maxed = _a451,
ready = (not _a451) and _a444 >= 7 and _a445 >= _a450,
reason = _a451 and "최대 리버스 도달"
or (_a444 < 7 and ("레인 %d/7"):format(_a444))
or (_a445 < _a450 and ("코인보스 %d/%d"):format(_a445, _a450))
or nil,
}
end
local function _a452()
if not _a50.R_WK then _a45("[리버스] WK_Reclaim 리모트 없음") return end
local _a453 = _a437()
if not _a453 then _a45("[리버스] 밭 없음") return end
if not _a453.ready then
_a45(("[리버스] 대기 — %s   (리버스 %d회)"):format(tostring(_a453.reason), _a453.regrows))
return
end
_a45(("[리버스] 조건 충족 (레인 %d, 보스 %d/%d) — 실행"):format(_a453.lanes, _a453.kills, _a453.need))
local _a454, _a455, _a456
pcall(function() _a454, _a455, _a456 = _a50.R_WK:InvokeServer() end)
task.wait(1.5)
if _a454 then
_a55.sun = _a233()
_a56 = nil
_a45(("  ★ 리버스 성공 → %s회   (레인/밭칸/작물 초기화됨)"):format(tostring(_a456 or (_a453.regrows + 1))))
_a45("  자동 확장이 켜져 있으면 레인/밭칸을 다시 엽니다")
else
_a45("  ✗ 리버스 실패: " .. tostring(_a455))
end
end
local _a457 = _a47("Library", "Util", "GardenEggs")
local _a458    = _a47("Library", "Directory", "Eggs")
local _a459= _a47("Library", "Balancing", "CalcEggPricePlayer")
local _a460  = _a47("Library", "Balancing", "CalcEggPrice")
local function _a461()
if _a51.HatchEggNum and _a51.HatchEggNum >= 1 then
return math.floor(_a51.HatchEggNum)
end
local _a462, _a463 = _a105()
if _a457 and rawget(_a457, "CurrentEggNum") then
local _a464, _a465 = pcall(_a457.CurrentEggNum, _a463)
if _a464 and tonumber(_a465) then return math.floor(tonumber(_a465)) end
end
if _a48.EventUpgradeCmds and rawget(_a48.EventUpgradeCmds, "GetPower") then
local _a466, _a467 = pcall(_a48.EventUpgradeCmds.GetPower, "GardenBetterEggs")
if _a466 and tonumber(_a467) then return math.clamp(1 + math.floor(tonumber(_a467)), 1, 12) end
end
return 1
end
local function _a468(_a469)
return ("Garden Egg %d"):format(_a469 or _a461())
end
local function _a470(_a471)
if type(_a458) == "table" then
local _a472 = rawget(_a458, _a471)
if _a472 then return _a472 end
end
local _a473 = _a43:FindFirstChild("__DIRECTORY")
_a473 = _a473 and _a473:FindFirstChild("Eggs")
if _a473 then
for _a474, _a475 in ipairs(_a473:GetDescendants()) do
if _a475:IsA("ModuleScript") then
local _a476, _a477 = pcall(require, _a475)
if _a476 and type(_a477) == "table" and rawget(_a477, "_id") == _a471 then return _a477 end
end
end
end
return nil
end
table.clear(_a53)
local function _a478(_a479)
if _a53[_a479] then return _a53[_a479] end
local _a480 = _a470(_a479)
if not _a480 then return nil end
for _a481, _a482 in ipairs({ _a459, _a460 }) do
if type(_a482) == "function" then
local _a483, _a484 = pcall(_a482, _a480)
if _a483 and tonumber(_a484) and tonumber(_a484) > 0 then
_a53[_a479] = tonumber(_a484)
return _a53[_a479]
end
end
end
local _a485 = tonumber(rawget(_a480, "overrideCost"))
if _a485 then
local _a486 = _a49("PvC_EggCostMult")
if not _a486 or _a486 <= 0 then _a486 = 1 end
local _a487 = math.max(1, math.round(_a485 * _a486))
_a53[_a479] = _a487
return _a487
end
return nil
end
local _a488 = _a47("Library", "Client", "CustomEggsCmds")
local function _a489()
local _a490 = {}
local _a491 = workspace:FindFirstChild("__THINGS")
_a491 = _a491 and _a491:FindFirstChild("CustomEggs")
if not _a491 then return _a490 end
local _a492 = _a44.Character and _a44.Character:FindFirstChild("HumanoidRootPart")
for _a493, _a494 in ipairs(_a491:GetChildren()) do
local _a495
pcall(function()
if _a494:IsA("Model") then _a495 = _a494:GetPivot().Position
elseif _a494:IsA("BasePart") then _a495 = _a494.Position end
end)
_a490[#_a490 + 1] = {
uid = _a494.Name, inst = _a494,
dist = (_a495 and _a492) and (_a495 - _a492.Position).Magnitude or math.huge,
}
end
table.sort(_a490, function(_a496, _a497) return _a496.dist < _a497.dist end)
return _a490
end
local function _a498()
if _a51.HatchUid and _a51.HatchUid ~= "" then return _a51.HatchUid end
local _a499 = _a489()
return _a499[1] and _a499[1].uid or nil
end
local function _a500()
if type(_a488) == "table" then
local _a501 = rawget(_a488, "GetMaxEggCount")
if type(_a501) == "function" then
local _a502, _a503 = pcall(_a501)
if _a502 and tonumber(_a503) and tonumber(_a503) >= 1 then return math.floor(tonumber(_a503)) end
end
end
return _a51.HatchMax
end
local function _a504()
local _a505 = _a461()
local _a506 = _a468(_a505)
local _a507 = _a478(_a506)
local _a508 = _a233()
local _a509 = math.max(0, _a508 - (_a51.HatchReserve or 0))
local _a510 = _a489()
return {
num = _a505, id = _a506, cost = _a507, sun = _a508,
uid = _a498(), eggCount = #_a510, eggs = _a510,
canBuy = (_a507 and _a507 > 0) and math.floor(_a509 / _a507) or 0,
}
end
local function _a511()
if not _a50.R_CEGG then _a45("[뽑기] CustomEggs_Hatch 리모트 없음") return end
local _a512 = _a504()
_a55.sun = _a512.sun
if not _a512.uid then
_a45("[뽑기] 알을 못 찾음 — 알 근처로 가주세요 (workspace.__THINGS.CustomEggs 비어있음)")
return
end
if not _a512.cost then
_a45("[뽑기] " .. _a512.id .. " 비용을 못 읽음")
return
end
if _a512.canBuy < 1 then
return
end
local _a513 = math.min(_a51.HatchMax, _a500())
local _a514, _a515 = 0, 0
local _a516 = math.min(_a512.canBuy, _a513)
while _a54.hatch and _a516 >= 1 and _a515 < 20 do
_a515 += 1
local _a517, _a518
pcall(function() _a517, _a518 = _a50.R_CEGG:InvokeServer(_a512.uid, _a516) end)
if _a517 then
_a514 += _a516
_a55.hatched += _a516
task.wait(0.4)
local _a519 = _a233()
_a55.sun = _a519
local _a520 = math.max(0, _a519 - (_a51.HatchReserve or 0))
local _a521 = math.floor(_a520 / _a512.cost)
if _a521 < 1 then break end
_a516 = math.min(_a521, _a513)
else
local _a522 = tostring(_a518)
if _a522:find("quickly") then
task.wait(2.5)
elseif _a516 > 1 then
_a516 = math.floor(_a516 / 2)
else
if _a518 then _a45("[뽑기] 실패: " .. _a522) end
break
end
end
end
if _a514 > 0 then
_a45(("[뽑기] %s × %d   (개당 %s)   잔액 %s"):format(
_a512.id, _a514, _a46(_a512.cost, 0), _a46(_a233(), 0)))
end
end
local _a523 = _a47("Library", "Client", "GardenChanceMachineCmds")
local _a524 = _a47("Library", "Types", "GardenChanceMachine")
local _a525 = { "Huge", "Titanic", "Gargantuan" }
local function _a526()
if _a523 and rawget(_a523, "GetMaxBoostSeconds") then
local _a527, _a528 = pcall(_a523.GetMaxBoostSeconds)
if _a527 and tonumber(_a528) then return tonumber(_a528) end
end
return (_a524 and tonumber(rawget(_a524, "MaxSecondsDefault"))) or 21600
end
local function _a529(_a530)
if _a523 and rawget(_a523, "GetPerTokenSecondsForBoost") then
local _a531, _a532 = pcall(_a523.GetPerTokenSecondsForBoost, _a530)
if _a531 and tonumber(_a532) and tonumber(_a532) > 0 then return tonumber(_a532) end
end
local _a533 = (_a524 and _a524.TokensToMaxDefault
and tonumber(_a524.TokensToMaxDefault[_a530])) or 5000
return _a526() / _a533
end
local function _a534(_a535)
if _a523 and rawget(_a523, "GetBoostTime") then
local _a536, _a537 = pcall(_a523.GetBoostTime, _a535)
if _a536 and tonumber(_a537) then return tonumber(_a537) end
end
return 0
end
local function _a538()
if _a523 and rawget(_a523, "IsEnabled") then
local _a539, _a540 = pcall(_a523.IsEnabled)
if _a539 then return _a540 and true or false end
end
return true
end
local function _a541()
local _a542 = _a526()
local _a543 = {}
for _a544, _a545 in ipairs(_a525) do
local _a546 = _a534(_a545)
local _a547 = _a529(_a545)
local _a548 = math.max(0, _a542 - _a546)
_a543[#_a543 + 1] = {
rarity = _a545, left = _a546, per = _a547, deficit = _a548,
need = (_a547 > 0) and math.ceil(_a548 / _a547) or 0,
on = _a51.LuckBoosts[_a545] and true or false,
}
end
return { maxSec = _a542, rows = _a543, enabled = _a538(), sun = _a233() }
end
local function _a549(_a550)
_a550 = math.max(0, math.floor(tonumber(_a550) or 0))
local _a551 = math.floor(_a550 / 3600)
local _a552 = math.floor((_a550 % 3600) / 60)
return ("%d시간 %d분"):format(_a551, _a552)
end
local function _a553()
if not _a50.R_LUCK then _a45("[럭] GardenChanceMachine_AddTime 리모트 없음") return end
if not _a538() then _a45("[럭] 이 서버에서 비활성") return end
local _a554 = _a541()
_a55.sun = _a554.sun
local _a555 = _a554.sun
local _a556 = 0
for _a557, _a558 in ipairs(_a554.rows) do
if not _a54.luck then break end
if _a558.on and _a558.deficit >= _a51.LuckMinTopUp and _a558.need >= 1 then
local _a559 = math.max(0, _a555 - _a51.LuckReserve)
local _a560 = math.min(_a558.need, math.floor(_a559))
if _a560 >= 1 then
local _a561 = _a555
local _a562, _a563
pcall(function()
_a562, _a563 = _a50.R_LUCK:InvokeServer(_a558.rarity, "Slot1", _a560)
end)
task.wait(0.4)
_a555 = _a233()
_a55.sun = _a555
if _a562 then
_a556 += 1
_a55.luck += 1
_a45(("  ✦ 럭 %s  +%s  (%s → %s)  비용 %s"):format(
_a558.rarity, _a549(_a560 * _a558.per),
_a549(_a558.left), _a549(math.min(_a554.maxSec, _a558.left + _a560 * _a558.per)),
_a46(_a561 - _a555, 0)))
else
_a45(("  ✗ 럭 %s 실패: %s"):format(_a558.rarity, tostring(_a563)))
end
task.wait(_a51.ActionGap)
end
end
end
if _a556 == 0 then
local _a564 = {}
for _a565, _a566 in ipairs(_a554.rows) do
if _a566.on then
_a564[#_a564 + 1] = ("%s %s"):format(_a566.rarity, _a549(_a566.left))
end
end
if #_a564 > 0 then
_a45("[럭] 유지 중 — " .. table.concat(_a564, " / "))
end
end
end
_a42.EVENT_UPGRADES, _a42.ctx, _a42.collectSlots, _a42.placedTowers, _a42.availableItems, _a42.cyclePlace = _a57, _a105, _a112, _a131, _a145, _a186
_a42.cycleMerchant, _a42.sunflowers, _a42.eventTiers, _a42.nextCost, _a42.cycleUpgrade, _a42.seedInv = _a228, _a233, _a239, _a271, _a292, _a349
_a42.bedsOf, _a42.isUnhatched, _a42.bedCps, _a42.cycleCrop, _a42.laneCosts, _a42.lockedBeds = _a359, _a367, _a371, _a375, _a398, _a406
_a42.cycleExpand, _a42.rebirthStatus, _a42.cycleRebirth, _a42.hatchStatus, _a42.cycleHatch = _a413, _a437, _a452, _a504, _a511
_a42.LUCK_ORDER, _a42.luckStatus, _a42.fmtDur, _a42.cycleLuck = _a525, _a541, _a549, _a553
end)(_a1)
;(function(_a567)
local _a568, _a569, _a570, _a571, _a572, _a573 = _a567.UIS, _a567.RunService, _a567.LP, _a567.log, _a567.num, _a567.req
local _a574, _a575, _a576, _a577, _a578, _a579 = _a567.LB, _a567.NET, _a567.RM, _a567.CFG, _a567.RUN, _a567.STAT
local _a580, _a581 = _a567.ctx, _a567.placedTowers
local _a582 = {
AutoFarm = _a573("Library", "Client", "AutoFarmCmds"),
Zone     = _a573("Library", "Client", "ZoneCmds"),
Currency = _a573("Library", "Client", "CurrencyCmds"),
Bal      = _a573("Library", "Balancing"),
Egg      = _a573("Library", "Client", "EggCmds"),
Rebirth  = _a573("Library", "Client", "RebirthCmds"),
RanksU   = _a573("Library", "Util", "RanksUtil"),
DirRanks = _a573("Library", "Directory", "Ranks"),
DirEggs  = _a573("Library", "Directory", "Eggs"),
CalcEgg  = _a573("Library", "Balancing", "CalcEggPricePlayer"),
R_Farm   = _a575:FindFirstChild("AutoFarm_Enable"),
R_FarmOff = _a575:FindFirstChild("AutoFarm_Disable"),
R_Zone   = _a575:FindFirstChild("Zones_RequestPurchase"),
R_Reb    = _a575:FindFirstChild("Rebirth_Request"),
R_Rank   = _a575:FindFirstChild("Ranks_ClaimReward"),
Quest    = _a573("Library", "Client", "QuestCmds"),
EggsU    = _a573("Library", "Util", "EggsUtil"),
Map      = _a573("Library", "Client", "MapCmds"),
Inst     = _a573("Library", "Client", "InstancingCmds"),
DirZones = _a573("Library", "Directory", "Zones"),
ZonesU   = _a573("Library", "Util", "ZonesUtil"),
Upg      = _a573("Library", "Client", "UpgradeCmds"),
DirUpg   = _a573("Library", "Directory", "Upgrades"),
R_Upg    = _a575:FindFirstChild("Upgrades_Purchase"),
R_EggUn  = _a575:FindFirstChild("Eggs_RequestUnlock"),
Rand     = _a573("Library", "Client", "RandomEventCmds"),
R_Events = _a575:FindFirstChild("RandomEvents_Get"),
Ult      = _a573("Library", "Client", "UltimateCmds"),
R_Fruit  = _a575:FindFirstChild("Fruits: Consume"),
R_Cons   = _a575:FindFirstChild("Consumables_Consume"),
R_Ult    = _a575:FindFirstChild("Ultimates: Activate"),
R_Gold   = _a575:FindFirstChild("GoldMachine_Activate"),
R_Rain   = _a575:FindFirstChild("RainbowMachine_Activate"),
R_Flag   = _a575:FindFirstChild("FlexibleFlags_Consume"),
DirPets  = _a573("Library", "Directory", "Pets"),
CalcEggB = _a573("Library", "Balancing", "CalcEggPrice"),
PlayerPet = _a573("Library", "Client", "PlayerPet"),
Machine  = _a573("Library", "Client", "MachineCmds"),
Vars     = _a573("Library", "Variables"),
Hatch    = _a573("Library", "Client", "HatchingCmds"),
R_AHTog  = _a575:FindFirstChild("AutoHatch_Toggle"),
R_AHOn   = _a575:FindFirstChild("AutoHatch_Enable"),
R_AHOff  = _a575:FindFirstChild("AutoHatch_Disable"),
RankC    = _a573("Library", "Client", "RankCmds"),
CalcPetS = _a573("Library", "Balancing", "CalcPetSlotPrice"),
CalcEggS = _a573("Library", "Balancing", "CalcEggSlotPrice"),
R_PetSlot = _a575:FindFirstChild("EquipSlotsMachine_RequestPurchase"),
R_EggSlot = _a575:FindFirstChild("EggHatchSlotsMachine_RequestPurchase"),
R_Tp     = _a575:FindFirstChild("Teleports_RequestTeleport"),
R_TpI    = _a575:FindFirstChild("Teleports_RequestInstanceTeleport"),
R_PotUp  = _a575:FindFirstChild("UpgradePotionsMachine_ActivateBulk"),
R_EncUp  = _a575:FindFirstChild("UpgradeEnchantsMachine_ActivateBulk"),
R_PotUse = _a575:FindFirstChild("Potions: Consume"),
}
local _a583 = {
[1]="farm", [9]="farm", [21]="farm", [7]="farm", [99]="farm", [8]="farm",
[30]="farm", [31]="farm", [32]="farm", [37]="farm", [38]="farm", [39]="farm",
[43]="farm", [44]="farm", [66]="farm", [67]="farm", [75]="farm", [76]="farm",
[14]="farm", [15]="farm", [64]="farm", [65]="farm", [63]="farm",
[2]="hatch", [3]="hatch", [20]="hatch", [42]="hatch", [47]="hatch",
[6]="zone", [81]="zone",
[34]="potuse",
[35]="fruituse", [33]="flaguse",
}
local _a584 = {}
_a584.ctl, _a584.move, _a584.egg = {}, {}, {}
_a584.screen, _a584.quest, _a584.ev = {}, {}, {}
_a584.item, _a584.mach, _a584.auto = {}, {}, {}
_a584.quest.IGNORE = {
[4]  = "골드 펫 만들기 (합성 필요)",
[5]  = "레인보우 펫 만들기 (합성 필요)",
[40] = "best egg 골드 펫 (뽑기+합성 필요)",
[41] = "best egg 레인보우 펫 (뽑기+2단 합성 필요)",
[12] = "포션 업글 (업글 머신으로 이동 필요)",
[13] = "인챈트 업글 (업글 머신으로 이동 필요)",
}
_a584.ctl.abort = false
function _a584.ctl.stopped() return _a584.ctl.abort == true end
function _a584.ctl.stopAll()
_a584.ctl.abort = true
for _a585 in pairs(_a578) do
if _a585 ~= "petspd" and _a585 ~= "rewatch" then _a578[_a585] = false end
end
_a584.ctl.lockGoal = nil
_a584.ctl.moving = nil
_a584.ctl.now.step = "정지"
_a584.ctl.setAct("정지됨")
end
_a584.ctl.now = { step = "-", act = "-", detail = "", goal = "-", prog = "" }
function _a584.ctl.setAct(_a586, _a587)
_a584.ctl.now.act = _a586 or "-"
_a584.ctl.now.detail = _a587 and tostring(_a587) or ""
_a584.ctl.now.at = os.clock()
end
function _a584.ctl.setGoal(_a588, _a589)
_a584.ctl.now.goal = _a588 and tostring(_a588) or "-"
_a584.ctl.now.prog = _a589 and tostring(_a589) or ""
end
function _a584.egg.eggStands()
local _a590 = os.clock()
if _a584.egg._standsAt and (_a590 - _a584.egg._standsAt) < 2 and _a584.egg._stands then
local _a591 = _a570.Character
local _a592 = _a591 and _a591:FindFirstChild("HumanoidRootPart")
if _a592 then
for _a593, _a594 in ipairs(_a584.egg._stands) do
_a594.dist = (_a594.pos - _a592.Position).Magnitude
end
table.sort(_a584.egg._stands, function(_a595, _a596) return _a595.dist < _a596.dist end)
end
return _a584.egg._stands
end
local _a597 = {}
local _a598 = workspace:FindFirstChild("__THINGS")
local _a599 = _a598 and _a598:FindFirstChild("Eggs")
if not _a599 then return _a597 end
local _a600 = _a570.Character
local _a601 = _a600 and _a600:FindFirstChild("HumanoidRootPart")
for _a602, _a603 in ipairs(_a599:GetDescendants()) do
if _a603:IsA("Model") and _a603.PrimaryPart then
local _a604 = tonumber(tostring(_a603.Name):match("%d+"))
if _a604 then
local _a605
if _a582.EggsU and rawget(_a582.EggsU, "GetByNumber") then
local _a606, _a607 = pcall(_a582.EggsU.GetByNumber, _a604)
if _a606 then _a605 = _a607 end
end
local _a608 = _a605 and (rawget(_a605, "_id") or rawget(_a605, "name"))
if _a608 then
_a597[#_a597 + 1] = {
id = _a608, def = _a605, num = _a604,
pos = _a603.PrimaryPart.Position,
dist = _a601 and (_a603.PrimaryPart.Position - _a601.Position).Magnitude or 9e9,
unlocked = _a603:GetAttribute("Unlocked") and true or false,
}
end
end
end
end
table.sort(_a597, function(_a609, _a610) return _a609.dist < _a610.dist end)
_a584.egg._stands, _a584.egg._standsAt = _a597, os.clock()
return _a597
end
local function _a611()
local _a612 = _a574.Save
if not _a612 then return nil end
local _a613, _a614 = pcall(_a612.Get)
if _a613 and type(_a614) == "table" then return _a614 end
if _a570 then
_a613, _a614 = pcall(_a612.Get, _a570)
if _a613 and type(_a614) == "table" then return _a614 end
end
if rawget(_a612, "GetSaves") then
local _a615, _a616 = pcall(_a612.GetSaves)
if _a615 and type(_a616) == "table" then
local _a617, _a618 = nil, 0
for _a619, _a620 in pairs(_a616) do _a618 += 1 _a617 = _a620 end
if _a618 == 1 and type(_a617) == "table" then
if not _a584.ctl.saveAlt then
_a584.ctl.saveAlt = true
_a571("[세이브] LocalPlayer 키가 안 맞아 유일한 항목으로 대체했습니다")
end
return _a617
end
end
end
return nil
end
local function _a621(_a622, _a623)
if _a582.Currency and rawget(_a582.Currency, "CanAfford") then
local _a624, _a625 = pcall(_a582.Currency.CanAfford, _a622, _a623)
if _a624 then return _a625 and true or false end
end
return false
end
local function _a626(_a627)
if _a582.Currency and rawget(_a582.Currency, "Get") then
local _a628, _a629 = pcall(_a582.Currency.Get, _a627)
if _a628 and tonumber(_a629) then return tonumber(_a629) end
end
return 0
end
local function _a630()
if _a582.AutoFarm and rawget(_a582.AutoFarm, "IsEnabled") then
local _a631, _a632 = pcall(_a582.AutoFarm.IsEnabled)
if _a631 then return _a632 and true or false end
end
return false
end
local function _a633()
if _a582.AutoFarm and rawget(_a582.AutoFarm, "GetTargetParentId") then
local _a634, _a635 = pcall(_a582.AutoFarm.GetTargetParentId)
if _a634 then return _a635 end
end
return nil
end
local function _a636()
if not _a582.R_Farm then _a571("[파밍] AutoFarm_Enable 리모트 없음") return end
local _a637 = _a630()
_a584.auto.farmZone, _a584.auto.hereZone = _a633(), _a584.move.curZone()
if _a637 then
local _a638, _a639 = _a633(), _a584.move.curZone()
if _a638 and _a639 and _a638 ~= _a639 then
_a571(("[파밍] 대상이 %s 인데 지금은 %s — 다시 켬"):format(
tostring(_a638), tostring(_a639)))
if _a582.R_FarmOff then pcall(function() _a582.R_FarmOff:InvokeServer() end) end
if _a582.AutoFarm and rawget(_a582.AutoFarm, "ForceDisable") then
pcall(_a582.AutoFarm.ForceDisable)
end
task.wait(0.3)
_a637 = false
end
end
if _a637 then return end
local _a640, _a641
pcall(function() _a640, _a641 = _a582.R_Farm:InvokeServer() end)
if _a640 then
_a579.farm += 1
_a584.auto.farmSaid = nil
_a571("[파밍] 자동 파밍 ON  (대상 " .. tostring(_a633() or _a584.move.curZone()) .. ")")
elseif _a641 and _a584.auto.farmSaid ~= tostring(_a641) then
_a584.auto.farmSaid = tostring(_a641)
_a571("[파밍] 실패: " .. tostring(_a641))
end
end
local function _a642()
if not (_a582.Zone and rawget(_a582.Zone, "GetNextZone")) then return nil end
local _a643, _a644, _a645 = pcall(_a582.Zone.GetNextZone)
if not _a643 then return nil end
return _a645 or _a644
end
local function _a646(_a647)
if not (_a582.Bal and rawget(_a582.Bal, "CalcGatePrice")) then return nil end
local _a648, _a649 = pcall(_a582.Bal.CalcGatePrice, _a647)
return (_a648 and tonumber(_a649)) or nil
end
local function _a650()
local _a651 = _a642()
if not _a651 then return nil end
local _a652 = _a646(_a651)
local _a653 = rawget(_a651, "Currency")
return {
zone = _a651, id = rawget(_a651, "_id"), price = _a652, currency = _a653,
have = _a653 and _a626(_a653) or 0,
ok = (_a652 and _a653) and _a621(_a653, _a652) or false,
}
end
local function _a654()
if not _a582.R_Zone then _a571("[존] Zones_RequestPurchase 리모트 없음") return end
local _a655 = 0
while _a578.zone and not _a584.ctl.stopped() and _a655 < 20 do
_a655 += 1
local _a656 = _a650()
if not _a656 then
_a584.auto.zoneNote = "다음 존을 못 구함 (GetNextZone 실패 / 존 퀘스트 미완료?)"
if _a584.auto.zoneSaid ~= _a584.auto.zoneNote then
_a584.auto.zoneSaid = _a584.auto.zoneNote
_a571("[존] " .. _a584.auto.zoneNote)
end
return
end
if not _a656.ok then
_a584.auto.zoneNote = ("%s  %s %s / 보유 %s — 부족"):format(
tostring(_a656.id), _a572(_a656.price or 0, 0), tostring(_a656.currency), _a572(_a656.have, 0))
if _a584.auto.zoneSaid ~= _a584.auto.zoneNote then
_a584.auto.zoneSaid = _a584.auto.zoneNote
_a571("[존] " .. _a584.auto.zoneNote)
end
return
end
_a584.auto.zoneSaid = nil
local _a657, _a658
pcall(function() _a657, _a658 = _a582.R_Zone:InvokeServer(_a656.id) end)
task.wait(0.5)
if _a657 then
_a579.zone += 1
_a571(("  ▶ 존 해금  %s   (%s %s)"):format(
tostring(_a656.id), _a572(_a656.price or 0, 0), tostring(_a656.currency)))
else
if _a658 then _a571("[존] 실패: " .. tostring(_a658)) end
return
end
task.wait(_a577.ActionGap)
end
end
local function _a659()
local _a660 = _a584.egg.eggStands()
local _a661 = (_a577.MainEggId and _a577.MainEggId ~= "") and _a577.MainEggId or nil
if _a661 then
for _a662, _a663 in ipairs(_a660) do
if _a663.id == _a661 then return _a663.id, _a663.def, _a663.dist end
end
local _a664 = _a582.DirEggs and rawget(_a582.DirEggs, _a661)
if _a664 then return _a661, _a664, nil, (_a660[1] and _a660[1].dist) end
return nil
end
if not _a582.DirEggs then return nil end
local _a665, _a666, _a667 = nil, nil, -1
for _a668, _a669 in pairs(_a582.DirEggs) do
if type(_a669) == "table" and not rawget(_a669, "isCustomEgg") then
local _a670 = tonumber(rawget(_a669, "eggNumber"))
if _a670 and _a670 > _a667 and _a584.egg.eggUnlocked(_a670) then
_a665, _a666, _a667 = _a668, _a669, _a670
end
end
end
if not _a665 then return nil end
local _a671, _a672
for _a673, _a674 in ipairs(_a660) do
if not _a672 then _a672 = _a674.dist end
if _a674.id == _a665 then _a671 = _a674.dist break end
end
if _a671 and _a671 <= _a577.EggRange then
return _a665, _a666, _a671
end
return _a665, _a666, nil, _a671 or _a672
end
local function _a675(_a676)
if type(_a582.CalcEgg) == "function" then
local _a677, _a678 = pcall(_a582.CalcEgg, _a676)
if _a677 and tonumber(_a678) then return tonumber(_a678) end
if not _a677 and not _a584.egg.priceWarned then
_a584.egg.priceWarned = true
_a571("[부화] CalcEggPricePlayer 막힘 → 기본가로 계산: " .. tostring(_a678))
end
end
if type(_a582.CalcEggB) == "function" then
local _a679, _a680 = pcall(_a582.CalcEggB, _a676)
if _a679 and tonumber(_a680) then return tonumber(_a680) end
end
for _a681, _a682 in ipairs({ "price", "Price", "cost", "Cost" }) do
local _a683 = tonumber(rawget(_a676, _a682))
if _a683 then return _a683 end
end
return nil
end
local function _a684()
local _a685, _a686, _a687, _a688 = _a659()
if not _a685 then return nil end
local _a689 = _a675(_a686)
local _a690 = rawget(_a686, "currency") or "Coins"
local _a691 = 1
if _a582.Egg and rawget(_a582.Egg, "GetMaxHatch") then
local _a692, _a693 = pcall(_a582.Egg.GetMaxHatch, _a686)
if _a692 and tonumber(_a693) then _a691 = math.max(1, math.floor(tonumber(_a693))) end
end
local _a694 = _a626(_a690)
return {
id = _a685, def = _a686, price = _a689, currency = _a690, maxN = _a691, have = _a694,
dist = _a687, nearest = _a688, inRange = _a687 ~= nil,
canBuy = (_a689 and _a689 > 0) and math.floor(math.max(0, _a694 - _a577.MainHatchReserve) / _a689) or 0,
}
end
local function _a695()
if not _a576.R_EGG then _a571("[부화] Eggs_RequestPurchase 리모트 없음") return end
if _a577.AutoUnlockEgg then
local _a696, _a697, _a698 = _a584.egg.lockedEggs()
if _a697 > _a698 then
local _a699 = _a584.egg.unlockEggs()
if _a699 > 0 then _a571(("[부화] 알 %d개 해금 (해금가능 #%d)"):format(_a699, _a697)) end
end
end
local _a700 = _a684()
if not _a700 then _a571("[부화] 알을 못 찾음") return end
if not _a700.inRange then
if _a577.HatchAutoTp then
local _a701, _a702 = _a584.egg.tpEgg(_a700.id)
if not _a701 then
if not _a584.egg.hatchWarned then
_a584.egg.hatchWarned = true
_a571("[부화] 알로 이동 실패: " .. tostring(_a702))
end
return
end
_a571("[부화] " .. _a700.id .. " 로 이동")
_a700 = _a684()
if not (_a700 and _a700.inRange) then return end
else
if not _a584.egg.hatchWarned then
_a584.egg.hatchWarned = true
_a571(("[부화] 알 근처로 가주세요 (가장 가까운 알까지 %s스터드, 인식 %d)"):format(
_a700.nearest and ("%.0f"):format(_a700.nearest) or "?", _a577.EggRange))
end
return
end
end
_a584.egg.hatchWarned = false
local _a703 = math.min(_a700.maxN, _a577.MainHatchMax)
local _a704 = _a700.price and math.min(_a700.canBuy, _a703) or _a703
if _a704 < 1 then return end
local _a705, _a706 = 0, 0
local function _a707()
return tonumber(_a582.Vars and rawget(_a582.Vars, "OpeningEgg")) or 0
end
local _a708 = _a582.Vars and rawget(_a582.Vars, "OpeningEgg") ~= nil
local _a709 = 2.5
if _a582.Egg and rawget(_a582.Egg, "ComputeDebounce") then
local _a710, _a711 = pcall(_a582.Egg.ComputeDebounce)
if _a710 and tonumber(_a711) then _a709 = tonumber(_a711) end
end
_a584.egg.autoHatchOn(_a700.id, _a704)
local _a712 = false
local _a713 = _a584.ctl.lockGoal and _a584.ctl.lockGoal.q
local _a714 = _a713 and (_a713.how == "hatch" or _a713.where == "bestegg") or false
local _a715 = _a714 and math.huge
or (os.clock() + math.max(3, _a577.HatchBudget or 25))
local _a716 = _a714 and 100000 or 400
while _a578.mhatch and not _a584.ctl.stopped() and _a704 >= 1 and _a706 < _a716 and os.clock() < _a715 do
if _a714 and (_a706 % 5 == 0) then
local _a717 = _a584.quest.findQuest(_a713.uid)
if not _a717 or _a717.progress >= _a717.amount then break end
end
_a706 += 1
if _a708 then
local _a718 = os.clock()
local _a719 = _a577.HatchClickAfter
local _a720 = false
while _a707() > 0 and _a578.mhatch and not _a584.ctl.stopped()
and (os.clock() - _a718) < 20 do
if _a577.HatchClick and (os.clock() - _a718) > _a719 then
_a584.egg.clickOnce()
_a719 += 0.3
if (os.clock() - _a718) > 3 and not _a720 then
_a720 = true
_a584.egg._ahEgg = nil
_a584.egg.autoHatchOn(_a700.id, _a704)
_a571("[부화] 화면이 안 넘어가서 오토해치 재설정")
end
end
task.wait(0.03)
end
if _a707() > 0 then
if _a584.egg.hatchStuck ~= _a700.id then
_a584.egg.hatchStuck = _a700.id
_a571("[부화] " .. tostring(_a700.id) .. " 까는 화면에서 멈춤 — 이번 회차 중단")
end
_a712 = true
break
end
_a584.egg.hatchStuck = nil
else
local _a721 = os.clock() - (_a584.egg.lastHatch or 0)
if _a721 < _a709 then task.wait(_a709 - _a721) end
end
_a584.egg.lastHatch = os.clock()
_a584.ctl.setAct("알 까는 중", ("%s x%d  (총 %d)"):format(_a700.id, _a704, _a705))
local _a722, _a723
local _a724 = pcall(function() _a722, _a723 = _a576.R_EGG:InvokeServer(_a700.id, _a704) end)
if _a722 then
_a705 += _a704
_a579.mhatch += _a704
_a584.egg.hatchErr = nil
if _a700.price then
local _a725 = _a626(_a700.currency)
local _a726 = math.floor(math.max(0, _a725 - _a577.MainHatchReserve) / _a700.price)
if _a726 < 1 then break end
_a704 = math.min(_a726, _a703)
end
else
local _a727 = _a724 and tostring(_a723) or "호출 자체 실패"
if _a727:find("quickly") or _a727:find("fast") then
task.wait(0.25)
elseif _a727:find("far away") then
if _a577.HatchAutoTp then _a584.egg.tpEgg(_a700.id) task.wait(0.2)
else _a571("[부화] 알에서 너무 멈") break end
elseif _a704 > 1 then
_a704 = math.floor(_a704 / 2)
else
if _a584.egg.hatchErr ~= _a727 then
_a584.egg.hatchErr = _a727
_a571("[부화] 실패: " .. _a727 .. "   (알 " .. tostring(_a700.id)
.. " / 개수 " .. _a704 .. " / 거리 "
.. (_a700.dist and ("%.0f"):format(_a700.dist) or "?") .. ")")
end
break
end
end
end
if _a708 and _a705 > 0 and not _a712 then
local _a728 = os.clock()
while _a707() == 0 and not _a584.ctl.stopped() and (os.clock() - _a728) < 2.5 do
task.wait(0.05)
end
local _a729 = os.clock()
local _a730 = _a577.HatchClickAfter
while _a707() > 0 and not _a584.ctl.stopped() and (os.clock() - _a729) < 20 do
_a584.ctl.setAct("알 마무리", ("%s  마지막 %d개 까는 중"):format(_a700.id, _a704))
if _a577.HatchClick and (os.clock() - _a729) > _a730 then
_a584.egg.clickOnce()
_a730 += 0.3
if (os.clock() - _a729) > 3 and not _a584.egg._finRe then
_a584.egg._finRe = true
_a584.egg._ahEgg = nil
_a584.egg.autoHatchOn(_a700.id, _a704)
end
end
task.wait(0.03)
end
_a584.egg._finRe = nil
if _a707() > 0 then
_a571("[부화] 마지막 알이 20초 넘게 안 끝남 — 그대로 두고 진행합니다")
end
end
_a584.egg.autoHatchOff()
if _a705 > 0 then
_a584.egg.hatchErr = nil
_a571(("[부화] %s × %d%s  (개당 %s %s)"):format(
_a700.id, _a705, _a714 and " (목표까지)" or "",
_a700.price and _a572(_a700.price, 0) or "?", tostring(_a700.currency)))
end
end
local function _a731()
local _a732 = _a611()
if not _a732 then return nil end
local _a733 = tonumber(rawget(_a732, "Rank")) or 1
local _a734 = tonumber(rawget(_a732, "RankStars")) or 0
local _a735 = rawget(_a732, "RedeemedRankRewards") or {}
local _a736
if _a582.RanksU and rawget(_a582.RanksU, "RankIDFromNumber") then
local _a737, _a738 = pcall(_a582.RanksU.RankIDFromNumber, _a733)
if _a737 then _a736 = _a738 end
end
local _a739 = _a736 and _a582.DirRanks and rawget(_a582.DirRanks, _a736)
if type(_a739) ~= "table" then
return { rankNum = _a733, stars = _a734, rankId = _a736, rewards = {} }
end
local _a740, _a741 = {}, 0
for _a742, _a743 in ipairs(rawget(_a739, "Rewards") or {}) do
_a741 += (tonumber(rawget(_a743, "StarsRequired")) or 0)
local _a744 = _a741 <= _a734
local _a745 = _a735[tostring(_a742)] ~= nil
_a740[#_a740 + 1] = {
index = _a742, need = _a741, earned = _a744, redeemed = _a745,
claimable = _a744 and not _a745,
}
end
return { rankNum = _a733, stars = _a734, rankId = _a736, rewards = _a740 }
end
local function _a746()
if not _a582.R_Rank then _a571("[랭크] Ranks_ClaimReward 리모트 없음") return end
local _a747 = _a731()
if not _a747 then return end
local _a748 = 0
for _a749, _a750 in ipairs(_a747.rewards) do
if not _a578.rank then break end
if _a750.claimable then
pcall(function() _a582.R_Rank:FireServer(_a750.index) end)
_a748 += 1
_a579.rank += 1
task.wait(0.1)
end
end
if _a748 > 0 then
_a571(("[랭크] 보상 %d개 수령  (Rank %d, ★%d)"):format(_a748, _a747.rankNum, _a747.stars))
end
end
function _a584.move.hrp()
local _a751 = _a570.Character
return _a751 and _a751:FindFirstChild("HumanoidRootPart"),
_a751 and _a751:FindFirstChildOfClass("Humanoid")
end
function _a584.egg.autoHatchOn(_a752, _a753)
if not _a577.UseAutoHatch then return end
if _a584.egg._ahEgg == _a752 and _a584.egg._ahAt and (os.clock() - _a584.egg._ahAt) < 15 then return end
_a584.egg._ahEgg, _a584.egg._ahAt = _a752, os.clock()
local _a754 = _a582.DirEggs and rawget(_a582.DirEggs, _a752)
if _a582.Hatch and _a754 and rawget(_a582.Hatch, "SetupEgg") then
local _a755, _a756 = pcall(_a582.Hatch.SetupEgg, _a754, _a753 or 1)
if not _a755 and not _a584.egg._ahWarn then
_a584.egg._ahWarn = true
_a571("[부화] SetupEgg 실패: " .. tostring(_a756) .. "  → 클릭 대체 사용")
end
end
if _a582.R_AHTog then pcall(function() _a582.R_AHTog:FireServer(true) end) end
if _a582.R_AHOn then pcall(function() _a582.R_AHOn:FireServer(_a752, _a753 or 1) end) end
if _a582.Hatch and rawget(_a582.Hatch, "IsHatching") then
local _a757, _a758 = pcall(_a582.Hatch.IsHatching)
_a584.egg._ahLive = _a757 and _a758 and true or false
end
end
function _a584.egg.autoHatchOff()
_a584.egg._ahEgg, _a584.egg._ahAt, _a584.egg._ahLive = nil, nil, nil
if _a582.Hatch and rawget(_a582.Hatch, "StopHatching") then pcall(_a582.Hatch.StopHatching) end
if _a582.R_AHOff then pcall(function() _a582.R_AHOff:FireServer() end) end
end
function _a584.egg.clickOnce()
if _a584.ctl.moving then return false end
local _a759 = _a584.screen.signal("egg")
if not _a759 then _a759 = _a584.screen.pressInGame({ "Egg Opening" }) end
if not _a759 and not _a584.egg._eggSigWarn then
_a584.egg._eggSigWarn = true
_a571("[부화] 게임 내 방법이 다 막힘 — SetupEgg 에만 의존합니다")
end
return _a759
end
function _a584.egg.watchStuck()
local _a760 = _a582.Vars
if not _a760 then return end
local _a761 = tonumber(rawget(_a760, "OpeningEgg")) or 0
if _a761 <= 0 then
_a584.egg.stuckSince, _a584.egg.stuckSaid = nil, nil
return
end
_a584.egg.stuckSince = _a584.egg.stuckSince or os.clock()
local _a762 = os.clock() - _a584.egg.stuckSince
if _a762 < 3 then return end
if not _a577.HatchClick then return end
if _a584.ctl.moving then _a584.screen.signal("egg") else _a584.egg.clickOnce() end
if _a762 > 6 and not _a584.egg.stuckSaid then
_a584.egg.stuckSaid = true
_a571("[부화] 까는 화면에서 멈춰 있어 계속 넘기는 중")
end
end
function _a584.item.applyPetSpeed()
local _a763 = _a582.PlayerPet
if not (_a763 and rawget(_a763, "GetByPlayer")) then return 0, "PlayerPet 없음" end
local _a764, _a765 = pcall(_a763.GetByPlayer, _a570)
if not (_a764 and type(_a765) == "table") then return 0, "펫 목록 못 읽음" end
local _a766 = math.max(1, tonumber(_a577.PetSpeedMult) or 50)
local _a767 = math.max(0.05, tonumber(_a577.PetSpeedBase) or 4)
local _a768 = 0
for _a769, _a770 in pairs(_a765) do
if type(_a770) == "table" then
local _a771 = rawget(_a770, "cpet")
if _a771 then
_a770.speedMult = _a766
pcall(function() _a771:Broadcast("petSpeedMult", _a766) end)
pcall(function() _a771:Broadcast("petSpeed", _a767) end)
_a768 += 1
end
end
end
return _a768
end
_a584.screen.SIGNAL = {
reward  = { pats = { "Rebirth", "Rank Up" }, sigs = {
{ np = 2, t = "table,boolean,boolean,number,table,boolean",
set = { {4,0}, {2,true}, {3,true}, {6,true} } },
{ np = 0, t = "boolean,boolean,number,table,boolean",
set = { {3,0}, {1,true}, {2,true}, {5,true} } },
} },
egg     = { pats = { "Egg Opening" },            minBools = 1 },
mastery = { pats = { "Mastery Perk" },           minBools = 1 },
card    = { pats = { "Card Flashing", "Card" },  minBools = 1 },
}
_a584.screen.BLOCKERS = {
{ "Rebirth",     "리버스",   "reward" },
{ "RankUp",      "랭크업",   "reward" },
{ "MasteryPerk", "마스터리", "mastery" },
{ "Card",        "카드",     "card" },
}
function _a584.screen.findSignalFns(_a772)
local _a773 = _a584.screen.SIGNAL[_a772]
if not _a773 then return {} end
_a584.screen._sig = _a584.screen._sig or {}
local _a774 = _a584.screen._sig[_a772]
if _a774 and (os.clock() - _a774.at) < (#_a774.fns > 0 and 20 or 3) then return _a774.fns end
local _a775 = {}
_a584.screen._sig[_a772] = { at = os.clock(), fns = _a775 }
if type(getgc) ~= "function" or type(debug) ~= "table"
or type(debug.info) ~= "function" or type(debug.getupvalue) ~= "function" then
return _a775
end
local _a776 = {}
for _a777, _a778 in ipairs({ true, false }) do
local _a779, _a780 = pcall(getgc, _a778)
if _a779 and type(_a780) == "table" then
for _a781, _a782 in ipairs(_a780) do _a776[#_a776 + 1] = _a782 end
end
end
if #_a776 == 0 then return _a775 end
for _a783, _a784 in ipairs(_a776) do
if type(_a784) == "function" then
local _a785, _a786 = pcall(debug.info, _a784, "s")
if _a785 and type(_a786) == "string" then
local _a787 = false
for _a788, _a789 in ipairs(_a773.pats) do
if _a786:find(_a789, 1, true) then _a787 = true break end
end
if _a787 then
local _a790, _a791 = pcall(debug.info, _a784, "a")
if _a790 then
local _a792, _a793 = {}, 0
for _a794 = 1, 16 do
local _a795, _a796 = pcall(debug.getupvalue, _a784, _a794)
if not _a795 then break end
_a793 = _a794
_a792[_a794] = type(_a796)
end
local _a797 = table.concat(_a792, ",")
local _a798 = false
for _a799, _a800 in ipairs(_a773.sigs or {}) do
if _a791 == _a800.np and _a797 == _a800.t then
_a775[#_a775 + 1] = { fn = _a784, sig = _a797, n = _a793, np = _a791,
src = _a786, set = _a800.set }
_a798 = true
break
end
end
if not _a798 and _a773.sigs then
local _a801 = {}
for _a802, _a803 in ipairs(_a792) do
if _a803 == "boolean" then _a801[#_a801 + 1] = _a802 end
end
if #_a801 > 0 then
_a775[#_a775 + 1] = { fn = _a784, idx = _a801, sig = _a797, n = _a793,
np = _a791, src = _a786, loose = true }
end
end
if not _a798 and not _a773.sigs and _a791 == 0 then
local _a804 = 0
for _a805, _a806 in ipairs(_a792) do if _a806 == "boolean" then _a804 += 1 end end
if _a804 >= (_a773.minBools or 1) then
local _a807 = {}
for _a808, _a809 in ipairs(_a792) do
if _a809 == "boolean" then _a807[#_a807 + 1] = _a808 end
end
_a775[#_a775 + 1] = { fn = _a784, idx = _a807, sig = _a797, n = _a793, src = _a786 }
end
end
end
end
end
end
end
return _a775
end
function _a584.screen.signal(_a810)
if type(debug) ~= "table" or type(debug.setupvalue) ~= "function" then return false, 0 end
local _a811 = _a584.screen.findSignalFns(_a810)
local _a812 = 0
for _a813, _a814 in ipairs(_a811) do
if _a814.set then
for _a815, _a816 in ipairs(_a814.set) do
if pcall(debug.setupvalue, _a814.fn, _a816[1], _a816[2]) then _a812 += 1 end
end
elseif not _a814.loose then
for _a817, _a818 in ipairs(_a814.idx or {}) do
if pcall(debug.setupvalue, _a814.fn, _a818, true) then _a812 += 1 end
end
end
end
if _a812 == 0 then
for _a819, _a820 in ipairs(_a811) do
if _a820.loose then
for _a821, _a822 in ipairs(_a820.idx or {}) do
if pcall(debug.setupvalue, _a820.fn, _a822, true) then _a812 += 1 end
end
end
end
end
return _a812 > 0, _a812
end
function _a584.screen.pressInGame(_a823)
local _a824, _a825 = pcall(function() return game:GetService("UserInputService") end)
if not (_a824 and _a825) then return false end
local _a826 = {
UserInputType  = Enum.UserInputType.MouseButton1,
UserInputState = Enum.UserInputState.Begin,
KeyCode        = Enum.KeyCode.Unknown,
Position       = Vector3.new(),
Delta          = Vector3.new(),
}
local _a827 = 0
if type(getconnections) == "function" then
local _a828, _a829 = pcall(getconnections, _a825.InputBegan)
if _a828 and type(_a829) == "table" then
for _a830, _a831 in ipairs(_a829) do
local _a832 = ""
local _a833 = _a831.Function
if _a833 and type(debug) == "table" and type(debug.info) == "function" then
local _a834, _a835 = pcall(debug.info, _a833, "s")
if _a834 and _a835 then _a832 = tostring(_a835) end
end
local _a836 = false
for _a837, _a838 in ipairs(_a823) do
if _a832 ~= "" and _a832:find(_a838, 1, true) then _a836 = true break end
end
if _a836 then
if _a833 and pcall(_a833, _a826, false) then _a827 += 1
elseif _a831.Fire and pcall(function() _a831:Fire(_a826, false) end) then _a827 += 1
elseif _a831.Defer and pcall(function() _a831:Defer(_a826, false) end) then _a827 += 1 end
end
end
end
end
if _a827 == 0 and type(firesignal) == "function" then
if pcall(firesignal, _a825.InputBegan, _a826, false) then _a827 += 1 end
end
return _a827 > 0
end
function _a584.screen.realClick(_a839)
if not _a577.ScreenRealClick then return false end
local _a840 = workspace.CurrentCamera
local _a841 = (_a840 and _a840.ViewportSize) or Vector2.new(1280, 720)
local _a842, _a843 = _a841.X * 0.5, _a841.Y * 0.45
local _a844 = {}
local function _a845(_a846, _a847)
local _a848 = pcall(_a847)
_a844[#_a844 + 1] = _a846 .. (_a848 and "=OK" or "=X")
return _a848
end
local _a849 = false
if not _a849 and type(mouse1click) == "function" then
_a849 = _a845("mouse1click", function() mouse1click() end)
end
if not _a849 and type(mouse1press) == "function" then
_a849 = _a845("mouse1press", function()
mouse1press() task.wait(0.05)
if type(mouse1release) == "function" then mouse1release() end
end)
end
if not _a849 then
_a849 = _a845("VirtualUser", function()
local _a850 = game:GetService("VirtualUser")
_a850:Button1Down(Vector2.new(_a842, _a843), _a840 and _a840.CFrame or CFrame.new())
task.wait(0.05)
_a850:Button1Up(Vector2.new(_a842, _a843), _a840 and _a840.CFrame or CFrame.new())
end)
end
if not _a849 then
_a849 = _a845("VirtualInputManager", function()
local _a851 = game:GetService("VirtualInputManager")
_a851:SendMouseButtonEvent(_a842, _a843, 0, true, game, 1)
task.wait(0.05)
_a851:SendMouseButtonEvent(_a842, _a843, 0, false, game, 1)
end)
end
if _a839 then _a571("    " .. table.concat(_a844, " / ")) end
return _a849
end
function _a584.screen.rewardScreenUp()
if not _a570 then
if not _a584.screen.noLP then
_a584.screen.noLP = true
_a571("[화면] LocalPlayer 를 못 잡았습니다 — 화면 감시를 건너뜁니다")
end
return false
end
local _a852 = _a570:FindFirstChildOfClass("PlayerGui")
if _a852 then
for _a853, _a854 in ipairs(_a584.screen.BLOCKERS) do
local _a855 = _a852:FindFirstChild(_a854[1])
if _a855 and _a855:IsA("ScreenGui") and _a855.Enabled then return true, _a854[2], _a854[3] end
end
end
local _a856 = _a582.Vars
if _a856 then
if rawget(_a856, "IsRebirthing") then return true, "리버스", "reward" end
if rawget(_a856, "IsRankingUp") then return true, "랭크업", "reward" end
end
return false
end
function _a584.screen.dismissRewardScreens(_a857)
if _a584.screen.dismissBusy then return end
_a584.screen.dismissBusy = true
local _a858, _a859 = pcall(_a584.screen.dismissInner, _a857)
_a584.screen.dismissBusy = false
if not _a858 then _a571("[화면] 오류: " .. tostring(_a859)) end
end
function _a584.screen.dismissInner(_a860)
local _a861 = _a582.Vars
if not _a861 then return end
local _a862 = os.clock()
local _a863, _a864 = false, nil
local _a865 = 0
local _a866 = math.max(3, _a577.ScreenTryMax or 8)
while os.clock() - _a862 < (_a860 or 120) do
local _a867, _a868, _a869 = _a584.screen.rewardScreenUp()
if not _a867 then break end
_a863, _a864 = true, _a868
_a865 += 1
_a584.ctl.setAct("보상 화면 넘기는 중",
("%s (%d회%s)"):format(tostring(_a868), _a865,
_a865 <= 6 and " · 첫 화면 대기" or ""))
local _a870 = _a584.screen.SIGNAL[_a869 or "reward"]
local _a871 = (_a870 and _a870.pats) or { "Rebirth", "Rank Up" }
local _a872 = _a584.screen.signal(_a869 or "reward")
if not _a872 then
for _a873 in pairs(_a584.screen.SIGNAL) do
if _a584.screen.signal(_a873) then _a872 = true end
end
end
local _a874 = false
if not _a872 or _a865 >= 2 then
_a874 = _a584.screen.pressInGame(_a871)
end
if _a865 >= 3 then
if _a584.screen.realClick() then
_a874 = true
if not _a584.screen._realSaid then
_a584.screen._realSaid = true
_a571("[화면] 실제 클릭까지 같이 씁니다 (Roblox 창이 켜져 있어야 먹습니다)")
end
end
end
if (_a872 or _a874) and not _a584.screen._sigSaid then
_a584.screen._sigSaid = true
_a571("[화면] " .. (_a872 and "upvalue 신호" or "게임 내 입력 발동") .. " 로 넘깁니다")
end
if _a865 >= _a866 and (os.clock() - _a862) >= 12 then
if _a584.screen.giveUpSaid ~= _a868 then
_a584.screen.giveUpSaid = _a868
_a571(("[화면] %s 화면을 못 넘김 — 그냥 두고 자동화는 계속합니다"):format(tostring(_a868)))
_a571("        (이 화면은 UI만 가릴 뿐 리모트 호출은 막지 않습니다)")
end
_a584.screen.screenGaveUp = os.clock()
return
end
task.wait(0.8)
end
if _a863 then
if not _a584.screen.rewardScreenUp() then
_a584.screen.lastBlocker = nil
_a584.screen.screenGaveUp = nil
_a571(("[화면] %s 넘김 완료 (%d회)"):format(tostring(_a864), _a865))
end
end
end
function _a584.egg.eggUnlocked(_a875)
_a875 = tonumber(_a875)
if not _a875 then return false end
local _a876 = _a611()
local _a877 = _a876 and rawget(_a876, "UnlockedEggs")
if type(_a877) == "table" then
for _a878, _a879 in pairs(_a877) do
if tonumber(_a879) == _a875 then return true end
end
return false
end
return _a875 <= 1
end
function _a584.egg.lockedEggs()
local _a880 = {}
if not _a582.DirEggs then return _a880, 0, 0 end
local _a881 = _a611()
local _a882 = tonumber(_a881 and rawget(_a881, "MaximumAvailableEgg")) or 1
local _a883 = 0
local _a884 = _a881 and rawget(_a881, "UnlockedEggs")
if type(_a884) == "table" then
for _a885, _a886 in pairs(_a884) do
local _a887 = tonumber(_a886)
if _a887 and _a887 > _a883 then _a883 = _a887 end
end
end
for _a888, _a889 in pairs(_a582.DirEggs) do
if type(_a889) == "table" and not rawget(_a889, "isCustomEgg") then
local _a890 = tonumber(rawget(_a889, "eggNumber"))
if _a890 and _a890 <= _a882 and not _a584.egg.eggUnlocked(_a890) then
_a880[#_a880 + 1] = { id = _a888, num = _a890 }
end
end
end
table.sort(_a880, function(_a891, _a892) return _a891.num < _a892.num end)
return _a880, _a882, _a883
end
function _a584.egg.unlockEggs(_a893)
if not _a582.R_EggUn then return 0, "Eggs_RequestUnlock 리모트 없음" end
local _a894 = _a584.egg.lockedEggs()
if #_a894 == 0 then return 0 end
local _a895, _a896 = 0, nil
for _a897, _a898 in ipairs(_a894) do
if not _a584.egg.eggUnlocked(_a898.num) then
local _a899, _a900
pcall(function() _a899, _a900 = _a582.R_EggUn:InvokeServer(_a898.id) end)
if not _a899 and _a577.HatchAutoTp then
local _a901 = _a584.egg.tpEgg(_a898.id)
if _a901 then
task.wait(0.3)
pcall(function() _a899, _a900 = _a582.R_EggUn:InvokeServer(_a898.id) end)
end
end
if _a899 then
_a895 += 1
_a584.ctl.setAct("알 해금", ("#%d %s"):format(_a898.num, _a898.id))
_a571(("  🔓 알 해금  #%d %s"):format(_a898.num, _a898.id))
task.wait(0.15)
else
_a896 = _a900
if _a893 then
_a571(("[해금] #%d %s 실패: %s"):format(_a898.num, _a898.id, tostring(_a900)))
end
end
end
end
return _a895, _a896
end
function _a584.move.curZone()
if _a582.Map and rawget(_a582.Map, "GetCurrentZone") then
local _a902, _a903 = pcall(_a582.Map.GetCurrentZone)
if _a902 then return _a903 end
end
return nil
end
function _a584.move.zone1()
if not _a582.DirZones then return nil end
local _a904, _a905 = nil, math.huge
for _a906, _a907 in pairs(_a582.DirZones) do
if type(_a907) == "table" and _a584.move.ownsZone(_a906) then
local _a908 = tonumber(rawget(_a907, "ZoneNumber")) or math.huge
if _a908 < _a905 then _a904, _a905 = _a906, _a908 end
end
end
return _a904
end
function _a584.move.realZone(_a909) return _a909 end
function _a584.move.resolvableZone(_a910)
if _a910 then
local _a911 = _a584.move.zonePos(_a910)
if _a911 then return _a910, _a911 end
end
if not _a582.DirZones then return nil end
local _a912 = {}
for _a913, _a914 in pairs(_a582.DirZones) do
if type(_a914) == "table" and _a584.move.ownsZone(_a913) then
_a912[#_a912 + 1] = { id = _a913, n = tonumber(rawget(_a914, "ZoneNumber")) or 0 }
end
end
table.sort(_a912, function(_a915, _a916) return _a915.n > _a916.n end)
for _a917, _a918 in ipairs(_a912) do
if _a918.id ~= _a910 then
local _a919 = _a584.move.zonePos(_a918.id)
if _a919 then
if _a584.move.fallZone ~= _a918.id then
_a584.move.fallZone = _a918.id
_a571(("[TP] %s 좌표를 못 구해서 %s 로 대신 감 (로드 안 된 존)"):format(
tostring(_a910), tostring(_a918.id)))
end
return _a918.id, _a919
end
end
end
return nil
end
function _a584.move.bestZone()
if _a582.Zone and rawget(_a582.Zone, "GetMaxOwnedZone") then
local _a920, _a921, _a922 = pcall(_a582.Zone.GetMaxOwnedZone)
if _a920 and _a921 then return _a921, _a922 end
end
return _a584.move.zone1()
end
function _a584.move.ownsZone(_a923)
local _a924 = _a611()
local _a925 = _a924 and rawget(_a924, "UnlockedZones")
return (type(_a925) == "table" and _a925[_a923] ~= nil) or false
end
function _a584.move.zoneByNumber(_a926)
if not (_a582.DirZones and _a926) then return nil end
for _a927, _a928 in pairs(_a582.DirZones) do
if type(_a928) == "table" and tonumber(rawget(_a928, "ZoneNumber")) == tonumber(_a926) then
return _a927, _a928
end
end
return nil
end
local function _a929(_a930, _a931)
local _a932 = rawget(_a930, "Breakables")
local _a933 = type(_a932) == "table" and rawget(_a932, "Main") or nil
local _a934 = type(_a933) == "table" and rawget(_a933, "Data") or nil
if type(_a934) ~= "table" then return false end
for _a935, _a936 in pairs(_a934) do
local _a937 = type(_a936) == "table" and rawget(_a936, "Type") or nil
if _a937 and tostring(_a937):lower():find(_a931, 1, true) then return true end
end
return false
end
function _a584.move.zoneForBreakable(_a938)
if not (_a582.DirZones and _a938) then return nil end
local _a939 = tostring(_a938):lower()
local _a940 = _a584.move.bestZone()
if _a940 then
local _a941 = rawget(_a582.DirZones, _a940)
if type(_a941) == "table" and _a929(_a941, _a939) then return _a940 end
end
local _a942, _a943 = nil, -1
for _a944, _a945 in pairs(_a582.DirZones) do
if type(_a945) == "table" and _a944 ~= "Spawn" and _a584.move.ownsZone(_a944) then
local _a946 = rawget(_a945, "Breakables")
local _a947 = type(_a946) == "table" and rawget(_a946, "Main") or nil
local _a948 = type(_a947) == "table" and rawget(_a947, "Data") or nil
if type(_a948) == "table" then
for _a949, _a950 in pairs(_a948) do
local _a951 = type(_a950) == "table" and rawget(_a950, "Type") or nil
if _a951 and tostring(_a951):lower():find(_a939, 1, true) then
local _a952 = tonumber(rawget(_a945, "ZoneNumber")) or 0
if _a952 > _a943 then _a942, _a943 = _a944, _a952 end
break
end
end
end
end
end
return _a942
end
function _a584.move.tpZone(_a953)
if not _a953 then return false, "존 id 없음" end
if _a584.move.curZone() == _a953 then return true end
if not _a577.TpGameFallback then
_a571("[TP] 게임 정식 TP 차단됨 (" .. tostring(_a953) .. ")\n" .. debug.traceback("", 2))
return false, "게임 TP 꺼져 있음"
end
local _a954 = _a582.R_Tp
if _a582.Inst and rawget(_a582.Inst, "IsInInstance") then
local _a955, _a956 = pcall(_a582.Inst.IsInInstance)
if _a955 and _a956 and _a582.R_TpI then _a954 = _a582.R_TpI end
end
if not _a954 then return false, "텔레포트 리모트 없음" end
local _a957 = os.clock() - (_a584.move.lastTp or 0)
if _a957 < _a577.TpCooldown then task.wait(_a577.TpCooldown - _a957) end
_a584.move.lastTp = os.clock()
local _a958, _a959
pcall(function() _a958, _a959 = _a954:InvokeServer(_a953) end)
if not _a958 then return false, _a959 end
local _a960 = os.clock()
while os.clock() - _a960 < 5 do
if _a584.move.curZone() == _a953 then break end
task.wait(0.05)
end
task.wait(0.15)
return true
end
function _a584.move.glideTo(_a961)
if _a584.ctl.stopped() then return false, "정지됨" end
if _a584.ctl.moving and (os.clock() - _a584.ctl.moving) < 30 then
return false, "이미 이동 중 (다른 이동이 아직 안 끝남)"
end
_a584.ctl.moving = os.clock()
local _a962, _a963, _a964 = pcall(_a584.move.glideRaw, _a961)
_a584.ctl.moving = nil
if not _a962 then return false, tostring(_a963) end
return _a963, _a964
end
function _a584.move.glideRaw(_a965)
local _a966, _a967 = _a584.move.hrp()
if not _a966 then return false, "캐릭터 없음" end
if _a577.TpMode == "instant" then
local _a968 = _a965 + Vector3.new(0, 4, 0)
for _a969 = 1, 3 do
local _a970 = _a570.Character
local _a971, _a972 = _a584.move.hrp()
if not (_a970 and _a971) then return false, "캐릭터 없음" end
local _a973 = _a971.CFrame - _a971.CFrame.Position
pcall(function() _a970:PivotTo(CFrame.new(_a968) * _a973) end)
_a971.AssemblyLinearVelocity = Vector3.zero
for _a974 = 1, 6 do _a569.Heartbeat:Wait() end
if _a972 then
pcall(function()
_a972:Move(Vector3.new(0.3, 0, 0), false)
end)
task.wait(0.1)
pcall(function() _a972:Move(Vector3.zero, false) end)
end
task.wait(0.15)
_a971 = _a584.move.hrp()
if _a971 and (_a971.Position - _a968).Magnitude <= 30 then
local _a975 = os.clock()
while os.clock() - _a975 < 1.5 do
if _a584.move.inDottedBox() ~= false then break end
task.wait(0.05)
end
return true
end
if _a969 < 3 then task.wait(0.15) end
end
return false, "순간이동이 되돌려짐"
end
if _a577.TpMode == "walk" then
if not _a967 then return false, "Humanoid 없음" end
local _a976 = os.clock()
while os.clock() - _a976 < 45 do
local _a977 = _a966.Position
if (Vector3.new(_a977.X, 0, _a977.Z) - Vector3.new(_a965.X, 0, _a965.Z)).Magnitude < 8 then
return true
end
_a967:MoveTo(_a965)
task.wait(0.5)
end
return false, "걸어가다 시간초과"
end
if (_a966.Position - _a965).Magnitude <= (_a577.ArriveDist or 12) then return true end
local _a978 = math.max(16, tonumber(_a577.TpSpeed) or 90)
local _a979 = math.max(0, tonumber(_a577.TpHeight) or 0)
local function _a980(_a981, _a982)
local _a983 = 0
while _a983 < 2000 do
if _a584.ctl.stopped() then return false end
_a983 += 1
local _a984 = _a584.move.hrp()
if not _a984 then return false end
local _a985 = _a984.Position
local _a986 = _a981 - _a985
local _a987 = _a986.Magnitude
if _a987 < 2.5 then return true end
local _a988 = _a569.Heartbeat:Wait()
local _a989 = math.min(_a987, _a978 * math.min(_a988, 0.1))
local _a990 = _a982 and (Vector3.new(_a981.X, _a985.Y, _a981.Z)) or nil
if _a990 and (_a990 - _a985).Magnitude > 1 then
_a984.CFrame = CFrame.lookAt(_a985 + _a986.Unit * _a989, _a990)
else
_a984.CFrame = CFrame.new(_a985 + _a986.Unit * _a989) * (_a984.CFrame - _a984.Position)
end
_a984.AssemblyLinearVelocity = Vector3.zero
end
return false
end
if _a979 > 0 then
local _a991 = _a966.Position
local _a992 = math.max(_a991.Y, _a965.Y) + _a979
_a980(Vector3.new(_a991.X, _a992, _a991.Z), false)
_a980(Vector3.new(_a965.X, _a992, _a965.Z), true)
end
_a980(_a965 + Vector3.new(0, 3, 0), true)
local _a993 = _a584.move.hrp()
if _a993 then _a993.AssemblyLinearVelocity = Vector3.zero end
return true
end
local function _a994(_a995)
local _a996 = #_a995
if _a996 == 0 then return nil, 0 end
local _a997, _a998 = math.huge, -math.huge
local _a999, _a1000 = math.huge, -math.huge
local _a1001 = 0
for _a1002, _a1003 in ipairs(_a995) do
if _a1003.X < _a997 then _a997 = _a1003.X end
if _a1003.X > _a998 then _a998 = _a1003.X end
if _a1003.Z < _a999 then _a999 = _a1003.Z end
if _a1003.Z > _a1000 then _a1000 = _a1003.Z end
_a1001 += _a1003.Y
end
return Vector3.new((_a997 + _a998) / 2, _a1001 / _a996, (_a999 + _a1000) / 2), _a996
end
function _a584.move.breakCenter(_a1004)
local _a1005 = _a584.move.hrp()
if not _a1005 then return nil, 0 end
local _a1006 = workspace:FindFirstChild("__THINGS")
if not _a1006 then return nil, 0 end
local _a1007 = _a1005.Position
local _a1008 = {}
for _a1009, _a1010 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a1011 = _a1006:FindFirstChild(_a1010)
if _a1011 then
for _a1012, _a1013 in ipairs(_a1011:GetChildren()) do
local _a1014
if _a1013:IsA("BasePart") then _a1014 = _a1013.Position
elseif _a1013:IsA("Model") then
local _a1015, _a1016 = pcall(function() return _a1013:GetPivot() end)
if _a1015 and typeof(_a1016) == "CFrame" then _a1014 = _a1016.Position end
end
if _a1014 and (_a1014 - _a1007).Magnitude <= (_a1004 or 400) then
_a1008[#_a1008 + 1] = _a1014
end
end
end
end
return _a994(_a1008)
end
function _a584.move.groundY(_a1017, _a1018, _a1019)
_a1019 = tonumber(_a1019) or 0
local _a1020 = RaycastParams.new()
_a1020.FilterType = Enum.RaycastFilterType.Exclude
local _a1021 = {}
if _a570.Character then _a1021[#_a1021 + 1] = _a570.Character end
local _a1022 = workspace:FindFirstChild("__THINGS")
if _a1022 then _a1021[#_a1021 + 1] = _a1022 end
_a1020.FilterDescendantsInstances = _a1021
local _a1023 = Vector3.new(_a1017, _a1019 + 12, _a1018)
local _a1024, _a1025 = pcall(function()
return workspace:Raycast(_a1023, Vector3.new(0, -160, 0), _a1020)
end)
if _a1024 and _a1025 then
local _a1026 = _a1025.Position.Y
if math.abs(_a1026 - _a1019) <= 80 then return _a1026 + 4 end
end
return nil
end
function _a584.move.zonePos(_a1027, _a1028)
if not _a1027 then return nil, "존 id 없음" end
_a1027 = _a584.move.realZone(_a1027)
local _a1029 = _a582.DirZones and rawget(_a582.DirZones, _a1027)
local _a1030 = _a1029 and rawget(_a1029, "ZoneFolder")
local _a1031 = {}
do
local _a1032 = workspace:FindFirstChild("__THINGS")
for _a1033, _a1034 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a1035 = _a1032 and _a1032:FindFirstChild(_a1034)
if _a1035 then
for _a1036, _a1037 in ipairs(_a1035:GetChildren()) do
local _a1038
if _a1037:IsA("BasePart") then _a1038 = _a1037.Position
elseif _a1037:IsA("Model") then
local _a1039, _a1040 = pcall(function() return _a1037:GetPivot() end)
if _a1039 and typeof(_a1040) == "CFrame" then _a1038 = _a1040.Position end
end
if _a1038 then _a1031[#_a1031 + 1] = _a1038 end
end
end
end
end
local _a1041 = {}
local function _a1042(_a1043, _a1044)
if not _a1043 then return end
local _a1045, _a1046 = pcall(function() return _a1043:GetDescendants() end)
if _a1043:IsA("BasePart") then _a1041[#_a1041 + 1] = { p = _a1043.Position, why = _a1044 } end
if _a1045 then
for _a1047, _a1048 in ipairs(_a1046) do
if _a1048:IsA("BasePart") then
_a1041[#_a1041 + 1] = { p = _a1048.Position, why = _a1044 .. "/" .. _a1048.Name }
end
end
end
end
if _a582.ZonesU then
for _a1049, _a1050 in ipairs({ "GetBreakableZones", "GetBreakableSpawns" }) do
local _a1051 = rawget(_a582.ZonesU, _a1050)
if type(_a1051) == "function" then
local _a1052, _a1053 = pcall(_a1051, _a1027)
if _a1052 and _a1053 then _a1042(_a1053, _a1050) end
end
end
end
if _a1030 then
for _a1054, _a1055 in ipairs({ "BREAK_ZONES", "BREAKABLE_SPAWNS" }) do
local _a1056, _a1057 = pcall(function() return _a1030:FindFirstChild(_a1055, true) end)
if _a1056 and _a1057 then _a1042(_a1057, "ZoneFolder/" .. _a1055) end
end
end
local _a1058, _a1059, _a1060
for _a1061, _a1062 in ipairs(_a1041) do
local _a1063 = 0
for _a1064, _a1065 in ipairs(_a1031) do
if (_a1065 - _a1062.p).Magnitude <= 150 then _a1063 += 1 end
end
if not _a1059 or _a1063 > _a1059 then _a1058, _a1059, _a1060 = _a1062.p, _a1063, _a1062.why end
end
local _a1066, _a1067
if _a1058 and (_a1059 or 0) >= 1 then
_a1066, _a1067 = _a1058, ("%s (브레이커블 %d개)"):format(tostring(_a1060), _a1059)
end
if not _a1066 and _a1058 then
_a1066, _a1067 = _a1058, tostring(_a1060) .. " (브레이커블 없음)"
end
if not _a1066 and _a582.ZonesU and rawget(_a582.ZonesU, "GetTeleportPartLocation") then
local _a1068, _a1069 = pcall(_a582.ZonesU.GetTeleportPartLocation, _a1027)
if _a1068 and typeof(_a1069) == "CFrame" then
_a1066, _a1067 = _a1069.Position, "PERSISTENT/Teleport (스트리밍 대기)"
end
end
if not _a1066 then return nil, "브레이커블 위치를 못 찾음" end
local _a1070 = _a584.move.groundY(_a1066.X, _a1066.Z, _a1066.Y)
if _a1070 then
_a1066 = Vector3.new(_a1066.X, _a1070, _a1066.Z)
_a1067 = _a1067 .. " +지면"
else
_a1066 = Vector3.new(_a1066.X, _a1066.Y + 5, _a1066.Z)
end
return _a1066, _a1067
end
function _a584.move.goToZone(_a1071, _a1072, _a1073, _a1074)
_a1071 = _a584.move.realZone(_a1071)
if not _a1071 then return false, "존 id 없음" end
local _a1075, _a1076 = _a584.move.zonePos(_a1071)
if not _a1075 then
if _a577.TpGameFallback and _a584.move.curZone() ~= _a1071 then
local _a1077, _a1078 = _a584.move.tpZone(_a1071)
if not _a1077 then return false, _a1078 end
task.wait(0.3)
_a1075, _a1076 = _a584.move.zonePos(_a1071)
end
if not _a1075 then
local _a1079, _a1080 = _a584.move.resolvableZone(_a1071)
if _a1079 and _a1080 then
if _a1074 then
return false, ("%s 가 로드되지 않음"):format(tostring(_a1071))
end
_a1071, _a1075, _a1076 = _a1079, _a1080, "대체 존 " .. tostring(_a1079)
else
if _a584.move.zoneFailSaid ~= _a1071 then
_a584.move.zoneFailSaid = _a1071
_a571(("[TP] %s 좌표 실패: %s (갈 수 있는 존이 없음)"):format(
tostring(_a1071), tostring(_a1076)))
end
return false, _a1076
end
end
end
local _a1081 = _a584.move.hrp()
if not _a1073 and _a1081 and _a584.move.curZone() == _a1071 then
local _a1082 = _a584.move.inDottedBox()
local _a1083
if _a1082 ~= nil then
_a1083 = _a1082
else
_a1083 = (_a1081.Position - _a1075).Magnitude <= (_a577.ZoneArriveDist or 90)
end
if _a1083 then
if _a1072 then _a571("[TP] 이미 " .. _a1071 .. " 사냥터 안에 있음") end
return true
end
end
if _a1072 then
_a571(("[TP] %s 내부 좌표 %s → (%.0f, %.0f, %.0f)"):format(
_a1071, tostring(_a1076), _a1075.X, _a1075.Y, _a1075.Z))
end
local _a1084, _a1085 = _a584.move.glideTo(_a1075)
local _a1086 = _a584.move.hrp()
if _a1086 and (_a1086.Position - _a1075).Magnitude > math.max(40, _a577.ArriveDist or 12) then
task.wait(0.2)
_a584.ctl.moving = nil
_a584.move.glideTo(_a1075)
local _a1087 = _a584.move.hrp()
local _a1088 = _a1087 and (_a1087.Position - _a1075).Magnitude or -1
if _a1088 > math.max(40, _a577.ArriveDist or 12) then
local _a1089 = _a577.TpMode
_a577.TpMode = "glide"
_a584.ctl.moving = nil
_a584.move.glideTo(_a1075)
_a577.TpMode = _a1089
local _a1090 = _a584.move.hrp()
_a1088 = _a1090 and (_a1090.Position - _a1075).Magnitude or -1
if _a1088 > math.max(40, _a577.ArriveDist or 12) then
_a571(("[TP] %s 이동 실패 — %.0f스터드 남음 (순간이동·glide 둘 다)"):format(
tostring(_a1071), _a1088))
return false, "이동이 되돌려짐"
end
_a571("[TP] 순간이동이 막혀서 glide 로 이동함: " .. tostring(_a1071))
end
end
do
local _a1091 = _a584.move.hrp()
if _a1091 and (_a1091.Position.Y - _a1075.Y) > 25 then
_a571(("[TP] 목표보다 %.0f 높은 곳에 얹힘 — 내려감"):format(_a1091.Position.Y - _a1075.Y))
_a584.ctl.moving = nil
_a584.move.glideTo(Vector3.new(_a1075.X, _a1075.Y, _a1075.Z))
end
end
if tostring(_a1076):find("스트리밍", 1, true) then
task.wait(1.2)
local _a1092, _a1093 = _a584.move.zonePos(_a1071)
if _a1092 and not tostring(_a1093):find("스트리밍", 1, true) then
if _a1072 then
_a571("[TP] 스트리밍 로드됨 → 사냥터로 (" .. tostring(_a1093) .. ")")
end
_a584.ctl.moving = nil
_a584.move.glideTo(_a1092)
_a1075, _a1076 = _a1092, _a1093
end
end
if _a584.move.inDottedBox() == false then
task.wait(0.2)
local _a1094, _a1095 = _a584.move.breakCenter(400)
if _a1094 and _a1095 >= 3 then
if _a1072 then
_a571(("[TP] 네모 밖 → 주변 브레이커블 %d개 중심으로 보정"):format(_a1095))
end
_a584.ctl.moving = nil
_a584.move.glideTo(_a1094)
_a1075 = _a1094
end
if _a584.move.inDottedBox() == false then
local _a1096 = _a584.move.zonePos(_a1071)
if _a1096 and (_a1096 - _a1075).Magnitude > 5 then
if _a1072 then _a571("[TP] 아직 네모 밖 → 좌표 재계산 후 재시도") end
_a584.ctl.moving = nil
_a584.move.glideTo(_a1096)
_a1075 = _a1096
end
end
if _a584.move.inDottedBox() == false and _a1072 then
_a571(("[TP] %s 네모 안으로 못 들어감 (좌표 %s)"):format(_a1071, tostring(_a1076)))
end
end
local function _a1097()
if _a584.move.inDottedBox() == true then return false end
local _a1098, _a1099 = _a584.move.breakCenter(400)
if (_a1099 or 0) >= 1 then return false end
task.wait(0.6)
if _a584.move.inDottedBox() == true then return false end
local _a1100, _a1101 = _a584.move.breakCenter(400)
return (_a1101 or 0) < 1
end
if _a1097() and (os.clock() - (_a584.move.lastRecover or -999)) > 30 then
_a584.move.lastRecover = os.clock()
_a571(("[TP] %s 근처에 브레이커블이 없음 (%s) — 좌표 확인 필요"):format(
tostring(_a1071), tostring(_a1076)))
end
_a584.move.zoneFailSaid = nil
_a584.move.arrivedZone = _a1071
do
local _a1102 = _a584.move.hrp()
local _a1103 = _a1102 and (_a1102.Position - _a1075).Magnitude or 0
if _a1103 > math.max(60, _a577.ArriveDist or 12) then
_a571(("[TP] %s 도착 실패 — %.0f스터드 남음 (되돌려짐)"):format(tostring(_a1071), _a1103))
return false, "이동이 되돌려짐"
end
end
local _a1104 = _a584.move.hrp()
if _a1072 and _a1104 then
_a571(("[TP] 도착. 목표까지 %.0f스터드 / 존 %s / 네모안 %s"):format(
(_a1104.Position - _a1075).Magnitude, tostring(_a584.move.curZone()), tostring(_a584.move.inDottedBox())))
end
return true
end
function _a584.egg.tpEgg(_a1105)
if not _a1105 then return false, "알 id 없음" end
for _a1106, _a1107 in ipairs(_a584.egg.eggStands()) do
if _a1107.id == _a1105 then
if _a1107.dist <= _a577.EggRange then return true, _a1105 end
local _a1108, _a1109 = _a584.move.glideTo(_a1107.pos)
return _a1108, _a1108 and _a1105 or _a1109
end
end
if _a577.TpGameFallback then
local _a1110 = _a582.DirEggs and rawget(_a582.DirEggs, _a1105)
local _a1111 = _a1110 and select(1, _a584.move.zoneByNumber(rawget(_a1110, "zoneNumber")))
if _a1111 and _a584.move.curZone() ~= _a1111 then
local _a1112, _a1113 = _a584.move.tpZone(_a1111)
if not _a1112 then return false, _a1113 end
task.wait(0.5)
_a584.egg._standsAt = nil
for _a1114, _a1115 in ipairs(_a584.egg.eggStands()) do
if _a1115.id == _a1105 then return _a584.move.glideTo(_a1115.pos), _a1105 end
end
end
end
return false, "알 받침대를 못 찾음 (" .. tostring(_a1105) .. ")"
end
function _a584.item.stacks(_a1116)
local _a1117 = _a611()
local _a1118 = _a1117 and rawget(_a1117, "Inventory")
local _a1119 = _a1118 and rawget(_a1118, _a1116)
if type(_a1119) ~= "table" then return {} end
local _a1120 = {}
for _a1121, _a1122 in pairs(_a1119) do
if type(_a1122) == "table" then
_a1120[#_a1120 + 1] = {
uid = _a1121,
id = tostring(rawget(_a1122, "id")),
tier = tonumber(rawget(_a1122, "tn")) or 1,
am = tonumber(rawget(_a1122, "_am")) or 1,
}
end
end
return _a1120
end
_a584.item.PERTIER = {
Potion  = { 3, 3, 4, 5, 5, 5, 5, 5, 7, 7, 7 },
Enchant = { 5, 5, 5, 7, 7, 7, 7, 7, 10, 10 },
}
function _a584.item.perTier(_a1123, _a1124)
_a1124 = tonumber(_a1124)
local _a1125 = _a582.Bal and rawget(_a582.Bal,
_a1123 == "Potion" and "CalcPotionsPerTierRequired" or "CalcEnchantsPerTierRequired")
if type(_a1125) == "function" then
local _a1126, _a1127 = pcall(_a1125, _a1124)
_a1127 = _a1126 and tonumber(_a1127) or nil
if _a1127 and _a1127 > 0 then return _a1127 end
if not _a1126 and not _a584.item.perTierWarned then
_a584.item.perTierWarned = true
_a571("[퀘스트] 재료 수량 함수 막힘 → 기본표로 계산 (" .. tostring(_a1127) .. ")")
end
end
local _a1128 = _a584.item.PERTIER[_a1123]
local _a1129 = _a1128 and _a1124 and _a1128[_a1124]
return (_a1129 and _a1129 > 0) and _a1129 or nil
end
function _a584.item.upgradeTo(_a1130, _a1131)
local _a1132 = (_a1130 == "Potion") and _a582.R_PotUp or _a582.R_EncUp
if not _a1132 then return 0, (_a1130 .. " 업글 리모트 없음") end
local _a1133 = math.max(1, (tonumber(_a1131) or 2) - 1)
local _a1134 = _a584.item.perTier(_a1130, _a1133)
if not _a1134 then return 0, ("T%d 재료 수량을 못 읽음"):format(_a1133) end
local _a1135, _a1136 = {}, 0
for _a1137, _a1138 in ipairs(_a584.item.stacks(_a1130)) do
if _a1138.tier == _a1133 then
local _a1139 = math.floor(_a1138.am / _a1134)
if _a1139 > 0 then _a1135[_a1138.uid] = _a1139 _a1136 += _a1139 end
end
end
if _a1136 < 1 then return 0, ("T%d 재료 부족 (T%d %d개당 1개)"):format(_a1133, _a1133, _a1134) end
local _a1140, _a1141
pcall(function() _a1140, _a1141 = _a1132:InvokeServer(_a1135) end)
if not _a1140 then return 0, tostring(_a1141) end
return _a1136
end
function _a584.item.usePotion(_a1142, _a1143)
if not _a582.R_PotUse then return 0, "Potions: Consume 리모트 없음" end
_a1142 = tonumber(_a1142) or 1
local _a1144 = {}
for _a1145, _a1146 in ipairs(_a584.item.stacks("Potion")) do
if _a1146.tier >= _a1142 and _a1146.am >= 1 then _a1144[#_a1144 + 1] = _a1146 end
end
if #_a1144 == 0 then return 0, ("T%d 이상 포션 없음"):format(_a1142) end
table.sort(_a1144, function(_a1147, _a1148) return _a1147.tier < _a1148.tier end)
local _a1149, _a1150 = _a1143, 0
for _a1151, _a1152 in ipairs(_a1144) do
for _a1153 = 1, math.min(_a1149, _a1152.am) do
if _a1149 < 1 or not _a578.quest then break end
pcall(function() _a582.R_PotUse:FireServer(_a1152.uid, 1) end)
_a1150 += 1
_a1149 -= 1
task.wait(0.12)
end
if _a1149 < 1 then break end
end
return _a1150
end
_a584.ev.EVENTKIND = {
[31]="CoinJar",    [37]="CoinJar",    [68]="CoinJar",
[32]="Comet",      [38]="Comet",      [69]="Comet",
[66]="Pinata",     [43]="Pinata",     [70]="Pinata",
[67]="LuckyBlock", [44]="LuckyBlock", [71]="LuckyBlock",
}
_a584.ev.BESTONLY = { [37]=true, [38]=true, [43]=true, [44]=true, [39]=true, [76]=true }
_a584.ev.CHESTKIND = { [8]="MiniChests", [39]="MiniChests", [72]="MiniChests",
[75]="SuperiorMiniChests", [76]="SuperiorMiniChests", [77]="SuperiorMiniChests" }
local function _a1154(_a1155)
if typeof(_a1155) == "Vector3" then return _a1155 end
if typeof(_a1155) == "CFrame" then return _a1155.Position end
if type(_a1155) == "table" then
local _a1156, _a1157, _a1158 = tonumber(_a1155.X or _a1155.x or _a1155[1]), tonumber(_a1155.Y or _a1155.y or _a1155[2]), tonumber(_a1155.Z or _a1155.z or _a1155[3])
if _a1156 and _a1157 and _a1158 then return Vector3.new(_a1156, _a1157, _a1158) end
end
return nil
end
function _a584.ev.events()
local _a1159
if _a582.Rand and rawget(_a582.Rand, "GetActive") then
local _a1160, _a1161 = pcall(_a582.Rand.GetActive)
if _a1160 and type(_a1161) == "table" and next(_a1161) then _a1159 = _a1161 end
end
if not _a1159 and _a582.R_Events then
local _a1162, _a1163 = pcall(function() return _a582.R_Events:InvokeServer() end)
if _a1162 and type(_a1163) == "table" then _a1159 = _a1163 end
end
if type(_a1159) ~= "table" then return {} end
local _a1164 = workspace:GetServerTimeNow()
local _a1165 = {}
for _a1166, _a1167 in pairs(_a1159) do
if type(_a1167) == "table" then
local _a1168 = tostring(rawget(_a1167, "id") or "")
local _a1169 = _a1168:match("|%s*(%S+)%s*$") or _a1168
local _a1170 = tonumber(rawget(_a1167, "started")) or 0
local _a1171 = tonumber(rawget(_a1167, "duration")) or 0
_a1165[#_a1165 + 1] = {
uid = rawget(_a1167, "uid"),
id = _a1168,
kind = _a1169,
name = rawget(_a1167, "name") or _a1169,
zone = rawget(_a1167, "parentID"),
pos = _a1154(rawget(_a1167, "origin")),
left = math.max(0, _a1171 - (_a1164 - _a1170)),
}
end
end
table.sort(_a1165, function(_a1172, _a1173) return _a1172.left > _a1173.left end)
return _a1165
end
_a584.ev.SPAWN = {
CoinJar    = { rem = "CoinJar_Spawn",           key = "coin jar",
order = { "basic", "giant", "magic" } },
Comet      = { rem = "Comet_Spawn",             key = "comet" },
Pinata     = { rem = "MiniPinata_Consume",      key = "pinata" },
LuckyBlock = { rem = "MiniLuckyBlock_Consume",  key = "lucky block" },
}
function _a584.move.inDottedBox()
if _a582.Map and rawget(_a582.Map, "IsInDottedBox") then
local _a1174, _a1175 = pcall(_a582.Map.IsInDottedBox)
if _a1174 then return _a1175 and true or false end
end
return nil
end
function _a584.ev.spawnItems(_a1176)
local _a1177 = _a584.ev.SPAWN[_a1176]
if not _a1177 then return {} end
local _a1178 = {}
for _a1179, _a1180 in ipairs({ "Misc", "Consumable", "Lootbox" }) do
for _a1181, _a1182 in ipairs(_a584.item.stacks(_a1180)) do
local _a1183 = _a1182.id:lower()
if _a1183:find(_a1177.key, 1, true) then
local _a1184 = 99
if _a1177.order then
for _a1185, _a1186 in ipairs(_a1177.order) do
if _a1183:find(_a1186, 1, true) then _a1184 = _a1185 break end
end
end
_a1182.rank = _a1184
_a1178[#_a1178 + 1] = _a1182
end
end
end
table.sort(_a1178, function(_a1187, _a1188)
if _a1187.rank ~= _a1188.rank then return _a1187.rank < _a1188.rank end
return _a1187.tier < _a1188.tier
end)
return _a1178
end
function _a584.ev.spawnEvent(_a1189)
local _a1190 = _a584.ev.SPAWN[_a1189]
if not _a1190 then return 0, "소환 불가 종류" end
local _a1191 = _a575:FindFirstChild(_a1190.rem)
if not _a1191 then return 0, _a1190.rem .. " 리모트 없음" end
local _a1192 = _a584.ev.spawnItems(_a1189)
if #_a1192 == 0 then return 0, _a1189 .. " 아이템 없음" end
local _a1193 = _a584.move.inDottedBox()
if _a1193 == false then return 0, "점선 네모 안이 아님" end
local _a1194, _a1195 = 0, nil
for _a1196, _a1197 in ipairs(_a1192) do
if _a1194 >= (_a577.SpawnPerCycle or 1) or not _a578.quest then break end
local _a1198, _a1199
pcall(function() _a1198, _a1199 = _a1191:InvokeServer(_a1197.uid) end)
if _a1198 then
_a1194 += 1
_a584.ctl.setAct("소환", _a1189 .. " · " .. _a1197.id)
_a571(("  🎁 %s 소환  (%s)"):format(_a1189, _a1197.id))
task.wait(0.4)
else
_a1195 = _a1199
break
end
end
return _a1194, _a1195
end
function _a584.ev.findEvent(_a1200, _a1201)
local _a1202 = _a1201 and _a584.move.bestZone() or nil
local _a1203
for _a1204, _a1205 in ipairs(_a584.ev.events()) do
if _a1205.kind == _a1200 and _a1205.left > 15 then
if not _a1201 or _a1205.zone == _a1202 then
if not _a1203 or (_a1205.zone == _a584.move.curZone() and _a1203.zone ~= _a584.move.curZone()) then
_a1203 = _a1205
end
end
end
end
return _a1203
end
function _a584.ev.findChest(_a1206, _a1207)
local _a1208 = workspace:FindFirstChild("__THINGS")
if not _a1208 then return nil end
local _a1209 = tostring(_a1206):lower():find("superior") ~= nil
local _a1210 = _a584.move.hrp()
local _a1211 = _a1210 and _a1210.Position
local _a1212, _a1213, _a1214, _a1215
for _a1216, _a1217 in ipairs(_a1208:GetChildren()) do
if tostring(_a1217.Name):lower():find("chest", 1, true) then
for _a1218, _a1219 in ipairs(_a1217:GetChildren()) do
local _a1220
if _a1219:IsA("BasePart") then _a1220 = _a1219.Position
elseif _a1219:IsA("Model") then
local _a1221, _a1222 = pcall(function() return _a1219:GetPivot() end)
if _a1221 and typeof(_a1222) == "CFrame" then _a1220 = _a1222.Position end
end
if _a1220 then
local _a1223 = _a1211 and (_a1220 - _a1211).Magnitude or 0
local _a1224 = (tostring(_a1219.Name) .. tostring(_a1217.Name)):lower()
:find("superior", 1, true) ~= nil
if not _a1215 or _a1223 < _a1215 then _a1214, _a1215 = _a1220, _a1223 end
if _a1224 == _a1209 and (not _a1213 or _a1223 < _a1213) then
_a1212, _a1213 = _a1220, _a1223
end
end
end
end
end
if _a1212 then return _a1212, _a1213 end
return _a1214, _a1215
end
_a584.quest.SKIP = { [4] = true, [5] = true, [40] = true, [41] = true }
_a584.quest.WHERE = {
[21]="bestzone", [9]="bestzone", [37]="bestzone", [38]="bestzone", [39]="bestzone",
[43]="bestzone", [44]="bestzone", [76]="bestzone", [30]="bestzone", [8]="bestzone",
[20]="bestegg",  [42]="bestegg",
[1]="breakable", [81]="zoneid",
}
function _a584.item.petStacks()
local _a1225 = _a611()
local _a1226 = _a1225 and rawget(_a1225, "Inventory")
local _a1227 = _a1226 and rawget(_a1226, "Pet")
local _a1228 = {}
if type(_a1227) ~= "table" then return _a1228 end
for _a1229, _a1230 in pairs(_a1227) do
if type(_a1230) == "table" then
_a1228[#_a1228 + 1] = {
uid = _a1229,
id = tostring(rawget(_a1230, "id")),
pt = tonumber(rawget(_a1230, "pt")) or 0,
am = tonumber(rawget(_a1230, "_am")) or 1,
}
end
end
return _a1228
end
function _a584.item.bestEggPets()
local _a1231 = _a659()
local _a1232 = _a1231 and _a582.DirEggs and rawget(_a582.DirEggs, _a1231)
local _a1233 = _a1232 and rawget(_a1232, "pets")
local _a1234 = {}
if type(_a1233) == "table" then
for _a1235, _a1236 in pairs(_a1233) do
local _a1237 = type(_a1236) == "table" and _a1236[1] or _a1236
if _a1237 then _a1234[tostring(_a1237)] = true end
end
end
return _a1234, _a1231
end
function _a584.item.makeVariant(_a1238, _a1239)
local _a1240 = (_a1238 == "gold") and _a582.R_Gold or _a582.R_Rain
if not _a1240 then return 0, (_a1238 .. " 머신 리모트 없음") end
local _a1241 = (_a1238 == "gold") and 0 or 1
local _a1242
if _a1239 then
local _a1243, _a1244 = _a584.item.bestEggPets()
if not next(_a1243) then return 0, "최고 알(" .. tostring(_a1244) .. ") 펫 목록을 못 읽음" end
_a1242 = _a1243
end
local _a1245, _a1246 = 0, nil
for _a1247, _a1248 in ipairs(_a584.item.petStacks()) do
if not _a578.quest then break end
if _a1248.pt == _a1241 and _a1248.am >= 10 and (not _a1242 or _a1242[_a1248.id]) then
local _a1249 = math.floor(_a1248.am / 10)
if _a1249 > 0 then
local _a1250, _a1251
pcall(function() _a1250, _a1251 = _a1240:InvokeServer(_a1248.uid, _a1249) end)
if _a1250 then
_a1245 += _a1249
_a571(("  ✨ %s 제작  %s x%d"):format(
_a1238 == "gold" and "골드" or "레인보우", _a1248.id, _a1249))
task.wait(0.4)
else
_a1246 = _a1251
end
end
end
end
return _a1245, _a1246
end
function _a584.item.useFlag(_a1252)
if not _a582.R_Flag then return 0, "FlexibleFlags_Consume 리모트 없음" end
local _a1253, _a1254 = 0, nil
for _a1255, _a1256 in ipairs(_a584.item.stacks("Misc")) do
if _a1253 >= (_a1252 or 1) then break end
if _a1256.id:lower():find("flag", 1, true) and _a1256.am >= 1 and _a584.item.itemAllowed(_a1256.id) then
local _a1257, _a1258
pcall(function() _a1257, _a1258 = _a582.R_Flag:InvokeServer(_a1256.id, _a1256.uid, 1) end)
if _a1257 then _a1253 += 1 task.wait(0.4) else _a1254 = _a1258 end
end
end
return _a1253, _a1254
end
function _a584.item.useFruit(_a1259)
if not _a582.R_Fruit then return 0, "Fruits: Consume 리모트 없음" end
local _a1260 = _a584.item.activeBuffs("Fruits")
local _a1261 = 0
for _a1262, _a1263 in ipairs(_a584.item.stacks("Fruit")) do
if _a1261 >= (_a1259 or 1) then break end
if _a1263.am >= 1 and _a584.item.itemAllowed(_a1263.id) and not _a1260[_a1263.id] then
pcall(function() _a582.R_Fruit:FireServer(_a1263.uid, 1) end)
_a1261 += 1
task.wait(0.4)
end
end
return _a1261
end
function _a584.quest.status()
local _a1264 = _a611()
if not _a1264 then return nil end
local _a1265 = rawget(_a1264, "Goals")
if type(_a1265) ~= "table" then return { list = {} } end
local _a1266 = {}
for _a1267, _a1268 in pairs(_a1265) do
if type(_a1268) == "table" then
local _a1269 = tonumber(rawget(_a1268, "Type")) or -1
local _a1270
if _a582.Quest and rawget(_a582.Quest, "MakeTitle") then
local _a1271, _a1272 = pcall(_a582.Quest.MakeTitle, _a1268)
if _a1271 then _a1270 = _a1272 end
end
_a1266[#_a1266 + 1] = {
slot = _a1267,
uid = tostring(rawget(_a1268, "UID")),
type = _a1269,
how = _a583[_a1269],
title = _a1270 or ("Type " .. _a1269),
amount = tonumber(rawget(_a1268, "Amount")) or 0,
progress = tonumber(rawget(_a1268, "Progress")) or 0,
stars = tonumber(rawget(_a1268, "Stars")) or 0,
potionTier = tonumber(rawget(_a1268, "PotionTier")),
enchantTier = tonumber(rawget(_a1268, "EnchantTier")),
breakable = rawget(_a1268, "BreakableType") or rawget(_a1268, "BreakableDirID"),
zoneId = rawget(_a1268, "ZoneID"),
where = _a584.quest.WHERE[_a1269] or (_a583[_a1269] == "farm" and "bestzone" or nil),
event = _a584.ev.EVENTKIND[_a1269],
chest = _a584.ev.CHESTKIND[_a1269],
bestOnly = _a584.ev.BESTONLY[_a1269] or false,
ignored = _a584.quest.IGNORE[_a1269],
}
end
end
table.sort(_a1266, function(_a1273, _a1274) return _a1273.stars > _a1274.stars end)
return { list = _a1266, rank = tonumber(rawget(_a1264, "Rank")) or 1,
rankStars = tonumber(rawget(_a1264, "RankStars")) or 0 }
end
_a584.quest.BESTDEP = {
[20]=true, [21]=true, [37]=true, [38]=true, [39]=true,
[43]=true, [44]=true, [76]=true,
}
function _a584.quest.bestDepActive()
local _a1275 = _a584.ctl.lockGoal and _a584.ctl.lockGoal.q
if not _a1275 then return false end
if _a584.quest.IGNORE[_a1275.type] then return false end
if not _a584.quest.BESTDEP[_a1275.type] then return false end
local _a1276 = _a584.quest.findQuest(_a1275.uid)
if not _a1276 or _a1276.progress >= _a1276.amount then return false end
return true, _a1276
end
function _a584.quest.canDo(_a1277, _a1278)
if _a1277.how == "hatch" or _a1277.where == "bestegg" then
local _a1279 = _a684()
if not _a1279 then return false, "알 정보를 못 읽음" end
if not _a1279.price then return true end
if not _a1278 then
if _a1279.canBuy < 1 then
return false, ("돈 부족 — %s 개당 %s %s / 보유 %s"):format(
tostring(_a1279.id), _a572(_a1279.price, 0), tostring(_a1279.currency), _a572(_a1279.have, 0))
end
return true
end
local _a1280 = math.max(1, (_a1277.amount or 1) - (_a1277.progress or 0))
local _a1281 = _a1280
if _a1277.type == 2 or _a1277.type == 42 or _a1277.type == 47 then
_a1281 = math.max(_a1280, _a577.HatchMinAfford or 10)
end
if _a1279.canBuy < _a1281 then
_a584.quest.moneyUntil = os.clock() + math.max(0, _a577.MoneyDwell or 60)
return false, ("돈 모으는 중 — %d개분 필요 / 지금 %d개분 (개당 %s %s)"):format(
_a1281, _a1279.canBuy, _a572(_a1279.price, 0), tostring(_a1279.currency))
end
if _a584.quest.moneyUntil and os.clock() < _a584.quest.moneyUntil then
return false, ("조금 더 벌고 감 (%.0f초 남음)"):format(_a584.quest.moneyUntil - os.clock())
end
_a584.quest.moneyUntil = nil
end
return true
end
function _a584.quest.findQuest(_a1282)
local _a1283 = _a584.quest.status()
for _a1284, _a1285 in ipairs(_a1283 and _a1283.list or {}) do
if _a1285.uid == _a1282 then return _a1285 end
end
return nil
end
function _a584.quest.pursue(_a1286)
local _a1287, _a1288
if _a1286.how == "hatch" then _a1287, _a1288 = _a695, "mhatch"
elseif _a1286.how == "zone" then _a1287, _a1288 = _a654, "zone"
elseif _a1286.how == "gold" or _a1286.how == "rainbow" then
local _a1289 = (_a1286.type == 40 or _a1286.type == 41)
_a1288 = "quest"
_a1287 = function()
local _a1290 = _a584.item.makeVariant("gold", _a1289) or 0
if _a1286.how == "rainbow" then
_a1290 += (_a584.item.makeVariant("rainbow", _a1289) or 0)
end
if _a1290 > 0 then
_a584.ctl.setAct(_a1286.how == "gold" and "골드 합성" or "레인보우 합성", _a1290 .. "마리")
return
end
_a584.ctl.setAct("재료 모으는 중", "최고 알 부화")
local _a1291 = _a578.mhatch
_a578.mhatch = true
pcall(_a695)
_a578.mhatch = _a1291
end
end
local _a1292 = _a1286.progress
local _a1293 = os.clock()
_a584.ctl.setGoal(_a1286.title, ("%d/%d"):format(_a1286.progress, _a1286.amount))
local function _a1294()
if not _a1286.event then return end
local _a1295 = _a584.ev.findEvent(_a1286.event, _a1286.bestOnly)
if _a1295 then
_a584.ctl.setAct(_a1286.event .. " 진행 중", ("%d초 남음"):format(_a1295.left))
if _a1295.pos then
local _a1296 = _a584.move.hrp()
if _a1296 and (_a1296.Position - _a1295.pos).Magnitude > (_a577.EventStayDist or 45) then
_a584.move.glideTo(_a1295.pos)
end
end
return
end
local _a1297, _a1298 = _a584.ev.spawnEvent(_a1286.event)
if _a1297 > 0 then
_a584.ctl.setAct("소환", _a1286.event)
task.wait(0.5)
elseif _a1298 and _a584.ev.spawnErr ~= tostring(_a1298) then
_a584.ev.spawnErr = tostring(_a1298)
_a571("[퀘스트] " .. _a1286.event .. " 소환 실패: " .. tostring(_a1298))
end
end
local _a1299, _a1300 = pcall(function()
while _a578.quest and not _a584.ctl.stopped() do
local _a1301, _a1302 = _a584.quest.canDo(_a1286, false)
if not _a1301 then
_a571(("[퀘스트] %s → 다른 퀘스트 먼저 (%s)"):format(tostring(_a1286.title), tostring(_a1302)))
return
end
_a1294()
if _a1287 then
local _a1303 = _a578[_a1288]
_a578[_a1288] = true
local _a1304, _a1305 = pcall(_a1287)
_a578[_a1288] = _a1303
if not _a1304 then error(_a1305, 0) end
elseif _a1286.event then
task.wait(0.4)
else
task.wait(2)
end
local _a1306 = _a584.quest.findQuest(_a1286.uid)
if not _a1306 then
_a571("[퀘스트] 완료 — " .. tostring(_a1286.title))
return
end
_a584.ctl.setGoal(_a1306.title, ("%d/%d"):format(_a1306.progress, _a1306.amount))
if _a1306.progress >= _a1306.amount then
_a571(("[퀘스트] 달성 %d/%d — %s"):format(_a1306.progress, _a1306.amount, tostring(_a1306.title)))
return
end
if _a1306.progress > _a1292 then
_a1293 = os.clock()
_a571(("[퀘스트] %d/%d  %s"):format(_a1306.progress, _a1306.amount, tostring(_a1306.title)))
end
_a1292 = _a1306.progress
local _a1307 = os.clock() - _a1293
if _a1307 >= math.max(10, _a577.PursueStallSec or 60) then
_a571(("[퀘스트] %.0f초째 진행 없음 (%d/%d) — 다음 단계로: %s"):format(
_a1307, _a1306.progress, _a1306.amount, tostring(_a1306.title)))
return
end
task.wait(0.2)
end
end)
if not _a1299 then _a571("[퀘스트] " .. tostring(_a1286.how) .. " 오류: " .. tostring(_a1300)) end
_a584.ctl.lockGoal = nil
_a584.ctl.setGoal(nil)
end
function _a584.quest.cycle()
do
local _a1308 = _a578.rank
_a578.rank = true
pcall(_a746)
_a578.rank = _a1308
end
local _a1309 = _a584.quest.status()
if not _a1309 then return end
local _a1310, _a1311, _a1312 = false, false, false
local _a1313 = {}
local _a1314 = nil
for _a1315, _a1316 in ipairs(_a1309.list) do
if not _a578.quest then break end
local _a1317, _a1318 = true, nil
if not _a1316.ignored and _a1316.progress < _a1316.amount then
_a1317, _a1318 = _a584.quest.canDo(_a1316, true)
end
if _a1316.ignored then
if _a1316.progress < _a1316.amount then
_a1313[#_a1313 + 1] = tostring(_a1316.title) .. "  — " .. _a1316.ignored
end
elseif not _a1317 then
local _a1319 = tostring(_a1316.uid) .. tostring(_a1318)
if _a584.item.skipSaid ~= _a1319 then
_a584.item.skipSaid = _a1319
_a571(("[퀘스트] 건너뜀: %s   (%s)"):format(tostring(_a1316.title), tostring(_a1318)))
end
elseif _a1316.progress < _a1316.amount then
local _a1320 = _a1316.where
if _a1316.event then
if not _a1314 or _a1314.rank > 0 then _a1314 = { rank = 0, kind = "event", q = _a1316 } end
elseif _a1316.chest then
if not _a1314 or _a1314.rank > 1 then _a1314 = { rank = 1, kind = "chest", q = _a1316 } end
elseif _a1320 == "bestegg" then
if not _a1314 or _a1314.rank > 1 then _a1314 = { rank = 1, kind = "egg", q = _a1316 } end
elseif _a1320 == "breakable" and _a1316.breakable then
if not _a1314 or _a1314.rank > 2 then _a1314 = { rank = 2, kind = "breakable", q = _a1316 } end
elseif _a1320 == "zoneid" and _a1316.zoneId then
if not _a1314 or _a1314.rank > 2 then _a1314 = { rank = 2, kind = "zoneid", q = _a1316 } end
elseif _a1320 == "bestzone" or _a1320 == "breakable" then
if not _a1314 then _a1314 = { rank = 3, kind = "bestzone", q = _a1316 } end
end
if _a1316.how == "farm" then
_a1310 = true
elseif _a1316.how == "hatch" then
_a1311 = true
elseif _a1316.how == "zone" then
_a1312 = true
elseif _a1316.how == "potup" and _a577.QuestUpgrade then
local _a1321, _a1322 = _a584.item.upgradeTo("Potion", _a1316.potionTier or 2)
if _a1321 > 0 then
_a579.potup += _a1321
_a579.quest += 1
_a571(("[퀘스트] 포션 T%d %d개 제작  (%s)"):format(_a1316.potionTier or 2, _a1321, _a1316.title))
elseif _a1322 and not tostring(_a1322):find("부족") then
if _a584.item.potUpSaid ~= tostring(_a1322) then
_a584.item.potUpSaid = tostring(_a1322)
_a571("[퀘스트] 포션 업글 실패: " .. tostring(_a1322))
end
end
elseif _a1316.how == "encup" and _a577.QuestUpgrade then
local _a1323, _a1324 = _a584.item.upgradeTo("Enchant", _a1316.enchantTier or 2)
if _a1323 > 0 then
_a579.potup += _a1323
_a579.quest += 1
_a571(("[퀘스트] 인챈트 T%d %d개 제작  (%s)"):format(_a1316.enchantTier or 2, _a1323, _a1316.title))
elseif _a1324 and not tostring(_a1324):find("부족") then
if _a584.item.encUpSaid ~= tostring(_a1324) then
_a584.item.encUpSaid = tostring(_a1324)
_a571("[퀘스트] 인챈트 업글 실패: " .. tostring(_a1324))
end
end
elseif _a1316.how == "potuse" and _a577.QuestUsePotion then
_a584.item.lastUse = _a584.item.lastUse or {}
local _a1325 = _a584.item.lastUse[_a1316.uid]
if _a1325 and _a1325.used > 0 and _a1316.progress <= _a1325.progress then
if not _a1325.gaveUp then
_a1325.gaveUp = true
_a571("[퀘스트] 포션을 마셔도 진행도가 안 올라서 중단: " .. tostring(_a1316.title))
end
else
local _a1326 = math.min(_a577.QuestUseMax, math.max(1, _a1316.amount - _a1316.progress))
local _a1327, _a1328 = _a584.item.usePotion(_a1316.potionTier or 1, _a1326)
_a584.item.lastUse[_a1316.uid] = { used = _a1327, progress = _a1316.progress }
if _a1327 > 0 then
_a579.potuse += _a1327
_a579.quest += 1
_a571(("[퀘스트] 포션 %d개 사용  (%s)"):format(_a1327, _a1316.title))
elseif _a1328 and not tostring(_a1328):find("없음") then
_a571("[퀘스트] 포션 사용 실패: " .. tostring(_a1328))
end
end
elseif _a1316.how == "gold" or _a1316.how == "rainbow" then
local _a1329, _a1330 = _a584.item.makeVariant(_a1316.how, _a1316.type == 40 or _a1316.type == 41)
if _a1329 > 0 then
_a579.quest += 1
_a571(("[퀘스트] %s 펫 %d마리 제작  (%s)"):format(
_a1316.how == "gold" and "골드" or "레인보우", _a1329, _a1316.title))
elseif _a1330 then
_a571("[퀘스트] " .. _a1316.how .. " 실패: " .. tostring(_a1330))
end
elseif _a1316.how == "fruituse" then
local _a1331 = _a584.item.useFruit(math.max(1, _a1316.amount - _a1316.progress))
if _a1331 > 0 then
_a579.quest += 1
_a571(("[퀘스트] 과일 %d개 사용  (%s)"):format(_a1331, _a1316.title))
end
elseif _a1316.how == "flaguse" then
local _a1332, _a1333 = _a584.item.useFlag(math.max(1, _a1316.amount - _a1316.progress))
if _a1332 > 0 then
_a579.quest += 1
_a571(("[퀘스트] 깃발 %d개 사용  (%s)"):format(_a1332, _a1316.title))
elseif _a1333 then
_a571("[퀘스트] 깃발 실패: " .. tostring(_a1333))
end
elseif not _a1316.how then
_a1313[#_a1313 + 1] = _a1316.title
end
end
end
if _a577.QuestLock and _a584.ctl.lockGoal then
local _a1334
for _a1335, _a1336 in ipairs(_a1309.list) do
if _a1336.uid == _a584.ctl.lockGoal.q.uid and _a1336.progress < _a1336.amount then _a1334 = _a1336 break end
end
if _a1334 then
_a584.ctl.lockGoal.q = _a1334
_a1314 = _a584.ctl.lockGoal
else
if _a584.ctl.lockGoal.q then
_a571("[퀘스트] 완료/교체됨 → 다음 목표로: " .. tostring(_a584.ctl.lockGoal.q.title))
end
_a584.ctl.lockGoal = nil
end
end
if _a577.QuestLock and _a1314 then _a584.ctl.lockGoal = _a1314 end
if _a577.QuestTp and _a1314 and _a578.quest then
local _a1337, _a1338, _a1339
if _a1314.kind == "event" then
local _a1340 = _a584.ev.findEvent(_a1314.q.event, _a1314.q.bestOnly)
if _a1340 then
_a1339 = ("%s @%s (%d초 남음)"):format(_a1340.name, tostring(_a1340.zone), _a1340.left)
if _a1340.pos then _a1337, _a1338 = _a584.move.glideTo(_a1340.pos)
else _a1337, _a1338 = _a584.move.goToZone(_a1340.zone) end
else
local _a1341 = _a1314.q.bestOnly and _a584.move.bestZone() or (_a584.move.curZone() or _a584.move.bestZone())
_a1339 = _a1314.q.event .. " 소환용 " .. tostring(_a1341)
local _a1342 = _a584.move.inDottedBox()
_a1337, _a1338 = _a584.move.goToZone(_a1341, false, _a1342 == false, _a1314.q.bestOnly)
if _a1337 then
local _a1343, _a1344 = _a584.ev.spawnEvent(_a1314.q.event)
if _a1343 < 1 and tostring(_a1344):find("점선") then
_a584.move.goToZone(_a1341, false, true)
task.wait(0.2)
_a1343, _a1344 = _a584.ev.spawnEvent(_a1314.q.event)
end
if _a1343 > 0 then
_a1339 = ("%s %d개 소환 @%s"):format(_a1314.q.event, _a1343, tostring(_a1341))
else
_a1338 = _a1344
_a1337 = false
end
end
end
elseif _a1314.kind == "chest" then
local _a1345 = _a1314.q.bestOnly and _a584.move.bestZone() or _a584.move.curZone()
local _a1346, _a1347 = _a584.ev.findChest(_a1314.q.chest, _a1345)
_a1339 = _a1314.q.chest .. " @" .. tostring(_a1345)
if _a1346 then
if not _a1347 or _a1347 > 20 then _a584.move.glideTo(_a1346) end
_a1337 = true
else
_a1337, _a1338 = _a584.move.goToZone(_a1345)
_a1339 = _a1339 .. " (상자 없음 → 존 가운데)"
end
elseif _a1314.kind == "egg" then
local _a1348 = _a659()
_a1339 = "최고 알 " .. tostring(_a1348)
if _a1348 then _a1337, _a1338 = _a584.egg.tpEgg(_a1348) else _a1338 = "최고 알을 못 찾음" end
elseif _a1314.kind == "breakable" then
local _a1349 = _a584.move.zoneForBreakable(_a1314.q.breakable)
_a1339 = tostring(_a1314.q.breakable) .. " 나오는 존 " .. tostring(_a1349)
if _a1349 then _a1337, _a1338 = _a584.move.goToZone(_a1349, true) else _a1338 = "그 브레이커블이 나오는 존이 없음" end
elseif _a1314.kind == "zoneid" then
_a1339 = "존 " .. tostring(_a1314.q.zoneId)
_a1337, _a1338 = _a584.move.goToZone(_a1314.q.zoneId)
else
local _a1350 = _a584.move.bestZone()
local _a1351 = _a1314.q.bestOnly or _a584.quest.BESTDEP[_a1314.q.type] or false
if _a1350 then _a1337, _a1338 = _a584.move.goToZone(_a1350, true, false, _a1351)
else _a1338 = "최고 존을 못 찾음" end
_a1339 = "최고 존 " .. tostring(_a584.move.arrivedZone or _a1350)
if not _a1337 then _a1338 = _a1350 end
end
if _a1337 then
if _a584.quest.lastGoal ~= _a1339 then
_a584.quest.lastGoal = _a1339
_a571("[퀘스트] " .. _a1339 .. " 으로 이동  (" .. tostring(_a1314.q.title) .. ")")
end
_a584.quest.pursue(_a1314.q)
else
local _a1352 = _a1338 and tostring(_a1338) or "이유 불명"
if _a584.quest.lastFail ~= _a1352 then
_a584.quest.lastFail = _a1352
_a571(("[퀘스트] 진행 못 함: %s   (%s / %s)"):format(
_a1352, tostring(_a1314.kind), tostring(_a1314.q.title)))
_a571(("           현재 존 %s / 최고 존 %s / 점선네모 %s"):format(
tostring(_a584.move.curZone()), tostring(_a584.move.bestZone()), tostring(_a584.move.inDottedBox())))
end
end
end
if _a577.QuestDrive and _a584.auto.turnOn then
if _a1310  then _a584.auto.turnOn("farm",   "파밍 퀘스트 → 자동 파밍") end
if _a1312  then _a584.auto.turnOn("zone",   "존 퀘스트 → 자동 존 해금") end
if _a1311 then _a584.auto.turnOn("mhatch", "부화 퀘스트 → 자동 부화") end
end
if #_a1313 > 0 and not _a584.quest.manualWarned then
_a584.quest.manualWarned = true
_a571("[퀘스트] 수동으로 해야 하는 것:")
for _a1353, _a1354 in ipairs(_a1313) do _a571("    · " .. tostring(_a1354)) end
elseif #_a1313 == 0 then
_a584.quest.manualWarned = false
end
return _a1314 ~= nil
end
local function _a1355(_a1356)
local _a1357 = {}
for _a1358 in tostring(_a1356 or ""):gmatch("[^,]+") do
_a1358 = _a1358:match("^%s*(.-)%s*$")
if _a1358 ~= "" then _a1357[#_a1357 + 1] = _a1358:lower() end
end
return _a1357
end
function _a584.item.itemAllowed(_a1359)
local _a1360 = tostring(_a1359):lower()
for _a1361, _a1362 in ipairs(_a1355(_a577.ItemBlock)) do
if _a1360:find(_a1362, 1, true) then return false end
end
local _a1363 = _a1355(_a577.ItemAllow)
if #_a1363 == 0 then return true end
for _a1364, _a1365 in ipairs(_a1363) do
if _a1360:find(_a1365, 1, true) then return true end
end
return false
end
function _a584.item.activeBuffs(_a1366)
local _a1367 = _a611()
local _a1368 = _a1367 and rawget(_a1367, _a1366)
local _a1369 = {}
if type(_a1368) == "table" then
for _a1370, _a1371 in pairs(_a1368) do
if type(_a1371) == "table" and next(_a1371) then _a1369[_a1370] = true
elseif _a1371 then _a1369[_a1370] = true end
end
end
return _a1369
end
local function _a1372(_a1373, _a1374, _a1375, _a1376)
local _a1377 = _a584.item.activeBuffs(_a1374)
local _a1378 = {}
local _a1379 = { total = 0, act = 0, blocked = 0, few = 0, ok = 0 }
for _a1380, _a1381 in ipairs(_a584.item.stacks(_a1373)) do
_a1379.total += 1
if _a1377[_a1381.id] then _a1379.act += 1
elseif not _a584.item.itemAllowed(_a1381.id) then _a1379.blocked += 1
elseif _a1381.am <= _a577.ItemKeep then _a1379.few += 1
else
_a1379.ok += 1
local _a1382 = _a1378[_a1381.id]
local _a1383
if not _a1382 then _a1383 = true
elseif _a577.BuffHighTier then _a1383 = _a1381.tier > _a1382.tier
else _a1383 = _a1381.tier < _a1382.tier end
if _a1383 then _a1378[_a1381.id] = _a1381 end
end
end
if _a1379.ok == 0 and _a1379.total > 0 then
local _a1384 = ("%s %d종 중 사용 가능 0 (이미걸림 %d / 제외 %d / 재고부족 %d)")
:format(_a1373, _a1379.total, _a1379.act, _a1379.blocked, _a1379.few)
if _a584.item.buffSaid ~= _a1384 then
_a584.item.buffSaid = _a1384
_a571("[아이템] " .. _a1384)
end
elseif _a1379.ok > 0 then
_a584.item.buffSaid = nil
end
local _a1385 = {}
for _a1386, _a1387 in pairs(_a1378) do _a1385[#_a1385 + 1] = _a1387 end
table.sort(_a1385, function(_a1388, _a1389)
if _a1388.tier ~= _a1389.tier then return _a1388.tier > _a1389.tier end
return _a1388.am > _a1389.am
end)
local _a1390 = {}
for _a1391, _a1392 in ipairs(_a1385) do
if not _a578.items then break end
if _a1376 and _a1376.left <= 0 then break end
local _a1393 = pcall(function() _a1375(_a1392.uid, 1) end)
if _a1393 then
_a1390[#_a1390 + 1] = ("%s T%d"):format(_a1392.id, _a1392.tier)
_a579.items += 1
if _a1376 then _a1376.left -= 1 end
task.wait(0.12)
end
end
return _a1390
end
function _a584.item.cycleItems()
local function _a1394()
local _a1395 = {}
if _a577.BuffPotion then _a1395[#_a1395 + 1] = { "Potion", "Potions" } end
if _a577.BuffFruit then _a1395[#_a1395 + 1] = { "Fruit", "Fruits" } end
if _a577.BuffConsumable then _a1395[#_a1395 + 1] = { "Consumable", "Consumables" } end
for _a1396, _a1397 in ipairs(_a1395) do
local _a1398 = _a584.item.activeBuffs(_a1397[2])
for _a1399, _a1400 in ipairs(_a584.item.stacks(_a1397[1])) do
if _a1400.am > _a577.ItemKeep and _a584.item.itemAllowed(_a1400.id) and not _a1398[_a1400.id] then
return true
end
end
end
if _a577.BuffUltimate and _a582.R_Ult then
local _a1401 = _a611()
local _a1402 = _a1401 and rawget(_a1401, "Ultimates")
if type(_a1402) == "table" then
for _a1403 in pairs(_a1402) do
if _a584.item.itemAllowed(_a1403) then
if not (_a582.Ult and rawget(_a582.Ult, "IsCharged")) then return true end
local _a1404, _a1405 = pcall(_a582.Ult.IsCharged, _a1403)
if _a1404 and _a1405 then return true end
end
end
end
end
return false
end
if not _a1394() then return end
if _a577.ItemBestZone then
local _a1406 = _a584.move.bestZone()
if _a1406 and _a584.move.curZone() ~= _a1406 then
if not _a577.ItemTp then
if not _a584.item.itemZoneWarned then
_a584.item.itemZoneWarned = true
_a571(("[아이템] 최고 존(%s)이 아니라 대기 — 현재 %s"):format(
tostring(_a1406), tostring(_a584.move.curZone())))
end
return
end
local _a1407, _a1408 = _a584.move.goToZone(_a1406)
if not _a1407 then
_a571("[아이템] 최고 존 이동 실패: " .. tostring(_a1408))
return
end
_a571("[아이템] 최고 존 " .. tostring(_a1406) .. " 에서 사용")
end
_a584.item.itemZoneWarned = false
end
local _a1409 = {}
local _a1410  = { left = math.max(1, _a577.BuffMaxPotion or 5) }
local _a1411 = { left = math.max(1, _a577.BuffMaxOther or 2) }
if _a577.BuffPotion and _a582.R_PotUse then
local _a1412 = _a1372("Potion", "Potions", function(_a1413, _a1414)
_a582.R_PotUse:FireServer(_a1413, _a1414)
end, _a1410)
for _a1415, _a1416 in ipairs(_a1412) do _a1409[#_a1409 + 1] = "포션 " .. _a1416 end
end
if _a577.BuffFruit and _a582.R_Fruit then
local _a1417 = _a1372("Fruit", "Fruits", function(_a1418, _a1419)
_a582.R_Fruit:FireServer(_a1418, _a1419)
end, _a1411)
for _a1420, _a1421 in ipairs(_a1417) do _a1409[#_a1409 + 1] = "과일 " .. _a1421 end
end
if _a577.BuffConsumable and _a582.R_Cons then
local _a1422 = _a1372("Consumable", "Consumables", function(_a1423, _a1424)
_a582.R_Cons:InvokeServer(_a1423, _a1424)
end, _a1411)
for _a1425, _a1426 in ipairs(_a1422) do _a1409[#_a1409 + 1] = "소모품 " .. _a1426 end
end
if _a577.BuffUltimate and _a582.R_Ult then
local _a1427 = _a611()
local _a1428 = _a1427 and rawget(_a1427, "Ultimates")
if type(_a1428) == "table" then
for _a1429 in pairs(_a1428) do
if not _a578.items then break end
if _a584.item.itemAllowed(_a1429) then
local _a1430 = true
if _a582.Ult and rawget(_a582.Ult, "IsCharged") then
local _a1431, _a1432 = pcall(_a582.Ult.IsCharged, _a1429)
_a1430 = _a1431 and _a1432 and true or false
end
if _a1430 then
local _a1433
pcall(function() _a1433 = _a582.R_Ult:InvokeServer(_a1429) end)
if _a1433 then
_a1409[#_a1409 + 1] = "얼티밋 " .. tostring(_a1429)
_a579.items += 1
task.wait(0.3)
end
end
end
end
end
end
if #_a1409 > 0 then
_a584.ctl.setAct("버프 사용", table.concat(_a1409, ", "))
_a571("[아이템] " .. table.concat(_a1409, ", ") .. " 사용")
end
end
function _a584.mach.slotStatus()
local _a1434 = _a611()
if not _a1434 then return nil end
local _a1435 = tonumber(rawget(_a1434, "PetSlotsPurchased")) or 0
local _a1436 = tonumber(rawget(_a1434, "EggSlotsPurchased")) or 0
local _a1437, _a1438 = 0, 0
if _a582.RankC then
if rawget(_a582.RankC, "GetMaxPurchasableEquipSlots") then
local _a1439, _a1440 = pcall(_a582.RankC.GetMaxPurchasableEquipSlots)
if _a1439 and tonumber(_a1440) then _a1437 = tonumber(_a1440) end
end
if rawget(_a582.RankC, "GetMaxPurchasableEggSlots") then
local _a1441, _a1442 = pcall(_a582.RankC.GetMaxPurchasableEggSlots)
if _a1441 and tonumber(_a1442) then _a1438 = tonumber(_a1442) end
end
end
local _a1443, _a1444
if _a1435 < _a1437 then
_a1443 = _a1435 + 1
if type(_a582.CalcPetS) == "function" then
local _a1445, _a1446 = pcall(_a582.CalcPetS, _a1443)
if _a1445 then _a1444 = tonumber(_a1446) end
end
end
local _a1447, _a1448, _a1449
if _a1436 < _a1438 and _a582.RankC and rawget(_a582.RankC, "GetEggBundle") then
local _a1450, _a1451, _a1452 = pcall(_a582.RankC.GetEggBundle, _a1436 + 1)
if _a1450 and tonumber(_a1451) then
_a1447, _a1448 = tonumber(_a1451), tonumber(_a1452) or 1
if type(_a582.CalcEggS) == "function" then
local _a1453, _a1454 = 0, false
for _a1455 = _a1447 - _a1448 + 1, _a1447 do
local _a1456, _a1457 = pcall(_a582.CalcEggS, _a1455)
if _a1456 and tonumber(_a1457) then _a1453 += tonumber(_a1457) else _a1454 = true end
end
if not _a1454 then _a1449 = _a1453 end
end
end
end
local _a1458
if _a582.Egg and rawget(_a582.Egg, "GetMaxHatch") then
local _a1459, _a1460 = pcall(_a582.Egg.GetMaxHatch)
if _a1459 then _a1458 = tonumber(_a1460) end
end
return {
dia = _a626("Diamonds"),
petOwned = _a1435, petMax = _a1437, petNext = _a1443, petCost = _a1444,
eggOwned = _a1436, eggMax = _a1438, eggEnd = _a1447, eggSize = _a1448, eggCost = _a1449,
maxEquip = tonumber(rawget(_a1434, "MaxPetsEquipped")), maxHatch = _a1458,
}
end
function _a584.move.machinePos(_a1461)
local _a1462
if _a582.Machine and rawget(_a582.Machine, "GetModels") then
local _a1463, _a1464 = pcall(_a582.Machine.GetModels, _a1461)
if _a1463 and type(_a1464) == "table" then
for _a1465, _a1466 in pairs(_a1464) do
if typeof(_a1466) == "Instance" then _a1462 = _a1466 break end
end
end
end
if not _a1462 then
local _a1467, _a1468 = pcall(function()
return game:GetService("CollectionService"):GetTagged("Machine")
end)
if _a1467 then
for _a1469, _a1470 in ipairs(_a1468) do
if _a1470.Name == _a1461 then _a1462 = _a1470 break end
end
end
end
if not _a1462 then return nil end
if _a1462:IsA("BasePart") then return _a1462.Position end
local _a1471, _a1472 = pcall(function() return _a1462:GetPivot() end)
return (_a1471 and typeof(_a1472) == "CFrame") and _a1472.Position or nil
end
function _a584.mach.cycleSlots()
local _a1473 = 0
local _a1474 = 0
while _a578.slots and not _a584.ctl.stopped() and _a1474 < 40 do
_a1474 += 1
local _a1475 = _a584.mach.slotStatus()
if not _a1475 then return end
local _a1476 = _a577.SlotPet and _a1475.petNext and _a1475.petCost
and (_a1475.dia - _a577.SlotReserve) >= _a1475.petCost
local _a1477 = _a577.SlotEgg and _a1475.eggEnd and _a1475.eggCost
and (_a1475.dia - _a577.SlotReserve) >= _a1475.eggCost
if _a1476 and _a1477 then
if _a1475.eggCost < _a1475.petCost then _a1476 = false else _a1477 = false end
end
if not (_a1476 or _a1477) then break end
local _a1478, _a1479, _a1480, _a1481
local function _a1482()
if _a1476 then
pcall(function() _a1478, _a1479 = _a582.R_PetSlot:InvokeServer(_a1475.petNext) end)
else
pcall(function() _a1478, _a1479 = _a582.R_EggSlot:InvokeServer(_a1475.eggEnd) end)
end
end
if _a1476 then
_a1480 = ("펫 장착 슬롯 #%d (%s 다이아)"):format(_a1475.petNext, _a572(_a1475.petCost, 0))
_a1481 = "EquipSlotsMachine"
else
_a1480 = ("알 부화 슬롯 %d칸 → %d (%s 다이아)"):format(
_a1475.eggSize, _a1475.eggEnd, _a572(_a1475.eggCost, 0))
_a1481 = "EggSlotsMachine"
end
_a1482()
if not _a1478 and tostring(_a1479):find("far away") then
local _a1483 = _a584.move.machinePos(_a1481)
if _a1483 then
_a584.ctl.setAct("슬롯 머신으로 이동", _a1481)
_a584.move.glideTo(_a1483)
task.wait(0.25)
_a1478, _a1479 = nil, nil
_a1482()
else
_a1479 = "머신 위치를 못 찾음 (" .. _a1481 .. ")"
end
end
if _a1478 then
_a1473 += 1
_a579.mslot += 1
_a584.mach.slotSaid = nil
_a584.ctl.setAct("슬롯 구매", _a1480)
_a571("  ⬆ " .. _a1480)
task.wait(0.35)
else
local _a1484 = _a1480 .. " 실패: " .. tostring(_a1479)
if _a584.mach.slotSaid ~= _a1484 then
_a584.mach.slotSaid = _a1484
_a571("[슬롯] " .. _a1484)
end
break
end
end
if _a1473 > 0 then
local _a1485 = _a584.mach.slotStatus()
_a571(("[슬롯] %d개 구매 — 장착 %s / 한번에 %s개 부화 (다이아 %s 남음)"):format(
_a1473, tostring(_a1485 and _a1485.maxEquip), tostring(_a1485 and _a1485.maxHatch),
_a572(_a626("Diamonds"), 0)))
end
end
function _a584.mach.upgList()
local _a1486 = {}
if not _a582.Upg then return _a1486 end
local _a1487, _a1488 = pcall(_a582.Upg.All)
if not (_a1487 and type(_a1488) == "table") then return _a1486 end
for _a1489, _a1490 in ipairs(_a1488) do
local _a1491, _a1492, _a1493 = rawget(_a1490, "UpgradeID"), rawget(_a1490, "ZoneID"), rawget(_a1490, "UpgradeTier")
if _a1491 and _a1492 and _a1493 then
local _a1494 = false
if rawget(_a582.Upg, "Owns") then
local _a1495, _a1496 = pcall(_a582.Upg.Owns, _a1491, _a1492)
_a1494 = _a1495 and _a1496 and true or false
end
local _a1497 = _a584.move.ownsZone(_a1492)
local _a1498 = _a582.DirUpg and rawget(_a582.DirUpg, _a1491)
local _a1499 = _a1498 and rawget(_a1498, "TierCosts")
local _a1500 = _a1499 and tonumber(_a1499[_a1493])
local _a1501 = "Diamonds"
local _a1502 = _a1498 and rawget(_a1498, "TierCurrencies")
local _a1503 = _a1502 and _a1502[_a1493]
if type(_a1503) == "table" and rawget(_a1503, "_id") then _a1501 = rawget(_a1503, "_id") end
local _a1504 = rawget(_a1490, "Model")
local _a1505
if typeof(_a1504) == "Instance" then
if _a1504:IsA("BasePart") then _a1505 = _a1504.Position
else
local _a1506, _a1507 = pcall(function() return _a1504:GetPivot() end)
if _a1506 and _a1507 then _a1505 = _a1507.Position end
end
end
_a1486[#_a1486 + 1] = {
id = _a1491, zone = _a1492, tier = _a1493, cost = _a1500, cur = _a1501,
bought = _a1494, zoneOwned = _a1497,
buyable = _a1497 and not _a1494,
pos = _a1505, model = _a1504,
}
end
end
table.sort(_a1486, function(_a1508, _a1509) return (_a1508.cost or math.huge) < (_a1509.cost or math.huge) end)
return _a1486
end
function _a584.mach.cycleUpg()
if not _a582.R_Upg then _a571("[맵업글] Upgrades_Purchase 리모트 없음") return end
local _a1510 = _a584.mach.upgList()
if #_a1510 == 0 then return end
local _a1511 = 0
for _a1512, _a1513 in ipairs(_a1510) do
if not _a578.mapupg then break end
if _a1513.buyable and _a1513.cost then
local _a1514 = _a626(_a1513.cur or "Diamonds")
if _a1514 - _a577.UpgReserve < _a1513.cost then break end
if _a577.UpgTp and _a1513.pos and _a1513.zone == _a584.move.curZone() then
_a584.move.glideTo(_a1513.pos)
end
local _a1515, _a1516
pcall(function() _a1515, _a1516 = _a582.R_Upg:InvokeServer(_a1513.id, _a1513.zone) end)
if _a1515 then
_a1511 += 1
_a579.mapupg += 1
_a584.ctl.setAct("맵 업글", _a1513.id .. " T" .. _a1513.tier)
_a571(("  ▲ 맵업글  %s T%d  @%s   (%s 다이아)"):format(
_a1513.id, _a1513.tier, _a1513.zone, _a572(_a1513.cost, 0)))
elseif _a1516 then
_a571(("[맵업글] %s T%d @%s 실패: %s"):format(
_a1513.id, _a1513.tier, _a1513.zone, tostring(_a1516)))
end
task.wait(_a577.ActionGap)
end
end
if _a1511 > 0 then
_a571(("[맵업글] %d개 구매  (다이아 %s 남음)"):format(_a1511, _a572(_a626("Diamonds"), 0)))
end
end
local function _a1517()
local _a1518 = _a611()
if not _a1518 then return nil end
local _a1519 = tonumber(rawget(_a1518, "Rebirths")) or 0
local _a1520 = _a1519 + 1
local _a1521
if _a582.Rebirth and rawget(_a582.Rebirth, "GetNextRebirth") then
local _a1522, _a1523 = pcall(_a582.Rebirth.GetNextRebirth, _a1518)
if _a1522 then _a1521 = _a1523 end
end
return { current = _a1519, nextN = _a1520, def = _a1521 }
end
local function _a1524()
if not _a582.R_Reb then _a571("[리버스] Rebirth_Request 리모트 없음") return end
local _a1525 = _a1517()
if not _a1525 then
_a584.auto.rebNote = "세이브를 못 읽음"
return
end
local _a1526, _a1527
pcall(function() _a1526, _a1527 = _a582.R_Reb:InvokeServer(_a1525.nextN) end)
if _a1526 then
_a579.mreb += 1
_a584.auto.rebNote, _a584.auto.rebSaid = nil, nil
_a571(("  ★ 리버스 %d → %d"):format(_a1525.current, _a1525.nextN))
task.wait(0.5)
_a584.screen.dismissRewardScreens(25)
else
_a584.auto.rebNote = ("%d → %d : %s"):format(_a1525.current, _a1525.nextN,
_a1527 and tostring(_a1527) or "조건 미달 (리버스 킬/존 요구치)")
if _a584.auto.rebSaid ~= _a584.auto.rebNote then
_a584.auto.rebSaid = _a584.auto.rebNote
_a571("[리버스] " .. _a584.auto.rebNote)
end
end
end
_a584.auto.SIDE = {
{ key = "unlock", label = "알 해금",   run = "mhatch", fn = function() _a584.egg.unlockEggs() end },
{ key = "slots",  label = "슬롯 머신", run = "slots",  fn = function() _a584.mach.cycleSlots() end },
{ key = "mapupg", label = "맵 업그레이드", run = "mapupg", fn = function() _a584.mach.cycleUpg() end },
{ key = "items",  label = "버프 유지",     run = "items",  fn = function() _a584.item.cycleItems() end },
}
_a584.auto.STEPS = {
{ key = "mreb",   label = "리버스",  run = "mreb",  fn = function() _a1524() end,
hold = true },
{ key = "zone",   label = "존 해금", run = "zone",  fn = function() _a654() end,
hold = true },
{ key = "quest",  label = "랭크 퀘스트+보상", run = "quest", fn = function()
local _a1528 = _a578.farm
_a578.farm = true
pcall(_a636)
_a578.farm = _a1528
local _a1529 = _a584.quest.cycle()
if not _a1529 then
local _a1530 = _a584.move.bestZone()
if _a1530 then
local _a1531, _a1532 = _a584.move.goToZone(_a1530)
if not _a1531 then
if _a1532 and _a584.auto.idleMoveSaid ~= tostring(_a1532) then
_a584.auto.idleMoveSaid = tostring(_a1532)
_a571("[자동] 최고 존 이동 실패: " .. tostring(_a1532))
end
else
_a584.auto.idleMoveSaid = nil
end
end
if not _a577.IdleHatch then
_a584.ctl.setAct("파밍 중", ("퀘스트 없음 @%s"):format(tostring(_a584.move.curZone())))
return
end
local _a1533 = _a684()
local _a1534 = math.max(1, _a577.HatchMinAfford or 10)
if _a1533 and _a1533.price and _a1533.canBuy < _a1534 then
_a584.ctl.setAct("돈 버는 중", ("%s  %d/%d개분  개당 %s %s"):format(
tostring(_a584.move.curZone()), _a1533.canBuy, _a1534,
_a572(_a1533.price, 0), tostring(_a1533.currency)))
else
_a584.ctl.setAct("대기 중 부화")
local _a1535 = _a578.mhatch
_a578.mhatch = true
pcall(_a695)
_a578.mhatch = _a1535
end
end
end },
}
_a577.StepOn = {}
for _a1536, _a1537 in ipairs(_a584.auto.SIDE) do _a577.StepOn[_a1537.key] = true end
for _a1538, _a1539 in ipairs(_a584.auto.STEPS) do _a577.StepOn[_a1539.key] = true end
local function _a1540(_a1541, _a1542, _a1543, _a1544)
if not _a577.StepOn[_a1541.key] then
_a1544[#_a1544 + 1] = ("%-14s 꺼져있음"):format(_a1541.label)
return
end
if _a1541.hold and _a1542 then
_a1544[#_a1544 + 1] = ("%-14s 보류 (%s)"):format(
_a1541.label, _a1543 and tostring(_a1543.title) or "?")
if _a584.auto.heldMsg ~= _a1541.key then
_a584.auto.heldMsg = _a1541.key
_a571(("[자동] %s 보류 — best 존이 바뀌면 깨지는 퀘스트 진행 중 (%s)"):format(
_a1541.label, _a1543 and tostring(_a1543.title) or "?"))
end
return
end
if _a1541.hold then _a584.auto.heldMsg = nil end
_a584.auto.step = _a1541.label
_a584.ctl.now.step = _a1541.label
_a584.ctl.setAct("시작", _a1541.label)
local _a1545 = os.clock()
local _a1546 = _a578[_a1541.run]
_a578[_a1541.run] = true
local _a1547, _a1548 = pcall(_a1541.fn)
_a578[_a1541.run] = _a1546
local _a1549 = os.clock() - _a1545
if not _a1547 then
_a1544[#_a1544 + 1] = ("%-14s 오류: %s"):format(_a1541.label, tostring(_a1548))
_a571("[자동] " .. _a1541.label .. " 오류: " .. tostring(_a1548))
else
local _a1550 = (_a1541.key == "zone" and _a584.auto.zoneNote)
or (_a1541.key == "mreb" and _a584.auto.rebNote) or nil
_a1544[#_a1544 + 1] = ("%-14s 실행 %.1f초%s"):format(
_a1541.label, _a1549, _a1550 and ("  → " .. _a1550) or "")
end
end
function _a584.auto.master()
local _a1551 = {}
_a584.auto.lastTrace = _a1551
_a584.auto.lastPassAt = os.clock()
if _a584.screen.rewardScreenUp() then
_a1551[#_a1551 + 1] = "보상 화면 넘기는 중"
_a584.screen.dismissRewardScreens(15)
end
for _a1552, _a1553 in ipairs(_a584.auto.SIDE) do
if not _a578.auto or _a584.ctl.stopped() then return end
_a1540(_a1553, false, nil, _a1551)
end
local _a1554, _a1555 = false, nil
if _a577.HoldZoneForQuest then _a1554, _a1555 = _a584.quest.bestDepActive() end
for _a1556, _a1557 in ipairs(_a584.auto.STEPS) do
if not _a578.auto or _a584.ctl.stopped() then break end
_a1540(_a1557, _a1554, _a1555, _a1551)
end
_a584.auto.step = nil
if not _a584.ctl.lockGoal then
_a584.ctl.now.step = "대기"
_a584.ctl.setAct("다음 바퀴 대기", ("%.0f초 주기"):format(_a577.AutoInterval or 5))
end
local _a1558 = {}
for _a1559, _a1560 in ipairs(_a1551) do _a1558[#_a1558 + 1] = (_a1560:gsub("[%d%.]+초", "")) end
_a1558 = table.concat(_a1558, " | ")
if _a1558 ~= _a584.auto.lastSig then
_a584.auto.lastSig = _a1558
_a571("[자동] 바퀴 " .. (_a584.auto.passN or 0))
for _a1561, _a1562 in ipairs(_a1551) do _a571("    " .. _a1562) end
end
_a584.auto.passN = (_a584.auto.passN or 0) + 1
end
local function _a1563()
if not _a576.R_PROMO then _a571("[타워업글] 리모트 없음") return end
local _a1564 = _a580()
if not _a1564 then return end
local _a1565 = _a581(_a1564)
table.sort(_a1565, function(_a1566, _a1567) return (_a1566.dps or 0) > (_a1567.dps or 0) end)
local _a1568, _a1569 = 0, 0
for _a1570, _a1571 in ipairs(_a1565) do
if not _a578.towerup then break end
if _a1571.id then
local _a1572
pcall(function() _a1572 = _a576.R_PROMO:InvokeServer(_a1571.id) end)
if _a1572 ~= nil and _a1572 ~= false then
_a1568 += 1
_a571(("  ▲ 타워업글  %s  Lv%s → Lv%s"):format(tostring(_a1571.kind), tostring(_a1571.up), tostring((_a1571.up or 0) + 1)))
_a1569 = 0
task.wait(_a577.ActionGap)
else
_a1569 += 1
if _a1569 >= 5 then break end
end
end
end
_a571("[타워업글] " .. _a1568 .. "건")
end
local _a1573 = {}
local _a1574 = {}
local function _a1575(_a1576, _a1577)
local _a1578 = tostring(_a1577)
local _a1579 = _a1574[_a1576]
if _a1579 and _a1579.msg == _a1578 then
_a1579.n += 1
if _a1579.n % 20 == 0 then
_a571(("[%s 오류] %s   (%d회 반복)"):format(_a1576, _a1578, _a1579.n))
end
return
end
_a1574[_a1576] = { msg = _a1578, n = 1 }
_a571("[" .. _a1576 .. " 오류] " .. _a1578)
end
local function _a1580(_a1581, _a1582, _a1583, _a1584)
_a1573[_a1581] = (_a1573[_a1581] or 0) + 1
local _a1585 = _a1573[_a1581]
task.spawn(function()
while _a578[_a1581] and _a1573[_a1581] == _a1585 do
local _a1586, _a1587 = pcall(_a1583)
if not _a1586 then _a1575(_a1584, _a1587) else _a1574[_a1584] = nil end
local _a1588, _a1589 = _a1582(), 0
while _a1589 < _a1588 and _a578[_a1581] and _a1573[_a1581] == _a1585 do task.wait(0.1) _a1589 += 0.1 end
end
if _a1573[_a1581] == _a1585 then _a571("[" .. _a1584 .. "] 중지") end
end)
end
do
local _a1590 = {
farm   = { function() return _a577.FarmInterval end,      function() _a636() end,      "파밍" },
zone   = { function() return _a577.ZoneInterval end,      function() _a654() end,      "존" },
mhatch = { function() return _a577.MainHatchInterval end, function() _a695() end, "부화" },
}
function _a584.auto.turnOn(_a1591, _a1592)
if _a578.auto then return end
if _a578[_a1591] then return end
local _a1593 = _a1590[_a1591]
if not _a1593 then return end
_a578[_a1591] = true
_a1580(_a1591, _a1593[1], _a1593[2], _a1593[3])
if _a584.auto.refresh then _a584.auto.refresh() end
_a571("[퀘스트] " .. tostring(_a1592) .. " ON")
end
end
_a567.MG, _a567.QS, _a567.saveGet, _a567.currencyAmount, _a567.cycleFarm, _a567.zoneStatus = _a582, _a584, _a611, _a626, _a636, _a650
_a567.cycleZone, _a567.bestMainEgg, _a567.mainHatchStatus, _a567.cycleMainHatch, _a567.mainRebirthStatus, _a567.cycleMainRebirth = _a654, _a659, _a684, _a695, _a1517, _a1524
_a567.cycleTowerUp, _a567.startLoop = _a1563, _a1580
end)(_a1)
;(function(_a1594)
local _a1595, _a1596, _a1597, _a1598, _a1599, _a1600, _a1601 = _a1594.UIS, _a1594.RunService, _a1594.LP, _a1594.LOG, _a1594.log, _a1594.num, _a1594.LB
local _a1602, _a1603, _a1604, _a1605, _a1606, _a1607 = _a1594.RM, _a1594.CFG, _a1594.EGG_COST_CACHE, _a1594.RUN, _a1594.STAT, _a1594.EVENT_UPGRADES
local _a1608, _a1609, _a1610, _a1611, _a1612, _a1613 = _a1594.ctx, _a1594.collectSlots, _a1594.placedTowers, _a1594.availableItems, _a1594.cyclePlace, _a1594.cycleMerchant
local _a1614, _a1615, _a1616, _a1617, _a1618, _a1619 = _a1594.sunflowers, _a1594.eventTiers, _a1594.nextCost, _a1594.cycleUpgrade, _a1594.seedInv, _a1594.bedsOf
local _a1620, _a1621, _a1622, _a1623, _a1624, _a1625 = _a1594.isUnhatched, _a1594.bedCps, _a1594.cycleCrop, _a1594.laneCosts, _a1594.lockedBeds, _a1594.cycleExpand
local _a1626, _a1627, _a1628, _a1629, _a1630 = _a1594.rebirthStatus, _a1594.cycleRebirth, _a1594.hatchStatus, _a1594.cycleHatch, _a1594.LUCK_ORDER
local _a1631, _a1632, _a1633, _a1634, _a1635, _a1636 = _a1594.luckStatus, _a1594.fmtDur, _a1594.cycleLuck, _a1594.MG, _a1594.QS, _a1594.saveGet
local _a1637, _a1638, _a1639, _a1640, _a1641, _a1642 = _a1594.currencyAmount, _a1594.cycleFarm, _a1594.zoneStatus, _a1594.cycleZone, _a1594.bestMainEgg, _a1594.mainHatchStatus
local _a1643, _a1644, _a1645, _a1646, _a1647 = _a1594.cycleMainHatch, _a1594.mainRebirthStatus, _a1594.cycleMainRebirth, _a1594.cycleTowerUp, _a1594.startLoop
local _a1648 = {
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
local function _a1649(_a1650, _a1651, _a1652)
local _a1653 = Instance.new(_a1650)
for _a1654, _a1655 in pairs(_a1651) do _a1653[_a1654] = _a1655 end
if _a1652 then _a1653.Parent = _a1652 end
return _a1653
end
local function _a1656(_a1657, _a1658) _a1649("UICorner", { CornerRadius = UDim.new(0, _a1658 or 8) }, _a1657) end
local function _a1659(_a1660, _a1661, _a1662)
_a1649("UIStroke", { Color = _a1661 or _a1648.line, Thickness = _a1662 or 1,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, _a1660)
end
local function _a1663(_a1664, _a1665)
_a1649("UIPadding", {
PaddingTop = UDim.new(0, _a1665), PaddingBottom = UDim.new(0, _a1665),
PaddingLeft = UDim.new(0, _a1665), PaddingRight = UDim.new(0, _a1665),
}, _a1664)
end
local _a1666 = _a1649("ScreenGui", {
Name = "PS99GardenAuto", ResetOnSpawn = false,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
IgnoreGuiInset = true, DisplayOrder = 9999,
})
local _a1667 = false
if type(gethui) == "function" then _a1667 = pcall(function() _a1666.Parent = gethui() end) end
if not _a1667 then _a1667 = pcall(function() _a1666.Parent = game:GetService("CoreGui") end) end
if not _a1667 then _a1666.Parent = _a1597:WaitForChild("PlayerGui") end
local _a1668, _a1669 = 780, 520
local _a1670 = _a1649("Frame", {
Size = UDim2.fromOffset(_a1668, _a1669), Position = UDim2.new(0.5, -_a1668 / 2, 0.5, -_a1669 / 2),
BackgroundColor3 = _a1648.bg, BorderSizePixel = 0, Active = true, ClipsDescendants = true,
}, _a1666)
_a1656(_a1670, 12)
_a1659(_a1670, Color3.fromRGB(60, 66, 82), 1)
local _a1671 = _a1649("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = _a1648.panel, BorderSizePixel = 0,
}, _a1670)
_a1656(_a1671, 12)
_a1649("Frame", {
Size = UDim2.new(1, 0, 0, 12), Position = UDim2.new(0, 0, 1, -12),
BackgroundColor3 = _a1648.panel, BorderSizePixel = 0,
}, _a1671)
_a1649("Frame", {
Size = UDim2.fromOffset(10, 10), Position = UDim2.fromOffset(14, 15),
BackgroundColor3 = _a1648.good, BorderSizePixel = 0,
}, _a1671).Name = "Dot"
_a1656(_a1671:FindFirstChild("Dot"), 5)
_a1649("TextLabel", {
Size = UDim2.new(0, 320, 1, 0), Position = UDim2.fromOffset(32, 0),
BackgroundTransparency = 1, Text = "Garden Defenders  AutoPlay",
TextColor3 = _a1648.text, TextSize = 14, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1671)
local function _a1672(_a1673, _a1674, _a1675, _a1676)
local _a1677 = _a1649("TextButton", {
Size = UDim2.new(0, _a1676, 0, 24), Position = UDim2.new(1, _a1675, 0, 8),
BackgroundColor3 = _a1674, BorderSizePixel = 0, Text = _a1673,
TextColor3 = _a1648.text, TextSize = 12, Font = Enum.Font.GothamMedium,
AutoButtonColor = true,
}, _a1671)
_a1656(_a1677, 6)
return _a1677
end
local _a1678 = _a1672("✕", _a1648.bad, -38, 28)
local _a1679   = _a1672("—", _a1648.card, -70, 28)
local _a1680 = _a1672("지우기", _a1648.card, -132, 58)
local _a1681  = _a1672("복사", _a1648.accent, -190, 54)
local _a1682  = _a1672("정지", _a1648.bad, -252, 58)
_a1682.MouseButton1Click:Connect(function()
task.spawn(function()
_a1635.ctl.stopAll()
if _a1635.auto.refresh then pcall(_a1635.auto.refresh) end
_a1599("[정지] 모든 동작을 멈췄습니다")
end)
end)
local _a1683 = _a1649("ScrollingFrame", {
Size = UDim2.new(0, 152, 1, -92), Position = UDim2.fromOffset(10, 48),
BackgroundColor3 = _a1648.panel, BorderSizePixel = 0,
ScrollBarThickness = 3, ScrollBarImageColor3 = _a1648.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1670)
_a1656(_a1683, 8)
_a1649("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, _a1683)
_a1649("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }, _a1683)
local _a1684 = _a1649("Frame", {
Size = UDim2.new(1, -182, 1, -92), Position = UDim2.fromOffset(172, 48),
BackgroundTransparency = 1,
}, _a1670)
local _a1685, _a1686 = {}, nil
local _a1687, _a1688 = {}, {}
local _a1689 = {}
local function _a1690(_a1691)
_a1686 = _a1691
for _a1692, _a1693 in pairs(_a1685) do _a1693.Visible = (_a1692 == _a1691) end
for _a1694, _a1695 in pairs(_a1687) do
local _a1696 = (_a1694 == _a1691)
_a1695.BackgroundColor3 = _a1696 and _a1648.accent or _a1648.panel
_a1695.TextColor3 = _a1696 and Color3.fromRGB(255, 255, 255) or _a1648.dim
end
local _a1697 = _a1688[_a1691]
if _a1697 and _a1689[_a1697] and not _a1689[_a1697].open then _a1689[_a1697].toggle() end
end
local function _a1698(_a1699, _a1700, _a1701)
local _a1702 = { open = true, kids = {} }
local _a1703 = _a1649("TextButton", {
Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = _a1648.bg, BorderSizePixel = 0,
Text = "", TextColor3 = _a1648.dim, TextSize = 11,
Font = Enum.Font.GothamBold, LayoutOrder = _a1701, AutoButtonColor = false,
}, _a1683)
_a1656(_a1703, 5)
local _a1704 = _a1649("TextLabel", {
Size = UDim2.fromOffset(14, 26), Position = UDim2.fromOffset(6, 0),
BackgroundTransparency = 1, Text = "▾", TextColor3 = _a1648.dim,
TextSize = 10, Font = Enum.Font.GothamBold,
}, _a1703)
_a1649("TextLabel", {
Size = UDim2.new(1, -22, 1, 0), Position = UDim2.fromOffset(20, 0),
BackgroundTransparency = 1, Text = _a1700, TextColor3 = _a1648.dim,
TextSize = 11, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1703)
function _a1702.toggle()
_a1702.open = not _a1702.open
_a1704.Text = _a1702.open and "▾" or "▸"
for _a1705, _a1706 in ipairs(_a1702.kids) do _a1706.Visible = _a1702.open end
end
_a1703.MouseButton1Click:Connect(_a1702.toggle)
_a1689[_a1699] = _a1702
return _a1702
end
local function _a1707(_a1708, _a1709, _a1710, _a1711)
local _a1712 = _a1711 and 14 or 6
local _a1713 = _a1649("TextButton", {
Size = UDim2.new(1, 0, 0, 27), BackgroundColor3 = _a1648.panel, BorderSizePixel = 0,
Text = "", TextColor3 = _a1648.dim, TextSize = 12,
Font = Enum.Font.GothamMedium, LayoutOrder = _a1710, AutoButtonColor = false,
}, _a1683)
_a1656(_a1713, 5)
local _a1714 = _a1649("TextLabel", {
Size = UDim2.new(1, -_a1712 - 4, 1, 0), Position = UDim2.fromOffset(_a1712, 0),
BackgroundTransparency = 1, Text = _a1709, TextColor3 = _a1648.dim,
TextSize = 12, Font = Enum.Font.GothamMedium,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1713)
_a1687[_a1708] = _a1713
if _a1711 then
_a1688[_a1708] = _a1711
local _a1715 = _a1689[_a1711]
if _a1715 then
table.insert(_a1715.kids, _a1713)
_a1713.Visible = _a1715.open
end
end
local _a1716 = _a1649("ScrollingFrame", {
Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false,
BorderSizePixel = 0, ScrollBarThickness = 4,
ScrollBarImageColor3 = _a1648.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1684)
_a1649("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, _a1716)
_a1649("UIPadding", { PaddingRight = UDim.new(0, 8) }, _a1716)
_a1685[_a1708] = _a1716
_a1713.MouseButton1Click:Connect(function() _a1690(_a1708) end)
_a1713.MouseEnter:Connect(function()
if _a1686 ~= _a1708 then _a1713.BackgroundColor3 = _a1648.card end
end)
_a1713.MouseLeave:Connect(function()
if _a1686 ~= _a1708 then _a1713.BackgroundColor3 = _a1648.panel end
end)
_a1713:GetPropertyChangedSignal("TextColor3"):Connect(function()
_a1714.TextColor3 = _a1713.TextColor3
end)
return _a1716
end
local _a1717 = 0
local function _a1718()
_a1717 += 1
return _a1717
end
local function _a1719(_a1720, _a1721)
local _a1722 = _a1649("Frame", {
Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, LayoutOrder = _a1718(),
}, _a1720)
_a1649("Frame", {
Size = UDim2.fromOffset(3, 14), Position = UDim2.fromOffset(0, 7),
BackgroundColor3 = _a1648.accent, BorderSizePixel = 0,
}, _a1722)
_a1649("TextLabel", {
Size = UDim2.new(1, -12, 1, 0), Position = UDim2.fromOffset(10, 0),
BackgroundTransparency = 1, Text = _a1721, TextColor3 = _a1648.text,
TextSize = 13, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1722)
return _a1722
end
local function _a1723(_a1724, _a1725, _a1726)
local _a1727 = _a1649("Frame", {
Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundColor3 = _a1648.card, BorderSizePixel = 0, LayoutOrder = _a1718(),
}, _a1724)
_a1656(_a1727, 8)
_a1659(_a1727, _a1648.line, 1)
_a1663(_a1727, 12)
_a1649("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, _a1727)
if _a1725 then
local _a1728 = _a1649("Frame", {
Size = UDim2.new(1, 0, 0, _a1726 and 32 or 22), BackgroundTransparency = 1,
LayoutOrder = 0,
}, _a1727)
_a1649("TextLabel", {
Size = UDim2.new(1, -70, 0, 16), BackgroundTransparency = 1, Text = _a1725,
TextColor3 = _a1648.text, TextSize = 13, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1728)
if _a1726 then
_a1649("TextLabel", {
Size = UDim2.new(1, -70, 0, 13), Position = UDim2.fromOffset(0, 17),
BackgroundTransparency = 1, Text = _a1726, TextColor3 = _a1648.dim,
TextSize = 11, Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
}, _a1728)
end
_a1727:SetAttribute("HeadHeight", _a1726 and 32 or 18)
return _a1727, _a1728
end
return _a1727
end
local _a1729 = {}
local function _a1730()
for _a1731, _a1732 in pairs(_a1729) do pcall(_a1732) end
end
_a1635.auto.refresh = _a1730
local function _a1733(_a1734, _a1735, _a1736)
local _a1737 = _a1649("TextButton", {
Size = UDim2.fromOffset(46, 24), Position = UDim2.new(1, -46, 0, 0),
BackgroundColor3 = _a1648.cardHi, BorderSizePixel = 0, Text = "",
AutoButtonColor = false,
}, _a1734)
_a1656(_a1737, 12)
local _a1738 = _a1649("Frame", {
Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(3, 3),
BackgroundColor3 = _a1648.dim, BorderSizePixel = 0,
}, _a1737)
_a1656(_a1738, 9)
local _a1739 = _a1649("TextLabel", {
Size = UDim2.fromOffset(46, 12), Position = UDim2.fromOffset(0, 26),
BackgroundTransparency = 1, Text = "OFF", TextColor3 = _a1648.dim,
TextSize = 10, Font = Enum.Font.GothamBold,
}, _a1737)
local function _a1740()
local _a1741 = _a1605[_a1735]
_a1737.BackgroundColor3 = _a1741 and _a1648.good or _a1648.cardHi
_a1738:TweenPosition(UDim2.fromOffset(_a1741 and 25 or 3, 3),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
_a1738.BackgroundColor3 = _a1741 and Color3.fromRGB(255, 255, 255) or _a1648.dim
_a1739.Text = _a1741 and "ON" or "OFF"
_a1739.TextColor3 = _a1741 and _a1648.good or _a1648.dim
end
_a1737.MouseButton1Click:Connect(function()
_a1605[_a1735] = not _a1605[_a1735]
if _a1605[_a1735] then
if _a1735 == "auto" then _a1635.ctl.abort = false end
_a1740()
_a1599("[" .. _a1735 .. "] 시작")
task.spawn(function()
local _a1742, _a1743 = pcall(_a1736)
if not _a1742 then _a1599("[에러] " .. tostring(_a1743)) end
end)
else
if _a1735 == "auto" then
_a1635.ctl.stopAll()
_a1599("[정지] 모든 동작을 멈췄습니다")
end
_a1740()
end
end)
_a1740()
_a1729[_a1735] = _a1740
return _a1737, _a1740
end
local function _a1744(_a1745, _a1746)
local _a1747 = _a1649("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, LayoutOrder = _a1718(),
}, _a1745)
local _a1748 = #_a1746
for _a1749, _a1750 in ipairs(_a1746) do
local _a1751 = _a1649("Frame", {
Size = UDim2.new(1 / _a1748, -6, 1, 0), Position = UDim2.new((_a1749 - 1) / _a1748, 3, 0, 0),
BackgroundTransparency = 1,
}, _a1747)
_a1649("TextLabel", {
Size = UDim2.new(1, 0, 0, 13), BackgroundTransparency = 1, Text = _a1750.label,
TextColor3 = _a1648.dim, TextSize = 10, Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1751)
local _a1752 = _a1649("TextBox", {
Size = UDim2.new(1, 0, 0, 24), Position = UDim2.fromOffset(0, 15),
BackgroundColor3 = _a1648.bg, BorderSizePixel = 0, Text = tostring(_a1750.value),
TextColor3 = _a1648.text, TextSize = 12, Font = Enum.Font.Code,
ClearTextOnFocus = false,
}, _a1751)
_a1656(_a1752, 5)
_a1659(_a1752, _a1648.line, 1)
_a1752.FocusLost:Connect(function() _a1750.onChange(_a1752.Text, _a1752) end)
end
return _a1747
end
local function _a1753(_a1754, _a1755)
local _a1756 = _a1649("Frame", {
Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = _a1718(),
}, _a1754)
local _a1757 = #_a1755
for _a1758, _a1759 in ipairs(_a1755) do
local _a1760 = _a1649("TextButton", {
Size = UDim2.new(1 / _a1757, -5, 1, 0), Position = UDim2.new((_a1758 - 1) / _a1757, 2.5, 0, 0),
BackgroundColor3 = _a1759.col or _a1648.cardHi, BorderSizePixel = 0, Text = _a1759.label,
TextColor3 = _a1648.text, TextSize = 12, Font = Enum.Font.GothamMedium,
}, _a1756)
_a1656(_a1760, 6)
_a1760.MouseButton1Click:Connect(function()
task.spawn(function()
local _a1761, _a1762 = pcall(_a1759.fn, _a1760)
if not _a1761 then _a1599("[에러] " .. tostring(_a1759.label) .. " → " .. tostring(_a1762)) end
end)
end)
end
return _a1756
end
local function _a1763(_a1764, _a1765, _a1766, _a1767)
local _a1768 = _a1649("TextButton", {
Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = _a1648.cardHi, BorderSizePixel = 0,
Text = "", TextColor3 = _a1648.text, TextSize = 12, Font = Enum.Font.GothamMedium,
LayoutOrder = _a1718(),
}, _a1764)
_a1656(_a1768, 6)
local function _a1769()
local _a1770 = _a1766()
_a1768.Text = _a1765 .. "   " .. (_a1770 and "ON" or "OFF")
_a1768.BackgroundColor3 = _a1770 and Color3.fromRGB(40, 78, 58) or _a1648.cardHi
_a1768.TextColor3 = _a1770 and _a1648.good or _a1648.dim
end
_a1768.MouseButton1Click:Connect(function()
_a1767(not _a1766())
_a1769()
end)
_a1769()
return _a1768
end
local _a1771 = _a1707("log", "로그", 90)
local _a1772
do
local _a1773 = _a1649("Frame", {
Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(13, 14, 18),
BorderSizePixel = 0, LayoutOrder = _a1718(),
}, _a1771)
_a1656(_a1773, 8)
_a1659(_a1773, _a1648.line, 1)
local _a1774 = _a1649("ScrollingFrame", {
Size = UDim2.new(1, -10, 1, -10), Position = UDim2.fromOffset(5, 5),
BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4,
ScrollBarImageColor3 = _a1648.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1773)
_a1772 = _a1649("TextLabel", {
Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1, Text = "", TextColor3 = Color3.fromRGB(196, 208, 196),
TextSize = 11, Font = Enum.Font.Code,
TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
TextWrapped = true,
}, _a1774)
_a1771.AutomaticCanvasSize = Enum.AutomaticSize.None
_a1771.CanvasSize = UDim2.new()
end
do
local _a1775, _a1776, _a1777, _a1778
_a1671.InputBegan:Connect(function(_a1779)
if _a1779.UserInputType == Enum.UserInputType.MouseButton1
or _a1779.UserInputType == Enum.UserInputType.Touch then
_a1775, _a1776, _a1777 = true, _a1779.Position, _a1670.Position
_a1779.Changed:Connect(function()
if _a1779.UserInputState == Enum.UserInputState.End then _a1775 = false end
end)
end
end)
_a1671.InputChanged:Connect(function(_a1780)
if _a1780.UserInputType == Enum.UserInputType.MouseMovement
or _a1780.UserInputType == Enum.UserInputType.Touch then _a1778 = _a1780 end
end)
_a1595.InputChanged:Connect(function(_a1781)
if _a1775 and _a1781 == _a1778 then
local _a1782 = _a1781.Position - _a1776
_a1670.Position = UDim2.new(_a1777.X.Scale, _a1777.X.Offset + _a1782.X,
_a1777.Y.Scale, _a1777.Y.Offset + _a1782.Y)
end
end)
local _a1783 = false
_a1679.MouseButton1Click:Connect(function()
_a1783 = not _a1783
_a1670:TweenSize(_a1783 and UDim2.fromOffset(_a1668, 40) or UDim2.fromOffset(_a1668, _a1669),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
_a1679.Text = _a1783 and "▢" or "—"
end)
end
local _a1784 = _a1596.Heartbeat:Connect(function()
if not _a1594.dirty then return end
_a1594.dirty = false
local _a1785 = #_a1598
_a1772.Text = table.concat(table.move(_a1598, math.max(1, _a1785 - 300), _a1785, 1, {}), "\n")
end)
local _a1786 = _a1707("dash", "대시보드", 10)
local _a1787 = _a1707("event", "이벤트", 20)
do
local _a1788 = _a1723(_a1786, "전체 제어", nil)
_a1753(_a1788, {
{ label = "권장 전부 ON", col = _a1648.good, fn = function()
for _a1789, _a1790 in ipairs({ "place", "merchant", "crop", "expand", "hatch" }) do
if not _a1605[_a1790] then
_a1605[_a1790] = true
if _a1790 == "place"    then _a1647(_a1790, function() return _a1603.PlaceInterval end, _a1612, "배치") end
if _a1790 == "merchant" then _a1647(_a1790, function() return _a1603.MerchantInterval end, _a1613, "구매") end
if _a1790 == "crop"     then _a1647(_a1790, function() return _a1603.CropInterval end, _a1622, "씨앗") end
if _a1790 == "expand"   then _a1647(_a1790, function() return _a1603.ExpandInterval end, _a1625, "확장") end
if _a1790 == "hatch"    then _a1647(_a1790, function() return _a1603.HatchInterval end, _a1629, "뽑기") end
end
end
_a1730()
_a1599("[전체] 배치/구매/씨앗/확장/뽑기 ON  (업글·리버스는 따로 켜세요)")
end },
{ label = "전부 정지", col = _a1648.bad, fn = function()
_a1605.place, _a1605.merchant, _a1605.upgrade = false, false, false
_a1605.towerup, _a1605.crop, _a1605.expand, _a1605.rebirth, _a1605.hatch, _a1605.luck = false, false, false, false, false, false
_a1605.farm, _a1605.zone, _a1605.mhatch, _a1605.rank, _a1605.mreb = false, false, false, false, false
_a1730()
_a1599("[전체] 정지")
end },
})
local _a1791 = _a1723(_a1786, "현황", nil)
_a1753(_a1791, {
{ label = "밭 / 타워", col = _a1648.accent, fn = function()
local _a1792, _a1793, _a1794, _a1795 = _a1608()
_a1599("")
_a1599("──── 현재 상태 ────")
_a1599("레인 " .. tostring(_a1795) .. " / plot " .. (_a1794 and "O" or "X")
.. " / world " .. (_a1792 and "O" or "X"))
local _a1796 = _a1609(_a1794, _a1795)
local _a1797 = _a1610(_a1792)
_a1599("슬롯 " .. #_a1796 .. " / 배치 " .. #_a1797)
local _a1798, _a1799 = 0, {}
for _a1800, _a1801 in ipairs(_a1797) do
_a1798 += (_a1801.dps or 0)
_a1799[tostring(_a1801.kind)] = (_a1799[tostring(_a1801.kind)] or 0) + 1
end
_a1599("총 DPS " .. _a1600(_a1798))
for _a1802, _a1803 in pairs(_a1799) do _a1599("  " .. _a1802 .. " × " .. _a1803) end
local _a1804 = _a1611()
_a1599("")
_a1599("배치 가능 " .. #_a1804 .. "종")
for _a1805 = 1, math.min(10, #_a1804) do
local _a1806 = _a1804[_a1805]
_a1599(("  %-22s %-7s 남은 %-3s DPS %s"):format(
tostring(_a1806.id), tostring(_a1806.vr or "-"), tostring(_a1806.copies), _a1600(_a1806.dps)))
end
_a1690("log")
end },
{ label = "로그 보기", col = _a1648.cardHi, fn = function() _a1690("log") end },
})
end
do
local _a1807, _a1808 = _a1723(_a1787, "자동 배치 / 교체", nil)
_a1733(_a1808, "place", function()
_a1647("place", function() return _a1603.PlaceInterval end, _a1612, "배치")
end)
_a1744(_a1807, {
{ label = "주기", value = _a1603.PlaceInterval, onChange = function(_a1809)
local _a1810 = tonumber(_a1809) if _a1810 and _a1810 >= 3 then _a1603.PlaceInterval = _a1810 end
end },
{ label = "교체 배수", value = _a1603.SwapMargin, onChange = function(_a1811)
local _a1812 = tonumber(_a1811) if _a1812 and _a1812 >= 1 then _a1603.SwapMargin = _a1812 _a1599("[설정] 교체 배수 " .. _a1812) end
end },
{ label = "DoT 반영", value = _a1603.DotFactor, onChange = function(_a1813)
local _a1814 = tonumber(_a1813) if _a1814 and _a1814 >= 0 and _a1814 <= 1 then _a1603.DotFactor = _a1814 end
end },
})
_a1763(_a1807, "업글 타워 보호",
function() return _a1603.ProtectUpgraded end,
function(_a1815) _a1603.ProtectUpgraded = _a1815
_a1599("[설정] 업글 보호 " .. (_a1815 and "ON — 업글된 건 안 건드림" or "OFF — 약하면 교체")) end)
_a1753(_a1807, {
{ label = "지금 1회 실행", col = _a1648.accent, fn = function()
task.spawn(function() _a1605.place = true _a1612() _a1605.place = false _a1690("log") end)
end },
})
end
do
local _a1816, _a1817 = _a1723(_a1787, "머천트 자동 구매", nil)
_a1733(_a1817, "merchant", function()
_a1647("merchant", function() return _a1603.MerchantInterval end, _a1613, "구매")
end)
_a1744(_a1816, {
{ label = "머천트 ID", value = _a1603.MerchantId, onChange = function(_a1818)
if _a1818 ~= "" then _a1603.MerchantId = _a1818 _a1599("[설정] 머천트 " .. _a1818) end
end },
{ label = "주기", value = _a1603.MerchantInterval, onChange = function(_a1819)
local _a1820 = tonumber(_a1819) if _a1820 and _a1820 >= 5 then _a1603.MerchantInterval = _a1820 end
end },
})
_a1753(_a1816, {
{ label = "지금 1회 구매", col = _a1648.accent, fn = function()
task.spawn(function() _a1605.merchant = true _a1613() _a1605.merchant = false _a1690("log") end)
end },
})
end
do
local _a1821, _a1822 = _a1723(_a1787, "업그레이드 머신", nil)
_a1733(_a1822, "upgrade", function()
_a1647("upgrade", function() return _a1603.UpgradeInterval end, _a1617, "머신업글")
end)
_a1744(_a1821, {
{ label = "주기", value = _a1603.UpgradeInterval, onChange = function(_a1823)
local _a1824 = tonumber(_a1823) if _a1824 and _a1824 >= 5 then _a1603.UpgradeInterval = _a1824 end
end },
{ label = "최소 잔액", value = _a1603.MinSunflowers, onChange = function(_a1825)
local _a1826 = tonumber(_a1825) if _a1826 and _a1826 >= 0 then _a1603.MinSunflowers = _a1826
_a1599("[설정] 최소 잔액 " .. _a1600(_a1826, 0)) end
end },
})
_a1763(_a1821, "가격 미상 구매",
function() return _a1603.BuyUnknownCost end,
function(_a1827) _a1603.BuyUnknownCost = _a1827 end)
_a1753(_a1821, {
{ label = "업글 현황 보기", col = _a1648.accent, fn = function()
local _a1828 = _a1614()
local _a1829 = _a1615()
_a1606.sun = _a1828
_a1599("")
_a1599("──── 업그레이드 머신 ────")
_a1599("Sunflowers = " .. _a1600(_a1828, 0))
local _a1830 = {}
for _a1831, _a1832 in ipairs(_a1607) do
local _a1833 = _a1829[_a1832] or 0
_a1830[#_a1830 + 1] = { id = _a1832, tier = _a1833, cost = _a1616(_a1832, _a1833) }
end
table.sort(_a1830, function(_a1834, _a1835)
return (_a1834.cost or math.huge) < (_a1835.cost or math.huge)
end)
for _a1836, _a1837 in ipairs(_a1830) do
_a1599(("  %-22s Lv%-3s 다음 %-14s %s"):format(
_a1837.id, tostring(_a1837.tier), _a1837.cost and _a1600(_a1837.cost, 0) or "?",
(_a1837.cost and _a1837.cost <= _a1828) and "← 구매가능" or ""))
end
_a1690("log")
end },
{ label = "지금 1회 업글", col = _a1648.cardHi, fn = function()
task.spawn(function() _a1605.upgrade = true _a1617() _a1605.upgrade = false _a1690("log") end)
end },
})
local _a1838, _a1839 = _a1723(_a1787, "타워 개별 업글", nil)
_a1733(_a1839, "towerup", function()
_a1647("towerup", function() return _a1603.UpgradeInterval end, _a1646, "타워업글")
end)
end
do
local _a1840, _a1841 = _a1723(_a1787, "자동 뽑기", nil)
_a1733(_a1841, "hatch", function()
_a1647("hatch", function() return _a1603.HatchInterval end, _a1629, "뽑기")
end)
_a1744(_a1840, {
{ label = "주기", value = _a1603.HatchInterval, onChange = function(_a1842)
local _a1843 = tonumber(_a1842) if _a1843 and _a1843 >= 1 then _a1603.HatchInterval = _a1843 end
end },
{ label = "한 번에 최대", value = _a1603.HatchMax, onChange = function(_a1844)
local _a1845 = tonumber(_a1844) if _a1845 and _a1845 >= 1 then _a1603.HatchMax = math.floor(_a1845) end
end },
})
_a1744(_a1840, {
{ label = "예비금", value = _a1603.HatchReserve, onChange = function(_a1846)
local _a1847 = tonumber(_a1846) if _a1847 and _a1847 >= 0 then _a1603.HatchReserve = _a1847
_a1599("[설정] 뽑기 예비금 " .. _a1600(_a1847, 0)) end
end },
{ label = "알 번호 (0=자동)", value = _a1603.HatchEggNum, onChange = function(_a1848)
local _a1849 = tonumber(_a1848) if _a1849 and _a1849 >= 0 and _a1849 <= 12 then
_a1603.HatchEggNum = math.floor(_a1849)
table.clear(_a1604)
_a1599("[설정] 알 번호 " .. (_a1849 == 0 and "자동" or _a1849)) end
end },
})
_a1753(_a1840, {
{ label = "뽑기 현황 보기", col = _a1648.accent, fn = function()
local _a1850 = _a1628()
_a1606.sun = _a1850.sun
_a1599("")
_a1599("──── 뽑기 현황 ────")
_a1599("  알 등급     " .. _a1850.id)
_a1599("  알 uid      " .. tostring(_a1850.uid))
_a1599("  개당 비용   " .. (_a1850.cost and _a1600(_a1850.cost, 0) or "?"))
_a1599("  Sunflowers  " .. _a1600(_a1850.sun, 0))
_a1599("  예비금      " .. _a1600(_a1603.HatchReserve, 0))
_a1599("  지금 가능   " .. _a1850.canBuy .. "회")
_a1599("")
_a1599("  월드의 알 " .. _a1850.eggCount .. "개")
for _a1851, _a1852 in ipairs(_a1850.eggs) do
if _a1851 > 5 then break end
_a1599(("    %s  거리 %s"):format(_a1852.uid, _a1600(_a1852.dist)))
end
_a1599("")
_a1599("  누적 뽑기   " .. _a1606.hatched .. "회")
_a1690("log")
end },
{ label = "지금 1회 실행", col = _a1648.cardHi, fn = function()
task.spawn(function() _a1605.hatch = true _a1629() _a1605.hatch = false _a1690("log") end)
end },
})
end
do
local _a1853, _a1854 = _a1723(_a1787, "럭 상시 최대 유지", nil)
_a1733(_a1854, "luck", function()
_a1647("luck", function() return _a1603.LuckInterval end, _a1633, "럭")
end)
_a1744(_a1853, {
{ label = "주기", value = _a1603.LuckInterval, onChange = function(_a1855)
local _a1856 = tonumber(_a1855) if _a1856 and _a1856 >= 60 then _a1603.LuckInterval = _a1856 end
end },
{ label = "예비금", value = _a1603.LuckReserve, onChange = function(_a1857)
local _a1858 = tonumber(_a1857) if _a1858 and _a1858 >= 0 then _a1603.LuckReserve = _a1858 end
end },
})
_a1744(_a1853, {
{ label = "최소 부족분", value = _a1603.LuckMinTopUp, onChange = function(_a1859)
local _a1860 = tonumber(_a1859) if _a1860 and _a1860 >= 0 then _a1603.LuckMinTopUp = _a1860 end
end },
})
for _a1861, _a1862 in ipairs(_a1630) do
_a1763(_a1853, _a1862,
function() return _a1603.LuckBoosts[_a1862] end,
function(_a1863) _a1603.LuckBoosts[_a1862] = _a1863 end)
end
_a1753(_a1853, {
{ label = "럭 현황 보기", col = _a1648.accent, fn = function()
local _a1864 = _a1631()
_a1606.sun = _a1864.sun
_a1599("")
_a1599("──── 이벤트 럭 ────")
_a1599("  머신 활성   " .. (_a1864.enabled and "O" or "X"))
_a1599("  최대 시간   " .. _a1632(_a1864.maxSec))
_a1599("  Sunflowers  " .. _a1600(_a1864.sun, 0))
_a1599("")
for _a1865, _a1866 in ipairs(_a1864.rows) do
_a1599(("  %-12s %-14s 부족 %-14s 필요 %s개%s"):format(
_a1866.rarity, _a1632(_a1866.left), _a1632(_a1866.deficit), _a1600(_a1866.need, 0),
_a1866.on and "" or "   (꺼짐)"))
end
_a1599("")
_a1599("  효과 : 비활성 0.5배 → 활성 1.0배 (2배)")
_a1690("log")
end },
{ label = "지금 1회 충전", col = _a1648.cardHi, fn = function()
task.spawn(function() _a1605.luck = true _a1633() _a1605.luck = false _a1690("log") end)
end },
})
end
do
local _a1867, _a1868 = _a1723(_a1787, "자동 씨앗 교체", nil)
_a1733(_a1868, "crop", function()
_a1647("crop", function() return _a1603.CropInterval end, _a1622, "씨앗")
end)
_a1744(_a1867, {
{ label = "주기", value = _a1603.CropInterval, onChange = function(_a1869)
local _a1870 = tonumber(_a1869) if _a1870 and _a1870 >= 5 then _a1603.CropInterval = _a1870 end
end },
{ label = "갈아엎기 배수", value = _a1603.CropMargin, onChange = function(_a1871)
local _a1872 = tonumber(_a1871) if _a1872 and _a1872 >= 1 then _a1603.CropMargin = _a1872 _a1599("[설정] 작물 배수 " .. _a1872) end
end },
})
_a1763(_a1867, "성장중 건너뛰기",
function() return _a1603.SkipUnhatched end,
function(_a1873) _a1603.SkipUnhatched = _a1873 end)
_a1753(_a1867, {
{ label = "밭 현황 보기", col = _a1648.accent, fn = function()
local _a1874, _a1875 = _a1608()
if not _a1875 then _a1599("[씨앗] 밭 없음") _a1690("log") return end
local _a1876, _a1877 = _a1619(_a1875), _a1618()
_a1599("")
_a1599("──── 밭 현황 ────")
_a1599("보유 씨앗 (기대 초당수익 순)")
for _a1878, _a1879 in ipairs(_a1877) do
_a1599(("  %-10s %-8s ×%-6s  기대 %s/s"):format(
tostring(_a1879.id), tostring(_a1879.vr or "-"), tostring(_a1879.am), _a1600(_a1879.exp)))
end
local _a1880, _a1881, _a1882, _a1883, _a1884 = 0, 0, 0, 0, 0
local _a1885 = _a1877[1]
local _a1886 = _a1885 and _a1885.exp or 0
_a1599("")
_a1599("심어진 작물")
local _a1887 = 0
for _a1888, _a1889 in pairs(_a1876) do
_a1880 += 1
local _a1890 = _a1621(_a1889) or 0
_a1881 += _a1890
if _a1620(_a1889) then _a1883 += 1
elseif _a1886 > _a1890 * _a1603.CropMargin then _a1882 += 1
else _a1884 += 1 end
_a1887 += 1
if _a1887 <= 20 then
_a1599(("  칸%-4s %-20s %s/s%s"):format(tostring(_a1888),
tostring(rawget(_a1889, "sp") or "?"), _a1600(_a1890),
_a1620(_a1889) and "  (자라는 중)" or ""))
end
end
if _a1880 > 20 then _a1599("  ... (" .. (_a1880 - 20) .. "칸 더)") end
_a1599("")
_a1599(("총 %d칸 / 합계 %s per sec"):format(_a1880, _a1600(_a1881)))
_a1599(("갈아엎기 대상 %d / 유지 %d / 자라는 중 %d"):format(_a1882, _a1884, _a1883))
_a1690("log")
end },
{ label = "지금 1회 실행", col = _a1648.cardHi, fn = function()
task.spawn(function() _a1605.crop = true _a1622() _a1605.crop = false _a1690("log") end)
end },
})
end
do
local _a1891, _a1892 = _a1723(_a1787, "자동 확장", nil)
_a1733(_a1892, "expand", function()
_a1647("expand", function() return _a1603.ExpandInterval end, _a1625, "확장")
end)
_a1744(_a1891, {
{ label = "주기", value = _a1603.ExpandInterval, onChange = function(_a1893)
local _a1894 = tonumber(_a1893) if _a1894 and _a1894 >= 5 then _a1603.ExpandInterval = _a1894 end
end },
{ label = "밭칸 스캔", value = _a1603.MaxBedScan, onChange = function(_a1895)
local _a1896 = tonumber(_a1895) if _a1896 and _a1896 >= 1 then _a1603.MaxBedScan = math.floor(_a1896) end
end },
})
_a1753(_a1891, {
{ label = "확장 현황 보기", col = _a1648.accent, fn = function()
local _a1897, _a1898, _a1899, _a1900 = _a1608()
if not _a1898 then _a1599("[확장] 밭 없음") _a1690("log") return end
local _a1901 = _a1614()
_a1606.sun = _a1901
local _a1902 = _a1623(true)
_a1599("")
_a1599("──── 확장 현황 ────")
_a1599("Sunflowers = " .. _a1600(_a1901, 0))
_a1599("")
_a1599("레인 " .. tostring(_a1900) .. "개 열림")
local _a1903 = {}
for _a1904 in pairs(_a1902) do _a1903[#_a1903 + 1] = tonumber(_a1904) or _a1904 end
table.sort(_a1903, function(_a1905, _a1906) return tostring(_a1905) < tostring(_a1906) end)
for _a1907, _a1908 in ipairs(_a1903) do
local _a1909 = _a1902[_a1908] or _a1902[tostring(_a1908)]
local _a1910 = tonumber(_a1908) or 0
local _a1911 = (_a1910 == (tonumber(_a1900) or 0) + 1)
and ((tonumber(_a1909) or math.huge) <= _a1901 and "  ← 지금 오픈 가능" or "  ← 다음 (돈 부족)")
or (_a1910 <= (tonumber(_a1900) or 0) and "  (열림)" or "")
_a1599(("  레인 %-3s %s%s"):format(tostring(_a1908), _a1600(tonumber(_a1909) or 0, 0), _a1911))
end
local _a1912 = _a1624(_a1898)
_a1599("")
_a1599("잠긴 밭칸 " .. #_a1912 .. "개 (싼 순 8개)")
for _a1913 = 1, math.min(8, #_a1912) do
local _a1914 = _a1912[_a1913]
_a1599(("  칸 %-4s %s%s"):format(_a1914.id, _a1914.cost and _a1600(_a1914.cost, 0) or "?",
(_a1914.cost and _a1914.cost <= _a1901) and "  ← 오픈 가능" or ""))
end
if #_a1912 == 0 then _a1599("  (전부 열려 있음)") end
_a1690("log")
end },
{ label = "지금 1회 실행", col = _a1648.cardHi, fn = function()
task.spawn(function() _a1605.expand = true _a1625() _a1605.expand = false _a1690("log") end)
end },
})
end
do
local _a1915, _a1916 = _a1723(_a1787, "자동 리버스", nil)
_a1733(_a1916, "rebirth", function()
_a1647("rebirth", function() return _a1603.RebirthInterval end, _a1627, "리버스")
end)
_a1744(_a1915, {
{ label = "주기", value = _a1603.RebirthInterval, onChange = function(_a1917)
local _a1918 = tonumber(_a1917) if _a1918 and _a1918 >= 10 then _a1603.RebirthInterval = _a1918 end
end },
})
_a1753(_a1915, {
{ label = "리버스 현황 보기", col = _a1648.accent, fn = function()
local _a1919 = _a1626()
_a1599("")
_a1599("──── 리버스 현황 ────")
if not _a1919 then _a1599("  밭 없음") _a1690("log") return end
_a1599(("  현재 리버스   %d회  (최대 %s)"):format(_a1919.regrows, tostring(_a1919.cap)))
_a1599(("  레인          %d / 7 %s"):format(_a1919.lanes, _a1919.lanes >= 7 and "OK" or "부족"))
_a1599(("  코인보스      %d / %d %s"):format(_a1919.kills, _a1919.need,
_a1919.kills >= _a1919.need and "OK" or "부족"))
_a1599("")
_a1599(_a1919.ready and "  ★ 지금 리버스 가능" or ("  대기 — " .. tostring(_a1919.reason)))
_a1690("log")
end },
{ label = "지금 1회 리버스", col = _a1648.bad, fn = function()
task.spawn(function() _a1605.rebirth = true _a1627() _a1605.rebirth = false _a1690("log") end)
end },
})
end
local _a1920 = _a1707("main", "메인 게임", 30)
do
local _a1921, _a1922 = _a1723(_a1920, "올 자동", nil)
local _a1923 = _a1649("Frame", {
Size = UDim2.new(1, 0, 0, 108), BackgroundColor3 = _a1648.cardHi,
BorderSizePixel = 0, LayoutOrder = _a1718(),
}, _a1921)
_a1656(_a1923, 6)
_a1663(_a1923, 8)
local _a1924 = _a1649("TextLabel", {
Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
Font = Enum.Font.Code, TextSize = 12, TextColor3 = _a1648.text,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Text = "정지", RichText = true,
}, _a1923)
task.spawn(function()
while _a1666 and _a1666.Parent do
local _a1925 = _a1635.ctl.now
local _a1926 = _a1605.auto and "🟢" or "⚪"
local _a1927 = _a1925.act or "-"
if _a1925.detail and _a1925.detail ~= "" then _a1927 = _a1927 .. "  " .. _a1925.detail end
_a1924.Text = table.concat({
_a1926 .. " " .. (_a1605.auto and (_a1925.step or "-") or "정지"),
"▸ " .. _a1927,
"목표 " .. (_a1925.goal or "-") .. (_a1925.prog ~= "" and ("   " .. _a1925.prog) or ""),
"1.리버스 " .. (_a1635.auto.rebNote or "-"),
"2.존해금 " .. (_a1635.auto.zoneNote or "-"),
"파밍대상 " .. tostring(_a1635.auto.farmZone or "-") .. "   현재 " .. tostring(_a1635.auto.hereZone or "-"),
}, "\n")
task.wait(0.2)
end
end)
function _a1635.auto.start()
for _a1928, _a1929 in ipairs(_a1635.auto.STEPS) do _a1605[_a1929.run] = false end
for _a1930, _a1931 in ipairs(_a1635.auto.SIDE) do _a1605[_a1931.run] = false end
_a1605.petspd = true
_a1605.rewatch = true
_a1730()
_a1647("auto", function() return _a1603.AutoInterval end, _a1635.auto.master, "자동")
end
_a1733(_a1922, "auto", _a1635.auto.start)
_a1744(_a1921, {
{ label = "주기", value = _a1603.AutoInterval, onChange = function(_a1932)
local _a1933 = tonumber(_a1932) if _a1933 and _a1933 >= 1 then _a1603.AutoInterval = _a1933 end
end },
{ label = "정체 판정(초)", value = _a1603.PursueStallSec, onChange = function(_a1934)
local _a1935 = tonumber(_a1934) if _a1935 and _a1935 >= 10 then _a1603.PursueStallSec = _a1935 end
end },
})
_a1744(_a1921, {
{ label = "운 퀘 최소 알 개수", value = _a1603.HatchMinAfford, onChange = function(_a1936)
local _a1937 = tonumber(_a1936) if _a1937 and _a1937 >= 1 then _a1603.HatchMinAfford = math.floor(_a1937) end
end },
{ label = "더 버는 시간(초)", value = _a1603.MoneyDwell, onChange = function(_a1938)
local _a1939 = tonumber(_a1938) if _a1939 and _a1939 >= 0 then _a1603.MoneyDwell = _a1939 end
end },
})
_a1744(_a1921, {
{ label = "부화 한 번에(초)", value = _a1603.HatchBudget, onChange = function(_a1940)
local _a1941 = tonumber(_a1940) if _a1941 and _a1941 >= 3 then _a1603.HatchBudget = _a1941 end
end },
})
_a1744(_a1921, {
{ label = "이동 방식", value = _a1603.TpMode, onChange = function(_a1942)
_a1942 = tostring(_a1942 or ""):lower()
if _a1942 == "instant" or _a1942 == "glide" or _a1942 == "walk" then _a1603.TpMode = _a1942 end
end },
{ label = "glide 속도", value = _a1603.TpSpeed, onChange = function(_a1943)
local _a1944 = tonumber(_a1943) if _a1944 and _a1944 >= 16 then _a1603.TpSpeed = _a1944 end
end },
})
_a1763(_a1921, "차단 화면에 실제 클릭까지 시도",
function() return _a1603.ScreenRealClick end,
function(_a1945) _a1603.ScreenRealClick = _a1945 end)
_a1763(_a1921, "퀘스트 없을 때도 알 까기",
function() return _a1603.IdleHatch end,
function(_a1946) _a1603.IdleHatch = _a1946 end)
_a1763(_a1921, "존 해금·리버스는 퀘스트 끝나고",
function() return _a1603.HoldZoneForQuest end,
function(_a1947) _a1603.HoldZoneForQuest = _a1947 end)
for _a1948, _a1949 in ipairs(_a1635.auto.STEPS) do
local _a1950 = _a1949.key
_a1763(_a1921, "  " .. _a1948 .. ". " .. _a1949.label,
function() return _a1603.StepOn[_a1950] end,
function(_a1951) _a1603.StepOn[_a1950] = _a1951 end)
end
for _a1952, _a1953 in ipairs(_a1635.auto.SIDE) do
local _a1954 = _a1953.key
_a1763(_a1921, "  · " .. _a1953.label .. " (순위 밖)",
function() return _a1603.StepOn[_a1954] end,
function(_a1955) _a1603.StepOn[_a1954] = _a1955 end)
end
_a1753(_a1921, {
{ label = "지금 상태", col = _a1648.accent, fn = function()
_a1599("")
_a1599("──── 올 자동 ────")
_a1599("  " .. (_a1605.auto and "돌아가는 중" or "정지") ..
(_a1635.auto.step and ("   지금: " .. _a1635.auto.step) or ""))
local _a1956, _a1957 = _a1635.quest.bestDepActive()
_a1599("  현재 존 " .. tostring(_a1635.move.curZone()) .. " / 최고 존 " .. tostring(_a1635.move.bestZone()))
if _a1956 then
_a1599("  ⏸ 존해금·리버스 보류 중 — " .. tostring(_a1957 and _a1957.title))
else
_a1599("  존해금·리버스 진행 가능")
end
_a1599("")
_a1599("  먼저 (순위 밖):")
for _a1958, _a1959 in ipairs(_a1635.auto.SIDE) do
_a1599(("      %-16s %s"):format(_a1959.label, _a1603.StepOn[_a1959.key] and "ON" or "off"))
end
_a1599("  우선순위:")
for _a1960, _a1961 in ipairs(_a1635.auto.STEPS) do
_a1599(("    %d. %-16s %s%s"):format(_a1960, _a1961.label,
_a1603.StepOn[_a1961.key] and "ON" or "off",
_a1961.hold and "   (퀘스트 붙잡는 중엔 보류)" or ""))
end
_a1599("")
_a1599("  세이브")
local _a1962 = _a1601.Save
_a1599("    Library.Client.Save : " .. (_a1962 and "로드됨" or "★ 없음"))
if _a1962 then
local _a1963, _a1964 = pcall(_a1962.Get)
_a1599("    Get()        : " .. (_a1963 and type(_a1964) or ("에러 " .. tostring(_a1964))))
local _a1965, _a1966 = pcall(_a1962.Get, _a1597)
_a1599("    Get(LP)      : " .. (_a1965 and type(_a1966) or ("에러 " .. tostring(_a1966))))
if rawget(_a1962, "GetSaves") then
local _a1967, _a1968 = pcall(_a1962.GetSaves)
if _a1967 and type(_a1968) == "table" then
local _a1969 = 0
for _a1970 in pairs(_a1968) do
_a1969 += 1
if _a1969 <= 3 then _a1599("      키: " .. tostring(_a1970)
.. (_a1970 == _a1597 and "   ← 내 LocalPlayer" or "")) end
end
_a1599("    GetSaves()   : " .. _a1969 .. "개")
else
_a1599("    GetSaves()   : 에러 " .. tostring(_a1968))
end
end
local _a1971 = _a1636()
if _a1971 then
local _a1972 = rawget(_a1971, "Goals")
_a1599("    → 읽기 성공. Rebirths " .. tostring(rawget(_a1971, "Rebirths"))
.. " / Goals " .. (type(_a1972) == "table" and #_a1972 or "없음"))
else
_a1599("    → ★ 어떤 방법으로도 못 읽음")
end
end
_a1599("")
_a1599("  마지막 바퀴 (" .. tostring(_a1635.auto.passN or 0) .. "번째)")
if _a1635.auto.lastPassAt then
_a1599(("    %.0f초 전"):format(os.clock() - _a1635.auto.lastPassAt))
else
_a1599("    아직 한 바퀴도 안 돎 — 루프가 안 돌고 있습니다")
end
for _a1973, _a1974 in ipairs(_a1635.auto.lastTrace or {}) do _a1599("    " .. _a1974) end
_a1690("log")
end },
{ label = "화면 넘기기 진단", col = _a1648.warn, fn = function()
task.spawn(function()
_a1599("")
_a1599("──── 보상 화면 ────")
local _a1975 = _a1634.Vars
_a1599("  Library.Variables : " .. (_a1975 and "로드됨" or "없음"))
if _a1975 then
_a1599("    IsRebirthing = " .. tostring(rawget(_a1975, "IsRebirthing")))
_a1599("    IsRankingUp  = " .. tostring(rawget(_a1975, "IsRankingUp")))
_a1599("    OpeningEgg   = " .. tostring(rawget(_a1975, "OpeningEgg")))
end
_a1599("  debug.info     : " .. tostring(type(debug) == "table" and type(debug.info) == "function"))
_a1599("  getgc          : " .. tostring(type(getgc) == "function"))
_a1599("  debug.setupvalue: " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
local _a1976 = _a1597:FindFirstChildOfClass("PlayerGui")
if _a1976 then
_a1599("  떠 있는 차단 화면:")
local _a1977 = false
for _a1978, _a1979 in ipairs(_a1635.screen.BLOCKERS) do
local _a1980 = _a1976:FindFirstChild(_a1979[1])
_a1599(("    %-14s %s"):format(_a1979[1],
_a1980 and (_a1980.Enabled and "★ 켜짐" or "꺼짐") or "없음"))
if _a1980 and _a1980.Enabled then _a1977 = true end
end
if not _a1977 then _a1599("    (없음)") end
end
if type(getgc) == "function" and type(debug) == "table" and debug.info then
_a1599("")
_a1599("  Rebirth/RankUp 스크립트의 클로저 시그니처:")
local _a1981, _a1982 = {}, 0
for _a1983, _a1984 in ipairs({ true, false }) do
local _a1985, _a1986 = pcall(getgc, _a1984)
if _a1985 then
for _a1987, _a1988 in ipairs(_a1986) do
if type(_a1988) == "function" and _a1982 < 25 then
local _a1989, _a1990 = pcall(debug.info, _a1988, "s")
if _a1989 and type(_a1990) == "string"
and (_a1990:find("Rebirth", 1, true) or _a1990:find("Rank Up", 1, true)) then
local _a1991, _a1992 = pcall(debug.info, _a1988, "a")
if _a1991 then
local _a1993 = {}
for _a1994 = 1, 16 do
local _a1995, _a1996 = pcall(debug.getupvalue, _a1988, _a1994)
if not _a1995 then break end
_a1993[_a1994] = type(_a1996)
end
local _a1997 = ("인자%d | %s"):format(_a1992 or -1,
#_a1993 > 0 and table.concat(_a1993, ",") or "(없음)")
if not _a1981[_a1997] then
_a1981[_a1997] = true
_a1982 += 1
_a1599("    " .. _a1997)
end
end
end
end
end
end
end
if _a1982 == 0 then _a1599("    (하나도 못 찾음)") end
end
for _a1998, _a1999 in ipairs({ "reward", "egg", "mastery", "card" }) do
_a1635.screen._sig = nil
local _a2000 = _a1635.screen.findSignalFns(_a1999)
_a1599("")
_a1599(("  [%s] 찾은 함수 %d개"):format(_a1999, #_a2000))
for _a2001, _a2002 in ipairs(_a2000) do
_a1599(("    %s%s"):format(_a2002.exact and "★정확일치 " or "", tostring(_a2002.src)))
_a1599(("       upvalue %d개 : %s"):format(_a2002.n or 0, tostring(_a2002.sig)))
end
if #_a2000 == 0 then
_a1599("    (getgc 로 그 스크립트의 클로저를 못 찾음)")
end
local _a2003, _a2004 = _a1635.screen.signal(_a1999)
_a1599(("    upvalue 신호 : %s (%s개 세팅)"):format(tostring(_a2003), tostring(_a2004)))
local _a2005 = _a1635.screen.SIGNAL[_a1999]
_a1599(("    게임내 입력발동 : %s"):format(
tostring(_a1635.screen.pressInGame(_a2005 and _a2005.pats or {}))))
end
_a1599("")
_a1599("  감시 루프 RUN.rewatch = " .. tostring(_a1605.rewatch))
_a1690("log")
end)
end },
{ label = "한 바퀴만", col = _a1648.cardHi, fn = function()
task.spawn(function()
_a1605.auto = true _a1635.auto.master() _a1605.auto = false _a1690("log")
end)
end },
{ label = "자동 점검", col = _a1648.warn, fn = function()
task.spawn(function()
_a1599("")
_a1599("════ 올 자동 점검 ════")
_a1599("  RUN.auto = " .. tostring(_a1605.auto))
local _a2006 = {}
for _a2007, _a2008 in ipairs(_a1635.auto.SIDE) do
_a2006[#_a2006 + 1] = _a2008.key .. "=" .. tostring(_a1603.StepOn[_a2008.key])
end
for _a2009, _a2010 in ipairs(_a1635.auto.STEPS) do
_a2006[#_a2006 + 1] = _a2010.key .. "=" .. tostring(_a1603.StepOn[_a2010.key])
end
_a1599("  단계 ON/OFF : " .. table.concat(_a2006, "  "))
_a1599("  lockGoal    : " .. (_a1635.ctl.lockGoal and tostring(_a1635.ctl.lockGoal.q.title) or "없음"))
local _a2011, _a2012 = _a1635.quest.bestDepActive()
_a1599("  보류중?     : " .. tostring(_a2011) .. (_a2012 and ("  ← " .. tostring(_a2012.title)) or ""))
_a1599("  리모트      : 존 " .. (_a1634.R_Zone and "O" or "X")
.. " / 리버스 " .. (_a1634.R_Reb and "O" or "X"))
_a1599("")
_a1599("  ── 존 해금 판정 ──")
local _a2013 = _a1639()
if not _a2013 then
_a1599("    zoneStatus() = nil  ← 다음 존을 못 구함")
local _a2014 = _a1634.Zone and rawget(_a1634.Zone, "GetNextZone")
if _a2014 then
local _a2015, _a2016, _a2017 = pcall(_a1634.Zone.GetNextZone)
_a1599("    GetNextZone → ok=" .. tostring(_a2015)
.. " / " .. tostring(_a2016) .. " / " .. tostring(_a2017))
end
if _a1634.Zone and rawget(_a1634.Zone, "HasCompletedNextZoneQuests") then
local _a2018, _a2019 = pcall(_a1634.Zone.HasCompletedNextZoneQuests)
_a1599("    존 퀘스트 완료? " .. (_a2018 and tostring(_a2019) or ("에러 " .. tostring(_a2019))))
end
else
_a1599("    다음 존 : " .. tostring(_a2013.id))
_a1599(("    가격 %s %s / 보유 %s → %s"):format(
_a1600(_a2013.price or 0, 0), tostring(_a2013.currency), _a1600(_a2013.have, 0),
_a2013.ok and "지금 살 수 있음" or "부족"))
end
_a1599("")
_a1599("  ── 리버스 판정 ──")
local _a2020 = _a1644()
if not _a2020 then _a1599("    세이브 못 읽음")
else
_a1599(("    현재 %d → 다음 %d"):format(_a2020.current, _a2020.nextN))
_a1599("    최근 사유 : " .. tostring(_a1635.auto.rebNote or "-"))
end
_a1599("")
_a1599("  ── 직전 바퀴 기록 ──")
if _a1635.auto.lastTrace and #_a1635.auto.lastTrace > 0 then
for _a2021, _a2022 in ipairs(_a1635.auto.lastTrace) do _a1599("    " .. _a2022) end
_a1599(("    (%.0f초 전)"):format(os.clock() - (_a1635.auto.lastPassAt or os.clock())))
else
_a1599("    아직 한 바퀴도 안 돌았음")
end
_a1690("log")
end)
end },
})
local _a2023, _a2024 = _a1723(_a1920, "펫 이동속도", nil)
_a1733(_a2024, "petspd", function()
_a1647("petspd", function() return 0.4 end, _a1635.item.applyPetSpeed, "펫속도")
end)
_a1744(_a2023, {
{ label = "배수", value = _a1603.PetSpeedMult, onChange = function(_a2025)
local _a2026 = tonumber(_a2025) if _a2026 and _a2026 >= 1 then _a1603.PetSpeedMult = _a2026 end
end },
{ label = "기본 계수 (원래 0.45)", value = _a1603.PetSpeedBase, onChange = function(_a2027)
local _a2028 = tonumber(_a2027) if _a2028 and _a2028 > 0 then _a1603.PetSpeedBase = _a2028 end
end },
})
_a1753(_a2023, {
{ label = "지금 적용 / 확인", col = _a1648.accent, fn = function()
local _a2029, _a2030 = _a1635.item.applyPetSpeed()
_a1599("")
_a1599("──── 펫 이동속도 ────")
_a1599("  PlayerPet 모듈 : " .. (_a1634.PlayerPet and "로드됨" or "없음"))
_a1599(("  적용된 펫 %d마리  (배수 %s / 계수 %s)"):format(
_a2029, tostring(_a1603.PetSpeedMult), tostring(_a1603.PetSpeedBase)))
if _a2030 then _a1599("  " .. tostring(_a2030)) end
if _a2029 == 0 then _a1599("  펫을 장착하고 다시 눌러보세요") end
_a1690("log")
end },
})
_a1647("petspd", function() return 0.4 end, _a1635.item.applyPetSpeed, "펫속도")
_a1647("rewatch", function() return 1 end, function()
_a1635.screen.watchTick = (_a1635.screen.watchTick or 0) + 1
_a1635.egg.watchStuck()
if _a1635.screen.dismissBusy then return end
local _a2031, _a2032 = _a1635.screen.rewardScreenUp()
if _a2031 and _a1635.screen.screenGaveUp and (os.clock() - _a1635.screen.screenGaveUp) < 30 then
return
end
if _a2031 then
if _a1635.screen.lastBlocker ~= _a2032 then
_a1635.screen.lastBlocker = _a2032
_a1599("[화면] " .. tostring(_a2032) .. " 화면 감지 — 넘기는 중")
end
_a1635.screen.dismissRewardScreens(20)
end
end, "보상화면")
local _a2033, _a2034 = _a1723(_a1920, "자동 파밍 유지", nil)
_a1733(_a2034, "farm", function()
_a1647("farm", function() return _a1603.FarmInterval end, _a1638, "파밍")
end)
_a1744(_a2033, {
{ label = "주기", value = _a1603.FarmInterval, onChange = function(_a2035)
local _a2036 = tonumber(_a2035) if _a2036 and _a2036 >= 3 then _a1603.FarmInterval = _a2036 end
end },
})
local _a2037, _a2038 = _a1723(_a1920, "자동 존 해금", nil)
_a1733(_a2038, "zone", function()
_a1647("zone", function() return _a1603.ZoneInterval end, _a1640, "존")
end)
_a1744(_a2037, {
{ label = "주기", value = _a1603.ZoneInterval, onChange = function(_a2039)
local _a2040 = tonumber(_a2039) if _a2040 and _a2040 >= 3 then _a1603.ZoneInterval = _a2040 end
end },
})
_a1753(_a2037, {
{ label = "다음 존 보기", col = _a1648.accent, fn = function()
local _a2041 = _a1639()
_a1599("")
if not _a2041 then _a1599("[존] 다음 존 없음 (최대 도달?)")
else
_a1599("──── 다음 존 ────")
_a1599("  " .. tostring(_a2041.id))
_a1599("  가격 " .. _a1600(_a2041.price or 0, 0) .. " " .. tostring(_a2041.currency))
_a1599("  보유 " .. _a1600(_a2041.have, 0))
_a1599("  " .. (_a2041.ok and "지금 해금 가능" or "부족"))
end
_a1690("log")
end },
{ label = "지금 1회", col = _a1648.cardHi, fn = function()
task.spawn(function() _a1605.zone = true _a1640() _a1605.zone = false _a1690("log") end)
end },
})
local _a2042, _a2043 = _a1723(_a1920, "자동 부화", nil)
_a1733(_a2043, "mhatch", function()
_a1647("mhatch", function() return _a1603.MainHatchInterval end, _a1643, "부화")
end)
_a1744(_a2042, {
{ label = "주기", value = _a1603.MainHatchInterval, onChange = function(_a2044)
local _a2045 = tonumber(_a2044) if _a2045 and _a2045 >= 1 then _a1603.MainHatchInterval = _a2045 end
end },
{ label = "한 번에 최대", value = _a1603.MainHatchMax, onChange = function(_a2046)
local _a2047 = tonumber(_a2046) if _a2047 and _a2047 >= 1 then _a1603.MainHatchMax = math.floor(_a2047) end
end },
})
_a1744(_a2042, {
{ label = "예비금", value = _a1603.MainHatchReserve, onChange = function(_a2048)
local _a2049 = tonumber(_a2048) if _a2049 and _a2049 >= 0 then _a1603.MainHatchReserve = _a2049 end
end },
{ label = "알 ID (비우면 자동)", value = _a1603.MainEggId, onChange = function(_a2050)
_a1603.MainEggId = _a2050 or ""
end },
})
_a1744(_a2042, {
{ label = "알 인식 거리", value = _a1603.EggRange, onChange = function(_a2051)
local _a2052 = tonumber(_a2051) if _a2052 and _a2052 >= 5 then _a1603.EggRange = _a2052 end
end },
})
_a1763(_a2042, "새 맵 열리면 잠긴 알 자동 해금",
function() return _a1603.AutoUnlockEgg end,
function(_a2053) _a1603.AutoUnlockEgg = _a2053 end)
_a1763(_a2042, "게임 내장 오토해치 사용 (기본 끔)",
function() return _a1603.UseAutoHatch end,
function(_a2054) _a1603.UseAutoHatch = _a2054 if not _a2054 then _a1635.egg.autoHatchOff() end end)
_a1763(_a2042, "까는 화면 자동으로 넘기기 (신호)",
function() return _a1603.HatchClick end,
function(_a2055) _a1603.HatchClick = _a2055 end)
_a1753(_a2042, {
{ label = "잠긴 알 보기", col = _a1648.accent, fn = function()
local _a2056, _a2057, _a2058 = _a1635.egg.lockedEggs()
_a1599("")
_a1599("──── 알 해금 현황 ────")
_a1599(("  해금 가능 최대 : #%d   /   현재 해금한 최대 : #%d"):format(_a2057, _a2058))
_a1599("  해금 리모트 : " .. (_a1634.R_EggUn and "있음" or "없음"))
if #_a2056 == 0 then
_a1599("  풀 수 있는 알이 없음 (다 풀었거나 존을 더 사야 함)")
else
_a1599("  아직 안 푼 알 " .. #_a2056 .. "개:")
for _a2059, _a2060 in ipairs(_a2056) do
_a1599(("    #%-3d %s"):format(_a2060.num, _a2060.id))
if _a2059 >= 20 then _a1599("    ...") break end
end
end
_a1690("log")
end },
{ label = "부화 진단", col = _a1648.warn, fn = function()
task.spawn(function()
_a1599("")
_a1599("──── 부화 진단 ────")
local _a2061, _a2062, _a2063, _a2064 = _a1641()
_a1599("  대상 알   : " .. tostring(_a2061))
if not _a2061 then _a1599("  (오픈한 알이 없음)") _a1690("log") return end
local _a2065 = _a2062 and tonumber(rawget(_a2062, "eggNumber"))
_a1599("  알 번호   : " .. tostring(_a2065) .. "   오픈함? " .. tostring(_a1635.egg.eggUnlocked(_a2065)))
_a1599("  거리      : " .. (_a2063 and ("%.0f (사거리 안)"):format(_a2063)
or ((_a2064 and ("%.0f (사거리 %d 밖)"):format(_a2064, _a1603.EggRange)) or "받침대 못 찾음")))
local _a2066 = _a2062 and rawget(_a2062, "currency") or "?"
_a1599("  통화      : " .. tostring(_a2066) .. "   보유 " .. _a1600(_a1637(_a2066), 0))
if type(_a1634.CalcEgg) == "function" then
local _a2067, _a2068 = pcall(_a1634.CalcEgg, _a2062)
_a1599("  CalcEggPricePlayer : " .. (_a2067 and tostring(_a2068) or ("에러 " .. tostring(_a2068))))
end
if type(_a1634.CalcEggB) == "function" then
local _a2069, _a2070 = pcall(_a1634.CalcEggB, _a2062)
_a1599("  CalcEggPrice       : " .. (_a2069 and tostring(_a2070) or ("에러 " .. tostring(_a2070))))
end
if _a1634.Egg then
for _a2071, _a2072 in ipairs({ "GetMaxHatch", "ComputeDebounce", "GetHighestEggNumberAvailable" }) do
if rawget(_a1634.Egg, _a2072) then
local _a2073, _a2074 = pcall(_a1634.Egg[_a2072], _a2062)
_a1599(("  %-28s : %s"):format(_a2072, _a2073 and tostring(_a2074) or ("에러 " .. tostring(_a2074))))
end
end
end
_a1599("  OpeningEgg      : " .. tostring(_a1634.Vars and rawget(_a1634.Vars, "OpeningEgg")))
if _a1634.Hatch then
for _a2075, _a2076 in ipairs({ "IsHatching", "GetEggAmount" }) do
if rawget(_a1634.Hatch, _a2076) then
local _a2077, _a2078 = pcall(_a1634.Hatch[_a2076])
_a1599(("  %-15s : %s"):format(_a2076, _a2077 and tostring(_a2078) or ("에러 " .. tostring(_a2078))))
end
end
if rawget(_a1634.Hatch, "GetEggDirectory") then
local _a2079, _a2080 = pcall(_a1634.Hatch.GetEggDirectory)
_a1599("  세팅된 알       : " .. (_a2079 and _a2080 and tostring(rawget(_a2080, "_id")) or "없음"))
end
end
_a1599("  ▶ SetupEgg 시도")
_a1635.egg._ahEgg = nil
_a1635.egg.autoHatchOn(_a2061, 1)
if _a1634.Hatch and rawget(_a1634.Hatch, "IsHatching") then
local _a2081, _a2082 = pcall(_a1634.Hatch.IsHatching)
_a1599("    IsHatching 이후 : " .. (_a2081 and tostring(_a2082) or ("에러 " .. tostring(_a2082))))
_a1599("    " .. ((_a2081 and _a2082) and "→ 클릭 없이 넘어갑니다"
or "→ SetupEgg 안 먹음. 클릭 대체가 필요합니다"))
end
_a1599("  신호 가능 : getgc " .. tostring(type(getgc) == "function")
.. " / debug.setupvalue " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
_a1599("")
_a1599("  ▶ 1개로 실제 호출")
local _a2083, _a2084
local _a2085 = pcall(function() _a2083, _a2084 = _a1602.R_EGG:InvokeServer(_a2061, 1) end)
_a1599("    호출성공 : " .. tostring(_a2085))
_a1599("    반환1    : " .. tostring(_a2083))
_a1599("    반환2    : " .. tostring(_a2084))
_a1690("log")
end)
end },
{ label = "지금 전부 해금", col = _a1648.good, fn = function()
task.spawn(function()
_a1599("")
local _a2086, _a2087 = _a1635.egg.unlockEggs(true)
_a1599(_a2086 > 0 and ("[해금] %d개 완료"):format(_a2086)
or ("[해금] 0개" .. (_a2087 and (" — " .. tostring(_a2087)) or "")))
_a1690("log")
end)
end },
})
_a1753(_a2042, {
{ label = "알 현황 보기", col = _a1648.accent, fn = function()
local _a2088 = _a1642()
_a1599("")
if not _a2088 then _a1599("[부화] 알을 못 찾음")
else
_a1599("──── 메인 알 ────")
_a1599("  " .. tostring(_a2088.id))
_a1599("  가격 " .. (_a2088.price and _a1600(_a2088.price, 0) or "?") .. " " .. tostring(_a2088.currency))
_a1599("  보유 " .. _a1600(_a2088.have, 0))
_a1599("  한 번에 " .. _a2088.maxN .. "개까지")
_a1599("  지금 가능 " .. _a2088.canBuy .. "회")
if _a2088.inRange then
_a1599(("  거리 %.0f 스터드 — 부화 가능"):format(_a2088.dist))
else
_a1599(("  사거리(%d) 안에 알 없음. 가장 가까운 알 %s스터드"):format(
_a1603.EggRange, _a2088.nearest and ("%.0f"):format(_a2088.nearest) or "?"))
_a1599("  → 알 앞으로 걸어가야 부화됩니다")
end
end
_a1599("")
_a1599("──── 주변 알 (가까운 순 10개) ────")
local _a2089 = _a1635.egg.eggStands()
for _a2090 = 1, math.min(10, #_a2089) do
local _a2091 = _a2089[_a2090]
_a1599(("  %6.0f  #%-3d %-24s %s"):format(
_a2091.dist, _a2091.num, _a2091.id, _a1635.egg.eggUnlocked(_a2091.num) and "오픈함" or "잠김"))
end
if #_a2089 == 0 then _a1599("  (못 찾음)") end
_a1690("log")
end },
{ label = "지금 1회", col = _a1648.cardHi, fn = function()
task.spawn(function() _a1605.mhatch = true _a1643() _a1605.mhatch = false _a1690("log") end)
end },
})
local _a2092, _a2093 = _a1723(_a1920, "랭크 퀘스트 자동", nil)
_a1733(_a2093, "quest", function()
_a1647("quest", function() return _a1603.QuestInterval end, _a1635.quest.cycle, "퀘스트")
end)
_a1744(_a2092, {
{ label = "주기", value = _a1603.QuestInterval, onChange = function(_a2094)
local _a2095 = tonumber(_a2094) if _a2095 and _a2095 >= 5 then _a1603.QuestInterval = _a2095 end
end },
{ label = "포션 한 번에", value = _a1603.QuestUseMax, onChange = function(_a2096)
local _a2097 = tonumber(_a2096) if _a2097 and _a2097 >= 1 then _a1603.QuestUseMax = math.floor(_a2097) end
end },
})
_a1763(_a2092, "필요한 자동화 자동 ON",
function() return _a1603.QuestDrive end,
function(_a2098) _a1603.QuestDrive = _a2098 end)
_a1763(_a2092, "포션/인챈트 업글 퀘스트",
function() return _a1603.QuestUpgrade end,
function(_a2099) _a1603.QuestUpgrade = _a2099 end)
_a1763(_a2092, "포션 사용 퀘스트",
function() return _a1603.QuestUsePotion end,
function(_a2100) _a1603.QuestUsePotion = _a2100 end)
_a1753(_a2092, {
{ label = "퀘스트 현황 보기", col = _a1648.accent, fn = function()
local _a2101 = _a1635.quest.status()
_a1599("")
if not _a2101 then _a1599("[퀘스트] 세이브 못 읽음")
else
_a1599("──── 랭크 퀘스트 ────")
_a1599(("  Rank %d   ★%d"):format(_a2101.rank, _a2101.rankStars))
if #_a2101.list == 0 then _a1599("  퀘스트 없음") end
for _a2102, _a2103 in ipairs(_a2101.list) do
local _a2104 = _a2103.how
local _a2105 =
(_a2104 == "farm" and "자동 파밍") or
(_a2104 == "hatch" and "자동 부화") or
(_a2104 == "zone" and "자동 존") or
(_a2104 == "potup" and "포션 업글") or
(_a2104 == "encup" and "인챈트 업글") or
(_a2104 == "potuse" and "포션 사용") or
(_a2104 == "fruituse" and "과일 사용") or
(_a2104 == "flaguse" and "깃발 사용") or
(_a2104 == "gold" and "골드 머신") or
(_a2104 == "rainbow" and "레인보우 머신") or
"수동"
local _a2106 = ""
if _a2103.ignored then
_a2105 = "무시"
_a2106 = "   → " .. _a2103.ignored
elseif _a2103.event then
local _a2107 = _a1635.ev.findEvent(_a2103.event, _a2103.bestOnly)
_a2106 = _a2107 and ("   → %s @%s %d초"):format(_a2107.name, tostring(_a2107.zone), _a2107.left)
or ("   → " .. _a2103.event .. " 대기중")
elseif _a2103.chest then
_a2106 = "   → " .. _a2103.chest
elseif _a2103.where then
_a2106 = "   → " .. _a2103.where
end
_a1599(("  [%d] %s"):format(_a2103.stars, tostring(_a2103.title)))
_a1599(("       %d / %d    처리: %s   (Type %d)%s"):format(
_a2103.progress, _a2103.amount, _a2105, _a2103.type, _a2106))
end
end
_a1690("log")
end },
{ label = "활성 이벤트 보기", col = _a1648.accent, fn = function()
local _a2108 = _a1635.ev.events()
local _a2109 = _a1635.move.bestZone()
_a1599("")
_a1599("──── 지금 떠 있는 랜덤 이벤트 ────")
_a1599("  최고 존 : " .. tostring(_a2109) .. "   현재 존 : " .. tostring(_a1635.move.curZone()))
if #_a2108 == 0 then _a1599("  없음 (RandomEvents_Get 응답 비어있음)") end
for _a2110, _a2111 in ipairs(_a2108) do
_a1599(("  %-12s @%-20s %4d초 남음  %s%s"):format(
_a2111.kind, tostring(_a2111.zone), _a2111.left,
_a2111.pos and ("(%.0f, %.0f, %.0f)"):format(_a2111.pos.X, _a2111.pos.Y, _a2111.pos.Z) or "좌표없음",
_a2111.zone == _a2109 and "  ★최고존" or ""))
end
_a1599("")
_a1599("  내 소환 아이템 :")
for _a2112 in pairs(_a1635.ev.SPAWN) do
local _a2113 = _a1635.ev.spawnItems(_a2112)
local _a2114 = 0
for _a2115, _a2116 in ipairs(_a2113) do _a2114 += _a2116.am end
_a1599(("    %-12s %d종 %d개"):format(_a2112, #_a2113, _a2114))
for _a2117, _a2118 in ipairs(_a2113) do
_a1599(("        %d. %-24s x%d%s"):format(
_a2117, _a2118.id, _a2118.am, _a2117 == 1 and "   ← 먼저 씀" or ""))
if _a2117 >= 6 then break end
end
end
_a1599("  점선 네모 안? " .. tostring(_a1635.move.inDottedBox()))
for _a2119, _a2120 in ipairs({ "MiniChests", "SuperiorMiniChests" }) do
local _a2121, _a2122 = _a1635.ev.findChest(_a2120)
_a1599(("  %-20s %s"):format(_a2120,
_a2121 and ("가장 가까운 것 %.0f스터드"):format(_a2122 or 0) or "없음"))
end
_a1690("log")
end },
{ label = "포션 재고 보기", col = _a1648.accent, fn = function()
_a1599("")
_a1599("──── 포션 / 인챈트 재고 ────")
for _a2123, _a2124 in ipairs({ "Potion", "Enchant" }) do
local _a2125 = _a1635.item.stacks(_a2124)
table.sort(_a2125, function(_a2126, _a2127)
if _a2126.id ~= _a2127.id then return _a2126.id < _a2127.id end
return _a2126.tier < _a2127.tier
end)
_a1599("")
_a1599(_a2124 .. "  (" .. #_a2125 .. "종)")
for _a2128, _a2129 in ipairs(_a2125) do
local _a2130 = _a1635.item.perTier(_a2124, _a2129.tier)
local _a2131 = _a2130 and math.floor(_a2129.am / _a2130) or 0
_a1599(("   %-20s T%-2d x%-6d %s"):format(
_a2129.id, _a2129.tier, _a2129.am,
_a2131 > 0 and ("→ T" .. (_a2129.tier + 1) .. " " .. _a2131 .. "개 제작가능") or ""))
if _a2128 >= 40 then _a1599("   ...") break end
end
if #_a2125 == 0 then _a1599("   (없음)") end
end
_a1690("log")
end },
{ label = "지금 1회", col = _a1648.cardHi, fn = function()
task.spawn(function() _a1605.quest = true _a1635.quest.cycle() _a1605.quest = false _a1690("log") end)
end },
})
local _a2132, _a2133 = _a1723(_a1920, "슬롯 머신 자동 (다이아)", nil)
_a1733(_a2133, "slots", function()
_a1647("slots", function() return _a1603.SlotInterval end, _a1635.mach.cycleSlots, "슬롯")
end)
_a1744(_a2132, {
{ label = "주기", value = _a1603.SlotInterval, onChange = function(_a2134)
local _a2135 = tonumber(_a2134) if _a2135 and _a2135 >= 5 then _a1603.SlotInterval = _a2135 end
end },
{ label = "남길 다이아", value = _a1603.SlotReserve, onChange = function(_a2136)
local _a2137 = tonumber(_a2136) if _a2137 and _a2137 >= 0 then _a1603.SlotReserve = _a2137 end
end },
})
_a1763(_a2132, "펫 장착 슬롯 (Pet Equip)",
function() return _a1603.SlotPet end, function(_a2138) _a1603.SlotPet = _a2138 end)
_a1763(_a2132, "알 부화 슬롯 (Egg Machine)",
function() return _a1603.SlotEgg end, function(_a2139) _a1603.SlotEgg = _a2139 end)
_a1753(_a2132, {
{ label = "슬롯 현황 보기", col = _a1648.accent, fn = function()
local _a2140 = _a1635.mach.slotStatus()
_a1599("")
_a1599("──── 슬롯 머신 ────")
if not _a2140 then _a1599("  세이브 못 읽음") _a1690("log") return end
_a1599("  다이아 " .. _a1600(_a2140.dia, 0))
_a1599("")
_a1599(("  펫 장착 : 구매 %d / 랭크상한 %d   현재 최대장착 %s"):format(
_a2140.petOwned, _a2140.petMax, tostring(_a2140.maxEquip)))
if _a2140.petNext then
_a1599(("     다음 #%d  %s 다이아  %s"):format(
_a2140.petNext, _a2140.petCost and _a1600(_a2140.petCost, 0) or "?",
(_a2140.petCost and _a2140.petCost <= _a2140.dia - _a1603.SlotReserve) and "← 지금 가능" or "부족"))
else
_a1599("     랭크 상한까지 다 삼 (랭크를 올려야 더 살 수 있음)")
end
_a1599("")
_a1599(("  알 부화 : 구매 %d / 랭크상한 %d   한 번에 %s개"):format(
_a2140.eggOwned, _a2140.eggMax, tostring(_a2140.maxHatch)))
if _a2140.eggEnd then
_a1599(("     다음 %d칸 묶음 → %d   %s 다이아  %s"):format(
_a2140.eggSize, _a2140.eggEnd, _a2140.eggCost and _a1600(_a2140.eggCost, 0) or "?",
(_a2140.eggCost and _a2140.eggCost <= _a2140.dia - _a1603.SlotReserve) and "← 지금 가능" or "부족"))
else
_a1599("     랭크 상한까지 다 삼")
end
_a1599("")
_a1599("  리모트 : 펫 " .. (_a1634.R_PetSlot and "O" or "X")
.. " / 알 " .. (_a1634.R_EggSlot and "O" or "X"))
_a1690("log")
end },
{ label = "지금 1회", col = _a1648.cardHi, fn = function()
task.spawn(function() _a1605.slots = true _a1635.mach.cycleSlots() _a1605.slots = false _a1690("log") end)
end },
})
local _a2141, _a2142 = _a1723(_a1920, "아이템 자동 사용 (버프 유지)", nil)
_a1733(_a2142, "items", function()
_a1647("items", function() return _a1603.ItemInterval end, _a1635.item.cycleItems, "아이템")
end)
_a1744(_a2141, {
{ label = "주기", value = _a1603.ItemInterval, onChange = function(_a2143)
local _a2144 = tonumber(_a2143) if _a2144 and _a2144 >= 5 then _a1603.ItemInterval = _a2144 end
end },
{ label = "포션 한 바퀴 최대", value = _a1603.BuffMaxPotion, onChange = function(_a2145)
local _a2146 = tonumber(_a2145) if _a2146 and _a2146 >= 1 then _a1603.BuffMaxPotion = math.floor(_a2146) end
end },
})
_a1744(_a2141, {
{ label = "남길 개수", value = _a1603.ItemKeep, onChange = function(_a2147)
local _a2148 = tonumber(_a2147) if _a2148 and _a2148 >= 0 then _a1603.ItemKeep = math.floor(_a2148) end
end },
{ label = "과일/소모품 최대", value = _a1603.BuffMaxOther, onChange = function(_a2149)
local _a2150 = tonumber(_a2149) if _a2150 and _a2150 >= 1 then _a1603.BuffMaxOther = math.floor(_a2150) end
end },
})
_a1744(_a2141, {
{ label = "쓸 것 (비우면 전부)", value = _a1603.ItemAllow, onChange = function(_a2151)
_a1603.ItemAllow = _a2151 or ""
end },
{ label = "제외", value = _a1603.ItemBlock, onChange = function(_a2152)
_a1603.ItemBlock = _a2152 or ""
end },
})
_a1763(_a2141, "포션", function() return _a1603.BuffPotion end,
function(_a2153) _a1603.BuffPotion = _a2153 end)
_a1763(_a2141, "과일", function() return _a1603.BuffFruit end,
function(_a2154) _a1603.BuffFruit = _a2154 end)
_a1763(_a2141, "얼티밋 (충전되면 발동, 무료)", function() return _a1603.BuffUltimate end,
function(_a2155) _a1603.BuffUltimate = _a2155 end)
_a1763(_a2141, "소모품 (Rain/Sunlight 주의)", function() return _a1603.BuffConsumable end,
function(_a2156) _a1603.BuffConsumable = _a2156 end)
_a1763(_a2141, "높은 티어부터 사용 (끄면 낮은 것부터)", function() return _a1603.BuffHighTier end,
function(_a2157) _a1603.BuffHighTier = _a2157 end)
_a1763(_a2141, "최고 존에서만 사용", function() return _a1603.ItemBestZone end,
function(_a2158) _a1603.ItemBestZone = _a2158 end)
_a1763(_a2141, "최고 존이 아니면 이동 후 사용", function() return _a1603.ItemTp end,
function(_a2159) _a1603.ItemTp = _a2159 end)
_a1753(_a2141, {
{ label = "버프 현황 보기", col = _a1648.accent, fn = function()
_a1599("")
_a1599("──── 버프 / 아이템 ────")
_a1599(("  현재 존 %s / 최고 존 %s%s"):format(
tostring(_a1635.move.curZone()), tostring(_a1635.move.bestZone()),
_a1603.ItemBestZone and (_a1635.move.curZone() == _a1635.move.bestZone() and "   ← 사용 가능" or "   ← 이동 필요") or ""))
for _a2160, _a2161 in pairs({ Potions = "Potion", Fruits = "Fruit" }) do
local _a2162 = _a1635.item.activeBuffs(_a2160)
local _a2163 = {}
for _a2164 in pairs(_a2162) do _a2163[#_a2163 + 1] = _a2164 end
table.sort(_a2163)
_a1599(("  지금 걸린 %s : %s"):format(_a2160,
#_a2163 > 0 and table.concat(_a2163, ", ") or "없음"))
end
local _a2165 = _a1636()
local _a2166 = _a2165 and rawget(_a2165, "Ultimates")
if type(_a2166) == "table" then
local _a2167 = {}
for _a2168 in pairs(_a2166) do
local _a2169 = "?"
if _a1634.Ult and rawget(_a1634.Ult, "IsCharged") then
local _a2170, _a2171 = pcall(_a1634.Ult.IsCharged, _a2168)
_a2169 = _a2170 and (_a2171 and "충전됨" or "충전중") or "?"
end
_a2167[#_a2167 + 1] = _a2168 .. "(" .. _a2169 .. ")"
end
_a1599("  얼티밋 : " .. (#_a2167 > 0 and table.concat(_a2167, ", ") or "없음"))
end
_a1599("")
for _a2172, _a2173 in ipairs({ "Potion", "Fruit", "Consumable" }) do
local _a2174 = _a1635.item.stacks(_a2173)
local _a2175, _a2176 = 0, 0
for _a2177, _a2178 in ipairs(_a2174) do
if _a1635.item.itemAllowed(_a2178.id) then _a2175 += 1 else _a2176 += 1 end
end
_a1599(("  %-12s %d종 (쓸 수 있음 %d / 제외 %d)"):format(_a2173, #_a2174, _a2175, _a2176))
for _a2179, _a2180 in ipairs(_a2174) do
_a1599(("      %-20s T%-2d x%-6d %s"):format(
_a2180.id, _a2180.tier, _a2180.am, _a1635.item.itemAllowed(_a2180.id) and "" or "제외됨"))
if _a2179 >= 12 then _a1599("      ...") break end
end
end
_a1599("")
_a1599("  리모트 : 포션 " .. (_a1634.R_PotUse and "O" or "X")
.. " / 과일 " .. (_a1634.R_Fruit and "O" or "X")
.. " / 소모품 " .. (_a1634.R_Cons and "O" or "X")
.. " / 얼티밋 " .. (_a1634.R_Ult and "O" or "X"))
_a1690("log")
end },
{ label = "지금 1회", col = _a1648.cardHi, fn = function()
task.spawn(function() _a1605.items = true _a1635.item.cycleItems() _a1605.items = false _a1690("log") end)
end },
})
local _a2181, _a2182 = _a1723(_a1920, "맵 업그레이드 자동 (다이아)", nil)
_a1733(_a2182, "mapupg", function()
_a1647("mapupg", function() return _a1603.UpgInterval end, _a1635.mach.cycleUpg, "맵업글")
end)
_a1744(_a2181, {
{ label = "주기", value = _a1603.UpgInterval, onChange = function(_a2183)
local _a2184 = tonumber(_a2183) if _a2184 and _a2184 >= 5 then _a1603.UpgInterval = _a2184 end
end },
{ label = "남길 다이아", value = _a1603.UpgReserve, onChange = function(_a2185)
local _a2186 = tonumber(_a2185) if _a2186 and _a2186 >= 0 then _a1603.UpgReserve = _a2186 end
end },
})
_a1763(_a2181, "구매 전 그 앞으로 이동",
function() return _a1603.UpgTp end,
function(_a2187) _a1603.UpgTp = _a2187 end)
_a1753(_a2181, {
{ label = "업그레이드 목록", col = _a1648.accent, fn = function()
local _a2188 = _a1635.mach.upgList()
local _a2189 = _a1637("Diamonds")
_a1599("")
_a1599("──── 맵 업그레이드 ────")
_a1599("보유 다이아 " .. _a1600(_a2189, 0))
if #_a2188 == 0 then
_a1599("  로드된 업그레이드 기둥이 없음 (해당 존에 가야 보입니다)")
end
local _a2190, _a2191, _a2192 = 0, 0, 0
for _a2193, _a2194 in ipairs(_a2188) do
if _a2194.bought then _a2191 += 1
elseif not _a2194.zoneOwned then _a2192 += 1
else _a2190 += 1 end
end
_a1599(("  구매가능 %d / 구매완료 %d / 존 미보유 %d"):format(_a2190, _a2191, _a2192))
_a1599("")
local _a2195 = 0
for _a2196, _a2197 in ipairs(_a2188) do
if _a2197.buyable then
_a2195 += 1
_a1599(("  %-12s T%-2d %-20s %12s %-9s %s"):format(
_a2197.id, _a2197.tier, _a2197.zone, _a2197.cost and _a1600(_a2197.cost, 0) or "?",
tostring(_a2197.cur),
(_a2197.cost and _a2197.cost <= _a1637(_a2197.cur or "Diamonds") - _a1603.UpgReserve)
and "← 지금 가능" or ""))
if _a2195 >= 25 then _a1599("  ...") break end
end
end
_a1690("log")
end },
{ label = "업글 진단", col = _a1648.warn, fn = function()
task.spawn(function()
_a1599("")
_a1599("──── 맵 업그레이드 진단 ────")
_a1599("  리모트 : " .. (_a1634.R_Upg and _a1634.R_Upg:GetFullName() or "없음"))
local _a2198 = _a1635.mach.upgList()
_a1599("  로드된 기둥 " .. #_a2198 .. "개")
local _a2199
for _a2200, _a2201 in ipairs(_a2198) do
if _a2201.buyable and _a2201.cost then _a2199 = _a2201 break end
end
if not _a2199 then
_a1599("  살 수 있는 게 없음 (전부 구매완료거나 존 미보유)")
for _a2202, _a2203 in ipairs(_a2198) do
_a1599(("   %-12s T%-2d @%-18s 구매됨=%s 존보유=%s"):format(
_a2203.id, _a2203.tier, tostring(_a2203.zone), tostring(_a2203.bought), tostring(_a2203.zoneOwned)))
if _a2202 >= 8 then _a1599("   ...") break end
end
_a1690("log") return
end
local _a2204 = _a1637(_a2199.cur or "Diamonds")
local _a2205 = _a1635.move.hrp()
local _a2206 = (_a2205 and _a2199.pos) and (_a2205.Position - _a2199.pos).Magnitude or nil
_a1599(("  대상 : %s T%d @%s"):format(_a2199.id, _a2199.tier, tostring(_a2199.zone)))
_a1599(("  가격 : %s %s / 보유 %s"):format(
_a1600(_a2199.cost, 0), tostring(_a2199.cur), _a1600(_a2204, 0)))
_a1599("  거리 : " .. (_a2206 and ("%.0f 스터드"):format(_a2206) or "좌표 없음"))
_a1599("")
_a1599("  ▶ 제자리에서 호출")
local _a2207, _a2208
local _a2209 = pcall(function() _a2207, _a2208 = _a1634.R_Upg:InvokeServer(_a2199.id, _a2199.zone) end)
_a1599("    호출성공 " .. tostring(_a2209) .. " / 반환1 " .. tostring(_a2207)
.. " / 반환2 " .. tostring(_a2208))
if not _a2207 and _a2199.pos then
_a1599("")
_a1599("  ▶ 기둥 앞으로 이동해서 재시도")
_a1635.move.glideTo(_a2199.pos)
task.wait(0.3)
local _a2210 = _a1635.move.hrp()
_a1599("    이동후 거리 " .. (_a2210 and ("%.0f"):format((_a2210.Position - _a2199.pos).Magnitude) or "?"))
local _a2211, _a2212
local _a2213 = pcall(function() _a2211, _a2212 = _a1634.R_Upg:InvokeServer(_a2199.id, _a2199.zone) end)
_a1599("    호출성공 " .. tostring(_a2213) .. " / 반환1 " .. tostring(_a2211)
.. " / 반환2 " .. tostring(_a2212))
_a1599("")
_a1599(_a2211 and "  → 거리 검사 있음. 이동해야 됩니다."
or "  → 이동해도 실패. 거리 문제가 아닙니다.")
else
_a1599("")
_a1599(_a2207 and "  → 원격으로 됩니다. 이동 불필요." or "  → 실패 (좌표 없음)")
end
_a1690("log")
end)
end },
{ label = "지금 1회", col = _a1648.cardHi, fn = function()
task.spawn(function() _a1605.mapupg = true _a1635.mach.cycleUpg() _a1605.mapupg = false _a1690("log") end)
end },
})
local _a2214, _a2215 = _a1723(_a1920, "자동 리버스", nil)
_a1733(_a2215, "mreb", function()
_a1647("mreb", function() return _a1603.MainRebirthInterval end, _a1645, "리버스")
end)
_a1744(_a2214, {
{ label = "주기", value = _a1603.MainRebirthInterval, onChange = function(_a2216)
local _a2217 = tonumber(_a2216) if _a2217 and _a2217 >= 10 then _a1603.MainRebirthInterval = _a2217 end
end },
})
_a1763(_a2214, "실패 이유 로그",
function() return _a1603.MainRebirthVerbose end,
function(_a2218) _a1603.MainRebirthVerbose = _a2218 end)
_a1753(_a2214, {
{ label = "리버스 현황 보기", col = _a1648.accent, fn = function()
local _a2219 = _a1644()
_a1599("")
if not _a2219 then _a1599("[리버스] 세이브 못 읽음")
else
_a1599("──── 메인 리버스 ────")
_a1599("  현재 " .. _a2219.current .. "회 → 다음 " .. _a2219.nextN)
if type(_a2219.def) == "table" then
for _a2220, _a2221 in pairs(_a2219.def) do
if type(_a2221) ~= "table" and type(_a2221) ~= "function" then
_a1599("    " .. tostring(_a2220) .. " = " .. tostring(_a2221))
end
end
end
end
_a1690("log")
end },
{ label = "지금 1회", col = _a1648.bad, fn = function()
task.spawn(function() _a1605.mreb = true _a1645() _a1605.mreb = false _a1690("log") end)
end },
})
local _a2222 = _a1723(_a1920, "전체 제어", nil)
_a1753(_a2222, {
{ label = "메인 전부 ON", col = _a1648.good, fn = function()
local _a2223 = {
{ "farm",   function() return _a1603.FarmInterval end,       _a1638,       "파밍" },
{ "zone",   function() return _a1603.ZoneInterval end,       _a1640,       "존" },
{ "mhatch", function() return _a1603.MainHatchInterval end,  _a1643,  "부화" },
{ "quest",  function() return _a1603.QuestInterval end,      _a1635.quest.cycle,        "퀘스트" },
{ "mapupg", function() return _a1603.UpgInterval end,        _a1635.mach.cycleUpg,     "맵업글" },
{ "items",  function() return _a1603.ItemInterval end,       _a1635.item.cycleItems,   "아이템" },
{ "slots",  function() return _a1603.SlotInterval end,       _a1635.mach.cycleSlots,   "슬롯" },
}
for _a2224, _a2225 in ipairs(_a2223) do
if not _a1605[_a2225[1]] then
_a1605[_a2225[1]] = true
_a1647(_a2225[1], _a2225[2], _a2225[3], _a2225[4])
end
end
_a1730()
_a1599("[메인] 파밍/존/부화/랭크/퀘스트/맵업글 ON  (리버스는 따로)")
end },
{ label = "메인 전부 OFF", col = _a1648.bad, fn = function()
_a1635.ctl.stopAll()
_a1730()
_a1599("[메인] 정지")
end },
})
end
_a1681.MouseButton1Click:Connect(function()
local _a2226 = table.concat(_a1598, "\n")
if #_a2226 > 900000 then _a2226 = _a2226:sub(#_a2226 - 900000) end
if type(setclipboard) == "function" then
pcall(setclipboard, _a2226)
_a1681.Text = "완료"
task.delay(1.5, function() if _a1681 then _a1681.Text = "복사" end end)
end
end)
_a1680.MouseButton1Click:Connect(function()
table.clear(_a1598)
_a1594.dirty = true
end)
local function _a2227()
_a1605.place, _a1605.merchant, _a1605.upgrade = false, false, false
_a1605.towerup, _a1605.crop, _a1605.expand, _a1605.rebirth, _a1605.hatch, _a1605.luck = false, false, false, false, false, false
_a1605.farm, _a1605.zone, _a1605.mhatch, _a1605.rank, _a1605.mreb = false, false, false, false, false
if _a1784 then _a1784:Disconnect() end
if _a1666 then _a1666:Destroy() end
_G.__PS99_GARDEN = nil
end
_a1678.MouseButton1Click:Connect(_a2227)
_G.__PS99_GARDEN = _a2227
_a1690("dash")
_a1599("PS99 자동")
if _a1594.lpWait then
_a1599(("[진단] LocalPlayer 가 늦게 잡혔습니다 — %.1f초 대기, 결과 %s")
:format(_a1594.lpWait, _a1594.lpFail and "실패 (기능 대부분 못 씀)" or "성공"))
end
if _a1594.libWait then
_a1599(("[진단] 게임 모듈(Library/Network)도 늦게 잡혔습니다 — %.1f초 대기")
:format(_a1594.libWait))
end
if _a1594.libFail then
_a1599("[진단] ★ " .. _a1594.libFail .. " 를 못 찾았습니다 — 게임 로드 후 다시 실행하세요")
end
if _a1605.auto then
if _a1635.auto.start then
_a1599("[자동] 올 자동 켜짐 — 1초 뒤 시작합니다")
task.spawn(function()
task.wait(1)
_a1635.ctl.abort = false
local _a2228, _a2229 = pcall(_a1635.auto.start)
if _a2228 then
_a1599("[자동] 시작됨")
else
_a1605.auto = false
_a1599("[자동] 시작 실패: " .. tostring(_a2229))
if _a1635.auto.refresh then pcall(_a1635.auto.refresh) end
end
end)
else
_a1605.auto = false
_a1599("[자동] QS.auto.start 가 없습니다 — 메인 게임 탭이 안 만들어짐")
end
end
pcall(function()
local _a2230, _a2231, _a2232, _a2233 = _a1608()
if _a2230 and _a2232 then
local _a2234 = _a1609(_a2232, _a2233)
_a1606.slots = #_a2234
_a1599("레인 " .. _a2233 .. " / 슬롯 " .. #_a2234)
else
_a1599("가든 이벤트 밖입니다 (이벤트 탭은 이벤트 안에서만 동작)")
end
_a1606.sun = _a1614()
_a1599("Sunflowers " .. _a1600(_a1606.sun, 0))
end)
end)(_a1)
