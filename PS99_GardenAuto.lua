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
auto = false, petspd = true, rewatch = true }
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
local _a97 = _a39.ClientTowerDefense and _a39.ClientTowerDefense.GetLocal and _a39.ClientTowerDefense.GetLocal()
local _a98  = _a39.ClientPlot and _a39.ClientPlot.GetLocal and _a39.ClientPlot.GetLocal()
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
_a33.cycleExpand, _a33.rebirthStatus, _a33.cycleRebirth, _a33.eggCost, _a33.hatchStatus, _a33.cycleHatch = _a404, _a428, _a443, _a469, _a495, _a502
_a33.LUCK_ORDER, _a33.luckStatus, _a33.fmtDur, _a33.cycleLuck = _a516, _a532, _a540, _a544
end)(_a1)
;(function(_a558)
local _a559, _a560, _a561, _a562, _a563, _a564 = _a558.UIS, _a558.RunService, _a558.LP, _a558.log, _a558.num, _a558.req
local _a565, _a566, _a567, _a568, _a569, _a570 = _a558.LB, _a558.NET, _a558.RM, _a558.CFG, _a558.RUN, _a558.STAT
local _a571, _a572, _a573 = _a558.ctx, _a558.placedTowers, _a558.eggCost
local _a574 = {
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
local _a575 = {
[1]="farm", [9]="farm", [21]="farm", [7]="farm", [99]="farm", [8]="farm",
[30]="farm", [31]="farm", [32]="farm", [37]="farm", [38]="farm", [39]="farm",
[43]="farm", [44]="farm", [66]="farm", [67]="farm", [75]="farm", [76]="farm",
[14]="farm", [15]="farm", [64]="farm", [65]="farm", [63]="farm",
[2]="hatch", [3]="hatch", [20]="hatch", [42]="hatch", [47]="hatch",
[6]="zone", [81]="zone",
[34]="potuse",
[35]="fruituse", [33]="flaguse",
}
local _a576 = {}
_a576.IGNORE = {
[4]  = "골드 펫 만들기 (합성 필요)",
[5]  = "레인보우 펫 만들기 (합성 필요)",
[40] = "best egg 골드 펫 (뽑기+합성 필요)",
[41] = "best egg 레인보우 펫 (뽑기+2단 합성 필요)",
[12] = "포션 업글 (업글 머신으로 이동 필요)",
[13] = "인챈트 업글 (업글 머신으로 이동 필요)",
}
_a576.abort = false
function _a576.stopped() return _a576.abort == true end
function _a576.stopAll()
_a576.abort = true
for _a577 in pairs(_a569) do
if _a577 ~= "petspd" and _a577 ~= "rewatch" then _a569[_a577] = false end
end
_a576.lockGoal = nil
_a576.moving = nil
_a576.now.step = "정지"
_a576.setAct("정지됨")
end
_a576.now = { step = "-", act = "-", detail = "", goal = "-", prog = "" }
function _a576.setAct(_a578, _a579)
_a576.now.act = _a578 or "-"
_a576.now.detail = _a579 and tostring(_a579) or ""
_a576.now.at = os.clock()
end
function _a576.setGoal(_a580, _a581)
_a576.now.goal = _a580 and tostring(_a580) or "-"
_a576.now.prog = _a581 and tostring(_a581) or ""
end
function _a576.eggStands()
local _a582 = os.clock()
if _a576._standsAt and (_a582 - _a576._standsAt) < 2 and _a576._stands then
local _a583 = _a561.Character
local _a584 = _a583 and _a583:FindFirstChild("HumanoidRootPart")
if _a584 then
for _a585, _a586 in ipairs(_a576._stands) do
_a586.dist = (_a586.pos - _a584.Position).Magnitude
end
table.sort(_a576._stands, function(_a587, _a588) return _a587.dist < _a588.dist end)
end
return _a576._stands
end
local _a589 = {}
local _a590 = workspace:FindFirstChild("__THINGS")
local _a591 = _a590 and _a590:FindFirstChild("Eggs")
if not _a591 then return _a589 end
local _a592 = _a561.Character
local _a593 = _a592 and _a592:FindFirstChild("HumanoidRootPart")
for _a594, _a595 in ipairs(_a591:GetDescendants()) do
if _a595:IsA("Model") and _a595.PrimaryPart then
local _a596 = tonumber(tostring(_a595.Name):match("%d+"))
if _a596 then
local _a597
if _a574.EggsU and rawget(_a574.EggsU, "GetByNumber") then
local _a598, _a599 = pcall(_a574.EggsU.GetByNumber, _a596)
if _a598 then _a597 = _a599 end
end
local _a600 = _a597 and (rawget(_a597, "_id") or rawget(_a597, "name"))
if _a600 then
_a589[#_a589 + 1] = {
id = _a600, def = _a597, num = _a596,
pos = _a595.PrimaryPart.Position,
dist = _a593 and (_a595.PrimaryPart.Position - _a593.Position).Magnitude or 9e9,
unlocked = _a595:GetAttribute("Unlocked") and true or false,
}
end
end
end
end
table.sort(_a589, function(_a601, _a602) return _a601.dist < _a602.dist end)
_a576._stands, _a576._standsAt = _a589, os.clock()
return _a589
end
local function _a603()
if not _a565.Save then return nil end
local _a604, _a605 = pcall(_a565.Save.Get)
return (_a604 and type(_a605) == "table") and _a605 or nil
end
local function _a606(_a607, _a608)
if _a574.Currency and rawget(_a574.Currency, "CanAfford") then
local _a609, _a610 = pcall(_a574.Currency.CanAfford, _a607, _a608)
if _a609 then return _a610 and true or false end
end
return false
end
local function _a611(_a612)
if _a574.Currency and rawget(_a574.Currency, "Get") then
local _a613, _a614 = pcall(_a574.Currency.Get, _a612)
if _a613 and tonumber(_a614) then return tonumber(_a614) end
end
return 0
end
local function _a615()
if _a574.AutoFarm and rawget(_a574.AutoFarm, "IsEnabled") then
local _a616, _a617 = pcall(_a574.AutoFarm.IsEnabled)
if _a616 then return _a617 and true or false end
end
return false
end
local function _a618()
if _a574.AutoFarm and rawget(_a574.AutoFarm, "GetTargetParentId") then
local _a619, _a620 = pcall(_a574.AutoFarm.GetTargetParentId)
if _a619 then return _a620 end
end
return nil
end
local function _a621()
if not _a574.R_Farm then _a562("[파밍] AutoFarm_Enable 리모트 없음") return end
local _a622 = _a615()
_a576.farmZone, _a576.hereZone = _a618(), _a576.curZone()
if _a622 then
local _a623, _a624 = _a618(), _a576.curZone()
if _a623 and _a624 and _a623 ~= _a624 then
_a562(("[파밍] 대상이 %s 인데 지금은 %s — 다시 켬"):format(
tostring(_a623), tostring(_a624)))
if _a574.R_FarmOff then pcall(function() _a574.R_FarmOff:InvokeServer() end) end
if _a574.AutoFarm and rawget(_a574.AutoFarm, "ForceDisable") then
pcall(_a574.AutoFarm.ForceDisable)
end
task.wait(0.3)
_a622 = false
end
end
if _a622 then return end
local _a625, _a626
pcall(function() _a625, _a626 = _a574.R_Farm:InvokeServer() end)
if _a625 then
_a570.farm += 1
_a576.farmSaid = nil
_a562("[파밍] 자동 파밍 ON  (대상 " .. tostring(_a618() or _a576.curZone()) .. ")")
elseif _a626 and _a576.farmSaid ~= tostring(_a626) then
_a576.farmSaid = tostring(_a626)
_a562("[파밍] 실패: " .. tostring(_a626))
end
end
local function _a627()
if not (_a574.Zone and rawget(_a574.Zone, "GetNextZone")) then return nil end
local _a628, _a629, _a630 = pcall(_a574.Zone.GetNextZone)
if not _a628 then return nil end
return _a630 or _a629
end
local function _a631(_a632)
if not (_a574.Bal and rawget(_a574.Bal, "CalcGatePrice")) then return nil end
local _a633, _a634 = pcall(_a574.Bal.CalcGatePrice, _a632)
return (_a633 and tonumber(_a634)) or nil
end
local function _a635()
local _a636 = _a627()
if not _a636 then return nil end
local _a637 = _a631(_a636)
local _a638 = rawget(_a636, "Currency")
return {
zone = _a636, id = rawget(_a636, "_id"), price = _a637, currency = _a638,
have = _a638 and _a611(_a638) or 0,
ok = (_a637 and _a638) and _a606(_a638, _a637) or false,
}
end
local function _a639()
if not _a574.R_Zone then _a562("[존] Zones_RequestPurchase 리모트 없음") return end
local _a640 = 0
while _a569.zone and not _a576.stopped() and _a640 < 20 do
_a640 += 1
local _a641 = _a635()
if not _a641 then
_a576.zoneNote = "다음 존을 못 구함 (GetNextZone 실패 / 존 퀘스트 미완료?)"
if _a576.zoneSaid ~= _a576.zoneNote then
_a576.zoneSaid = _a576.zoneNote
_a562("[존] " .. _a576.zoneNote)
end
return
end
if not _a641.ok then
_a576.zoneNote = ("%s  %s %s / 보유 %s — 부족"):format(
tostring(_a641.id), _a563(_a641.price or 0, 0), tostring(_a641.currency), _a563(_a641.have, 0))
if _a576.zoneSaid ~= _a576.zoneNote then
_a576.zoneSaid = _a576.zoneNote
_a562("[존] " .. _a576.zoneNote)
end
return
end
_a576.zoneSaid = nil
local _a642, _a643
pcall(function() _a642, _a643 = _a574.R_Zone:InvokeServer(_a641.id) end)
task.wait(0.5)
if _a642 then
_a570.zone += 1
_a562(("  ▶ 존 해금  %s   (%s %s)"):format(
tostring(_a641.id), _a563(_a641.price or 0, 0), tostring(_a641.currency)))
else
if _a643 then _a562("[존] 실패: " .. tostring(_a643)) end
return
end
task.wait(_a568.ActionGap)
end
end
local function _a644()
local _a645 = _a576.eggStands()
local _a646 = (_a568.MainEggId and _a568.MainEggId ~= "") and _a568.MainEggId or nil
if _a646 then
for _a647, _a648 in ipairs(_a645) do
if _a648.id == _a646 then return _a648.id, _a648.def, _a648.dist end
end
local _a649 = _a574.DirEggs and rawget(_a574.DirEggs, _a646)
if _a649 then return _a646, _a649, nil, (_a645[1] and _a645[1].dist) end
return nil
end
if not _a574.DirEggs then return nil end
local _a650, _a651, _a652 = nil, nil, -1
for _a653, _a654 in pairs(_a574.DirEggs) do
if type(_a654) == "table" and not rawget(_a654, "isCustomEgg") then
local _a655 = tonumber(rawget(_a654, "eggNumber"))
if _a655 and _a655 > _a652 and _a576.eggUnlocked(_a655) then
_a650, _a651, _a652 = _a653, _a654, _a655
end
end
end
if not _a650 then return nil end
local _a656, _a657
for _a658, _a659 in ipairs(_a645) do
if not _a657 then _a657 = _a659.dist end
if _a659.id == _a650 then _a656 = _a659.dist break end
end
if _a656 and _a656 <= _a568.EggRange then
return _a650, _a651, _a656
end
return _a650, _a651, nil, _a656 or _a657
end
local function _a660(_a661)
if type(_a574.CalcEgg) == "function" then
local _a662, _a663 = pcall(_a574.CalcEgg, _a661)
if _a662 and tonumber(_a663) then return tonumber(_a663) end
if not _a662 and not _a576.priceWarned then
_a576.priceWarned = true
_a562("[부화] CalcEggPricePlayer 막힘 → 기본가로 계산: " .. tostring(_a663))
end
end
if type(_a574.CalcEggB) == "function" then
local _a664, _a665 = pcall(_a574.CalcEggB, _a661)
if _a664 and tonumber(_a665) then return tonumber(_a665) end
end
for _a666, _a667 in ipairs({ "price", "Price", "cost", "Cost" }) do
local _a668 = tonumber(rawget(_a661, _a667))
if _a668 then return _a668 end
end
return nil
end
local function _a669()
local _a670, _a671, _a672, _a673 = _a644()
if not _a670 then return nil end
local _a674 = _a660(_a671)
local _a675 = rawget(_a671, "currency") or "Coins"
local _a676 = 1
if _a574.Egg and rawget(_a574.Egg, "GetMaxHatch") then
local _a677, _a678 = pcall(_a574.Egg.GetMaxHatch, _a671)
if _a677 and tonumber(_a678) then _a676 = math.max(1, math.floor(tonumber(_a678))) end
end
local _a679 = _a611(_a675)
return {
id = _a670, def = _a671, price = _a674, currency = _a675, maxN = _a676, have = _a679,
dist = _a672, nearest = _a673, inRange = _a672 ~= nil,
canBuy = (_a674 and _a674 > 0) and math.floor(math.max(0, _a679 - _a568.MainHatchReserve) / _a674) or 0,
}
end
local function _a680()
if not _a567.R_EGG then _a562("[부화] Eggs_RequestPurchase 리모트 없음") return end
if _a568.AutoUnlockEgg then
local _a681, _a682, _a683 = _a576.lockedEggs()
if _a682 > _a683 then
local _a684 = _a576.unlockEggs()
if _a684 > 0 then _a562(("[부화] 알 %d개 해금 (해금가능 #%d)"):format(_a684, _a682)) end
end
end
local _a685 = _a669()
if not _a685 then _a562("[부화] 알을 못 찾음") return end
if not _a685.inRange then
if _a568.HatchAutoTp then
local _a686, _a687 = _a576.tpEgg(_a685.id)
if not _a686 then
if not _a576.hatchWarned then
_a576.hatchWarned = true
_a562("[부화] 알로 이동 실패: " .. tostring(_a687))
end
return
end
_a562("[부화] " .. _a685.id .. " 로 이동")
_a685 = _a669()
if not (_a685 and _a685.inRange) then return end
else
if not _a576.hatchWarned then
_a576.hatchWarned = true
_a562(("[부화] 알 근처로 가주세요 (가장 가까운 알까지 %s스터드, 인식 %d)"):format(
_a685.nearest and ("%.0f"):format(_a685.nearest) or "?", _a568.EggRange))
end
return
end
end
_a576.hatchWarned = false
local _a688 = math.min(_a685.maxN, _a568.MainHatchMax)
local _a689 = _a685.price and math.min(_a685.canBuy, _a688) or _a688
if _a689 < 1 then return end
local _a690, _a691 = 0, 0
local function _a692()
return tonumber(_a574.Vars and rawget(_a574.Vars, "OpeningEgg")) or 0
end
local _a693 = _a574.Vars and rawget(_a574.Vars, "OpeningEgg") ~= nil
local _a694 = 2.5
if _a574.Egg and rawget(_a574.Egg, "ComputeDebounce") then
local _a695, _a696 = pcall(_a574.Egg.ComputeDebounce)
if _a695 and tonumber(_a696) then _a694 = tonumber(_a696) end
end
_a576.autoHatchOn(_a685.id, _a689)
local _a697 = false
local _a698 = _a576.lockGoal and _a576.lockGoal.q
local _a699 = _a698 and (_a698.how == "hatch" or _a698.where == "bestegg") or false
local _a700 = _a699 and math.huge
or (os.clock() + math.max(3, _a568.HatchBudget or 25))
local _a701 = _a699 and 100000 or 400
while _a569.mhatch and not _a576.stopped() and _a689 >= 1 and _a691 < _a701 and os.clock() < _a700 do
if _a699 and (_a691 % 5 == 0) then
local _a702 = _a576.findQuest(_a698.uid)
if not _a702 or _a702.progress >= _a702.amount then break end
end
_a691 += 1
if _a693 then
local _a703 = os.clock()
local _a704 = _a568.HatchClickAfter
local _a705 = false
while _a692() > 0 and _a569.mhatch and not _a576.stopped()
and (os.clock() - _a703) < 20 do
if _a568.HatchClick and (os.clock() - _a703) > _a704 then
_a576.clickOnce()
_a704 += 0.3
if (os.clock() - _a703) > 3 and not _a705 then
_a705 = true
_a576._ahEgg = nil
_a576.autoHatchOn(_a685.id, _a689)
_a562("[부화] 화면이 안 넘어가서 오토해치 재설정")
end
end
task.wait(0.03)
end
if _a692() > 0 then
if _a576.hatchStuck ~= _a685.id then
_a576.hatchStuck = _a685.id
_a562("[부화] " .. tostring(_a685.id) .. " 까는 화면에서 멈춤 — 이번 회차 중단")
end
_a697 = true
break
end
_a576.hatchStuck = nil
else
local _a706 = os.clock() - (_a576.lastHatch or 0)
if _a706 < _a694 then task.wait(_a694 - _a706) end
end
_a576.lastHatch = os.clock()
_a576.setAct("알 까는 중", ("%s x%d  (총 %d)"):format(_a685.id, _a689, _a690))
local _a707, _a708
local _a709 = pcall(function() _a707, _a708 = _a567.R_EGG:InvokeServer(_a685.id, _a689) end)
if _a707 then
_a690 += _a689
_a570.mhatch += _a689
_a576.hatchErr = nil
if _a685.price then
local _a710 = _a611(_a685.currency)
local _a711 = math.floor(math.max(0, _a710 - _a568.MainHatchReserve) / _a685.price)
if _a711 < 1 then break end
_a689 = math.min(_a711, _a688)
end
else
local _a712 = _a709 and tostring(_a708) or "호출 자체 실패"
if _a712:find("quickly") or _a712:find("fast") then
task.wait(0.25)
elseif _a712:find("far away") then
if _a568.HatchAutoTp then _a576.tpEgg(_a685.id) task.wait(0.2)
else _a562("[부화] 알에서 너무 멈") break end
elseif _a689 > 1 then
_a689 = math.floor(_a689 / 2)
else
if _a576.hatchErr ~= _a712 then
_a576.hatchErr = _a712
_a562("[부화] 실패: " .. _a712 .. "   (알 " .. tostring(_a685.id)
.. " / 개수 " .. _a689 .. " / 거리 "
.. (_a685.dist and ("%.0f"):format(_a685.dist) or "?") .. ")")
end
break
end
end
end
if _a693 and _a690 > 0 and not _a697 then
local _a713 = os.clock()
local _a714 = _a568.HatchClickAfter
while _a692() > 0 and not _a576.stopped() and (os.clock() - _a713) < 20 do
_a576.setAct("알 마무리", ("%s  마지막 %d개 까는 중"):format(_a685.id, _a689))
if _a568.HatchClick and (os.clock() - _a713) > _a714 then
_a576.clickOnce()
_a714 += 0.3
if (os.clock() - _a713) > 3 and not _a576._finRe then
_a576._finRe = true
_a576._ahEgg = nil
_a576.autoHatchOn(_a685.id, _a689)
end
end
task.wait(0.03)
end
_a576._finRe = nil
if _a692() > 0 then
_a562("[부화] 마지막 알이 20초 넘게 안 끝남 — 그대로 두고 진행합니다")
end
end
_a576.autoHatchOff()
if _a690 > 0 then
_a576.hatchErr = nil
_a562(("[부화] %s × %d%s  (개당 %s %s)"):format(
_a685.id, _a690, _a699 and " (목표까지)" or "",
_a685.price and _a563(_a685.price, 0) or "?", tostring(_a685.currency)))
end
end
local function _a715()
local _a716 = _a603()
if not _a716 then return nil end
local _a717 = tonumber(rawget(_a716, "Rank")) or 1
local _a718 = tonumber(rawget(_a716, "RankStars")) or 0
local _a719 = rawget(_a716, "RedeemedRankRewards") or {}
local _a720
if _a574.RanksU and rawget(_a574.RanksU, "RankIDFromNumber") then
local _a721, _a722 = pcall(_a574.RanksU.RankIDFromNumber, _a717)
if _a721 then _a720 = _a722 end
end
local _a723 = _a720 and _a574.DirRanks and rawget(_a574.DirRanks, _a720)
if type(_a723) ~= "table" then
return { rankNum = _a717, stars = _a718, rankId = _a720, rewards = {} }
end
local _a724, _a725 = {}, 0
for _a726, _a727 in ipairs(rawget(_a723, "Rewards") or {}) do
_a725 += (tonumber(rawget(_a727, "StarsRequired")) or 0)
local _a728 = _a725 <= _a718
local _a729 = _a719[tostring(_a726)] ~= nil
_a724[#_a724 + 1] = {
index = _a726, need = _a725, earned = _a728, redeemed = _a729,
claimable = _a728 and not _a729,
}
end
return { rankNum = _a717, stars = _a718, rankId = _a720, rewards = _a724 }
end
local function _a730()
if not _a574.R_Rank then _a562("[랭크] Ranks_ClaimReward 리모트 없음") return end
local _a731 = _a715()
if not _a731 then return end
local _a732 = 0
for _a733, _a734 in ipairs(_a731.rewards) do
if not _a569.rank then break end
if _a734.claimable then
pcall(function() _a574.R_Rank:FireServer(_a734.index) end)
_a732 += 1
_a570.rank += 1
task.wait(0.1)
end
end
if _a732 > 0 then
_a562(("[랭크] 보상 %d개 수령  (Rank %d, ★%d)"):format(_a732, _a731.rankNum, _a731.stars))
end
end
function _a576.hrp()
local _a735 = _a561.Character
return _a735 and _a735:FindFirstChild("HumanoidRootPart"),
_a735 and _a735:FindFirstChildOfClass("Humanoid")
end
function _a576.autoHatchOn(_a736, _a737)
if not _a568.UseAutoHatch then return end
if _a576._ahEgg == _a736 and _a576._ahAt and (os.clock() - _a576._ahAt) < 15 then return end
_a576._ahEgg, _a576._ahAt = _a736, os.clock()
local _a738 = _a574.DirEggs and rawget(_a574.DirEggs, _a736)
if _a574.Hatch and _a738 and rawget(_a574.Hatch, "SetupEgg") then
local _a739, _a740 = pcall(_a574.Hatch.SetupEgg, _a738, _a737 or 1)
if not _a739 and not _a576._ahWarn then
_a576._ahWarn = true
_a562("[부화] SetupEgg 실패: " .. tostring(_a740) .. "  → 클릭 대체 사용")
end
end
if _a574.R_AHTog then pcall(function() _a574.R_AHTog:FireServer(true) end) end
if _a574.R_AHOn then pcall(function() _a574.R_AHOn:FireServer(_a736, _a737 or 1) end) end
if _a574.Hatch and rawget(_a574.Hatch, "IsHatching") then
local _a741, _a742 = pcall(_a574.Hatch.IsHatching)
_a576._ahLive = _a741 and _a742 and true or false
end
end
function _a576.autoHatchOff()
_a576._ahEgg, _a576._ahAt, _a576._ahLive = nil, nil, nil
if _a574.Hatch and rawget(_a574.Hatch, "StopHatching") then pcall(_a574.Hatch.StopHatching) end
if _a574.R_AHOff then pcall(function() _a574.R_AHOff:FireServer() end) end
end
function _a576.clickOnce()
if _a576.moving then return false end
local _a743 = _a576.signal("egg")
if not _a743 then _a743 = _a576.pressInGame({ "Egg Opening" }) end
if not _a743 and not _a576._eggSigWarn then
_a576._eggSigWarn = true
_a562("[부화] 게임 내 방법이 다 막힘 — SetupEgg 에만 의존합니다")
end
return _a743
end
function _a576.applyPetSpeed()
local _a744 = _a574.PlayerPet
if not (_a744 and rawget(_a744, "GetByPlayer")) then return 0, "PlayerPet 없음" end
local _a745, _a746 = pcall(_a744.GetByPlayer, _a561)
if not (_a745 and type(_a746) == "table") then return 0, "펫 목록 못 읽음" end
local _a747 = math.max(1, tonumber(_a568.PetSpeedMult) or 50)
local _a748 = math.max(0.05, tonumber(_a568.PetSpeedBase) or 4)
local _a749 = 0
for _a750, _a751 in pairs(_a746) do
if type(_a751) == "table" then
local _a752 = rawget(_a751, "cpet")
if _a752 then
_a751.speedMult = _a747
pcall(function() _a752:Broadcast("petSpeedMult", _a747) end)
pcall(function() _a752:Broadcast("petSpeed", _a748) end)
_a749 += 1
end
end
end
return _a749
end
_a576.SIGNAL = {
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
_a576.BLOCKERS = {
{ "Rebirth",     "리버스",   "reward" },
{ "RankUp",      "랭크업",   "reward" },
{ "MasteryPerk", "마스터리", "mastery" },
{ "Card",        "카드",     "card" },
}
function _a576.findSignalFns(_a753)
local _a754 = _a576.SIGNAL[_a753]
if not _a754 then return {} end
_a576._sig = _a576._sig or {}
local _a755 = _a576._sig[_a753]
if _a755 and (os.clock() - _a755.at) < (#_a755.fns > 0 and 20 or 3) then return _a755.fns end
local _a756 = {}
_a576._sig[_a753] = { at = os.clock(), fns = _a756 }
if type(getgc) ~= "function" or type(debug) ~= "table"
or type(debug.info) ~= "function" or type(debug.getupvalue) ~= "function" then
return _a756
end
local _a757 = {}
for _a758, _a759 in ipairs({ true, false }) do
local _a760, _a761 = pcall(getgc, _a759)
if _a760 and type(_a761) == "table" then
for _a762, _a763 in ipairs(_a761) do _a757[#_a757 + 1] = _a763 end
end
end
if #_a757 == 0 then return _a756 end
for _a764, _a765 in ipairs(_a757) do
if type(_a765) == "function" then
local _a766, _a767 = pcall(debug.info, _a765, "s")
if _a766 and type(_a767) == "string" then
local _a768 = false
for _a769, _a770 in ipairs(_a754.pats) do
if _a767:find(_a770, 1, true) then _a768 = true break end
end
if _a768 then
local _a771, _a772 = pcall(debug.info, _a765, "a")
if _a771 then
local _a773, _a774 = {}, 0
for _a775 = 1, 16 do
local _a776, _a777 = pcall(debug.getupvalue, _a765, _a775)
if not _a776 then break end
_a774 = _a775
_a773[_a775] = type(_a777)
end
local _a778 = table.concat(_a773, ",")
local _a779 = false
for _a780, _a781 in ipairs(_a754.sigs or {}) do
if _a772 == _a781.np and _a778 == _a781.t then
_a756[#_a756 + 1] = { fn = _a765, sig = _a778, n = _a774, np = _a772,
src = _a767, set = _a781.set }
_a779 = true
break
end
end
if not _a779 and _a754.sigs then
local _a782 = {}
for _a783, _a784 in ipairs(_a773) do
if _a784 == "boolean" then _a782[#_a782 + 1] = _a783 end
end
if #_a782 > 0 then
_a756[#_a756 + 1] = { fn = _a765, idx = _a782, sig = _a778, n = _a774,
np = _a772, src = _a767, loose = true }
end
end
if not _a779 and not _a754.sigs and _a772 == 0 then
local _a785 = 0
for _a786, _a787 in ipairs(_a773) do if _a787 == "boolean" then _a785 += 1 end end
if _a785 >= (_a754.minBools or 1) then
local _a788 = {}
for _a789, _a790 in ipairs(_a773) do
if _a790 == "boolean" then _a788[#_a788 + 1] = _a789 end
end
_a756[#_a756 + 1] = { fn = _a765, idx = _a788, sig = _a778, n = _a774, src = _a767 }
end
end
end
end
end
end
end
return _a756
end
function _a576.signal(_a791)
if type(debug) ~= "table" or type(debug.setupvalue) ~= "function" then return false, 0 end
local _a792 = _a576.findSignalFns(_a791)
local _a793 = 0
for _a794, _a795 in ipairs(_a792) do
if _a795.set then
for _a796, _a797 in ipairs(_a795.set) do
if pcall(debug.setupvalue, _a795.fn, _a797[1], _a797[2]) then _a793 += 1 end
end
elseif not _a795.loose then
for _a798, _a799 in ipairs(_a795.idx or {}) do
if pcall(debug.setupvalue, _a795.fn, _a799, true) then _a793 += 1 end
end
end
end
if _a793 == 0 then
for _a800, _a801 in ipairs(_a792) do
if _a801.loose then
for _a802, _a803 in ipairs(_a801.idx or {}) do
if pcall(debug.setupvalue, _a801.fn, _a803, true) then _a793 += 1 end
end
end
end
end
return _a793 > 0, _a793
end
function _a576.pressInGame(_a804)
local _a805, _a806 = pcall(function() return game:GetService("UserInputService") end)
if not (_a805 and _a806) then return false end
local _a807 = {
UserInputType  = Enum.UserInputType.MouseButton1,
UserInputState = Enum.UserInputState.Begin,
KeyCode        = Enum.KeyCode.Unknown,
Position       = Vector3.new(),
Delta          = Vector3.new(),
}
local _a808 = 0
if type(getconnections) == "function" then
local _a809, _a810 = pcall(getconnections, _a806.InputBegan)
if _a809 and type(_a810) == "table" then
for _a811, _a812 in ipairs(_a810) do
local _a813 = ""
local _a814 = _a812.Function
if _a814 and type(debug) == "table" and type(debug.info) == "function" then
local _a815, _a816 = pcall(debug.info, _a814, "s")
if _a815 and _a816 then _a813 = tostring(_a816) end
end
local _a817 = false
for _a818, _a819 in ipairs(_a804) do
if _a813 ~= "" and _a813:find(_a819, 1, true) then _a817 = true break end
end
if _a817 then
if _a814 and pcall(_a814, _a807, false) then _a808 += 1
elseif _a812.Fire and pcall(function() _a812:Fire(_a807, false) end) then _a808 += 1
elseif _a812.Defer and pcall(function() _a812:Defer(_a807, false) end) then _a808 += 1 end
end
end
end
end
if _a808 == 0 and type(firesignal) == "function" then
if pcall(firesignal, _a806.InputBegan, _a807, false) then _a808 += 1 end
end
return _a808 > 0
end
function _a576.realClick(_a820)
if not _a568.ScreenRealClick then return false end
local _a821 = workspace.CurrentCamera
local _a822 = (_a821 and _a821.ViewportSize) or Vector2.new(1280, 720)
local _a823, _a824 = _a822.X * 0.5, _a822.Y * 0.45
local _a825 = {}
local function _a826(_a827, _a828)
local _a829 = pcall(_a828)
_a825[#_a825 + 1] = _a827 .. (_a829 and "=OK" or "=X")
return _a829
end
local _a830 = false
if not _a830 and type(mouse1click) == "function" then
_a830 = _a826("mouse1click", function() mouse1click() end)
end
if not _a830 and type(mouse1press) == "function" then
_a830 = _a826("mouse1press", function()
mouse1press() task.wait(0.05)
if type(mouse1release) == "function" then mouse1release() end
end)
end
if not _a830 then
_a830 = _a826("VirtualUser", function()
local _a831 = game:GetService("VirtualUser")
_a831:Button1Down(Vector2.new(_a823, _a824), _a821 and _a821.CFrame or CFrame.new())
task.wait(0.05)
_a831:Button1Up(Vector2.new(_a823, _a824), _a821 and _a821.CFrame or CFrame.new())
end)
end
if not _a830 then
_a830 = _a826("VirtualInputManager", function()
local _a832 = game:GetService("VirtualInputManager")
_a832:SendMouseButtonEvent(_a823, _a824, 0, true, game, 1)
task.wait(0.05)
_a832:SendMouseButtonEvent(_a823, _a824, 0, false, game, 1)
end)
end
if _a820 then _a562("    " .. table.concat(_a825, " / ")) end
return _a830
end
function _a576.rewardScreenUp()
local _a833 = _a561:FindFirstChildOfClass("PlayerGui")
if _a833 then
for _a834, _a835 in ipairs(_a576.BLOCKERS) do
local _a836 = _a833:FindFirstChild(_a835[1])
if _a836 and _a836:IsA("ScreenGui") and _a836.Enabled then return true, _a835[2], _a835[3] end
end
end
local _a837 = _a574.Vars
if _a837 then
if rawget(_a837, "IsRebirthing") then return true, "리버스", "reward" end
if rawget(_a837, "IsRankingUp") then return true, "랭크업", "reward" end
end
return false
end
function _a576.dismissRewardScreens(_a838)
if _a576.dismissBusy then return end
_a576.dismissBusy = true
local _a839, _a840 = pcall(_a576.dismissInner, _a838)
_a576.dismissBusy = false
if not _a839 then _a562("[화면] 오류: " .. tostring(_a840)) end
end
function _a576.dismissInner(_a841)
local _a842 = _a574.Vars
if not _a842 then return end
local _a843 = os.clock()
local _a844, _a845 = false, nil
local _a846 = 0
local _a847 = math.max(3, _a568.ScreenTryMax or 8)
while os.clock() - _a843 < (_a841 or 120) do
local _a848, _a849, _a850 = _a576.rewardScreenUp()
if not _a848 then break end
_a844, _a845 = true, _a849
_a846 += 1
_a576.setAct("보상 화면 넘기는 중",
("%s (%d회%s)"):format(tostring(_a849), _a846,
_a846 <= 6 and " · 첫 화면 대기" or ""))
local _a851 = _a576.SIGNAL[_a850 or "reward"]
local _a852 = (_a851 and _a851.pats) or { "Rebirth", "Rank Up" }
local _a853 = _a576.signal(_a850 or "reward")
if not _a853 then
for _a854 in pairs(_a576.SIGNAL) do
if _a576.signal(_a854) then _a853 = true end
end
end
local _a855 = false
if not _a853 or _a846 >= 2 then
_a855 = _a576.pressInGame(_a852)
end
if _a846 >= 3 then
if _a576.realClick() then
_a855 = true
if not _a576._realSaid then
_a576._realSaid = true
_a562("[화면] 실제 클릭까지 같이 씁니다 (Roblox 창이 켜져 있어야 먹습니다)")
end
end
end
if (_a853 or _a855) and not _a576._sigSaid then
_a576._sigSaid = true
_a562("[화면] " .. (_a853 and "upvalue 신호" or "게임 내 입력 발동") .. " 로 넘깁니다")
end
if _a846 >= _a847 and (os.clock() - _a843) >= 12 then
if _a576.giveUpSaid ~= _a849 then
_a576.giveUpSaid = _a849
_a562(("[화면] %s 화면을 못 넘김 — 그냥 두고 자동화는 계속합니다"):format(tostring(_a849)))
_a562("        (이 화면은 UI만 가릴 뿐 리모트 호출은 막지 않습니다)")
end
_a576.screenGaveUp = os.clock()
return
end
task.wait(0.8)
end
if _a844 then
if not _a576.rewardScreenUp() then
_a576.lastBlocker = nil
_a576.screenGaveUp = nil
_a562(("[화면] %s 넘김 완료 (%d회)"):format(tostring(_a845), _a846))
end
end
end
function _a576.eggUnlocked(_a856)
_a856 = tonumber(_a856)
if not _a856 then return false end
local _a857 = _a603()
local _a858 = _a857 and rawget(_a857, "UnlockedEggs")
if type(_a858) == "table" then
for _a859, _a860 in pairs(_a858) do
if tonumber(_a860) == _a856 then return true end
end
return false
end
return _a856 <= 1
end
function _a576.lockedEggs()
local _a861 = {}
if not _a574.DirEggs then return _a861, 0, 0 end
local _a862 = _a603()
local _a863 = tonumber(_a862 and rawget(_a862, "MaximumAvailableEgg")) or 1
local _a864 = 0
local _a865 = _a862 and rawget(_a862, "UnlockedEggs")
if type(_a865) == "table" then
for _a866, _a867 in pairs(_a865) do
local _a868 = tonumber(_a867)
if _a868 and _a868 > _a864 then _a864 = _a868 end
end
end
for _a869, _a870 in pairs(_a574.DirEggs) do
if type(_a870) == "table" and not rawget(_a870, "isCustomEgg") then
local _a871 = tonumber(rawget(_a870, "eggNumber"))
if _a871 and _a871 <= _a863 and not _a576.eggUnlocked(_a871) then
_a861[#_a861 + 1] = { id = _a869, num = _a871 }
end
end
end
table.sort(_a861, function(_a872, _a873) return _a872.num < _a873.num end)
return _a861, _a863, _a864
end
function _a576.unlockEggs(_a874)
if not _a574.R_EggUn then return 0, "Eggs_RequestUnlock 리모트 없음" end
local _a875 = _a576.lockedEggs()
if #_a875 == 0 then return 0 end
local _a876, _a877 = 0, nil
for _a878, _a879 in ipairs(_a875) do
if not _a576.eggUnlocked(_a879.num) then
local _a880, _a881
pcall(function() _a880, _a881 = _a574.R_EggUn:InvokeServer(_a879.id) end)
if not _a880 and _a568.HatchAutoTp then
local _a882 = _a576.tpEgg(_a879.id)
if _a882 then
task.wait(0.3)
pcall(function() _a880, _a881 = _a574.R_EggUn:InvokeServer(_a879.id) end)
end
end
if _a880 then
_a876 += 1
_a576.setAct("알 해금", ("#%d %s"):format(_a879.num, _a879.id))
_a562(("  🔓 알 해금  #%d %s"):format(_a879.num, _a879.id))
task.wait(0.15)
else
_a877 = _a881
if _a874 then
_a562(("[해금] #%d %s 실패: %s"):format(_a879.num, _a879.id, tostring(_a881)))
end
end
end
end
return _a876, _a877
end
function _a576.curZone()
if _a574.Map and rawget(_a574.Map, "GetCurrentZone") then
local _a883, _a884 = pcall(_a574.Map.GetCurrentZone)
if _a883 then return _a884 end
end
return nil
end
function _a576.zone1()
if not _a574.DirZones then return nil end
local _a885, _a886 = nil, math.huge
for _a887, _a888 in pairs(_a574.DirZones) do
if type(_a888) == "table" and _a576.ownsZone(_a887) then
local _a889 = tonumber(rawget(_a888, "ZoneNumber")) or math.huge
if _a889 < _a886 then _a885, _a886 = _a887, _a889 end
end
end
return _a885
end
function _a576.realZone(_a890) return _a890 end
function _a576.resolvableZone(_a891)
if _a891 then
local _a892 = _a576.zonePos(_a891)
if _a892 then return _a891, _a892 end
end
if not _a574.DirZones then return nil end
local _a893 = {}
for _a894, _a895 in pairs(_a574.DirZones) do
if type(_a895) == "table" and _a576.ownsZone(_a894) then
_a893[#_a893 + 1] = { id = _a894, n = tonumber(rawget(_a895, "ZoneNumber")) or 0 }
end
end
table.sort(_a893, function(_a896, _a897) return _a896.n > _a897.n end)
for _a898, _a899 in ipairs(_a893) do
if _a899.id ~= _a891 then
local _a900 = _a576.zonePos(_a899.id)
if _a900 then
if _a576.fallZone ~= _a899.id then
_a576.fallZone = _a899.id
_a562(("[TP] %s 좌표를 못 구해서 %s 로 대신 감 (로드 안 된 존)"):format(
tostring(_a891), tostring(_a899.id)))
end
return _a899.id, _a900
end
end
end
return nil
end
function _a576.bestZone()
if _a574.Zone and rawget(_a574.Zone, "GetMaxOwnedZone") then
local _a901, _a902, _a903 = pcall(_a574.Zone.GetMaxOwnedZone)
if _a901 and _a902 then return _a902, _a903 end
end
return _a576.zone1()
end
function _a576.ownsZone(_a904)
local _a905 = _a603()
local _a906 = _a905 and rawget(_a905, "UnlockedZones")
return (type(_a906) == "table" and _a906[_a904] ~= nil) or false
end
function _a576.zoneByNumber(_a907)
if not (_a574.DirZones and _a907) then return nil end
for _a908, _a909 in pairs(_a574.DirZones) do
if type(_a909) == "table" and tonumber(rawget(_a909, "ZoneNumber")) == tonumber(_a907) then
return _a908, _a909
end
end
return nil
end
local function _a910(_a911, _a912)
local _a913 = rawget(_a911, "Breakables")
local _a914 = type(_a913) == "table" and rawget(_a913, "Main") or nil
local _a915 = type(_a914) == "table" and rawget(_a914, "Data") or nil
if type(_a915) ~= "table" then return false end
for _a916, _a917 in pairs(_a915) do
local _a918 = type(_a917) == "table" and rawget(_a917, "Type") or nil
if _a918 and tostring(_a918):lower():find(_a912, 1, true) then return true end
end
return false
end
function _a576.zoneForBreakable(_a919)
if not (_a574.DirZones and _a919) then return nil end
local _a920 = tostring(_a919):lower()
local _a921 = _a576.bestZone()
if _a921 then
local _a922 = rawget(_a574.DirZones, _a921)
if type(_a922) == "table" and _a910(_a922, _a920) then return _a921 end
end
local _a923, _a924 = nil, -1
for _a925, _a926 in pairs(_a574.DirZones) do
if type(_a926) == "table" and _a925 ~= "Spawn" and _a576.ownsZone(_a925) then
local _a927 = rawget(_a926, "Breakables")
local _a928 = type(_a927) == "table" and rawget(_a927, "Main") or nil
local _a929 = type(_a928) == "table" and rawget(_a928, "Data") or nil
if type(_a929) == "table" then
for _a930, _a931 in pairs(_a929) do
local _a932 = type(_a931) == "table" and rawget(_a931, "Type") or nil
if _a932 and tostring(_a932):lower():find(_a920, 1, true) then
local _a933 = tonumber(rawget(_a926, "ZoneNumber")) or 0
if _a933 > _a924 then _a923, _a924 = _a925, _a933 end
break
end
end
end
end
end
return _a923
end
function _a576.tpZone(_a934)
if not _a934 then return false, "존 id 없음" end
if _a576.curZone() == _a934 then return true end
if not _a568.TpGameFallback then
_a562("[TP] 게임 정식 TP 차단됨 (" .. tostring(_a934) .. ")\n" .. debug.traceback("", 2))
return false, "게임 TP 꺼져 있음"
end
local _a935 = _a574.R_Tp
if _a574.Inst and rawget(_a574.Inst, "IsInInstance") then
local _a936, _a937 = pcall(_a574.Inst.IsInInstance)
if _a936 and _a937 and _a574.R_TpI then _a935 = _a574.R_TpI end
end
if not _a935 then return false, "텔레포트 리모트 없음" end
local _a938 = os.clock() - (_a576.lastTp or 0)
if _a938 < _a568.TpCooldown then task.wait(_a568.TpCooldown - _a938) end
_a576.lastTp = os.clock()
local _a939, _a940
pcall(function() _a939, _a940 = _a935:InvokeServer(_a934) end)
if not _a939 then return false, _a940 end
local _a941 = os.clock()
while os.clock() - _a941 < 5 do
if _a576.curZone() == _a934 then break end
task.wait(0.05)
end
task.wait(0.15)
return true
end
function _a576.glideTo(_a942)
if _a576.stopped() then return false, "정지됨" end
if _a576.moving and (os.clock() - _a576.moving) < 30 then
return false, "이미 이동 중 (다른 이동이 아직 안 끝남)"
end
_a576.moving = os.clock()
local _a943, _a944, _a945 = pcall(_a576.glideRaw, _a942)
_a576.moving = nil
if not _a943 then return false, tostring(_a944) end
return _a944, _a945
end
function _a576.glideRaw(_a946)
local _a947, _a948 = _a576.hrp()
if not _a947 then return false, "캐릭터 없음" end
if _a568.TpMode == "instant" then
local _a949 = _a946 + Vector3.new(0, 4, 0)
for _a950 = 1, 3 do
local _a951 = _a561.Character
local _a952, _a953 = _a576.hrp()
if not (_a951 and _a952) then return false, "캐릭터 없음" end
local _a954 = _a952.CFrame - _a952.CFrame.Position
pcall(function() _a951:PivotTo(CFrame.new(_a949) * _a954) end)
_a952.AssemblyLinearVelocity = Vector3.zero
for _a955 = 1, 6 do _a560.Heartbeat:Wait() end
if _a953 then
pcall(function()
_a953:Move(Vector3.new(0.3, 0, 0), false)
end)
task.wait(0.1)
pcall(function() _a953:Move(Vector3.zero, false) end)
end
task.wait(0.15)
_a952 = _a576.hrp()
if _a952 and (_a952.Position - _a949).Magnitude <= 30 then
local _a956 = os.clock()
while os.clock() - _a956 < 1.5 do
if _a576.inDottedBox() ~= false then break end
task.wait(0.05)
end
return true
end
if _a950 < 3 then task.wait(0.15) end
end
return false, "순간이동이 되돌려짐"
end
if _a568.TpMode == "walk" then
if not _a948 then return false, "Humanoid 없음" end
local _a957 = os.clock()
while os.clock() - _a957 < 45 do
local _a958 = _a947.Position
if (Vector3.new(_a958.X, 0, _a958.Z) - Vector3.new(_a946.X, 0, _a946.Z)).Magnitude < 8 then
return true
end
_a948:MoveTo(_a946)
task.wait(0.5)
end
return false, "걸어가다 시간초과"
end
if (_a947.Position - _a946).Magnitude <= (_a568.ArriveDist or 12) then return true end
local _a959 = math.max(16, tonumber(_a568.TpSpeed) or 90)
local _a960 = math.max(0, tonumber(_a568.TpHeight) or 0)
local function _a961(_a962, _a963)
local _a964 = 0
while _a964 < 2000 do
if _a576.stopped() then return false end
_a964 += 1
local _a965 = _a576.hrp()
if not _a965 then return false end
local _a966 = _a965.Position
local _a967 = _a962 - _a966
local _a968 = _a967.Magnitude
if _a968 < 2.5 then return true end
local _a969 = _a560.Heartbeat:Wait()
local _a970 = math.min(_a968, _a959 * math.min(_a969, 0.1))
local _a971 = _a963 and (Vector3.new(_a962.X, _a966.Y, _a962.Z)) or nil
if _a971 and (_a971 - _a966).Magnitude > 1 then
_a965.CFrame = CFrame.lookAt(_a966 + _a967.Unit * _a970, _a971)
else
_a965.CFrame = CFrame.new(_a966 + _a967.Unit * _a970) * (_a965.CFrame - _a965.Position)
end
_a965.AssemblyLinearVelocity = Vector3.zero
end
return false
end
if _a960 > 0 then
local _a972 = _a947.Position
local _a973 = math.max(_a972.Y, _a946.Y) + _a960
_a961(Vector3.new(_a972.X, _a973, _a972.Z), false)
_a961(Vector3.new(_a946.X, _a973, _a946.Z), true)
end
_a961(_a946 + Vector3.new(0, 3, 0), true)
local _a974 = _a576.hrp()
if _a974 then _a974.AssemblyLinearVelocity = Vector3.zero end
return true
end
local function _a975(_a976)
local _a977 = #_a976
if _a977 == 0 then return nil, 0 end
local _a978, _a979 = math.huge, -math.huge
local _a980, _a981 = math.huge, -math.huge
local _a982 = 0
for _a983, _a984 in ipairs(_a976) do
if _a984.X < _a978 then _a978 = _a984.X end
if _a984.X > _a979 then _a979 = _a984.X end
if _a984.Z < _a980 then _a980 = _a984.Z end
if _a984.Z > _a981 then _a981 = _a984.Z end
_a982 += _a984.Y
end
return Vector3.new((_a978 + _a979) / 2, _a982 / _a977, (_a980 + _a981) / 2), _a977
end
function _a576.breakCenter(_a985)
local _a986 = _a576.hrp()
if not _a986 then return nil, 0 end
local _a987 = workspace:FindFirstChild("__THINGS")
if not _a987 then return nil, 0 end
local _a988 = _a986.Position
local _a989 = {}
for _a990, _a991 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a992 = _a987:FindFirstChild(_a991)
if _a992 then
for _a993, _a994 in ipairs(_a992:GetChildren()) do
local _a995
if _a994:IsA("BasePart") then _a995 = _a994.Position
elseif _a994:IsA("Model") then
local _a996, _a997 = pcall(function() return _a994:GetPivot() end)
if _a996 and typeof(_a997) == "CFrame" then _a995 = _a997.Position end
end
if _a995 and (_a995 - _a988).Magnitude <= (_a985 or 400) then
_a989[#_a989 + 1] = _a995
end
end
end
end
return _a975(_a989)
end
function _a576.groundY(_a998, _a999, _a1000)
_a1000 = tonumber(_a1000) or 0
local _a1001 = RaycastParams.new()
_a1001.FilterType = Enum.RaycastFilterType.Exclude
local _a1002 = {}
if _a561.Character then _a1002[#_a1002 + 1] = _a561.Character end
local _a1003 = workspace:FindFirstChild("__THINGS")
if _a1003 then _a1002[#_a1002 + 1] = _a1003 end
_a1001.FilterDescendantsInstances = _a1002
local _a1004 = Vector3.new(_a998, _a1000 + 12, _a999)
local _a1005, _a1006 = pcall(function()
return workspace:Raycast(_a1004, Vector3.new(0, -160, 0), _a1001)
end)
if _a1005 and _a1006 then
local _a1007 = _a1006.Position.Y
if math.abs(_a1007 - _a1000) <= 80 then return _a1007 + 4 end
end
return nil
end
function _a576.zonePos(_a1008, _a1009)
if not _a1008 then return nil, "존 id 없음" end
_a1008 = _a576.realZone(_a1008)
local _a1010 = _a574.DirZones and rawget(_a574.DirZones, _a1008)
local _a1011 = _a1010 and rawget(_a1010, "ZoneFolder")
local _a1012 = {}
do
local _a1013 = workspace:FindFirstChild("__THINGS")
for _a1014, _a1015 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a1016 = _a1013 and _a1013:FindFirstChild(_a1015)
if _a1016 then
for _a1017, _a1018 in ipairs(_a1016:GetChildren()) do
local _a1019
if _a1018:IsA("BasePart") then _a1019 = _a1018.Position
elseif _a1018:IsA("Model") then
local _a1020, _a1021 = pcall(function() return _a1018:GetPivot() end)
if _a1020 and typeof(_a1021) == "CFrame" then _a1019 = _a1021.Position end
end
if _a1019 then _a1012[#_a1012 + 1] = _a1019 end
end
end
end
end
local _a1022 = {}
local function _a1023(_a1024, _a1025)
if not _a1024 then return end
local _a1026, _a1027 = pcall(function() return _a1024:GetDescendants() end)
if _a1024:IsA("BasePart") then _a1022[#_a1022 + 1] = { p = _a1024.Position, why = _a1025 } end
if _a1026 then
for _a1028, _a1029 in ipairs(_a1027) do
if _a1029:IsA("BasePart") then
_a1022[#_a1022 + 1] = { p = _a1029.Position, why = _a1025 .. "/" .. _a1029.Name }
end
end
end
end
if _a574.ZonesU then
for _a1030, _a1031 in ipairs({ "GetBreakableZones", "GetBreakableSpawns" }) do
local _a1032 = rawget(_a574.ZonesU, _a1031)
if type(_a1032) == "function" then
local _a1033, _a1034 = pcall(_a1032, _a1008)
if _a1033 and _a1034 then _a1023(_a1034, _a1031) end
end
end
end
if _a1011 then
for _a1035, _a1036 in ipairs({ "BREAK_ZONES", "BREAKABLE_SPAWNS" }) do
local _a1037, _a1038 = pcall(function() return _a1011:FindFirstChild(_a1036, true) end)
if _a1037 and _a1038 then _a1023(_a1038, "ZoneFolder/" .. _a1036) end
end
end
local _a1039, _a1040, _a1041
for _a1042, _a1043 in ipairs(_a1022) do
local _a1044 = 0
for _a1045, _a1046 in ipairs(_a1012) do
if (_a1046 - _a1043.p).Magnitude <= 150 then _a1044 += 1 end
end
if not _a1040 or _a1044 > _a1040 then _a1039, _a1040, _a1041 = _a1043.p, _a1044, _a1043.why end
end
local _a1047, _a1048
if _a1039 and (_a1040 or 0) >= 1 then
_a1047, _a1048 = _a1039, ("%s (브레이커블 %d개)"):format(tostring(_a1041), _a1040)
end
if not _a1047 and _a1039 then
_a1047, _a1048 = _a1039, tostring(_a1041) .. " (브레이커블 없음)"
end
if not _a1047 and _a574.ZonesU and rawget(_a574.ZonesU, "GetTeleportPartLocation") then
local _a1049, _a1050 = pcall(_a574.ZonesU.GetTeleportPartLocation, _a1008)
if _a1049 and typeof(_a1050) == "CFrame" then
_a1047, _a1048 = _a1050.Position, "PERSISTENT/Teleport (스트리밍 대기)"
end
end
if not _a1047 then return nil, "브레이커블 위치를 못 찾음" end
local _a1051 = _a576.groundY(_a1047.X, _a1047.Z, _a1047.Y)
if _a1051 then
_a1047 = Vector3.new(_a1047.X, _a1051, _a1047.Z)
_a1048 = _a1048 .. " +지면"
else
_a1047 = Vector3.new(_a1047.X, _a1047.Y + 5, _a1047.Z)
end
return _a1047, _a1048
end
function _a576.goToZone(_a1052, _a1053, _a1054, _a1055)
_a1052 = _a576.realZone(_a1052)
if not _a1052 then return false, "존 id 없음" end
local _a1056, _a1057 = _a576.zonePos(_a1052)
if not _a1056 then
if _a568.TpGameFallback and _a576.curZone() ~= _a1052 then
local _a1058, _a1059 = _a576.tpZone(_a1052)
if not _a1058 then return false, _a1059 end
task.wait(0.3)
_a1056, _a1057 = _a576.zonePos(_a1052)
end
if not _a1056 then
local _a1060, _a1061 = _a576.resolvableZone(_a1052)
if _a1060 and _a1061 then
if _a1055 then
return false, ("%s 가 로드되지 않음"):format(tostring(_a1052))
end
_a1052, _a1056, _a1057 = _a1060, _a1061, "대체 존 " .. tostring(_a1060)
else
if _a576.zoneFailSaid ~= _a1052 then
_a576.zoneFailSaid = _a1052
_a562(("[TP] %s 좌표 실패: %s (갈 수 있는 존이 없음)"):format(
tostring(_a1052), tostring(_a1057)))
end
return false, _a1057
end
end
end
local _a1062 = _a576.hrp()
if not _a1054 and _a1062 and _a576.curZone() == _a1052 then
local _a1063 = _a576.inDottedBox()
local _a1064
if _a1063 ~= nil then
_a1064 = _a1063
else
_a1064 = (_a1062.Position - _a1056).Magnitude <= (_a568.ZoneArriveDist or 90)
end
if _a1064 then
if _a1053 then _a562("[TP] 이미 " .. _a1052 .. " 사냥터 안에 있음") end
return true
end
end
if _a1053 then
_a562(("[TP] %s 내부 좌표 %s → (%.0f, %.0f, %.0f)"):format(
_a1052, tostring(_a1057), _a1056.X, _a1056.Y, _a1056.Z))
end
local _a1065, _a1066 = _a576.glideTo(_a1056)
local _a1067 = _a576.hrp()
if _a1067 and (_a1067.Position - _a1056).Magnitude > math.max(40, _a568.ArriveDist or 12) then
task.wait(0.2)
_a576.moving = nil
_a576.glideTo(_a1056)
local _a1068 = _a576.hrp()
local _a1069 = _a1068 and (_a1068.Position - _a1056).Magnitude or -1
if _a1069 > math.max(40, _a568.ArriveDist or 12) then
local _a1070 = _a568.TpMode
_a568.TpMode = "glide"
_a576.moving = nil
_a576.glideTo(_a1056)
_a568.TpMode = _a1070
local _a1071 = _a576.hrp()
_a1069 = _a1071 and (_a1071.Position - _a1056).Magnitude or -1
if _a1069 > math.max(40, _a568.ArriveDist or 12) then
_a562(("[TP] %s 이동 실패 — %.0f스터드 남음 (순간이동·glide 둘 다)"):format(
tostring(_a1052), _a1069))
return false, "이동이 되돌려짐"
end
_a562("[TP] 순간이동이 막혀서 glide 로 이동함: " .. tostring(_a1052))
end
end
do
local _a1072 = _a576.hrp()
if _a1072 and (_a1072.Position.Y - _a1056.Y) > 25 then
_a562(("[TP] 목표보다 %.0f 높은 곳에 얹힘 — 내려감"):format(_a1072.Position.Y - _a1056.Y))
_a576.moving = nil
_a576.glideTo(Vector3.new(_a1056.X, _a1056.Y, _a1056.Z))
end
end
if tostring(_a1057):find("스트리밍", 1, true) then
task.wait(1.2)
local _a1073, _a1074 = _a576.zonePos(_a1052)
if _a1073 and not tostring(_a1074):find("스트리밍", 1, true) then
if _a1053 then
_a562("[TP] 스트리밍 로드됨 → 사냥터로 (" .. tostring(_a1074) .. ")")
end
_a576.moving = nil
_a576.glideTo(_a1073)
_a1056, _a1057 = _a1073, _a1074
end
end
if _a576.inDottedBox() == false then
task.wait(0.2)
local _a1075, _a1076 = _a576.breakCenter(400)
if _a1075 and _a1076 >= 3 then
if _a1053 then
_a562(("[TP] 네모 밖 → 주변 브레이커블 %d개 중심으로 보정"):format(_a1076))
end
_a576.moving = nil
_a576.glideTo(_a1075)
_a1056 = _a1075
end
if _a576.inDottedBox() == false then
local _a1077 = _a576.zonePos(_a1052)
if _a1077 and (_a1077 - _a1056).Magnitude > 5 then
if _a1053 then _a562("[TP] 아직 네모 밖 → 좌표 재계산 후 재시도") end
_a576.moving = nil
_a576.glideTo(_a1077)
_a1056 = _a1077
end
end
if _a576.inDottedBox() == false and _a1053 then
_a562(("[TP] %s 네모 안으로 못 들어감 (좌표 %s)"):format(_a1052, tostring(_a1057)))
end
end
local function _a1078()
if _a576.inDottedBox() == true then return false end
local _a1079, _a1080 = _a576.breakCenter(400)
if (_a1080 or 0) >= 1 then return false end
task.wait(0.6)
if _a576.inDottedBox() == true then return false end
local _a1081, _a1082 = _a576.breakCenter(400)
return (_a1082 or 0) < 1
end
if _a1078() and (os.clock() - (_a576.lastRecover or -999)) > 30 then
_a576.lastRecover = os.clock()
_a562(("[TP] %s 근처에 브레이커블이 없음 (%s) — 좌표 확인 필요"):format(
tostring(_a1052), tostring(_a1057)))
end
_a576.zoneFailSaid = nil
_a576.arrivedZone = _a1052
do
local _a1083 = _a576.hrp()
local _a1084 = _a1083 and (_a1083.Position - _a1056).Magnitude or 0
if _a1084 > math.max(60, _a568.ArriveDist or 12) then
_a562(("[TP] %s 도착 실패 — %.0f스터드 남음 (되돌려짐)"):format(tostring(_a1052), _a1084))
return false, "이동이 되돌려짐"
end
end
local _a1085 = _a576.hrp()
if _a1053 and _a1085 then
_a562(("[TP] 도착. 목표까지 %.0f스터드 / 존 %s / 네모안 %s"):format(
(_a1085.Position - _a1056).Magnitude, tostring(_a576.curZone()), tostring(_a576.inDottedBox())))
end
return true
end
function _a576.tpEgg(_a1086)
if not _a1086 then return false, "알 id 없음" end
for _a1087, _a1088 in ipairs(_a576.eggStands()) do
if _a1088.id == _a1086 then
if _a1088.dist <= _a568.EggRange then return true, _a1086 end
local _a1089, _a1090 = _a576.glideTo(_a1088.pos)
return _a1089, _a1089 and _a1086 or _a1090
end
end
if _a568.TpGameFallback then
local _a1091 = _a574.DirEggs and rawget(_a574.DirEggs, _a1086)
local _a1092 = _a1091 and select(1, _a576.zoneByNumber(rawget(_a1091, "zoneNumber")))
if _a1092 and _a576.curZone() ~= _a1092 then
local _a1093, _a1094 = _a576.tpZone(_a1092)
if not _a1093 then return false, _a1094 end
task.wait(0.5)
_a576._standsAt = nil
for _a1095, _a1096 in ipairs(_a576.eggStands()) do
if _a1096.id == _a1086 then return _a576.glideTo(_a1096.pos), _a1086 end
end
end
end
return false, "알 받침대를 못 찾음 (" .. tostring(_a1086) .. ")"
end
function _a576.stacks(_a1097)
local _a1098 = _a603()
local _a1099 = _a1098 and rawget(_a1098, "Inventory")
local _a1100 = _a1099 and rawget(_a1099, _a1097)
if type(_a1100) ~= "table" then return {} end
local _a1101 = {}
for _a1102, _a1103 in pairs(_a1100) do
if type(_a1103) == "table" then
_a1101[#_a1101 + 1] = {
uid = _a1102,
id = tostring(rawget(_a1103, "id")),
tier = tonumber(rawget(_a1103, "tn")) or 1,
am = tonumber(rawget(_a1103, "_am")) or 1,
}
end
end
return _a1101
end
_a576.PERTIER = {
Potion  = { 3, 3, 4, 5, 5, 5, 5, 5, 7, 7, 7 },
Enchant = { 5, 5, 5, 7, 7, 7, 7, 7, 10, 10 },
}
function _a576.perTier(_a1104, _a1105)
_a1105 = tonumber(_a1105)
local _a1106 = _a574.Bal and rawget(_a574.Bal,
_a1104 == "Potion" and "CalcPotionsPerTierRequired" or "CalcEnchantsPerTierRequired")
if type(_a1106) == "function" then
local _a1107, _a1108 = pcall(_a1106, _a1105)
_a1108 = _a1107 and tonumber(_a1108) or nil
if _a1108 and _a1108 > 0 then return _a1108 end
if not _a1107 and not _a576.perTierWarned then
_a576.perTierWarned = true
_a562("[퀘스트] 재료 수량 함수 막힘 → 기본표로 계산 (" .. tostring(_a1108) .. ")")
end
end
local _a1109 = _a576.PERTIER[_a1104]
local _a1110 = _a1109 and _a1105 and _a1109[_a1105]
return (_a1110 and _a1110 > 0) and _a1110 or nil
end
function _a576.upgradeTo(_a1111, _a1112)
local _a1113 = (_a1111 == "Potion") and _a574.R_PotUp or _a574.R_EncUp
if not _a1113 then return 0, (_a1111 .. " 업글 리모트 없음") end
local _a1114 = math.max(1, (tonumber(_a1112) or 2) - 1)
local _a1115 = _a576.perTier(_a1111, _a1114)
if not _a1115 then return 0, ("T%d 재료 수량을 못 읽음"):format(_a1114) end
local _a1116, _a1117 = {}, 0
for _a1118, _a1119 in ipairs(_a576.stacks(_a1111)) do
if _a1119.tier == _a1114 then
local _a1120 = math.floor(_a1119.am / _a1115)
if _a1120 > 0 then _a1116[_a1119.uid] = _a1120 _a1117 += _a1120 end
end
end
if _a1117 < 1 then return 0, ("T%d 재료 부족 (T%d %d개당 1개)"):format(_a1114, _a1114, _a1115) end
local _a1121, _a1122
pcall(function() _a1121, _a1122 = _a1113:InvokeServer(_a1116) end)
if not _a1121 then return 0, tostring(_a1122) end
return _a1117
end
function _a576.usePotion(_a1123, _a1124)
if not _a574.R_PotUse then return 0, "Potions: Consume 리모트 없음" end
_a1123 = tonumber(_a1123) or 1
local _a1125 = {}
for _a1126, _a1127 in ipairs(_a576.stacks("Potion")) do
if _a1127.tier >= _a1123 and _a1127.am >= 1 then _a1125[#_a1125 + 1] = _a1127 end
end
if #_a1125 == 0 then return 0, ("T%d 이상 포션 없음"):format(_a1123) end
table.sort(_a1125, function(_a1128, _a1129) return _a1128.tier < _a1129.tier end)
local _a1130, _a1131 = _a1124, 0
for _a1132, _a1133 in ipairs(_a1125) do
for _a1134 = 1, math.min(_a1130, _a1133.am) do
if _a1130 < 1 or not _a569.quest then break end
pcall(function() _a574.R_PotUse:FireServer(_a1133.uid, 1) end)
_a1131 += 1
_a1130 -= 1
task.wait(0.12)
end
if _a1130 < 1 then break end
end
return _a1131
end
_a576.EVENTKIND = {
[31]="CoinJar",    [37]="CoinJar",    [68]="CoinJar",
[32]="Comet",      [38]="Comet",      [69]="Comet",
[66]="Pinata",     [43]="Pinata",     [70]="Pinata",
[67]="LuckyBlock", [44]="LuckyBlock", [71]="LuckyBlock",
}
_a576.BESTONLY = { [37]=true, [38]=true, [43]=true, [44]=true, [39]=true, [76]=true }
_a576.CHESTKIND = { [8]="MiniChests", [39]="MiniChests", [72]="MiniChests",
[75]="SuperiorMiniChests", [76]="SuperiorMiniChests", [77]="SuperiorMiniChests" }
local function _a1135(_a1136)
if typeof(_a1136) == "Vector3" then return _a1136 end
if typeof(_a1136) == "CFrame" then return _a1136.Position end
if type(_a1136) == "table" then
local _a1137, _a1138, _a1139 = tonumber(_a1136.X or _a1136.x or _a1136[1]), tonumber(_a1136.Y or _a1136.y or _a1136[2]), tonumber(_a1136.Z or _a1136.z or _a1136[3])
if _a1137 and _a1138 and _a1139 then return Vector3.new(_a1137, _a1138, _a1139) end
end
return nil
end
function _a576.events()
local _a1140
if _a574.Rand and rawget(_a574.Rand, "GetActive") then
local _a1141, _a1142 = pcall(_a574.Rand.GetActive)
if _a1141 and type(_a1142) == "table" and next(_a1142) then _a1140 = _a1142 end
end
if not _a1140 and _a574.R_Events then
local _a1143, _a1144 = pcall(function() return _a574.R_Events:InvokeServer() end)
if _a1143 and type(_a1144) == "table" then _a1140 = _a1144 end
end
if type(_a1140) ~= "table" then return {} end
local _a1145 = workspace:GetServerTimeNow()
local _a1146 = {}
for _a1147, _a1148 in pairs(_a1140) do
if type(_a1148) == "table" then
local _a1149 = tostring(rawget(_a1148, "id") or "")
local _a1150 = _a1149:match("|%s*(%S+)%s*$") or _a1149
local _a1151 = tonumber(rawget(_a1148, "started")) or 0
local _a1152 = tonumber(rawget(_a1148, "duration")) or 0
_a1146[#_a1146 + 1] = {
uid = rawget(_a1148, "uid"),
id = _a1149,
kind = _a1150,
name = rawget(_a1148, "name") or _a1150,
zone = rawget(_a1148, "parentID"),
pos = _a1135(rawget(_a1148, "origin")),
left = math.max(0, _a1152 - (_a1145 - _a1151)),
}
end
end
table.sort(_a1146, function(_a1153, _a1154) return _a1153.left > _a1154.left end)
return _a1146
end
_a576.SPAWN = {
CoinJar    = { rem = "CoinJar_Spawn",           key = "coin jar",
order = { "basic", "giant", "magic" } },
Comet      = { rem = "Comet_Spawn",             key = "comet" },
Pinata     = { rem = "MiniPinata_Consume",      key = "pinata" },
LuckyBlock = { rem = "MiniLuckyBlock_Consume",  key = "lucky block" },
}
function _a576.inDottedBox()
if _a574.Map and rawget(_a574.Map, "IsInDottedBox") then
local _a1155, _a1156 = pcall(_a574.Map.IsInDottedBox)
if _a1155 then return _a1156 and true or false end
end
return nil
end
function _a576.spawnItems(_a1157)
local _a1158 = _a576.SPAWN[_a1157]
if not _a1158 then return {} end
local _a1159 = {}
for _a1160, _a1161 in ipairs({ "Misc", "Consumable", "Lootbox" }) do
for _a1162, _a1163 in ipairs(_a576.stacks(_a1161)) do
local _a1164 = _a1163.id:lower()
if _a1164:find(_a1158.key, 1, true) then
local _a1165 = 99
if _a1158.order then
for _a1166, _a1167 in ipairs(_a1158.order) do
if _a1164:find(_a1167, 1, true) then _a1165 = _a1166 break end
end
end
_a1163.rank = _a1165
_a1159[#_a1159 + 1] = _a1163
end
end
end
table.sort(_a1159, function(_a1168, _a1169)
if _a1168.rank ~= _a1169.rank then return _a1168.rank < _a1169.rank end
return _a1168.tier < _a1169.tier
end)
return _a1159
end
function _a576.spawnEvent(_a1170)
local _a1171 = _a576.SPAWN[_a1170]
if not _a1171 then return 0, "소환 불가 종류" end
local _a1172 = _a566:FindFirstChild(_a1171.rem)
if not _a1172 then return 0, _a1171.rem .. " 리모트 없음" end
local _a1173 = _a576.spawnItems(_a1170)
if #_a1173 == 0 then return 0, _a1170 .. " 아이템 없음" end
local _a1174 = _a576.inDottedBox()
if _a1174 == false then return 0, "점선 네모 안이 아님" end
local _a1175, _a1176 = 0, nil
for _a1177, _a1178 in ipairs(_a1173) do
if _a1175 >= (_a568.SpawnPerCycle or 1) or not _a569.quest then break end
local _a1179, _a1180
pcall(function() _a1179, _a1180 = _a1172:InvokeServer(_a1178.uid) end)
if _a1179 then
_a1175 += 1
_a576.setAct("소환", _a1170 .. " · " .. _a1178.id)
_a562(("  🎁 %s 소환  (%s)"):format(_a1170, _a1178.id))
task.wait(0.4)
else
_a1176 = _a1180
break
end
end
return _a1175, _a1176
end
function _a576.findEvent(_a1181, _a1182)
local _a1183 = _a1182 and _a576.bestZone() or nil
local _a1184
for _a1185, _a1186 in ipairs(_a576.events()) do
if _a1186.kind == _a1181 and _a1186.left > 15 then
if not _a1182 or _a1186.zone == _a1183 then
if not _a1184 or (_a1186.zone == _a576.curZone() and _a1184.zone ~= _a576.curZone()) then
_a1184 = _a1186
end
end
end
end
return _a1184
end
function _a576.findChest(_a1187, _a1188)
local _a1189 = workspace:FindFirstChild("__THINGS")
if not _a1189 then return nil end
local _a1190 = tostring(_a1187):lower():find("superior") ~= nil
local _a1191 = _a576.hrp()
local _a1192 = _a1191 and _a1191.Position
local _a1193, _a1194, _a1195, _a1196
for _a1197, _a1198 in ipairs(_a1189:GetChildren()) do
if tostring(_a1198.Name):lower():find("chest", 1, true) then
for _a1199, _a1200 in ipairs(_a1198:GetChildren()) do
local _a1201
if _a1200:IsA("BasePart") then _a1201 = _a1200.Position
elseif _a1200:IsA("Model") then
local _a1202, _a1203 = pcall(function() return _a1200:GetPivot() end)
if _a1202 and typeof(_a1203) == "CFrame" then _a1201 = _a1203.Position end
end
if _a1201 then
local _a1204 = _a1192 and (_a1201 - _a1192).Magnitude or 0
local _a1205 = (tostring(_a1200.Name) .. tostring(_a1198.Name)):lower()
:find("superior", 1, true) ~= nil
if not _a1196 or _a1204 < _a1196 then _a1195, _a1196 = _a1201, _a1204 end
if _a1205 == _a1190 and (not _a1194 or _a1204 < _a1194) then
_a1193, _a1194 = _a1201, _a1204
end
end
end
end
end
if _a1193 then return _a1193, _a1194 end
return _a1195, _a1196
end
_a576.SKIP = { [4] = true, [5] = true, [40] = true, [41] = true }
_a576.WHERE = {
[21]="bestzone", [9]="bestzone", [37]="bestzone", [38]="bestzone", [39]="bestzone",
[43]="bestzone", [44]="bestzone", [76]="bestzone", [30]="bestzone", [8]="bestzone",
[20]="bestegg",  [42]="bestegg",
[1]="breakable", [81]="zoneid",
}
function _a576.petStacks()
local _a1206 = _a603()
local _a1207 = _a1206 and rawget(_a1206, "Inventory")
local _a1208 = _a1207 and rawget(_a1207, "Pet")
local _a1209 = {}
if type(_a1208) ~= "table" then return _a1209 end
for _a1210, _a1211 in pairs(_a1208) do
if type(_a1211) == "table" then
_a1209[#_a1209 + 1] = {
uid = _a1210,
id = tostring(rawget(_a1211, "id")),
pt = tonumber(rawget(_a1211, "pt")) or 0,
am = tonumber(rawget(_a1211, "_am")) or 1,
}
end
end
return _a1209
end
function _a576.bestEggPets()
local _a1212 = _a644()
local _a1213 = _a1212 and _a574.DirEggs and rawget(_a574.DirEggs, _a1212)
local _a1214 = _a1213 and rawget(_a1213, "pets")
local _a1215 = {}
if type(_a1214) == "table" then
for _a1216, _a1217 in pairs(_a1214) do
local _a1218 = type(_a1217) == "table" and _a1217[1] or _a1217
if _a1218 then _a1215[tostring(_a1218)] = true end
end
end
return _a1215, _a1212
end
function _a576.makeVariant(_a1219, _a1220)
local _a1221 = (_a1219 == "gold") and _a574.R_Gold or _a574.R_Rain
if not _a1221 then return 0, (_a1219 .. " 머신 리모트 없음") end
local _a1222 = (_a1219 == "gold") and 0 or 1
local _a1223
if _a1220 then
local _a1224, _a1225 = _a576.bestEggPets()
if not next(_a1224) then return 0, "최고 알(" .. tostring(_a1225) .. ") 펫 목록을 못 읽음" end
_a1223 = _a1224
end
local _a1226, _a1227 = 0, nil
for _a1228, _a1229 in ipairs(_a576.petStacks()) do
if not _a569.quest then break end
if _a1229.pt == _a1222 and _a1229.am >= 10 and (not _a1223 or _a1223[_a1229.id]) then
local _a1230 = math.floor(_a1229.am / 10)
if _a1230 > 0 then
local _a1231, _a1232
pcall(function() _a1231, _a1232 = _a1221:InvokeServer(_a1229.uid, _a1230) end)
if _a1231 then
_a1226 += _a1230
_a562(("  ✨ %s 제작  %s x%d"):format(
_a1219 == "gold" and "골드" or "레인보우", _a1229.id, _a1230))
task.wait(0.4)
else
_a1227 = _a1232
end
end
end
end
return _a1226, _a1227
end
function _a576.useFlag(_a1233)
if not _a574.R_Flag then return 0, "FlexibleFlags_Consume 리모트 없음" end
local _a1234, _a1235 = 0, nil
for _a1236, _a1237 in ipairs(_a576.stacks("Misc")) do
if _a1234 >= (_a1233 or 1) then break end
if _a1237.id:lower():find("flag", 1, true) and _a1237.am >= 1 and _a576.itemAllowed(_a1237.id) then
local _a1238, _a1239
pcall(function() _a1238, _a1239 = _a574.R_Flag:InvokeServer(_a1237.id, _a1237.uid, 1) end)
if _a1238 then _a1234 += 1 task.wait(0.4) else _a1235 = _a1239 end
end
end
return _a1234, _a1235
end
function _a576.useFruit(_a1240)
if not _a574.R_Fruit then return 0, "Fruits: Consume 리모트 없음" end
local _a1241 = _a576.activeBuffs("Fruits")
local _a1242 = 0
for _a1243, _a1244 in ipairs(_a576.stacks("Fruit")) do
if _a1242 >= (_a1240 or 1) then break end
if _a1244.am >= 1 and _a576.itemAllowed(_a1244.id) and not _a1241[_a1244.id] then
pcall(function() _a574.R_Fruit:FireServer(_a1244.uid, 1) end)
_a1242 += 1
task.wait(0.4)
end
end
return _a1242
end
function _a576.status()
local _a1245 = _a603()
if not _a1245 then return nil end
local _a1246 = rawget(_a1245, "Goals")
if type(_a1246) ~= "table" then return { list = {} } end
local _a1247 = {}
for _a1248, _a1249 in pairs(_a1246) do
if type(_a1249) == "table" then
local _a1250 = tonumber(rawget(_a1249, "Type")) or -1
local _a1251
if _a574.Quest and rawget(_a574.Quest, "MakeTitle") then
local _a1252, _a1253 = pcall(_a574.Quest.MakeTitle, _a1249)
if _a1252 then _a1251 = _a1253 end
end
_a1247[#_a1247 + 1] = {
slot = _a1248,
uid = tostring(rawget(_a1249, "UID")),
type = _a1250,
how = _a575[_a1250],
title = _a1251 or ("Type " .. _a1250),
amount = tonumber(rawget(_a1249, "Amount")) or 0,
progress = tonumber(rawget(_a1249, "Progress")) or 0,
stars = tonumber(rawget(_a1249, "Stars")) or 0,
potionTier = tonumber(rawget(_a1249, "PotionTier")),
enchantTier = tonumber(rawget(_a1249, "EnchantTier")),
breakable = rawget(_a1249, "BreakableType") or rawget(_a1249, "BreakableDirID"),
zoneId = rawget(_a1249, "ZoneID"),
where = _a576.WHERE[_a1250] or (_a575[_a1250] == "farm" and "bestzone" or nil),
event = _a576.EVENTKIND[_a1250],
chest = _a576.CHESTKIND[_a1250],
bestOnly = _a576.BESTONLY[_a1250] or false,
ignored = _a576.IGNORE[_a1250],
}
end
end
table.sort(_a1247, function(_a1254, _a1255) return _a1254.stars > _a1255.stars end)
return { list = _a1247, rank = tonumber(rawget(_a1245, "Rank")) or 1,
rankStars = tonumber(rawget(_a1245, "RankStars")) or 0 }
end
_a576.BESTDEP = {
[20]=true, [21]=true, [37]=true, [38]=true, [39]=true,
[43]=true, [44]=true, [76]=true,
}
function _a576.bestDepActive()
local _a1256 = _a576.lockGoal and _a576.lockGoal.q
if not _a1256 then return false end
if _a576.IGNORE[_a1256.type] then return false end
if not _a576.BESTDEP[_a1256.type] then return false end
local _a1257 = _a576.findQuest(_a1256.uid)
if not _a1257 or _a1257.progress >= _a1257.amount then return false end
return true, _a1257
end
function _a576.canDo(_a1258, _a1259)
if _a1258.how == "hatch" or _a1258.where == "bestegg" then
local _a1260 = _a669()
if not _a1260 then return false, "알 정보를 못 읽음" end
if not _a1260.price then return true end
if not _a1259 then
if _a1260.canBuy < 1 then
return false, ("돈 부족 — %s 개당 %s %s / 보유 %s"):format(
tostring(_a1260.id), _a563(_a1260.price, 0), tostring(_a1260.currency), _a563(_a1260.have, 0))
end
return true
end
local _a1261 = math.max(1, (_a1258.amount or 1) - (_a1258.progress or 0))
local _a1262 = _a1261
if _a1258.type == 2 or _a1258.type == 42 or _a1258.type == 47 then
_a1262 = math.max(_a1261, _a568.HatchMinAfford or 10)
end
if _a1260.canBuy < _a1262 then
_a576.moneyUntil = os.clock() + math.max(0, _a568.MoneyDwell or 60)
return false, ("돈 모으는 중 — %d개분 필요 / 지금 %d개분 (개당 %s %s)"):format(
_a1262, _a1260.canBuy, _a563(_a1260.price, 0), tostring(_a1260.currency))
end
if _a576.moneyUntil and os.clock() < _a576.moneyUntil then
return false, ("조금 더 벌고 감 (%.0f초 남음)"):format(_a576.moneyUntil - os.clock())
end
_a576.moneyUntil = nil
end
return true
end
function _a576.findQuest(_a1263)
local _a1264 = _a576.status()
for _a1265, _a1266 in ipairs(_a1264 and _a1264.list or {}) do
if _a1266.uid == _a1263 then return _a1266 end
end
return nil
end
function _a576.pursue(_a1267)
local _a1268, _a1269
if _a1267.how == "hatch" then _a1268, _a1269 = _a680, "mhatch"
elseif _a1267.how == "zone" then _a1268, _a1269 = _a639, "zone"
elseif _a1267.how == "gold" or _a1267.how == "rainbow" then
local _a1270 = (_a1267.type == 40 or _a1267.type == 41)
_a1269 = "quest"
_a1268 = function()
local _a1271 = _a576.makeVariant("gold", _a1270) or 0
if _a1267.how == "rainbow" then
_a1271 += (_a576.makeVariant("rainbow", _a1270) or 0)
end
if _a1271 > 0 then
_a576.setAct(_a1267.how == "gold" and "골드 합성" or "레인보우 합성", _a1271 .. "마리")
return
end
_a576.setAct("재료 모으는 중", "최고 알 부화")
local _a1272 = _a569.mhatch
_a569.mhatch = true
pcall(_a680)
_a569.mhatch = _a1272
end
end
local _a1273 = _a1267.progress
local _a1274 = os.clock()
_a576.setGoal(_a1267.title, ("%d/%d"):format(_a1267.progress, _a1267.amount))
local function _a1275()
if not _a1267.event then return end
local _a1276 = _a576.findEvent(_a1267.event, _a1267.bestOnly)
if _a1276 then
_a576.setAct(_a1267.event .. " 진행 중", ("%d초 남음"):format(_a1276.left))
if _a1276.pos then
local _a1277 = _a576.hrp()
if _a1277 and (_a1277.Position - _a1276.pos).Magnitude > (_a568.EventStayDist or 45) then
_a576.glideTo(_a1276.pos)
end
end
return
end
local _a1278, _a1279 = _a576.spawnEvent(_a1267.event)
if _a1278 > 0 then
_a576.setAct("소환", _a1267.event)
task.wait(0.5)
elseif _a1279 and _a576.spawnErr ~= tostring(_a1279) then
_a576.spawnErr = tostring(_a1279)
_a562("[퀘스트] " .. _a1267.event .. " 소환 실패: " .. tostring(_a1279))
end
end
local _a1280, _a1281 = pcall(function()
while _a569.quest and not _a576.stopped() do
local _a1282, _a1283 = _a576.canDo(_a1267, false)
if not _a1282 then
_a562(("[퀘스트] %s → 다른 퀘스트 먼저 (%s)"):format(tostring(_a1267.title), tostring(_a1283)))
return
end
_a1275()
if _a1268 then
local _a1284 = _a569[_a1269]
_a569[_a1269] = true
local _a1285, _a1286 = pcall(_a1268)
_a569[_a1269] = _a1284
if not _a1285 then error(_a1286, 0) end
elseif _a1267.event then
task.wait(0.4)
else
task.wait(2)
end
local _a1287 = _a576.findQuest(_a1267.uid)
if not _a1287 then
_a562("[퀘스트] 완료 — " .. tostring(_a1267.title))
return
end
_a576.setGoal(_a1287.title, ("%d/%d"):format(_a1287.progress, _a1287.amount))
if _a1287.progress >= _a1287.amount then
_a562(("[퀘스트] 달성 %d/%d — %s"):format(_a1287.progress, _a1287.amount, tostring(_a1287.title)))
return
end
if _a1287.progress > _a1273 then
_a1274 = os.clock()
_a562(("[퀘스트] %d/%d  %s"):format(_a1287.progress, _a1287.amount, tostring(_a1287.title)))
end
_a1273 = _a1287.progress
local _a1288 = os.clock() - _a1274
if _a1288 >= math.max(10, _a568.PursueStallSec or 60) then
_a562(("[퀘스트] %.0f초째 진행 없음 (%d/%d) — 다음 단계로: %s"):format(
_a1288, _a1287.progress, _a1287.amount, tostring(_a1287.title)))
return
end
task.wait(0.2)
end
end)
if not _a1280 then _a562("[퀘스트] " .. tostring(_a1267.how) .. " 오류: " .. tostring(_a1281)) end
_a576.lockGoal = nil
_a576.setGoal(nil)
end
function _a576.cycle()
do
local _a1289 = _a569.rank
_a569.rank = true
pcall(_a730)
_a569.rank = _a1289
end
local _a1290 = _a576.status()
if not _a1290 then return end
local _a1291, _a1292, _a1293 = false, false, false
local _a1294 = {}
local _a1295 = nil
for _a1296, _a1297 in ipairs(_a1290.list) do
if not _a569.quest then break end
local _a1298, _a1299 = true, nil
if not _a1297.ignored and _a1297.progress < _a1297.amount then
_a1298, _a1299 = _a576.canDo(_a1297, true)
end
if _a1297.ignored then
if _a1297.progress < _a1297.amount then
_a1294[#_a1294 + 1] = tostring(_a1297.title) .. "  — " .. _a1297.ignored
end
elseif not _a1298 then
local _a1300 = tostring(_a1297.uid) .. tostring(_a1299)
if _a576.skipSaid ~= _a1300 then
_a576.skipSaid = _a1300
_a562(("[퀘스트] 건너뜀: %s   (%s)"):format(tostring(_a1297.title), tostring(_a1299)))
end
elseif _a1297.progress < _a1297.amount then
local _a1301 = _a1297.where
if _a1297.event then
if not _a1295 or _a1295.rank > 0 then _a1295 = { rank = 0, kind = "event", q = _a1297 } end
elseif _a1297.chest then
if not _a1295 or _a1295.rank > 1 then _a1295 = { rank = 1, kind = "chest", q = _a1297 } end
elseif _a1301 == "bestegg" then
if not _a1295 or _a1295.rank > 1 then _a1295 = { rank = 1, kind = "egg", q = _a1297 } end
elseif _a1301 == "breakable" and _a1297.breakable then
if not _a1295 or _a1295.rank > 2 then _a1295 = { rank = 2, kind = "breakable", q = _a1297 } end
elseif _a1301 == "zoneid" and _a1297.zoneId then
if not _a1295 or _a1295.rank > 2 then _a1295 = { rank = 2, kind = "zoneid", q = _a1297 } end
elseif _a1301 == "bestzone" or _a1301 == "breakable" then
if not _a1295 then _a1295 = { rank = 3, kind = "bestzone", q = _a1297 } end
end
if _a1297.how == "farm" then
_a1291 = true
elseif _a1297.how == "hatch" then
_a1292 = true
elseif _a1297.how == "zone" then
_a1293 = true
elseif _a1297.how == "potup" and _a568.QuestUpgrade then
local _a1302, _a1303 = _a576.upgradeTo("Potion", _a1297.potionTier or 2)
if _a1302 > 0 then
_a570.potup += _a1302
_a570.quest += 1
_a562(("[퀘스트] 포션 T%d %d개 제작  (%s)"):format(_a1297.potionTier or 2, _a1302, _a1297.title))
elseif _a1303 and not tostring(_a1303):find("부족") then
if _a576.potUpSaid ~= tostring(_a1303) then
_a576.potUpSaid = tostring(_a1303)
_a562("[퀘스트] 포션 업글 실패: " .. tostring(_a1303))
end
end
elseif _a1297.how == "encup" and _a568.QuestUpgrade then
local _a1304, _a1305 = _a576.upgradeTo("Enchant", _a1297.enchantTier or 2)
if _a1304 > 0 then
_a570.potup += _a1304
_a570.quest += 1
_a562(("[퀘스트] 인챈트 T%d %d개 제작  (%s)"):format(_a1297.enchantTier or 2, _a1304, _a1297.title))
elseif _a1305 and not tostring(_a1305):find("부족") then
if _a576.encUpSaid ~= tostring(_a1305) then
_a576.encUpSaid = tostring(_a1305)
_a562("[퀘스트] 인챈트 업글 실패: " .. tostring(_a1305))
end
end
elseif _a1297.how == "potuse" and _a568.QuestUsePotion then
_a576.lastUse = _a576.lastUse or {}
local _a1306 = _a576.lastUse[_a1297.uid]
if _a1306 and _a1306.used > 0 and _a1297.progress <= _a1306.progress then
if not _a1306.gaveUp then
_a1306.gaveUp = true
_a562("[퀘스트] 포션을 마셔도 진행도가 안 올라서 중단: " .. tostring(_a1297.title))
end
else
local _a1307 = math.min(_a568.QuestUseMax, math.max(1, _a1297.amount - _a1297.progress))
local _a1308, _a1309 = _a576.usePotion(_a1297.potionTier or 1, _a1307)
_a576.lastUse[_a1297.uid] = { used = _a1308, progress = _a1297.progress }
if _a1308 > 0 then
_a570.potuse += _a1308
_a570.quest += 1
_a562(("[퀘스트] 포션 %d개 사용  (%s)"):format(_a1308, _a1297.title))
elseif _a1309 and not tostring(_a1309):find("없음") then
_a562("[퀘스트] 포션 사용 실패: " .. tostring(_a1309))
end
end
elseif _a1297.how == "gold" or _a1297.how == "rainbow" then
local _a1310, _a1311 = _a576.makeVariant(_a1297.how, _a1297.type == 40 or _a1297.type == 41)
if _a1310 > 0 then
_a570.quest += 1
_a562(("[퀘스트] %s 펫 %d마리 제작  (%s)"):format(
_a1297.how == "gold" and "골드" or "레인보우", _a1310, _a1297.title))
elseif _a1311 then
_a562("[퀘스트] " .. _a1297.how .. " 실패: " .. tostring(_a1311))
end
elseif _a1297.how == "fruituse" then
local _a1312 = _a576.useFruit(math.max(1, _a1297.amount - _a1297.progress))
if _a1312 > 0 then
_a570.quest += 1
_a562(("[퀘스트] 과일 %d개 사용  (%s)"):format(_a1312, _a1297.title))
end
elseif _a1297.how == "flaguse" then
local _a1313, _a1314 = _a576.useFlag(math.max(1, _a1297.amount - _a1297.progress))
if _a1313 > 0 then
_a570.quest += 1
_a562(("[퀘스트] 깃발 %d개 사용  (%s)"):format(_a1313, _a1297.title))
elseif _a1314 then
_a562("[퀘스트] 깃발 실패: " .. tostring(_a1314))
end
elseif not _a1297.how then
_a1294[#_a1294 + 1] = _a1297.title
end
end
end
if _a568.QuestLock and _a576.lockGoal then
local _a1315
for _a1316, _a1317 in ipairs(_a1290.list) do
if _a1317.uid == _a576.lockGoal.q.uid and _a1317.progress < _a1317.amount then _a1315 = _a1317 break end
end
if _a1315 then
_a576.lockGoal.q = _a1315
_a1295 = _a576.lockGoal
else
if _a576.lockGoal.q then
_a562("[퀘스트] 완료/교체됨 → 다음 목표로: " .. tostring(_a576.lockGoal.q.title))
end
_a576.lockGoal = nil
end
end
if _a568.QuestLock and _a1295 then _a576.lockGoal = _a1295 end
if _a568.QuestTp and _a1295 and _a569.quest then
local _a1318, _a1319, _a1320
if _a1295.kind == "event" then
local _a1321 = _a576.findEvent(_a1295.q.event, _a1295.q.bestOnly)
if _a1321 then
_a1320 = ("%s @%s (%d초 남음)"):format(_a1321.name, tostring(_a1321.zone), _a1321.left)
if _a1321.pos then _a1318, _a1319 = _a576.glideTo(_a1321.pos)
else _a1318, _a1319 = _a576.goToZone(_a1321.zone) end
else
local _a1322 = _a1295.q.bestOnly and _a576.bestZone() or (_a576.curZone() or _a576.bestZone())
_a1320 = _a1295.q.event .. " 소환용 " .. tostring(_a1322)
local _a1323 = _a576.inDottedBox()
_a1318, _a1319 = _a576.goToZone(_a1322, false, _a1323 == false, _a1295.q.bestOnly)
if _a1318 then
local _a1324, _a1325 = _a576.spawnEvent(_a1295.q.event)
if _a1324 < 1 and tostring(_a1325):find("점선") then
_a576.goToZone(_a1322, false, true)
task.wait(0.2)
_a1324, _a1325 = _a576.spawnEvent(_a1295.q.event)
end
if _a1324 > 0 then
_a1320 = ("%s %d개 소환 @%s"):format(_a1295.q.event, _a1324, tostring(_a1322))
else
_a1319 = _a1325
_a1318 = false
end
end
end
elseif _a1295.kind == "chest" then
local _a1326 = _a1295.q.bestOnly and _a576.bestZone() or _a576.curZone()
local _a1327, _a1328 = _a576.findChest(_a1295.q.chest, _a1326)
_a1320 = _a1295.q.chest .. " @" .. tostring(_a1326)
if _a1327 then
if not _a1328 or _a1328 > 20 then _a576.glideTo(_a1327) end
_a1318 = true
else
_a1318, _a1319 = _a576.goToZone(_a1326)
_a1320 = _a1320 .. " (상자 없음 → 존 가운데)"
end
elseif _a1295.kind == "egg" then
local _a1329 = _a644()
_a1320 = "최고 알 " .. tostring(_a1329)
if _a1329 then _a1318, _a1319 = _a576.tpEgg(_a1329) else _a1319 = "최고 알을 못 찾음" end
elseif _a1295.kind == "breakable" then
local _a1330 = _a576.zoneForBreakable(_a1295.q.breakable)
_a1320 = tostring(_a1295.q.breakable) .. " 나오는 존 " .. tostring(_a1330)
if _a1330 then _a1318, _a1319 = _a576.goToZone(_a1330, true) else _a1319 = "그 브레이커블이 나오는 존이 없음" end
elseif _a1295.kind == "zoneid" then
_a1320 = "존 " .. tostring(_a1295.q.zoneId)
_a1318, _a1319 = _a576.goToZone(_a1295.q.zoneId)
else
local _a1331 = _a576.bestZone()
local _a1332 = _a1295.q.bestOnly or _a576.BESTDEP[_a1295.q.type] or false
if _a1331 then _a1318, _a1319 = _a576.goToZone(_a1331, true, false, _a1332)
else _a1319 = "최고 존을 못 찾음" end
_a1320 = "최고 존 " .. tostring(_a576.arrivedZone or _a1331)
if not _a1318 then _a1319 = _a1331 end
end
if _a1318 then
if _a576.lastGoal ~= _a1320 then
_a576.lastGoal = _a1320
_a562("[퀘스트] " .. _a1320 .. " 으로 이동  (" .. tostring(_a1295.q.title) .. ")")
end
_a576.pursue(_a1295.q)
else
local _a1333 = _a1319 and tostring(_a1319) or "이유 불명"
if _a576.lastFail ~= _a1333 then
_a576.lastFail = _a1333
_a562(("[퀘스트] 진행 못 함: %s   (%s / %s)"):format(
_a1333, tostring(_a1295.kind), tostring(_a1295.q.title)))
_a562(("           현재 존 %s / 최고 존 %s / 점선네모 %s"):format(
tostring(_a576.curZone()), tostring(_a576.bestZone()), tostring(_a576.inDottedBox())))
end
end
end
if _a568.QuestDrive and _a576.turnOn then
if _a1291  then _a576.turnOn("farm",   "파밍 퀘스트 → 자동 파밍") end
if _a1293  then _a576.turnOn("zone",   "존 퀘스트 → 자동 존 해금") end
if _a1292 then _a576.turnOn("mhatch", "부화 퀘스트 → 자동 부화") end
end
if #_a1294 > 0 and not _a576.manualWarned then
_a576.manualWarned = true
_a562("[퀘스트] 수동으로 해야 하는 것:")
for _a1334, _a1335 in ipairs(_a1294) do _a562("    · " .. tostring(_a1335)) end
elseif #_a1294 == 0 then
_a576.manualWarned = false
end
return _a1295 ~= nil
end
local function _a1336(_a1337)
local _a1338 = {}
for _a1339 in tostring(_a1337 or ""):gmatch("[^,]+") do
_a1339 = _a1339:match("^%s*(.-)%s*$")
if _a1339 ~= "" then _a1338[#_a1338 + 1] = _a1339:lower() end
end
return _a1338
end
function _a576.itemAllowed(_a1340)
local _a1341 = tostring(_a1340):lower()
for _a1342, _a1343 in ipairs(_a1336(_a568.ItemBlock)) do
if _a1341:find(_a1343, 1, true) then return false end
end
local _a1344 = _a1336(_a568.ItemAllow)
if #_a1344 == 0 then return true end
for _a1345, _a1346 in ipairs(_a1344) do
if _a1341:find(_a1346, 1, true) then return true end
end
return false
end
function _a576.activeBuffs(_a1347)
local _a1348 = _a603()
local _a1349 = _a1348 and rawget(_a1348, _a1347)
local _a1350 = {}
if type(_a1349) == "table" then
for _a1351, _a1352 in pairs(_a1349) do
if type(_a1352) == "table" and next(_a1352) then _a1350[_a1351] = true
elseif _a1352 then _a1350[_a1351] = true end
end
end
return _a1350
end
local function _a1353(_a1354, _a1355, _a1356, _a1357)
local _a1358 = _a576.activeBuffs(_a1355)
local _a1359 = {}
local _a1360 = { total = 0, act = 0, blocked = 0, few = 0, ok = 0 }
for _a1361, _a1362 in ipairs(_a576.stacks(_a1354)) do
_a1360.total += 1
if _a1358[_a1362.id] then _a1360.act += 1
elseif not _a576.itemAllowed(_a1362.id) then _a1360.blocked += 1
elseif _a1362.am <= _a568.ItemKeep then _a1360.few += 1
else
_a1360.ok += 1
local _a1363 = _a1359[_a1362.id]
local _a1364
if not _a1363 then _a1364 = true
elseif _a568.BuffHighTier then _a1364 = _a1362.tier > _a1363.tier
else _a1364 = _a1362.tier < _a1363.tier end
if _a1364 then _a1359[_a1362.id] = _a1362 end
end
end
if _a1360.ok == 0 and _a1360.total > 0 then
local _a1365 = ("%s %d종 중 사용 가능 0 (이미걸림 %d / 제외 %d / 재고부족 %d)")
:format(_a1354, _a1360.total, _a1360.act, _a1360.blocked, _a1360.few)
if _a576.buffSaid ~= _a1365 then
_a576.buffSaid = _a1365
_a562("[아이템] " .. _a1365)
end
elseif _a1360.ok > 0 then
_a576.buffSaid = nil
end
local _a1366 = {}
for _a1367, _a1368 in pairs(_a1359) do _a1366[#_a1366 + 1] = _a1368 end
table.sort(_a1366, function(_a1369, _a1370)
if _a1369.tier ~= _a1370.tier then return _a1369.tier > _a1370.tier end
return _a1369.am > _a1370.am
end)
local _a1371 = {}
for _a1372, _a1373 in ipairs(_a1366) do
if not _a569.items then break end
if _a1357 and _a1357.left <= 0 then break end
local _a1374 = pcall(function() _a1356(_a1373.uid, 1) end)
if _a1374 then
_a1371[#_a1371 + 1] = ("%s T%d"):format(_a1373.id, _a1373.tier)
_a570.items += 1
if _a1357 then _a1357.left -= 1 end
task.wait(0.12)
end
end
return _a1371
end
function _a576.cycleItems()
local function _a1375()
local _a1376 = {}
if _a568.BuffPotion then _a1376[#_a1376 + 1] = { "Potion", "Potions" } end
if _a568.BuffFruit then _a1376[#_a1376 + 1] = { "Fruit", "Fruits" } end
if _a568.BuffConsumable then _a1376[#_a1376 + 1] = { "Consumable", "Consumables" } end
for _a1377, _a1378 in ipairs(_a1376) do
local _a1379 = _a576.activeBuffs(_a1378[2])
for _a1380, _a1381 in ipairs(_a576.stacks(_a1378[1])) do
if _a1381.am > _a568.ItemKeep and _a576.itemAllowed(_a1381.id) and not _a1379[_a1381.id] then
return true
end
end
end
if _a568.BuffUltimate and _a574.R_Ult then
local _a1382 = _a603()
local _a1383 = _a1382 and rawget(_a1382, "Ultimates")
if type(_a1383) == "table" then
for _a1384 in pairs(_a1383) do
if _a576.itemAllowed(_a1384) then
if not (_a574.Ult and rawget(_a574.Ult, "IsCharged")) then return true end
local _a1385, _a1386 = pcall(_a574.Ult.IsCharged, _a1384)
if _a1385 and _a1386 then return true end
end
end
end
end
return false
end
if not _a1375() then return end
if _a568.ItemBestZone then
local _a1387 = _a576.bestZone()
if _a1387 and _a576.curZone() ~= _a1387 then
if not _a568.ItemTp then
if not _a576.itemZoneWarned then
_a576.itemZoneWarned = true
_a562(("[아이템] 최고 존(%s)이 아니라 대기 — 현재 %s"):format(
tostring(_a1387), tostring(_a576.curZone())))
end
return
end
local _a1388, _a1389 = _a576.goToZone(_a1387)
if not _a1388 then
_a562("[아이템] 최고 존 이동 실패: " .. tostring(_a1389))
return
end
_a562("[아이템] 최고 존 " .. tostring(_a1387) .. " 에서 사용")
end
_a576.itemZoneWarned = false
end
local _a1390 = {}
local _a1391  = { left = math.max(1, _a568.BuffMaxPotion or 5) }
local _a1392 = { left = math.max(1, _a568.BuffMaxOther or 2) }
if _a568.BuffPotion and _a574.R_PotUse then
local _a1393 = _a1353("Potion", "Potions", function(_a1394, _a1395)
_a574.R_PotUse:FireServer(_a1394, _a1395)
end, _a1391)
for _a1396, _a1397 in ipairs(_a1393) do _a1390[#_a1390 + 1] = "포션 " .. _a1397 end
end
if _a568.BuffFruit and _a574.R_Fruit then
local _a1398 = _a1353("Fruit", "Fruits", function(_a1399, _a1400)
_a574.R_Fruit:FireServer(_a1399, _a1400)
end, _a1392)
for _a1401, _a1402 in ipairs(_a1398) do _a1390[#_a1390 + 1] = "과일 " .. _a1402 end
end
if _a568.BuffConsumable and _a574.R_Cons then
local _a1403 = _a1353("Consumable", "Consumables", function(_a1404, _a1405)
_a574.R_Cons:InvokeServer(_a1404, _a1405)
end, _a1392)
for _a1406, _a1407 in ipairs(_a1403) do _a1390[#_a1390 + 1] = "소모품 " .. _a1407 end
end
if _a568.BuffUltimate and _a574.R_Ult then
local _a1408 = _a603()
local _a1409 = _a1408 and rawget(_a1408, "Ultimates")
if type(_a1409) == "table" then
for _a1410 in pairs(_a1409) do
if not _a569.items then break end
if _a576.itemAllowed(_a1410) then
local _a1411 = true
if _a574.Ult and rawget(_a574.Ult, "IsCharged") then
local _a1412, _a1413 = pcall(_a574.Ult.IsCharged, _a1410)
_a1411 = _a1412 and _a1413 and true or false
end
if _a1411 then
local _a1414
pcall(function() _a1414 = _a574.R_Ult:InvokeServer(_a1410) end)
if _a1414 then
_a1390[#_a1390 + 1] = "얼티밋 " .. tostring(_a1410)
_a570.items += 1
task.wait(0.3)
end
end
end
end
end
end
if #_a1390 > 0 then
_a576.setAct("버프 사용", table.concat(_a1390, ", "))
_a562("[아이템] " .. table.concat(_a1390, ", ") .. " 사용")
end
end
function _a576.slotStatus()
local _a1415 = _a603()
if not _a1415 then return nil end
local _a1416 = tonumber(rawget(_a1415, "PetSlotsPurchased")) or 0
local _a1417 = tonumber(rawget(_a1415, "EggSlotsPurchased")) or 0
local _a1418, _a1419 = 0, 0
if _a574.RankC then
if rawget(_a574.RankC, "GetMaxPurchasableEquipSlots") then
local _a1420, _a1421 = pcall(_a574.RankC.GetMaxPurchasableEquipSlots)
if _a1420 and tonumber(_a1421) then _a1418 = tonumber(_a1421) end
end
if rawget(_a574.RankC, "GetMaxPurchasableEggSlots") then
local _a1422, _a1423 = pcall(_a574.RankC.GetMaxPurchasableEggSlots)
if _a1422 and tonumber(_a1423) then _a1419 = tonumber(_a1423) end
end
end
local _a1424, _a1425
if _a1416 < _a1418 then
_a1424 = _a1416 + 1
if type(_a574.CalcPetS) == "function" then
local _a1426, _a1427 = pcall(_a574.CalcPetS, _a1424)
if _a1426 then _a1425 = tonumber(_a1427) end
end
end
local _a1428, _a1429, _a1430
if _a1417 < _a1419 and _a574.RankC and rawget(_a574.RankC, "GetEggBundle") then
local _a1431, _a1432, _a1433 = pcall(_a574.RankC.GetEggBundle, _a1417 + 1)
if _a1431 and tonumber(_a1432) then
_a1428, _a1429 = tonumber(_a1432), tonumber(_a1433) or 1
if type(_a574.CalcEggS) == "function" then
local _a1434, _a1435 = 0, false
for _a1436 = _a1428 - _a1429 + 1, _a1428 do
local _a1437, _a1438 = pcall(_a574.CalcEggS, _a1436)
if _a1437 and tonumber(_a1438) then _a1434 += tonumber(_a1438) else _a1435 = true end
end
if not _a1435 then _a1430 = _a1434 end
end
end
end
local _a1439
if _a574.Egg and rawget(_a574.Egg, "GetMaxHatch") then
local _a1440, _a1441 = pcall(_a574.Egg.GetMaxHatch)
if _a1440 then _a1439 = tonumber(_a1441) end
end
return {
dia = _a611("Diamonds"),
petOwned = _a1416, petMax = _a1418, petNext = _a1424, petCost = _a1425,
eggOwned = _a1417, eggMax = _a1419, eggEnd = _a1428, eggSize = _a1429, eggCost = _a1430,
maxEquip = tonumber(rawget(_a1415, "MaxPetsEquipped")), maxHatch = _a1439,
}
end
function _a576.machinePos(_a1442)
local _a1443
if _a574.Machine and rawget(_a574.Machine, "GetModels") then
local _a1444, _a1445 = pcall(_a574.Machine.GetModels, _a1442)
if _a1444 and type(_a1445) == "table" then
for _a1446, _a1447 in pairs(_a1445) do
if typeof(_a1447) == "Instance" then _a1443 = _a1447 break end
end
end
end
if not _a1443 then
local _a1448, _a1449 = pcall(function()
return game:GetService("CollectionService"):GetTagged("Machine")
end)
if _a1448 then
for _a1450, _a1451 in ipairs(_a1449) do
if _a1451.Name == _a1442 then _a1443 = _a1451 break end
end
end
end
if not _a1443 then return nil end
if _a1443:IsA("BasePart") then return _a1443.Position end
local _a1452, _a1453 = pcall(function() return _a1443:GetPivot() end)
return (_a1452 and typeof(_a1453) == "CFrame") and _a1453.Position or nil
end
function _a576.cycleSlots()
local _a1454 = 0
local _a1455 = 0
while _a569.slots and not _a576.stopped() and _a1455 < 40 do
_a1455 += 1
local _a1456 = _a576.slotStatus()
if not _a1456 then return end
local _a1457 = _a568.SlotPet and _a1456.petNext and _a1456.petCost
and (_a1456.dia - _a568.SlotReserve) >= _a1456.petCost
local _a1458 = _a568.SlotEgg and _a1456.eggEnd and _a1456.eggCost
and (_a1456.dia - _a568.SlotReserve) >= _a1456.eggCost
if _a1457 and _a1458 then
if _a1456.eggCost < _a1456.petCost then _a1457 = false else _a1458 = false end
end
if not (_a1457 or _a1458) then break end
local _a1459, _a1460, _a1461, _a1462
local function _a1463()
if _a1457 then
pcall(function() _a1459, _a1460 = _a574.R_PetSlot:InvokeServer(_a1456.petNext) end)
else
pcall(function() _a1459, _a1460 = _a574.R_EggSlot:InvokeServer(_a1456.eggEnd) end)
end
end
if _a1457 then
_a1461 = ("펫 장착 슬롯 #%d (%s 다이아)"):format(_a1456.petNext, _a563(_a1456.petCost, 0))
_a1462 = "EquipSlotsMachine"
else
_a1461 = ("알 부화 슬롯 %d칸 → %d (%s 다이아)"):format(
_a1456.eggSize, _a1456.eggEnd, _a563(_a1456.eggCost, 0))
_a1462 = "EggSlotsMachine"
end
_a1463()
if not _a1459 and tostring(_a1460):find("far away") then
local _a1464 = _a576.machinePos(_a1462)
if _a1464 then
_a576.setAct("슬롯 머신으로 이동", _a1462)
_a576.glideTo(_a1464)
task.wait(0.25)
_a1459, _a1460 = nil, nil
_a1463()
else
_a1460 = "머신 위치를 못 찾음 (" .. _a1462 .. ")"
end
end
if _a1459 then
_a1454 += 1
_a570.mslot += 1
_a576.slotSaid = nil
_a576.setAct("슬롯 구매", _a1461)
_a562("  ⬆ " .. _a1461)
task.wait(0.35)
else
local _a1465 = _a1461 .. " 실패: " .. tostring(_a1460)
if _a576.slotSaid ~= _a1465 then
_a576.slotSaid = _a1465
_a562("[슬롯] " .. _a1465)
end
break
end
end
if _a1454 > 0 then
local _a1466 = _a576.slotStatus()
_a562(("[슬롯] %d개 구매 — 장착 %s / 한번에 %s개 부화 (다이아 %s 남음)"):format(
_a1454, tostring(_a1466 and _a1466.maxEquip), tostring(_a1466 and _a1466.maxHatch),
_a563(_a611("Diamonds"), 0)))
end
end
function _a576.upgList()
local _a1467 = {}
if not _a574.Upg then return _a1467 end
local _a1468, _a1469 = pcall(_a574.Upg.All)
if not (_a1468 and type(_a1469) == "table") then return _a1467 end
for _a1470, _a1471 in ipairs(_a1469) do
local _a1472, _a1473, _a1474 = rawget(_a1471, "UpgradeID"), rawget(_a1471, "ZoneID"), rawget(_a1471, "UpgradeTier")
if _a1472 and _a1473 and _a1474 then
local _a1475 = false
if rawget(_a574.Upg, "Owns") then
local _a1476, _a1477 = pcall(_a574.Upg.Owns, _a1472, _a1473)
_a1475 = _a1476 and _a1477 and true or false
end
local _a1478 = _a576.ownsZone(_a1473)
local _a1479 = _a574.DirUpg and rawget(_a574.DirUpg, _a1472)
local _a1480 = _a1479 and rawget(_a1479, "TierCosts")
local _a1481 = _a1480 and tonumber(_a1480[_a1474])
local _a1482 = "Diamonds"
local _a1483 = _a1479 and rawget(_a1479, "TierCurrencies")
local _a1484 = _a1483 and _a1483[_a1474]
if type(_a1484) == "table" and rawget(_a1484, "_id") then _a1482 = rawget(_a1484, "_id") end
local _a1485 = rawget(_a1471, "Model")
local _a1486
if typeof(_a1485) == "Instance" then
if _a1485:IsA("BasePart") then _a1486 = _a1485.Position
else
local _a1487, _a1488 = pcall(function() return _a1485:GetPivot() end)
if _a1487 and _a1488 then _a1486 = _a1488.Position end
end
end
_a1467[#_a1467 + 1] = {
id = _a1472, zone = _a1473, tier = _a1474, cost = _a1481, cur = _a1482,
bought = _a1475, zoneOwned = _a1478,
buyable = _a1478 and not _a1475,
pos = _a1486, model = _a1485,
}
end
end
table.sort(_a1467, function(_a1489, _a1490) return (_a1489.cost or math.huge) < (_a1490.cost or math.huge) end)
return _a1467
end
function _a576.cycleUpg()
if not _a574.R_Upg then _a562("[맵업글] Upgrades_Purchase 리모트 없음") return end
local _a1491 = _a576.upgList()
if #_a1491 == 0 then return end
local _a1492 = 0
for _a1493, _a1494 in ipairs(_a1491) do
if not _a569.mapupg then break end
if _a1494.buyable and _a1494.cost then
local _a1495 = _a611(_a1494.cur or "Diamonds")
if _a1495 - _a568.UpgReserve < _a1494.cost then break end
if _a568.UpgTp and _a1494.pos and _a1494.zone == _a576.curZone() then
_a576.glideTo(_a1494.pos)
end
local _a1496, _a1497
pcall(function() _a1496, _a1497 = _a574.R_Upg:InvokeServer(_a1494.id, _a1494.zone) end)
if _a1496 then
_a1492 += 1
_a570.mapupg += 1
_a576.setAct("맵 업글", _a1494.id .. " T" .. _a1494.tier)
_a562(("  ▲ 맵업글  %s T%d  @%s   (%s 다이아)"):format(
_a1494.id, _a1494.tier, _a1494.zone, _a563(_a1494.cost, 0)))
elseif _a1497 then
_a562(("[맵업글] %s T%d @%s 실패: %s"):format(
_a1494.id, _a1494.tier, _a1494.zone, tostring(_a1497)))
end
task.wait(_a568.ActionGap)
end
end
if _a1492 > 0 then
_a562(("[맵업글] %d개 구매  (다이아 %s 남음)"):format(_a1492, _a563(_a611("Diamonds"), 0)))
end
end
local function _a1498()
local _a1499 = _a603()
if not _a1499 then return nil end
local _a1500 = tonumber(rawget(_a1499, "Rebirths")) or 0
local _a1501 = _a1500 + 1
local _a1502
if _a574.Rebirth and rawget(_a574.Rebirth, "GetNextRebirth") then
local _a1503, _a1504 = pcall(_a574.Rebirth.GetNextRebirth, _a1499)
if _a1503 then _a1502 = _a1504 end
end
return { current = _a1500, nextN = _a1501, def = _a1502 }
end
local function _a1505()
if not _a574.R_Reb then _a562("[리버스] Rebirth_Request 리모트 없음") return end
local _a1506 = _a1498()
if not _a1506 then
_a576.rebNote = "세이브를 못 읽음"
return
end
local _a1507, _a1508
pcall(function() _a1507, _a1508 = _a574.R_Reb:InvokeServer(_a1506.nextN) end)
if _a1507 then
_a570.mreb += 1
_a576.rebNote, _a576.rebSaid = nil, nil
_a562(("  ★ 리버스 %d → %d"):format(_a1506.current, _a1506.nextN))
task.wait(0.5)
_a576.dismissRewardScreens(25)
else
_a576.rebNote = ("%d → %d : %s"):format(_a1506.current, _a1506.nextN,
_a1508 and tostring(_a1508) or "조건 미달 (리버스 킬/존 요구치)")
if _a576.rebSaid ~= _a576.rebNote then
_a576.rebSaid = _a576.rebNote
_a562("[리버스] " .. _a576.rebNote)
end
end
end
_a576.SIDE = {
{ key = "unlock", label = "알 해금",   run = "mhatch", fn = function() _a576.unlockEggs() end },
{ key = "slots",  label = "슬롯 머신", run = "slots",  fn = function() _a576.cycleSlots() end },
{ key = "mapupg", label = "맵 업그레이드", run = "mapupg", fn = function() _a576.cycleUpg() end },
{ key = "items",  label = "버프 유지",     run = "items",  fn = function() _a576.cycleItems() end },
}
_a576.STEPS = {
{ key = "mreb",   label = "리버스",  run = "mreb",  fn = function() _a1505() end,
hold = true },
{ key = "zone",   label = "존 해금", run = "zone",  fn = function() _a639() end,
hold = true },
{ key = "quest",  label = "랭크 퀘스트+보상", run = "quest", fn = function()
local _a1509 = _a569.farm
_a569.farm = true
pcall(_a621)
_a569.farm = _a1509
local _a1510 = _a576.cycle()
if not _a1510 then
local _a1511 = _a576.bestZone()
if _a1511 then
local _a1512, _a1513 = _a576.goToZone(_a1511)
if not _a1512 then
if _a1513 and _a576.idleMoveSaid ~= tostring(_a1513) then
_a576.idleMoveSaid = tostring(_a1513)
_a562("[자동] 최고 존 이동 실패: " .. tostring(_a1513))
end
else
_a576.idleMoveSaid = nil
end
end
if not _a568.IdleHatch then
_a576.setAct("파밍 중", ("퀘스트 없음 @%s"):format(tostring(_a576.curZone())))
return false
end
local _a1514 = _a669()
local _a1515 = math.max(1, _a568.HatchMinAfford or 10)
if _a1514 and _a1514.price and _a1514.canBuy < _a1515 then
_a576.setAct("돈 버는 중", ("%s  %d/%d개분  개당 %s %s"):format(
tostring(_a576.curZone()), _a1514.canBuy, _a1515,
_a563(_a1514.price, 0), tostring(_a1514.currency)))
else
_a576.setAct("대기 중 부화")
local _a1516 = _a569.mhatch
_a569.mhatch = true
pcall(_a680)
_a569.mhatch = _a1516
end
end
end },
}
_a568.StepOn = {}
for _a1517, _a1518 in ipairs(_a576.SIDE) do _a568.StepOn[_a1518.key] = true end
for _a1519, _a1520 in ipairs(_a576.STEPS) do _a568.StepOn[_a1520.key] = true end
local function _a1521(_a1522, _a1523, _a1524, _a1525)
if not _a568.StepOn[_a1522.key] then
_a1525[#_a1525 + 1] = ("%-14s 꺼져있음"):format(_a1522.label)
return
end
if _a1522.hold and _a1523 then
_a1525[#_a1525 + 1] = ("%-14s 보류 (%s)"):format(
_a1522.label, _a1524 and tostring(_a1524.title) or "?")
if _a576.heldMsg ~= _a1522.key then
_a576.heldMsg = _a1522.key
_a562(("[자동] %s 보류 — best 존이 바뀌면 깨지는 퀘스트 진행 중 (%s)"):format(
_a1522.label, _a1524 and tostring(_a1524.title) or "?"))
end
return
end
if _a1522.hold then _a576.heldMsg = nil end
_a576.step = _a1522.label
_a576.now.step = _a1522.label
_a576.setAct("시작", _a1522.label)
local _a1526 = os.clock()
local _a1527 = _a569[_a1522.run]
_a569[_a1522.run] = true
local _a1528, _a1529 = pcall(_a1522.fn)
_a569[_a1522.run] = _a1527
local _a1530 = os.clock() - _a1526
if not _a1528 then
_a1525[#_a1525 + 1] = ("%-14s 오류: %s"):format(_a1522.label, tostring(_a1529))
_a562("[자동] " .. _a1522.label .. " 오류: " .. tostring(_a1529))
else
local _a1531 = (_a1522.key == "zone" and _a576.zoneNote)
or (_a1522.key == "mreb" and _a576.rebNote) or nil
_a1525[#_a1525 + 1] = ("%-14s 실행 %.1f초%s"):format(
_a1522.label, _a1530, _a1531 and ("  → " .. _a1531) or "")
end
end
function _a576.master()
local _a1532 = {}
_a576.lastTrace = _a1532
_a576.lastPassAt = os.clock()
if _a576.rewardScreenUp() then
_a1532[#_a1532 + 1] = "보상 화면 넘기는 중"
_a576.dismissRewardScreens(15)
end
for _a1533, _a1534 in ipairs(_a576.SIDE) do
if not _a569.auto or _a576.stopped() then return end
_a1521(_a1534, false, nil, _a1532)
end
local _a1535, _a1536 = false, nil
if _a568.HoldZoneForQuest then _a1535, _a1536 = _a576.bestDepActive() end
for _a1537, _a1538 in ipairs(_a576.STEPS) do
if not _a569.auto or _a576.stopped() then break end
_a1521(_a1538, _a1535, _a1536, _a1532)
end
_a576.step = nil
if not _a576.lockGoal then
_a576.now.step = "대기"
_a576.setAct("다음 바퀴 대기", ("%.0f초 주기"):format(_a568.AutoInterval or 5))
end
end
local function _a1539()
if not _a567.R_PROMO then _a562("[타워업글] 리모트 없음") return end
local _a1540 = _a571()
if not _a1540 then return end
local _a1541 = _a572(_a1540)
table.sort(_a1541, function(_a1542, _a1543) return (_a1542.dps or 0) > (_a1543.dps or 0) end)
local _a1544, _a1545 = 0, 0
for _a1546, _a1547 in ipairs(_a1541) do
if not _a569.towerup then break end
if _a1547.id then
local _a1548
pcall(function() _a1548 = _a567.R_PROMO:InvokeServer(_a1547.id) end)
if _a1548 ~= nil and _a1548 ~= false then
_a1544 += 1
_a562(("  ▲ 타워업글  %s  Lv%s → Lv%s"):format(tostring(_a1547.kind), tostring(_a1547.up), tostring((_a1547.up or 0) + 1)))
_a1545 = 0
task.wait(_a568.ActionGap)
else
_a1545 += 1
if _a1545 >= 5 then break end
end
end
end
_a562("[타워업글] " .. _a1544 .. "건")
end
local _a1549 = {}
local function _a1550(_a1551, _a1552, _a1553, _a1554)
_a1549[_a1551] = (_a1549[_a1551] or 0) + 1
local _a1555 = _a1549[_a1551]
task.spawn(function()
while _a569[_a1551] and _a1549[_a1551] == _a1555 do
local _a1556, _a1557 = pcall(_a1553)
if not _a1556 then _a562("[" .. _a1554 .. " 오류] " .. tostring(_a1557)) end
local _a1558, _a1559 = _a1552(), 0
while _a1559 < _a1558 and _a569[_a1551] and _a1549[_a1551] == _a1555 do task.wait(0.1) _a1559 += 0.1 end
end
if _a1549[_a1551] == _a1555 then _a562("[" .. _a1554 .. "] 중지") end
end)
end
do
local _a1560 = {
farm   = { function() return _a568.FarmInterval end,      function() _a621() end,      "파밍" },
zone   = { function() return _a568.ZoneInterval end,      function() _a639() end,      "존" },
mhatch = { function() return _a568.MainHatchInterval end, function() _a680() end, "부화" },
}
function _a576.turnOn(_a1561, _a1562)
if _a569.auto then return end
if _a569[_a1561] then return end
local _a1563 = _a1560[_a1561]
if not _a1563 then return end
_a569[_a1561] = true
_a1550(_a1561, _a1563[1], _a1563[2], _a1563[3])
if _a576.refresh then _a576.refresh() end
_a562("[퀘스트] " .. tostring(_a1562) .. " ON")
end
end
_a558.MG, _a558.QS, _a558.saveGet, _a558.currencyAmount, _a558.cycleFarm, _a558.zoneStatus = _a574, _a576, _a603, _a611, _a621, _a635
_a558.cycleZone, _a558.bestMainEgg, _a558.mainHatchStatus, _a558.cycleMainHatch, _a558.mainRebirthStatus, _a558.cycleMainRebirth = _a639, _a644, _a669, _a680, _a1498, _a1505
_a558.cycleTowerUp, _a558.startLoop = _a1539, _a1550
end)(_a1)
;(function(_a1564)
local _a1565, _a1566, _a1567, _a1568, _a1569, _a1570 = _a1564.UIS, _a1564.RunService, _a1564.LP, _a1564.LOG, _a1564.log, _a1564.num
local _a1571, _a1572, _a1573, _a1574, _a1575, _a1576 = _a1564.RM, _a1564.CFG, _a1564.EGG_COST_CACHE, _a1564.RUN, _a1564.STAT, _a1564.EVENT_UPGRADES
local _a1577, _a1578, _a1579, _a1580, _a1581, _a1582 = _a1564.ctx, _a1564.collectSlots, _a1564.placedTowers, _a1564.availableItems, _a1564.cyclePlace, _a1564.cycleMerchant
local _a1583, _a1584, _a1585, _a1586, _a1587, _a1588 = _a1564.sunflowers, _a1564.eventTiers, _a1564.nextCost, _a1564.cycleUpgrade, _a1564.seedInv, _a1564.bedsOf
local _a1589, _a1590, _a1591, _a1592, _a1593, _a1594 = _a1564.isUnhatched, _a1564.bedCps, _a1564.cycleCrop, _a1564.laneCosts, _a1564.lockedBeds, _a1564.cycleExpand
local _a1595, _a1596, _a1597, _a1598, _a1599, _a1600 = _a1564.rebirthStatus, _a1564.cycleRebirth, _a1564.eggCost, _a1564.hatchStatus, _a1564.cycleHatch, _a1564.LUCK_ORDER
local _a1601, _a1602, _a1603, _a1604, _a1605, _a1606 = _a1564.luckStatus, _a1564.fmtDur, _a1564.cycleLuck, _a1564.MG, _a1564.QS, _a1564.saveGet
local _a1607, _a1608, _a1609, _a1610, _a1611, _a1612 = _a1564.currencyAmount, _a1564.cycleFarm, _a1564.zoneStatus, _a1564.cycleZone, _a1564.bestMainEgg, _a1564.mainHatchStatus
local _a1613, _a1614, _a1615, _a1616, _a1617 = _a1564.cycleMainHatch, _a1564.mainRebirthStatus, _a1564.cycleMainRebirth, _a1564.cycleTowerUp, _a1564.startLoop
local _a1618 = {
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
local function _a1619(_a1620, _a1621, _a1622)
local _a1623 = Instance.new(_a1620)
for _a1624, _a1625 in pairs(_a1621) do _a1623[_a1624] = _a1625 end
if _a1622 then _a1623.Parent = _a1622 end
return _a1623
end
local function _a1626(_a1627, _a1628) _a1619("UICorner", { CornerRadius = UDim.new(0, _a1628 or 8) }, _a1627) end
local function _a1629(_a1630, _a1631, _a1632)
_a1619("UIStroke", { Color = _a1631 or _a1618.line, Thickness = _a1632 or 1,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, _a1630)
end
local function _a1633(_a1634, _a1635)
_a1619("UIPadding", {
PaddingTop = UDim.new(0, _a1635), PaddingBottom = UDim.new(0, _a1635),
PaddingLeft = UDim.new(0, _a1635), PaddingRight = UDim.new(0, _a1635),
}, _a1634)
end
local _a1636 = _a1619("ScreenGui", {
Name = "PS99GardenAuto", ResetOnSpawn = false,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
IgnoreGuiInset = true, DisplayOrder = 9999,
})
local _a1637 = false
if type(gethui) == "function" then _a1637 = pcall(function() _a1636.Parent = gethui() end) end
if not _a1637 then _a1637 = pcall(function() _a1636.Parent = game:GetService("CoreGui") end) end
if not _a1637 then _a1636.Parent = _a1567:WaitForChild("PlayerGui") end
local _a1638, _a1639 = 780, 520
local _a1640 = _a1619("Frame", {
Size = UDim2.fromOffset(_a1638, _a1639), Position = UDim2.new(0.5, -_a1638 / 2, 0.5, -_a1639 / 2),
BackgroundColor3 = _a1618.bg, BorderSizePixel = 0, Active = true, ClipsDescendants = true,
}, _a1636)
_a1626(_a1640, 12)
_a1629(_a1640, Color3.fromRGB(60, 66, 82), 1)
local _a1641 = _a1619("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = _a1618.panel, BorderSizePixel = 0,
}, _a1640)
_a1626(_a1641, 12)
_a1619("Frame", {
Size = UDim2.new(1, 0, 0, 12), Position = UDim2.new(0, 0, 1, -12),
BackgroundColor3 = _a1618.panel, BorderSizePixel = 0,
}, _a1641)
_a1619("Frame", {
Size = UDim2.fromOffset(10, 10), Position = UDim2.fromOffset(14, 15),
BackgroundColor3 = _a1618.good, BorderSizePixel = 0,
}, _a1641).Name = "Dot"
_a1626(_a1641:FindFirstChild("Dot"), 5)
_a1619("TextLabel", {
Size = UDim2.new(0, 320, 1, 0), Position = UDim2.fromOffset(32, 0),
BackgroundTransparency = 1, Text = "Garden Defenders  AutoPlay",
TextColor3 = _a1618.text, TextSize = 14, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1641)
local function _a1642(_a1643, _a1644, _a1645, _a1646)
local _a1647 = _a1619("TextButton", {
Size = UDim2.new(0, _a1646, 0, 24), Position = UDim2.new(1, _a1645, 0, 8),
BackgroundColor3 = _a1644, BorderSizePixel = 0, Text = _a1643,
TextColor3 = _a1618.text, TextSize = 12, Font = Enum.Font.GothamMedium,
AutoButtonColor = true,
}, _a1641)
_a1626(_a1647, 6)
return _a1647
end
local _a1648 = _a1642("✕", _a1618.bad, -38, 28)
local _a1649   = _a1642("—", _a1618.card, -70, 28)
local _a1650 = _a1642("지우기", _a1618.card, -132, 58)
local _a1651  = _a1642("복사", _a1618.accent, -190, 54)
local _a1652  = _a1642("정지", _a1618.bad, -252, 58)
_a1652.MouseButton1Click:Connect(function()
_a1605.stopAll()
if refreshAllSwitches then pcall(refreshAllSwitches) end
_a1569("[정지] 모든 동작을 멈췄습니다")
end)
local _a1653 = _a1619("ScrollingFrame", {
Size = UDim2.new(0, 152, 1, -92), Position = UDim2.fromOffset(10, 48),
BackgroundColor3 = _a1618.panel, BorderSizePixel = 0,
ScrollBarThickness = 3, ScrollBarImageColor3 = _a1618.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1640)
_a1626(_a1653, 8)
_a1619("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, _a1653)
_a1619("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }, _a1653)
local _a1654 = _a1619("Frame", {
Size = UDim2.new(1, -182, 1, -92), Position = UDim2.fromOffset(172, 48),
BackgroundTransparency = 1,
}, _a1640)
local _a1655, _a1656 = {}, nil
local _a1657, _a1658 = {}, {}
local _a1659 = {}
local function _a1660(_a1661)
_a1656 = _a1661
for _a1662, _a1663 in pairs(_a1655) do _a1663.Visible = (_a1662 == _a1661) end
for _a1664, _a1665 in pairs(_a1657) do
local _a1666 = (_a1664 == _a1661)
_a1665.BackgroundColor3 = _a1666 and _a1618.accent or _a1618.panel
_a1665.TextColor3 = _a1666 and Color3.fromRGB(255, 255, 255) or _a1618.dim
end
local _a1667 = _a1658[_a1661]
if _a1667 and _a1659[_a1667] and not _a1659[_a1667].open then _a1659[_a1667].toggle() end
end
local function _a1668(_a1669, _a1670, _a1671)
local _a1672 = { open = true, kids = {} }
local _a1673 = _a1619("TextButton", {
Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = _a1618.bg, BorderSizePixel = 0,
Text = "", TextColor3 = _a1618.dim, TextSize = 11,
Font = Enum.Font.GothamBold, LayoutOrder = _a1671, AutoButtonColor = false,
}, _a1653)
_a1626(_a1673, 5)
local _a1674 = _a1619("TextLabel", {
Size = UDim2.fromOffset(14, 26), Position = UDim2.fromOffset(6, 0),
BackgroundTransparency = 1, Text = "▾", TextColor3 = _a1618.dim,
TextSize = 10, Font = Enum.Font.GothamBold,
}, _a1673)
_a1619("TextLabel", {
Size = UDim2.new(1, -22, 1, 0), Position = UDim2.fromOffset(20, 0),
BackgroundTransparency = 1, Text = _a1670, TextColor3 = _a1618.dim,
TextSize = 11, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1673)
function _a1672.toggle()
_a1672.open = not _a1672.open
_a1674.Text = _a1672.open and "▾" or "▸"
for _a1675, _a1676 in ipairs(_a1672.kids) do _a1676.Visible = _a1672.open end
end
_a1673.MouseButton1Click:Connect(_a1672.toggle)
_a1659[_a1669] = _a1672
return _a1672
end
local function _a1677(_a1678, _a1679, _a1680, _a1681)
local _a1682 = _a1681 and 14 or 6
local _a1683 = _a1619("TextButton", {
Size = UDim2.new(1, 0, 0, 27), BackgroundColor3 = _a1618.panel, BorderSizePixel = 0,
Text = "", TextColor3 = _a1618.dim, TextSize = 12,
Font = Enum.Font.GothamMedium, LayoutOrder = _a1680, AutoButtonColor = false,
}, _a1653)
_a1626(_a1683, 5)
local _a1684 = _a1619("TextLabel", {
Size = UDim2.new(1, -_a1682 - 4, 1, 0), Position = UDim2.fromOffset(_a1682, 0),
BackgroundTransparency = 1, Text = _a1679, TextColor3 = _a1618.dim,
TextSize = 12, Font = Enum.Font.GothamMedium,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1683)
_a1657[_a1678] = _a1683
if _a1681 then
_a1658[_a1678] = _a1681
local _a1685 = _a1659[_a1681]
if _a1685 then
table.insert(_a1685.kids, _a1683)
_a1683.Visible = _a1685.open
end
end
local _a1686 = _a1619("ScrollingFrame", {
Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false,
BorderSizePixel = 0, ScrollBarThickness = 4,
ScrollBarImageColor3 = _a1618.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1654)
_a1619("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, _a1686)
_a1619("UIPadding", { PaddingRight = UDim.new(0, 8) }, _a1686)
_a1655[_a1678] = _a1686
_a1683.MouseButton1Click:Connect(function() _a1660(_a1678) end)
_a1683.MouseEnter:Connect(function()
if _a1656 ~= _a1678 then _a1683.BackgroundColor3 = _a1618.card end
end)
_a1683.MouseLeave:Connect(function()
if _a1656 ~= _a1678 then _a1683.BackgroundColor3 = _a1618.panel end
end)
_a1683:GetPropertyChangedSignal("TextColor3"):Connect(function()
_a1684.TextColor3 = _a1683.TextColor3
end)
return _a1686
end
local _a1687 = 0
local function _a1688()
_a1687 += 1
return _a1687
end
local function _a1689(_a1690, _a1691)
local _a1692 = _a1619("Frame", {
Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, LayoutOrder = _a1688(),
}, _a1690)
_a1619("Frame", {
Size = UDim2.fromOffset(3, 14), Position = UDim2.fromOffset(0, 7),
BackgroundColor3 = _a1618.accent, BorderSizePixel = 0,
}, _a1692)
_a1619("TextLabel", {
Size = UDim2.new(1, -12, 1, 0), Position = UDim2.fromOffset(10, 0),
BackgroundTransparency = 1, Text = _a1691, TextColor3 = _a1618.text,
TextSize = 13, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1692)
return _a1692
end
local function _a1693(_a1694, _a1695, _a1696)
local _a1697 = _a1619("Frame", {
Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundColor3 = _a1618.card, BorderSizePixel = 0, LayoutOrder = _a1688(),
}, _a1694)
_a1626(_a1697, 8)
_a1629(_a1697, _a1618.line, 1)
_a1633(_a1697, 12)
_a1619("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, _a1697)
if _a1695 then
local _a1698 = _a1619("Frame", {
Size = UDim2.new(1, 0, 0, _a1696 and 32 or 22), BackgroundTransparency = 1,
LayoutOrder = 0,
}, _a1697)
_a1619("TextLabel", {
Size = UDim2.new(1, -70, 0, 16), BackgroundTransparency = 1, Text = _a1695,
TextColor3 = _a1618.text, TextSize = 13, Font = Enum.Font.GothamBold,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1698)
if _a1696 then
_a1619("TextLabel", {
Size = UDim2.new(1, -70, 0, 13), Position = UDim2.fromOffset(0, 17),
BackgroundTransparency = 1, Text = _a1696, TextColor3 = _a1618.dim,
TextSize = 11, Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
}, _a1698)
end
_a1697:SetAttribute("HeadHeight", _a1696 and 32 or 18)
return _a1697, _a1698
end
return _a1697
end
local _a1699 = {}
local function _a1700()
for _a1701, _a1702 in pairs(_a1699) do pcall(_a1702) end
end
_a1605.refresh = _a1700
local function _a1703(_a1704, _a1705, _a1706)
local _a1707 = _a1619("TextButton", {
Size = UDim2.fromOffset(46, 24), Position = UDim2.new(1, -46, 0, 0),
BackgroundColor3 = _a1618.cardHi, BorderSizePixel = 0, Text = "",
AutoButtonColor = false,
}, _a1704)
_a1626(_a1707, 12)
local _a1708 = _a1619("Frame", {
Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(3, 3),
BackgroundColor3 = _a1618.dim, BorderSizePixel = 0,
}, _a1707)
_a1626(_a1708, 9)
local _a1709 = _a1619("TextLabel", {
Size = UDim2.fromOffset(46, 12), Position = UDim2.fromOffset(0, 26),
BackgroundTransparency = 1, Text = "OFF", TextColor3 = _a1618.dim,
TextSize = 10, Font = Enum.Font.GothamBold,
}, _a1707)
local function _a1710()
local _a1711 = _a1574[_a1705]
_a1707.BackgroundColor3 = _a1711 and _a1618.good or _a1618.cardHi
_a1708:TweenPosition(UDim2.fromOffset(_a1711 and 25 or 3, 3),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
_a1708.BackgroundColor3 = _a1711 and Color3.fromRGB(255, 255, 255) or _a1618.dim
_a1709.Text = _a1711 and "ON" or "OFF"
_a1709.TextColor3 = _a1711 and _a1618.good or _a1618.dim
end
_a1707.MouseButton1Click:Connect(function()
_a1574[_a1705] = not _a1574[_a1705]
if _a1574[_a1705] then
if _a1705 == "auto" then _a1605.abort = false end
_a1710()
_a1569("[" .. _a1705 .. "] 시작")
local _a1712, _a1713 = pcall(_a1706)
if not _a1712 then _a1569("[에러] " .. tostring(_a1713)) end
else
if _a1705 == "auto" then
_a1605.stopAll()
_a1569("[정지] 모든 동작을 멈췄습니다")
end
_a1710()
end
end)
_a1710()
_a1699[_a1705] = _a1710
return _a1707, _a1710
end
local function _a1714(_a1715, _a1716)
local _a1717 = _a1619("Frame", {
Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, LayoutOrder = _a1688(),
}, _a1715)
local _a1718 = #_a1716
for _a1719, _a1720 in ipairs(_a1716) do
local _a1721 = _a1619("Frame", {
Size = UDim2.new(1 / _a1718, -6, 1, 0), Position = UDim2.new((_a1719 - 1) / _a1718, 3, 0, 0),
BackgroundTransparency = 1,
}, _a1717)
_a1619("TextLabel", {
Size = UDim2.new(1, 0, 0, 13), BackgroundTransparency = 1, Text = _a1720.label,
TextColor3 = _a1618.dim, TextSize = 10, Font = Enum.Font.Gotham,
TextXAlignment = Enum.TextXAlignment.Left,
}, _a1721)
local _a1722 = _a1619("TextBox", {
Size = UDim2.new(1, 0, 0, 24), Position = UDim2.fromOffset(0, 15),
BackgroundColor3 = _a1618.bg, BorderSizePixel = 0, Text = tostring(_a1720.value),
TextColor3 = _a1618.text, TextSize = 12, Font = Enum.Font.Code,
ClearTextOnFocus = false,
}, _a1721)
_a1626(_a1722, 5)
_a1629(_a1722, _a1618.line, 1)
_a1722.FocusLost:Connect(function() _a1720.onChange(_a1722.Text, _a1722) end)
end
return _a1717
end
local function _a1723(_a1724, _a1725)
local _a1726 = _a1619("Frame", {
Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = _a1688(),
}, _a1724)
local _a1727 = #_a1725
for _a1728, _a1729 in ipairs(_a1725) do
local _a1730 = _a1619("TextButton", {
Size = UDim2.new(1 / _a1727, -5, 1, 0), Position = UDim2.new((_a1728 - 1) / _a1727, 2.5, 0, 0),
BackgroundColor3 = _a1729.col or _a1618.cardHi, BorderSizePixel = 0, Text = _a1729.label,
TextColor3 = _a1618.text, TextSize = 12, Font = Enum.Font.GothamMedium,
}, _a1726)
_a1626(_a1730, 6)
_a1730.MouseButton1Click:Connect(function()
local _a1731, _a1732 = pcall(_a1729.fn, _a1730)
if not _a1731 then _a1569("[에러] " .. tostring(_a1729.label) .. " → " .. tostring(_a1732)) end
end)
end
return _a1726
end
local function _a1733(_a1734, _a1735, _a1736, _a1737)
local _a1738 = _a1619("TextButton", {
Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = _a1618.cardHi, BorderSizePixel = 0,
Text = "", TextColor3 = _a1618.text, TextSize = 12, Font = Enum.Font.GothamMedium,
LayoutOrder = _a1688(),
}, _a1734)
_a1626(_a1738, 6)
local function _a1739()
local _a1740 = _a1736()
_a1738.Text = _a1735 .. "   " .. (_a1740 and "ON" or "OFF")
_a1738.BackgroundColor3 = _a1740 and Color3.fromRGB(40, 78, 58) or _a1618.cardHi
_a1738.TextColor3 = _a1740 and _a1618.good or _a1618.dim
end
_a1738.MouseButton1Click:Connect(function()
_a1737(not _a1736())
_a1739()
end)
_a1739()
return _a1738
end
local _a1741 = _a1677("log", "로그", 90)
local _a1742
do
local _a1743 = _a1619("Frame", {
Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(13, 14, 18),
BorderSizePixel = 0, LayoutOrder = _a1688(),
}, _a1741)
_a1626(_a1743, 8)
_a1629(_a1743, _a1618.line, 1)
local _a1744 = _a1619("ScrollingFrame", {
Size = UDim2.new(1, -10, 1, -10), Position = UDim2.fromOffset(5, 5),
BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4,
ScrollBarImageColor3 = _a1618.line,
CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, _a1743)
_a1742 = _a1619("TextLabel", {
Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
BackgroundTransparency = 1, Text = "", TextColor3 = Color3.fromRGB(196, 208, 196),
TextSize = 11, Font = Enum.Font.Code,
TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
TextWrapped = true,
}, _a1744)
_a1741.AutomaticCanvasSize = Enum.AutomaticSize.None
_a1741.CanvasSize = UDim2.new()
end
do
local _a1745, _a1746, _a1747, _a1748
_a1641.InputBegan:Connect(function(_a1749)
if _a1749.UserInputType == Enum.UserInputType.MouseButton1
or _a1749.UserInputType == Enum.UserInputType.Touch then
_a1745, _a1746, _a1747 = true, _a1749.Position, _a1640.Position
_a1749.Changed:Connect(function()
if _a1749.UserInputState == Enum.UserInputState.End then _a1745 = false end
end)
end
end)
_a1641.InputChanged:Connect(function(_a1750)
if _a1750.UserInputType == Enum.UserInputType.MouseMovement
or _a1750.UserInputType == Enum.UserInputType.Touch then _a1748 = _a1750 end
end)
_a1565.InputChanged:Connect(function(_a1751)
if _a1745 and _a1751 == _a1748 then
local _a1752 = _a1751.Position - _a1746
_a1640.Position = UDim2.new(_a1747.X.Scale, _a1747.X.Offset + _a1752.X,
_a1747.Y.Scale, _a1747.Y.Offset + _a1752.Y)
end
end)
local _a1753 = false
_a1649.MouseButton1Click:Connect(function()
_a1753 = not _a1753
_a1640:TweenSize(_a1753 and UDim2.fromOffset(_a1638, 40) or UDim2.fromOffset(_a1638, _a1639),
Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
_a1649.Text = _a1753 and "▢" or "—"
end)
end
local _a1754 = _a1566.Heartbeat:Connect(function()
if not _a1564.dirty then return end
_a1564.dirty = false
local _a1755 = #_a1568
_a1742.Text = table.concat(table.move(_a1568, math.max(1, _a1755 - 300), _a1755, 1, {}), "\n")
end)
local _a1756 = _a1677("dash", "대시보드", 10)
local _a1757 = _a1677("event", "이벤트", 20)
do
local _a1758 = _a1693(_a1756, "전체 제어", nil)
_a1723(_a1758, {
{ label = "권장 전부 ON", col = _a1618.good, fn = function()
for _a1759, _a1760 in ipairs({ "place", "merchant", "crop", "expand", "hatch" }) do
if not _a1574[_a1760] then
_a1574[_a1760] = true
if _a1760 == "place"    then _a1617(_a1760, function() return _a1572.PlaceInterval end, _a1581, "배치") end
if _a1760 == "merchant" then _a1617(_a1760, function() return _a1572.MerchantInterval end, _a1582, "구매") end
if _a1760 == "crop"     then _a1617(_a1760, function() return _a1572.CropInterval end, _a1591, "씨앗") end
if _a1760 == "expand"   then _a1617(_a1760, function() return _a1572.ExpandInterval end, _a1594, "확장") end
if _a1760 == "hatch"    then _a1617(_a1760, function() return _a1572.HatchInterval end, _a1599, "뽑기") end
end
end
_a1700()
_a1569("[전체] 배치/구매/씨앗/확장/뽑기 ON  (업글·리버스는 따로 켜세요)")
end },
{ label = "전부 정지", col = _a1618.bad, fn = function()
_a1574.place, _a1574.merchant, _a1574.upgrade = false, false, false
_a1574.towerup, _a1574.crop, _a1574.expand, _a1574.rebirth, _a1574.hatch, _a1574.luck = false, false, false, false, false, false
_a1574.farm, _a1574.zone, _a1574.mhatch, _a1574.rank, _a1574.mreb = false, false, false, false, false
_a1700()
_a1569("[전체] 정지")
end },
})
local _a1761 = _a1693(_a1756, "현황", nil)
_a1723(_a1761, {
{ label = "밭 / 타워", col = _a1618.accent, fn = function()
local _a1762, _a1763, _a1764, _a1765 = _a1577()
_a1569("")
_a1569("──── 현재 상태 ────")
_a1569("레인 " .. tostring(_a1765) .. " / plot " .. (_a1764 and "O" or "X")
.. " / world " .. (_a1762 and "O" or "X"))
local _a1766 = _a1578(_a1764, _a1765)
local _a1767 = _a1579(_a1762)
_a1569("슬롯 " .. #_a1766 .. " / 배치 " .. #_a1767)
local _a1768, _a1769 = 0, {}
for _a1770, _a1771 in ipairs(_a1767) do
_a1768 += (_a1771.dps or 0)
_a1769[tostring(_a1771.kind)] = (_a1769[tostring(_a1771.kind)] or 0) + 1
end
_a1569("총 DPS " .. _a1570(_a1768))
for _a1772, _a1773 in pairs(_a1769) do _a1569("  " .. _a1772 .. " × " .. _a1773) end
local _a1774 = _a1580()
_a1569("")
_a1569("배치 가능 " .. #_a1774 .. "종")
for _a1775 = 1, math.min(10, #_a1774) do
local _a1776 = _a1774[_a1775]
_a1569(("  %-22s %-7s 남은 %-3s DPS %s"):format(
tostring(_a1776.id), tostring(_a1776.vr or "-"), tostring(_a1776.copies), _a1570(_a1776.dps)))
end
_a1660("log")
end },
{ label = "로그 보기", col = _a1618.cardHi, fn = function() _a1660("log") end },
})
end
do
local _a1777, _a1778 = _a1693(_a1757, "자동 배치 / 교체", nil)
_a1703(_a1778, "place", function()
_a1617("place", function() return _a1572.PlaceInterval end, _a1581, "배치")
end)
_a1714(_a1777, {
{ label = "주기", value = _a1572.PlaceInterval, onChange = function(_a1779)
local _a1780 = tonumber(_a1779) if _a1780 and _a1780 >= 3 then _a1572.PlaceInterval = _a1780 end
end },
{ label = "교체 배수", value = _a1572.SwapMargin, onChange = function(_a1781)
local _a1782 = tonumber(_a1781) if _a1782 and _a1782 >= 1 then _a1572.SwapMargin = _a1782 _a1569("[설정] 교체 배수 " .. _a1782) end
end },
{ label = "DoT 반영", value = _a1572.DotFactor, onChange = function(_a1783)
local _a1784 = tonumber(_a1783) if _a1784 and _a1784 >= 0 and _a1784 <= 1 then _a1572.DotFactor = _a1784 end
end },
})
_a1733(_a1777, "업글 타워 보호",
function() return _a1572.ProtectUpgraded end,
function(_a1785) _a1572.ProtectUpgraded = _a1785
_a1569("[설정] 업글 보호 " .. (_a1785 and "ON — 업글된 건 안 건드림" or "OFF — 약하면 교체")) end)
_a1723(_a1777, {
{ label = "지금 1회 실행", col = _a1618.accent, fn = function()
task.spawn(function() _a1574.place = true _a1581() _a1574.place = false _a1660("log") end)
end },
})
end
do
local _a1786, _a1787 = _a1693(_a1757, "머천트 자동 구매", nil)
_a1703(_a1787, "merchant", function()
_a1617("merchant", function() return _a1572.MerchantInterval end, _a1582, "구매")
end)
_a1714(_a1786, {
{ label = "머천트 ID", value = _a1572.MerchantId, onChange = function(_a1788)
if _a1788 ~= "" then _a1572.MerchantId = _a1788 _a1569("[설정] 머천트 " .. _a1788) end
end },
{ label = "주기", value = _a1572.MerchantInterval, onChange = function(_a1789)
local _a1790 = tonumber(_a1789) if _a1790 and _a1790 >= 5 then _a1572.MerchantInterval = _a1790 end
end },
})
_a1723(_a1786, {
{ label = "지금 1회 구매", col = _a1618.accent, fn = function()
task.spawn(function() _a1574.merchant = true _a1582() _a1574.merchant = false _a1660("log") end)
end },
})
end
do
local _a1791, _a1792 = _a1693(_a1757, "업그레이드 머신", nil)
_a1703(_a1792, "upgrade", function()
_a1617("upgrade", function() return _a1572.UpgradeInterval end, _a1586, "머신업글")
end)
_a1714(_a1791, {
{ label = "주기", value = _a1572.UpgradeInterval, onChange = function(_a1793)
local _a1794 = tonumber(_a1793) if _a1794 and _a1794 >= 5 then _a1572.UpgradeInterval = _a1794 end
end },
{ label = "최소 잔액", value = _a1572.MinSunflowers, onChange = function(_a1795)
local _a1796 = tonumber(_a1795) if _a1796 and _a1796 >= 0 then _a1572.MinSunflowers = _a1796
_a1569("[설정] 최소 잔액 " .. _a1570(_a1796, 0)) end
end },
})
_a1733(_a1791, "가격 미상 구매",
function() return _a1572.BuyUnknownCost end,
function(_a1797) _a1572.BuyUnknownCost = _a1797 end)
_a1723(_a1791, {
{ label = "업글 현황 보기", col = _a1618.accent, fn = function()
local _a1798 = _a1583()
local _a1799 = _a1584()
_a1575.sun = _a1798
_a1569("")
_a1569("──── 업그레이드 머신 ────")
_a1569("Sunflowers = " .. _a1570(_a1798, 0))
local _a1800 = {}
for _a1801, _a1802 in ipairs(_a1576) do
local _a1803 = _a1799[_a1802] or 0
_a1800[#_a1800 + 1] = { id = _a1802, tier = _a1803, cost = _a1585(_a1802, _a1803) }
end
table.sort(_a1800, function(_a1804, _a1805)
return (_a1804.cost or math.huge) < (_a1805.cost or math.huge)
end)
for _a1806, _a1807 in ipairs(_a1800) do
_a1569(("  %-22s Lv%-3s 다음 %-14s %s"):format(
_a1807.id, tostring(_a1807.tier), _a1807.cost and _a1570(_a1807.cost, 0) or "?",
(_a1807.cost and _a1807.cost <= _a1798) and "← 구매가능" or ""))
end
_a1660("log")
end },
{ label = "지금 1회 업글", col = _a1618.cardHi, fn = function()
task.spawn(function() _a1574.upgrade = true _a1586() _a1574.upgrade = false _a1660("log") end)
end },
})
local _a1808, _a1809 = _a1693(_a1757, "타워 개별 업글", nil)
_a1703(_a1809, "towerup", function()
_a1617("towerup", function() return _a1572.UpgradeInterval end, _a1616, "타워업글")
end)
end
do
local _a1810, _a1811 = _a1693(_a1757, "자동 뽑기", nil)
_a1703(_a1811, "hatch", function()
_a1617("hatch", function() return _a1572.HatchInterval end, _a1599, "뽑기")
end)
_a1714(_a1810, {
{ label = "주기", value = _a1572.HatchInterval, onChange = function(_a1812)
local _a1813 = tonumber(_a1812) if _a1813 and _a1813 >= 1 then _a1572.HatchInterval = _a1813 end
end },
{ label = "한 번에 최대", value = _a1572.HatchMax, onChange = function(_a1814)
local _a1815 = tonumber(_a1814) if _a1815 and _a1815 >= 1 then _a1572.HatchMax = math.floor(_a1815) end
end },
})
_a1714(_a1810, {
{ label = "예비금", value = _a1572.HatchReserve, onChange = function(_a1816)
local _a1817 = tonumber(_a1816) if _a1817 and _a1817 >= 0 then _a1572.HatchReserve = _a1817
_a1569("[설정] 뽑기 예비금 " .. _a1570(_a1817, 0)) end
end },
{ label = "알 번호 (0=자동)", value = _a1572.HatchEggNum, onChange = function(_a1818)
local _a1819 = tonumber(_a1818) if _a1819 and _a1819 >= 0 and _a1819 <= 12 then
_a1572.HatchEggNum = math.floor(_a1819)
table.clear(_a1573)
_a1569("[설정] 알 번호 " .. (_a1819 == 0 and "자동" or _a1819)) end
end },
})
_a1723(_a1810, {
{ label = "뽑기 현황 보기", col = _a1618.accent, fn = function()
local _a1820 = _a1598()
_a1575.sun = _a1820.sun
_a1569("")
_a1569("──── 뽑기 현황 ────")
_a1569("  알 등급     " .. _a1820.id)
_a1569("  알 uid      " .. tostring(_a1820.uid))
_a1569("  개당 비용   " .. (_a1820.cost and _a1570(_a1820.cost, 0) or "?"))
_a1569("  Sunflowers  " .. _a1570(_a1820.sun, 0))
_a1569("  예비금      " .. _a1570(_a1572.HatchReserve, 0))
_a1569("  지금 가능   " .. _a1820.canBuy .. "회")
_a1569("")
_a1569("  월드의 알 " .. _a1820.eggCount .. "개")
for _a1821, _a1822 in ipairs(_a1820.eggs) do
if _a1821 > 5 then break end
_a1569(("    %s  거리 %s"):format(_a1822.uid, _a1570(_a1822.dist)))
end
_a1569("")
_a1569("  누적 뽑기   " .. _a1575.hatched .. "회")
_a1660("log")
end },
{ label = "지금 1회 실행", col = _a1618.cardHi, fn = function()
task.spawn(function() _a1574.hatch = true _a1599() _a1574.hatch = false _a1660("log") end)
end },
})
end
do
local _a1823, _a1824 = _a1693(_a1757, "럭 상시 최대 유지", nil)
_a1703(_a1824, "luck", function()
_a1617("luck", function() return _a1572.LuckInterval end, _a1603, "럭")
end)
_a1714(_a1823, {
{ label = "주기", value = _a1572.LuckInterval, onChange = function(_a1825)
local _a1826 = tonumber(_a1825) if _a1826 and _a1826 >= 60 then _a1572.LuckInterval = _a1826 end
end },
{ label = "예비금", value = _a1572.LuckReserve, onChange = function(_a1827)
local _a1828 = tonumber(_a1827) if _a1828 and _a1828 >= 0 then _a1572.LuckReserve = _a1828 end
end },
})
_a1714(_a1823, {
{ label = "최소 부족분", value = _a1572.LuckMinTopUp, onChange = function(_a1829)
local _a1830 = tonumber(_a1829) if _a1830 and _a1830 >= 0 then _a1572.LuckMinTopUp = _a1830 end
end },
})
for _a1831, _a1832 in ipairs(_a1600) do
_a1733(_a1823, _a1832,
function() return _a1572.LuckBoosts[_a1832] end,
function(_a1833) _a1572.LuckBoosts[_a1832] = _a1833 end)
end
_a1723(_a1823, {
{ label = "럭 현황 보기", col = _a1618.accent, fn = function()
local _a1834 = _a1601()
_a1575.sun = _a1834.sun
_a1569("")
_a1569("──── 이벤트 럭 ────")
_a1569("  머신 활성   " .. (_a1834.enabled and "O" or "X"))
_a1569("  최대 시간   " .. _a1602(_a1834.maxSec))
_a1569("  Sunflowers  " .. _a1570(_a1834.sun, 0))
_a1569("")
for _a1835, _a1836 in ipairs(_a1834.rows) do
_a1569(("  %-12s %-14s 부족 %-14s 필요 %s개%s"):format(
_a1836.rarity, _a1602(_a1836.left), _a1602(_a1836.deficit), _a1570(_a1836.need, 0),
_a1836.on and "" or "   (꺼짐)"))
end
_a1569("")
_a1569("  효과 : 비활성 0.5배 → 활성 1.0배 (2배)")
_a1660("log")
end },
{ label = "지금 1회 충전", col = _a1618.cardHi, fn = function()
task.spawn(function() _a1574.luck = true _a1603() _a1574.luck = false _a1660("log") end)
end },
})
end
do
local _a1837, _a1838 = _a1693(_a1757, "자동 씨앗 교체", nil)
_a1703(_a1838, "crop", function()
_a1617("crop", function() return _a1572.CropInterval end, _a1591, "씨앗")
end)
_a1714(_a1837, {
{ label = "주기", value = _a1572.CropInterval, onChange = function(_a1839)
local _a1840 = tonumber(_a1839) if _a1840 and _a1840 >= 5 then _a1572.CropInterval = _a1840 end
end },
{ label = "갈아엎기 배수", value = _a1572.CropMargin, onChange = function(_a1841)
local _a1842 = tonumber(_a1841) if _a1842 and _a1842 >= 1 then _a1572.CropMargin = _a1842 _a1569("[설정] 작물 배수 " .. _a1842) end
end },
})
_a1733(_a1837, "성장중 건너뛰기",
function() return _a1572.SkipUnhatched end,
function(_a1843) _a1572.SkipUnhatched = _a1843 end)
_a1723(_a1837, {
{ label = "밭 현황 보기", col = _a1618.accent, fn = function()
local _a1844, _a1845 = _a1577()
if not _a1845 then _a1569("[씨앗] 밭 없음") _a1660("log") return end
local _a1846, _a1847 = _a1588(_a1845), _a1587()
_a1569("")
_a1569("──── 밭 현황 ────")
_a1569("보유 씨앗 (기대 초당수익 순)")
for _a1848, _a1849 in ipairs(_a1847) do
_a1569(("  %-10s %-8s ×%-6s  기대 %s/s"):format(
tostring(_a1849.id), tostring(_a1849.vr or "-"), tostring(_a1849.am), _a1570(_a1849.exp)))
end
local _a1850, _a1851, _a1852, _a1853, _a1854 = 0, 0, 0, 0, 0
local _a1855 = _a1847[1]
local _a1856 = _a1855 and _a1855.exp or 0
_a1569("")
_a1569("심어진 작물")
local _a1857 = 0
for _a1858, _a1859 in pairs(_a1846) do
_a1850 += 1
local _a1860 = _a1590(_a1859) or 0
_a1851 += _a1860
if _a1589(_a1859) then _a1853 += 1
elseif _a1856 > _a1860 * _a1572.CropMargin then _a1852 += 1
else _a1854 += 1 end
_a1857 += 1
if _a1857 <= 20 then
_a1569(("  칸%-4s %-20s %s/s%s"):format(tostring(_a1858),
tostring(rawget(_a1859, "sp") or "?"), _a1570(_a1860),
_a1589(_a1859) and "  (자라는 중)" or ""))
end
end
if _a1850 > 20 then _a1569("  ... (" .. (_a1850 - 20) .. "칸 더)") end
_a1569("")
_a1569(("총 %d칸 / 합계 %s per sec"):format(_a1850, _a1570(_a1851)))
_a1569(("갈아엎기 대상 %d / 유지 %d / 자라는 중 %d"):format(_a1852, _a1854, _a1853))
_a1660("log")
end },
{ label = "지금 1회 실행", col = _a1618.cardHi, fn = function()
task.spawn(function() _a1574.crop = true _a1591() _a1574.crop = false _a1660("log") end)
end },
})
end
do
local _a1861, _a1862 = _a1693(_a1757, "자동 확장", nil)
_a1703(_a1862, "expand", function()
_a1617("expand", function() return _a1572.ExpandInterval end, _a1594, "확장")
end)
_a1714(_a1861, {
{ label = "주기", value = _a1572.ExpandInterval, onChange = function(_a1863)
local _a1864 = tonumber(_a1863) if _a1864 and _a1864 >= 5 then _a1572.ExpandInterval = _a1864 end
end },
{ label = "밭칸 스캔", value = _a1572.MaxBedScan, onChange = function(_a1865)
local _a1866 = tonumber(_a1865) if _a1866 and _a1866 >= 1 then _a1572.MaxBedScan = math.floor(_a1866) end
end },
})
_a1723(_a1861, {
{ label = "확장 현황 보기", col = _a1618.accent, fn = function()
local _a1867, _a1868, _a1869, _a1870 = _a1577()
if not _a1868 then _a1569("[확장] 밭 없음") _a1660("log") return end
local _a1871 = _a1583()
_a1575.sun = _a1871
local _a1872 = _a1592(true)
_a1569("")
_a1569("──── 확장 현황 ────")
_a1569("Sunflowers = " .. _a1570(_a1871, 0))
_a1569("")
_a1569("레인 " .. tostring(_a1870) .. "개 열림")
local _a1873 = {}
for _a1874 in pairs(_a1872) do _a1873[#_a1873 + 1] = tonumber(_a1874) or _a1874 end
table.sort(_a1873, function(_a1875, _a1876) return tostring(_a1875) < tostring(_a1876) end)
for _a1877, _a1878 in ipairs(_a1873) do
local _a1879 = _a1872[_a1878] or _a1872[tostring(_a1878)]
local _a1880 = tonumber(_a1878) or 0
local _a1881 = (_a1880 == (tonumber(_a1870) or 0) + 1)
and ((tonumber(_a1879) or math.huge) <= _a1871 and "  ← 지금 오픈 가능" or "  ← 다음 (돈 부족)")
or (_a1880 <= (tonumber(_a1870) or 0) and "  (열림)" or "")
_a1569(("  레인 %-3s %s%s"):format(tostring(_a1878), _a1570(tonumber(_a1879) or 0, 0), _a1881))
end
local _a1882 = _a1593(_a1868)
_a1569("")
_a1569("잠긴 밭칸 " .. #_a1882 .. "개 (싼 순 8개)")
for _a1883 = 1, math.min(8, #_a1882) do
local _a1884 = _a1882[_a1883]
_a1569(("  칸 %-4s %s%s"):format(_a1884.id, _a1884.cost and _a1570(_a1884.cost, 0) or "?",
(_a1884.cost and _a1884.cost <= _a1871) and "  ← 오픈 가능" or ""))
end
if #_a1882 == 0 then _a1569("  (전부 열려 있음)") end
_a1660("log")
end },
{ label = "지금 1회 실행", col = _a1618.cardHi, fn = function()
task.spawn(function() _a1574.expand = true _a1594() _a1574.expand = false _a1660("log") end)
end },
})
end
do
local _a1885, _a1886 = _a1693(_a1757, "자동 리버스", nil)
_a1703(_a1886, "rebirth", function()
_a1617("rebirth", function() return _a1572.RebirthInterval end, _a1596, "리버스")
end)
_a1714(_a1885, {
{ label = "주기", value = _a1572.RebirthInterval, onChange = function(_a1887)
local _a1888 = tonumber(_a1887) if _a1888 and _a1888 >= 10 then _a1572.RebirthInterval = _a1888 end
end },
})
_a1723(_a1885, {
{ label = "리버스 현황 보기", col = _a1618.accent, fn = function()
local _a1889 = _a1595()
_a1569("")
_a1569("──── 리버스 현황 ────")
if not _a1889 then _a1569("  밭 없음") _a1660("log") return end
_a1569(("  현재 리버스   %d회  (최대 %s)"):format(_a1889.regrows, tostring(_a1889.cap)))
_a1569(("  레인          %d / 7 %s"):format(_a1889.lanes, _a1889.lanes >= 7 and "OK" or "부족"))
_a1569(("  코인보스      %d / %d %s"):format(_a1889.kills, _a1889.need,
_a1889.kills >= _a1889.need and "OK" or "부족"))
_a1569("")
_a1569(_a1889.ready and "  ★ 지금 리버스 가능" or ("  대기 — " .. tostring(_a1889.reason)))
_a1660("log")
end },
{ label = "지금 1회 리버스", col = _a1618.bad, fn = function()
task.spawn(function() _a1574.rebirth = true _a1596() _a1574.rebirth = false _a1660("log") end)
end },
})
end
local _a1890 = _a1677("main", "메인 게임", 30)
do
local _a1891, _a1892 = _a1693(_a1890, "올 자동", nil)
local _a1893 = _a1619("Frame", {
Size = UDim2.new(1, 0, 0, 108), BackgroundColor3 = _a1618.cardHi,
BorderSizePixel = 0, LayoutOrder = _a1688(),
}, _a1891)
_a1626(_a1893, 6)
_a1633(_a1893, 8)
local _a1894 = _a1619("TextLabel", {
Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
Font = Enum.Font.Code, TextSize = 12, TextColor3 = _a1618.text,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Text = "정지", RichText = true,
}, _a1893)
task.spawn(function()
while _a1636 and _a1636.Parent do
local _a1895 = _a1605.now
local _a1896 = _a1574.auto and "🟢" or "⚪"
local _a1897 = _a1895.act or "-"
if _a1895.detail and _a1895.detail ~= "" then _a1897 = _a1897 .. "  " .. _a1895.detail end
_a1894.Text = table.concat({
_a1896 .. " " .. (_a1574.auto and (_a1895.step or "-") or "정지"),
"▸ " .. _a1897,
"목표 " .. (_a1895.goal or "-") .. (_a1895.prog ~= "" and ("   " .. _a1895.prog) or ""),
"1.리버스 " .. (_a1605.rebNote or "-"),
"2.존해금 " .. (_a1605.zoneNote or "-"),
"파밍대상 " .. tostring(_a1605.farmZone or "-") .. "   현재 " .. tostring(_a1605.hereZone or "-"),
}, "\n")
task.wait(0.2)
end
end)
_a1703(_a1892, "auto", function()
for _a1898, _a1899 in ipairs(_a1605.STEPS) do _a1574[_a1899.run] = false end
for _a1900, _a1901 in ipairs(_a1605.SIDE) do _a1574[_a1901.run] = false end
_a1574.petspd = true
_a1574.rewatch = true
_a1700()
_a1617("auto", function() return _a1572.AutoInterval end, _a1605.master, "자동")
end)
_a1714(_a1891, {
{ label = "주기", value = _a1572.AutoInterval, onChange = function(_a1902)
local _a1903 = tonumber(_a1902) if _a1903 and _a1903 >= 1 then _a1572.AutoInterval = _a1903 end
end },
{ label = "정체 판정(초)", value = _a1572.PursueStallSec, onChange = function(_a1904)
local _a1905 = tonumber(_a1904) if _a1905 and _a1905 >= 10 then _a1572.PursueStallSec = _a1905 end
end },
})
_a1714(_a1891, {
{ label = "운 퀘 최소 알 개수", value = _a1572.HatchMinAfford, onChange = function(_a1906)
local _a1907 = tonumber(_a1906) if _a1907 and _a1907 >= 1 then _a1572.HatchMinAfford = math.floor(_a1907) end
end },
{ label = "더 버는 시간(초)", value = _a1572.MoneyDwell, onChange = function(_a1908)
local _a1909 = tonumber(_a1908) if _a1909 and _a1909 >= 0 then _a1572.MoneyDwell = _a1909 end
end },
})
_a1714(_a1891, {
{ label = "부화 한 번에(초)", value = _a1572.HatchBudget, onChange = function(_a1910)
local _a1911 = tonumber(_a1910) if _a1911 and _a1911 >= 3 then _a1572.HatchBudget = _a1911 end
end },
})
_a1714(_a1891, {
{ label = "이동 방식", value = _a1572.TpMode, onChange = function(_a1912)
_a1912 = tostring(_a1912 or ""):lower()
if _a1912 == "instant" or _a1912 == "glide" or _a1912 == "walk" then _a1572.TpMode = _a1912 end
end },
{ label = "glide 속도", value = _a1572.TpSpeed, onChange = function(_a1913)
local _a1914 = tonumber(_a1913) if _a1914 and _a1914 >= 16 then _a1572.TpSpeed = _a1914 end
end },
})
_a1733(_a1891, "차단 화면에 실제 클릭까지 시도",
function() return _a1572.ScreenRealClick end,
function(_a1915) _a1572.ScreenRealClick = _a1915 end)
_a1733(_a1891, "퀘스트 없을 때도 알 까기",
function() return _a1572.IdleHatch end,
function(_a1916) _a1572.IdleHatch = _a1916 end)
_a1733(_a1891, "존 해금·리버스는 퀘스트 끝나고",
function() return _a1572.HoldZoneForQuest end,
function(_a1917) _a1572.HoldZoneForQuest = _a1917 end)
for _a1918, _a1919 in ipairs(_a1605.STEPS) do
local _a1920 = _a1919.key
_a1733(_a1891, "  " .. _a1918 .. ". " .. _a1919.label,
function() return _a1572.StepOn[_a1920] end,
function(_a1921) _a1572.StepOn[_a1920] = _a1921 end)
end
for _a1922, _a1923 in ipairs(_a1605.SIDE) do
local _a1924 = _a1923.key
_a1733(_a1891, "  · " .. _a1923.label .. " (순위 밖)",
function() return _a1572.StepOn[_a1924] end,
function(_a1925) _a1572.StepOn[_a1924] = _a1925 end)
end
_a1723(_a1891, {
{ label = "지금 상태", col = _a1618.accent, fn = function()
_a1569("")
_a1569("──── 올 자동 ────")
_a1569("  " .. (_a1574.auto and "돌아가는 중" or "정지") ..
(_a1605.step and ("   지금: " .. _a1605.step) or ""))
local _a1926, _a1927 = _a1605.bestDepActive()
_a1569("  현재 존 " .. tostring(_a1605.curZone()) .. " / 최고 존 " .. tostring(_a1605.bestZone()))
if _a1926 then
_a1569("  ⏸ 존해금·리버스 보류 중 — " .. tostring(_a1927 and _a1927.title))
else
_a1569("  존해금·리버스 진행 가능")
end
_a1569("")
_a1569("  먼저 (순위 밖):")
for _a1928, _a1929 in ipairs(_a1605.SIDE) do
_a1569(("      %-16s %s"):format(_a1929.label, _a1572.StepOn[_a1929.key] and "ON" or "off"))
end
_a1569("  우선순위:")
for _a1930, _a1931 in ipairs(_a1605.STEPS) do
_a1569(("    %d. %-16s %s%s"):format(_a1930, _a1931.label,
_a1572.StepOn[_a1931.key] and "ON" or "off",
_a1931.hold and "   (퀘스트 붙잡는 중엔 보류)" or ""))
end
_a1660("log")
end },
{ label = "화면 넘기기 진단", col = _a1618.warn, fn = function()
task.spawn(function()
_a1569("")
_a1569("──── 보상 화면 ────")
local _a1932 = _a1604.Vars
_a1569("  Library.Variables : " .. (_a1932 and "로드됨" or "없음"))
if _a1932 then
_a1569("    IsRebirthing = " .. tostring(rawget(_a1932, "IsRebirthing")))
_a1569("    IsRankingUp  = " .. tostring(rawget(_a1932, "IsRankingUp")))
_a1569("    OpeningEgg   = " .. tostring(rawget(_a1932, "OpeningEgg")))
end
_a1569("  debug.info     : " .. tostring(type(debug) == "table" and type(debug.info) == "function"))
_a1569("  getgc          : " .. tostring(type(getgc) == "function"))
_a1569("  debug.setupvalue: " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
local _a1933 = _a1567:FindFirstChildOfClass("PlayerGui")
if _a1933 then
_a1569("  떠 있는 차단 화면:")
local _a1934 = false
for _a1935, _a1936 in ipairs(_a1605.BLOCKERS) do
local _a1937 = _a1933:FindFirstChild(_a1936[1])
_a1569(("    %-14s %s"):format(_a1936[1],
_a1937 and (_a1937.Enabled and "★ 켜짐" or "꺼짐") or "없음"))
if _a1937 and _a1937.Enabled then _a1934 = true end
end
if not _a1934 then _a1569("    (없음)") end
end
if type(getgc) == "function" and type(debug) == "table" and debug.info then
_a1569("")
_a1569("  Rebirth/RankUp 스크립트의 클로저 시그니처:")
local _a1938, _a1939 = {}, 0
for _a1940, _a1941 in ipairs({ true, false }) do
local _a1942, _a1943 = pcall(getgc, _a1941)
if _a1942 then
for _a1944, _a1945 in ipairs(_a1943) do
if type(_a1945) == "function" and _a1939 < 25 then
local _a1946, _a1947 = pcall(debug.info, _a1945, "s")
if _a1946 and type(_a1947) == "string"
and (_a1947:find("Rebirth", 1, true) or _a1947:find("Rank Up", 1, true)) then
local _a1948, _a1949 = pcall(debug.info, _a1945, "a")
if _a1948 then
local _a1950 = {}
for _a1951 = 1, 16 do
local _a1952, _a1953 = pcall(debug.getupvalue, _a1945, _a1951)
if not _a1952 then break end
_a1950[_a1951] = type(_a1953)
end
local _a1954 = ("인자%d | %s"):format(_a1949 or -1,
#_a1950 > 0 and table.concat(_a1950, ",") or "(없음)")
if not _a1938[_a1954] then
_a1938[_a1954] = true
_a1939 += 1
_a1569("    " .. _a1954)
end
end
end
end
end
end
end
if _a1939 == 0 then _a1569("    (하나도 못 찾음)") end
end
for _a1955, _a1956 in ipairs({ "reward", "egg", "mastery", "card" }) do
_a1605._sig = nil
local _a1957 = _a1605.findSignalFns(_a1956)
_a1569("")
_a1569(("  [%s] 찾은 함수 %d개"):format(_a1956, #_a1957))
for _a1958, _a1959 in ipairs(_a1957) do
_a1569(("    %s%s"):format(_a1959.exact and "★정확일치 " or "", tostring(_a1959.src)))
_a1569(("       upvalue %d개 : %s"):format(_a1959.n or 0, tostring(_a1959.sig)))
end
if #_a1957 == 0 then
_a1569("    (getgc 로 그 스크립트의 클로저를 못 찾음)")
end
local _a1960, _a1961 = _a1605.signal(_a1956)
_a1569(("    upvalue 신호 : %s (%s개 세팅)"):format(tostring(_a1960), tostring(_a1961)))
local _a1962 = _a1605.SIGNAL[_a1956]
_a1569(("    게임내 입력발동 : %s"):format(
tostring(_a1605.pressInGame(_a1962 and _a1962.pats or {}))))
end
_a1569("")
_a1569("  감시 루프 RUN.rewatch = " .. tostring(_a1574.rewatch))
_a1660("log")
end)
end },
{ label = "한 바퀴만", col = _a1618.cardHi, fn = function()
task.spawn(function()
_a1574.auto = true _a1605.master() _a1574.auto = false _a1660("log")
end)
end },
{ label = "자동 점검", col = _a1618.warn, fn = function()
task.spawn(function()
_a1569("")
_a1569("════ 올 자동 점검 ════")
_a1569("  RUN.auto = " .. tostring(_a1574.auto))
local _a1963 = {}
for _a1964, _a1965 in ipairs(_a1605.SIDE) do
_a1963[#_a1963 + 1] = _a1965.key .. "=" .. tostring(_a1572.StepOn[_a1965.key])
end
for _a1966, _a1967 in ipairs(_a1605.STEPS) do
_a1963[#_a1963 + 1] = _a1967.key .. "=" .. tostring(_a1572.StepOn[_a1967.key])
end
_a1569("  단계 ON/OFF : " .. table.concat(_a1963, "  "))
_a1569("  lockGoal    : " .. (_a1605.lockGoal and tostring(_a1605.lockGoal.q.title) or "없음"))
local _a1968, _a1969 = _a1605.bestDepActive()
_a1569("  보류중?     : " .. tostring(_a1968) .. (_a1969 and ("  ← " .. tostring(_a1969.title)) or ""))
_a1569("  리모트      : 존 " .. (_a1604.R_Zone and "O" or "X")
.. " / 리버스 " .. (_a1604.R_Reb and "O" or "X"))
_a1569("")
_a1569("  ── 존 해금 판정 ──")
local _a1970 = _a1609()
if not _a1970 then
_a1569("    zoneStatus() = nil  ← 다음 존을 못 구함")
local _a1971 = _a1604.Zone and rawget(_a1604.Zone, "GetNextZone")
if _a1971 then
local _a1972, _a1973, _a1974 = pcall(_a1604.Zone.GetNextZone)
_a1569("    GetNextZone → ok=" .. tostring(_a1972)
.. " / " .. tostring(_a1973) .. " / " .. tostring(_a1974))
end
if _a1604.Zone and rawget(_a1604.Zone, "HasCompletedNextZoneQuests") then
local _a1975, _a1976 = pcall(_a1604.Zone.HasCompletedNextZoneQuests)
_a1569("    존 퀘스트 완료? " .. (_a1975 and tostring(_a1976) or ("에러 " .. tostring(_a1976))))
end
else
_a1569("    다음 존 : " .. tostring(_a1970.id))
_a1569(("    가격 %s %s / 보유 %s → %s"):format(
_a1570(_a1970.price or 0, 0), tostring(_a1970.currency), _a1570(_a1970.have, 0),
_a1970.ok and "지금 살 수 있음" or "부족"))
end
_a1569("")
_a1569("  ── 리버스 판정 ──")
local _a1977 = _a1614()
if not _a1977 then _a1569("    세이브 못 읽음")
else
_a1569(("    현재 %d → 다음 %d"):format(_a1977.current, _a1977.nextN))
_a1569("    최근 사유 : " .. tostring(_a1605.rebNote or "-"))
end
_a1569("")
_a1569("  ── 직전 바퀴 기록 ──")
if _a1605.lastTrace and #_a1605.lastTrace > 0 then
for _a1978, _a1979 in ipairs(_a1605.lastTrace) do _a1569("    " .. _a1979) end
_a1569(("    (%.0f초 전)"):format(os.clock() - (_a1605.lastPassAt or os.clock())))
else
_a1569("    아직 한 바퀴도 안 돌았음")
end
_a1660("log")
end)
end },
})
local _a1980, _a1981 = _a1693(_a1890, "펫 이동속도", nil)
_a1703(_a1981, "petspd", function()
_a1617("petspd", function() return 0.4 end, _a1605.applyPetSpeed, "펫속도")
end)
_a1714(_a1980, {
{ label = "배수", value = _a1572.PetSpeedMult, onChange = function(_a1982)
local _a1983 = tonumber(_a1982) if _a1983 and _a1983 >= 1 then _a1572.PetSpeedMult = _a1983 end
end },
{ label = "기본 계수 (원래 0.45)", value = _a1572.PetSpeedBase, onChange = function(_a1984)
local _a1985 = tonumber(_a1984) if _a1985 and _a1985 > 0 then _a1572.PetSpeedBase = _a1985 end
end },
})
_a1723(_a1980, {
{ label = "지금 적용 / 확인", col = _a1618.accent, fn = function()
local _a1986, _a1987 = _a1605.applyPetSpeed()
_a1569("")
_a1569("──── 펫 이동속도 ────")
_a1569("  PlayerPet 모듈 : " .. (_a1604.PlayerPet and "로드됨" or "없음"))
_a1569(("  적용된 펫 %d마리  (배수 %s / 계수 %s)"):format(
_a1986, tostring(_a1572.PetSpeedMult), tostring(_a1572.PetSpeedBase)))
if _a1987 then _a1569("  " .. tostring(_a1987)) end
if _a1986 == 0 then _a1569("  펫을 장착하고 다시 눌러보세요") end
_a1660("log")
end },
})
_a1617("petspd", function() return 0.4 end, _a1605.applyPetSpeed, "펫속도")
_a1617("rewatch", function() return 1 end, function()
_a1605.watchTick = (_a1605.watchTick or 0) + 1
if _a1605.dismissBusy then return end
local _a1988, _a1989 = _a1605.rewardScreenUp()
if _a1988 and _a1605.screenGaveUp and (os.clock() - _a1605.screenGaveUp) < 30 then
return
end
if _a1988 then
if _a1605.lastBlocker ~= _a1989 then
_a1605.lastBlocker = _a1989
_a1569("[화면] " .. tostring(_a1989) .. " 화면 감지 — 넘기는 중")
end
_a1605.dismissRewardScreens(20)
end
end, "보상화면")
local _a1990, _a1991 = _a1693(_a1890, "자동 파밍 유지", nil)
_a1703(_a1991, "farm", function()
_a1617("farm", function() return _a1572.FarmInterval end, _a1608, "파밍")
end)
_a1714(_a1990, {
{ label = "주기", value = _a1572.FarmInterval, onChange = function(_a1992)
local _a1993 = tonumber(_a1992) if _a1993 and _a1993 >= 3 then _a1572.FarmInterval = _a1993 end
end },
})
local _a1994, _a1995 = _a1693(_a1890, "자동 존 해금", nil)
_a1703(_a1995, "zone", function()
_a1617("zone", function() return _a1572.ZoneInterval end, _a1610, "존")
end)
_a1714(_a1994, {
{ label = "주기", value = _a1572.ZoneInterval, onChange = function(_a1996)
local _a1997 = tonumber(_a1996) if _a1997 and _a1997 >= 3 then _a1572.ZoneInterval = _a1997 end
end },
})
_a1723(_a1994, {
{ label = "다음 존 보기", col = _a1618.accent, fn = function()
local _a1998 = _a1609()
_a1569("")
if not _a1998 then _a1569("[존] 다음 존 없음 (최대 도달?)")
else
_a1569("──── 다음 존 ────")
_a1569("  " .. tostring(_a1998.id))
_a1569("  가격 " .. _a1570(_a1998.price or 0, 0) .. " " .. tostring(_a1998.currency))
_a1569("  보유 " .. _a1570(_a1998.have, 0))
_a1569("  " .. (_a1998.ok and "지금 해금 가능" or "부족"))
end
_a1660("log")
end },
{ label = "지금 1회", col = _a1618.cardHi, fn = function()
task.spawn(function() _a1574.zone = true _a1610() _a1574.zone = false _a1660("log") end)
end },
})
local _a1999, _a2000 = _a1693(_a1890, "자동 부화", nil)
_a1703(_a2000, "mhatch", function()
_a1617("mhatch", function() return _a1572.MainHatchInterval end, _a1613, "부화")
end)
_a1714(_a1999, {
{ label = "주기", value = _a1572.MainHatchInterval, onChange = function(_a2001)
local _a2002 = tonumber(_a2001) if _a2002 and _a2002 >= 1 then _a1572.MainHatchInterval = _a2002 end
end },
{ label = "한 번에 최대", value = _a1572.MainHatchMax, onChange = function(_a2003)
local _a2004 = tonumber(_a2003) if _a2004 and _a2004 >= 1 then _a1572.MainHatchMax = math.floor(_a2004) end
end },
})
_a1714(_a1999, {
{ label = "예비금", value = _a1572.MainHatchReserve, onChange = function(_a2005)
local _a2006 = tonumber(_a2005) if _a2006 and _a2006 >= 0 then _a1572.MainHatchReserve = _a2006 end
end },
{ label = "알 ID (비우면 자동)", value = _a1572.MainEggId, onChange = function(_a2007)
_a1572.MainEggId = _a2007 or ""
end },
})
_a1714(_a1999, {
{ label = "알 인식 거리", value = _a1572.EggRange, onChange = function(_a2008)
local _a2009 = tonumber(_a2008) if _a2009 and _a2009 >= 5 then _a1572.EggRange = _a2009 end
end },
})
_a1733(_a1999, "새 맵 열리면 잠긴 알 자동 해금",
function() return _a1572.AutoUnlockEgg end,
function(_a2010) _a1572.AutoUnlockEgg = _a2010 end)
_a1733(_a1999, "게임 내장 오토해치 사용 (기본 끔)",
function() return _a1572.UseAutoHatch end,
function(_a2011) _a1572.UseAutoHatch = _a2011 if not _a2011 then _a1605.autoHatchOff() end end)
_a1733(_a1999, "까는 화면 자동으로 넘기기 (신호)",
function() return _a1572.HatchClick end,
function(_a2012) _a1572.HatchClick = _a2012 end)
_a1723(_a1999, {
{ label = "잠긴 알 보기", col = _a1618.accent, fn = function()
local _a2013, _a2014, _a2015 = _a1605.lockedEggs()
_a1569("")
_a1569("──── 알 해금 현황 ────")
_a1569(("  해금 가능 최대 : #%d   /   현재 해금한 최대 : #%d"):format(_a2014, _a2015))
_a1569("  해금 리모트 : " .. (_a1604.R_EggUn and "있음" or "없음"))
if #_a2013 == 0 then
_a1569("  풀 수 있는 알이 없음 (다 풀었거나 존을 더 사야 함)")
else
_a1569("  아직 안 푼 알 " .. #_a2013 .. "개:")
for _a2016, _a2017 in ipairs(_a2013) do
_a1569(("    #%-3d %s"):format(_a2017.num, _a2017.id))
if _a2016 >= 20 then _a1569("    ...") break end
end
end
_a1660("log")
end },
{ label = "부화 진단", col = _a1618.warn, fn = function()
task.spawn(function()
_a1569("")
_a1569("──── 부화 진단 ────")
local _a2018, _a2019, _a2020, _a2021 = _a1611()
_a1569("  대상 알   : " .. tostring(_a2018))
if not _a2018 then _a1569("  (오픈한 알이 없음)") _a1660("log") return end
local _a2022 = _a2019 and tonumber(rawget(_a2019, "eggNumber"))
_a1569("  알 번호   : " .. tostring(_a2022) .. "   오픈함? " .. tostring(_a1605.eggUnlocked(_a2022)))
_a1569("  거리      : " .. (_a2020 and ("%.0f (사거리 안)"):format(_a2020)
or ((_a2021 and ("%.0f (사거리 %d 밖)"):format(_a2021, _a1572.EggRange)) or "받침대 못 찾음")))
local _a2023 = _a2019 and rawget(_a2019, "currency") or "?"
_a1569("  통화      : " .. tostring(_a2023) .. "   보유 " .. _a1570(_a1607(_a2023), 0))
if type(_a1604.CalcEgg) == "function" then
local _a2024, _a2025 = pcall(_a1604.CalcEgg, _a2019)
_a1569("  CalcEggPricePlayer : " .. (_a2024 and tostring(_a2025) or ("에러 " .. tostring(_a2025))))
end
if type(_a1604.CalcEggB) == "function" then
local _a2026, _a2027 = pcall(_a1604.CalcEggB, _a2019)
_a1569("  CalcEggPrice       : " .. (_a2026 and tostring(_a2027) or ("에러 " .. tostring(_a2027))))
end
if _a1604.Egg then
for _a2028, _a2029 in ipairs({ "GetMaxHatch", "ComputeDebounce", "GetHighestEggNumberAvailable" }) do
if rawget(_a1604.Egg, _a2029) then
local _a2030, _a2031 = pcall(_a1604.Egg[_a2029], _a2019)
_a1569(("  %-28s : %s"):format(_a2029, _a2030 and tostring(_a2031) or ("에러 " .. tostring(_a2031))))
end
end
end
_a1569("  OpeningEgg      : " .. tostring(_a1604.Vars and rawget(_a1604.Vars, "OpeningEgg")))
if _a1604.Hatch then
for _a2032, _a2033 in ipairs({ "IsHatching", "GetEggAmount" }) do
if rawget(_a1604.Hatch, _a2033) then
local _a2034, _a2035 = pcall(_a1604.Hatch[_a2033])
_a1569(("  %-15s : %s"):format(_a2033, _a2034 and tostring(_a2035) or ("에러 " .. tostring(_a2035))))
end
end
if rawget(_a1604.Hatch, "GetEggDirectory") then
local _a2036, _a2037 = pcall(_a1604.Hatch.GetEggDirectory)
_a1569("  세팅된 알       : " .. (_a2036 and _a2037 and tostring(rawget(_a2037, "_id")) or "없음"))
end
end
_a1569("  ▶ SetupEgg 시도")
_a1605._ahEgg = nil
_a1605.autoHatchOn(_a2018, 1)
if _a1604.Hatch and rawget(_a1604.Hatch, "IsHatching") then
local _a2038, _a2039 = pcall(_a1604.Hatch.IsHatching)
_a1569("    IsHatching 이후 : " .. (_a2038 and tostring(_a2039) or ("에러 " .. tostring(_a2039))))
_a1569("    " .. ((_a2038 and _a2039) and "→ 클릭 없이 넘어갑니다"
or "→ SetupEgg 안 먹음. 클릭 대체가 필요합니다"))
end
_a1569("  신호 가능 : getgc " .. tostring(type(getgc) == "function")
.. " / debug.setupvalue " .. tostring(type(debug) == "table" and type(debug.setupvalue) == "function"))
_a1569("")
_a1569("  ▶ 1개로 실제 호출")
local _a2040, _a2041
local _a2042 = pcall(function() _a2040, _a2041 = _a1571.R_EGG:InvokeServer(_a2018, 1) end)
_a1569("    호출성공 : " .. tostring(_a2042))
_a1569("    반환1    : " .. tostring(_a2040))
_a1569("    반환2    : " .. tostring(_a2041))
_a1660("log")
end)
end },
{ label = "지금 전부 해금", col = _a1618.good, fn = function()
task.spawn(function()
_a1569("")
local _a2043, _a2044 = _a1605.unlockEggs(true)
_a1569(_a2043 > 0 and ("[해금] %d개 완료"):format(_a2043)
or ("[해금] 0개" .. (_a2044 and (" — " .. tostring(_a2044)) or "")))
_a1660("log")
end)
end },
})
_a1723(_a1999, {
{ label = "알 현황 보기", col = _a1618.accent, fn = function()
local _a2045 = _a1612()
_a1569("")
if not _a2045 then _a1569("[부화] 알을 못 찾음")
else
_a1569("──── 메인 알 ────")
_a1569("  " .. tostring(_a2045.id))
_a1569("  가격 " .. (_a2045.price and _a1570(_a2045.price, 0) or "?") .. " " .. tostring(_a2045.currency))
_a1569("  보유 " .. _a1570(_a2045.have, 0))
_a1569("  한 번에 " .. _a2045.maxN .. "개까지")
_a1569("  지금 가능 " .. _a2045.canBuy .. "회")
if _a2045.inRange then
_a1569(("  거리 %.0f 스터드 — 부화 가능"):format(_a2045.dist))
else
_a1569(("  사거리(%d) 안에 알 없음. 가장 가까운 알 %s스터드"):format(
_a1572.EggRange, _a2045.nearest and ("%.0f"):format(_a2045.nearest) or "?"))
_a1569("  → 알 앞으로 걸어가야 부화됩니다")
end
end
_a1569("")
_a1569("──── 주변 알 (가까운 순 10개) ────")
local _a2046 = _a1605.eggStands()
for _a2047 = 1, math.min(10, #_a2046) do
local _a2048 = _a2046[_a2047]
_a1569(("  %6.0f  #%-3d %-24s %s"):format(
_a2048.dist, _a2048.num, _a2048.id, _a1605.eggUnlocked(_a2048.num) and "오픈함" or "잠김"))
end
if #_a2046 == 0 then _a1569("  (못 찾음)") end
_a1660("log")
end },
{ label = "지금 1회", col = _a1618.cardHi, fn = function()
task.spawn(function() _a1574.mhatch = true _a1613() _a1574.mhatch = false _a1660("log") end)
end },
})
local _a2049, _a2050 = _a1693(_a1890, "랭크 퀘스트 자동", nil)
_a1703(_a2050, "quest", function()
_a1617("quest", function() return _a1572.QuestInterval end, _a1605.cycle, "퀘스트")
end)
_a1714(_a2049, {
{ label = "주기", value = _a1572.QuestInterval, onChange = function(_a2051)
local _a2052 = tonumber(_a2051) if _a2052 and _a2052 >= 5 then _a1572.QuestInterval = _a2052 end
end },
{ label = "포션 한 번에", value = _a1572.QuestUseMax, onChange = function(_a2053)
local _a2054 = tonumber(_a2053) if _a2054 and _a2054 >= 1 then _a1572.QuestUseMax = math.floor(_a2054) end
end },
})
_a1733(_a2049, "필요한 자동화 자동 ON",
function() return _a1572.QuestDrive end,
function(_a2055) _a1572.QuestDrive = _a2055 end)
_a1733(_a2049, "포션/인챈트 업글 퀘스트",
function() return _a1572.QuestUpgrade end,
function(_a2056) _a1572.QuestUpgrade = _a2056 end)
_a1733(_a2049, "포션 사용 퀘스트",
function() return _a1572.QuestUsePotion end,
function(_a2057) _a1572.QuestUsePotion = _a2057 end)
_a1723(_a2049, {
{ label = "퀘스트 현황 보기", col = _a1618.accent, fn = function()
local _a2058 = _a1605.status()
_a1569("")
if not _a2058 then _a1569("[퀘스트] 세이브 못 읽음")
else
_a1569("──── 랭크 퀘스트 ────")
_a1569(("  Rank %d   ★%d"):format(_a2058.rank, _a2058.rankStars))
if #_a2058.list == 0 then _a1569("  퀘스트 없음") end
for _a2059, _a2060 in ipairs(_a2058.list) do
local _a2061 = _a2060.how
local _a2062 =
(_a2061 == "farm" and "자동 파밍") or
(_a2061 == "hatch" and "자동 부화") or
(_a2061 == "zone" and "자동 존") or
(_a2061 == "potup" and "포션 업글") or
(_a2061 == "encup" and "인챈트 업글") or
(_a2061 == "potuse" and "포션 사용") or
(_a2061 == "fruituse" and "과일 사용") or
(_a2061 == "flaguse" and "깃발 사용") or
(_a2061 == "gold" and "골드 머신") or
(_a2061 == "rainbow" and "레인보우 머신") or
"수동"
local _a2063 = ""
if _a2060.ignored then
_a2062 = "무시"
_a2063 = "   → " .. _a2060.ignored
elseif _a2060.event then
local _a2064 = _a1605.findEvent(_a2060.event, _a2060.bestOnly)
_a2063 = _a2064 and ("   → %s @%s %d초"):format(_a2064.name, tostring(_a2064.zone), _a2064.left)
or ("   → " .. _a2060.event .. " 대기중")
elseif _a2060.chest then
_a2063 = "   → " .. _a2060.chest
elseif _a2060.where then
_a2063 = "   → " .. _a2060.where
end
_a1569(("  [%d] %s"):format(_a2060.stars, tostring(_a2060.title)))
_a1569(("       %d / %d    처리: %s   (Type %d)%s"):format(
_a2060.progress, _a2060.amount, _a2062, _a2060.type, _a2063))
end
end
_a1660("log")
end },
{ label = "활성 이벤트 보기", col = _a1618.accent, fn = function()
local _a2065 = _a1605.events()
local _a2066 = _a1605.bestZone()
_a1569("")
_a1569("──── 지금 떠 있는 랜덤 이벤트 ────")
_a1569("  최고 존 : " .. tostring(_a2066) .. "   현재 존 : " .. tostring(_a1605.curZone()))
if #_a2065 == 0 then _a1569("  없음 (RandomEvents_Get 응답 비어있음)") end
for _a2067, _a2068 in ipairs(_a2065) do
_a1569(("  %-12s @%-20s %4d초 남음  %s%s"):format(
_a2068.kind, tostring(_a2068.zone), _a2068.left,
_a2068.pos and ("(%.0f, %.0f, %.0f)"):format(_a2068.pos.X, _a2068.pos.Y, _a2068.pos.Z) or "좌표없음",
_a2068.zone == _a2066 and "  ★최고존" or ""))
end
_a1569("")
_a1569("  내 소환 아이템 :")
for _a2069 in pairs(_a1605.SPAWN) do
local _a2070 = _a1605.spawnItems(_a2069)
local _a2071 = 0
for _a2072, _a2073 in ipairs(_a2070) do _a2071 += _a2073.am end
_a1569(("    %-12s %d종 %d개"):format(_a2069, #_a2070, _a2071))
for _a2074, _a2075 in ipairs(_a2070) do
_a1569(("        %d. %-24s x%d%s"):format(
_a2074, _a2075.id, _a2075.am, _a2074 == 1 and "   ← 먼저 씀" or ""))
if _a2074 >= 6 then break end
end
end
_a1569("  점선 네모 안? " .. tostring(_a1605.inDottedBox()))
for _a2076, _a2077 in ipairs({ "MiniChests", "SuperiorMiniChests" }) do
local _a2078, _a2079 = _a1605.findChest(_a2077)
_a1569(("  %-20s %s"):format(_a2077,
_a2078 and ("가장 가까운 것 %.0f스터드"):format(_a2079 or 0) or "없음"))
end
_a1660("log")
end },
{ label = "포션 재고 보기", col = _a1618.accent, fn = function()
_a1569("")
_a1569("──── 포션 / 인챈트 재고 ────")
for _a2080, _a2081 in ipairs({ "Potion", "Enchant" }) do
local _a2082 = _a1605.stacks(_a2081)
table.sort(_a2082, function(_a2083, _a2084)
if _a2083.id ~= _a2084.id then return _a2083.id < _a2084.id end
return _a2083.tier < _a2084.tier
end)
_a1569("")
_a1569(_a2081 .. "  (" .. #_a2082 .. "종)")
for _a2085, _a2086 in ipairs(_a2082) do
local _a2087 = _a1605.perTier(_a2081, _a2086.tier)
local _a2088 = _a2087 and math.floor(_a2086.am / _a2087) or 0
_a1569(("   %-20s T%-2d x%-6d %s"):format(
_a2086.id, _a2086.tier, _a2086.am,
_a2088 > 0 and ("→ T" .. (_a2086.tier + 1) .. " " .. _a2088 .. "개 제작가능") or ""))
if _a2085 >= 40 then _a1569("   ...") break end
end
if #_a2082 == 0 then _a1569("   (없음)") end
end
_a1660("log")
end },
{ label = "지금 1회", col = _a1618.cardHi, fn = function()
task.spawn(function() _a1574.quest = true _a1605.cycle() _a1574.quest = false _a1660("log") end)
end },
})
local _a2089, _a2090 = _a1693(_a1890, "슬롯 머신 자동 (다이아)", nil)
_a1703(_a2090, "slots", function()
_a1617("slots", function() return _a1572.SlotInterval end, _a1605.cycleSlots, "슬롯")
end)
_a1714(_a2089, {
{ label = "주기", value = _a1572.SlotInterval, onChange = function(_a2091)
local _a2092 = tonumber(_a2091) if _a2092 and _a2092 >= 5 then _a1572.SlotInterval = _a2092 end
end },
{ label = "남길 다이아", value = _a1572.SlotReserve, onChange = function(_a2093)
local _a2094 = tonumber(_a2093) if _a2094 and _a2094 >= 0 then _a1572.SlotReserve = _a2094 end
end },
})
_a1733(_a2089, "펫 장착 슬롯 (Pet Equip)",
function() return _a1572.SlotPet end, function(_a2095) _a1572.SlotPet = _a2095 end)
_a1733(_a2089, "알 부화 슬롯 (Egg Machine)",
function() return _a1572.SlotEgg end, function(_a2096) _a1572.SlotEgg = _a2096 end)
_a1723(_a2089, {
{ label = "슬롯 현황 보기", col = _a1618.accent, fn = function()
local _a2097 = _a1605.slotStatus()
_a1569("")
_a1569("──── 슬롯 머신 ────")
if not _a2097 then _a1569("  세이브 못 읽음") _a1660("log") return end
_a1569("  다이아 " .. _a1570(_a2097.dia, 0))
_a1569("")
_a1569(("  펫 장착 : 구매 %d / 랭크상한 %d   현재 최대장착 %s"):format(
_a2097.petOwned, _a2097.petMax, tostring(_a2097.maxEquip)))
if _a2097.petNext then
_a1569(("     다음 #%d  %s 다이아  %s"):format(
_a2097.petNext, _a2097.petCost and _a1570(_a2097.petCost, 0) or "?",
(_a2097.petCost and _a2097.petCost <= _a2097.dia - _a1572.SlotReserve) and "← 지금 가능" or "부족"))
else
_a1569("     랭크 상한까지 다 삼 (랭크를 올려야 더 살 수 있음)")
end
_a1569("")
_a1569(("  알 부화 : 구매 %d / 랭크상한 %d   한 번에 %s개"):format(
_a2097.eggOwned, _a2097.eggMax, tostring(_a2097.maxHatch)))
if _a2097.eggEnd then
_a1569(("     다음 %d칸 묶음 → %d   %s 다이아  %s"):format(
_a2097.eggSize, _a2097.eggEnd, _a2097.eggCost and _a1570(_a2097.eggCost, 0) or "?",
(_a2097.eggCost and _a2097.eggCost <= _a2097.dia - _a1572.SlotReserve) and "← 지금 가능" or "부족"))
else
_a1569("     랭크 상한까지 다 삼")
end
_a1569("")
_a1569("  리모트 : 펫 " .. (_a1604.R_PetSlot and "O" or "X")
.. " / 알 " .. (_a1604.R_EggSlot and "O" or "X"))
_a1660("log")
end },
{ label = "지금 1회", col = _a1618.cardHi, fn = function()
task.spawn(function() _a1574.slots = true _a1605.cycleSlots() _a1574.slots = false _a1660("log") end)
end },
})
local _a2098, _a2099 = _a1693(_a1890, "아이템 자동 사용 (버프 유지)", nil)
_a1703(_a2099, "items", function()
_a1617("items", function() return _a1572.ItemInterval end, _a1605.cycleItems, "아이템")
end)
_a1714(_a2098, {
{ label = "주기", value = _a1572.ItemInterval, onChange = function(_a2100)
local _a2101 = tonumber(_a2100) if _a2101 and _a2101 >= 5 then _a1572.ItemInterval = _a2101 end
end },
{ label = "포션 한 바퀴 최대", value = _a1572.BuffMaxPotion, onChange = function(_a2102)
local _a2103 = tonumber(_a2102) if _a2103 and _a2103 >= 1 then _a1572.BuffMaxPotion = math.floor(_a2103) end
end },
})
_a1714(_a2098, {
{ label = "남길 개수", value = _a1572.ItemKeep, onChange = function(_a2104)
local _a2105 = tonumber(_a2104) if _a2105 and _a2105 >= 0 then _a1572.ItemKeep = math.floor(_a2105) end
end },
{ label = "과일/소모품 최대", value = _a1572.BuffMaxOther, onChange = function(_a2106)
local _a2107 = tonumber(_a2106) if _a2107 and _a2107 >= 1 then _a1572.BuffMaxOther = math.floor(_a2107) end
end },
})
_a1714(_a2098, {
{ label = "쓸 것 (비우면 전부)", value = _a1572.ItemAllow, onChange = function(_a2108)
_a1572.ItemAllow = _a2108 or ""
end },
{ label = "제외", value = _a1572.ItemBlock, onChange = function(_a2109)
_a1572.ItemBlock = _a2109 or ""
end },
})
_a1733(_a2098, "포션", function() return _a1572.BuffPotion end,
function(_a2110) _a1572.BuffPotion = _a2110 end)
_a1733(_a2098, "과일", function() return _a1572.BuffFruit end,
function(_a2111) _a1572.BuffFruit = _a2111 end)
_a1733(_a2098, "얼티밋 (충전되면 발동, 무료)", function() return _a1572.BuffUltimate end,
function(_a2112) _a1572.BuffUltimate = _a2112 end)
_a1733(_a2098, "소모품 (Rain/Sunlight 주의)", function() return _a1572.BuffConsumable end,
function(_a2113) _a1572.BuffConsumable = _a2113 end)
_a1733(_a2098, "높은 티어부터 사용 (끄면 낮은 것부터)", function() return _a1572.BuffHighTier end,
function(_a2114) _a1572.BuffHighTier = _a2114 end)
_a1733(_a2098, "최고 존에서만 사용", function() return _a1572.ItemBestZone end,
function(_a2115) _a1572.ItemBestZone = _a2115 end)
_a1733(_a2098, "최고 존이 아니면 이동 후 사용", function() return _a1572.ItemTp end,
function(_a2116) _a1572.ItemTp = _a2116 end)
_a1723(_a2098, {
{ label = "버프 현황 보기", col = _a1618.accent, fn = function()
_a1569("")
_a1569("──── 버프 / 아이템 ────")
_a1569(("  현재 존 %s / 최고 존 %s%s"):format(
tostring(_a1605.curZone()), tostring(_a1605.bestZone()),
_a1572.ItemBestZone and (_a1605.curZone() == _a1605.bestZone() and "   ← 사용 가능" or "   ← 이동 필요") or ""))
for _a2117, _a2118 in pairs({ Potions = "Potion", Fruits = "Fruit" }) do
local _a2119 = _a1605.activeBuffs(_a2117)
local _a2120 = {}
for _a2121 in pairs(_a2119) do _a2120[#_a2120 + 1] = _a2121 end
table.sort(_a2120)
_a1569(("  지금 걸린 %s : %s"):format(_a2117,
#_a2120 > 0 and table.concat(_a2120, ", ") or "없음"))
end
local _a2122 = _a1606()
local _a2123 = _a2122 and rawget(_a2122, "Ultimates")
if type(_a2123) == "table" then
local _a2124 = {}
for _a2125 in pairs(_a2123) do
local _a2126 = "?"
if _a1604.Ult and rawget(_a1604.Ult, "IsCharged") then
local _a2127, _a2128 = pcall(_a1604.Ult.IsCharged, _a2125)
_a2126 = _a2127 and (_a2128 and "충전됨" or "충전중") or "?"
end
_a2124[#_a2124 + 1] = _a2125 .. "(" .. _a2126 .. ")"
end
_a1569("  얼티밋 : " .. (#_a2124 > 0 and table.concat(_a2124, ", ") or "없음"))
end
_a1569("")
for _a2129, _a2130 in ipairs({ "Potion", "Fruit", "Consumable" }) do
local _a2131 = _a1605.stacks(_a2130)
local _a2132, _a2133 = 0, 0
for _a2134, _a2135 in ipairs(_a2131) do
if _a1605.itemAllowed(_a2135.id) then _a2132 += 1 else _a2133 += 1 end
end
_a1569(("  %-12s %d종 (쓸 수 있음 %d / 제외 %d)"):format(_a2130, #_a2131, _a2132, _a2133))
for _a2136, _a2137 in ipairs(_a2131) do
_a1569(("      %-20s T%-2d x%-6d %s"):format(
_a2137.id, _a2137.tier, _a2137.am, _a1605.itemAllowed(_a2137.id) and "" or "제외됨"))
if _a2136 >= 12 then _a1569("      ...") break end
end
end
_a1569("")
_a1569("  리모트 : 포션 " .. (_a1604.R_PotUse and "O" or "X")
.. " / 과일 " .. (_a1604.R_Fruit and "O" or "X")
.. " / 소모품 " .. (_a1604.R_Cons and "O" or "X")
.. " / 얼티밋 " .. (_a1604.R_Ult and "O" or "X"))
_a1660("log")
end },
{ label = "지금 1회", col = _a1618.cardHi, fn = function()
task.spawn(function() _a1574.items = true _a1605.cycleItems() _a1574.items = false _a1660("log") end)
end },
})
local _a2138, _a2139 = _a1693(_a1890, "맵 업그레이드 자동 (다이아)", nil)
_a1703(_a2139, "mapupg", function()
_a1617("mapupg", function() return _a1572.UpgInterval end, _a1605.cycleUpg, "맵업글")
end)
_a1714(_a2138, {
{ label = "주기", value = _a1572.UpgInterval, onChange = function(_a2140)
local _a2141 = tonumber(_a2140) if _a2141 and _a2141 >= 5 then _a1572.UpgInterval = _a2141 end
end },
{ label = "남길 다이아", value = _a1572.UpgReserve, onChange = function(_a2142)
local _a2143 = tonumber(_a2142) if _a2143 and _a2143 >= 0 then _a1572.UpgReserve = _a2143 end
end },
})
_a1733(_a2138, "구매 전 그 앞으로 이동",
function() return _a1572.UpgTp end,
function(_a2144) _a1572.UpgTp = _a2144 end)
_a1723(_a2138, {
{ label = "업그레이드 목록", col = _a1618.accent, fn = function()
local _a2145 = _a1605.upgList()
local _a2146 = _a1607("Diamonds")
_a1569("")
_a1569("──── 맵 업그레이드 ────")
_a1569("보유 다이아 " .. _a1570(_a2146, 0))
if #_a2145 == 0 then
_a1569("  로드된 업그레이드 기둥이 없음 (해당 존에 가야 보입니다)")
end
local _a2147, _a2148, _a2149 = 0, 0, 0
for _a2150, _a2151 in ipairs(_a2145) do
if _a2151.bought then _a2148 += 1
elseif not _a2151.zoneOwned then _a2149 += 1
else _a2147 += 1 end
end
_a1569(("  구매가능 %d / 구매완료 %d / 존 미보유 %d"):format(_a2147, _a2148, _a2149))
_a1569("")
local _a2152 = 0
for _a2153, _a2154 in ipairs(_a2145) do
if _a2154.buyable then
_a2152 += 1
_a1569(("  %-12s T%-2d %-20s %12s %-9s %s"):format(
_a2154.id, _a2154.tier, _a2154.zone, _a2154.cost and _a1570(_a2154.cost, 0) or "?",
tostring(_a2154.cur),
(_a2154.cost and _a2154.cost <= _a1607(_a2154.cur or "Diamonds") - _a1572.UpgReserve)
and "← 지금 가능" or ""))
if _a2152 >= 25 then _a1569("  ...") break end
end
end
_a1660("log")
end },
{ label = "업글 진단", col = _a1618.warn, fn = function()
task.spawn(function()
_a1569("")
_a1569("──── 맵 업그레이드 진단 ────")
_a1569("  리모트 : " .. (_a1604.R_Upg and _a1604.R_Upg:GetFullName() or "없음"))
local _a2155 = _a1605.upgList()
_a1569("  로드된 기둥 " .. #_a2155 .. "개")
local _a2156
for _a2157, _a2158 in ipairs(_a2155) do
if _a2158.buyable and _a2158.cost then _a2156 = _a2158 break end
end
if not _a2156 then
_a1569("  살 수 있는 게 없음 (전부 구매완료거나 존 미보유)")
for _a2159, _a2160 in ipairs(_a2155) do
_a1569(("   %-12s T%-2d @%-18s 구매됨=%s 존보유=%s"):format(
_a2160.id, _a2160.tier, tostring(_a2160.zone), tostring(_a2160.bought), tostring(_a2160.zoneOwned)))
if _a2159 >= 8 then _a1569("   ...") break end
end
_a1660("log") return
end
local _a2161 = _a1607(_a2156.cur or "Diamonds")
local _a2162 = _a1605.hrp()
local _a2163 = (_a2162 and _a2156.pos) and (_a2162.Position - _a2156.pos).Magnitude or nil
_a1569(("  대상 : %s T%d @%s"):format(_a2156.id, _a2156.tier, tostring(_a2156.zone)))
_a1569(("  가격 : %s %s / 보유 %s"):format(
_a1570(_a2156.cost, 0), tostring(_a2156.cur), _a1570(_a2161, 0)))
_a1569("  거리 : " .. (_a2163 and ("%.0f 스터드"):format(_a2163) or "좌표 없음"))
_a1569("")
_a1569("  ▶ 제자리에서 호출")
local _a2164, _a2165
local _a2166 = pcall(function() _a2164, _a2165 = _a1604.R_Upg:InvokeServer(_a2156.id, _a2156.zone) end)
_a1569("    호출성공 " .. tostring(_a2166) .. " / 반환1 " .. tostring(_a2164)
.. " / 반환2 " .. tostring(_a2165))
if not _a2164 and _a2156.pos then
_a1569("")
_a1569("  ▶ 기둥 앞으로 이동해서 재시도")
_a1605.glideTo(_a2156.pos)
task.wait(0.3)
local _a2167 = _a1605.hrp()
_a1569("    이동후 거리 " .. (_a2167 and ("%.0f"):format((_a2167.Position - _a2156.pos).Magnitude) or "?"))
local _a2168, _a2169
local _a2170 = pcall(function() _a2168, _a2169 = _a1604.R_Upg:InvokeServer(_a2156.id, _a2156.zone) end)
_a1569("    호출성공 " .. tostring(_a2170) .. " / 반환1 " .. tostring(_a2168)
.. " / 반환2 " .. tostring(_a2169))
_a1569("")
_a1569(_a2168 and "  → 거리 검사 있음. 이동해야 됩니다."
or "  → 이동해도 실패. 거리 문제가 아닙니다.")
else
_a1569("")
_a1569(_a2164 and "  → 원격으로 됩니다. 이동 불필요." or "  → 실패 (좌표 없음)")
end
_a1660("log")
end)
end },
{ label = "지금 1회", col = _a1618.cardHi, fn = function()
task.spawn(function() _a1574.mapupg = true _a1605.cycleUpg() _a1574.mapupg = false _a1660("log") end)
end },
})
local _a2171, _a2172 = _a1693(_a1890, "자동 리버스", nil)
_a1703(_a2172, "mreb", function()
_a1617("mreb", function() return _a1572.MainRebirthInterval end, _a1615, "리버스")
end)
_a1714(_a2171, {
{ label = "주기", value = _a1572.MainRebirthInterval, onChange = function(_a2173)
local _a2174 = tonumber(_a2173) if _a2174 and _a2174 >= 10 then _a1572.MainRebirthInterval = _a2174 end
end },
})
_a1733(_a2171, "실패 이유 로그",
function() return _a1572.MainRebirthVerbose end,
function(_a2175) _a1572.MainRebirthVerbose = _a2175 end)
_a1723(_a2171, {
{ label = "리버스 현황 보기", col = _a1618.accent, fn = function()
local _a2176 = _a1614()
_a1569("")
if not _a2176 then _a1569("[리버스] 세이브 못 읽음")
else
_a1569("──── 메인 리버스 ────")
_a1569("  현재 " .. _a2176.current .. "회 → 다음 " .. _a2176.nextN)
if type(_a2176.def) == "table" then
for _a2177, _a2178 in pairs(_a2176.def) do
if type(_a2178) ~= "table" and type(_a2178) ~= "function" then
_a1569("    " .. tostring(_a2177) .. " = " .. tostring(_a2178))
end
end
end
end
_a1660("log")
end },
{ label = "지금 1회", col = _a1618.bad, fn = function()
task.spawn(function() _a1574.mreb = true _a1615() _a1574.mreb = false _a1660("log") end)
end },
})
local _a2179 = _a1693(_a1890, "전체 제어", nil)
_a1723(_a2179, {
{ label = "메인 전부 ON", col = _a1618.good, fn = function()
local _a2180 = {
{ "farm",   function() return _a1572.FarmInterval end,       _a1608,       "파밍" },
{ "zone",   function() return _a1572.ZoneInterval end,       _a1610,       "존" },
{ "mhatch", function() return _a1572.MainHatchInterval end,  _a1613,  "부화" },
{ "quest",  function() return _a1572.QuestInterval end,      _a1605.cycle,        "퀘스트" },
{ "mapupg", function() return _a1572.UpgInterval end,        _a1605.cycleUpg,     "맵업글" },
{ "items",  function() return _a1572.ItemInterval end,       _a1605.cycleItems,   "아이템" },
{ "slots",  function() return _a1572.SlotInterval end,       _a1605.cycleSlots,   "슬롯" },
}
for _a2181, _a2182 in ipairs(_a2180) do
if not _a1574[_a2182[1]] then
_a1574[_a2182[1]] = true
_a1617(_a2182[1], _a2182[2], _a2182[3], _a2182[4])
end
end
_a1700()
_a1569("[메인] 파밍/존/부화/랭크/퀘스트/맵업글 ON  (리버스는 따로)")
end },
{ label = "메인 전부 OFF", col = _a1618.bad, fn = function()
_a1605.stopAll()
_a1700()
_a1569("[메인] 정지")
end },
})
end
_a1651.MouseButton1Click:Connect(function()
local _a2183 = table.concat(_a1568, "\n")
if #_a2183 > 900000 then _a2183 = _a2183:sub(#_a2183 - 900000) end
if type(setclipboard) == "function" then
pcall(setclipboard, _a2183)
_a1651.Text = "완료"
task.delay(1.5, function() if _a1651 then _a1651.Text = "복사" end end)
end
end)
_a1650.MouseButton1Click:Connect(function()
table.clear(_a1568)
_a1564.dirty = true
end)
local function _a2184()
_a1574.place, _a1574.merchant, _a1574.upgrade = false, false, false
_a1574.towerup, _a1574.crop, _a1574.expand, _a1574.rebirth, _a1574.hatch, _a1574.luck = false, false, false, false, false, false
_a1574.farm, _a1574.zone, _a1574.mhatch, _a1574.rank, _a1574.mreb = false, false, false, false, false
if _a1754 then _a1754:Disconnect() end
if _a1636 then _a1636:Destroy() end
_G.__PS99_GARDEN = nil
end
_a1648.MouseButton1Click:Connect(_a2184)
_G.__PS99_GARDEN = _a2184
_a1660("dash")
_a1569("Garden Defenders AutoPlay")
local _a2185, _a2186, _a2187, _a2188 = _a1577()
if _a2185 and _a2187 then
local _a2189 = _a1578(_a2187, _a2188)
_a1575.slots = #_a2189
_a1569("레인 " .. _a2188 .. " / 슬롯 " .. #_a2189)
else
_a1569("Garden 이벤트 안에서 실행해 주세요")
end
_a1575.sun = _a1583()
_a1569("Sunflowers " .. _a1570(_a1575.sun, 0))
end)(_a1)
