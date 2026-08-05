local _a1 = {}
local _a2  = game:GetService("ReplicatedStorage")
local _a3 = game:GetService("UserInputService")
local _a4 = game:GetService("RunService")
local _a5  = game:GetService("Players").LocalPlayer
if _G.__PS99_GARDEN then pcall(_G.__PS99_GARDEN) end
local _a6, _a7 = {}, 3000
local function _a8(_a9)
_a6[#_a6 + 1] = tostring(_a9)
if #_a6 > _a7 then table.remove(_a6, 1) end
_a1.dirty = true
end
local function _a10(_a11, _a12)
if type(_a11) ~= "number" then return tostring(_a11) end
if _a11 ~= _a11 then return "0" end
return string.format("%." .. (_a12 or 1) .. "f", _a11)
end
local function _a13(...)
local _a14 = _a2
for _a15, _a16 in ipairs({ ... }) do
if not _a14 then return nil end
_a14 = _a14:FindFirstChild(_a16)
end
if not _a14 then return nil end
local _a17, _a18 = pcall(require, _a14)
return _a17 and _a18 or nil
end
local _a19 = {
EntityPlacement = _a13("Library", "Client", "PvCombatCmds", "EntityPlacement"),
ClientTowerDefense = _a13("Library", "Client", "PvCombatCmds", "ClientTowerDefense"),
ClientPlot = _a13("Library", "Client", "PlotCmds", "ClientPlot"),
LaneUnlock = _a13("Library", "Client", "PvCombatCmds", "LaneUnlock"),
ClientTower = _a13("Library", "Client", "PvCombatCmds", "ClientTowerDefense", "EntityRegistry", "ClientTower"),
GardenLaneFacing = _a13("Library", "Util", "GardenLaneFacing"),
GardenDefenders = _a13("Library", "Util", "GardenDefenders"),
TowerItem = _a13("Library", "Items", "TowerItem"),
Save = _a13("Library", "Client", "Save"),
EventUpgradeCmds = _a13("Library", "Client", "EventUpgradeCmds"),
GardenPlots = _a13("Library", "Util", "GardenPlots"),
PvCropGrowth = _a13("Library", "PvCropGrowth"),
FFlagsM = _a13("Library", "Universal", "FFlags"),
}
local function _a20(_a21)
if type(_a19.FFlagsM) ~= "table" then return nil end
local _a22 = rawget(_a19.FFlagsM, "Keys")
local _a23 = _a22 and _a22[_a21]
if _a23 == nil then return nil end
local _a24, _a25 = pcall(_a19.FFlagsM.GetNumber, _a23)
return _a24 and tonumber(_a25) or nil
end
local _a26      = _a2:WaitForChild("Network")
local _a27 = {
R_ATTACH = _a26:FindFirstChild("WD_Attach"),
R_DETACH = _a26:FindFirstChild("OR_Detach"),
R_PROMO = _a26:FindFirstChild("EK_Promote"),
R_BUY = _a26:FindFirstChild("Merchant_RequestPurchase"),
R_EVUP = _a26:FindFirstChild("EventUpgrades: Purchase"),
R_WIDEN = _a26:FindFirstChild("PG_Widen"),
R_JC = _a26:FindFirstChild("JC_Manifest"),
R_WK = _a26:FindFirstChild("WK_Reclaim"),
R_EGG = _a26:FindFirstChild("Eggs_RequestPurchase"),
R_CEGG = _a26:FindFirstChild("CustomEggs_Hatch"),
R_LUCK = _a26:FindFirstChild("GardenChanceMachine_AddTime"),
}
if not (_a19.EntityPlacement and _a19.ClientTowerDefense and _a19.ClientPlot and _a19.GardenLaneFacing and _a19.TowerItem and _a27.R_ATTACH) then
warn("[PS99 Garden] 필수 모듈 로드 실패 — Garden 이벤트 안에서 실행해 주세요")
end
local _a28 = {
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
local _a29 = { Shiny = 1.5, Gold = 2, Rainbow = 4 }
local _a30 = {}
local _a31 = { place = false, merchant = false, upgrade = false, towerup = false,
crop = false, expand = false, rebirth = false, hatch = false, luck = false,
farm = false, zone = false, mhatch = false, rank = false, mreb = false,
quest = false, mapupg = false, items = false, slots = false,
auto = true, petspd = true, rewatch = true }
local _a32 = { slots = 0, filled = 0, empty = 0, placed = 0, swapped = 0, bought = 0,
upgraded = 0, sun = 0, replant = 0, hatched = 0, luck = 0,
farm = 0, zone = 0, mhatch = 0, rank = 0, mreb = 0,
quest = 0, potup = 0, potuse = 0, mapupg = 0, items = 0, mslot = 0 }
_a28.CropInterval = 20
_a28.CropMargin   = 1.5
_a28.SkipUnhatched = true
_a28.MinSunflowers  = 0
_a28.BuyUnknownCost = false
_a28.ExpandInterval  = 20
_a28.RebirthInterval = 30
_a28.HatchInterval = 5
_a28.HatchMax      = 100
_a28.HatchReserve  = 0
_a28.HatchEggNum   = 0
_a28.HatchUid      = ""
_a28.LuckInterval  = 3600
_a28.LuckReserve   = 0
_a28.LuckMinTopUp  = 600
_a28.LuckBoosts    = { Huge = true, Titanic = true, Gargantuan = true }
_a28.FarmInterval        = 10
_a28.ZoneInterval        = 10
_a28.MainHatchInterval   = 1
_a28.MainHatchMax        = 100
_a28.MainHatchReserve    = 0
_a28.MainEggId           = ""
_a28.RankInterval        = 30
_a28.MainRebirthInterval = 60
_a28.MainRebirthVerbose  = false
_a28.MaxBedScan     = 80
_a28.QuestInterval  = 10
_a28.QuestUpgrade   = true
_a28.QuestUsePotion = true
_a28.QuestDrive     = true
_a28.QuestUseMax    = 20
_a28.EggRange       = 40
_a28.QuestTp        = true
_a28.TpMode     = "instant"
_a28.TpSpeed    = 160
_a28.TpHeight   = 0
_a28.ArriveDist = 12
_a28.ZoneArriveDist = 90
_a28.QuestLock  = true
_a28.SpawnPerCycle = 1
_a28.EventStayDist = 45
_a28.AutoInterval = 5
_a28.HoldZoneForQuest = true
_a28.HatchBudget  = 25
_a28.ScreenTryMax   = 8
_a28.ScreenRealClick = true
_a28.PursueStallSec = 60
_a28.HatchMinAfford = 10
_a28.MoneyDwell     = 60
_a28.IdleHatch      = false
_a28.PetSpeedMult = 50
_a28.PetSpeedBase = 4
_a28.TpGameFallback = false
_a28.TpCooldown = 2.5
_a28.HatchAutoTp = true
_a28.AutoUnlockEgg = true
_a28.UseAutoHatch  = true
_a28.HatchClick    = true
_a28.HatchClickAfter = 0.6
_a28.TpToBreakables = true
_a28.UpgInterval  = 30
_a28.UpgReserve   = 0
_a28.UpgTp        = true
_a28.SlotInterval = 30
_a28.SlotReserve  = 0
_a28.SlotPet      = true
_a28.SlotEgg      = true
_a28.ItemInterval  = 20
_a28.BuffPotion    = true
_a28.BuffFruit     = true
_a28.BuffUltimate  = true
_a28.BuffConsumable = false
_a28.BuffHighTier  = true
_a28.ItemKeep      = 0
_a28.ItemAllow     = ""
_a28.ItemBlock     = "Rain, Sunlight"
_a28.ItemBestZone  = true
_a28.ItemTp        = false
_a28.BuffMaxPotion = 5
_a28.BuffMaxOther  = 2
_a1.RS, _a1.UIS, _a1.RunService, _a1.LP, _a1.LOG, _a1.log = _a2, _a3, _a4, _a5, _a6, _a8
_a1.num, _a1.req, _a1.LB, _a1.ff, _a1.NET, _a1.RM = _a10, _a13, _a19, _a20, _a26, _a27
_a1.CFG, _a1.VARIANT, _a1.EGG_COST_CACHE, _a1.RUN, _a1.STAT = _a28, _a29, _a30, _a31, _a32
;(function(_a33)
local _a34, _a35, _a36, _a37, _a38, _a39 = _a33.RS, _a33.LP, _a33.log, _a33.num, _a33.req, _a33.LB
local _a40, _a41, _a42, _a43, _a44, _a45 = _a33.ff, _a33.RM, _a33.CFG, _a33.VARIANT, _a33.EGG_COST_CACHE, _a33.RUN
local _a46 = _a33.STAT
local _a47
local _a48 = {
"GardenMoreDamage", "GardenFasterAttacks", "GardenMoreCoins",
"GardenBetterEggs", "GardenBetterLuck", "GardenBiggerHarvest",
"GardenFasterCrops", "GardenMoreSeeds",
}
local _a49
local function _a50()
if _a49 then return _a49 end
_a49 = {}
local _a51 = _a34:FindFirstChild("__DIRECTORY")
_a51 = _a51 and _a51:FindFirstChild("TowerDefenseTowers")
if _a51 then
for _a52, _a53 in ipairs(_a51:GetDescendants()) do
if _a53:IsA("ModuleScript") then
local _a54, _a55 = pcall(require, _a53)
if _a54 and type(_a55) == "table" then _a49[rawget(_a55, "_id") or _a53.Name] = _a55 end
end
end
end
return _a49
end
local function _a56(_a57, _a58, _a59)
local _a60 = _a50()[_a57]
if type(_a60) ~= "table" then return 0 end
local _a61 = tonumber(rawget(_a60, "AttackDamage")) or 0
local _a62 = tonumber(rawget(_a60, "AttackSpeed")) or 0
local _a63, _a64 = _a61 * _a62, 0
local _a65 = rawget(_a60, "Projectile")
if type(_a65) == "table" then
local _a66 = rawget(_a65, "ApplyDots")
if type(_a66) == "table" then
for _a67, _a68 in pairs(_a66) do
if type(_a68) == "table" then
local _a69  = tonumber(rawget(_a68, "Duration")) or 0
local _a70 = tonumber(rawget(_a68, "TickDelta")) or 0
local _a71  = tonumber(rawget(_a68, "DamageMult")) or 1
local _a72   = tonumber(rawget(_a68, "Probability")) or 1
if _a70 > 0 and _a69 > 0 and _a62 > 0 then
_a64 += (_a61 * _a71 * _a72 / _a70) * math.min(1, _a69 * _a62) * _a42.DotFactor
end
end
end
end
local _a73 = tonumber(rawget(_a65, "LingerDuration")) or 0
if _a73 > 0 and _a62 > 0 then _a64 += _a63 * math.min(1, _a73 * _a62) * 0.5 * _a42.DotFactor end
end
local _a74 = (_a63 + _a64) * (_a43[_a58 or ""] or 1)
return (_a74 ~= _a74) and 0 or _a74
end
local function _a75(_a76, _a77)
if type(_a76) ~= "string" then return nil end
return string.match(_a76, '"' .. _a77 .. '"%s*:%s*"([^"]*)"')
end
local function _a78(_a79)
if type(_a79) ~= "table" and typeof(_a79) ~= "userdata" then return nil, nil end
local _a80, _a81
pcall(function() _a80 = rawget(_a79, "_stackKey") end)
pcall(function() _a81 = rawget(_a79, "_exactStackKey") end)
if not _a80 then pcall(function() _a80 = _a79._stackKey end) end
if not _a81 then pcall(function() _a81 = _a79._exactStackKey end) end
local _a82 = _a75(_a80, "id") or _a75(_a81, "id")
local _a83 = _a75(_a80, "vr") or _a75(_a81, "vr")
return _a82, _a83
end
local function _a84(_a85)
local _a86
if _a39.GardenDefenders and _a39.GardenDefenders.UnitKey then
pcall(function() _a86 = _a39.GardenDefenders.UnitKey(_a85) end)
end
if _a86 ~= nil then return tostring(_a86) end
local _a87, _a88 = _a78(_a85)
return tostring(_a87) .. "|" .. tostring(_a88 or "")
end
local function _a89()
local _a90 = {}
if not _a39.Save then return _a90 end
local _a91, _a92 = pcall(_a39.Save.Get)
if not _a91 or type(_a92) ~= "table" then return _a90 end
local _a93 = _a92.Inventory and _a92.Inventory.Tower
if type(_a93) ~= "table" then return _a90 end
for _a94, _a95 in pairs(_a93) do
if type(_a95) == "table" then _a90[_a94] = { id = _a95.id, vr = _a95.vr } end
end
return _a90
end
local function _a96()
local _a97, _a98
pcall(function()
_a97 = _a39.ClientTowerDefense and _a39.ClientTowerDefense.GetLocal and _a39.ClientTowerDefense.GetLocal()
end)
pcall(function()
_a98 = _a39.ClientPlot and _a39.ClientPlot.GetLocal and _a39.ClientPlot.GetLocal()
end)
local _a99
if _a98 then pcall(function() _a99 = _a98:GetModel() end) end
local _a100 = 0
if _a39.LaneUnlock and _a98 then
local _a101, _a102 = pcall(_a39.LaneUnlock.UnlockedFor, _a98)
if _a101 then _a100 = tonumber(_a102) or 0 end
end
return _a97, _a98, _a99, _a100
end
local function _a103(_a104, _a105)
local _a106 = {}
local _a107 = _a104 and _a104:FindFirstChild("Lanes")
if not _a107 then return _a106 end
for _a108, _a109 in ipairs(_a107:GetChildren()) do
local _a110 = tonumber(_a109.Name)
if _a110 and _a110 <= _a105 then
local _a111 = _a109:FindFirstChild("Slots")
if _a111 then
for _a112, _a113 in ipairs(_a111:GetChildren()) do
if _a113:IsA("BasePart") then
_a106[#_a106 + 1] = {
part = _a113, lane = _a110,
pos = _a113.Position + Vector3.new(0, _a113.Size.Y / 2, 0),
}
end
end
end
end
end
return _a106
end
local function _a114(_a115)
local _a116
pcall(function() _a116 = _a115:GetUpgrade() end)
if type(_a116) == "number" then return _a116 end
pcall(function()
local _a117 = rawget(_a115, "State")
local _a118 = _a117 and rawget(_a117, "Upgrade")
_a116 = _a118 and rawget(_a118, "Value")
end)
return tonumber(_a116) or 0
end
local function _a119(_a120)
local _a121
pcall(function() _a121 = _a120:GetId() end)
if type(_a121) == "number" then return _a121 end
pcall(function() _a121 = rawget(_a120, "Id") end)
return tonumber(_a121)
end
local function _a122(_a123)
local _a124 = {}
if not (_a123 and _a39.ClientTower) then return _a124 end
local _a125
pcall(function() _a125 = _a39.ClientTower.All(_a123) end)
if type(_a125) ~= "table" then return _a124 end
local _a126 = _a89()
for _a127, _a128 in ipairs(_a125) do
local _a129, _a130, _a131
pcall(function() _a129 = _a128:GetItem() end)
pcall(function() _a130 = _a128:GetCFrame() end)
if _a129 then pcall(function() _a131 = _a129:GetOptionalUID() end) end
local _a132, _a133 = _a78(_a129)
if not _a132 then
local _a134 = _a126[_a131 or ""] or {}
_a132, _a133 = _a134.id, _a134.vr
end
local _a135 = _a114(_a128)
_a124[#_a124 + 1] = {
tower = _a128, item = _a129, uid = _a131, cf = _a130,
id = _a119(_a128), kind = _a132, vr = _a133, up = _a135,
dps = _a56(_a132, _a133, _a135),
}
end
return _a124
end
local function _a136()
local _a137 = {}
if not (_a39.TowerItem and _a39.EntityPlacement) then return _a137 end
local _a138
if not pcall(function() _a138 = _a39.TowerItem:All() end) or type(_a138) ~= "table" then return _a137 end
local _a139 = _a89()
local _a140 = {}
for _a141, _a142 in pairs(_a138) do
local _a143
pcall(function() _a143 = _a142:GetOptionalUID() end)
if _a143 then
local _a144 = _a84(_a142)
if not _a140[_a144] then
local _a145 = 0
pcall(function() _a145 = _a39.EntityPlacement.AvailableCopies(_a142) or 0 end)
if _a145 > 0 then
local _a146, _a147 = _a78(_a142)
if not _a146 then
local _a148 = _a139[_a143] or {}
_a146, _a147 = _a148.id, _a148.vr
end
_a140[_a144] = {
item = _a142, uid = _a143, key = _a144, id = _a146, vr = _a147,
copies = _a145, dps = _a56(_a146, _a147, 0),
}
else
_a140[_a144] = false
end
end
end
end
for _a149, _a150 in pairs(_a140) do
if _a150 then _a137[#_a137 + 1] = _a150 end
end
table.sort(_a137, function(_a151, _a152)
if (_a151.dps or 0) == (_a152.dps or 0) then return tostring(_a151.key) < tostring(_a152.key) end
return (_a151.dps or 0) > (_a152.dps or 0)
end)
return _a137
end
local function _a153(_a154)
local _a155
pcall(function() _a155 = _a39.GardenLaneFacing.ForSlot(_a154.pos, _a154.part) end)
return _a155
end
local function _a156(_a157, _a158)
local _a159 = _a153(_a157)
if not _a159 then return false end
local _a160 = false
pcall(function() _a160 = _a39.EntityPlacement.Validate(_a158, _a159) end)
return _a160 and true or false, _a159
end
local function _a161(_a162, _a163, _a164)
local _a165 = _a153(_a163)
if not _a165 then return false, "facing 실패" end
local _a166, _a167 = _a162.item, _a162.uid
if _a39.EntityPlacement and type(rawget(_a39.EntityPlacement, "FirstFreeCopy")) == "function" then
local _a168, _a169 = pcall(_a39.EntityPlacement.FirstFreeCopy, _a162.item)
if _a168 and _a169 then
_a166 = _a169
pcall(function() _a167 = _a169:GetUID() end)
end
end
if not _a167 then return false, "쓸 수 있는 스택 없음" end
local _a170 = _a164.CFrame:ToObjectSpace(_a165)
local _a171, _a172, _a173
if not pcall(function() _a171, _a172, _a173 = _a41.R_ATTACH:InvokeServer(_a167, _a170) end) then
return false, "호출 실패"
end
return _a171 and true or false, _a172, _a173
end
local function _a174(_a175)
if not (_a41.R_DETACH and _a175) then return false end
local _a176
pcall(function() _a176 = _a41.R_DETACH:InvokeServer(_a175) end)
return _a176 and true or false
end
local function _a177()
local _a178, _a179, _a180, _a181 = _a96()
if not (_a178 and _a180) then
_a36("[배치] 밭/월드 준비 안 됨 — Garden 안에 있는지 확인")
return
end
local _a182 = _a103(_a180, _a181)
_a46.slots = #_a182
if #_a182 == 0 then _a36("[배치] 슬롯 없음 (잠금해제 레인 " .. _a181 .. ")") return end
local _a183 = _a122(_a178)
local _a184 = _a136()
if #_a184 == 0 then
_a36("[배치] 배치 가능한 타워 없음 (종류별 최대치 도달)")
end
local _a185 = _a183
local _a186, _a187, _a188, _a189 = 0, 0, 0, 0
local _a190 = {}
local _a191 = {}
local function _a192(_a193)
return tostring(_a193 and _a193.key or (tostring(_a193 and _a193.id) .. "|" .. tostring(_a193 and _a193.vr or "")))
end
for _a194 = #_a184, 1, -1 do
if _a191[_a192(_a184[_a194])] then table.remove(_a184, _a194) end
end
local function _a195(_a196)
for _a197, _a198 in ipairs(_a185) do
if _a198.cf then
local _a199 = Vector2.new(_a198.cf.X - _a196.pos.X, _a198.cf.Z - _a196.pos.Z).Magnitude
if _a199 < 2 then return _a198 end
end
end
return nil
end
for _a200, _a201 in ipairs(_a182) do
if not _a45.place then break end
local _a202 = _a195(_a201)
if _a202 then _a186 += 1 else _a187 += 1 end
local _a203 = _a184[1]
if not _a203 then break end
if not _a202 then
local _a204, _a205, _a206 = _a161(_a203, _a201, _a178)
if _a204 then
_a188 += 1
_a46.placed += 1
_a36(("  ▸ 배치  레인%s  %s %s  DPS %s"):format(
_a201.lane, tostring(_a203.id), tostring(_a203.vr or "-"), _a37(_a203.dps)))
_a185 = _a122(_a178)
_a184 = _a136()
for _a207 = #_a184, 1, -1 do
if _a191[_a192(_a184[_a207])] then table.remove(_a184, _a207) end
end
else
_a190[tostring(_a205)] = (_a190[tostring(_a205)] or 0) + 1
if tostring(_a205):find("copies") then _a191[_a192(_a203)] = true end
table.remove(_a184, 1)
end
task.wait(_a42.ActionGap)
elseif (_a203.dps or 0) > (_a202.dps or 0) * _a42.SwapMargin then
if _a42.ProtectUpgraded and (_a202.up or 0) > 0 then
else
if _a174(_a202.id) then
task.wait(0.5)
local _a208 = _a136()
local _a209, _a210 = false, nil
for _a211 = 1, math.min(10, #_a208) do
local _a212 = _a208[_a211]
if not _a191[_a192(_a212)] then
local _a213, _a214 = _a161(_a212, _a201, _a178)
if _a213 then
_a209, _a210 = true, _a212
break
end
_a190[tostring(_a214)] = (_a190[tostring(_a214)] or 0) + 1
if tostring(_a214):find("copies") then _a191[_a192(_a212)] = true end
task.wait(0.15)
end
end
if _a209 and _a210 then
if _a210.id == _a202.kind and (_a210.vr or "") == (_a202.vr or "") then
_a36("  · 레인" .. _a201.lane .. " 같은 종류로 되돌림 (더 나은 게 없음)")
else
_a189 += 1
_a46.swapped += 1
_a36(("  ⇄ 교체  레인%s   %s%s(Lv%s) DPS %s  →  %s %s DPS %s"):format(
_a201.lane,
tostring(_a202.kind), _a202.vr and (" " .. _a202.vr) or "",
tostring(_a202.up), _a37(_a202.dps),
tostring(_a210.id), tostring(_a210.vr or "-"), _a37(_a210.dps)))
end
else
_a36("  ! 레인" .. _a201.lane .. " 아무것도 못 놓음 — 칸이 비었습니다")
end
_a185 = _a122(_a178)
_a184 = _a136()
for _a215 = #_a184, 1, -1 do
if _a191[_a192(_a184[_a215])] then table.remove(_a184, _a215) end
end
task.wait(_a42.ActionGap)
end
end
end
end
_a46.filled, _a46.empty = _a186, _a187
local _a216 = ("[배치] 슬롯 %d (찬칸 %d / 빈칸 %d)  이번에 배치 %d, 교체 %d")
:format(#_a182, _a186, _a187, _a188, _a189)
_a36(_a216)
if next(_a190) then
for _a217, _a218 in pairs(_a190) do _a36("    실패 " .. _a218 .. "회: " .. _a217) end
end
end
local function _a219()
if not _a41.R_BUY then _a36("[구매] 리모트 없음") return end
local _a220, _a221 = 0, 0
for _a222 = 1, _a42.MerchantSlots do
if not _a45.merchant then break end
local _a223
pcall(function() _a223 = _a41.R_BUY:InvokeServer(_a42.MerchantId, _a222) end)
if _a223 ~= nil and _a223 ~= false then _a220 += 1 else _a221 += 1 end
task.wait(0.3)
end
_a46.bought += _a220
_a36(("[구매] %s  성공 %d / 실패 %d"):format(_a42.MerchantId, _a220, _a221))
end
local function _a224()
if not _a39.Save then return 0 end
local _a225, _a226 = pcall(_a39.Save.Get)
if not _a225 or type(_a226) ~= "table" then return 0 end
local _a227 = _a226.Inventory and _a226.Inventory.Currency
if type(_a227) ~= "table" then return 0 end
for _a228, _a229 in pairs(_a227) do
if type(_a229) == "table" and rawget(_a229, "id") == "Sunflowers" then
return tonumber(rawget(_a229, "_am")) or 0
end
end
return 0
end
local function _a230()
local _a231 = {}
if not _a39.Save then return _a231 end
local _a232, _a233 = pcall(_a39.Save.Get)
if not _a232 or type(_a233) ~= "table" then return _a231 end
local _a234 = rawget(_a233, "EventUpgrades")
if type(_a234) == "table" then
for _a235, _a236 in pairs(_a234) do _a231[_a235] = tonumber(_a236) or 0 end
end
return _a231
end
local _a237
local function _a238()
if _a237 then return _a237 end
_a237 = {}
local _a239 = _a34:FindFirstChild("__DIRECTORY")
_a239 = _a239 and _a239:FindFirstChild("EventUpgrades")
if _a239 then
for _a240, _a241 in ipairs(_a239:GetDescendants()) do
if _a241:IsA("ModuleScript") then
local _a242, _a243 = pcall(require, _a241)
if _a242 and type(_a243) == "table" then
_a237[rawget(_a243, "_id") or _a241.Name] = _a243
end
end
end
end
return _a237
end
local _a244, _a245
local function _a246()
if _a244 ~= nil then return _a244 end
_a244 = false
local _a247 = {
_a38("Library", "Util", "GardenUpgradeCurve"),
_a38("Library", "Util", "GardenUpgradeBoosts"),
_a39.EventUpgradeCmds,
}
for _a248, _a249 in ipairs(_a247) do
if type(_a249) == "table" then
for _a250, _a251 in pairs(_a249) do
local _a252 = tostring(_a250):lower()
if type(_a251) == "function" and (_a252:find("cost") or _a252:find("price")) then
for _a253, _a254 in ipairs({
{ "GardenMoreDamage", 1 }, { "GardenMoreDamage", 2 },
{ 1 }, { 2 }, { "GardenMoreDamage" },
}) do
local _a255, _a256 = pcall(_a251, table.unpack(_a254))
if _a255 and type(_a256) == "number" and _a256 > 0 then
_a244 = _a251
_a245 = (#_a254 == 2) and "id_tier" or
(type(_a254[1]) == "number" and "tier" or "id")
return _a244
end
end
end
end
end
end
return _a244
end
local function _a257(_a258)
if _a258 == nil then return nil end
if type(_a258) == "number" then return _a258 end
if type(_a258) == "table" then
local _a259 = rawget(_a258, "_data")
if type(_a259) == "table" then
return tonumber(rawget(_a259, "_am")) or 1
end
end
local _a260, _a261 = pcall(function() return _a258:GetAmount() end)
if _a260 and type(_a261) == "number" then return _a261 end
return nil
end
local function _a262(_a263, _a264)
local _a265 = _a238()[_a263]
if type(_a265) == "table" then
for _a266, _a267 in ipairs({ "TierCosts", "Costs", "Prices", "TierPrices" }) do
local _a268 = rawget(_a265, _a267)
if type(_a268) == "table" then
local _a269 = _a257(_a268[(tonumber(_a264) or 0) + 1])
if _a269 then return _a269 end
end
end
end
local _a270 = _a246()
if _a270 then
local _a271 = (tonumber(_a264) or 0) + 1
local _a272
if _a245 == "id_tier" then _a272 = { { _a263, _a271 }, { _a263, _a264 } }
elseif _a245 == "tier" then _a272 = { { _a271 }, { _a264 } }
else _a272 = { { _a263 } } end
for _a273, _a274 in ipairs(_a272) do
local _a275, _a276 = pcall(_a270, table.unpack(_a274))
if _a275 and type(_a276) == "number" and _a276 > 0 then return _a276 end
end
end
return nil
end
local function _a277(_a278)
if _a39.EventUpgradeCmds and type(rawget(_a39.EventUpgradeCmds, "Purchase")) == "function" then
local _a279, _a280 = pcall(_a39.EventUpgradeCmds.Purchase, _a278)
if _a279 and _a280 ~= nil and _a280 ~= false then return true, _a280 end
if _a279 then return false, _a280 end
end
if _a41.R_EVUP then
local _a281
local _a282 = pcall(function() _a281 = _a41.R_EVUP:InvokeServer(_a278) end)
if _a282 then return (_a281 ~= nil and _a281 ~= false), _a281 end
end
return false, "호출 실패"
end
local function _a283()
if not (_a41.R_EVUP or _a39.EventUpgradeCmds) then _a36("[머신업글] API 없음") return end
local _a284, _a285 = 0, 0
while _a45.upgrade and _a284 < 40 do
_a284 += 1
local _a286 = _a224()
_a46.sun = _a286
local _a287 = _a230()
local _a288 = {}
for _a289, _a290 in ipairs(_a48) do
local _a291 = _a287[_a290] or 0
local _a292 = _a262(_a290, _a291)
_a288[#_a288 + 1] = { id = _a290, tier = _a291, cost = _a292 }
end
table.sort(_a288, function(_a293, _a294)
local _a295 = _a293.cost or math.huge
local _a296 = _a294.cost or math.huge
if _a295 == _a296 then return _a293.id < _a294.id end
return _a295 < _a296
end)
local _a297 = false
for _a298, _a299 in ipairs(_a288) do
if not _a45.upgrade then break end
local _a300 = _a299.cost and (_a286 - _a299.cost >= _a42.MinSunflowers)
if _a299.cost == nil then _a300 = _a42.BuyUnknownCost end
if _a300 then
local _a301 = _a286
local _a302, _a303 = _a277(_a299.id)
if _a302 then
_a285 += 1
_a46.upgraded += 1
_a297 = true
task.wait(0.4)
local _a304 = _a224()
_a36(("  ▲ %s  Lv%s → Lv%s   비용 %s   잔액 %s"):format(
_a299.id, tostring(_a299.tier), tostring(_a299.tier + 1),
_a37(_a301 - _a304, 0), _a37(_a304, 0)))
break
end
end
end
if not _a297 then break end
end
local _a305 = _a224()
_a46.sun = _a305
local _a306 = _a230()
if _a285 > 0 then
_a36(("[머신업글] %d건 구매 / 잔액 %s"):format(_a285, _a37(_a305, 0)))
else
local _a307, _a308 = math.huge, nil
for _a309, _a310 in ipairs(_a48) do
local _a311 = _a262(_a310, _a306[_a310] or 0)
if _a311 and _a311 < _a307 then _a307, _a308 = _a311, _a310 end
end
if _a308 then
_a36(("[머신업글] 살 수 있는 게 없음 — 잔액 %s / 최저 %s (%s)")
:format(_a37(_a305, 0), _a37(_a307, 0), _a308))
else
_a36("[머신업글] 구매 실패 (비용표를 못 읽음)")
end
end
end
local _a312, _a313
local function _a314()
if _a312 then return _a312 end
_a312 = {}
local _a315 = _a34:FindFirstChild("__DIRECTORY")
_a315 = _a315 and _a315:FindFirstChild("CropSeeds")
if _a315 then
for _a316, _a317 in ipairs(_a315:GetDescendants()) do
if _a317:IsA("ModuleScript") then
local _a318, _a319 = pcall(require, _a317)
if _a318 and type(_a319) == "table" then _a312[rawget(_a319, "_id") or _a317.Name] = _a319 end
end
end
end
return _a312
end
local function _a320()
if _a313 then return _a313 end
_a313 = {}
local _a321 = _a34:FindFirstChild("__DIRECTORY")
_a321 = _a321 and _a321:FindFirstChild("GardenCrops")
if _a321 then
for _a322, _a323 in ipairs(_a321:GetDescendants()) do
if _a323:IsA("ModuleScript") then
local _a324, _a325 = pcall(require, _a323)
if _a324 and type(_a325) == "table" then _a313[rawget(_a325, "_id") or _a323.Name] = _a325 end
end
end
end
return _a313
end
local function _a326(_a327)
local _a328 = _a320()[_a327]
return _a328 and tonumber(rawget(_a328, "CoinsPerSec")) or 0
end
local _a329 = {}
local function _a330(_a331)
if _a329[_a331] then return _a329[_a331] end
local _a332 = _a314()[_a331]
local _a333 = _a332 and rawget(_a332, "SpeciesWeights")
local _a334, _a335 = 0, 0
if type(_a333) == "table" then
for _a336, _a337 in pairs(_a333) do
local _a338 = tonumber(_a337) or 0
_a334 += _a338
_a335 += _a338 * _a326(_a336)
end
end
local _a339 = (_a334 > 0) and (_a335 / _a334) or 0
_a329[_a331] = _a339
return _a339
end
local function _a340()
local _a341 = {}
if not _a39.Save then return _a341 end
local _a342, _a343 = pcall(_a39.Save.Get)
if not _a342 or type(_a343) ~= "table" then return _a341 end
local _a344 = _a343.Inventory and _a343.Inventory.CropSeed
if type(_a344) ~= "table" then return _a341 end
for _a345, _a346 in pairs(_a344) do
if type(_a346) == "table" then
local _a347 = tonumber(rawget(_a346, "_am")) or 1
if _a347 > 0 then
_a341[#_a341 + 1] = {
uid = _a345, id = rawget(_a346, "id"), vr = rawget(_a346, "vr"),
am = _a347, exp = _a330(rawget(_a346, "id")),
}
end
end
end
table.sort(_a341, function(_a348, _a349)
if (_a348.exp or 0) == (_a349.exp or 0) then return (_a348.am or 0) > (_a349.am or 0) end
return (_a348.exp or 0) > (_a349.exp or 0)
end)
return _a341
end
local function _a350(_a351)
if not _a351 then return {} end
local _a352
pcall(function() _a352 = _a351:Save("PvC_Beds") end)
return type(_a352) == "table" and _a352 or {}
end
local function _a353(_a354, _a355)
if not (_a39.GardenPlots and _a354) then return true end
local _a356, _a357 = pcall(_a39.GardenPlots.IsBedUnlocked, _a354, _a355)
if _a356 then return _a357 and true or false end
return true
end
local function _a358(_a359)
if not (_a39.PvCropGrowth and type(_a359) == "table") then return false end
local _a360, _a361 = pcall(_a39.PvCropGrowth.IsUnhatched, _a359)
return _a360 and _a361 and true or false
end
local function _a362(_a363)
if type(_a363) ~= "table" then return nil end
local _a364 = tonumber(rawget(_a363, "cps"))
if _a364 then return _a364 end
local _a365 = rawget(_a363, "sp")
if _a365 then return _a326(_a365) end
return nil
end
local function _a366()
local _a367, _a368 = _a96()
if not _a368 then _a36("[씨앗] 밭 없음") return end
local _a369 = _a350(_a368)
local _a370 = _a340()
if #_a370 == 0 then _a36("[씨앗] 인벤에 씨앗 없음") return end
local _a371, _a372 = {}, {}
for _a373 in pairs(_a369) do
if not _a372[tostring(_a373)] then _a372[tostring(_a373)] = true _a371[#_a371 + 1] = _a373 end
end
for _a374 = 1, 80 do
local _a375 = tostring(_a374)
if not _a372[_a375] and _a353(_a368, _a375) then _a372[_a375] = true _a371[#_a371 + 1] = _a375 end
end
local _a376, _a377, _a378, _a379 = 0, 0, 0, 0
local _a380 = 1
for _a381, _a382 in ipairs(_a371) do
if not _a45.crop then break end
local _a383 = _a370[_a380]
while _a383 and _a383.am <= 0 do
_a380 += 1
_a383 = _a370[_a380]
end
if not _a383 then break end
local _a384 = _a369[_a382]
local _a385 = _a362(_a384)
if _a384 == nil then
local _a386
pcall(function() _a386 = _a368:Invoke("SD_Insert", _a382, _a383.uid) end)
if _a386 ~= false then
_a377 += 1
_a46.replant += 1
_a383.am -= 1
_a36(("  ▸ 심기  칸%s  %s 씨앗 (기대 %s/s)"):format(tostring(_a382), tostring(_a383.id), _a37(_a383.exp)))
task.wait(_a42.ActionGap)
end
elseif _a42.SkipUnhatched and _a358(_a384) then
_a379 += 1
elseif _a385 and (_a383.exp or 0) > _a385 * _a42.CropMargin then
local _a387
pcall(function() _a387 = _a368:Invoke("SD_Purge", _a382) end)
if _a387 ~= false then
task.wait(0.4)
local _a388
pcall(function() _a388 = _a368:Invoke("SD_Insert", _a382, _a383.uid) end)
if _a388 ~= false then
_a376 += 1
_a46.replant += 1
_a383.am -= 1
_a36(("  ⇄ 갈아엎기  칸%s  %s(%s/s) → %s 씨앗(기대 %s/s)"):format(
tostring(_a382), tostring(rawget(_a384, "sp") or "?"), _a37(_a385),
tostring(_a383.id), _a37(_a383.exp)))
else
_a36("  ! 칸" .. tostring(_a382) .. " 파냈는데 심기 실패")
end
task.wait(_a42.ActionGap)
end
else
_a378 += 1
end
end
_a36(("[씨앗] 심기 %d / 갈아엎기 %d / 유지 %d / 성장중 %d")
:format(_a377, _a376, _a378, _a379))
end
local function _a389(_a390)
if _a47 and not _a390 then return _a47 end
if _a41.R_JC then
local _a391, _a392 = pcall(function() return _a41.R_JC:InvokeServer() end)
if _a391 and type(_a392) == "table" then _a47 = _a392 end
end
return _a47 or {}
end
local function _a393(_a394)
if not (_a39.GardenPlots and rawget(_a39.GardenPlots, "PlotCost")) then return nil end
local _a395, _a396 = pcall(_a39.GardenPlots.PlotCost, tonumber(_a394))
return (_a395 and type(_a396) == "number") and _a396 or nil
end
local function _a397(_a398)
local _a399 = {}
if not _a398 then return _a399 end
for _a400 = 1, _a42.MaxBedScan do
local _a401 = tostring(_a400)
if not _a353(_a398, _a401) then
_a399[#_a399 + 1] = { id = _a401, n = _a400, cost = _a393(_a400) }
end
end
table.sort(_a399, function(_a402, _a403)
return (_a402.cost or math.huge) < (_a403.cost or math.huge)
end)
return _a399
end
local function _a404()
local _a405, _a406, _a407, _a408 = _a96()
if not _a406 then _a36("[확장] 밭 없음") return end
local _a409, _a410 = 0, 0
local _a411 = _a224()
local _a412 = _a389(true)
local _a413 = 0
while _a45.expand and _a413 < 12 do
_a413 += 1
local _a414 = (tonumber(_a408) or 0) + 1
local _a415 = tonumber(_a412[_a414]) or tonumber(_a412[tostring(_a414)])
if _a415 and (_a411 - _a415) < _a42.MinSunflowers then
_a36(("[확장] 레인%d 비용 %s / 잔액 %s — 부족"):format(_a414, _a37(_a415, 0), _a37(_a411, 0)))
break
end
if not _a415 and not _a42.BuyUnknownCost then
_a36("[확장] 레인" .. _a414 .. " 비용을 못 읽음 — 건너뜀")
break
end
if not _a41.R_WIDEN then break end
local _a416 = _a411
local _a417, _a418, _a419
pcall(function() _a417, _a418, _a419 = _a41.R_WIDEN:InvokeServer() end)
task.wait(0.5)
_a411 = _a224()
if _a417 then
_a409 += 1
_a410 += (_a416 - _a411)
_a408 = tonumber(_a419) or (_a408 + 1)
_a36(("  ▣ 레인 오픈 → %s개   비용 %s   잔액 %s"):format(
tostring(_a408), _a37(_a416 - _a411, 0), _a37(_a411, 0)))
task.wait(_a42.ActionGap)
else
if _a418 then _a36("[확장] 레인 실패: " .. tostring(_a418)) end
break
end
end
local _a420 = _a397(_a406)
for _a421, _a422 in ipairs(_a420) do
if not _a45.expand then break end
if _a422.cost and (_a411 - _a422.cost) < _a42.MinSunflowers then break end
if not _a422.cost and not _a42.BuyUnknownCost then break end
local _a423 = _a411
local _a424
pcall(function() _a424 = _a406:Invoke("BD_Acquire", _a422.id) end)
task.wait(0.4)
_a411 = _a224()
if _a424 ~= false and _a411 < _a423 then
_a409 += 1
_a410 += (_a423 - _a411)
_a36(("  ▣ 밭칸 %s 오픈   비용 %s   잔액 %s"):format(
_a422.id, _a37(_a423 - _a411, 0), _a37(_a411, 0)))
task.wait(_a42.ActionGap)
else
break
end
end
_a46.sun = _a411
if _a409 > 0 then
_a36(("[확장] %d개 오픈 / 총 %s 소비"):format(_a409, _a37(_a410, 0)))
else
local _a425 = (tonumber(_a408) or 0) + 1
local _a426 = _a412[_a425] or _a412[tostring(_a425)]
local _a427 = _a420[1]
_a36(("[확장] 오픈할 것 없음 — 잔액 %s / 다음 레인%d %s / 다음 밭칸 %s"):format(
_a37(_a411, 0), _a425, _a426 and _a37(_a426, 0) or "?",
_a427 and (_a427.id .. " " .. (_a427.cost and _a37(_a427.cost, 0) or "?")) or "없음"))
end
end
local function _a428()
local _a429, _a430 = _a96()
if not _a430 then return nil end
local function _a431(_a432)
local _a433
pcall(function() _a433 = _a430:Save(_a432) end)
return _a433
end
local _a434 = tonumber(_a431("PvC_Regrows")) or 0
local _a435   = tonumber(_a431("PvC_UnlockedLanes")) or 1
local _a436   = tonumber(_a431("PvC_RunBossKills")) or 0
local _a437     = _a40("PvC_RegrowCap") or math.huge
local _a438    = _a40("PvC_RegrowBossBase") or 1
local _a439    = _a40("PvC_RegrowBossStep") or 1
local _a440  = math.min(_a434, _a437)
local _a441    = math.ceil(_a438 * (_a439 ^ _a440))
local _a442   = (_a437 <= _a440)
return {
regrows = _a434, lanes = _a435, kills = _a436, need = _a441,
cap = _a437, maxed = _a442,
ready = (not _a442) and _a435 >= 7 and _a436 >= _a441,
reason = _a442 and "최대 리버스 도달"
or (_a435 < 7 and ("레인 %d/7"):format(_a435))
or (_a436 < _a441 and ("코인보스 %d/%d"):format(_a436, _a441))
or nil,
}
end
local function _a443()
if not _a41.R_WK then _a36("[리버스] WK_Reclaim 리모트 없음") return end
local _a444 = _a428()
if not _a444 then _a36("[리버스] 밭 없음") return end
if not _a444.ready then
_a36(("[리버스] 대기 — %s   (리버스 %d회)"):format(tostring(_a444.reason), _a444.regrows))
return
end
_a36(("[리버스] 조건 충족 (레인 %d, 보스 %d/%d) — 실행"):format(_a444.lanes, _a444.kills, _a444.need))
local _a445, _a446, _a447
pcall(function() _a445, _a446, _a447 = _a41.R_WK:InvokeServer() end)
task.wait(1.5)
if _a445 then
_a46.sun = _a224()
_a47 = nil
_a36(("  ★ 리버스 성공 → %s회   (레인/밭칸/작물 초기화됨)"):format(tostring(_a447 or (_a444.regrows + 1))))
_a36("  자동 확장이 켜져 있으면 레인/밭칸을 다시 엽니다")
else
_a36("  ✗ 리버스 실패: " .. tostring(_a446))
end
end
local _a448 = _a38("Library", "Util", "GardenEggs")
local _a449    = _a38("Library", "Directory", "Eggs")
local _a450= _a38("Library", "Balancing", "CalcEggPricePlayer")
local _a451  = _a38("Library", "Balancing", "CalcEggPrice")
local function _a452()
if _a42.HatchEggNum and _a42.HatchEggNum >= 1 then
return math.floor(_a42.HatchEggNum)
end
local _a453, _a454 = _a96()
if _a448 and rawget(_a448, "CurrentEggNum") then
local _a455, _a456 = pcall(_a448.CurrentEggNum, _a454)
if _a455 and tonumber(_a456) then return math.floor(tonumber(_a456)) end
end
if _a39.EventUpgradeCmds and rawget(_a39.EventUpgradeCmds, "GetPower") then
local _a457, _a458 = pcall(_a39.EventUpgradeCmds.GetPower, "GardenBetterEggs")
if _a457 and tonumber(_a458) then return math.clamp(1 + math.floor(tonumber(_a458)), 1, 12) end
end
return 1
end
local function _a459(_a460)
return ("Garden Egg %d"):format(_a460 or _a452())
end
local function _a461(_a462)
if type(_a449) == "table" then
local _a463 = rawget(_a449, _a462)
if _a463 then return _a463 end
end
local _a464 = _a34:FindFirstChild("__DIRECTORY")
_a464 = _a464 and _a464:FindFirstChild("Eggs")
if _a464 then
for _a465, _a466 in ipairs(_a464:GetDescendants()) do
if _a466:IsA("ModuleScript") then
local _a467, _a468 = pcall(require, _a466)
if _a467 and type(_a468) == "table" and rawget(_a468, "_id") == _a462 then return _a468 end
end
end
end
return nil
end
table.clear(_a44)
local function _a469(_a470)
if _a44[_a470] then return _a44[_a470] end
local _a471 = _a461(_a470)
if not _a471 then return nil end
for _a472, _a473 in ipairs({ _a450, _a451 }) do
if type(_a473) == "function" then
local _a474, _a475 = pcall(_a473, _a471)
if _a474 and tonumber(_a475) and tonumber(_a475) > 0 then
_a44[_a470] = tonumber(_a475)
return _a44[_a470]
end
end
end
local _a476 = tonumber(rawget(_a471, "overrideCost"))
if _a476 then
local _a477 = _a40("PvC_EggCostMult")
if not _a477 or _a477 <= 0 then _a477 = 1 end
local _a478 = math.max(1, math.round(_a476 * _a477))
_a44[_a470] = _a478
return _a478
end
return nil
end
local _a479 = _a38("Library", "Client", "CustomEggsCmds")
local function _a480()
local _a481 = {}
local _a482 = workspace:FindFirstChild("__THINGS")
_a482 = _a482 and _a482:FindFirstChild("CustomEggs")
if not _a482 then return _a481 end
local _a483 = _a35.Character and _a35.Character:FindFirstChild("HumanoidRootPart")
for _a484, _a485 in ipairs(_a482:GetChildren()) do
local _a486
pcall(function()
if _a485:IsA("Model") then _a486 = _a485:GetPivot().Position
elseif _a485:IsA("BasePart") then _a486 = _a485.Position end
end)
_a481[#_a481 + 1] = {
uid = _a485.Name, inst = _a485,
dist = (_a486 and _a483) and (_a486 - _a483.Position).Magnitude or math.huge,
}
end
table.sort(_a481, function(_a487, _a488) return _a487.dist < _a488.dist end)
return _a481
end
local function _a489()
if _a42.HatchUid and _a42.HatchUid ~= "" then return _a42.HatchUid end
local _a490 = _a480()
return _a490[1] and _a490[1].uid or nil
end
local function _a491()
if type(_a479) == "table" then
local _a492 = rawget(_a479, "GetMaxEggCount")
if type(_a492) == "function" then
local _a493, _a494 = pcall(_a492)
if _a493 and tonumber(_a494) and tonumber(_a494) >= 1 then return math.floor(tonumber(_a494)) end
end
end
return _a42.HatchMax
end
local function _a495()
local _a496 = _a452()
local _a497 = _a459(_a496)
local _a498 = _a469(_a497)
local _a499 = _a224()
local _a500 = math.max(0, _a499 - (_a42.HatchReserve or 0))
local _a501 = _a480()
return {
num = _a496, id = _a497, cost = _a498, sun = _a499,
uid = _a489(), eggCount = #_a501, eggs = _a501,
canBuy = (_a498 and _a498 > 0) and math.floor(_a500 / _a498) or 0,
}
end
local function _a502()
if not _a41.R_CEGG then _a36("[뽑기] CustomEggs_Hatch 리모트 없음") return end
local _a503 = _a495()
_a46.sun = _a503.sun
if not _a503.uid then
_a36("[뽑기] 알을 못 찾음 — 알 근처로 가주세요 (workspace.__THINGS.CustomEggs 비어있음)")
return
end
if not _a503.cost then
_a36("[뽑기] " .. _a503.id .. " 비용을 못 읽음")
return
end
if _a503.canBuy < 1 then
return
end
local _a504 = math.min(_a42.HatchMax, _a491())
local _a505, _a506 = 0, 0
local _a507 = math.min(_a503.canBuy, _a504)
while _a45.hatch and _a507 >= 1 and _a506 < 20 do
_a506 += 1
local _a508, _a509
pcall(function() _a508, _a509 = _a41.R_CEGG:InvokeServer(_a503.uid, _a507) end)
if _a508 then
_a505 += _a507
_a46.hatched += _a507
task.wait(0.4)
local _a510 = _a224()
_a46.sun = _a510
local _a511 = math.max(0, _a510 - (_a42.HatchReserve or 0))
local _a512 = math.floor(_a511 / _a503.cost)
if _a512 < 1 then break end
_a507 = math.min(_a512, _a504)
else
local _a513 = tostring(_a509)
if _a513:find("quickly") then
task.wait(2.5)
elseif _a507 > 1 then
_a507 = math.floor(_a507 / 2)
else
if _a509 then _a36("[뽑기] 실패: " .. _a513) end
break
end
end
end
if _a505 > 0 then
_a36(("[뽑기] %s × %d   (개당 %s)   잔액 %s"):format(
_a503.id, _a505, _a37(_a503.cost, 0), _a37(_a224(), 0)))
end
end
local _a514 = _a38("Library", "Client", "GardenChanceMachineCmds")
local _a515 = _a38("Library", "Types", "GardenChanceMachine")
local _a516 = { "Huge", "Titanic", "Gargantuan" }
local function _a517()
if _a514 and rawget(_a514, "GetMaxBoostSeconds") then
local _a518, _a519 = pcall(_a514.GetMaxBoostSeconds)
if _a518 and tonumber(_a519) then return tonumber(_a519) end
end
return (_a515 and tonumber(rawget(_a515, "MaxSecondsDefault"))) or 21600
end
local function _a520(_a521)
if _a514 and rawget(_a514, "GetPerTokenSecondsForBoost") then
local _a522, _a523 = pcall(_a514.GetPerTokenSecondsForBoost, _a521)
if _a522 and tonumber(_a523) and tonumber(_a523) > 0 then return tonumber(_a523) end
end
local _a524 = (_a515 and _a515.TokensToMaxDefault
and tonumber(_a515.TokensToMaxDefault[_a521])) or 5000
return _a517() / _a524
end
local function _a525(_a526)
if _a514 and rawget(_a514, "GetBoostTime") then
local _a527, _a528 = pcall(_a514.GetBoostTime, _a526)
if _a527 and tonumber(_a528) then return tonumber(_a528) end
end
return 0
end
local function _a529()
if _a514 and rawget(_a514, "IsEnabled") then
local _a530, _a531 = pcall(_a514.IsEnabled)
if _a530 then return _a531 and true or false end
end
return true
end
local function _a532()
local _a533 = _a517()
local _a534 = {}
for _a535, _a536 in ipairs(_a516) do
local _a537 = _a525(_a536)
local _a538 = _a520(_a536)
local _a539 = math.max(0, _a533 - _a537)
_a534[#_a534 + 1] = {
rarity = _a536, left = _a537, per = _a538, deficit = _a539,
need = (_a538 > 0) and math.ceil(_a539 / _a538) or 0,
on = _a42.LuckBoosts[_a536] and true or false,
}
end
return { maxSec = _a533, rows = _a534, enabled = _a529(), sun = _a224() }
end
local function _a540(_a541)
_a541 = math.max(0, math.floor(tonumber(_a541) or 0))
local _a542 = math.floor(_a541 / 3600)
local _a543 = math.floor((_a541 % 3600) / 60)
return ("%d시간 %d분"):format(_a542, _a543)
end
local function _a544()
if not _a41.R_LUCK then _a36("[럭] GardenChanceMachine_AddTime 리모트 없음") return end
if not _a529() then _a36("[럭] 이 서버에서 비활성") return end
local _a545 = _a532()
_a46.sun = _a545.sun
local _a546 = _a545.sun
local _a547 = 0
for _a548, _a549 in ipairs(_a545.rows) do
if not _a45.luck then break end
if _a549.on and _a549.deficit >= _a42.LuckMinTopUp and _a549.need >= 1 then
local _a550 = math.max(0, _a546 - _a42.LuckReserve)
local _a551 = math.min(_a549.need, math.floor(_a550))
if _a551 >= 1 then
local _a552 = _a546
local _a553, _a554
pcall(function()
_a553, _a554 = _a41.R_LUCK:InvokeServer(_a549.rarity, "Slot1", _a551)
end)
task.wait(0.4)
_a546 = _a224()
_a46.sun = _a546
if _a553 then
_a547 += 1
_a46.luck += 1
_a36(("  ✦ 럭 %s  +%s  (%s → %s)  비용 %s"):format(
_a549.rarity, _a540(_a551 * _a549.per),
_a540(_a549.left), _a540(math.min(_a545.maxSec, _a549.left + _a551 * _a549.per)),
_a37(_a552 - _a546, 0)))
else
_a36(("  ✗ 럭 %s 실패: %s"):format(_a549.rarity, tostring(_a554)))
end
task.wait(_a42.ActionGap)
end
end
end
if _a547 == 0 then
local _a555 = {}
for _a556, _a557 in ipairs(_a545.rows) do
if _a557.on then
_a555[#_a555 + 1] = ("%s %s"):format(_a557.rarity, _a540(_a557.left))
end
end
if #_a555 > 0 then
_a36("[럭] 유지 중 — " .. table.concat(_a555, " / "))
end
end
end
_a33.EVENT_UPGRADES, _a33.ctx, _a33.collectSlots, _a33.placedTowers, _a33.availableItems, _a33.cyclePlace = _a48, _a96, _a103, _a122, _a136, _a177
_a33.cycleMerchant, _a33.sunflowers, _a33.eventTiers, _a33.nextCost, _a33.cycleUpgrade, _a33.seedInv = _a219, _a224, _a230, _a262, _a283, _a340
_a33.bedsOf, _a33.isUnhatched, _a33.bedCps, _a33.cycleCrop, _a33.laneCosts, _a33.lockedBeds = _a350, _a358, _a362, _a366, _a389, _a397
_a33.cycleExpand, _a33.rebirthStatus, _a33.cycleRebirth, _a33.hatchStatus, _a33.cycleHatch = _a404, _a428, _a443, _a495, _a502
_a33.LUCK_ORDER, _a33.luckStatus, _a33.fmtDur, _a33.cycleLuck = _a516, _a532, _a540, _a544
end)(_a1)
;(function(_a558)
local _a559, _a560, _a561, _a562, _a563, _a564 = _a558.UIS, _a558.RunService, _a558.LP, _a558.log, _a558.num, _a558.req
local _a565, _a566, _a567, _a568, _a569, _a570 = _a558.LB, _a558.NET, _a558.RM, _a558.CFG, _a558.RUN, _a558.STAT
local _a571, _a572 = _a558.ctx, _a558.placedTowers
local _a573 = {
AutoFarm = _a564("Library", "Client", "AutoFarmCmds"),
Zone     = _a564("Library", "Client", "ZoneCmds"),
Currency = _a564("Library", "Client", "CurrencyCmds"),
Bal      = _a564("Library", "Balancing"),
Egg      = _a564("Library", "Client", "EggCmds"),
Rebirth  = _a564("Library", "Client", "RebirthCmds"),
RanksU   = _a564("Library", "Util", "RanksUtil"),
DirRanks = _a564("Library", "Directory", "Ranks"),
DirEggs  = _a564("Library", "Directory", "Eggs"),
CalcEgg  = _a564("Library", "Balancing", "CalcEggPricePlayer"),
R_Farm   = _a566:FindFirstChild("AutoFarm_Enable"),
R_FarmOff = _a566:FindFirstChild("AutoFarm_Disable"),
R_Zone   = _a566:FindFirstChild("Zones_RequestPurchase"),
R_Reb    = _a566:FindFirstChild("Rebirth_Request"),
R_Rank   = _a566:FindFirstChild("Ranks_ClaimReward"),
Quest    = _a564("Library", "Client", "QuestCmds"),
EggsU    = _a564("Library", "Util", "EggsUtil"),
Map      = _a564("Library", "Client", "MapCmds"),
Inst     = _a564("Library", "Client", "InstancingCmds"),
DirZones = _a564("Library", "Directory", "Zones"),
ZonesU   = _a564("Library", "Util", "ZonesUtil"),
Upg      = _a564("Library", "Client", "UpgradeCmds"),
DirUpg   = _a564("Library", "Directory", "Upgrades"),
R_Upg    = _a566:FindFirstChild("Upgrades_Purchase"),
R_EggUn  = _a566:FindFirstChild("Eggs_RequestUnlock"),
Rand     = _a564("Library", "Client", "RandomEventCmds"),
R_Events = _a566:FindFirstChild("RandomEvents_Get"),
Ult      = _a564("Library", "Client", "UltimateCmds"),
R_Fruit  = _a566:FindFirstChild("Fruits: Consume"),
R_Cons   = _a566:FindFirstChild("Consumables_Consume"),
R_Ult    = _a566:FindFirstChild("Ultimates: Activate"),
R_Gold   = _a566:FindFirstChild("GoldMachine_Activate"),
R_Rain   = _a566:FindFirstChild("RainbowMachine_Activate"),
R_Flag   = _a566:FindFirstChild("FlexibleFlags_Consume"),
DirPets  = _a564("Library", "Directory", "Pets"),
CalcEggB = _a564("Library", "Balancing", "CalcEggPrice"),
PlayerPet = _a564("Library", "Client", "PlayerPet"),
Machine  = _a564("Library", "Client", "MachineCmds"),
Vars     = _a564("Library", "Variables"),
Hatch    = _a564("Library", "Client", "HatchingCmds"),
R_AHTog  = _a566:FindFirstChild("AutoHatch_Toggle"),
R_AHOn   = _a566:FindFirstChild("AutoHatch_Enable"),
R_AHOff  = _a566:FindFirstChild("AutoHatch_Disable"),
RankC    = _a564("Library", "Client", "RankCmds"),
CalcPetS = _a564("Library", "Balancing", "CalcPetSlotPrice"),
CalcEggS = _a564("Library", "Balancing", "CalcEggSlotPrice"),
R_PetSlot = _a566:FindFirstChild("EquipSlotsMachine_RequestPurchase"),
R_EggSlot = _a566:FindFirstChild("EggHatchSlotsMachine_RequestPurchase"),
R_Tp     = _a566:FindFirstChild("Teleports_RequestTeleport"),
R_TpI    = _a566:FindFirstChild("Teleports_RequestInstanceTeleport"),
R_PotUp  = _a566:FindFirstChild("UpgradePotionsMachine_ActivateBulk"),
R_EncUp  = _a566:FindFirstChild("UpgradeEnchantsMachine_ActivateBulk"),
R_PotUse = _a566:FindFirstChild("Potions: Consume"),
}
local _a574 = {
[1]="farm", [9]="farm", [21]="farm", [7]="farm", [99]="farm", [8]="farm",
[30]="farm", [31]="farm", [32]="farm", [37]="farm", [38]="farm", [39]="farm",
[43]="farm", [44]="farm", [66]="farm", [67]="farm", [75]="farm", [76]="farm",
[14]="farm", [15]="farm", [64]="farm", [65]="farm", [63]="farm",
[2]="hatch", [3]="hatch", [20]="hatch", [42]="hatch", [47]="hatch",
[6]="zone", [81]="zone",
[34]="potuse",
[35]="fruituse", [33]="flaguse",
}
local _a575 = {}
_a575.ctl, _a575.move, _a575.egg = {}, {}, {}
_a575.screen, _a575.quest, _a575.ev = {}, {}, {}
_a575.item, _a575.mach, _a575.auto = {}, {}, {}
_a575.quest.IGNORE = {
[4]  = "골드 펫 만들기 (합성 필요)",
[5]  = "레인보우 펫 만들기 (합성 필요)",
[40] = "best egg 골드 펫 (뽑기+합성 필요)",
[41] = "best egg 레인보우 펫 (뽑기+2단 합성 필요)",
[12] = "포션 업글 (업글 머신으로 이동 필요)",
[13] = "인챈트 업글 (업글 머신으로 이동 필요)",
}
_a575.ctl.abort = false
function _a575.ctl.stopped() return _a575.ctl.abort == true end
function _a575.ctl.stopAll()
_a575.ctl.abort = true
for _a576 in pairs(_a569) do
if _a576 ~= "petspd" and _a576 ~= "rewatch" then _a569[_a576] = false end
end
_a575.ctl.lockGoal = nil
_a575.ctl.moving = nil
_a575.ctl.now.step = "정지"
_a575.ctl.setAct("정지됨")
end
_a575.ctl.now = { step = "-", act = "-", detail = "", goal = "-", prog = "" }
function _a575.ctl.setAct(_a577, _a578)
_a575.ctl.now.act = _a577 or "-"
_a575.ctl.now.detail = _a578 and tostring(_a578) or ""
_a575.ctl.now.at = os.clock()
end
function _a575.ctl.setGoal(_a579, _a580)
_a575.ctl.now.goal = _a579 and tostring(_a579) or "-"
_a575.ctl.now.prog = _a580 and tostring(_a580) or ""
end
function _a575.egg.eggStands()
local _a581 = os.clock()
if _a575.egg._standsAt and (_a581 - _a575.egg._standsAt) < 2 and _a575.egg._stands then
local _a582 = _a561.Character
local _a583 = _a582 and _a582:FindFirstChild("HumanoidRootPart")
if _a583 then
for _a584, _a585 in ipairs(_a575.egg._stands) do
_a585.dist = (_a585.pos - _a583.Position).Magnitude
end
table.sort(_a575.egg._stands, function(_a586, _a587) return _a586.dist < _a587.dist end)
end
return _a575.egg._stands
end
local _a588 = {}
local _a589 = workspace:FindFirstChild("__THINGS")
local _a590 = _a589 and _a589:FindFirstChild("Eggs")
if not _a590 then return _a588 end
local _a591 = _a561.Character
local _a592 = _a591 and _a591:FindFirstChild("HumanoidRootPart")
for _a593, _a594 in ipairs(_a590:GetDescendants()) do
if _a594:IsA("Model") and _a594.PrimaryPart then
local _a595 = tonumber(tostring(_a594.Name):match("%d+"))
if _a595 then
local _a596
if _a573.EggsU and rawget(_a573.EggsU, "GetByNumber") then
local _a597, _a598 = pcall(_a573.EggsU.GetByNumber, _a595)
if _a597 then _a596 = _a598 end
end
local _a599 = _a596 and (rawget(_a596, "_id") or rawget(_a596, "name"))
if _a599 then
_a588[#_a588 + 1] = {
id = _a599, def = _a596, num = _a595,
pos = _a594.PrimaryPart.Position,
dist = _a592 and (_a594.PrimaryPart.Position - _a592.Position).Magnitude or 9e9,
unlocked = _a594:GetAttribute("Unlocked") and true or false,
}
end
end
end
end
table.sort(_a588, function(_a600, _a601) return _a600.dist < _a601.dist end)
_a575.egg._stands, _a575.egg._standsAt = _a588, os.clock()
return _a588
end
local function _a602()
if not _a565.Save then return nil end
local _a603, _a604 = pcall(_a565.Save.Get)
return (_a603 and type(_a604) == "table") and _a604 or nil
end
local function _a605(_a606, _a607)
if _a573.Currency and rawget(_a573.Currency, "CanAfford") then
local _a608, _a609 = pcall(_a573.Currency.CanAfford, _a606, _a607)
if _a608 then return _a609 and true or false end
end
return false
end
local function _a610(_a611)
if _a573.Currency and rawget(_a573.Currency, "Get") then
local _a612, _a613 = pcall(_a573.Currency.Get, _a611)
if _a612 and tonumber(_a613) then return tonumber(_a613) end
end
return 0
end
local function _a614()
if _a573.AutoFarm and rawget(_a573.AutoFarm, "IsEnabled") then
local _a615, _a616 = pcall(_a573.AutoFarm.IsEnabled)
if _a615 then return _a616 and true or false end
end
return false
end
local function _a617()
if _a573.AutoFarm and rawget(_a573.AutoFarm, "GetTargetParentId") then
local _a618, _a619 = pcall(_a573.AutoFarm.GetTargetParentId)
if _a618 then return _a619 end
end
return nil
end
local function _a620()
if not _a573.R_Farm then _a562("[파밍] AutoFarm_Enable 리모트 없음") return end
local _a621 = _a614()
_a575.auto.farmZone, _a575.auto.hereZone = _a617(), _a575.move.curZone()
if _a621 then
local _a622, _a623 = _a617(), _a575.move.curZone()
if _a622 and _a623 and _a622 ~= _a623 then
_a562(("[파밍] 대상이 %s 인데 지금은 %s — 다시 켬"):format(
tostring(_a622), tostring(_a623)))
if _a573.R_FarmOff then pcall(function() _a573.R_FarmOff:InvokeServer() end) end
if _a573.AutoFarm and rawget(_a573.AutoFarm, "ForceDisable") then
pcall(_a573.AutoFarm.ForceDisable)
end
task.wait(0.3)
_a621 = false
end
end
if _a621 then return end
local _a624, _a625
pcall(function() _a624, _a625 = _a573.R_Farm:InvokeServer() end)
if _a624 then
_a570.farm += 1
_a575.auto.farmSaid = nil
_a562("[파밍] 자동 파밍 ON  (대상 " .. tostring(_a617() or _a575.move.curZone()) .. ")")
elseif _a625 and _a575.auto.farmSaid ~= tostring(_a625) then
_a575.auto.farmSaid = tostring(_a625)
_a562("[파밍] 실패: " .. tostring(_a625))
end
end
local function _a626()
if not (_a573.Zone and rawget(_a573.Zone, "GetNextZone")) then return nil end
local _a627, _a628, _a629 = pcall(_a573.Zone.GetNextZone)
if not _a627 then return nil end
return _a629 or _a628
end
local function _a630(_a631)
if not (_a573.Bal and rawget(_a573.Bal, "CalcGatePrice")) then return nil end
local _a632, _a633 = pcall(_a573.Bal.CalcGatePrice, _a631)
return (_a632 and tonumber(_a633)) or nil
end
local function _a634()
local _a635 = _a626()
if not _a635 then return nil end
local _a636 = _a630(_a635)
local _a637 = rawget(_a635, "Currency")
return {
zone = _a635, id = rawget(_a635, "_id"), price = _a636, currency = _a637,
have = _a637 and _a610(_a637) or 0,
ok = (_a636 and _a637) and _a605(_a637, _a636) or false,
}
end
local function _a638()
if not _a573.R_Zone then _a562("[존] Zones_RequestPurchase 리모트 없음") return end
local _a639 = 0
while _a569.zone and not _a575.ctl.stopped() and _a639 < 20 do
_a639 += 1
local _a640 = _a634()
if not _a640 then
_a575.auto.zoneNote = "다음 존을 못 구함 (GetNextZone 실패 / 존 퀘스트 미완료?)"
if _a575.auto.zoneSaid ~= _a575.auto.zoneNote then
_a575.auto.zoneSaid = _a575.auto.zoneNote
_a562("[존] " .. _a575.auto.zoneNote)
end
return
end
if not _a640.ok then
_a575.auto.zoneNote = ("%s  %s %s / 보유 %s — 부족"):format(
tostring(_a640.id), _a563(_a640.price or 0, 0), tostring(_a640.currency), _a563(_a640.have, 0))
if _a575.auto.zoneSaid ~= _a575.auto.zoneNote then
_a575.auto.zoneSaid = _a575.auto.zoneNote
_a562("[존] " .. _a575.auto.zoneNote)
end
return
end
_a575.auto.zoneSaid = nil
local _a641, _a642
pcall(function() _a641, _a642 = _a573.R_Zone:InvokeServer(_a640.id) end)
task.wait(0.5)
if _a641 then
_a570.zone += 1
_a562(("  ▶ 존 해금  %s   (%s %s)"):format(
tostring(_a640.id), _a563(_a640.price or 0, 0), tostring(_a640.currency)))
else
if _a642 then _a562("[존] 실패: " .. tostring(_a642)) end
return
end
task.wait(_a568.ActionGap)
end
end
local function _a643()
local _a644 = _a575.egg.eggStands()
local _a645 = (_a568.MainEggId and _a568.MainEggId ~= "") and _a568.MainEggId or nil
if _a645 then
for _a646, _a647 in ipairs(_a644) do
if _a647.id == _a645 then return _a647.id, _a647.def, _a647.dist end
end
local _a648 = _a573.DirEggs and rawget(_a573.DirEggs, _a645)
if _a648 then return _a645, _a648, nil, (_a644[1] and _a644[1].dist) end
return nil
end
if not _a573.DirEggs then return nil end
local _a649, _a650, _a651 = nil, nil, -1
for _a652, _a653 in pairs(_a573.DirEggs) do
if type(_a653) == "table" and not rawget(_a653, "isCustomEgg") then
local _a654 = tonumber(rawget(_a653, "eggNumber"))
if _a654 and _a654 > _a651 and _a575.egg.eggUnlocked(_a654) then
_a649, _a650, _a651 = _a652, _a653, _a654
end
end
end
if not _a649 then return nil end
local _a655, _a656
for _a657, _a658 in ipairs(_a644) do
if not _a656 then _a656 = _a658.dist end
if _a658.id == _a649 then _a655 = _a658.dist break end
end
if _a655 and _a655 <= _a568.EggRange then
return _a649, _a650, _a655
end
return _a649, _a650, nil, _a655 or _a656
end
local function _a659(_a660)
if type(_a573.CalcEgg) == "function" then
local _a661, _a662 = pcall(_a573.CalcEgg, _a660)
if _a661 and tonumber(_a662) then return tonumber(_a662) end
if not _a661 and not _a575.egg.priceWarned then
_a575.egg.priceWarned = true
_a562("[부화] CalcEggPricePlayer 막힘 → 기본가로 계산: " .. tostring(_a662))
end
end
if type(_a573.CalcEggB) == "function" then
local _a663, _a664 = pcall(_a573.CalcEggB, _a660)
if _a663 and tonumber(_a664) then return tonumber(_a664) end
end
for _a665, _a666 in ipairs({ "price", "Price", "cost", "Cost" }) do
local _a667 = tonumber(rawget(_a660, _a666))
if _a667 then return _a667 end
end
return nil
end
local function _a668()
local _a669, _a670, _a671, _a672 = _a643()
if not _a669 then return nil end
local _a673 = _a659(_a670)
local _a674 = rawget(_a670, "currency") or "Coins"
local _a675 = 1
if _a573.Egg and rawget(_a573.Egg, "GetMaxHatch") then
local _a676, _a677 = pcall(_a573.Egg.GetMaxHatch, _a670)
if _a676 and tonumber(_a677) then _a675 = math.max(1, math.floor(tonumber(_a677))) end
end
local _a678 = _a610(_a674)
return {
id = _a669, def = _a670, price = _a673, currency = _a674, maxN = _a675, have = _a678,
dist = _a671, nearest = _a672, inRange = _a671 ~= nil,
canBuy = (_a673 and _a673 > 0) and math.floor(math.max(0, _a678 - _a568.MainHatchReserve) / _a673) or 0,
}
end
local function _a679()
if not _a567.R_EGG then _a562("[부화] Eggs_RequestPurchase 리모트 없음") return end
if _a568.AutoUnlockEgg then
local _a680, _a681, _a682 = _a575.egg.lockedEggs()
if _a681 > _a682 then
local _a683 = _a575.egg.unlockEggs()
if _a683 > 0 then _a562(("[부화] 알 %d개 해금 (해금가능 #%d)"):format(_a683, _a681)) end
end
end
local _a684 = _a668()
if not _a684 then _a562("[부화] 알을 못 찾음") return end
if not _a684.inRange then
if _a568.HatchAutoTp then
local _a685, _a686 = _a575.egg.tpEgg(_a684.id)
if not _a685 then
if not _a575.egg.hatchWarned then
_a575.egg.hatchWarned = true
_a562("[부화] 알로 이동 실패: " .. tostring(_a686))
end
return
end
_a562("[부화] " .. _a684.id .. " 로 이동")
_a684 = _a668()
if not (_a684 and _a684.inRange) then return end
else
if not _a575.egg.hatchWarned then
_a575.egg.hatchWarned = true
_a562(("[부화] 알 근처로 가주세요 (가장 가까운 알까지 %s스터드, 인식 %d)"):format(
_a684.nearest and ("%.0f"):format(_a684.nearest) or "?", _a568.EggRange))
end
return
end
end
_a575.egg.hatchWarned = false
local _a687 = math.min(_a684.maxN, _a568.MainHatchMax)
local _a688 = _a684.price and math.min(_a684.canBuy, _a687) or _a687
if _a688 < 1 then return end
local _a689, _a690 = 0, 0
local function _a691()
return tonumber(_a573.Vars and rawget(_a573.Vars, "OpeningEgg")) or 0
end
local _a692 = _a573.Vars and rawget(_a573.Vars, "OpeningEgg") ~= nil
local _a693 = 2.5
if _a573.Egg and rawget(_a573.Egg, "ComputeDebounce") then
local _a694, _a695 = pcall(_a573.Egg.ComputeDebounce)
if _a694 and tonumber(_a695) then _a693 = tonumber(_a695) end
end
_a575.egg.autoHatchOn(_a684.id, _a688)
local _a696 = false
local _a697 = _a575.ctl.lockGoal and _a575.ctl.lockGoal.q
local _a698 = _a697 and (_a697.how == "hatch" or _a697.where == "bestegg") or false
local _a699 = _a698 and math.huge
or (os.clock() + math.max(3, _a568.HatchBudget or 25))
local _a700 = _a698 and 100000 or 400
while _a569.mhatch and not _a575.ctl.stopped() and _a688 >= 1 and _a690 < _a700 and os.clock() < _a699 do
if _a698 and (_a690 % 5 == 0) then
local _a701 = _a575.quest.findQuest(_a697.uid)
if not _a701 or _a701.progress >= _a701.amount then break end
end
_a690 += 1
if _a692 then
local _a702 = os.clock()
local _a703 = _a568.HatchClickAfter
local _a704 = false
while _a691() > 0 and _a569.mhatch and not _a575.ctl.stopped()
and (os.clock() - _a702) < 20 do
if _a568.HatchClick and (os.clock() - _a702) > _a703 then
_a575.egg.clickOnce()
_a703 += 0.3
if (os.clock() - _a702) > 3 and not _a704 then
_a704 = true
_a575.egg._ahEgg = nil
_a575.egg.autoHatchOn(_a684.id, _a688)
_a562("[부화] 화면이 안 넘어가서 오토해치 재설정")
end
end
task.wait(0.03)
end
if _a691() > 0 then
if _a575.egg.hatchStuck ~= _a684.id then
_a575.egg.hatchStuck = _a684.id
_a562("[부화] " .. tostring(_a684.id) .. " 까는 화면에서 멈춤 — 이번 회차 중단")
end
_a696 = true
break
end
_a575.egg.hatchStuck = nil
else
local _a705 = os.clock() - (_a575.egg.lastHatch or 0)
if _a705 < _a693 then task.wait(_a693 - _a705) end
end
_a575.egg.lastHatch = os.clock()
_a575.ctl.setAct("알 까는 중", ("%s x%d  (총 %d)"):format(_a684.id, _a688, _a689))
local _a706, _a707
local _a708 = pcall(function() _a706, _a707 = _a567.R_EGG:InvokeServer(_a684.id, _a688) end)
if _a706 then
_a689 += _a688
_a570.mhatch += _a688
_a575.egg.hatchErr = nil
if _a684.price then
local _a709 = _a610(_a684.currency)
local _a710 = math.floor(math.max(0, _a709 - _a568.MainHatchReserve) / _a684.price)
if _a710 < 1 then break end
_a688 = math.min(_a710, _a687)
end
else
local _a711 = _a708 and tostring(_a707) or "호출 자체 실패"
if _a711:find("quickly") or _a711:find("fast") then
task.wait(0.25)
elseif _a711:find("far away") then
if _a568.HatchAutoTp then _a575.egg.tpEgg(_a684.id) task.wait(0.2)
else _a562("[부화] 알에서 너무 멈") break end
elseif _a688 > 1 then
_a688 = math.floor(_a688 / 2)
else
if _a575.egg.hatchErr ~= _a711 then
_a575.egg.hatchErr = _a711
_a562("[부화] 실패: " .. _a711 .. "   (알 " .. tostring(_a684.id)
.. " / 개수 " .. _a688 .. " / 거리 "
.. (_a684.dist and ("%.0f"):format(_a684.dist) or "?") .. ")")
end
break
end
end
end
if _a692 and _a689 > 0 and not _a696 then
local _a712 = os.clock()
local _a713 = _a568.HatchClickAfter
while _a691() > 0 and not _a575.ctl.stopped() and (os.clock() - _a712) < 20 do
_a575.ctl.setAct("알 마무리", ("%s  마지막 %d개 까는 중"):format(_a684.id, _a688))
if _a568.HatchClick and (os.clock() - _a712) > _a713 then
_a575.egg.clickOnce()
_a713 += 0.3
if (os.clock() - _a712) > 3 and not _a575.egg._finRe then
_a575.egg._finRe = true
_a575.egg._ahEgg = nil
_a575.egg.autoHatchOn(_a684.id, _a688)
end
end
task.wait(0.03)
end
_a575.egg._finRe = nil
if _a691() > 0 then
_a562("[부화] 마지막 알이 20초 넘게 안 끝남 — 그대로 두고 진행합니다")
end
end
_a575.egg.autoHatchOff()
if _a689 > 0 then
_a575.egg.hatchErr = nil
_a562(("[부화] %s × %d%s  (개당 %s %s)"):format(
_a684.id, _a689, _a698 and " (목표까지)" or "",
_a684.price and _a563(_a684.price, 0) or "?", tostring(_a684.currency)))
end
end
local function _a714()
local _a715 = _a602()
if not _a715 then return nil end
local _a716 = tonumber(rawget(_a715, "Rank")) or 1
local _a717 = tonumber(rawget(_a715, "RankStars")) or 0
local _a718 = rawget(_a715, "RedeemedRankRewards") or {}
local _a719
if _a573.RanksU and rawget(_a573.RanksU, "RankIDFromNumber") then
local _a720, _a721 = pcall(_a573.RanksU.RankIDFromNumber, _a716)
if _a720 then _a719 = _a721 end
end
local _a722 = _a719 and _a573.DirRanks and rawget(_a573.DirRanks, _a719)
if type(_a722) ~= "table" then
return { rankNum = _a716, stars = _a717, rankId = _a719, rewards = {} }
end
local _a723, _a724 = {}, 0
for _a725, _a726 in ipairs(rawget(_a722, "Rewards") or {}) do
_a724 += (tonumber(rawget(_a726, "StarsRequired")) or 0)
local _a727 = _a724 <= _a717
local _a728 = _a718[tostring(_a725)] ~= nil
_a723[#_a723 + 1] = {
index = _a725, need = _a724, earned = _a727, redeemed = _a728,
claimable = _a727 and not _a728,
}
end
return { rankNum = _a716, stars = _a717, rankId = _a719, rewards = _a723 }
end
local function _a729()
if not _a573.R_Rank then _a562("[랭크] Ranks_ClaimReward 리모트 없음") return end
local _a730 = _a714()
if not _a730 then return end
local _a731 = 0
for _a732, _a733 in ipairs(_a730.rewards) do
if not _a569.rank then break end
if _a733.claimable then
pcall(function() _a573.R_Rank:FireServer(_a733.index) end)
_a731 += 1
_a570.rank += 1
task.wait(0.1)
end
end
if _a731 > 0 then
_a562(("[랭크] 보상 %d개 수령  (Rank %d, ★%d)"):format(_a731, _a730.rankNum, _a730.stars))
end
end
function _a575.move.hrp()
local _a734 = _a561.Character
return _a734 and _a734:FindFirstChild("HumanoidRootPart"),
_a734 and _a734:FindFirstChildOfClass("Humanoid")
end
function _a575.egg.autoHatchOn(_a735, _a736)
if not _a568.UseAutoHatch then return end
if _a575.egg._ahEgg == _a735 and _a575.egg._ahAt and (os.clock() - _a575.egg._ahAt) < 15 then return end
_a575.egg._ahEgg, _a575.egg._ahAt = _a735, os.clock()
local _a737 = _a573.DirEggs and rawget(_a573.DirEggs, _a735)
if _a573.Hatch and _a737 and rawget(_a573.Hatch, "SetupEgg") then
local _a738, _a739 = pcall(_a573.Hatch.SetupEgg, _a737, _a736 or 1)
if not _a738 and not _a575.egg._ahWarn then
_a575.egg._ahWarn = true
_a562("[부화] SetupEgg 실패: " .. tostring(_a739) .. "  → 클릭 대체 사용")
end
end
if _a573.R_AHTog then pcall(function() _a573.R_AHTog:FireServer(true) end) end
if _a573.R_AHOn then pcall(function() _a573.R_AHOn:FireServer(_a735, _a736 or 1) end) end
if _a573.Hatch and rawget(_a573.Hatch, "IsHatching") then
local _a740, _a741 = pcall(_a573.Hatch.IsHatching)
_a575.egg._ahLive = _a740 and _a741 and true or false
end
end
function _a575.egg.autoHatchOff()
_a575.egg._ahEgg, _a575.egg._ahAt, _a575.egg._ahLive = nil, nil, nil
if _a573.Hatch and rawget(_a573.Hatch, "StopHatching") then pcall(_a573.Hatch.StopHatching) end
if _a573.R_AHOff then pcall(function() _a573.R_AHOff:FireServer() end) end
end
function _a575.egg.clickOnce()
if _a575.ctl.moving then return false end
local _a742 = _a575.screen.signal("egg")
if not _a742 then _a742 = _a575.screen.pressInGame({ "Egg Opening" }) end
if not _a742 and not _a575.egg._eggSigWarn then
_a575.egg._eggSigWarn = true
_a562("[부화] 게임 내 방법이 다 막힘 — SetupEgg 에만 의존합니다")
end
return _a742
end
function _a575.item.applyPetSpeed()
local _a743 = _a573.PlayerPet
if not (_a743 and rawget(_a743, "GetByPlayer")) then return 0, "PlayerPet 없음" end
local _a744, _a745 = pcall(_a743.GetByPlayer, _a561)
if not (_a744 and type(_a745) == "table") then return 0, "펫 목록 못 읽음" end
local _a746 = math.max(1, tonumber(_a568.PetSpeedMult) or 50)
local _a747 = math.max(0.05, tonumber(_a568.PetSpeedBase) or 4)
local _a748 = 0
for _a749, _a750 in pairs(_a745) do
if type(_a750) == "table" then
local _a751 = rawget(_a750, "cpet")
if _a751 then
_a750.speedMult = _a746
pcall(function() _a751:Broadcast("petSpeedMult", _a746) end)
pcall(function() _a751:Broadcast("petSpeed", _a747) end)
_a748 += 1
end
end
end
return _a748
end
_a575.screen.SIGNAL = {
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
_a575.screen.BLOCKERS = {
{ "Rebirth",     "리버스",   "reward" },
{ "RankUp",      "랭크업",   "reward" },
{ "MasteryPerk", "마스터리", "mastery" },
{ "Card",        "카드",     "card" },
}
function _a575.screen.findSignalFns(_a752)
local _a753 = _a575.screen.SIGNAL[_a752]
if not _a753 then return {} end
_a575.screen._sig = _a575.screen._sig or {}
local _a754 = _a575.screen._sig[_a752]
if _a754 and (os.clock() - _a754.at) < (#_a754.fns > 0 and 20 or 3) then return _a754.fns end
local _a755 = {}
_a575.screen._sig[_a752] = { at = os.clock(), fns = _a755 }
if type(getgc) ~= "function" or type(debug) ~= "table"
or type(debug.info) ~= "function" or type(debug.getupvalue) ~= "function" then
return _a755
end
local _a756 = {}
for _a757, _a758 in ipairs({ true, false }) do
local _a759, _a760 = pcall(getgc, _a758)
if _a759 and type(_a760) == "table" then
for _a761, _a762 in ipairs(_a760) do _a756[#_a756 + 1] = _a762 end
end
end
if #_a756 == 0 then return _a755 end
for _a763, _a764 in ipairs(_a756) do
if type(_a764) == "function" then
local _a765, _a766 = pcall(debug.info, _a764, "s")
if _a765 and type(_a766) == "string" then
local _a767 = false
for _a768, _a769 in ipairs(_a753.pats) do
if _a766:find(_a769, 1, true) then _a767 = true break end
end
if _a767 then
local _a770, _a771 = pcall(debug.info, _a764, "a")
if _a770 then
local _a772, _a773 = {}, 0
for _a774 = 1, 16 do
local _a775, _a776 = pcall(debug.getupvalue, _a764, _a774)
if not _a775 then break end
_a773 = _a774
_a772[_a774] = type(_a776)
end
local _a777 = table.concat(_a772, ",")
local _a778 = false
for _a779, _a780 in ipairs(_a753.sigs or {}) do
if _a771 == _a780.np and _a777 == _a780.t then
_a755[#_a755 + 1] = { fn = _a764, sig = _a777, n = _a773, np = _a771,
src = _a766, set = _a780.set }
_a778 = true
break
end
end
if not _a778 and _a753.sigs then
local _a781 = {}
for _a782, _a783 in ipairs(_a772) do
if _a783 == "boolean" then _a781[#_a781 + 1] = _a782 end
end
if #_a781 > 0 then
_a755[#_a755 + 1] = { fn = _a764, idx = _a781, sig = _a777, n = _a773,
np = _a771, src = _a766, loose = true }
end
end
if not _a778 and not _a753.sigs and _a771 == 0 then
local _a784 = 0
for _a785, _a786 in ipairs(_a772) do if _a786 == "boolean" then _a784 += 1 end end
if _a784 >= (_a753.minBools or 1) then
local _a787 = {}
for _a788, _a789 in ipairs(_a772) do
if _a789 == "boolean" then _a787[#_a787 + 1] = _a788 end
end
_a755[#_a755 + 1] = { fn = _a764, idx = _a787, sig = _a777, n = _a773, src = _a766 }
end
end
end
end
end
end
end
return _a755
end
function _a575.screen.signal(_a790)
if type(debug) ~= "table" or type(debug.setupvalue) ~= "function" then return false, 0 end
local _a791 = _a575.screen.findSignalFns(_a790)
local _a792 = 0
for _a793, _a794 in ipairs(_a791) do
if _a794.set then
for _a795, _a796 in ipairs(_a794.set) do
if pcall(debug.setupvalue, _a794.fn, _a796[1], _a796[2]) then _a792 += 1 end
end
elseif not _a794.loose then
for _a797, _a798 in ipairs(_a794.idx or {}) do
if pcall(debug.setupvalue, _a794.fn, _a798, true) then _a792 += 1 end
end
end
end
if _a792 == 0 then
for _a799, _a800 in ipairs(_a791) do
if _a800.loose then
for _a801, _a802 in ipairs(_a800.idx or {}) do
if pcall(debug.setupvalue, _a800.fn, _a802, true) then _a792 += 1 end
end
end
end
end
return _a792 > 0, _a792
end
function _a575.screen.pressInGame(_a803)
local _a804, _a805 = pcall(function() return game:GetService("UserInputService") end)
if not (_a804 and _a805) then return false end
local _a806 = {
UserInputType  = Enum.UserInputType.MouseButton1,
UserInputState = Enum.UserInputState.Begin,
KeyCode        = Enum.KeyCode.Unknown,
Position       = Vector3.new(),
Delta          = Vector3.new(),
}
local _a807 = 0
if type(getconnections) == "function" then
local _a808, _a809 = pcall(getconnections, _a805.InputBegan)
if _a808 and type(_a809) == "table" then
for _a810, _a811 in ipairs(_a809) do
local _a812 = ""
local _a813 = _a811.Function
if _a813 and type(debug) == "table" and type(debug.info) == "function" then
local _a814, _a815 = pcall(debug.info, _a813, "s")
if _a814 and _a815 then _a812 = tostring(_a815) end
end
local _a816 = false
for _a817, _a818 in ipairs(_a803) do
if _a812 ~= "" and _a812:find(_a818, 1, true) then _a816 = true break end
end
if _a816 then
if _a813 and pcall(_a813, _a806, false) then _a807 += 1
elseif _a811.Fire and pcall(function() _a811:Fire(_a806, false) end) then _a807 += 1
elseif _a811.Defer and pcall(function() _a811:Defer(_a806, false) end) then _a807 += 1 end
end
end
end
end
if _a807 == 0 and type(firesignal) == "function" then
if pcall(firesignal, _a805.InputBegan, _a806, false) then _a807 += 1 end
end
return _a807 > 0
end
function _a575.screen.realClick(_a819)
if not _a568.ScreenRealClick then return false end
local _a820 = workspace.CurrentCamera
local _a821 = (_a820 and _a820.ViewportSize) or Vector2.new(1280, 720)
local _a822, _a823 = _a821.X * 0.5, _a821.Y * 0.45
local _a824 = {}
local function _a825(_a826, _a827)
local _a828 = pcall(_a827)
_a824[#_a824 + 1] = _a826 .. (_a828 and "=OK" or "=X")
return _a828
end
local _a829 = false
if not _a829 and type(mouse1click) == "function" then
_a829 = _a825("mouse1click", function() mouse1click() end)
end
if not _a829 and type(mouse1press) == "function" then
_a829 = _a825("mouse1press", function()
mouse1press() task.wait(0.05)
if type(mouse1release) == "function" then mouse1release() end
end)
end
if not _a829 then
_a829 = _a825("VirtualUser", function()
local _a830 = game:GetService("VirtualUser")
_a830:Button1Down(Vector2.new(_a822, _a823), _a820 and _a820.CFrame or CFrame.new())
task.wait(0.05)
_a830:Button1Up(Vector2.new(_a822, _a823), _a820 and _a820.CFrame or CFrame.new())
end)
end
if not _a829 then
_a829 = _a825("VirtualInputManager", function()
local _a831 = game:GetService("VirtualInputManager")
_a831:SendMouseButtonEvent(_a822, _a823, 0, true, game, 1)
task.wait(0.05)
_a831:SendMouseButtonEvent(_a822, _a823, 0, false, game, 1)
end)
end
if _a819 then _a562("    " .. table.concat(_a824, " / ")) end
return _a829
end
function _a575.screen.rewardScreenUp()
local _a832 = _a561:FindFirstChildOfClass("PlayerGui")
if _a832 then
for _a833, _a834 in ipairs(_a575.screen.BLOCKERS) do
local _a835 = _a832:FindFirstChild(_a834[1])
if _a835 and _a835:IsA("ScreenGui") and _a835.Enabled then return true, _a834[2], _a834[3] end
end
end
local _a836 = _a573.Vars
if _a836 then
if rawget(_a836, "IsRebirthing") then return true, "리버스", "reward" end
if rawget(_a836, "IsRankingUp") then return true, "랭크업", "reward" end
end
return false
end
function _a575.screen.dismissRewardScreens(_a837)
if _a575.screen.dismissBusy then return end
_a575.screen.dismissBusy = true
local _a838, _a839 = pcall(_a575.screen.dismissInner, _a837)
_a575.screen.dismissBusy = false
if not _a838 then _a562("[화면] 오류: " .. tostring(_a839)) end
end
function _a575.screen.dismissInner(_a840)
local _a841 = _a573.Vars
if not _a841 then return end
local _a842 = os.clock()
local _a843, _a844 = false, nil
local _a845 = 0
local _a846 = math.max(3, _a568.ScreenTryMax or 8)
while os.clock() - _a842 < (_a840 or 120) do
local _a847, _a848, _a849 = _a575.screen.rewardScreenUp()
if not _a847 then break end
_a843, _a844 = true, _a848
_a845 += 1
_a575.ctl.setAct("보상 화면 넘기는 중",
("%s (%d회%s)"):format(tostring(_a848), _a845,
_a845 <= 6 and " · 첫 화면 대기" or ""))
local _a850 = _a575.screen.SIGNAL[_a849 or "reward"]
local _a851 = (_a850 and _a850.pats) or { "Rebirth", "Rank Up" }
local _a852 = _a575.screen.signal(_a849 or "reward")
if not _a852 then
for _a853 in pairs(_a575.screen.SIGNAL) do
if _a575.screen.signal(_a853) then _a852 = true end
end
end
local _a854 = false
if not _a852 or _a845 >= 2 then
_a854 = _a575.screen.pressInGame(_a851)
end
if _a845 >= 3 then
if _a575.screen.realClick() then
_a854 = true
if not _a575.screen._realSaid then
_a575.screen._realSaid = true
_a562("[화면] 실제 클릭까지 같이 씁니다 (Roblox 창이 켜져 있어야 먹습니다)")
end
end
end
if (_a852 or _a854) and not _a575.screen._sigSaid then
_a575.screen._sigSaid = true
_a562("[화면] " .. (_a852 and "upvalue 신호" or "게임 내 입력 발동") .. " 로 넘깁니다")
end
if _a845 >= _a846 and (os.clock() - _a842) >= 12 then
if _a575.screen.giveUpSaid ~= _a848 then
_a575.screen.giveUpSaid = _a848
_a562(("[화면] %s 화면을 못 넘김 — 그냥 두고 자동화는 계속합니다"):format(tostring(_a848)))
_a562("        (이 화면은 UI만 가릴 뿐 리모트 호출은 막지 않습니다)")
end
_a575.screen.screenGaveUp = os.clock()
return
end
task.wait(0.8)
end
if _a843 then
if not _a575.screen.rewardScreenUp() then
_a575.screen.lastBlocker = nil
_a575.screen.screenGaveUp = nil
_a562(("[화면] %s 넘김 완료 (%d회)"):format(tostring(_a844), _a845))
end
end
end
function _a575.egg.eggUnlocked(_a855)
_a855 = tonumber(_a855)
if not _a855 then return false end
local _a856 = _a602()
local _a857 = _a856 and rawget(_a856, "UnlockedEggs")
if type(_a857) == "table" then
for _a858, _a859 in pairs(_a857) do
if tonumber(_a859) == _a855 then return true end
end
return false
end
return _a855 <= 1
end
function _a575.egg.lockedEggs()
local _a860 = {}
if not _a573.DirEggs then return _a860, 0, 0 end
local _a861 = _a602()
local _a862 = tonumber(_a861 and rawget(_a861, "MaximumAvailableEgg")) or 1
local _a863 = 0
local _a864 = _a861 and rawget(_a861, "UnlockedEggs")
if type(_a864) == "table" then
for _a865, _a866 in pairs(_a864) do
local _a867 = tonumber(_a866)
if _a867 and _a867 > _a863 then _a863 = _a867 end
end
end
for _a868, _a869 in pairs(_a573.DirEggs) do
if type(_a869) == "table" and not rawget(_a869, "isCustomEgg") then
local _a870 = tonumber(rawget(_a869, "eggNumber"))
if _a870 and _a870 <= _a862 and not _a575.egg.eggUnlocked(_a870) then
_a860[#_a860 + 1] = { id = _a868, num = _a870 }
end
end
end
table.sort(_a860, function(_a871, _a872) return _a871.num < _a872.num end)
return _a860, _a862, _a863
end
function _a575.egg.unlockEggs(_a873)
if not _a573.R_EggUn then return 0, "Eggs_RequestUnlock 리모트 없음" end
local _a874 = _a575.egg.lockedEggs()
if #_a874 == 0 then return 0 end
local _a875, _a876 = 0, nil
for _a877, _a878 in ipairs(_a874) do
if not _a575.egg.eggUnlocked(_a878.num) then
local _a879, _a880
pcall(function() _a879, _a880 = _a573.R_EggUn:InvokeServer(_a878.id) end)
if not _a879 and _a568.HatchAutoTp then
local _a881 = _a575.egg.tpEgg(_a878.id)
if _a881 then
task.wait(0.3)
pcall(function() _a879, _a880 = _a573.R_EggUn:InvokeServer(_a878.id) end)
end
end
if _a879 then
_a875 += 1
_a575.ctl.setAct("알 해금", ("#%d %s"):format(_a878.num, _a878.id))
_a562(("  🔓 알 해금  #%d %s"):format(_a878.num, _a878.id))
task.wait(0.15)
else
_a876 = _a880
if _a873 then
_a562(("[해금] #%d %s 실패: %s"):format(_a878.num, _a878.id, tostring(_a880)))
end
end
end
end
return _a875, _a876
end
function _a575.move.curZone()
if _a573.Map and rawget(_a573.Map, "GetCurrentZone") then
local _a882, _a883 = pcall(_a573.Map.GetCurrentZone)
if _a882 then return _a883 end
end
return nil
end
function _a575.move.zone1()
if not _a573.DirZones then return nil end
local _a884, _a885 = nil, math.huge
for _a886, _a887 in pairs(_a573.DirZones) do
if type(_a887) == "table" and _a575.move.ownsZone(_a886) then
local _a888 = tonumber(rawget(_a887, "ZoneNumber")) or math.huge
if _a888 < _a885 then _a884, _a885 = _a886, _a888 end
end
end
return _a884
end
function _a575.move.realZone(_a889) return _a889 end
function _a575.move.resolvableZone(_a890)
if _a890 then
local _a891 = _a575.move.zonePos(_a890)
if _a891 then return _a890, _a891 end
end
if not _a573.DirZones then return nil end
local _a892 = {}
for _a893, _a894 in pairs(_a573.DirZones) do
if type(_a894) == "table" and _a575.move.ownsZone(_a893) then
_a892[#_a892 + 1] = { id = _a893, n = tonumber(rawget(_a894, "ZoneNumber")) or 0 }
end
end
table.sort(_a892, function(_a895, _a896) return _a895.n > _a896.n end)
for _a897, _a898 in ipairs(_a892) do
if _a898.id ~= _a890 then
local _a899 = _a575.move.zonePos(_a898.id)
if _a899 then
if _a575.move.fallZone ~= _a898.id then
_a575.move.fallZone = _a898.id
_a562(("[TP] %s 좌표를 못 구해서 %s 로 대신 감 (로드 안 된 존)"):format(
tostring(_a890), tostring(_a898.id)))
end
return _a898.id, _a899
end
end
end
return nil
end
function _a575.move.bestZone()
if _a573.Zone and rawget(_a573.Zone, "GetMaxOwnedZone") then
local _a900, _a901, _a902 = pcall(_a573.Zone.GetMaxOwnedZone)
if _a900 and _a901 then return _a901, _a902 end
end
return _a575.move.zone1()
end
function _a575.move.ownsZone(_a903)
local _a904 = _a602()
local _a905 = _a904 and rawget(_a904, "UnlockedZones")
return (type(_a905) == "table" and _a905[_a903] ~= nil) or false
end
function _a575.move.zoneByNumber(_a906)
if not (_a573.DirZones and _a906) then return nil end
for _a907, _a908 in pairs(_a573.DirZones) do
if type(_a908) == "table" and tonumber(rawget(_a908, "ZoneNumber")) == tonumber(_a906) then
return _a907, _a908
end
end
return nil
end
local function _a909(_a910, _a911)
local _a912 = rawget(_a910, "Breakables")
local _a913 = type(_a912) == "table" and rawget(_a912, "Main") or nil
local _a914 = type(_a913) == "table" and rawget(_a913, "Data") or nil
if type(_a914) ~= "table" then return false end
for _a915, _a916 in pairs(_a914) do
local _a917 = type(_a916) == "table" and rawget(_a916, "Type") or nil
if _a917 and tostring(_a917):lower():find(_a911, 1, true) then return true end
end
return false
end
function _a575.move.zoneForBreakable(_a918)
if not (_a573.DirZones and _a918) then return nil end
local _a919 = tostring(_a918):lower()
local _a920 = _a575.move.bestZone()
if _a920 then
local _a921 = rawget(_a573.DirZones, _a920)
if type(_a921) == "table" and _a909(_a921, _a919) then return _a920 end
end
local _a922, _a923 = nil, -1
for _a924, _a925 in pairs(_a573.DirZones) do
if type(_a925) == "table" and _a924 ~= "Spawn" and _a575.move.ownsZone(_a924) then
local _a926 = rawget(_a925, "Breakables")
local _a927 = type(_a926) == "table" and rawget(_a926, "Main") or nil
local _a928 = type(_a927) == "table" and rawget(_a927, "Data") or nil
if type(_a928) == "table" then
for _a929, _a930 in pairs(_a928) do
local _a931 = type(_a930) == "table" and rawget(_a930, "Type") or nil
if _a931 and tostring(_a931):lower():find(_a919, 1, true) then
local _a932 = tonumber(rawget(_a925, "ZoneNumber")) or 0
if _a932 > _a923 then _a922, _a923 = _a924, _a932 end
break
end
end
end
end
end
return _a922
end
function _a575.move.tpZone(_a933)
if not _a933 then return false, "존 id 없음" end
if _a575.move.curZone() == _a933 then return true end
if not _a568.TpGameFallback then
_a562("[TP] 게임 정식 TP 차단됨 (" .. tostring(_a933) .. ")\n" .. debug.traceback("", 2))
return false, "게임 TP 꺼져 있음"
end
local _a934 = _a573.R_Tp
if _a573.Inst and rawget(_a573.Inst, "IsInInstance") then
local _a935, _a936 = pcall(_a573.Inst.IsInInstance)
if _a935 and _a936 and _a573.R_TpI then _a934 = _a573.R_TpI end
end
if not _a934 then return false, "텔레포트 리모트 없음" end
local _a937 = os.clock() - (_a575.move.lastTp or 0)
if _a937 < _a568.TpCooldown then task.wait(_a568.TpCooldown - _a937) end
_a575.move.lastTp = os.clock()
local _a938, _a939
pcall(function() _a938, _a939 = _a934:InvokeServer(_a933) end)
if not _a938 then return false, _a939 end
local _a940 = os.clock()
while os.clock() - _a940 < 5 do
if _a575.move.curZone() == _a933 then break end
task.wait(0.05)
end
task.wait(0.15)
return true
end
function _a575.move.glideTo(_a941)
if _a575.ctl.stopped() then return false, "정지됨" end
if _a575.ctl.moving and (os.clock() - _a575.ctl.moving) < 30 then
return false, "이미 이동 중 (다른 이동이 아직 안 끝남)"
end
_a575.ctl.moving = os.clock()
local _a942, _a943, _a944 = pcall(_a575.move.glideRaw, _a941)
_a575.ctl.moving = nil
if not _a942 then return false, tostring(_a943) end
return _a943, _a944
end
function _a575.move.glideRaw(_a945)
local _a946, _a947 = _a575.move.hrp()
if not _a946 then return false, "캐릭터 없음" end
if _a568.TpMode == "instant" then
local _a948 = _a945 + Vector3.new(0, 4, 0)
for _a949 = 1, 3 do
local _a950 = _a561.Character
local _a951, _a952 = _a575.move.hrp()
if not (_a950 and _a951) then return false, "캐릭터 없음" end
local _a953 = _a951.CFrame - _a951.CFrame.Position
pcall(function() _a950:PivotTo(CFrame.new(_a948) * _a953) end)
_a951.AssemblyLinearVelocity = Vector3.zero
for _a954 = 1, 6 do _a560.Heartbeat:Wait() end
if _a952 then
pcall(function()
_a952:Move(Vector3.new(0.3, 0, 0), false)
end)
task.wait(0.1)
pcall(function() _a952:Move(Vector3.zero, false) end)
end
task.wait(0.15)
_a951 = _a575.move.hrp()
if _a951 and (_a951.Position - _a948).Magnitude <= 30 then
local _a955 = os.clock()
while os.clock() - _a955 < 1.5 do
if _a575.move.inDottedBox() ~= false then break end
task.wait(0.05)
end
return true
end
if _a949 < 3 then task.wait(0.15) end
end
return false, "순간이동이 되돌려짐"
end
if _a568.TpMode == "walk" then
if not _a947 then return false, "Humanoid 없음" end
local _a956 = os.clock()
while os.clock() - _a956 < 45 do
local _a957 = _a946.Position
if (Vector3.new(_a957.X, 0, _a957.Z) - Vector3.new(_a945.X, 0, _a945.Z)).Magnitude < 8 then
return true
end
_a947:MoveTo(_a945)
task.wait(0.5)
end
return false, "걸어가다 시간초과"
end
if (_a946.Position - _a945).Magnitude <= (_a568.ArriveDist or 12) then return true end
local _a958 = math.max(16, tonumber(_a568.TpSpeed) or 90)
local _a959 = math.max(0, tonumber(_a568.TpHeight) or 0)
local function _a960(_a961, _a962)
local _a963 = 0
while _a963 < 2000 do
if _a575.ctl.stopped() then return false end
_a963 += 1
local _a964 = _a575.move.hrp()
if not _a964 then return false end
local _a965 = _a964.Position
local _a966 = _a961 - _a965
local _a967 = _a966.Magnitude
if _a967 < 2.5 then return true end
local _a968 = _a560.Heartbeat:Wait()
local _a969 = math.min(_a967, _a958 * math.min(_a968, 0.1))
local _a970 = _a962 and (Vector3.new(_a961.X, _a965.Y, _a961.Z)) or nil
if _a970 and (_a970 - _a965).Magnitude > 1 then
_a964.CFrame = CFrame.lookAt(_a965 + _a966.Unit * _a969, _a970)
else
_a964.CFrame = CFrame.new(_a965 + _a966.Unit * _a969) * (_a964.CFrame - _a964.Position)
end
_a964.AssemblyLinearVelocity = Vector3.zero
end
return false
end
if _a959 > 0 then
local _a971 = _a946.Position
local _a972 = math.max(_a971.Y, _a945.Y) + _a959
_a960(Vector3.new(_a971.X, _a972, _a971.Z), false)
_a960(Vector3.new(_a945.X, _a972, _a945.Z), true)
end
_a960(_a945 + Vector3.new(0, 3, 0), true)
local _a973 = _a575.move.hrp()
if _a973 then _a973.AssemblyLinearVelocity = Vector3.zero end
return true
end
local function _a974(_a975)
local _a976 = #_a975
if _a976 == 0 then return nil, 0 end
local _a977, _a978 = math.huge, -math.huge
local _a979, _a980 = math.huge, -math.huge
local _a981 = 0
for _a982, _a983 in ipairs(_a975) do
if _a983.X < _a977 then _a977 = _a983.X end
if _a983.X > _a978 then _a978 = _a983.X end
if _a983.Z < _a979 then _a979 = _a983.Z end
if _a983.Z > _a980 then _a980 = _a983.Z end
_a981 += _a983.Y
end
return Vector3.new((_a977 + _a978) / 2, _a981 / _a976, (_a979 + _a980) / 2), _a976
end
function _a575.move.breakCenter(_a984)
local _a985 = _a575.move.hrp()
if not _a985 then return nil, 0 end
local _a986 = workspace:FindFirstChild("__THINGS")
if not _a986 then return nil, 0 end
local _a987 = _a985.Position
local _a988 = {}
for _a989, _a990 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a991 = _a986:FindFirstChild(_a990)
if _a991 then
for _a992, _a993 in ipairs(_a991:GetChildren()) do
local _a994
if _a993:IsA("BasePart") then _a994 = _a993.Position
elseif _a993:IsA("Model") then
local _a995, _a996 = pcall(function() return _a993:GetPivot() end)
if _a995 and typeof(_a996) == "CFrame" then _a994 = _a996.Position end
end
if _a994 and (_a994 - _a987).Magnitude <= (_a984 or 400) then
_a988[#_a988 + 1] = _a994
end
end
end
end
return _a974(_a988)
end
function _a575.move.groundY(_a997, _a998, _a999)
_a999 = tonumber(_a999) or 0
local _a1000 = RaycastParams.new()
_a1000.FilterType = Enum.RaycastFilterType.Exclude
local _a1001 = {}
if _a561.Character then _a1001[#_a1001 + 1] = _a561.Character end
local _a1002 = workspace:FindFirstChild("__THINGS")
if _a1002 then _a1001[#_a1001 + 1] = _a1002 end
_a1000.FilterDescendantsInstances = _a1001
local _a1003 = Vector3.new(_a997, _a999 + 12, _a998)
local _a1004, _a1005 = pcall(function()
return workspace:Raycast(_a1003, Vector3.new(0, -160, 0), _a1000)
end)
if _a1004 and _a1005 then
local _a1006 = _a1005.Position.Y
if math.abs(_a1006 - _a999) <= 80 then return _a1006 + 4 end
end
return nil
end
function _a575.move.zonePos(_a1007, _a1008)
if not _a1007 then return nil, "존 id 없음" end
_a1007 = _a575.move.realZone(_a1007)
local _a1009 = _a573.DirZones and rawget(_a573.DirZones, _a1007)
local _a1010 = _a1009 and rawget(_a1009, "ZoneFolder")
local _a1011 = {}
do
local _a1012 = workspace:FindFirstChild("__THINGS")
for _a1013, _a1014 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a1015 = _a1012 and _a1012:FindFirstChild(_a1014)
if _a1015 then
for _a1016, _a1017 in ipairs(_a1015:GetChildren()) do
local _a1018
if _a1017:IsA("BasePart") then _a1018 = _a1017.Position
elseif _a1017:IsA("Model") then
local _a1019, _a1020 = pcall(function() return _a1017:GetPivot() end)
if _a1019 and typeof(_a1020) == "CFrame" then _a1018 = _a1020.Position end
end
if _a1018 then _a1011[#_a1011 + 1] = _a1018 end
end
end
end
end
local _a1021 = {}
local function _a1022(_a1023, _a1024)
if not _a1023 then return end
local _a1025, _a1026 = pcall(function() return _a1023:GetDescendants() end)
if _a1023:IsA("BasePart") then _a1021[#_a1021 + 1] = { p = _a1023.Position, why = _a1024 } end
if _a1025 then
for _a1027, _a1028 in ipairs(_a1026) do
if _a1028:IsA("BasePart") then
_a1021[#_a1021 + 1] = { p = _a1028.Position, why = _a1024 .. "/" .. _a1028.Name }
end
end
end
end
if _a573.ZonesU then
for _a1029, _a1030 in ipairs({ "GetBreakableZones", "GetBreakableSpawns" }) do
local _a1031 = rawget(_a573.ZonesU, _a1030)
if type(_a1031) == "function" then
local _a1032, _a1033 = pcall(_a1031, _a1007)
if _a1032 and _a1033 then _a1022(_a1033, _a1030) end
end
end
end
if _a1010 then
for _a1034, _a1035 in ipairs({ "BREAK_ZONES", "BREAKABLE_SPAWNS" }) do
local _a1036, _a1037 = pcall(function() return _a1010:FindFirstChild(_a1035, true) end)
if _a1036 and _a1037 then _a1022(_a1037, "ZoneFolder/" .. _a1035) end
end
end
local _a1038, _a1039, _a1040
for _a1041, _a1042 in ipairs(_a1021) do
local _a1043 = 0
for _a1044, _a1045 in ipairs(_a1011) do
if (_a1045 - _a1042.p).Magnitude <= 150 then _a1043 += 1 end
end
if not _a1039 or _a1043 > _a1039 then _a1038, _a1039, _a1040 = _a1042.p, _a1043, _a1042.why end
end
local _a1046, _a1047
if _a1038 and (_a1039 or 0) >= 1 then
_a1046, _a1047 = _a1038, ("%s (브레이커블 %d개)"):format(tostring(_a1040), _a1039)
end
if not _a1046 and _a1038 then
_a1046, _a1047 = _a1038, tostring(_a1040) .. " (브레이커블 없음)"
end
if not _a1046 and _a573.ZonesU and rawget(_a573.ZonesU, "GetTeleportPartLocation") then
local _a1048, _a1049 = pcall(_a573.ZonesU.GetTeleportPartLocation, _a1007)
if _a1048 and typeof(_a1049) == "CFrame" then
_a1046, _a1047 = _a1049.Position, "PERSISTENT/Teleport (스트리밍 대기)"
end
end
if not _a1046 then return nil, "브레이커블 위치를 못 찾음" end
local _a1050 = _a575.move.groundY(_a1046.X, _a1046.Z, _a1046.Y)
if _a1050 then
_a1046 = Vector3.new(_a1046.X, _a1050, _a1046.Z)
_a1047 = _a1047 .. " +지면"
else
_a1046 = Vector3.new(_a1046.X, _a1046.Y + 5, _a1046.Z)
end
return _a1046, _a1047
end
function _a575.move.goToZone(_a1051, _a1052, _a1053, _a1054)
_a1051 = _a575.move.realZone(_a1051)
if not _a1051 then return false, "존 id 없음" end
local _a1055, _a1056 = _a575.move.zonePos(_a1051)
if not _a1055 then
if _a568.TpGameFallback and _a575.move.curZone() ~= _a1051 then
local _a1057, _a1058 = _a575.move.tpZone(_a1051)
if not _a1057 then return false, _a1058 end
task.wait(0.3)
_a1055, _a1056 = _a575.move.zonePos(_a1051)
end
if not _a1055 then
local _a1059, _a1060 = _a575.move.resolvableZone(_a1051)
if _a1059 and _a1060 then
if _a1054 then
return false, ("%s 가 로드되지 않음"):format(tostring(_a1051))
end
_a1051, _a1055, _a1056 = _a1059, _a1060, "대체 존 " .. tostring(_a1059)
else
if _a575.move.zoneFailSaid ~= _a1051 then
_a575.move.zoneFailSaid = _a1051
_a562(("[TP] %s 좌표 실패: %s (갈 수 있는 존이 없음)"):format(
tostring(_a1051), tostring(_a1056)))
end
return false, _a1056
end
end
end
local _a1061 = _a575.move.hrp()
if not _a1053 and _a1061 and _a575.move.curZone() == _a1051 then
local _a1062 = _a575.move.inDottedBox()
local _a1063
if _a1062 ~= nil then
_a1063 = _a1062
else
_a1063 = (_a1061.Position - _a1055).Magnitude <= (_a568.ZoneArriveDist or 90)
end
if _a1063 then
if _a1052 then _a562("[TP] 이미 " .. _a1051 .. " 사냥터 안에 있음") end
return true
end
end
if _a1052 then
_a562(("[TP] %s 내부 좌표 %s → (%.0f, %.0f, %.0f)"):format(
_a1051, tostring(_a1056), _a1055.X, _a1055.Y, _a1055.Z))
end
local _a1064, _a1065 = _a575.move.glideTo(_a1055)
local _a1066 = _a575.move.hrp()
if _a1066 and (_a1066.Position - _a1055).Magnitude > math.max(40, _a568.ArriveDist or 12) then
task.wait(0.2)
_a575.ctl.moving = nil
_a575.move.glideTo(_a1055)
local _a1067 = _a575.move.hrp()
local _a1068 = _a1067 and (_a1067.Position - _a1055).Magnitude or -1
if _a1068 > math.max(40, _a568.ArriveDist or 12) then
local _a1069 = _a568.TpMode
_a568.TpMode = "glide"
_a575.ctl.moving = nil
_a575.move.glideTo(_a1055)
_a568.TpMode = _a1069
local _a1070 = _a575.move.hrp()
_a1068 = _a1070 and (_a1070.Position - _a1055).Magnitude or -1
if _a1068 > math.max(40, _a568.ArriveDist or 12) then
_a562(("[TP] %s 이동 실패 — %.0f스터드 남음 (순간이동·glide 둘 다)"):format(
tostring(_a1051), _a1068))
return false, "이동이 되돌려짐"
end
_a562("[TP] 순간이동이 막혀서 glide 로 이동함: " .. tostring(_a1051))
end
end
do
local _a1071 = _a575.move.hrp()
if _a1071 and (_a1071.Position.Y - _a1055.Y) > 25 then
_a562(("[TP] 목표보다 %.0f 높은 곳에 얹힘 — 내려감"):format(_a1071.Position.Y - _a1055.Y))
_a575.ctl.moving = nil
_a575.move.glideTo(Vector3.new(_a1055.X, _a1055.Y, _a1055.Z))
end
end
if tostring(_a1056):find("스트리밍", 1, true) then
task.wait(1.2)
local _a1072, _a1073 = _a575.move.zonePos(_a1051)
if _a1072 and not tostring(_a1073):find("스트리밍", 1, true) then
if _a1052 then
_a562("[TP] 스트리밍 로드됨 → 사냥터로 (" .. tostring(_a1073) .. ")")
end
_a575.ctl.moving = nil
_a575.move.glideTo(_a1072)
_a1055, _a1056 = _a1072, _a1073
end
end
if _a575.move.inDottedBox() == false then
task.wait(0.2)
local _a1074, _a1075 = _a575.move.breakCenter(400)
if _a1074 and _a1075 >= 3 then
if _a1052 then
_a562(("[TP] 네모 밖 → 주변 브레이커블 %d개 중심으로 보정"):format(_a1075))
end
_a575.ctl.moving = nil
_a575.move.glideTo(_a1074)
_a1055 = _a1074
end
if _a575.move.inDottedBox() == false then
local _a1076 = _a575.move.zonePos(_a1051)
if _a1076 and (_a1076 - _a1055).Magnitude > 5 then
if _a1052 then _a562("[TP] 아직 네모 밖 → 좌표 재계산 후 재시도") end
_a575.ctl.moving = nil
_a575.move.glideTo(_a1076)
_a1055 = _a1076
end
end
if _a575.move.inDottedBox() == false and _a1052 then
_a562(("[TP] %s 네모 안으로 못 들어감 (좌표 %s)"):format(_a1051, tostring(_a1056)))
end
end
local function _a1077()
if _a575.move.inDottedBox() == true then return false end
local _a1078, _a1079 = _a575.move.breakCenter(400)
if (_a1079 or 0) >= 1 then return false end
task.wait(0.6)
if _a575.move.inDottedBox() == true then return false end
local _a1080, _a1081 = _a575.move.breakCenter(400)
return (_a1081 or 0) < 1
end
if _a1077() and (os.clock() - (_a575.move.lastRecover or -999)) > 30 then
_a575.move.lastRecover = os.clock()
_a562(("[TP] %s 근처에 브레이커블이 없음 (%s) — 좌표 확인 필요"):format(
tostring(_a1051), tostring(_a1056)))
end
_a575.move.zoneFailSaid = nil
_a575.move.arrivedZone = _a1051
do
local _a1082 = _a575.move.hrp()
local _a1083 = _a1082 and (_a1082.Position - _a1055).Magnitude or 0
if _a1083 > math.max(60, _a568.ArriveDist or 12) then
_a562(("[TP] %s 도착 실패 — %.0f스터드 남음 (되돌려짐)"):format(tostring(_a1051), _a1083))
return false, "이동이 되돌려짐"
end
end
local _a1084 = _a575.move.hrp()
if _a1052 and _a1084 then
_a562(("[TP] 도착. 목표까지 %.0f스터드 / 존 %s / 네모안 %s"):format(
(_a1084.Position - _a1055).Magnitude, tostring(_a575.move.curZone()), tostring(_a575.move.inDottedBox())))
end
return true
end
function _a575.egg.tpEgg(_a1085)
if not _a1085 then return false, "알 id 없음" end
for _a1086, _a1087 in ipairs(_a575.egg.eggStands()) do
if _a1087.id == _a1085 then
if _a1087.dist <= _a568.EggRange then return true, _a1085 end
local _a1088, _a1089 = _a575.move.glideTo(_a1087.pos)
return _a1088, _a1088 and _a1085 or _a1089
end
end
if _a568.TpGameFallback then
local _a1090 = _a573.DirEggs and rawget(_a573.DirEggs, _a1085)
local _a1091 = _a1090 and select(1, _a575.move.zoneByNumber(rawget(_a1090, "zoneNumber")))
if _a1091 and _a575.move.curZone() ~= _a1091 then
local _a1092, _a1093 = _a575.move.tpZone(_a1091)
if not _a1092 then return false, _a1093 end
task.wait(0.5)
_a575.egg._standsAt = nil
for _a1094, _a1095 in ipairs(_a575.egg.eggStands()) do
if _a1095.id == _a1085 then return _a575.move.glideTo(_a1095.pos), _a1085 end
end
end
end
return false, "알 받침대를 못 찾음 (" .. tostring(_a1085) .. ")"
end
function _a575.item.stacks(_a1096)
local _a1097 = _a602()
local _a1098 = _a1097 and rawget(_a1097, "Inventory")
local _a1099 = _a1098 and rawget(_a1098, _a1096)
if type(_a1099) ~= "table" then return {} end
local _a1100 = {}
for _a1101, _a1102 in pairs(_a1099) do
if type(_a1102) == "table" then
_a1100[#_a1100 + 1] = {
uid = _a1101,
id = tostring(rawget(_a1102, "id")),
tier = tonumber(rawget(_a1102, "tn")) or 1,
am = tonumber(rawget(_a1102, "_am")) or 1,
}
end
end
return _a1100
end
_a575.item.PERTIER = {
Potion  = { 3, 3, 4, 5, 5, 5, 5, 5, 7, 7, 7 },
Enchant = { 5, 5, 5, 7, 7, 7, 7, 7, 10, 10 },
}
function _a575.item.perTier(_a1103, _a1104)
_a1104 = tonumber(_a1104)
local _a1105 = _a573.Bal and rawget(_a573.Bal,
_a1103 == "Potion" and "CalcPotionsPerTierRequired" or "CalcEnchantsPerTierRequired")
if type(_a1105) == "function" then
local _a1106, _a1107 = pcall(_a1105, _a1104)
_a1107 = _a1106 and tonumber(_a1107) or nil
if _a1107 and _a1107 > 0 then return _a1107 end
if not _a1106 and not _a575.item.perTierWarned then
_a575.item.perTierWarned = true
_a562("[퀘스트] 재료 수량 함수 막힘 → 기본표로 계산 (" .. tostring(_a1107) .. ")")
end
end
local _a1108 = _a575.item.PERTIER[_a1103]
local _a1109 = _a1108 and _a1104 and _a1108[_a1104]
return (_a1109 and _a1109 > 0) and _a1109 or nil
end
function _a575.item.upgradeTo(_a1110, _a1111)
local _a1112 = (_a1110 == "Potion") and _a573.R_PotUp or _a573.R_EncUp
if not _a1112 then return 0, (_a1110 .. " 업글 리모트 없음") end
local _a1113 = math.max(1, (tonumber(_a1111) or 2) - 1)
local _a1114 = _a575.item.perTier(_a1110, _a1113)
if not _a1114 then return 0, ("T%d 재료 수량을 못 읽음"):format(_a1113) end
local _a1115, _a1116 = {}, 0
for _a1117, _a1118 in ipairs(_a575.item.stacks(_a1110)) do
if _a1118.tier == _a1113 then
local _a1119 = math.floor(_a1118.am / _a1114)
if _a1119 > 0 then _a1115[_a1118.uid] = _a1119 _a1116 += _a1119 end
end
end
if _a1116 < 1 then return 0, ("T%d 재료 부족 (T%d %d개당 1개)"):format(_a1113, _a1113, _a1114) end
local _a1120, _a1121
pcall(function() _a1120, _a1121 = _a1112:InvokeServer(_a1115) end)
if not _a1120 then return 0, tostring(_a1121) end
return _a1116
end
function _a575.item.usePotion(_a1122, _a1123)
if not _a573.R_PotUse then return 0, "Potions: Consume 리모트 없음" end
_a1122 = tonumber(_a1122) or 1
local _a1124 = {}
for _a1125, _a1126 in ipairs(_a575.item.stacks("Potion")) do
if _a1126.tier >= _a1122 and _a1126.am >= 1 then _a1124[#_a1124 + 1] = _a1126 end
end
if #_a1124 == 0 then return 0, ("T%d 이상 포션 없음"):format(_a1122) end
table.sort(_a1124, function(_a1127, _a1128) return _a1127.tier < _a1128.tier end)
local _a1129, _a1130 = _a1123, 0
for _a1131, _a1132 in ipairs(_a1124) do
for _a1133 = 1, math.min(_a1129, _a1132.am) do
if _a1129 < 1 or not _a569.quest then break end
pcall(function() _a573.R_PotUse:FireServer(_a1132.uid, 1) end)
_a1130 += 1
_a1129 -= 1
task.wait(0.12)
end
if _a1129 < 1 then break end
end
return _a1130
end
_a575.ev.EVENTKIND = {
[31]="CoinJar",    [37]="CoinJar",    [68]="CoinJar",
[32]="Comet",      [38]="Comet",      [69]="Comet",
[66]="Pinata",     [43]="Pinata",     [70]="Pinata",
[67]="LuckyBlock", [44]="LuckyBlock", [71]="LuckyBlock",
}
_a575.ev.BESTONLY = { [37]=true, [38]=true, [43]=true, [44]=true, [39]=true, [76]=true }
_a575.ev.CHESTKIND = { [8]="MiniChests", [39]="MiniChests", [72]="MiniChests",
[75]="SuperiorMiniChests", [76]="SuperiorMiniChests", [77]="SuperiorMiniChests" }
local function _a1134(_a1135)
if typeof(_a1135) == "Vector3" then return _a1135 end
if typeof(_a1135) == "CFrame" then return _a1135.Position end
if type(_a1135) == "table" then
local _a1136, _a1137, _a1138 = tonumber(_a1135.X or _a1135.x or _a1135[1]), tonumber(_a1135.Y or _a1135.y or _a1135[2]), tonumber(_a1135.Z or _a1135.z or _a1135[3])
if _a1136 and _a1137 and _a1138 then return Vector3.new(_a1136, _a1137, _a1138) end
end
return nil
end
function _a575.ev.events()
local _a1139
if _a573.Rand and rawget(_a573.Rand, "GetActive") then
local _a1140, _a1141 = pcall(_a573.Rand.GetActive)
if _a1140 and type(_a1141) == "table" and next(_a1141) then _a1139 = _a1141 end
end
if not _a1139 and _a573.R_Events then
local _a1142, _a1143 = pcall(function() return _a573.R_Events:InvokeServer() end)
if _a1142 and type(_a1143) == "table" then _a1139 = _a1143 end
end
if type(_a1139) ~= "table" then return {} end
local _a1144 = workspace:GetServerTimeNow()
local _a1145 = {}
for _a1146, _a1147 in pairs(_a1139) do
if type(_a1147) == "table" then
local _a1148 = tostring(rawget(_a1147, "id") or "")
local _a1149 = _a1148:match("|%s*(%S+)%s*$") or _a1148
local _a1150 = tonumber(rawget(_a1147, "started")) or 0
local _a1151 = tonumber(rawget(_a1147, "duration")) or 0
_a1145[#_a1145 + 1] = {
uid = rawget(_a1147, "uid"),
id = _a1148,
kind = _a1149,
name = rawget(_a1147, "name") or _a1149,
zone = rawget(_a1147, "parentID"),
pos = _a1134(rawget(_a1147, "origin")),
left = math.max(0, _a1151 - (_a1144 - _a1150)),
}
end
end
table.sort(_a1145, function(_a1152, _a1153) return _a1152.left > _a1153.left end)
return _a1145
end
_a575.ev.SPAWN = {
CoinJar    = { rem = "CoinJar_Spawn",           key = "coin jar",
order = { "basic", "giant", "magic" } },
Comet      = { rem = "Comet_Spawn",             key = "comet" },
Pinata     = { rem = "MiniPinata_Consume",      key = "pinata" },
LuckyBlock = { rem = "MiniLuckyBlock_Consume",  key = "lucky block" },
}
function _a575.move.inDottedBox()
if _a573.Map and rawget(_a573.Map, "IsInDottedBox") then
local _a1154, _a1155 = pcall(_a573.Map.IsInDottedBox)
if _a1154 then return _a1155 and true or false end
end
return nil
end
function _a575.ev.spawnItems(_a1156)
local _a1157 = _a575.ev.SPAWN[_a1156]
if not _a1157 then return {} end
local _a1158 = {}
for _a1159, _a1160 in ipairs({ "Misc", "Consumable", "Lootbox" }) do
for _a1161, _a1162 in ipairs(_a575.item.stacks(_a1160)) do
local _a1163 = _a1162.id:lower()
if _a1163:find(_a1157.key, 1, true) then
local _a1164 = 99
if _a1157.order then
for _a1165, _a1166 in ipairs(_a1157.order) do
if _a1163:find(_a1166, 1, true) then _a1164 = _a1165 break end
end
end
_a1162.rank = _a1164
_a1158[#_a1158 + 1] = _a1162
end
end
end
table.sort(_a1158, function(_a1167, _a1168)
if _a1167.rank ~= _a1168.rank then return _a1167.rank < _a1168.rank end
return _a1167.tier < _a1168.tier
end)
return _a1158
end
function _a575.ev.spawnEvent(_a1169)
local _a1170 = _a575.ev.SPAWN[_a1169]
if not _a1170 then return 0, "소환 불가 종류" end
local _a1171 = _a566:FindFirstChild(_a1170.rem)
if not _a1171 then return 0, _a1170.rem .. " 리모트 없음" end
local _a1172 = _a575.ev.spawnItems(_a1169)
if #_a1172 == 0 then return 0, _a1169 .. " 아이템 없음" end
local _a1173 = _a575.move.inDottedBox()
if _a1173 == false then return 0, "점선 네모 안이 아님" end
local _a1174, _a1175 = 0, nil
for _a1176, _a1177 in ipairs(_a1172) do
if _a1174 >= (_a568.SpawnPerCycle or 1) or not _a569.quest then break end
local _a1178, _a1179
pcall(function() _a1178, _a1179 = _a1171:InvokeServer(_a1177.uid) end)
if _a1178 then
_a1174 += 1
_a575.ctl.setAct("소환", _a1169 .. " · " .. _a1177.id)
_a562(("  🎁 %s 소환  (%s)"):format(_a1169, _a1177.id))
task.wait(0.4)
else
_a1175 = _a1179
break
end
end
return _a1174, _a1175
end
function _a575.ev.findEvent(_a1180, _a1181)
local _a1182 = _a1181 and _a575.move.bestZone() or nil
local _a1183
for _a1184, _a1185 in ipairs(_a575.ev.events()) do
if _a1185.kind == _a1180 and _a1185.left > 15 then
if not _a1181 or _a1185.zone == _a1182 then
if not _a1183 or (_a1185.zone == _a575.move.curZone() and _a1183.zone ~= _a575.move.curZone()) then
_a1183 = _a1185
end
end
end
end
return _a1183
end
function _a575.ev.findChest(_a1186, _a1187)
local _a1188 = workspace:FindFirstChild("__THINGS")
if not _a1188 then return nil end
local _a1189 = tostring(_a1186):lower():find("superior") ~= nil
local _a1190 = _a575.move.hrp()
local _a1191 = _a1190 and _a1190.Position
local _a1192, _a1193, _a1194, _a1195
for _a1196, _a1197 in ipairs(_a1188:GetChildren()) do
if tostring(_a1197.Name):lower():find("chest", 1, true) then
for _a1198, _a1199 in ipairs(_a1197:GetChildren()) do
local _a1200
if _a1199:IsA("BasePart") then _a1200 = _a1199.Position
elseif _a1199:IsA("Model") then
local _a1201, _a1202 = pcall(function() return _a1199:GetPivot() end)
if _a1201 and typeof(_a1202) == "CFrame" then _a1200 = _a1202.Position end
end
if _a1200 then
local _a1203 = _a1191 and (_a1200 - _a1191).Magnitude or 0
local _a1204 = (tostring(_a1199.Name) .. tostring(_a1197.Name)):lower()
:find("superior", 1, true) ~= nil
if not _a1195 or _a1203 < _a1195 then _a1194, _a1195 = _a1200, _a1203 end
if _a1204 == _a1189 and (not _a1193 or _a1203 < _a1193) then
_a1192, _a1193 = _a1200, _a1203
end
end
end
end
end
if _a1192 then return _a1192, _a1193 end
return _a1194, _a1195
end
_a575.quest.SKIP = { [4] = true, [5] = true, [40] = true, [41] = true }
_a575.quest.WHERE = {
[21]="bestzone", [9]="bestzone", [37]="bestzone", [38]="bestzone", [39]="bestzone",
[43]="bestzone", [44]="bestzone", [76]="bestzone", [30]="bestzone", [8]="bestzone",
[20]="bestegg",  [42]="bestegg",
[1]="breakable", [81]="zoneid",
}
function _a575.item.petStacks()
local _a1205 = _a602()
local _a1206 = _a1205 and rawget(_a1205, "Inventory")
local _a1207 = _a1206 and rawget(_a1206, "Pet")
local _a1208 = {}
if type(_a1207) ~= "table" then return _a1208 end
for _a1209, _a1210 in pairs(_a1207) do
if type(_a1210) == "table" then
_a1208[#_a1208 + 1] = {
uid = _a1209,
id = tostring(rawget(_a1210, "id")),
pt = tonumber(rawget(_a1210, "pt")) or 0,
am = tonumber(rawget(_a1210, "_am")) or 1,
}
end
end
return _a1208
end
function _a575.item.bestEggPets()
local _a1211 = _a643()
local _a1212 = _a1211 and _a573.DirEggs and rawget(_a573.DirEggs, _a1211)
local _a1213 = _a1212 and rawget(_a1212, "pets")
local _a1214 = {}
if type(_a1213) == "table" then
for _a1215, _a1216 in pairs(_a1213) do
local _a1217 = type(_a1216) == "table" and _a1216[1] or _a1216
if _a1217 then _a1214[tostring(_a1217)] = true end
end
end
return _a1214, _a1211
end
function _a575.item.makeVariant(_a1218, _a1219)
local _a1220 = (_a1218 == "gold") and _a573.R_Gold or _a573.R_Rain
if not _a1220 then return 0, (_a1218 .. " 머신 리모트 없음") end
local _a1221 = (_a1218 == "gold") and 0 or 1
local _a1222
if _a1219 then
local _a1223, _a1224 = _a575.item.bestEggPets()
if not next(_a1223) then return 0, "최고 알(" .. tostring(_a1224) .. ") 펫 목록을 못 읽음" end
_a1222 = _a1223
end
local _a1225, _a1226 = 0, nil
for _a1227, _a1228 in ipairs(_a575.item.petStacks()) do
if not _a569.quest then break end
if _a1228.pt == _a1221 and _a1228.am >= 10 and (not _a1222 or _a1222[_a1228.id]) then
local _a1229 = math.floor(_a1228.am / 10)
if _a1229 > 0 then
local _a1230, _a1231
pcall(function() _a1230, _a1231 = _a1220:InvokeServer(_a1228.uid, _a1229) end)
if _a1230 then
_a1225 += _a1229
_a562(("  ✨ %s 제작  %s x%d"):format(
_a1218 == "gold" and "골드" or "레인보우", _a1228.id, _a1229))
task.wait(0.4)
else
_a1226 = _a1231
end
end
end
end
return _a1225, _a1226
end
function _a575.item.useFlag(_a1232)
if not _a573.R_Flag then return 0, "FlexibleFlags_Consume 리모트 없음" end
local _a1233, _a1234 = 0, nil
for _a1235, _a1236 in ipairs(_a575.item.stacks("Misc")) do
if _a1233 >= (_a1232 or 1) then break end
if _a1236.id:lower():find("flag", 1, true) and _a1236.am >= 1 and _a575.item.itemAllowed(_a1236.id) then
local _a1237, _a1238
pcall(function() _a1237, _a1238 = _a573.R_Flag:InvokeServer(_a1236.id, _a1236.uid, 1) end)
if _a1237 then _a1233 += 1 task.wait(0.4) else _a1234 = _a1238 end
end
end
return _a1233, _a1234
end
function _a575.item.useFruit(_a1239)
if not _a573.R_Fruit then return 0, "Fruits: Consume 리모트 없음" end
local _a1240 = _a575.item.activeBuffs("Fruits")
local _a1241 = 0
for _a1242, _a1243 in ipairs(_a575.item.stacks("Fruit")) do
if _a1241 >= (_a1239 or 1) then break end
if _a1243.am >= 1 and _a575.item.itemAllowed(_a1243.id) and not _a1240[_a1243.id] then
pcall(function() _a573.R_Fruit:FireServer(_a1243.uid, 1) end)
_a1241 += 1
task.wait(0.4)
end
end
return _a1241
end
function _a575.quest.status()
local _a1244 = _a602()
if not _a1244 then return nil end
local _a1245 = rawget(_a1244, "Goals")
if type(_a1245) ~= "table" then return { list = {} } end
local _a1246 = {}
for _a1247, _a1248 in pairs(_a1245) do
if type(_a1248) == "table" then
local _a1249 = tonumber(rawget(_a1248, "Type")) or -1
local _a1250
if _a573.Quest and rawget(_a573.Quest, "MakeTitle") then
local _a1251, _a1252 = pcall(_a573.Quest.MakeTitle, _a1248)
if _a1251 then _a1250 = _a1252 end
end
_a1246[#_a1246 + 1] = {
slot = _a1247,
uid = tostring(rawget(_a1248, "UID")),
type = _a1249,
how = _a574[_a1249],
title = _a1250 or ("Type " .. _a1249),
amount = tonumber(rawget(_a1248, "Amount")) or 0,
progress = tonumber(rawget(_a1248, "Progress")) or 0,
stars = tonumber(rawget(_a1248, "Stars")) or 0,
potionTier = tonumber(rawget(_a1248, "PotionTier")),
enchantTier = tonumber(rawget(_a1248, "EnchantTier")),
breakable = rawget(_a1248, "BreakableType") or rawget(_a1248, "BreakableDirID"),
zoneId = rawget(_a1248, "ZoneID"),
where = _a575.quest.WHERE[_a1249] or (_a574[_a1249] == "farm" and "bestzone" or nil),
event = _a575.ev.EVENTKIND[_a1249],
chest = _a575.ev.CHESTKIND[_a1249],
bestOnly = _a575.ev.BESTONLY[_a1249] or false,
ignored = _a575.quest.IGNORE[_a1249],
}
end
end
table.sort(_a1246, function(_a1253, _a1254) return _a1253.stars > _a1254.stars end)
return { list = _a1246, rank = tonumber(rawget(_a1244, "Rank")) or 1,
rankStars = tonumber(rawget(_a1244, "RankStars")) or 0 }
end
_a575.quest.BESTDEP = {
[20]=true, [21]=true, [37]=true, [38]=true, [39]=true,
[43]=true, [44]=true, [76]=true,
}
function _a575.quest.bestDepActive()
local _a1255 = _a575.ctl.lockGoal and _a575.ctl.lockGoal.q
if not _a1255 then return false end
if _a575.quest.IGNORE[_a1255.type] then return false end
if not _a575.quest.BESTDEP[_a1255.type] then return false end
local _a1256 = _a575.quest.findQuest(_a1255.uid)
if not _a1256 or _a1256.progress >= _a1256.amount then return false end
return true, _a1256
end
function _a575.quest.canDo(_a1257, _a1258)
if _a1257.how == "hatch" or _a1257.where == "bestegg" then
local _a1259 = _a668()
if not _a1259 then return false, "알 정보를 못 읽음" end
if not _a1259.price then return true end
if not _a1258 then
if _a1259.canBuy < 1 then
return false, ("돈 부족 — %s 개당 %s %s / 보유 %s"):format(
tostring(_a1259.id), _a563(_a1259.price, 0), tostring(_a1259.currency), _a563(_a1259.have, 0))
end
return true
end
local _a1260 = math.max(1, (_a1257.amount or 1) - (_a1257.progress or 0))
local _a1261 = _a1260
if _a1257.type == 2 or _a1257.type == 42 or _a1257.type == 47 then
_a1261 = math.max(_a1260, _a568.HatchMinAfford or 10)
end
if _a1259.canBuy < _a1261 then
_a575.quest.moneyUntil = os.clock() + math.max(0, _a568.MoneyDwell or 60)
return false, ("돈 모으는 중 — %d개분 필요 / 지금 %d개분 (개당 %s %s)"):format(
_a1261, _a1259.canBuy, _a563(_a1259.price, 0), tostring(_a1259.currency))
end
if _a575.quest.moneyUntil and os.clock() < _a575.quest.moneyUntil then
return false, ("조금 더 벌고 감 (%.0f초 남음)"):format(_a575.quest.moneyUntil - os.clock())
end
_a575.quest.moneyUntil = nil
end
return true
end
function _a575.quest.findQuest(_a1262)
local _a1263 = _a575.quest.status()
for _a1264, _a1265 in ipairs(_a1263 and _a1263.list or {}) do
if _a1265.uid == _a1262 then return _a1265 end
end
return nil
end
function _a575.quest.pursue(_a1266)
local _a1267, _a1268
if _a1266.how == "hatch" then _a1267, _a1268 = _a679, "mhatch"
elseif _a1266.how == "zone" then _a1267, _a1268 = _a638, "zone"
elseif _a1266.how == "gold" or _a1266.how == "rainbow" then
local _a1269 = (_a1266.type == 40 or _a1266.type == 41)
_a1268 = "quest"
_a1267 = function()
local _a1270 = _a575.item.makeVariant("gold", _a1269) or 0
if _a1266.how == "rainbow" then
_a1270 += (_a575.item.makeVariant("rainbow", _a1269) or 0)
end
if _a1270 > 0 then
_a575.ctl.setAct(_a1266.how == "gold" and "골드 합성" or "레인보우 합성", _a1270 .. "마리")
return
end
_a575.ctl.setAct("재료 모으는 중", "최고 알 부화")
local _a1271 = _a569.mhatch
_a569.mhatch = true
pcall(_a679)
_a569.mhatch = _a1271
end
end
local _a1272 = _a1266.progress
local _a1273 = os.clock()
_a575.ctl.setGoal(_a1266.title, ("%d/%d"):format(_a1266.progress, _a1266.amount))
local function _a1274()
if not _a1266.event then return end
local _a1275 = _a575.ev.findEvent(_a1266.event, _a1266.bestOnly)
if _a1275 then
_a575.ctl.setAct(_a1266.event .. " 진행 중", ("%d초 남음"):format(_a1275.left))
if _a1275.pos then
local _a1276 = _a575.move.hrp()
if _a1276 and (_a1276.Position - _a1275.pos).Magnitude > (_a568.EventStayDist or 45) then
_a575.move.glideTo(_a1275.pos)
end
end
return
end
local _a1277, _a1278 = _a575.ev.spawnEvent(_a1266.event)
if _a1277 > 0 then
_a575.ctl.setAct("소환", _a1266.event)
task.wait(0.5)
elseif _a1278 and _a575.ev.spawnErr ~= tostring(_a1278) then
_a575.ev.spawnErr = tostring(_a1278)
_a562("[퀘스트] " .. _a1266.event .. " 소환 실패: " .. tostring(_a1278))
end
end
local _a1279, _a1280 = pcall(function()
while _a569.quest and not _a575.ctl.stopped() do
local _a1281, _a1282 = _a575.quest.canDo(_a1266, false)
if not _a1281 then
_a562(("[퀘스트] %s → 다른 퀘스트 먼저 (%s)"):format(tostring(_a1266.title), tostring(_a1282)))
return
end
_a1274()
if _a1267 then
local _a1283 = _a569[_a1268]
_a569[_a1268] = true
local _a1284, _a1285 = pcall(_a1267)
_a569[_a1268] = _a1283
if not _a1284 then error(_a1285, 0) end
elseif _a1266.event then
task.wait(0.4)
else
task.wait(2)
end
local _a1286 = _a575.quest.findQuest(_a1266.uid)
if not _a1286 then
_a562("[퀘스트] 완료 — " .. tostring(_a1266.title))
return
end
_a575.ctl.setGoal(_a1286.title, ("%d/%d"):format(_a1286.progress, _a1286.amount))
if _a1286.progress >= _a1286.amount then
_a562(("[퀘스트] 달성 %d/%d — %s"):format(_a1286.progress, _a1286.amount, tostring(_a1286.title)))
return
end
if _a1286.progress > _a1272 then
_a1273 = os.clock()
_a562(("[퀘스트] %d/%d  %s"):format(_a1286.progress, _a1286.amount, tostring(_a1286.title)))
end
_a1272 = _a1286.progress
local _a1287 = os.clock() - _a1273
if _a1287 >= math.max(10, _a568.PursueStallSec or 60) then
_a562(("[퀘스트] %.0f초째 진행 없음 (%d/%d) — 다음 단계로: %s"):format(
_a1287, _a1286.progress, _a1286.amount, tostring(_a1286.title)))
return
end
task.wait(0.2)
end
end)
if not _a1279 then _a562("[퀘스트] " .. tostring(_a1266.how) .. " 오류: " .. tostring(_a1280)) end
_a575.ctl.lockGoal = nil
_a575.ctl.setGoal(nil)
end
function _a575.quest.cycle()
do
local _a1288 = _a569.rank
_a569.rank = true
pcall(_a729)
_a569.rank = _a1288
end
local _a1289 = _a575.quest.status()
if not _a1289 then return end
local _a1290, _a1291, _a1292 = false, false, false
local _a1293 = {}
local _a1294 = nil
for _a1295, _a1296 in ipairs(_a1289.list) do
if not _a569.quest then break end
local _a1297, _a1298 = true, nil
if not _a1296.ignored and _a1296.progress < _a1296.amount then
_a1297, _a1298 = _a575.quest.canDo(_a1296, true)
end
if _a1296.ignored then
if _a1296.progress < _a1296.amount then
_a1293[#_a1293 + 1] = tostring(_a1296.title) .. "  — " .. _a1296.ignored
end
elseif not _a1297 then
local _a1299 = tostring(_a1296.uid) .. tostring(_a1298)
if _a575.item.skipSaid ~= _a1299 then
_a575.item.skipSaid = _a1299
_a562(("[퀘스트] 건너뜀: %s   (%s)"):format(tostring(_a1296.title), tostring(_a1298)))
end
elseif _a1296.progress < _a1296.amount then
local _a1300 = _a1296.where
if _a1296.event then
if not _a1294 or _a1294.rank > 0 then _a1294 = { rank = 0, kind = "event", q = _a1296 } end
elseif _a1296.chest then
if not _a1294 or _a1294.rank > 1 then _a1294 = { rank = 1, kind = "chest", q = _a1296 } end
elseif _a1300 == "bestegg" then
if not _a1294 or _a1294.rank > 1 then _a1294 = { rank = 1, kind = "egg", q = _a1296 } end
elseif _a1300 == "breakable" and _a1296.breakable then
if not _a1294 or _a1294.rank > 2 then _a1294 = { rank = 2, kind = "breakable", q = _a1296 } end
elseif _a1300 == "zoneid" and _a1296.zoneId then
if not _a1294 or _a1294.rank > 2 then _a1294 = { rank = 2, kind = "zoneid", q = _a1296 } end
elseif _a1300 == "bestzone" or _a1300 == "breakable" then
if not _a1294 then _a1294 = { rank = 3, kind = "bestzone", q = _a1296 } end
end
if _a1296.how == "farm" then
_a1290 = true
elseif _a1296.how == "hatch" then
_a1291 = true
elseif _a1296.how == "zone" then
_a1292 = true
elseif _a1296.how == "potup" and _a568.QuestUpgrade then
local _a1301, _a1302 = _a575.item.upgradeTo("Potion", _a1296.potionTier or 2)
if _a1301 > 0 then
_a570.potup += _a1301
_a570.quest += 1
_a562(("[퀘스트] 포션 T%d %d개 제작  (%s)"):format(_a1296.potionTier or 2, _a1301, _a1296.title))
elseif _a1302 and not tostring(_a1302):find("부족") then
if _a575.item.potUpSaid ~= tostring(_a1302) then
_a575.item.potUpSaid = tostring(_a1302)
_a562("[퀘스트] 포션 업글 실패: " .. tostring(_a1302))
end
end
elseif _a1296.how == "encup" and _a568.QuestUpgrade then
local _a1303, _a1304 = _a575.item.upgradeTo("Enchant", _a1296.enchantTier or 2)
if _a1303 > 0 then
_a570.potup += _a1303
_a570.quest += 1
_a562(("[퀘스트] 인챈트 T%d %d개 제작  (%s)"):format(_a1296.enchantTier or 2, _a1303, _a1296.title))
elseif _a1304 and not tostring(_a1304):find("부족") then
if _a575.item.encUpSaid ~= tostring(_a1304) then
_a575.item.encUpSaid = tostring(_a1304)
_a562("[퀘스트] 인챈트 업글 실패: " .. tostring(_a1304))
end
end
elseif _a1296.how == "potuse" and _a568.QuestUsePotion then
_a575.item.lastUse = _a575.item.lastUse or {}
local _a1305 = _a575.item.lastUse[_a1296.uid]
if _a1305 and _a1305.used > 0 and _a1296.progress <= _a1305.progress then
if not _a1305.gaveUp then
_a1305.gaveUp = true
_a562("[퀘스트] 포션을 마셔도 진행도가 안 올라서 중단: " .. tostring(_a1296.title))
end
else
local _a1306 = math.min(_a568.QuestUseMax, math.max(1, _a1296.amount - _a1296.progress))
local _a1307, _a1308 = _a575.item.usePotion(_a1296.potionTier or 1, _a1306)
_a575.item.lastUse[_a1296.uid] = { used = _a1307, progress = _a1296.progress }
if _a1307 > 0 then
_a570.potuse += _a1307
_a570.quest += 1
_a562(("[퀘스트] 포션 %d개 사용  (%s)"):format(_a1307, _a1296.title))
elseif _a1308 and not tostring(_a1308):find("없음") then
_a562("[퀘스트] 포션 사용 실패: " .. tostring(_a1308))
end
end
elseif _a1296.how == "gold" or _a1296.how == "rainbow" then
local _a1309, _a1310 = _a575.item.makeVariant(_a1296.how, _a1296.type == 40 or _a1296.type == 41)
if _a1309 > 0 then
_a570.quest += 1
_a562(("[퀘스트] %s 펫 %d마리 제작  (%s)"):format(
_a1296.how == "gold" and "골드" or "레인보우", _a1309, _a1296.title))
elseif _a1310 then
_a562("[퀘스트] " .. _a1296.how .. " 실패: " .. tostring(_a1310))
end
elseif _a1296.how == "fruituse" then
local _a1311 = _a575.item.useFruit(math.max(1, _a1296.amount - _a1296.progress))
if _a1311 > 0 then
_a570.quest += 1
_a562(("[퀘스트] 과일 %d개 사용  (%s)"):format(_a1311, _a1296.title))
end
elseif _a1296.how == "flaguse" then
local _a1312, _a1313 = _a575.item.useFlag(math.max(1, _a1296.amount - _a1296.progress))
if _a1312 > 0 then
_a570.quest += 1
_a562(("[퀘스트] 깃발 %d개 사용  (%s)"):format(_a1312, _a1296.title))
elseif _a1313 then
_a562("[퀘스트] 깃발 실패: " .. tostring(_a1313))
end
elseif not _a1296.how then
_a1293[#_a1293 + 1] = _a1296.title
end
end
end
if _a568.QuestLock and _a575.ctl.lockGoal then
local _a1314
for _a1315, _a1316 in ipairs(_a1289.list) do
if _a1316.uid == _a575.ctl.lockGoal.q.uid and _a1316.progress < _a1316.amount then _a1314 = _a1316 break end
end
if _a1314 then
_a575.ctl.lockGoal.q = _a1314
_a1294 = _a575.ctl.lockGoal
else
if _a575.ctl.lockGoal.q then
_a562("[퀘스트] 완료/교체됨 → 다음 목표로: " .. tostring(_a575.ctl.lockGoal.q.title))
end
_a575.ctl.lockGoal = nil
end
end
if _a568.QuestLock and _a1294 then _a575.ctl.lockGoal = _a1294 end
if _a568.QuestTp and _a1294 and _a569.quest then
local _a1317, _a1318, _a1319
if _a1294.kind == "event" then
local _a1320 = _a575.ev.findEvent(_a1294.q.event, _a1294.q.bestOnly)
if _a1320 then
_a1319 = ("%s @%s (%d초 남음)"):format(_a1320.name, tostring(_a1320.zone), _a1320.left)
if _a1320.pos then _a1317, _a1318 = _a575.move.glideTo(_a1320.pos)
else _a1317, _a1318 = _a575.move.goToZone(_a1320.zone) end
else
local _a1321 = _a1294.q.bestOnly and _a575.move.bestZone() or (_a575.move.curZone() or _a575.move.bestZone())
_a1319 = _a1294.q.event .. " 소환용 " .. tostring(_a1321)
local _a1322 = _a575.move.inDottedBox()
_a1317, _a1318 = _a575.move.goToZone(_a1321, false, _a1322 == false, _a1294.q.bestOnly)
if _a1317 then
local _a1323, _a1324 = _a575.ev.spawnEvent(_a1294.q.event)
if _a1323 < 1 and tostring(_a1324):find("점선") then
_a575.move.goToZone(_a1321, false, true)
task.wait(0.2)
_a1323, _a1324 = _a575.ev.spawnEvent(_a1294.q.event)
end
if _a1323 > 0 then
_a1319 = ("%s %d개 소환 @%s"):format(_a1294.q.event, _a1323, tostring(_a1321))
else
_a1318 = _a1324
_a1317 = false
end
end
end
elseif _a1294.kind == "chest" then
local _a1325 = _a1294.q.bestOnly and _a575.move.bestZone() or _a575.move.curZone()
local _a1326, _a1327 = _a575.ev.findChest(_a1294.q.chest, _a1325)
_a1319 = _a1294.q.chest .. " @" .. tostring(_a1325)
if _a1326 then
if not _a1327 or _a1327 > 20 then _a575.move.glideTo(_a1326) end
_a1317 = true
else
_a1317, _a1318 = _a575.move.goToZone(_a1325)
_a1319 = _a1319 .. " (상자 없음 → 존 가운데)"
end
elseif _a1294.kind == "egg" then
local _a1328 = _a643()
_a1319 = "최고 알 " .. tostring(_a1328)
if _a1328 then _a1317, _a1318 = _a575.egg.tpEgg(_a1328) else _a1318 = "최고 알을 못 찾음" end
elseif _a1294.kind == "breakable" then
local _a1329 = _a575.move.zoneForBreakable(_a1294.q.breakable)
_a1319 = tostring(_a1294.q.breakable) .. " 나오는 존 " .. tostring(_a1329)
if _a1329 then _a1317, _a1318 = _a575.move.goToZone(_a1329, true) else _a1318 = "그 브레이커블이 나오는 존이 없음" end
elseif _a1294.kind == "zoneid" then
_a1319 = "존 " .. tostring(_a1294.q.zoneId)
_a1317, _a1318 = _a575.move.goToZone(_a1294.q.zoneId)
else
local _a1330 = _a575.move.bestZone()
local _a1331 = _a1294.q.bestOnly or _a575.quest.BESTDEP[_a1294.q.type] or false
if _a1330 then _a1317, _a1318 = _a575.move.goToZone(_a1330, true, false, _a1331)
else _a1318 = "최고 존을 못 찾음" end
_a1319 = "최고 존 " .. tostring(_a575.move.arrivedZone or _a1330)
if not _a1317 then _a1318 = _a1330 end
end
if _a1317 then
if _a575.quest.lastGoal ~= _a1319 then
_a575.quest.lastGoal = _a1319
_a562("[퀘스트] " .. _a1319 .. " 으로 이동  (" .. tostring(_a1294.q.title) .. ")")
end
_a575.quest.pursue(_a1294.q)
else
local _a1332 = _a1318 and tostring(_a1318) or "이유 불명"
if _a575.quest.lastFail ~= _a1332 then
_a575.quest.lastFail = _a1332
_a562(("[퀘스트] 진행 못 함: %s   (%s / %s)"):format(
_a1332, tostring(_a1294.kind), tostring(_a1294.q.title)))
_a562(("           현재 존 %s / 최고 존 %s / 점선네모 %s"):format(
tostring(_a575.move.curZone()), tostring(_a575.move.bestZone()), tostring(_a575.move.inDottedBox())))
end
end
end
if _a568.QuestDrive and _a575.auto.turnOn then
if _a1290  then _a575.auto.turnOn("farm",   "파밍 퀘스트 → 자동 파밍") end
if _a1292  then _a575.auto.turnOn("zone",   "존 퀘스트 → 자동 존 해금") end
if _a1291 then _a575.auto.turnOn("mhatch", "부화 퀘스트 → 자동 부화") end
end
if #_a1293 > 0 and not _a575.quest.manualWarned then
_a575.quest.manualWarned = true
_a562("[퀘스트] 수동으로 해야 하는 것:")
for _a1333, _a1334 in ipairs(_a1293) do _a562("    · " .. tostring(_a1334)) end
elseif #_a1293 == 0 then
_a575.quest.manualWarned = false
end
return _a1294 ~= nil
end
local function _a1335(_a1336)
local _a1337 = {}
for _a1338 in tostring(_a1336 or ""):gmatch("[^,]+") do
_a1338 = _a1338:match("^%s*(.-)%s*$")
if _a1338 ~= "" then _a1337[#_a1337 + 1] = _a1338:lower() end
end
return _a1337
end
function _a575.item.itemAllowed(_a1339)
local _a1340 = tostring(_a1339):lower()
for _a1341, _a1342 in ipairs(_a1335(_a568.ItemBlock)) do
if _a1340:find(_a1342, 1, true) then return false end
end
local _a1343 = _a1335(_a568.ItemAllow)
if #_a1343 == 0 then return true end
for _a1344, _a1345 in ipairs(_a1343) do
if _a1340:find(_a1345, 1, true) then return true end
end
return false
end
function _a575.item.activeBuffs(_a1346)
local _a1347 = _a602()
local _a1348 = _a1347 and rawget(_a1347, _a1346)
local _a1349 = {}
if type(_a1348) == "table" then
for _a1350, _a1351 in pairs(_a1348) do
if type(_a1351) == "table" and next(_a1351) then _a1349[_a1350] = true
elseif _a1351 then _a1349[_a1350] = true end
end
end
return _a1349
end
local function _a1352(_a1353, _a1354, _a1355, _a1356)
local _a1357 = _a575.item.activeBuffs(_a1354)
local _a1358 = {}
local _a1359 = { total = 0, act = 0, blocked = 0, few = 0, ok = 0 }
for _a1360, _a1361 in ipairs(_a575.item.stacks(_a1353)) do
_a1359.total += 1
if _a1357[_a1361.id] then _a1359.act += 1
elseif not _a575.item.itemAllowed(_a1361.id) then _a1359.blocked += 1
elseif _a1361.am <= _a568.ItemKeep then _a1359.few += 1
else
_a1359.ok += 1
local _a1362 = _a1358[_a1361.id]
local _a1363
if not _a1362 then _a1363 = true
elseif _a568.BuffHighTier then _a1363 = _a1361.tier > _a1362.tier
else _a1363 = _a1361.tier < _a1362.tier end
if _a1363 then _a1358[_a1361.id] = _a1361 end
end
end
if _a1359.ok == 0 and _a1359.total > 0 then
local _a1364 = ("%s %d종 중 사용 가능 0 (이미걸림 %d / 제외 %d / 재고부족 %d)")
:format(_a1353, _a1359.total, _a1359.act, _a1359.blocked, _a1359.few)
if _a575.item.buffSaid ~= _a1364 then
_a575.item.buffSaid = _a1364
_a562("[아이템] " .. _a1364)
end
elseif _a1359.ok > 0 then
_a575.item.buffSaid = nil
end
local _a1365 = {}
for _a1366, _a1367 in pairs(_a1358) do _a1365[#_a1365 + 1] = _a1367 end
table.sort(_a1365, function(_a1368, _a1369)
if _a1368.tier ~= _a1369.tier then return _a1368.tier > _a1369.tier end
return _a1368.am > _a1369.am
end)
local _a1370 = {}
for _a1371, _a1372 in ipairs(_a1365) do
if not _a569.items then break end
if _a1356 and _a1356.left <= 0 then break end
local _a1373 = pcall(function() _a1355(_a1372.uid, 1) end)
if _a1373 then
_a1370[#_a1370 + 1] = ("%s T%d"):format(_a1372.id, _a1372.tier)
_a570.items += 1
if _a1356 then _a1356.left -= 1 end
task.wait(0.12)
end
end
return _a1370
end
function _a575.item.cycleItems()
local function _a1374()
local _a1375 = {}
if _a568.BuffPotion then _a1375[#_a1375 + 1] = { "Potion", "Potions" } end
if _a568.BuffFruit then _a1375[#_a1375 + 1] = { "Fruit", "Fruits" } end
if _a568.BuffConsumable then _a1375[#_a1375 + 1] = { "Consumable", "Consumables" } end
for _a1376, _a1377 in ipairs(_a1375) do
local _a1378 = _a575.item.activeBuffs(_a1377[2])
for _a1379, _a1380 in ipairs(_a575.item.stacks(_a1377[1])) do
if _a1380.am > _a568.ItemKeep and _a575.item.itemAllowed(_a1380.id) and not _a1378[_a1380.id] then
return true
end
end
end
if _a568.BuffUltimate and _a573.R_Ult then
local _a1381 = _a602()
local _a1382 = _a1381 and rawget(_a1381, "Ultimates")
if type(_a1382) == "table" then
for _a1383 in pairs(_a1382) do
if _a575.item.itemAllowed(_a1383) then
if not (_a573.Ult and rawget(_a573.Ult, "IsCharged")) then return true end
local _a1384, _a1385 = pcall(_a573.Ult.IsCharged, _a1383)
if _a1384 and _a1385 then return true end
end
end
end
end
return false
end
if not _a1374() then return end
if _a568.ItemBestZone then
local _a1386 = _a575.move.bestZone()
if _a1386 and _a575.move.curZone() ~= _a1386 then
if not _a568.ItemTp then
if not _a575.item.itemZoneWarned then
_a575.item.itemZoneWarned = true
_a562(("[아이템] 최고 존(%s)이 아니라 대기 — 현재 %s"):format(
tostring(_a1386), tostring(_a575.move.curZone())))
end
return
end
local _a1387, _a1388 = _a575.move.goToZone(_a1386)
if not _a1387 then
_a562("[아이템] 최고 존 이동 실패: " .. tostring(_a1388))
return
end
_a562("[아이템] 최고 존 " .. tostring(_a1386) .. " 에서 사용")
end
_a575.item.itemZoneWarned = false
end
local _a1389 = {}
local _a1390  = { left = math.max(1, _a568.BuffMaxPotion or 5) }
local _a1391 = { left = math.max(1, _a568.BuffMaxOther or 2) }
if _a568.BuffPotion and _a573.R_PotUse then
local _a1392 = _a1352("Potion", "Potions", function(_a1393, _a1394)
_a573.R_PotUse:FireServer(_a1393, _a1394)
end, _a1390)
for _a1395, _a1396 in ipairs(_a1392) do _a1389[#_a1389 + 1] = "포션 " .. _a1396 end
end
if _a568.BuffFruit and _a573.R_Fruit then
local _a1397 = _a1352("Fruit", "Fruits", function(_a1398, _a1399)
_a573.R_Fruit:FireServer(_a1398, _a1399)
end, _a1391)
for _a1400, _a1401 in ipairs(_a1397) do _a1389[#_a1389 + 1] = "과일 " .. _a1401 end
end
if _a568.BuffConsumable and _a573.R_Cons then
local _a1402 = _a1352("Consumable", "Consumables", function(_a1403, _a1404)
_a573.R_Cons:InvokeServer(_a1403, _a1404)
end, _a1391)
for _a1405, _a1406 in ipairs(_a1402) do _a1389[#_a1389 + 1] = "소모품 " .. _a1406 end
end
if _a568.BuffUltimate and _a573.R_Ult then
local _a1407 = _a602()
local _a1408 = _a1407 and rawget(_a1407, "Ultimates")
if type(_a1408) == "table" then
for _a1409 in pairs(_a1408) do
if not _a569.items then break end
if _a575.item.itemAllowed(_a1409) then
local _a1410 = true
if _a573.Ult and rawget(_a573.Ult, "IsCharged") then
local _a1411, _a1412 = pcall(_a573.Ult.IsCharged, _a1409)
_a1410 = _a1411 and _a1412 and true or false
end
if _a1410 then
local _a1413
pcall(function() _a1413 = _a573.R_Ult:InvokeServer(_a1409) end)
if _a1413 then
_a1389[#_a1389 + 1] = "얼티밋 " .. tostring(_a1409)
_a570.items += 1
task.wait(0.3)
end
end
end
end
end
end
if #_a1389 > 0 then
_a575.ctl.setAct("버프 사용", table.concat(_a1389, ", "))
_a562("[아이템] " .. table.concat(_a1389, ", ") .. " 사용")
end
end
function _a575.mach.slotStatus()
local _a1414 = _a602()
if not _a1414 then return nil end
local _a1415 = tonumber(rawget(_a1414, "PetSlotsPurchased")) or 0
local _a1416 = tonumber(rawget(_a1414, "EggSlotsPurchased")) or 0
local _a1417, _a1418 = 0, 0
if _a573.RankC then
if rawget(_a573.RankC, "GetMaxPurchasableEquipSlots") then
local _a1419, _a1420 = pcall(_a573.RankC.GetMaxPurchasableEquipSlots)
if _a1419 and tonumber(_a1420) then _a1417 = tonumber(_a1420) end
end
if rawget(_a573.RankC, "GetMaxPurchasableEggSlots") then
local _a1421, _a1422 = pcall(_a573.RankC.GetMaxPurchasableEggSlots)
if _a1421 and tonumber(_a1422) then _a1418 = tonumber(_a1422) end
end
end
local _a1423, _a1424
if _a1415 < _a1417 then
_a1423 = _a1415 + 1
if type(_a573.CalcPetS) == "function" then
local _a1425, _a1426 = pcall(_a573.CalcPetS, _a1423)
if _a1425 then _a1424 = tonumber(_a1426) end
end
end
local _a1427, _a1428, _a1429
if _a1416 < _a1418 and _a573.RankC and rawget(_a573.RankC, "GetEggBundle") then
local _a1430, _a1431, _a1432 = pcall(_a573.RankC.GetEggBundle, _a1416 + 1)
if _a1430 and tonumber(_a1431) then
_a1427, _a1428 = tonumber(_a1431), tonumber(_a1432) or 1
if type(_a573.CalcEggS) == "function" then
local _a1433, _a1434 = 0, false
for _a1435 = _a1427 - _a1428 + 1, _a1427 do
local _a1436, _a1437 = pcall(_a573.CalcEggS, _a1435)
if _a1436 and tonumber(_a1437) then _a1433 += tonumber(_a1437) else _a1434 = true end
end
if not _a1434 then _a1429 = _a1433 end
end
end
end
local _a1438
if _a573.Egg and rawget(_a573.Egg, "GetMaxHatch") then
local _a1439, _a1440 = pcall(_a573.Egg.GetMaxHatch)
if _a1439 then _a1438 = tonumber(_a1440) end
end
return {
dia = _a610("Diamonds"),
petOwned = _a1415, petMax = _a1417, petNext = _a1423, petCost = _a1424,
eggOwned = _a1416, eggMax = _a1418, eggEnd = _a1427, eggSize = _a1428, eggCost = _a1429,
maxEquip = tonumber(rawget(_a1414, "MaxPetsEquipped")), maxHatch = _a1438,
}
end
function _a575.move.machinePos(_a1441)
local _a1442
if _a573.Machine and rawget(_a573.Machine, "GetModels") then
local _a1443, _a1444 = pcall(_a573.Machine.GetModels, _a1441)
if _a1443 and type(_a1444) == "table" then
for _a1445, _a1446 in pairs(_a1444) do
if typeof(_a1446) == "Instance" then _a1442 = _a1446 break end
end
end
end
if not _a1442 then
local _a1447, _a1448 = pcall(function()
return game:GetService("CollectionService"):GetTagged("Machine")
end)
if _a1447 then
for _a1449, _a1450 in ipairs(_a1448) do
if _a1450.Name == _a1441 then _a1442 = _a1450 break end
end
end
end
if not _a1442 then return nil end
if _a1442:IsA("BasePart") then return _a1442.Position end
local _a1451, _a1452 = pcall(function() return _a1442:GetPivot() end)
return (_a1451 and typeof(_a1452) == "CFrame") and _a1452.Position or nil
end
function _a575.mach.cycleSlots()
local _a1453 = 0
local _a1454 = 0
while _a569.slots and not _a575.ctl.stopped() and _a1454 < 40 do
_a1454 += 1
local _a1455 = _a575.mach.slotStatus()
if not _a1455 then return end
local _a1456 = _a568.SlotPet and _a1455.petNext and _a1455.petCost
and (_a1455.dia - _a568.SlotReserve) >= _a1455.petCost
local _a1457 = _a568.SlotEgg and _a1455.eggEnd and _a1455.eggCost
and (_a1455.dia - _a568.SlotReserve) >= _a1455.eggCost
if _a1456 and _a1457 then
if _a1455.eggCost < _a1455.petCost then _a1456 = false else _a1457 = false end
end
if not (_a1456 or _a1457) then break end
local _a1458, _a1459, _a1460, _a1461
local function _a1462()
if _a1456 then
pcall(function() _a1458, _a1459 = _a573.R_PetSlot:InvokeServer(_a1455.petNext) end)
else
pcall(function() _a1458, _a1459 = _a573.R_EggSlot:InvokeServer(_a1455.eggEnd) end)
end
end
if _a1456 then
_a1460 = ("펫 장착 슬롯 #%d (%s 다이아)"):format(_a1455.petNext, _a563(_a1455.petCost, 0))
_a1461 = "EquipSlotsMachine"
else
_a1460 = ("알 부화 슬롯 %d칸 → %d (%s 다이아)"):format(
_a1455.eggSize, _a1455.eggEnd, _a563(_a1455.eggCost, 0))
_a1461 = "EggSlotsMachine"
end
_a1462()
if not _a1458 and tostring(_a1459):find("far away") then
local _a1463 = _a575.move.machinePos(_a1461)
if _a1463 then
_a575.ctl.setAct("슬롯 머신으로 이동", _a1461)
_a575.move.glideTo(_a1463)
task.wait(0.25)
_a1458, _a1459 = nil, nil
_a1462()
else
_a1459 = "머신 위치를 못 찾음 (" .. _a1461 .. ")"
end
end
if _a1458 then
_a1453 += 1
_a570.mslot += 1
_a575.mach.slotSaid = nil
_a575.ctl.setAct("슬롯 구매", _a1460)
_a562("  ⬆ " .. _a1460)
task.wait(0.35)
else
local _a1464 = _a1460 .. " 실패: " .. tostring(_a1459)
if _a575.mach.slotSaid ~= _a1464 then
_a575.mach.slotSaid = _a1464
_a562("[슬롯] " .. _a1464)
end
break
end
end
if _a1453 > 0 then
local _a1465 = _a575.mach.slotStatus()
_a562(("[슬롯] %d개 구매 — 장착 %s / 한번에 %s개 부화 (다이아 %s 남음)"):format(
_a1453, tostring(_a1465 and _a1465.maxEquip), tostring(_a1465 and _a1465.maxHatch),
_a563(_a610("Diamonds"), 0)))
end
end
function _a575.mach.upgList()
local _a1466 = {}
if not _a573.Upg then return _a1466 end
local _a1467, _a1468 = pcall(_a573.Upg.All)
if not (_a1467 and type(_a1468) == "table") then return _a1466 end
for _a1469, _a1470 in ipairs(_a1468) do
local _a1471, _a1472, _a1473 = rawget(_a1470, "UpgradeID"), rawget(_a1470, "ZoneID"), rawget(_a1470, "UpgradeTier")
if _a1471 and _a1472 and _a1473 then
local _a1474 = false
if rawget(_a573.Upg, "Owns") then
local _a1475, _a1476 = pcall(_a573.Upg.Owns, _a1471, _a1472)
_a1474 = _a1475 and _a1476 and true or false
end
local _a1477 = _a575.move.ownsZone(_a1472)
local _a1478 = _a573.DirUpg and rawget(_a573.DirUpg, _a1471)
local _a1479 = _a1478 and rawget(_a1478, "TierCosts")
local _a1480 = _a1479 and tonumber(_a1479[_a1473])
local _a1481 = "Diamonds"
local _a1482 = _a1478 and rawget(_a1478, "TierCurrencies")
local _a1483 = _a1482 and _a1482[_a1473]
if type(_a1483) == "table" and rawget(_a1483, "_id") then _a1481 = rawget(_a1483, "_id") end
local _a1484 = rawget(_a1470, "Model")
local _a1485
if typeof(_a1484) == "Instance" then
if _a1484:IsA("BasePart") then _a1485 = _a1484.Position
else
local _a1486, _a1487 = pcall(function() return _a1484:GetPivot() end)
if _a1486 and _a1487 then _a1485 = _a1487.Position end
end
end
_a1466[#_a1466 + 1] = {
id = _a1471, zone = _a1472, tier = _a1473, cost = _a1480, cur = _a1481,
bought = _a1474, zoneOwned = _a1477,
buyable = _a1477 and not _a1474,
pos = _a1485, model = _a1484,
}
end
end
table.sort(_a1466, function(_a1488, _a1489) return (_a1488.cost or math.huge) < (_a1489.cost or math.huge) end)
return _a1466
end
function _a575.mach.cycleUpg()
if not _a573.R_Upg then _a562("[맵업글] Upgrades_Purchase 리모트 없음") return end
local _a1490 = _a575.mach.upgList()
if #_a1490 == 0 then return end
local _a1491 = 0
for _a1492, _a1493 in ipairs(_a1490) do
if not _a569.mapupg then break end
if _a1493.buyable and _a1493.cost then
local _a1494 = _a610(_a1493.cur or "Diamonds")
if _a1494 - _a568.UpgReserve < _a1493.cost then break end
if _a568.UpgTp and _a1493.pos and _a1493.zone == _a575.move.curZone() then
_a575.move.glideTo(_a1493.pos)
end
local _a1495, _a1496
pcall(function() _a1495, _a1496 = _a573.R_Upg:InvokeServer(_a1493.id, _a1493.zone) end)
if _a1495 then
_a1491 += 1
_a570.mapupg += 1
_a575.ctl.setAct("맵 업글", _a1493.id .. " T" .. _a1493.tier)
_a562(("  ▲ 맵업글  %s T%d  @%s   (%s 다이아)"):format(
_a1493.id, _a1493.tier, _a1493.zone, _a563(_a1493.cost, 0)))
elseif _a1496 then
_a562(("[맵업글] %s T%d @%s 실패: %s"):format(
_a1493.id, _a1493.tier, _a1493.zone, tostring(_a1496)))
end
task.wait(_a568.ActionGap)
end
end
if _a1491 > 0 then
_a562(("[맵업글] %d개 구매  (다이아 %s 남음)"):format(_a1491, _a563(_a610("Diamonds"), 0)))
end
end
local function _a1497()
local _a1498 = _a602()
if not _a1498 then return nil end
local _a1499 = tonumber(rawget(_a1498, "Rebirths")) or 0
local _a1500 = _a1499 + 1
local _a1501
if _a573.Rebirth and rawget(_a573.Rebirth, "GetNextRebirth") then
local _a1502, _a1503 = pcall(_a573.Rebirth.GetNextRebirth, _a1498)
if _a1502 then _a1501 = _a1503 end
end
return { current = _a1499, nextN = _a1500, def = _a1501 }
end
local function _a1504()
if not _a573.R_Reb then _a562("[리버스] Rebirth_Request 리모트 없음") return end
local _a1505 = _a1497()
if not _a1505 then
_a575.auto.rebNote = "세이브를 못 읽음"
return
end
local _a1506, _a1507
pcall(function() _a1506, _a1507 = _a573.R_Reb:InvokeServer(_a1505.nextN) end)
if _a1506 then
_a570.mreb += 1
_a575.auto.rebNote, _a575.auto.rebSaid = nil, nil
_a562(("  ★ 리버스 %d → %d"):format(_a1505.current, _a1505.nextN))
task.wait(0.5)
_a575.screen.dismissRewardScreens(25)
else
_a575.auto.rebNote = ("%d → %d : %s"):format(_a1505.current, _a1505.nextN,
_a1507 and tostring(_a1507) or "조건 미달 (리버스 킬/존 요구치)")
if _a575.auto.rebSaid ~= _a575.auto.rebNote then
_a575.auto.rebSaid = _a575.auto.rebNote
_a562("[리버스] " .. _a575.auto.rebNote)
end
end
end
_a575.auto.SIDE = {
{ key = "unlock", label = "알 해금",   run = "mhatch", fn = function() _a575.egg.unlockEggs() end },
{ key = "slots",  label = "슬롯 머신", run = "slots",  fn = function() _a575.mach.cycleSlots() end },
{ key = "mapupg", label = "맵 업그레이드", run = "mapupg", fn = function() _a575.mach.cycleUpg() end },
{ key = "items",  label = "버프 유지",     run = "items",  fn = function() _a575.item.cycleItems() end },
}
_a575.auto.STEPS = {
{ key = "mreb",   label = "리버스",  run = "mreb",  fn = function() _a1504() end,
hold = true },
{ key = "zone",   label = "존 해금", run = "zone",  fn = function() _a638() end,
hold = true },
{ key = "quest",  label = "랭크 퀘스트+보상", run = "quest", fn = function()
local _a1508 = _a569.farm
_a569.farm = true
pcall(_a620)
_a569.farm = _a1508
local _a1509 = _a575.quest.cycle()
if not _a1509 then
local _a1510 = _a575.move.bestZone()
if _a1510 then
local _a1511, _a1512 = _a575.move.goToZone(_a1510)
if not _a1511 then
if _a1512 and _a575.auto.idleMoveSaid ~= tostring(_a1512) then
_a575.auto.idleMoveSaid = tostring(_a1512)
_a562("[자동] 최고 존 이동 실패: " .. tostring(_a1512))
end
else
_a575.auto.idleMoveSaid = nil
end
end
if not _a568.IdleHatch then
_a575.ctl.setAct("파밍 중", ("퀘스트 없음 @%s"):format(tostring(_a575.move.curZone())))
return
end
local _a1513 = _a668()
local _a1514 = math.max(1, _a568.HatchMinAfford or 10)
if _a1513 and _a1513.price and _a1513.canBuy < _a1514 then
_a575.ctl.setAct("돈 버는 중", ("%s  %d/%d개분  개당 %s %s"):format(
tostring(_a575.move.curZone()), _a1513.canBuy, _a1514,
_a563(_a1513.price, 0), tostring(_a1513.currency)))
else
_a575.ctl.setAct("대기 중 부화")
local _a1515 = _a569.mhatch
_a569.mhatch = true
pcall(_a679)
_a569.mhatch = _a1515
end
end
end },
}
_a568.StepOn = {}
for _a1516, _a1517 in ipairs(_a575.auto.SIDE) do _a568.StepOn[_a1517.key] = true end
for _a1518, _a1519 in ipairs(_a575.auto.STEPS) do _a568.StepOn[_a1519.key] = true end
local function _a1520(_a1521, _a1522, _a1523, _a1524)
if not _a568.StepOn[_a1521.key] then
_a1524[#_a1524 + 1] = ("%-14s 꺼져있음"):format(_a1521.label)
return
end
if _a1521.hold and _a1522 then
_a1524[#_a1524 + 1] = ("%-14s 보류 (%s)"):format(
_a1521.label, _a1523 and tostring(_a1523.title) or "?")
if _a575.auto.heldMsg ~= _a1521.key then
_a575.auto.heldMsg = _a1521.key
_a562(("[자동] %s 보류 — best 존이 바뀌면 깨지는 퀘스트 진행 중 (%s)"):format(
_a1521.label, _a1523 and tostring(_a1523.title) or "?"))
end
return
end
if _a1521.hold then _a575.auto.heldMsg = nil end
_a575.auto.step = _a1521.label
_a575.ctl.now.step = _a1521.label
_a575.ctl.setAct("시작", _a1521.label)
local _a1525 = os.clock()
local _a1526 = _a569[_a1521.run]
_a569[_a1521.run] = true
local _a1527, _a1528 = pcall(_a1521.fn)
_a569[_a1521.run] = _a1526
local _a1529 = os.clock() - _a1525
if not _a1527 then
_a1524[#_a1524 + 1] = ("%-14s 오류: %s"):format(_a1521.label, tostring(_a1528))
_a562("[자동] " .. _a1521.label .. " 오류: " .. tostring(_a1528))
else
local _a1530 = (_a1521.key == "zone" and _a575.auto.zoneNote)
or (_a1521.key == "mreb" and _a575.auto.rebNote) or nil
_a1524[#_a1524 + 1] = ("%-14s 실행 %.1f초%s"):format(
_a1521.label, _a1529, _a1530 and ("  → " .. _a1530) or "")
end
end
function _a575.auto.master()
local _a1531 = {}
_a575.auto.lastTrace = _a1531
_a575.auto.lastPassAt = os.clock()
if _a575.screen.rewardScreenUp() then
_a1531[#_a1531 + 1] = "보상 화면 넘기는 중"
_a575.screen.dismissRewardScreens(15)
end
for _a1532, _a1533 in ipairs(_a575.auto.SIDE) do
if not _a569.auto or _a575.ctl.stopped() then return end
_a1520(_a1533, false, nil, _a1531)
end
local _a1534, _a1535 = false, nil
if _a568.HoldZoneForQuest then _a1534, _a1535 = _a575.quest.bestDepActive() end
for _a1536, _a1537 in ipairs(_a575.auto.STEPS) do
if not _a569.auto or _a575.ctl.stopped() then break end
_a1520(_a1537, _a1534, _a1535, _a1531)
end
_a575.auto.step = nil
if not _a575.ctl.lockGoal then
_a575.ctl.now.step = "대기"
_a575.ctl.setAct("다음 바퀴 대기", ("%.0f초 주기"):format(_a568.AutoInterval or 5))
end
end
local function _a1538()
if not _a567.R_PROMO then _a562("[타워업글] 리모트 없음") return end
local _a1539 = _a571()
if not _a1539 then return end
local _a1540 = _a572(_a1539)
table.sort(_a1540, function(_a1541, _a1542) return (_a1541.dps or 0) > (_a1542.dps or 0) end)
local _a1543, _a1544 = 0, 0
for _a1545, _a1546 in ipairs(_a1540) do
if not _a569.towerup then break end
if _a1546.id then
local _a1547
pcall(function() _a1547 = _a567.R_PROMO:InvokeServer(_a1546.id) end)
if _a1547 ~= nil and _a1547 ~= false then
_a1543 += 1
_a562(("  ▲ 타워업글  %s  Lv%s → Lv%s"):format(tostring(_a1546.kind), tostring(_a1546.up), tostring((_a1546.up or 0) + 1)))
_a1544 = 0
task.wait(_a568.ActionGap)
else
_a1544 += 1
if _a1544 >= 5 then break end
end
end
end
_a562("[타워업글] " .. _a1543 .. "건")
end
local _a1548 = {}
local function _a1549(_a1550, _a1551, _a1552, _a1553)
_a1548[_a1550] = (_a1548[_a1550] or 0) + 1
local _a1554 = _a1548[_a1550]
task.spawn(function()
while _a569[_a1550] and _a1548[_a1550] == _a1554 do
local _a1555, _a1556 = pcall(_a1552)
if not _a1555 then _a562("[" .. _a1553 .. " 오류] " .. tostring(_a1556)) end
local _a1557, _a1558 = _a1551(), 0
while _a1558 < _a1557 and _a569[_a1550] and _a1548[_a1550] == _a1554 do task.wait(0.1) _a1558 += 0.1 end
end
if _a1548[_a1550] == _a1554 then _a562("[" .. _a1553 .. "] 중지") end
end)
end
do
local _a1559 = {
farm   = { function() return _a568.FarmInterval end,      function() _a620() end,      "파밍" },
zone   = { function() return _a568.ZoneInterval end,      function() _a638() end,      "존" },
mhatch = { function() return _a568.MainHatchInterval end, function() _a679() end, "부화" },
}
function _a575.auto.turnOn(_a1560, _a1561)
if _a569.auto then return end
if _a569[_a1560] then return end
local _a1562 = _a1559[_a1560]
if not _a1562 then return end
_a569[_a1560] = true
_a1549(_a1560, _a1562[1], _a1562[2], _a1562[3])
if _a575.auto.refresh then _a575.auto.refresh() end
_a562("[퀘스트] " .. tostring(_a1561) .. " ON")
end
end
_a558.MG, _a558.QS, _a558.saveGet, _a558.currencyAmount, _a558.cycleFarm, _a558.zoneStatus = _a573, _a575, _a602, _a610, _a620, _a634
_a558.cycleZone, _a558.bestMainEgg, _a558.mainHatchStatus, _a558.cycleMainHatch, _a558.mainRebirthStatus, _a558.cycleMainRebirth = _a638, _a643, _a668, _a679, _a1497, _a1504
_a558.cycleTowerUp, _a558.startLoop = _a1538, _a1549
end)(_a1)
;(function(_a1563)
local _a1564, _a1565, _a1566, _a1567, _a1568, _a1569 = _a1563.UIS, _a1563.RunService, _a1563.LP, _a1563.LOG, _a1563.log, _a1563.num
local _a1570, _a1571, _a1572, _a1573, _a1574, _a1575 = _a1563.RM, _a1563.CFG, _a1563.EGG_COST_CACHE, _a1563.RUN, _a1563.STAT, _a1563.EVENT_UPGRADES
local _a1576, _a1577, _a1578, _a1579, _a1580, _a1581 = _a1563.ctx, _a1563.collectSlots, _a1563.placedTowers, _a1563.availableItems, _a1563.cyclePlace, _a1563.cycleMerchant
local _a1582, _a1583, _a1584, _a1585, _a1586, _a1587 = _a1563.sunflowers, _a1563.eventTiers, _a1563.nextCost, _a1563.cycleUpgrade, _a1563.seedInv, _a1563.bedsOf
local _a1588, _a1589, _a1590, _a1591, _a1592, _a1593 = _a1563.isUnhatched, _a1563.bedCps, _a1563.cycleCrop, _a1563.laneCosts, _a1563.lockedBeds, _a1563.cycleExpand
local _a1594, _a1595, _a1596, _a1597, _a1598 = _a1563.rebirthStatus, _a1563.cycleRebirth, _a1563.hatchStatus, _a1563.cycleHatch, _a1563.LUCK_ORDER
local _a1599, _a1600, _a1601, _a1602, _a1603, _a1604 = _a1563.luckStatus, _a1563.fmtDur, _a1563.cycleLuck, _a1563.MG, _a1563.QS, _a1563.saveGet
local _a1605, _a1606, _a1607, _a1608, _a1609, _a1610 = _a1563.currencyAmount, _a1563.cycleFarm, _a1563.zoneStatus, _a1563.cycleZone, _a1563.bestMainEgg, _a1563.mainHatchStatus
local _a1611, _a1612, _a1613, _a1614, _a1615 = _a1563.cycleMainHatch, _a1563.mainRebirthStatus, _a1563.cycleMainRebirth, _a1563.cycleTowerUp, _a1563.startLoop
local _a1616 = {
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
local function _a1617(_a1618, _a1619, _a1620)
local _a1621 = Instance.new(_a1618)
for _a1622, _a1623 in pairs(_a1619) do _a1621[_a1622] = _a1623 end
if _a1620 then _a1621.Parent = _a1620 end
return _a1621
end
local function _a1624(_a1625, _a1626) _a1617("UICorner", { CornerRadius = UDim.new(0, _a1626 or 8) }, _a1625) end
local function _a1627(_a1628, _a1629, _a1630)
_a1617("UIStroke", { Color = _a1629 or _a1616.line, Thickness = _a1630 or 1,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, _a1628)
end
local function _a1631(_a1632, _a1633)
_a1617("UIPadding", {
PaddingTop = UDim.new(0, _a1633), PaddingBottom = UDim.new(0, _a1633),
PaddingLeft = UDim.new(0, _a1633), PaddingRight = UDim.new(0, _a1633),
}, _a1632)
end
local _a1634 = _a1617("ScreenGui", {
Name = "PS99GardenAuto", ResetOnSpawn = false,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
IgnoreGuiInset = true, DisplayOrder = 9999,
})
local _a1635 = false
if type(gethui) == "function" then _a1635 = pcall(function() _a1634.Parent = gethui() end) end
if not _a1635 then _a1635 = pcall(function() _a1634.Parent = game:GetService("CoreGui") end) end
if not _a1635 then _a1634.Parent = _a1566:WaitForChild("PlayerGui") end
local _a1636, _a1637 = 780, 520
local _a1638 = _a1617("Frame", {
Size = UDim2.fromOffset(_a1636, _a1637), Position = UDim2.new(0.5, -_a1636 / 2, 0.5, -_a1637 / 2),
BackgroundColor3 = _a1616.bg, BorderSizePixel = 0, Active = true, ClipsDescendants = true,
}, _a1634)
_a1624(_a1638, 12)
_a1627(_a1638, Color3.fromRGB(60, 66, 82), 1)
local _a1639 = _a1617("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = _a1616.panel, BorderSizePixel = 0,
}, _a1638)
_a1624(_a1639, 12)
_a1617("Frame", {
Size = UDim2.new(1, 0, 0, 12), Position = UDim2.new(0, 0, 1, -12),
BackgroundColor3 = _a1616.panel, BorderSizePixel = 0,
}, _a1639)
_a1617("Frame", {
Size = UDim2.fromOffset(10, 10), Position = UDim2.fromOffset(14, 15),
BackgroundColor3 = _a1616.good, BorderSizePixel = 0,
}, _a1639).Name = "Dot"
_a1624(_a1639:FindFirstChild("Dot"), 5)
_a1617("TextLabel", {
Size = UDim2.new(0, 320, 1, 0), Position = UDim2.fromOffset(32, 0),
BackgroundTransparency = 1, Text = "Garden Defenders  AutoPlay",
TextColor3 = _a1616.text, TextSize = 14, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1639)
local function _a1640(_a1641, _a1642, _a1643, _a1644)
local _a1645 = _a1617("TextButton", {
Size = UDim2.new(0, _a1644, 0, 24), Position = UDim2.new(1, _a1643, 0, 8),
BackgroundColor3 = _a1642, BorderSizePixel = 0, Text = _a1641,
TextColor3 = _a1616.text, TextSize = 12, Font = Enum.Font.GothamMedium,
AutoButtonColor = true,
}, _a1639)
_a1624(_a1645, 6)
return _a1645
end
local _a1646 = _a1640("✕", _a1616.bad, -38, 28)
local _a1647   = _a1640("—", _a1616.card, -70, 28)
local _a1648 = _a1640("지우기", _a1616.card, -132, 58)
local _a1649  = _a1640("복사", _a1616.accent, -190, 54)
local _a1650  = _a1640("정지", _a1616.bad, -252, 58)
_a1650.MouseButton1Click:Connect(function()
_a1603.ctl.stopAll()
if _a1603.auto.refresh then pcall(_a1603.auto.refresh) end
_a1568("[정지] 모든 동작을 멈췄습니다")
end)
local _a1651 = _a1617("ScrollingFrame", {
Size = UDim2.new(0, 152, 1, -92), Position = UDim2.fromOffset(10, 48),
BackgroundColor3 = _a1616.panel, BorderSizePixel = 0,
ScrollBarThickness = 3, ScrollBarImageColor3 = _a1616.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1638)
_a1624(_a1651, 8)
_a1617("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, _a1651)
_a1617("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }, _a1651)
local _a1652 = _a1617("Frame", {
Size = UDim2.new(1, -182, 1, -92), Position = UDim2.fromOffset(172, 48),
BackgroundTransparency = 1,
}, _a1638)
local _a1653, _a1654 = {}, nil
local _a1655, _a1656 = {}, {}
local _a1657 = {}
local function _a1658(_a1659)
_a1654 = _a1659
for _a1660, _a1661 in pairs(_a1653) do _a1661.Visible = (_a1660 == _a1659) end
for _a1662, _a1663 in pairs(_a1655) do
local _a1664 = (_a1662 == _a1659)
_a1663.BackgroundColor3 = _a1664 and _a1616.accent or _a1616.panel
_a1663.TextColor3 = _a1664 and Color3.fromRGB(255, 255, 255) or _a1616.dim
end
local _a1665 = _a1656[_a1659]
if _a1665 and _a1657[_a1665] and not _a1657[_a1665].open then _a1657[_a1665].toggle() end
end
local function _a1666(_a1667, _a1668, _a1669)
local _a1670 = { open = true, kids = {} }
local _a1671 = _a1617("TextButton", {
Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = _a1616.bg, BorderSizePixel = 0,
Text = "", TextColor3 = _a1616.dim, TextSize = 11,
Font = Enum.Font.GothamBold, LayoutOrder = _a1669, AutoButtonColor = false,
}, _a1651)
_a1624(_a1671, 5)
local _a1672 = _a1617("TextLabel", {
Size = UDim2.fromOffset(14, 26), Position = UDim2.fromOffset(6, 0),
BackgroundTransparency = 1, Text = "▾", TextColor3 = _a1616.dim,
TextSize = 10, Font = Enum.Font.GothamBold,
}, _a1671)
_a1617("TextLabel", {
Size = UDim2.new(1, -22, 1, 0), Position = UDim2.fromOffset(20, 0),
BackgroundTransparency = 1, Text = _a1668, TextColor3 = _a1616.dim,
TextSize = 11, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1671)
function _a1670.toggle()
_a1670.open = not _a1670.open
_a1672.Text = _a1670.open and "▾" or "▸"
for _a1673, _a1674 in ipairs(_a1670.kids) do _a1674.Visible = _a1670.open end
end
_a1671.MouseButton1Click:Connect(_a1670.toggle)
_a1657[_a1667] = _a1670
return _a1670
end
local function _a1675(_a1676, _a1677, _a1678, _a1679)
local _a1680 = _a1679 and 14 or 6
local _a1681 = _a1617("TextButton", {
Size = UDim2.new(1, 0, 0, 27), BackgroundColor3 = _a1616.panel, BorderSizePixel = 0,
Text = "", TextColor3 = _a1616.dim, TextSize = 12,
Font = Enum.Font.GothamMedium, LayoutOrder = _a1678, AutoButtonColor = false,
}, _a1651)
_a1624(_a1681, 5)
local _a1682 = _a1617("TextLabel", {
Size = UDim2.new(1, -_a1680 - 4, 1, 0), Position = UDim2.fromOffset(_a1680, 0),
BackgroundTransparency = 1, Text = _a1677, TextColor3 = _a1616.dim,
TextSize = 12, Font = Enum.Font.GothamMedium,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1681)
_a1655[_a1676] = _a1681
if _a1679 then
_a1656[_a1676] = _a1679
local _a1683 = _a1657[_a1679]
if _a1683 then
table.insert(_a1683.kids, _a1681)
_a1681.Visible = _a1683.open
end
end
local _a1684 = _a1617("ScrollingFrame", {
Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false,
BorderSizePixel = 0, ScrollBarThickness = 4,
ScrollBarImageColor3 = _a1616.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1652)
_a1617("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, _a1684)
_a1617("UIPadding", { PaddingRight = UDim.new(0, 8) }, _a1684)
_a1653[_a1676] = _a1684
_a1681.MouseButton1Click:Connect(function() _a1658(_a1676) end)
_a1681.MouseEnter:Connect(function()
if _a1654 ~= _a1676 then _a1681.BackgroundColor3 = _a1616.card end
end)
_a1681.MouseLeave:Connect(function()
if _a1654 ~= _a1676 then _a1681.BackgroundColor3 = _a1616.panel end
end)
_a1681:GetPropertyChangedSignal("TextColor3"):Connect(function()
_a1682.TextColor3 = _a1681.TextColor3
end)
return _a1684
end
local _a1685 = 0
local function _a1686()
_a1685 += 1
return _a1685
end
local function _a1687(_a1688, _a1689)
local _a1690 = _a1617("Frame", {
Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, LayoutOrder = _a1686(),
}, _a1688)
_a1617("Frame", {
Size = UDim2.fromOffset(3, 14), Position = UDim2.fromOffset(0, 7),
BackgroundColor3 = _a1616.accent, BorderSizePixel = 0,
}, _a1690)
_a1617("TextLabel", {
Size = UDim2.new(1, -12, 1, 0), Position = UDim2.fromOffset(10, 0),
BackgroundTransparency = 1, Text = _a1689, TextColor3 = _a1616.text,
TextSize = 13, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1690)
return _a1690
end
local function _a1691(_a1692, _a1693, _a1694)
local _a1695 = _a1617("Frame", {
Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundColor3 = _a1616.card, BorderSizePixel = 0, LayoutOrder = _a1686(),
}, _a1692)
_a1624(_a1695, 8)
_a1627(_a1695, _a1616.line, 1)
_a1631(_a1695, 12)
_a1617("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, _a1695)
if _a1693 then
local _a1696 = _a1617("Frame", {
Size = UDim2.new(1, 0, 0, _a1694 and 32 or 22), BackgroundTransparency = 1,
LayoutOrder = 0,
}, _a1695)
_a1617("TextLabel", {
Size = UDim2.new(1, -70, 0, 16), BackgroundTransparency = 1, Text = _a1693,
TextColor3 = _a1616.text, TextSize = 13, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1696)
if _a1694 then
_a1617("TextLabel", {
Size = UDim2.new(1, -70, 0, 13), Position = UDim2.fromOffset(0, 17),
BackgroundTransparency = 1, Text = _a1694, TextColor3 = _a1616.dim,
TextSize = 11, Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
}, _a1696)
end
_a1695:SetAttribute("HeadHeight", _a1694 and 32 or 18)
return _a1695, _a1696
end
return _a1695
end
local _a1697 = {}
local function _a1698()
for _a1699, _a1700 in pairs(_a1697) do pcall(_a1700) end
end
_a1603.auto.refresh = _a1698
local function _a1701(_a1702, _a1703, _a1704)
local _a1705 = _a1617("TextButton", {
Size = UDim2.fromOffset(46, 24), Position = UDim2.new(1, -46, 0, 0),
BackgroundColor3 = _a1616.cardHi, BorderSizePixel = 0, Text = "",
AutoButtonColor = false,
}, _a1702)
_a1624(_a1705, 12)
local _a1706 = _a1617("Frame", {
Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(3, 3),
BackgroundColor3 = _a1616.dim, BorderSizePixel = 0,
}, _a1705)
_a1624(_a1706, 9)
local _a1707 = _a1617("TextLabel", {
Size = UDim2.fromOffset(46, 12), Position = UDim2.fromOffset(0, 26),
BackgroundTransparency = 1, Text = "OFF", TextColor3 = _a1616.dim,
TextSize = 10, Font = Enum.Font.GothamBold,
}, _a1705)
local function _a1708()
local _a1709 = _a1573[_a1703]
_a1705.BackgroundColor3 = _a1709 and _a1616.good or _a1616.cardHi
_a1706:TweenPosition(UDim2.fromOffset(_a1709 and 25 or 3, 3),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
_a1706.BackgroundColor3 = _a1709 and Color3.fromRGB(255, 255, 255) or _a1616.dim
_a1707.Text = _a1709 and "ON" or "OFF"
_a1707.TextColor3 = _a1709 and _a1616.good or _a1616.dim
end
_a1705.MouseButton1Click:Connect(function()
_a1573[_a1703] = not _a1573[_a1703]
if _a1573[_a1703] then
if _a1703 == "auto" then _a1603.ctl.abort = false end
_a1708()
_a1568("[" .. _a1703 .. "] 시작")
local _a1710, _a1711 = pcall(_a1704)
if not _a1710 then _a1568("[에러] " .. tostring(_a1711)) end
else
if _a1703 == "auto" then
_a1603.ctl.stopAll()
_a1568("[정지] 모든 동작을 멈췄습니다")
end
_a1708()
end
end)
_a1708()
_a1697[_a1703] = _a1708
return _a1705, _a1708
end
local function _a1712(_a1713, _a1714)
local _a1715 = _a1617("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, LayoutOrder = _a1686(),
}, _a1713)
local _a1716 = #_a1714
for _a1717, _a1718 in ipairs(_a1714) do
local _a1719 = _a1617("Frame", {
Size = UDim2.new(1 / _a1716, -6, 1, 0), Position = UDim2.new((_a1717 - 1) / _a1716, 3, 0, 0),
BackgroundTransparency = 1,
}, _a1715)
_a1617("TextLabel", {
Size = UDim2.new(1, 0, 0, 13), BackgroundTransparency = 1, Text = _a1718.label,
TextColor3 = _a1616.dim, TextSize = 10, Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1719)
local _a1720 = _a1617("TextBox", {
Size = UDim2.new(1, 0, 0, 24), Position = UDim2.fromOffset(0, 15),
BackgroundColor3 = _a1616.bg, BorderSizePixel = 0, Text = tostring(_a1718.value),
TextColor3 = _a1616.text, TextSize = 12, Font = Enum.Font.Code,
ClearTextOnFocus = false,
}, _a1719)
_a1624(_a1720, 5)
_a1627(_a1720, _a1616.line, 1)
_a1720.FocusLost:Connect(function() _a1718.onChange(_a1720.Text, _a1720) end)
end
return _a1715
end
local function _a1721(_a1722, _a1723)
local _a1724 = _a1617("Frame", {
Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = _a1686(),
}, _a1722)
local _a1725 = #_a1723
for _a1726, _a1727 in ipairs(_a1723) do
local _a1728 = _a1617("TextButton", {
Size = UDim2.new(1 / _a1725, -5, 1, 0), Position = UDim2.new((_a1726 - 1) / _a1725, 2.5, 0, 0),
BackgroundColor3 = _a1727.col or _a1616.cardHi, BorderSizePixel = 0, Text = _a1727.label,
TextColor3 = _a1616.text, TextSize = 12, Font = Enum.Font.GothamMedium,
}, _a1724)
_a1624(_a1728, 6)
_a1728.MouseButton1Click:Connect(function()
local _a1729, _a1730 = pcall(_a1727.fn, _a1728)
if not _a1729 then _a1568("[에러] " .. tostring(_a1727.label) .. " → " .. tostring(_a1730)) end
end)
end
return _a1724
end
local function _a1731(_a1732, _a1733, _a1734, _a1735)
local _a1736 = _a1617("TextButton", {
Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = _a1616.cardHi, BorderSizePixel = 0,
Text = "", TextColor3 = _a1616.text, TextSize = 12, Font = Enum.Font.GothamMedium,
LayoutOrder = _a1686(),
}, _a1732)
_a1624(_a1736, 6)
local function _a1737()
local _a1738 = _a1734()
_a1736.Text = _a1733 .. "   " .. (_a1738 and "ON" or "OFF")
_a1736.BackgroundColor3 = _a1738 and Color3.fromRGB(40, 78, 58) or _a1616.cardHi
_a1736.TextColor3 = _a1738 and _a1616.good or _a1616.dim
end
_a1736.MouseButton1Click:Connect(function()
_a1735(not _a1734())
_a1737()
end)
_a1737()
return _a1736
end
local _a1739 = _a1675("log", "로그", 90)
local _a1740
do
local _a1741 = _a1617("Frame", {
Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(13, 14, 18),
BorderSizePixel = 0, LayoutOrder = _a1686(),
}, _a1739)
_a1624(_a1741, 8)
_a1627(_a1741, _a1616.line, 1)
local _a1742 = _a1617("ScrollingFrame", {
Size = UDim2.new(1, -10, 1, -10), Position = UDim2.fromOffset(5, 5),
BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4,
ScrollBarImageColor3 = _a1616.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1741)
_a1740 = _a1617("TextLabel", {
Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1, Text = "", TextColor3 = Color3.fromRGB(196, 208, 196),
TextSize = 11, Font = Enum.Font.Code,
TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
TextWrapped = true,
}, _a1742)
_a1739.AutomaticCanvasSize = Enum.AutomaticSize.None
_a1739.CanvasSize = UDim2.new()
end
do
local _a1743, _a1744, _a1745, _a1746
_a1639.InputBegan:Connect(function(_a1747)
if _a1747.UserInputType == Enum.UserInputType.MouseButton1
or _a1747.UserInputType == Enum.UserInputType.Touch then
_a1743, _a1744, _a1745 = true, _a1747.Position, _a1638.Position
_a1747.Changed:Connect(function()
if _a1747.UserInputState == Enum.UserInputState.End then _a1743 = false end
end)
end
end)
_a1639.InputChanged:Connect(function(_a1748)
if _a1748.UserInputType == Enum.UserInputType.MouseMovement
or _a1748.UserInputType == Enum.UserInputType.Touch then _a1746 = _a1748 end
end)
_a1564.InputChanged:Connect(function(_a1749)
if _a1743 and _a1749 == _a1746 then
local _a1750 = _a1749.Position - _a1744
_a1638.Position = UDim2.new(_a1745.X.Scale, _a1745.X.Offset + _a1750.X,
_a1745.Y.Scale, _a1745.Y.Offset + _a1750.Y)
end
end)
local _a1751 = false
_a1647.MouseButton1Click:Connect(function()
_a1751 = not _a1751
_a1638:TweenSize(_a1751 and UDim2.fromOffset(_a1636, 40) or UDim2.fromOffset(_a1636, _a1637),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
_a1647.Text = _a1751 and "▢" or "—"
end)
end
local _a1752 = _a1565.Heartbeat:Connect(function()
if not _a1563.dirty then return end
_a1563.dirty = false
local _a1753 = #_a1567
_a1740.Text = table.concat(table.move(_a1567, math.max(1, _a1753 - 300), _a1753, 1, {}), "\n")
end)
local _a1754 = _a1675("dash", "대시보드", 10)
local _a1755 = _a1675("event", "이벤트", 20)
do
local _a1756 = _a1691(_a1754, "전체 제어", nil)
_a1721(_a1756, {
{ label = "권장 전부 ON", col = _a1616.good, fn = function()
for _a1757, _a1758 in ipairs({ "place", "merchant", "crop", "expand", "hatch" }) do
if not _a1573[_a1758] then
_a1573[_a1758] = true
if _a1758 == "place"    then _a1615(_a1758, function() return _a1571.PlaceInterval end, _a1580, "배치") end
if _a1758 == "merchant" then _a1615(_a1758, function() return _a1571.MerchantInterval end, _a1581, "구매") end
if _a1758 == "crop"     then _a1615(_a1758, function() return _a1571.CropInterval end, _a1590, "씨앗") end
if _a1758 == "expand"   then _a1615(_a1758, function() return _a1571.ExpandInterval end, _a1593, "확장") end
if _a1758 == "hatch"    then _a1615(_a1758, function() return _a1571.HatchInterval end, _a1597, "뽑기") end
end
end
_a1698()
_a1568("[전체] 배치/구매/씨앗/확장/뽑기 ON  (업글·리버스는 따로 켜세요)")
end },
{ label = "전부 정지", col = _a1616.bad, fn = function()
_a1573.place, _a1573.merchant, _a1573.upgrade = false, false, false
_a1573.towerup, _a1573.crop, _a1573.expand, _a1573.rebirth, _a1573.hatch, _a1573.luck = false, false, false, false, false, false
_a1573.farm, _a1573.zone, _a1573.mhatch, _a1573.rank, _a1573.mreb = false, false, false, false, false
_a1698()
_a1568("[전체] 정지")
end },
})
local _a1759 = _a1691(_a1754, "현황", nil)
_a1721(_a1759, {
{ label = "밭 / 타워", col = _a1616.accent, fn = function()
local _a1760, _a1761, _a1762, _a1763 = _a1576()
_a1568("")
_a1568("──── 현재 상태 ────")
_a1568("레인 " .. tostring(_a1763) .. " / plot " .. (_a1762 and "O" or "X")
.. " / world " .. (_a1760 and "O" or "X"))
local _a1764 = _a1577(_a1762, _a1763)
local _a1765 = _a1578(_a1760)
_a1568("슬롯 " .. #_a1764 .. " / 배치 " .. #_a1765)
local _a1766, _a1767 = 0, {}
for _a1768, _a1769 in ipairs(_a1765) do
_a1766 += (_a1769.dps or 0)
_a1767[tostring(_a1769.kind)] = (_a1767[tostring(_a1769.kind)] or 0) + 1
end
_a1568("총 DPS " .. _a1569(_a1766))
for _a1770, _a1771 in pairs(_a1767) do _a1568("  " .. _a1770 .. " × " .. _a1771) end
local _a1772 = _a1579()
_a1568("")
_a1568("배치 가능 " .. #_a1772 .. "종")
for _a1773 = 1, math.min(10, #_a1772) do
local _a1774 = _a1772[_a1773]
_a1568(("  %-22s %-7s 남은 %-3s DPS %s"):format(
tostring(_a1774.id), tostring(_a1774.vr or "-"), tostring(_a1774.copies), _a1569(_a1774.dps)))
end
_a1658("log")
end },
{ label = "로그 보기", col = _a1616.cardHi, fn = function() _a1658("log") end },
})
end
do
local _a1775, _a1776 = _a1691(_a1755, "자동 배치 / 교체", nil)
_a1701(_a1776, "place", function()
_a1615("place", function() return _a1571.PlaceInterval end, _a1580, "배치")
end)
_a1712(_a1775, {
{ label = "주기", value = _a1571.PlaceInterval, onChange = function(_a1777)
local _a1778 = tonumber(_a1777) if _a1778 and _a1778 >= 3 then _a1571.PlaceInterval = _a1778 end
end },
{ label = "교체 배수", value = _a1571.SwapMargin, onChange = function(_a1779)
local _a1780 = tonumber(_a1779) if _a1780 and _a1780 >= 1 then _a1571.SwapMargin = _a1780 _a1568("[설정] 교체 배수 " .. _a1780) end
end },
{ label = "DoT 반영", value = _a1571.DotFactor, onChange = function(_a1781)
local _a1782 = tonumber(_a1781) if _a1782 and _a1782 >= 0 and _a1782 <= 1 then _a1571.DotFactor = _a1782 end
end },
})
_a1731(_a1775, "업글 타워 보호",
function() return _a1571.ProtectUpgraded end,
function(_a1783) _a1571.ProtectUpgraded = _a1783
_a1568("[설정] 업글 보호 " .. (_a1783 and "ON — 업글된 건 안 건드림" or "OFF — 약하면 교체")) end)
_a1721(_a1775, {
{ label = "지금 1회 실행", col = _a1616.accent, fn = function()
task.spawn(function() _a1573.place = true _a1580() _a1573.place = false _a1658("log") end)
end },
})
end
do
local _a1784, _a1785 = _a1691(_a1755, "머천트 자동 구매", nil)
_a1701(_a1785, "merchant", function()
_a1615("merchant", function() return _a1571.MerchantInterval end, _a1581, "구매")
end)
_a1712(_a1784, {
{ label = "머천트 ID", value = _a1571.MerchantId, onChange = function(_a1786)
if _a1786 ~= "" then _a1571.MerchantId = _a1786 _a1568("[설정] 머천트 " .. _a1786) end
end },
{ label = "주기", value = _a1571.MerchantInterval, onChange = function(_a1787)
local _a1788 = tonumber(_a1787) if _a1788 and _a1788 >= 5 then _a1571.MerchantInterval = _a1788 end
end },
})
_a1721(_a1784, {
{ label = "지금 1회 구매", col = _a1616.accent, fn = function()
task.spawn(function() _a1573.merchant = true _a1581() _a1573.merchant = false _a1658("log") end)
end },
})
end
do
local _a1789, _a1790 = _a1691(_a1755, "업그레이드 머신", nil)
_a1701(_a1790, "upgrade", function()
_a1615("upgrade", function() return _a1571.UpgradeInterval end, _a1585, "머신업글")
end)
_a1712(_a1789, {
{ label = "주기", value = _a1571.UpgradeInterval, onChange = function(_a1791)
local _a1792 = tonumber(_a1791) if _a1792 and _a1792 >= 5 then _a1571.UpgradeInterval = _a1792 end
end },
{ label = "최소 잔액", value = _a1571.MinSunflowers, onChange = function(_a1793)
local _a1794 = tonumber(_a1793) if _a1794 and _a1794 >= 0 then _a1571.MinSunflowers = _a1794
_a1568("[설정] 최소 잔액 " .. _a1569(_a1794, 0)) end
end },
})
_a1731(_a1789, "가격 미상 구매",
function() return _a1571.BuyUnknownCost end,
function(_a1795) _a1571.BuyUnknownCost = _a1795 end)
_a1721(_a1789, {
{ label = "업글 현황 보기", col = _a1616.accent, fn = function()
local _a1796 = _a1582()
local _a1797 = _a1583()
_a1574.sun = _a1796
_a1568("")
_a1568("──── 업그레이드 머신 ────")
_a1568("Sunflowers = " .. _a1569(_a1796, 0))
local _a1798 = {}
for _a1799, _a1800 in ipairs(_a1575) do
local _a1801 = _a1797[_a1800] or 0
_a1798[#_a1798 + 1] = { id = _a1800, tier = _a1801, cost = _a1584(_a1800, _a1801) }
end
table.sort(_a1798, function(_a1802, _a1803)
return (_a1802.cost or math.huge) < (_a1803.cost or math.huge)
end)
for _a1804, _a1805 in ipairs(_a1798) do
_a1568(("  %-22s Lv%-3s 다음 %-14s %s"):format(
_a1805.id, tostring(_a1805.tier), _a1805.cost and _a1569(_a1805.cost, 0) or "?",
(_a1805.cost and _a1805.cost <= _a1796) and "← 구매가능" or ""))
end
_a1658("log")
end },
{ label = "지금 1회 업글", col = _a1616.cardHi, fn = function()
task.spawn(function() _a1573.upgrade = true _a1585() _a1573.upgrade = false _a1658("log") end)
end },
})
local _a1806, _a1807 = _a1691(_a1755, "타워 개별 업글", nil)
_a1701(_a1807, "towerup", function()
_a1615("towerup", function() return _a1571.UpgradeInterval end, _a1614, "타워업글")
end)
end
do
local _a1808, _a1809 = _a1691(_a1755, "자동 뽑기", nil)
_a1701(_a1809, "hatch", function()
_a1615("hatch", function() return _a1571.HatchInterval end, _a1597, "뽑기")
end)
_a1712(_a1808, {
{ label = "주기", value = _a1571.HatchInterval, onChange = function(_a1810)
local _a1811 = tonumber(_a1810) if _a1811 and _a1811 >= 1 then _a1571.HatchInterval = _a1811 end
end },
{ label = "한 번에 최대", value = _a1571.HatchMax, onChange = function(_a1812)
local _a1813 = tonumber(_a1812) if _a1813 and _a1813 >= 1 then _a1571.HatchMax = math.floor(_a1813) end
end },
})
_a1712(_a1808, {
{ label = "예비금", value = _a1571.HatchReserve, onChange = function(_a1814)
local _a1815 = tonumber(_a1814) if _a1815 and _a1815 >= 0 then _a1571.HatchReserve = _a1815
_a1568("[설정] 뽑기 예비금 " .. _a1569(_a1815, 0)) end
end },
{ label = "알 번호 (0=자동)", value = _a1571.HatchEggNum, onChange = function(_a1816)
local _a1817 = tonumber(_a1816) if _a1817 and _a1817 >= 0 and _a1817 <= 12 then
_a1571.HatchEggNum = math.floor(_a1817)
table.clear(_a1572)
_a1568("[설정] 알 번호 " .. (_a1817 == 0 and "자동" or _a1817)) end
end },
})
_a1721(_a1808, {
{ label = "뽑기 현황 보기", col = _a1616.accent, fn = function()
local _a1818 = _a1596()
_a1574.sun = _a1818.sun
_a1568("")
_a1568("──── 뽑기 현황 ────")
_a1568("  알 등급     " .. _a1818.id)
_a1568("  알 uid      " .. tostring(_a1818.uid))
_a1568("  개당 비용   " .. (_a1818.cost and _a1569(_a1818.cost, 0) or "?"))
_a1568("  Sunflowers  " .. _a1569(_a1818.sun, 0))
_a1568("  예비금      " .. _a1569(_a1571.HatchReserve, 0))
_a1568("  지금 가능   " .. _a1818.canBuy .. "회")
_a1568("")
_a1568("  월드의 알 " .. _a1818.eggCount .. "개")
for _a1819, _a1820 in ipairs(_a1818.eggs) do
if _a1819 > 5 then break end
_a1568(("    %s  거리 %s"):format(_a1820.uid, _a1569(_a1820.dist)))
end
_a1568("")
_a1568("  누적 뽑기   " .. _a1574.hatched .. "회")
_a1658("log")
end },
{ label = "지금 1회 실행", col = _a1616.cardHi, fn = function()
task.spawn(function() _a1573.hatch = true _a1597() _a1573.hatch = false _a1658("log") end)
end },
})
end
do
local _a1821, _a1822 = _a1691(_a1755, "럭 상시 최대 유지", nil)
_a1701(_a1822, "luck", function()
_a1615("luck", function() return _a1571.LuckInterval end, _a1601, "럭")
end)
_a1712(_a1821, {
{ label = "주기", value = _a1571.LuckInterval, onChange = function(_a1823)
local _a1824 = tonumber(_a1823) if _a1824 and _a1824 >= 60 then _a1571.LuckInterval = _a1824 end
end },
{ label = "예비금", value = _a1571.LuckReserve, onChange = function(_a1825)
local _a1826 = tonumber(_a1825) if _a1826 and _a1826 >= 0 then _a1571.LuckReserve = _a1826 end
end },
})
_a1712(_a1821, {
{ label = "최소 부족분", value = _a1571.LuckMinTopUp, onChange = function(_a1827)
local _a1828 = tonumber(_a1827) if _a1828 and _a1828 >= 0 then _a1571.LuckMinTopUp = _a1828 end
end },
})
for _a1829, _a1830 in ipairs(_a1598) do
_a1731(_a1821, _a1830,
function() return _a1571.LuckBoosts[_a1830] end,
function(_a1831) _a1571.LuckBoosts[_a1830] = _a1831 end)
end
_a1721(_a1821, {
{ label = "럭 현황 보기", col = _a1616.accent, fn = function()
local _a1832 = _a1599()
_a1574.sun = _a1832.sun
_a1568("")
_a1568("──── 이벤트 럭 ────")
_a1568("  머신 활성   " .. (_a1832.enabled and "O" or "X"))
_a1568("  최대 시간   " .. _a1600(_a1832.maxSec))
_a1568("  Sunflowers  " .. _a1569(_a1832.sun, 0))
_a1568("")
for _a1833, _a1834 in ipairs(_a1832.rows) do
_a1568(("  %-12s %-14s 부족 %-14s 필요 %s개%s"):format(
_a1834.rarity, _a1600(_a1834.left), _a1600(_a1834.deficit), _a1569(_a1834.need, 0),
_a1834.on and "" or "   (꺼짐)"))
end
_a1568("")
_a1568("  효과 : 비활성 0.5배 → 활성 1.0배 (2배)")
_a1658("log")
end },
{ label = "지금 1회 충전", col = _a1616.cardHi, fn = function()
task.spawn(function() _a1573.luck = true _a1601() _a1573.luck = false _a1658("log") end)
end },
})
end
do
local _a1835, _a1836 = _a1691(_a1755, "자동 씨앗 교체", nil)
_a1701(_a1836, "crop", function()
_a1615("crop", function() return _a1571.CropInterval end, _a1590, "씨앗")
end)
_a1712(_a1835, {
{ label = "주기", value = _a1571.CropInterval, onChange = function(_a1837)
local _a1838 = tonumber(_a1837) if _a1838 and _a1838 >= 5 then _a1571.CropInterval = _a1838 end
end },
{ label = "갈아엎기 배수", value = _a1571.CropMargin, onChange = function(_a1839)
local _a1840 = tonumber(_a1839) if _a1840 and _a1840 >= 1 then _a1571.CropMargin = _a1840 _a1568("[설정] 작물 배수 " .. _a1840) end
end },
})
_a1731(_a1835, "성장중 건너뛰기",
function() return _a1571.SkipUnhatched end,
function(_a1841) _a1571.SkipUnhatched = _a1841 end)
_a1721(_a1835, {
{ label = "밭 현황 보기", col = _a1616.accent, fn = function()
local _a1842, _a1843 = _a1576()
if not _a1843 then _a1568("[씨앗] 밭 없음") _a1658("log") return end
local _a1844, _a1845 = _a1587(_a1843), _a1586()
_a1568("")
_a1568("──── 밭 현황 ────")
_a1568("보유 씨앗 (기대 초당수익 순)")
for _a1846, _a1847 in ipairs(_a1845) do
_a1568(("  %-10s %-8s ×%-6s  기대 %s/s"):format(
tostring(_a1847.id), tostring(_a1847.vr or "-"), tostring(_a1847.am), _a1569(_a1847.exp)))
end
local _a1848, _a1849, _a1850, _a1851, _a1852 = 0, 0, 0, 0, 0
local _a1853 = _a1845[1]
local _a1854 = _a1853 and _a1853.exp or 0
_a1568("")
_a1568("심어진 작물")
local _a1855 = 0
for _a1856, _a1857 in pairs(_a1844) do
_a1848 += 1
local _a1858 = _a1589(_a1857) or 0
_a1849 += _a1858
if _a1588(_a1857) then _a1851 += 1
elseif _a1854 > _a1858 * _a1571.CropMargin then _a1850 += 1
else _a1852 += 1 end
_a1855 += 1
if _a1855 <= 20 then
_a1568(("  칸%-4s %-20s %s/s%s"):format(tostring(_a1856),
tostring(rawget(_a1857, "sp") or "?"), _a1569(_a1858),
_a1588(_a1857) and "  (자라는 중)" or ""))
end
end
if _a1848 > 20 then _a1568("  ... (" .. (_a1848 - 20) .. "칸 더)") end
_a1568("")
_a1568(("총 %d칸 / 합계 %s per sec"):format(_a1848, _a1569(_a1849)))
_a1568(("갈아엎기 대상 %d / 유지 %d / 자라는 중 %d"):format(_a1850, _a1852, _a1851))
_a1658("log")
end },
{ label = "지금 1회 실행", col = _a1616.cardHi, fn = function()
task.spawn(function() _a1573.crop = true _a1590() _a1573.crop = false _a1658("log") end)
end },
})
end
do
local _a1859, _a1860 = _a1691(_a1755, "자동 확장", nil)
_a1701(_a1860, "expand", function()
_a1615("expand", function() return _a1571.ExpandInterval end, _a1593, "확장")
end)
_a1712(_a1859, {
{ label = "주기", value = _a1571.ExpandInterval, onChange = function(_a1861)
local _a1862 = tonumber(_a1861) if _a1862 and _a1862 >= 5 then _a1571.ExpandInterval = _a1862 end
end },
{ label = "밭칸 스캔", value = _a1571.MaxBedScan, onChange = function(_a1863)
local _a1864 = tonumber(_a1863) if _a1864 and _a1864 >= 1 then _a1571.MaxBedScan = math.floor(_a1864) end
end },
})
_a1721(_a1859, {
{ label = "확장 현황 보기", col = _a1616.accent, fn = function()
local _a1865, _a1866, _a1867, _a1868 = _a1576()
if not _a1866 then _a1568("[확장] 밭 없음") _a1658("log") return end
local _a1869 = _a1582()
_a1574.sun = _a1869
local _a1870 = _a1591(true)
_a1568("")
_a1568("──── 확장 현황 ────")
_a1568("Sunflowers = " .. _a1569(_a1869, 0))
_a1568("")
_a1568("레인 " .. tostring(_a1868) .. "개 열림")
local _a1871 = {}
for _a1872 in pairs(_a1870) do _a1871[#_a1871 + 1] = tonumber(_a1872) or _a1872 end
table.sort(_a1871, function(_a1873, _a1874) return tostring(_a1873) < tostring(_a1874) end)
for _a1875, _a1876 in ipairs(_a1871) do
local _a1877 = _a1870[_a1876] or _a1870[tostring(_a1876)]
local _a1878 = tonumber(_a1876) or 0
local _a1879 = (_a1878 == (tonumber(_a1868) or 0) + 1)
and ((tonumber(_a1877) or math.huge) <= _a1869 and "  ← 지금 오픈 가능" or "  ← 다음 (돈 부족)")
or (_a1878 <= (tonumber(_a1868) or 0) and "  (열림)" or "")
_a1568(("  레인 %-3s %s%s"):format(tostring(_a1876), _a1569(tonumber(_a1877) or 0, 0), _a1879))
end
local _a1880 = _a1592(_a1866)
_a1568("")
_a1568("잠긴 밭칸 " .. #_a1880 .. "개 (싼 순 8개)")
for _a1881 = 1, math.min(8, #_a1880) do
local _a1882 = _a1880[_a1881]
_a1568(("  칸 %-4s %s%s"):format(_a1882.id, _a1882.cost and _a1569(_a1882.cost, 0) or "?",
(_a1882.cost and _a1882.cost <= _a1869) and "  ← 오픈 가능" or ""))
end
if #_a1880 == 0 then _a1568("  (전부 열려 있음)") end
_a1658("log")
end },
{ label = "지금 1회 실행", col = _a1616.cardHi, fn = function()
task.spawn(function() _a1573.expand = true _a1593() _a1573.expand = false _a1658("log") end)
end },
})
end
do
local _a1883, _a1884 = _a1691(_a1755, "자동 리버스", nil)
_a1701(_a1884, "rebirth", function()
_a1615("rebirth", function() return _a1571.RebirthInterval end, _a1595, "리버스")
end)
_a1712(_a1883, {
{ label = "주기", value = _a1571.RebirthInterval, onChange = function(_a1885)
local _a1886 = tonumber(_a1885) if _a1886 and _a1886 >= 10 then _a1571.RebirthInterval = _a1886 end
end },
})
_a1721(_a1883, {
{ label = "리버스 현황 보기", col = _a1616.accent, fn = function()
local _a1887 = _a1594()
_a1568("")
_a1568("──── 리버스 현황 ────")
if not _a1887 then _a1568("  밭 없음") _a1658("log") return end
_a1568(("  현재 리버스   %d회  (최대 %s)"):format(_a1887.regrows, tostring(_a1887.cap)))
_a1568(("  레인          %d / 7 %s"):format(_a1887.lanes, _a1887.lanes >= 7 and "OK" or "부족"))
_a1568(("  코인보스      %d / %d %s"):format(_a1887.kills, _a1887.need,
_a1887.kills >= _a1887.need and "OK" or "부족"))
_a1568("")
_a1568(_a1887.ready and "  ★ 지금 리버스 가능" or ("  대기 — " .. tostring(_a1887.reason)))
_a1658("log")
end },
{ label = "지금 1회 리버스", col = _a1616.bad, fn = function()
task.spawn(function() _a1573.rebirth = true _a1595() _a1573.rebirth = false _a1658("log") end)
end },
})
end
local _a1888 = _a1675("main", "메인 게임", 30)
do
local _a1889, _a1890 = _a1691(_a1888, "올 자동", nil)
local _a1891 = _a1617("Frame", {
Size = UDim2.new(1, 0, 0, 108), BackgroundColor3 = _a1616.cardHi,
BorderSizePixel = 0, LayoutOrder = _a1686(),
}, _a1889)
_a1624(_a1891, 6)
_a1631(_a1891, 8)
local _a1892 = _a1617("TextLabel", {
Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
Font = Enum.Font.Code, TextSize = 12, TextColor3 = _a1616.text,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Text = "정지", RichText = true,
}, _a1891)
task.spawn(function()
while _a1634 and _a1634.Parent do
local _a1893 = _a1603.ctl.now
local _a1894 = _a1573.auto and "🟢" or "⚪"
local _a1895 = _a1893.act or "-"
if _a1893.detail and _a1893.detail ~= "" then _a1895 = _a1895 .. "  " .. _a1893.detail end
_a1892.Text = table.concat({
_a1894 .. " " .. (_a1573.auto and (_a1893.step or "-") or "정지"),
"▸ " .. _a1895,
"목표 " .. (_a1893.goal or "-") .. (_a1893.prog ~= "" and ("   " .. _a1893.prog) or ""),
"1.리버스 " .. (_a1603.auto.rebNote or "-"),
"2.존해금 " .. (_a1603.auto.zoneNote or "-"),
"파밍대상 " .. tostring(_a1603.auto.farmZone or "-") .. "   현재 " .. tostring(_a1603.auto.hereZone or "-"),
}, "\n")
task.wait(0.2)
end
end)
function _a1603.auto.start()
for _a1896, _a1897 in ipairs(_a1603.auto.STEPS) do _a1573[_a1897.run] = false end
for _a1898, _a1899 in ipairs(_a1603.auto.SIDE) do _a1573[_a1899.run] = false end
_a1573.petspd = true
_a1573.rewatch = true
_a1698()
_a1615("auto", function() return _a1571.AutoInterval end, _a1603.auto.master, "자동")
end
_a1701(_a1890, "auto", _a1603.auto.start)
_a1712(_a1889, {
{ label = "주기", value = _a1571.AutoInterval, onChange = function(_a1900)
local _a1901 = tonumber(_a1900) if _a1901 and _a1901 >= 1 then _a1571.AutoInterval = _a1901 end
end },
{ label = "정체 판정(초)", value = _a1571.PursueStallSec, onChange = function(_a1902)
local _a1903 = tonumber(_a1902) if _a1903 and _a1903 >= 10 then _a1571.PursueStallSec = _a1903 end
end },
})
_a1712(_a1889, {
{ label = "운 퀘 최소 알 개수", value = _a1571.HatchMinAfford, onChange = function(_a1904)
local _a1905 = tonumber(_a1904) if _a1905 and _a1905 >= 1 then _a1571.HatchMinAfford = math.floor(_a1905) end
end },
{ label = "더 버는 시간(초)", value = _a1571.MoneyDwell, onChange = function(_a1906)
local _a1907 = tonumber(_a1906) if _a1907 and _a1907 >= 0 then _a1571.MoneyDwell = _a1907 end
end },
})
_a1712(_a1889, {
{ label = "부화 한 번에(초)", value = _a1571.HatchBudget, onChange = function(_a1908)
local _a1909 = tonumber(_a1908) if _a1909 and _a1909 >= 3 then _a1571.HatchBudget = _a1909 end
end },
})
_a1712(_a1889, {
{ label = "이동 방식", value = _a1571.TpMode, onChange = function(_a1910)
_a1910 = tostring(_a1910 or ""):lower()
if _a1910 == "instant" or _a1910 == "glide" or _a1910 == "walk" then _a1571.TpMode = _a1910 end
end },
{ label = "glide 속도", value = _a1571.TpSpeed, onChange = function(_a1911)
local _a1912 = tonumber(_a1911) if _a1912 and _a1912 >= 16 then _a1571.TpSpeed = _a1912 end
end },
})
_a1731(_a1889, "차단 화면에 실제 클릭까지 시도",
function() return _a1571.ScreenRealClick end,
function(_a1913) _a1571.ScreenRealClick = _a1913 end)
_a1731(_a1889, "퀘스트 없을 때도 알 까기",
function() return _a1571.IdleHatch end,
function(_a1914) _a1571.IdleHatch = _a1914 end)
_a1731(_a1889, "존 해금·리버스는 퀘스트 끝나고",
function() return _a1571.HoldZoneForQuest end,
function(_a1915) _a1571.HoldZoneForQuest = _a1915 end)
for _a1916, _a1917 in ipairs(_a1603.auto.STEPS) do
local _a1918 = _a1917.key
_a1731(_a1889, "  " .. _a1916 .. ". " .. _a1917.label,
function() return _a1571.StepOn[_a1918] end,
function(_a1919) _a1571.StepOn[_a1918] = _a1919 end)
end
for _a1920, _a1921 in ipairs(_a1603.auto.SIDE) do
local _a1922 = _a1921.key
_a1731(_a1889, "  · " .. _a1921.label .. " (순위 밖)",
function() return _a1571.StepOn[_a1922] end,
function(_a1923) _a1571.StepOn[_a1922] = _a1923 end)
end
_a1721(_a1889, {
{ label = "지금 상태", col = _a1616.accent, fn = function()
_a1568("")
_a1568("──── 올 자동 ────")
_a1568("  " .. (_a1573.auto and "돌아가는 중" or "정지") ..
(_a1603.auto.step and ("   지금: " .. _a1603.auto.step) or ""))
local _a1924, _a1925 = _a1603.quest.bestDepActive()
_a1568("  현재 존 " .. tostring(_a1603.move.curZone()) .. " / 최고 존 " .. tostring(_a1603.move.bestZone()))
if _a1924 then
_a1568("  ⏸ 존해금·리버스 보류 중 — " .. tostring(_a1925 and _a1925.title))
else
_a1568("  존해금·리버스 진행 가능")
end
_a1568("")
_a1568("  먼저 (순위 밖):")
for _a1926, _a1927 in ipairs(_a1603.auto.SIDE) do
_a1568(("      %-16s %s"):format(_a1927.label, _a1571.StepOn[_a1927.key] and "ON" or "off"))
end
_a1568("  우선순위:")
for _a1928, _a1929 in ipairs(_a1603.auto.STEPS) do
_a1568(("    %d. %-16s %s%s"):format(_a1928, _a1929.label,
_a1571.StepOn[_a1929.key] and "ON" or "off",
_a1929.hold and "   (퀘스트 붙잡는 중엔 보류)" or ""))
end
_a1658("log")
end },
{ label = "화면 넘기기 진단", col = _a1616.warn, fn = function()
task.spawn(function()
_a1568("")
_a1568("──── 보상 화면 ────")
local _a1930 = _a1602.Vars
_a1568("  Library.Variables : " .. (_a1930 and "로드됨" or "없음"))
if _a1930 then
_a1568("    IsRebirthing = " .. tostring(rawget(_a1930, "IsRebirthing")))
_a1568("    IsRankingUp  = " .. tostring(rawget(_a1930, "IsRankingUp")))
_a1568("    OpeningEgg   = " .. tostring(rawget(_a1930, "OpeningEgg")))
end
_a1568("  debug.info     : " .. tostring(type(debug) == "table" and type(debug.info) == "function"))
_a1568("  getgc          : " .. tostring(type(getgc) == "function"))
_a1568("  debug.setupvalue: " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
local _a1931 = _a1566:FindFirstChildOfClass("PlayerGui")
if _a1931 then
_a1568("  떠 있는 차단 화면:")
local _a1932 = false
for _a1933, _a1934 in ipairs(_a1603.screen.BLOCKERS) do
local _a1935 = _a1931:FindFirstChild(_a1934[1])
_a1568(("    %-14s %s"):format(_a1934[1],
_a1935 and (_a1935.Enabled and "★ 켜짐" or "꺼짐") or "없음"))
if _a1935 and _a1935.Enabled then _a1932 = true end
end
if not _a1932 then _a1568("    (없음)") end
end
if type(getgc) == "function" and type(debug) == "table" and debug.info then
_a1568("")
_a1568("  Rebirth/RankUp 스크립트의 클로저 시그니처:")
local _a1936, _a1937 = {}, 0
for _a1938, _a1939 in ipairs({ true, false }) do
local _a1940, _a1941 = pcall(getgc, _a1939)
if _a1940 then
for _a1942, _a1943 in ipairs(_a1941) do
if type(_a1943) == "function" and _a1937 < 25 then
local _a1944, _a1945 = pcall(debug.info, _a1943, "s")
if _a1944 and type(_a1945) == "string"
and (_a1945:find("Rebirth", 1, true) or _a1945:find("Rank Up", 1, true)) then
local _a1946, _a1947 = pcall(debug.info, _a1943, "a")
if _a1946 then
local _a1948 = {}
for _a1949 = 1, 16 do
local _a1950, _a1951 = pcall(debug.getupvalue, _a1943, _a1949)
if not _a1950 then break end
_a1948[_a1949] = type(_a1951)
end
local _a1952 = ("인자%d | %s"):format(_a1947 or -1,
#_a1948 > 0 and table.concat(_a1948, ",") or "(없음)")
if not _a1936[_a1952] then
_a1936[_a1952] = true
_a1937 += 1
_a1568("    " .. _a1952)
end
end
end
end
end
end
end
if _a1937 == 0 then _a1568("    (하나도 못 찾음)") end
end
for _a1953, _a1954 in ipairs({ "reward", "egg", "mastery", "card" }) do
_a1603.screen._sig = nil
local _a1955 = _a1603.screen.findSignalFns(_a1954)
_a1568("")
_a1568(("  [%s] 찾은 함수 %d개"):format(_a1954, #_a1955))
for _a1956, _a1957 in ipairs(_a1955) do
_a1568(("    %s%s"):format(_a1957.exact and "★정확일치 " or "", tostring(_a1957.src)))
_a1568(("       upvalue %d개 : %s"):format(_a1957.n or 0, tostring(_a1957.sig)))
end
if #_a1955 == 0 then
_a1568("    (getgc 로 그 스크립트의 클로저를 못 찾음)")
end
local _a1958, _a1959 = _a1603.screen.signal(_a1954)
_a1568(("    upvalue 신호 : %s (%s개 세팅)"):format(tostring(_a1958), tostring(_a1959)))
local _a1960 = _a1603.screen.SIGNAL[_a1954]
_a1568(("    게임내 입력발동 : %s"):format(
tostring(_a1603.screen.pressInGame(_a1960 and _a1960.pats or {}))))
end
_a1568("")
_a1568("  감시 루프 RUN.rewatch = " .. tostring(_a1573.rewatch))
_a1658("log")
end)
end },
{ label = "한 바퀴만", col = _a1616.cardHi, fn = function()
task.spawn(function()
_a1573.auto = true _a1603.auto.master() _a1573.auto = false _a1658("log")
end)
end },
{ label = "자동 점검", col = _a1616.warn, fn = function()
task.spawn(function()
_a1568("")
_a1568("════ 올 자동 점검 ════")
_a1568("  RUN.auto = " .. tostring(_a1573.auto))
local _a1961 = {}
for _a1962, _a1963 in ipairs(_a1603.auto.SIDE) do
_a1961[#_a1961 + 1] = _a1963.key .. "=" .. tostring(_a1571.StepOn[_a1963.key])
end
for _a1964, _a1965 in ipairs(_a1603.auto.STEPS) do
_a1961[#_a1961 + 1] = _a1965.key .. "=" .. tostring(_a1571.StepOn[_a1965.key])
end
_a1568("  단계 ON/OFF : " .. table.concat(_a1961, "  "))
_a1568("  lockGoal    : " .. (_a1603.ctl.lockGoal and tostring(_a1603.ctl.lockGoal.q.title) or "없음"))
local _a1966, _a1967 = _a1603.quest.bestDepActive()
_a1568("  보류중?     : " .. tostring(_a1966) .. (_a1967 and ("  ← " .. tostring(_a1967.title)) or ""))
_a1568("  리모트      : 존 " .. (_a1602.R_Zone and "O" or "X")
.. " / 리버스 " .. (_a1602.R_Reb and "O" or "X"))
_a1568("")
_a1568("  ── 존 해금 판정 ──")
local _a1968 = _a1607()
if not _a1968 then
_a1568("    zoneStatus() = nil  ← 다음 존을 못 구함")
local _a1969 = _a1602.Zone and rawget(_a1602.Zone, "GetNextZone")
if _a1969 then
local _a1970, _a1971, _a1972 = pcall(_a1602.Zone.GetNextZone)
_a1568("    GetNextZone → ok=" .. tostring(_a1970)
.. " / " .. tostring(_a1971) .. " / " .. tostring(_a1972))
end
if _a1602.Zone and rawget(_a1602.Zone, "HasCompletedNextZoneQuests") then
local _a1973, _a1974 = pcall(_a1602.Zone.HasCompletedNextZoneQuests)
_a1568("    존 퀘스트 완료? " .. (_a1973 and tostring(_a1974) or ("에러 " .. tostring(_a1974))))
end
else
_a1568("    다음 존 : " .. tostring(_a1968.id))
_a1568(("    가격 %s %s / 보유 %s → %s"):format(
_a1569(_a1968.price or 0, 0), tostring(_a1968.currency), _a1569(_a1968.have, 0),
_a1968.ok and "지금 살 수 있음" or "부족"))
end
_a1568("")
_a1568("  ── 리버스 판정 ──")
local _a1975 = _a1612()
if not _a1975 then _a1568("    세이브 못 읽음")
else
_a1568(("    현재 %d → 다음 %d"):format(_a1975.current, _a1975.nextN))
_a1568("    최근 사유 : " .. tostring(_a1603.auto.rebNote or "-"))
end
_a1568("")
_a1568("  ── 직전 바퀴 기록 ──")
if _a1603.auto.lastTrace and #_a1603.auto.lastTrace > 0 then
for _a1976, _a1977 in ipairs(_a1603.auto.lastTrace) do _a1568("    " .. _a1977) end
_a1568(("    (%.0f초 전)"):format(os.clock() - (_a1603.auto.lastPassAt or os.clock())))
else
_a1568("    아직 한 바퀴도 안 돌았음")
end
_a1658("log")
end)
end },
})
local _a1978, _a1979 = _a1691(_a1888, "펫 이동속도", nil)
_a1701(_a1979, "petspd", function()
_a1615("petspd", function() return 0.4 end, _a1603.item.applyPetSpeed, "펫속도")
end)
_a1712(_a1978, {
{ label = "배수", value = _a1571.PetSpeedMult, onChange = function(_a1980)
local _a1981 = tonumber(_a1980) if _a1981 and _a1981 >= 1 then _a1571.PetSpeedMult = _a1981 end
end },
{ label = "기본 계수 (원래 0.45)", value = _a1571.PetSpeedBase, onChange = function(_a1982)
local _a1983 = tonumber(_a1982) if _a1983 and _a1983 > 0 then _a1571.PetSpeedBase = _a1983 end
end },
})
_a1721(_a1978, {
{ label = "지금 적용 / 확인", col = _a1616.accent, fn = function()
local _a1984, _a1985 = _a1603.item.applyPetSpeed()
_a1568("")
_a1568("──── 펫 이동속도 ────")
_a1568("  PlayerPet 모듈 : " .. (_a1602.PlayerPet and "로드됨" or "없음"))
_a1568(("  적용된 펫 %d마리  (배수 %s / 계수 %s)"):format(
_a1984, tostring(_a1571.PetSpeedMult), tostring(_a1571.PetSpeedBase)))
if _a1985 then _a1568("  " .. tostring(_a1985)) end
if _a1984 == 0 then _a1568("  펫을 장착하고 다시 눌러보세요") end
_a1658("log")
end },
})
_a1615("petspd", function() return 0.4 end, _a1603.item.applyPetSpeed, "펫속도")
_a1615("rewatch", function() return 1 end, function()
_a1603.screen.watchTick = (_a1603.screen.watchTick or 0) + 1
if _a1603.screen.dismissBusy then return end
local _a1986, _a1987 = _a1603.screen.rewardScreenUp()
if _a1986 and _a1603.screen.screenGaveUp and (os.clock() - _a1603.screen.screenGaveUp) < 30 then
return
end
if _a1986 then
if _a1603.screen.lastBlocker ~= _a1987 then
_a1603.screen.lastBlocker = _a1987
_a1568("[화면] " .. tostring(_a1987) .. " 화면 감지 — 넘기는 중")
end
_a1603.screen.dismissRewardScreens(20)
end
end, "보상화면")
local _a1988, _a1989 = _a1691(_a1888, "자동 파밍 유지", nil)
_a1701(_a1989, "farm", function()
_a1615("farm", function() return _a1571.FarmInterval end, _a1606, "파밍")
end)
_a1712(_a1988, {
{ label = "주기", value = _a1571.FarmInterval, onChange = function(_a1990)
local _a1991 = tonumber(_a1990) if _a1991 and _a1991 >= 3 then _a1571.FarmInterval = _a1991 end
end },
})
local _a1992, _a1993 = _a1691(_a1888, "자동 존 해금", nil)
_a1701(_a1993, "zone", function()
_a1615("zone", function() return _a1571.ZoneInterval end, _a1608, "존")
end)
_a1712(_a1992, {
{ label = "주기", value = _a1571.ZoneInterval, onChange = function(_a1994)
local _a1995 = tonumber(_a1994) if _a1995 and _a1995 >= 3 then _a1571.ZoneInterval = _a1995 end
end },
})
_a1721(_a1992, {
{ label = "다음 존 보기", col = _a1616.accent, fn = function()
local _a1996 = _a1607()
_a1568("")
if not _a1996 then _a1568("[존] 다음 존 없음 (최대 도달?)")
else
_a1568("──── 다음 존 ────")
_a1568("  " .. tostring(_a1996.id))
_a1568("  가격 " .. _a1569(_a1996.price or 0, 0) .. " " .. tostring(_a1996.currency))
_a1568("  보유 " .. _a1569(_a1996.have, 0))
_a1568("  " .. (_a1996.ok and "지금 해금 가능" or "부족"))
end
_a1658("log")
end },
{ label = "지금 1회", col = _a1616.cardHi, fn = function()
task.spawn(function() _a1573.zone = true _a1608() _a1573.zone = false _a1658("log") end)
end },
})
local _a1997, _a1998 = _a1691(_a1888, "자동 부화", nil)
_a1701(_a1998, "mhatch", function()
_a1615("mhatch", function() return _a1571.MainHatchInterval end, _a1611, "부화")
end)
_a1712(_a1997, {
{ label = "주기", value = _a1571.MainHatchInterval, onChange = function(_a1999)
local _a2000 = tonumber(_a1999) if _a2000 and _a2000 >= 1 then _a1571.MainHatchInterval = _a2000 end
end },
{ label = "한 번에 최대", value = _a1571.MainHatchMax, onChange = function(_a2001)
local _a2002 = tonumber(_a2001) if _a2002 and _a2002 >= 1 then _a1571.MainHatchMax = math.floor(_a2002) end
end },
})
_a1712(_a1997, {
{ label = "예비금", value = _a1571.MainHatchReserve, onChange = function(_a2003)
local _a2004 = tonumber(_a2003) if _a2004 and _a2004 >= 0 then _a1571.MainHatchReserve = _a2004 end
end },
{ label = "알 ID (비우면 자동)", value = _a1571.MainEggId, onChange = function(_a2005)
_a1571.MainEggId = _a2005 or ""
end },
})
_a1712(_a1997, {
{ label = "알 인식 거리", value = _a1571.EggRange, onChange = function(_a2006)
local _a2007 = tonumber(_a2006) if _a2007 and _a2007 >= 5 then _a1571.EggRange = _a2007 end
end },
})
_a1731(_a1997, "새 맵 열리면 잠긴 알 자동 해금",
function() return _a1571.AutoUnlockEgg end,
function(_a2008) _a1571.AutoUnlockEgg = _a2008 end)
_a1731(_a1997, "게임 내장 오토해치 사용 (기본 끔)",
function() return _a1571.UseAutoHatch end,
function(_a2009) _a1571.UseAutoHatch = _a2009 if not _a2009 then _a1603.egg.autoHatchOff() end end)
_a1731(_a1997, "까는 화면 자동으로 넘기기 (신호)",
function() return _a1571.HatchClick end,
function(_a2010) _a1571.HatchClick = _a2010 end)
_a1721(_a1997, {
{ label = "잠긴 알 보기", col = _a1616.accent, fn = function()
local _a2011, _a2012, _a2013 = _a1603.egg.lockedEggs()
_a1568("")
_a1568("──── 알 해금 현황 ────")
_a1568(("  해금 가능 최대 : #%d   /   현재 해금한 최대 : #%d"):format(_a2012, _a2013))
_a1568("  해금 리모트 : " .. (_a1602.R_EggUn and "있음" or "없음"))
if #_a2011 == 0 then
_a1568("  풀 수 있는 알이 없음 (다 풀었거나 존을 더 사야 함)")
else
_a1568("  아직 안 푼 알 " .. #_a2011 .. "개:")
for _a2014, _a2015 in ipairs(_a2011) do
_a1568(("    #%-3d %s"):format(_a2015.num, _a2015.id))
if _a2014 >= 20 then _a1568("    ...") break end
end
end
_a1658("log")
end },
{ label = "부화 진단", col = _a1616.warn, fn = function()
task.spawn(function()
_a1568("")
_a1568("──── 부화 진단 ────")
local _a2016, _a2017, _a2018, _a2019 = _a1609()
_a1568("  대상 알   : " .. tostring(_a2016))
if not _a2016 then _a1568("  (오픈한 알이 없음)") _a1658("log") return end
local _a2020 = _a2017 and tonumber(rawget(_a2017, "eggNumber"))
_a1568("  알 번호   : " .. tostring(_a2020) .. "   오픈함? " .. tostring(_a1603.egg.eggUnlocked(_a2020)))
_a1568("  거리      : " .. (_a2018 and ("%.0f (사거리 안)"):format(_a2018)
or ((_a2019 and ("%.0f (사거리 %d 밖)"):format(_a2019, _a1571.EggRange)) or "받침대 못 찾음")))
local _a2021 = _a2017 and rawget(_a2017, "currency") or "?"
_a1568("  통화      : " .. tostring(_a2021) .. "   보유 " .. _a1569(_a1605(_a2021), 0))
if type(_a1602.CalcEgg) == "function" then
local _a2022, _a2023 = pcall(_a1602.CalcEgg, _a2017)
_a1568("  CalcEggPricePlayer : " .. (_a2022 and tostring(_a2023) or ("에러 " .. tostring(_a2023))))
end
if type(_a1602.CalcEggB) == "function" then
local _a2024, _a2025 = pcall(_a1602.CalcEggB, _a2017)
_a1568("  CalcEggPrice       : " .. (_a2024 and tostring(_a2025) or ("에러 " .. tostring(_a2025))))
end
if _a1602.Egg then
for _a2026, _a2027 in ipairs({ "GetMaxHatch", "ComputeDebounce", "GetHighestEggNumberAvailable" }) do
if rawget(_a1602.Egg, _a2027) then
local _a2028, _a2029 = pcall(_a1602.Egg[_a2027], _a2017)
_a1568(("  %-28s : %s"):format(_a2027, _a2028 and tostring(_a2029) or ("에러 " .. tostring(_a2029))))
end
end
end
_a1568("  OpeningEgg      : " .. tostring(_a1602.Vars and rawget(_a1602.Vars, "OpeningEgg")))
if _a1602.Hatch then
for _a2030, _a2031 in ipairs({ "IsHatching", "GetEggAmount" }) do
if rawget(_a1602.Hatch, _a2031) then
local _a2032, _a2033 = pcall(_a1602.Hatch[_a2031])
_a1568(("  %-15s : %s"):format(_a2031, _a2032 and tostring(_a2033) or ("에러 " .. tostring(_a2033))))
end
end
if rawget(_a1602.Hatch, "GetEggDirectory") then
local _a2034, _a2035 = pcall(_a1602.Hatch.GetEggDirectory)
_a1568("  세팅된 알       : " .. (_a2034 and _a2035 and tostring(rawget(_a2035, "_id")) or "없음"))
end
end
_a1568("  ▶ SetupEgg 시도")
_a1603.egg._ahEgg = nil
_a1603.egg.autoHatchOn(_a2016, 1)
if _a1602.Hatch and rawget(_a1602.Hatch, "IsHatching") then
local _a2036, _a2037 = pcall(_a1602.Hatch.IsHatching)
_a1568("    IsHatching 이후 : " .. (_a2036 and tostring(_a2037) or ("에러 " .. tostring(_a2037))))
_a1568("    " .. ((_a2036 and _a2037) and "→ 클릭 없이 넘어갑니다"
or "→ SetupEgg 안 먹음. 클릭 대체가 필요합니다"))
end
_a1568("  신호 가능 : getgc " .. tostring(type(getgc) == "function")
.. " / debug.setupvalue " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
_a1568("")
_a1568("  ▶ 1개로 실제 호출")
local _a2038, _a2039
local _a2040 = pcall(function() _a2038, _a2039 = _a1570.R_EGG:InvokeServer(_a2016, 1) end)
_a1568("    호출성공 : " .. tostring(_a2040))
_a1568("    반환1    : " .. tostring(_a2038))
_a1568("    반환2    : " .. tostring(_a2039))
_a1658("log")
end)
end },
{ label = "지금 전부 해금", col = _a1616.good, fn = function()
task.spawn(function()
_a1568("")
local _a2041, _a2042 = _a1603.egg.unlockEggs(true)
_a1568(_a2041 > 0 and ("[해금] %d개 완료"):format(_a2041)
or ("[해금] 0개" .. (_a2042 and (" — " .. tostring(_a2042)) or "")))
_a1658("log")
end)
end },
})
_a1721(_a1997, {
{ label = "알 현황 보기", col = _a1616.accent, fn = function()
local _a2043 = _a1610()
_a1568("")
if not _a2043 then _a1568("[부화] 알을 못 찾음")
else
_a1568("──── 메인 알 ────")
_a1568("  " .. tostring(_a2043.id))
_a1568("  가격 " .. (_a2043.price and _a1569(_a2043.price, 0) or "?") .. " " .. tostring(_a2043.currency))
_a1568("  보유 " .. _a1569(_a2043.have, 0))
_a1568("  한 번에 " .. _a2043.maxN .. "개까지")
_a1568("  지금 가능 " .. _a2043.canBuy .. "회")
if _a2043.inRange then
_a1568(("  거리 %.0f 스터드 — 부화 가능"):format(_a2043.dist))
else
_a1568(("  사거리(%d) 안에 알 없음. 가장 가까운 알 %s스터드"):format(
_a1571.EggRange, _a2043.nearest and ("%.0f"):format(_a2043.nearest) or "?"))
_a1568("  → 알 앞으로 걸어가야 부화됩니다")
end
end
_a1568("")
_a1568("──── 주변 알 (가까운 순 10개) ────")
local _a2044 = _a1603.egg.eggStands()
for _a2045 = 1, math.min(10, #_a2044) do
local _a2046 = _a2044[_a2045]
_a1568(("  %6.0f  #%-3d %-24s %s"):format(
_a2046.dist, _a2046.num, _a2046.id, _a1603.egg.eggUnlocked(_a2046.num) and "오픈함" or "잠김"))
end
if #_a2044 == 0 then _a1568("  (못 찾음)") end
_a1658("log")
end },
{ label = "지금 1회", col = _a1616.cardHi, fn = function()
task.spawn(function() _a1573.mhatch = true _a1611() _a1573.mhatch = false _a1658("log") end)
end },
})
local _a2047, _a2048 = _a1691(_a1888, "랭크 퀘스트 자동", nil)
_a1701(_a2048, "quest", function()
_a1615("quest", function() return _a1571.QuestInterval end, _a1603.quest.cycle, "퀘스트")
end)
_a1712(_a2047, {
{ label = "주기", value = _a1571.QuestInterval, onChange = function(_a2049)
local _a2050 = tonumber(_a2049) if _a2050 and _a2050 >= 5 then _a1571.QuestInterval = _a2050 end
end },
{ label = "포션 한 번에", value = _a1571.QuestUseMax, onChange = function(_a2051)
local _a2052 = tonumber(_a2051) if _a2052 and _a2052 >= 1 then _a1571.QuestUseMax = math.floor(_a2052) end
end },
})
_a1731(_a2047, "필요한 자동화 자동 ON",
function() return _a1571.QuestDrive end,
function(_a2053) _a1571.QuestDrive = _a2053 end)
_a1731(_a2047, "포션/인챈트 업글 퀘스트",
function() return _a1571.QuestUpgrade end,
function(_a2054) _a1571.QuestUpgrade = _a2054 end)
_a1731(_a2047, "포션 사용 퀘스트",
function() return _a1571.QuestUsePotion end,
function(_a2055) _a1571.QuestUsePotion = _a2055 end)
_a1721(_a2047, {
{ label = "퀘스트 현황 보기", col = _a1616.accent, fn = function()
local _a2056 = _a1603.quest.status()
_a1568("")
if not _a2056 then _a1568("[퀘스트] 세이브 못 읽음")
else
_a1568("──── 랭크 퀘스트 ────")
_a1568(("  Rank %d   ★%d"):format(_a2056.rank, _a2056.rankStars))
if #_a2056.list == 0 then _a1568("  퀘스트 없음") end
for _a2057, _a2058 in ipairs(_a2056.list) do
local _a2059 = _a2058.how
local _a2060 =
(_a2059 == "farm" and "자동 파밍") or
(_a2059 == "hatch" and "자동 부화") or
(_a2059 == "zone" and "자동 존") or
(_a2059 == "potup" and "포션 업글") or
(_a2059 == "encup" and "인챈트 업글") or
(_a2059 == "potuse" and "포션 사용") or
(_a2059 == "fruituse" and "과일 사용") or
(_a2059 == "flaguse" and "깃발 사용") or
(_a2059 == "gold" and "골드 머신") or
(_a2059 == "rainbow" and "레인보우 머신") or
"수동"
local _a2061 = ""
if _a2058.ignored then
_a2060 = "무시"
_a2061 = "   → " .. _a2058.ignored
elseif _a2058.event then
local _a2062 = _a1603.ev.findEvent(_a2058.event, _a2058.bestOnly)
_a2061 = _a2062 and ("   → %s @%s %d초"):format(_a2062.name, tostring(_a2062.zone), _a2062.left)
or ("   → " .. _a2058.event .. " 대기중")
elseif _a2058.chest then
_a2061 = "   → " .. _a2058.chest
elseif _a2058.where then
_a2061 = "   → " .. _a2058.where
end
_a1568(("  [%d] %s"):format(_a2058.stars, tostring(_a2058.title)))
_a1568(("       %d / %d    처리: %s   (Type %d)%s"):format(
_a2058.progress, _a2058.amount, _a2060, _a2058.type, _a2061))
end
end
_a1658("log")
end },
{ label = "활성 이벤트 보기", col = _a1616.accent, fn = function()
local _a2063 = _a1603.ev.events()
local _a2064 = _a1603.move.bestZone()
_a1568("")
_a1568("──── 지금 떠 있는 랜덤 이벤트 ────")
_a1568("  최고 존 : " .. tostring(_a2064) .. "   현재 존 : " .. tostring(_a1603.move.curZone()))
if #_a2063 == 0 then _a1568("  없음 (RandomEvents_Get 응답 비어있음)") end
for _a2065, _a2066 in ipairs(_a2063) do
_a1568(("  %-12s @%-20s %4d초 남음  %s%s"):format(
_a2066.kind, tostring(_a2066.zone), _a2066.left,
_a2066.pos and ("(%.0f, %.0f, %.0f)"):format(_a2066.pos.X, _a2066.pos.Y, _a2066.pos.Z) or "좌표없음",
_a2066.zone == _a2064 and "  ★최고존" or ""))
end
_a1568("")
_a1568("  내 소환 아이템 :")
for _a2067 in pairs(_a1603.ev.SPAWN) do
local _a2068 = _a1603.ev.spawnItems(_a2067)
local _a2069 = 0
for _a2070, _a2071 in ipairs(_a2068) do _a2069 += _a2071.am end
_a1568(("    %-12s %d종 %d개"):format(_a2067, #_a2068, _a2069))
for _a2072, _a2073 in ipairs(_a2068) do
_a1568(("        %d. %-24s x%d%s"):format(
_a2072, _a2073.id, _a2073.am, _a2072 == 1 and "   ← 먼저 씀" or ""))
if _a2072 >= 6 then break end
end
end
_a1568("  점선 네모 안? " .. tostring(_a1603.move.inDottedBox()))
for _a2074, _a2075 in ipairs({ "MiniChests", "SuperiorMiniChests" }) do
local _a2076, _a2077 = _a1603.ev.findChest(_a2075)
_a1568(("  %-20s %s"):format(_a2075,
_a2076 and ("가장 가까운 것 %.0f스터드"):format(_a2077 or 0) or "없음"))
end
_a1658("log")
end },
{ label = "포션 재고 보기", col = _a1616.accent, fn = function()
_a1568("")
_a1568("──── 포션 / 인챈트 재고 ────")
for _a2078, _a2079 in ipairs({ "Potion", "Enchant" }) do
local _a2080 = _a1603.item.stacks(_a2079)
table.sort(_a2080, function(_a2081, _a2082)
if _a2081.id ~= _a2082.id then return _a2081.id < _a2082.id end
return _a2081.tier < _a2082.tier
end)
_a1568("")
_a1568(_a2079 .. "  (" .. #_a2080 .. "종)")
for _a2083, _a2084 in ipairs(_a2080) do
local _a2085 = _a1603.item.perTier(_a2079, _a2084.tier)
local _a2086 = _a2085 and math.floor(_a2084.am / _a2085) or 0
_a1568(("   %-20s T%-2d x%-6d %s"):format(
_a2084.id, _a2084.tier, _a2084.am,
_a2086 > 0 and ("→ T" .. (_a2084.tier + 1) .. " " .. _a2086 .. "개 제작가능") or ""))
if _a2083 >= 40 then _a1568("   ...") break end
end
if #_a2080 == 0 then _a1568("   (없음)") end
end
_a1658("log")
end },
{ label = "지금 1회", col = _a1616.cardHi, fn = function()
task.spawn(function() _a1573.quest = true _a1603.quest.cycle() _a1573.quest = false _a1658("log") end)
end },
})
local _a2087, _a2088 = _a1691(_a1888, "슬롯 머신 자동 (다이아)", nil)
_a1701(_a2088, "slots", function()
_a1615("slots", function() return _a1571.SlotInterval end, _a1603.mach.cycleSlots, "슬롯")
end)
_a1712(_a2087, {
{ label = "주기", value = _a1571.SlotInterval, onChange = function(_a2089)
local _a2090 = tonumber(_a2089) if _a2090 and _a2090 >= 5 then _a1571.SlotInterval = _a2090 end
end },
{ label = "남길 다이아", value = _a1571.SlotReserve, onChange = function(_a2091)
local _a2092 = tonumber(_a2091) if _a2092 and _a2092 >= 0 then _a1571.SlotReserve = _a2092 end
end },
})
_a1731(_a2087, "펫 장착 슬롯 (Pet Equip)",
function() return _a1571.SlotPet end, function(_a2093) _a1571.SlotPet = _a2093 end)
_a1731(_a2087, "알 부화 슬롯 (Egg Machine)",
function() return _a1571.SlotEgg end, function(_a2094) _a1571.SlotEgg = _a2094 end)
_a1721(_a2087, {
{ label = "슬롯 현황 보기", col = _a1616.accent, fn = function()
local _a2095 = _a1603.mach.slotStatus()
_a1568("")
_a1568("──── 슬롯 머신 ────")
if not _a2095 then _a1568("  세이브 못 읽음") _a1658("log") return end
_a1568("  다이아 " .. _a1569(_a2095.dia, 0))
_a1568("")
_a1568(("  펫 장착 : 구매 %d / 랭크상한 %d   현재 최대장착 %s"):format(
_a2095.petOwned, _a2095.petMax, tostring(_a2095.maxEquip)))
if _a2095.petNext then
_a1568(("     다음 #%d  %s 다이아  %s"):format(
_a2095.petNext, _a2095.petCost and _a1569(_a2095.petCost, 0) or "?",
(_a2095.petCost and _a2095.petCost <= _a2095.dia - _a1571.SlotReserve) and "← 지금 가능" or "부족"))
else
_a1568("     랭크 상한까지 다 삼 (랭크를 올려야 더 살 수 있음)")
end
_a1568("")
_a1568(("  알 부화 : 구매 %d / 랭크상한 %d   한 번에 %s개"):format(
_a2095.eggOwned, _a2095.eggMax, tostring(_a2095.maxHatch)))
if _a2095.eggEnd then
_a1568(("     다음 %d칸 묶음 → %d   %s 다이아  %s"):format(
_a2095.eggSize, _a2095.eggEnd, _a2095.eggCost and _a1569(_a2095.eggCost, 0) or "?",
(_a2095.eggCost and _a2095.eggCost <= _a2095.dia - _a1571.SlotReserve) and "← 지금 가능" or "부족"))
else
_a1568("     랭크 상한까지 다 삼")
end
_a1568("")
_a1568("  리모트 : 펫 " .. (_a1602.R_PetSlot and "O" or "X")
.. " / 알 " .. (_a1602.R_EggSlot and "O" or "X"))
_a1658("log")
end },
{ label = "지금 1회", col = _a1616.cardHi, fn = function()
task.spawn(function() _a1573.slots = true _a1603.mach.cycleSlots() _a1573.slots = false _a1658("log") end)
end },
})
local _a2096, _a2097 = _a1691(_a1888, "아이템 자동 사용 (버프 유지)", nil)
_a1701(_a2097, "items", function()
_a1615("items", function() return _a1571.ItemInterval end, _a1603.item.cycleItems, "아이템")
end)
_a1712(_a2096, {
{ label = "주기", value = _a1571.ItemInterval, onChange = function(_a2098)
local _a2099 = tonumber(_a2098) if _a2099 and _a2099 >= 5 then _a1571.ItemInterval = _a2099 end
end },
{ label = "포션 한 바퀴 최대", value = _a1571.BuffMaxPotion, onChange = function(_a2100)
local _a2101 = tonumber(_a2100) if _a2101 and _a2101 >= 1 then _a1571.BuffMaxPotion = math.floor(_a2101) end
end },
})
_a1712(_a2096, {
{ label = "남길 개수", value = _a1571.ItemKeep, onChange = function(_a2102)
local _a2103 = tonumber(_a2102) if _a2103 and _a2103 >= 0 then _a1571.ItemKeep = math.floor(_a2103) end
end },
{ label = "과일/소모품 최대", value = _a1571.BuffMaxOther, onChange = function(_a2104)
local _a2105 = tonumber(_a2104) if _a2105 and _a2105 >= 1 then _a1571.BuffMaxOther = math.floor(_a2105) end
end },
})
_a1712(_a2096, {
{ label = "쓸 것 (비우면 전부)", value = _a1571.ItemAllow, onChange = function(_a2106)
_a1571.ItemAllow = _a2106 or ""
end },
{ label = "제외", value = _a1571.ItemBlock, onChange = function(_a2107)
_a1571.ItemBlock = _a2107 or ""
end },
})
_a1731(_a2096, "포션", function() return _a1571.BuffPotion end,
function(_a2108) _a1571.BuffPotion = _a2108 end)
_a1731(_a2096, "과일", function() return _a1571.BuffFruit end,
function(_a2109) _a1571.BuffFruit = _a2109 end)
_a1731(_a2096, "얼티밋 (충전되면 발동, 무료)", function() return _a1571.BuffUltimate end,
function(_a2110) _a1571.BuffUltimate = _a2110 end)
_a1731(_a2096, "소모품 (Rain/Sunlight 주의)", function() return _a1571.BuffConsumable end,
function(_a2111) _a1571.BuffConsumable = _a2111 end)
_a1731(_a2096, "높은 티어부터 사용 (끄면 낮은 것부터)", function() return _a1571.BuffHighTier end,
function(_a2112) _a1571.BuffHighTier = _a2112 end)
_a1731(_a2096, "최고 존에서만 사용", function() return _a1571.ItemBestZone end,
function(_a2113) _a1571.ItemBestZone = _a2113 end)
_a1731(_a2096, "최고 존이 아니면 이동 후 사용", function() return _a1571.ItemTp end,
function(_a2114) _a1571.ItemTp = _a2114 end)
_a1721(_a2096, {
{ label = "버프 현황 보기", col = _a1616.accent, fn = function()
_a1568("")
_a1568("──── 버프 / 아이템 ────")
_a1568(("  현재 존 %s / 최고 존 %s%s"):format(
tostring(_a1603.move.curZone()), tostring(_a1603.move.bestZone()),
_a1571.ItemBestZone and (_a1603.move.curZone() == _a1603.move.bestZone() and "   ← 사용 가능" or "   ← 이동 필요") or ""))
for _a2115, _a2116 in pairs({ Potions = "Potion", Fruits = "Fruit" }) do
local _a2117 = _a1603.item.activeBuffs(_a2115)
local _a2118 = {}
for _a2119 in pairs(_a2117) do _a2118[#_a2118 + 1] = _a2119 end
table.sort(_a2118)
_a1568(("  지금 걸린 %s : %s"):format(_a2115,
#_a2118 > 0 and table.concat(_a2118, ", ") or "없음"))
end
local _a2120 = _a1604()
local _a2121 = _a2120 and rawget(_a2120, "Ultimates")
if type(_a2121) == "table" then
local _a2122 = {}
for _a2123 in pairs(_a2121) do
local _a2124 = "?"
if _a1602.Ult and rawget(_a1602.Ult, "IsCharged") then
local _a2125, _a2126 = pcall(_a1602.Ult.IsCharged, _a2123)
_a2124 = _a2125 and (_a2126 and "충전됨" or "충전중") or "?"
end
_a2122[#_a2122 + 1] = _a2123 .. "(" .. _a2124 .. ")"
end
_a1568("  얼티밋 : " .. (#_a2122 > 0 and table.concat(_a2122, ", ") or "없음"))
end
_a1568("")
for _a2127, _a2128 in ipairs({ "Potion", "Fruit", "Consumable" }) do
local _a2129 = _a1603.item.stacks(_a2128)
local _a2130, _a2131 = 0, 0
for _a2132, _a2133 in ipairs(_a2129) do
if _a1603.item.itemAllowed(_a2133.id) then _a2130 += 1 else _a2131 += 1 end
end
_a1568(("  %-12s %d종 (쓸 수 있음 %d / 제외 %d)"):format(_a2128, #_a2129, _a2130, _a2131))
for _a2134, _a2135 in ipairs(_a2129) do
_a1568(("      %-20s T%-2d x%-6d %s"):format(
_a2135.id, _a2135.tier, _a2135.am, _a1603.item.itemAllowed(_a2135.id) and "" or "제외됨"))
if _a2134 >= 12 then _a1568("      ...") break end
end
end
_a1568("")
_a1568("  리모트 : 포션 " .. (_a1602.R_PotUse and "O" or "X")
.. " / 과일 " .. (_a1602.R_Fruit and "O" or "X")
.. " / 소모품 " .. (_a1602.R_Cons and "O" or "X")
.. " / 얼티밋 " .. (_a1602.R_Ult and "O" or "X"))
_a1658("log")
end },
{ label = "지금 1회", col = _a1616.cardHi, fn = function()
task.spawn(function() _a1573.items = true _a1603.item.cycleItems() _a1573.items = false _a1658("log") end)
end },
})
local _a2136, _a2137 = _a1691(_a1888, "맵 업그레이드 자동 (다이아)", nil)
_a1701(_a2137, "mapupg", function()
_a1615("mapupg", function() return _a1571.UpgInterval end, _a1603.mach.cycleUpg, "맵업글")
end)
_a1712(_a2136, {
{ label = "주기", value = _a1571.UpgInterval, onChange = function(_a2138)
local _a2139 = tonumber(_a2138) if _a2139 and _a2139 >= 5 then _a1571.UpgInterval = _a2139 end
end },
{ label = "남길 다이아", value = _a1571.UpgReserve, onChange = function(_a2140)
local _a2141 = tonumber(_a2140) if _a2141 and _a2141 >= 0 then _a1571.UpgReserve = _a2141 end
end },
})
_a1731(_a2136, "구매 전 그 앞으로 이동",
function() return _a1571.UpgTp end,
function(_a2142) _a1571.UpgTp = _a2142 end)
_a1721(_a2136, {
{ label = "업그레이드 목록", col = _a1616.accent, fn = function()
local _a2143 = _a1603.mach.upgList()
local _a2144 = _a1605("Diamonds")
_a1568("")
_a1568("──── 맵 업그레이드 ────")
_a1568("보유 다이아 " .. _a1569(_a2144, 0))
if #_a2143 == 0 then
_a1568("  로드된 업그레이드 기둥이 없음 (해당 존에 가야 보입니다)")
end
local _a2145, _a2146, _a2147 = 0, 0, 0
for _a2148, _a2149 in ipairs(_a2143) do
if _a2149.bought then _a2146 += 1
elseif not _a2149.zoneOwned then _a2147 += 1
else _a2145 += 1 end
end
_a1568(("  구매가능 %d / 구매완료 %d / 존 미보유 %d"):format(_a2145, _a2146, _a2147))
_a1568("")
local _a2150 = 0
for _a2151, _a2152 in ipairs(_a2143) do
if _a2152.buyable then
_a2150 += 1
_a1568(("  %-12s T%-2d %-20s %12s %-9s %s"):format(
_a2152.id, _a2152.tier, _a2152.zone, _a2152.cost and _a1569(_a2152.cost, 0) or "?",
tostring(_a2152.cur),
(_a2152.cost and _a2152.cost <= _a1605(_a2152.cur or "Diamonds") - _a1571.UpgReserve)
and "← 지금 가능" or ""))
if _a2150 >= 25 then _a1568("  ...") break end
end
end
_a1658("log")
end },
{ label = "업글 진단", col = _a1616.warn, fn = function()
task.spawn(function()
_a1568("")
_a1568("──── 맵 업그레이드 진단 ────")
_a1568("  리모트 : " .. (_a1602.R_Upg and _a1602.R_Upg:GetFullName() or "없음"))
local _a2153 = _a1603.mach.upgList()
_a1568("  로드된 기둥 " .. #_a2153 .. "개")
local _a2154
for _a2155, _a2156 in ipairs(_a2153) do
if _a2156.buyable and _a2156.cost then _a2154 = _a2156 break end
end
if not _a2154 then
_a1568("  살 수 있는 게 없음 (전부 구매완료거나 존 미보유)")
for _a2157, _a2158 in ipairs(_a2153) do
_a1568(("   %-12s T%-2d @%-18s 구매됨=%s 존보유=%s"):format(
_a2158.id, _a2158.tier, tostring(_a2158.zone), tostring(_a2158.bought), tostring(_a2158.zoneOwned)))
if _a2157 >= 8 then _a1568("   ...") break end
end
_a1658("log") return
end
local _a2159 = _a1605(_a2154.cur or "Diamonds")
local _a2160 = _a1603.move.hrp()
local _a2161 = (_a2160 and _a2154.pos) and (_a2160.Position - _a2154.pos).Magnitude or nil
_a1568(("  대상 : %s T%d @%s"):format(_a2154.id, _a2154.tier, tostring(_a2154.zone)))
_a1568(("  가격 : %s %s / 보유 %s"):format(
_a1569(_a2154.cost, 0), tostring(_a2154.cur), _a1569(_a2159, 0)))
_a1568("  거리 : " .. (_a2161 and ("%.0f 스터드"):format(_a2161) or "좌표 없음"))
_a1568("")
_a1568("  ▶ 제자리에서 호출")
local _a2162, _a2163
local _a2164 = pcall(function() _a2162, _a2163 = _a1602.R_Upg:InvokeServer(_a2154.id, _a2154.zone) end)
_a1568("    호출성공 " .. tostring(_a2164) .. " / 반환1 " .. tostring(_a2162)
.. " / 반환2 " .. tostring(_a2163))
if not _a2162 and _a2154.pos then
_a1568("")
_a1568("  ▶ 기둥 앞으로 이동해서 재시도")
_a1603.move.glideTo(_a2154.pos)
task.wait(0.3)
local _a2165 = _a1603.move.hrp()
_a1568("    이동후 거리 " .. (_a2165 and ("%.0f"):format((_a2165.Position - _a2154.pos).Magnitude) or "?"))
local _a2166, _a2167
local _a2168 = pcall(function() _a2166, _a2167 = _a1602.R_Upg:InvokeServer(_a2154.id, _a2154.zone) end)
_a1568("    호출성공 " .. tostring(_a2168) .. " / 반환1 " .. tostring(_a2166)
.. " / 반환2 " .. tostring(_a2167))
_a1568("")
_a1568(_a2166 and "  → 거리 검사 있음. 이동해야 됩니다."
or "  → 이동해도 실패. 거리 문제가 아닙니다.")
else
_a1568("")
_a1568(_a2162 and "  → 원격으로 됩니다. 이동 불필요." or "  → 실패 (좌표 없음)")
end
_a1658("log")
end)
end },
{ label = "지금 1회", col = _a1616.cardHi, fn = function()
task.spawn(function() _a1573.mapupg = true _a1603.mach.cycleUpg() _a1573.mapupg = false _a1658("log") end)
end },
})
local _a2169, _a2170 = _a1691(_a1888, "자동 리버스", nil)
_a1701(_a2170, "mreb", function()
_a1615("mreb", function() return _a1571.MainRebirthInterval end, _a1613, "리버스")
end)
_a1712(_a2169, {
{ label = "주기", value = _a1571.MainRebirthInterval, onChange = function(_a2171)
local _a2172 = tonumber(_a2171) if _a2172 and _a2172 >= 10 then _a1571.MainRebirthInterval = _a2172 end
end },
})
_a1731(_a2169, "실패 이유 로그",
function() return _a1571.MainRebirthVerbose end,
function(_a2173) _a1571.MainRebirthVerbose = _a2173 end)
_a1721(_a2169, {
{ label = "리버스 현황 보기", col = _a1616.accent, fn = function()
local _a2174 = _a1612()
_a1568("")
if not _a2174 then _a1568("[리버스] 세이브 못 읽음")
else
_a1568("──── 메인 리버스 ────")
_a1568("  현재 " .. _a2174.current .. "회 → 다음 " .. _a2174.nextN)
if type(_a2174.def) == "table" then
for _a2175, _a2176 in pairs(_a2174.def) do
if type(_a2176) ~= "table" and type(_a2176) ~= "function" then
_a1568("    " .. tostring(_a2175) .. " = " .. tostring(_a2176))
end
end
end
end
_a1658("log")
end },
{ label = "지금 1회", col = _a1616.bad, fn = function()
task.spawn(function() _a1573.mreb = true _a1613() _a1573.mreb = false _a1658("log") end)
end },
})
local _a2177 = _a1691(_a1888, "전체 제어", nil)
_a1721(_a2177, {
{ label = "메인 전부 ON", col = _a1616.good, fn = function()
local _a2178 = {
{ "farm",   function() return _a1571.FarmInterval end,       _a1606,       "파밍" },
{ "zone",   function() return _a1571.ZoneInterval end,       _a1608,       "존" },
{ "mhatch", function() return _a1571.MainHatchInterval end,  _a1611,  "부화" },
{ "quest",  function() return _a1571.QuestInterval end,      _a1603.quest.cycle,        "퀘스트" },
{ "mapupg", function() return _a1571.UpgInterval end,        _a1603.mach.cycleUpg,     "맵업글" },
{ "items",  function() return _a1571.ItemInterval end,       _a1603.item.cycleItems,   "아이템" },
{ "slots",  function() return _a1571.SlotInterval end,       _a1603.mach.cycleSlots,   "슬롯" },
}
for _a2179, _a2180 in ipairs(_a2178) do
if not _a1573[_a2180[1]] then
_a1573[_a2180[1]] = true
_a1615(_a2180[1], _a2180[2], _a2180[3], _a2180[4])
end
end
_a1698()
_a1568("[메인] 파밍/존/부화/랭크/퀘스트/맵업글 ON  (리버스는 따로)")
end },
{ label = "메인 전부 OFF", col = _a1616.bad, fn = function()
_a1603.ctl.stopAll()
_a1698()
_a1568("[메인] 정지")
end },
})
end
_a1649.MouseButton1Click:Connect(function()
local _a2181 = table.concat(_a1567, "\n")
if #_a2181 > 900000 then _a2181 = _a2181:sub(#_a2181 - 900000) end
if type(setclipboard) == "function" then
pcall(setclipboard, _a2181)
_a1649.Text = "완료"
task.delay(1.5, function() if _a1649 then _a1649.Text = "복사" end end)
end
end)
_a1648.MouseButton1Click:Connect(function()
table.clear(_a1567)
_a1563.dirty = true
end)
local function _a2182()
_a1573.place, _a1573.merchant, _a1573.upgrade = false, false, false
_a1573.towerup, _a1573.crop, _a1573.expand, _a1573.rebirth, _a1573.hatch, _a1573.luck = false, false, false, false, false, false
_a1573.farm, _a1573.zone, _a1573.mhatch, _a1573.rank, _a1573.mreb = false, false, false, false, false
if _a1752 then _a1752:Disconnect() end
if _a1634 then _a1634:Destroy() end
_G.__PS99_GARDEN = nil
end
_a1646.MouseButton1Click:Connect(_a2182)
_G.__PS99_GARDEN = _a2182
_a1658("dash")
_a1568("PS99 자동")
if _a1573.auto then
if _a1603.auto.start then
_a1568("[자동] 올 자동 켜짐 — 1초 뒤 시작합니다")
task.spawn(function()
task.wait(1)
_a1603.ctl.abort = false
local _a2183, _a2184 = pcall(_a1603.auto.start)
if _a2183 then
_a1568("[자동] 시작됨")
else
_a1573.auto = false
_a1568("[자동] 시작 실패: " .. tostring(_a2184))
if _a1603.auto.refresh then pcall(_a1603.auto.refresh) end
end
end)
else
_a1573.auto = false
_a1568("[자동] QS.auto.start 가 없습니다 — 메인 게임 탭이 안 만들어짐")
end
end
pcall(function()
local _a2185, _a2186, _a2187, _a2188 = _a1576()
if _a2185 and _a2187 then
local _a2189 = _a1577(_a2187, _a2188)
_a1574.slots = #_a2189
_a1568("레인 " .. _a2188 .. " / 슬롯 " .. #_a2189)
else
_a1568("가든 이벤트 밖입니다 (이벤트 탭은 이벤트 안에서만 동작)")
end
_a1574.sun = _a1582()
_a1568("Sunflowers " .. _a1569(_a1574.sun, 0))
end)
end)(_a1)
