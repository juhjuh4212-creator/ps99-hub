return function(_a1)
local _a2, _a3, _a4, _a5, _a6, _a7 = _a1.UIS, _a1.RunService, _a1.LP, _a1.log, _a1.num, _a1.req
local _a8, _a9, _a10, _a11, _a12, _a13 = _a1.LB, _a1.NET, _a1.RM, _a1.CFG, _a1.RUN, _a1.STAT
local _a14, _a15 = _a1.ctx, _a1.placedTowers
local _a16 = {
AutoFarm = _a7("Library", "Client", "AutoFarmCmds"),
Zone     = _a7("Library", "Client", "ZoneCmds"),
Currency = _a7("Library", "Client", "CurrencyCmds"),
Bal      = _a7("Library", "Balancing"),
Egg      = _a7("Library", "Client", "EggCmds"),
Rebirth  = _a7("Library", "Client", "RebirthCmds"),
RanksU   = _a7("Library", "Util", "RanksUtil"),
DirRanks = _a7("Library", "Directory", "Ranks"),
DirEggs  = _a7("Library", "Directory", "Eggs"),
CalcEgg  = _a7("Library", "Balancing", "CalcEggPricePlayer"),
R_Farm   = _a9:FindFirstChild("AutoFarm_Enable"),
R_FarmOff = _a9:FindFirstChild("AutoFarm_Disable"),
R_Zone   = _a9:FindFirstChild("Zones_RequestPurchase"),
R_Reb    = _a9:FindFirstChild("Rebirth_Request"),
R_Rank   = _a9:FindFirstChild("Ranks_ClaimReward"),
Quest    = _a7("Library", "Client", "QuestCmds"),
EggsU    = _a7("Library", "Util", "EggsUtil"),
Map      = _a7("Library", "Client", "MapCmds"),
Inst     = _a7("Library", "Client", "InstancingCmds"),
DirZones = _a7("Library", "Directory", "Zones"),
ZonesU   = _a7("Library", "Util", "ZonesUtil"),
Upg      = _a7("Library", "Client", "UpgradeCmds"),
DirUpg   = _a7("Library", "Directory", "Upgrades"),
R_Upg    = _a9:FindFirstChild("Upgrades_Purchase"),
R_EggUn  = _a9:FindFirstChild("Eggs_RequestUnlock"),
Rand     = _a7("Library", "Client", "RandomEventCmds"),
R_Events = _a9:FindFirstChild("RandomEvents_Get"),
Ult      = _a7("Library", "Client", "UltimateCmds"),
R_Fruit  = _a9:FindFirstChild("Fruits: Consume"),
R_Cons   = _a9:FindFirstChild("Consumables_Consume"),
R_Ult    = _a9:FindFirstChild("Ultimates: Activate"),
R_Gold   = _a9:FindFirstChild("GoldMachine_Activate"),
R_Rain   = _a9:FindFirstChild("RainbowMachine_Activate"),
R_Flag   = _a9:FindFirstChild("FlexibleFlags_Consume"),
DirPets  = _a7("Library", "Directory", "Pets"),
CalcEggB = _a7("Library", "Balancing", "CalcEggPrice"),
PlayerPet = _a7("Library", "Client", "PlayerPet"),
Machine  = _a7("Library", "Client", "MachineCmds"),
Vars     = _a7("Library", "Variables"),
Hatch    = _a7("Library", "Client", "HatchingCmds"),
R_AHTog  = _a9:FindFirstChild("AutoHatch_Toggle"),
R_AHOn   = _a9:FindFirstChild("AutoHatch_Enable"),
R_AHOff  = _a9:FindFirstChild("AutoHatch_Disable"),
RankC    = _a7("Library", "Client", "RankCmds"),
CalcPetS = _a7("Library", "Balancing", "CalcPetSlotPrice"),
CalcEggS = _a7("Library", "Balancing", "CalcEggSlotPrice"),
R_PetSlot = _a9:FindFirstChild("EquipSlotsMachine_RequestPurchase"),
R_EggSlot = _a9:FindFirstChild("EggHatchSlotsMachine_RequestPurchase"),
R_Tp     = _a9:FindFirstChild("Teleports_RequestTeleport"),
R_TpI    = _a9:FindFirstChild("Teleports_RequestInstanceTeleport"),
R_PotUp  = _a9:FindFirstChild("UpgradePotionsMachine_ActivateBulk"),
R_EncUp  = _a9:FindFirstChild("UpgradeEnchantsMachine_ActivateBulk"),
R_PotUse = _a9:FindFirstChild("Potions: Consume"),
}
local _a17 = {
[1]="farm", [9]="farm", [21]="farm", [7]="farm", [99]="farm", [8]="farm",
[30]="farm", [31]="farm", [32]="farm", [37]="farm", [38]="farm", [39]="farm",
[43]="farm", [44]="farm", [66]="farm", [67]="farm", [75]="farm", [76]="farm",
[14]="farm", [15]="farm", [64]="farm", [65]="farm", [63]="farm",
[2]="hatch", [3]="hatch", [20]="hatch", [42]="hatch", [47]="hatch",
[6]="zone", [81]="zone",
[34]="potuse",
[35]="fruituse", [33]="flaguse",
}
local _a18 = {}
_a18.ctl, _a18.move, _a18.egg = {}, {}, {}
_a18.screen, _a18.quest, _a18.ev = {}, {}, {}
_a18.item, _a18.mach, _a18.auto = {}, {}, {}
_a18.quest.IGNORE = {
[4]  = "골드 펫 만들기 (합성 필요)",
[5]  = "레인보우 펫 만들기 (합성 필요)",
[40] = "best egg 골드 펫 (뽑기+합성 필요)",
[41] = "best egg 레인보우 펫 (뽑기+2단 합성 필요)",
[12] = "포션 업글 (업글 머신으로 이동 필요)",
[13] = "인챈트 업글 (업글 머신으로 이동 필요)",
}
_a18.ctl.abort = false
function _a18.ctl.stopped() return _a18.ctl.abort == true end
function _a18.ctl.stopAll()
_a18.ctl.abort = true
for _a19 in pairs(_a12) do
if _a19 ~= "petspd" and _a19 ~= "rewatch" then _a12[_a19] = false end
end
_a18.ctl.lockGoal = nil
_a18.ctl.moving = nil
_a18.ctl.now.step = "정지"
_a18.ctl.setAct("정지됨")
end
_a18.ctl.now = { step = "-", act = "-", detail = "", goal = "-", prog = "" }
function _a18.ctl.setAct(_a20, _a21)
_a18.ctl.now.act = _a20 or "-"
_a18.ctl.now.detail = _a21 and tostring(_a21) or ""
_a18.ctl.now.at = os.clock()
end
function _a18.ctl.setGoal(_a22, _a23)
_a18.ctl.now.goal = _a22 and tostring(_a22) or "-"
_a18.ctl.now.prog = _a23 and tostring(_a23) or ""
end
function _a18.egg.eggStands()
local _a24 = os.clock()
if _a18.egg._standsAt and (_a24 - _a18.egg._standsAt) < 2 and _a18.egg._stands then
local _a25 = _a4 and _a4.Character
local _a26 = _a25 and _a25:FindFirstChild("HumanoidRootPart")
if _a26 then
for _a27, _a28 in ipairs(_a18.egg._stands) do
_a28.dist = (_a28.pos - _a26.Position).Magnitude
end
table.sort(_a18.egg._stands, function(_a29, _a30) return _a29.dist < _a30.dist end)
end
return _a18.egg._stands
end
local _a31 = {}
local _a32 = workspace:FindFirstChild("__THINGS")
local _a33 = _a32 and _a32:FindFirstChild("Eggs")
if not _a33 then return _a31 end
local _a34 = _a4 and _a4.Character
local _a35 = _a34 and _a34:FindFirstChild("HumanoidRootPart")
for _a36, _a37 in ipairs(_a33:GetDescendants()) do
if _a37:IsA("Model") and _a37.PrimaryPart then
local _a38 = tonumber(tostring(_a37.Name):match("%d+"))
if _a38 then
local _a39
if _a16.EggsU and rawget(_a16.EggsU, "GetByNumber") then
local _a40, _a41 = pcall(_a16.EggsU.GetByNumber, _a38)
if _a40 then _a39 = _a41 end
end
local _a42 = _a39 and (rawget(_a39, "_id") or rawget(_a39, "name"))
if _a42 then
_a31[#_a31 + 1] = {
id = _a42, def = _a39, num = _a38,
pos = _a37.PrimaryPart.Position,
dist = _a35 and (_a37.PrimaryPart.Position - _a35.Position).Magnitude or 9e9,
unlocked = _a37:GetAttribute("Unlocked") and true or false,
}
end
end
end
end
table.sort(_a31, function(_a43, _a44) return _a43.dist < _a44.dist end)
_a18.egg._stands, _a18.egg._standsAt = _a31, os.clock()
return _a31
end
local function _a45()
local _a46 = _a8.Save
if not _a46 then return nil end
local _a47, _a48 = pcall(_a46.Get)
if _a47 and type(_a48) == "table" then return _a48 end
if _a4 then
_a47, _a48 = pcall(_a46.Get, _a4)
if _a47 and type(_a48) == "table" then return _a48 end
end
if rawget(_a46, "GetSaves") then
local _a49, _a50 = pcall(_a46.GetSaves)
if _a49 and type(_a50) == "table" then
local _a51, _a52 = nil, 0
for _a53, _a54 in pairs(_a50) do _a52 += 1 _a51 = _a54 end
if _a52 == 1 and type(_a51) == "table" then
if not _a18.ctl.saveAlt then
_a18.ctl.saveAlt = true
_a5("[세이브] LocalPlayer 키가 안 맞아 유일한 항목으로 대체했습니다")
end
return _a51
end
end
end
return nil
end
local function _a55(_a56, _a57)
if _a16.Currency and rawget(_a16.Currency, "CanAfford") then
local _a58, _a59 = pcall(_a16.Currency.CanAfford, _a56, _a57)
if _a58 then return _a59 and true or false end
end
return false
end
local function _a60(_a61)
if _a16.Currency and rawget(_a16.Currency, "Get") then
local _a62, _a63 = pcall(_a16.Currency.Get, _a61)
if _a62 and tonumber(_a63) then return tonumber(_a63) end
end
return 0
end
local function _a64()
if _a16.AutoFarm and rawget(_a16.AutoFarm, "IsEnabled") then
local _a65, _a66 = pcall(_a16.AutoFarm.IsEnabled)
if _a65 then return _a66 and true or false end
end
return false
end
local function _a67()
if _a16.AutoFarm and rawget(_a16.AutoFarm, "GetTargetParentId") then
local _a68, _a69 = pcall(_a16.AutoFarm.GetTargetParentId)
if _a68 then return _a69 end
end
return nil
end
local function _a70()
if not _a16.R_Farm then _a5("[파밍] AutoFarm_Enable 리모트 없음") return end
local _a71 = _a64()
_a18.auto.farmZone, _a18.auto.hereZone = _a67(), _a18.move.curZone()
if _a71 then
local _a72, _a73 = _a67(), _a18.move.curZone()
if _a72 and _a73 and _a72 ~= _a73 then
_a5(("[파밍] 대상이 %s 인데 지금은 %s — 다시 켬"):format(
tostring(_a72), tostring(_a73)))
if _a16.R_FarmOff then pcall(function() _a16.R_FarmOff:InvokeServer() end) end
if _a16.AutoFarm and rawget(_a16.AutoFarm, "ForceDisable") then
pcall(_a16.AutoFarm.ForceDisable)
end
task.wait(0.3)
_a71 = false
end
end
if _a71 then return end
local _a74, _a75
pcall(function() _a74, _a75 = _a16.R_Farm:InvokeServer() end)
if _a74 then
_a13.farm += 1
_a18.auto.farmSaid = nil
_a5("[파밍] 자동 파밍 ON  (대상 " .. tostring(_a67() or _a18.move.curZone()) .. ")")
elseif _a75 and _a18.auto.farmSaid ~= tostring(_a75) then
_a18.auto.farmSaid = tostring(_a75)
_a5("[파밍] 실패: " .. tostring(_a75))
end
end
local function _a76()
if not (_a16.Zone and rawget(_a16.Zone, "GetNextZone")) then return nil end
local _a77, _a78, _a79 = pcall(_a16.Zone.GetNextZone)
if not _a77 then return nil end
return _a79 or _a78
end
local function _a80(_a81)
if not (_a16.Bal and rawget(_a16.Bal, "CalcGatePrice")) then return nil end
local _a82, _a83 = pcall(_a16.Bal.CalcGatePrice, _a81)
return (_a82 and tonumber(_a83)) or nil
end
local function _a84()
local _a85 = _a76()
if not _a85 then return nil end
local _a86 = _a80(_a85)
local _a87 = rawget(_a85, "Currency")
return {
zone = _a85, id = rawget(_a85, "_id"), price = _a86, currency = _a87,
have = _a87 and _a60(_a87) or 0,
ok = (_a86 and _a87) and _a55(_a87, _a86) or false,
}
end
local function _a88()
if not _a16.R_Zone then _a5("[존] Zones_RequestPurchase 리모트 없음") return end
local _a89 = 0
while _a12.zone and not _a18.ctl.stopped() and _a89 < 20 do
_a89 += 1
local _a90 = _a84()
if not _a90 then
_a18.auto.zoneNote = "다음 존을 못 구함 (GetNextZone 실패 / 존 퀘스트 미완료?)"
if _a18.auto.zoneSaid ~= _a18.auto.zoneNote then
_a18.auto.zoneSaid = _a18.auto.zoneNote
_a5("[존] " .. _a18.auto.zoneNote)
end
return
end
if not _a90.ok then
_a18.auto.zoneNote = ("%s  %s %s / 보유 %s — 부족"):format(
tostring(_a90.id), _a6(_a90.price or 0, 0), tostring(_a90.currency), _a6(_a90.have, 0))
if _a18.auto.zoneSaid ~= _a18.auto.zoneNote then
_a18.auto.zoneSaid = _a18.auto.zoneNote
_a5("[존] " .. _a18.auto.zoneNote)
end
return
end
_a18.auto.zoneSaid = nil
local _a91, _a92
pcall(function() _a91, _a92 = _a16.R_Zone:InvokeServer(_a90.id) end)
task.wait(0.5)
if _a91 then
_a13.zone += 1
_a5(("  ▶ 존 해금  %s   (%s %s)"):format(
tostring(_a90.id), _a6(_a90.price or 0, 0), tostring(_a90.currency)))
else
if _a92 then _a5("[존] 실패: " .. tostring(_a92)) end
return
end
task.wait(_a11.ActionGap)
end
end
local function _a93()
local _a94 = _a18.egg.eggStands()
local _a95 = (_a11.MainEggId and _a11.MainEggId ~= "") and _a11.MainEggId or nil
if _a95 then
for _a96, _a97 in ipairs(_a94) do
if _a97.id == _a95 then return _a97.id, _a97.def, _a97.dist end
end
local _a98 = _a16.DirEggs and rawget(_a16.DirEggs, _a95)
if _a98 then return _a95, _a98, nil, (_a94[1] and _a94[1].dist) end
return nil
end
if not _a16.DirEggs then return nil end
local _a99, _a100, _a101 = nil, nil, -1
for _a102, _a103 in pairs(_a16.DirEggs) do
if type(_a103) == "table" and not rawget(_a103, "isCustomEgg") then
local _a104 = tonumber(rawget(_a103, "eggNumber"))
if _a104 and _a104 > _a101 and _a18.egg.eggUnlocked(_a104) then
_a99, _a100, _a101 = _a102, _a103, _a104
end
end
end
if not _a99 then return nil end
local _a105, _a106
for _a107, _a108 in ipairs(_a94) do
if not _a106 then _a106 = _a108.dist end
if _a108.id == _a99 then _a105 = _a108.dist break end
end
if _a105 and _a105 <= _a11.EggRange then
return _a99, _a100, _a105
end
return _a99, _a100, nil, _a105 or _a106
end
local function _a109(_a110)
if type(_a16.CalcEgg) == "function" then
local _a111, _a112 = pcall(_a16.CalcEgg, _a110)
if _a111 and tonumber(_a112) then return tonumber(_a112) end
if not _a111 and not _a18.egg.priceWarned then
_a18.egg.priceWarned = true
_a5("[부화] CalcEggPricePlayer 막힘 → 기본가로 계산: " .. tostring(_a112))
end
end
if type(_a16.CalcEggB) == "function" then
local _a113, _a114 = pcall(_a16.CalcEggB, _a110)
if _a113 and tonumber(_a114) then return tonumber(_a114) end
end
for _a115, _a116 in ipairs({ "price", "Price", "cost", "Cost" }) do
local _a117 = tonumber(rawget(_a110, _a116))
if _a117 then return _a117 end
end
return nil
end
local function _a118()
local _a119, _a120, _a121, _a122 = _a93()
if not _a119 then return nil end
local _a123 = _a109(_a120)
local _a124 = rawget(_a120, "currency") or "Coins"
local _a125 = 1
if _a16.Egg and rawget(_a16.Egg, "GetMaxHatch") then
local _a126, _a127 = pcall(_a16.Egg.GetMaxHatch, _a120)
if _a126 and tonumber(_a127) then _a125 = math.max(1, math.floor(tonumber(_a127))) end
end
local _a128 = _a60(_a124)
return {
id = _a119, def = _a120, price = _a123, currency = _a124, maxN = _a125, have = _a128,
dist = _a121, nearest = _a122, inRange = _a121 ~= nil,
canBuy = (_a123 and _a123 > 0) and math.floor(math.max(0, _a128 - _a11.MainHatchReserve) / _a123) or 0,
}
end
local function _a129()
if not _a10.R_EGG then _a5("[부화] Eggs_RequestPurchase 리모트 없음") return end
if _a11.AutoUnlockEgg then
local _a130, _a131, _a132 = _a18.egg.lockedEggs()
if _a131 > _a132 then
local _a133 = _a18.egg.unlockEggs()
if _a133 > 0 then _a5(("[부화] 알 %d개 해금 (해금가능 #%d)"):format(_a133, _a131)) end
end
end
local _a134 = _a118()
if not _a134 then _a5("[부화] 알을 못 찾음") return end
if not _a134.inRange then
if _a11.HatchAutoTp then
local _a135, _a136 = _a18.egg.tpEgg(_a134.id)
if not _a135 then
if not _a18.egg.hatchWarned then
_a18.egg.hatchWarned = true
_a5("[부화] 알로 이동 실패: " .. tostring(_a136))
end
return
end
_a5("[부화] " .. _a134.id .. " 로 이동")
_a134 = _a118()
if not (_a134 and _a134.inRange) then return end
else
if not _a18.egg.hatchWarned then
_a18.egg.hatchWarned = true
_a5(("[부화] 알 근처로 가주세요 (가장 가까운 알까지 %s스터드, 인식 %d)"):format(
_a134.nearest and ("%.0f"):format(_a134.nearest) or "?", _a11.EggRange))
end
return
end
end
_a18.egg.hatchWarned = false
local _a137 = math.min(_a134.maxN, _a11.MainHatchMax)
local _a138 = _a134.price and math.min(_a134.canBuy, _a137) or _a137
if _a138 < 1 then return end
local _a139, _a140 = 0, 0
local function _a141()
return tonumber(_a16.Vars and rawget(_a16.Vars, "OpeningEgg")) or 0
end
local _a142 = _a16.Vars and rawget(_a16.Vars, "OpeningEgg") ~= nil
local _a143 = 2.5
if _a16.Egg and rawget(_a16.Egg, "ComputeDebounce") then
local _a144, _a145 = pcall(_a16.Egg.ComputeDebounce)
if _a144 and tonumber(_a145) then _a143 = tonumber(_a145) end
end
_a18.egg.autoHatchOn(_a134.id, _a138)
local _a146 = false
local _a147 = _a18.ctl.lockGoal and _a18.ctl.lockGoal.q
local _a148 = _a147 and (_a147.how == "hatch" or _a147.where == "bestegg") or false
local _a149 = _a148 and math.huge
or (os.clock() + math.max(3, _a11.HatchBudget or 25))
local _a150 = _a148 and 100000 or 400
while _a12.mhatch and not _a18.ctl.stopped() and _a138 >= 1 and _a140 < _a150 and os.clock() < _a149 do
if _a148 and (_a140 % 5 == 0) then
local _a151 = _a18.quest.findQuest(_a147.uid)
if not _a151 or _a151.progress >= _a151.amount then break end
end
_a140 += 1
if _a142 then
local _a152 = os.clock()
local _a153 = _a11.HatchClickAfter
local _a154 = false
while _a141() > 0 and _a12.mhatch and not _a18.ctl.stopped()
and (os.clock() - _a152) < 20 do
if _a11.HatchClick and (os.clock() - _a152) > _a153 then
_a18.egg.clickOnce()
_a153 += 0.3
if (os.clock() - _a152) > 3 and not _a154 then
_a154 = true
_a18.egg._ahEgg = nil
_a18.egg.autoHatchOn(_a134.id, _a138)
_a5("[부화] 화면이 안 넘어가서 오토해치 재설정")
end
end
task.wait(0.03)
end
if _a141() > 0 then
if _a18.egg.hatchStuck ~= _a134.id then
_a18.egg.hatchStuck = _a134.id
_a5("[부화] " .. tostring(_a134.id) .. " 까는 화면에서 멈춤 — 이번 회차 중단")
end
_a146 = true
break
end
_a18.egg.hatchStuck = nil
else
local _a155 = os.clock() - (_a18.egg.lastHatch or 0)
if _a155 < _a143 then task.wait(_a143 - _a155) end
end
_a18.egg.lastHatch = os.clock()
_a18.ctl.setAct("알 까는 중", ("%s x%d  (총 %d)"):format(_a134.id, _a138, _a139))
local _a156, _a157
local _a158 = pcall(function() _a156, _a157 = _a10.R_EGG:InvokeServer(_a134.id, _a138) end)
if _a156 then
_a139 += _a138
_a13.mhatch += _a138
_a18.egg.hatchErr = nil
if _a134.price then
local _a159 = _a60(_a134.currency)
local _a160 = math.floor(math.max(0, _a159 - _a11.MainHatchReserve) / _a134.price)
if _a160 < 1 then break end
_a138 = math.min(_a160, _a137)
end
else
local _a161 = _a158 and tostring(_a157) or "호출 자체 실패"
if _a161:find("quickly") or _a161:find("fast") then
task.wait(0.25)
elseif _a161:find("far away") then
if _a11.HatchAutoTp then _a18.egg.tpEgg(_a134.id) task.wait(0.2)
else _a5("[부화] 알에서 너무 멈") break end
elseif _a138 > 1 then
_a138 = math.floor(_a138 / 2)
else
if _a18.egg.hatchErr ~= _a161 then
_a18.egg.hatchErr = _a161
_a5("[부화] 실패: " .. _a161 .. "   (알 " .. tostring(_a134.id)
.. " / 개수 " .. _a138 .. " / 거리 "
.. (_a134.dist and ("%.0f"):format(_a134.dist) or "?") .. ")")
end
break
end
end
end
if _a142 and _a139 > 0 and not _a146 then
local _a162 = os.clock()
while _a141() == 0 and not _a18.ctl.stopped() and (os.clock() - _a162) < 2.5 do
task.wait(0.05)
end
local _a163 = os.clock()
local _a164 = _a11.HatchClickAfter
while _a141() > 0 and not _a18.ctl.stopped() and (os.clock() - _a163) < 20 do
_a18.ctl.setAct("알 마무리", ("%s  마지막 %d개 까는 중"):format(_a134.id, _a138))
if _a11.HatchClick and (os.clock() - _a163) > _a164 then
_a18.egg.clickOnce()
_a164 += 0.3
if (os.clock() - _a163) > 3 and not _a18.egg._finRe then
_a18.egg._finRe = true
_a18.egg._ahEgg = nil
_a18.egg.autoHatchOn(_a134.id, _a138)
end
end
task.wait(0.03)
end
_a18.egg._finRe = nil
if _a141() > 0 then
_a5("[부화] 마지막 알이 20초 넘게 안 끝남 — 그대로 두고 진행합니다")
end
end
_a18.egg.autoHatchOff()
if _a139 > 0 then
_a18.egg.hatchErr = nil
_a5(("[부화] %s × %d%s  (개당 %s %s)"):format(
_a134.id, _a139, _a148 and " (목표까지)" or "",
_a134.price and _a6(_a134.price, 0) or "?", tostring(_a134.currency)))
end
end
local function _a165()
local _a166 = _a45()
if not _a166 then return nil end
local _a167 = tonumber(rawget(_a166, "Rank")) or 1
local _a168 = tonumber(rawget(_a166, "RankStars")) or 0
local _a169 = rawget(_a166, "RedeemedRankRewards") or {}
local _a170
if _a16.RanksU and rawget(_a16.RanksU, "RankIDFromNumber") then
local _a171, _a172 = pcall(_a16.RanksU.RankIDFromNumber, _a167)
if _a171 then _a170 = _a172 end
end
local _a173 = _a170 and _a16.DirRanks and rawget(_a16.DirRanks, _a170)
if type(_a173) ~= "table" then
return { rankNum = _a167, stars = _a168, rankId = _a170, rewards = {} }
end
local _a174, _a175 = {}, 0
for _a176, _a177 in ipairs(rawget(_a173, "Rewards") or {}) do
_a175 += (tonumber(rawget(_a177, "StarsRequired")) or 0)
local _a178 = _a175 <= _a168
local _a179 = _a169[tostring(_a176)] ~= nil
_a174[#_a174 + 1] = {
index = _a176, need = _a175, earned = _a178, redeemed = _a179,
claimable = _a178 and not _a179,
}
end
return { rankNum = _a167, stars = _a168, rankId = _a170, rewards = _a174 }
end
local function _a180()
if not _a16.R_Rank then _a5("[랭크] Ranks_ClaimReward 리모트 없음") return end
local _a181 = _a165()
if not _a181 then return end
local _a182 = 0
for _a183, _a184 in ipairs(_a181.rewards) do
if not _a12.rank then break end
if _a184.claimable then
pcall(function() _a16.R_Rank:FireServer(_a184.index) end)
_a182 += 1
_a13.rank += 1
task.wait(0.1)
end
end
if _a182 > 0 then
_a5(("[랭크] 보상 %d개 수령  (Rank %d, ★%d)"):format(_a182, _a181.rankNum, _a181.stars))
end
end
function _a18.move.hrp()
local _a185 = _a4 and _a4.Character
return _a185 and _a185:FindFirstChild("HumanoidRootPart"),
_a185 and _a185:FindFirstChildOfClass("Humanoid")
end
function _a18.egg.autoHatchOn(_a186, _a187)
if not _a11.UseAutoHatch then return end
if _a18.egg._ahEgg == _a186 and _a18.egg._ahAt and (os.clock() - _a18.egg._ahAt) < 15 then return end
_a18.egg._ahEgg, _a18.egg._ahAt = _a186, os.clock()
local _a188 = _a16.DirEggs and rawget(_a16.DirEggs, _a186)
if _a16.Hatch and _a188 and rawget(_a16.Hatch, "SetupEgg") then
local _a189, _a190 = pcall(_a16.Hatch.SetupEgg, _a188, _a187 or 1)
if not _a189 and not _a18.egg._ahWarn then
_a18.egg._ahWarn = true
_a5("[부화] SetupEgg 실패: " .. tostring(_a190) .. "  → 클릭 대체 사용")
end
end
if _a16.R_AHTog then pcall(function() _a16.R_AHTog:FireServer(true) end) end
if _a16.R_AHOn then pcall(function() _a16.R_AHOn:FireServer(_a186, _a187 or 1) end) end
if _a16.Hatch and rawget(_a16.Hatch, "IsHatching") then
local _a191, _a192 = pcall(_a16.Hatch.IsHatching)
_a18.egg._ahLive = _a191 and _a192 and true or false
end
end
function _a18.egg.autoHatchOff()
_a18.egg._ahEgg, _a18.egg._ahAt, _a18.egg._ahLive = nil, nil, nil
if _a16.Hatch and rawget(_a16.Hatch, "StopHatching") then pcall(_a16.Hatch.StopHatching) end
if _a16.R_AHOff then pcall(function() _a16.R_AHOff:FireServer() end) end
end
function _a18.egg.clickOnce()
if _a18.ctl.moving then return false end
local _a193 = _a18.screen.signal("egg")
if not _a193 then _a193 = _a18.screen.pressInGame({ "Egg Opening" }) end
if not _a193 and not _a18.egg._eggSigWarn then
_a18.egg._eggSigWarn = true
_a5("[부화] 게임 내 방법이 다 막힘 — SetupEgg 에만 의존합니다")
end
return _a193
end
function _a18.egg.watchStuck()
local _a194 = _a16.Vars
if not _a194 then return end
local _a195 = tonumber(rawget(_a194, "OpeningEgg")) or 0
if _a195 <= 0 then
_a18.egg.stuckSince, _a18.egg.stuckSaid = nil, nil
return
end
_a18.egg.stuckSince = _a18.egg.stuckSince or os.clock()
local _a196 = os.clock() - _a18.egg.stuckSince
if _a196 < 3 then return end
if not _a11.HatchClick then return end
if _a18.ctl.moving then _a18.screen.signal("egg") else _a18.egg.clickOnce() end
if _a196 > 6 and not _a18.egg.stuckSaid then
_a18.egg.stuckSaid = true
_a5("[부화] 까는 화면에서 멈춰 있어 계속 넘기는 중")
end
end
function _a18.item.applyPetSpeed()
local _a197 = _a16.PlayerPet
if not (_a197 and rawget(_a197, "GetByPlayer")) then return 0, "PlayerPet 없음" end
local _a198, _a199 = pcall(_a197.GetByPlayer, _a4)
if not (_a198 and type(_a199) == "table") then return 0, "펫 목록 못 읽음" end
local _a200 = math.max(1, tonumber(_a11.PetSpeedMult) or 50)
local _a201 = math.max(0.05, tonumber(_a11.PetSpeedBase) or 4)
local _a202 = 0
for _a203, _a204 in pairs(_a199) do
if type(_a204) == "table" then
local _a205 = rawget(_a204, "cpet")
if _a205 then
_a204.speedMult = _a200
pcall(function() _a205:Broadcast("petSpeedMult", _a200) end)
pcall(function() _a205:Broadcast("petSpeed", _a201) end)
_a202 += 1
end
end
end
return _a202
end
_a18.screen.SIGNAL = {
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
_a18.screen.BLOCKERS = {
{ "Rebirth",     "리버스",   "reward" },
{ "RankUp",      "랭크업",   "reward" },
{ "MasteryPerk", "마스터리", "mastery" },
{ "Card",        "카드",     "card" },
}
function _a18.screen.findSignalFns(_a206)
local _a207 = _a18.screen.SIGNAL[_a206]
if not _a207 then return {} end
_a18.screen._sig = _a18.screen._sig or {}
local _a208 = _a18.screen._sig[_a206]
if _a208 and (os.clock() - _a208.at) < (#_a208.fns > 0 and 20 or 3) then return _a208.fns end
local _a209 = {}
_a18.screen._sig[_a206] = { at = os.clock(), fns = _a209 }
if type(getgc) ~= "function" or type(debug) ~= "table"
or type(debug.info) ~= "function" or type(debug.getupvalue) ~= "function" then
return _a209
end
local _a210 = {}
for _a211, _a212 in ipairs({ true, false }) do
local _a213, _a214 = pcall(getgc, _a212)
if _a213 and type(_a214) == "table" then
for _a215, _a216 in ipairs(_a214) do _a210[#_a210 + 1] = _a216 end
end
end
if #_a210 == 0 then return _a209 end
for _a217, _a218 in ipairs(_a210) do
if type(_a218) == "function" then
local _a219, _a220 = pcall(debug.info, _a218, "s")
if _a219 and type(_a220) == "string" then
local _a221 = false
for _a222, _a223 in ipairs(_a207.pats) do
if _a220:find(_a223, 1, true) then _a221 = true break end
end
if _a221 then
local _a224, _a225 = pcall(debug.info, _a218, "a")
if _a224 then
local _a226, _a227 = {}, 0
for _a228 = 1, 16 do
local _a229, _a230 = pcall(debug.getupvalue, _a218, _a228)
if not _a229 then break end
_a227 = _a228
_a226[_a228] = type(_a230)
end
local _a231 = table.concat(_a226, ",")
local _a232 = false
for _a233, _a234 in ipairs(_a207.sigs or {}) do
if _a225 == _a234.np and _a231 == _a234.t then
_a209[#_a209 + 1] = { fn = _a218, sig = _a231, n = _a227, np = _a225,
src = _a220, set = _a234.set }
_a232 = true
break
end
end
if not _a232 and _a207.sigs then
local _a235 = {}
for _a236, _a237 in ipairs(_a226) do
if _a237 == "boolean" then _a235[#_a235 + 1] = _a236 end
end
if #_a235 > 0 then
_a209[#_a209 + 1] = { fn = _a218, idx = _a235, sig = _a231, n = _a227,
np = _a225, src = _a220, loose = true }
end
end
if not _a232 and not _a207.sigs and _a225 == 0 then
local _a238 = 0
for _a239, _a240 in ipairs(_a226) do if _a240 == "boolean" then _a238 += 1 end end
if _a238 >= (_a207.minBools or 1) then
local _a241 = {}
for _a242, _a243 in ipairs(_a226) do
if _a243 == "boolean" then _a241[#_a241 + 1] = _a242 end
end
_a209[#_a209 + 1] = { fn = _a218, idx = _a241, sig = _a231, n = _a227, src = _a220 }
end
end
end
end
end
end
end
return _a209
end
function _a18.screen.signal(_a244)
if type(debug) ~= "table" or type(debug.setupvalue) ~= "function" then return false, 0 end
local _a245 = _a18.screen.findSignalFns(_a244)
local _a246 = 0
for _a247, _a248 in ipairs(_a245) do
if _a248.set then
for _a249, _a250 in ipairs(_a248.set) do
if pcall(debug.setupvalue, _a248.fn, _a250[1], _a250[2]) then _a246 += 1 end
end
elseif not _a248.loose then
for _a251, _a252 in ipairs(_a248.idx or {}) do
if pcall(debug.setupvalue, _a248.fn, _a252, true) then _a246 += 1 end
end
end
end
if _a246 == 0 then
for _a253, _a254 in ipairs(_a245) do
if _a254.loose then
for _a255, _a256 in ipairs(_a254.idx or {}) do
if pcall(debug.setupvalue, _a254.fn, _a256, true) then _a246 += 1 end
end
end
end
end
return _a246 > 0, _a246
end
function _a18.screen.pressInGame(_a257)
local _a258, _a259 = pcall(function() return game:GetService("UserInputService") end)
if not (_a258 and _a259) then return false end
local _a260 = {
UserInputType  = Enum.UserInputType.MouseButton1,
UserInputState = Enum.UserInputState.Begin,
KeyCode        = Enum.KeyCode.Unknown,
Position       = Vector3.new(),
Delta          = Vector3.new(),
}
local _a261 = 0
if type(getconnections) == "function" then
local _a262, _a263 = pcall(getconnections, _a259.InputBegan)
if _a262 and type(_a263) == "table" then
for _a264, _a265 in ipairs(_a263) do
local _a266 = ""
local _a267 = _a265.Function
if _a267 and type(debug) == "table" and type(debug.info) == "function" then
local _a268, _a269 = pcall(debug.info, _a267, "s")
if _a268 and _a269 then _a266 = tostring(_a269) end
end
local _a270 = false
for _a271, _a272 in ipairs(_a257) do
if _a266 ~= "" and _a266:find(_a272, 1, true) then _a270 = true break end
end
if _a270 then
if _a267 and pcall(_a267, _a260, false) then _a261 += 1
elseif _a265.Fire and pcall(function() _a265:Fire(_a260, false) end) then _a261 += 1
elseif _a265.Defer and pcall(function() _a265:Defer(_a260, false) end) then _a261 += 1 end
end
end
end
end
if _a261 == 0 and type(firesignal) == "function" then
if pcall(firesignal, _a259.InputBegan, _a260, false) then _a261 += 1 end
end
return _a261 > 0
end
function _a18.screen.realClick(_a273)
if not _a11.ScreenRealClick then return false end
local _a274 = workspace.CurrentCamera
local _a275 = (_a274 and _a274.ViewportSize) or Vector2.new(1280, 720)
local _a276, _a277 = _a275.X * 0.5, _a275.Y * 0.45
local _a278 = {}
local function _a279(_a280, _a281)
local _a282 = pcall(_a281)
_a278[#_a278 + 1] = _a280 .. (_a282 and "=OK" or "=X")
return _a282
end
local _a283 = false
if not _a283 and type(mouse1click) == "function" then
_a283 = _a279("mouse1click", function() mouse1click() end)
end
if not _a283 and type(mouse1press) == "function" then
_a283 = _a279("mouse1press", function()
mouse1press() task.wait(0.05)
if type(mouse1release) == "function" then mouse1release() end
end)
end
if not _a283 then
_a283 = _a279("VirtualUser", function()
local _a284 = game:GetService("VirtualUser")
_a284:Button1Down(Vector2.new(_a276, _a277), _a274 and _a274.CFrame or CFrame.new())
task.wait(0.05)
_a284:Button1Up(Vector2.new(_a276, _a277), _a274 and _a274.CFrame or CFrame.new())
end)
end
if not _a283 then
_a283 = _a279("VirtualInputManager", function()
local _a285 = game:GetService("VirtualInputManager")
_a285:SendMouseButtonEvent(_a276, _a277, 0, true, game, 1)
task.wait(0.05)
_a285:SendMouseButtonEvent(_a276, _a277, 0, false, game, 1)
end)
end
if _a273 then _a5("    " .. table.concat(_a278, " / ")) end
return _a283
end
function _a18.screen.rewardScreenUp()
if not _a4 then
if not _a18.screen.noLP then
_a18.screen.noLP = true
_a5("[화면] LocalPlayer 를 못 잡았습니다 — 화면 감시를 건너뜁니다")
end
return false
end
local _a286 = _a4:FindFirstChildOfClass("PlayerGui")
if _a286 then
for _a287, _a288 in ipairs(_a18.screen.BLOCKERS) do
local _a289 = _a286:FindFirstChild(_a288[1])
if _a289 and _a289:IsA("ScreenGui") and _a289.Enabled then return true, _a288[2], _a288[3] end
end
end
local _a290 = _a16.Vars
if _a290 then
if rawget(_a290, "IsRebirthing") then return true, "리버스", "reward" end
if rawget(_a290, "IsRankingUp") then return true, "랭크업", "reward" end
end
return false
end
function _a18.screen.dismissRewardScreens(_a291)
if _a18.screen.dismissBusy then return end
_a18.screen.dismissBusy = true
local _a292, _a293 = pcall(_a18.screen.dismissInner, _a291)
_a18.screen.dismissBusy = false
if not _a292 then _a5("[화면] 오류: " .. tostring(_a293)) end
end
function _a18.screen.dismissInner(_a294)
local _a295 = _a16.Vars
if not _a295 then return end
local _a296 = os.clock()
local _a297, _a298 = false, nil
local _a299 = 0
local _a300 = math.max(3, _a11.ScreenTryMax or 8)
while os.clock() - _a296 < (_a294 or 120) do
local _a301, _a302, _a303 = _a18.screen.rewardScreenUp()
if not _a301 then break end
_a297, _a298 = true, _a302
_a299 += 1
_a18.ctl.setAct("보상 화면 넘기는 중",
("%s (%d회%s)"):format(tostring(_a302), _a299,
_a299 <= 6 and " · 첫 화면 대기" or ""))
local _a304 = _a18.screen.SIGNAL[_a303 or "reward"]
local _a305 = (_a304 and _a304.pats) or { "Rebirth", "Rank Up" }
local _a306 = _a18.screen.signal(_a303 or "reward")
if not _a306 then
for _a307 in pairs(_a18.screen.SIGNAL) do
if _a18.screen.signal(_a307) then _a306 = true end
end
end
local _a308 = false
if not _a306 or _a299 >= 2 then
_a308 = _a18.screen.pressInGame(_a305)
end
if _a299 >= 3 then
if _a18.screen.realClick() then
_a308 = true
if not _a18.screen._realSaid then
_a18.screen._realSaid = true
_a5("[화면] 실제 클릭까지 같이 씁니다 (Roblox 창이 켜져 있어야 먹습니다)")
end
end
end
if (_a306 or _a308) and not _a18.screen._sigSaid then
_a18.screen._sigSaid = true
_a5("[화면] " .. (_a306 and "upvalue 신호" or "게임 내 입력 발동") .. " 로 넘깁니다")
end
if _a299 >= _a300 and (os.clock() - _a296) >= 12 then
if _a18.screen.giveUpSaid ~= _a302 then
_a18.screen.giveUpSaid = _a302
_a5(("[화면] %s 화면을 못 넘김 — 그냥 두고 자동화는 계속합니다"):format(tostring(_a302)))
_a5("        (이 화면은 UI만 가릴 뿐 리모트 호출은 막지 않습니다)")
end
_a18.screen.screenGaveUp = os.clock()
return
end
task.wait(0.8)
end
if _a297 then
if not _a18.screen.rewardScreenUp() then
_a18.screen.lastBlocker = nil
_a18.screen.screenGaveUp = nil
_a5(("[화면] %s 넘김 완료 (%d회)"):format(tostring(_a298), _a299))
end
end
end
function _a18.egg.eggUnlocked(_a309)
_a309 = tonumber(_a309)
if not _a309 then return false end
local _a310 = _a45()
local _a311 = _a310 and rawget(_a310, "UnlockedEggs")
if type(_a311) == "table" then
for _a312, _a313 in pairs(_a311) do
if tonumber(_a313) == _a309 then return true end
end
return false
end
return _a309 <= 1
end
function _a18.egg.lockedEggs()
local _a314 = {}
if not _a16.DirEggs then return _a314, 0, 0 end
local _a315 = _a45()
local _a316 = tonumber(_a315 and rawget(_a315, "MaximumAvailableEgg")) or 1
local _a317 = 0
local _a318 = _a315 and rawget(_a315, "UnlockedEggs")
if type(_a318) == "table" then
for _a319, _a320 in pairs(_a318) do
local _a321 = tonumber(_a320)
if _a321 and _a321 > _a317 then _a317 = _a321 end
end
end
for _a322, _a323 in pairs(_a16.DirEggs) do
if type(_a323) == "table" and not rawget(_a323, "isCustomEgg") then
local _a324 = tonumber(rawget(_a323, "eggNumber"))
if _a324 and _a324 <= _a316 and not _a18.egg.eggUnlocked(_a324) then
_a314[#_a314 + 1] = { id = _a322, num = _a324 }
end
end
end
table.sort(_a314, function(_a325, _a326) return _a325.num < _a326.num end)
return _a314, _a316, _a317
end
function _a18.egg.unlockEggs(_a327)
if not _a16.R_EggUn then return 0, "Eggs_RequestUnlock 리모트 없음" end
local _a328 = _a18.egg.lockedEggs()
if #_a328 == 0 then return 0 end
local _a329, _a330 = 0, nil
for _a331, _a332 in ipairs(_a328) do
if not _a18.egg.eggUnlocked(_a332.num) then
local _a333, _a334
pcall(function() _a333, _a334 = _a16.R_EggUn:InvokeServer(_a332.id) end)
if not _a333 and _a11.HatchAutoTp then
local _a335 = _a18.egg.tpEgg(_a332.id)
if _a335 then
task.wait(0.3)
pcall(function() _a333, _a334 = _a16.R_EggUn:InvokeServer(_a332.id) end)
end
end
if _a333 then
_a329 += 1
_a18.ctl.setAct("알 해금", ("#%d %s"):format(_a332.num, _a332.id))
_a5(("  🔓 알 해금  #%d %s"):format(_a332.num, _a332.id))
task.wait(0.15)
else
_a330 = _a334
if _a327 then
_a5(("[해금] #%d %s 실패: %s"):format(_a332.num, _a332.id, tostring(_a334)))
end
end
end
end
return _a329, _a330
end
function _a18.move.curZone()
if _a16.Map and rawget(_a16.Map, "GetCurrentZone") then
local _a336, _a337 = pcall(_a16.Map.GetCurrentZone)
if _a336 then return _a337 end
end
return nil
end
function _a18.move.zone1()
if not _a16.DirZones then return nil end
local _a338, _a339 = nil, math.huge
for _a340, _a341 in pairs(_a16.DirZones) do
if type(_a341) == "table" and _a18.move.ownsZone(_a340) then
local _a342 = tonumber(rawget(_a341, "ZoneNumber")) or math.huge
if _a342 < _a339 then _a338, _a339 = _a340, _a342 end
end
end
return _a338
end
function _a18.move.realZone(_a343) return _a343 end
function _a18.move.resolvableZone(_a344)
if _a344 then
local _a345 = _a18.move.zonePos(_a344)
if _a345 then return _a344, _a345 end
end
if not _a16.DirZones then return nil end
local _a346 = {}
for _a347, _a348 in pairs(_a16.DirZones) do
if type(_a348) == "table" and _a18.move.ownsZone(_a347) then
_a346[#_a346 + 1] = { id = _a347, n = tonumber(rawget(_a348, "ZoneNumber")) or 0 }
end
end
table.sort(_a346, function(_a349, _a350) return _a349.n > _a350.n end)
for _a351, _a352 in ipairs(_a346) do
if _a352.id ~= _a344 then
local _a353 = _a18.move.zonePos(_a352.id)
if _a353 then
if _a18.move.fallZone ~= _a352.id then
_a18.move.fallZone = _a352.id
_a5(("[TP] %s 좌표를 못 구해서 %s 로 대신 감 (로드 안 된 존)"):format(
tostring(_a344), tostring(_a352.id)))
end
return _a352.id, _a353
end
end
end
return nil
end
function _a18.move.bestZone()
if _a16.Zone and rawget(_a16.Zone, "GetMaxOwnedZone") then
local _a354, _a355, _a356 = pcall(_a16.Zone.GetMaxOwnedZone)
if _a354 and _a355 then return _a355, _a356 end
end
return _a18.move.zone1()
end
function _a18.move.ownsZone(_a357)
local _a358 = _a45()
local _a359 = _a358 and rawget(_a358, "UnlockedZones")
return (type(_a359) == "table" and _a359[_a357] ~= nil) or false
end
function _a18.move.zoneByNumber(_a360)
if not (_a16.DirZones and _a360) then return nil end
for _a361, _a362 in pairs(_a16.DirZones) do
if type(_a362) == "table" and tonumber(rawget(_a362, "ZoneNumber")) == tonumber(_a360) then
return _a361, _a362
end
end
return nil
end
local function _a363(_a364, _a365)
local _a366 = rawget(_a364, "Breakables")
local _a367 = type(_a366) == "table" and rawget(_a366, "Main") or nil
local _a368 = type(_a367) == "table" and rawget(_a367, "Data") or nil
if type(_a368) ~= "table" then return false end
for _a369, _a370 in pairs(_a368) do
local _a371 = type(_a370) == "table" and rawget(_a370, "Type") or nil
if _a371 and tostring(_a371):lower():find(_a365, 1, true) then return true end
end
return false
end
function _a18.move.zoneForBreakable(_a372)
if not (_a16.DirZones and _a372) then return nil end
local _a373 = tostring(_a372):lower()
local _a374 = _a18.move.bestZone()
if _a374 then
local _a375 = rawget(_a16.DirZones, _a374)
if type(_a375) == "table" and _a363(_a375, _a373) then return _a374 end
end
local _a376, _a377 = nil, -1
for _a378, _a379 in pairs(_a16.DirZones) do
if type(_a379) == "table" and _a378 ~= "Spawn" and _a18.move.ownsZone(_a378) then
local _a380 = rawget(_a379, "Breakables")
local _a381 = type(_a380) == "table" and rawget(_a380, "Main") or nil
local _a382 = type(_a381) == "table" and rawget(_a381, "Data") or nil
if type(_a382) == "table" then
for _a383, _a384 in pairs(_a382) do
local _a385 = type(_a384) == "table" and rawget(_a384, "Type") or nil
if _a385 and tostring(_a385):lower():find(_a373, 1, true) then
local _a386 = tonumber(rawget(_a379, "ZoneNumber")) or 0
if _a386 > _a377 then _a376, _a377 = _a378, _a386 end
break
end
end
end
end
end
return _a376
end
function _a18.move.tpZone(_a387)
if not _a387 then return false, "존 id 없음" end
if _a18.move.curZone() == _a387 then return true end
if not _a11.TpGameFallback then
_a5("[TP] 게임 정식 TP 차단됨 (" .. tostring(_a387) .. ")\n" .. debug.traceback("", 2))
return false, "게임 TP 꺼져 있음"
end
local _a388 = _a16.R_Tp
if _a16.Inst and rawget(_a16.Inst, "IsInInstance") then
local _a389, _a390 = pcall(_a16.Inst.IsInInstance)
if _a389 and _a390 and _a16.R_TpI then _a388 = _a16.R_TpI end
end
if not _a388 then return false, "텔레포트 리모트 없음" end
local _a391 = os.clock() - (_a18.move.lastTp or 0)
if _a391 < _a11.TpCooldown then task.wait(_a11.TpCooldown - _a391) end
_a18.move.lastTp = os.clock()
local _a392, _a393
pcall(function() _a392, _a393 = _a388:InvokeServer(_a387) end)
if not _a392 then return false, _a393 end
local _a394 = os.clock()
while os.clock() - _a394 < 5 do
if _a18.move.curZone() == _a387 then break end
task.wait(0.05)
end
task.wait(0.15)
return true
end
function _a18.move.glideTo(_a395)
if _a18.ctl.stopped() then return false, "정지됨" end
if _a18.ctl.moving and (os.clock() - _a18.ctl.moving) < 30 then
return false, "이미 이동 중 (다른 이동이 아직 안 끝남)"
end
_a18.ctl.moving = os.clock()
local _a396, _a397, _a398 = pcall(_a18.move.glideRaw, _a395)
_a18.ctl.moving = nil
if not _a396 then return false, tostring(_a397) end
return _a397, _a398
end
function _a18.move.glideRaw(_a399)
local _a400, _a401 = _a18.move.hrp()
if not _a400 then return false, "캐릭터 없음" end
if _a11.TpMode == "instant" then
local _a402 = _a399 + Vector3.new(0, 4, 0)
for _a403 = 1, 3 do
local _a404 = _a4 and _a4.Character
local _a405, _a406 = _a18.move.hrp()
if not (_a404 and _a405) then return false, "캐릭터 없음" end
local _a407 = _a405.CFrame - _a405.CFrame.Position
pcall(function() _a404:PivotTo(CFrame.new(_a402) * _a407) end)
_a405.AssemblyLinearVelocity = Vector3.zero
for _a408 = 1, 6 do _a3.Heartbeat:Wait() end
if _a406 then
pcall(function()
_a406:Move(Vector3.new(0.3, 0, 0), false)
end)
task.wait(0.1)
pcall(function() _a406:Move(Vector3.zero, false) end)
end
task.wait(0.15)
_a405 = _a18.move.hrp()
if _a405 and (_a405.Position - _a402).Magnitude <= 30 then
local _a409 = os.clock()
while os.clock() - _a409 < 1.5 do
if _a18.move.inDottedBox() ~= false then break end
task.wait(0.05)
end
return true
end
if _a403 < 3 then task.wait(0.15) end
end
return false, "순간이동이 되돌려짐"
end
if _a11.TpMode == "walk" then
if not _a401 then return false, "Humanoid 없음" end
local _a410 = os.clock()
while os.clock() - _a410 < 45 do
local _a411 = _a400.Position
if (Vector3.new(_a411.X, 0, _a411.Z) - Vector3.new(_a399.X, 0, _a399.Z)).Magnitude < 8 then
return true
end
_a401:MoveTo(_a399)
task.wait(0.5)
end
return false, "걸어가다 시간초과"
end
if (_a400.Position - _a399).Magnitude <= (_a11.ArriveDist or 12) then return true end
local _a412 = math.max(16, tonumber(_a11.TpSpeed) or 90)
local _a413 = math.max(0, tonumber(_a11.TpHeight) or 0)
local function _a414(_a415, _a416)
local _a417 = 0
while _a417 < 2000 do
if _a18.ctl.stopped() then return false end
_a417 += 1
local _a418 = _a18.move.hrp()
if not _a418 then return false end
local _a419 = _a418.Position
local _a420 = _a415 - _a419
local _a421 = _a420.Magnitude
if _a421 < 2.5 then return true end
local _a422 = _a3.Heartbeat:Wait()
local _a423 = math.min(_a421, _a412 * math.min(_a422, 0.1))
local _a424 = _a416 and (Vector3.new(_a415.X, _a419.Y, _a415.Z)) or nil
if _a424 and (_a424 - _a419).Magnitude > 1 then
_a418.CFrame = CFrame.lookAt(_a419 + _a420.Unit * _a423, _a424)
else
_a418.CFrame = CFrame.new(_a419 + _a420.Unit * _a423) * (_a418.CFrame - _a418.Position)
end
_a418.AssemblyLinearVelocity = Vector3.zero
end
return false
end
if _a413 > 0 then
local _a425 = _a400.Position
local _a426 = math.max(_a425.Y, _a399.Y) + _a413
_a414(Vector3.new(_a425.X, _a426, _a425.Z), false)
_a414(Vector3.new(_a399.X, _a426, _a399.Z), true)
end
_a414(_a399 + Vector3.new(0, 3, 0), true)
local _a427 = _a18.move.hrp()
if _a427 then _a427.AssemblyLinearVelocity = Vector3.zero end
return true
end
local function _a428(_a429)
local _a430 = #_a429
if _a430 == 0 then return nil, 0 end
local _a431, _a432 = math.huge, -math.huge
local _a433, _a434 = math.huge, -math.huge
local _a435 = 0
for _a436, _a437 in ipairs(_a429) do
if _a437.X < _a431 then _a431 = _a437.X end
if _a437.X > _a432 then _a432 = _a437.X end
if _a437.Z < _a433 then _a433 = _a437.Z end
if _a437.Z > _a434 then _a434 = _a437.Z end
_a435 += _a437.Y
end
return Vector3.new((_a431 + _a432) / 2, _a435 / _a430, (_a433 + _a434) / 2), _a430
end
function _a18.move.breakCenter(_a438)
local _a439 = _a18.move.hrp()
if not _a439 then return nil, 0 end
local _a440 = workspace:FindFirstChild("__THINGS")
if not _a440 then return nil, 0 end
local _a441 = _a439.Position
local _a442 = {}
for _a443, _a444 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a445 = _a440:FindFirstChild(_a444)
if _a445 then
for _a446, _a447 in ipairs(_a445:GetChildren()) do
local _a448
if _a447:IsA("BasePart") then _a448 = _a447.Position
elseif _a447:IsA("Model") then
local _a449, _a450 = pcall(function() return _a447:GetPivot() end)
if _a449 and typeof(_a450) == "CFrame" then _a448 = _a450.Position end
end
if _a448 and (_a448 - _a441).Magnitude <= (_a438 or 400) then
_a442[#_a442 + 1] = _a448
end
end
end
end
return _a428(_a442)
end
function _a18.move.groundY(_a451, _a452, _a453)
_a453 = tonumber(_a453) or 0
local _a454 = RaycastParams.new()
_a454.FilterType = Enum.RaycastFilterType.Exclude
local _a455 = {}
if _a4 and _a4.Character then _a455[#_a455 + 1] = _a4.Character end
local _a456 = workspace:FindFirstChild("__THINGS")
if _a456 then _a455[#_a455 + 1] = _a456 end
_a454.FilterDescendantsInstances = _a455
local _a457 = Vector3.new(_a451, _a453 + 12, _a452)
local _a458, _a459 = pcall(function()
return workspace:Raycast(_a457, Vector3.new(0, -160, 0), _a454)
end)
if _a458 and _a459 then
local _a460 = _a459.Position.Y
if math.abs(_a460 - _a453) <= 80 then return _a460 + 4 end
end
return nil
end
function _a18.move.zonePos(_a461, _a462)
if not _a461 then return nil, "존 id 없음" end
_a461 = _a18.move.realZone(_a461)
local _a463 = _a16.DirZones and rawget(_a16.DirZones, _a461)
local _a464 = _a463 and rawget(_a463, "ZoneFolder")
local _a465 = {}
do
local _a466 = workspace:FindFirstChild("__THINGS")
for _a467, _a468 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a469 = _a466 and _a466:FindFirstChild(_a468)
if _a469 then
for _a470, _a471 in ipairs(_a469:GetChildren()) do
local _a472
if _a471:IsA("BasePart") then _a472 = _a471.Position
elseif _a471:IsA("Model") then
local _a473, _a474 = pcall(function() return _a471:GetPivot() end)
if _a473 and typeof(_a474) == "CFrame" then _a472 = _a474.Position end
end
if _a472 then _a465[#_a465 + 1] = _a472 end
end
end
end
end
local _a475 = {}
local function _a476(_a477, _a478)
if not _a477 then return end
local _a479, _a480 = pcall(function() return _a477:GetDescendants() end)
if _a477:IsA("BasePart") then _a475[#_a475 + 1] = { p = _a477.Position, why = _a478 } end
if _a479 then
for _a481, _a482 in ipairs(_a480) do
if _a482:IsA("BasePart") then
_a475[#_a475 + 1] = { p = _a482.Position, why = _a478 .. "/" .. _a482.Name }
end
end
end
end
if _a16.ZonesU then
for _a483, _a484 in ipairs({ "GetBreakableZones", "GetBreakableSpawns" }) do
local _a485 = rawget(_a16.ZonesU, _a484)
if type(_a485) == "function" then
local _a486, _a487 = pcall(_a485, _a461)
if _a486 and _a487 then _a476(_a487, _a484) end
end
end
end
if _a464 then
for _a488, _a489 in ipairs({ "BREAK_ZONES", "BREAKABLE_SPAWNS" }) do
local _a490, _a491 = pcall(function() return _a464:FindFirstChild(_a489, true) end)
if _a490 and _a491 then _a476(_a491, "ZoneFolder/" .. _a489) end
end
end
local _a492, _a493, _a494
for _a495, _a496 in ipairs(_a475) do
local _a497 = 0
for _a498, _a499 in ipairs(_a465) do
if (_a499 - _a496.p).Magnitude <= 150 then _a497 += 1 end
end
if not _a493 or _a497 > _a493 then _a492, _a493, _a494 = _a496.p, _a497, _a496.why end
end
local _a500, _a501
if _a492 and (_a493 or 0) >= 1 then
_a500, _a501 = _a492, ("%s (브레이커블 %d개)"):format(tostring(_a494), _a493)
end
if not _a500 and _a492 then
_a500, _a501 = _a492, tostring(_a494) .. " (브레이커블 없음)"
end
if not _a500 and _a16.ZonesU and rawget(_a16.ZonesU, "GetTeleportPartLocation") then
local _a502, _a503 = pcall(_a16.ZonesU.GetTeleportPartLocation, _a461)
if _a502 and typeof(_a503) == "CFrame" then
_a500, _a501 = _a503.Position, "PERSISTENT/Teleport (스트리밍 대기)"
end
end
if not _a500 then return nil, "브레이커블 위치를 못 찾음" end
local _a504 = _a18.move.groundY(_a500.X, _a500.Z, _a500.Y)
if _a504 then
_a500 = Vector3.new(_a500.X, _a504, _a500.Z)
_a501 = _a501 .. " +지면"
else
_a500 = Vector3.new(_a500.X, _a500.Y + 5, _a500.Z)
end
return _a500, _a501
end
function _a18.move.goToZone(_a505, _a506, _a507, _a508)
_a505 = _a18.move.realZone(_a505)
if not _a505 then return false, "존 id 없음" end
local _a509, _a510 = _a18.move.zonePos(_a505)
if not _a509 then
if _a11.TpGameFallback and _a18.move.curZone() ~= _a505 then
local _a511, _a512 = _a18.move.tpZone(_a505)
if not _a511 then return false, _a512 end
task.wait(0.3)
_a509, _a510 = _a18.move.zonePos(_a505)
end
if not _a509 then
local _a513, _a514 = _a18.move.resolvableZone(_a505)
if _a513 and _a514 then
if _a508 then
return false, ("%s 가 로드되지 않음"):format(tostring(_a505))
end
_a505, _a509, _a510 = _a513, _a514, "대체 존 " .. tostring(_a513)
else
if _a18.move.zoneFailSaid ~= _a505 then
_a18.move.zoneFailSaid = _a505
_a5(("[TP] %s 좌표 실패: %s (갈 수 있는 존이 없음)"):format(
tostring(_a505), tostring(_a510)))
end
return false, _a510
end
end
end
local _a515 = _a18.move.hrp()
if not _a507 and _a515 and _a18.move.curZone() == _a505 then
local _a516 = _a18.move.inDottedBox()
local _a517
if _a516 ~= nil then
_a517 = _a516
else
_a517 = (_a515.Position - _a509).Magnitude <= (_a11.ZoneArriveDist or 90)
end
if _a517 then
if _a506 then _a5("[TP] 이미 " .. _a505 .. " 사냥터 안에 있음") end
return true
end
end
if _a506 then
_a5(("[TP] %s 내부 좌표 %s → (%.0f, %.0f, %.0f)"):format(
_a505, tostring(_a510), _a509.X, _a509.Y, _a509.Z))
end
local _a518, _a519 = _a18.move.glideTo(_a509)
local _a520 = _a18.move.hrp()
if _a520 and (_a520.Position - _a509).Magnitude > math.max(40, _a11.ArriveDist or 12) then
task.wait(0.2)
_a18.ctl.moving = nil
_a18.move.glideTo(_a509)
local _a521 = _a18.move.hrp()
local _a522 = _a521 and (_a521.Position - _a509).Magnitude or -1
if _a522 > math.max(40, _a11.ArriveDist or 12) then
local _a523 = _a11.TpMode
_a11.TpMode = "glide"
_a18.ctl.moving = nil
_a18.move.glideTo(_a509)
_a11.TpMode = _a523
local _a524 = _a18.move.hrp()
_a522 = _a524 and (_a524.Position - _a509).Magnitude or -1
if _a522 > math.max(40, _a11.ArriveDist or 12) then
_a5(("[TP] %s 이동 실패 — %.0f스터드 남음 (순간이동·glide 둘 다)"):format(
tostring(_a505), _a522))
return false, "이동이 되돌려짐"
end
_a5("[TP] 순간이동이 막혀서 glide 로 이동함: " .. tostring(_a505))
end
end
do
local _a525 = _a18.move.hrp()
if _a525 and (_a525.Position.Y - _a509.Y) > 25 then
_a5(("[TP] 목표보다 %.0f 높은 곳에 얹힘 — 내려감"):format(_a525.Position.Y - _a509.Y))
_a18.ctl.moving = nil
_a18.move.glideTo(Vector3.new(_a509.X, _a509.Y, _a509.Z))
end
end
if tostring(_a510):find("스트리밍", 1, true) then
task.wait(1.2)
local _a526, _a527 = _a18.move.zonePos(_a505)
if _a526 and not tostring(_a527):find("스트리밍", 1, true) then
if _a506 then
_a5("[TP] 스트리밍 로드됨 → 사냥터로 (" .. tostring(_a527) .. ")")
end
_a18.ctl.moving = nil
_a18.move.glideTo(_a526)
_a509, _a510 = _a526, _a527
end
end
if _a18.move.inDottedBox() == false then
task.wait(0.2)
local _a528, _a529 = _a18.move.breakCenter(400)
if _a528 and _a529 >= 3 then
if _a506 then
_a5(("[TP] 네모 밖 → 주변 브레이커블 %d개 중심으로 보정"):format(_a529))
end
_a18.ctl.moving = nil
_a18.move.glideTo(_a528)
_a509 = _a528
end
if _a18.move.inDottedBox() == false then
local _a530 = _a18.move.zonePos(_a505)
if _a530 and (_a530 - _a509).Magnitude > 5 then
if _a506 then _a5("[TP] 아직 네모 밖 → 좌표 재계산 후 재시도") end
_a18.ctl.moving = nil
_a18.move.glideTo(_a530)
_a509 = _a530
end
end
if _a18.move.inDottedBox() == false and _a506 then
_a5(("[TP] %s 네모 안으로 못 들어감 (좌표 %s)"):format(_a505, tostring(_a510)))
end
end
local function _a531()
if _a18.move.inDottedBox() == true then return false end
local _a532, _a533 = _a18.move.breakCenter(400)
if (_a533 or 0) >= 1 then return false end
task.wait(0.6)
if _a18.move.inDottedBox() == true then return false end
local _a534, _a535 = _a18.move.breakCenter(400)
return (_a535 or 0) < 1
end
if _a531() and (os.clock() - (_a18.move.lastRecover or -999)) > 30 then
_a18.move.lastRecover = os.clock()
_a5(("[TP] %s 근처에 브레이커블이 없음 (%s) — 좌표 확인 필요"):format(
tostring(_a505), tostring(_a510)))
end
_a18.move.zoneFailSaid = nil
_a18.move.arrivedZone = _a505
do
local _a536 = _a18.move.hrp()
local _a537 = _a536 and (_a536.Position - _a509).Magnitude or 0
if _a537 > math.max(60, _a11.ArriveDist or 12) then
_a5(("[TP] %s 도착 실패 — %.0f스터드 남음 (되돌려짐)"):format(tostring(_a505), _a537))
return false, "이동이 되돌려짐"
end
end
local _a538 = _a18.move.hrp()
if _a506 and _a538 then
_a5(("[TP] 도착. 목표까지 %.0f스터드 / 존 %s / 네모안 %s"):format(
(_a538.Position - _a509).Magnitude, tostring(_a18.move.curZone()), tostring(_a18.move.inDottedBox())))
end
return true
end
function _a18.egg.tpEgg(_a539)
if not _a539 then return false, "알 id 없음" end
for _a540, _a541 in ipairs(_a18.egg.eggStands()) do
if _a541.id == _a539 then
if _a541.dist <= _a11.EggRange then return true, _a539 end
local _a542, _a543 = _a18.move.glideTo(_a541.pos)
return _a542, _a542 and _a539 or _a543
end
end
if _a11.TpGameFallback then
local _a544 = _a16.DirEggs and rawget(_a16.DirEggs, _a539)
local _a545 = _a544 and select(1, _a18.move.zoneByNumber(rawget(_a544, "zoneNumber")))
if _a545 and _a18.move.curZone() ~= _a545 then
local _a546, _a547 = _a18.move.tpZone(_a545)
if not _a546 then return false, _a547 end
task.wait(0.5)
_a18.egg._standsAt = nil
for _a548, _a549 in ipairs(_a18.egg.eggStands()) do
if _a549.id == _a539 then return _a18.move.glideTo(_a549.pos), _a539 end
end
end
end
return false, "알 받침대를 못 찾음 (" .. tostring(_a539) .. ")"
end
function _a18.item.stacks(_a550)
local _a551 = _a45()
local _a552 = _a551 and rawget(_a551, "Inventory")
local _a553 = _a552 and rawget(_a552, _a550)
if type(_a553) ~= "table" then return {} end
local _a554 = {}
for _a555, _a556 in pairs(_a553) do
if type(_a556) == "table" then
_a554[#_a554 + 1] = {
uid = _a555,
id = tostring(rawget(_a556, "id")),
tier = tonumber(rawget(_a556, "tn")) or 1,
am = tonumber(rawget(_a556, "_am")) or 1,
}
end
end
return _a554
end
_a18.item.PERTIER = {
Potion  = { 3, 3, 4, 5, 5, 5, 5, 5, 7, 7, 7 },
Enchant = { 5, 5, 5, 7, 7, 7, 7, 7, 10, 10 },
}
function _a18.item.perTier(_a557, _a558)
_a558 = tonumber(_a558)
local _a559 = _a16.Bal and rawget(_a16.Bal,
_a557 == "Potion" and "CalcPotionsPerTierRequired" or "CalcEnchantsPerTierRequired")
if type(_a559) == "function" then
local _a560, _a561 = pcall(_a559, _a558)
_a561 = _a560 and tonumber(_a561) or nil
if _a561 and _a561 > 0 then return _a561 end
if not _a560 and not _a18.item.perTierWarned then
_a18.item.perTierWarned = true
_a5("[퀘스트] 재료 수량 함수 막힘 → 기본표로 계산 (" .. tostring(_a561) .. ")")
end
end
local _a562 = _a18.item.PERTIER[_a557]
local _a563 = _a562 and _a558 and _a562[_a558]
return (_a563 and _a563 > 0) and _a563 or nil
end
function _a18.item.upgradeTo(_a564, _a565)
local _a566 = (_a564 == "Potion") and _a16.R_PotUp or _a16.R_EncUp
if not _a566 then return 0, (_a564 .. " 업글 리모트 없음") end
local _a567 = math.max(1, (tonumber(_a565) or 2) - 1)
local _a568 = _a18.item.perTier(_a564, _a567)
if not _a568 then return 0, ("T%d 재료 수량을 못 읽음"):format(_a567) end
local _a569, _a570 = {}, 0
for _a571, _a572 in ipairs(_a18.item.stacks(_a564)) do
if _a572.tier == _a567 then
local _a573 = math.floor(_a572.am / _a568)
if _a573 > 0 then _a569[_a572.uid] = _a573 _a570 += _a573 end
end
end
if _a570 < 1 then return 0, ("T%d 재료 부족 (T%d %d개당 1개)"):format(_a567, _a567, _a568) end
local _a574, _a575
pcall(function() _a574, _a575 = _a566:InvokeServer(_a569) end)
if not _a574 then return 0, tostring(_a575) end
return _a570
end
function _a18.item.usePotion(_a576, _a577)
if not _a16.R_PotUse then return 0, "Potions: Consume 리모트 없음" end
_a576 = tonumber(_a576) or 1
local _a578 = {}
for _a579, _a580 in ipairs(_a18.item.stacks("Potion")) do
if _a580.tier >= _a576 and _a580.am >= 1 then _a578[#_a578 + 1] = _a580 end
end
if #_a578 == 0 then return 0, ("T%d 이상 포션 없음"):format(_a576) end
table.sort(_a578, function(_a581, _a582) return _a581.tier < _a582.tier end)
local _a583, _a584 = _a577, 0
for _a585, _a586 in ipairs(_a578) do
for _a587 = 1, math.min(_a583, _a586.am) do
if _a583 < 1 or not _a12.quest then break end
pcall(function() _a16.R_PotUse:FireServer(_a586.uid, 1) end)
_a584 += 1
_a583 -= 1
task.wait(0.12)
end
if _a583 < 1 then break end
end
return _a584
end
_a18.ev.EVENTKIND = {
[31]="CoinJar",    [37]="CoinJar",    [68]="CoinJar",
[32]="Comet",      [38]="Comet",      [69]="Comet",
[66]="Pinata",     [43]="Pinata",     [70]="Pinata",
[67]="LuckyBlock", [44]="LuckyBlock", [71]="LuckyBlock",
}
_a18.ev.BESTONLY = { [37]=true, [38]=true, [43]=true, [44]=true, [39]=true, [76]=true }
_a18.ev.CHESTKIND = { [8]="MiniChests", [39]="MiniChests", [72]="MiniChests",
[75]="SuperiorMiniChests", [76]="SuperiorMiniChests", [77]="SuperiorMiniChests" }
local function _a588(_a589)
if typeof(_a589) == "Vector3" then return _a589 end
if typeof(_a589) == "CFrame" then return _a589.Position end
if type(_a589) == "table" then
local _a590, _a591, _a592 = tonumber(_a589.X or _a589.x or _a589[1]), tonumber(_a589.Y or _a589.y or _a589[2]), tonumber(_a589.Z or _a589.z or _a589[3])
if _a590 and _a591 and _a592 then return Vector3.new(_a590, _a591, _a592) end
end
return nil
end
function _a18.ev.events()
local _a593
if _a16.Rand and rawget(_a16.Rand, "GetActive") then
local _a594, _a595 = pcall(_a16.Rand.GetActive)
if _a594 and type(_a595) == "table" and next(_a595) then _a593 = _a595 end
end
if not _a593 and _a16.R_Events then
local _a596, _a597 = pcall(function() return _a16.R_Events:InvokeServer() end)
if _a596 and type(_a597) == "table" then _a593 = _a597 end
end
if type(_a593) ~= "table" then return {} end
local _a598 = workspace:GetServerTimeNow()
local _a599 = {}
for _a600, _a601 in pairs(_a593) do
if type(_a601) == "table" then
local _a602 = tostring(rawget(_a601, "id") or "")
local _a603 = _a602:match("|%s*(%S+)%s*$") or _a602
local _a604 = tonumber(rawget(_a601, "started")) or 0
local _a605 = tonumber(rawget(_a601, "duration")) or 0
_a599[#_a599 + 1] = {
uid = rawget(_a601, "uid"),
id = _a602,
kind = _a603,
name = rawget(_a601, "name") or _a603,
zone = rawget(_a601, "parentID"),
pos = _a588(rawget(_a601, "origin")),
left = math.max(0, _a605 - (_a598 - _a604)),
}
end
end
table.sort(_a599, function(_a606, _a607) return _a606.left > _a607.left end)
return _a599
end
_a18.ev.SPAWN = {
CoinJar    = { rem = "CoinJar_Spawn",           key = "coin jar",
order = { "basic", "giant", "magic" } },
Comet      = { rem = "Comet_Spawn",             key = "comet" },
Pinata     = { rem = "MiniPinata_Consume",      key = "pinata" },
LuckyBlock = { rem = "MiniLuckyBlock_Consume",  key = "lucky block" },
}
function _a18.move.inDottedBox()
if _a16.Map and rawget(_a16.Map, "IsInDottedBox") then
local _a608, _a609 = pcall(_a16.Map.IsInDottedBox)
if _a608 then return _a609 and true or false end
end
return nil
end
function _a18.ev.spawnItems(_a610)
local _a611 = _a18.ev.SPAWN[_a610]
if not _a611 then return {} end
local _a612 = {}
for _a613, _a614 in ipairs({ "Misc", "Consumable", "Lootbox" }) do
for _a615, _a616 in ipairs(_a18.item.stacks(_a614)) do
local _a617 = _a616.id:lower()
if _a617:find(_a611.key, 1, true) then
local _a618 = 99
if _a611.order then
for _a619, _a620 in ipairs(_a611.order) do
if _a617:find(_a620, 1, true) then _a618 = _a619 break end
end
end
_a616.rank = _a618
_a612[#_a612 + 1] = _a616
end
end
end
table.sort(_a612, function(_a621, _a622)
if _a621.rank ~= _a622.rank then return _a621.rank < _a622.rank end
return _a621.tier < _a622.tier
end)
return _a612
end
function _a18.ev.spawnEvent(_a623)
local _a624 = _a18.ev.SPAWN[_a623]
if not _a624 then return 0, "소환 불가 종류" end
local _a625 = _a9:FindFirstChild(_a624.rem)
if not _a625 then return 0, _a624.rem .. " 리모트 없음" end
local _a626 = _a18.ev.spawnItems(_a623)
if #_a626 == 0 then return 0, _a623 .. " 아이템 없음" end
local _a627 = _a18.move.inDottedBox()
if _a627 == false then return 0, "점선 네모 안이 아님" end
local _a628, _a629 = 0, nil
for _a630, _a631 in ipairs(_a626) do
if _a628 >= (_a11.SpawnPerCycle or 1) or not _a12.quest then break end
local _a632, _a633
pcall(function() _a632, _a633 = _a625:InvokeServer(_a631.uid) end)
if _a632 then
_a628 += 1
_a18.ctl.setAct("소환", _a623 .. " · " .. _a631.id)
_a5(("  🎁 %s 소환  (%s)"):format(_a623, _a631.id))
task.wait(0.4)
else
_a629 = _a633
break
end
end
return _a628, _a629
end
function _a18.ev.findEvent(_a634, _a635)
local _a636 = _a635 and _a18.move.bestZone() or nil
local _a637
for _a638, _a639 in ipairs(_a18.ev.events()) do
if _a639.kind == _a634 and _a639.left > 15 then
if not _a635 or _a639.zone == _a636 then
if not _a637 or (_a639.zone == _a18.move.curZone() and _a637.zone ~= _a18.move.curZone()) then
_a637 = _a639
end
end
end
end
return _a637
end
function _a18.ev.findChest(_a640, _a641)
local _a642 = workspace:FindFirstChild("__THINGS")
if not _a642 then return nil end
local _a643 = tostring(_a640):lower():find("superior") ~= nil
local _a644 = _a18.move.hrp()
local _a645 = _a644 and _a644.Position
local _a646, _a647, _a648, _a649
for _a650, _a651 in ipairs(_a642:GetChildren()) do
if tostring(_a651.Name):lower():find("chest", 1, true) then
for _a652, _a653 in ipairs(_a651:GetChildren()) do
local _a654
if _a653:IsA("BasePart") then _a654 = _a653.Position
elseif _a653:IsA("Model") then
local _a655, _a656 = pcall(function() return _a653:GetPivot() end)
if _a655 and typeof(_a656) == "CFrame" then _a654 = _a656.Position end
end
if _a654 then
local _a657 = _a645 and (_a654 - _a645).Magnitude or 0
local _a658 = (tostring(_a653.Name) .. tostring(_a651.Name)):lower()
:find("superior", 1, true) ~= nil
if not _a649 or _a657 < _a649 then _a648, _a649 = _a654, _a657 end
if _a658 == _a643 and (not _a647 or _a657 < _a647) then
_a646, _a647 = _a654, _a657
end
end
end
end
end
if _a646 then return _a646, _a647 end
return _a648, _a649
end
_a18.quest.SKIP = { [4] = true, [5] = true, [40] = true, [41] = true }
_a18.quest.WHERE = {
[21]="bestzone", [9]="bestzone", [37]="bestzone", [38]="bestzone", [39]="bestzone",
[43]="bestzone", [44]="bestzone", [76]="bestzone", [30]="bestzone", [8]="bestzone",
[20]="bestegg",  [42]="bestegg",
[1]="breakable", [81]="zoneid",
}
function _a18.item.petStacks()
local _a659 = _a45()
local _a660 = _a659 and rawget(_a659, "Inventory")
local _a661 = _a660 and rawget(_a660, "Pet")
local _a662 = {}
if type(_a661) ~= "table" then return _a662 end
for _a663, _a664 in pairs(_a661) do
if type(_a664) == "table" then
_a662[#_a662 + 1] = {
uid = _a663,
id = tostring(rawget(_a664, "id")),
pt = tonumber(rawget(_a664, "pt")) or 0,
am = tonumber(rawget(_a664, "_am")) or 1,
}
end
end
return _a662
end
function _a18.item.bestEggPets()
local _a665 = _a93()
local _a666 = _a665 and _a16.DirEggs and rawget(_a16.DirEggs, _a665)
local _a667 = _a666 and rawget(_a666, "pets")
local _a668 = {}
if type(_a667) == "table" then
for _a669, _a670 in pairs(_a667) do
local _a671 = type(_a670) == "table" and _a670[1] or _a670
if _a671 then _a668[tostring(_a671)] = true end
end
end
return _a668, _a665
end
function _a18.item.makeVariant(_a672, _a673)
local _a674 = (_a672 == "gold") and _a16.R_Gold or _a16.R_Rain
if not _a674 then return 0, (_a672 .. " 머신 리모트 없음") end
local _a675 = (_a672 == "gold") and 0 or 1
local _a676
if _a673 then
local _a677, _a678 = _a18.item.bestEggPets()
if not next(_a677) then return 0, "최고 알(" .. tostring(_a678) .. ") 펫 목록을 못 읽음" end
_a676 = _a677
end
local _a679, _a680 = 0, nil
for _a681, _a682 in ipairs(_a18.item.petStacks()) do
if not _a12.quest then break end
if _a682.pt == _a675 and _a682.am >= 10 and (not _a676 or _a676[_a682.id]) then
local _a683 = math.floor(_a682.am / 10)
if _a683 > 0 then
local _a684, _a685
pcall(function() _a684, _a685 = _a674:InvokeServer(_a682.uid, _a683) end)
if _a684 then
_a679 += _a683
_a5(("  ✨ %s 제작  %s x%d"):format(
_a672 == "gold" and "골드" or "레인보우", _a682.id, _a683))
task.wait(0.4)
else
_a680 = _a685
end
end
end
end
return _a679, _a680
end
function _a18.item.useFlag(_a686)
if not _a16.R_Flag then return 0, "FlexibleFlags_Consume 리모트 없음" end
local _a687, _a688 = 0, nil
for _a689, _a690 in ipairs(_a18.item.stacks("Misc")) do
if _a687 >= (_a686 or 1) then break end
if _a690.id:lower():find("flag", 1, true) and _a690.am >= 1 and _a18.item.itemAllowed(_a690.id) then
local _a691, _a692
pcall(function() _a691, _a692 = _a16.R_Flag:InvokeServer(_a690.id, _a690.uid, 1) end)
if _a691 then _a687 += 1 task.wait(0.4) else _a688 = _a692 end
end
end
return _a687, _a688
end
function _a18.item.useFruit(_a693)
if not _a16.R_Fruit then return 0, "Fruits: Consume 리모트 없음" end
local _a694 = _a18.item.activeBuffs("Fruits")
local _a695 = 0
for _a696, _a697 in ipairs(_a18.item.stacks("Fruit")) do
if _a695 >= (_a693 or 1) then break end
if _a697.am >= 1 and _a18.item.itemAllowed(_a697.id) and not _a694[_a697.id] then
pcall(function() _a16.R_Fruit:FireServer(_a697.uid, 1) end)
_a695 += 1
task.wait(0.4)
end
end
return _a695
end
function _a18.quest.status()
local _a698 = _a45()
if not _a698 then return nil end
local _a699 = rawget(_a698, "Goals")
if type(_a699) ~= "table" then return { list = {} } end
local _a700 = {}
for _a701, _a702 in pairs(_a699) do
if type(_a702) == "table" then
local _a703 = tonumber(rawget(_a702, "Type")) or -1
local _a704
if _a16.Quest and rawget(_a16.Quest, "MakeTitle") then
local _a705, _a706 = pcall(_a16.Quest.MakeTitle, _a702)
if _a705 then _a704 = _a706 end
end
_a700[#_a700 + 1] = {
slot = _a701,
uid = tostring(rawget(_a702, "UID")),
type = _a703,
how = _a17[_a703],
title = _a704 or ("Type " .. _a703),
amount = tonumber(rawget(_a702, "Amount")) or 0,
progress = tonumber(rawget(_a702, "Progress")) or 0,
stars = tonumber(rawget(_a702, "Stars")) or 0,
potionTier = tonumber(rawget(_a702, "PotionTier")),
enchantTier = tonumber(rawget(_a702, "EnchantTier")),
breakable = rawget(_a702, "BreakableType") or rawget(_a702, "BreakableDirID"),
zoneId = rawget(_a702, "ZoneID"),
where = _a18.quest.WHERE[_a703] or (_a17[_a703] == "farm" and "bestzone" or nil),
event = _a18.ev.EVENTKIND[_a703],
chest = _a18.ev.CHESTKIND[_a703],
bestOnly = _a18.ev.BESTONLY[_a703] or false,
ignored = _a18.quest.IGNORE[_a703],
}
end
end
table.sort(_a700, function(_a707, _a708) return _a707.stars > _a708.stars end)
return { list = _a700, rank = tonumber(rawget(_a698, "Rank")) or 1,
rankStars = tonumber(rawget(_a698, "RankStars")) or 0 }
end
_a18.quest.BESTDEP = {
[20]=true, [21]=true, [37]=true, [38]=true, [39]=true,
[43]=true, [44]=true, [76]=true,
}
function _a18.quest.bestDepActive()
local _a709 = _a18.ctl.lockGoal and _a18.ctl.lockGoal.q
if not _a709 then return false end
if _a18.quest.IGNORE[_a709.type] then return false end
if not _a18.quest.BESTDEP[_a709.type] then return false end
local _a710 = _a18.quest.findQuest(_a709.uid)
if not _a710 or _a710.progress >= _a710.amount then return false end
return true, _a710
end
function _a18.quest.canDo(_a711, _a712)
if _a711.how == "hatch" or _a711.where == "bestegg" then
local _a713 = _a118()
if not _a713 then return false, "알 정보를 못 읽음" end
if not _a713.price then return true end
if not _a712 then
if _a713.canBuy < 1 then
return false, ("돈 부족 — %s 개당 %s %s / 보유 %s"):format(
tostring(_a713.id), _a6(_a713.price, 0), tostring(_a713.currency), _a6(_a713.have, 0))
end
return true
end
local _a714 = math.max(1, (_a711.amount or 1) - (_a711.progress or 0))
local _a715 = _a714
if _a711.type == 2 or _a711.type == 42 or _a711.type == 47 then
_a715 = math.max(_a714, _a11.HatchMinAfford or 10)
end
if _a713.canBuy < _a715 then
_a18.quest.moneyUntil = os.clock() + math.max(0, _a11.MoneyDwell or 60)
return false, ("돈 모으는 중 — %d개분 필요 / 지금 %d개분 (개당 %s %s)"):format(
_a715, _a713.canBuy, _a6(_a713.price, 0), tostring(_a713.currency))
end
if _a18.quest.moneyUntil and os.clock() < _a18.quest.moneyUntil then
return false, ("조금 더 벌고 감 (%.0f초 남음)"):format(_a18.quest.moneyUntil - os.clock())
end
_a18.quest.moneyUntil = nil
end
return true
end
function _a18.quest.findQuest(_a716)
local _a717 = _a18.quest.status()
for _a718, _a719 in ipairs(_a717 and _a717.list or {}) do
if _a719.uid == _a716 then return _a719 end
end
return nil
end
function _a18.quest.pursue(_a720)
local _a721, _a722
if _a720.how == "hatch" then _a721, _a722 = _a129, "mhatch"
elseif _a720.how == "zone" then _a721, _a722 = _a88, "zone"
elseif _a720.how == "gold" or _a720.how == "rainbow" then
local _a723 = (_a720.type == 40 or _a720.type == 41)
_a722 = "quest"
_a721 = function()
local _a724 = _a18.item.makeVariant("gold", _a723) or 0
if _a720.how == "rainbow" then
_a724 += (_a18.item.makeVariant("rainbow", _a723) or 0)
end
if _a724 > 0 then
_a18.ctl.setAct(_a720.how == "gold" and "골드 합성" or "레인보우 합성", _a724 .. "마리")
return
end
_a18.ctl.setAct("재료 모으는 중", "최고 알 부화")
local _a725 = _a12.mhatch
_a12.mhatch = true
pcall(_a129)
_a12.mhatch = _a725
end
end
local _a726 = _a720.progress
local _a727 = os.clock()
_a18.ctl.setGoal(_a720.title, ("%d/%d"):format(_a720.progress, _a720.amount))
local function _a728()
if not _a720.event then return end
local _a729 = _a18.ev.findEvent(_a720.event, _a720.bestOnly)
if _a729 then
_a18.ctl.setAct(_a720.event .. " 진행 중", ("%d초 남음"):format(_a729.left))
if _a729.pos then
local _a730 = _a18.move.hrp()
if _a730 and (_a730.Position - _a729.pos).Magnitude > (_a11.EventStayDist or 45) then
_a18.move.glideTo(_a729.pos)
end
end
return
end
local _a731, _a732 = _a18.ev.spawnEvent(_a720.event)
if _a731 > 0 then
_a18.ctl.setAct("소환", _a720.event)
task.wait(0.5)
elseif _a732 and _a18.ev.spawnErr ~= tostring(_a732) then
_a18.ev.spawnErr = tostring(_a732)
_a5("[퀘스트] " .. _a720.event .. " 소환 실패: " .. tostring(_a732))
end
end
local _a733, _a734 = pcall(function()
while _a12.quest and not _a18.ctl.stopped() do
local _a735, _a736 = _a18.quest.canDo(_a720, false)
if not _a735 then
_a5(("[퀘스트] %s → 다른 퀘스트 먼저 (%s)"):format(tostring(_a720.title), tostring(_a736)))
return
end
_a728()
if _a721 then
local _a737 = _a12[_a722]
_a12[_a722] = true
local _a738, _a739 = pcall(_a721)
_a12[_a722] = _a737
if not _a738 then error(_a739, 0) end
elseif _a720.event then
task.wait(0.4)
else
task.wait(2)
end
local _a740 = _a18.quest.findQuest(_a720.uid)
if not _a740 then
_a5("[퀘스트] 완료 — " .. tostring(_a720.title))
return
end
_a18.ctl.setGoal(_a740.title, ("%d/%d"):format(_a740.progress, _a740.amount))
if _a740.progress >= _a740.amount then
_a5(("[퀘스트] 달성 %d/%d — %s"):format(_a740.progress, _a740.amount, tostring(_a740.title)))
return
end
if _a740.progress > _a726 then
_a727 = os.clock()
_a5(("[퀘스트] %d/%d  %s"):format(_a740.progress, _a740.amount, tostring(_a740.title)))
end
_a726 = _a740.progress
local _a741 = os.clock() - _a727
if _a741 >= math.max(10, _a11.PursueStallSec or 60) then
_a5(("[퀘스트] %.0f초째 진행 없음 (%d/%d) — 다음 단계로: %s"):format(
_a741, _a740.progress, _a740.amount, tostring(_a740.title)))
return
end
task.wait(0.2)
end
end)
if not _a733 then _a5("[퀘스트] " .. tostring(_a720.how) .. " 오류: " .. tostring(_a734)) end
_a18.ctl.lockGoal = nil
_a18.ctl.setGoal(nil)
end
function _a18.quest.cycle()
do
local _a742 = _a12.rank
_a12.rank = true
pcall(_a180)
_a12.rank = _a742
end
local _a743 = _a18.quest.status()
if not _a743 then return end
local _a744, _a745, _a746 = false, false, false
local _a747 = {}
local _a748 = nil
for _a749, _a750 in ipairs(_a743.list) do
if not _a12.quest then break end
local _a751, _a752 = true, nil
if not _a750.ignored and _a750.progress < _a750.amount then
_a751, _a752 = _a18.quest.canDo(_a750, true)
end
if _a750.ignored then
if _a750.progress < _a750.amount then
_a747[#_a747 + 1] = tostring(_a750.title) .. "  — " .. _a750.ignored
end
elseif not _a751 then
local _a753 = tostring(_a750.uid) .. tostring(_a752)
if _a18.item.skipSaid ~= _a753 then
_a18.item.skipSaid = _a753
_a5(("[퀘스트] 건너뜀: %s   (%s)"):format(tostring(_a750.title), tostring(_a752)))
end
elseif _a750.progress < _a750.amount then
local _a754 = _a750.where
if _a750.event then
if not _a748 or _a748.rank > 0 then _a748 = { rank = 0, kind = "event", q = _a750 } end
elseif _a750.chest then
if not _a748 or _a748.rank > 1 then _a748 = { rank = 1, kind = "chest", q = _a750 } end
elseif _a754 == "bestegg" then
if not _a748 or _a748.rank > 1 then _a748 = { rank = 1, kind = "egg", q = _a750 } end
elseif _a754 == "breakable" and _a750.breakable then
if not _a748 or _a748.rank > 2 then _a748 = { rank = 2, kind = "breakable", q = _a750 } end
elseif _a754 == "zoneid" and _a750.zoneId then
if not _a748 or _a748.rank > 2 then _a748 = { rank = 2, kind = "zoneid", q = _a750 } end
elseif _a754 == "bestzone" or _a754 == "breakable" then
if not _a748 then _a748 = { rank = 3, kind = "bestzone", q = _a750 } end
end
if _a750.how == "farm" then
_a744 = true
elseif _a750.how == "hatch" then
_a745 = true
elseif _a750.how == "zone" then
_a746 = true
elseif _a750.how == "potup" and _a11.QuestUpgrade then
local _a755, _a756 = _a18.item.upgradeTo("Potion", _a750.potionTier or 2)
if _a755 > 0 then
_a13.potup += _a755
_a13.quest += 1
_a5(("[퀘스트] 포션 T%d %d개 제작  (%s)"):format(_a750.potionTier or 2, _a755, _a750.title))
elseif _a756 and not tostring(_a756):find("부족") then
if _a18.item.potUpSaid ~= tostring(_a756) then
_a18.item.potUpSaid = tostring(_a756)
_a5("[퀘스트] 포션 업글 실패: " .. tostring(_a756))
end
end
elseif _a750.how == "encup" and _a11.QuestUpgrade then
local _a757, _a758 = _a18.item.upgradeTo("Enchant", _a750.enchantTier or 2)
if _a757 > 0 then
_a13.potup += _a757
_a13.quest += 1
_a5(("[퀘스트] 인챈트 T%d %d개 제작  (%s)"):format(_a750.enchantTier or 2, _a757, _a750.title))
elseif _a758 and not tostring(_a758):find("부족") then
if _a18.item.encUpSaid ~= tostring(_a758) then
_a18.item.encUpSaid = tostring(_a758)
_a5("[퀘스트] 인챈트 업글 실패: " .. tostring(_a758))
end
end
elseif _a750.how == "potuse" and _a11.QuestUsePotion then
_a18.item.lastUse = _a18.item.lastUse or {}
local _a759 = _a18.item.lastUse[_a750.uid]
if _a759 and _a759.used > 0 and _a750.progress <= _a759.progress then
if not _a759.gaveUp then
_a759.gaveUp = true
_a5("[퀘스트] 포션을 마셔도 진행도가 안 올라서 중단: " .. tostring(_a750.title))
end
else
local _a760 = math.min(_a11.QuestUseMax, math.max(1, _a750.amount - _a750.progress))
local _a761, _a762 = _a18.item.usePotion(_a750.potionTier or 1, _a760)
_a18.item.lastUse[_a750.uid] = { used = _a761, progress = _a750.progress }
if _a761 > 0 then
_a13.potuse += _a761
_a13.quest += 1
_a5(("[퀘스트] 포션 %d개 사용  (%s)"):format(_a761, _a750.title))
elseif _a762 and not tostring(_a762):find("없음") then
_a5("[퀘스트] 포션 사용 실패: " .. tostring(_a762))
end
end
elseif _a750.how == "gold" or _a750.how == "rainbow" then
local _a763, _a764 = _a18.item.makeVariant(_a750.how, _a750.type == 40 or _a750.type == 41)
if _a763 > 0 then
_a13.quest += 1
_a5(("[퀘스트] %s 펫 %d마리 제작  (%s)"):format(
_a750.how == "gold" and "골드" or "레인보우", _a763, _a750.title))
elseif _a764 then
_a5("[퀘스트] " .. _a750.how .. " 실패: " .. tostring(_a764))
end
elseif _a750.how == "fruituse" then
local _a765 = _a18.item.useFruit(math.max(1, _a750.amount - _a750.progress))
if _a765 > 0 then
_a13.quest += 1
_a5(("[퀘스트] 과일 %d개 사용  (%s)"):format(_a765, _a750.title))
end
elseif _a750.how == "flaguse" then
local _a766, _a767 = _a18.item.useFlag(math.max(1, _a750.amount - _a750.progress))
if _a766 > 0 then
_a13.quest += 1
_a5(("[퀘스트] 깃발 %d개 사용  (%s)"):format(_a766, _a750.title))
elseif _a767 then
_a5("[퀘스트] 깃발 실패: " .. tostring(_a767))
end
elseif not _a750.how then
_a747[#_a747 + 1] = _a750.title
end
end
end
if _a11.QuestLock and _a18.ctl.lockGoal then
local _a768
for _a769, _a770 in ipairs(_a743.list) do
if _a770.uid == _a18.ctl.lockGoal.q.uid and _a770.progress < _a770.amount then _a768 = _a770 break end
end
if _a768 then
_a18.ctl.lockGoal.q = _a768
_a748 = _a18.ctl.lockGoal
else
if _a18.ctl.lockGoal.q then
_a5("[퀘스트] 완료/교체됨 → 다음 목표로: " .. tostring(_a18.ctl.lockGoal.q.title))
end
_a18.ctl.lockGoal = nil
end
end
if _a11.QuestLock and _a748 then _a18.ctl.lockGoal = _a748 end
if _a11.QuestTp and _a748 and _a12.quest then
local _a771, _a772, _a773
if _a748.kind == "event" then
local _a774 = _a18.ev.findEvent(_a748.q.event, _a748.q.bestOnly)
if _a774 then
_a773 = ("%s @%s (%d초 남음)"):format(_a774.name, tostring(_a774.zone), _a774.left)
if _a774.pos then _a771, _a772 = _a18.move.glideTo(_a774.pos)
else _a771, _a772 = _a18.move.goToZone(_a774.zone) end
else
local _a775 = _a748.q.bestOnly and _a18.move.bestZone() or (_a18.move.curZone() or _a18.move.bestZone())
_a773 = _a748.q.event .. " 소환용 " .. tostring(_a775)
local _a776 = _a18.move.inDottedBox()
_a771, _a772 = _a18.move.goToZone(_a775, false, _a776 == false, _a748.q.bestOnly)
if _a771 then
local _a777, _a778 = _a18.ev.spawnEvent(_a748.q.event)
if _a777 < 1 and tostring(_a778):find("점선") then
_a18.move.goToZone(_a775, false, true)
task.wait(0.2)
_a777, _a778 = _a18.ev.spawnEvent(_a748.q.event)
end
if _a777 > 0 then
_a773 = ("%s %d개 소환 @%s"):format(_a748.q.event, _a777, tostring(_a775))
else
_a772 = _a778
_a771 = false
end
end
end
elseif _a748.kind == "chest" then
local _a779 = _a748.q.bestOnly and _a18.move.bestZone() or _a18.move.curZone()
local _a780, _a781 = _a18.ev.findChest(_a748.q.chest, _a779)
_a773 = _a748.q.chest .. " @" .. tostring(_a779)
if _a780 then
if not _a781 or _a781 > 20 then _a18.move.glideTo(_a780) end
_a771 = true
else
_a771, _a772 = _a18.move.goToZone(_a779)
_a773 = _a773 .. " (상자 없음 → 존 가운데)"
end
elseif _a748.kind == "egg" then
local _a782 = _a93()
_a773 = "최고 알 " .. tostring(_a782)
if _a782 then _a771, _a772 = _a18.egg.tpEgg(_a782) else _a772 = "최고 알을 못 찾음" end
elseif _a748.kind == "breakable" then
local _a783 = _a18.move.zoneForBreakable(_a748.q.breakable)
_a773 = tostring(_a748.q.breakable) .. " 나오는 존 " .. tostring(_a783)
if _a783 then _a771, _a772 = _a18.move.goToZone(_a783, true) else _a772 = "그 브레이커블이 나오는 존이 없음" end
elseif _a748.kind == "zoneid" then
_a773 = "존 " .. tostring(_a748.q.zoneId)
_a771, _a772 = _a18.move.goToZone(_a748.q.zoneId)
else
local _a784 = _a18.move.bestZone()
local _a785 = _a748.q.bestOnly or _a18.quest.BESTDEP[_a748.q.type] or false
if _a784 then _a771, _a772 = _a18.move.goToZone(_a784, true, false, _a785)
else _a772 = "최고 존을 못 찾음" end
_a773 = "최고 존 " .. tostring(_a18.move.arrivedZone or _a784)
if not _a771 then _a772 = _a784 end
end
if _a771 then
if _a18.quest.lastGoal ~= _a773 then
_a18.quest.lastGoal = _a773
_a5("[퀘스트] " .. _a773 .. " 으로 이동  (" .. tostring(_a748.q.title) .. ")")
end
_a18.quest.pursue(_a748.q)
else
local _a786 = _a772 and tostring(_a772) or "이유 불명"
if _a18.quest.lastFail ~= _a786 then
_a18.quest.lastFail = _a786
_a5(("[퀘스트] 진행 못 함: %s   (%s / %s)"):format(
_a786, tostring(_a748.kind), tostring(_a748.q.title)))
_a5(("           현재 존 %s / 최고 존 %s / 점선네모 %s"):format(
tostring(_a18.move.curZone()), tostring(_a18.move.bestZone()), tostring(_a18.move.inDottedBox())))
end
end
end
if _a11.QuestDrive and _a18.auto.turnOn then
if _a744  then _a18.auto.turnOn("farm",   "파밍 퀘스트 → 자동 파밍") end
if _a746  then _a18.auto.turnOn("zone",   "존 퀘스트 → 자동 존 해금") end
if _a745 then _a18.auto.turnOn("mhatch", "부화 퀘스트 → 자동 부화") end
end
if #_a747 > 0 and not _a18.quest.manualWarned then
_a18.quest.manualWarned = true
_a5("[퀘스트] 수동으로 해야 하는 것:")
for _a787, _a788 in ipairs(_a747) do _a5("    · " .. tostring(_a788)) end
elseif #_a747 == 0 then
_a18.quest.manualWarned = false
end
return _a748 ~= nil
end
local function _a789(_a790)
local _a791 = {}
for _a792 in tostring(_a790 or ""):gmatch("[^,]+") do
_a792 = _a792:match("^%s*(.-)%s*$")
if _a792 ~= "" then _a791[#_a791 + 1] = _a792:lower() end
end
return _a791
end
function _a18.item.itemAllowed(_a793)
local _a794 = tostring(_a793):lower()
for _a795, _a796 in ipairs(_a789(_a11.ItemBlock)) do
if _a794:find(_a796, 1, true) then return false end
end
local _a797 = _a789(_a11.ItemAllow)
if #_a797 == 0 then return true end
for _a798, _a799 in ipairs(_a797) do
if _a794:find(_a799, 1, true) then return true end
end
return false
end
function _a18.item.activeBuffs(_a800)
local _a801 = _a45()
local _a802 = _a801 and rawget(_a801, _a800)
local _a803 = {}
if type(_a802) == "table" then
for _a804, _a805 in pairs(_a802) do
if type(_a805) == "table" and next(_a805) then _a803[_a804] = true
elseif _a805 then _a803[_a804] = true end
end
end
return _a803
end
local function _a806(_a807, _a808, _a809, _a810)
local _a811 = _a18.item.activeBuffs(_a808)
local _a812 = {}
local _a813 = { total = 0, act = 0, blocked = 0, few = 0, ok = 0 }
for _a814, _a815 in ipairs(_a18.item.stacks(_a807)) do
_a813.total += 1
if _a811[_a815.id] then _a813.act += 1
elseif not _a18.item.itemAllowed(_a815.id) then _a813.blocked += 1
elseif _a815.am <= _a11.ItemKeep then _a813.few += 1
else
_a813.ok += 1
local _a816 = _a812[_a815.id]
local _a817
if not _a816 then _a817 = true
elseif _a11.BuffHighTier then _a817 = _a815.tier > _a816.tier
else _a817 = _a815.tier < _a816.tier end
if _a817 then _a812[_a815.id] = _a815 end
end
end
if _a813.ok == 0 and _a813.total > 0 then
local _a818 = ("%s %d종 중 사용 가능 0 (이미걸림 %d / 제외 %d / 재고부족 %d)")
:format(_a807, _a813.total, _a813.act, _a813.blocked, _a813.few)
if _a18.item.buffSaid ~= _a818 then
_a18.item.buffSaid = _a818
_a5("[아이템] " .. _a818)
end
elseif _a813.ok > 0 then
_a18.item.buffSaid = nil
end
local _a819 = {}
for _a820, _a821 in pairs(_a812) do _a819[#_a819 + 1] = _a821 end
table.sort(_a819, function(_a822, _a823)
if _a822.tier ~= _a823.tier then return _a822.tier > _a823.tier end
return _a822.am > _a823.am
end)
local _a824 = {}
for _a825, _a826 in ipairs(_a819) do
if not _a12.items then break end
if _a810 and _a810.left <= 0 then break end
local _a827 = pcall(function() _a809(_a826.uid, 1) end)
if _a827 then
_a824[#_a824 + 1] = ("%s T%d"):format(_a826.id, _a826.tier)
_a13.items += 1
if _a810 then _a810.left -= 1 end
task.wait(0.12)
end
end
return _a824
end
function _a18.item.cycleItems()
local function _a828()
local _a829 = {}
if _a11.BuffPotion then _a829[#_a829 + 1] = { "Potion", "Potions" } end
if _a11.BuffFruit then _a829[#_a829 + 1] = { "Fruit", "Fruits" } end
if _a11.BuffConsumable then _a829[#_a829 + 1] = { "Consumable", "Consumables" } end
for _a830, _a831 in ipairs(_a829) do
local _a832 = _a18.item.activeBuffs(_a831[2])
for _a833, _a834 in ipairs(_a18.item.stacks(_a831[1])) do
if _a834.am > _a11.ItemKeep and _a18.item.itemAllowed(_a834.id) and not _a832[_a834.id] then
return true
end
end
end
if _a11.BuffUltimate and _a16.R_Ult then
local _a835 = _a45()
local _a836 = _a835 and rawget(_a835, "Ultimates")
if type(_a836) == "table" then
for _a837 in pairs(_a836) do
if _a18.item.itemAllowed(_a837) then
if not (_a16.Ult and rawget(_a16.Ult, "IsCharged")) then return true end
local _a838, _a839 = pcall(_a16.Ult.IsCharged, _a837)
if _a838 and _a839 then return true end
end
end
end
end
return false
end
if not _a828() then return end
if _a11.ItemBestZone then
local _a840 = _a18.move.bestZone()
if _a840 and _a18.move.curZone() ~= _a840 then
if not _a11.ItemTp then
if not _a18.item.itemZoneWarned then
_a18.item.itemZoneWarned = true
_a5(("[아이템] 최고 존(%s)이 아니라 대기 — 현재 %s"):format(
tostring(_a840), tostring(_a18.move.curZone())))
end
return
end
local _a841, _a842 = _a18.move.goToZone(_a840)
if not _a841 then
_a5("[아이템] 최고 존 이동 실패: " .. tostring(_a842))
return
end
_a5("[아이템] 최고 존 " .. tostring(_a840) .. " 에서 사용")
end
_a18.item.itemZoneWarned = false
end
local _a843 = {}
local _a844  = { left = math.max(1, _a11.BuffMaxPotion or 5) }
local _a845 = { left = math.max(1, _a11.BuffMaxOther or 2) }
if _a11.BuffPotion and _a16.R_PotUse then
local _a846 = _a806("Potion", "Potions", function(_a847, _a848)
_a16.R_PotUse:FireServer(_a847, _a848)
end, _a844)
for _a849, _a850 in ipairs(_a846) do _a843[#_a843 + 1] = "포션 " .. _a850 end
end
if _a11.BuffFruit and _a16.R_Fruit then
local _a851 = _a806("Fruit", "Fruits", function(_a852, _a853)
_a16.R_Fruit:FireServer(_a852, _a853)
end, _a845)
for _a854, _a855 in ipairs(_a851) do _a843[#_a843 + 1] = "과일 " .. _a855 end
end
if _a11.BuffConsumable and _a16.R_Cons then
local _a856 = _a806("Consumable", "Consumables", function(_a857, _a858)
_a16.R_Cons:InvokeServer(_a857, _a858)
end, _a845)
for _a859, _a860 in ipairs(_a856) do _a843[#_a843 + 1] = "소모품 " .. _a860 end
end
if _a11.BuffUltimate and _a16.R_Ult then
local _a861 = _a45()
local _a862 = _a861 and rawget(_a861, "Ultimates")
if type(_a862) == "table" then
for _a863 in pairs(_a862) do
if not _a12.items then break end
if _a18.item.itemAllowed(_a863) then
local _a864 = true
if _a16.Ult and rawget(_a16.Ult, "IsCharged") then
local _a865, _a866 = pcall(_a16.Ult.IsCharged, _a863)
_a864 = _a865 and _a866 and true or false
end
if _a864 then
local _a867
pcall(function() _a867 = _a16.R_Ult:InvokeServer(_a863) end)
if _a867 then
_a843[#_a843 + 1] = "얼티밋 " .. tostring(_a863)
_a13.items += 1
task.wait(0.3)
end
end
end
end
end
end
if #_a843 > 0 then
_a18.ctl.setAct("버프 사용", table.concat(_a843, ", "))
_a5("[아이템] " .. table.concat(_a843, ", ") .. " 사용")
end
end
function _a18.mach.slotStatus()
local _a868 = _a45()
if not _a868 then return nil end
local _a869 = tonumber(rawget(_a868, "PetSlotsPurchased")) or 0
local _a870 = tonumber(rawget(_a868, "EggSlotsPurchased")) or 0
local _a871, _a872 = 0, 0
if _a16.RankC then
if rawget(_a16.RankC, "GetMaxPurchasableEquipSlots") then
local _a873, _a874 = pcall(_a16.RankC.GetMaxPurchasableEquipSlots)
if _a873 and tonumber(_a874) then _a871 = tonumber(_a874) end
end
if rawget(_a16.RankC, "GetMaxPurchasableEggSlots") then
local _a875, _a876 = pcall(_a16.RankC.GetMaxPurchasableEggSlots)
if _a875 and tonumber(_a876) then _a872 = tonumber(_a876) end
end
end
local _a877, _a878
if _a869 < _a871 then
_a877 = _a869 + 1
if type(_a16.CalcPetS) == "function" then
local _a879, _a880 = pcall(_a16.CalcPetS, _a877)
if _a879 then _a878 = tonumber(_a880) end
end
end
local _a881, _a882, _a883
if _a870 < _a872 and _a16.RankC and rawget(_a16.RankC, "GetEggBundle") then
local _a884, _a885, _a886 = pcall(_a16.RankC.GetEggBundle, _a870 + 1)
if _a884 and tonumber(_a885) then
_a881, _a882 = tonumber(_a885), tonumber(_a886) or 1
if type(_a16.CalcEggS) == "function" then
local _a887, _a888 = 0, false
for _a889 = _a881 - _a882 + 1, _a881 do
local _a890, _a891 = pcall(_a16.CalcEggS, _a889)
if _a890 and tonumber(_a891) then _a887 += tonumber(_a891) else _a888 = true end
end
if not _a888 then _a883 = _a887 end
end
end
end
local _a892
if _a16.Egg and rawget(_a16.Egg, "GetMaxHatch") then
local _a893, _a894 = pcall(_a16.Egg.GetMaxHatch)
if _a893 then _a892 = tonumber(_a894) end
end
return {
dia = _a60("Diamonds"),
petOwned = _a869, petMax = _a871, petNext = _a877, petCost = _a878,
eggOwned = _a870, eggMax = _a872, eggEnd = _a881, eggSize = _a882, eggCost = _a883,
maxEquip = tonumber(rawget(_a868, "MaxPetsEquipped")), maxHatch = _a892,
}
end
function _a18.move.machinePos(_a895)
local _a896
if _a16.Machine and rawget(_a16.Machine, "GetModels") then
local _a897, _a898 = pcall(_a16.Machine.GetModels, _a895)
if _a897 and type(_a898) == "table" then
for _a899, _a900 in pairs(_a898) do
if typeof(_a900) == "Instance" then _a896 = _a900 break end
end
end
end
if not _a896 then
local _a901, _a902 = pcall(function()
return game:GetService("CollectionService"):GetTagged("Machine")
end)
if _a901 then
for _a903, _a904 in ipairs(_a902) do
if _a904.Name == _a895 then _a896 = _a904 break end
end
end
end
if not _a896 then return nil end
if _a896:IsA("BasePart") then return _a896.Position end
local _a905, _a906 = pcall(function() return _a896:GetPivot() end)
return (_a905 and typeof(_a906) == "CFrame") and _a906.Position or nil
end
function _a18.mach.cycleSlots()
local _a907 = 0
local _a908 = 0
while _a12.slots and not _a18.ctl.stopped() and _a908 < 40 do
_a908 += 1
local _a909 = _a18.mach.slotStatus()
if not _a909 then return end
local _a910 = _a11.SlotPet and _a909.petNext and _a909.petCost
and (_a909.dia - _a11.SlotReserve) >= _a909.petCost
local _a911 = _a11.SlotEgg and _a909.eggEnd and _a909.eggCost
and (_a909.dia - _a11.SlotReserve) >= _a909.eggCost
if _a910 and _a911 then
if _a909.eggCost < _a909.petCost then _a910 = false else _a911 = false end
end
if not (_a910 or _a911) then break end
local _a912, _a913, _a914, _a915
local function _a916()
if _a910 then
pcall(function() _a912, _a913 = _a16.R_PetSlot:InvokeServer(_a909.petNext) end)
else
pcall(function() _a912, _a913 = _a16.R_EggSlot:InvokeServer(_a909.eggEnd) end)
end
end
if _a910 then
_a914 = ("펫 장착 슬롯 #%d (%s 다이아)"):format(_a909.petNext, _a6(_a909.petCost, 0))
_a915 = "EquipSlotsMachine"
else
_a914 = ("알 부화 슬롯 %d칸 → %d (%s 다이아)"):format(
_a909.eggSize, _a909.eggEnd, _a6(_a909.eggCost, 0))
_a915 = "EggSlotsMachine"
end
_a916()
if not _a912 and tostring(_a913):find("far away") then
local _a917 = _a18.move.machinePos(_a915)
if _a917 then
_a18.ctl.setAct("슬롯 머신으로 이동", _a915)
_a18.move.glideTo(_a917)
task.wait(0.25)
_a912, _a913 = nil, nil
_a916()
else
_a913 = "머신 위치를 못 찾음 (" .. _a915 .. ")"
end
end
if _a912 then
_a907 += 1
_a13.mslot += 1
_a18.mach.slotSaid = nil
_a18.ctl.setAct("슬롯 구매", _a914)
_a5("  ⬆ " .. _a914)
task.wait(0.35)
else
local _a918 = _a914 .. " 실패: " .. tostring(_a913)
if _a18.mach.slotSaid ~= _a918 then
_a18.mach.slotSaid = _a918
_a5("[슬롯] " .. _a918)
end
break
end
end
if _a907 > 0 then
local _a919 = _a18.mach.slotStatus()
_a5(("[슬롯] %d개 구매 — 장착 %s / 한번에 %s개 부화 (다이아 %s 남음)"):format(
_a907, tostring(_a919 and _a919.maxEquip), tostring(_a919 and _a919.maxHatch),
_a6(_a60("Diamonds"), 0)))
end
end
function _a18.mach.upgList()
local _a920 = {}
if not _a16.Upg then return _a920 end
local _a921, _a922 = pcall(_a16.Upg.All)
if not (_a921 and type(_a922) == "table") then return _a920 end
for _a923, _a924 in ipairs(_a922) do
local _a925, _a926, _a927 = rawget(_a924, "UpgradeID"), rawget(_a924, "ZoneID"), rawget(_a924, "UpgradeTier")
if _a925 and _a926 and _a927 then
local _a928 = false
if rawget(_a16.Upg, "Owns") then
local _a929, _a930 = pcall(_a16.Upg.Owns, _a925, _a926)
_a928 = _a929 and _a930 and true or false
end
local _a931 = _a18.move.ownsZone(_a926)
local _a932 = _a16.DirUpg and rawget(_a16.DirUpg, _a925)
local _a933 = _a932 and rawget(_a932, "TierCosts")
local _a934 = _a933 and tonumber(_a933[_a927])
local _a935 = "Diamonds"
local _a936 = _a932 and rawget(_a932, "TierCurrencies")
local _a937 = _a936 and _a936[_a927]
if type(_a937) == "table" and rawget(_a937, "_id") then _a935 = rawget(_a937, "_id") end
local _a938 = rawget(_a924, "Model")
local _a939
if typeof(_a938) == "Instance" then
if _a938:IsA("BasePart") then _a939 = _a938.Position
else
local _a940, _a941 = pcall(function() return _a938:GetPivot() end)
if _a940 and _a941 then _a939 = _a941.Position end
end
end
_a920[#_a920 + 1] = {
id = _a925, zone = _a926, tier = _a927, cost = _a934, cur = _a935,
bought = _a928, zoneOwned = _a931,
buyable = _a931 and not _a928,
pos = _a939, model = _a938,
}
end
end
table.sort(_a920, function(_a942, _a943) return (_a942.cost or math.huge) < (_a943.cost or math.huge) end)
return _a920
end
function _a18.mach.cycleUpg()
if not _a16.R_Upg then _a5("[맵업글] Upgrades_Purchase 리모트 없음") return end
local _a944 = _a18.mach.upgList()
if #_a944 == 0 then return end
local _a945 = 0
for _a946, _a947 in ipairs(_a944) do
if not _a12.mapupg then break end
if _a947.buyable and _a947.cost then
local _a948 = _a60(_a947.cur or "Diamonds")
if _a948 - _a11.UpgReserve < _a947.cost then break end
if _a11.UpgTp and _a947.pos and _a947.zone == _a18.move.curZone() then
_a18.move.glideTo(_a947.pos)
end
local _a949, _a950
pcall(function() _a949, _a950 = _a16.R_Upg:InvokeServer(_a947.id, _a947.zone) end)
if _a949 then
_a945 += 1
_a13.mapupg += 1
_a18.ctl.setAct("맵 업글", _a947.id .. " T" .. _a947.tier)
_a5(("  ▲ 맵업글  %s T%d  @%s   (%s 다이아)"):format(
_a947.id, _a947.tier, _a947.zone, _a6(_a947.cost, 0)))
elseif _a950 then
_a5(("[맵업글] %s T%d @%s 실패: %s"):format(
_a947.id, _a947.tier, _a947.zone, tostring(_a950)))
end
task.wait(_a11.ActionGap)
end
end
if _a945 > 0 then
_a5(("[맵업글] %d개 구매  (다이아 %s 남음)"):format(_a945, _a6(_a60("Diamonds"), 0)))
end
end
local function _a951()
local _a952 = _a45()
if not _a952 then return nil end
local _a953 = tonumber(rawget(_a952, "Rebirths")) or 0
local _a954 = _a953 + 1
local _a955
if _a16.Rebirth and rawget(_a16.Rebirth, "GetNextRebirth") then
local _a956, _a957 = pcall(_a16.Rebirth.GetNextRebirth, _a952)
if _a956 then _a955 = _a957 end
end
return { current = _a953, nextN = _a954, def = _a955 }
end
local function _a958()
if not _a16.R_Reb then _a5("[리버스] Rebirth_Request 리모트 없음") return end
local _a959 = _a951()
if not _a959 then
_a18.auto.rebNote = "세이브를 못 읽음"
return
end
local _a960, _a961
pcall(function() _a960, _a961 = _a16.R_Reb:InvokeServer(_a959.nextN) end)
if _a960 then
_a13.mreb += 1
_a18.auto.rebNote, _a18.auto.rebSaid = nil, nil
_a5(("  ★ 리버스 %d → %d"):format(_a959.current, _a959.nextN))
task.wait(0.5)
_a18.screen.dismissRewardScreens(25)
else
_a18.auto.rebNote = ("%d → %d : %s"):format(_a959.current, _a959.nextN,
_a961 and tostring(_a961) or "조건 미달 (리버스 킬/존 요구치)")
if _a18.auto.rebSaid ~= _a18.auto.rebNote then
_a18.auto.rebSaid = _a18.auto.rebNote
_a5("[리버스] " .. _a18.auto.rebNote)
end
end
end
_a18.auto.SIDE = {
{ key = "unlock", label = "알 해금",   run = "mhatch", fn = function() _a18.egg.unlockEggs() end },
{ key = "slots",  label = "슬롯 머신", run = "slots",  fn = function() _a18.mach.cycleSlots() end },
{ key = "mapupg", label = "맵 업그레이드", run = "mapupg", fn = function() _a18.mach.cycleUpg() end },
{ key = "items",  label = "버프 유지",     run = "items",  fn = function() _a18.item.cycleItems() end },
}
_a18.auto.STEPS = {
{ key = "mreb",   label = "리버스",  run = "mreb",  fn = function() _a958() end,
hold = true },
{ key = "zone",   label = "존 해금", run = "zone",  fn = function() _a88() end,
hold = true },
{ key = "quest",  label = "랭크 퀘스트+보상", run = "quest", fn = function()
local _a962 = _a12.farm
_a12.farm = true
pcall(_a70)
_a12.farm = _a962
local _a963 = _a18.quest.cycle()
if not _a963 then
local _a964 = _a18.move.bestZone()
if _a964 then
local _a965, _a966 = _a18.move.goToZone(_a964)
if not _a965 then
if _a966 and _a18.auto.idleMoveSaid ~= tostring(_a966) then
_a18.auto.idleMoveSaid = tostring(_a966)
_a5("[자동] 최고 존 이동 실패: " .. tostring(_a966))
end
else
_a18.auto.idleMoveSaid = nil
end
end
if not _a11.IdleHatch then
_a18.ctl.setAct("파밍 중", ("퀘스트 없음 @%s"):format(tostring(_a18.move.curZone())))
return
end
local _a967 = _a118()
local _a968 = math.max(1, _a11.HatchMinAfford or 10)
if _a967 and _a967.price and _a967.canBuy < _a968 then
_a18.ctl.setAct("돈 버는 중", ("%s  %d/%d개분  개당 %s %s"):format(
tostring(_a18.move.curZone()), _a967.canBuy, _a968,
_a6(_a967.price, 0), tostring(_a967.currency)))
else
_a18.ctl.setAct("대기 중 부화")
local _a969 = _a12.mhatch
_a12.mhatch = true
pcall(_a129)
_a12.mhatch = _a969
end
end
end },
}
_a11.StepOn = {}
for _a970, _a971 in ipairs(_a18.auto.SIDE) do _a11.StepOn[_a971.key] = true end
for _a972, _a973 in ipairs(_a18.auto.STEPS) do _a11.StepOn[_a973.key] = true end
local function _a974(_a975, _a976, _a977, _a978)
if not _a11.StepOn[_a975.key] then
_a978[#_a978 + 1] = ("%-14s 꺼져있음"):format(_a975.label)
return
end
if _a975.hold and _a976 then
_a978[#_a978 + 1] = ("%-14s 보류 (%s)"):format(
_a975.label, _a977 and tostring(_a977.title) or "?")
if _a18.auto.heldMsg ~= _a975.key then
_a18.auto.heldMsg = _a975.key
_a5(("[자동] %s 보류 — best 존이 바뀌면 깨지는 퀘스트 진행 중 (%s)"):format(
_a975.label, _a977 and tostring(_a977.title) or "?"))
end
return
end
if _a975.hold then _a18.auto.heldMsg = nil end
_a18.auto.step = _a975.label
_a18.ctl.now.step = _a975.label
_a18.ctl.setAct("시작", _a975.label)
local _a979 = os.clock()
local _a980 = _a12[_a975.run]
_a12[_a975.run] = true
local _a981, _a982 = pcall(_a975.fn)
_a12[_a975.run] = _a980
local _a983 = os.clock() - _a979
if not _a981 then
_a978[#_a978 + 1] = ("%-14s 오류: %s"):format(_a975.label, tostring(_a982))
_a5("[자동] " .. _a975.label .. " 오류: " .. tostring(_a982))
else
local _a984 = (_a975.key == "zone" and _a18.auto.zoneNote)
or (_a975.key == "mreb" and _a18.auto.rebNote) or nil
_a978[#_a978 + 1] = ("%-14s 실행 %.1f초%s"):format(
_a975.label, _a983, _a984 and ("  → " .. _a984) or "")
end
end
function _a18.auto.master()
local _a985 = {}
_a18.auto.lastTrace = _a985
_a18.auto.lastPassAt = os.clock()
if _a18.screen.rewardScreenUp() then
_a985[#_a985 + 1] = "보상 화면 넘기는 중"
_a18.screen.dismissRewardScreens(15)
end
for _a986, _a987 in ipairs(_a18.auto.SIDE) do
if not _a12.auto or _a18.ctl.stopped() then return end
_a974(_a987, false, nil, _a985)
end
local _a988, _a989 = false, nil
if _a11.HoldZoneForQuest then _a988, _a989 = _a18.quest.bestDepActive() end
for _a990, _a991 in ipairs(_a18.auto.STEPS) do
if not _a12.auto or _a18.ctl.stopped() then break end
_a974(_a991, _a988, _a989, _a985)
end
_a18.auto.step = nil
if not _a18.ctl.lockGoal then
_a18.ctl.now.step = "대기"
_a18.ctl.setAct("다음 바퀴 대기", ("%.0f초 주기"):format(_a11.AutoInterval or 5))
end
local _a992 = {}
for _a993, _a994 in ipairs(_a985) do _a992[#_a992 + 1] = (_a994:gsub("[%d%.]+초", "")) end
_a992 = table.concat(_a992, " | ")
if _a992 ~= _a18.auto.lastSig then
_a18.auto.lastSig = _a992
_a5("[자동] 바퀴 " .. (_a18.auto.passN or 0))
for _a995, _a996 in ipairs(_a985) do _a5("    " .. _a996) end
end
_a18.auto.passN = (_a18.auto.passN or 0) + 1
end
local function _a997()
if not _a10.R_PROMO then _a5("[타워업글] 리모트 없음") return end
local _a998 = _a14()
if not _a998 then return end
local _a999 = _a15(_a998)
table.sort(_a999, function(_a1000, _a1001) return (_a1000.dps or 0) > (_a1001.dps or 0) end)
local _a1002, _a1003 = 0, 0
for _a1004, _a1005 in ipairs(_a999) do
if not _a12.towerup then break end
if _a1005.id then
local _a1006
pcall(function() _a1006 = _a10.R_PROMO:InvokeServer(_a1005.id) end)
if _a1006 ~= nil and _a1006 ~= false then
_a1002 += 1
_a5(("  ▲ 타워업글  %s  Lv%s → Lv%s"):format(tostring(_a1005.kind), tostring(_a1005.up), tostring((_a1005.up or 0) + 1)))
_a1003 = 0
task.wait(_a11.ActionGap)
else
_a1003 += 1
if _a1003 >= 5 then break end
end
end
end
_a5("[타워업글] " .. _a1002 .. "건")
end
local _a1007 = {}
local _a1008 = {}
local function _a1009(_a1010, _a1011)
local _a1012 = tostring(_a1011)
local _a1013 = _a1008[_a1010]
if _a1013 and _a1013.msg == _a1012 then
_a1013.n += 1
if _a1013.n % 20 == 0 then
_a5(("[%s 오류] %s   (%d회 반복)"):format(_a1010, _a1012, _a1013.n))
end
return
end
_a1008[_a1010] = { msg = _a1012, n = 1 }
_a5("[" .. _a1010 .. " 오류] " .. _a1012)
end
local function _a1014(_a1015, _a1016, _a1017, _a1018)
_a1007[_a1015] = (_a1007[_a1015] or 0) + 1
local _a1019 = _a1007[_a1015]
task.spawn(function()
while _a12[_a1015] and _a1007[_a1015] == _a1019 do
local _a1020, _a1021 = pcall(_a1017)
if not _a1020 then _a1009(_a1018, _a1021) else _a1008[_a1018] = nil end
local _a1022, _a1023 = _a1016(), 0
while _a1023 < _a1022 and _a12[_a1015] and _a1007[_a1015] == _a1019 do task.wait(0.1) _a1023 += 0.1 end
end
if _a1007[_a1015] == _a1019 then _a5("[" .. _a1018 .. "] 중지") end
end)
end
do
local _a1024 = {
farm   = { function() return _a11.FarmInterval end,      function() _a70() end,      "파밍" },
zone   = { function() return _a11.ZoneInterval end,      function() _a88() end,      "존" },
mhatch = { function() return _a11.MainHatchInterval end, function() _a129() end, "부화" },
}
function _a18.auto.turnOn(_a1025, _a1026)
if _a12.auto then return end
if _a12[_a1025] then return end
local _a1027 = _a1024[_a1025]
if not _a1027 then return end
_a12[_a1025] = true
_a1014(_a1025, _a1027[1], _a1027[2], _a1027[3])
if _a18.auto.refresh then _a18.auto.refresh() end
_a5("[퀘스트] " .. tostring(_a1026) .. " ON")
end
end
_a1.MG, _a1.QS, _a1.saveGet, _a1.currencyAmount, _a1.cycleFarm, _a1.zoneStatus = _a16, _a18, _a45, _a60, _a70, _a84
_a1.cycleZone, _a1.bestMainEgg, _a1.mainHatchStatus, _a1.cycleMainHatch, _a1.mainRebirthStatus, _a1.cycleMainRebirth = _a88, _a93, _a118, _a129, _a951, _a958
_a1.cycleTowerUp, _a1.startLoop = _a997, _a1014
end
