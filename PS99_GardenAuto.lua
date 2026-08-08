local _a1 = {}
local _a2  = game:GetService("ReplicatedStorage")
local _a3 = game:GetService("UserInputService")
local _a4 = game:GetService("RunService")
do
local _a5 = os.clock()
for _a6, _a7 in ipairs({ "Library", "Network" }) do
local _a8 = pcall(function() _a2:WaitForChild(_a7, 30) end)
if not _a8 or not _a2:FindFirstChild(_a7) then
_a1.libFail = (_a1.libFail and (_a1.libFail .. ", ") or "") .. _a7
end
end
local _a9 = os.clock() - _a5
if _a9 > 0.2 then _a1.libWait = _a9 end
end
local _a10 = game:GetService("Players")
local _a11 = _a10.LocalPlayer
if not _a11 then
local _a12 = os.clock()
repeat
task.wait(0.1)
_a11 = _a10.LocalPlayer
until _a11 or (os.clock() - _a12) > 30
_a1.lpWait = os.clock() - _a12
_a1.lpFail = (_a11 == nil)
end
if _G.__PS99_GARDEN then pcall(_G.__PS99_GARDEN) end
local _a13, _a14 = {}, 3000
local function _a15(_a16)
_a13[#_a13 + 1] = tostring(_a16)
if #_a13 > _a14 then table.remove(_a13, 1) end
_a1.dirty = true
end
local function _a17(_a18, _a19)
if type(_a18) ~= "number" then return tostring(_a18) end
if _a18 ~= _a18 then return "0" end
return string.format("%." .. (_a19 or 1) .. "f", _a18)
end
local function _a20(...)
local _a21 = _a2
for _a22, _a23 in ipairs({ ... }) do
if not _a21 then return nil end
local _a24 = _a21:FindFirstChild(_a23)
if not _a24 then
local _a25, _a26 = pcall(function() return _a21:WaitForChild(_a23, 2) end)
_a24 = _a25 and _a26 or nil
end
_a21 = _a24
end
if not _a21 then return nil end
local _a27, _a28 = pcall(require, _a21)
return _a27 and _a28 or nil
end
local _a29 = {
EntityPlacement = _a20("Library", "Client", "PvCombatCmds", "EntityPlacement"),
ClientTowerDefense = _a20("Library", "Client", "PvCombatCmds", "ClientTowerDefense"),
ClientPlot = _a20("Library", "Client", "PlotCmds", "ClientPlot"),
LaneUnlock = _a20("Library", "Client", "PvCombatCmds", "LaneUnlock"),
ClientTower = _a20("Library", "Client", "PvCombatCmds", "ClientTowerDefense", "EntityRegistry", "ClientTower"),
GardenLaneFacing = _a20("Library", "Util", "GardenLaneFacing"),
GardenDefenders = _a20("Library", "Util", "GardenDefenders"),
TowerItem = _a20("Library", "Items", "TowerItem"),
Save = _a20("Library", "Client", "Save"),
EventUpgradeCmds = _a20("Library", "Client", "EventUpgradeCmds"),
GardenPlots = _a20("Library", "Util", "GardenPlots"),
PvCropGrowth = _a20("Library", "PvCropGrowth"),
FFlagsM = _a20("Library", "Universal", "FFlags"),
}
local function _a30(_a31)
if type(_a29.FFlagsM) ~= "table" then return nil end
local _a32 = rawget(_a29.FFlagsM, "Keys")
local _a33 = _a32 and _a32[_a31]
if _a33 == nil then return nil end
local _a34, _a35 = pcall(_a29.FFlagsM.GetNumber, _a33)
return _a34 and tonumber(_a35) or nil
end
local _a36      = _a2:WaitForChild("Network")
local _a37 = {
R_ATTACH = _a36:FindFirstChild("WD_Attach"),
R_DETACH = _a36:FindFirstChild("OR_Detach"),
R_PROMO = _a36:FindFirstChild("EK_Promote"),
R_BUY = _a36:FindFirstChild("Merchant_RequestPurchase"),
R_EVUP = _a36:FindFirstChild("EventUpgrades: Purchase"),
R_WIDEN = _a36:FindFirstChild("PG_Widen"),
R_JC = _a36:FindFirstChild("JC_Manifest"),
R_WK = _a36:FindFirstChild("WK_Reclaim"),
R_EGG = _a36:FindFirstChild("Eggs_RequestPurchase"),
R_CEGG = _a36:FindFirstChild("CustomEggs_Hatch"),
R_LUCK = _a36:FindFirstChild("GardenChanceMachine_AddTime"),
}
if not (_a29.EntityPlacement and _a29.ClientTowerDefense and _a29.ClientPlot and _a29.GardenLaneFacing and _a29.TowerItem and _a37.R_ATTACH) then
warn("[PS99 Garden] 필수 모듈 로드 실패 — Garden 이벤트 안에서 실행해 주세요")
end
local _a38 = {
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
local _a39 = { Shiny = 1.5, Gold = 2, Rainbow = 4 }
local _a40 = {}
local _a41 = { place = false, merchant = false, upgrade = false, towerup = false,
crop = false, expand = false, rebirth = false, hatch = false, luck = false,
farm = false, zone = false, mhatch = false, rank = false, mreb = false,
quest = false, mapupg = false, items = false, slots = false,
auto = true, petspd = true, rewatch = true }
local _a42 = { slots = 0, filled = 0, empty = 0, placed = 0, swapped = 0, bought = 0,
upgraded = 0, sun = 0, replant = 0, hatched = 0, luck = 0,
farm = 0, zone = 0, mhatch = 0, rank = 0, mreb = 0,
quest = 0, potup = 0, potuse = 0, mapupg = 0, items = 0, mslot = 0 }
_a38.CropInterval = 20
_a38.CropMargin   = 1.5
_a38.SkipUnhatched = true
_a38.MinSunflowers  = 0
_a38.BuyUnknownCost = false
_a38.ExpandInterval  = 20
_a38.RebirthInterval = 30
_a38.HatchInterval = 5
_a38.HatchMax      = 100
_a38.HatchReserve  = 0
_a38.HatchEggNum   = 0
_a38.HatchUid      = ""
_a38.LuckInterval  = 3600
_a38.LuckReserve   = 0
_a38.LuckMinTopUp  = 600
_a38.LuckBoosts    = { Huge = true, Titanic = true, Gargantuan = true }
_a38.FarmInterval        = 10
_a38.ZoneInterval        = 10
_a38.MainHatchInterval   = 1
_a38.MainHatchMax        = 100
_a38.MainHatchReserve    = 0
_a38.MainEggId           = ""
_a38.RankInterval        = 30
_a38.MainRebirthInterval = 60
_a38.MainRebirthVerbose  = false
_a38.MaxBedScan     = 80
_a38.QuestInterval  = 10
_a38.QuestUpgrade   = true
_a38.QuestUsePotion = true
_a38.QuestDrive     = true
_a38.QuestUseMax    = 20
_a38.EggRange       = 40
_a38.QuestTp        = true
_a38.TpMode     = "instant"
_a38.TpSpeed    = 160
_a38.TpHeight   = 0
_a38.ArriveDist = 12
_a38.ZoneArriveDist = 90
_a38.QuestLock  = true
_a38.SpawnPerCycle = 1
_a38.EventStayDist = 45
_a38.AutoInterval = 5
_a38.HoldZoneForQuest = true
_a38.HatchBudget  = 25
_a38.ScreenTryMax   = 8
_a38.ScreenRealClick = true
_a38.PursueStallSec = 60
_a38.HatchMinAfford = 10
_a38.MoneyDwell     = 60
_a38.IdleHatch      = false
_a38.PetSpeedMult = 50
_a38.PetSpeedBase = 4
_a38.TpGameFallback = false
_a38.TpCooldown = 2.5
_a38.HatchAutoTp = true
_a38.AutoUnlockEgg = true
_a38.UseAutoHatch  = true
_a38.HatchClick    = true
_a38.HatchClickAfter = 0.6
_a38.TpToBreakables = true
_a38.UpgInterval  = 30
_a38.UpgReserve   = 0
_a38.UpgTp        = true
_a38.SlotInterval = 30
_a38.SlotReserve  = 0
_a38.SlotPet      = true
_a38.SlotEgg      = true
_a38.ItemInterval  = 20
_a38.BuffPotion    = true
_a38.BuffFruit     = true
_a38.BuffUltimate  = true
_a38.BuffConsumable = false
_a38.BuffHighTier  = true
_a38.ItemKeep      = 0
_a38.ItemAllow     = ""
_a38.ItemBlock     = "Rain, Sunlight"
_a38.ItemBestZone  = true
_a38.ItemTp        = false
_a38.BuffMaxPotion = 5
_a38.BuffMaxOther  = 2
_a1.RS, _a1.UIS, _a1.RunService, _a1.LP, _a1.LOG, _a1.log = _a2, _a3, _a4, _a11, _a13, _a15
_a1.num, _a1.req, _a1.LB, _a1.ff, _a1.NET, _a1.RM = _a17, _a20, _a29, _a30, _a36, _a37
_a1.CFG, _a1.VARIANT, _a1.EGG_COST_CACHE, _a1.RUN, _a1.STAT = _a38, _a39, _a40, _a41, _a42
;(function(_a43)
local _a44, _a45, _a46, _a47, _a48, _a49 = _a43.RS, _a43.LP, _a43.log, _a43.num, _a43.req, _a43.LB
local _a50, _a51, _a52, _a53, _a54, _a55 = _a43.ff, _a43.RM, _a43.CFG, _a43.VARIANT, _a43.EGG_COST_CACHE, _a43.RUN
local _a56 = _a43.STAT
local _a57
local _a58 = {
"GardenMoreDamage", "GardenFasterAttacks", "GardenMoreCoins",
"GardenBetterEggs", "GardenBetterLuck", "GardenBiggerHarvest",
"GardenFasterCrops", "GardenMoreSeeds",
}
local _a59
local function _a60()
if _a59 then return _a59 end
_a59 = {}
local _a61 = _a44:FindFirstChild("__DIRECTORY")
_a61 = _a61 and _a61:FindFirstChild("TowerDefenseTowers")
if _a61 then
for _a62, _a63 in ipairs(_a61:GetDescendants()) do
if _a63:IsA("ModuleScript") then
local _a64, _a65 = pcall(require, _a63)
if _a64 and type(_a65) == "table" then _a59[rawget(_a65, "_id") or _a63.Name] = _a65 end
end
end
end
return _a59
end
local function _a66(_a67, _a68, _a69)
local _a70 = _a60()[_a67]
if type(_a70) ~= "table" then return 0 end
local _a71 = tonumber(rawget(_a70, "AttackDamage")) or 0
local _a72 = tonumber(rawget(_a70, "AttackSpeed")) or 0
local _a73, _a74 = _a71 * _a72, 0
local _a75 = rawget(_a70, "Projectile")
if type(_a75) == "table" then
local _a76 = rawget(_a75, "ApplyDots")
if type(_a76) == "table" then
for _a77, _a78 in pairs(_a76) do
if type(_a78) == "table" then
local _a79  = tonumber(rawget(_a78, "Duration")) or 0
local _a80 = tonumber(rawget(_a78, "TickDelta")) or 0
local _a81  = tonumber(rawget(_a78, "DamageMult")) or 1
local _a82   = tonumber(rawget(_a78, "Probability")) or 1
if _a80 > 0 and _a79 > 0 and _a72 > 0 then
_a74 += (_a71 * _a81 * _a82 / _a80) * math.min(1, _a79 * _a72) * _a52.DotFactor
end
end
end
end
local _a83 = tonumber(rawget(_a75, "LingerDuration")) or 0
if _a83 > 0 and _a72 > 0 then _a74 += _a73 * math.min(1, _a83 * _a72) * 0.5 * _a52.DotFactor end
end
local _a84 = (_a73 + _a74) * (_a53[_a68 or ""] or 1)
return (_a84 ~= _a84) and 0 or _a84
end
local function _a85(_a86, _a87)
if type(_a86) ~= "string" then return nil end
return string.match(_a86, '"' .. _a87 .. '"%s*:%s*"([^"]*)"')
end
local function _a88(_a89)
if type(_a89) ~= "table" and typeof(_a89) ~= "userdata" then return nil, nil end
local _a90, _a91
pcall(function() _a90 = rawget(_a89, "_stackKey") end)
pcall(function() _a91 = rawget(_a89, "_exactStackKey") end)
if not _a90 then pcall(function() _a90 = _a89._stackKey end) end
if not _a91 then pcall(function() _a91 = _a89._exactStackKey end) end
local _a92 = _a85(_a90, "id") or _a85(_a91, "id")
local _a93 = _a85(_a90, "vr") or _a85(_a91, "vr")
return _a92, _a93
end
local function _a94(_a95)
local _a96
if _a49.GardenDefenders and _a49.GardenDefenders.UnitKey then
pcall(function() _a96 = _a49.GardenDefenders.UnitKey(_a95) end)
end
if _a96 ~= nil then return tostring(_a96) end
local _a97, _a98 = _a88(_a95)
return tostring(_a97) .. "|" .. tostring(_a98 or "")
end
local function _a99()
local _a100 = {}
if not _a49.Save then return _a100 end
local _a101, _a102 = pcall(_a49.Save.Get)
if not _a101 or type(_a102) ~= "table" then return _a100 end
local _a103 = _a102.Inventory and _a102.Inventory.Tower
if type(_a103) ~= "table" then return _a100 end
for _a104, _a105 in pairs(_a103) do
if type(_a105) == "table" then _a100[_a104] = { id = _a105.id, vr = _a105.vr } end
end
return _a100
end
local function _a106()
local _a107, _a108
pcall(function()
_a107 = _a49.ClientTowerDefense and _a49.ClientTowerDefense.GetLocal and _a49.ClientTowerDefense.GetLocal()
end)
pcall(function()
_a108 = _a49.ClientPlot and _a49.ClientPlot.GetLocal and _a49.ClientPlot.GetLocal()
end)
local _a109
if _a108 then pcall(function() _a109 = _a108:GetModel() end) end
local _a110 = 0
if _a49.LaneUnlock and _a108 then
local _a111, _a112 = pcall(_a49.LaneUnlock.UnlockedFor, _a108)
if _a111 then _a110 = tonumber(_a112) or 0 end
end
return _a107, _a108, _a109, _a110
end
local function _a113(_a114, _a115)
local _a116 = {}
local _a117 = _a114 and _a114:FindFirstChild("Lanes")
if not _a117 then return _a116 end
for _a118, _a119 in ipairs(_a117:GetChildren()) do
local _a120 = tonumber(_a119.Name)
if _a120 and _a120 <= _a115 then
local _a121 = _a119:FindFirstChild("Slots")
if _a121 then
for _a122, _a123 in ipairs(_a121:GetChildren()) do
if _a123:IsA("BasePart") then
_a116[#_a116 + 1] = {
part = _a123, lane = _a120,
pos = _a123.Position + Vector3.new(0, _a123.Size.Y / 2, 0),
}
end
end
end
end
end
return _a116
end
local function _a124(_a125)
local _a126
pcall(function() _a126 = _a125:GetUpgrade() end)
if type(_a126) == "number" then return _a126 end
pcall(function()
local _a127 = rawget(_a125, "State")
local _a128 = _a127 and rawget(_a127, "Upgrade")
_a126 = _a128 and rawget(_a128, "Value")
end)
return tonumber(_a126) or 0
end
local function _a129(_a130)
local _a131
pcall(function() _a131 = _a130:GetId() end)
if type(_a131) == "number" then return _a131 end
pcall(function() _a131 = rawget(_a130, "Id") end)
return tonumber(_a131)
end
local function _a132(_a133)
local _a134 = {}
if not (_a133 and _a49.ClientTower) then return _a134 end
local _a135
pcall(function() _a135 = _a49.ClientTower.All(_a133) end)
if type(_a135) ~= "table" then return _a134 end
local _a136 = _a99()
for _a137, _a138 in ipairs(_a135) do
local _a139, _a140, _a141
pcall(function() _a139 = _a138:GetItem() end)
pcall(function() _a140 = _a138:GetCFrame() end)
if _a139 then pcall(function() _a141 = _a139:GetOptionalUID() end) end
local _a142, _a143 = _a88(_a139)
if not _a142 then
local _a144 = _a136[_a141 or ""] or {}
_a142, _a143 = _a144.id, _a144.vr
end
local _a145 = _a124(_a138)
_a134[#_a134 + 1] = {
tower = _a138, item = _a139, uid = _a141, cf = _a140,
id = _a129(_a138), kind = _a142, vr = _a143, up = _a145,
dps = _a66(_a142, _a143, _a145),
}
end
return _a134
end
local function _a146()
local _a147 = {}
if not (_a49.TowerItem and _a49.EntityPlacement) then return _a147 end
local _a148
if not pcall(function() _a148 = _a49.TowerItem:All() end) or type(_a148) ~= "table" then return _a147 end
local _a149 = _a99()
local _a150 = {}
for _a151, _a152 in pairs(_a148) do
local _a153
pcall(function() _a153 = _a152:GetOptionalUID() end)
if _a153 then
local _a154 = _a94(_a152)
if not _a150[_a154] then
local _a155 = 0
pcall(function() _a155 = _a49.EntityPlacement.AvailableCopies(_a152) or 0 end)
if _a155 > 0 then
local _a156, _a157 = _a88(_a152)
if not _a156 then
local _a158 = _a149[_a153] or {}
_a156, _a157 = _a158.id, _a158.vr
end
_a150[_a154] = {
item = _a152, uid = _a153, key = _a154, id = _a156, vr = _a157,
copies = _a155, dps = _a66(_a156, _a157, 0),
}
else
_a150[_a154] = false
end
end
end
end
for _a159, _a160 in pairs(_a150) do
if _a160 then _a147[#_a147 + 1] = _a160 end
end
table.sort(_a147, function(_a161, _a162)
if (_a161.dps or 0) == (_a162.dps or 0) then return tostring(_a161.key) < tostring(_a162.key) end
return (_a161.dps or 0) > (_a162.dps or 0)
end)
return _a147
end
local function _a163(_a164)
local _a165
pcall(function() _a165 = _a49.GardenLaneFacing.ForSlot(_a164.pos, _a164.part) end)
return _a165
end
local function _a166(_a167, _a168)
local _a169 = _a163(_a167)
if not _a169 then return false end
local _a170 = false
pcall(function() _a170 = _a49.EntityPlacement.Validate(_a168, _a169) end)
return _a170 and true or false, _a169
end
local function _a171(_a172, _a173, _a174)
local _a175 = _a163(_a173)
if not _a175 then return false, "facing 실패" end
local _a176, _a177 = _a172.item, _a172.uid
if _a49.EntityPlacement and type(rawget(_a49.EntityPlacement, "FirstFreeCopy")) == "function" then
local _a178, _a179 = pcall(_a49.EntityPlacement.FirstFreeCopy, _a172.item)
if _a178 and _a179 then
_a176 = _a179
pcall(function() _a177 = _a179:GetUID() end)
end
end
if not _a177 then return false, "쓸 수 있는 스택 없음" end
local _a180 = _a174.CFrame:ToObjectSpace(_a175)
local _a181, _a182, _a183
if not pcall(function() _a181, _a182, _a183 = _a51.R_ATTACH:InvokeServer(_a177, _a180) end) then
return false, "호출 실패"
end
return _a181 and true or false, _a182, _a183
end
local function _a184(_a185)
if not (_a51.R_DETACH and _a185) then return false end
local _a186
pcall(function() _a186 = _a51.R_DETACH:InvokeServer(_a185) end)
return _a186 and true or false
end
local function _a187()
local _a188, _a189, _a190, _a191 = _a106()
if not (_a188 and _a190) then
_a46("[배치] 밭/월드 준비 안 됨 — Garden 안에 있는지 확인")
return
end
local _a192 = _a113(_a190, _a191)
_a56.slots = #_a192
if #_a192 == 0 then _a46("[배치] 슬롯 없음 (잠금해제 레인 " .. _a191 .. ")") return end
local _a193 = _a132(_a188)
local _a194 = _a146()
if #_a194 == 0 then
_a46("[배치] 배치 가능한 타워 없음 (종류별 최대치 도달)")
end
local _a195 = _a193
local _a196, _a197, _a198, _a199 = 0, 0, 0, 0
local _a200 = {}
local _a201 = {}
local function _a202(_a203)
return tostring(_a203 and _a203.key or (tostring(_a203 and _a203.id) .. "|" .. tostring(_a203 and _a203.vr or "")))
end
for _a204 = #_a194, 1, -1 do
if _a201[_a202(_a194[_a204])] then table.remove(_a194, _a204) end
end
local function _a205(_a206)
for _a207, _a208 in ipairs(_a195) do
if _a208.cf then
local _a209 = Vector2.new(_a208.cf.X - _a206.pos.X, _a208.cf.Z - _a206.pos.Z).Magnitude
if _a209 < 2 then return _a208 end
end
end
return nil
end
for _a210, _a211 in ipairs(_a192) do
if not _a55.place then break end
local _a212 = _a205(_a211)
if _a212 then _a196 += 1 else _a197 += 1 end
local _a213 = _a194[1]
if not _a213 then break end
if not _a212 then
local _a214, _a215, _a216 = _a171(_a213, _a211, _a188)
if _a214 then
_a198 += 1
_a56.placed += 1
_a46(("  ▸ 배치  레인%s  %s %s  DPS %s"):format(
_a211.lane, tostring(_a213.id), tostring(_a213.vr or "-"), _a47(_a213.dps)))
_a195 = _a132(_a188)
_a194 = _a146()
for _a217 = #_a194, 1, -1 do
if _a201[_a202(_a194[_a217])] then table.remove(_a194, _a217) end
end
else
_a200[tostring(_a215)] = (_a200[tostring(_a215)] or 0) + 1
if tostring(_a215):find("copies") then _a201[_a202(_a213)] = true end
table.remove(_a194, 1)
end
task.wait(_a52.ActionGap)
elseif (_a213.dps or 0) > (_a212.dps or 0) * _a52.SwapMargin then
if _a52.ProtectUpgraded and (_a212.up or 0) > 0 then
else
if _a184(_a212.id) then
task.wait(0.5)
local _a218 = _a146()
local _a219, _a220 = false, nil
for _a221 = 1, math.min(10, #_a218) do
local _a222 = _a218[_a221]
if not _a201[_a202(_a222)] then
local _a223, _a224 = _a171(_a222, _a211, _a188)
if _a223 then
_a219, _a220 = true, _a222
break
end
_a200[tostring(_a224)] = (_a200[tostring(_a224)] or 0) + 1
if tostring(_a224):find("copies") then _a201[_a202(_a222)] = true end
task.wait(0.15)
end
end
if _a219 and _a220 then
if _a220.id == _a212.kind and (_a220.vr or "") == (_a212.vr or "") then
_a46("  · 레인" .. _a211.lane .. " 같은 종류로 되돌림 (더 나은 게 없음)")
else
_a199 += 1
_a56.swapped += 1
_a46(("  ⇄ 교체  레인%s   %s%s(Lv%s) DPS %s  →  %s %s DPS %s"):format(
_a211.lane,
tostring(_a212.kind), _a212.vr and (" " .. _a212.vr) or "",
tostring(_a212.up), _a47(_a212.dps),
tostring(_a220.id), tostring(_a220.vr or "-"), _a47(_a220.dps)))
end
else
_a46("  ! 레인" .. _a211.lane .. " 아무것도 못 놓음 — 칸이 비었습니다")
end
_a195 = _a132(_a188)
_a194 = _a146()
for _a225 = #_a194, 1, -1 do
if _a201[_a202(_a194[_a225])] then table.remove(_a194, _a225) end
end
task.wait(_a52.ActionGap)
end
end
end
end
_a56.filled, _a56.empty = _a196, _a197
local _a226 = ("[배치] 슬롯 %d (찬칸 %d / 빈칸 %d)  이번에 배치 %d, 교체 %d")
:format(#_a192, _a196, _a197, _a198, _a199)
_a46(_a226)
if next(_a200) then
for _a227, _a228 in pairs(_a200) do _a46("    실패 " .. _a228 .. "회: " .. _a227) end
end
end
local function _a229()
if not _a51.R_BUY then _a46("[구매] 리모트 없음") return end
local _a230, _a231 = 0, 0
for _a232 = 1, _a52.MerchantSlots do
if not _a55.merchant then break end
local _a233
pcall(function() _a233 = _a51.R_BUY:InvokeServer(_a52.MerchantId, _a232) end)
if _a233 ~= nil and _a233 ~= false then _a230 += 1 else _a231 += 1 end
task.wait(0.3)
end
_a56.bought += _a230
_a46(("[구매] %s  성공 %d / 실패 %d"):format(_a52.MerchantId, _a230, _a231))
end
local function _a234()
if not _a49.Save then return 0 end
local _a235, _a236 = pcall(_a49.Save.Get)
if not _a235 or type(_a236) ~= "table" then return 0 end
local _a237 = _a236.Inventory and _a236.Inventory.Currency
if type(_a237) ~= "table" then return 0 end
for _a238, _a239 in pairs(_a237) do
if type(_a239) == "table" and rawget(_a239, "id") == "Sunflowers" then
return tonumber(rawget(_a239, "_am")) or 0
end
end
return 0
end
local function _a240()
local _a241 = {}
if not _a49.Save then return _a241 end
local _a242, _a243 = pcall(_a49.Save.Get)
if not _a242 or type(_a243) ~= "table" then return _a241 end
local _a244 = rawget(_a243, "EventUpgrades")
if type(_a244) == "table" then
for _a245, _a246 in pairs(_a244) do _a241[_a245] = tonumber(_a246) or 0 end
end
return _a241
end
local _a247
local function _a248()
if _a247 then return _a247 end
_a247 = {}
local _a249 = _a44:FindFirstChild("__DIRECTORY")
_a249 = _a249 and _a249:FindFirstChild("EventUpgrades")
if _a249 then
for _a250, _a251 in ipairs(_a249:GetDescendants()) do
if _a251:IsA("ModuleScript") then
local _a252, _a253 = pcall(require, _a251)
if _a252 and type(_a253) == "table" then
_a247[rawget(_a253, "_id") or _a251.Name] = _a253
end
end
end
end
return _a247
end
local _a254, _a255
local function _a256()
if _a254 ~= nil then return _a254 end
_a254 = false
local _a257 = {
_a48("Library", "Util", "GardenUpgradeCurve"),
_a48("Library", "Util", "GardenUpgradeBoosts"),
_a49.EventUpgradeCmds,
}
for _a258, _a259 in ipairs(_a257) do
if type(_a259) == "table" then
for _a260, _a261 in pairs(_a259) do
local _a262 = tostring(_a260):lower()
if type(_a261) == "function" and (_a262:find("cost") or _a262:find("price")) then
for _a263, _a264 in ipairs({
{ "GardenMoreDamage", 1 }, { "GardenMoreDamage", 2 },
{ 1 }, { 2 }, { "GardenMoreDamage" },
}) do
local _a265, _a266 = pcall(_a261, table.unpack(_a264))
if _a265 and type(_a266) == "number" and _a266 > 0 then
_a254 = _a261
_a255 = (#_a264 == 2) and "id_tier" or
(type(_a264[1]) == "number" and "tier" or "id")
return _a254
end
end
end
end
end
end
return _a254
end
local function _a267(_a268)
if _a268 == nil then return nil end
if type(_a268) == "number" then return _a268 end
if type(_a268) == "table" then
local _a269 = rawget(_a268, "_data")
if type(_a269) == "table" then
return tonumber(rawget(_a269, "_am")) or 1
end
end
local _a270, _a271 = pcall(function() return _a268:GetAmount() end)
if _a270 and type(_a271) == "number" then return _a271 end
return nil
end
local function _a272(_a273, _a274)
local _a275 = _a248()[_a273]
if type(_a275) == "table" then
for _a276, _a277 in ipairs({ "TierCosts", "Costs", "Prices", "TierPrices" }) do
local _a278 = rawget(_a275, _a277)
if type(_a278) == "table" then
local _a279 = _a267(_a278[(tonumber(_a274) or 0) + 1])
if _a279 then return _a279 end
end
end
end
local _a280 = _a256()
if _a280 then
local _a281 = (tonumber(_a274) or 0) + 1
local _a282
if _a255 == "id_tier" then _a282 = { { _a273, _a281 }, { _a273, _a274 } }
elseif _a255 == "tier" then _a282 = { { _a281 }, { _a274 } }
else _a282 = { { _a273 } } end
for _a283, _a284 in ipairs(_a282) do
local _a285, _a286 = pcall(_a280, table.unpack(_a284))
if _a285 and type(_a286) == "number" and _a286 > 0 then return _a286 end
end
end
return nil
end
local function _a287(_a288)
if _a49.EventUpgradeCmds and type(rawget(_a49.EventUpgradeCmds, "Purchase")) == "function" then
local _a289, _a290 = pcall(_a49.EventUpgradeCmds.Purchase, _a288)
if _a289 and _a290 ~= nil and _a290 ~= false then return true, _a290 end
if _a289 then return false, _a290 end
end
if _a51.R_EVUP then
local _a291
local _a292 = pcall(function() _a291 = _a51.R_EVUP:InvokeServer(_a288) end)
if _a292 then return (_a291 ~= nil and _a291 ~= false), _a291 end
end
return false, "호출 실패"
end
local function _a293()
if not (_a51.R_EVUP or _a49.EventUpgradeCmds) then _a46("[머신업글] API 없음") return end
local _a294, _a295 = 0, 0
while _a55.upgrade and _a294 < 40 do
_a294 += 1
local _a296 = _a234()
_a56.sun = _a296
local _a297 = _a240()
local _a298 = {}
for _a299, _a300 in ipairs(_a58) do
local _a301 = _a297[_a300] or 0
local _a302 = _a272(_a300, _a301)
_a298[#_a298 + 1] = { id = _a300, tier = _a301, cost = _a302 }
end
table.sort(_a298, function(_a303, _a304)
local _a305 = _a303.cost or math.huge
local _a306 = _a304.cost or math.huge
if _a305 == _a306 then return _a303.id < _a304.id end
return _a305 < _a306
end)
local _a307 = false
for _a308, _a309 in ipairs(_a298) do
if not _a55.upgrade then break end
local _a310 = _a309.cost and (_a296 - _a309.cost >= _a52.MinSunflowers)
if _a309.cost == nil then _a310 = _a52.BuyUnknownCost end
if _a310 then
local _a311 = _a296
local _a312, _a313 = _a287(_a309.id)
if _a312 then
_a295 += 1
_a56.upgraded += 1
_a307 = true
task.wait(0.4)
local _a314 = _a234()
_a46(("  ▲ %s  Lv%s → Lv%s   비용 %s   잔액 %s"):format(
_a309.id, tostring(_a309.tier), tostring(_a309.tier + 1),
_a47(_a311 - _a314, 0), _a47(_a314, 0)))
break
end
end
end
if not _a307 then break end
end
local _a315 = _a234()
_a56.sun = _a315
local _a316 = _a240()
if _a295 > 0 then
_a46(("[머신업글] %d건 구매 / 잔액 %s"):format(_a295, _a47(_a315, 0)))
else
local _a317, _a318 = math.huge, nil
for _a319, _a320 in ipairs(_a58) do
local _a321 = _a272(_a320, _a316[_a320] or 0)
if _a321 and _a321 < _a317 then _a317, _a318 = _a321, _a320 end
end
if _a318 then
_a46(("[머신업글] 살 수 있는 게 없음 — 잔액 %s / 최저 %s (%s)")
:format(_a47(_a315, 0), _a47(_a317, 0), _a318))
else
_a46("[머신업글] 구매 실패 (비용표를 못 읽음)")
end
end
end
local _a322, _a323
local function _a324()
if _a322 then return _a322 end
_a322 = {}
local _a325 = _a44:FindFirstChild("__DIRECTORY")
_a325 = _a325 and _a325:FindFirstChild("CropSeeds")
if _a325 then
for _a326, _a327 in ipairs(_a325:GetDescendants()) do
if _a327:IsA("ModuleScript") then
local _a328, _a329 = pcall(require, _a327)
if _a328 and type(_a329) == "table" then _a322[rawget(_a329, "_id") or _a327.Name] = _a329 end
end
end
end
return _a322
end
local function _a330()
if _a323 then return _a323 end
_a323 = {}
local _a331 = _a44:FindFirstChild("__DIRECTORY")
_a331 = _a331 and _a331:FindFirstChild("GardenCrops")
if _a331 then
for _a332, _a333 in ipairs(_a331:GetDescendants()) do
if _a333:IsA("ModuleScript") then
local _a334, _a335 = pcall(require, _a333)
if _a334 and type(_a335) == "table" then _a323[rawget(_a335, "_id") or _a333.Name] = _a335 end
end
end
end
return _a323
end
local function _a336(_a337)
local _a338 = _a330()[_a337]
return _a338 and tonumber(rawget(_a338, "CoinsPerSec")) or 0
end
local _a339 = {}
local function _a340(_a341)
if _a339[_a341] then return _a339[_a341] end
local _a342 = _a324()[_a341]
local _a343 = _a342 and rawget(_a342, "SpeciesWeights")
local _a344, _a345 = 0, 0
if type(_a343) == "table" then
for _a346, _a347 in pairs(_a343) do
local _a348 = tonumber(_a347) or 0
_a344 += _a348
_a345 += _a348 * _a336(_a346)
end
end
local _a349 = (_a344 > 0) and (_a345 / _a344) or 0
_a339[_a341] = _a349
return _a349
end
local function _a350()
local _a351 = {}
if not _a49.Save then return _a351 end
local _a352, _a353 = pcall(_a49.Save.Get)
if not _a352 or type(_a353) ~= "table" then return _a351 end
local _a354 = _a353.Inventory and _a353.Inventory.CropSeed
if type(_a354) ~= "table" then return _a351 end
for _a355, _a356 in pairs(_a354) do
if type(_a356) == "table" then
local _a357 = tonumber(rawget(_a356, "_am")) or 1
if _a357 > 0 then
_a351[#_a351 + 1] = {
uid = _a355, id = rawget(_a356, "id"), vr = rawget(_a356, "vr"),
am = _a357, exp = _a340(rawget(_a356, "id")),
}
end
end
end
table.sort(_a351, function(_a358, _a359)
if (_a358.exp or 0) == (_a359.exp or 0) then return (_a358.am or 0) > (_a359.am or 0) end
return (_a358.exp or 0) > (_a359.exp or 0)
end)
return _a351
end
local function _a360(_a361)
if not _a361 then return {} end
local _a362
pcall(function() _a362 = _a361:Save("PvC_Beds") end)
return type(_a362) == "table" and _a362 or {}
end
local function _a363(_a364, _a365)
if not (_a49.GardenPlots and _a364) then return true end
local _a366, _a367 = pcall(_a49.GardenPlots.IsBedUnlocked, _a364, _a365)
if _a366 then return _a367 and true or false end
return true
end
local function _a368(_a369)
if not (_a49.PvCropGrowth and type(_a369) == "table") then return false end
local _a370, _a371 = pcall(_a49.PvCropGrowth.IsUnhatched, _a369)
return _a370 and _a371 and true or false
end
local function _a372(_a373)
if type(_a373) ~= "table" then return nil end
local _a374 = tonumber(rawget(_a373, "cps"))
if _a374 then return _a374 end
local _a375 = rawget(_a373, "sp")
if _a375 then return _a336(_a375) end
return nil
end
local function _a376()
local _a377, _a378 = _a106()
if not _a378 then _a46("[씨앗] 밭 없음") return end
local _a379 = _a360(_a378)
local _a380 = _a350()
if #_a380 == 0 then _a46("[씨앗] 인벤에 씨앗 없음") return end
local _a381, _a382 = {}, {}
for _a383 in pairs(_a379) do
if not _a382[tostring(_a383)] then _a382[tostring(_a383)] = true _a381[#_a381 + 1] = _a383 end
end
for _a384 = 1, 80 do
local _a385 = tostring(_a384)
if not _a382[_a385] and _a363(_a378, _a385) then _a382[_a385] = true _a381[#_a381 + 1] = _a385 end
end
local _a386, _a387, _a388, _a389 = 0, 0, 0, 0
local _a390 = 1
for _a391, _a392 in ipairs(_a381) do
if not _a55.crop then break end
local _a393 = _a380[_a390]
while _a393 and _a393.am <= 0 do
_a390 += 1
_a393 = _a380[_a390]
end
if not _a393 then break end
local _a394 = _a379[_a392]
local _a395 = _a372(_a394)
if _a394 == nil then
local _a396
pcall(function() _a396 = _a378:Invoke("SD_Insert", _a392, _a393.uid) end)
if _a396 ~= false then
_a387 += 1
_a56.replant += 1
_a393.am -= 1
_a46(("  ▸ 심기  칸%s  %s 씨앗 (기대 %s/s)"):format(tostring(_a392), tostring(_a393.id), _a47(_a393.exp)))
task.wait(_a52.ActionGap)
end
elseif _a52.SkipUnhatched and _a368(_a394) then
_a389 += 1
elseif _a395 and (_a393.exp or 0) > _a395 * _a52.CropMargin then
local _a397
pcall(function() _a397 = _a378:Invoke("SD_Purge", _a392) end)
if _a397 ~= false then
task.wait(0.4)
local _a398
pcall(function() _a398 = _a378:Invoke("SD_Insert", _a392, _a393.uid) end)
if _a398 ~= false then
_a386 += 1
_a56.replant += 1
_a393.am -= 1
_a46(("  ⇄ 갈아엎기  칸%s  %s(%s/s) → %s 씨앗(기대 %s/s)"):format(
tostring(_a392), tostring(rawget(_a394, "sp") or "?"), _a47(_a395),
tostring(_a393.id), _a47(_a393.exp)))
else
_a46("  ! 칸" .. tostring(_a392) .. " 파냈는데 심기 실패")
end
task.wait(_a52.ActionGap)
end
else
_a388 += 1
end
end
_a46(("[씨앗] 심기 %d / 갈아엎기 %d / 유지 %d / 성장중 %d")
:format(_a387, _a386, _a388, _a389))
end
local function _a399(_a400)
if _a57 and not _a400 then return _a57 end
if _a51.R_JC then
local _a401, _a402 = pcall(function() return _a51.R_JC:InvokeServer() end)
if _a401 and type(_a402) == "table" then _a57 = _a402 end
end
return _a57 or {}
end
local function _a403(_a404)
if not (_a49.GardenPlots and rawget(_a49.GardenPlots, "PlotCost")) then return nil end
local _a405, _a406 = pcall(_a49.GardenPlots.PlotCost, tonumber(_a404))
return (_a405 and type(_a406) == "number") and _a406 or nil
end
local function _a407(_a408)
local _a409 = {}
if not _a408 then return _a409 end
for _a410 = 1, _a52.MaxBedScan do
local _a411 = tostring(_a410)
if not _a363(_a408, _a411) then
_a409[#_a409 + 1] = { id = _a411, n = _a410, cost = _a403(_a410) }
end
end
table.sort(_a409, function(_a412, _a413)
return (_a412.cost or math.huge) < (_a413.cost or math.huge)
end)
return _a409
end
local function _a414()
local _a415, _a416, _a417, _a418 = _a106()
if not _a416 then _a46("[확장] 밭 없음") return end
local _a419, _a420 = 0, 0
local _a421 = _a234()
local _a422 = _a399(true)
local _a423 = 0
while _a55.expand and _a423 < 12 do
_a423 += 1
local _a424 = (tonumber(_a418) or 0) + 1
local _a425 = tonumber(_a422[_a424]) or tonumber(_a422[tostring(_a424)])
if _a425 and (_a421 - _a425) < _a52.MinSunflowers then
_a46(("[확장] 레인%d 비용 %s / 잔액 %s — 부족"):format(_a424, _a47(_a425, 0), _a47(_a421, 0)))
break
end
if not _a425 and not _a52.BuyUnknownCost then
_a46("[확장] 레인" .. _a424 .. " 비용을 못 읽음 — 건너뜀")
break
end
if not _a51.R_WIDEN then break end
local _a426 = _a421
local _a427, _a428, _a429
pcall(function() _a427, _a428, _a429 = _a51.R_WIDEN:InvokeServer() end)
task.wait(0.5)
_a421 = _a234()
if _a427 then
_a419 += 1
_a420 += (_a426 - _a421)
_a418 = tonumber(_a429) or (_a418 + 1)
_a46(("  ▣ 레인 오픈 → %s개   비용 %s   잔액 %s"):format(
tostring(_a418), _a47(_a426 - _a421, 0), _a47(_a421, 0)))
task.wait(_a52.ActionGap)
else
if _a428 then _a46("[확장] 레인 실패: " .. tostring(_a428)) end
break
end
end
local _a430 = _a407(_a416)
for _a431, _a432 in ipairs(_a430) do
if not _a55.expand then break end
if _a432.cost and (_a421 - _a432.cost) < _a52.MinSunflowers then break end
if not _a432.cost and not _a52.BuyUnknownCost then break end
local _a433 = _a421
local _a434
pcall(function() _a434 = _a416:Invoke("BD_Acquire", _a432.id) end)
task.wait(0.4)
_a421 = _a234()
if _a434 ~= false and _a421 < _a433 then
_a419 += 1
_a420 += (_a433 - _a421)
_a46(("  ▣ 밭칸 %s 오픈   비용 %s   잔액 %s"):format(
_a432.id, _a47(_a433 - _a421, 0), _a47(_a421, 0)))
task.wait(_a52.ActionGap)
else
break
end
end
_a56.sun = _a421
if _a419 > 0 then
_a46(("[확장] %d개 오픈 / 총 %s 소비"):format(_a419, _a47(_a420, 0)))
else
local _a435 = (tonumber(_a418) or 0) + 1
local _a436 = _a422[_a435] or _a422[tostring(_a435)]
local _a437 = _a430[1]
_a46(("[확장] 오픈할 것 없음 — 잔액 %s / 다음 레인%d %s / 다음 밭칸 %s"):format(
_a47(_a421, 0), _a435, _a436 and _a47(_a436, 0) or "?",
_a437 and (_a437.id .. " " .. (_a437.cost and _a47(_a437.cost, 0) or "?")) or "없음"))
end
end
local function _a438()
local _a439, _a440 = _a106()
if not _a440 then return nil end
local function _a441(_a442)
local _a443
pcall(function() _a443 = _a440:Save(_a442) end)
return _a443
end
local _a444 = tonumber(_a441("PvC_Regrows")) or 0
local _a445   = tonumber(_a441("PvC_UnlockedLanes")) or 1
local _a446   = tonumber(_a441("PvC_RunBossKills")) or 0
local _a447     = _a50("PvC_RegrowCap") or math.huge
local _a448    = _a50("PvC_RegrowBossBase") or 1
local _a449    = _a50("PvC_RegrowBossStep") or 1
local _a450  = math.min(_a444, _a447)
local _a451    = math.ceil(_a448 * (_a449 ^ _a450))
local _a452   = (_a447 <= _a450)
return {
regrows = _a444, lanes = _a445, kills = _a446, need = _a451,
cap = _a447, maxed = _a452,
ready = (not _a452) and _a445 >= 7 and _a446 >= _a451,
reason = _a452 and "최대 리버스 도달"
or (_a445 < 7 and ("레인 %d/7"):format(_a445))
or (_a446 < _a451 and ("코인보스 %d/%d"):format(_a446, _a451))
or nil,
}
end
local function _a453()
if not _a51.R_WK then _a46("[리버스] WK_Reclaim 리모트 없음") return end
local _a454 = _a438()
if not _a454 then _a46("[리버스] 밭 없음") return end
if not _a454.ready then
_a46(("[리버스] 대기 — %s   (리버스 %d회)"):format(tostring(_a454.reason), _a454.regrows))
return
end
_a46(("[리버스] 조건 충족 (레인 %d, 보스 %d/%d) — 실행"):format(_a454.lanes, _a454.kills, _a454.need))
local _a455, _a456, _a457
pcall(function() _a455, _a456, _a457 = _a51.R_WK:InvokeServer() end)
task.wait(1.5)
if _a455 then
_a56.sun = _a234()
_a57 = nil
_a46(("  ★ 리버스 성공 → %s회   (레인/밭칸/작물 초기화됨)"):format(tostring(_a457 or (_a454.regrows + 1))))
_a46("  자동 확장이 켜져 있으면 레인/밭칸을 다시 엽니다")
else
_a46("  ✗ 리버스 실패: " .. tostring(_a456))
end
end
local _a458 = _a48("Library", "Util", "GardenEggs")
local _a459    = _a48("Library", "Directory", "Eggs")
local _a460= _a48("Library", "Balancing", "CalcEggPricePlayer")
local _a461  = _a48("Library", "Balancing", "CalcEggPrice")
local function _a462()
if _a52.HatchEggNum and _a52.HatchEggNum >= 1 then
return math.floor(_a52.HatchEggNum)
end
local _a463, _a464 = _a106()
if _a458 and rawget(_a458, "CurrentEggNum") then
local _a465, _a466 = pcall(_a458.CurrentEggNum, _a464)
if _a465 and tonumber(_a466) then return math.floor(tonumber(_a466)) end
end
if _a49.EventUpgradeCmds and rawget(_a49.EventUpgradeCmds, "GetPower") then
local _a467, _a468 = pcall(_a49.EventUpgradeCmds.GetPower, "GardenBetterEggs")
if _a467 and tonumber(_a468) then return math.clamp(1 + math.floor(tonumber(_a468)), 1, 12) end
end
return 1
end
local function _a469(_a470)
return ("Garden Egg %d"):format(_a470 or _a462())
end
local function _a471(_a472)
if type(_a459) == "table" then
local _a473 = rawget(_a459, _a472)
if _a473 then return _a473 end
end
local _a474 = _a44:FindFirstChild("__DIRECTORY")
_a474 = _a474 and _a474:FindFirstChild("Eggs")
if _a474 then
for _a475, _a476 in ipairs(_a474:GetDescendants()) do
if _a476:IsA("ModuleScript") then
local _a477, _a478 = pcall(require, _a476)
if _a477 and type(_a478) == "table" and rawget(_a478, "_id") == _a472 then return _a478 end
end
end
end
return nil
end
table.clear(_a54)
local function _a479(_a480)
if _a54[_a480] then return _a54[_a480] end
local _a481 = _a471(_a480)
if not _a481 then return nil end
for _a482, _a483 in ipairs({ _a460, _a461 }) do
if type(_a483) == "function" then
local _a484, _a485 = pcall(_a483, _a481)
if _a484 and tonumber(_a485) and tonumber(_a485) > 0 then
_a54[_a480] = tonumber(_a485)
return _a54[_a480]
end
end
end
local _a486 = tonumber(rawget(_a481, "overrideCost"))
if _a486 then
local _a487 = _a50("PvC_EggCostMult")
if not _a487 or _a487 <= 0 then _a487 = 1 end
local _a488 = math.max(1, math.round(_a486 * _a487))
_a54[_a480] = _a488
return _a488
end
return nil
end
local _a489 = _a48("Library", "Client", "CustomEggsCmds")
local function _a490()
local _a491 = {}
local _a492 = workspace:FindFirstChild("__THINGS")
_a492 = _a492 and _a492:FindFirstChild("CustomEggs")
if not _a492 then return _a491 end
local _a493 = _a45.Character and _a45.Character:FindFirstChild("HumanoidRootPart")
for _a494, _a495 in ipairs(_a492:GetChildren()) do
local _a496
pcall(function()
if _a495:IsA("Model") then _a496 = _a495:GetPivot().Position
elseif _a495:IsA("BasePart") then _a496 = _a495.Position end
end)
_a491[#_a491 + 1] = {
uid = _a495.Name, inst = _a495,
dist = (_a496 and _a493) and (_a496 - _a493.Position).Magnitude or math.huge,
}
end
table.sort(_a491, function(_a497, _a498) return _a497.dist < _a498.dist end)
return _a491
end
local function _a499()
if _a52.HatchUid and _a52.HatchUid ~= "" then return _a52.HatchUid end
local _a500 = _a490()
return _a500[1] and _a500[1].uid or nil
end
local function _a501()
if type(_a489) == "table" then
local _a502 = rawget(_a489, "GetMaxEggCount")
if type(_a502) == "function" then
local _a503, _a504 = pcall(_a502)
if _a503 and tonumber(_a504) and tonumber(_a504) >= 1 then return math.floor(tonumber(_a504)) end
end
end
return _a52.HatchMax
end
local function _a505()
local _a506 = _a462()
local _a507 = _a469(_a506)
local _a508 = _a479(_a507)
local _a509 = _a234()
local _a510 = math.max(0, _a509 - (_a52.HatchReserve or 0))
local _a511 = _a490()
return {
num = _a506, id = _a507, cost = _a508, sun = _a509,
uid = _a499(), eggCount = #_a511, eggs = _a511,
canBuy = (_a508 and _a508 > 0) and math.floor(_a510 / _a508) or 0,
}
end
local function _a512()
if not _a51.R_CEGG then _a46("[뽑기] CustomEggs_Hatch 리모트 없음") return end
local _a513 = _a505()
_a56.sun = _a513.sun
if not _a513.uid then
_a46("[뽑기] 알을 못 찾음 — 알 근처로 가주세요 (workspace.__THINGS.CustomEggs 비어있음)")
return
end
if not _a513.cost then
_a46("[뽑기] " .. _a513.id .. " 비용을 못 읽음")
return
end
if _a513.canBuy < 1 then
return
end
local _a514 = math.min(_a52.HatchMax, _a501())
local _a515, _a516 = 0, 0
local _a517 = math.min(_a513.canBuy, _a514)
while _a55.hatch and _a517 >= 1 and _a516 < 20 do
_a516 += 1
local _a518, _a519
pcall(function() _a518, _a519 = _a51.R_CEGG:InvokeServer(_a513.uid, _a517) end)
if _a518 then
_a515 += _a517
_a56.hatched += _a517
task.wait(0.4)
local _a520 = _a234()
_a56.sun = _a520
local _a521 = math.max(0, _a520 - (_a52.HatchReserve or 0))
local _a522 = math.floor(_a521 / _a513.cost)
if _a522 < 1 then break end
_a517 = math.min(_a522, _a514)
else
local _a523 = tostring(_a519)
if _a523:find("quickly") then
task.wait(2.5)
elseif _a517 > 1 then
_a517 = math.floor(_a517 / 2)
else
if _a519 then _a46("[뽑기] 실패: " .. _a523) end
break
end
end
end
if _a515 > 0 then
_a46(("[뽑기] %s × %d   (개당 %s)   잔액 %s"):format(
_a513.id, _a515, _a47(_a513.cost, 0), _a47(_a234(), 0)))
end
end
local _a524 = _a48("Library", "Client", "GardenChanceMachineCmds")
local _a525 = _a48("Library", "Types", "GardenChanceMachine")
local _a526 = { "Huge", "Titanic", "Gargantuan" }
local function _a527()
if _a524 and rawget(_a524, "GetMaxBoostSeconds") then
local _a528, _a529 = pcall(_a524.GetMaxBoostSeconds)
if _a528 and tonumber(_a529) then return tonumber(_a529) end
end
return (_a525 and tonumber(rawget(_a525, "MaxSecondsDefault"))) or 21600
end
local function _a530(_a531)
if _a524 and rawget(_a524, "GetPerTokenSecondsForBoost") then
local _a532, _a533 = pcall(_a524.GetPerTokenSecondsForBoost, _a531)
if _a532 and tonumber(_a533) and tonumber(_a533) > 0 then return tonumber(_a533) end
end
local _a534 = (_a525 and _a525.TokensToMaxDefault
and tonumber(_a525.TokensToMaxDefault[_a531])) or 5000
return _a527() / _a534
end
local function _a535(_a536)
if _a524 and rawget(_a524, "GetBoostTime") then
local _a537, _a538 = pcall(_a524.GetBoostTime, _a536)
if _a537 and tonumber(_a538) then return tonumber(_a538) end
end
return 0
end
local function _a539()
if _a524 and rawget(_a524, "IsEnabled") then
local _a540, _a541 = pcall(_a524.IsEnabled)
if _a540 then return _a541 and true or false end
end
return true
end
local function _a542()
local _a543 = _a527()
local _a544 = {}
for _a545, _a546 in ipairs(_a526) do
local _a547 = _a535(_a546)
local _a548 = _a530(_a546)
local _a549 = math.max(0, _a543 - _a547)
_a544[#_a544 + 1] = {
rarity = _a546, left = _a547, per = _a548, deficit = _a549,
need = (_a548 > 0) and math.ceil(_a549 / _a548) or 0,
on = _a52.LuckBoosts[_a546] and true or false,
}
end
return { maxSec = _a543, rows = _a544, enabled = _a539(), sun = _a234() }
end
local function _a550(_a551)
_a551 = math.max(0, math.floor(tonumber(_a551) or 0))
local _a552 = math.floor(_a551 / 3600)
local _a553 = math.floor((_a551 % 3600) / 60)
return ("%d시간 %d분"):format(_a552, _a553)
end
local function _a554()
if not _a51.R_LUCK then _a46("[럭] GardenChanceMachine_AddTime 리모트 없음") return end
if not _a539() then _a46("[럭] 이 서버에서 비활성") return end
local _a555 = _a542()
_a56.sun = _a555.sun
local _a556 = _a555.sun
local _a557 = 0
for _a558, _a559 in ipairs(_a555.rows) do
if not _a55.luck then break end
if _a559.on and _a559.deficit >= _a52.LuckMinTopUp and _a559.need >= 1 then
local _a560 = math.max(0, _a556 - _a52.LuckReserve)
local _a561 = math.min(_a559.need, math.floor(_a560))
if _a561 >= 1 then
local _a562 = _a556
local _a563, _a564
pcall(function()
_a563, _a564 = _a51.R_LUCK:InvokeServer(_a559.rarity, "Slot1", _a561)
end)
task.wait(0.4)
_a556 = _a234()
_a56.sun = _a556
if _a563 then
_a557 += 1
_a56.luck += 1
_a46(("  ✦ 럭 %s  +%s  (%s → %s)  비용 %s"):format(
_a559.rarity, _a550(_a561 * _a559.per),
_a550(_a559.left), _a550(math.min(_a555.maxSec, _a559.left + _a561 * _a559.per)),
_a47(_a562 - _a556, 0)))
else
_a46(("  ✗ 럭 %s 실패: %s"):format(_a559.rarity, tostring(_a564)))
end
task.wait(_a52.ActionGap)
end
end
end
if _a557 == 0 then
local _a565 = {}
for _a566, _a567 in ipairs(_a555.rows) do
if _a567.on then
_a565[#_a565 + 1] = ("%s %s"):format(_a567.rarity, _a550(_a567.left))
end
end
if #_a565 > 0 then
_a46("[럭] 유지 중 — " .. table.concat(_a565, " / "))
end
end
end
_a43.EVENT_UPGRADES, _a43.ctx, _a43.collectSlots, _a43.placedTowers, _a43.availableItems, _a43.cyclePlace = _a58, _a106, _a113, _a132, _a146, _a187
_a43.cycleMerchant, _a43.sunflowers, _a43.eventTiers, _a43.nextCost, _a43.cycleUpgrade, _a43.seedInv = _a229, _a234, _a240, _a272, _a293, _a350
_a43.bedsOf, _a43.isUnhatched, _a43.bedCps, _a43.cycleCrop, _a43.laneCosts, _a43.lockedBeds = _a360, _a368, _a372, _a376, _a399, _a407
_a43.cycleExpand, _a43.rebirthStatus, _a43.cycleRebirth, _a43.hatchStatus, _a43.cycleHatch = _a414, _a438, _a453, _a505, _a512
_a43.LUCK_ORDER, _a43.luckStatus, _a43.fmtDur, _a43.cycleLuck = _a526, _a542, _a550, _a554
end)(_a1)
;(function(_a568)
local _a569, _a570, _a571, _a572, _a573, _a574 = _a568.UIS, _a568.RunService, _a568.LP, _a568.log, _a568.num, _a568.req
local _a575, _a576, _a577, _a578, _a579, _a580 = _a568.LB, _a568.NET, _a568.RM, _a568.CFG, _a568.RUN, _a568.STAT
local _a581, _a582 = _a568.ctx, _a568.placedTowers
local _a583 = {
AutoFarm = _a574("Library", "Client", "AutoFarmCmds"),
Zone     = _a574("Library", "Client", "ZoneCmds"),
Currency = _a574("Library", "Client", "CurrencyCmds"),
Bal      = _a574("Library", "Balancing"),
Egg      = _a574("Library", "Client", "EggCmds"),
Rebirth  = _a574("Library", "Client", "RebirthCmds"),
RanksU   = _a574("Library", "Util", "RanksUtil"),
DirRanks = _a574("Library", "Directory", "Ranks"),
DirEggs  = _a574("Library", "Directory", "Eggs"),
CalcEgg  = _a574("Library", "Balancing", "CalcEggPricePlayer"),
R_Farm   = _a576:FindFirstChild("AutoFarm_Enable"),
R_FarmOff = _a576:FindFirstChild("AutoFarm_Disable"),
R_Zone   = _a576:FindFirstChild("Zones_RequestPurchase"),
R_Reb    = _a576:FindFirstChild("Rebirth_Request"),
R_Rank   = _a576:FindFirstChild("Ranks_ClaimReward"),
Quest    = _a574("Library", "Client", "QuestCmds"),
EggsU    = _a574("Library", "Util", "EggsUtil"),
Map      = _a574("Library", "Client", "MapCmds"),
Inst     = _a574("Library", "Client", "InstancingCmds"),
DirZones = _a574("Library", "Directory", "Zones"),
ZonesU   = _a574("Library", "Util", "ZonesUtil"),
Upg      = _a574("Library", "Client", "UpgradeCmds"),
DirUpg   = _a574("Library", "Directory", "Upgrades"),
R_Upg    = _a576:FindFirstChild("Upgrades_Purchase"),
R_EggUn  = _a576:FindFirstChild("Eggs_RequestUnlock"),
Rand     = _a574("Library", "Client", "RandomEventCmds"),
R_Events = _a576:FindFirstChild("RandomEvents_Get"),
Ult      = _a574("Library", "Client", "UltimateCmds"),
R_Fruit  = _a576:FindFirstChild("Fruits: Consume"),
R_Cons   = _a576:FindFirstChild("Consumables_Consume"),
R_Ult    = _a576:FindFirstChild("Ultimates: Activate"),
R_Gold   = _a576:FindFirstChild("GoldMachine_Activate"),
R_Rain   = _a576:FindFirstChild("RainbowMachine_Activate"),
R_Flag   = _a576:FindFirstChild("FlexibleFlags_Consume"),
DirPets  = _a574("Library", "Directory", "Pets"),
CalcEggB = _a574("Library", "Balancing", "CalcEggPrice"),
PlayerPet = _a574("Library", "Client", "PlayerPet"),
Machine  = _a574("Library", "Client", "MachineCmds"),
Vars     = _a574("Library", "Variables"),
Hatch    = _a574("Library", "Client", "HatchingCmds"),
R_AHTog  = _a576:FindFirstChild("AutoHatch_Toggle"),
R_AHOn   = _a576:FindFirstChild("AutoHatch_Enable"),
R_AHOff  = _a576:FindFirstChild("AutoHatch_Disable"),
RankC    = _a574("Library", "Client", "RankCmds"),
CalcPetS = _a574("Library", "Balancing", "CalcPetSlotPrice"),
CalcEggS = _a574("Library", "Balancing", "CalcEggSlotPrice"),
R_PetSlot = _a576:FindFirstChild("EquipSlotsMachine_RequestPurchase"),
R_EggSlot = _a576:FindFirstChild("EggHatchSlotsMachine_RequestPurchase"),
R_Tp     = _a576:FindFirstChild("Teleports_RequestTeleport"),
R_TpI    = _a576:FindFirstChild("Teleports_RequestInstanceTeleport"),
R_PotUp  = _a576:FindFirstChild("UpgradePotionsMachine_ActivateBulk"),
R_EncUp  = _a576:FindFirstChild("UpgradeEnchantsMachine_ActivateBulk"),
R_PotUse = _a576:FindFirstChild("Potions: Consume"),
}
local _a584 = {
[1]="farm", [9]="farm", [21]="farm", [7]="farm", [99]="farm", [8]="farm",
[30]="farm", [31]="farm", [32]="farm", [37]="farm", [38]="farm", [39]="farm",
[43]="farm", [44]="farm", [66]="farm", [67]="farm", [75]="farm", [76]="farm",
[14]="farm", [15]="farm", [64]="farm", [65]="farm", [63]="farm",
[2]="hatch", [3]="hatch", [20]="hatch", [42]="hatch", [47]="hatch",
[6]="zone", [81]="zone",
[34]="potuse",
[35]="fruituse", [33]="flaguse",
}
local _a585 = {}
_a585.ctl, _a585.move, _a585.egg = {}, {}, {}
_a585.screen, _a585.quest, _a585.ev = {}, {}, {}
_a585.item, _a585.mach, _a585.auto = {}, {}, {}
_a585.quest.IGNORE = {
[4]  = "골드 펫 만들기 (합성 필요)",
[5]  = "레인보우 펫 만들기 (합성 필요)",
[40] = "best egg 골드 펫 (뽑기+합성 필요)",
[41] = "best egg 레인보우 펫 (뽑기+2단 합성 필요)",
[12] = "포션 업글 (업글 머신으로 이동 필요)",
[13] = "인챈트 업글 (업글 머신으로 이동 필요)",
}
_a585.ctl.abort = false
function _a585.ctl.stopped() return _a585.ctl.abort == true end
function _a585.ctl.stopAll()
_a585.ctl.abort = true
for _a586 in pairs(_a579) do
if _a586 ~= "petspd" and _a586 ~= "rewatch" then _a579[_a586] = false end
end
_a585.ctl.lockGoal = nil
_a585.ctl.moving = nil
_a585.ctl.now.step = "정지"
_a585.ctl.setAct("정지됨")
end
_a585.ctl.now = { step = "-", act = "-", detail = "", goal = "-", prog = "" }
function _a585.ctl.setAct(_a587, _a588)
_a585.ctl.now.act = _a587 or "-"
_a585.ctl.now.detail = _a588 and tostring(_a588) or ""
_a585.ctl.now.at = os.clock()
end
function _a585.ctl.setGoal(_a589, _a590)
_a585.ctl.now.goal = _a589 and tostring(_a589) or "-"
_a585.ctl.now.prog = _a590 and tostring(_a590) or ""
end
function _a585.egg.eggStands()
local _a591 = os.clock()
if _a585.egg._standsAt and (_a591 - _a585.egg._standsAt) < 2 and _a585.egg._stands then
local _a592 = _a571 and _a571.Character
local _a593 = _a592 and _a592:FindFirstChild("HumanoidRootPart")
if _a593 then
for _a594, _a595 in ipairs(_a585.egg._stands) do
_a595.dist = (_a595.pos - _a593.Position).Magnitude
end
table.sort(_a585.egg._stands, function(_a596, _a597) return _a596.dist < _a597.dist end)
end
return _a585.egg._stands
end
local _a598 = {}
local _a599 = workspace:FindFirstChild("__THINGS")
local _a600 = _a599 and _a599:FindFirstChild("Eggs")
if not _a600 then return _a598 end
local _a601 = _a571 and _a571.Character
local _a602 = _a601 and _a601:FindFirstChild("HumanoidRootPart")
for _a603, _a604 in ipairs(_a600:GetDescendants()) do
if _a604:IsA("Model") and _a604.PrimaryPart then
local _a605 = tonumber(tostring(_a604.Name):match("%d+"))
if _a605 then
local _a606
if _a583.EggsU and rawget(_a583.EggsU, "GetByNumber") then
local _a607, _a608 = pcall(_a583.EggsU.GetByNumber, _a605)
if _a607 then _a606 = _a608 end
end
local _a609 = _a606 and (rawget(_a606, "_id") or rawget(_a606, "name"))
if _a609 then
_a598[#_a598 + 1] = {
id = _a609, def = _a606, num = _a605,
pos = _a604.PrimaryPart.Position,
dist = _a602 and (_a604.PrimaryPart.Position - _a602.Position).Magnitude or 9e9,
unlocked = _a604:GetAttribute("Unlocked") and true or false,
}
end
end
end
end
table.sort(_a598, function(_a610, _a611) return _a610.dist < _a611.dist end)
_a585.egg._stands, _a585.egg._standsAt = _a598, os.clock()
return _a598
end
local function _a612()
local _a613 = _a575.Save
if not _a613 then return nil end
local _a614, _a615 = pcall(_a613.Get)
if _a614 and type(_a615) == "table" then return _a615 end
if _a571 then
_a614, _a615 = pcall(_a613.Get, _a571)
if _a614 and type(_a615) == "table" then return _a615 end
end
if rawget(_a613, "GetSaves") then
local _a616, _a617 = pcall(_a613.GetSaves)
if _a616 and type(_a617) == "table" then
local _a618, _a619 = nil, 0
for _a620, _a621 in pairs(_a617) do _a619 += 1 _a618 = _a621 end
if _a619 == 1 and type(_a618) == "table" then
if not _a585.ctl.saveAlt then
_a585.ctl.saveAlt = true
_a572("[세이브] LocalPlayer 키가 안 맞아 유일한 항목으로 대체했습니다")
end
return _a618
end
end
end
return nil
end
local function _a622(_a623, _a624)
if _a583.Currency and rawget(_a583.Currency, "CanAfford") then
local _a625, _a626 = pcall(_a583.Currency.CanAfford, _a623, _a624)
if _a625 then return _a626 and true or false end
end
return false
end
local function _a627(_a628)
if _a583.Currency and rawget(_a583.Currency, "Get") then
local _a629, _a630 = pcall(_a583.Currency.Get, _a628)
if _a629 and tonumber(_a630) then return tonumber(_a630) end
end
return 0
end
local function _a631()
if _a583.AutoFarm and rawget(_a583.AutoFarm, "IsEnabled") then
local _a632, _a633 = pcall(_a583.AutoFarm.IsEnabled)
if _a632 then return _a633 and true or false end
end
return false
end
local function _a634()
if _a583.AutoFarm and rawget(_a583.AutoFarm, "GetTargetParentId") then
local _a635, _a636 = pcall(_a583.AutoFarm.GetTargetParentId)
if _a635 then return _a636 end
end
return nil
end
local function _a637()
if not _a583.R_Farm then _a572("[파밍] AutoFarm_Enable 리모트 없음") return end
local _a638 = _a631()
_a585.auto.farmZone, _a585.auto.hereZone = _a634(), _a585.move.curZone()
if _a638 then
local _a639, _a640 = _a634(), _a585.move.curZone()
if _a639 and _a640 and _a639 ~= _a640 then
_a572(("[파밍] 대상이 %s 인데 지금은 %s — 다시 켬"):format(
tostring(_a639), tostring(_a640)))
if _a583.R_FarmOff then pcall(function() _a583.R_FarmOff:InvokeServer() end) end
if _a583.AutoFarm and rawget(_a583.AutoFarm, "ForceDisable") then
pcall(_a583.AutoFarm.ForceDisable)
end
task.wait(0.3)
_a638 = false
end
end
if _a638 then return end
local _a641, _a642
pcall(function() _a641, _a642 = _a583.R_Farm:InvokeServer() end)
if _a641 then
_a580.farm += 1
_a585.auto.farmSaid = nil
_a572("[파밍] 자동 파밍 ON  (대상 " .. tostring(_a634() or _a585.move.curZone()) .. ")")
elseif _a642 and _a585.auto.farmSaid ~= tostring(_a642) then
_a585.auto.farmSaid = tostring(_a642)
_a572("[파밍] 실패: " .. tostring(_a642))
end
end
local function _a643()
if not (_a583.Zone and rawget(_a583.Zone, "GetNextZone")) then return nil end
local _a644, _a645, _a646 = pcall(_a583.Zone.GetNextZone)
if not _a644 then return nil end
return _a646 or _a645
end
local function _a647(_a648)
if not (_a583.Bal and rawget(_a583.Bal, "CalcGatePrice")) then return nil end
local _a649, _a650 = pcall(_a583.Bal.CalcGatePrice, _a648)
return (_a649 and tonumber(_a650)) or nil
end
local function _a651()
local _a652 = _a643()
if not _a652 then return nil end
local _a653 = _a647(_a652)
local _a654 = rawget(_a652, "Currency")
return {
zone = _a652, id = rawget(_a652, "_id"), price = _a653, currency = _a654,
have = _a654 and _a627(_a654) or 0,
ok = (_a653 and _a654) and _a622(_a654, _a653) or false,
}
end
local function _a655()
if not _a583.R_Zone then _a572("[존] Zones_RequestPurchase 리모트 없음") return end
local _a656 = 0
while _a579.zone and not _a585.ctl.stopped() and _a656 < 20 do
_a656 += 1
local _a657 = _a651()
if not _a657 then
_a585.auto.zoneNote = "다음 존을 못 구함 (GetNextZone 실패 / 존 퀘스트 미완료?)"
if _a585.auto.zoneSaid ~= _a585.auto.zoneNote then
_a585.auto.zoneSaid = _a585.auto.zoneNote
_a572("[존] " .. _a585.auto.zoneNote)
end
return
end
if not _a657.ok then
_a585.auto.zoneNote = ("%s  %s %s / 보유 %s — 부족"):format(
tostring(_a657.id), _a573(_a657.price or 0, 0), tostring(_a657.currency), _a573(_a657.have, 0))
if _a585.auto.zoneSaid ~= _a585.auto.zoneNote then
_a585.auto.zoneSaid = _a585.auto.zoneNote
_a572("[존] " .. _a585.auto.zoneNote)
end
return
end
_a585.auto.zoneSaid = nil
local _a658, _a659
pcall(function() _a658, _a659 = _a583.R_Zone:InvokeServer(_a657.id) end)
task.wait(0.5)
if _a658 then
_a580.zone += 1
_a572(("  ▶ 존 해금  %s   (%s %s)"):format(
tostring(_a657.id), _a573(_a657.price or 0, 0), tostring(_a657.currency)))
else
if _a659 then _a572("[존] 실패: " .. tostring(_a659)) end
return
end
task.wait(_a578.ActionGap)
end
end
local function _a660()
local _a661 = _a585.egg.eggStands()
local _a662 = (_a578.MainEggId and _a578.MainEggId ~= "") and _a578.MainEggId or nil
if _a662 then
for _a663, _a664 in ipairs(_a661) do
if _a664.id == _a662 then return _a664.id, _a664.def, _a664.dist end
end
local _a665 = _a583.DirEggs and rawget(_a583.DirEggs, _a662)
if _a665 then return _a662, _a665, nil, (_a661[1] and _a661[1].dist) end
return nil
end
if not _a583.DirEggs then return nil end
local _a666, _a667, _a668 = nil, nil, -1
for _a669, _a670 in pairs(_a583.DirEggs) do
if type(_a670) == "table" and not rawget(_a670, "isCustomEgg") then
local _a671 = tonumber(rawget(_a670, "eggNumber"))
if _a671 and _a671 > _a668 and _a585.egg.eggUnlocked(_a671) then
_a666, _a667, _a668 = _a669, _a670, _a671
end
end
end
if not _a666 then return nil end
local _a672, _a673
for _a674, _a675 in ipairs(_a661) do
if not _a673 then _a673 = _a675.dist end
if _a675.id == _a666 then _a672 = _a675.dist break end
end
if _a672 and _a672 <= _a578.EggRange then
return _a666, _a667, _a672
end
return _a666, _a667, nil, _a672 or _a673
end
local function _a676(_a677)
if type(_a583.CalcEgg) == "function" then
local _a678, _a679 = pcall(_a583.CalcEgg, _a677)
if _a678 and tonumber(_a679) then return tonumber(_a679) end
if not _a678 and not _a585.egg.priceWarned then
_a585.egg.priceWarned = true
_a572("[부화] CalcEggPricePlayer 막힘 → 기본가로 계산: " .. tostring(_a679))
end
end
if type(_a583.CalcEggB) == "function" then
local _a680, _a681 = pcall(_a583.CalcEggB, _a677)
if _a680 and tonumber(_a681) then return tonumber(_a681) end
end
for _a682, _a683 in ipairs({ "price", "Price", "cost", "Cost" }) do
local _a684 = tonumber(rawget(_a677, _a683))
if _a684 then return _a684 end
end
return nil
end
local function _a685()
local _a686, _a687, _a688, _a689 = _a660()
if not _a686 then return nil end
local _a690 = _a676(_a687)
local _a691 = rawget(_a687, "currency") or "Coins"
local _a692 = 1
if _a583.Egg and rawget(_a583.Egg, "GetMaxHatch") then
local _a693, _a694 = pcall(_a583.Egg.GetMaxHatch, _a687)
if _a693 and tonumber(_a694) then _a692 = math.max(1, math.floor(tonumber(_a694))) end
end
local _a695 = _a627(_a691)
return {
id = _a686, def = _a687, price = _a690, currency = _a691, maxN = _a692, have = _a695,
dist = _a688, nearest = _a689, inRange = _a688 ~= nil,
canBuy = (_a690 and _a690 > 0) and math.floor(math.max(0, _a695 - _a578.MainHatchReserve) / _a690) or 0,
}
end
local function _a696()
if not _a577.R_EGG then _a572("[부화] Eggs_RequestPurchase 리모트 없음") return end
if _a578.AutoUnlockEgg then
local _a697, _a698, _a699 = _a585.egg.lockedEggs()
if _a698 > _a699 then
local _a700 = _a585.egg.unlockEggs()
if _a700 > 0 then _a572(("[부화] 알 %d개 해금 (해금가능 #%d)"):format(_a700, _a698)) end
end
end
local _a701 = _a685()
if not _a701 then _a572("[부화] 알을 못 찾음") return end
if not _a701.inRange then
if _a578.HatchAutoTp then
local _a702, _a703 = _a585.egg.tpEgg(_a701.id)
if not _a702 then
if not _a585.egg.hatchWarned then
_a585.egg.hatchWarned = true
_a572("[부화] 알로 이동 실패: " .. tostring(_a703))
end
return
end
_a572("[부화] " .. _a701.id .. " 로 이동")
_a701 = _a685()
if not (_a701 and _a701.inRange) then return end
else
if not _a585.egg.hatchWarned then
_a585.egg.hatchWarned = true
_a572(("[부화] 알 근처로 가주세요 (가장 가까운 알까지 %s스터드, 인식 %d)"):format(
_a701.nearest and ("%.0f"):format(_a701.nearest) or "?", _a578.EggRange))
end
return
end
end
_a585.egg.hatchWarned = false
local _a704 = math.min(_a701.maxN, _a578.MainHatchMax)
local _a705 = _a701.price and math.min(_a701.canBuy, _a704) or _a704
if _a705 < 1 then return end
local _a706, _a707 = 0, 0
local function _a708()
return tonumber(_a583.Vars and rawget(_a583.Vars, "OpeningEgg")) or 0
end
local _a709 = _a583.Vars and rawget(_a583.Vars, "OpeningEgg") ~= nil
local _a710 = 2.5
if _a583.Egg and rawget(_a583.Egg, "ComputeDebounce") then
local _a711, _a712 = pcall(_a583.Egg.ComputeDebounce)
if _a711 and tonumber(_a712) then _a710 = tonumber(_a712) end
end
_a585.egg.autoHatchOn(_a701.id, _a705)
local _a713 = false
local _a714 = _a585.ctl.lockGoal and _a585.ctl.lockGoal.q
local _a715 = _a714 and (_a714.how == "hatch" or _a714.where == "bestegg") or false
local _a716 = _a715 and math.huge
or (os.clock() + math.max(3, _a578.HatchBudget or 25))
local _a717 = _a715 and 100000 or 400
while _a579.mhatch and not _a585.ctl.stopped() and _a705 >= 1 and _a707 < _a717 and os.clock() < _a716 do
if _a715 and (_a707 % 5 == 0) then
local _a718 = _a585.quest.findQuest(_a714.uid)
if not _a718 or _a718.progress >= _a718.amount then break end
end
_a707 += 1
if _a709 then
local _a719 = os.clock()
local _a720 = _a578.HatchClickAfter
local _a721 = false
while _a708() > 0 and _a579.mhatch and not _a585.ctl.stopped()
and (os.clock() - _a719) < 20 do
if _a578.HatchClick and (os.clock() - _a719) > _a720 then
_a585.egg.clickOnce()
_a720 += 0.3
if (os.clock() - _a719) > 3 and not _a721 then
_a721 = true
_a585.egg._ahEgg = nil
_a585.egg.autoHatchOn(_a701.id, _a705)
_a572("[부화] 화면이 안 넘어가서 오토해치 재설정")
end
end
task.wait(0.03)
end
if _a708() > 0 then
if _a585.egg.hatchStuck ~= _a701.id then
_a585.egg.hatchStuck = _a701.id
_a572("[부화] " .. tostring(_a701.id) .. " 까는 화면에서 멈춤 — 이번 회차 중단")
end
_a713 = true
break
end
_a585.egg.hatchStuck = nil
else
local _a722 = os.clock() - (_a585.egg.lastHatch or 0)
if _a722 < _a710 then task.wait(_a710 - _a722) end
end
_a585.egg.lastHatch = os.clock()
_a585.ctl.setAct("알 까는 중", ("%s x%d  (총 %d)"):format(_a701.id, _a705, _a706))
local _a723, _a724
local _a725 = pcall(function() _a723, _a724 = _a577.R_EGG:InvokeServer(_a701.id, _a705) end)
if _a723 then
_a706 += _a705
_a580.mhatch += _a705
_a585.egg.hatchErr = nil
if _a701.price then
local _a726 = _a627(_a701.currency)
local _a727 = math.floor(math.max(0, _a726 - _a578.MainHatchReserve) / _a701.price)
if _a727 < 1 then break end
_a705 = math.min(_a727, _a704)
end
else
local _a728 = _a725 and tostring(_a724) or "호출 자체 실패"
if _a728:find("quickly") or _a728:find("fast") then
task.wait(0.25)
elseif _a728:find("far away") then
if _a578.HatchAutoTp then _a585.egg.tpEgg(_a701.id) task.wait(0.2)
else _a572("[부화] 알에서 너무 멈") break end
elseif _a705 > 1 then
_a705 = math.floor(_a705 / 2)
else
if _a585.egg.hatchErr ~= _a728 then
_a585.egg.hatchErr = _a728
_a572("[부화] 실패: " .. _a728 .. "   (알 " .. tostring(_a701.id)
.. " / 개수 " .. _a705 .. " / 거리 "
.. (_a701.dist and ("%.0f"):format(_a701.dist) or "?") .. ")")
end
break
end
end
end
if _a709 and _a706 > 0 and not _a713 then
local _a729 = os.clock()
while _a708() == 0 and not _a585.ctl.stopped() and (os.clock() - _a729) < 2.5 do
task.wait(0.05)
end
local _a730 = os.clock()
local _a731 = _a578.HatchClickAfter
while _a708() > 0 and not _a585.ctl.stopped() and (os.clock() - _a730) < 20 do
_a585.ctl.setAct("알 마무리", ("%s  마지막 %d개 까는 중"):format(_a701.id, _a705))
if _a578.HatchClick and (os.clock() - _a730) > _a731 then
_a585.egg.clickOnce()
_a731 += 0.3
if (os.clock() - _a730) > 3 and not _a585.egg._finRe then
_a585.egg._finRe = true
_a585.egg._ahEgg = nil
_a585.egg.autoHatchOn(_a701.id, _a705)
end
end
task.wait(0.03)
end
_a585.egg._finRe = nil
if _a708() > 0 then
_a572("[부화] 마지막 알이 20초 넘게 안 끝남 — 그대로 두고 진행합니다")
end
end
_a585.egg.autoHatchOff()
if _a706 > 0 then
_a585.egg.hatchErr = nil
_a572(("[부화] %s × %d%s  (개당 %s %s)"):format(
_a701.id, _a706, _a715 and " (목표까지)" or "",
_a701.price and _a573(_a701.price, 0) or "?", tostring(_a701.currency)))
end
end
local function _a732()
local _a733 = _a612()
if not _a733 then return nil end
local _a734 = tonumber(rawget(_a733, "Rank")) or 1
local _a735 = tonumber(rawget(_a733, "RankStars")) or 0
local _a736 = rawget(_a733, "RedeemedRankRewards") or {}
local _a737
if _a583.RanksU and rawget(_a583.RanksU, "RankIDFromNumber") then
local _a738, _a739 = pcall(_a583.RanksU.RankIDFromNumber, _a734)
if _a738 then _a737 = _a739 end
end
local _a740 = _a737 and _a583.DirRanks and rawget(_a583.DirRanks, _a737)
if type(_a740) ~= "table" then
return { rankNum = _a734, stars = _a735, rankId = _a737, rewards = {} }
end
local _a741, _a742 = {}, 0
for _a743, _a744 in ipairs(rawget(_a740, "Rewards") or {}) do
_a742 += (tonumber(rawget(_a744, "StarsRequired")) or 0)
local _a745 = _a742 <= _a735
local _a746 = _a736[tostring(_a743)] ~= nil
_a741[#_a741 + 1] = {
index = _a743, need = _a742, earned = _a745, redeemed = _a746,
claimable = _a745 and not _a746,
}
end
return { rankNum = _a734, stars = _a735, rankId = _a737, rewards = _a741 }
end
local function _a747()
if not _a583.R_Rank then _a572("[랭크] Ranks_ClaimReward 리모트 없음") return end
local _a748 = _a732()
if not _a748 then return end
local _a749 = 0
for _a750, _a751 in ipairs(_a748.rewards) do
if not _a579.rank then break end
if _a751.claimable then
pcall(function() _a583.R_Rank:FireServer(_a751.index) end)
_a749 += 1
_a580.rank += 1
task.wait(0.1)
end
end
if _a749 > 0 then
_a572(("[랭크] 보상 %d개 수령  (Rank %d, ★%d)"):format(_a749, _a748.rankNum, _a748.stars))
end
end
function _a585.move.hrp()
local _a752 = _a571 and _a571.Character
return _a752 and _a752:FindFirstChild("HumanoidRootPart"),
_a752 and _a752:FindFirstChildOfClass("Humanoid")
end
function _a585.egg.autoHatchOn(_a753, _a754)
if not _a578.UseAutoHatch then return end
if _a585.egg._ahEgg == _a753 and _a585.egg._ahAt and (os.clock() - _a585.egg._ahAt) < 15 then return end
_a585.egg._ahEgg, _a585.egg._ahAt = _a753, os.clock()
local _a755 = _a583.DirEggs and rawget(_a583.DirEggs, _a753)
if _a583.Hatch and _a755 and rawget(_a583.Hatch, "SetupEgg") then
local _a756, _a757 = pcall(_a583.Hatch.SetupEgg, _a755, _a754 or 1)
if not _a756 and not _a585.egg._ahWarn then
_a585.egg._ahWarn = true
_a572("[부화] SetupEgg 실패: " .. tostring(_a757) .. "  → 클릭 대체 사용")
end
end
if _a583.R_AHTog then pcall(function() _a583.R_AHTog:FireServer(true) end) end
if _a583.R_AHOn then pcall(function() _a583.R_AHOn:FireServer(_a753, _a754 or 1) end) end
if _a583.Hatch and rawget(_a583.Hatch, "IsHatching") then
local _a758, _a759 = pcall(_a583.Hatch.IsHatching)
_a585.egg._ahLive = _a758 and _a759 and true or false
end
end
function _a585.egg.autoHatchOff()
_a585.egg._ahEgg, _a585.egg._ahAt, _a585.egg._ahLive = nil, nil, nil
if _a583.Hatch and rawget(_a583.Hatch, "StopHatching") then pcall(_a583.Hatch.StopHatching) end
if _a583.R_AHOff then pcall(function() _a583.R_AHOff:FireServer() end) end
end
function _a585.egg.clickOnce()
if _a585.ctl.moving then return false end
local _a760 = _a585.screen.signal("egg")
if not _a760 then _a760 = _a585.screen.pressInGame({ "Egg Opening" }) end
if not _a760 and not _a585.egg._eggSigWarn then
_a585.egg._eggSigWarn = true
_a572("[부화] 게임 내 방법이 다 막힘 — SetupEgg 에만 의존합니다")
end
return _a760
end
function _a585.egg.watchStuck()
local _a761 = _a583.Vars
if not _a761 then return end
local _a762 = tonumber(rawget(_a761, "OpeningEgg")) or 0
if _a762 <= 0 then
_a585.egg.stuckSince, _a585.egg.stuckSaid = nil, nil
return
end
_a585.egg.stuckSince = _a585.egg.stuckSince or os.clock()
local _a763 = os.clock() - _a585.egg.stuckSince
if _a763 < 3 then return end
if not _a578.HatchClick then return end
if _a585.ctl.moving then _a585.screen.signal("egg") else _a585.egg.clickOnce() end
if _a763 > 6 and not _a585.egg.stuckSaid then
_a585.egg.stuckSaid = true
_a572("[부화] 까는 화면에서 멈춰 있어 계속 넘기는 중")
end
end
function _a585.item.applyPetSpeed()
local _a764 = _a583.PlayerPet
if not (_a764 and rawget(_a764, "GetByPlayer")) then return 0, "PlayerPet 없음" end
local _a765, _a766 = pcall(_a764.GetByPlayer, _a571)
if not (_a765 and type(_a766) == "table") then return 0, "펫 목록 못 읽음" end
local _a767 = math.max(1, tonumber(_a578.PetSpeedMult) or 50)
local _a768 = math.max(0.05, tonumber(_a578.PetSpeedBase) or 4)
local _a769 = 0
for _a770, _a771 in pairs(_a766) do
if type(_a771) == "table" then
local _a772 = rawget(_a771, "cpet")
if _a772 then
_a771.speedMult = _a767
pcall(function() _a772:Broadcast("petSpeedMult", _a767) end)
pcall(function() _a772:Broadcast("petSpeed", _a768) end)
_a769 += 1
end
end
end
return _a769
end
_a585.screen.SIGNAL = {
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
_a585.screen.BLOCKERS = {
{ "Rebirth",     "리버스",   "reward" },
{ "RankUp",      "랭크업",   "reward" },
{ "MasteryPerk", "마스터리", "mastery" },
{ "Card",        "카드",     "card" },
}
function _a585.screen.findSignalFns(_a773)
local _a774 = _a585.screen.SIGNAL[_a773]
if not _a774 then return {} end
_a585.screen._sig = _a585.screen._sig or {}
local _a775 = _a585.screen._sig[_a773]
if _a775 and (os.clock() - _a775.at) < (#_a775.fns > 0 and 20 or 3) then return _a775.fns end
local _a776 = {}
_a585.screen._sig[_a773] = { at = os.clock(), fns = _a776 }
if type(getgc) ~= "function" or type(debug) ~= "table"
or type(debug.info) ~= "function" or type(debug.getupvalue) ~= "function" then
return _a776
end
local _a777 = {}
for _a778, _a779 in ipairs({ true, false }) do
local _a780, _a781 = pcall(getgc, _a779)
if _a780 and type(_a781) == "table" then
for _a782, _a783 in ipairs(_a781) do _a777[#_a777 + 1] = _a783 end
end
end
if #_a777 == 0 then return _a776 end
for _a784, _a785 in ipairs(_a777) do
if type(_a785) == "function" then
local _a786, _a787 = pcall(debug.info, _a785, "s")
if _a786 and type(_a787) == "string" then
local _a788 = false
for _a789, _a790 in ipairs(_a774.pats) do
if _a787:find(_a790, 1, true) then _a788 = true break end
end
if _a788 then
local _a791, _a792 = pcall(debug.info, _a785, "a")
if _a791 then
local _a793, _a794 = {}, 0
for _a795 = 1, 16 do
local _a796, _a797 = pcall(debug.getupvalue, _a785, _a795)
if not _a796 then break end
_a794 = _a795
_a793[_a795] = type(_a797)
end
local _a798 = table.concat(_a793, ",")
local _a799 = false
for _a800, _a801 in ipairs(_a774.sigs or {}) do
if _a792 == _a801.np and _a798 == _a801.t then
_a776[#_a776 + 1] = { fn = _a785, sig = _a798, n = _a794, np = _a792,
src = _a787, set = _a801.set }
_a799 = true
break
end
end
if not _a799 and _a774.sigs then
local _a802 = {}
for _a803, _a804 in ipairs(_a793) do
if _a804 == "boolean" then _a802[#_a802 + 1] = _a803 end
end
if #_a802 > 0 then
_a776[#_a776 + 1] = { fn = _a785, idx = _a802, sig = _a798, n = _a794,
np = _a792, src = _a787, loose = true }
end
end
if not _a799 and not _a774.sigs and _a792 == 0 then
local _a805 = 0
for _a806, _a807 in ipairs(_a793) do if _a807 == "boolean" then _a805 += 1 end end
if _a805 >= (_a774.minBools or 1) then
local _a808 = {}
for _a809, _a810 in ipairs(_a793) do
if _a810 == "boolean" then _a808[#_a808 + 1] = _a809 end
end
_a776[#_a776 + 1] = { fn = _a785, idx = _a808, sig = _a798, n = _a794, src = _a787 }
end
end
end
end
end
end
end
return _a776
end
function _a585.screen.signal(_a811)
if type(debug) ~= "table" or type(debug.setupvalue) ~= "function" then return false, 0 end
local _a812 = _a585.screen.findSignalFns(_a811)
local _a813 = 0
for _a814, _a815 in ipairs(_a812) do
if _a815.set then
for _a816, _a817 in ipairs(_a815.set) do
if pcall(debug.setupvalue, _a815.fn, _a817[1], _a817[2]) then _a813 += 1 end
end
elseif not _a815.loose then
for _a818, _a819 in ipairs(_a815.idx or {}) do
if pcall(debug.setupvalue, _a815.fn, _a819, true) then _a813 += 1 end
end
end
end
if _a813 == 0 then
for _a820, _a821 in ipairs(_a812) do
if _a821.loose then
for _a822, _a823 in ipairs(_a821.idx or {}) do
if pcall(debug.setupvalue, _a821.fn, _a823, true) then _a813 += 1 end
end
end
end
end
return _a813 > 0, _a813
end
function _a585.screen.pressInGame(_a824)
local _a825, _a826 = pcall(function() return game:GetService("UserInputService") end)
if not (_a825 and _a826) then return false end
local _a827 = {
UserInputType  = Enum.UserInputType.MouseButton1,
UserInputState = Enum.UserInputState.Begin,
KeyCode        = Enum.KeyCode.Unknown,
Position       = Vector3.new(),
Delta          = Vector3.new(),
}
local _a828 = 0
if type(getconnections) == "function" then
local _a829, _a830 = pcall(getconnections, _a826.InputBegan)
if _a829 and type(_a830) == "table" then
for _a831, _a832 in ipairs(_a830) do
local _a833 = ""
local _a834 = _a832.Function
if _a834 and type(debug) == "table" and type(debug.info) == "function" then
local _a835, _a836 = pcall(debug.info, _a834, "s")
if _a835 and _a836 then _a833 = tostring(_a836) end
end
local _a837 = false
for _a838, _a839 in ipairs(_a824) do
if _a833 ~= "" and _a833:find(_a839, 1, true) then _a837 = true break end
end
if _a837 then
if _a834 and pcall(_a834, _a827, false) then _a828 += 1
elseif _a832.Fire and pcall(function() _a832:Fire(_a827, false) end) then _a828 += 1
elseif _a832.Defer and pcall(function() _a832:Defer(_a827, false) end) then _a828 += 1 end
end
end
end
end
if _a828 == 0 and type(firesignal) == "function" then
if pcall(firesignal, _a826.InputBegan, _a827, false) then _a828 += 1 end
end
return _a828 > 0
end
function _a585.screen.realClick(_a840)
if not _a578.ScreenRealClick then return false end
local _a841 = workspace.CurrentCamera
local _a842 = (_a841 and _a841.ViewportSize) or Vector2.new(1280, 720)
local _a843, _a844 = _a842.X * 0.5, _a842.Y * 0.45
local _a845 = {}
local function _a846(_a847, _a848)
local _a849 = pcall(_a848)
_a845[#_a845 + 1] = _a847 .. (_a849 and "=OK" or "=X")
return _a849
end
local _a850 = false
if not _a850 and type(mouse1click) == "function" then
_a850 = _a846("mouse1click", function() mouse1click() end)
end
if not _a850 and type(mouse1press) == "function" then
_a850 = _a846("mouse1press", function()
mouse1press() task.wait(0.05)
if type(mouse1release) == "function" then mouse1release() end
end)
end
if not _a850 then
_a850 = _a846("VirtualUser", function()
local _a851 = game:GetService("VirtualUser")
_a851:Button1Down(Vector2.new(_a843, _a844), _a841 and _a841.CFrame or CFrame.new())
task.wait(0.05)
_a851:Button1Up(Vector2.new(_a843, _a844), _a841 and _a841.CFrame or CFrame.new())
end)
end
if not _a850 then
_a850 = _a846("VirtualInputManager", function()
local _a852 = game:GetService("VirtualInputManager")
_a852:SendMouseButtonEvent(_a843, _a844, 0, true, game, 1)
task.wait(0.05)
_a852:SendMouseButtonEvent(_a843, _a844, 0, false, game, 1)
end)
end
if _a840 then _a572("    " .. table.concat(_a845, " / ")) end
return _a850
end
function _a585.screen.rewardScreenUp()
if not _a571 then
if not _a585.screen.noLP then
_a585.screen.noLP = true
_a572("[화면] LocalPlayer 를 못 잡았습니다 — 화면 감시를 건너뜁니다")
end
return false
end
local _a853 = _a571:FindFirstChildOfClass("PlayerGui")
if _a853 then
for _a854, _a855 in ipairs(_a585.screen.BLOCKERS) do
local _a856 = _a853:FindFirstChild(_a855[1])
if _a856 and _a856:IsA("ScreenGui") and _a856.Enabled then return true, _a855[2], _a855[3] end
end
end
local _a857 = _a583.Vars
if _a857 then
if rawget(_a857, "IsRebirthing") then return true, "리버스", "reward" end
if rawget(_a857, "IsRankingUp") then return true, "랭크업", "reward" end
end
return false
end
function _a585.screen.dismissRewardScreens(_a858)
if _a585.screen.dismissBusy then return end
_a585.screen.dismissBusy = true
local _a859, _a860 = pcall(_a585.screen.dismissInner, _a858)
_a585.screen.dismissBusy = false
if not _a859 then _a572("[화면] 오류: " .. tostring(_a860)) end
end
function _a585.screen.dismissInner(_a861)
local _a862 = _a583.Vars
if not _a862 then return end
local _a863 = os.clock()
local _a864, _a865 = false, nil
local _a866 = 0
local _a867 = math.max(3, _a578.ScreenTryMax or 8)
while os.clock() - _a863 < (_a861 or 120) do
local _a868, _a869, _a870 = _a585.screen.rewardScreenUp()
if not _a868 then break end
_a864, _a865 = true, _a869
_a866 += 1
_a585.ctl.setAct("보상 화면 넘기는 중",
("%s (%d회%s)"):format(tostring(_a869), _a866,
_a866 <= 6 and " · 첫 화면 대기" or ""))
local _a871 = _a585.screen.SIGNAL[_a870 or "reward"]
local _a872 = (_a871 and _a871.pats) or { "Rebirth", "Rank Up" }
local _a873 = _a585.screen.signal(_a870 or "reward")
if not _a873 then
for _a874 in pairs(_a585.screen.SIGNAL) do
if _a585.screen.signal(_a874) then _a873 = true end
end
end
local _a875 = false
if not _a873 or _a866 >= 2 then
_a875 = _a585.screen.pressInGame(_a872)
end
if _a866 >= 3 then
if _a585.screen.realClick() then
_a875 = true
if not _a585.screen._realSaid then
_a585.screen._realSaid = true
_a572("[화면] 실제 클릭까지 같이 씁니다 (Roblox 창이 켜져 있어야 먹습니다)")
end
end
end
if (_a873 or _a875) and not _a585.screen._sigSaid then
_a585.screen._sigSaid = true
_a572("[화면] " .. (_a873 and "upvalue 신호" or "게임 내 입력 발동") .. " 로 넘깁니다")
end
if _a866 >= _a867 and (os.clock() - _a863) >= 12 then
if _a585.screen.giveUpSaid ~= _a869 then
_a585.screen.giveUpSaid = _a869
_a572(("[화면] %s 화면을 못 넘김 — 그냥 두고 자동화는 계속합니다"):format(tostring(_a869)))
_a572("        (이 화면은 UI만 가릴 뿐 리모트 호출은 막지 않습니다)")
end
_a585.screen.screenGaveUp = os.clock()
return
end
task.wait(0.8)
end
if _a864 then
if not _a585.screen.rewardScreenUp() then
_a585.screen.lastBlocker = nil
_a585.screen.screenGaveUp = nil
_a572(("[화면] %s 넘김 완료 (%d회)"):format(tostring(_a865), _a866))
end
end
end
function _a585.egg.eggUnlocked(_a876)
_a876 = tonumber(_a876)
if not _a876 then return false end
local _a877 = _a612()
local _a878 = _a877 and rawget(_a877, "UnlockedEggs")
if type(_a878) == "table" then
for _a879, _a880 in pairs(_a878) do
if tonumber(_a880) == _a876 then return true end
end
return false
end
return _a876 <= 1
end
function _a585.egg.lockedEggs()
local _a881 = {}
if not _a583.DirEggs then return _a881, 0, 0 end
local _a882 = _a612()
local _a883 = tonumber(_a882 and rawget(_a882, "MaximumAvailableEgg")) or 1
local _a884 = 0
local _a885 = _a882 and rawget(_a882, "UnlockedEggs")
if type(_a885) == "table" then
for _a886, _a887 in pairs(_a885) do
local _a888 = tonumber(_a887)
if _a888 and _a888 > _a884 then _a884 = _a888 end
end
end
for _a889, _a890 in pairs(_a583.DirEggs) do
if type(_a890) == "table" and not rawget(_a890, "isCustomEgg") then
local _a891 = tonumber(rawget(_a890, "eggNumber"))
if _a891 and _a891 <= _a883 and not _a585.egg.eggUnlocked(_a891) then
_a881[#_a881 + 1] = { id = _a889, num = _a891 }
end
end
end
table.sort(_a881, function(_a892, _a893) return _a892.num < _a893.num end)
return _a881, _a883, _a884
end
function _a585.egg.unlockEggs(_a894)
if not _a583.R_EggUn then return 0, "Eggs_RequestUnlock 리모트 없음" end
local _a895 = _a585.egg.lockedEggs()
if #_a895 == 0 then return 0 end
local _a896, _a897 = 0, nil
for _a898, _a899 in ipairs(_a895) do
if not _a585.egg.eggUnlocked(_a899.num) then
local _a900, _a901
pcall(function() _a900, _a901 = _a583.R_EggUn:InvokeServer(_a899.id) end)
if not _a900 and _a578.HatchAutoTp then
local _a902 = _a585.egg.tpEgg(_a899.id)
if _a902 then
task.wait(0.3)
pcall(function() _a900, _a901 = _a583.R_EggUn:InvokeServer(_a899.id) end)
end
end
if _a900 then
_a896 += 1
_a585.ctl.setAct("알 해금", ("#%d %s"):format(_a899.num, _a899.id))
_a572(("  🔓 알 해금  #%d %s"):format(_a899.num, _a899.id))
task.wait(0.15)
else
_a897 = _a901
if _a894 then
_a572(("[해금] #%d %s 실패: %s"):format(_a899.num, _a899.id, tostring(_a901)))
end
end
end
end
return _a896, _a897
end
function _a585.move.curZone()
if _a583.Map and rawget(_a583.Map, "GetCurrentZone") then
local _a903, _a904 = pcall(_a583.Map.GetCurrentZone)
if _a903 then return _a904 end
end
return nil
end
function _a585.move.zone1()
if not _a583.DirZones then return nil end
local _a905, _a906 = nil, math.huge
for _a907, _a908 in pairs(_a583.DirZones) do
if type(_a908) == "table" and _a585.move.ownsZone(_a907) then
local _a909 = tonumber(rawget(_a908, "ZoneNumber")) or math.huge
if _a909 < _a906 then _a905, _a906 = _a907, _a909 end
end
end
return _a905
end
function _a585.move.realZone(_a910) return _a910 end
function _a585.move.resolvableZone(_a911)
if _a911 then
local _a912 = _a585.move.zonePos(_a911)
if _a912 then return _a911, _a912 end
end
if not _a583.DirZones then return nil end
local _a913 = {}
for _a914, _a915 in pairs(_a583.DirZones) do
if type(_a915) == "table" and _a585.move.ownsZone(_a914) then
_a913[#_a913 + 1] = { id = _a914, n = tonumber(rawget(_a915, "ZoneNumber")) or 0 }
end
end
table.sort(_a913, function(_a916, _a917) return _a916.n > _a917.n end)
for _a918, _a919 in ipairs(_a913) do
if _a919.id ~= _a911 then
local _a920 = _a585.move.zonePos(_a919.id)
if _a920 then
if _a585.move.fallZone ~= _a919.id then
_a585.move.fallZone = _a919.id
_a572(("[TP] %s 좌표를 못 구해서 %s 로 대신 감 (로드 안 된 존)"):format(
tostring(_a911), tostring(_a919.id)))
end
return _a919.id, _a920
end
end
end
return nil
end
function _a585.move.bestZone()
if _a583.Zone and rawget(_a583.Zone, "GetMaxOwnedZone") then
local _a921, _a922, _a923 = pcall(_a583.Zone.GetMaxOwnedZone)
if _a921 and _a922 then return _a922, _a923 end
end
return _a585.move.zone1()
end
function _a585.move.ownsZone(_a924)
local _a925 = _a612()
local _a926 = _a925 and rawget(_a925, "UnlockedZones")
return (type(_a926) == "table" and _a926[_a924] ~= nil) or false
end
function _a585.move.zoneByNumber(_a927)
if not (_a583.DirZones and _a927) then return nil end
for _a928, _a929 in pairs(_a583.DirZones) do
if type(_a929) == "table" and tonumber(rawget(_a929, "ZoneNumber")) == tonumber(_a927) then
return _a928, _a929
end
end
return nil
end
local function _a930(_a931, _a932)
local _a933 = rawget(_a931, "Breakables")
local _a934 = type(_a933) == "table" and rawget(_a933, "Main") or nil
local _a935 = type(_a934) == "table" and rawget(_a934, "Data") or nil
if type(_a935) ~= "table" then return false end
for _a936, _a937 in pairs(_a935) do
local _a938 = type(_a937) == "table" and rawget(_a937, "Type") or nil
if _a938 and tostring(_a938):lower():find(_a932, 1, true) then return true end
end
return false
end
function _a585.move.zoneForBreakable(_a939)
if not (_a583.DirZones and _a939) then return nil end
local _a940 = tostring(_a939):lower()
local _a941 = _a585.move.bestZone()
if _a941 then
local _a942 = rawget(_a583.DirZones, _a941)
if type(_a942) == "table" and _a930(_a942, _a940) then return _a941 end
end
local _a943, _a944 = nil, -1
for _a945, _a946 in pairs(_a583.DirZones) do
if type(_a946) == "table" and _a945 ~= "Spawn" and _a585.move.ownsZone(_a945) then
local _a947 = rawget(_a946, "Breakables")
local _a948 = type(_a947) == "table" and rawget(_a947, "Main") or nil
local _a949 = type(_a948) == "table" and rawget(_a948, "Data") or nil
if type(_a949) == "table" then
for _a950, _a951 in pairs(_a949) do
local _a952 = type(_a951) == "table" and rawget(_a951, "Type") or nil
if _a952 and tostring(_a952):lower():find(_a940, 1, true) then
local _a953 = tonumber(rawget(_a946, "ZoneNumber")) or 0
if _a953 > _a944 then _a943, _a944 = _a945, _a953 end
break
end
end
end
end
end
return _a943
end
function _a585.move.tpZone(_a954)
if not _a954 then return false, "존 id 없음" end
if _a585.move.curZone() == _a954 then return true end
if not _a578.TpGameFallback then
_a572("[TP] 게임 정식 TP 차단됨 (" .. tostring(_a954) .. ")\n" .. debug.traceback("", 2))
return false, "게임 TP 꺼져 있음"
end
local _a955 = _a583.R_Tp
if _a583.Inst and rawget(_a583.Inst, "IsInInstance") then
local _a956, _a957 = pcall(_a583.Inst.IsInInstance)
if _a956 and _a957 and _a583.R_TpI then _a955 = _a583.R_TpI end
end
if not _a955 then return false, "텔레포트 리모트 없음" end
local _a958 = os.clock() - (_a585.move.lastTp or 0)
if _a958 < _a578.TpCooldown then task.wait(_a578.TpCooldown - _a958) end
_a585.move.lastTp = os.clock()
local _a959, _a960
pcall(function() _a959, _a960 = _a955:InvokeServer(_a954) end)
if not _a959 then return false, _a960 end
local _a961 = os.clock()
while os.clock() - _a961 < 5 do
if _a585.move.curZone() == _a954 then break end
task.wait(0.05)
end
task.wait(0.15)
return true
end
function _a585.move.glideTo(_a962)
if _a585.ctl.stopped() then return false, "정지됨" end
if _a585.ctl.moving and (os.clock() - _a585.ctl.moving) < 30 then
return false, "이미 이동 중 (다른 이동이 아직 안 끝남)"
end
_a585.ctl.moving = os.clock()
local _a963, _a964, _a965 = pcall(_a585.move.glideRaw, _a962)
_a585.ctl.moving = nil
if not _a963 then return false, tostring(_a964) end
return _a964, _a965
end
function _a585.move.glideRaw(_a966)
local _a967, _a968 = _a585.move.hrp()
if not _a967 then return false, "캐릭터 없음" end
if _a578.TpMode == "instant" then
local _a969 = _a966 + Vector3.new(0, 4, 0)
for _a970 = 1, 3 do
local _a971 = _a571 and _a571.Character
local _a972, _a973 = _a585.move.hrp()
if not (_a971 and _a972) then return false, "캐릭터 없음" end
local _a974 = _a972.CFrame - _a972.CFrame.Position
pcall(function() _a971:PivotTo(CFrame.new(_a969) * _a974) end)
_a972.AssemblyLinearVelocity = Vector3.zero
for _a975 = 1, 6 do _a570.Heartbeat:Wait() end
if _a973 then
pcall(function()
_a973:Move(Vector3.new(0.3, 0, 0), false)
end)
task.wait(0.1)
pcall(function() _a973:Move(Vector3.zero, false) end)
end
task.wait(0.15)
_a972 = _a585.move.hrp()
if _a972 and (_a972.Position - _a969).Magnitude <= 30 then
local _a976 = os.clock()
while os.clock() - _a976 < 1.5 do
if _a585.move.inDottedBox() ~= false then break end
task.wait(0.05)
end
return true
end
if _a970 < 3 then task.wait(0.15) end
end
return false, "순간이동이 되돌려짐"
end
if _a578.TpMode == "walk" then
if not _a968 then return false, "Humanoid 없음" end
local _a977 = os.clock()
while os.clock() - _a977 < 45 do
local _a978 = _a967.Position
if (Vector3.new(_a978.X, 0, _a978.Z) - Vector3.new(_a966.X, 0, _a966.Z)).Magnitude < 8 then
return true
end
_a968:MoveTo(_a966)
task.wait(0.5)
end
return false, "걸어가다 시간초과"
end
if (_a967.Position - _a966).Magnitude <= (_a578.ArriveDist or 12) then return true end
local _a979 = math.max(16, tonumber(_a578.TpSpeed) or 90)
local _a980 = math.max(0, tonumber(_a578.TpHeight) or 0)
local function _a981(_a982, _a983)
local _a984 = 0
while _a984 < 2000 do
if _a585.ctl.stopped() then return false end
_a984 += 1
local _a985 = _a585.move.hrp()
if not _a985 then return false end
local _a986 = _a985.Position
local _a987 = _a982 - _a986
local _a988 = _a987.Magnitude
if _a988 < 2.5 then return true end
local _a989 = _a570.Heartbeat:Wait()
local _a990 = math.min(_a988, _a979 * math.min(_a989, 0.1))
local _a991 = _a983 and (Vector3.new(_a982.X, _a986.Y, _a982.Z)) or nil
if _a991 and (_a991 - _a986).Magnitude > 1 then
_a985.CFrame = CFrame.lookAt(_a986 + _a987.Unit * _a990, _a991)
else
_a985.CFrame = CFrame.new(_a986 + _a987.Unit * _a990) * (_a985.CFrame - _a985.Position)
end
_a985.AssemblyLinearVelocity = Vector3.zero
end
return false
end
if _a980 > 0 then
local _a992 = _a967.Position
local _a993 = math.max(_a992.Y, _a966.Y) + _a980
_a981(Vector3.new(_a992.X, _a993, _a992.Z), false)
_a981(Vector3.new(_a966.X, _a993, _a966.Z), true)
end
_a981(_a966 + Vector3.new(0, 3, 0), true)
local _a994 = _a585.move.hrp()
if _a994 then _a994.AssemblyLinearVelocity = Vector3.zero end
return true
end
local function _a995(_a996)
local _a997 = #_a996
if _a997 == 0 then return nil, 0 end
local _a998, _a999 = math.huge, -math.huge
local _a1000, _a1001 = math.huge, -math.huge
local _a1002 = 0
for _a1003, _a1004 in ipairs(_a996) do
if _a1004.X < _a998 then _a998 = _a1004.X end
if _a1004.X > _a999 then _a999 = _a1004.X end
if _a1004.Z < _a1000 then _a1000 = _a1004.Z end
if _a1004.Z > _a1001 then _a1001 = _a1004.Z end
_a1002 += _a1004.Y
end
return Vector3.new((_a998 + _a999) / 2, _a1002 / _a997, (_a1000 + _a1001) / 2), _a997
end
function _a585.move.breakCenter(_a1005)
local _a1006 = _a585.move.hrp()
if not _a1006 then return nil, 0 end
local _a1007 = workspace:FindFirstChild("__THINGS")
if not _a1007 then return nil, 0 end
local _a1008 = _a1006.Position
local _a1009 = {}
for _a1010, _a1011 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a1012 = _a1007:FindFirstChild(_a1011)
if _a1012 then
for _a1013, _a1014 in ipairs(_a1012:GetChildren()) do
local _a1015
if _a1014:IsA("BasePart") then _a1015 = _a1014.Position
elseif _a1014:IsA("Model") then
local _a1016, _a1017 = pcall(function() return _a1014:GetPivot() end)
if _a1016 and typeof(_a1017) == "CFrame" then _a1015 = _a1017.Position end
end
if _a1015 and (_a1015 - _a1008).Magnitude <= (_a1005 or 400) then
_a1009[#_a1009 + 1] = _a1015
end
end
end
end
return _a995(_a1009)
end
function _a585.move.groundY(_a1018, _a1019, _a1020)
_a1020 = tonumber(_a1020) or 0
local _a1021 = RaycastParams.new()
_a1021.FilterType = Enum.RaycastFilterType.Exclude
local _a1022 = {}
if _a571 and _a571.Character then _a1022[#_a1022 + 1] = _a571.Character end
local _a1023 = workspace:FindFirstChild("__THINGS")
if _a1023 then _a1022[#_a1022 + 1] = _a1023 end
_a1021.FilterDescendantsInstances = _a1022
local _a1024 = Vector3.new(_a1018, _a1020 + 12, _a1019)
local _a1025, _a1026 = pcall(function()
return workspace:Raycast(_a1024, Vector3.new(0, -160, 0), _a1021)
end)
if _a1025 and _a1026 then
local _a1027 = _a1026.Position.Y
if math.abs(_a1027 - _a1020) <= 80 then return _a1027 + 4 end
end
return nil
end
function _a585.move.zonePos(_a1028, _a1029)
if not _a1028 then return nil, "존 id 없음" end
_a1028 = _a585.move.realZone(_a1028)
local _a1030 = _a583.DirZones and rawget(_a583.DirZones, _a1028)
local _a1031 = _a1030 and rawget(_a1030, "ZoneFolder")
local _a1032 = {}
do
local _a1033 = workspace:FindFirstChild("__THINGS")
for _a1034, _a1035 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a1036 = _a1033 and _a1033:FindFirstChild(_a1035)
if _a1036 then
for _a1037, _a1038 in ipairs(_a1036:GetChildren()) do
local _a1039
if _a1038:IsA("BasePart") then _a1039 = _a1038.Position
elseif _a1038:IsA("Model") then
local _a1040, _a1041 = pcall(function() return _a1038:GetPivot() end)
if _a1040 and typeof(_a1041) == "CFrame" then _a1039 = _a1041.Position end
end
if _a1039 then _a1032[#_a1032 + 1] = _a1039 end
end
end
end
end
local _a1042 = {}
local function _a1043(_a1044, _a1045)
if not _a1044 then return end
local _a1046, _a1047 = pcall(function() return _a1044:GetDescendants() end)
if _a1044:IsA("BasePart") then _a1042[#_a1042 + 1] = { p = _a1044.Position, why = _a1045 } end
if _a1046 then
for _a1048, _a1049 in ipairs(_a1047) do
if _a1049:IsA("BasePart") then
_a1042[#_a1042 + 1] = { p = _a1049.Position, why = _a1045 .. "/" .. _a1049.Name }
end
end
end
end
if _a583.ZonesU then
for _a1050, _a1051 in ipairs({ "GetBreakableZones", "GetBreakableSpawns" }) do
local _a1052 = rawget(_a583.ZonesU, _a1051)
if type(_a1052) == "function" then
local _a1053, _a1054 = pcall(_a1052, _a1028)
if _a1053 and _a1054 then _a1043(_a1054, _a1051) end
end
end
end
if _a1031 then
for _a1055, _a1056 in ipairs({ "BREAK_ZONES", "BREAKABLE_SPAWNS" }) do
local _a1057, _a1058 = pcall(function() return _a1031:FindFirstChild(_a1056, true) end)
if _a1057 and _a1058 then _a1043(_a1058, "ZoneFolder/" .. _a1056) end
end
end
local _a1059, _a1060, _a1061
for _a1062, _a1063 in ipairs(_a1042) do
local _a1064 = 0
for _a1065, _a1066 in ipairs(_a1032) do
if (_a1066 - _a1063.p).Magnitude <= 150 then _a1064 += 1 end
end
if not _a1060 or _a1064 > _a1060 then _a1059, _a1060, _a1061 = _a1063.p, _a1064, _a1063.why end
end
local _a1067, _a1068
if _a1059 and (_a1060 or 0) >= 1 then
_a1067, _a1068 = _a1059, ("%s (브레이커블 %d개)"):format(tostring(_a1061), _a1060)
end
if not _a1067 and _a1059 then
_a1067, _a1068 = _a1059, tostring(_a1061) .. " (브레이커블 없음)"
end
if not _a1067 and _a583.ZonesU and rawget(_a583.ZonesU, "GetTeleportPartLocation") then
local _a1069, _a1070 = pcall(_a583.ZonesU.GetTeleportPartLocation, _a1028)
if _a1069 and typeof(_a1070) == "CFrame" then
_a1067, _a1068 = _a1070.Position, "PERSISTENT/Teleport (스트리밍 대기)"
end
end
if not _a1067 then return nil, "브레이커블 위치를 못 찾음" end
local _a1071 = _a585.move.groundY(_a1067.X, _a1067.Z, _a1067.Y)
if _a1071 then
_a1067 = Vector3.new(_a1067.X, _a1071, _a1067.Z)
_a1068 = _a1068 .. " +지면"
else
_a1067 = Vector3.new(_a1067.X, _a1067.Y + 5, _a1067.Z)
end
return _a1067, _a1068
end
function _a585.move.goToZone(_a1072, _a1073, _a1074, _a1075)
_a1072 = _a585.move.realZone(_a1072)
if not _a1072 then return false, "존 id 없음" end
local _a1076, _a1077 = _a585.move.zonePos(_a1072)
if not _a1076 then
if _a578.TpGameFallback and _a585.move.curZone() ~= _a1072 then
local _a1078, _a1079 = _a585.move.tpZone(_a1072)
if not _a1078 then return false, _a1079 end
task.wait(0.3)
_a1076, _a1077 = _a585.move.zonePos(_a1072)
end
if not _a1076 then
local _a1080, _a1081 = _a585.move.resolvableZone(_a1072)
if _a1080 and _a1081 then
if _a1075 then
return false, ("%s 가 로드되지 않음"):format(tostring(_a1072))
end
_a1072, _a1076, _a1077 = _a1080, _a1081, "대체 존 " .. tostring(_a1080)
else
if _a585.move.zoneFailSaid ~= _a1072 then
_a585.move.zoneFailSaid = _a1072
_a572(("[TP] %s 좌표 실패: %s (갈 수 있는 존이 없음)"):format(
tostring(_a1072), tostring(_a1077)))
end
return false, _a1077
end
end
end
local _a1082 = _a585.move.hrp()
if not _a1074 and _a1082 and _a585.move.curZone() == _a1072 then
local _a1083 = _a585.move.inDottedBox()
local _a1084
if _a1083 ~= nil then
_a1084 = _a1083
else
_a1084 = (_a1082.Position - _a1076).Magnitude <= (_a578.ZoneArriveDist or 90)
end
if _a1084 then
if _a1073 then _a572("[TP] 이미 " .. _a1072 .. " 사냥터 안에 있음") end
return true
end
end
if _a1073 then
_a572(("[TP] %s 내부 좌표 %s → (%.0f, %.0f, %.0f)"):format(
_a1072, tostring(_a1077), _a1076.X, _a1076.Y, _a1076.Z))
end
local _a1085, _a1086 = _a585.move.glideTo(_a1076)
local _a1087 = _a585.move.hrp()
if _a1087 and (_a1087.Position - _a1076).Magnitude > math.max(40, _a578.ArriveDist or 12) then
task.wait(0.2)
_a585.ctl.moving = nil
_a585.move.glideTo(_a1076)
local _a1088 = _a585.move.hrp()
local _a1089 = _a1088 and (_a1088.Position - _a1076).Magnitude or -1
if _a1089 > math.max(40, _a578.ArriveDist or 12) then
local _a1090 = _a578.TpMode
_a578.TpMode = "glide"
_a585.ctl.moving = nil
_a585.move.glideTo(_a1076)
_a578.TpMode = _a1090
local _a1091 = _a585.move.hrp()
_a1089 = _a1091 and (_a1091.Position - _a1076).Magnitude or -1
if _a1089 > math.max(40, _a578.ArriveDist or 12) then
_a572(("[TP] %s 이동 실패 — %.0f스터드 남음 (순간이동·glide 둘 다)"):format(
tostring(_a1072), _a1089))
return false, "이동이 되돌려짐"
end
_a572("[TP] 순간이동이 막혀서 glide 로 이동함: " .. tostring(_a1072))
end
end
do
local _a1092 = _a585.move.hrp()
if _a1092 and (_a1092.Position.Y - _a1076.Y) > 25 then
_a572(("[TP] 목표보다 %.0f 높은 곳에 얹힘 — 내려감"):format(_a1092.Position.Y - _a1076.Y))
_a585.ctl.moving = nil
_a585.move.glideTo(Vector3.new(_a1076.X, _a1076.Y, _a1076.Z))
end
end
if tostring(_a1077):find("스트리밍", 1, true) then
task.wait(1.2)
local _a1093, _a1094 = _a585.move.zonePos(_a1072)
if _a1093 and not tostring(_a1094):find("스트리밍", 1, true) then
if _a1073 then
_a572("[TP] 스트리밍 로드됨 → 사냥터로 (" .. tostring(_a1094) .. ")")
end
_a585.ctl.moving = nil
_a585.move.glideTo(_a1093)
_a1076, _a1077 = _a1093, _a1094
end
end
if _a585.move.inDottedBox() == false then
task.wait(0.2)
local _a1095, _a1096 = _a585.move.breakCenter(400)
if _a1095 and _a1096 >= 3 then
if _a1073 then
_a572(("[TP] 네모 밖 → 주변 브레이커블 %d개 중심으로 보정"):format(_a1096))
end
_a585.ctl.moving = nil
_a585.move.glideTo(_a1095)
_a1076 = _a1095
end
if _a585.move.inDottedBox() == false then
local _a1097 = _a585.move.zonePos(_a1072)
if _a1097 and (_a1097 - _a1076).Magnitude > 5 then
if _a1073 then _a572("[TP] 아직 네모 밖 → 좌표 재계산 후 재시도") end
_a585.ctl.moving = nil
_a585.move.glideTo(_a1097)
_a1076 = _a1097
end
end
if _a585.move.inDottedBox() == false and _a1073 then
_a572(("[TP] %s 네모 안으로 못 들어감 (좌표 %s)"):format(_a1072, tostring(_a1077)))
end
end
local function _a1098()
if _a585.move.inDottedBox() == true then return false end
local _a1099, _a1100 = _a585.move.breakCenter(400)
if (_a1100 or 0) >= 1 then return false end
task.wait(0.6)
if _a585.move.inDottedBox() == true then return false end
local _a1101, _a1102 = _a585.move.breakCenter(400)
return (_a1102 or 0) < 1
end
if _a1098() and (os.clock() - (_a585.move.lastRecover or -999)) > 30 then
_a585.move.lastRecover = os.clock()
_a572(("[TP] %s 근처에 브레이커블이 없음 (%s) — 좌표 확인 필요"):format(
tostring(_a1072), tostring(_a1077)))
end
_a585.move.zoneFailSaid = nil
_a585.move.arrivedZone = _a1072
do
local _a1103 = _a585.move.hrp()
local _a1104 = _a1103 and (_a1103.Position - _a1076).Magnitude or 0
if _a1104 > math.max(60, _a578.ArriveDist or 12) then
_a572(("[TP] %s 도착 실패 — %.0f스터드 남음 (되돌려짐)"):format(tostring(_a1072), _a1104))
return false, "이동이 되돌려짐"
end
end
local _a1105 = _a585.move.hrp()
if _a1073 and _a1105 then
_a572(("[TP] 도착. 목표까지 %.0f스터드 / 존 %s / 네모안 %s"):format(
(_a1105.Position - _a1076).Magnitude, tostring(_a585.move.curZone()), tostring(_a585.move.inDottedBox())))
end
return true
end
function _a585.egg.tpEgg(_a1106)
if not _a1106 then return false, "알 id 없음" end
for _a1107, _a1108 in ipairs(_a585.egg.eggStands()) do
if _a1108.id == _a1106 then
if _a1108.dist <= _a578.EggRange then return true, _a1106 end
local _a1109, _a1110 = _a585.move.glideTo(_a1108.pos)
return _a1109, _a1109 and _a1106 or _a1110
end
end
if _a578.TpGameFallback then
local _a1111 = _a583.DirEggs and rawget(_a583.DirEggs, _a1106)
local _a1112 = _a1111 and select(1, _a585.move.zoneByNumber(rawget(_a1111, "zoneNumber")))
if _a1112 and _a585.move.curZone() ~= _a1112 then
local _a1113, _a1114 = _a585.move.tpZone(_a1112)
if not _a1113 then return false, _a1114 end
task.wait(0.5)
_a585.egg._standsAt = nil
for _a1115, _a1116 in ipairs(_a585.egg.eggStands()) do
if _a1116.id == _a1106 then return _a585.move.glideTo(_a1116.pos), _a1106 end
end
end
end
return false, "알 받침대를 못 찾음 (" .. tostring(_a1106) .. ")"
end
function _a585.item.stacks(_a1117)
local _a1118 = _a612()
local _a1119 = _a1118 and rawget(_a1118, "Inventory")
local _a1120 = _a1119 and rawget(_a1119, _a1117)
if type(_a1120) ~= "table" then return {} end
local _a1121 = {}
for _a1122, _a1123 in pairs(_a1120) do
if type(_a1123) == "table" then
_a1121[#_a1121 + 1] = {
uid = _a1122,
id = tostring(rawget(_a1123, "id")),
tier = tonumber(rawget(_a1123, "tn")) or 1,
am = tonumber(rawget(_a1123, "_am")) or 1,
}
end
end
return _a1121
end
_a585.item.PERTIER = {
Potion  = { 3, 3, 4, 5, 5, 5, 5, 5, 7, 7, 7 },
Enchant = { 5, 5, 5, 7, 7, 7, 7, 7, 10, 10 },
}
function _a585.item.perTier(_a1124, _a1125)
_a1125 = tonumber(_a1125)
local _a1126 = _a583.Bal and rawget(_a583.Bal,
_a1124 == "Potion" and "CalcPotionsPerTierRequired" or "CalcEnchantsPerTierRequired")
if type(_a1126) == "function" then
local _a1127, _a1128 = pcall(_a1126, _a1125)
_a1128 = _a1127 and tonumber(_a1128) or nil
if _a1128 and _a1128 > 0 then return _a1128 end
if not _a1127 and not _a585.item.perTierWarned then
_a585.item.perTierWarned = true
_a572("[퀘스트] 재료 수량 함수 막힘 → 기본표로 계산 (" .. tostring(_a1128) .. ")")
end
end
local _a1129 = _a585.item.PERTIER[_a1124]
local _a1130 = _a1129 and _a1125 and _a1129[_a1125]
return (_a1130 and _a1130 > 0) and _a1130 or nil
end
function _a585.item.upgradeTo(_a1131, _a1132)
local _a1133 = (_a1131 == "Potion") and _a583.R_PotUp or _a583.R_EncUp
if not _a1133 then return 0, (_a1131 .. " 업글 리모트 없음") end
local _a1134 = math.max(1, (tonumber(_a1132) or 2) - 1)
local _a1135 = _a585.item.perTier(_a1131, _a1134)
if not _a1135 then return 0, ("T%d 재료 수량을 못 읽음"):format(_a1134) end
local _a1136, _a1137 = {}, 0
for _a1138, _a1139 in ipairs(_a585.item.stacks(_a1131)) do
if _a1139.tier == _a1134 then
local _a1140 = math.floor(_a1139.am / _a1135)
if _a1140 > 0 then _a1136[_a1139.uid] = _a1140 _a1137 += _a1140 end
end
end
if _a1137 < 1 then return 0, ("T%d 재료 부족 (T%d %d개당 1개)"):format(_a1134, _a1134, _a1135) end
local _a1141, _a1142
pcall(function() _a1141, _a1142 = _a1133:InvokeServer(_a1136) end)
if not _a1141 then return 0, tostring(_a1142) end
return _a1137
end
function _a585.item.usePotion(_a1143, _a1144)
if not _a583.R_PotUse then return 0, "Potions: Consume 리모트 없음" end
_a1143 = tonumber(_a1143) or 1
local _a1145 = {}
for _a1146, _a1147 in ipairs(_a585.item.stacks("Potion")) do
if _a1147.tier >= _a1143 and _a1147.am >= 1 then _a1145[#_a1145 + 1] = _a1147 end
end
if #_a1145 == 0 then return 0, ("T%d 이상 포션 없음"):format(_a1143) end
table.sort(_a1145, function(_a1148, _a1149) return _a1148.tier < _a1149.tier end)
local _a1150, _a1151 = _a1144, 0
for _a1152, _a1153 in ipairs(_a1145) do
for _a1154 = 1, math.min(_a1150, _a1153.am) do
if _a1150 < 1 or not _a579.quest then break end
pcall(function() _a583.R_PotUse:FireServer(_a1153.uid, 1) end)
_a1151 += 1
_a1150 -= 1
task.wait(0.12)
end
if _a1150 < 1 then break end
end
return _a1151
end
_a585.ev.EVENTKIND = {
[31]="CoinJar",    [37]="CoinJar",    [68]="CoinJar",
[32]="Comet",      [38]="Comet",      [69]="Comet",
[66]="Pinata",     [43]="Pinata",     [70]="Pinata",
[67]="LuckyBlock", [44]="LuckyBlock", [71]="LuckyBlock",
}
_a585.ev.BESTONLY = { [37]=true, [38]=true, [43]=true, [44]=true, [39]=true, [76]=true }
_a585.ev.CHESTKIND = { [8]="MiniChests", [39]="MiniChests", [72]="MiniChests",
[75]="SuperiorMiniChests", [76]="SuperiorMiniChests", [77]="SuperiorMiniChests" }
local function _a1155(_a1156)
if typeof(_a1156) == "Vector3" then return _a1156 end
if typeof(_a1156) == "CFrame" then return _a1156.Position end
if type(_a1156) == "table" then
local _a1157, _a1158, _a1159 = tonumber(_a1156.X or _a1156.x or _a1156[1]), tonumber(_a1156.Y or _a1156.y or _a1156[2]), tonumber(_a1156.Z or _a1156.z or _a1156[3])
if _a1157 and _a1158 and _a1159 then return Vector3.new(_a1157, _a1158, _a1159) end
end
return nil
end
function _a585.ev.events()
local _a1160
if _a583.Rand and rawget(_a583.Rand, "GetActive") then
local _a1161, _a1162 = pcall(_a583.Rand.GetActive)
if _a1161 and type(_a1162) == "table" and next(_a1162) then _a1160 = _a1162 end
end
if not _a1160 and _a583.R_Events then
local _a1163, _a1164 = pcall(function() return _a583.R_Events:InvokeServer() end)
if _a1163 and type(_a1164) == "table" then _a1160 = _a1164 end
end
if type(_a1160) ~= "table" then return {} end
local _a1165 = workspace:GetServerTimeNow()
local _a1166 = {}
for _a1167, _a1168 in pairs(_a1160) do
if type(_a1168) == "table" then
local _a1169 = tostring(rawget(_a1168, "id") or "")
local _a1170 = _a1169:match("|%s*(%S+)%s*$") or _a1169
local _a1171 = tonumber(rawget(_a1168, "started")) or 0
local _a1172 = tonumber(rawget(_a1168, "duration")) or 0
_a1166[#_a1166 + 1] = {
uid = rawget(_a1168, "uid"),
id = _a1169,
kind = _a1170,
name = rawget(_a1168, "name") or _a1170,
zone = rawget(_a1168, "parentID"),
pos = _a1155(rawget(_a1168, "origin")),
left = math.max(0, _a1172 - (_a1165 - _a1171)),
}
end
end
table.sort(_a1166, function(_a1173, _a1174) return _a1173.left > _a1174.left end)
return _a1166
end
_a585.ev.SPAWN = {
CoinJar    = { rem = "CoinJar_Spawn",           key = "coin jar",
order = { "basic", "giant", "magic" } },
Comet      = { rem = "Comet_Spawn",             key = "comet" },
Pinata     = { rem = "MiniPinata_Consume",      key = "pinata" },
LuckyBlock = { rem = "MiniLuckyBlock_Consume",  key = "lucky block" },
}
function _a585.move.inDottedBox()
if _a583.Map and rawget(_a583.Map, "IsInDottedBox") then
local _a1175, _a1176 = pcall(_a583.Map.IsInDottedBox)
if _a1175 then return _a1176 and true or false end
end
return nil
end
function _a585.ev.spawnItems(_a1177)
local _a1178 = _a585.ev.SPAWN[_a1177]
if not _a1178 then return {} end
local _a1179 = {}
for _a1180, _a1181 in ipairs({ "Misc", "Consumable", "Lootbox" }) do
for _a1182, _a1183 in ipairs(_a585.item.stacks(_a1181)) do
local _a1184 = _a1183.id:lower()
if _a1184:find(_a1178.key, 1, true) then
local _a1185 = 99
if _a1178.order then
for _a1186, _a1187 in ipairs(_a1178.order) do
if _a1184:find(_a1187, 1, true) then _a1185 = _a1186 break end
end
end
_a1183.rank = _a1185
_a1179[#_a1179 + 1] = _a1183
end
end
end
table.sort(_a1179, function(_a1188, _a1189)
if _a1188.rank ~= _a1189.rank then return _a1188.rank < _a1189.rank end
return _a1188.tier < _a1189.tier
end)
return _a1179
end
function _a585.ev.spawnEvent(_a1190)
local _a1191 = _a585.ev.SPAWN[_a1190]
if not _a1191 then return 0, "소환 불가 종류" end
local _a1192 = _a576:FindFirstChild(_a1191.rem)
if not _a1192 then return 0, _a1191.rem .. " 리모트 없음" end
local _a1193 = _a585.ev.spawnItems(_a1190)
if #_a1193 == 0 then return 0, _a1190 .. " 아이템 없음" end
local _a1194 = _a585.move.inDottedBox()
if _a1194 == false then return 0, "점선 네모 안이 아님" end
local _a1195, _a1196 = 0, nil
for _a1197, _a1198 in ipairs(_a1193) do
if _a1195 >= (_a578.SpawnPerCycle or 1) or not _a579.quest then break end
local _a1199, _a1200
pcall(function() _a1199, _a1200 = _a1192:InvokeServer(_a1198.uid) end)
if _a1199 then
_a1195 += 1
_a585.ctl.setAct("소환", _a1190 .. " · " .. _a1198.id)
_a572(("  🎁 %s 소환  (%s)"):format(_a1190, _a1198.id))
task.wait(0.4)
else
_a1196 = _a1200
break
end
end
return _a1195, _a1196
end
function _a585.ev.findEvent(_a1201, _a1202)
local _a1203 = _a1202 and _a585.move.bestZone() or nil
local _a1204
for _a1205, _a1206 in ipairs(_a585.ev.events()) do
if _a1206.kind == _a1201 and _a1206.left > 15 then
if not _a1202 or _a1206.zone == _a1203 then
if not _a1204 or (_a1206.zone == _a585.move.curZone() and _a1204.zone ~= _a585.move.curZone()) then
_a1204 = _a1206
end
end
end
end
return _a1204
end
function _a585.ev.findChest(_a1207, _a1208)
local _a1209 = workspace:FindFirstChild("__THINGS")
if not _a1209 then return nil end
local _a1210 = tostring(_a1207):lower():find("superior") ~= nil
local _a1211 = _a585.move.hrp()
local _a1212 = _a1211 and _a1211.Position
local _a1213, _a1214, _a1215, _a1216
for _a1217, _a1218 in ipairs(_a1209:GetChildren()) do
if tostring(_a1218.Name):lower():find("chest", 1, true) then
for _a1219, _a1220 in ipairs(_a1218:GetChildren()) do
local _a1221
if _a1220:IsA("BasePart") then _a1221 = _a1220.Position
elseif _a1220:IsA("Model") then
local _a1222, _a1223 = pcall(function() return _a1220:GetPivot() end)
if _a1222 and typeof(_a1223) == "CFrame" then _a1221 = _a1223.Position end
end
if _a1221 then
local _a1224 = _a1212 and (_a1221 - _a1212).Magnitude or 0
local _a1225 = (tostring(_a1220.Name) .. tostring(_a1218.Name)):lower()
:find("superior", 1, true) ~= nil
if not _a1216 or _a1224 < _a1216 then _a1215, _a1216 = _a1221, _a1224 end
if _a1225 == _a1210 and (not _a1214 or _a1224 < _a1214) then
_a1213, _a1214 = _a1221, _a1224
end
end
end
end
end
if _a1213 then return _a1213, _a1214 end
return _a1215, _a1216
end
_a585.quest.SKIP = { [4] = true, [5] = true, [40] = true, [41] = true }
_a585.quest.WHERE = {
[21]="bestzone", [9]="bestzone", [37]="bestzone", [38]="bestzone", [39]="bestzone",
[43]="bestzone", [44]="bestzone", [76]="bestzone", [30]="bestzone", [8]="bestzone",
[20]="bestegg",  [42]="bestegg",
[1]="breakable", [81]="zoneid",
}
function _a585.item.petStacks()
local _a1226 = _a612()
local _a1227 = _a1226 and rawget(_a1226, "Inventory")
local _a1228 = _a1227 and rawget(_a1227, "Pet")
local _a1229 = {}
if type(_a1228) ~= "table" then return _a1229 end
for _a1230, _a1231 in pairs(_a1228) do
if type(_a1231) == "table" then
_a1229[#_a1229 + 1] = {
uid = _a1230,
id = tostring(rawget(_a1231, "id")),
pt = tonumber(rawget(_a1231, "pt")) or 0,
am = tonumber(rawget(_a1231, "_am")) or 1,
}
end
end
return _a1229
end
function _a585.item.bestEggPets()
local _a1232 = _a660()
local _a1233 = _a1232 and _a583.DirEggs and rawget(_a583.DirEggs, _a1232)
local _a1234 = _a1233 and rawget(_a1233, "pets")
local _a1235 = {}
if type(_a1234) == "table" then
for _a1236, _a1237 in pairs(_a1234) do
local _a1238 = type(_a1237) == "table" and _a1237[1] or _a1237
if _a1238 then _a1235[tostring(_a1238)] = true end
end
end
return _a1235, _a1232
end
function _a585.item.makeVariant(_a1239, _a1240)
local _a1241 = (_a1239 == "gold") and _a583.R_Gold or _a583.R_Rain
if not _a1241 then return 0, (_a1239 .. " 머신 리모트 없음") end
local _a1242 = (_a1239 == "gold") and 0 or 1
local _a1243
if _a1240 then
local _a1244, _a1245 = _a585.item.bestEggPets()
if not next(_a1244) then return 0, "최고 알(" .. tostring(_a1245) .. ") 펫 목록을 못 읽음" end
_a1243 = _a1244
end
local _a1246, _a1247 = 0, nil
for _a1248, _a1249 in ipairs(_a585.item.petStacks()) do
if not _a579.quest then break end
if _a1249.pt == _a1242 and _a1249.am >= 10 and (not _a1243 or _a1243[_a1249.id]) then
local _a1250 = math.floor(_a1249.am / 10)
if _a1250 > 0 then
local _a1251, _a1252
pcall(function() _a1251, _a1252 = _a1241:InvokeServer(_a1249.uid, _a1250) end)
if _a1251 then
_a1246 += _a1250
_a572(("  ✨ %s 제작  %s x%d"):format(
_a1239 == "gold" and "골드" or "레인보우", _a1249.id, _a1250))
task.wait(0.4)
else
_a1247 = _a1252
end
end
end
end
return _a1246, _a1247
end
function _a585.item.useFlag(_a1253)
if not _a583.R_Flag then return 0, "FlexibleFlags_Consume 리모트 없음" end
local _a1254, _a1255 = 0, nil
for _a1256, _a1257 in ipairs(_a585.item.stacks("Misc")) do
if _a1254 >= (_a1253 or 1) then break end
if _a1257.id:lower():find("flag", 1, true) and _a1257.am >= 1 and _a585.item.itemAllowed(_a1257.id) then
local _a1258, _a1259
pcall(function() _a1258, _a1259 = _a583.R_Flag:InvokeServer(_a1257.id, _a1257.uid, 1) end)
if _a1258 then _a1254 += 1 task.wait(0.4) else _a1255 = _a1259 end
end
end
return _a1254, _a1255
end
function _a585.item.useFruit(_a1260)
if not _a583.R_Fruit then return 0, "Fruits: Consume 리모트 없음" end
local _a1261 = _a585.item.activeBuffs("Fruits")
local _a1262 = 0
for _a1263, _a1264 in ipairs(_a585.item.stacks("Fruit")) do
if _a1262 >= (_a1260 or 1) then break end
if _a1264.am >= 1 and _a585.item.itemAllowed(_a1264.id) and not _a1261[_a1264.id] then
pcall(function() _a583.R_Fruit:FireServer(_a1264.uid, 1) end)
_a1262 += 1
task.wait(0.4)
end
end
return _a1262
end
function _a585.quest.status()
local _a1265 = _a612()
if not _a1265 then return nil end
local _a1266 = rawget(_a1265, "Goals")
if type(_a1266) ~= "table" then return { list = {} } end
local _a1267 = {}
for _a1268, _a1269 in pairs(_a1266) do
if type(_a1269) == "table" then
local _a1270 = tonumber(rawget(_a1269, "Type")) or -1
local _a1271
if _a583.Quest and rawget(_a583.Quest, "MakeTitle") then
local _a1272, _a1273 = pcall(_a583.Quest.MakeTitle, _a1269)
if _a1272 then _a1271 = _a1273 end
end
_a1267[#_a1267 + 1] = {
slot = _a1268,
uid = tostring(rawget(_a1269, "UID")),
type = _a1270,
how = _a584[_a1270],
title = _a1271 or ("Type " .. _a1270),
amount = tonumber(rawget(_a1269, "Amount")) or 0,
progress = tonumber(rawget(_a1269, "Progress")) or 0,
stars = tonumber(rawget(_a1269, "Stars")) or 0,
potionTier = tonumber(rawget(_a1269, "PotionTier")),
enchantTier = tonumber(rawget(_a1269, "EnchantTier")),
breakable = rawget(_a1269, "BreakableType") or rawget(_a1269, "BreakableDirID"),
zoneId = rawget(_a1269, "ZoneID"),
where = _a585.quest.WHERE[_a1270] or (_a584[_a1270] == "farm" and "bestzone" or nil),
event = _a585.ev.EVENTKIND[_a1270],
chest = _a585.ev.CHESTKIND[_a1270],
bestOnly = _a585.ev.BESTONLY[_a1270] or false,
ignored = _a585.quest.IGNORE[_a1270],
}
end
end
table.sort(_a1267, function(_a1274, _a1275) return _a1274.stars > _a1275.stars end)
return { list = _a1267, rank = tonumber(rawget(_a1265, "Rank")) or 1,
rankStars = tonumber(rawget(_a1265, "RankStars")) or 0 }
end
_a585.quest.BESTDEP = {
[20]=true, [21]=true, [37]=true, [38]=true, [39]=true,
[43]=true, [44]=true, [76]=true,
}
function _a585.quest.bestDepActive()
local _a1276 = _a585.ctl.lockGoal and _a585.ctl.lockGoal.q
if not _a1276 then return false end
if _a585.quest.IGNORE[_a1276.type] then return false end
if not _a585.quest.BESTDEP[_a1276.type] then return false end
local _a1277 = _a585.quest.findQuest(_a1276.uid)
if not _a1277 or _a1277.progress >= _a1277.amount then return false end
return true, _a1277
end
function _a585.quest.canDo(_a1278, _a1279)
if _a1278.how == "hatch" or _a1278.where == "bestegg" then
local _a1280 = _a685()
if not _a1280 then return false, "알 정보를 못 읽음" end
if not _a1280.price then return true end
if not _a1279 then
if _a1280.canBuy < 1 then
return false, ("돈 부족 — %s 개당 %s %s / 보유 %s"):format(
tostring(_a1280.id), _a573(_a1280.price, 0), tostring(_a1280.currency), _a573(_a1280.have, 0))
end
return true
end
local _a1281 = math.max(1, (_a1278.amount or 1) - (_a1278.progress or 0))
local _a1282 = _a1281
if _a1278.type == 2 or _a1278.type == 42 or _a1278.type == 47 then
_a1282 = math.max(_a1281, _a578.HatchMinAfford or 10)
end
if _a1280.canBuy < _a1282 then
_a585.quest.moneyUntil = os.clock() + math.max(0, _a578.MoneyDwell or 60)
return false, ("돈 모으는 중 — %d개분 필요 / 지금 %d개분 (개당 %s %s)"):format(
_a1282, _a1280.canBuy, _a573(_a1280.price, 0), tostring(_a1280.currency))
end
if _a585.quest.moneyUntil and os.clock() < _a585.quest.moneyUntil then
return false, ("조금 더 벌고 감 (%.0f초 남음)"):format(_a585.quest.moneyUntil - os.clock())
end
_a585.quest.moneyUntil = nil
end
return true
end
function _a585.quest.findQuest(_a1283)
local _a1284 = _a585.quest.status()
for _a1285, _a1286 in ipairs(_a1284 and _a1284.list or {}) do
if _a1286.uid == _a1283 then return _a1286 end
end
return nil
end
function _a585.quest.pursue(_a1287)
local _a1288, _a1289
if _a1287.how == "hatch" then _a1288, _a1289 = _a696, "mhatch"
elseif _a1287.how == "zone" then _a1288, _a1289 = _a655, "zone"
elseif _a1287.how == "gold" or _a1287.how == "rainbow" then
local _a1290 = (_a1287.type == 40 or _a1287.type == 41)
_a1289 = "quest"
_a1288 = function()
local _a1291 = _a585.item.makeVariant("gold", _a1290) or 0
if _a1287.how == "rainbow" then
_a1291 += (_a585.item.makeVariant("rainbow", _a1290) or 0)
end
if _a1291 > 0 then
_a585.ctl.setAct(_a1287.how == "gold" and "골드 합성" or "레인보우 합성", _a1291 .. "마리")
return
end
_a585.ctl.setAct("재료 모으는 중", "최고 알 부화")
local _a1292 = _a579.mhatch
_a579.mhatch = true
pcall(_a696)
_a579.mhatch = _a1292
end
end
local _a1293 = _a1287.progress
local _a1294 = os.clock()
_a585.ctl.setGoal(_a1287.title, ("%d/%d"):format(_a1287.progress, _a1287.amount))
local function _a1295()
if not _a1287.event then return end
local _a1296 = _a585.ev.findEvent(_a1287.event, _a1287.bestOnly)
if _a1296 then
_a585.ctl.setAct(_a1287.event .. " 진행 중", ("%d초 남음"):format(_a1296.left))
if _a1296.pos then
local _a1297 = _a585.move.hrp()
if _a1297 and (_a1297.Position - _a1296.pos).Magnitude > (_a578.EventStayDist or 45) then
_a585.move.glideTo(_a1296.pos)
end
end
return
end
local _a1298, _a1299 = _a585.ev.spawnEvent(_a1287.event)
if _a1298 > 0 then
_a585.ctl.setAct("소환", _a1287.event)
task.wait(0.5)
elseif _a1299 and _a585.ev.spawnErr ~= tostring(_a1299) then
_a585.ev.spawnErr = tostring(_a1299)
_a572("[퀘스트] " .. _a1287.event .. " 소환 실패: " .. tostring(_a1299))
end
end
local _a1300, _a1301 = pcall(function()
while _a579.quest and not _a585.ctl.stopped() do
local _a1302, _a1303 = _a585.quest.canDo(_a1287, false)
if not _a1302 then
_a572(("[퀘스트] %s → 다른 퀘스트 먼저 (%s)"):format(tostring(_a1287.title), tostring(_a1303)))
return
end
_a1295()
if _a1288 then
local _a1304 = _a579[_a1289]
_a579[_a1289] = true
local _a1305, _a1306 = pcall(_a1288)
_a579[_a1289] = _a1304
if not _a1305 then error(_a1306, 0) end
elseif _a1287.event then
task.wait(0.4)
else
task.wait(2)
end
local _a1307 = _a585.quest.findQuest(_a1287.uid)
if not _a1307 then
_a572("[퀘스트] 완료 — " .. tostring(_a1287.title))
return
end
_a585.ctl.setGoal(_a1307.title, ("%d/%d"):format(_a1307.progress, _a1307.amount))
if _a1307.progress >= _a1307.amount then
_a572(("[퀘스트] 달성 %d/%d — %s"):format(_a1307.progress, _a1307.amount, tostring(_a1307.title)))
return
end
if _a1307.progress > _a1293 then
_a1294 = os.clock()
_a572(("[퀘스트] %d/%d  %s"):format(_a1307.progress, _a1307.amount, tostring(_a1307.title)))
end
_a1293 = _a1307.progress
local _a1308 = os.clock() - _a1294
if _a1308 >= math.max(10, _a578.PursueStallSec or 60) then
_a572(("[퀘스트] %.0f초째 진행 없음 (%d/%d) — 다음 단계로: %s"):format(
_a1308, _a1307.progress, _a1307.amount, tostring(_a1307.title)))
return
end
task.wait(0.2)
end
end)
if not _a1300 then _a572("[퀘스트] " .. tostring(_a1287.how) .. " 오류: " .. tostring(_a1301)) end
_a585.ctl.lockGoal = nil
_a585.ctl.setGoal(nil)
end
function _a585.quest.cycle()
do
local _a1309 = _a579.rank
_a579.rank = true
pcall(_a747)
_a579.rank = _a1309
end
local _a1310 = _a585.quest.status()
if not _a1310 then return end
local _a1311, _a1312, _a1313 = false, false, false
local _a1314 = {}
local _a1315 = nil
for _a1316, _a1317 in ipairs(_a1310.list) do
if not _a579.quest then break end
local _a1318, _a1319 = true, nil
if not _a1317.ignored and _a1317.progress < _a1317.amount then
_a1318, _a1319 = _a585.quest.canDo(_a1317, true)
end
if _a1317.ignored then
if _a1317.progress < _a1317.amount then
_a1314[#_a1314 + 1] = tostring(_a1317.title) .. "  — " .. _a1317.ignored
end
elseif not _a1318 then
local _a1320 = tostring(_a1317.uid) .. tostring(_a1319)
if _a585.item.skipSaid ~= _a1320 then
_a585.item.skipSaid = _a1320
_a572(("[퀘스트] 건너뜀: %s   (%s)"):format(tostring(_a1317.title), tostring(_a1319)))
end
elseif _a1317.progress < _a1317.amount then
local _a1321 = _a1317.where
if _a1317.event then
if not _a1315 or _a1315.rank > 0 then _a1315 = { rank = 0, kind = "event", q = _a1317 } end
elseif _a1317.chest then
if not _a1315 or _a1315.rank > 1 then _a1315 = { rank = 1, kind = "chest", q = _a1317 } end
elseif _a1321 == "bestegg" then
if not _a1315 or _a1315.rank > 1 then _a1315 = { rank = 1, kind = "egg", q = _a1317 } end
elseif _a1321 == "breakable" and _a1317.breakable then
if not _a1315 or _a1315.rank > 2 then _a1315 = { rank = 2, kind = "breakable", q = _a1317 } end
elseif _a1321 == "zoneid" and _a1317.zoneId then
if not _a1315 or _a1315.rank > 2 then _a1315 = { rank = 2, kind = "zoneid", q = _a1317 } end
elseif _a1321 == "bestzone" or _a1321 == "breakable" then
if not _a1315 then _a1315 = { rank = 3, kind = "bestzone", q = _a1317 } end
end
if _a1317.how == "farm" then
_a1311 = true
elseif _a1317.how == "hatch" then
_a1312 = true
elseif _a1317.how == "zone" then
_a1313 = true
elseif _a1317.how == "potup" and _a578.QuestUpgrade then
local _a1322, _a1323 = _a585.item.upgradeTo("Potion", _a1317.potionTier or 2)
if _a1322 > 0 then
_a580.potup += _a1322
_a580.quest += 1
_a572(("[퀘스트] 포션 T%d %d개 제작  (%s)"):format(_a1317.potionTier or 2, _a1322, _a1317.title))
elseif _a1323 and not tostring(_a1323):find("부족") then
if _a585.item.potUpSaid ~= tostring(_a1323) then
_a585.item.potUpSaid = tostring(_a1323)
_a572("[퀘스트] 포션 업글 실패: " .. tostring(_a1323))
end
end
elseif _a1317.how == "encup" and _a578.QuestUpgrade then
local _a1324, _a1325 = _a585.item.upgradeTo("Enchant", _a1317.enchantTier or 2)
if _a1324 > 0 then
_a580.potup += _a1324
_a580.quest += 1
_a572(("[퀘스트] 인챈트 T%d %d개 제작  (%s)"):format(_a1317.enchantTier or 2, _a1324, _a1317.title))
elseif _a1325 and not tostring(_a1325):find("부족") then
if _a585.item.encUpSaid ~= tostring(_a1325) then
_a585.item.encUpSaid = tostring(_a1325)
_a572("[퀘스트] 인챈트 업글 실패: " .. tostring(_a1325))
end
end
elseif _a1317.how == "potuse" and _a578.QuestUsePotion then
_a585.item.lastUse = _a585.item.lastUse or {}
local _a1326 = _a585.item.lastUse[_a1317.uid]
if _a1326 and _a1326.used > 0 and _a1317.progress <= _a1326.progress then
if not _a1326.gaveUp then
_a1326.gaveUp = true
_a572("[퀘스트] 포션을 마셔도 진행도가 안 올라서 중단: " .. tostring(_a1317.title))
end
else
local _a1327 = math.min(_a578.QuestUseMax, math.max(1, _a1317.amount - _a1317.progress))
local _a1328, _a1329 = _a585.item.usePotion(_a1317.potionTier or 1, _a1327)
_a585.item.lastUse[_a1317.uid] = { used = _a1328, progress = _a1317.progress }
if _a1328 > 0 then
_a580.potuse += _a1328
_a580.quest += 1
_a572(("[퀘스트] 포션 %d개 사용  (%s)"):format(_a1328, _a1317.title))
elseif _a1329 and not tostring(_a1329):find("없음") then
_a572("[퀘스트] 포션 사용 실패: " .. tostring(_a1329))
end
end
elseif _a1317.how == "gold" or _a1317.how == "rainbow" then
local _a1330, _a1331 = _a585.item.makeVariant(_a1317.how, _a1317.type == 40 or _a1317.type == 41)
if _a1330 > 0 then
_a580.quest += 1
_a572(("[퀘스트] %s 펫 %d마리 제작  (%s)"):format(
_a1317.how == "gold" and "골드" or "레인보우", _a1330, _a1317.title))
elseif _a1331 then
_a572("[퀘스트] " .. _a1317.how .. " 실패: " .. tostring(_a1331))
end
elseif _a1317.how == "fruituse" then
local _a1332 = _a585.item.useFruit(math.max(1, _a1317.amount - _a1317.progress))
if _a1332 > 0 then
_a580.quest += 1
_a572(("[퀘스트] 과일 %d개 사용  (%s)"):format(_a1332, _a1317.title))
end
elseif _a1317.how == "flaguse" then
local _a1333, _a1334 = _a585.item.useFlag(math.max(1, _a1317.amount - _a1317.progress))
if _a1333 > 0 then
_a580.quest += 1
_a572(("[퀘스트] 깃발 %d개 사용  (%s)"):format(_a1333, _a1317.title))
elseif _a1334 then
_a572("[퀘스트] 깃발 실패: " .. tostring(_a1334))
end
elseif not _a1317.how then
_a1314[#_a1314 + 1] = _a1317.title
end
end
end
if _a578.QuestLock and _a585.ctl.lockGoal then
local _a1335
for _a1336, _a1337 in ipairs(_a1310.list) do
if _a1337.uid == _a585.ctl.lockGoal.q.uid and _a1337.progress < _a1337.amount then _a1335 = _a1337 break end
end
if _a1335 then
_a585.ctl.lockGoal.q = _a1335
_a1315 = _a585.ctl.lockGoal
else
if _a585.ctl.lockGoal.q then
_a572("[퀘스트] 완료/교체됨 → 다음 목표로: " .. tostring(_a585.ctl.lockGoal.q.title))
end
_a585.ctl.lockGoal = nil
end
end
if _a578.QuestLock and _a1315 then _a585.ctl.lockGoal = _a1315 end
if _a578.QuestTp and _a1315 and _a579.quest then
local _a1338, _a1339, _a1340
if _a1315.kind == "event" then
local _a1341 = _a585.ev.findEvent(_a1315.q.event, _a1315.q.bestOnly)
if _a1341 then
_a1340 = ("%s @%s (%d초 남음)"):format(_a1341.name, tostring(_a1341.zone), _a1341.left)
if _a1341.pos then _a1338, _a1339 = _a585.move.glideTo(_a1341.pos)
else _a1338, _a1339 = _a585.move.goToZone(_a1341.zone) end
else
local _a1342 = _a1315.q.bestOnly and _a585.move.bestZone() or (_a585.move.curZone() or _a585.move.bestZone())
_a1340 = _a1315.q.event .. " 소환용 " .. tostring(_a1342)
local _a1343 = _a585.move.inDottedBox()
_a1338, _a1339 = _a585.move.goToZone(_a1342, false, _a1343 == false, _a1315.q.bestOnly)
if _a1338 then
local _a1344, _a1345 = _a585.ev.spawnEvent(_a1315.q.event)
if _a1344 < 1 and tostring(_a1345):find("점선") then
_a585.move.goToZone(_a1342, false, true)
task.wait(0.2)
_a1344, _a1345 = _a585.ev.spawnEvent(_a1315.q.event)
end
if _a1344 > 0 then
_a1340 = ("%s %d개 소환 @%s"):format(_a1315.q.event, _a1344, tostring(_a1342))
else
_a1339 = _a1345
_a1338 = false
end
end
end
elseif _a1315.kind == "chest" then
local _a1346 = _a1315.q.bestOnly and _a585.move.bestZone() or _a585.move.curZone()
local _a1347, _a1348 = _a585.ev.findChest(_a1315.q.chest, _a1346)
_a1340 = _a1315.q.chest .. " @" .. tostring(_a1346)
if _a1347 then
if not _a1348 or _a1348 > 20 then _a585.move.glideTo(_a1347) end
_a1338 = true
else
_a1338, _a1339 = _a585.move.goToZone(_a1346)
_a1340 = _a1340 .. " (상자 없음 → 존 가운데)"
end
elseif _a1315.kind == "egg" then
local _a1349 = _a660()
_a1340 = "최고 알 " .. tostring(_a1349)
if _a1349 then _a1338, _a1339 = _a585.egg.tpEgg(_a1349) else _a1339 = "최고 알을 못 찾음" end
elseif _a1315.kind == "breakable" then
local _a1350 = _a585.move.zoneForBreakable(_a1315.q.breakable)
_a1340 = tostring(_a1315.q.breakable) .. " 나오는 존 " .. tostring(_a1350)
if _a1350 then _a1338, _a1339 = _a585.move.goToZone(_a1350, true) else _a1339 = "그 브레이커블이 나오는 존이 없음" end
elseif _a1315.kind == "zoneid" then
_a1340 = "존 " .. tostring(_a1315.q.zoneId)
_a1338, _a1339 = _a585.move.goToZone(_a1315.q.zoneId)
else
local _a1351 = _a585.move.bestZone()
local _a1352 = _a1315.q.bestOnly or _a585.quest.BESTDEP[_a1315.q.type] or false
if _a1351 then _a1338, _a1339 = _a585.move.goToZone(_a1351, true, false, _a1352)
else _a1339 = "최고 존을 못 찾음" end
_a1340 = "최고 존 " .. tostring(_a585.move.arrivedZone or _a1351)
if not _a1338 then _a1339 = _a1351 end
end
if _a1338 then
if _a585.quest.lastGoal ~= _a1340 then
_a585.quest.lastGoal = _a1340
_a572("[퀘스트] " .. _a1340 .. " 으로 이동  (" .. tostring(_a1315.q.title) .. ")")
end
_a585.quest.pursue(_a1315.q)
else
local _a1353 = _a1339 and tostring(_a1339) or "이유 불명"
if _a585.quest.lastFail ~= _a1353 then
_a585.quest.lastFail = _a1353
_a572(("[퀘스트] 진행 못 함: %s   (%s / %s)"):format(
_a1353, tostring(_a1315.kind), tostring(_a1315.q.title)))
_a572(("           현재 존 %s / 최고 존 %s / 점선네모 %s"):format(
tostring(_a585.move.curZone()), tostring(_a585.move.bestZone()), tostring(_a585.move.inDottedBox())))
end
end
end
if _a578.QuestDrive and _a585.auto.turnOn then
if _a1311  then _a585.auto.turnOn("farm",   "파밍 퀘스트 → 자동 파밍") end
if _a1313  then _a585.auto.turnOn("zone",   "존 퀘스트 → 자동 존 해금") end
if _a1312 then _a585.auto.turnOn("mhatch", "부화 퀘스트 → 자동 부화") end
end
if #_a1314 > 0 and not _a585.quest.manualWarned then
_a585.quest.manualWarned = true
_a572("[퀘스트] 수동으로 해야 하는 것:")
for _a1354, _a1355 in ipairs(_a1314) do _a572("    · " .. tostring(_a1355)) end
elseif #_a1314 == 0 then
_a585.quest.manualWarned = false
end
return _a1315 ~= nil
end
local function _a1356(_a1357)
local _a1358 = {}
for _a1359 in tostring(_a1357 or ""):gmatch("[^,]+") do
_a1359 = _a1359:match("^%s*(.-)%s*$")
if _a1359 ~= "" then _a1358[#_a1358 + 1] = _a1359:lower() end
end
return _a1358
end
function _a585.item.itemAllowed(_a1360)
local _a1361 = tostring(_a1360):lower()
for _a1362, _a1363 in ipairs(_a1356(_a578.ItemBlock)) do
if _a1361:find(_a1363, 1, true) then return false end
end
local _a1364 = _a1356(_a578.ItemAllow)
if #_a1364 == 0 then return true end
for _a1365, _a1366 in ipairs(_a1364) do
if _a1361:find(_a1366, 1, true) then return true end
end
return false
end
function _a585.item.activeBuffs(_a1367)
local _a1368 = _a612()
local _a1369 = _a1368 and rawget(_a1368, _a1367)
local _a1370 = {}
if type(_a1369) == "table" then
for _a1371, _a1372 in pairs(_a1369) do
if type(_a1372) == "table" and next(_a1372) then _a1370[_a1371] = true
elseif _a1372 then _a1370[_a1371] = true end
end
end
return _a1370
end
local function _a1373(_a1374, _a1375, _a1376, _a1377)
local _a1378 = _a585.item.activeBuffs(_a1375)
local _a1379 = {}
local _a1380 = { total = 0, act = 0, blocked = 0, few = 0, ok = 0 }
for _a1381, _a1382 in ipairs(_a585.item.stacks(_a1374)) do
_a1380.total += 1
if _a1378[_a1382.id] then _a1380.act += 1
elseif not _a585.item.itemAllowed(_a1382.id) then _a1380.blocked += 1
elseif _a1382.am <= _a578.ItemKeep then _a1380.few += 1
else
_a1380.ok += 1
local _a1383 = _a1379[_a1382.id]
local _a1384
if not _a1383 then _a1384 = true
elseif _a578.BuffHighTier then _a1384 = _a1382.tier > _a1383.tier
else _a1384 = _a1382.tier < _a1383.tier end
if _a1384 then _a1379[_a1382.id] = _a1382 end
end
end
if _a1380.ok == 0 and _a1380.total > 0 then
local _a1385 = ("%s %d종 중 사용 가능 0 (이미걸림 %d / 제외 %d / 재고부족 %d)")
:format(_a1374, _a1380.total, _a1380.act, _a1380.blocked, _a1380.few)
if _a585.item.buffSaid ~= _a1385 then
_a585.item.buffSaid = _a1385
_a572("[아이템] " .. _a1385)
end
elseif _a1380.ok > 0 then
_a585.item.buffSaid = nil
end
local _a1386 = {}
for _a1387, _a1388 in pairs(_a1379) do _a1386[#_a1386 + 1] = _a1388 end
table.sort(_a1386, function(_a1389, _a1390)
if _a1389.tier ~= _a1390.tier then return _a1389.tier > _a1390.tier end
return _a1389.am > _a1390.am
end)
local _a1391 = {}
for _a1392, _a1393 in ipairs(_a1386) do
if not _a579.items then break end
if _a1377 and _a1377.left <= 0 then break end
local _a1394 = pcall(function() _a1376(_a1393.uid, 1) end)
if _a1394 then
_a1391[#_a1391 + 1] = ("%s T%d"):format(_a1393.id, _a1393.tier)
_a580.items += 1
if _a1377 then _a1377.left -= 1 end
task.wait(0.12)
end
end
return _a1391
end
function _a585.item.cycleItems()
local function _a1395()
local _a1396 = {}
if _a578.BuffPotion then _a1396[#_a1396 + 1] = { "Potion", "Potions" } end
if _a578.BuffFruit then _a1396[#_a1396 + 1] = { "Fruit", "Fruits" } end
if _a578.BuffConsumable then _a1396[#_a1396 + 1] = { "Consumable", "Consumables" } end
for _a1397, _a1398 in ipairs(_a1396) do
local _a1399 = _a585.item.activeBuffs(_a1398[2])
for _a1400, _a1401 in ipairs(_a585.item.stacks(_a1398[1])) do
if _a1401.am > _a578.ItemKeep and _a585.item.itemAllowed(_a1401.id) and not _a1399[_a1401.id] then
return true
end
end
end
if _a578.BuffUltimate and _a583.R_Ult then
local _a1402 = _a612()
local _a1403 = _a1402 and rawget(_a1402, "Ultimates")
if type(_a1403) == "table" then
for _a1404 in pairs(_a1403) do
if _a585.item.itemAllowed(_a1404) then
if not (_a583.Ult and rawget(_a583.Ult, "IsCharged")) then return true end
local _a1405, _a1406 = pcall(_a583.Ult.IsCharged, _a1404)
if _a1405 and _a1406 then return true end
end
end
end
end
return false
end
if not _a1395() then return end
if _a578.ItemBestZone then
local _a1407 = _a585.move.bestZone()
if _a1407 and _a585.move.curZone() ~= _a1407 then
if not _a578.ItemTp then
if not _a585.item.itemZoneWarned then
_a585.item.itemZoneWarned = true
_a572(("[아이템] 최고 존(%s)이 아니라 대기 — 현재 %s"):format(
tostring(_a1407), tostring(_a585.move.curZone())))
end
return
end
local _a1408, _a1409 = _a585.move.goToZone(_a1407)
if not _a1408 then
_a572("[아이템] 최고 존 이동 실패: " .. tostring(_a1409))
return
end
_a572("[아이템] 최고 존 " .. tostring(_a1407) .. " 에서 사용")
end
_a585.item.itemZoneWarned = false
end
local _a1410 = {}
local _a1411  = { left = math.max(1, _a578.BuffMaxPotion or 5) }
local _a1412 = { left = math.max(1, _a578.BuffMaxOther or 2) }
if _a578.BuffPotion and _a583.R_PotUse then
local _a1413 = _a1373("Potion", "Potions", function(_a1414, _a1415)
_a583.R_PotUse:FireServer(_a1414, _a1415)
end, _a1411)
for _a1416, _a1417 in ipairs(_a1413) do _a1410[#_a1410 + 1] = "포션 " .. _a1417 end
end
if _a578.BuffFruit and _a583.R_Fruit then
local _a1418 = _a1373("Fruit", "Fruits", function(_a1419, _a1420)
_a583.R_Fruit:FireServer(_a1419, _a1420)
end, _a1412)
for _a1421, _a1422 in ipairs(_a1418) do _a1410[#_a1410 + 1] = "과일 " .. _a1422 end
end
if _a578.BuffConsumable and _a583.R_Cons then
local _a1423 = _a1373("Consumable", "Consumables", function(_a1424, _a1425)
_a583.R_Cons:InvokeServer(_a1424, _a1425)
end, _a1412)
for _a1426, _a1427 in ipairs(_a1423) do _a1410[#_a1410 + 1] = "소모품 " .. _a1427 end
end
if _a578.BuffUltimate and _a583.R_Ult then
local _a1428 = _a612()
local _a1429 = _a1428 and rawget(_a1428, "Ultimates")
if type(_a1429) == "table" then
for _a1430 in pairs(_a1429) do
if not _a579.items then break end
if _a585.item.itemAllowed(_a1430) then
local _a1431 = true
if _a583.Ult and rawget(_a583.Ult, "IsCharged") then
local _a1432, _a1433 = pcall(_a583.Ult.IsCharged, _a1430)
_a1431 = _a1432 and _a1433 and true or false
end
if _a1431 then
local _a1434
pcall(function() _a1434 = _a583.R_Ult:InvokeServer(_a1430) end)
if _a1434 then
_a1410[#_a1410 + 1] = "얼티밋 " .. tostring(_a1430)
_a580.items += 1
task.wait(0.3)
end
end
end
end
end
end
if #_a1410 > 0 then
_a585.ctl.setAct("버프 사용", table.concat(_a1410, ", "))
_a572("[아이템] " .. table.concat(_a1410, ", ") .. " 사용")
end
end
function _a585.mach.slotStatus()
local _a1435 = _a612()
if not _a1435 then return nil end
local _a1436 = tonumber(rawget(_a1435, "PetSlotsPurchased")) or 0
local _a1437 = tonumber(rawget(_a1435, "EggSlotsPurchased")) or 0
local _a1438, _a1439 = 0, 0
if _a583.RankC then
if rawget(_a583.RankC, "GetMaxPurchasableEquipSlots") then
local _a1440, _a1441 = pcall(_a583.RankC.GetMaxPurchasableEquipSlots)
if _a1440 and tonumber(_a1441) then _a1438 = tonumber(_a1441) end
end
if rawget(_a583.RankC, "GetMaxPurchasableEggSlots") then
local _a1442, _a1443 = pcall(_a583.RankC.GetMaxPurchasableEggSlots)
if _a1442 and tonumber(_a1443) then _a1439 = tonumber(_a1443) end
end
end
local _a1444, _a1445
if _a1436 < _a1438 then
_a1444 = _a1436 + 1
if type(_a583.CalcPetS) == "function" then
local _a1446, _a1447 = pcall(_a583.CalcPetS, _a1444)
if _a1446 then _a1445 = tonumber(_a1447) end
end
end
local _a1448, _a1449, _a1450
if _a1437 < _a1439 and _a583.RankC and rawget(_a583.RankC, "GetEggBundle") then
local _a1451, _a1452, _a1453 = pcall(_a583.RankC.GetEggBundle, _a1437 + 1)
if _a1451 and tonumber(_a1452) then
_a1448, _a1449 = tonumber(_a1452), tonumber(_a1453) or 1
if type(_a583.CalcEggS) == "function" then
local _a1454, _a1455 = 0, false
for _a1456 = _a1448 - _a1449 + 1, _a1448 do
local _a1457, _a1458 = pcall(_a583.CalcEggS, _a1456)
if _a1457 and tonumber(_a1458) then _a1454 += tonumber(_a1458) else _a1455 = true end
end
if not _a1455 then _a1450 = _a1454 end
end
end
end
local _a1459
if _a583.Egg and rawget(_a583.Egg, "GetMaxHatch") then
local _a1460, _a1461 = pcall(_a583.Egg.GetMaxHatch)
if _a1460 then _a1459 = tonumber(_a1461) end
end
return {
dia = _a627("Diamonds"),
petOwned = _a1436, petMax = _a1438, petNext = _a1444, petCost = _a1445,
eggOwned = _a1437, eggMax = _a1439, eggEnd = _a1448, eggSize = _a1449, eggCost = _a1450,
maxEquip = tonumber(rawget(_a1435, "MaxPetsEquipped")), maxHatch = _a1459,
}
end
function _a585.move.machinePos(_a1462)
local _a1463
if _a583.Machine and rawget(_a583.Machine, "GetModels") then
local _a1464, _a1465 = pcall(_a583.Machine.GetModels, _a1462)
if _a1464 and type(_a1465) == "table" then
for _a1466, _a1467 in pairs(_a1465) do
if typeof(_a1467) == "Instance" then _a1463 = _a1467 break end
end
end
end
if not _a1463 then
local _a1468, _a1469 = pcall(function()
return game:GetService("CollectionService"):GetTagged("Machine")
end)
if _a1468 then
for _a1470, _a1471 in ipairs(_a1469) do
if _a1471.Name == _a1462 then _a1463 = _a1471 break end
end
end
end
if not _a1463 then return nil end
if _a1463:IsA("BasePart") then return _a1463.Position end
local _a1472, _a1473 = pcall(function() return _a1463:GetPivot() end)
return (_a1472 and typeof(_a1473) == "CFrame") and _a1473.Position or nil
end
function _a585.mach.cycleSlots()
local _a1474 = 0
local _a1475 = 0
while _a579.slots and not _a585.ctl.stopped() and _a1475 < 40 do
_a1475 += 1
local _a1476 = _a585.mach.slotStatus()
if not _a1476 then return end
local _a1477 = _a578.SlotPet and _a1476.petNext and _a1476.petCost
and (_a1476.dia - _a578.SlotReserve) >= _a1476.petCost
local _a1478 = _a578.SlotEgg and _a1476.eggEnd and _a1476.eggCost
and (_a1476.dia - _a578.SlotReserve) >= _a1476.eggCost
if _a1477 and _a1478 then
if _a1476.eggCost < _a1476.petCost then _a1477 = false else _a1478 = false end
end
if not (_a1477 or _a1478) then break end
local _a1479, _a1480, _a1481, _a1482
local function _a1483()
if _a1477 then
pcall(function() _a1479, _a1480 = _a583.R_PetSlot:InvokeServer(_a1476.petNext) end)
else
pcall(function() _a1479, _a1480 = _a583.R_EggSlot:InvokeServer(_a1476.eggEnd) end)
end
end
if _a1477 then
_a1481 = ("펫 장착 슬롯 #%d (%s 다이아)"):format(_a1476.petNext, _a573(_a1476.petCost, 0))
_a1482 = "EquipSlotsMachine"
else
_a1481 = ("알 부화 슬롯 %d칸 → %d (%s 다이아)"):format(
_a1476.eggSize, _a1476.eggEnd, _a573(_a1476.eggCost, 0))
_a1482 = "EggSlotsMachine"
end
_a1483()
if not _a1479 and tostring(_a1480):find("far away") then
local _a1484 = _a585.move.machinePos(_a1482)
if _a1484 then
_a585.ctl.setAct("슬롯 머신으로 이동", _a1482)
_a585.move.glideTo(_a1484)
task.wait(0.25)
_a1479, _a1480 = nil, nil
_a1483()
else
_a1480 = "머신 위치를 못 찾음 (" .. _a1482 .. ")"
end
end
if _a1479 then
_a1474 += 1
_a580.mslot += 1
_a585.mach.slotSaid = nil
_a585.ctl.setAct("슬롯 구매", _a1481)
_a572("  ⬆ " .. _a1481)
task.wait(0.35)
else
local _a1485 = _a1481 .. " 실패: " .. tostring(_a1480)
if _a585.mach.slotSaid ~= _a1485 then
_a585.mach.slotSaid = _a1485
_a572("[슬롯] " .. _a1485)
end
break
end
end
if _a1474 > 0 then
local _a1486 = _a585.mach.slotStatus()
_a572(("[슬롯] %d개 구매 — 장착 %s / 한번에 %s개 부화 (다이아 %s 남음)"):format(
_a1474, tostring(_a1486 and _a1486.maxEquip), tostring(_a1486 and _a1486.maxHatch),
_a573(_a627("Diamonds"), 0)))
end
end
function _a585.mach.upgList()
local _a1487 = {}
if not _a583.Upg then return _a1487 end
local _a1488, _a1489 = pcall(_a583.Upg.All)
if not (_a1488 and type(_a1489) == "table") then return _a1487 end
for _a1490, _a1491 in ipairs(_a1489) do
local _a1492, _a1493, _a1494 = rawget(_a1491, "UpgradeID"), rawget(_a1491, "ZoneID"), rawget(_a1491, "UpgradeTier")
if _a1492 and _a1493 and _a1494 then
local _a1495 = false
if rawget(_a583.Upg, "Owns") then
local _a1496, _a1497 = pcall(_a583.Upg.Owns, _a1492, _a1493)
_a1495 = _a1496 and _a1497 and true or false
end
local _a1498 = _a585.move.ownsZone(_a1493)
local _a1499 = _a583.DirUpg and rawget(_a583.DirUpg, _a1492)
local _a1500 = _a1499 and rawget(_a1499, "TierCosts")
local _a1501 = _a1500 and tonumber(_a1500[_a1494])
local _a1502 = "Diamonds"
local _a1503 = _a1499 and rawget(_a1499, "TierCurrencies")
local _a1504 = _a1503 and _a1503[_a1494]
if type(_a1504) == "table" and rawget(_a1504, "_id") then _a1502 = rawget(_a1504, "_id") end
local _a1505 = rawget(_a1491, "Model")
local _a1506
if typeof(_a1505) == "Instance" then
if _a1505:IsA("BasePart") then _a1506 = _a1505.Position
else
local _a1507, _a1508 = pcall(function() return _a1505:GetPivot() end)
if _a1507 and _a1508 then _a1506 = _a1508.Position end
end
end
_a1487[#_a1487 + 1] = {
id = _a1492, zone = _a1493, tier = _a1494, cost = _a1501, cur = _a1502,
bought = _a1495, zoneOwned = _a1498,
buyable = _a1498 and not _a1495,
pos = _a1506, model = _a1505,
}
end
end
table.sort(_a1487, function(_a1509, _a1510) return (_a1509.cost or math.huge) < (_a1510.cost or math.huge) end)
return _a1487
end
function _a585.mach.cycleUpg()
if not _a583.R_Upg then _a572("[맵업글] Upgrades_Purchase 리모트 없음") return end
local _a1511 = _a585.mach.upgList()
if #_a1511 == 0 then return end
local _a1512 = 0
for _a1513, _a1514 in ipairs(_a1511) do
if not _a579.mapupg then break end
if _a1514.buyable and _a1514.cost then
local _a1515 = _a627(_a1514.cur or "Diamonds")
if _a1515 - _a578.UpgReserve < _a1514.cost then break end
if _a578.UpgTp and _a1514.pos and _a1514.zone == _a585.move.curZone() then
_a585.move.glideTo(_a1514.pos)
end
local _a1516, _a1517
pcall(function() _a1516, _a1517 = _a583.R_Upg:InvokeServer(_a1514.id, _a1514.zone) end)
if _a1516 then
_a1512 += 1
_a580.mapupg += 1
_a585.ctl.setAct("맵 업글", _a1514.id .. " T" .. _a1514.tier)
_a572(("  ▲ 맵업글  %s T%d  @%s   (%s 다이아)"):format(
_a1514.id, _a1514.tier, _a1514.zone, _a573(_a1514.cost, 0)))
elseif _a1517 then
_a572(("[맵업글] %s T%d @%s 실패: %s"):format(
_a1514.id, _a1514.tier, _a1514.zone, tostring(_a1517)))
end
task.wait(_a578.ActionGap)
end
end
if _a1512 > 0 then
_a572(("[맵업글] %d개 구매  (다이아 %s 남음)"):format(_a1512, _a573(_a627("Diamonds"), 0)))
end
end
local function _a1518()
local _a1519 = _a612()
if not _a1519 then return nil end
local _a1520 = tonumber(rawget(_a1519, "Rebirths")) or 0
local _a1521 = _a1520 + 1
local _a1522
if _a583.Rebirth and rawget(_a583.Rebirth, "GetNextRebirth") then
local _a1523, _a1524 = pcall(_a583.Rebirth.GetNextRebirth, _a1519)
if _a1523 then _a1522 = _a1524 end
end
return { current = _a1520, nextN = _a1521, def = _a1522 }
end
local function _a1525()
if not _a583.R_Reb then _a572("[리버스] Rebirth_Request 리모트 없음") return end
local _a1526 = _a1518()
if not _a1526 then
_a585.auto.rebNote = "세이브를 못 읽음"
return
end
local _a1527, _a1528
pcall(function() _a1527, _a1528 = _a583.R_Reb:InvokeServer(_a1526.nextN) end)
if _a1527 then
_a580.mreb += 1
_a585.auto.rebNote, _a585.auto.rebSaid = nil, nil
_a572(("  ★ 리버스 %d → %d"):format(_a1526.current, _a1526.nextN))
task.wait(0.5)
_a585.screen.dismissRewardScreens(25)
else
_a585.auto.rebNote = ("%d → %d : %s"):format(_a1526.current, _a1526.nextN,
_a1528 and tostring(_a1528) or "조건 미달 (리버스 킬/존 요구치)")
if _a585.auto.rebSaid ~= _a585.auto.rebNote then
_a585.auto.rebSaid = _a585.auto.rebNote
_a572("[리버스] " .. _a585.auto.rebNote)
end
end
end
_a585.auto.SIDE = {
{ key = "unlock", label = "알 해금",   run = "mhatch", fn = function() _a585.egg.unlockEggs() end },
{ key = "slots",  label = "슬롯 머신", run = "slots",  fn = function() _a585.mach.cycleSlots() end },
{ key = "mapupg", label = "맵 업그레이드", run = "mapupg", fn = function() _a585.mach.cycleUpg() end },
{ key = "items",  label = "버프 유지",     run = "items",  fn = function() _a585.item.cycleItems() end },
}
_a585.auto.STEPS = {
{ key = "mreb",   label = "리버스",  run = "mreb",  fn = function() _a1525() end,
hold = true },
{ key = "zone",   label = "존 해금", run = "zone",  fn = function() _a655() end,
hold = true },
{ key = "quest",  label = "랭크 퀘스트+보상", run = "quest", fn = function()
local _a1529 = _a579.farm
_a579.farm = true
pcall(_a637)
_a579.farm = _a1529
local _a1530 = _a585.quest.cycle()
if not _a1530 then
local _a1531 = _a585.move.bestZone()
if _a1531 then
local _a1532, _a1533 = _a585.move.goToZone(_a1531)
if not _a1532 then
if _a1533 and _a585.auto.idleMoveSaid ~= tostring(_a1533) then
_a585.auto.idleMoveSaid = tostring(_a1533)
_a572("[자동] 최고 존 이동 실패: " .. tostring(_a1533))
end
else
_a585.auto.idleMoveSaid = nil
end
end
if not _a578.IdleHatch then
_a585.ctl.setAct("파밍 중", ("퀘스트 없음 @%s"):format(tostring(_a585.move.curZone())))
return
end
local _a1534 = _a685()
local _a1535 = math.max(1, _a578.HatchMinAfford or 10)
if _a1534 and _a1534.price and _a1534.canBuy < _a1535 then
_a585.ctl.setAct("돈 버는 중", ("%s  %d/%d개분  개당 %s %s"):format(
tostring(_a585.move.curZone()), _a1534.canBuy, _a1535,
_a573(_a1534.price, 0), tostring(_a1534.currency)))
else
_a585.ctl.setAct("대기 중 부화")
local _a1536 = _a579.mhatch
_a579.mhatch = true
pcall(_a696)
_a579.mhatch = _a1536
end
end
end },
}
_a578.StepOn = {}
for _a1537, _a1538 in ipairs(_a585.auto.SIDE) do _a578.StepOn[_a1538.key] = true end
for _a1539, _a1540 in ipairs(_a585.auto.STEPS) do _a578.StepOn[_a1540.key] = true end
local function _a1541(_a1542, _a1543, _a1544, _a1545)
if not _a578.StepOn[_a1542.key] then
_a1545[#_a1545 + 1] = ("%-14s 꺼져있음"):format(_a1542.label)
return
end
if _a1542.hold and _a1543 then
_a1545[#_a1545 + 1] = ("%-14s 보류 (%s)"):format(
_a1542.label, _a1544 and tostring(_a1544.title) or "?")
if _a585.auto.heldMsg ~= _a1542.key then
_a585.auto.heldMsg = _a1542.key
_a572(("[자동] %s 보류 — best 존이 바뀌면 깨지는 퀘스트 진행 중 (%s)"):format(
_a1542.label, _a1544 and tostring(_a1544.title) or "?"))
end
return
end
if _a1542.hold then _a585.auto.heldMsg = nil end
_a585.auto.step = _a1542.label
_a585.ctl.now.step = _a1542.label
_a585.ctl.setAct("시작", _a1542.label)
local _a1546 = os.clock()
local _a1547 = _a579[_a1542.run]
_a579[_a1542.run] = true
local _a1548, _a1549 = pcall(_a1542.fn)
_a579[_a1542.run] = _a1547
local _a1550 = os.clock() - _a1546
if not _a1548 then
_a1545[#_a1545 + 1] = ("%-14s 오류: %s"):format(_a1542.label, tostring(_a1549))
_a572("[자동] " .. _a1542.label .. " 오류: " .. tostring(_a1549))
else
local _a1551 = (_a1542.key == "zone" and _a585.auto.zoneNote)
or (_a1542.key == "mreb" and _a585.auto.rebNote) or nil
_a1545[#_a1545 + 1] = ("%-14s 실행 %.1f초%s"):format(
_a1542.label, _a1550, _a1551 and ("  → " .. _a1551) or "")
end
end
function _a585.auto.master()
local _a1552 = {}
_a585.auto.lastTrace = _a1552
_a585.auto.lastPassAt = os.clock()
if _a585.screen.rewardScreenUp() then
_a1552[#_a1552 + 1] = "보상 화면 넘기는 중"
_a585.screen.dismissRewardScreens(15)
end
for _a1553, _a1554 in ipairs(_a585.auto.SIDE) do
if not _a579.auto or _a585.ctl.stopped() then return end
_a1541(_a1554, false, nil, _a1552)
end
local _a1555, _a1556 = false, nil
if _a578.HoldZoneForQuest then _a1555, _a1556 = _a585.quest.bestDepActive() end
for _a1557, _a1558 in ipairs(_a585.auto.STEPS) do
if not _a579.auto or _a585.ctl.stopped() then break end
_a1541(_a1558, _a1555, _a1556, _a1552)
end
_a585.auto.step = nil
if not _a585.ctl.lockGoal then
_a585.ctl.now.step = "대기"
_a585.ctl.setAct("다음 바퀴 대기", ("%.0f초 주기"):format(_a578.AutoInterval or 5))
end
local _a1559 = {}
for _a1560, _a1561 in ipairs(_a1552) do _a1559[#_a1559 + 1] = (_a1561:gsub("[%d%.]+초", "")) end
_a1559 = table.concat(_a1559, " | ")
if _a1559 ~= _a585.auto.lastSig then
_a585.auto.lastSig = _a1559
_a572("[자동] 바퀴 " .. (_a585.auto.passN or 0))
for _a1562, _a1563 in ipairs(_a1552) do _a572("    " .. _a1563) end
end
_a585.auto.passN = (_a585.auto.passN or 0) + 1
end
local function _a1564()
if not _a577.R_PROMO then _a572("[타워업글] 리모트 없음") return end
local _a1565 = _a581()
if not _a1565 then return end
local _a1566 = _a582(_a1565)
table.sort(_a1566, function(_a1567, _a1568) return (_a1567.dps or 0) > (_a1568.dps or 0) end)
local _a1569, _a1570 = 0, 0
for _a1571, _a1572 in ipairs(_a1566) do
if not _a579.towerup then break end
if _a1572.id then
local _a1573
pcall(function() _a1573 = _a577.R_PROMO:InvokeServer(_a1572.id) end)
if _a1573 ~= nil and _a1573 ~= false then
_a1569 += 1
_a572(("  ▲ 타워업글  %s  Lv%s → Lv%s"):format(tostring(_a1572.kind), tostring(_a1572.up), tostring((_a1572.up or 0) + 1)))
_a1570 = 0
task.wait(_a578.ActionGap)
else
_a1570 += 1
if _a1570 >= 5 then break end
end
end
end
_a572("[타워업글] " .. _a1569 .. "건")
end
local _a1574 = {}
local _a1575 = {}
local function _a1576(_a1577, _a1578)
local _a1579 = tostring(_a1578)
local _a1580 = _a1575[_a1577]
if _a1580 and _a1580.msg == _a1579 then
_a1580.n += 1
if _a1580.n % 20 == 0 then
_a572(("[%s 오류] %s   (%d회 반복)"):format(_a1577, _a1579, _a1580.n))
end
return
end
_a1575[_a1577] = { msg = _a1579, n = 1 }
_a572("[" .. _a1577 .. " 오류] " .. _a1579)
end
local function _a1581(_a1582, _a1583, _a1584, _a1585)
_a1574[_a1582] = (_a1574[_a1582] or 0) + 1
local _a1586 = _a1574[_a1582]
task.spawn(function()
while _a579[_a1582] and _a1574[_a1582] == _a1586 do
local _a1587, _a1588 = pcall(_a1584)
if not _a1587 then _a1576(_a1585, _a1588) else _a1575[_a1585] = nil end
local _a1589, _a1590 = _a1583(), 0
while _a1590 < _a1589 and _a579[_a1582] and _a1574[_a1582] == _a1586 do task.wait(0.1) _a1590 += 0.1 end
end
if _a1574[_a1582] == _a1586 then _a572("[" .. _a1585 .. "] 중지") end
end)
end
do
local _a1591 = {
farm   = { function() return _a578.FarmInterval end,      function() _a637() end,      "파밍" },
zone   = { function() return _a578.ZoneInterval end,      function() _a655() end,      "존" },
mhatch = { function() return _a578.MainHatchInterval end, function() _a696() end, "부화" },
}
function _a585.auto.turnOn(_a1592, _a1593)
if _a579.auto then return end
if _a579[_a1592] then return end
local _a1594 = _a1591[_a1592]
if not _a1594 then return end
_a579[_a1592] = true
_a1581(_a1592, _a1594[1], _a1594[2], _a1594[3])
if _a585.auto.refresh then _a585.auto.refresh() end
_a572("[퀘스트] " .. tostring(_a1593) .. " ON")
end
end
_a568.MG, _a568.QS, _a568.saveGet, _a568.currencyAmount, _a568.cycleFarm, _a568.zoneStatus = _a583, _a585, _a612, _a627, _a637, _a651
_a568.cycleZone, _a568.bestMainEgg, _a568.mainHatchStatus, _a568.cycleMainHatch, _a568.mainRebirthStatus, _a568.cycleMainRebirth = _a655, _a660, _a685, _a696, _a1518, _a1525
_a568.cycleTowerUp, _a568.startLoop = _a1564, _a1581
end)(_a1)
;(function(_a1595)
local _a1596, _a1597, _a1598, _a1599, _a1600, _a1601, _a1602 = _a1595.UIS, _a1595.RunService, _a1595.LP, _a1595.LOG, _a1595.log, _a1595.num, _a1595.LB
local _a1603, _a1604, _a1605, _a1606, _a1607, _a1608 = _a1595.RM, _a1595.CFG, _a1595.EGG_COST_CACHE, _a1595.RUN, _a1595.STAT, _a1595.EVENT_UPGRADES
local _a1609, _a1610, _a1611, _a1612, _a1613, _a1614 = _a1595.ctx, _a1595.collectSlots, _a1595.placedTowers, _a1595.availableItems, _a1595.cyclePlace, _a1595.cycleMerchant
local _a1615, _a1616, _a1617, _a1618, _a1619, _a1620 = _a1595.sunflowers, _a1595.eventTiers, _a1595.nextCost, _a1595.cycleUpgrade, _a1595.seedInv, _a1595.bedsOf
local _a1621, _a1622, _a1623, _a1624, _a1625, _a1626 = _a1595.isUnhatched, _a1595.bedCps, _a1595.cycleCrop, _a1595.laneCosts, _a1595.lockedBeds, _a1595.cycleExpand
local _a1627, _a1628, _a1629, _a1630, _a1631 = _a1595.rebirthStatus, _a1595.cycleRebirth, _a1595.hatchStatus, _a1595.cycleHatch, _a1595.LUCK_ORDER
local _a1632, _a1633, _a1634, _a1635, _a1636, _a1637 = _a1595.luckStatus, _a1595.fmtDur, _a1595.cycleLuck, _a1595.MG, _a1595.QS, _a1595.saveGet
local _a1638, _a1639, _a1640, _a1641, _a1642, _a1643 = _a1595.currencyAmount, _a1595.cycleFarm, _a1595.zoneStatus, _a1595.cycleZone, _a1595.bestMainEgg, _a1595.mainHatchStatus
local _a1644, _a1645, _a1646, _a1647, _a1648 = _a1595.cycleMainHatch, _a1595.mainRebirthStatus, _a1595.cycleMainRebirth, _a1595.cycleTowerUp, _a1595.startLoop
local _a1649 = {
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
local function _a1650(_a1651, _a1652, _a1653)
local _a1654 = Instance.new(_a1651)
for _a1655, _a1656 in pairs(_a1652) do _a1654[_a1655] = _a1656 end
if _a1653 then _a1654.Parent = _a1653 end
return _a1654
end
local function _a1657(_a1658, _a1659) _a1650("UICorner", { CornerRadius = UDim.new(0, _a1659 or 8) }, _a1658) end
local function _a1660(_a1661, _a1662, _a1663)
_a1650("UIStroke", { Color = _a1662 or _a1649.line, Thickness = _a1663 or 1,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, _a1661)
end
local function _a1664(_a1665, _a1666)
_a1650("UIPadding", {
PaddingTop = UDim.new(0, _a1666), PaddingBottom = UDim.new(0, _a1666),
PaddingLeft = UDim.new(0, _a1666), PaddingRight = UDim.new(0, _a1666),
}, _a1665)
end
local _a1667 = _a1650("ScreenGui", {
Name = "PS99GardenAuto", ResetOnSpawn = false,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
IgnoreGuiInset = true, DisplayOrder = 9999,
})
local _a1668 = false
if type(gethui) == "function" then _a1668 = pcall(function() _a1667.Parent = gethui() end) end
if not _a1668 then _a1668 = pcall(function() _a1667.Parent = game:GetService("CoreGui") end) end
if not _a1668 then _a1667.Parent = _a1598:WaitForChild("PlayerGui") end
local _a1669, _a1670 = 780, 520
local _a1671 = _a1650("Frame", {
Size = UDim2.fromOffset(_a1669, _a1670), Position = UDim2.new(0.5, -_a1669 / 2, 0.5, -_a1670 / 2),
BackgroundColor3 = _a1649.bg, BorderSizePixel = 0, Active = true, ClipsDescendants = true,
}, _a1667)
_a1657(_a1671, 12)
_a1660(_a1671, Color3.fromRGB(60, 66, 82), 1)
local _a1672 = _a1650("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = _a1649.panel, BorderSizePixel = 0,
}, _a1671)
_a1657(_a1672, 12)
_a1650("Frame", {
Size = UDim2.new(1, 0, 0, 12), Position = UDim2.new(0, 0, 1, -12),
BackgroundColor3 = _a1649.panel, BorderSizePixel = 0,
}, _a1672)
_a1650("Frame", {
Size = UDim2.fromOffset(10, 10), Position = UDim2.fromOffset(14, 15),
BackgroundColor3 = _a1649.good, BorderSizePixel = 0,
}, _a1672).Name = "Dot"
_a1657(_a1672:FindFirstChild("Dot"), 5)
_a1650("TextLabel", {
Size = UDim2.new(0, 320, 1, 0), Position = UDim2.fromOffset(32, 0),
BackgroundTransparency = 1, Text = "Garden Defenders  AutoPlay",
TextColor3 = _a1649.text, TextSize = 14, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1672)
local function _a1673(_a1674, _a1675, _a1676, _a1677)
local _a1678 = _a1650("TextButton", {
Size = UDim2.new(0, _a1677, 0, 24), Position = UDim2.new(1, _a1676, 0, 8),
BackgroundColor3 = _a1675, BorderSizePixel = 0, Text = _a1674,
TextColor3 = _a1649.text, TextSize = 12, Font = Enum.Font.GothamMedium,
AutoButtonColor = true,
}, _a1672)
_a1657(_a1678, 6)
return _a1678
end
local _a1679 = _a1673("✕", _a1649.bad, -38, 28)
local _a1680   = _a1673("—", _a1649.card, -70, 28)
local _a1681 = _a1673("지우기", _a1649.card, -132, 58)
local _a1682  = _a1673("복사", _a1649.accent, -190, 54)
local _a1683  = _a1673("정지", _a1649.bad, -252, 58)
_a1683.MouseButton1Click:Connect(function()
task.spawn(function()
_a1636.ctl.stopAll()
if _a1636.auto.refresh then pcall(_a1636.auto.refresh) end
_a1600("[정지] 모든 동작을 멈췄습니다")
end)
end)
local _a1684 = _a1650("ScrollingFrame", {
Size = UDim2.new(0, 152, 1, -92), Position = UDim2.fromOffset(10, 48),
BackgroundColor3 = _a1649.panel, BorderSizePixel = 0,
ScrollBarThickness = 3, ScrollBarImageColor3 = _a1649.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1671)
_a1657(_a1684, 8)
_a1650("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, _a1684)
_a1650("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }, _a1684)
local _a1685 = _a1650("Frame", {
Size = UDim2.new(1, -182, 1, -92), Position = UDim2.fromOffset(172, 48),
BackgroundTransparency = 1,
}, _a1671)
local _a1686, _a1687 = {}, nil
local _a1688, _a1689 = {}, {}
local _a1690 = {}
local function _a1691(_a1692)
_a1687 = _a1692
for _a1693, _a1694 in pairs(_a1686) do _a1694.Visible = (_a1693 == _a1692) end
for _a1695, _a1696 in pairs(_a1688) do
local _a1697 = (_a1695 == _a1692)
_a1696.BackgroundColor3 = _a1697 and _a1649.accent or _a1649.panel
_a1696.TextColor3 = _a1697 and Color3.fromRGB(255, 255, 255) or _a1649.dim
end
local _a1698 = _a1689[_a1692]
if _a1698 and _a1690[_a1698] and not _a1690[_a1698].open then _a1690[_a1698].toggle() end
end
local function _a1699(_a1700, _a1701, _a1702)
local _a1703 = { open = true, kids = {} }
local _a1704 = _a1650("TextButton", {
Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = _a1649.bg, BorderSizePixel = 0,
Text = "", TextColor3 = _a1649.dim, TextSize = 11,
Font = Enum.Font.GothamBold, LayoutOrder = _a1702, AutoButtonColor = false,
}, _a1684)
_a1657(_a1704, 5)
local _a1705 = _a1650("TextLabel", {
Size = UDim2.fromOffset(14, 26), Position = UDim2.fromOffset(6, 0),
BackgroundTransparency = 1, Text = "▾", TextColor3 = _a1649.dim,
TextSize = 10, Font = Enum.Font.GothamBold,
}, _a1704)
_a1650("TextLabel", {
Size = UDim2.new(1, -22, 1, 0), Position = UDim2.fromOffset(20, 0),
BackgroundTransparency = 1, Text = _a1701, TextColor3 = _a1649.dim,
TextSize = 11, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1704)
function _a1703.toggle()
_a1703.open = not _a1703.open
_a1705.Text = _a1703.open and "▾" or "▸"
for _a1706, _a1707 in ipairs(_a1703.kids) do _a1707.Visible = _a1703.open end
end
_a1704.MouseButton1Click:Connect(_a1703.toggle)
_a1690[_a1700] = _a1703
return _a1703
end
local function _a1708(_a1709, _a1710, _a1711, _a1712)
local _a1713 = _a1712 and 14 or 6
local _a1714 = _a1650("TextButton", {
Size = UDim2.new(1, 0, 0, 27), BackgroundColor3 = _a1649.panel, BorderSizePixel = 0,
Text = "", TextColor3 = _a1649.dim, TextSize = 12,
Font = Enum.Font.GothamMedium, LayoutOrder = _a1711, AutoButtonColor = false,
}, _a1684)
_a1657(_a1714, 5)
local _a1715 = _a1650("TextLabel", {
Size = UDim2.new(1, -_a1713 - 4, 1, 0), Position = UDim2.fromOffset(_a1713, 0),
BackgroundTransparency = 1, Text = _a1710, TextColor3 = _a1649.dim,
TextSize = 12, Font = Enum.Font.GothamMedium,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1714)
_a1688[_a1709] = _a1714
if _a1712 then
_a1689[_a1709] = _a1712
local _a1716 = _a1690[_a1712]
if _a1716 then
table.insert(_a1716.kids, _a1714)
_a1714.Visible = _a1716.open
end
end
local _a1717 = _a1650("ScrollingFrame", {
Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false,
BorderSizePixel = 0, ScrollBarThickness = 4,
ScrollBarImageColor3 = _a1649.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1685)
_a1650("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, _a1717)
_a1650("UIPadding", { PaddingRight = UDim.new(0, 8) }, _a1717)
_a1686[_a1709] = _a1717
_a1714.MouseButton1Click:Connect(function() _a1691(_a1709) end)
_a1714.MouseEnter:Connect(function()
if _a1687 ~= _a1709 then _a1714.BackgroundColor3 = _a1649.card end
end)
_a1714.MouseLeave:Connect(function()
if _a1687 ~= _a1709 then _a1714.BackgroundColor3 = _a1649.panel end
end)
_a1714:GetPropertyChangedSignal("TextColor3"):Connect(function()
_a1715.TextColor3 = _a1714.TextColor3
end)
return _a1717
end
local _a1718 = 0
local function _a1719()
_a1718 += 1
return _a1718
end
local function _a1720(_a1721, _a1722)
local _a1723 = _a1650("Frame", {
Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, LayoutOrder = _a1719(),
}, _a1721)
_a1650("Frame", {
Size = UDim2.fromOffset(3, 14), Position = UDim2.fromOffset(0, 7),
BackgroundColor3 = _a1649.accent, BorderSizePixel = 0,
}, _a1723)
_a1650("TextLabel", {
Size = UDim2.new(1, -12, 1, 0), Position = UDim2.fromOffset(10, 0),
BackgroundTransparency = 1, Text = _a1722, TextColor3 = _a1649.text,
TextSize = 13, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1723)
return _a1723
end
local function _a1724(_a1725, _a1726, _a1727)
local _a1728 = _a1650("Frame", {
Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundColor3 = _a1649.card, BorderSizePixel = 0, LayoutOrder = _a1719(),
}, _a1725)
_a1657(_a1728, 8)
_a1660(_a1728, _a1649.line, 1)
_a1664(_a1728, 12)
_a1650("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, _a1728)
if _a1726 then
local _a1729 = _a1650("Frame", {
Size = UDim2.new(1, 0, 0, _a1727 and 32 or 22), BackgroundTransparency = 1,
LayoutOrder = 0,
}, _a1728)
_a1650("TextLabel", {
Size = UDim2.new(1, -70, 0, 16), BackgroundTransparency = 1, Text = _a1726,
TextColor3 = _a1649.text, TextSize = 13, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1729)
if _a1727 then
_a1650("TextLabel", {
Size = UDim2.new(1, -70, 0, 13), Position = UDim2.fromOffset(0, 17),
BackgroundTransparency = 1, Text = _a1727, TextColor3 = _a1649.dim,
TextSize = 11, Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
}, _a1729)
end
_a1728:SetAttribute("HeadHeight", _a1727 and 32 or 18)
return _a1728, _a1729
end
return _a1728
end
local _a1730 = {}
local function _a1731()
for _a1732, _a1733 in pairs(_a1730) do pcall(_a1733) end
end
_a1636.auto.refresh = _a1731
local function _a1734(_a1735, _a1736, _a1737)
local _a1738 = _a1650("TextButton", {
Size = UDim2.fromOffset(46, 24), Position = UDim2.new(1, -46, 0, 0),
BackgroundColor3 = _a1649.cardHi, BorderSizePixel = 0, Text = "",
AutoButtonColor = false,
}, _a1735)
_a1657(_a1738, 12)
local _a1739 = _a1650("Frame", {
Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(3, 3),
BackgroundColor3 = _a1649.dim, BorderSizePixel = 0,
}, _a1738)
_a1657(_a1739, 9)
local _a1740 = _a1650("TextLabel", {
Size = UDim2.fromOffset(46, 12), Position = UDim2.fromOffset(0, 26),
BackgroundTransparency = 1, Text = "OFF", TextColor3 = _a1649.dim,
TextSize = 10, Font = Enum.Font.GothamBold,
}, _a1738)
local function _a1741()
local _a1742 = _a1606[_a1736]
_a1738.BackgroundColor3 = _a1742 and _a1649.good or _a1649.cardHi
_a1739:TweenPosition(UDim2.fromOffset(_a1742 and 25 or 3, 3),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
_a1739.BackgroundColor3 = _a1742 and Color3.fromRGB(255, 255, 255) or _a1649.dim
_a1740.Text = _a1742 and "ON" or "OFF"
_a1740.TextColor3 = _a1742 and _a1649.good or _a1649.dim
end
_a1738.MouseButton1Click:Connect(function()
_a1606[_a1736] = not _a1606[_a1736]
if _a1606[_a1736] then
if _a1736 == "auto" then _a1636.ctl.abort = false end
_a1741()
_a1600("[" .. _a1736 .. "] 시작")
task.spawn(function()
local _a1743, _a1744 = pcall(_a1737)
if not _a1743 then _a1600("[에러] " .. tostring(_a1744)) end
end)
else
if _a1736 == "auto" then
_a1636.ctl.stopAll()
_a1600("[정지] 모든 동작을 멈췄습니다")
end
_a1741()
end
end)
_a1741()
_a1730[_a1736] = _a1741
return _a1738, _a1741
end
local function _a1745(_a1746, _a1747)
local _a1748 = _a1650("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, LayoutOrder = _a1719(),
}, _a1746)
local _a1749 = #_a1747
for _a1750, _a1751 in ipairs(_a1747) do
local _a1752 = _a1650("Frame", {
Size = UDim2.new(1 / _a1749, -6, 1, 0), Position = UDim2.new((_a1750 - 1) / _a1749, 3, 0, 0),
BackgroundTransparency = 1,
}, _a1748)
_a1650("TextLabel", {
Size = UDim2.new(1, 0, 0, 13), BackgroundTransparency = 1, Text = _a1751.label,
TextColor3 = _a1649.dim, TextSize = 10, Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1752)
local _a1753 = _a1650("TextBox", {
Size = UDim2.new(1, 0, 0, 24), Position = UDim2.fromOffset(0, 15),
BackgroundColor3 = _a1649.bg, BorderSizePixel = 0, Text = tostring(_a1751.value),
TextColor3 = _a1649.text, TextSize = 12, Font = Enum.Font.Code,
ClearTextOnFocus = false,
}, _a1752)
_a1657(_a1753, 5)
_a1660(_a1753, _a1649.line, 1)
_a1753.FocusLost:Connect(function() _a1751.onChange(_a1753.Text, _a1753) end)
end
return _a1748
end
local function _a1754(_a1755, _a1756)
local _a1757 = _a1650("Frame", {
Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = _a1719(),
}, _a1755)
local _a1758 = #_a1756
for _a1759, _a1760 in ipairs(_a1756) do
local _a1761 = _a1650("TextButton", {
Size = UDim2.new(1 / _a1758, -5, 1, 0), Position = UDim2.new((_a1759 - 1) / _a1758, 2.5, 0, 0),
BackgroundColor3 = _a1760.col or _a1649.cardHi, BorderSizePixel = 0, Text = _a1760.label,
TextColor3 = _a1649.text, TextSize = 12, Font = Enum.Font.GothamMedium,
}, _a1757)
_a1657(_a1761, 6)
_a1761.MouseButton1Click:Connect(function()
task.spawn(function()
local _a1762, _a1763 = pcall(_a1760.fn, _a1761)
if not _a1762 then _a1600("[에러] " .. tostring(_a1760.label) .. " → " .. tostring(_a1763)) end
end)
end)
end
return _a1757
end
local function _a1764(_a1765, _a1766, _a1767, _a1768)
local _a1769 = _a1650("TextButton", {
Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = _a1649.cardHi, BorderSizePixel = 0,
Text = "", TextColor3 = _a1649.text, TextSize = 12, Font = Enum.Font.GothamMedium,
LayoutOrder = _a1719(),
}, _a1765)
_a1657(_a1769, 6)
local function _a1770()
local _a1771 = _a1767()
_a1769.Text = _a1766 .. "   " .. (_a1771 and "ON" or "OFF")
_a1769.BackgroundColor3 = _a1771 and Color3.fromRGB(40, 78, 58) or _a1649.cardHi
_a1769.TextColor3 = _a1771 and _a1649.good or _a1649.dim
end
_a1769.MouseButton1Click:Connect(function()
_a1768(not _a1767())
_a1770()
end)
_a1770()
return _a1769
end
local _a1772 = _a1708("log", "로그", 90)
local _a1773, _a1774, _a1775
local _a1776 = { size = 140, top = nil }
do
local _a1777 = _a1650("Frame", {
Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(13, 14, 18),
BorderSizePixel = 0, LayoutOrder = _a1719(),
}, _a1772)
_a1657(_a1777, 8)
_a1660(_a1777, _a1649.line, 1)
local _a1778 = _a1650("Frame", {
Size = UDim2.new(1, -10, 0, 24), Position = UDim2.fromOffset(5, 5),
BackgroundTransparency = 1,
}, _a1777)
_a1774 = _a1650("TextLabel", {
Size = UDim2.new(1, -250, 1, 0), BackgroundTransparency = 1,
Text = "", TextColor3 = _a1649.dim, TextSize = 11, Font = Enum.Font.Code,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1778)
local function _a1779(_a1780, _a1781, _a1782, _a1783)
local _a1784 = _a1650("TextButton", {
Size = UDim2.new(0, _a1781, 0, 22), Position = UDim2.new(1, _a1780, 0, 1),
BackgroundColor3 = _a1649.cardHi, BorderSizePixel = 0, AutoButtonColor = true,
Text = _a1782, TextColor3 = _a1649.text, TextSize = 11, Font = Enum.Font.GothamBold,
}, _a1778)
_a1657(_a1784, 5)
_a1784.MouseButton1Click:Connect(function()
task.spawn(function() pcall(_a1783) _a1595.dirty = true end)
end)
return _a1784
end
local function _a1785()
return _a1776.top or math.max(1, #_a1599 - _a1776.size + 1)
end
_a1779(-244, 56, "맨 위",  function() _a1776.top = 1 end)
_a1779(-186, 40, "▲",     function() _a1776.top = math.max(1, _a1785() - _a1776.size) end)
_a1779(-144, 40, "▼",     function()
local _a1786 = _a1785() + _a1776.size
if _a1786 >= math.max(1, #_a1599 - _a1776.size + 1) then _a1776.top = nil else _a1776.top = _a1786 end
end)
_a1779(-102, 100, "최신 따라가기", function() _a1776.top = nil end)
_a1775 = _a1650("ScrollingFrame", {
Size = UDim2.new(1, -10, 1, -36), Position = UDim2.fromOffset(5, 31),
BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 6,
ScrollBarImageColor3 = _a1649.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1777)
_a1773 = _a1650("TextLabel", {
Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1, Text = "", TextColor3 = Color3.fromRGB(196, 208, 196),
TextSize = 11, Font = Enum.Font.Code,
TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
TextWrapped = true,
}, _a1775)
_a1772.AutomaticCanvasSize = Enum.AutomaticSize.None
_a1772.CanvasSize = UDim2.new()
end
do
local _a1787, _a1788, _a1789, _a1790
_a1672.InputBegan:Connect(function(_a1791)
if _a1791.UserInputType == Enum.UserInputType.MouseButton1
or _a1791.UserInputType == Enum.UserInputType.Touch then
_a1787, _a1788, _a1789 = true, _a1791.Position, _a1671.Position
_a1791.Changed:Connect(function()
if _a1791.UserInputState == Enum.UserInputState.End then _a1787 = false end
end)
end
end)
_a1672.InputChanged:Connect(function(_a1792)
if _a1792.UserInputType == Enum.UserInputType.MouseMovement
or _a1792.UserInputType == Enum.UserInputType.Touch then _a1790 = _a1792 end
end)
_a1596.InputChanged:Connect(function(_a1793)
if _a1787 and _a1793 == _a1790 then
local _a1794 = _a1793.Position - _a1788
_a1671.Position = UDim2.new(_a1789.X.Scale, _a1789.X.Offset + _a1794.X,
_a1789.Y.Scale, _a1789.Y.Offset + _a1794.Y)
end
end)
local _a1795 = false
_a1680.MouseButton1Click:Connect(function()
_a1795 = not _a1795
_a1671:TweenSize(_a1795 and UDim2.fromOffset(_a1669, 40) or UDim2.fromOffset(_a1669, _a1670),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
_a1680.Text = _a1795 and "▢" or "—"
end)
end
local _a1796 = _a1597.Heartbeat:Connect(function()
if not _a1595.dirty then return end
_a1595.dirty = false
local _a1797 = #_a1599
local _a1798 = math.max(1, _a1797 - _a1776.size + 1)
local _a1799 = (_a1776.top == nil)
local _a1800 = math.max(1, math.min(_a1776.top or _a1798, _a1798))
local _a1801 = math.min(_a1797, _a1800 + _a1776.size - 1)
local _a1802, _a1803 = {}, 0
for _a1804 = _a1800, _a1801 do
local _a1805 = _a1599[_a1804] or ""
if #_a1805 > 400 then _a1805 = _a1805:sub(1, 400) .. " …" end
_a1803 += #_a1805 + 1
if _a1803 > 12000 then
_a1802[#_a1802 + 1] = "…  (이 창에 다 못 담아 잘랐습니다. ▲ 로 나눠서 보세요)"
_a1801 = _a1804 - 1
break
end
_a1802[#_a1802 + 1] = _a1805
end
_a1773.Text = table.concat(_a1802, "\n")
_a1774.Text = ("%d-%d / %d 줄    %s")
:format(_a1800, _a1801, _a1797, _a1799 and "최신 따라가는 중" or "▲▼ 로 이동  ·  멈춤")
if _a1799 then
task.defer(function()
if _a1775 and _a1775.Parent then
_a1775.CanvasPosition = Vector2.new(0, _a1775.AbsoluteCanvasSize.Y)
end
end)
end
end)
local _a1806 = _a1708("dash", "대시보드", 10)
local _a1807 = _a1708("event", "이벤트", 20)
do
local _a1808 = _a1724(_a1806, "전체 제어", nil)
_a1754(_a1808, {
{ label = "권장 전부 ON", col = _a1649.good, fn = function()
for _a1809, _a1810 in ipairs({ "place", "merchant", "crop", "expand", "hatch" }) do
if not _a1606[_a1810] then
_a1606[_a1810] = true
if _a1810 == "place"    then _a1648(_a1810, function() return _a1604.PlaceInterval end, _a1613, "배치") end
if _a1810 == "merchant" then _a1648(_a1810, function() return _a1604.MerchantInterval end, _a1614, "구매") end
if _a1810 == "crop"     then _a1648(_a1810, function() return _a1604.CropInterval end, _a1623, "씨앗") end
if _a1810 == "expand"   then _a1648(_a1810, function() return _a1604.ExpandInterval end, _a1626, "확장") end
if _a1810 == "hatch"    then _a1648(_a1810, function() return _a1604.HatchInterval end, _a1630, "뽑기") end
end
end
_a1731()
_a1600("[전체] 배치/구매/씨앗/확장/뽑기 ON  (업글·리버스는 따로 켜세요)")
end },
{ label = "전부 정지", col = _a1649.bad, fn = function()
_a1606.place, _a1606.merchant, _a1606.upgrade = false, false, false
_a1606.towerup, _a1606.crop, _a1606.expand, _a1606.rebirth, _a1606.hatch, _a1606.luck = false, false, false, false, false, false
_a1606.farm, _a1606.zone, _a1606.mhatch, _a1606.rank, _a1606.mreb = false, false, false, false, false
_a1731()
_a1600("[전체] 정지")
end },
})
local _a1811 = _a1724(_a1806, "현황", nil)
_a1754(_a1811, {
{ label = "밭 / 타워", col = _a1649.accent, fn = function()
local _a1812, _a1813, _a1814, _a1815 = _a1609()
_a1600("")
_a1600("──── 현재 상태 ────")
_a1600("레인 " .. tostring(_a1815) .. " / plot " .. (_a1814 and "O" or "X")
.. " / world " .. (_a1812 and "O" or "X"))
local _a1816 = _a1610(_a1814, _a1815)
local _a1817 = _a1611(_a1812)
_a1600("슬롯 " .. #_a1816 .. " / 배치 " .. #_a1817)
local _a1818, _a1819 = 0, {}
for _a1820, _a1821 in ipairs(_a1817) do
_a1818 += (_a1821.dps or 0)
_a1819[tostring(_a1821.kind)] = (_a1819[tostring(_a1821.kind)] or 0) + 1
end
_a1600("총 DPS " .. _a1601(_a1818))
for _a1822, _a1823 in pairs(_a1819) do _a1600("  " .. _a1822 .. " × " .. _a1823) end
local _a1824 = _a1612()
_a1600("")
_a1600("배치 가능 " .. #_a1824 .. "종")
for _a1825 = 1, math.min(10, #_a1824) do
local _a1826 = _a1824[_a1825]
_a1600(("  %-22s %-7s 남은 %-3s DPS %s"):format(
tostring(_a1826.id), tostring(_a1826.vr or "-"), tostring(_a1826.copies), _a1601(_a1826.dps)))
end
_a1691("log")
end },
{ label = "로그 보기", col = _a1649.cardHi, fn = function() _a1691("log") end },
})
end
do
local _a1827, _a1828 = _a1724(_a1807, "자동 배치 / 교체", nil)
_a1734(_a1828, "place", function()
_a1648("place", function() return _a1604.PlaceInterval end, _a1613, "배치")
end)
_a1745(_a1827, {
{ label = "주기", value = _a1604.PlaceInterval, onChange = function(_a1829)
local _a1830 = tonumber(_a1829) if _a1830 and _a1830 >= 3 then _a1604.PlaceInterval = _a1830 end
end },
{ label = "교체 배수", value = _a1604.SwapMargin, onChange = function(_a1831)
local _a1832 = tonumber(_a1831) if _a1832 and _a1832 >= 1 then _a1604.SwapMargin = _a1832 _a1600("[설정] 교체 배수 " .. _a1832) end
end },
{ label = "DoT 반영", value = _a1604.DotFactor, onChange = function(_a1833)
local _a1834 = tonumber(_a1833) if _a1834 and _a1834 >= 0 and _a1834 <= 1 then _a1604.DotFactor = _a1834 end
end },
})
_a1764(_a1827, "업글 타워 보호",
function() return _a1604.ProtectUpgraded end,
function(_a1835) _a1604.ProtectUpgraded = _a1835
_a1600("[설정] 업글 보호 " .. (_a1835 and "ON — 업글된 건 안 건드림" or "OFF — 약하면 교체")) end)
_a1754(_a1827, {
{ label = "지금 1회 실행", col = _a1649.accent, fn = function()
task.spawn(function() _a1606.place = true _a1613() _a1606.place = false _a1691("log") end)
end },
})
end
do
local _a1836, _a1837 = _a1724(_a1807, "머천트 자동 구매", nil)
_a1734(_a1837, "merchant", function()
_a1648("merchant", function() return _a1604.MerchantInterval end, _a1614, "구매")
end)
_a1745(_a1836, {
{ label = "머천트 ID", value = _a1604.MerchantId, onChange = function(_a1838)
if _a1838 ~= "" then _a1604.MerchantId = _a1838 _a1600("[설정] 머천트 " .. _a1838) end
end },
{ label = "주기", value = _a1604.MerchantInterval, onChange = function(_a1839)
local _a1840 = tonumber(_a1839) if _a1840 and _a1840 >= 5 then _a1604.MerchantInterval = _a1840 end
end },
})
_a1754(_a1836, {
{ label = "지금 1회 구매", col = _a1649.accent, fn = function()
task.spawn(function() _a1606.merchant = true _a1614() _a1606.merchant = false _a1691("log") end)
end },
})
end
do
local _a1841, _a1842 = _a1724(_a1807, "업그레이드 머신", nil)
_a1734(_a1842, "upgrade", function()
_a1648("upgrade", function() return _a1604.UpgradeInterval end, _a1618, "머신업글")
end)
_a1745(_a1841, {
{ label = "주기", value = _a1604.UpgradeInterval, onChange = function(_a1843)
local _a1844 = tonumber(_a1843) if _a1844 and _a1844 >= 5 then _a1604.UpgradeInterval = _a1844 end
end },
{ label = "최소 잔액", value = _a1604.MinSunflowers, onChange = function(_a1845)
local _a1846 = tonumber(_a1845) if _a1846 and _a1846 >= 0 then _a1604.MinSunflowers = _a1846
_a1600("[설정] 최소 잔액 " .. _a1601(_a1846, 0)) end
end },
})
_a1764(_a1841, "가격 미상 구매",
function() return _a1604.BuyUnknownCost end,
function(_a1847) _a1604.BuyUnknownCost = _a1847 end)
_a1754(_a1841, {
{ label = "업글 현황 보기", col = _a1649.accent, fn = function()
local _a1848 = _a1615()
local _a1849 = _a1616()
_a1607.sun = _a1848
_a1600("")
_a1600("──── 업그레이드 머신 ────")
_a1600("Sunflowers = " .. _a1601(_a1848, 0))
local _a1850 = {}
for _a1851, _a1852 in ipairs(_a1608) do
local _a1853 = _a1849[_a1852] or 0
_a1850[#_a1850 + 1] = { id = _a1852, tier = _a1853, cost = _a1617(_a1852, _a1853) }
end
table.sort(_a1850, function(_a1854, _a1855)
return (_a1854.cost or math.huge) < (_a1855.cost or math.huge)
end)
for _a1856, _a1857 in ipairs(_a1850) do
_a1600(("  %-22s Lv%-3s 다음 %-14s %s"):format(
_a1857.id, tostring(_a1857.tier), _a1857.cost and _a1601(_a1857.cost, 0) or "?",
(_a1857.cost and _a1857.cost <= _a1848) and "← 구매가능" or ""))
end
_a1691("log")
end },
{ label = "지금 1회 업글", col = _a1649.cardHi, fn = function()
task.spawn(function() _a1606.upgrade = true _a1618() _a1606.upgrade = false _a1691("log") end)
end },
})
local _a1858, _a1859 = _a1724(_a1807, "타워 개별 업글", nil)
_a1734(_a1859, "towerup", function()
_a1648("towerup", function() return _a1604.UpgradeInterval end, _a1647, "타워업글")
end)
end
do
local _a1860, _a1861 = _a1724(_a1807, "자동 뽑기", nil)
_a1734(_a1861, "hatch", function()
_a1648("hatch", function() return _a1604.HatchInterval end, _a1630, "뽑기")
end)
_a1745(_a1860, {
{ label = "주기", value = _a1604.HatchInterval, onChange = function(_a1862)
local _a1863 = tonumber(_a1862) if _a1863 and _a1863 >= 1 then _a1604.HatchInterval = _a1863 end
end },
{ label = "한 번에 최대", value = _a1604.HatchMax, onChange = function(_a1864)
local _a1865 = tonumber(_a1864) if _a1865 and _a1865 >= 1 then _a1604.HatchMax = math.floor(_a1865) end
end },
})
_a1745(_a1860, {
{ label = "예비금", value = _a1604.HatchReserve, onChange = function(_a1866)
local _a1867 = tonumber(_a1866) if _a1867 and _a1867 >= 0 then _a1604.HatchReserve = _a1867
_a1600("[설정] 뽑기 예비금 " .. _a1601(_a1867, 0)) end
end },
{ label = "알 번호 (0=자동)", value = _a1604.HatchEggNum, onChange = function(_a1868)
local _a1869 = tonumber(_a1868) if _a1869 and _a1869 >= 0 and _a1869 <= 12 then
_a1604.HatchEggNum = math.floor(_a1869)
table.clear(_a1605)
_a1600("[설정] 알 번호 " .. (_a1869 == 0 and "자동" or _a1869)) end
end },
})
_a1754(_a1860, {
{ label = "뽑기 현황 보기", col = _a1649.accent, fn = function()
local _a1870 = _a1629()
_a1607.sun = _a1870.sun
_a1600("")
_a1600("──── 뽑기 현황 ────")
_a1600("  알 등급     " .. _a1870.id)
_a1600("  알 uid      " .. tostring(_a1870.uid))
_a1600("  개당 비용   " .. (_a1870.cost and _a1601(_a1870.cost, 0) or "?"))
_a1600("  Sunflowers  " .. _a1601(_a1870.sun, 0))
_a1600("  예비금      " .. _a1601(_a1604.HatchReserve, 0))
_a1600("  지금 가능   " .. _a1870.canBuy .. "회")
_a1600("")
_a1600("  월드의 알 " .. _a1870.eggCount .. "개")
for _a1871, _a1872 in ipairs(_a1870.eggs) do
if _a1871 > 5 then break end
_a1600(("    %s  거리 %s"):format(_a1872.uid, _a1601(_a1872.dist)))
end
_a1600("")
_a1600("  누적 뽑기   " .. _a1607.hatched .. "회")
_a1691("log")
end },
{ label = "지금 1회 실행", col = _a1649.cardHi, fn = function()
task.spawn(function() _a1606.hatch = true _a1630() _a1606.hatch = false _a1691("log") end)
end },
})
end
do
local _a1873, _a1874 = _a1724(_a1807, "럭 상시 최대 유지", nil)
_a1734(_a1874, "luck", function()
_a1648("luck", function() return _a1604.LuckInterval end, _a1634, "럭")
end)
_a1745(_a1873, {
{ label = "주기", value = _a1604.LuckInterval, onChange = function(_a1875)
local _a1876 = tonumber(_a1875) if _a1876 and _a1876 >= 60 then _a1604.LuckInterval = _a1876 end
end },
{ label = "예비금", value = _a1604.LuckReserve, onChange = function(_a1877)
local _a1878 = tonumber(_a1877) if _a1878 and _a1878 >= 0 then _a1604.LuckReserve = _a1878 end
end },
})
_a1745(_a1873, {
{ label = "최소 부족분", value = _a1604.LuckMinTopUp, onChange = function(_a1879)
local _a1880 = tonumber(_a1879) if _a1880 and _a1880 >= 0 then _a1604.LuckMinTopUp = _a1880 end
end },
})
for _a1881, _a1882 in ipairs(_a1631) do
_a1764(_a1873, _a1882,
function() return _a1604.LuckBoosts[_a1882] end,
function(_a1883) _a1604.LuckBoosts[_a1882] = _a1883 end)
end
_a1754(_a1873, {
{ label = "럭 현황 보기", col = _a1649.accent, fn = function()
local _a1884 = _a1632()
_a1607.sun = _a1884.sun
_a1600("")
_a1600("──── 이벤트 럭 ────")
_a1600("  머신 활성   " .. (_a1884.enabled and "O" or "X"))
_a1600("  최대 시간   " .. _a1633(_a1884.maxSec))
_a1600("  Sunflowers  " .. _a1601(_a1884.sun, 0))
_a1600("")
for _a1885, _a1886 in ipairs(_a1884.rows) do
_a1600(("  %-12s %-14s 부족 %-14s 필요 %s개%s"):format(
_a1886.rarity, _a1633(_a1886.left), _a1633(_a1886.deficit), _a1601(_a1886.need, 0),
_a1886.on and "" or "   (꺼짐)"))
end
_a1600("")
_a1600("  효과 : 비활성 0.5배 → 활성 1.0배 (2배)")
_a1691("log")
end },
{ label = "지금 1회 충전", col = _a1649.cardHi, fn = function()
task.spawn(function() _a1606.luck = true _a1634() _a1606.luck = false _a1691("log") end)
end },
})
end
do
local _a1887, _a1888 = _a1724(_a1807, "자동 씨앗 교체", nil)
_a1734(_a1888, "crop", function()
_a1648("crop", function() return _a1604.CropInterval end, _a1623, "씨앗")
end)
_a1745(_a1887, {
{ label = "주기", value = _a1604.CropInterval, onChange = function(_a1889)
local _a1890 = tonumber(_a1889) if _a1890 and _a1890 >= 5 then _a1604.CropInterval = _a1890 end
end },
{ label = "갈아엎기 배수", value = _a1604.CropMargin, onChange = function(_a1891)
local _a1892 = tonumber(_a1891) if _a1892 and _a1892 >= 1 then _a1604.CropMargin = _a1892 _a1600("[설정] 작물 배수 " .. _a1892) end
end },
})
_a1764(_a1887, "성장중 건너뛰기",
function() return _a1604.SkipUnhatched end,
function(_a1893) _a1604.SkipUnhatched = _a1893 end)
_a1754(_a1887, {
{ label = "밭 현황 보기", col = _a1649.accent, fn = function()
local _a1894, _a1895 = _a1609()
if not _a1895 then _a1600("[씨앗] 밭 없음") _a1691("log") return end
local _a1896, _a1897 = _a1620(_a1895), _a1619()
_a1600("")
_a1600("──── 밭 현황 ────")
_a1600("보유 씨앗 (기대 초당수익 순)")
for _a1898, _a1899 in ipairs(_a1897) do
_a1600(("  %-10s %-8s ×%-6s  기대 %s/s"):format(
tostring(_a1899.id), tostring(_a1899.vr or "-"), tostring(_a1899.am), _a1601(_a1899.exp)))
end
local _a1900, _a1901, _a1902, _a1903, _a1904 = 0, 0, 0, 0, 0
local _a1905 = _a1897[1]
local _a1906 = _a1905 and _a1905.exp or 0
_a1600("")
_a1600("심어진 작물")
local _a1907 = 0
for _a1908, _a1909 in pairs(_a1896) do
_a1900 += 1
local _a1910 = _a1622(_a1909) or 0
_a1901 += _a1910
if _a1621(_a1909) then _a1903 += 1
elseif _a1906 > _a1910 * _a1604.CropMargin then _a1902 += 1
else _a1904 += 1 end
_a1907 += 1
if _a1907 <= 20 then
_a1600(("  칸%-4s %-20s %s/s%s"):format(tostring(_a1908),
tostring(rawget(_a1909, "sp") or "?"), _a1601(_a1910),
_a1621(_a1909) and "  (자라는 중)" or ""))
end
end
if _a1900 > 20 then _a1600("  ... (" .. (_a1900 - 20) .. "칸 더)") end
_a1600("")
_a1600(("총 %d칸 / 합계 %s per sec"):format(_a1900, _a1601(_a1901)))
_a1600(("갈아엎기 대상 %d / 유지 %d / 자라는 중 %d"):format(_a1902, _a1904, _a1903))
_a1691("log")
end },
{ label = "지금 1회 실행", col = _a1649.cardHi, fn = function()
task.spawn(function() _a1606.crop = true _a1623() _a1606.crop = false _a1691("log") end)
end },
})
end
do
local _a1911, _a1912 = _a1724(_a1807, "자동 확장", nil)
_a1734(_a1912, "expand", function()
_a1648("expand", function() return _a1604.ExpandInterval end, _a1626, "확장")
end)
_a1745(_a1911, {
{ label = "주기", value = _a1604.ExpandInterval, onChange = function(_a1913)
local _a1914 = tonumber(_a1913) if _a1914 and _a1914 >= 5 then _a1604.ExpandInterval = _a1914 end
end },
{ label = "밭칸 스캔", value = _a1604.MaxBedScan, onChange = function(_a1915)
local _a1916 = tonumber(_a1915) if _a1916 and _a1916 >= 1 then _a1604.MaxBedScan = math.floor(_a1916) end
end },
})
_a1754(_a1911, {
{ label = "확장 현황 보기", col = _a1649.accent, fn = function()
local _a1917, _a1918, _a1919, _a1920 = _a1609()
if not _a1918 then _a1600("[확장] 밭 없음") _a1691("log") return end
local _a1921 = _a1615()
_a1607.sun = _a1921
local _a1922 = _a1624(true)
_a1600("")
_a1600("──── 확장 현황 ────")
_a1600("Sunflowers = " .. _a1601(_a1921, 0))
_a1600("")
_a1600("레인 " .. tostring(_a1920) .. "개 열림")
local _a1923 = {}
for _a1924 in pairs(_a1922) do _a1923[#_a1923 + 1] = tonumber(_a1924) or _a1924 end
table.sort(_a1923, function(_a1925, _a1926) return tostring(_a1925) < tostring(_a1926) end)
for _a1927, _a1928 in ipairs(_a1923) do
local _a1929 = _a1922[_a1928] or _a1922[tostring(_a1928)]
local _a1930 = tonumber(_a1928) or 0
local _a1931 = (_a1930 == (tonumber(_a1920) or 0) + 1)
and ((tonumber(_a1929) or math.huge) <= _a1921 and "  ← 지금 오픈 가능" or "  ← 다음 (돈 부족)")
or (_a1930 <= (tonumber(_a1920) or 0) and "  (열림)" or "")
_a1600(("  레인 %-3s %s%s"):format(tostring(_a1928), _a1601(tonumber(_a1929) or 0, 0), _a1931))
end
local _a1932 = _a1625(_a1918)
_a1600("")
_a1600("잠긴 밭칸 " .. #_a1932 .. "개 (싼 순 8개)")
for _a1933 = 1, math.min(8, #_a1932) do
local _a1934 = _a1932[_a1933]
_a1600(("  칸 %-4s %s%s"):format(_a1934.id, _a1934.cost and _a1601(_a1934.cost, 0) or "?",
(_a1934.cost and _a1934.cost <= _a1921) and "  ← 오픈 가능" or ""))
end
if #_a1932 == 0 then _a1600("  (전부 열려 있음)") end
_a1691("log")
end },
{ label = "지금 1회 실행", col = _a1649.cardHi, fn = function()
task.spawn(function() _a1606.expand = true _a1626() _a1606.expand = false _a1691("log") end)
end },
})
end
do
local _a1935, _a1936 = _a1724(_a1807, "자동 리버스", nil)
_a1734(_a1936, "rebirth", function()
_a1648("rebirth", function() return _a1604.RebirthInterval end, _a1628, "리버스")
end)
_a1745(_a1935, {
{ label = "주기", value = _a1604.RebirthInterval, onChange = function(_a1937)
local _a1938 = tonumber(_a1937) if _a1938 and _a1938 >= 10 then _a1604.RebirthInterval = _a1938 end
end },
})
_a1754(_a1935, {
{ label = "리버스 현황 보기", col = _a1649.accent, fn = function()
local _a1939 = _a1627()
_a1600("")
_a1600("──── 리버스 현황 ────")
if not _a1939 then _a1600("  밭 없음") _a1691("log") return end
_a1600(("  현재 리버스   %d회  (최대 %s)"):format(_a1939.regrows, tostring(_a1939.cap)))
_a1600(("  레인          %d / 7 %s"):format(_a1939.lanes, _a1939.lanes >= 7 and "OK" or "부족"))
_a1600(("  코인보스      %d / %d %s"):format(_a1939.kills, _a1939.need,
_a1939.kills >= _a1939.need and "OK" or "부족"))
_a1600("")
_a1600(_a1939.ready and "  ★ 지금 리버스 가능" or ("  대기 — " .. tostring(_a1939.reason)))
_a1691("log")
end },
{ label = "지금 1회 리버스", col = _a1649.bad, fn = function()
task.spawn(function() _a1606.rebirth = true _a1628() _a1606.rebirth = false _a1691("log") end)
end },
})
end
local _a1940 = _a1708("main", "메인 게임", 30)
do
local _a1941, _a1942 = _a1724(_a1940, "올 자동", nil)
local _a1943 = _a1650("Frame", {
Size = UDim2.new(1, 0, 0, 108), BackgroundColor3 = _a1649.cardHi,
BorderSizePixel = 0, LayoutOrder = _a1719(),
}, _a1941)
_a1657(_a1943, 6)
_a1664(_a1943, 8)
local _a1944 = _a1650("TextLabel", {
Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
Font = Enum.Font.Code, TextSize = 12, TextColor3 = _a1649.text,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Text = "정지", RichText = true,
}, _a1943)
task.spawn(function()
while _a1667 and _a1667.Parent do
local _a1945 = _a1636.ctl.now
local _a1946 = _a1606.auto and "🟢" or "⚪"
local _a1947 = _a1945.act or "-"
if _a1945.detail and _a1945.detail ~= "" then _a1947 = _a1947 .. "  " .. _a1945.detail end
_a1944.Text = table.concat({
_a1946 .. " " .. (_a1606.auto and (_a1945.step or "-") or "정지"),
"▸ " .. _a1947,
"목표 " .. (_a1945.goal or "-") .. (_a1945.prog ~= "" and ("   " .. _a1945.prog) or ""),
"1.리버스 " .. (_a1636.auto.rebNote or "-"),
"2.존해금 " .. (_a1636.auto.zoneNote or "-"),
"파밍대상 " .. tostring(_a1636.auto.farmZone or "-") .. "   현재 " .. tostring(_a1636.auto.hereZone or "-"),
}, "\n")
task.wait(0.2)
end
end)
function _a1636.auto.start()
for _a1948, _a1949 in ipairs(_a1636.auto.STEPS) do _a1606[_a1949.run] = false end
for _a1950, _a1951 in ipairs(_a1636.auto.SIDE) do _a1606[_a1951.run] = false end
_a1606.petspd = true
_a1606.rewatch = true
_a1731()
_a1648("auto", function() return _a1604.AutoInterval end, _a1636.auto.master, "자동")
end
_a1734(_a1942, "auto", _a1636.auto.start)
_a1745(_a1941, {
{ label = "주기", value = _a1604.AutoInterval, onChange = function(_a1952)
local _a1953 = tonumber(_a1952) if _a1953 and _a1953 >= 1 then _a1604.AutoInterval = _a1953 end
end },
{ label = "정체 판정(초)", value = _a1604.PursueStallSec, onChange = function(_a1954)
local _a1955 = tonumber(_a1954) if _a1955 and _a1955 >= 10 then _a1604.PursueStallSec = _a1955 end
end },
})
_a1745(_a1941, {
{ label = "운 퀘 최소 알 개수", value = _a1604.HatchMinAfford, onChange = function(_a1956)
local _a1957 = tonumber(_a1956) if _a1957 and _a1957 >= 1 then _a1604.HatchMinAfford = math.floor(_a1957) end
end },
{ label = "더 버는 시간(초)", value = _a1604.MoneyDwell, onChange = function(_a1958)
local _a1959 = tonumber(_a1958) if _a1959 and _a1959 >= 0 then _a1604.MoneyDwell = _a1959 end
end },
})
_a1745(_a1941, {
{ label = "부화 한 번에(초)", value = _a1604.HatchBudget, onChange = function(_a1960)
local _a1961 = tonumber(_a1960) if _a1961 and _a1961 >= 3 then _a1604.HatchBudget = _a1961 end
end },
})
_a1745(_a1941, {
{ label = "이동 방식", value = _a1604.TpMode, onChange = function(_a1962)
_a1962 = tostring(_a1962 or ""):lower()
if _a1962 == "instant" or _a1962 == "glide" or _a1962 == "walk" then _a1604.TpMode = _a1962 end
end },
{ label = "glide 속도", value = _a1604.TpSpeed, onChange = function(_a1963)
local _a1964 = tonumber(_a1963) if _a1964 and _a1964 >= 16 then _a1604.TpSpeed = _a1964 end
end },
})
_a1764(_a1941, "차단 화면에 실제 클릭까지 시도",
function() return _a1604.ScreenRealClick end,
function(_a1965) _a1604.ScreenRealClick = _a1965 end)
_a1764(_a1941, "퀘스트 없을 때도 알 까기",
function() return _a1604.IdleHatch end,
function(_a1966) _a1604.IdleHatch = _a1966 end)
_a1764(_a1941, "존 해금·리버스는 퀘스트 끝나고",
function() return _a1604.HoldZoneForQuest end,
function(_a1967) _a1604.HoldZoneForQuest = _a1967 end)
for _a1968, _a1969 in ipairs(_a1636.auto.STEPS) do
local _a1970 = _a1969.key
_a1764(_a1941, "  " .. _a1968 .. ". " .. _a1969.label,
function() return _a1604.StepOn[_a1970] end,
function(_a1971) _a1604.StepOn[_a1970] = _a1971 end)
end
for _a1972, _a1973 in ipairs(_a1636.auto.SIDE) do
local _a1974 = _a1973.key
_a1764(_a1941, "  · " .. _a1973.label .. " (순위 밖)",
function() return _a1604.StepOn[_a1974] end,
function(_a1975) _a1604.StepOn[_a1974] = _a1975 end)
end
_a1754(_a1941, {
{ label = "지금 상태", col = _a1649.accent, fn = function()
_a1600("")
_a1600("──── 올 자동 ────")
_a1600("  " .. (_a1606.auto and "돌아가는 중" or "정지") ..
(_a1636.auto.step and ("   지금: " .. _a1636.auto.step) or ""))
local _a1976, _a1977 = _a1636.quest.bestDepActive()
_a1600("  현재 존 " .. tostring(_a1636.move.curZone()) .. " / 최고 존 " .. tostring(_a1636.move.bestZone()))
if _a1976 then
_a1600("  ⏸ 존해금·리버스 보류 중 — " .. tostring(_a1977 and _a1977.title))
else
_a1600("  존해금·리버스 진행 가능")
end
_a1600("")
_a1600("  먼저 (순위 밖):")
for _a1978, _a1979 in ipairs(_a1636.auto.SIDE) do
_a1600(("      %-16s %s"):format(_a1979.label, _a1604.StepOn[_a1979.key] and "ON" or "off"))
end
_a1600("  우선순위:")
for _a1980, _a1981 in ipairs(_a1636.auto.STEPS) do
_a1600(("    %d. %-16s %s%s"):format(_a1980, _a1981.label,
_a1604.StepOn[_a1981.key] and "ON" or "off",
_a1981.hold and "   (퀘스트 붙잡는 중엔 보류)" or ""))
end
_a1600("")
_a1600("  세이브")
local _a1982 = _a1602.Save
_a1600("    Library.Client.Save : " .. (_a1982 and "로드됨" or "★ 없음"))
if _a1982 then
local _a1983, _a1984 = pcall(_a1982.Get)
_a1600("    Get()        : " .. (_a1983 and type(_a1984) or ("에러 " .. tostring(_a1984))))
local _a1985, _a1986 = pcall(_a1982.Get, _a1598)
_a1600("    Get(LP)      : " .. (_a1985 and type(_a1986) or ("에러 " .. tostring(_a1986))))
if rawget(_a1982, "GetSaves") then
local _a1987, _a1988 = pcall(_a1982.GetSaves)
if _a1987 and type(_a1988) == "table" then
local _a1989 = 0
for _a1990 in pairs(_a1988) do
_a1989 += 1
if _a1989 <= 3 then _a1600("      키: " .. tostring(_a1990)
.. (_a1990 == _a1598 and "   ← 내 LocalPlayer" or "")) end
end
_a1600("    GetSaves()   : " .. _a1989 .. "개")
else
_a1600("    GetSaves()   : 에러 " .. tostring(_a1988))
end
end
local _a1991 = _a1637()
if _a1991 then
local _a1992 = rawget(_a1991, "Goals")
_a1600("    → 읽기 성공. Rebirths " .. tostring(rawget(_a1991, "Rebirths"))
.. " / Goals " .. (type(_a1992) == "table" and #_a1992 or "없음"))
else
_a1600("    → ★ 어떤 방법으로도 못 읽음")
end
end
_a1600("")
_a1600("  마지막 바퀴 (" .. tostring(_a1636.auto.passN or 0) .. "번째)")
if _a1636.auto.lastPassAt then
_a1600(("    %.0f초 전"):format(os.clock() - _a1636.auto.lastPassAt))
else
_a1600("    아직 한 바퀴도 안 돎 — 루프가 안 돌고 있습니다")
end
for _a1993, _a1994 in ipairs(_a1636.auto.lastTrace or {}) do _a1600("    " .. _a1994) end
_a1691("log")
end },
{ label = "화면 넘기기 진단", col = _a1649.warn, fn = function()
task.spawn(function()
_a1600("")
_a1600("──── 보상 화면 ────")
local _a1995 = _a1635.Vars
_a1600("  Library.Variables : " .. (_a1995 and "로드됨" or "없음"))
if _a1995 then
_a1600("    IsRebirthing = " .. tostring(rawget(_a1995, "IsRebirthing")))
_a1600("    IsRankingUp  = " .. tostring(rawget(_a1995, "IsRankingUp")))
_a1600("    OpeningEgg   = " .. tostring(rawget(_a1995, "OpeningEgg")))
end
_a1600("  debug.info     : " .. tostring(type(debug) == "table" and type(debug.info) == "function"))
_a1600("  getgc          : " .. tostring(type(getgc) == "function"))
_a1600("  debug.setupvalue: " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
local _a1996 = _a1598:FindFirstChildOfClass("PlayerGui")
if _a1996 then
_a1600("  떠 있는 차단 화면:")
local _a1997 = false
for _a1998, _a1999 in ipairs(_a1636.screen.BLOCKERS) do
local _a2000 = _a1996:FindFirstChild(_a1999[1])
_a1600(("    %-14s %s"):format(_a1999[1],
_a2000 and (_a2000.Enabled and "★ 켜짐" or "꺼짐") or "없음"))
if _a2000 and _a2000.Enabled then _a1997 = true end
end
if not _a1997 then _a1600("    (없음)") end
end
if type(getgc) == "function" and type(debug) == "table" and debug.info then
_a1600("")
_a1600("  Rebirth/RankUp 스크립트의 클로저 시그니처:")
local _a2001, _a2002 = {}, 0
for _a2003, _a2004 in ipairs({ true, false }) do
local _a2005, _a2006 = pcall(getgc, _a2004)
if _a2005 then
for _a2007, _a2008 in ipairs(_a2006) do
if type(_a2008) == "function" and _a2002 < 25 then
local _a2009, _a2010 = pcall(debug.info, _a2008, "s")
if _a2009 and type(_a2010) == "string"
and (_a2010:find("Rebirth", 1, true) or _a2010:find("Rank Up", 1, true)) then
local _a2011, _a2012 = pcall(debug.info, _a2008, "a")
if _a2011 then
local _a2013 = {}
for _a2014 = 1, 16 do
local _a2015, _a2016 = pcall(debug.getupvalue, _a2008, _a2014)
if not _a2015 then break end
_a2013[_a2014] = type(_a2016)
end
local _a2017 = ("인자%d | %s"):format(_a2012 or -1,
#_a2013 > 0 and table.concat(_a2013, ",") or "(없음)")
if not _a2001[_a2017] then
_a2001[_a2017] = true
_a2002 += 1
_a1600("    " .. _a2017)
end
end
end
end
end
end
end
if _a2002 == 0 then _a1600("    (하나도 못 찾음)") end
end
for _a2018, _a2019 in ipairs({ "reward", "egg", "mastery", "card" }) do
_a1636.screen._sig = nil
local _a2020 = _a1636.screen.findSignalFns(_a2019)
_a1600("")
_a1600(("  [%s] 찾은 함수 %d개"):format(_a2019, #_a2020))
for _a2021, _a2022 in ipairs(_a2020) do
_a1600(("    %s%s"):format(_a2022.exact and "★정확일치 " or "", tostring(_a2022.src)))
_a1600(("       upvalue %d개 : %s"):format(_a2022.n or 0, tostring(_a2022.sig)))
end
if #_a2020 == 0 then
_a1600("    (getgc 로 그 스크립트의 클로저를 못 찾음)")
end
local _a2023, _a2024 = _a1636.screen.signal(_a2019)
_a1600(("    upvalue 신호 : %s (%s개 세팅)"):format(tostring(_a2023), tostring(_a2024)))
local _a2025 = _a1636.screen.SIGNAL[_a2019]
_a1600(("    게임내 입력발동 : %s"):format(
tostring(_a1636.screen.pressInGame(_a2025 and _a2025.pats or {}))))
end
_a1600("")
_a1600("  감시 루프 RUN.rewatch = " .. tostring(_a1606.rewatch))
_a1691("log")
end)
end },
{ label = "한 바퀴만", col = _a1649.cardHi, fn = function()
task.spawn(function()
_a1606.auto = true _a1636.auto.master() _a1606.auto = false _a1691("log")
end)
end },
{ label = "자동 점검", col = _a1649.warn, fn = function()
task.spawn(function()
_a1600("")
_a1600("════ 올 자동 점검 ════")
_a1600("  RUN.auto = " .. tostring(_a1606.auto))
local _a2026 = {}
for _a2027, _a2028 in ipairs(_a1636.auto.SIDE) do
_a2026[#_a2026 + 1] = _a2028.key .. "=" .. tostring(_a1604.StepOn[_a2028.key])
end
for _a2029, _a2030 in ipairs(_a1636.auto.STEPS) do
_a2026[#_a2026 + 1] = _a2030.key .. "=" .. tostring(_a1604.StepOn[_a2030.key])
end
_a1600("  단계 ON/OFF : " .. table.concat(_a2026, "  "))
_a1600("  lockGoal    : " .. (_a1636.ctl.lockGoal and tostring(_a1636.ctl.lockGoal.q.title) or "없음"))
local _a2031, _a2032 = _a1636.quest.bestDepActive()
_a1600("  보류중?     : " .. tostring(_a2031) .. (_a2032 and ("  ← " .. tostring(_a2032.title)) or ""))
_a1600("  리모트      : 존 " .. (_a1635.R_Zone and "O" or "X")
.. " / 리버스 " .. (_a1635.R_Reb and "O" or "X"))
_a1600("")
_a1600("  ── 존 해금 판정 ──")
local _a2033 = _a1640()
if not _a2033 then
_a1600("    zoneStatus() = nil  ← 다음 존을 못 구함")
local _a2034 = _a1635.Zone and rawget(_a1635.Zone, "GetNextZone")
if _a2034 then
local _a2035, _a2036, _a2037 = pcall(_a1635.Zone.GetNextZone)
_a1600("    GetNextZone → ok=" .. tostring(_a2035)
.. " / " .. tostring(_a2036) .. " / " .. tostring(_a2037))
end
if _a1635.Zone and rawget(_a1635.Zone, "HasCompletedNextZoneQuests") then
local _a2038, _a2039 = pcall(_a1635.Zone.HasCompletedNextZoneQuests)
_a1600("    존 퀘스트 완료? " .. (_a2038 and tostring(_a2039) or ("에러 " .. tostring(_a2039))))
end
else
_a1600("    다음 존 : " .. tostring(_a2033.id))
_a1600(("    가격 %s %s / 보유 %s → %s"):format(
_a1601(_a2033.price or 0, 0), tostring(_a2033.currency), _a1601(_a2033.have, 0),
_a2033.ok and "지금 살 수 있음" or "부족"))
end
_a1600("")
_a1600("  ── 리버스 판정 ──")
local _a2040 = _a1645()
if not _a2040 then _a1600("    세이브 못 읽음")
else
_a1600(("    현재 %d → 다음 %d"):format(_a2040.current, _a2040.nextN))
_a1600("    최근 사유 : " .. tostring(_a1636.auto.rebNote or "-"))
end
_a1600("")
_a1600("  ── 직전 바퀴 기록 ──")
if _a1636.auto.lastTrace and #_a1636.auto.lastTrace > 0 then
for _a2041, _a2042 in ipairs(_a1636.auto.lastTrace) do _a1600("    " .. _a2042) end
_a1600(("    (%.0f초 전)"):format(os.clock() - (_a1636.auto.lastPassAt or os.clock())))
else
_a1600("    아직 한 바퀴도 안 돌았음")
end
_a1691("log")
end)
end },
})
local _a2043, _a2044 = _a1724(_a1940, "펫 이동속도", nil)
_a1734(_a2044, "petspd", function()
_a1648("petspd", function() return 0.4 end, _a1636.item.applyPetSpeed, "펫속도")
end)
_a1745(_a2043, {
{ label = "배수", value = _a1604.PetSpeedMult, onChange = function(_a2045)
local _a2046 = tonumber(_a2045) if _a2046 and _a2046 >= 1 then _a1604.PetSpeedMult = _a2046 end
end },
{ label = "기본 계수 (원래 0.45)", value = _a1604.PetSpeedBase, onChange = function(_a2047)
local _a2048 = tonumber(_a2047) if _a2048 and _a2048 > 0 then _a1604.PetSpeedBase = _a2048 end
end },
})
_a1754(_a2043, {
{ label = "지금 적용 / 확인", col = _a1649.accent, fn = function()
local _a2049, _a2050 = _a1636.item.applyPetSpeed()
_a1600("")
_a1600("──── 펫 이동속도 ────")
_a1600("  PlayerPet 모듈 : " .. (_a1635.PlayerPet and "로드됨" or "없음"))
_a1600(("  적용된 펫 %d마리  (배수 %s / 계수 %s)"):format(
_a2049, tostring(_a1604.PetSpeedMult), tostring(_a1604.PetSpeedBase)))
if _a2050 then _a1600("  " .. tostring(_a2050)) end
if _a2049 == 0 then _a1600("  펫을 장착하고 다시 눌러보세요") end
_a1691("log")
end },
})
_a1648("petspd", function() return 0.4 end, _a1636.item.applyPetSpeed, "펫속도")
_a1648("rewatch", function() return 1 end, function()
_a1636.screen.watchTick = (_a1636.screen.watchTick or 0) + 1
_a1636.egg.watchStuck()
if _a1636.screen.dismissBusy then return end
local _a2051, _a2052 = _a1636.screen.rewardScreenUp()
if _a2051 and _a1636.screen.screenGaveUp and (os.clock() - _a1636.screen.screenGaveUp) < 30 then
return
end
if _a2051 then
if _a1636.screen.lastBlocker ~= _a2052 then
_a1636.screen.lastBlocker = _a2052
_a1600("[화면] " .. tostring(_a2052) .. " 화면 감지 — 넘기는 중")
end
_a1636.screen.dismissRewardScreens(20)
end
end, "보상화면")
local _a2053, _a2054 = _a1724(_a1940, "자동 파밍 유지", nil)
_a1734(_a2054, "farm", function()
_a1648("farm", function() return _a1604.FarmInterval end, _a1639, "파밍")
end)
_a1745(_a2053, {
{ label = "주기", value = _a1604.FarmInterval, onChange = function(_a2055)
local _a2056 = tonumber(_a2055) if _a2056 and _a2056 >= 3 then _a1604.FarmInterval = _a2056 end
end },
})
local _a2057, _a2058 = _a1724(_a1940, "자동 존 해금", nil)
_a1734(_a2058, "zone", function()
_a1648("zone", function() return _a1604.ZoneInterval end, _a1641, "존")
end)
_a1745(_a2057, {
{ label = "주기", value = _a1604.ZoneInterval, onChange = function(_a2059)
local _a2060 = tonumber(_a2059) if _a2060 and _a2060 >= 3 then _a1604.ZoneInterval = _a2060 end
end },
})
_a1754(_a2057, {
{ label = "다음 존 보기", col = _a1649.accent, fn = function()
local _a2061 = _a1640()
_a1600("")
if not _a2061 then _a1600("[존] 다음 존 없음 (최대 도달?)")
else
_a1600("──── 다음 존 ────")
_a1600("  " .. tostring(_a2061.id))
_a1600("  가격 " .. _a1601(_a2061.price or 0, 0) .. " " .. tostring(_a2061.currency))
_a1600("  보유 " .. _a1601(_a2061.have, 0))
_a1600("  " .. (_a2061.ok and "지금 해금 가능" or "부족"))
end
_a1691("log")
end },
{ label = "지금 1회", col = _a1649.cardHi, fn = function()
task.spawn(function() _a1606.zone = true _a1641() _a1606.zone = false _a1691("log") end)
end },
})
local _a2062, _a2063 = _a1724(_a1940, "자동 부화", nil)
_a1734(_a2063, "mhatch", function()
_a1648("mhatch", function() return _a1604.MainHatchInterval end, _a1644, "부화")
end)
_a1745(_a2062, {
{ label = "주기", value = _a1604.MainHatchInterval, onChange = function(_a2064)
local _a2065 = tonumber(_a2064) if _a2065 and _a2065 >= 1 then _a1604.MainHatchInterval = _a2065 end
end },
{ label = "한 번에 최대", value = _a1604.MainHatchMax, onChange = function(_a2066)
local _a2067 = tonumber(_a2066) if _a2067 and _a2067 >= 1 then _a1604.MainHatchMax = math.floor(_a2067) end
end },
})
_a1745(_a2062, {
{ label = "예비금", value = _a1604.MainHatchReserve, onChange = function(_a2068)
local _a2069 = tonumber(_a2068) if _a2069 and _a2069 >= 0 then _a1604.MainHatchReserve = _a2069 end
end },
{ label = "알 ID (비우면 자동)", value = _a1604.MainEggId, onChange = function(_a2070)
_a1604.MainEggId = _a2070 or ""
end },
})
_a1745(_a2062, {
{ label = "알 인식 거리", value = _a1604.EggRange, onChange = function(_a2071)
local _a2072 = tonumber(_a2071) if _a2072 and _a2072 >= 5 then _a1604.EggRange = _a2072 end
end },
})
_a1764(_a2062, "새 맵 열리면 잠긴 알 자동 해금",
function() return _a1604.AutoUnlockEgg end,
function(_a2073) _a1604.AutoUnlockEgg = _a2073 end)
_a1764(_a2062, "게임 내장 오토해치 사용 (기본 끔)",
function() return _a1604.UseAutoHatch end,
function(_a2074) _a1604.UseAutoHatch = _a2074 if not _a2074 then _a1636.egg.autoHatchOff() end end)
_a1764(_a2062, "까는 화면 자동으로 넘기기 (신호)",
function() return _a1604.HatchClick end,
function(_a2075) _a1604.HatchClick = _a2075 end)
_a1754(_a2062, {
{ label = "잠긴 알 보기", col = _a1649.accent, fn = function()
local _a2076, _a2077, _a2078 = _a1636.egg.lockedEggs()
_a1600("")
_a1600("──── 알 해금 현황 ────")
_a1600(("  해금 가능 최대 : #%d   /   현재 해금한 최대 : #%d"):format(_a2077, _a2078))
_a1600("  해금 리모트 : " .. (_a1635.R_EggUn and "있음" or "없음"))
if #_a2076 == 0 then
_a1600("  풀 수 있는 알이 없음 (다 풀었거나 존을 더 사야 함)")
else
_a1600("  아직 안 푼 알 " .. #_a2076 .. "개:")
for _a2079, _a2080 in ipairs(_a2076) do
_a1600(("    #%-3d %s"):format(_a2080.num, _a2080.id))
if _a2079 >= 20 then _a1600("    ...") break end
end
end
_a1691("log")
end },
{ label = "부화 진단", col = _a1649.warn, fn = function()
task.spawn(function()
_a1600("")
_a1600("──── 부화 진단 ────")
local _a2081, _a2082, _a2083, _a2084 = _a1642()
_a1600("  대상 알   : " .. tostring(_a2081))
if not _a2081 then _a1600("  (오픈한 알이 없음)") _a1691("log") return end
local _a2085 = _a2082 and tonumber(rawget(_a2082, "eggNumber"))
_a1600("  알 번호   : " .. tostring(_a2085) .. "   오픈함? " .. tostring(_a1636.egg.eggUnlocked(_a2085)))
_a1600("  거리      : " .. (_a2083 and ("%.0f (사거리 안)"):format(_a2083)
or ((_a2084 and ("%.0f (사거리 %d 밖)"):format(_a2084, _a1604.EggRange)) or "받침대 못 찾음")))
local _a2086 = _a2082 and rawget(_a2082, "currency") or "?"
_a1600("  통화      : " .. tostring(_a2086) .. "   보유 " .. _a1601(_a1638(_a2086), 0))
if type(_a1635.CalcEgg) == "function" then
local _a2087, _a2088 = pcall(_a1635.CalcEgg, _a2082)
_a1600("  CalcEggPricePlayer : " .. (_a2087 and tostring(_a2088) or ("에러 " .. tostring(_a2088))))
end
if type(_a1635.CalcEggB) == "function" then
local _a2089, _a2090 = pcall(_a1635.CalcEggB, _a2082)
_a1600("  CalcEggPrice       : " .. (_a2089 and tostring(_a2090) or ("에러 " .. tostring(_a2090))))
end
if _a1635.Egg then
for _a2091, _a2092 in ipairs({ "GetMaxHatch", "ComputeDebounce", "GetHighestEggNumberAvailable" }) do
if rawget(_a1635.Egg, _a2092) then
local _a2093, _a2094 = pcall(_a1635.Egg[_a2092], _a2082)
_a1600(("  %-28s : %s"):format(_a2092, _a2093 and tostring(_a2094) or ("에러 " .. tostring(_a2094))))
end
end
end
_a1600("  OpeningEgg      : " .. tostring(_a1635.Vars and rawget(_a1635.Vars, "OpeningEgg")))
if _a1635.Hatch then
for _a2095, _a2096 in ipairs({ "IsHatching", "GetEggAmount" }) do
if rawget(_a1635.Hatch, _a2096) then
local _a2097, _a2098 = pcall(_a1635.Hatch[_a2096])
_a1600(("  %-15s : %s"):format(_a2096, _a2097 and tostring(_a2098) or ("에러 " .. tostring(_a2098))))
end
end
if rawget(_a1635.Hatch, "GetEggDirectory") then
local _a2099, _a2100 = pcall(_a1635.Hatch.GetEggDirectory)
_a1600("  세팅된 알       : " .. (_a2099 and _a2100 and tostring(rawget(_a2100, "_id")) or "없음"))
end
end
_a1600("  ▶ SetupEgg 시도")
_a1636.egg._ahEgg = nil
_a1636.egg.autoHatchOn(_a2081, 1)
if _a1635.Hatch and rawget(_a1635.Hatch, "IsHatching") then
local _a2101, _a2102 = pcall(_a1635.Hatch.IsHatching)
_a1600("    IsHatching 이후 : " .. (_a2101 and tostring(_a2102) or ("에러 " .. tostring(_a2102))))
_a1600("    " .. ((_a2101 and _a2102) and "→ 클릭 없이 넘어갑니다"
or "→ SetupEgg 안 먹음. 클릭 대체가 필요합니다"))
end
_a1600("  신호 가능 : getgc " .. tostring(type(getgc) == "function")
.. " / debug.setupvalue " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
_a1600("")
_a1600("  ▶ 1개로 실제 호출")
local _a2103, _a2104
local _a2105 = pcall(function() _a2103, _a2104 = _a1603.R_EGG:InvokeServer(_a2081, 1) end)
_a1600("    호출성공 : " .. tostring(_a2105))
_a1600("    반환1    : " .. tostring(_a2103))
_a1600("    반환2    : " .. tostring(_a2104))
_a1691("log")
end)
end },
{ label = "지금 전부 해금", col = _a1649.good, fn = function()
task.spawn(function()
_a1600("")
local _a2106, _a2107 = _a1636.egg.unlockEggs(true)
_a1600(_a2106 > 0 and ("[해금] %d개 완료"):format(_a2106)
or ("[해금] 0개" .. (_a2107 and (" — " .. tostring(_a2107)) or "")))
_a1691("log")
end)
end },
})
_a1754(_a2062, {
{ label = "알 현황 보기", col = _a1649.accent, fn = function()
local _a2108 = _a1643()
_a1600("")
if not _a2108 then _a1600("[부화] 알을 못 찾음")
else
_a1600("──── 메인 알 ────")
_a1600("  " .. tostring(_a2108.id))
_a1600("  가격 " .. (_a2108.price and _a1601(_a2108.price, 0) or "?") .. " " .. tostring(_a2108.currency))
_a1600("  보유 " .. _a1601(_a2108.have, 0))
_a1600("  한 번에 " .. _a2108.maxN .. "개까지")
_a1600("  지금 가능 " .. _a2108.canBuy .. "회")
if _a2108.inRange then
_a1600(("  거리 %.0f 스터드 — 부화 가능"):format(_a2108.dist))
else
_a1600(("  사거리(%d) 안에 알 없음. 가장 가까운 알 %s스터드"):format(
_a1604.EggRange, _a2108.nearest and ("%.0f"):format(_a2108.nearest) or "?"))
_a1600("  → 알 앞으로 걸어가야 부화됩니다")
end
end
_a1600("")
_a1600("──── 주변 알 (가까운 순 10개) ────")
local _a2109 = _a1636.egg.eggStands()
for _a2110 = 1, math.min(10, #_a2109) do
local _a2111 = _a2109[_a2110]
_a1600(("  %6.0f  #%-3d %-24s %s"):format(
_a2111.dist, _a2111.num, _a2111.id, _a1636.egg.eggUnlocked(_a2111.num) and "오픈함" or "잠김"))
end
if #_a2109 == 0 then _a1600("  (못 찾음)") end
_a1691("log")
end },
{ label = "지금 1회", col = _a1649.cardHi, fn = function()
task.spawn(function() _a1606.mhatch = true _a1644() _a1606.mhatch = false _a1691("log") end)
end },
})
local _a2112, _a2113 = _a1724(_a1940, "랭크 퀘스트 자동", nil)
_a1734(_a2113, "quest", function()
_a1648("quest", function() return _a1604.QuestInterval end, _a1636.quest.cycle, "퀘스트")
end)
_a1745(_a2112, {
{ label = "주기", value = _a1604.QuestInterval, onChange = function(_a2114)
local _a2115 = tonumber(_a2114) if _a2115 and _a2115 >= 5 then _a1604.QuestInterval = _a2115 end
end },
{ label = "포션 한 번에", value = _a1604.QuestUseMax, onChange = function(_a2116)
local _a2117 = tonumber(_a2116) if _a2117 and _a2117 >= 1 then _a1604.QuestUseMax = math.floor(_a2117) end
end },
})
_a1764(_a2112, "필요한 자동화 자동 ON",
function() return _a1604.QuestDrive end,
function(_a2118) _a1604.QuestDrive = _a2118 end)
_a1764(_a2112, "포션/인챈트 업글 퀘스트",
function() return _a1604.QuestUpgrade end,
function(_a2119) _a1604.QuestUpgrade = _a2119 end)
_a1764(_a2112, "포션 사용 퀘스트",
function() return _a1604.QuestUsePotion end,
function(_a2120) _a1604.QuestUsePotion = _a2120 end)
_a1754(_a2112, {
{ label = "퀘스트 현황 보기", col = _a1649.accent, fn = function()
local _a2121 = _a1636.quest.status()
_a1600("")
if not _a2121 then _a1600("[퀘스트] 세이브 못 읽음")
else
_a1600("──── 랭크 퀘스트 ────")
_a1600(("  Rank %d   ★%d"):format(_a2121.rank, _a2121.rankStars))
if #_a2121.list == 0 then _a1600("  퀘스트 없음") end
for _a2122, _a2123 in ipairs(_a2121.list) do
local _a2124 = _a2123.how
local _a2125 =
(_a2124 == "farm" and "자동 파밍") or
(_a2124 == "hatch" and "자동 부화") or
(_a2124 == "zone" and "자동 존") or
(_a2124 == "potup" and "포션 업글") or
(_a2124 == "encup" and "인챈트 업글") or
(_a2124 == "potuse" and "포션 사용") or
(_a2124 == "fruituse" and "과일 사용") or
(_a2124 == "flaguse" and "깃발 사용") or
(_a2124 == "gold" and "골드 머신") or
(_a2124 == "rainbow" and "레인보우 머신") or
"수동"
local _a2126 = ""
if _a2123.ignored then
_a2125 = "무시"
_a2126 = "   → " .. _a2123.ignored
elseif _a2123.event then
local _a2127 = _a1636.ev.findEvent(_a2123.event, _a2123.bestOnly)
_a2126 = _a2127 and ("   → %s @%s %d초"):format(_a2127.name, tostring(_a2127.zone), _a2127.left)
or ("   → " .. _a2123.event .. " 대기중")
elseif _a2123.chest then
_a2126 = "   → " .. _a2123.chest
elseif _a2123.where then
_a2126 = "   → " .. _a2123.where
end
_a1600(("  [%d] %s"):format(_a2123.stars, tostring(_a2123.title)))
_a1600(("       %d / %d    처리: %s   (Type %d)%s"):format(
_a2123.progress, _a2123.amount, _a2125, _a2123.type, _a2126))
end
end
_a1691("log")
end },
{ label = "활성 이벤트 보기", col = _a1649.accent, fn = function()
local _a2128 = _a1636.ev.events()
local _a2129 = _a1636.move.bestZone()
_a1600("")
_a1600("──── 지금 떠 있는 랜덤 이벤트 ────")
_a1600("  최고 존 : " .. tostring(_a2129) .. "   현재 존 : " .. tostring(_a1636.move.curZone()))
if #_a2128 == 0 then _a1600("  없음 (RandomEvents_Get 응답 비어있음)") end
for _a2130, _a2131 in ipairs(_a2128) do
_a1600(("  %-12s @%-20s %4d초 남음  %s%s"):format(
_a2131.kind, tostring(_a2131.zone), _a2131.left,
_a2131.pos and ("(%.0f, %.0f, %.0f)"):format(_a2131.pos.X, _a2131.pos.Y, _a2131.pos.Z) or "좌표없음",
_a2131.zone == _a2129 and "  ★최고존" or ""))
end
_a1600("")
_a1600("  내 소환 아이템 :")
for _a2132 in pairs(_a1636.ev.SPAWN) do
local _a2133 = _a1636.ev.spawnItems(_a2132)
local _a2134 = 0
for _a2135, _a2136 in ipairs(_a2133) do _a2134 += _a2136.am end
_a1600(("    %-12s %d종 %d개"):format(_a2132, #_a2133, _a2134))
for _a2137, _a2138 in ipairs(_a2133) do
_a1600(("        %d. %-24s x%d%s"):format(
_a2137, _a2138.id, _a2138.am, _a2137 == 1 and "   ← 먼저 씀" or ""))
if _a2137 >= 6 then break end
end
end
_a1600("  점선 네모 안? " .. tostring(_a1636.move.inDottedBox()))
for _a2139, _a2140 in ipairs({ "MiniChests", "SuperiorMiniChests" }) do
local _a2141, _a2142 = _a1636.ev.findChest(_a2140)
_a1600(("  %-20s %s"):format(_a2140,
_a2141 and ("가장 가까운 것 %.0f스터드"):format(_a2142 or 0) or "없음"))
end
_a1691("log")
end },
{ label = "포션 재고 보기", col = _a1649.accent, fn = function()
_a1600("")
_a1600("──── 포션 / 인챈트 재고 ────")
for _a2143, _a2144 in ipairs({ "Potion", "Enchant" }) do
local _a2145 = _a1636.item.stacks(_a2144)
table.sort(_a2145, function(_a2146, _a2147)
if _a2146.id ~= _a2147.id then return _a2146.id < _a2147.id end
return _a2146.tier < _a2147.tier
end)
_a1600("")
_a1600(_a2144 .. "  (" .. #_a2145 .. "종)")
for _a2148, _a2149 in ipairs(_a2145) do
local _a2150 = _a1636.item.perTier(_a2144, _a2149.tier)
local _a2151 = _a2150 and math.floor(_a2149.am / _a2150) or 0
_a1600(("   %-20s T%-2d x%-6d %s"):format(
_a2149.id, _a2149.tier, _a2149.am,
_a2151 > 0 and ("→ T" .. (_a2149.tier + 1) .. " " .. _a2151 .. "개 제작가능") or ""))
if _a2148 >= 40 then _a1600("   ...") break end
end
if #_a2145 == 0 then _a1600("   (없음)") end
end
_a1691("log")
end },
{ label = "지금 1회", col = _a1649.cardHi, fn = function()
task.spawn(function() _a1606.quest = true _a1636.quest.cycle() _a1606.quest = false _a1691("log") end)
end },
})
local _a2152, _a2153 = _a1724(_a1940, "슬롯 머신 자동 (다이아)", nil)
_a1734(_a2153, "slots", function()
_a1648("slots", function() return _a1604.SlotInterval end, _a1636.mach.cycleSlots, "슬롯")
end)
_a1745(_a2152, {
{ label = "주기", value = _a1604.SlotInterval, onChange = function(_a2154)
local _a2155 = tonumber(_a2154) if _a2155 and _a2155 >= 5 then _a1604.SlotInterval = _a2155 end
end },
{ label = "남길 다이아", value = _a1604.SlotReserve, onChange = function(_a2156)
local _a2157 = tonumber(_a2156) if _a2157 and _a2157 >= 0 then _a1604.SlotReserve = _a2157 end
end },
})
_a1764(_a2152, "펫 장착 슬롯 (Pet Equip)",
function() return _a1604.SlotPet end, function(_a2158) _a1604.SlotPet = _a2158 end)
_a1764(_a2152, "알 부화 슬롯 (Egg Machine)",
function() return _a1604.SlotEgg end, function(_a2159) _a1604.SlotEgg = _a2159 end)
_a1754(_a2152, {
{ label = "슬롯 현황 보기", col = _a1649.accent, fn = function()
local _a2160 = _a1636.mach.slotStatus()
_a1600("")
_a1600("──── 슬롯 머신 ────")
if not _a2160 then _a1600("  세이브 못 읽음") _a1691("log") return end
_a1600("  다이아 " .. _a1601(_a2160.dia, 0))
_a1600("")
_a1600(("  펫 장착 : 구매 %d / 랭크상한 %d   현재 최대장착 %s"):format(
_a2160.petOwned, _a2160.petMax, tostring(_a2160.maxEquip)))
if _a2160.petNext then
_a1600(("     다음 #%d  %s 다이아  %s"):format(
_a2160.petNext, _a2160.petCost and _a1601(_a2160.petCost, 0) or "?",
(_a2160.petCost and _a2160.petCost <= _a2160.dia - _a1604.SlotReserve) and "← 지금 가능" or "부족"))
else
_a1600("     랭크 상한까지 다 삼 (랭크를 올려야 더 살 수 있음)")
end
_a1600("")
_a1600(("  알 부화 : 구매 %d / 랭크상한 %d   한 번에 %s개"):format(
_a2160.eggOwned, _a2160.eggMax, tostring(_a2160.maxHatch)))
if _a2160.eggEnd then
_a1600(("     다음 %d칸 묶음 → %d   %s 다이아  %s"):format(
_a2160.eggSize, _a2160.eggEnd, _a2160.eggCost and _a1601(_a2160.eggCost, 0) or "?",
(_a2160.eggCost and _a2160.eggCost <= _a2160.dia - _a1604.SlotReserve) and "← 지금 가능" or "부족"))
else
_a1600("     랭크 상한까지 다 삼")
end
_a1600("")
_a1600("  리모트 : 펫 " .. (_a1635.R_PetSlot and "O" or "X")
.. " / 알 " .. (_a1635.R_EggSlot and "O" or "X"))
_a1691("log")
end },
{ label = "지금 1회", col = _a1649.cardHi, fn = function()
task.spawn(function() _a1606.slots = true _a1636.mach.cycleSlots() _a1606.slots = false _a1691("log") end)
end },
})
local _a2161, _a2162 = _a1724(_a1940, "아이템 자동 사용 (버프 유지)", nil)
_a1734(_a2162, "items", function()
_a1648("items", function() return _a1604.ItemInterval end, _a1636.item.cycleItems, "아이템")
end)
_a1745(_a2161, {
{ label = "주기", value = _a1604.ItemInterval, onChange = function(_a2163)
local _a2164 = tonumber(_a2163) if _a2164 and _a2164 >= 5 then _a1604.ItemInterval = _a2164 end
end },
{ label = "포션 한 바퀴 최대", value = _a1604.BuffMaxPotion, onChange = function(_a2165)
local _a2166 = tonumber(_a2165) if _a2166 and _a2166 >= 1 then _a1604.BuffMaxPotion = math.floor(_a2166) end
end },
})
_a1745(_a2161, {
{ label = "남길 개수", value = _a1604.ItemKeep, onChange = function(_a2167)
local _a2168 = tonumber(_a2167) if _a2168 and _a2168 >= 0 then _a1604.ItemKeep = math.floor(_a2168) end
end },
{ label = "과일/소모품 최대", value = _a1604.BuffMaxOther, onChange = function(_a2169)
local _a2170 = tonumber(_a2169) if _a2170 and _a2170 >= 1 then _a1604.BuffMaxOther = math.floor(_a2170) end
end },
})
_a1745(_a2161, {
{ label = "쓸 것 (비우면 전부)", value = _a1604.ItemAllow, onChange = function(_a2171)
_a1604.ItemAllow = _a2171 or ""
end },
{ label = "제외", value = _a1604.ItemBlock, onChange = function(_a2172)
_a1604.ItemBlock = _a2172 or ""
end },
})
_a1764(_a2161, "포션", function() return _a1604.BuffPotion end,
function(_a2173) _a1604.BuffPotion = _a2173 end)
_a1764(_a2161, "과일", function() return _a1604.BuffFruit end,
function(_a2174) _a1604.BuffFruit = _a2174 end)
_a1764(_a2161, "얼티밋 (충전되면 발동, 무료)", function() return _a1604.BuffUltimate end,
function(_a2175) _a1604.BuffUltimate = _a2175 end)
_a1764(_a2161, "소모품 (Rain/Sunlight 주의)", function() return _a1604.BuffConsumable end,
function(_a2176) _a1604.BuffConsumable = _a2176 end)
_a1764(_a2161, "높은 티어부터 사용 (끄면 낮은 것부터)", function() return _a1604.BuffHighTier end,
function(_a2177) _a1604.BuffHighTier = _a2177 end)
_a1764(_a2161, "최고 존에서만 사용", function() return _a1604.ItemBestZone end,
function(_a2178) _a1604.ItemBestZone = _a2178 end)
_a1764(_a2161, "최고 존이 아니면 이동 후 사용", function() return _a1604.ItemTp end,
function(_a2179) _a1604.ItemTp = _a2179 end)
_a1754(_a2161, {
{ label = "버프 현황 보기", col = _a1649.accent, fn = function()
_a1600("")
_a1600("──── 버프 / 아이템 ────")
_a1600(("  현재 존 %s / 최고 존 %s%s"):format(
tostring(_a1636.move.curZone()), tostring(_a1636.move.bestZone()),
_a1604.ItemBestZone and (_a1636.move.curZone() == _a1636.move.bestZone() and "   ← 사용 가능" or "   ← 이동 필요") or ""))
for _a2180, _a2181 in pairs({ Potions = "Potion", Fruits = "Fruit" }) do
local _a2182 = _a1636.item.activeBuffs(_a2180)
local _a2183 = {}
for _a2184 in pairs(_a2182) do _a2183[#_a2183 + 1] = _a2184 end
table.sort(_a2183)
_a1600(("  지금 걸린 %s : %s"):format(_a2180,
#_a2183 > 0 and table.concat(_a2183, ", ") or "없음"))
end
local _a2185 = _a1637()
local _a2186 = _a2185 and rawget(_a2185, "Ultimates")
if type(_a2186) == "table" then
local _a2187 = {}
for _a2188 in pairs(_a2186) do
local _a2189 = "?"
if _a1635.Ult and rawget(_a1635.Ult, "IsCharged") then
local _a2190, _a2191 = pcall(_a1635.Ult.IsCharged, _a2188)
_a2189 = _a2190 and (_a2191 and "충전됨" or "충전중") or "?"
end
_a2187[#_a2187 + 1] = _a2188 .. "(" .. _a2189 .. ")"
end
_a1600("  얼티밋 : " .. (#_a2187 > 0 and table.concat(_a2187, ", ") or "없음"))
end
_a1600("")
for _a2192, _a2193 in ipairs({ "Potion", "Fruit", "Consumable" }) do
local _a2194 = _a1636.item.stacks(_a2193)
local _a2195, _a2196 = 0, 0
for _a2197, _a2198 in ipairs(_a2194) do
if _a1636.item.itemAllowed(_a2198.id) then _a2195 += 1 else _a2196 += 1 end
end
_a1600(("  %-12s %d종 (쓸 수 있음 %d / 제외 %d)"):format(_a2193, #_a2194, _a2195, _a2196))
for _a2199, _a2200 in ipairs(_a2194) do
_a1600(("      %-20s T%-2d x%-6d %s"):format(
_a2200.id, _a2200.tier, _a2200.am, _a1636.item.itemAllowed(_a2200.id) and "" or "제외됨"))
if _a2199 >= 12 then _a1600("      ...") break end
end
end
_a1600("")
_a1600("  리모트 : 포션 " .. (_a1635.R_PotUse and "O" or "X")
.. " / 과일 " .. (_a1635.R_Fruit and "O" or "X")
.. " / 소모품 " .. (_a1635.R_Cons and "O" or "X")
.. " / 얼티밋 " .. (_a1635.R_Ult and "O" or "X"))
_a1691("log")
end },
{ label = "지금 1회", col = _a1649.cardHi, fn = function()
task.spawn(function() _a1606.items = true _a1636.item.cycleItems() _a1606.items = false _a1691("log") end)
end },
})
local _a2201, _a2202 = _a1724(_a1940, "맵 업그레이드 자동 (다이아)", nil)
_a1734(_a2202, "mapupg", function()
_a1648("mapupg", function() return _a1604.UpgInterval end, _a1636.mach.cycleUpg, "맵업글")
end)
_a1745(_a2201, {
{ label = "주기", value = _a1604.UpgInterval, onChange = function(_a2203)
local _a2204 = tonumber(_a2203) if _a2204 and _a2204 >= 5 then _a1604.UpgInterval = _a2204 end
end },
{ label = "남길 다이아", value = _a1604.UpgReserve, onChange = function(_a2205)
local _a2206 = tonumber(_a2205) if _a2206 and _a2206 >= 0 then _a1604.UpgReserve = _a2206 end
end },
})
_a1764(_a2201, "구매 전 그 앞으로 이동",
function() return _a1604.UpgTp end,
function(_a2207) _a1604.UpgTp = _a2207 end)
_a1754(_a2201, {
{ label = "업그레이드 목록", col = _a1649.accent, fn = function()
local _a2208 = _a1636.mach.upgList()
local _a2209 = _a1638("Diamonds")
_a1600("")
_a1600("──── 맵 업그레이드 ────")
_a1600("보유 다이아 " .. _a1601(_a2209, 0))
if #_a2208 == 0 then
_a1600("  로드된 업그레이드 기둥이 없음 (해당 존에 가야 보입니다)")
end
local _a2210, _a2211, _a2212 = 0, 0, 0
for _a2213, _a2214 in ipairs(_a2208) do
if _a2214.bought then _a2211 += 1
elseif not _a2214.zoneOwned then _a2212 += 1
else _a2210 += 1 end
end
_a1600(("  구매가능 %d / 구매완료 %d / 존 미보유 %d"):format(_a2210, _a2211, _a2212))
_a1600("")
local _a2215 = 0
for _a2216, _a2217 in ipairs(_a2208) do
if _a2217.buyable then
_a2215 += 1
_a1600(("  %-12s T%-2d %-20s %12s %-9s %s"):format(
_a2217.id, _a2217.tier, _a2217.zone, _a2217.cost and _a1601(_a2217.cost, 0) or "?",
tostring(_a2217.cur),
(_a2217.cost and _a2217.cost <= _a1638(_a2217.cur or "Diamonds") - _a1604.UpgReserve)
and "← 지금 가능" or ""))
if _a2215 >= 25 then _a1600("  ...") break end
end
end
_a1691("log")
end },
{ label = "업글 진단", col = _a1649.warn, fn = function()
task.spawn(function()
_a1600("")
_a1600("──── 맵 업그레이드 진단 ────")
_a1600("  리모트 : " .. (_a1635.R_Upg and _a1635.R_Upg:GetFullName() or "없음"))
local _a2218 = _a1636.mach.upgList()
_a1600("  로드된 기둥 " .. #_a2218 .. "개")
local _a2219
for _a2220, _a2221 in ipairs(_a2218) do
if _a2221.buyable and _a2221.cost then _a2219 = _a2221 break end
end
if not _a2219 then
_a1600("  살 수 있는 게 없음 (전부 구매완료거나 존 미보유)")
for _a2222, _a2223 in ipairs(_a2218) do
_a1600(("   %-12s T%-2d @%-18s 구매됨=%s 존보유=%s"):format(
_a2223.id, _a2223.tier, tostring(_a2223.zone), tostring(_a2223.bought), tostring(_a2223.zoneOwned)))
if _a2222 >= 8 then _a1600("   ...") break end
end
_a1691("log") return
end
local _a2224 = _a1638(_a2219.cur or "Diamonds")
local _a2225 = _a1636.move.hrp()
local _a2226 = (_a2225 and _a2219.pos) and (_a2225.Position - _a2219.pos).Magnitude or nil
_a1600(("  대상 : %s T%d @%s"):format(_a2219.id, _a2219.tier, tostring(_a2219.zone)))
_a1600(("  가격 : %s %s / 보유 %s"):format(
_a1601(_a2219.cost, 0), tostring(_a2219.cur), _a1601(_a2224, 0)))
_a1600("  거리 : " .. (_a2226 and ("%.0f 스터드"):format(_a2226) or "좌표 없음"))
_a1600("")
_a1600("  ▶ 제자리에서 호출")
local _a2227, _a2228
local _a2229 = pcall(function() _a2227, _a2228 = _a1635.R_Upg:InvokeServer(_a2219.id, _a2219.zone) end)
_a1600("    호출성공 " .. tostring(_a2229) .. " / 반환1 " .. tostring(_a2227)
.. " / 반환2 " .. tostring(_a2228))
if not _a2227 and _a2219.pos then
_a1600("")
_a1600("  ▶ 기둥 앞으로 이동해서 재시도")
_a1636.move.glideTo(_a2219.pos)
task.wait(0.3)
local _a2230 = _a1636.move.hrp()
_a1600("    이동후 거리 " .. (_a2230 and ("%.0f"):format((_a2230.Position - _a2219.pos).Magnitude) or "?"))
local _a2231, _a2232
local _a2233 = pcall(function() _a2231, _a2232 = _a1635.R_Upg:InvokeServer(_a2219.id, _a2219.zone) end)
_a1600("    호출성공 " .. tostring(_a2233) .. " / 반환1 " .. tostring(_a2231)
.. " / 반환2 " .. tostring(_a2232))
_a1600("")
_a1600(_a2231 and "  → 거리 검사 있음. 이동해야 됩니다."
or "  → 이동해도 실패. 거리 문제가 아닙니다.")
else
_a1600("")
_a1600(_a2227 and "  → 원격으로 됩니다. 이동 불필요." or "  → 실패 (좌표 없음)")
end
_a1691("log")
end)
end },
{ label = "지금 1회", col = _a1649.cardHi, fn = function()
task.spawn(function() _a1606.mapupg = true _a1636.mach.cycleUpg() _a1606.mapupg = false _a1691("log") end)
end },
})
local _a2234, _a2235 = _a1724(_a1940, "자동 리버스", nil)
_a1734(_a2235, "mreb", function()
_a1648("mreb", function() return _a1604.MainRebirthInterval end, _a1646, "리버스")
end)
_a1745(_a2234, {
{ label = "주기", value = _a1604.MainRebirthInterval, onChange = function(_a2236)
local _a2237 = tonumber(_a2236) if _a2237 and _a2237 >= 10 then _a1604.MainRebirthInterval = _a2237 end
end },
})
_a1764(_a2234, "실패 이유 로그",
function() return _a1604.MainRebirthVerbose end,
function(_a2238) _a1604.MainRebirthVerbose = _a2238 end)
_a1754(_a2234, {
{ label = "리버스 현황 보기", col = _a1649.accent, fn = function()
local _a2239 = _a1645()
_a1600("")
if not _a2239 then _a1600("[리버스] 세이브 못 읽음")
else
_a1600("──── 메인 리버스 ────")
_a1600("  현재 " .. _a2239.current .. "회 → 다음 " .. _a2239.nextN)
if type(_a2239.def) == "table" then
for _a2240, _a2241 in pairs(_a2239.def) do
if type(_a2241) ~= "table" and type(_a2241) ~= "function" then
_a1600("    " .. tostring(_a2240) .. " = " .. tostring(_a2241))
end
end
end
end
_a1691("log")
end },
{ label = "지금 1회", col = _a1649.bad, fn = function()
task.spawn(function() _a1606.mreb = true _a1646() _a1606.mreb = false _a1691("log") end)
end },
})
local _a2242 = _a1724(_a1940, "전체 제어", nil)
_a1754(_a2242, {
{ label = "메인 전부 ON", col = _a1649.good, fn = function()
local _a2243 = {
{ "farm",   function() return _a1604.FarmInterval end,       _a1639,       "파밍" },
{ "zone",   function() return _a1604.ZoneInterval end,       _a1641,       "존" },
{ "mhatch", function() return _a1604.MainHatchInterval end,  _a1644,  "부화" },
{ "quest",  function() return _a1604.QuestInterval end,      _a1636.quest.cycle,        "퀘스트" },
{ "mapupg", function() return _a1604.UpgInterval end,        _a1636.mach.cycleUpg,     "맵업글" },
{ "items",  function() return _a1604.ItemInterval end,       _a1636.item.cycleItems,   "아이템" },
{ "slots",  function() return _a1604.SlotInterval end,       _a1636.mach.cycleSlots,   "슬롯" },
}
for _a2244, _a2245 in ipairs(_a2243) do
if not _a1606[_a2245[1]] then
_a1606[_a2245[1]] = true
_a1648(_a2245[1], _a2245[2], _a2245[3], _a2245[4])
end
end
_a1731()
_a1600("[메인] 파밍/존/부화/랭크/퀘스트/맵업글 ON  (리버스는 따로)")
end },
{ label = "메인 전부 OFF", col = _a1649.bad, fn = function()
_a1636.ctl.stopAll()
_a1731()
_a1600("[메인] 정지")
end },
})
end
_a1682.MouseButton1Click:Connect(function()
local _a2246 = table.concat(_a1599, "\n")
if #_a2246 > 900000 then _a2246 = _a2246:sub(#_a2246 - 900000) end
if type(setclipboard) == "function" then
pcall(setclipboard, _a2246)
_a1682.Text = "완료"
task.delay(1.5, function() if _a1682 then _a1682.Text = "복사" end end)
end
end)
_a1681.MouseButton1Click:Connect(function()
table.clear(_a1599)
_a1776.top = nil
_a1595.dirty = true
end)
local function _a2247()
_a1606.place, _a1606.merchant, _a1606.upgrade = false, false, false
_a1606.towerup, _a1606.crop, _a1606.expand, _a1606.rebirth, _a1606.hatch, _a1606.luck = false, false, false, false, false, false
_a1606.farm, _a1606.zone, _a1606.mhatch, _a1606.rank, _a1606.mreb = false, false, false, false, false
if _a1796 then _a1796:Disconnect() end
if _a1667 then _a1667:Destroy() end
_G.__PS99_GARDEN = nil
end
_a1679.MouseButton1Click:Connect(_a2247)
_G.__PS99_GARDEN = _a2247
_a1691("dash")
_a1600("PS99 자동")
if _a1595.lpWait then
_a1600(("[진단] LocalPlayer 가 늦게 잡혔습니다 — %.1f초 대기, 결과 %s")
:format(_a1595.lpWait, _a1595.lpFail and "★ 실패" or "성공"))
end
if _a1595.lpFail then
_a1600("[진단] ★ LocalPlayer 를 못 잡아 이동·부화가 전부 안 됩니다.")
_a1600("        게임이 완전히 로드된 뒤에 다시 실행해 주세요.")
end
if _a1595.libWait then
_a1600(("[진단] 게임 모듈(Library/Network)도 늦게 잡혔습니다 — %.1f초 대기")
:format(_a1595.libWait))
end
if _a1595.libFail then
_a1600("[진단] ★ " .. _a1595.libFail .. " 를 못 찾았습니다 — 게임 로드 후 다시 실행하세요")
end
if _a1606.auto then
if _a1636.auto.start then
_a1600("[자동] 올 자동 켜짐 — 1초 뒤 시작합니다")
task.spawn(function()
task.wait(1)
_a1636.ctl.abort = false
local _a2248, _a2249 = pcall(_a1636.auto.start)
if _a2248 then
_a1600("[자동] 시작됨")
else
_a1606.auto = false
_a1600("[자동] 시작 실패: " .. tostring(_a2249))
if _a1636.auto.refresh then pcall(_a1636.auto.refresh) end
end
end)
else
_a1606.auto = false
_a1600("[자동] QS.auto.start 가 없습니다 — 메인 게임 탭이 안 만들어짐")
end
end
pcall(function()
local _a2250, _a2251, _a2252, _a2253 = _a1609()
if _a2250 and _a2252 then
local _a2254 = _a1610(_a2252, _a2253)
_a1607.slots = #_a2254
_a1600("레인 " .. _a2253 .. " / 슬롯 " .. #_a2254)
else
_a1600("가든 이벤트 밖입니다 (이벤트 탭은 이벤트 안에서만 동작)")
end
_a1607.sun = _a1615()
_a1600("Sunflowers " .. _a1601(_a1607.sun, 0))
end)
end)(_a1)
