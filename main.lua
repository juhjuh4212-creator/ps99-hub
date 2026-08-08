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
local _a492, _a493
if _a16.ZonesU and rawget(_a16.ZonesU, "GetTeleportPartLocation") then
local _a494, _a495 = pcall(_a16.ZonesU.GetTeleportPartLocation, _a461)
if _a494 and typeof(_a495) == "CFrame" then _a492, _a493 = _a495.Position, _a495.LookVector end
end
local _a496 = _a18.move.badSpot and _a18.move.badSpot[_a461]
local function _a497(_a498)
if not _a496 then return false end
for _a499, _a500 in ipairs(_a496) do
if (_a500 - _a498).Magnitude <= 60 then return true end
end
return false
end
local _a501, _a502, _a503, _a504
for _a505, _a506 in ipairs(_a475) do
if not _a497(_a506.p) then
local _a507 = 0
for _a508, _a509 in ipairs(_a465) do
if (_a509 - _a506.p).Magnitude <= 150 then _a507 += 1 end
end
local _a510
if _a492 then
local _a511 = _a506.p - _a492
local _a512 = _a511.Magnitude
local _a513 = 0
if _a493 and _a512 > 1 then
local _a514 = (_a511 / _a512):Dot(_a493)
if _a514 > 0.25 then _a513 = 200 end
end
_a510 = _a512 - _a513 - math.min(_a507, 20) * 5
else
_a510 = -_a507
end
if _a507 >= 1 and (not _a504 or _a510 < _a504) then
_a501, _a502, _a503, _a504 = _a506.p, _a507, _a506.why, _a510
end
end
end
local _a515, _a516
if _a501 then
_a515, _a516 = _a501, ("%s (브레이커블 %d개%s)"):format(
tostring(_a503), _a502, _a492 and ", 도착지점 앞" or "")
end
if not _a515 and _a492 then
_a515 = _a493 and (_a492 + _a493 * 40) or _a492
_a516 = "PERSISTENT/Teleport 앞 (스트리밍 대기)"
end
if not _a515 then return nil, "브레이커블 위치를 못 찾음" end
local _a517 = _a18.move.groundY(_a515.X, _a515.Z, _a515.Y)
if _a517 then
_a515 = Vector3.new(_a515.X, _a517, _a515.Z)
_a516 = _a516 .. " +지면"
else
_a515 = Vector3.new(_a515.X, _a515.Y + 5, _a515.Z)
end
return _a515, _a516
end
function _a18.move.goToZone(_a518, _a519, _a520, _a521)
_a518 = _a18.move.realZone(_a518)
if not _a518 then return false, "존 id 없음" end
local _a522, _a523 = _a18.move.zonePos(_a518)
if not _a522 then
if _a11.TpGameFallback and _a18.move.curZone() ~= _a518 then
local _a524, _a525 = _a18.move.tpZone(_a518)
if not _a524 then return false, _a525 end
task.wait(0.3)
_a522, _a523 = _a18.move.zonePos(_a518)
end
if not _a522 then
local _a526, _a527 = _a18.move.resolvableZone(_a518)
if _a526 and _a527 then
if _a521 then
return false, ("%s 가 로드되지 않음"):format(tostring(_a518))
end
_a518, _a522, _a523 = _a526, _a527, "대체 존 " .. tostring(_a526)
else
if _a18.move.zoneFailSaid ~= _a518 then
_a18.move.zoneFailSaid = _a518
_a5(("[TP] %s 좌표 실패: %s (갈 수 있는 존이 없음)"):format(
tostring(_a518), tostring(_a523)))
end
return false, _a523
end
end
end
local _a528 = _a18.move.hrp()
if not _a520 and _a528 and _a18.move.curZone() == _a518 then
local _a529 = _a18.move.inDottedBox()
local _a530
if _a529 ~= nil then
_a530 = _a529
else
_a530 = (_a528.Position - _a522).Magnitude <= (_a11.ZoneArriveDist or 90)
end
if _a530 then
if _a519 then _a5("[TP] 이미 " .. _a518 .. " 사냥터 안에 있음") end
return true
end
end
if _a519 then
_a5(("[TP] %s 내부 좌표 %s → (%.0f, %.0f, %.0f)"):format(
_a518, tostring(_a523), _a522.X, _a522.Y, _a522.Z))
end
local _a531, _a532 = _a18.move.glideTo(_a522)
local _a533 = _a18.move.hrp()
if _a533 and (_a533.Position - _a522).Magnitude > math.max(40, _a11.ArriveDist or 12) then
task.wait(0.2)
_a18.ctl.moving = nil
_a18.move.glideTo(_a522)
local _a534 = _a18.move.hrp()
local _a535 = _a534 and (_a534.Position - _a522).Magnitude or -1
if _a535 > math.max(40, _a11.ArriveDist or 12) then
local _a536 = _a11.TpMode
_a11.TpMode = "glide"
_a18.ctl.moving = nil
_a18.move.glideTo(_a522)
_a11.TpMode = _a536
local _a537 = _a18.move.hrp()
_a535 = _a537 and (_a537.Position - _a522).Magnitude or -1
if _a535 > math.max(40, _a11.ArriveDist or 12) then
_a5(("[TP] %s 이동 실패 — %.0f스터드 남음 (순간이동·glide 둘 다)"):format(
tostring(_a518), _a535))
return false, "이동이 되돌려짐"
end
_a5("[TP] 순간이동이 막혀서 glide 로 이동함: " .. tostring(_a518))
end
end
do
local _a538 = _a18.move.hrp()
if _a538 and (_a538.Position.Y - _a522.Y) > 25 then
_a5(("[TP] 목표보다 %.0f 높은 곳에 얹힘 — 내려감"):format(_a538.Position.Y - _a522.Y))
_a18.ctl.moving = nil
_a18.move.glideTo(Vector3.new(_a522.X, _a522.Y, _a522.Z))
end
end
if tostring(_a523):find("스트리밍", 1, true) then
task.wait(1.2)
local _a539, _a540 = _a18.move.zonePos(_a518)
if _a539 and not tostring(_a540):find("스트리밍", 1, true) then
if _a519 then
_a5("[TP] 스트리밍 로드됨 → 사냥터로 (" .. tostring(_a540) .. ")")
end
_a18.ctl.moving = nil
_a18.move.glideTo(_a539)
_a522, _a523 = _a539, _a540
end
end
if _a18.move.inDottedBox() == false then
task.wait(0.2)
local _a541, _a542 = _a18.move.breakCenter(400)
if _a541 and _a18.move.badSpot and _a18.move.badSpot[_a518] then
for _a543, _a544 in ipairs(_a18.move.badSpot[_a518]) do
if (_a544 - _a541).Magnitude <= 60 then _a541 = nil break end
end
end
if _a541 and _a542 >= 3 then
if _a519 then
_a5(("[TP] 네모 밖 → 주변 브레이커블 %d개 중심으로 보정"):format(_a542))
end
_a18.ctl.moving = nil
_a18.move.glideTo(_a541)
_a522 = _a541
end
if _a18.move.inDottedBox() == false then
local _a545 = _a18.move.zonePos(_a518)
if _a545 and (_a545 - _a522).Magnitude > 5 then
if _a519 then _a5("[TP] 아직 네모 밖 → 좌표 재계산 후 재시도") end
_a18.ctl.moving = nil
_a18.move.glideTo(_a545)
_a522 = _a545
end
end
if _a18.move.inDottedBox() == false and _a18.move.curZone() == _a518 then
_a18.move.badSpot = _a18.move.badSpot or {}
local _a546 = _a18.move.badSpot[_a518] or {}
if #_a546 < 5 then
_a546[#_a546 + 1] = _a522
_a18.move.badSpot[_a518] = _a546
_a5(("[TP] %s — 사냥터(점선 네모) 밖입니다. 이 지점은 앞으로 안 씁니다"):format(
tostring(_a518)))
_a5(("        후보: %s   좌표 (%.0f, %.0f, %.0f)"):format(
tostring(_a523), _a522.X, _a522.Y, _a522.Z))
else
_a18.move.badSpot[_a518] = nil
_a5("[TP] " .. tostring(_a518) .. " — 쓸만한 지점을 못 찾아 기록을 지웁니다")
end
return false, "사냥터 밖"
end
end
local function _a547()
if _a18.move.inDottedBox() == true then return false end
local _a548, _a549 = _a18.move.breakCenter(400)
if (_a549 or 0) >= 1 then return false end
task.wait(0.6)
if _a18.move.inDottedBox() == true then return false end
local _a550, _a551 = _a18.move.breakCenter(400)
return (_a551 or 0) < 1
end
if _a547() and (os.clock() - (_a18.move.lastRecover or -999)) > 30 then
_a18.move.lastRecover = os.clock()
_a5(("[TP] %s 근처에 브레이커블이 없음 (%s) — 좌표 확인 필요"):format(
tostring(_a518), tostring(_a523)))
end
_a18.move.zoneFailSaid = nil
_a18.move.arrivedZone = _a518
do
local _a552 = _a18.move.hrp()
local _a553 = _a552 and (_a552.Position - _a522).Magnitude or 0
if _a553 > math.max(60, _a11.ArriveDist or 12) then
_a5(("[TP] %s 도착 실패 — %.0f스터드 남음 (되돌려짐)"):format(tostring(_a518), _a553))
return false, "이동이 되돌려짐"
end
end
local _a554 = _a18.move.hrp()
if _a519 and _a554 then
_a5(("[TP] 도착. 목표까지 %.0f스터드 / 존 %s / 네모안 %s"):format(
(_a554.Position - _a522).Magnitude, tostring(_a18.move.curZone()), tostring(_a18.move.inDottedBox())))
end
return true
end
function _a18.egg.tpEgg(_a555)
if not _a555 then return false, "알 id 없음" end
for _a556, _a557 in ipairs(_a18.egg.eggStands()) do
if _a557.id == _a555 then
if _a557.dist <= _a11.EggRange then return true, _a555 end
local _a558, _a559 = _a18.move.glideTo(_a557.pos)
return _a558, _a558 and _a555 or _a559
end
end
if _a11.TpGameFallback then
local _a560 = _a16.DirEggs and rawget(_a16.DirEggs, _a555)
local _a561 = _a560 and select(1, _a18.move.zoneByNumber(rawget(_a560, "zoneNumber")))
if _a561 and _a18.move.curZone() ~= _a561 then
local _a562, _a563 = _a18.move.tpZone(_a561)
if not _a562 then return false, _a563 end
task.wait(0.5)
_a18.egg._standsAt = nil
for _a564, _a565 in ipairs(_a18.egg.eggStands()) do
if _a565.id == _a555 then return _a18.move.glideTo(_a565.pos), _a555 end
end
end
end
return false, "알 받침대를 못 찾음 (" .. tostring(_a555) .. ")"
end
function _a18.item.stacks(_a566)
local _a567 = _a45()
local _a568 = _a567 and rawget(_a567, "Inventory")
local _a569 = _a568 and rawget(_a568, _a566)
if type(_a569) ~= "table" then return {} end
local _a570 = {}
for _a571, _a572 in pairs(_a569) do
if type(_a572) == "table" then
_a570[#_a570 + 1] = {
uid = _a571,
id = tostring(rawget(_a572, "id")),
tier = tonumber(rawget(_a572, "tn")) or 1,
am = tonumber(rawget(_a572, "_am")) or 1,
}
end
end
return _a570
end
_a18.item.PERTIER = {
Potion  = { 3, 3, 4, 5, 5, 5, 5, 5, 7, 7, 7 },
Enchant = { 5, 5, 5, 7, 7, 7, 7, 7, 10, 10 },
}
function _a18.item.perTier(_a573, _a574)
_a574 = tonumber(_a574)
local _a575 = _a16.Bal and rawget(_a16.Bal,
_a573 == "Potion" and "CalcPotionsPerTierRequired" or "CalcEnchantsPerTierRequired")
if type(_a575) == "function" then
local _a576, _a577 = pcall(_a575, _a574)
_a577 = _a576 and tonumber(_a577) or nil
if _a577 and _a577 > 0 then return _a577 end
if not _a576 and not _a18.item.perTierWarned then
_a18.item.perTierWarned = true
_a5("[퀘스트] 재료 수량 함수 막힘 → 기본표로 계산 (" .. tostring(_a577) .. ")")
end
end
local _a578 = _a18.item.PERTIER[_a573]
local _a579 = _a578 and _a574 and _a578[_a574]
return (_a579 and _a579 > 0) and _a579 or nil
end
function _a18.item.upgradeTo(_a580, _a581)
local _a582 = (_a580 == "Potion") and _a16.R_PotUp or _a16.R_EncUp
if not _a582 then return 0, (_a580 .. " 업글 리모트 없음") end
local _a583 = math.max(1, (tonumber(_a581) or 2) - 1)
local _a584 = _a18.item.perTier(_a580, _a583)
if not _a584 then return 0, ("T%d 재료 수량을 못 읽음"):format(_a583) end
local _a585, _a586 = {}, 0
for _a587, _a588 in ipairs(_a18.item.stacks(_a580)) do
if _a588.tier == _a583 then
local _a589 = math.floor(_a588.am / _a584)
if _a589 > 0 then _a585[_a588.uid] = _a589 _a586 += _a589 end
end
end
if _a586 < 1 then return 0, ("T%d 재료 부족 (T%d %d개당 1개)"):format(_a583, _a583, _a584) end
local _a590, _a591
pcall(function() _a590, _a591 = _a582:InvokeServer(_a585) end)
if not _a590 then return 0, tostring(_a591) end
return _a586
end
function _a18.item.usePotion(_a592, _a593)
if not _a16.R_PotUse then return 0, "Potions: Consume 리모트 없음" end
_a592 = tonumber(_a592) or 1
local _a594 = {}
for _a595, _a596 in ipairs(_a18.item.stacks("Potion")) do
if _a596.tier >= _a592 and _a596.am >= 1 then _a594[#_a594 + 1] = _a596 end
end
if #_a594 == 0 then return 0, ("T%d 이상 포션 없음"):format(_a592) end
table.sort(_a594, function(_a597, _a598) return _a597.tier < _a598.tier end)
local _a599, _a600 = _a593, 0
for _a601, _a602 in ipairs(_a594) do
for _a603 = 1, math.min(_a599, _a602.am) do
if _a599 < 1 or not _a12.quest then break end
pcall(function() _a16.R_PotUse:FireServer(_a602.uid, 1) end)
_a600 += 1
_a599 -= 1
task.wait(0.12)
end
if _a599 < 1 then break end
end
return _a600
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
local function _a604(_a605)
if typeof(_a605) == "Vector3" then return _a605 end
if typeof(_a605) == "CFrame" then return _a605.Position end
if type(_a605) == "table" then
local _a606, _a607, _a608 = tonumber(_a605.X or _a605.x or _a605[1]), tonumber(_a605.Y or _a605.y or _a605[2]), tonumber(_a605.Z or _a605.z or _a605[3])
if _a606 and _a607 and _a608 then return Vector3.new(_a606, _a607, _a608) end
end
return nil
end
function _a18.ev.events()
local _a609
if _a16.Rand and rawget(_a16.Rand, "GetActive") then
local _a610, _a611 = pcall(_a16.Rand.GetActive)
if _a610 and type(_a611) == "table" and next(_a611) then _a609 = _a611 end
end
if not _a609 and _a16.R_Events then
local _a612, _a613 = pcall(function() return _a16.R_Events:InvokeServer() end)
if _a612 and type(_a613) == "table" then _a609 = _a613 end
end
if type(_a609) ~= "table" then return {} end
local _a614 = workspace:GetServerTimeNow()
local _a615 = {}
for _a616, _a617 in pairs(_a609) do
if type(_a617) == "table" then
local _a618 = tostring(rawget(_a617, "id") or "")
local _a619 = _a618:match("|%s*(%S+)%s*$") or _a618
local _a620 = tonumber(rawget(_a617, "started")) or 0
local _a621 = tonumber(rawget(_a617, "duration")) or 0
_a615[#_a615 + 1] = {
uid = rawget(_a617, "uid"),
id = _a618,
kind = _a619,
name = rawget(_a617, "name") or _a619,
zone = rawget(_a617, "parentID"),
pos = _a604(rawget(_a617, "origin")),
left = math.max(0, _a621 - (_a614 - _a620)),
}
end
end
table.sort(_a615, function(_a622, _a623) return _a622.left > _a623.left end)
return _a615
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
local _a624, _a625 = pcall(_a16.Map.IsInDottedBox)
if _a624 then return _a625 and true or false end
end
return nil
end
function _a18.ev.spawnItems(_a626)
local _a627 = _a18.ev.SPAWN[_a626]
if not _a627 then return {} end
local _a628 = {}
for _a629, _a630 in ipairs({ "Misc", "Consumable", "Lootbox" }) do
for _a631, _a632 in ipairs(_a18.item.stacks(_a630)) do
local _a633 = _a632.id:lower()
if _a633:find(_a627.key, 1, true) then
local _a634 = 99
if _a627.order then
for _a635, _a636 in ipairs(_a627.order) do
if _a633:find(_a636, 1, true) then _a634 = _a635 break end
end
end
_a632.rank = _a634
_a628[#_a628 + 1] = _a632
end
end
end
table.sort(_a628, function(_a637, _a638)
if _a637.rank ~= _a638.rank then return _a637.rank < _a638.rank end
return _a637.tier < _a638.tier
end)
return _a628
end
function _a18.ev.spawnEvent(_a639)
local _a640 = _a18.ev.SPAWN[_a639]
if not _a640 then return 0, "소환 불가 종류" end
local _a641 = _a9:FindFirstChild(_a640.rem)
if not _a641 then return 0, _a640.rem .. " 리모트 없음" end
local _a642 = _a18.ev.spawnItems(_a639)
if #_a642 == 0 then return 0, _a639 .. " 아이템 없음" end
local _a643 = _a18.move.inDottedBox()
if _a643 == false then return 0, "점선 네모 안이 아님" end
local _a644, _a645 = 0, nil
for _a646, _a647 in ipairs(_a642) do
if _a644 >= (_a11.SpawnPerCycle or 1) or not _a12.quest then break end
local _a648, _a649
pcall(function() _a648, _a649 = _a641:InvokeServer(_a647.uid) end)
if _a648 then
_a644 += 1
_a18.ctl.setAct("소환", _a639 .. " · " .. _a647.id)
_a5(("  🎁 %s 소환  (%s)"):format(_a639, _a647.id))
task.wait(0.4)
else
_a645 = _a649
break
end
end
return _a644, _a645
end
function _a18.ev.findEvent(_a650, _a651)
local _a652 = _a651 and _a18.move.bestZone() or nil
local _a653
for _a654, _a655 in ipairs(_a18.ev.events()) do
if _a655.kind == _a650 and _a655.left > 15 then
if not _a651 or _a655.zone == _a652 then
if not _a653 or (_a655.zone == _a18.move.curZone() and _a653.zone ~= _a18.move.curZone()) then
_a653 = _a655
end
end
end
end
return _a653
end
function _a18.ev.findChest(_a656, _a657)
local _a658 = workspace:FindFirstChild("__THINGS")
if not _a658 then return nil end
local _a659 = tostring(_a656):lower():find("superior") ~= nil
local _a660 = _a18.move.hrp()
local _a661 = _a660 and _a660.Position
local _a662, _a663, _a664, _a665
for _a666, _a667 in ipairs(_a658:GetChildren()) do
if tostring(_a667.Name):lower():find("chest", 1, true) then
for _a668, _a669 in ipairs(_a667:GetChildren()) do
local _a670
if _a669:IsA("BasePart") then _a670 = _a669.Position
elseif _a669:IsA("Model") then
local _a671, _a672 = pcall(function() return _a669:GetPivot() end)
if _a671 and typeof(_a672) == "CFrame" then _a670 = _a672.Position end
end
if _a670 then
local _a673 = _a661 and (_a670 - _a661).Magnitude or 0
local _a674 = (tostring(_a669.Name) .. tostring(_a667.Name)):lower()
:find("superior", 1, true) ~= nil
if not _a665 or _a673 < _a665 then _a664, _a665 = _a670, _a673 end
if _a674 == _a659 and (not _a663 or _a673 < _a663) then
_a662, _a663 = _a670, _a673
end
end
end
end
end
if _a662 then return _a662, _a663 end
return _a664, _a665
end
_a18.quest.SKIP = { [4] = true, [5] = true, [40] = true, [41] = true }
_a18.quest.WHERE = {
[21]="bestzone", [9]="bestzone", [37]="bestzone", [38]="bestzone", [39]="bestzone",
[43]="bestzone", [44]="bestzone", [76]="bestzone", [30]="bestzone", [8]="bestzone",
[20]="bestegg",  [42]="bestegg",
[1]="breakable", [81]="zoneid",
}
function _a18.item.petStacks()
local _a675 = _a45()
local _a676 = _a675 and rawget(_a675, "Inventory")
local _a677 = _a676 and rawget(_a676, "Pet")
local _a678 = {}
if type(_a677) ~= "table" then return _a678 end
for _a679, _a680 in pairs(_a677) do
if type(_a680) == "table" then
_a678[#_a678 + 1] = {
uid = _a679,
id = tostring(rawget(_a680, "id")),
pt = tonumber(rawget(_a680, "pt")) or 0,
am = tonumber(rawget(_a680, "_am")) or 1,
}
end
end
return _a678
end
function _a18.item.bestEggPets()
local _a681 = _a93()
local _a682 = _a681 and _a16.DirEggs and rawget(_a16.DirEggs, _a681)
local _a683 = _a682 and rawget(_a682, "pets")
local _a684 = {}
if type(_a683) == "table" then
for _a685, _a686 in pairs(_a683) do
local _a687 = type(_a686) == "table" and _a686[1] or _a686
if _a687 then _a684[tostring(_a687)] = true end
end
end
return _a684, _a681
end
function _a18.item.makeVariant(_a688, _a689)
local _a690 = (_a688 == "gold") and _a16.R_Gold or _a16.R_Rain
if not _a690 then return 0, (_a688 .. " 머신 리모트 없음") end
local _a691 = (_a688 == "gold") and 0 or 1
local _a692
if _a689 then
local _a693, _a694 = _a18.item.bestEggPets()
if not next(_a693) then return 0, "최고 알(" .. tostring(_a694) .. ") 펫 목록을 못 읽음" end
_a692 = _a693
end
local _a695, _a696 = 0, nil
for _a697, _a698 in ipairs(_a18.item.petStacks()) do
if not _a12.quest then break end
if _a698.pt == _a691 and _a698.am >= 10 and (not _a692 or _a692[_a698.id]) then
local _a699 = math.floor(_a698.am / 10)
if _a699 > 0 then
local _a700, _a701
pcall(function() _a700, _a701 = _a690:InvokeServer(_a698.uid, _a699) end)
if _a700 then
_a695 += _a699
_a5(("  ✨ %s 제작  %s x%d"):format(
_a688 == "gold" and "골드" or "레인보우", _a698.id, _a699))
task.wait(0.4)
else
_a696 = _a701
end
end
end
end
return _a695, _a696
end
function _a18.item.useFlag(_a702)
if not _a16.R_Flag then return 0, "FlexibleFlags_Consume 리모트 없음" end
local _a703, _a704 = 0, nil
for _a705, _a706 in ipairs(_a18.item.stacks("Misc")) do
if _a703 >= (_a702 or 1) then break end
if _a706.id:lower():find("flag", 1, true) and _a706.am >= 1 and _a18.item.itemAllowed(_a706.id) then
local _a707, _a708
pcall(function() _a707, _a708 = _a16.R_Flag:InvokeServer(_a706.id, _a706.uid, 1) end)
if _a707 then _a703 += 1 task.wait(0.4) else _a704 = _a708 end
end
end
return _a703, _a704
end
function _a18.item.useFruit(_a709)
if not _a16.R_Fruit then return 0, "Fruits: Consume 리모트 없음" end
local _a710 = _a18.item.activeBuffs("Fruits")
local _a711 = 0
for _a712, _a713 in ipairs(_a18.item.stacks("Fruit")) do
if _a711 >= (_a709 or 1) then break end
if _a713.am >= 1 and _a18.item.itemAllowed(_a713.id) and not _a710[_a713.id] then
pcall(function() _a16.R_Fruit:FireServer(_a713.uid, 1) end)
_a711 += 1
task.wait(0.4)
end
end
return _a711
end
function _a18.quest.status()
local _a714 = _a45()
if not _a714 then return nil end
local _a715 = rawget(_a714, "Goals")
if type(_a715) ~= "table" then return { list = {} } end
local _a716 = {}
for _a717, _a718 in pairs(_a715) do
if type(_a718) == "table" then
local _a719 = tonumber(rawget(_a718, "Type")) or -1
local _a720
if _a16.Quest and rawget(_a16.Quest, "MakeTitle") then
local _a721, _a722 = pcall(_a16.Quest.MakeTitle, _a718)
if _a721 then _a720 = _a722 end
end
_a716[#_a716 + 1] = {
slot = _a717,
uid = tostring(rawget(_a718, "UID")),
type = _a719,
how = _a17[_a719],
title = _a720 or ("Type " .. _a719),
amount = tonumber(rawget(_a718, "Amount")) or 0,
progress = tonumber(rawget(_a718, "Progress")) or 0,
stars = tonumber(rawget(_a718, "Stars")) or 0,
potionTier = tonumber(rawget(_a718, "PotionTier")),
enchantTier = tonumber(rawget(_a718, "EnchantTier")),
breakable = rawget(_a718, "BreakableType") or rawget(_a718, "BreakableDirID"),
zoneId = rawget(_a718, "ZoneID"),
where = _a18.quest.WHERE[_a719] or (_a17[_a719] == "farm" and "bestzone" or nil),
event = _a18.ev.EVENTKIND[_a719],
chest = _a18.ev.CHESTKIND[_a719],
bestOnly = _a18.ev.BESTONLY[_a719] or false,
ignored = _a18.quest.IGNORE[_a719],
}
end
end
table.sort(_a716, function(_a723, _a724) return _a723.stars > _a724.stars end)
return { list = _a716, rank = tonumber(rawget(_a714, "Rank")) or 1,
rankStars = tonumber(rawget(_a714, "RankStars")) or 0 }
end
_a18.quest.BESTDEP = {
[20]=true, [21]=true, [37]=true, [38]=true, [39]=true,
[43]=true, [44]=true, [76]=true,
}
function _a18.quest.bestDepActive()
local _a725 = _a18.ctl.lockGoal and _a18.ctl.lockGoal.q
if not _a725 then return false end
if _a18.quest.IGNORE[_a725.type] then return false end
if not _a18.quest.BESTDEP[_a725.type] then return false end
local _a726 = _a18.quest.findQuest(_a725.uid)
if not _a726 or _a726.progress >= _a726.amount then return false end
return true, _a726
end
function _a18.quest.canDo(_a727, _a728)
if _a727.how == "hatch" or _a727.where == "bestegg" then
local _a729 = _a118()
if not _a729 then return false, "알 정보를 못 읽음" end
if not _a729.price then return true end
if not _a728 then
if _a729.canBuy < 1 then
return false, ("돈 부족 — %s 개당 %s %s / 보유 %s"):format(
tostring(_a729.id), _a6(_a729.price, 0), tostring(_a729.currency), _a6(_a729.have, 0))
end
return true
end
local _a730 = math.max(1, (_a727.amount or 1) - (_a727.progress or 0))
local _a731 = _a730
if _a727.type == 2 or _a727.type == 42 or _a727.type == 47 then
_a731 = math.max(_a730, _a11.HatchMinAfford or 10)
end
if _a729.canBuy < _a731 then
_a18.quest.moneyUntil = os.clock() + math.max(0, _a11.MoneyDwell or 60)
return false, ("돈 모으는 중 — %d개분 필요 / 지금 %d개분 (개당 %s %s)"):format(
_a731, _a729.canBuy, _a6(_a729.price, 0), tostring(_a729.currency))
end
if _a18.quest.moneyUntil and os.clock() < _a18.quest.moneyUntil then
return false, ("조금 더 벌고 감 (%.0f초 남음)"):format(_a18.quest.moneyUntil - os.clock())
end
_a18.quest.moneyUntil = nil
end
return true
end
function _a18.quest.findQuest(_a732)
local _a733 = _a18.quest.status()
for _a734, _a735 in ipairs(_a733 and _a733.list or {}) do
if _a735.uid == _a732 then return _a735 end
end
return nil
end
function _a18.quest.pursue(_a736)
local _a737, _a738
if _a736.how == "hatch" then _a737, _a738 = _a129, "mhatch"
elseif _a736.how == "zone" then _a737, _a738 = _a88, "zone"
elseif _a736.how == "gold" or _a736.how == "rainbow" then
local _a739 = (_a736.type == 40 or _a736.type == 41)
_a738 = "quest"
_a737 = function()
local _a740 = _a18.item.makeVariant("gold", _a739) or 0
if _a736.how == "rainbow" then
_a740 += (_a18.item.makeVariant("rainbow", _a739) or 0)
end
if _a740 > 0 then
_a18.ctl.setAct(_a736.how == "gold" and "골드 합성" or "레인보우 합성", _a740 .. "마리")
return
end
_a18.ctl.setAct("재료 모으는 중", "최고 알 부화")
local _a741 = _a12.mhatch
_a12.mhatch = true
pcall(_a129)
_a12.mhatch = _a741
end
end
local _a742 = _a736.progress
local _a743 = os.clock()
_a18.ctl.setGoal(_a736.title, ("%d/%d"):format(_a736.progress, _a736.amount))
local function _a744()
if not _a736.event then return end
local _a745 = _a18.ev.findEvent(_a736.event, _a736.bestOnly)
if _a745 then
_a18.ctl.setAct(_a736.event .. " 진행 중", ("%d초 남음"):format(_a745.left))
if _a745.pos then
local _a746 = _a18.move.hrp()
if _a746 and (_a746.Position - _a745.pos).Magnitude > (_a11.EventStayDist or 45) then
_a18.move.glideTo(_a745.pos)
end
end
return
end
local _a747, _a748 = _a18.ev.spawnEvent(_a736.event)
if _a747 > 0 then
_a18.ctl.setAct("소환", _a736.event)
task.wait(0.5)
elseif _a748 and _a18.ev.spawnErr ~= tostring(_a748) then
_a18.ev.spawnErr = tostring(_a748)
_a5("[퀘스트] " .. _a736.event .. " 소환 실패: " .. tostring(_a748))
end
end
local _a749, _a750 = pcall(function()
while _a12.quest and not _a18.ctl.stopped() do
local _a751, _a752 = _a18.quest.canDo(_a736, false)
if not _a751 then
_a5(("[퀘스트] %s → 다른 퀘스트 먼저 (%s)"):format(tostring(_a736.title), tostring(_a752)))
return
end
_a744()
if _a737 then
local _a753 = _a12[_a738]
_a12[_a738] = true
local _a754, _a755 = pcall(_a737)
_a12[_a738] = _a753
if not _a754 then error(_a755, 0) end
elseif _a736.event then
task.wait(0.4)
else
task.wait(2)
end
local _a756 = _a18.quest.findQuest(_a736.uid)
if not _a756 then
_a5("[퀘스트] 완료 — " .. tostring(_a736.title))
return
end
_a18.ctl.setGoal(_a756.title, ("%d/%d"):format(_a756.progress, _a756.amount))
if _a756.progress >= _a756.amount then
_a5(("[퀘스트] 달성 %d/%d — %s"):format(_a756.progress, _a756.amount, tostring(_a756.title)))
return
end
if _a756.progress > _a742 then
_a743 = os.clock()
_a5(("[퀘스트] %d/%d  %s"):format(_a756.progress, _a756.amount, tostring(_a756.title)))
end
_a742 = _a756.progress
local _a757 = os.clock() - _a743
if _a757 >= math.max(10, _a11.PursueStallSec or 60) then
_a5(("[퀘스트] %.0f초째 진행 없음 (%d/%d) — 다음 단계로: %s"):format(
_a757, _a756.progress, _a756.amount, tostring(_a756.title)))
return
end
task.wait(0.2)
end
end)
if not _a749 then _a5("[퀘스트] " .. tostring(_a736.how) .. " 오류: " .. tostring(_a750)) end
_a18.ctl.lockGoal = nil
_a18.ctl.setGoal(nil)
end
function _a18.quest.cycle()
do
local _a758 = _a12.rank
_a12.rank = true
pcall(_a180)
_a12.rank = _a758
end
local _a759 = _a18.quest.status()
if not _a759 then return end
local _a760, _a761, _a762 = false, false, false
local _a763 = {}
local _a764 = nil
for _a765, _a766 in ipairs(_a759.list) do
if not _a12.quest then break end
local _a767, _a768 = true, nil
if not _a766.ignored and _a766.progress < _a766.amount then
_a767, _a768 = _a18.quest.canDo(_a766, true)
end
if _a766.ignored then
if _a766.progress < _a766.amount then
_a763[#_a763 + 1] = tostring(_a766.title) .. "  — " .. _a766.ignored
end
elseif not _a767 then
local _a769 = tostring(_a766.uid) .. tostring(_a768)
if _a18.item.skipSaid ~= _a769 then
_a18.item.skipSaid = _a769
_a5(("[퀘스트] 건너뜀: %s   (%s)"):format(tostring(_a766.title), tostring(_a768)))
end
elseif _a766.progress < _a766.amount then
local _a770 = _a766.where
if _a766.event then
if not _a764 or _a764.rank > 0 then _a764 = { rank = 0, kind = "event", q = _a766 } end
elseif _a766.chest then
if not _a764 or _a764.rank > 1 then _a764 = { rank = 1, kind = "chest", q = _a766 } end
elseif _a770 == "bestegg" then
if not _a764 or _a764.rank > 1 then _a764 = { rank = 1, kind = "egg", q = _a766 } end
elseif _a770 == "breakable" and _a766.breakable then
if not _a764 or _a764.rank > 2 then _a764 = { rank = 2, kind = "breakable", q = _a766 } end
elseif _a770 == "zoneid" and _a766.zoneId then
if not _a764 or _a764.rank > 2 then _a764 = { rank = 2, kind = "zoneid", q = _a766 } end
elseif _a770 == "bestzone" or _a770 == "breakable" then
if not _a764 then _a764 = { rank = 3, kind = "bestzone", q = _a766 } end
end
if _a766.how == "farm" then
_a760 = true
elseif _a766.how == "hatch" then
_a761 = true
elseif _a766.how == "zone" then
_a762 = true
elseif _a766.how == "potup" and _a11.QuestUpgrade then
local _a771, _a772 = _a18.item.upgradeTo("Potion", _a766.potionTier or 2)
if _a771 > 0 then
_a13.potup += _a771
_a13.quest += 1
_a5(("[퀘스트] 포션 T%d %d개 제작  (%s)"):format(_a766.potionTier or 2, _a771, _a766.title))
elseif _a772 and not tostring(_a772):find("부족") then
if _a18.item.potUpSaid ~= tostring(_a772) then
_a18.item.potUpSaid = tostring(_a772)
_a5("[퀘스트] 포션 업글 실패: " .. tostring(_a772))
end
end
elseif _a766.how == "encup" and _a11.QuestUpgrade then
local _a773, _a774 = _a18.item.upgradeTo("Enchant", _a766.enchantTier or 2)
if _a773 > 0 then
_a13.potup += _a773
_a13.quest += 1
_a5(("[퀘스트] 인챈트 T%d %d개 제작  (%s)"):format(_a766.enchantTier or 2, _a773, _a766.title))
elseif _a774 and not tostring(_a774):find("부족") then
if _a18.item.encUpSaid ~= tostring(_a774) then
_a18.item.encUpSaid = tostring(_a774)
_a5("[퀘스트] 인챈트 업글 실패: " .. tostring(_a774))
end
end
elseif _a766.how == "potuse" and _a11.QuestUsePotion then
_a18.item.lastUse = _a18.item.lastUse or {}
local _a775 = _a18.item.lastUse[_a766.uid]
if _a775 and _a775.used > 0 and _a766.progress <= _a775.progress then
if not _a775.gaveUp then
_a775.gaveUp = true
_a5("[퀘스트] 포션을 마셔도 진행도가 안 올라서 중단: " .. tostring(_a766.title))
end
else
local _a776 = math.min(_a11.QuestUseMax, math.max(1, _a766.amount - _a766.progress))
local _a777, _a778 = _a18.item.usePotion(_a766.potionTier or 1, _a776)
_a18.item.lastUse[_a766.uid] = { used = _a777, progress = _a766.progress }
if _a777 > 0 then
_a13.potuse += _a777
_a13.quest += 1
_a5(("[퀘스트] 포션 %d개 사용  (%s)"):format(_a777, _a766.title))
elseif _a778 and not tostring(_a778):find("없음") then
_a5("[퀘스트] 포션 사용 실패: " .. tostring(_a778))
end
end
elseif _a766.how == "gold" or _a766.how == "rainbow" then
local _a779, _a780 = _a18.item.makeVariant(_a766.how, _a766.type == 40 or _a766.type == 41)
if _a779 > 0 then
_a13.quest += 1
_a5(("[퀘스트] %s 펫 %d마리 제작  (%s)"):format(
_a766.how == "gold" and "골드" or "레인보우", _a779, _a766.title))
elseif _a780 then
_a5("[퀘스트] " .. _a766.how .. " 실패: " .. tostring(_a780))
end
elseif _a766.how == "fruituse" then
local _a781 = _a18.item.useFruit(math.max(1, _a766.amount - _a766.progress))
if _a781 > 0 then
_a13.quest += 1
_a5(("[퀘스트] 과일 %d개 사용  (%s)"):format(_a781, _a766.title))
end
elseif _a766.how == "flaguse" then
local _a782, _a783 = _a18.item.useFlag(math.max(1, _a766.amount - _a766.progress))
if _a782 > 0 then
_a13.quest += 1
_a5(("[퀘스트] 깃발 %d개 사용  (%s)"):format(_a782, _a766.title))
elseif _a783 then
_a5("[퀘스트] 깃발 실패: " .. tostring(_a783))
end
elseif not _a766.how then
_a763[#_a763 + 1] = _a766.title
end
end
end
if _a11.QuestLock and _a18.ctl.lockGoal then
local _a784
for _a785, _a786 in ipairs(_a759.list) do
if _a786.uid == _a18.ctl.lockGoal.q.uid and _a786.progress < _a786.amount then _a784 = _a786 break end
end
if _a784 then
_a18.ctl.lockGoal.q = _a784
_a764 = _a18.ctl.lockGoal
else
if _a18.ctl.lockGoal.q then
_a5("[퀘스트] 완료/교체됨 → 다음 목표로: " .. tostring(_a18.ctl.lockGoal.q.title))
end
_a18.ctl.lockGoal = nil
end
end
if _a11.QuestLock and _a764 then _a18.ctl.lockGoal = _a764 end
if _a11.QuestTp and _a764 and _a12.quest then
local _a787, _a788, _a789
if _a764.kind == "event" then
local _a790 = _a18.ev.findEvent(_a764.q.event, _a764.q.bestOnly)
if _a790 then
_a789 = ("%s @%s (%d초 남음)"):format(_a790.name, tostring(_a790.zone), _a790.left)
if _a790.pos then _a787, _a788 = _a18.move.glideTo(_a790.pos)
else _a787, _a788 = _a18.move.goToZone(_a790.zone) end
else
local _a791 = _a764.q.bestOnly and _a18.move.bestZone() or (_a18.move.curZone() or _a18.move.bestZone())
_a789 = _a764.q.event .. " 소환용 " .. tostring(_a791)
local _a792 = _a18.move.inDottedBox()
_a787, _a788 = _a18.move.goToZone(_a791, false, _a792 == false, _a764.q.bestOnly)
if _a787 then
local _a793, _a794 = _a18.ev.spawnEvent(_a764.q.event)
if _a793 < 1 and tostring(_a794):find("점선") then
_a18.move.goToZone(_a791, false, true)
task.wait(0.2)
_a793, _a794 = _a18.ev.spawnEvent(_a764.q.event)
end
if _a793 > 0 then
_a789 = ("%s %d개 소환 @%s"):format(_a764.q.event, _a793, tostring(_a791))
else
_a788 = _a794
_a787 = false
end
end
end
elseif _a764.kind == "chest" then
local _a795 = _a764.q.bestOnly and _a18.move.bestZone() or _a18.move.curZone()
local _a796, _a797 = _a18.ev.findChest(_a764.q.chest, _a795)
_a789 = _a764.q.chest .. " @" .. tostring(_a795)
if _a796 then
if not _a797 or _a797 > 20 then _a18.move.glideTo(_a796) end
_a787 = true
else
_a787, _a788 = _a18.move.goToZone(_a795)
_a789 = _a789 .. " (상자 없음 → 존 가운데)"
end
elseif _a764.kind == "egg" then
local _a798 = _a93()
_a789 = "최고 알 " .. tostring(_a798)
if _a798 then _a787, _a788 = _a18.egg.tpEgg(_a798) else _a788 = "최고 알을 못 찾음" end
elseif _a764.kind == "breakable" then
local _a799 = _a18.move.zoneForBreakable(_a764.q.breakable)
_a789 = tostring(_a764.q.breakable) .. " 나오는 존 " .. tostring(_a799)
if _a799 then _a787, _a788 = _a18.move.goToZone(_a799, true) else _a788 = "그 브레이커블이 나오는 존이 없음" end
elseif _a764.kind == "zoneid" then
_a789 = "존 " .. tostring(_a764.q.zoneId)
_a787, _a788 = _a18.move.goToZone(_a764.q.zoneId)
else
local _a800 = _a18.move.bestZone()
local _a801 = _a764.q.bestOnly or _a18.quest.BESTDEP[_a764.q.type] or false
if _a800 then _a787, _a788 = _a18.move.goToZone(_a800, true, false, _a801)
else _a788 = "최고 존을 못 찾음" end
_a789 = "최고 존 " .. tostring(_a18.move.arrivedZone or _a800)
if not _a787 then _a788 = _a800 end
end
if _a787 then
if _a18.quest.lastGoal ~= _a789 then
_a18.quest.lastGoal = _a789
_a5("[퀘스트] " .. _a789 .. " 으로 이동  (" .. tostring(_a764.q.title) .. ")")
end
_a18.quest.pursue(_a764.q)
else
local _a802 = _a788 and tostring(_a788) or "이유 불명"
if _a18.quest.lastFail ~= _a802 then
_a18.quest.lastFail = _a802
_a5(("[퀘스트] 진행 못 함: %s   (%s / %s)"):format(
_a802, tostring(_a764.kind), tostring(_a764.q.title)))
_a5(("           현재 존 %s / 최고 존 %s / 점선네모 %s"):format(
tostring(_a18.move.curZone()), tostring(_a18.move.bestZone()), tostring(_a18.move.inDottedBox())))
end
end
end
if _a11.QuestDrive and _a18.auto.turnOn then
if _a760  then _a18.auto.turnOn("farm",   "파밍 퀘스트 → 자동 파밍") end
if _a762  then _a18.auto.turnOn("zone",   "존 퀘스트 → 자동 존 해금") end
if _a761 then _a18.auto.turnOn("mhatch", "부화 퀘스트 → 자동 부화") end
end
if #_a763 > 0 and not _a18.quest.manualWarned then
_a18.quest.manualWarned = true
_a5("[퀘스트] 수동으로 해야 하는 것:")
for _a803, _a804 in ipairs(_a763) do _a5("    · " .. tostring(_a804)) end
elseif #_a763 == 0 then
_a18.quest.manualWarned = false
end
return _a764 ~= nil
end
local function _a805(_a806)
local _a807 = {}
for _a808 in tostring(_a806 or ""):gmatch("[^,]+") do
_a808 = _a808:match("^%s*(.-)%s*$")
if _a808 ~= "" then _a807[#_a807 + 1] = _a808:lower() end
end
return _a807
end
function _a18.item.itemAllowed(_a809)
local _a810 = tostring(_a809):lower()
for _a811, _a812 in ipairs(_a805(_a11.ItemBlock)) do
if _a810:find(_a812, 1, true) then return false end
end
local _a813 = _a805(_a11.ItemAllow)
if #_a813 == 0 then return true end
for _a814, _a815 in ipairs(_a813) do
if _a810:find(_a815, 1, true) then return true end
end
return false
end
function _a18.item.activeBuffs(_a816)
local _a817 = _a45()
local _a818 = _a817 and rawget(_a817, _a816)
local _a819 = {}
if type(_a818) == "table" then
for _a820, _a821 in pairs(_a818) do
if type(_a821) == "table" and next(_a821) then _a819[_a820] = true
elseif _a821 then _a819[_a820] = true end
end
end
return _a819
end
local function _a822(_a823, _a824, _a825, _a826)
local _a827 = _a18.item.activeBuffs(_a824)
local _a828 = {}
local _a829 = { total = 0, act = 0, blocked = 0, few = 0, ok = 0 }
for _a830, _a831 in ipairs(_a18.item.stacks(_a823)) do
_a829.total += 1
if _a827[_a831.id] then _a829.act += 1
elseif not _a18.item.itemAllowed(_a831.id) then _a829.blocked += 1
elseif _a831.am <= _a11.ItemKeep then _a829.few += 1
else
_a829.ok += 1
local _a832 = _a828[_a831.id]
local _a833
if not _a832 then _a833 = true
elseif _a11.BuffHighTier then _a833 = _a831.tier > _a832.tier
else _a833 = _a831.tier < _a832.tier end
if _a833 then _a828[_a831.id] = _a831 end
end
end
if _a829.ok == 0 and _a829.total > 0 then
local _a834 = ("%s %d종 중 사용 가능 0 (이미걸림 %d / 제외 %d / 재고부족 %d)")
:format(_a823, _a829.total, _a829.act, _a829.blocked, _a829.few)
if _a18.item.buffSaid ~= _a834 then
_a18.item.buffSaid = _a834
_a5("[아이템] " .. _a834)
end
elseif _a829.ok > 0 then
_a18.item.buffSaid = nil
end
local _a835 = {}
for _a836, _a837 in pairs(_a828) do _a835[#_a835 + 1] = _a837 end
table.sort(_a835, function(_a838, _a839)
if _a838.tier ~= _a839.tier then return _a838.tier > _a839.tier end
return _a838.am > _a839.am
end)
local _a840 = {}
for _a841, _a842 in ipairs(_a835) do
if not _a12.items then break end
if _a826 and _a826.left <= 0 then break end
local _a843 = pcall(function() _a825(_a842.uid, 1) end)
if _a843 then
_a840[#_a840 + 1] = ("%s T%d"):format(_a842.id, _a842.tier)
_a13.items += 1
if _a826 then _a826.left -= 1 end
task.wait(0.12)
end
end
return _a840
end
function _a18.item.cycleItems()
local function _a844()
local _a845 = {}
if _a11.BuffPotion then _a845[#_a845 + 1] = { "Potion", "Potions" } end
if _a11.BuffFruit then _a845[#_a845 + 1] = { "Fruit", "Fruits" } end
if _a11.BuffConsumable then _a845[#_a845 + 1] = { "Consumable", "Consumables" } end
for _a846, _a847 in ipairs(_a845) do
local _a848 = _a18.item.activeBuffs(_a847[2])
for _a849, _a850 in ipairs(_a18.item.stacks(_a847[1])) do
if _a850.am > _a11.ItemKeep and _a18.item.itemAllowed(_a850.id) and not _a848[_a850.id] then
return true
end
end
end
if _a11.BuffUltimate and _a16.R_Ult then
local _a851 = _a45()
local _a852 = _a851 and rawget(_a851, "Ultimates")
if type(_a852) == "table" then
for _a853 in pairs(_a852) do
if _a18.item.itemAllowed(_a853) then
if not (_a16.Ult and rawget(_a16.Ult, "IsCharged")) then return true end
local _a854, _a855 = pcall(_a16.Ult.IsCharged, _a853)
if _a854 and _a855 then return true end
end
end
end
end
return false
end
if not _a844() then return end
if _a11.ItemBestZone then
local _a856 = _a18.move.bestZone()
if _a856 and _a18.move.curZone() ~= _a856 then
if not _a11.ItemTp then
if not _a18.item.itemZoneWarned then
_a18.item.itemZoneWarned = true
_a5(("[아이템] 최고 존(%s)이 아니라 대기 — 현재 %s"):format(
tostring(_a856), tostring(_a18.move.curZone())))
end
return
end
local _a857, _a858 = _a18.move.goToZone(_a856)
if not _a857 then
_a5("[아이템] 최고 존 이동 실패: " .. tostring(_a858))
return
end
_a5("[아이템] 최고 존 " .. tostring(_a856) .. " 에서 사용")
end
_a18.item.itemZoneWarned = false
end
local _a859 = {}
local _a860  = { left = math.max(1, _a11.BuffMaxPotion or 5) }
local _a861 = { left = math.max(1, _a11.BuffMaxOther or 2) }
if _a11.BuffPotion and _a16.R_PotUse then
local _a862 = _a822("Potion", "Potions", function(_a863, _a864)
_a16.R_PotUse:FireServer(_a863, _a864)
end, _a860)
for _a865, _a866 in ipairs(_a862) do _a859[#_a859 + 1] = "포션 " .. _a866 end
end
if _a11.BuffFruit and _a16.R_Fruit then
local _a867 = _a822("Fruit", "Fruits", function(_a868, _a869)
_a16.R_Fruit:FireServer(_a868, _a869)
end, _a861)
for _a870, _a871 in ipairs(_a867) do _a859[#_a859 + 1] = "과일 " .. _a871 end
end
if _a11.BuffConsumable and _a16.R_Cons then
local _a872 = _a822("Consumable", "Consumables", function(_a873, _a874)
_a16.R_Cons:InvokeServer(_a873, _a874)
end, _a861)
for _a875, _a876 in ipairs(_a872) do _a859[#_a859 + 1] = "소모품 " .. _a876 end
end
if _a11.BuffUltimate and _a16.R_Ult then
local _a877 = _a45()
local _a878 = _a877 and rawget(_a877, "Ultimates")
if type(_a878) == "table" then
for _a879 in pairs(_a878) do
if not _a12.items then break end
if _a18.item.itemAllowed(_a879) then
local _a880 = true
if _a16.Ult and rawget(_a16.Ult, "IsCharged") then
local _a881, _a882 = pcall(_a16.Ult.IsCharged, _a879)
_a880 = _a881 and _a882 and true or false
end
if _a880 then
local _a883
pcall(function() _a883 = _a16.R_Ult:InvokeServer(_a879) end)
if _a883 then
_a859[#_a859 + 1] = "얼티밋 " .. tostring(_a879)
_a13.items += 1
task.wait(0.3)
end
end
end
end
end
end
if #_a859 > 0 then
_a18.ctl.setAct("버프 사용", table.concat(_a859, ", "))
_a5("[아이템] " .. table.concat(_a859, ", ") .. " 사용")
end
end
function _a18.mach.slotStatus()
local _a884 = _a45()
if not _a884 then return nil end
local _a885 = tonumber(rawget(_a884, "PetSlotsPurchased")) or 0
local _a886 = tonumber(rawget(_a884, "EggSlotsPurchased")) or 0
local _a887, _a888 = 0, 0
if _a16.RankC then
if rawget(_a16.RankC, "GetMaxPurchasableEquipSlots") then
local _a889, _a890 = pcall(_a16.RankC.GetMaxPurchasableEquipSlots)
if _a889 and tonumber(_a890) then _a887 = tonumber(_a890) end
end
if rawget(_a16.RankC, "GetMaxPurchasableEggSlots") then
local _a891, _a892 = pcall(_a16.RankC.GetMaxPurchasableEggSlots)
if _a891 and tonumber(_a892) then _a888 = tonumber(_a892) end
end
end
local _a893, _a894
if _a885 < _a887 then
_a893 = _a885 + 1
if type(_a16.CalcPetS) == "function" then
local _a895, _a896 = pcall(_a16.CalcPetS, _a893)
if _a895 then _a894 = tonumber(_a896) end
end
end
local _a897, _a898, _a899
if _a886 < _a888 and _a16.RankC and rawget(_a16.RankC, "GetEggBundle") then
local _a900, _a901, _a902 = pcall(_a16.RankC.GetEggBundle, _a886 + 1)
if _a900 and tonumber(_a901) then
_a897, _a898 = tonumber(_a901), tonumber(_a902) or 1
if type(_a16.CalcEggS) == "function" then
local _a903, _a904 = 0, false
for _a905 = _a897 - _a898 + 1, _a897 do
local _a906, _a907 = pcall(_a16.CalcEggS, _a905)
if _a906 and tonumber(_a907) then _a903 += tonumber(_a907) else _a904 = true end
end
if not _a904 then _a899 = _a903 end
end
end
end
local _a908
if _a16.Egg and rawget(_a16.Egg, "GetMaxHatch") then
local _a909, _a910 = pcall(_a16.Egg.GetMaxHatch)
if _a909 then _a908 = tonumber(_a910) end
end
return {
dia = _a60("Diamonds"),
petOwned = _a885, petMax = _a887, petNext = _a893, petCost = _a894,
eggOwned = _a886, eggMax = _a888, eggEnd = _a897, eggSize = _a898, eggCost = _a899,
maxEquip = tonumber(rawget(_a884, "MaxPetsEquipped")), maxHatch = _a908,
}
end
function _a18.move.machinePos(_a911)
local _a912
if _a16.Machine and rawget(_a16.Machine, "GetModels") then
local _a913, _a914 = pcall(_a16.Machine.GetModels, _a911)
if _a913 and type(_a914) == "table" then
for _a915, _a916 in pairs(_a914) do
if typeof(_a916) == "Instance" then _a912 = _a916 break end
end
end
end
if not _a912 then
local _a917, _a918 = pcall(function()
return game:GetService("CollectionService"):GetTagged("Machine")
end)
if _a917 then
for _a919, _a920 in ipairs(_a918) do
if _a920.Name == _a911 then _a912 = _a920 break end
end
end
end
if not _a912 then return nil end
if _a912:IsA("BasePart") then return _a912.Position end
local _a921, _a922 = pcall(function() return _a912:GetPivot() end)
return (_a921 and typeof(_a922) == "CFrame") and _a922.Position or nil
end
function _a18.mach.cycleSlots()
local _a923 = 0
local _a924 = 0
while _a12.slots and not _a18.ctl.stopped() and _a924 < 40 do
_a924 += 1
local _a925 = _a18.mach.slotStatus()
if not _a925 then return end
local _a926 = _a11.SlotPet and _a925.petNext and _a925.petCost
and (_a925.dia - _a11.SlotReserve) >= _a925.petCost
local _a927 = _a11.SlotEgg and _a925.eggEnd and _a925.eggCost
and (_a925.dia - _a11.SlotReserve) >= _a925.eggCost
if _a926 and _a927 then
if _a925.eggCost < _a925.petCost then _a926 = false else _a927 = false end
end
if not (_a926 or _a927) then break end
local _a928, _a929, _a930, _a931
local function _a932()
if _a926 then
pcall(function() _a928, _a929 = _a16.R_PetSlot:InvokeServer(_a925.petNext) end)
else
pcall(function() _a928, _a929 = _a16.R_EggSlot:InvokeServer(_a925.eggEnd) end)
end
end
if _a926 then
_a930 = ("펫 장착 슬롯 #%d (%s 다이아)"):format(_a925.petNext, _a6(_a925.petCost, 0))
_a931 = "EquipSlotsMachine"
else
_a930 = ("알 부화 슬롯 %d칸 → %d (%s 다이아)"):format(
_a925.eggSize, _a925.eggEnd, _a6(_a925.eggCost, 0))
_a931 = "EggSlotsMachine"
end
_a932()
if not _a928 and tostring(_a929):find("far away") then
local _a933 = _a18.move.machinePos(_a931)
if _a933 then
_a18.ctl.setAct("슬롯 머신으로 이동", _a931)
_a18.move.glideTo(_a933)
task.wait(0.25)
_a928, _a929 = nil, nil
_a932()
else
_a929 = "머신 위치를 못 찾음 (" .. _a931 .. ")"
end
end
if _a928 then
_a923 += 1
_a13.mslot += 1
_a18.mach.slotSaid = nil
_a18.ctl.setAct("슬롯 구매", _a930)
_a5("  ⬆ " .. _a930)
task.wait(0.35)
else
local _a934 = _a930 .. " 실패: " .. tostring(_a929)
if _a18.mach.slotSaid ~= _a934 then
_a18.mach.slotSaid = _a934
_a5("[슬롯] " .. _a934)
end
break
end
end
if _a923 > 0 then
local _a935 = _a18.mach.slotStatus()
_a5(("[슬롯] %d개 구매 — 장착 %s / 한번에 %s개 부화 (다이아 %s 남음)"):format(
_a923, tostring(_a935 and _a935.maxEquip), tostring(_a935 and _a935.maxHatch),
_a6(_a60("Diamonds"), 0)))
end
end
function _a18.mach.upgList()
local _a936 = {}
if not _a16.Upg then return _a936 end
local _a937, _a938 = pcall(_a16.Upg.All)
if not (_a937 and type(_a938) == "table") then return _a936 end
for _a939, _a940 in ipairs(_a938) do
local _a941, _a942, _a943 = rawget(_a940, "UpgradeID"), rawget(_a940, "ZoneID"), rawget(_a940, "UpgradeTier")
if _a941 and _a942 and _a943 then
local _a944 = false
if rawget(_a16.Upg, "Owns") then
local _a945, _a946 = pcall(_a16.Upg.Owns, _a941, _a942)
_a944 = _a945 and _a946 and true or false
end
local _a947 = _a18.move.ownsZone(_a942)
local _a948 = _a16.DirUpg and rawget(_a16.DirUpg, _a941)
local _a949 = _a948 and rawget(_a948, "TierCosts")
local _a950 = _a949 and tonumber(_a949[_a943])
local _a951 = "Diamonds"
local _a952 = _a948 and rawget(_a948, "TierCurrencies")
local _a953 = _a952 and _a952[_a943]
if type(_a953) == "table" and rawget(_a953, "_id") then _a951 = rawget(_a953, "_id") end
local _a954 = rawget(_a940, "Model")
local _a955
if typeof(_a954) == "Instance" then
if _a954:IsA("BasePart") then _a955 = _a954.Position
else
local _a956, _a957 = pcall(function() return _a954:GetPivot() end)
if _a956 and _a957 then _a955 = _a957.Position end
end
end
_a936[#_a936 + 1] = {
id = _a941, zone = _a942, tier = _a943, cost = _a950, cur = _a951,
bought = _a944, zoneOwned = _a947,
buyable = _a947 and not _a944,
pos = _a955, model = _a954,
}
end
end
table.sort(_a936, function(_a958, _a959) return (_a958.cost or math.huge) < (_a959.cost or math.huge) end)
return _a936
end
function _a18.mach.cycleUpg()
if not _a16.R_Upg then _a5("[맵업글] Upgrades_Purchase 리모트 없음") return end
local _a960 = _a18.mach.upgList()
if #_a960 == 0 then return end
local _a961 = 0
for _a962, _a963 in ipairs(_a960) do
if not _a12.mapupg then break end
if _a963.buyable and _a963.cost then
local _a964 = _a60(_a963.cur or "Diamonds")
if _a964 - _a11.UpgReserve < _a963.cost then break end
if _a11.UpgTp and _a963.pos and _a963.zone == _a18.move.curZone() then
_a18.move.glideTo(_a963.pos)
end
local _a965, _a966
pcall(function() _a965, _a966 = _a16.R_Upg:InvokeServer(_a963.id, _a963.zone) end)
if _a965 then
_a961 += 1
_a13.mapupg += 1
_a18.ctl.setAct("맵 업글", _a963.id .. " T" .. _a963.tier)
_a5(("  ▲ 맵업글  %s T%d  @%s   (%s 다이아)"):format(
_a963.id, _a963.tier, _a963.zone, _a6(_a963.cost, 0)))
elseif _a966 then
_a5(("[맵업글] %s T%d @%s 실패: %s"):format(
_a963.id, _a963.tier, _a963.zone, tostring(_a966)))
end
task.wait(_a11.ActionGap)
end
end
if _a961 > 0 then
_a5(("[맵업글] %d개 구매  (다이아 %s 남음)"):format(_a961, _a6(_a60("Diamonds"), 0)))
end
end
local function _a967()
local _a968 = _a45()
if not _a968 then return nil end
local _a969 = tonumber(rawget(_a968, "Rebirths")) or 0
local _a970 = _a969 + 1
local _a971
if _a16.Rebirth and rawget(_a16.Rebirth, "GetNextRebirth") then
local _a972, _a973 = pcall(_a16.Rebirth.GetNextRebirth, _a968)
if _a972 then _a971 = _a973 end
end
return { current = _a969, nextN = _a970, def = _a971 }
end
local function _a974()
if not _a16.R_Reb then _a5("[리버스] Rebirth_Request 리모트 없음") return end
local _a975 = _a967()
if not _a975 then
_a18.auto.rebNote = "세이브를 못 읽음"
return
end
local _a976, _a977
pcall(function() _a976, _a977 = _a16.R_Reb:InvokeServer(_a975.nextN) end)
if _a976 then
_a13.mreb += 1
_a18.auto.rebNote, _a18.auto.rebSaid = nil, nil
_a5(("  ★ 리버스 %d → %d"):format(_a975.current, _a975.nextN))
task.wait(0.5)
_a18.screen.dismissRewardScreens(25)
else
_a18.auto.rebNote = ("%d → %d : %s"):format(_a975.current, _a975.nextN,
_a977 and tostring(_a977) or "조건 미달 (리버스 킬/존 요구치)")
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
{ key = "mreb",   label = "리버스",  run = "mreb",  fn = function() _a974() end,
hold = true },
{ key = "zone",   label = "존 해금", run = "zone",  fn = function() _a88() end,
hold = true },
{ key = "quest",  label = "랭크 퀘스트+보상", run = "quest", fn = function()
local _a978 = _a12.farm
_a12.farm = true
pcall(_a70)
_a12.farm = _a978
local _a979 = _a18.quest.cycle()
if not _a979 then
local _a980 = _a18.move.bestZone()
if _a980 then
local _a981, _a982 = _a18.move.goToZone(_a980)
if not _a981 then
if _a982 and _a18.auto.idleMoveSaid ~= tostring(_a982) then
_a18.auto.idleMoveSaid = tostring(_a982)
_a5("[자동] 최고 존 이동 실패: " .. tostring(_a982))
end
else
_a18.auto.idleMoveSaid = nil
end
end
if not _a11.IdleHatch then
_a18.ctl.setAct("파밍 중", ("퀘스트 없음 @%s"):format(tostring(_a18.move.curZone())))
return
end
local _a983 = _a118()
local _a984 = math.max(1, _a11.HatchMinAfford or 10)
if _a983 and _a983.price and _a983.canBuy < _a984 then
_a18.ctl.setAct("돈 버는 중", ("%s  %d/%d개분  개당 %s %s"):format(
tostring(_a18.move.curZone()), _a983.canBuy, _a984,
_a6(_a983.price, 0), tostring(_a983.currency)))
else
_a18.ctl.setAct("대기 중 부화")
local _a985 = _a12.mhatch
_a12.mhatch = true
pcall(_a129)
_a12.mhatch = _a985
end
end
end },
}
_a11.StepOn = {}
for _a986, _a987 in ipairs(_a18.auto.SIDE) do _a11.StepOn[_a987.key] = true end
for _a988, _a989 in ipairs(_a18.auto.STEPS) do _a11.StepOn[_a989.key] = true end
local function _a990(_a991, _a992, _a993, _a994)
if not _a11.StepOn[_a991.key] then
_a994[#_a994 + 1] = ("%-14s 꺼져있음"):format(_a991.label)
return
end
if _a991.hold and _a992 then
_a994[#_a994 + 1] = ("%-14s 보류 (%s)"):format(
_a991.label, _a993 and tostring(_a993.title) or "?")
if _a18.auto.heldMsg ~= _a991.key then
_a18.auto.heldMsg = _a991.key
_a5(("[자동] %s 보류 — best 존이 바뀌면 깨지는 퀘스트 진행 중 (%s)"):format(
_a991.label, _a993 and tostring(_a993.title) or "?"))
end
return
end
if _a991.hold then _a18.auto.heldMsg = nil end
_a18.auto.step = _a991.label
_a18.ctl.now.step = _a991.label
_a18.ctl.setAct("시작", _a991.label)
local _a995 = os.clock()
local _a996 = _a12[_a991.run]
_a12[_a991.run] = true
local _a997, _a998 = pcall(_a991.fn)
_a12[_a991.run] = _a996
local _a999 = os.clock() - _a995
if not _a997 then
_a994[#_a994 + 1] = ("%-14s 오류: %s"):format(_a991.label, tostring(_a998))
_a5("[자동] " .. _a991.label .. " 오류: " .. tostring(_a998))
else
local _a1000 = (_a991.key == "zone" and _a18.auto.zoneNote)
or (_a991.key == "mreb" and _a18.auto.rebNote) or nil
_a994[#_a994 + 1] = ("%-14s 실행 %.1f초%s"):format(
_a991.label, _a999, _a1000 and ("  → " .. _a1000) or "")
end
end
function _a18.auto.master()
local _a1001 = {}
_a18.auto.lastTrace = _a1001
_a18.auto.lastPassAt = os.clock()
if _a18.screen.rewardScreenUp() then
_a1001[#_a1001 + 1] = "보상 화면 넘기는 중"
_a18.screen.dismissRewardScreens(15)
end
for _a1002, _a1003 in ipairs(_a18.auto.SIDE) do
if not _a12.auto or _a18.ctl.stopped() then return end
_a990(_a1003, false, nil, _a1001)
end
local _a1004, _a1005 = false, nil
if _a11.HoldZoneForQuest then _a1004, _a1005 = _a18.quest.bestDepActive() end
for _a1006, _a1007 in ipairs(_a18.auto.STEPS) do
if not _a12.auto or _a18.ctl.stopped() then break end
_a990(_a1007, _a1004, _a1005, _a1001)
end
_a18.auto.step = nil
if not _a18.ctl.lockGoal then
_a18.ctl.now.step = "대기"
_a18.ctl.setAct("다음 바퀴 대기", ("%.0f초 주기"):format(_a11.AutoInterval or 5))
end
local _a1008 = {}
for _a1009, _a1010 in ipairs(_a1001) do _a1008[#_a1008 + 1] = (_a1010:gsub("[%d%.]+초", "")) end
_a1008 = table.concat(_a1008, " | ")
if _a1008 ~= _a18.auto.lastSig then
_a18.auto.lastSig = _a1008
_a5("[자동] 바퀴 " .. (_a18.auto.passN or 0))
for _a1011, _a1012 in ipairs(_a1001) do _a5("    " .. _a1012) end
end
_a18.auto.passN = (_a18.auto.passN or 0) + 1
end
local function _a1013()
if not _a10.R_PROMO then _a5("[타워업글] 리모트 없음") return end
local _a1014 = _a14()
if not _a1014 then return end
local _a1015 = _a15(_a1014)
table.sort(_a1015, function(_a1016, _a1017) return (_a1016.dps or 0) > (_a1017.dps or 0) end)
local _a1018, _a1019 = 0, 0
for _a1020, _a1021 in ipairs(_a1015) do
if not _a12.towerup then break end
if _a1021.id then
local _a1022
pcall(function() _a1022 = _a10.R_PROMO:InvokeServer(_a1021.id) end)
if _a1022 ~= nil and _a1022 ~= false then
_a1018 += 1
_a5(("  ▲ 타워업글  %s  Lv%s → Lv%s"):format(tostring(_a1021.kind), tostring(_a1021.up), tostring((_a1021.up or 0) + 1)))
_a1019 = 0
task.wait(_a11.ActionGap)
else
_a1019 += 1
if _a1019 >= 5 then break end
end
end
end
_a5("[타워업글] " .. _a1018 .. "건")
end
local _a1023 = {}
local _a1024 = {}
local function _a1025(_a1026, _a1027)
local _a1028 = tostring(_a1027)
local _a1029 = _a1024[_a1026]
if _a1029 and _a1029.msg == _a1028 then
_a1029.n += 1
if _a1029.n % 20 == 0 then
_a5(("[%s 오류] %s   (%d회 반복)"):format(_a1026, _a1028, _a1029.n))
end
return
end
_a1024[_a1026] = { msg = _a1028, n = 1 }
_a5("[" .. _a1026 .. " 오류] " .. _a1028)
end
local function _a1030(_a1031, _a1032, _a1033, _a1034)
_a1023[_a1031] = (_a1023[_a1031] or 0) + 1
local _a1035 = _a1023[_a1031]
task.spawn(function()
while _a12[_a1031] and _a1023[_a1031] == _a1035 do
local _a1036, _a1037 = pcall(_a1033)
if not _a1036 then _a1025(_a1034, _a1037) else _a1024[_a1034] = nil end
local _a1038, _a1039 = _a1032(), 0
while _a1039 < _a1038 and _a12[_a1031] and _a1023[_a1031] == _a1035 do task.wait(0.1) _a1039 += 0.1 end
end
if _a1023[_a1031] == _a1035 then _a5("[" .. _a1034 .. "] 중지") end
end)
end
do
local _a1040 = {
farm   = { function() return _a11.FarmInterval end,      function() _a70() end,      "파밍" },
zone   = { function() return _a11.ZoneInterval end,      function() _a88() end,      "존" },
mhatch = { function() return _a11.MainHatchInterval end, function() _a129() end, "부화" },
}
function _a18.auto.turnOn(_a1041, _a1042)
if _a12.auto then return end
if _a12[_a1041] then return end
local _a1043 = _a1040[_a1041]
if not _a1043 then return end
_a12[_a1041] = true
_a1030(_a1041, _a1043[1], _a1043[2], _a1043[3])
if _a18.auto.refresh then _a18.auto.refresh() end
_a5("[퀘스트] " .. tostring(_a1042) .. " ON")
end
end
_a1.MG, _a1.QS, _a1.saveGet, _a1.currencyAmount, _a1.cycleFarm, _a1.zoneStatus = _a16, _a18, _a45, _a60, _a70, _a84
_a1.cycleZone, _a1.bestMainEgg, _a1.mainHatchStatus, _a1.cycleMainHatch, _a1.mainRebirthStatus, _a1.cycleMainRebirth = _a88, _a93, _a118, _a129, _a967, _a974
_a1.cycleTowerUp, _a1.startLoop = _a1013, _a1030
end
