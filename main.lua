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
local _a492 = _a18.move.badSpot and _a18.move.badSpot[_a461]
local _a493, _a494, _a495
for _a496, _a497 in ipairs(_a475) do
local _a498 = false
if _a492 then
for _a499, _a500 in ipairs(_a492) do
if (_a500 - _a497.p).Magnitude <= 60 then _a498 = true break end
end
end
if not _a498 then
local _a501 = 0
for _a502, _a503 in ipairs(_a465) do
if (_a503 - _a497.p).Magnitude <= 150 then _a501 += 1 end
end
if not _a494 or _a501 > _a494 then _a493, _a494, _a495 = _a497.p, _a501, _a497.why end
end
end
local _a504, _a505
if _a493 and (_a494 or 0) >= 1 then
_a504, _a505 = _a493, ("%s (브레이커블 %d개)"):format(tostring(_a495), _a494)
end
if not _a504 and _a493 then
_a504, _a505 = _a493, tostring(_a495) .. " (브레이커블 없음)"
end
if not _a504 and _a16.ZonesU and rawget(_a16.ZonesU, "GetTeleportPartLocation") then
local _a506, _a507 = pcall(_a16.ZonesU.GetTeleportPartLocation, _a461)
if _a506 and typeof(_a507) == "CFrame" then
_a504, _a505 = _a507.Position, "PERSISTENT/Teleport (스트리밍 대기)"
end
end
if not _a504 then return nil, "브레이커블 위치를 못 찾음" end
local _a508 = _a18.move.groundY(_a504.X, _a504.Z, _a504.Y)
if _a508 then
_a504 = Vector3.new(_a504.X, _a508, _a504.Z)
_a505 = _a505 .. " +지면"
else
_a504 = Vector3.new(_a504.X, _a504.Y + 5, _a504.Z)
end
return _a504, _a505
end
function _a18.move.goToZone(_a509, _a510, _a511, _a512)
_a509 = _a18.move.realZone(_a509)
if not _a509 then return false, "존 id 없음" end
local _a513, _a514 = _a18.move.zonePos(_a509)
if not _a513 then
if _a11.TpGameFallback and _a18.move.curZone() ~= _a509 then
local _a515, _a516 = _a18.move.tpZone(_a509)
if not _a515 then return false, _a516 end
task.wait(0.3)
_a513, _a514 = _a18.move.zonePos(_a509)
end
if not _a513 then
local _a517, _a518 = _a18.move.resolvableZone(_a509)
if _a517 and _a518 then
if _a512 then
return false, ("%s 가 로드되지 않음"):format(tostring(_a509))
end
_a509, _a513, _a514 = _a517, _a518, "대체 존 " .. tostring(_a517)
else
if _a18.move.zoneFailSaid ~= _a509 then
_a18.move.zoneFailSaid = _a509
_a5(("[TP] %s 좌표 실패: %s (갈 수 있는 존이 없음)"):format(
tostring(_a509), tostring(_a514)))
end
return false, _a514
end
end
end
local _a519 = _a18.move.hrp()
if not _a511 and _a519 and _a18.move.curZone() == _a509 then
local _a520 = _a18.move.inDottedBox()
local _a521
if _a520 ~= nil then
_a521 = _a520
else
_a521 = (_a519.Position - _a513).Magnitude <= (_a11.ZoneArriveDist or 90)
end
if _a521 then
if _a510 then _a5("[TP] 이미 " .. _a509 .. " 사냥터 안에 있음") end
return true
end
end
if _a510 then
_a5(("[TP] %s 내부 좌표 %s → (%.0f, %.0f, %.0f)"):format(
_a509, tostring(_a514), _a513.X, _a513.Y, _a513.Z))
end
local _a522, _a523 = _a18.move.glideTo(_a513)
local _a524 = _a18.move.hrp()
if _a524 and (_a524.Position - _a513).Magnitude > math.max(40, _a11.ArriveDist or 12) then
task.wait(0.2)
_a18.ctl.moving = nil
_a18.move.glideTo(_a513)
local _a525 = _a18.move.hrp()
local _a526 = _a525 and (_a525.Position - _a513).Magnitude or -1
if _a526 > math.max(40, _a11.ArriveDist or 12) then
local _a527 = _a11.TpMode
_a11.TpMode = "glide"
_a18.ctl.moving = nil
_a18.move.glideTo(_a513)
_a11.TpMode = _a527
local _a528 = _a18.move.hrp()
_a526 = _a528 and (_a528.Position - _a513).Magnitude or -1
if _a526 > math.max(40, _a11.ArriveDist or 12) then
_a5(("[TP] %s 이동 실패 — %.0f스터드 남음 (순간이동·glide 둘 다)"):format(
tostring(_a509), _a526))
return false, "이동이 되돌려짐"
end
_a5("[TP] 순간이동이 막혀서 glide 로 이동함: " .. tostring(_a509))
end
end
do
local _a529 = _a18.move.hrp()
if _a529 and (_a529.Position.Y - _a513.Y) > 25 then
_a5(("[TP] 목표보다 %.0f 높은 곳에 얹힘 — 내려감"):format(_a529.Position.Y - _a513.Y))
_a18.ctl.moving = nil
_a18.move.glideTo(Vector3.new(_a513.X, _a513.Y, _a513.Z))
end
end
if tostring(_a514):find("스트리밍", 1, true) then
task.wait(1.2)
local _a530, _a531 = _a18.move.zonePos(_a509)
if _a530 and not tostring(_a531):find("스트리밍", 1, true) then
if _a510 then
_a5("[TP] 스트리밍 로드됨 → 사냥터로 (" .. tostring(_a531) .. ")")
end
_a18.ctl.moving = nil
_a18.move.glideTo(_a530)
_a513, _a514 = _a530, _a531
end
end
if _a18.move.inDottedBox() == false then
task.wait(0.2)
local _a532, _a533 = _a18.move.breakCenter(400)
if _a532 and _a18.move.badSpot and _a18.move.badSpot[_a509] then
for _a534, _a535 in ipairs(_a18.move.badSpot[_a509]) do
if (_a535 - _a532).Magnitude <= 60 then _a532 = nil break end
end
end
if _a532 and _a533 >= 3 then
if _a510 then
_a5(("[TP] 네모 밖 → 주변 브레이커블 %d개 중심으로 보정"):format(_a533))
end
_a18.ctl.moving = nil
_a18.move.glideTo(_a532)
_a513 = _a532
end
if _a18.move.inDottedBox() == false then
local _a536 = _a18.move.zonePos(_a509)
if _a536 and (_a536 - _a513).Magnitude > 5 then
if _a510 then _a5("[TP] 아직 네모 밖 → 좌표 재계산 후 재시도") end
_a18.ctl.moving = nil
_a18.move.glideTo(_a536)
_a513 = _a536
end
end
if _a18.move.inDottedBox() == false and _a18.move.curZone() == _a509 then
_a18.move.badSpot = _a18.move.badSpot or {}
local _a537 = _a18.move.badSpot[_a509] or {}
if #_a537 < 5 then
_a537[#_a537 + 1] = _a513
_a18.move.badSpot[_a509] = _a537
_a5(("[TP] %s — 사냥터(점선 네모) 밖입니다. 이 지점은 앞으로 안 씁니다"):format(
tostring(_a509)))
_a5(("        후보: %s   좌표 (%.0f, %.0f, %.0f)"):format(
tostring(_a514), _a513.X, _a513.Y, _a513.Z))
else
_a18.move.badSpot[_a509] = nil
_a5("[TP] " .. tostring(_a509) .. " — 쓸만한 지점을 못 찾아 기록을 지웁니다")
end
return false, "사냥터 밖"
end
end
local function _a538()
if _a18.move.inDottedBox() == true then return false end
local _a539, _a540 = _a18.move.breakCenter(400)
if (_a540 or 0) >= 1 then return false end
task.wait(0.6)
if _a18.move.inDottedBox() == true then return false end
local _a541, _a542 = _a18.move.breakCenter(400)
return (_a542 or 0) < 1
end
if _a538() and (os.clock() - (_a18.move.lastRecover or -999)) > 30 then
_a18.move.lastRecover = os.clock()
_a5(("[TP] %s 근처에 브레이커블이 없음 (%s) — 좌표 확인 필요"):format(
tostring(_a509), tostring(_a514)))
end
_a18.move.zoneFailSaid = nil
_a18.move.arrivedZone = _a509
do
local _a543 = _a18.move.hrp()
local _a544 = _a543 and (_a543.Position - _a513).Magnitude or 0
if _a544 > math.max(60, _a11.ArriveDist or 12) then
_a5(("[TP] %s 도착 실패 — %.0f스터드 남음 (되돌려짐)"):format(tostring(_a509), _a544))
return false, "이동이 되돌려짐"
end
end
local _a545 = _a18.move.hrp()
if _a510 and _a545 then
_a5(("[TP] 도착. 목표까지 %.0f스터드 / 존 %s / 네모안 %s"):format(
(_a545.Position - _a513).Magnitude, tostring(_a18.move.curZone()), tostring(_a18.move.inDottedBox())))
end
return true
end
function _a18.egg.tpEgg(_a546)
if not _a546 then return false, "알 id 없음" end
for _a547, _a548 in ipairs(_a18.egg.eggStands()) do
if _a548.id == _a546 then
if _a548.dist <= _a11.EggRange then return true, _a546 end
local _a549, _a550 = _a18.move.glideTo(_a548.pos)
return _a549, _a549 and _a546 or _a550
end
end
if _a11.TpGameFallback then
local _a551 = _a16.DirEggs and rawget(_a16.DirEggs, _a546)
local _a552 = _a551 and select(1, _a18.move.zoneByNumber(rawget(_a551, "zoneNumber")))
if _a552 and _a18.move.curZone() ~= _a552 then
local _a553, _a554 = _a18.move.tpZone(_a552)
if not _a553 then return false, _a554 end
task.wait(0.5)
_a18.egg._standsAt = nil
for _a555, _a556 in ipairs(_a18.egg.eggStands()) do
if _a556.id == _a546 then return _a18.move.glideTo(_a556.pos), _a546 end
end
end
end
return false, "알 받침대를 못 찾음 (" .. tostring(_a546) .. ")"
end
function _a18.item.stacks(_a557)
local _a558 = _a45()
local _a559 = _a558 and rawget(_a558, "Inventory")
local _a560 = _a559 and rawget(_a559, _a557)
if type(_a560) ~= "table" then return {} end
local _a561 = {}
for _a562, _a563 in pairs(_a560) do
if type(_a563) == "table" then
_a561[#_a561 + 1] = {
uid = _a562,
id = tostring(rawget(_a563, "id")),
tier = tonumber(rawget(_a563, "tn")) or 1,
am = tonumber(rawget(_a563, "_am")) or 1,
}
end
end
return _a561
end
_a18.item.PERTIER = {
Potion  = { 3, 3, 4, 5, 5, 5, 5, 5, 7, 7, 7 },
Enchant = { 5, 5, 5, 7, 7, 7, 7, 7, 10, 10 },
}
function _a18.item.perTier(_a564, _a565)
_a565 = tonumber(_a565)
local _a566 = _a16.Bal and rawget(_a16.Bal,
_a564 == "Potion" and "CalcPotionsPerTierRequired" or "CalcEnchantsPerTierRequired")
if type(_a566) == "function" then
local _a567, _a568 = pcall(_a566, _a565)
_a568 = _a567 and tonumber(_a568) or nil
if _a568 and _a568 > 0 then return _a568 end
if not _a567 and not _a18.item.perTierWarned then
_a18.item.perTierWarned = true
_a5("[퀘스트] 재료 수량 함수 막힘 → 기본표로 계산 (" .. tostring(_a568) .. ")")
end
end
local _a569 = _a18.item.PERTIER[_a564]
local _a570 = _a569 and _a565 and _a569[_a565]
return (_a570 and _a570 > 0) and _a570 or nil
end
function _a18.item.upgradeTo(_a571, _a572)
local _a573 = (_a571 == "Potion") and _a16.R_PotUp or _a16.R_EncUp
if not _a573 then return 0, (_a571 .. " 업글 리모트 없음") end
local _a574 = math.max(1, (tonumber(_a572) or 2) - 1)
local _a575 = _a18.item.perTier(_a571, _a574)
if not _a575 then return 0, ("T%d 재료 수량을 못 읽음"):format(_a574) end
local _a576, _a577 = {}, 0
for _a578, _a579 in ipairs(_a18.item.stacks(_a571)) do
if _a579.tier == _a574 then
local _a580 = math.floor(_a579.am / _a575)
if _a580 > 0 then _a576[_a579.uid] = _a580 _a577 += _a580 end
end
end
if _a577 < 1 then return 0, ("T%d 재료 부족 (T%d %d개당 1개)"):format(_a574, _a574, _a575) end
local _a581, _a582
pcall(function() _a581, _a582 = _a573:InvokeServer(_a576) end)
if not _a581 then return 0, tostring(_a582) end
return _a577
end
function _a18.item.usePotion(_a583, _a584)
if not _a16.R_PotUse then return 0, "Potions: Consume 리모트 없음" end
_a583 = tonumber(_a583) or 1
local _a585 = {}
for _a586, _a587 in ipairs(_a18.item.stacks("Potion")) do
if _a587.tier >= _a583 and _a587.am >= 1 then _a585[#_a585 + 1] = _a587 end
end
if #_a585 == 0 then return 0, ("T%d 이상 포션 없음"):format(_a583) end
table.sort(_a585, function(_a588, _a589) return _a588.tier < _a589.tier end)
local _a590, _a591 = _a584, 0
for _a592, _a593 in ipairs(_a585) do
for _a594 = 1, math.min(_a590, _a593.am) do
if _a590 < 1 or not _a12.quest then break end
pcall(function() _a16.R_PotUse:FireServer(_a593.uid, 1) end)
_a591 += 1
_a590 -= 1
task.wait(0.12)
end
if _a590 < 1 then break end
end
return _a591
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
local function _a595(_a596)
if typeof(_a596) == "Vector3" then return _a596 end
if typeof(_a596) == "CFrame" then return _a596.Position end
if type(_a596) == "table" then
local _a597, _a598, _a599 = tonumber(_a596.X or _a596.x or _a596[1]), tonumber(_a596.Y or _a596.y or _a596[2]), tonumber(_a596.Z or _a596.z or _a596[3])
if _a597 and _a598 and _a599 then return Vector3.new(_a597, _a598, _a599) end
end
return nil
end
function _a18.ev.events()
local _a600
if _a16.Rand and rawget(_a16.Rand, "GetActive") then
local _a601, _a602 = pcall(_a16.Rand.GetActive)
if _a601 and type(_a602) == "table" and next(_a602) then _a600 = _a602 end
end
if not _a600 and _a16.R_Events then
local _a603, _a604 = pcall(function() return _a16.R_Events:InvokeServer() end)
if _a603 and type(_a604) == "table" then _a600 = _a604 end
end
if type(_a600) ~= "table" then return {} end
local _a605 = workspace:GetServerTimeNow()
local _a606 = {}
for _a607, _a608 in pairs(_a600) do
if type(_a608) == "table" then
local _a609 = tostring(rawget(_a608, "id") or "")
local _a610 = _a609:match("|%s*(%S+)%s*$") or _a609
local _a611 = tonumber(rawget(_a608, "started")) or 0
local _a612 = tonumber(rawget(_a608, "duration")) or 0
_a606[#_a606 + 1] = {
uid = rawget(_a608, "uid"),
id = _a609,
kind = _a610,
name = rawget(_a608, "name") or _a610,
zone = rawget(_a608, "parentID"),
pos = _a595(rawget(_a608, "origin")),
left = math.max(0, _a612 - (_a605 - _a611)),
}
end
end
table.sort(_a606, function(_a613, _a614) return _a613.left > _a614.left end)
return _a606
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
local _a615, _a616 = pcall(_a16.Map.IsInDottedBox)
if _a615 then return _a616 and true or false end
end
return nil
end
function _a18.ev.spawnItems(_a617)
local _a618 = _a18.ev.SPAWN[_a617]
if not _a618 then return {} end
local _a619 = {}
for _a620, _a621 in ipairs({ "Misc", "Consumable", "Lootbox" }) do
for _a622, _a623 in ipairs(_a18.item.stacks(_a621)) do
local _a624 = _a623.id:lower()
if _a624:find(_a618.key, 1, true) then
local _a625 = 99
if _a618.order then
for _a626, _a627 in ipairs(_a618.order) do
if _a624:find(_a627, 1, true) then _a625 = _a626 break end
end
end
_a623.rank = _a625
_a619[#_a619 + 1] = _a623
end
end
end
table.sort(_a619, function(_a628, _a629)
if _a628.rank ~= _a629.rank then return _a628.rank < _a629.rank end
return _a628.tier < _a629.tier
end)
return _a619
end
function _a18.ev.spawnEvent(_a630)
local _a631 = _a18.ev.SPAWN[_a630]
if not _a631 then return 0, "소환 불가 종류" end
local _a632 = _a9:FindFirstChild(_a631.rem)
if not _a632 then return 0, _a631.rem .. " 리모트 없음" end
local _a633 = _a18.ev.spawnItems(_a630)
if #_a633 == 0 then return 0, _a630 .. " 아이템 없음" end
local _a634 = _a18.move.inDottedBox()
if _a634 == false then return 0, "점선 네모 안이 아님" end
local _a635, _a636 = 0, nil
for _a637, _a638 in ipairs(_a633) do
if _a635 >= (_a11.SpawnPerCycle or 1) or not _a12.quest then break end
local _a639, _a640
pcall(function() _a639, _a640 = _a632:InvokeServer(_a638.uid) end)
if _a639 then
_a635 += 1
_a18.ctl.setAct("소환", _a630 .. " · " .. _a638.id)
_a5(("  🎁 %s 소환  (%s)"):format(_a630, _a638.id))
task.wait(0.4)
else
_a636 = _a640
break
end
end
return _a635, _a636
end
function _a18.ev.findEvent(_a641, _a642)
local _a643 = _a642 and _a18.move.bestZone() or nil
local _a644
for _a645, _a646 in ipairs(_a18.ev.events()) do
if _a646.kind == _a641 and _a646.left > 15 then
if not _a642 or _a646.zone == _a643 then
if not _a644 or (_a646.zone == _a18.move.curZone() and _a644.zone ~= _a18.move.curZone()) then
_a644 = _a646
end
end
end
end
return _a644
end
function _a18.ev.findChest(_a647, _a648)
local _a649 = workspace:FindFirstChild("__THINGS")
if not _a649 then return nil end
local _a650 = tostring(_a647):lower():find("superior") ~= nil
local _a651 = _a18.move.hrp()
local _a652 = _a651 and _a651.Position
local _a653, _a654, _a655, _a656
for _a657, _a658 in ipairs(_a649:GetChildren()) do
if tostring(_a658.Name):lower():find("chest", 1, true) then
for _a659, _a660 in ipairs(_a658:GetChildren()) do
local _a661
if _a660:IsA("BasePart") then _a661 = _a660.Position
elseif _a660:IsA("Model") then
local _a662, _a663 = pcall(function() return _a660:GetPivot() end)
if _a662 and typeof(_a663) == "CFrame" then _a661 = _a663.Position end
end
if _a661 then
local _a664 = _a652 and (_a661 - _a652).Magnitude or 0
local _a665 = (tostring(_a660.Name) .. tostring(_a658.Name)):lower()
:find("superior", 1, true) ~= nil
if not _a656 or _a664 < _a656 then _a655, _a656 = _a661, _a664 end
if _a665 == _a650 and (not _a654 or _a664 < _a654) then
_a653, _a654 = _a661, _a664
end
end
end
end
end
if _a653 then return _a653, _a654 end
return _a655, _a656
end
_a18.quest.SKIP = { [4] = true, [5] = true, [40] = true, [41] = true }
_a18.quest.WHERE = {
[21]="bestzone", [9]="bestzone", [37]="bestzone", [38]="bestzone", [39]="bestzone",
[43]="bestzone", [44]="bestzone", [76]="bestzone", [30]="bestzone", [8]="bestzone",
[20]="bestegg",  [42]="bestegg",
[1]="breakable", [81]="zoneid",
}
function _a18.item.petStacks()
local _a666 = _a45()
local _a667 = _a666 and rawget(_a666, "Inventory")
local _a668 = _a667 and rawget(_a667, "Pet")
local _a669 = {}
if type(_a668) ~= "table" then return _a669 end
for _a670, _a671 in pairs(_a668) do
if type(_a671) == "table" then
_a669[#_a669 + 1] = {
uid = _a670,
id = tostring(rawget(_a671, "id")),
pt = tonumber(rawget(_a671, "pt")) or 0,
am = tonumber(rawget(_a671, "_am")) or 1,
}
end
end
return _a669
end
function _a18.item.bestEggPets()
local _a672 = _a93()
local _a673 = _a672 and _a16.DirEggs and rawget(_a16.DirEggs, _a672)
local _a674 = _a673 and rawget(_a673, "pets")
local _a675 = {}
if type(_a674) == "table" then
for _a676, _a677 in pairs(_a674) do
local _a678 = type(_a677) == "table" and _a677[1] or _a677
if _a678 then _a675[tostring(_a678)] = true end
end
end
return _a675, _a672
end
function _a18.item.makeVariant(_a679, _a680)
local _a681 = (_a679 == "gold") and _a16.R_Gold or _a16.R_Rain
if not _a681 then return 0, (_a679 .. " 머신 리모트 없음") end
local _a682 = (_a679 == "gold") and 0 or 1
local _a683
if _a680 then
local _a684, _a685 = _a18.item.bestEggPets()
if not next(_a684) then return 0, "최고 알(" .. tostring(_a685) .. ") 펫 목록을 못 읽음" end
_a683 = _a684
end
local _a686, _a687 = 0, nil
for _a688, _a689 in ipairs(_a18.item.petStacks()) do
if not _a12.quest then break end
if _a689.pt == _a682 and _a689.am >= 10 and (not _a683 or _a683[_a689.id]) then
local _a690 = math.floor(_a689.am / 10)
if _a690 > 0 then
local _a691, _a692
pcall(function() _a691, _a692 = _a681:InvokeServer(_a689.uid, _a690) end)
if _a691 then
_a686 += _a690
_a5(("  ✨ %s 제작  %s x%d"):format(
_a679 == "gold" and "골드" or "레인보우", _a689.id, _a690))
task.wait(0.4)
else
_a687 = _a692
end
end
end
end
return _a686, _a687
end
function _a18.item.useFlag(_a693)
if not _a16.R_Flag then return 0, "FlexibleFlags_Consume 리모트 없음" end
local _a694, _a695 = 0, nil
for _a696, _a697 in ipairs(_a18.item.stacks("Misc")) do
if _a694 >= (_a693 or 1) then break end
if _a697.id:lower():find("flag", 1, true) and _a697.am >= 1 and _a18.item.itemAllowed(_a697.id) then
local _a698, _a699
pcall(function() _a698, _a699 = _a16.R_Flag:InvokeServer(_a697.id, _a697.uid, 1) end)
if _a698 then _a694 += 1 task.wait(0.4) else _a695 = _a699 end
end
end
return _a694, _a695
end
function _a18.item.useFruit(_a700)
if not _a16.R_Fruit then return 0, "Fruits: Consume 리모트 없음" end
local _a701 = _a18.item.activeBuffs("Fruits")
local _a702 = 0
for _a703, _a704 in ipairs(_a18.item.stacks("Fruit")) do
if _a702 >= (_a700 or 1) then break end
if _a704.am >= 1 and _a18.item.itemAllowed(_a704.id) and not _a701[_a704.id] then
pcall(function() _a16.R_Fruit:FireServer(_a704.uid, 1) end)
_a702 += 1
task.wait(0.4)
end
end
return _a702
end
function _a18.quest.status()
local _a705 = _a45()
if not _a705 then return nil end
local _a706 = rawget(_a705, "Goals")
if type(_a706) ~= "table" then return { list = {} } end
local _a707 = {}
for _a708, _a709 in pairs(_a706) do
if type(_a709) == "table" then
local _a710 = tonumber(rawget(_a709, "Type")) or -1
local _a711
if _a16.Quest and rawget(_a16.Quest, "MakeTitle") then
local _a712, _a713 = pcall(_a16.Quest.MakeTitle, _a709)
if _a712 then _a711 = _a713 end
end
_a707[#_a707 + 1] = {
slot = _a708,
uid = tostring(rawget(_a709, "UID")),
type = _a710,
how = _a17[_a710],
title = _a711 or ("Type " .. _a710),
amount = tonumber(rawget(_a709, "Amount")) or 0,
progress = tonumber(rawget(_a709, "Progress")) or 0,
stars = tonumber(rawget(_a709, "Stars")) or 0,
potionTier = tonumber(rawget(_a709, "PotionTier")),
enchantTier = tonumber(rawget(_a709, "EnchantTier")),
breakable = rawget(_a709, "BreakableType") or rawget(_a709, "BreakableDirID"),
zoneId = rawget(_a709, "ZoneID"),
where = _a18.quest.WHERE[_a710] or (_a17[_a710] == "farm" and "bestzone" or nil),
event = _a18.ev.EVENTKIND[_a710],
chest = _a18.ev.CHESTKIND[_a710],
bestOnly = _a18.ev.BESTONLY[_a710] or false,
ignored = _a18.quest.IGNORE[_a710],
}
end
end
table.sort(_a707, function(_a714, _a715) return _a714.stars > _a715.stars end)
return { list = _a707, rank = tonumber(rawget(_a705, "Rank")) or 1,
rankStars = tonumber(rawget(_a705, "RankStars")) or 0 }
end
_a18.quest.BESTDEP = {
[20]=true, [21]=true, [37]=true, [38]=true, [39]=true,
[43]=true, [44]=true, [76]=true,
}
function _a18.quest.bestDepActive()
local _a716 = _a18.ctl.lockGoal and _a18.ctl.lockGoal.q
if not _a716 then return false end
if _a18.quest.IGNORE[_a716.type] then return false end
if not _a18.quest.BESTDEP[_a716.type] then return false end
local _a717 = _a18.quest.findQuest(_a716.uid)
if not _a717 or _a717.progress >= _a717.amount then return false end
return true, _a717
end
function _a18.quest.canDo(_a718, _a719)
if _a718.how == "hatch" or _a718.where == "bestegg" then
local _a720 = _a118()
if not _a720 then return false, "알 정보를 못 읽음" end
if not _a720.price then return true end
if not _a719 then
if _a720.canBuy < 1 then
return false, ("돈 부족 — %s 개당 %s %s / 보유 %s"):format(
tostring(_a720.id), _a6(_a720.price, 0), tostring(_a720.currency), _a6(_a720.have, 0))
end
return true
end
local _a721 = math.max(1, (_a718.amount or 1) - (_a718.progress or 0))
local _a722 = _a721
if _a718.type == 2 or _a718.type == 42 or _a718.type == 47 then
_a722 = math.max(_a721, _a11.HatchMinAfford or 10)
end
if _a720.canBuy < _a722 then
_a18.quest.moneyUntil = os.clock() + math.max(0, _a11.MoneyDwell or 60)
return false, ("돈 모으는 중 — %d개분 필요 / 지금 %d개분 (개당 %s %s)"):format(
_a722, _a720.canBuy, _a6(_a720.price, 0), tostring(_a720.currency))
end
if _a18.quest.moneyUntil and os.clock() < _a18.quest.moneyUntil then
return false, ("조금 더 벌고 감 (%.0f초 남음)"):format(_a18.quest.moneyUntil - os.clock())
end
_a18.quest.moneyUntil = nil
end
return true
end
function _a18.quest.findQuest(_a723)
local _a724 = _a18.quest.status()
for _a725, _a726 in ipairs(_a724 and _a724.list or {}) do
if _a726.uid == _a723 then return _a726 end
end
return nil
end
function _a18.quest.pursue(_a727)
local _a728, _a729
if _a727.how == "hatch" then _a728, _a729 = _a129, "mhatch"
elseif _a727.how == "zone" then _a728, _a729 = _a88, "zone"
elseif _a727.how == "gold" or _a727.how == "rainbow" then
local _a730 = (_a727.type == 40 or _a727.type == 41)
_a729 = "quest"
_a728 = function()
local _a731 = _a18.item.makeVariant("gold", _a730) or 0
if _a727.how == "rainbow" then
_a731 += (_a18.item.makeVariant("rainbow", _a730) or 0)
end
if _a731 > 0 then
_a18.ctl.setAct(_a727.how == "gold" and "골드 합성" or "레인보우 합성", _a731 .. "마리")
return
end
_a18.ctl.setAct("재료 모으는 중", "최고 알 부화")
local _a732 = _a12.mhatch
_a12.mhatch = true
pcall(_a129)
_a12.mhatch = _a732
end
end
local _a733 = _a727.progress
local _a734 = os.clock()
_a18.ctl.setGoal(_a727.title, ("%d/%d"):format(_a727.progress, _a727.amount))
local function _a735()
if not _a727.event then return end
local _a736 = _a18.ev.findEvent(_a727.event, _a727.bestOnly)
if _a736 then
_a18.ctl.setAct(_a727.event .. " 진행 중", ("%d초 남음"):format(_a736.left))
if _a736.pos then
local _a737 = _a18.move.hrp()
if _a737 and (_a737.Position - _a736.pos).Magnitude > (_a11.EventStayDist or 45) then
_a18.move.glideTo(_a736.pos)
end
end
return
end
local _a738, _a739 = _a18.ev.spawnEvent(_a727.event)
if _a738 > 0 then
_a18.ctl.setAct("소환", _a727.event)
task.wait(0.5)
elseif _a739 and _a18.ev.spawnErr ~= tostring(_a739) then
_a18.ev.spawnErr = tostring(_a739)
_a5("[퀘스트] " .. _a727.event .. " 소환 실패: " .. tostring(_a739))
end
end
local _a740, _a741 = pcall(function()
while _a12.quest and not _a18.ctl.stopped() do
local _a742, _a743 = _a18.quest.canDo(_a727, false)
if not _a742 then
_a5(("[퀘스트] %s → 다른 퀘스트 먼저 (%s)"):format(tostring(_a727.title), tostring(_a743)))
return
end
_a735()
if _a728 then
local _a744 = _a12[_a729]
_a12[_a729] = true
local _a745, _a746 = pcall(_a728)
_a12[_a729] = _a744
if not _a745 then error(_a746, 0) end
elseif _a727.event then
task.wait(0.4)
else
task.wait(2)
end
local _a747 = _a18.quest.findQuest(_a727.uid)
if not _a747 then
_a5("[퀘스트] 완료 — " .. tostring(_a727.title))
return
end
_a18.ctl.setGoal(_a747.title, ("%d/%d"):format(_a747.progress, _a747.amount))
if _a747.progress >= _a747.amount then
_a5(("[퀘스트] 달성 %d/%d — %s"):format(_a747.progress, _a747.amount, tostring(_a747.title)))
return
end
if _a747.progress > _a733 then
_a734 = os.clock()
_a5(("[퀘스트] %d/%d  %s"):format(_a747.progress, _a747.amount, tostring(_a747.title)))
end
_a733 = _a747.progress
local _a748 = os.clock() - _a734
if _a748 >= math.max(10, _a11.PursueStallSec or 60) then
_a5(("[퀘스트] %.0f초째 진행 없음 (%d/%d) — 다음 단계로: %s"):format(
_a748, _a747.progress, _a747.amount, tostring(_a747.title)))
return
end
task.wait(0.2)
end
end)
if not _a740 then _a5("[퀘스트] " .. tostring(_a727.how) .. " 오류: " .. tostring(_a741)) end
_a18.ctl.lockGoal = nil
_a18.ctl.setGoal(nil)
end
function _a18.quest.cycle()
do
local _a749 = _a12.rank
_a12.rank = true
pcall(_a180)
_a12.rank = _a749
end
local _a750 = _a18.quest.status()
if not _a750 then return end
local _a751, _a752, _a753 = false, false, false
local _a754 = {}
local _a755 = nil
for _a756, _a757 in ipairs(_a750.list) do
if not _a12.quest then break end
local _a758, _a759 = true, nil
if not _a757.ignored and _a757.progress < _a757.amount then
_a758, _a759 = _a18.quest.canDo(_a757, true)
end
if _a757.ignored then
if _a757.progress < _a757.amount then
_a754[#_a754 + 1] = tostring(_a757.title) .. "  — " .. _a757.ignored
end
elseif not _a758 then
local _a760 = tostring(_a757.uid) .. tostring(_a759)
if _a18.item.skipSaid ~= _a760 then
_a18.item.skipSaid = _a760
_a5(("[퀘스트] 건너뜀: %s   (%s)"):format(tostring(_a757.title), tostring(_a759)))
end
elseif _a757.progress < _a757.amount then
local _a761 = _a757.where
if _a757.event then
if not _a755 or _a755.rank > 0 then _a755 = { rank = 0, kind = "event", q = _a757 } end
elseif _a757.chest then
if not _a755 or _a755.rank > 1 then _a755 = { rank = 1, kind = "chest", q = _a757 } end
elseif _a761 == "bestegg" then
if not _a755 or _a755.rank > 1 then _a755 = { rank = 1, kind = "egg", q = _a757 } end
elseif _a761 == "breakable" and _a757.breakable then
if not _a755 or _a755.rank > 2 then _a755 = { rank = 2, kind = "breakable", q = _a757 } end
elseif _a761 == "zoneid" and _a757.zoneId then
if not _a755 or _a755.rank > 2 then _a755 = { rank = 2, kind = "zoneid", q = _a757 } end
elseif _a761 == "bestzone" or _a761 == "breakable" then
if not _a755 then _a755 = { rank = 3, kind = "bestzone", q = _a757 } end
end
if _a757.how == "farm" then
_a751 = true
elseif _a757.how == "hatch" then
_a752 = true
elseif _a757.how == "zone" then
_a753 = true
elseif _a757.how == "potup" and _a11.QuestUpgrade then
local _a762, _a763 = _a18.item.upgradeTo("Potion", _a757.potionTier or 2)
if _a762 > 0 then
_a13.potup += _a762
_a13.quest += 1
_a5(("[퀘스트] 포션 T%d %d개 제작  (%s)"):format(_a757.potionTier or 2, _a762, _a757.title))
elseif _a763 and not tostring(_a763):find("부족") then
if _a18.item.potUpSaid ~= tostring(_a763) then
_a18.item.potUpSaid = tostring(_a763)
_a5("[퀘스트] 포션 업글 실패: " .. tostring(_a763))
end
end
elseif _a757.how == "encup" and _a11.QuestUpgrade then
local _a764, _a765 = _a18.item.upgradeTo("Enchant", _a757.enchantTier or 2)
if _a764 > 0 then
_a13.potup += _a764
_a13.quest += 1
_a5(("[퀘스트] 인챈트 T%d %d개 제작  (%s)"):format(_a757.enchantTier or 2, _a764, _a757.title))
elseif _a765 and not tostring(_a765):find("부족") then
if _a18.item.encUpSaid ~= tostring(_a765) then
_a18.item.encUpSaid = tostring(_a765)
_a5("[퀘스트] 인챈트 업글 실패: " .. tostring(_a765))
end
end
elseif _a757.how == "potuse" and _a11.QuestUsePotion then
_a18.item.lastUse = _a18.item.lastUse or {}
local _a766 = _a18.item.lastUse[_a757.uid]
if _a766 and _a766.used > 0 and _a757.progress <= _a766.progress then
if not _a766.gaveUp then
_a766.gaveUp = true
_a5("[퀘스트] 포션을 마셔도 진행도가 안 올라서 중단: " .. tostring(_a757.title))
end
else
local _a767 = math.min(_a11.QuestUseMax, math.max(1, _a757.amount - _a757.progress))
local _a768, _a769 = _a18.item.usePotion(_a757.potionTier or 1, _a767)
_a18.item.lastUse[_a757.uid] = { used = _a768, progress = _a757.progress }
if _a768 > 0 then
_a13.potuse += _a768
_a13.quest += 1
_a5(("[퀘스트] 포션 %d개 사용  (%s)"):format(_a768, _a757.title))
elseif _a769 and not tostring(_a769):find("없음") then
_a5("[퀘스트] 포션 사용 실패: " .. tostring(_a769))
end
end
elseif _a757.how == "gold" or _a757.how == "rainbow" then
local _a770, _a771 = _a18.item.makeVariant(_a757.how, _a757.type == 40 or _a757.type == 41)
if _a770 > 0 then
_a13.quest += 1
_a5(("[퀘스트] %s 펫 %d마리 제작  (%s)"):format(
_a757.how == "gold" and "골드" or "레인보우", _a770, _a757.title))
elseif _a771 then
_a5("[퀘스트] " .. _a757.how .. " 실패: " .. tostring(_a771))
end
elseif _a757.how == "fruituse" then
local _a772 = _a18.item.useFruit(math.max(1, _a757.amount - _a757.progress))
if _a772 > 0 then
_a13.quest += 1
_a5(("[퀘스트] 과일 %d개 사용  (%s)"):format(_a772, _a757.title))
end
elseif _a757.how == "flaguse" then
local _a773, _a774 = _a18.item.useFlag(math.max(1, _a757.amount - _a757.progress))
if _a773 > 0 then
_a13.quest += 1
_a5(("[퀘스트] 깃발 %d개 사용  (%s)"):format(_a773, _a757.title))
elseif _a774 then
_a5("[퀘스트] 깃발 실패: " .. tostring(_a774))
end
elseif not _a757.how then
_a754[#_a754 + 1] = _a757.title
end
end
end
if _a11.QuestLock and _a18.ctl.lockGoal then
local _a775
for _a776, _a777 in ipairs(_a750.list) do
if _a777.uid == _a18.ctl.lockGoal.q.uid and _a777.progress < _a777.amount then _a775 = _a777 break end
end
if _a775 then
_a18.ctl.lockGoal.q = _a775
_a755 = _a18.ctl.lockGoal
else
if _a18.ctl.lockGoal.q then
_a5("[퀘스트] 완료/교체됨 → 다음 목표로: " .. tostring(_a18.ctl.lockGoal.q.title))
end
_a18.ctl.lockGoal = nil
end
end
if _a11.QuestLock and _a755 then _a18.ctl.lockGoal = _a755 end
if _a11.QuestTp and _a755 and _a12.quest then
local _a778, _a779, _a780
if _a755.kind == "event" then
local _a781 = _a18.ev.findEvent(_a755.q.event, _a755.q.bestOnly)
if _a781 then
_a780 = ("%s @%s (%d초 남음)"):format(_a781.name, tostring(_a781.zone), _a781.left)
if _a781.pos then _a778, _a779 = _a18.move.glideTo(_a781.pos)
else _a778, _a779 = _a18.move.goToZone(_a781.zone) end
else
local _a782 = _a755.q.bestOnly and _a18.move.bestZone() or (_a18.move.curZone() or _a18.move.bestZone())
_a780 = _a755.q.event .. " 소환용 " .. tostring(_a782)
local _a783 = _a18.move.inDottedBox()
_a778, _a779 = _a18.move.goToZone(_a782, false, _a783 == false, _a755.q.bestOnly)
if _a778 then
local _a784, _a785 = _a18.ev.spawnEvent(_a755.q.event)
if _a784 < 1 and tostring(_a785):find("점선") then
_a18.move.goToZone(_a782, false, true)
task.wait(0.2)
_a784, _a785 = _a18.ev.spawnEvent(_a755.q.event)
end
if _a784 > 0 then
_a780 = ("%s %d개 소환 @%s"):format(_a755.q.event, _a784, tostring(_a782))
else
_a779 = _a785
_a778 = false
end
end
end
elseif _a755.kind == "chest" then
local _a786 = _a755.q.bestOnly and _a18.move.bestZone() or _a18.move.curZone()
local _a787, _a788 = _a18.ev.findChest(_a755.q.chest, _a786)
_a780 = _a755.q.chest .. " @" .. tostring(_a786)
if _a787 then
if not _a788 or _a788 > 20 then _a18.move.glideTo(_a787) end
_a778 = true
else
_a778, _a779 = _a18.move.goToZone(_a786)
_a780 = _a780 .. " (상자 없음 → 존 가운데)"
end
elseif _a755.kind == "egg" then
local _a789 = _a93()
_a780 = "최고 알 " .. tostring(_a789)
if _a789 then _a778, _a779 = _a18.egg.tpEgg(_a789) else _a779 = "최고 알을 못 찾음" end
elseif _a755.kind == "breakable" then
local _a790 = _a18.move.zoneForBreakable(_a755.q.breakable)
_a780 = tostring(_a755.q.breakable) .. " 나오는 존 " .. tostring(_a790)
if _a790 then _a778, _a779 = _a18.move.goToZone(_a790, true) else _a779 = "그 브레이커블이 나오는 존이 없음" end
elseif _a755.kind == "zoneid" then
_a780 = "존 " .. tostring(_a755.q.zoneId)
_a778, _a779 = _a18.move.goToZone(_a755.q.zoneId)
else
local _a791 = _a18.move.bestZone()
local _a792 = _a755.q.bestOnly or _a18.quest.BESTDEP[_a755.q.type] or false
if _a791 then _a778, _a779 = _a18.move.goToZone(_a791, true, false, _a792)
else _a779 = "최고 존을 못 찾음" end
_a780 = "최고 존 " .. tostring(_a18.move.arrivedZone or _a791)
if not _a778 then _a779 = _a791 end
end
if _a778 then
if _a18.quest.lastGoal ~= _a780 then
_a18.quest.lastGoal = _a780
_a5("[퀘스트] " .. _a780 .. " 으로 이동  (" .. tostring(_a755.q.title) .. ")")
end
_a18.quest.pursue(_a755.q)
else
local _a793 = _a779 and tostring(_a779) or "이유 불명"
if _a18.quest.lastFail ~= _a793 then
_a18.quest.lastFail = _a793
_a5(("[퀘스트] 진행 못 함: %s   (%s / %s)"):format(
_a793, tostring(_a755.kind), tostring(_a755.q.title)))
_a5(("           현재 존 %s / 최고 존 %s / 점선네모 %s"):format(
tostring(_a18.move.curZone()), tostring(_a18.move.bestZone()), tostring(_a18.move.inDottedBox())))
end
end
end
if _a11.QuestDrive and _a18.auto.turnOn then
if _a751  then _a18.auto.turnOn("farm",   "파밍 퀘스트 → 자동 파밍") end
if _a753  then _a18.auto.turnOn("zone",   "존 퀘스트 → 자동 존 해금") end
if _a752 then _a18.auto.turnOn("mhatch", "부화 퀘스트 → 자동 부화") end
end
if #_a754 > 0 and not _a18.quest.manualWarned then
_a18.quest.manualWarned = true
_a5("[퀘스트] 수동으로 해야 하는 것:")
for _a794, _a795 in ipairs(_a754) do _a5("    · " .. tostring(_a795)) end
elseif #_a754 == 0 then
_a18.quest.manualWarned = false
end
return _a755 ~= nil
end
local function _a796(_a797)
local _a798 = {}
for _a799 in tostring(_a797 or ""):gmatch("[^,]+") do
_a799 = _a799:match("^%s*(.-)%s*$")
if _a799 ~= "" then _a798[#_a798 + 1] = _a799:lower() end
end
return _a798
end
function _a18.item.itemAllowed(_a800)
local _a801 = tostring(_a800):lower()
for _a802, _a803 in ipairs(_a796(_a11.ItemBlock)) do
if _a801:find(_a803, 1, true) then return false end
end
local _a804 = _a796(_a11.ItemAllow)
if #_a804 == 0 then return true end
for _a805, _a806 in ipairs(_a804) do
if _a801:find(_a806, 1, true) then return true end
end
return false
end
function _a18.item.activeBuffs(_a807)
local _a808 = _a45()
local _a809 = _a808 and rawget(_a808, _a807)
local _a810 = {}
if type(_a809) == "table" then
for _a811, _a812 in pairs(_a809) do
if type(_a812) == "table" and next(_a812) then _a810[_a811] = true
elseif _a812 then _a810[_a811] = true end
end
end
return _a810
end
local function _a813(_a814, _a815, _a816, _a817)
local _a818 = _a18.item.activeBuffs(_a815)
local _a819 = {}
local _a820 = { total = 0, act = 0, blocked = 0, few = 0, ok = 0 }
for _a821, _a822 in ipairs(_a18.item.stacks(_a814)) do
_a820.total += 1
if _a818[_a822.id] then _a820.act += 1
elseif not _a18.item.itemAllowed(_a822.id) then _a820.blocked += 1
elseif _a822.am <= _a11.ItemKeep then _a820.few += 1
else
_a820.ok += 1
local _a823 = _a819[_a822.id]
local _a824
if not _a823 then _a824 = true
elseif _a11.BuffHighTier then _a824 = _a822.tier > _a823.tier
else _a824 = _a822.tier < _a823.tier end
if _a824 then _a819[_a822.id] = _a822 end
end
end
if _a820.ok == 0 and _a820.total > 0 then
local _a825 = ("%s %d종 중 사용 가능 0 (이미걸림 %d / 제외 %d / 재고부족 %d)")
:format(_a814, _a820.total, _a820.act, _a820.blocked, _a820.few)
if _a18.item.buffSaid ~= _a825 then
_a18.item.buffSaid = _a825
_a5("[아이템] " .. _a825)
end
elseif _a820.ok > 0 then
_a18.item.buffSaid = nil
end
local _a826 = {}
for _a827, _a828 in pairs(_a819) do _a826[#_a826 + 1] = _a828 end
table.sort(_a826, function(_a829, _a830)
if _a829.tier ~= _a830.tier then return _a829.tier > _a830.tier end
return _a829.am > _a830.am
end)
local _a831 = {}
for _a832, _a833 in ipairs(_a826) do
if not _a12.items then break end
if _a817 and _a817.left <= 0 then break end
local _a834 = pcall(function() _a816(_a833.uid, 1) end)
if _a834 then
_a831[#_a831 + 1] = ("%s T%d"):format(_a833.id, _a833.tier)
_a13.items += 1
if _a817 then _a817.left -= 1 end
task.wait(0.12)
end
end
return _a831
end
function _a18.item.cycleItems()
local function _a835()
local _a836 = {}
if _a11.BuffPotion then _a836[#_a836 + 1] = { "Potion", "Potions" } end
if _a11.BuffFruit then _a836[#_a836 + 1] = { "Fruit", "Fruits" } end
if _a11.BuffConsumable then _a836[#_a836 + 1] = { "Consumable", "Consumables" } end
for _a837, _a838 in ipairs(_a836) do
local _a839 = _a18.item.activeBuffs(_a838[2])
for _a840, _a841 in ipairs(_a18.item.stacks(_a838[1])) do
if _a841.am > _a11.ItemKeep and _a18.item.itemAllowed(_a841.id) and not _a839[_a841.id] then
return true
end
end
end
if _a11.BuffUltimate and _a16.R_Ult then
local _a842 = _a45()
local _a843 = _a842 and rawget(_a842, "Ultimates")
if type(_a843) == "table" then
for _a844 in pairs(_a843) do
if _a18.item.itemAllowed(_a844) then
if not (_a16.Ult and rawget(_a16.Ult, "IsCharged")) then return true end
local _a845, _a846 = pcall(_a16.Ult.IsCharged, _a844)
if _a845 and _a846 then return true end
end
end
end
end
return false
end
if not _a835() then return end
if _a11.ItemBestZone then
local _a847 = _a18.move.bestZone()
if _a847 and _a18.move.curZone() ~= _a847 then
if not _a11.ItemTp then
if not _a18.item.itemZoneWarned then
_a18.item.itemZoneWarned = true
_a5(("[아이템] 최고 존(%s)이 아니라 대기 — 현재 %s"):format(
tostring(_a847), tostring(_a18.move.curZone())))
end
return
end
local _a848, _a849 = _a18.move.goToZone(_a847)
if not _a848 then
_a5("[아이템] 최고 존 이동 실패: " .. tostring(_a849))
return
end
_a5("[아이템] 최고 존 " .. tostring(_a847) .. " 에서 사용")
end
_a18.item.itemZoneWarned = false
end
local _a850 = {}
local _a851  = { left = math.max(1, _a11.BuffMaxPotion or 5) }
local _a852 = { left = math.max(1, _a11.BuffMaxOther or 2) }
if _a11.BuffPotion and _a16.R_PotUse then
local _a853 = _a813("Potion", "Potions", function(_a854, _a855)
_a16.R_PotUse:FireServer(_a854, _a855)
end, _a851)
for _a856, _a857 in ipairs(_a853) do _a850[#_a850 + 1] = "포션 " .. _a857 end
end
if _a11.BuffFruit and _a16.R_Fruit then
local _a858 = _a813("Fruit", "Fruits", function(_a859, _a860)
_a16.R_Fruit:FireServer(_a859, _a860)
end, _a852)
for _a861, _a862 in ipairs(_a858) do _a850[#_a850 + 1] = "과일 " .. _a862 end
end
if _a11.BuffConsumable and _a16.R_Cons then
local _a863 = _a813("Consumable", "Consumables", function(_a864, _a865)
_a16.R_Cons:InvokeServer(_a864, _a865)
end, _a852)
for _a866, _a867 in ipairs(_a863) do _a850[#_a850 + 1] = "소모품 " .. _a867 end
end
if _a11.BuffUltimate and _a16.R_Ult then
local _a868 = _a45()
local _a869 = _a868 and rawget(_a868, "Ultimates")
if type(_a869) == "table" then
for _a870 in pairs(_a869) do
if not _a12.items then break end
if _a18.item.itemAllowed(_a870) then
local _a871 = true
if _a16.Ult and rawget(_a16.Ult, "IsCharged") then
local _a872, _a873 = pcall(_a16.Ult.IsCharged, _a870)
_a871 = _a872 and _a873 and true or false
end
if _a871 then
local _a874
pcall(function() _a874 = _a16.R_Ult:InvokeServer(_a870) end)
if _a874 then
_a850[#_a850 + 1] = "얼티밋 " .. tostring(_a870)
_a13.items += 1
task.wait(0.3)
end
end
end
end
end
end
if #_a850 > 0 then
_a18.ctl.setAct("버프 사용", table.concat(_a850, ", "))
_a5("[아이템] " .. table.concat(_a850, ", ") .. " 사용")
end
end
function _a18.mach.slotStatus()
local _a875 = _a45()
if not _a875 then return nil end
local _a876 = tonumber(rawget(_a875, "PetSlotsPurchased")) or 0
local _a877 = tonumber(rawget(_a875, "EggSlotsPurchased")) or 0
local _a878, _a879 = 0, 0
if _a16.RankC then
if rawget(_a16.RankC, "GetMaxPurchasableEquipSlots") then
local _a880, _a881 = pcall(_a16.RankC.GetMaxPurchasableEquipSlots)
if _a880 and tonumber(_a881) then _a878 = tonumber(_a881) end
end
if rawget(_a16.RankC, "GetMaxPurchasableEggSlots") then
local _a882, _a883 = pcall(_a16.RankC.GetMaxPurchasableEggSlots)
if _a882 and tonumber(_a883) then _a879 = tonumber(_a883) end
end
end
local _a884, _a885
if _a876 < _a878 then
_a884 = _a876 + 1
if type(_a16.CalcPetS) == "function" then
local _a886, _a887 = pcall(_a16.CalcPetS, _a884)
if _a886 then _a885 = tonumber(_a887) end
end
end
local _a888, _a889, _a890
if _a877 < _a879 and _a16.RankC and rawget(_a16.RankC, "GetEggBundle") then
local _a891, _a892, _a893 = pcall(_a16.RankC.GetEggBundle, _a877 + 1)
if _a891 and tonumber(_a892) then
_a888, _a889 = tonumber(_a892), tonumber(_a893) or 1
if type(_a16.CalcEggS) == "function" then
local _a894, _a895 = 0, false
for _a896 = _a888 - _a889 + 1, _a888 do
local _a897, _a898 = pcall(_a16.CalcEggS, _a896)
if _a897 and tonumber(_a898) then _a894 += tonumber(_a898) else _a895 = true end
end
if not _a895 then _a890 = _a894 end
end
end
end
local _a899
if _a16.Egg and rawget(_a16.Egg, "GetMaxHatch") then
local _a900, _a901 = pcall(_a16.Egg.GetMaxHatch)
if _a900 then _a899 = tonumber(_a901) end
end
return {
dia = _a60("Diamonds"),
petOwned = _a876, petMax = _a878, petNext = _a884, petCost = _a885,
eggOwned = _a877, eggMax = _a879, eggEnd = _a888, eggSize = _a889, eggCost = _a890,
maxEquip = tonumber(rawget(_a875, "MaxPetsEquipped")), maxHatch = _a899,
}
end
function _a18.move.machinePos(_a902)
local _a903
if _a16.Machine and rawget(_a16.Machine, "GetModels") then
local _a904, _a905 = pcall(_a16.Machine.GetModels, _a902)
if _a904 and type(_a905) == "table" then
for _a906, _a907 in pairs(_a905) do
if typeof(_a907) == "Instance" then _a903 = _a907 break end
end
end
end
if not _a903 then
local _a908, _a909 = pcall(function()
return game:GetService("CollectionService"):GetTagged("Machine")
end)
if _a908 then
for _a910, _a911 in ipairs(_a909) do
if _a911.Name == _a902 then _a903 = _a911 break end
end
end
end
if not _a903 then return nil end
if _a903:IsA("BasePart") then return _a903.Position end
local _a912, _a913 = pcall(function() return _a903:GetPivot() end)
return (_a912 and typeof(_a913) == "CFrame") and _a913.Position or nil
end
function _a18.mach.cycleSlots()
local _a914 = 0
local _a915 = 0
while _a12.slots and not _a18.ctl.stopped() and _a915 < 40 do
_a915 += 1
local _a916 = _a18.mach.slotStatus()
if not _a916 then return end
local _a917 = _a11.SlotPet and _a916.petNext and _a916.petCost
and (_a916.dia - _a11.SlotReserve) >= _a916.petCost
local _a918 = _a11.SlotEgg and _a916.eggEnd and _a916.eggCost
and (_a916.dia - _a11.SlotReserve) >= _a916.eggCost
if _a917 and _a918 then
if _a916.eggCost < _a916.petCost then _a917 = false else _a918 = false end
end
if not (_a917 or _a918) then break end
local _a919, _a920, _a921, _a922
local function _a923()
if _a917 then
pcall(function() _a919, _a920 = _a16.R_PetSlot:InvokeServer(_a916.petNext) end)
else
pcall(function() _a919, _a920 = _a16.R_EggSlot:InvokeServer(_a916.eggEnd) end)
end
end
if _a917 then
_a921 = ("펫 장착 슬롯 #%d (%s 다이아)"):format(_a916.petNext, _a6(_a916.petCost, 0))
_a922 = "EquipSlotsMachine"
else
_a921 = ("알 부화 슬롯 %d칸 → %d (%s 다이아)"):format(
_a916.eggSize, _a916.eggEnd, _a6(_a916.eggCost, 0))
_a922 = "EggSlotsMachine"
end
_a923()
if not _a919 and tostring(_a920):find("far away") then
local _a924 = _a18.move.machinePos(_a922)
if _a924 then
_a18.ctl.setAct("슬롯 머신으로 이동", _a922)
_a18.move.glideTo(_a924)
task.wait(0.25)
_a919, _a920 = nil, nil
_a923()
else
_a920 = "머신 위치를 못 찾음 (" .. _a922 .. ")"
end
end
if _a919 then
_a914 += 1
_a13.mslot += 1
_a18.mach.slotSaid = nil
_a18.ctl.setAct("슬롯 구매", _a921)
_a5("  ⬆ " .. _a921)
task.wait(0.35)
else
local _a925 = _a921 .. " 실패: " .. tostring(_a920)
if _a18.mach.slotSaid ~= _a925 then
_a18.mach.slotSaid = _a925
_a5("[슬롯] " .. _a925)
end
break
end
end
if _a914 > 0 then
local _a926 = _a18.mach.slotStatus()
_a5(("[슬롯] %d개 구매 — 장착 %s / 한번에 %s개 부화 (다이아 %s 남음)"):format(
_a914, tostring(_a926 and _a926.maxEquip), tostring(_a926 and _a926.maxHatch),
_a6(_a60("Diamonds"), 0)))
end
end
function _a18.mach.upgList()
local _a927 = {}
if not _a16.Upg then return _a927 end
local _a928, _a929 = pcall(_a16.Upg.All)
if not (_a928 and type(_a929) == "table") then return _a927 end
for _a930, _a931 in ipairs(_a929) do
local _a932, _a933, _a934 = rawget(_a931, "UpgradeID"), rawget(_a931, "ZoneID"), rawget(_a931, "UpgradeTier")
if _a932 and _a933 and _a934 then
local _a935 = false
if rawget(_a16.Upg, "Owns") then
local _a936, _a937 = pcall(_a16.Upg.Owns, _a932, _a933)
_a935 = _a936 and _a937 and true or false
end
local _a938 = _a18.move.ownsZone(_a933)
local _a939 = _a16.DirUpg and rawget(_a16.DirUpg, _a932)
local _a940 = _a939 and rawget(_a939, "TierCosts")
local _a941 = _a940 and tonumber(_a940[_a934])
local _a942 = "Diamonds"
local _a943 = _a939 and rawget(_a939, "TierCurrencies")
local _a944 = _a943 and _a943[_a934]
if type(_a944) == "table" and rawget(_a944, "_id") then _a942 = rawget(_a944, "_id") end
local _a945 = rawget(_a931, "Model")
local _a946
if typeof(_a945) == "Instance" then
if _a945:IsA("BasePart") then _a946 = _a945.Position
else
local _a947, _a948 = pcall(function() return _a945:GetPivot() end)
if _a947 and _a948 then _a946 = _a948.Position end
end
end
_a927[#_a927 + 1] = {
id = _a932, zone = _a933, tier = _a934, cost = _a941, cur = _a942,
bought = _a935, zoneOwned = _a938,
buyable = _a938 and not _a935,
pos = _a946, model = _a945,
}
end
end
table.sort(_a927, function(_a949, _a950) return (_a949.cost or math.huge) < (_a950.cost or math.huge) end)
return _a927
end
function _a18.mach.cycleUpg()
if not _a16.R_Upg then _a5("[맵업글] Upgrades_Purchase 리모트 없음") return end
local _a951 = _a18.mach.upgList()
if #_a951 == 0 then return end
local _a952 = 0
for _a953, _a954 in ipairs(_a951) do
if not _a12.mapupg then break end
if _a954.buyable and _a954.cost then
local _a955 = _a60(_a954.cur or "Diamonds")
if _a955 - _a11.UpgReserve < _a954.cost then break end
if _a11.UpgTp and _a954.pos and _a954.zone == _a18.move.curZone() then
_a18.move.glideTo(_a954.pos)
end
local _a956, _a957
pcall(function() _a956, _a957 = _a16.R_Upg:InvokeServer(_a954.id, _a954.zone) end)
if _a956 then
_a952 += 1
_a13.mapupg += 1
_a18.ctl.setAct("맵 업글", _a954.id .. " T" .. _a954.tier)
_a5(("  ▲ 맵업글  %s T%d  @%s   (%s 다이아)"):format(
_a954.id, _a954.tier, _a954.zone, _a6(_a954.cost, 0)))
elseif _a957 then
_a5(("[맵업글] %s T%d @%s 실패: %s"):format(
_a954.id, _a954.tier, _a954.zone, tostring(_a957)))
end
task.wait(_a11.ActionGap)
end
end
if _a952 > 0 then
_a5(("[맵업글] %d개 구매  (다이아 %s 남음)"):format(_a952, _a6(_a60("Diamonds"), 0)))
end
end
local function _a958()
local _a959 = _a45()
if not _a959 then return nil end
local _a960 = tonumber(rawget(_a959, "Rebirths")) or 0
local _a961 = _a960 + 1
local _a962
if _a16.Rebirth and rawget(_a16.Rebirth, "GetNextRebirth") then
local _a963, _a964 = pcall(_a16.Rebirth.GetNextRebirth, _a959)
if _a963 then _a962 = _a964 end
end
return { current = _a960, nextN = _a961, def = _a962 }
end
local function _a965()
if not _a16.R_Reb then _a5("[리버스] Rebirth_Request 리모트 없음") return end
local _a966 = _a958()
if not _a966 then
_a18.auto.rebNote = "세이브를 못 읽음"
return
end
local _a967, _a968
pcall(function() _a967, _a968 = _a16.R_Reb:InvokeServer(_a966.nextN) end)
if _a967 then
_a13.mreb += 1
_a18.auto.rebNote, _a18.auto.rebSaid = nil, nil
_a5(("  ★ 리버스 %d → %d"):format(_a966.current, _a966.nextN))
task.wait(0.5)
_a18.screen.dismissRewardScreens(25)
else
_a18.auto.rebNote = ("%d → %d : %s"):format(_a966.current, _a966.nextN,
_a968 and tostring(_a968) or "조건 미달 (리버스 킬/존 요구치)")
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
{ key = "mreb",   label = "리버스",  run = "mreb",  fn = function() _a965() end,
hold = true },
{ key = "zone",   label = "존 해금", run = "zone",  fn = function() _a88() end,
hold = true },
{ key = "quest",  label = "랭크 퀘스트+보상", run = "quest", fn = function()
local _a969 = _a12.farm
_a12.farm = true
pcall(_a70)
_a12.farm = _a969
local _a970 = _a18.quest.cycle()
if not _a970 then
local _a971 = _a18.move.bestZone()
if _a971 then
local _a972, _a973 = _a18.move.goToZone(_a971)
if not _a972 then
if _a973 and _a18.auto.idleMoveSaid ~= tostring(_a973) then
_a18.auto.idleMoveSaid = tostring(_a973)
_a5("[자동] 최고 존 이동 실패: " .. tostring(_a973))
end
else
_a18.auto.idleMoveSaid = nil
end
end
if not _a11.IdleHatch then
_a18.ctl.setAct("파밍 중", ("퀘스트 없음 @%s"):format(tostring(_a18.move.curZone())))
return
end
local _a974 = _a118()
local _a975 = math.max(1, _a11.HatchMinAfford or 10)
if _a974 and _a974.price and _a974.canBuy < _a975 then
_a18.ctl.setAct("돈 버는 중", ("%s  %d/%d개분  개당 %s %s"):format(
tostring(_a18.move.curZone()), _a974.canBuy, _a975,
_a6(_a974.price, 0), tostring(_a974.currency)))
else
_a18.ctl.setAct("대기 중 부화")
local _a976 = _a12.mhatch
_a12.mhatch = true
pcall(_a129)
_a12.mhatch = _a976
end
end
end },
}
_a11.StepOn = {}
for _a977, _a978 in ipairs(_a18.auto.SIDE) do _a11.StepOn[_a978.key] = true end
for _a979, _a980 in ipairs(_a18.auto.STEPS) do _a11.StepOn[_a980.key] = true end
local function _a981(_a982, _a983, _a984, _a985)
if not _a11.StepOn[_a982.key] then
_a985[#_a985 + 1] = ("%-14s 꺼져있음"):format(_a982.label)
return
end
if _a982.hold and _a983 then
_a985[#_a985 + 1] = ("%-14s 보류 (%s)"):format(
_a982.label, _a984 and tostring(_a984.title) or "?")
if _a18.auto.heldMsg ~= _a982.key then
_a18.auto.heldMsg = _a982.key
_a5(("[자동] %s 보류 — best 존이 바뀌면 깨지는 퀘스트 진행 중 (%s)"):format(
_a982.label, _a984 and tostring(_a984.title) or "?"))
end
return
end
if _a982.hold then _a18.auto.heldMsg = nil end
_a18.auto.step = _a982.label
_a18.ctl.now.step = _a982.label
_a18.ctl.setAct("시작", _a982.label)
local _a986 = os.clock()
local _a987 = _a12[_a982.run]
_a12[_a982.run] = true
local _a988, _a989 = pcall(_a982.fn)
_a12[_a982.run] = _a987
local _a990 = os.clock() - _a986
if not _a988 then
_a985[#_a985 + 1] = ("%-14s 오류: %s"):format(_a982.label, tostring(_a989))
_a5("[자동] " .. _a982.label .. " 오류: " .. tostring(_a989))
else
local _a991 = (_a982.key == "zone" and _a18.auto.zoneNote)
or (_a982.key == "mreb" and _a18.auto.rebNote) or nil
_a985[#_a985 + 1] = ("%-14s 실행 %.1f초%s"):format(
_a982.label, _a990, _a991 and ("  → " .. _a991) or "")
end
end
function _a18.auto.master()
local _a992 = {}
_a18.auto.lastTrace = _a992
_a18.auto.lastPassAt = os.clock()
if _a18.screen.rewardScreenUp() then
_a992[#_a992 + 1] = "보상 화면 넘기는 중"
_a18.screen.dismissRewardScreens(15)
end
for _a993, _a994 in ipairs(_a18.auto.SIDE) do
if not _a12.auto or _a18.ctl.stopped() then return end
_a981(_a994, false, nil, _a992)
end
local _a995, _a996 = false, nil
if _a11.HoldZoneForQuest then _a995, _a996 = _a18.quest.bestDepActive() end
for _a997, _a998 in ipairs(_a18.auto.STEPS) do
if not _a12.auto or _a18.ctl.stopped() then break end
_a981(_a998, _a995, _a996, _a992)
end
_a18.auto.step = nil
if not _a18.ctl.lockGoal then
_a18.ctl.now.step = "대기"
_a18.ctl.setAct("다음 바퀴 대기", ("%.0f초 주기"):format(_a11.AutoInterval or 5))
end
local _a999 = {}
for _a1000, _a1001 in ipairs(_a992) do _a999[#_a999 + 1] = (_a1001:gsub("[%d%.]+초", "")) end
_a999 = table.concat(_a999, " | ")
if _a999 ~= _a18.auto.lastSig then
_a18.auto.lastSig = _a999
_a5("[자동] 바퀴 " .. (_a18.auto.passN or 0))
for _a1002, _a1003 in ipairs(_a992) do _a5("    " .. _a1003) end
end
_a18.auto.passN = (_a18.auto.passN or 0) + 1
end
local function _a1004()
if not _a10.R_PROMO then _a5("[타워업글] 리모트 없음") return end
local _a1005 = _a14()
if not _a1005 then return end
local _a1006 = _a15(_a1005)
table.sort(_a1006, function(_a1007, _a1008) return (_a1007.dps or 0) > (_a1008.dps or 0) end)
local _a1009, _a1010 = 0, 0
for _a1011, _a1012 in ipairs(_a1006) do
if not _a12.towerup then break end
if _a1012.id then
local _a1013
pcall(function() _a1013 = _a10.R_PROMO:InvokeServer(_a1012.id) end)
if _a1013 ~= nil and _a1013 ~= false then
_a1009 += 1
_a5(("  ▲ 타워업글  %s  Lv%s → Lv%s"):format(tostring(_a1012.kind), tostring(_a1012.up), tostring((_a1012.up or 0) + 1)))
_a1010 = 0
task.wait(_a11.ActionGap)
else
_a1010 += 1
if _a1010 >= 5 then break end
end
end
end
_a5("[타워업글] " .. _a1009 .. "건")
end
local _a1014 = {}
local _a1015 = {}
local function _a1016(_a1017, _a1018)
local _a1019 = tostring(_a1018)
local _a1020 = _a1015[_a1017]
if _a1020 and _a1020.msg == _a1019 then
_a1020.n += 1
if _a1020.n % 20 == 0 then
_a5(("[%s 오류] %s   (%d회 반복)"):format(_a1017, _a1019, _a1020.n))
end
return
end
_a1015[_a1017] = { msg = _a1019, n = 1 }
_a5("[" .. _a1017 .. " 오류] " .. _a1019)
end
local function _a1021(_a1022, _a1023, _a1024, _a1025)
_a1014[_a1022] = (_a1014[_a1022] or 0) + 1
local _a1026 = _a1014[_a1022]
task.spawn(function()
while _a12[_a1022] and _a1014[_a1022] == _a1026 do
local _a1027, _a1028 = pcall(_a1024)
if not _a1027 then _a1016(_a1025, _a1028) else _a1015[_a1025] = nil end
local _a1029, _a1030 = _a1023(), 0
while _a1030 < _a1029 and _a12[_a1022] and _a1014[_a1022] == _a1026 do task.wait(0.1) _a1030 += 0.1 end
end
if _a1014[_a1022] == _a1026 then _a5("[" .. _a1025 .. "] 중지") end
end)
end
do
local _a1031 = {
farm   = { function() return _a11.FarmInterval end,      function() _a70() end,      "파밍" },
zone   = { function() return _a11.ZoneInterval end,      function() _a88() end,      "존" },
mhatch = { function() return _a11.MainHatchInterval end, function() _a129() end, "부화" },
}
function _a18.auto.turnOn(_a1032, _a1033)
if _a12.auto then return end
if _a12[_a1032] then return end
local _a1034 = _a1031[_a1032]
if not _a1034 then return end
_a12[_a1032] = true
_a1021(_a1032, _a1034[1], _a1034[2], _a1034[3])
if _a18.auto.refresh then _a18.auto.refresh() end
_a5("[퀘스트] " .. tostring(_a1033) .. " ON")
end
end
_a1.MG, _a1.QS, _a1.saveGet, _a1.currencyAmount, _a1.cycleFarm, _a1.zoneStatus = _a16, _a18, _a45, _a60, _a70, _a84
_a1.cycleZone, _a1.bestMainEgg, _a1.mainHatchStatus, _a1.cycleMainHatch, _a1.mainRebirthStatus, _a1.cycleMainRebirth = _a88, _a93, _a118, _a129, _a958, _a965
_a1.cycleTowerUp, _a1.startLoop = _a1004, _a1021
end
