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
local _a25 = _a4.Character
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
local _a34 = _a4.Character
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
if not _a8.Save then return nil end
local _a46, _a47 = pcall(_a8.Save.Get)
return (_a46 and type(_a47) == "table") and _a47 or nil
end
local function _a48(_a49, _a50)
if _a16.Currency and rawget(_a16.Currency, "CanAfford") then
local _a51, _a52 = pcall(_a16.Currency.CanAfford, _a49, _a50)
if _a51 then return _a52 and true or false end
end
return false
end
local function _a53(_a54)
if _a16.Currency and rawget(_a16.Currency, "Get") then
local _a55, _a56 = pcall(_a16.Currency.Get, _a54)
if _a55 and tonumber(_a56) then return tonumber(_a56) end
end
return 0
end
local function _a57()
if _a16.AutoFarm and rawget(_a16.AutoFarm, "IsEnabled") then
local _a58, _a59 = pcall(_a16.AutoFarm.IsEnabled)
if _a58 then return _a59 and true or false end
end
return false
end
local function _a60()
if _a16.AutoFarm and rawget(_a16.AutoFarm, "GetTargetParentId") then
local _a61, _a62 = pcall(_a16.AutoFarm.GetTargetParentId)
if _a61 then return _a62 end
end
return nil
end
local function _a63()
if not _a16.R_Farm then _a5("[파밍] AutoFarm_Enable 리모트 없음") return end
local _a64 = _a57()
_a18.auto.farmZone, _a18.auto.hereZone = _a60(), _a18.move.curZone()
if _a64 then
local _a65, _a66 = _a60(), _a18.move.curZone()
if _a65 and _a66 and _a65 ~= _a66 then
_a5(("[파밍] 대상이 %s 인데 지금은 %s — 다시 켬"):format(
tostring(_a65), tostring(_a66)))
if _a16.R_FarmOff then pcall(function() _a16.R_FarmOff:InvokeServer() end) end
if _a16.AutoFarm and rawget(_a16.AutoFarm, "ForceDisable") then
pcall(_a16.AutoFarm.ForceDisable)
end
task.wait(0.3)
_a64 = false
end
end
if _a64 then return end
local _a67, _a68
pcall(function() _a67, _a68 = _a16.R_Farm:InvokeServer() end)
if _a67 then
_a13.farm += 1
_a18.auto.farmSaid = nil
_a5("[파밍] 자동 파밍 ON  (대상 " .. tostring(_a60() or _a18.move.curZone()) .. ")")
elseif _a68 and _a18.auto.farmSaid ~= tostring(_a68) then
_a18.auto.farmSaid = tostring(_a68)
_a5("[파밍] 실패: " .. tostring(_a68))
end
end
local function _a69()
if not (_a16.Zone and rawget(_a16.Zone, "GetNextZone")) then return nil end
local _a70, _a71, _a72 = pcall(_a16.Zone.GetNextZone)
if not _a70 then return nil end
return _a72 or _a71
end
local function _a73(_a74)
if not (_a16.Bal and rawget(_a16.Bal, "CalcGatePrice")) then return nil end
local _a75, _a76 = pcall(_a16.Bal.CalcGatePrice, _a74)
return (_a75 and tonumber(_a76)) or nil
end
local function _a77()
local _a78 = _a69()
if not _a78 then return nil end
local _a79 = _a73(_a78)
local _a80 = rawget(_a78, "Currency")
return {
zone = _a78, id = rawget(_a78, "_id"), price = _a79, currency = _a80,
have = _a80 and _a53(_a80) or 0,
ok = (_a79 and _a80) and _a48(_a80, _a79) or false,
}
end
local function _a81()
if not _a16.R_Zone then _a5("[존] Zones_RequestPurchase 리모트 없음") return end
local _a82 = 0
while _a12.zone and not _a18.ctl.stopped() and _a82 < 20 do
_a82 += 1
local _a83 = _a77()
if not _a83 then
_a18.auto.zoneNote = "다음 존을 못 구함 (GetNextZone 실패 / 존 퀘스트 미완료?)"
if _a18.auto.zoneSaid ~= _a18.auto.zoneNote then
_a18.auto.zoneSaid = _a18.auto.zoneNote
_a5("[존] " .. _a18.auto.zoneNote)
end
return
end
if not _a83.ok then
_a18.auto.zoneNote = ("%s  %s %s / 보유 %s — 부족"):format(
tostring(_a83.id), _a6(_a83.price or 0, 0), tostring(_a83.currency), _a6(_a83.have, 0))
if _a18.auto.zoneSaid ~= _a18.auto.zoneNote then
_a18.auto.zoneSaid = _a18.auto.zoneNote
_a5("[존] " .. _a18.auto.zoneNote)
end
return
end
_a18.auto.zoneSaid = nil
local _a84, _a85
pcall(function() _a84, _a85 = _a16.R_Zone:InvokeServer(_a83.id) end)
task.wait(0.5)
if _a84 then
_a13.zone += 1
_a5(("  ▶ 존 해금  %s   (%s %s)"):format(
tostring(_a83.id), _a6(_a83.price or 0, 0), tostring(_a83.currency)))
else
if _a85 then _a5("[존] 실패: " .. tostring(_a85)) end
return
end
task.wait(_a11.ActionGap)
end
end
local function _a86()
local _a87 = _a18.egg.eggStands()
local _a88 = (_a11.MainEggId and _a11.MainEggId ~= "") and _a11.MainEggId or nil
if _a88 then
for _a89, _a90 in ipairs(_a87) do
if _a90.id == _a88 then return _a90.id, _a90.def, _a90.dist end
end
local _a91 = _a16.DirEggs and rawget(_a16.DirEggs, _a88)
if _a91 then return _a88, _a91, nil, (_a87[1] and _a87[1].dist) end
return nil
end
if not _a16.DirEggs then return nil end
local _a92, _a93, _a94 = nil, nil, -1
for _a95, _a96 in pairs(_a16.DirEggs) do
if type(_a96) == "table" and not rawget(_a96, "isCustomEgg") then
local _a97 = tonumber(rawget(_a96, "eggNumber"))
if _a97 and _a97 > _a94 and _a18.egg.eggUnlocked(_a97) then
_a92, _a93, _a94 = _a95, _a96, _a97
end
end
end
if not _a92 then return nil end
local _a98, _a99
for _a100, _a101 in ipairs(_a87) do
if not _a99 then _a99 = _a101.dist end
if _a101.id == _a92 then _a98 = _a101.dist break end
end
if _a98 and _a98 <= _a11.EggRange then
return _a92, _a93, _a98
end
return _a92, _a93, nil, _a98 or _a99
end
local function _a102(_a103)
if type(_a16.CalcEgg) == "function" then
local _a104, _a105 = pcall(_a16.CalcEgg, _a103)
if _a104 and tonumber(_a105) then return tonumber(_a105) end
if not _a104 and not _a18.egg.priceWarned then
_a18.egg.priceWarned = true
_a5("[부화] CalcEggPricePlayer 막힘 → 기본가로 계산: " .. tostring(_a105))
end
end
if type(_a16.CalcEggB) == "function" then
local _a106, _a107 = pcall(_a16.CalcEggB, _a103)
if _a106 and tonumber(_a107) then return tonumber(_a107) end
end
for _a108, _a109 in ipairs({ "price", "Price", "cost", "Cost" }) do
local _a110 = tonumber(rawget(_a103, _a109))
if _a110 then return _a110 end
end
return nil
end
local function _a111()
local _a112, _a113, _a114, _a115 = _a86()
if not _a112 then return nil end
local _a116 = _a102(_a113)
local _a117 = rawget(_a113, "currency") or "Coins"
local _a118 = 1
if _a16.Egg and rawget(_a16.Egg, "GetMaxHatch") then
local _a119, _a120 = pcall(_a16.Egg.GetMaxHatch, _a113)
if _a119 and tonumber(_a120) then _a118 = math.max(1, math.floor(tonumber(_a120))) end
end
local _a121 = _a53(_a117)
return {
id = _a112, def = _a113, price = _a116, currency = _a117, maxN = _a118, have = _a121,
dist = _a114, nearest = _a115, inRange = _a114 ~= nil,
canBuy = (_a116 and _a116 > 0) and math.floor(math.max(0, _a121 - _a11.MainHatchReserve) / _a116) or 0,
}
end
local function _a122()
if not _a10.R_EGG then _a5("[부화] Eggs_RequestPurchase 리모트 없음") return end
if _a11.AutoUnlockEgg then
local _a123, _a124, _a125 = _a18.egg.lockedEggs()
if _a124 > _a125 then
local _a126 = _a18.egg.unlockEggs()
if _a126 > 0 then _a5(("[부화] 알 %d개 해금 (해금가능 #%d)"):format(_a126, _a124)) end
end
end
local _a127 = _a111()
if not _a127 then _a5("[부화] 알을 못 찾음") return end
if not _a127.inRange then
if _a11.HatchAutoTp then
local _a128, _a129 = _a18.egg.tpEgg(_a127.id)
if not _a128 then
if not _a18.egg.hatchWarned then
_a18.egg.hatchWarned = true
_a5("[부화] 알로 이동 실패: " .. tostring(_a129))
end
return
end
_a5("[부화] " .. _a127.id .. " 로 이동")
_a127 = _a111()
if not (_a127 and _a127.inRange) then return end
else
if not _a18.egg.hatchWarned then
_a18.egg.hatchWarned = true
_a5(("[부화] 알 근처로 가주세요 (가장 가까운 알까지 %s스터드, 인식 %d)"):format(
_a127.nearest and ("%.0f"):format(_a127.nearest) or "?", _a11.EggRange))
end
return
end
end
_a18.egg.hatchWarned = false
local _a130 = math.min(_a127.maxN, _a11.MainHatchMax)
local _a131 = _a127.price and math.min(_a127.canBuy, _a130) or _a130
if _a131 < 1 then return end
local _a132, _a133 = 0, 0
local function _a134()
return tonumber(_a16.Vars and rawget(_a16.Vars, "OpeningEgg")) or 0
end
local _a135 = _a16.Vars and rawget(_a16.Vars, "OpeningEgg") ~= nil
local _a136 = 2.5
if _a16.Egg and rawget(_a16.Egg, "ComputeDebounce") then
local _a137, _a138 = pcall(_a16.Egg.ComputeDebounce)
if _a137 and tonumber(_a138) then _a136 = tonumber(_a138) end
end
_a18.egg.autoHatchOn(_a127.id, _a131)
local _a139 = false
local _a140 = _a18.ctl.lockGoal and _a18.ctl.lockGoal.q
local _a141 = _a140 and (_a140.how == "hatch" or _a140.where == "bestegg") or false
local _a142 = _a141 and math.huge
or (os.clock() + math.max(3, _a11.HatchBudget or 25))
local _a143 = _a141 and 100000 or 400
while _a12.mhatch and not _a18.ctl.stopped() and _a131 >= 1 and _a133 < _a143 and os.clock() < _a142 do
if _a141 and (_a133 % 5 == 0) then
local _a144 = _a18.quest.findQuest(_a140.uid)
if not _a144 or _a144.progress >= _a144.amount then break end
end
_a133 += 1
if _a135 then
local _a145 = os.clock()
local _a146 = _a11.HatchClickAfter
local _a147 = false
while _a134() > 0 and _a12.mhatch and not _a18.ctl.stopped()
and (os.clock() - _a145) < 20 do
if _a11.HatchClick and (os.clock() - _a145) > _a146 then
_a18.egg.clickOnce()
_a146 += 0.3
if (os.clock() - _a145) > 3 and not _a147 then
_a147 = true
_a18.egg._ahEgg = nil
_a18.egg.autoHatchOn(_a127.id, _a131)
_a5("[부화] 화면이 안 넘어가서 오토해치 재설정")
end
end
task.wait(0.03)
end
if _a134() > 0 then
if _a18.egg.hatchStuck ~= _a127.id then
_a18.egg.hatchStuck = _a127.id
_a5("[부화] " .. tostring(_a127.id) .. " 까는 화면에서 멈춤 — 이번 회차 중단")
end
_a139 = true
break
end
_a18.egg.hatchStuck = nil
else
local _a148 = os.clock() - (_a18.egg.lastHatch or 0)
if _a148 < _a136 then task.wait(_a136 - _a148) end
end
_a18.egg.lastHatch = os.clock()
_a18.ctl.setAct("알 까는 중", ("%s x%d  (총 %d)"):format(_a127.id, _a131, _a132))
local _a149, _a150
local _a151 = pcall(function() _a149, _a150 = _a10.R_EGG:InvokeServer(_a127.id, _a131) end)
if _a149 then
_a132 += _a131
_a13.mhatch += _a131
_a18.egg.hatchErr = nil
if _a127.price then
local _a152 = _a53(_a127.currency)
local _a153 = math.floor(math.max(0, _a152 - _a11.MainHatchReserve) / _a127.price)
if _a153 < 1 then break end
_a131 = math.min(_a153, _a130)
end
else
local _a154 = _a151 and tostring(_a150) or "호출 자체 실패"
if _a154:find("quickly") or _a154:find("fast") then
task.wait(0.25)
elseif _a154:find("far away") then
if _a11.HatchAutoTp then _a18.egg.tpEgg(_a127.id) task.wait(0.2)
else _a5("[부화] 알에서 너무 멈") break end
elseif _a131 > 1 then
_a131 = math.floor(_a131 / 2)
else
if _a18.egg.hatchErr ~= _a154 then
_a18.egg.hatchErr = _a154
_a5("[부화] 실패: " .. _a154 .. "   (알 " .. tostring(_a127.id)
.. " / 개수 " .. _a131 .. " / 거리 "
.. (_a127.dist and ("%.0f"):format(_a127.dist) or "?") .. ")")
end
break
end
end
end
if _a135 and _a132 > 0 and not _a139 then
local _a155 = os.clock()
local _a156 = _a11.HatchClickAfter
while _a134() > 0 and not _a18.ctl.stopped() and (os.clock() - _a155) < 20 do
_a18.ctl.setAct("알 마무리", ("%s  마지막 %d개 까는 중"):format(_a127.id, _a131))
if _a11.HatchClick and (os.clock() - _a155) > _a156 then
_a18.egg.clickOnce()
_a156 += 0.3
if (os.clock() - _a155) > 3 and not _a18.egg._finRe then
_a18.egg._finRe = true
_a18.egg._ahEgg = nil
_a18.egg.autoHatchOn(_a127.id, _a131)
end
end
task.wait(0.03)
end
_a18.egg._finRe = nil
if _a134() > 0 then
_a5("[부화] 마지막 알이 20초 넘게 안 끝남 — 그대로 두고 진행합니다")
end
end
_a18.egg.autoHatchOff()
if _a132 > 0 then
_a18.egg.hatchErr = nil
_a5(("[부화] %s × %d%s  (개당 %s %s)"):format(
_a127.id, _a132, _a141 and " (목표까지)" or "",
_a127.price and _a6(_a127.price, 0) or "?", tostring(_a127.currency)))
end
end
local function _a157()
local _a158 = _a45()
if not _a158 then return nil end
local _a159 = tonumber(rawget(_a158, "Rank")) or 1
local _a160 = tonumber(rawget(_a158, "RankStars")) or 0
local _a161 = rawget(_a158, "RedeemedRankRewards") or {}
local _a162
if _a16.RanksU and rawget(_a16.RanksU, "RankIDFromNumber") then
local _a163, _a164 = pcall(_a16.RanksU.RankIDFromNumber, _a159)
if _a163 then _a162 = _a164 end
end
local _a165 = _a162 and _a16.DirRanks and rawget(_a16.DirRanks, _a162)
if type(_a165) ~= "table" then
return { rankNum = _a159, stars = _a160, rankId = _a162, rewards = {} }
end
local _a166, _a167 = {}, 0
for _a168, _a169 in ipairs(rawget(_a165, "Rewards") or {}) do
_a167 += (tonumber(rawget(_a169, "StarsRequired")) or 0)
local _a170 = _a167 <= _a160
local _a171 = _a161[tostring(_a168)] ~= nil
_a166[#_a166 + 1] = {
index = _a168, need = _a167, earned = _a170, redeemed = _a171,
claimable = _a170 and not _a171,
}
end
return { rankNum = _a159, stars = _a160, rankId = _a162, rewards = _a166 }
end
local function _a172()
if not _a16.R_Rank then _a5("[랭크] Ranks_ClaimReward 리모트 없음") return end
local _a173 = _a157()
if not _a173 then return end
local _a174 = 0
for _a175, _a176 in ipairs(_a173.rewards) do
if not _a12.rank then break end
if _a176.claimable then
pcall(function() _a16.R_Rank:FireServer(_a176.index) end)
_a174 += 1
_a13.rank += 1
task.wait(0.1)
end
end
if _a174 > 0 then
_a5(("[랭크] 보상 %d개 수령  (Rank %d, ★%d)"):format(_a174, _a173.rankNum, _a173.stars))
end
end
function _a18.move.hrp()
local _a177 = _a4.Character
return _a177 and _a177:FindFirstChild("HumanoidRootPart"),
_a177 and _a177:FindFirstChildOfClass("Humanoid")
end
function _a18.egg.autoHatchOn(_a178, _a179)
if not _a11.UseAutoHatch then return end
if _a18.egg._ahEgg == _a178 and _a18.egg._ahAt and (os.clock() - _a18.egg._ahAt) < 15 then return end
_a18.egg._ahEgg, _a18.egg._ahAt = _a178, os.clock()
local _a180 = _a16.DirEggs and rawget(_a16.DirEggs, _a178)
if _a16.Hatch and _a180 and rawget(_a16.Hatch, "SetupEgg") then
local _a181, _a182 = pcall(_a16.Hatch.SetupEgg, _a180, _a179 or 1)
if not _a181 and not _a18.egg._ahWarn then
_a18.egg._ahWarn = true
_a5("[부화] SetupEgg 실패: " .. tostring(_a182) .. "  → 클릭 대체 사용")
end
end
if _a16.R_AHTog then pcall(function() _a16.R_AHTog:FireServer(true) end) end
if _a16.R_AHOn then pcall(function() _a16.R_AHOn:FireServer(_a178, _a179 or 1) end) end
if _a16.Hatch and rawget(_a16.Hatch, "IsHatching") then
local _a183, _a184 = pcall(_a16.Hatch.IsHatching)
_a18.egg._ahLive = _a183 and _a184 and true or false
end
end
function _a18.egg.autoHatchOff()
_a18.egg._ahEgg, _a18.egg._ahAt, _a18.egg._ahLive = nil, nil, nil
if _a16.Hatch and rawget(_a16.Hatch, "StopHatching") then pcall(_a16.Hatch.StopHatching) end
if _a16.R_AHOff then pcall(function() _a16.R_AHOff:FireServer() end) end
end
function _a18.egg.clickOnce()
if _a18.ctl.moving then return false end
local _a185 = _a18.screen.signal("egg")
if not _a185 then _a185 = _a18.screen.pressInGame({ "Egg Opening" }) end
if not _a185 and not _a18.egg._eggSigWarn then
_a18.egg._eggSigWarn = true
_a5("[부화] 게임 내 방법이 다 막힘 — SetupEgg 에만 의존합니다")
end
return _a185
end
function _a18.item.applyPetSpeed()
local _a186 = _a16.PlayerPet
if not (_a186 and rawget(_a186, "GetByPlayer")) then return 0, "PlayerPet 없음" end
local _a187, _a188 = pcall(_a186.GetByPlayer, _a4)
if not (_a187 and type(_a188) == "table") then return 0, "펫 목록 못 읽음" end
local _a189 = math.max(1, tonumber(_a11.PetSpeedMult) or 50)
local _a190 = math.max(0.05, tonumber(_a11.PetSpeedBase) or 4)
local _a191 = 0
for _a192, _a193 in pairs(_a188) do
if type(_a193) == "table" then
local _a194 = rawget(_a193, "cpet")
if _a194 then
_a193.speedMult = _a189
pcall(function() _a194:Broadcast("petSpeedMult", _a189) end)
pcall(function() _a194:Broadcast("petSpeed", _a190) end)
_a191 += 1
end
end
end
return _a191
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
function _a18.screen.findSignalFns(_a195)
local _a196 = _a18.screen.SIGNAL[_a195]
if not _a196 then return {} end
_a18.screen._sig = _a18.screen._sig or {}
local _a197 = _a18.screen._sig[_a195]
if _a197 and (os.clock() - _a197.at) < (#_a197.fns > 0 and 20 or 3) then return _a197.fns end
local _a198 = {}
_a18.screen._sig[_a195] = { at = os.clock(), fns = _a198 }
if type(getgc) ~= "function" or type(debug) ~= "table"
or type(debug.info) ~= "function" or type(debug.getupvalue) ~= "function" then
return _a198
end
local _a199 = {}
for _a200, _a201 in ipairs({ true, false }) do
local _a202, _a203 = pcall(getgc, _a201)
if _a202 and type(_a203) == "table" then
for _a204, _a205 in ipairs(_a203) do _a199[#_a199 + 1] = _a205 end
end
end
if #_a199 == 0 then return _a198 end
for _a206, _a207 in ipairs(_a199) do
if type(_a207) == "function" then
local _a208, _a209 = pcall(debug.info, _a207, "s")
if _a208 and type(_a209) == "string" then
local _a210 = false
for _a211, _a212 in ipairs(_a196.pats) do
if _a209:find(_a212, 1, true) then _a210 = true break end
end
if _a210 then
local _a213, _a214 = pcall(debug.info, _a207, "a")
if _a213 then
local _a215, _a216 = {}, 0
for _a217 = 1, 16 do
local _a218, _a219 = pcall(debug.getupvalue, _a207, _a217)
if not _a218 then break end
_a216 = _a217
_a215[_a217] = type(_a219)
end
local _a220 = table.concat(_a215, ",")
local _a221 = false
for _a222, _a223 in ipairs(_a196.sigs or {}) do
if _a214 == _a223.np and _a220 == _a223.t then
_a198[#_a198 + 1] = { fn = _a207, sig = _a220, n = _a216, np = _a214,
src = _a209, set = _a223.set }
_a221 = true
break
end
end
if not _a221 and _a196.sigs then
local _a224 = {}
for _a225, _a226 in ipairs(_a215) do
if _a226 == "boolean" then _a224[#_a224 + 1] = _a225 end
end
if #_a224 > 0 then
_a198[#_a198 + 1] = { fn = _a207, idx = _a224, sig = _a220, n = _a216,
np = _a214, src = _a209, loose = true }
end
end
if not _a221 and not _a196.sigs and _a214 == 0 then
local _a227 = 0
for _a228, _a229 in ipairs(_a215) do if _a229 == "boolean" then _a227 += 1 end end
if _a227 >= (_a196.minBools or 1) then
local _a230 = {}
for _a231, _a232 in ipairs(_a215) do
if _a232 == "boolean" then _a230[#_a230 + 1] = _a231 end
end
_a198[#_a198 + 1] = { fn = _a207, idx = _a230, sig = _a220, n = _a216, src = _a209 }
end
end
end
end
end
end
end
return _a198
end
function _a18.screen.signal(_a233)
if type(debug) ~= "table" or type(debug.setupvalue) ~= "function" then return false, 0 end
local _a234 = _a18.screen.findSignalFns(_a233)
local _a235 = 0
for _a236, _a237 in ipairs(_a234) do
if _a237.set then
for _a238, _a239 in ipairs(_a237.set) do
if pcall(debug.setupvalue, _a237.fn, _a239[1], _a239[2]) then _a235 += 1 end
end
elseif not _a237.loose then
for _a240, _a241 in ipairs(_a237.idx or {}) do
if pcall(debug.setupvalue, _a237.fn, _a241, true) then _a235 += 1 end
end
end
end
if _a235 == 0 then
for _a242, _a243 in ipairs(_a234) do
if _a243.loose then
for _a244, _a245 in ipairs(_a243.idx or {}) do
if pcall(debug.setupvalue, _a243.fn, _a245, true) then _a235 += 1 end
end
end
end
end
return _a235 > 0, _a235
end
function _a18.screen.pressInGame(_a246)
local _a247, _a248 = pcall(function() return game:GetService("UserInputService") end)
if not (_a247 and _a248) then return false end
local _a249 = {
UserInputType  = Enum.UserInputType.MouseButton1,
UserInputState = Enum.UserInputState.Begin,
KeyCode        = Enum.KeyCode.Unknown,
Position       = Vector3.new(),
Delta          = Vector3.new(),
}
local _a250 = 0
if type(getconnections) == "function" then
local _a251, _a252 = pcall(getconnections, _a248.InputBegan)
if _a251 and type(_a252) == "table" then
for _a253, _a254 in ipairs(_a252) do
local _a255 = ""
local _a256 = _a254.Function
if _a256 and type(debug) == "table" and type(debug.info) == "function" then
local _a257, _a258 = pcall(debug.info, _a256, "s")
if _a257 and _a258 then _a255 = tostring(_a258) end
end
local _a259 = false
for _a260, _a261 in ipairs(_a246) do
if _a255 ~= "" and _a255:find(_a261, 1, true) then _a259 = true break end
end
if _a259 then
if _a256 and pcall(_a256, _a249, false) then _a250 += 1
elseif _a254.Fire and pcall(function() _a254:Fire(_a249, false) end) then _a250 += 1
elseif _a254.Defer and pcall(function() _a254:Defer(_a249, false) end) then _a250 += 1 end
end
end
end
end
if _a250 == 0 and type(firesignal) == "function" then
if pcall(firesignal, _a248.InputBegan, _a249, false) then _a250 += 1 end
end
return _a250 > 0
end
function _a18.screen.realClick(_a262)
if not _a11.ScreenRealClick then return false end
local _a263 = workspace.CurrentCamera
local _a264 = (_a263 and _a263.ViewportSize) or Vector2.new(1280, 720)
local _a265, _a266 = _a264.X * 0.5, _a264.Y * 0.45
local _a267 = {}
local function _a268(_a269, _a270)
local _a271 = pcall(_a270)
_a267[#_a267 + 1] = _a269 .. (_a271 and "=OK" or "=X")
return _a271
end
local _a272 = false
if not _a272 and type(mouse1click) == "function" then
_a272 = _a268("mouse1click", function() mouse1click() end)
end
if not _a272 and type(mouse1press) == "function" then
_a272 = _a268("mouse1press", function()
mouse1press() task.wait(0.05)
if type(mouse1release) == "function" then mouse1release() end
end)
end
if not _a272 then
_a272 = _a268("VirtualUser", function()
local _a273 = game:GetService("VirtualUser")
_a273:Button1Down(Vector2.new(_a265, _a266), _a263 and _a263.CFrame or CFrame.new())
task.wait(0.05)
_a273:Button1Up(Vector2.new(_a265, _a266), _a263 and _a263.CFrame or CFrame.new())
end)
end
if not _a272 then
_a272 = _a268("VirtualInputManager", function()
local _a274 = game:GetService("VirtualInputManager")
_a274:SendMouseButtonEvent(_a265, _a266, 0, true, game, 1)
task.wait(0.05)
_a274:SendMouseButtonEvent(_a265, _a266, 0, false, game, 1)
end)
end
if _a262 then _a5("    " .. table.concat(_a267, " / ")) end
return _a272
end
function _a18.screen.rewardScreenUp()
if not _a4 then
if not _a18.screen.noLP then
_a18.screen.noLP = true
_a5("[화면] LocalPlayer 를 못 잡았습니다 — 화면 감시를 건너뜁니다")
end
return false
end
local _a275 = _a4:FindFirstChildOfClass("PlayerGui")
if _a275 then
for _a276, _a277 in ipairs(_a18.screen.BLOCKERS) do
local _a278 = _a275:FindFirstChild(_a277[1])
if _a278 and _a278:IsA("ScreenGui") and _a278.Enabled then return true, _a277[2], _a277[3] end
end
end
local _a279 = _a16.Vars
if _a279 then
if rawget(_a279, "IsRebirthing") then return true, "리버스", "reward" end
if rawget(_a279, "IsRankingUp") then return true, "랭크업", "reward" end
end
return false
end
function _a18.screen.dismissRewardScreens(_a280)
if _a18.screen.dismissBusy then return end
_a18.screen.dismissBusy = true
local _a281, _a282 = pcall(_a18.screen.dismissInner, _a280)
_a18.screen.dismissBusy = false
if not _a281 then _a5("[화면] 오류: " .. tostring(_a282)) end
end
function _a18.screen.dismissInner(_a283)
local _a284 = _a16.Vars
if not _a284 then return end
local _a285 = os.clock()
local _a286, _a287 = false, nil
local _a288 = 0
local _a289 = math.max(3, _a11.ScreenTryMax or 8)
while os.clock() - _a285 < (_a283 or 120) do
local _a290, _a291, _a292 = _a18.screen.rewardScreenUp()
if not _a290 then break end
_a286, _a287 = true, _a291
_a288 += 1
_a18.ctl.setAct("보상 화면 넘기는 중",
("%s (%d회%s)"):format(tostring(_a291), _a288,
_a288 <= 6 and " · 첫 화면 대기" or ""))
local _a293 = _a18.screen.SIGNAL[_a292 or "reward"]
local _a294 = (_a293 and _a293.pats) or { "Rebirth", "Rank Up" }
local _a295 = _a18.screen.signal(_a292 or "reward")
if not _a295 then
for _a296 in pairs(_a18.screen.SIGNAL) do
if _a18.screen.signal(_a296) then _a295 = true end
end
end
local _a297 = false
if not _a295 or _a288 >= 2 then
_a297 = _a18.screen.pressInGame(_a294)
end
if _a288 >= 3 then
if _a18.screen.realClick() then
_a297 = true
if not _a18.screen._realSaid then
_a18.screen._realSaid = true
_a5("[화면] 실제 클릭까지 같이 씁니다 (Roblox 창이 켜져 있어야 먹습니다)")
end
end
end
if (_a295 or _a297) and not _a18.screen._sigSaid then
_a18.screen._sigSaid = true
_a5("[화면] " .. (_a295 and "upvalue 신호" or "게임 내 입력 발동") .. " 로 넘깁니다")
end
if _a288 >= _a289 and (os.clock() - _a285) >= 12 then
if _a18.screen.giveUpSaid ~= _a291 then
_a18.screen.giveUpSaid = _a291
_a5(("[화면] %s 화면을 못 넘김 — 그냥 두고 자동화는 계속합니다"):format(tostring(_a291)))
_a5("        (이 화면은 UI만 가릴 뿐 리모트 호출은 막지 않습니다)")
end
_a18.screen.screenGaveUp = os.clock()
return
end
task.wait(0.8)
end
if _a286 then
if not _a18.screen.rewardScreenUp() then
_a18.screen.lastBlocker = nil
_a18.screen.screenGaveUp = nil
_a5(("[화면] %s 넘김 완료 (%d회)"):format(tostring(_a287), _a288))
end
end
end
function _a18.egg.eggUnlocked(_a298)
_a298 = tonumber(_a298)
if not _a298 then return false end
local _a299 = _a45()
local _a300 = _a299 and rawget(_a299, "UnlockedEggs")
if type(_a300) == "table" then
for _a301, _a302 in pairs(_a300) do
if tonumber(_a302) == _a298 then return true end
end
return false
end
return _a298 <= 1
end
function _a18.egg.lockedEggs()
local _a303 = {}
if not _a16.DirEggs then return _a303, 0, 0 end
local _a304 = _a45()
local _a305 = tonumber(_a304 and rawget(_a304, "MaximumAvailableEgg")) or 1
local _a306 = 0
local _a307 = _a304 and rawget(_a304, "UnlockedEggs")
if type(_a307) == "table" then
for _a308, _a309 in pairs(_a307) do
local _a310 = tonumber(_a309)
if _a310 and _a310 > _a306 then _a306 = _a310 end
end
end
for _a311, _a312 in pairs(_a16.DirEggs) do
if type(_a312) == "table" and not rawget(_a312, "isCustomEgg") then
local _a313 = tonumber(rawget(_a312, "eggNumber"))
if _a313 and _a313 <= _a305 and not _a18.egg.eggUnlocked(_a313) then
_a303[#_a303 + 1] = { id = _a311, num = _a313 }
end
end
end
table.sort(_a303, function(_a314, _a315) return _a314.num < _a315.num end)
return _a303, _a305, _a306
end
function _a18.egg.unlockEggs(_a316)
if not _a16.R_EggUn then return 0, "Eggs_RequestUnlock 리모트 없음" end
local _a317 = _a18.egg.lockedEggs()
if #_a317 == 0 then return 0 end
local _a318, _a319 = 0, nil
for _a320, _a321 in ipairs(_a317) do
if not _a18.egg.eggUnlocked(_a321.num) then
local _a322, _a323
pcall(function() _a322, _a323 = _a16.R_EggUn:InvokeServer(_a321.id) end)
if not _a322 and _a11.HatchAutoTp then
local _a324 = _a18.egg.tpEgg(_a321.id)
if _a324 then
task.wait(0.3)
pcall(function() _a322, _a323 = _a16.R_EggUn:InvokeServer(_a321.id) end)
end
end
if _a322 then
_a318 += 1
_a18.ctl.setAct("알 해금", ("#%d %s"):format(_a321.num, _a321.id))
_a5(("  🔓 알 해금  #%d %s"):format(_a321.num, _a321.id))
task.wait(0.15)
else
_a319 = _a323
if _a316 then
_a5(("[해금] #%d %s 실패: %s"):format(_a321.num, _a321.id, tostring(_a323)))
end
end
end
end
return _a318, _a319
end
function _a18.move.curZone()
if _a16.Map and rawget(_a16.Map, "GetCurrentZone") then
local _a325, _a326 = pcall(_a16.Map.GetCurrentZone)
if _a325 then return _a326 end
end
return nil
end
function _a18.move.zone1()
if not _a16.DirZones then return nil end
local _a327, _a328 = nil, math.huge
for _a329, _a330 in pairs(_a16.DirZones) do
if type(_a330) == "table" and _a18.move.ownsZone(_a329) then
local _a331 = tonumber(rawget(_a330, "ZoneNumber")) or math.huge
if _a331 < _a328 then _a327, _a328 = _a329, _a331 end
end
end
return _a327
end
function _a18.move.realZone(_a332) return _a332 end
function _a18.move.resolvableZone(_a333)
if _a333 then
local _a334 = _a18.move.zonePos(_a333)
if _a334 then return _a333, _a334 end
end
if not _a16.DirZones then return nil end
local _a335 = {}
for _a336, _a337 in pairs(_a16.DirZones) do
if type(_a337) == "table" and _a18.move.ownsZone(_a336) then
_a335[#_a335 + 1] = { id = _a336, n = tonumber(rawget(_a337, "ZoneNumber")) or 0 }
end
end
table.sort(_a335, function(_a338, _a339) return _a338.n > _a339.n end)
for _a340, _a341 in ipairs(_a335) do
if _a341.id ~= _a333 then
local _a342 = _a18.move.zonePos(_a341.id)
if _a342 then
if _a18.move.fallZone ~= _a341.id then
_a18.move.fallZone = _a341.id
_a5(("[TP] %s 좌표를 못 구해서 %s 로 대신 감 (로드 안 된 존)"):format(
tostring(_a333), tostring(_a341.id)))
end
return _a341.id, _a342
end
end
end
return nil
end
function _a18.move.bestZone()
if _a16.Zone and rawget(_a16.Zone, "GetMaxOwnedZone") then
local _a343, _a344, _a345 = pcall(_a16.Zone.GetMaxOwnedZone)
if _a343 and _a344 then return _a344, _a345 end
end
return _a18.move.zone1()
end
function _a18.move.ownsZone(_a346)
local _a347 = _a45()
local _a348 = _a347 and rawget(_a347, "UnlockedZones")
return (type(_a348) == "table" and _a348[_a346] ~= nil) or false
end
function _a18.move.zoneByNumber(_a349)
if not (_a16.DirZones and _a349) then return nil end
for _a350, _a351 in pairs(_a16.DirZones) do
if type(_a351) == "table" and tonumber(rawget(_a351, "ZoneNumber")) == tonumber(_a349) then
return _a350, _a351
end
end
return nil
end
local function _a352(_a353, _a354)
local _a355 = rawget(_a353, "Breakables")
local _a356 = type(_a355) == "table" and rawget(_a355, "Main") or nil
local _a357 = type(_a356) == "table" and rawget(_a356, "Data") or nil
if type(_a357) ~= "table" then return false end
for _a358, _a359 in pairs(_a357) do
local _a360 = type(_a359) == "table" and rawget(_a359, "Type") or nil
if _a360 and tostring(_a360):lower():find(_a354, 1, true) then return true end
end
return false
end
function _a18.move.zoneForBreakable(_a361)
if not (_a16.DirZones and _a361) then return nil end
local _a362 = tostring(_a361):lower()
local _a363 = _a18.move.bestZone()
if _a363 then
local _a364 = rawget(_a16.DirZones, _a363)
if type(_a364) == "table" and _a352(_a364, _a362) then return _a363 end
end
local _a365, _a366 = nil, -1
for _a367, _a368 in pairs(_a16.DirZones) do
if type(_a368) == "table" and _a367 ~= "Spawn" and _a18.move.ownsZone(_a367) then
local _a369 = rawget(_a368, "Breakables")
local _a370 = type(_a369) == "table" and rawget(_a369, "Main") or nil
local _a371 = type(_a370) == "table" and rawget(_a370, "Data") or nil
if type(_a371) == "table" then
for _a372, _a373 in pairs(_a371) do
local _a374 = type(_a373) == "table" and rawget(_a373, "Type") or nil
if _a374 and tostring(_a374):lower():find(_a362, 1, true) then
local _a375 = tonumber(rawget(_a368, "ZoneNumber")) or 0
if _a375 > _a366 then _a365, _a366 = _a367, _a375 end
break
end
end
end
end
end
return _a365
end
function _a18.move.tpZone(_a376)
if not _a376 then return false, "존 id 없음" end
if _a18.move.curZone() == _a376 then return true end
if not _a11.TpGameFallback then
_a5("[TP] 게임 정식 TP 차단됨 (" .. tostring(_a376) .. ")\n" .. debug.traceback("", 2))
return false, "게임 TP 꺼져 있음"
end
local _a377 = _a16.R_Tp
if _a16.Inst and rawget(_a16.Inst, "IsInInstance") then
local _a378, _a379 = pcall(_a16.Inst.IsInInstance)
if _a378 and _a379 and _a16.R_TpI then _a377 = _a16.R_TpI end
end
if not _a377 then return false, "텔레포트 리모트 없음" end
local _a380 = os.clock() - (_a18.move.lastTp or 0)
if _a380 < _a11.TpCooldown then task.wait(_a11.TpCooldown - _a380) end
_a18.move.lastTp = os.clock()
local _a381, _a382
pcall(function() _a381, _a382 = _a377:InvokeServer(_a376) end)
if not _a381 then return false, _a382 end
local _a383 = os.clock()
while os.clock() - _a383 < 5 do
if _a18.move.curZone() == _a376 then break end
task.wait(0.05)
end
task.wait(0.15)
return true
end
function _a18.move.glideTo(_a384)
if _a18.ctl.stopped() then return false, "정지됨" end
if _a18.ctl.moving and (os.clock() - _a18.ctl.moving) < 30 then
return false, "이미 이동 중 (다른 이동이 아직 안 끝남)"
end
_a18.ctl.moving = os.clock()
local _a385, _a386, _a387 = pcall(_a18.move.glideRaw, _a384)
_a18.ctl.moving = nil
if not _a385 then return false, tostring(_a386) end
return _a386, _a387
end
function _a18.move.glideRaw(_a388)
local _a389, _a390 = _a18.move.hrp()
if not _a389 then return false, "캐릭터 없음" end
if _a11.TpMode == "instant" then
local _a391 = _a388 + Vector3.new(0, 4, 0)
for _a392 = 1, 3 do
local _a393 = _a4.Character
local _a394, _a395 = _a18.move.hrp()
if not (_a393 and _a394) then return false, "캐릭터 없음" end
local _a396 = _a394.CFrame - _a394.CFrame.Position
pcall(function() _a393:PivotTo(CFrame.new(_a391) * _a396) end)
_a394.AssemblyLinearVelocity = Vector3.zero
for _a397 = 1, 6 do _a3.Heartbeat:Wait() end
if _a395 then
pcall(function()
_a395:Move(Vector3.new(0.3, 0, 0), false)
end)
task.wait(0.1)
pcall(function() _a395:Move(Vector3.zero, false) end)
end
task.wait(0.15)
_a394 = _a18.move.hrp()
if _a394 and (_a394.Position - _a391).Magnitude <= 30 then
local _a398 = os.clock()
while os.clock() - _a398 < 1.5 do
if _a18.move.inDottedBox() ~= false then break end
task.wait(0.05)
end
return true
end
if _a392 < 3 then task.wait(0.15) end
end
return false, "순간이동이 되돌려짐"
end
if _a11.TpMode == "walk" then
if not _a390 then return false, "Humanoid 없음" end
local _a399 = os.clock()
while os.clock() - _a399 < 45 do
local _a400 = _a389.Position
if (Vector3.new(_a400.X, 0, _a400.Z) - Vector3.new(_a388.X, 0, _a388.Z)).Magnitude < 8 then
return true
end
_a390:MoveTo(_a388)
task.wait(0.5)
end
return false, "걸어가다 시간초과"
end
if (_a389.Position - _a388).Magnitude <= (_a11.ArriveDist or 12) then return true end
local _a401 = math.max(16, tonumber(_a11.TpSpeed) or 90)
local _a402 = math.max(0, tonumber(_a11.TpHeight) or 0)
local function _a403(_a404, _a405)
local _a406 = 0
while _a406 < 2000 do
if _a18.ctl.stopped() then return false end
_a406 += 1
local _a407 = _a18.move.hrp()
if not _a407 then return false end
local _a408 = _a407.Position
local _a409 = _a404 - _a408
local _a410 = _a409.Magnitude
if _a410 < 2.5 then return true end
local _a411 = _a3.Heartbeat:Wait()
local _a412 = math.min(_a410, _a401 * math.min(_a411, 0.1))
local _a413 = _a405 and (Vector3.new(_a404.X, _a408.Y, _a404.Z)) or nil
if _a413 and (_a413 - _a408).Magnitude > 1 then
_a407.CFrame = CFrame.lookAt(_a408 + _a409.Unit * _a412, _a413)
else
_a407.CFrame = CFrame.new(_a408 + _a409.Unit * _a412) * (_a407.CFrame - _a407.Position)
end
_a407.AssemblyLinearVelocity = Vector3.zero
end
return false
end
if _a402 > 0 then
local _a414 = _a389.Position
local _a415 = math.max(_a414.Y, _a388.Y) + _a402
_a403(Vector3.new(_a414.X, _a415, _a414.Z), false)
_a403(Vector3.new(_a388.X, _a415, _a388.Z), true)
end
_a403(_a388 + Vector3.new(0, 3, 0), true)
local _a416 = _a18.move.hrp()
if _a416 then _a416.AssemblyLinearVelocity = Vector3.zero end
return true
end
local function _a417(_a418)
local _a419 = #_a418
if _a419 == 0 then return nil, 0 end
local _a420, _a421 = math.huge, -math.huge
local _a422, _a423 = math.huge, -math.huge
local _a424 = 0
for _a425, _a426 in ipairs(_a418) do
if _a426.X < _a420 then _a420 = _a426.X end
if _a426.X > _a421 then _a421 = _a426.X end
if _a426.Z < _a422 then _a422 = _a426.Z end
if _a426.Z > _a423 then _a423 = _a426.Z end
_a424 += _a426.Y
end
return Vector3.new((_a420 + _a421) / 2, _a424 / _a419, (_a422 + _a423) / 2), _a419
end
function _a18.move.breakCenter(_a427)
local _a428 = _a18.move.hrp()
if not _a428 then return nil, 0 end
local _a429 = workspace:FindFirstChild("__THINGS")
if not _a429 then return nil, 0 end
local _a430 = _a428.Position
local _a431 = {}
for _a432, _a433 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a434 = _a429:FindFirstChild(_a433)
if _a434 then
for _a435, _a436 in ipairs(_a434:GetChildren()) do
local _a437
if _a436:IsA("BasePart") then _a437 = _a436.Position
elseif _a436:IsA("Model") then
local _a438, _a439 = pcall(function() return _a436:GetPivot() end)
if _a438 and typeof(_a439) == "CFrame" then _a437 = _a439.Position end
end
if _a437 and (_a437 - _a430).Magnitude <= (_a427 or 400) then
_a431[#_a431 + 1] = _a437
end
end
end
end
return _a417(_a431)
end
function _a18.move.groundY(_a440, _a441, _a442)
_a442 = tonumber(_a442) or 0
local _a443 = RaycastParams.new()
_a443.FilterType = Enum.RaycastFilterType.Exclude
local _a444 = {}
if _a4.Character then _a444[#_a444 + 1] = _a4.Character end
local _a445 = workspace:FindFirstChild("__THINGS")
if _a445 then _a444[#_a444 + 1] = _a445 end
_a443.FilterDescendantsInstances = _a444
local _a446 = Vector3.new(_a440, _a442 + 12, _a441)
local _a447, _a448 = pcall(function()
return workspace:Raycast(_a446, Vector3.new(0, -160, 0), _a443)
end)
if _a447 and _a448 then
local _a449 = _a448.Position.Y
if math.abs(_a449 - _a442) <= 80 then return _a449 + 4 end
end
return nil
end
function _a18.move.zonePos(_a450, _a451)
if not _a450 then return nil, "존 id 없음" end
_a450 = _a18.move.realZone(_a450)
local _a452 = _a16.DirZones and rawget(_a16.DirZones, _a450)
local _a453 = _a452 and rawget(_a452, "ZoneFolder")
local _a454 = {}
do
local _a455 = workspace:FindFirstChild("__THINGS")
for _a456, _a457 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a458 = _a455 and _a455:FindFirstChild(_a457)
if _a458 then
for _a459, _a460 in ipairs(_a458:GetChildren()) do
local _a461
if _a460:IsA("BasePart") then _a461 = _a460.Position
elseif _a460:IsA("Model") then
local _a462, _a463 = pcall(function() return _a460:GetPivot() end)
if _a462 and typeof(_a463) == "CFrame" then _a461 = _a463.Position end
end
if _a461 then _a454[#_a454 + 1] = _a461 end
end
end
end
end
local _a464 = {}
local function _a465(_a466, _a467)
if not _a466 then return end
local _a468, _a469 = pcall(function() return _a466:GetDescendants() end)
if _a466:IsA("BasePart") then _a464[#_a464 + 1] = { p = _a466.Position, why = _a467 } end
if _a468 then
for _a470, _a471 in ipairs(_a469) do
if _a471:IsA("BasePart") then
_a464[#_a464 + 1] = { p = _a471.Position, why = _a467 .. "/" .. _a471.Name }
end
end
end
end
if _a16.ZonesU then
for _a472, _a473 in ipairs({ "GetBreakableZones", "GetBreakableSpawns" }) do
local _a474 = rawget(_a16.ZonesU, _a473)
if type(_a474) == "function" then
local _a475, _a476 = pcall(_a474, _a450)
if _a475 and _a476 then _a465(_a476, _a473) end
end
end
end
if _a453 then
for _a477, _a478 in ipairs({ "BREAK_ZONES", "BREAKABLE_SPAWNS" }) do
local _a479, _a480 = pcall(function() return _a453:FindFirstChild(_a478, true) end)
if _a479 and _a480 then _a465(_a480, "ZoneFolder/" .. _a478) end
end
end
local _a481, _a482, _a483
for _a484, _a485 in ipairs(_a464) do
local _a486 = 0
for _a487, _a488 in ipairs(_a454) do
if (_a488 - _a485.p).Magnitude <= 150 then _a486 += 1 end
end
if not _a482 or _a486 > _a482 then _a481, _a482, _a483 = _a485.p, _a486, _a485.why end
end
local _a489, _a490
if _a481 and (_a482 or 0) >= 1 then
_a489, _a490 = _a481, ("%s (브레이커블 %d개)"):format(tostring(_a483), _a482)
end
if not _a489 and _a481 then
_a489, _a490 = _a481, tostring(_a483) .. " (브레이커블 없음)"
end
if not _a489 and _a16.ZonesU and rawget(_a16.ZonesU, "GetTeleportPartLocation") then
local _a491, _a492 = pcall(_a16.ZonesU.GetTeleportPartLocation, _a450)
if _a491 and typeof(_a492) == "CFrame" then
_a489, _a490 = _a492.Position, "PERSISTENT/Teleport (스트리밍 대기)"
end
end
if not _a489 then return nil, "브레이커블 위치를 못 찾음" end
local _a493 = _a18.move.groundY(_a489.X, _a489.Z, _a489.Y)
if _a493 then
_a489 = Vector3.new(_a489.X, _a493, _a489.Z)
_a490 = _a490 .. " +지면"
else
_a489 = Vector3.new(_a489.X, _a489.Y + 5, _a489.Z)
end
return _a489, _a490
end
function _a18.move.goToZone(_a494, _a495, _a496, _a497)
_a494 = _a18.move.realZone(_a494)
if not _a494 then return false, "존 id 없음" end
local _a498, _a499 = _a18.move.zonePos(_a494)
if not _a498 then
if _a11.TpGameFallback and _a18.move.curZone() ~= _a494 then
local _a500, _a501 = _a18.move.tpZone(_a494)
if not _a500 then return false, _a501 end
task.wait(0.3)
_a498, _a499 = _a18.move.zonePos(_a494)
end
if not _a498 then
local _a502, _a503 = _a18.move.resolvableZone(_a494)
if _a502 and _a503 then
if _a497 then
return false, ("%s 가 로드되지 않음"):format(tostring(_a494))
end
_a494, _a498, _a499 = _a502, _a503, "대체 존 " .. tostring(_a502)
else
if _a18.move.zoneFailSaid ~= _a494 then
_a18.move.zoneFailSaid = _a494
_a5(("[TP] %s 좌표 실패: %s (갈 수 있는 존이 없음)"):format(
tostring(_a494), tostring(_a499)))
end
return false, _a499
end
end
end
local _a504 = _a18.move.hrp()
if not _a496 and _a504 and _a18.move.curZone() == _a494 then
local _a505 = _a18.move.inDottedBox()
local _a506
if _a505 ~= nil then
_a506 = _a505
else
_a506 = (_a504.Position - _a498).Magnitude <= (_a11.ZoneArriveDist or 90)
end
if _a506 then
if _a495 then _a5("[TP] 이미 " .. _a494 .. " 사냥터 안에 있음") end
return true
end
end
if _a495 then
_a5(("[TP] %s 내부 좌표 %s → (%.0f, %.0f, %.0f)"):format(
_a494, tostring(_a499), _a498.X, _a498.Y, _a498.Z))
end
local _a507, _a508 = _a18.move.glideTo(_a498)
local _a509 = _a18.move.hrp()
if _a509 and (_a509.Position - _a498).Magnitude > math.max(40, _a11.ArriveDist or 12) then
task.wait(0.2)
_a18.ctl.moving = nil
_a18.move.glideTo(_a498)
local _a510 = _a18.move.hrp()
local _a511 = _a510 and (_a510.Position - _a498).Magnitude or -1
if _a511 > math.max(40, _a11.ArriveDist or 12) then
local _a512 = _a11.TpMode
_a11.TpMode = "glide"
_a18.ctl.moving = nil
_a18.move.glideTo(_a498)
_a11.TpMode = _a512
local _a513 = _a18.move.hrp()
_a511 = _a513 and (_a513.Position - _a498).Magnitude or -1
if _a511 > math.max(40, _a11.ArriveDist or 12) then
_a5(("[TP] %s 이동 실패 — %.0f스터드 남음 (순간이동·glide 둘 다)"):format(
tostring(_a494), _a511))
return false, "이동이 되돌려짐"
end
_a5("[TP] 순간이동이 막혀서 glide 로 이동함: " .. tostring(_a494))
end
end
do
local _a514 = _a18.move.hrp()
if _a514 and (_a514.Position.Y - _a498.Y) > 25 then
_a5(("[TP] 목표보다 %.0f 높은 곳에 얹힘 — 내려감"):format(_a514.Position.Y - _a498.Y))
_a18.ctl.moving = nil
_a18.move.glideTo(Vector3.new(_a498.X, _a498.Y, _a498.Z))
end
end
if tostring(_a499):find("스트리밍", 1, true) then
task.wait(1.2)
local _a515, _a516 = _a18.move.zonePos(_a494)
if _a515 and not tostring(_a516):find("스트리밍", 1, true) then
if _a495 then
_a5("[TP] 스트리밍 로드됨 → 사냥터로 (" .. tostring(_a516) .. ")")
end
_a18.ctl.moving = nil
_a18.move.glideTo(_a515)
_a498, _a499 = _a515, _a516
end
end
if _a18.move.inDottedBox() == false then
task.wait(0.2)
local _a517, _a518 = _a18.move.breakCenter(400)
if _a517 and _a518 >= 3 then
if _a495 then
_a5(("[TP] 네모 밖 → 주변 브레이커블 %d개 중심으로 보정"):format(_a518))
end
_a18.ctl.moving = nil
_a18.move.glideTo(_a517)
_a498 = _a517
end
if _a18.move.inDottedBox() == false then
local _a519 = _a18.move.zonePos(_a494)
if _a519 and (_a519 - _a498).Magnitude > 5 then
if _a495 then _a5("[TP] 아직 네모 밖 → 좌표 재계산 후 재시도") end
_a18.ctl.moving = nil
_a18.move.glideTo(_a519)
_a498 = _a519
end
end
if _a18.move.inDottedBox() == false and _a495 then
_a5(("[TP] %s 네모 안으로 못 들어감 (좌표 %s)"):format(_a494, tostring(_a499)))
end
end
local function _a520()
if _a18.move.inDottedBox() == true then return false end
local _a521, _a522 = _a18.move.breakCenter(400)
if (_a522 or 0) >= 1 then return false end
task.wait(0.6)
if _a18.move.inDottedBox() == true then return false end
local _a523, _a524 = _a18.move.breakCenter(400)
return (_a524 or 0) < 1
end
if _a520() and (os.clock() - (_a18.move.lastRecover or -999)) > 30 then
_a18.move.lastRecover = os.clock()
_a5(("[TP] %s 근처에 브레이커블이 없음 (%s) — 좌표 확인 필요"):format(
tostring(_a494), tostring(_a499)))
end
_a18.move.zoneFailSaid = nil
_a18.move.arrivedZone = _a494
do
local _a525 = _a18.move.hrp()
local _a526 = _a525 and (_a525.Position - _a498).Magnitude or 0
if _a526 > math.max(60, _a11.ArriveDist or 12) then
_a5(("[TP] %s 도착 실패 — %.0f스터드 남음 (되돌려짐)"):format(tostring(_a494), _a526))
return false, "이동이 되돌려짐"
end
end
local _a527 = _a18.move.hrp()
if _a495 and _a527 then
_a5(("[TP] 도착. 목표까지 %.0f스터드 / 존 %s / 네모안 %s"):format(
(_a527.Position - _a498).Magnitude, tostring(_a18.move.curZone()), tostring(_a18.move.inDottedBox())))
end
return true
end
function _a18.egg.tpEgg(_a528)
if not _a528 then return false, "알 id 없음" end
for _a529, _a530 in ipairs(_a18.egg.eggStands()) do
if _a530.id == _a528 then
if _a530.dist <= _a11.EggRange then return true, _a528 end
local _a531, _a532 = _a18.move.glideTo(_a530.pos)
return _a531, _a531 and _a528 or _a532
end
end
if _a11.TpGameFallback then
local _a533 = _a16.DirEggs and rawget(_a16.DirEggs, _a528)
local _a534 = _a533 and select(1, _a18.move.zoneByNumber(rawget(_a533, "zoneNumber")))
if _a534 and _a18.move.curZone() ~= _a534 then
local _a535, _a536 = _a18.move.tpZone(_a534)
if not _a535 then return false, _a536 end
task.wait(0.5)
_a18.egg._standsAt = nil
for _a537, _a538 in ipairs(_a18.egg.eggStands()) do
if _a538.id == _a528 then return _a18.move.glideTo(_a538.pos), _a528 end
end
end
end
return false, "알 받침대를 못 찾음 (" .. tostring(_a528) .. ")"
end
function _a18.item.stacks(_a539)
local _a540 = _a45()
local _a541 = _a540 and rawget(_a540, "Inventory")
local _a542 = _a541 and rawget(_a541, _a539)
if type(_a542) ~= "table" then return {} end
local _a543 = {}
for _a544, _a545 in pairs(_a542) do
if type(_a545) == "table" then
_a543[#_a543 + 1] = {
uid = _a544,
id = tostring(rawget(_a545, "id")),
tier = tonumber(rawget(_a545, "tn")) or 1,
am = tonumber(rawget(_a545, "_am")) or 1,
}
end
end
return _a543
end
_a18.item.PERTIER = {
Potion  = { 3, 3, 4, 5, 5, 5, 5, 5, 7, 7, 7 },
Enchant = { 5, 5, 5, 7, 7, 7, 7, 7, 10, 10 },
}
function _a18.item.perTier(_a546, _a547)
_a547 = tonumber(_a547)
local _a548 = _a16.Bal and rawget(_a16.Bal,
_a546 == "Potion" and "CalcPotionsPerTierRequired" or "CalcEnchantsPerTierRequired")
if type(_a548) == "function" then
local _a549, _a550 = pcall(_a548, _a547)
_a550 = _a549 and tonumber(_a550) or nil
if _a550 and _a550 > 0 then return _a550 end
if not _a549 and not _a18.item.perTierWarned then
_a18.item.perTierWarned = true
_a5("[퀘스트] 재료 수량 함수 막힘 → 기본표로 계산 (" .. tostring(_a550) .. ")")
end
end
local _a551 = _a18.item.PERTIER[_a546]
local _a552 = _a551 and _a547 and _a551[_a547]
return (_a552 and _a552 > 0) and _a552 or nil
end
function _a18.item.upgradeTo(_a553, _a554)
local _a555 = (_a553 == "Potion") and _a16.R_PotUp or _a16.R_EncUp
if not _a555 then return 0, (_a553 .. " 업글 리모트 없음") end
local _a556 = math.max(1, (tonumber(_a554) or 2) - 1)
local _a557 = _a18.item.perTier(_a553, _a556)
if not _a557 then return 0, ("T%d 재료 수량을 못 읽음"):format(_a556) end
local _a558, _a559 = {}, 0
for _a560, _a561 in ipairs(_a18.item.stacks(_a553)) do
if _a561.tier == _a556 then
local _a562 = math.floor(_a561.am / _a557)
if _a562 > 0 then _a558[_a561.uid] = _a562 _a559 += _a562 end
end
end
if _a559 < 1 then return 0, ("T%d 재료 부족 (T%d %d개당 1개)"):format(_a556, _a556, _a557) end
local _a563, _a564
pcall(function() _a563, _a564 = _a555:InvokeServer(_a558) end)
if not _a563 then return 0, tostring(_a564) end
return _a559
end
function _a18.item.usePotion(_a565, _a566)
if not _a16.R_PotUse then return 0, "Potions: Consume 리모트 없음" end
_a565 = tonumber(_a565) or 1
local _a567 = {}
for _a568, _a569 in ipairs(_a18.item.stacks("Potion")) do
if _a569.tier >= _a565 and _a569.am >= 1 then _a567[#_a567 + 1] = _a569 end
end
if #_a567 == 0 then return 0, ("T%d 이상 포션 없음"):format(_a565) end
table.sort(_a567, function(_a570, _a571) return _a570.tier < _a571.tier end)
local _a572, _a573 = _a566, 0
for _a574, _a575 in ipairs(_a567) do
for _a576 = 1, math.min(_a572, _a575.am) do
if _a572 < 1 or not _a12.quest then break end
pcall(function() _a16.R_PotUse:FireServer(_a575.uid, 1) end)
_a573 += 1
_a572 -= 1
task.wait(0.12)
end
if _a572 < 1 then break end
end
return _a573
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
local function _a577(_a578)
if typeof(_a578) == "Vector3" then return _a578 end
if typeof(_a578) == "CFrame" then return _a578.Position end
if type(_a578) == "table" then
local _a579, _a580, _a581 = tonumber(_a578.X or _a578.x or _a578[1]), tonumber(_a578.Y or _a578.y or _a578[2]), tonumber(_a578.Z or _a578.z or _a578[3])
if _a579 and _a580 and _a581 then return Vector3.new(_a579, _a580, _a581) end
end
return nil
end
function _a18.ev.events()
local _a582
if _a16.Rand and rawget(_a16.Rand, "GetActive") then
local _a583, _a584 = pcall(_a16.Rand.GetActive)
if _a583 and type(_a584) == "table" and next(_a584) then _a582 = _a584 end
end
if not _a582 and _a16.R_Events then
local _a585, _a586 = pcall(function() return _a16.R_Events:InvokeServer() end)
if _a585 and type(_a586) == "table" then _a582 = _a586 end
end
if type(_a582) ~= "table" then return {} end
local _a587 = workspace:GetServerTimeNow()
local _a588 = {}
for _a589, _a590 in pairs(_a582) do
if type(_a590) == "table" then
local _a591 = tostring(rawget(_a590, "id") or "")
local _a592 = _a591:match("|%s*(%S+)%s*$") or _a591
local _a593 = tonumber(rawget(_a590, "started")) or 0
local _a594 = tonumber(rawget(_a590, "duration")) or 0
_a588[#_a588 + 1] = {
uid = rawget(_a590, "uid"),
id = _a591,
kind = _a592,
name = rawget(_a590, "name") or _a592,
zone = rawget(_a590, "parentID"),
pos = _a577(rawget(_a590, "origin")),
left = math.max(0, _a594 - (_a587 - _a593)),
}
end
end
table.sort(_a588, function(_a595, _a596) return _a595.left > _a596.left end)
return _a588
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
local _a597, _a598 = pcall(_a16.Map.IsInDottedBox)
if _a597 then return _a598 and true or false end
end
return nil
end
function _a18.ev.spawnItems(_a599)
local _a600 = _a18.ev.SPAWN[_a599]
if not _a600 then return {} end
local _a601 = {}
for _a602, _a603 in ipairs({ "Misc", "Consumable", "Lootbox" }) do
for _a604, _a605 in ipairs(_a18.item.stacks(_a603)) do
local _a606 = _a605.id:lower()
if _a606:find(_a600.key, 1, true) then
local _a607 = 99
if _a600.order then
for _a608, _a609 in ipairs(_a600.order) do
if _a606:find(_a609, 1, true) then _a607 = _a608 break end
end
end
_a605.rank = _a607
_a601[#_a601 + 1] = _a605
end
end
end
table.sort(_a601, function(_a610, _a611)
if _a610.rank ~= _a611.rank then return _a610.rank < _a611.rank end
return _a610.tier < _a611.tier
end)
return _a601
end
function _a18.ev.spawnEvent(_a612)
local _a613 = _a18.ev.SPAWN[_a612]
if not _a613 then return 0, "소환 불가 종류" end
local _a614 = _a9:FindFirstChild(_a613.rem)
if not _a614 then return 0, _a613.rem .. " 리모트 없음" end
local _a615 = _a18.ev.spawnItems(_a612)
if #_a615 == 0 then return 0, _a612 .. " 아이템 없음" end
local _a616 = _a18.move.inDottedBox()
if _a616 == false then return 0, "점선 네모 안이 아님" end
local _a617, _a618 = 0, nil
for _a619, _a620 in ipairs(_a615) do
if _a617 >= (_a11.SpawnPerCycle or 1) or not _a12.quest then break end
local _a621, _a622
pcall(function() _a621, _a622 = _a614:InvokeServer(_a620.uid) end)
if _a621 then
_a617 += 1
_a18.ctl.setAct("소환", _a612 .. " · " .. _a620.id)
_a5(("  🎁 %s 소환  (%s)"):format(_a612, _a620.id))
task.wait(0.4)
else
_a618 = _a622
break
end
end
return _a617, _a618
end
function _a18.ev.findEvent(_a623, _a624)
local _a625 = _a624 and _a18.move.bestZone() or nil
local _a626
for _a627, _a628 in ipairs(_a18.ev.events()) do
if _a628.kind == _a623 and _a628.left > 15 then
if not _a624 or _a628.zone == _a625 then
if not _a626 or (_a628.zone == _a18.move.curZone() and _a626.zone ~= _a18.move.curZone()) then
_a626 = _a628
end
end
end
end
return _a626
end
function _a18.ev.findChest(_a629, _a630)
local _a631 = workspace:FindFirstChild("__THINGS")
if not _a631 then return nil end
local _a632 = tostring(_a629):lower():find("superior") ~= nil
local _a633 = _a18.move.hrp()
local _a634 = _a633 and _a633.Position
local _a635, _a636, _a637, _a638
for _a639, _a640 in ipairs(_a631:GetChildren()) do
if tostring(_a640.Name):lower():find("chest", 1, true) then
for _a641, _a642 in ipairs(_a640:GetChildren()) do
local _a643
if _a642:IsA("BasePart") then _a643 = _a642.Position
elseif _a642:IsA("Model") then
local _a644, _a645 = pcall(function() return _a642:GetPivot() end)
if _a644 and typeof(_a645) == "CFrame" then _a643 = _a645.Position end
end
if _a643 then
local _a646 = _a634 and (_a643 - _a634).Magnitude or 0
local _a647 = (tostring(_a642.Name) .. tostring(_a640.Name)):lower()
:find("superior", 1, true) ~= nil
if not _a638 or _a646 < _a638 then _a637, _a638 = _a643, _a646 end
if _a647 == _a632 and (not _a636 or _a646 < _a636) then
_a635, _a636 = _a643, _a646
end
end
end
end
end
if _a635 then return _a635, _a636 end
return _a637, _a638
end
_a18.quest.SKIP = { [4] = true, [5] = true, [40] = true, [41] = true }
_a18.quest.WHERE = {
[21]="bestzone", [9]="bestzone", [37]="bestzone", [38]="bestzone", [39]="bestzone",
[43]="bestzone", [44]="bestzone", [76]="bestzone", [30]="bestzone", [8]="bestzone",
[20]="bestegg",  [42]="bestegg",
[1]="breakable", [81]="zoneid",
}
function _a18.item.petStacks()
local _a648 = _a45()
local _a649 = _a648 and rawget(_a648, "Inventory")
local _a650 = _a649 and rawget(_a649, "Pet")
local _a651 = {}
if type(_a650) ~= "table" then return _a651 end
for _a652, _a653 in pairs(_a650) do
if type(_a653) == "table" then
_a651[#_a651 + 1] = {
uid = _a652,
id = tostring(rawget(_a653, "id")),
pt = tonumber(rawget(_a653, "pt")) or 0,
am = tonumber(rawget(_a653, "_am")) or 1,
}
end
end
return _a651
end
function _a18.item.bestEggPets()
local _a654 = _a86()
local _a655 = _a654 and _a16.DirEggs and rawget(_a16.DirEggs, _a654)
local _a656 = _a655 and rawget(_a655, "pets")
local _a657 = {}
if type(_a656) == "table" then
for _a658, _a659 in pairs(_a656) do
local _a660 = type(_a659) == "table" and _a659[1] or _a659
if _a660 then _a657[tostring(_a660)] = true end
end
end
return _a657, _a654
end
function _a18.item.makeVariant(_a661, _a662)
local _a663 = (_a661 == "gold") and _a16.R_Gold or _a16.R_Rain
if not _a663 then return 0, (_a661 .. " 머신 리모트 없음") end
local _a664 = (_a661 == "gold") and 0 or 1
local _a665
if _a662 then
local _a666, _a667 = _a18.item.bestEggPets()
if not next(_a666) then return 0, "최고 알(" .. tostring(_a667) .. ") 펫 목록을 못 읽음" end
_a665 = _a666
end
local _a668, _a669 = 0, nil
for _a670, _a671 in ipairs(_a18.item.petStacks()) do
if not _a12.quest then break end
if _a671.pt == _a664 and _a671.am >= 10 and (not _a665 or _a665[_a671.id]) then
local _a672 = math.floor(_a671.am / 10)
if _a672 > 0 then
local _a673, _a674
pcall(function() _a673, _a674 = _a663:InvokeServer(_a671.uid, _a672) end)
if _a673 then
_a668 += _a672
_a5(("  ✨ %s 제작  %s x%d"):format(
_a661 == "gold" and "골드" or "레인보우", _a671.id, _a672))
task.wait(0.4)
else
_a669 = _a674
end
end
end
end
return _a668, _a669
end
function _a18.item.useFlag(_a675)
if not _a16.R_Flag then return 0, "FlexibleFlags_Consume 리모트 없음" end
local _a676, _a677 = 0, nil
for _a678, _a679 in ipairs(_a18.item.stacks("Misc")) do
if _a676 >= (_a675 or 1) then break end
if _a679.id:lower():find("flag", 1, true) and _a679.am >= 1 and _a18.item.itemAllowed(_a679.id) then
local _a680, _a681
pcall(function() _a680, _a681 = _a16.R_Flag:InvokeServer(_a679.id, _a679.uid, 1) end)
if _a680 then _a676 += 1 task.wait(0.4) else _a677 = _a681 end
end
end
return _a676, _a677
end
function _a18.item.useFruit(_a682)
if not _a16.R_Fruit then return 0, "Fruits: Consume 리모트 없음" end
local _a683 = _a18.item.activeBuffs("Fruits")
local _a684 = 0
for _a685, _a686 in ipairs(_a18.item.stacks("Fruit")) do
if _a684 >= (_a682 or 1) then break end
if _a686.am >= 1 and _a18.item.itemAllowed(_a686.id) and not _a683[_a686.id] then
pcall(function() _a16.R_Fruit:FireServer(_a686.uid, 1) end)
_a684 += 1
task.wait(0.4)
end
end
return _a684
end
function _a18.quest.status()
local _a687 = _a45()
if not _a687 then return nil end
local _a688 = rawget(_a687, "Goals")
if type(_a688) ~= "table" then return { list = {} } end
local _a689 = {}
for _a690, _a691 in pairs(_a688) do
if type(_a691) == "table" then
local _a692 = tonumber(rawget(_a691, "Type")) or -1
local _a693
if _a16.Quest and rawget(_a16.Quest, "MakeTitle") then
local _a694, _a695 = pcall(_a16.Quest.MakeTitle, _a691)
if _a694 then _a693 = _a695 end
end
_a689[#_a689 + 1] = {
slot = _a690,
uid = tostring(rawget(_a691, "UID")),
type = _a692,
how = _a17[_a692],
title = _a693 or ("Type " .. _a692),
amount = tonumber(rawget(_a691, "Amount")) or 0,
progress = tonumber(rawget(_a691, "Progress")) or 0,
stars = tonumber(rawget(_a691, "Stars")) or 0,
potionTier = tonumber(rawget(_a691, "PotionTier")),
enchantTier = tonumber(rawget(_a691, "EnchantTier")),
breakable = rawget(_a691, "BreakableType") or rawget(_a691, "BreakableDirID"),
zoneId = rawget(_a691, "ZoneID"),
where = _a18.quest.WHERE[_a692] or (_a17[_a692] == "farm" and "bestzone" or nil),
event = _a18.ev.EVENTKIND[_a692],
chest = _a18.ev.CHESTKIND[_a692],
bestOnly = _a18.ev.BESTONLY[_a692] or false,
ignored = _a18.quest.IGNORE[_a692],
}
end
end
table.sort(_a689, function(_a696, _a697) return _a696.stars > _a697.stars end)
return { list = _a689, rank = tonumber(rawget(_a687, "Rank")) or 1,
rankStars = tonumber(rawget(_a687, "RankStars")) or 0 }
end
_a18.quest.BESTDEP = {
[20]=true, [21]=true, [37]=true, [38]=true, [39]=true,
[43]=true, [44]=true, [76]=true,
}
function _a18.quest.bestDepActive()
local _a698 = _a18.ctl.lockGoal and _a18.ctl.lockGoal.q
if not _a698 then return false end
if _a18.quest.IGNORE[_a698.type] then return false end
if not _a18.quest.BESTDEP[_a698.type] then return false end
local _a699 = _a18.quest.findQuest(_a698.uid)
if not _a699 or _a699.progress >= _a699.amount then return false end
return true, _a699
end
function _a18.quest.canDo(_a700, _a701)
if _a700.how == "hatch" or _a700.where == "bestegg" then
local _a702 = _a111()
if not _a702 then return false, "알 정보를 못 읽음" end
if not _a702.price then return true end
if not _a701 then
if _a702.canBuy < 1 then
return false, ("돈 부족 — %s 개당 %s %s / 보유 %s"):format(
tostring(_a702.id), _a6(_a702.price, 0), tostring(_a702.currency), _a6(_a702.have, 0))
end
return true
end
local _a703 = math.max(1, (_a700.amount or 1) - (_a700.progress or 0))
local _a704 = _a703
if _a700.type == 2 or _a700.type == 42 or _a700.type == 47 then
_a704 = math.max(_a703, _a11.HatchMinAfford or 10)
end
if _a702.canBuy < _a704 then
_a18.quest.moneyUntil = os.clock() + math.max(0, _a11.MoneyDwell or 60)
return false, ("돈 모으는 중 — %d개분 필요 / 지금 %d개분 (개당 %s %s)"):format(
_a704, _a702.canBuy, _a6(_a702.price, 0), tostring(_a702.currency))
end
if _a18.quest.moneyUntil and os.clock() < _a18.quest.moneyUntil then
return false, ("조금 더 벌고 감 (%.0f초 남음)"):format(_a18.quest.moneyUntil - os.clock())
end
_a18.quest.moneyUntil = nil
end
return true
end
function _a18.quest.findQuest(_a705)
local _a706 = _a18.quest.status()
for _a707, _a708 in ipairs(_a706 and _a706.list or {}) do
if _a708.uid == _a705 then return _a708 end
end
return nil
end
function _a18.quest.pursue(_a709)
local _a710, _a711
if _a709.how == "hatch" then _a710, _a711 = _a122, "mhatch"
elseif _a709.how == "zone" then _a710, _a711 = _a81, "zone"
elseif _a709.how == "gold" or _a709.how == "rainbow" then
local _a712 = (_a709.type == 40 or _a709.type == 41)
_a711 = "quest"
_a710 = function()
local _a713 = _a18.item.makeVariant("gold", _a712) or 0
if _a709.how == "rainbow" then
_a713 += (_a18.item.makeVariant("rainbow", _a712) or 0)
end
if _a713 > 0 then
_a18.ctl.setAct(_a709.how == "gold" and "골드 합성" or "레인보우 합성", _a713 .. "마리")
return
end
_a18.ctl.setAct("재료 모으는 중", "최고 알 부화")
local _a714 = _a12.mhatch
_a12.mhatch = true
pcall(_a122)
_a12.mhatch = _a714
end
end
local _a715 = _a709.progress
local _a716 = os.clock()
_a18.ctl.setGoal(_a709.title, ("%d/%d"):format(_a709.progress, _a709.amount))
local function _a717()
if not _a709.event then return end
local _a718 = _a18.ev.findEvent(_a709.event, _a709.bestOnly)
if _a718 then
_a18.ctl.setAct(_a709.event .. " 진행 중", ("%d초 남음"):format(_a718.left))
if _a718.pos then
local _a719 = _a18.move.hrp()
if _a719 and (_a719.Position - _a718.pos).Magnitude > (_a11.EventStayDist or 45) then
_a18.move.glideTo(_a718.pos)
end
end
return
end
local _a720, _a721 = _a18.ev.spawnEvent(_a709.event)
if _a720 > 0 then
_a18.ctl.setAct("소환", _a709.event)
task.wait(0.5)
elseif _a721 and _a18.ev.spawnErr ~= tostring(_a721) then
_a18.ev.spawnErr = tostring(_a721)
_a5("[퀘스트] " .. _a709.event .. " 소환 실패: " .. tostring(_a721))
end
end
local _a722, _a723 = pcall(function()
while _a12.quest and not _a18.ctl.stopped() do
local _a724, _a725 = _a18.quest.canDo(_a709, false)
if not _a724 then
_a5(("[퀘스트] %s → 다른 퀘스트 먼저 (%s)"):format(tostring(_a709.title), tostring(_a725)))
return
end
_a717()
if _a710 then
local _a726 = _a12[_a711]
_a12[_a711] = true
local _a727, _a728 = pcall(_a710)
_a12[_a711] = _a726
if not _a727 then error(_a728, 0) end
elseif _a709.event then
task.wait(0.4)
else
task.wait(2)
end
local _a729 = _a18.quest.findQuest(_a709.uid)
if not _a729 then
_a5("[퀘스트] 완료 — " .. tostring(_a709.title))
return
end
_a18.ctl.setGoal(_a729.title, ("%d/%d"):format(_a729.progress, _a729.amount))
if _a729.progress >= _a729.amount then
_a5(("[퀘스트] 달성 %d/%d — %s"):format(_a729.progress, _a729.amount, tostring(_a729.title)))
return
end
if _a729.progress > _a715 then
_a716 = os.clock()
_a5(("[퀘스트] %d/%d  %s"):format(_a729.progress, _a729.amount, tostring(_a729.title)))
end
_a715 = _a729.progress
local _a730 = os.clock() - _a716
if _a730 >= math.max(10, _a11.PursueStallSec or 60) then
_a5(("[퀘스트] %.0f초째 진행 없음 (%d/%d) — 다음 단계로: %s"):format(
_a730, _a729.progress, _a729.amount, tostring(_a729.title)))
return
end
task.wait(0.2)
end
end)
if not _a722 then _a5("[퀘스트] " .. tostring(_a709.how) .. " 오류: " .. tostring(_a723)) end
_a18.ctl.lockGoal = nil
_a18.ctl.setGoal(nil)
end
function _a18.quest.cycle()
do
local _a731 = _a12.rank
_a12.rank = true
pcall(_a172)
_a12.rank = _a731
end
local _a732 = _a18.quest.status()
if not _a732 then return end
local _a733, _a734, _a735 = false, false, false
local _a736 = {}
local _a737 = nil
for _a738, _a739 in ipairs(_a732.list) do
if not _a12.quest then break end
local _a740, _a741 = true, nil
if not _a739.ignored and _a739.progress < _a739.amount then
_a740, _a741 = _a18.quest.canDo(_a739, true)
end
if _a739.ignored then
if _a739.progress < _a739.amount then
_a736[#_a736 + 1] = tostring(_a739.title) .. "  — " .. _a739.ignored
end
elseif not _a740 then
local _a742 = tostring(_a739.uid) .. tostring(_a741)
if _a18.item.skipSaid ~= _a742 then
_a18.item.skipSaid = _a742
_a5(("[퀘스트] 건너뜀: %s   (%s)"):format(tostring(_a739.title), tostring(_a741)))
end
elseif _a739.progress < _a739.amount then
local _a743 = _a739.where
if _a739.event then
if not _a737 or _a737.rank > 0 then _a737 = { rank = 0, kind = "event", q = _a739 } end
elseif _a739.chest then
if not _a737 or _a737.rank > 1 then _a737 = { rank = 1, kind = "chest", q = _a739 } end
elseif _a743 == "bestegg" then
if not _a737 or _a737.rank > 1 then _a737 = { rank = 1, kind = "egg", q = _a739 } end
elseif _a743 == "breakable" and _a739.breakable then
if not _a737 or _a737.rank > 2 then _a737 = { rank = 2, kind = "breakable", q = _a739 } end
elseif _a743 == "zoneid" and _a739.zoneId then
if not _a737 or _a737.rank > 2 then _a737 = { rank = 2, kind = "zoneid", q = _a739 } end
elseif _a743 == "bestzone" or _a743 == "breakable" then
if not _a737 then _a737 = { rank = 3, kind = "bestzone", q = _a739 } end
end
if _a739.how == "farm" then
_a733 = true
elseif _a739.how == "hatch" then
_a734 = true
elseif _a739.how == "zone" then
_a735 = true
elseif _a739.how == "potup" and _a11.QuestUpgrade then
local _a744, _a745 = _a18.item.upgradeTo("Potion", _a739.potionTier or 2)
if _a744 > 0 then
_a13.potup += _a744
_a13.quest += 1
_a5(("[퀘스트] 포션 T%d %d개 제작  (%s)"):format(_a739.potionTier or 2, _a744, _a739.title))
elseif _a745 and not tostring(_a745):find("부족") then
if _a18.item.potUpSaid ~= tostring(_a745) then
_a18.item.potUpSaid = tostring(_a745)
_a5("[퀘스트] 포션 업글 실패: " .. tostring(_a745))
end
end
elseif _a739.how == "encup" and _a11.QuestUpgrade then
local _a746, _a747 = _a18.item.upgradeTo("Enchant", _a739.enchantTier or 2)
if _a746 > 0 then
_a13.potup += _a746
_a13.quest += 1
_a5(("[퀘스트] 인챈트 T%d %d개 제작  (%s)"):format(_a739.enchantTier or 2, _a746, _a739.title))
elseif _a747 and not tostring(_a747):find("부족") then
if _a18.item.encUpSaid ~= tostring(_a747) then
_a18.item.encUpSaid = tostring(_a747)
_a5("[퀘스트] 인챈트 업글 실패: " .. tostring(_a747))
end
end
elseif _a739.how == "potuse" and _a11.QuestUsePotion then
_a18.item.lastUse = _a18.item.lastUse or {}
local _a748 = _a18.item.lastUse[_a739.uid]
if _a748 and _a748.used > 0 and _a739.progress <= _a748.progress then
if not _a748.gaveUp then
_a748.gaveUp = true
_a5("[퀘스트] 포션을 마셔도 진행도가 안 올라서 중단: " .. tostring(_a739.title))
end
else
local _a749 = math.min(_a11.QuestUseMax, math.max(1, _a739.amount - _a739.progress))
local _a750, _a751 = _a18.item.usePotion(_a739.potionTier or 1, _a749)
_a18.item.lastUse[_a739.uid] = { used = _a750, progress = _a739.progress }
if _a750 > 0 then
_a13.potuse += _a750
_a13.quest += 1
_a5(("[퀘스트] 포션 %d개 사용  (%s)"):format(_a750, _a739.title))
elseif _a751 and not tostring(_a751):find("없음") then
_a5("[퀘스트] 포션 사용 실패: " .. tostring(_a751))
end
end
elseif _a739.how == "gold" or _a739.how == "rainbow" then
local _a752, _a753 = _a18.item.makeVariant(_a739.how, _a739.type == 40 or _a739.type == 41)
if _a752 > 0 then
_a13.quest += 1
_a5(("[퀘스트] %s 펫 %d마리 제작  (%s)"):format(
_a739.how == "gold" and "골드" or "레인보우", _a752, _a739.title))
elseif _a753 then
_a5("[퀘스트] " .. _a739.how .. " 실패: " .. tostring(_a753))
end
elseif _a739.how == "fruituse" then
local _a754 = _a18.item.useFruit(math.max(1, _a739.amount - _a739.progress))
if _a754 > 0 then
_a13.quest += 1
_a5(("[퀘스트] 과일 %d개 사용  (%s)"):format(_a754, _a739.title))
end
elseif _a739.how == "flaguse" then
local _a755, _a756 = _a18.item.useFlag(math.max(1, _a739.amount - _a739.progress))
if _a755 > 0 then
_a13.quest += 1
_a5(("[퀘스트] 깃발 %d개 사용  (%s)"):format(_a755, _a739.title))
elseif _a756 then
_a5("[퀘스트] 깃발 실패: " .. tostring(_a756))
end
elseif not _a739.how then
_a736[#_a736 + 1] = _a739.title
end
end
end
if _a11.QuestLock and _a18.ctl.lockGoal then
local _a757
for _a758, _a759 in ipairs(_a732.list) do
if _a759.uid == _a18.ctl.lockGoal.q.uid and _a759.progress < _a759.amount then _a757 = _a759 break end
end
if _a757 then
_a18.ctl.lockGoal.q = _a757
_a737 = _a18.ctl.lockGoal
else
if _a18.ctl.lockGoal.q then
_a5("[퀘스트] 완료/교체됨 → 다음 목표로: " .. tostring(_a18.ctl.lockGoal.q.title))
end
_a18.ctl.lockGoal = nil
end
end
if _a11.QuestLock and _a737 then _a18.ctl.lockGoal = _a737 end
if _a11.QuestTp and _a737 and _a12.quest then
local _a760, _a761, _a762
if _a737.kind == "event" then
local _a763 = _a18.ev.findEvent(_a737.q.event, _a737.q.bestOnly)
if _a763 then
_a762 = ("%s @%s (%d초 남음)"):format(_a763.name, tostring(_a763.zone), _a763.left)
if _a763.pos then _a760, _a761 = _a18.move.glideTo(_a763.pos)
else _a760, _a761 = _a18.move.goToZone(_a763.zone) end
else
local _a764 = _a737.q.bestOnly and _a18.move.bestZone() or (_a18.move.curZone() or _a18.move.bestZone())
_a762 = _a737.q.event .. " 소환용 " .. tostring(_a764)
local _a765 = _a18.move.inDottedBox()
_a760, _a761 = _a18.move.goToZone(_a764, false, _a765 == false, _a737.q.bestOnly)
if _a760 then
local _a766, _a767 = _a18.ev.spawnEvent(_a737.q.event)
if _a766 < 1 and tostring(_a767):find("점선") then
_a18.move.goToZone(_a764, false, true)
task.wait(0.2)
_a766, _a767 = _a18.ev.spawnEvent(_a737.q.event)
end
if _a766 > 0 then
_a762 = ("%s %d개 소환 @%s"):format(_a737.q.event, _a766, tostring(_a764))
else
_a761 = _a767
_a760 = false
end
end
end
elseif _a737.kind == "chest" then
local _a768 = _a737.q.bestOnly and _a18.move.bestZone() or _a18.move.curZone()
local _a769, _a770 = _a18.ev.findChest(_a737.q.chest, _a768)
_a762 = _a737.q.chest .. " @" .. tostring(_a768)
if _a769 then
if not _a770 or _a770 > 20 then _a18.move.glideTo(_a769) end
_a760 = true
else
_a760, _a761 = _a18.move.goToZone(_a768)
_a762 = _a762 .. " (상자 없음 → 존 가운데)"
end
elseif _a737.kind == "egg" then
local _a771 = _a86()
_a762 = "최고 알 " .. tostring(_a771)
if _a771 then _a760, _a761 = _a18.egg.tpEgg(_a771) else _a761 = "최고 알을 못 찾음" end
elseif _a737.kind == "breakable" then
local _a772 = _a18.move.zoneForBreakable(_a737.q.breakable)
_a762 = tostring(_a737.q.breakable) .. " 나오는 존 " .. tostring(_a772)
if _a772 then _a760, _a761 = _a18.move.goToZone(_a772, true) else _a761 = "그 브레이커블이 나오는 존이 없음" end
elseif _a737.kind == "zoneid" then
_a762 = "존 " .. tostring(_a737.q.zoneId)
_a760, _a761 = _a18.move.goToZone(_a737.q.zoneId)
else
local _a773 = _a18.move.bestZone()
local _a774 = _a737.q.bestOnly or _a18.quest.BESTDEP[_a737.q.type] or false
if _a773 then _a760, _a761 = _a18.move.goToZone(_a773, true, false, _a774)
else _a761 = "최고 존을 못 찾음" end
_a762 = "최고 존 " .. tostring(_a18.move.arrivedZone or _a773)
if not _a760 then _a761 = _a773 end
end
if _a760 then
if _a18.quest.lastGoal ~= _a762 then
_a18.quest.lastGoal = _a762
_a5("[퀘스트] " .. _a762 .. " 으로 이동  (" .. tostring(_a737.q.title) .. ")")
end
_a18.quest.pursue(_a737.q)
else
local _a775 = _a761 and tostring(_a761) or "이유 불명"
if _a18.quest.lastFail ~= _a775 then
_a18.quest.lastFail = _a775
_a5(("[퀘스트] 진행 못 함: %s   (%s / %s)"):format(
_a775, tostring(_a737.kind), tostring(_a737.q.title)))
_a5(("           현재 존 %s / 최고 존 %s / 점선네모 %s"):format(
tostring(_a18.move.curZone()), tostring(_a18.move.bestZone()), tostring(_a18.move.inDottedBox())))
end
end
end
if _a11.QuestDrive and _a18.auto.turnOn then
if _a733  then _a18.auto.turnOn("farm",   "파밍 퀘스트 → 자동 파밍") end
if _a735  then _a18.auto.turnOn("zone",   "존 퀘스트 → 자동 존 해금") end
if _a734 then _a18.auto.turnOn("mhatch", "부화 퀘스트 → 자동 부화") end
end
if #_a736 > 0 and not _a18.quest.manualWarned then
_a18.quest.manualWarned = true
_a5("[퀘스트] 수동으로 해야 하는 것:")
for _a776, _a777 in ipairs(_a736) do _a5("    · " .. tostring(_a777)) end
elseif #_a736 == 0 then
_a18.quest.manualWarned = false
end
return _a737 ~= nil
end
local function _a778(_a779)
local _a780 = {}
for _a781 in tostring(_a779 or ""):gmatch("[^,]+") do
_a781 = _a781:match("^%s*(.-)%s*$")
if _a781 ~= "" then _a780[#_a780 + 1] = _a781:lower() end
end
return _a780
end
function _a18.item.itemAllowed(_a782)
local _a783 = tostring(_a782):lower()
for _a784, _a785 in ipairs(_a778(_a11.ItemBlock)) do
if _a783:find(_a785, 1, true) then return false end
end
local _a786 = _a778(_a11.ItemAllow)
if #_a786 == 0 then return true end
for _a787, _a788 in ipairs(_a786) do
if _a783:find(_a788, 1, true) then return true end
end
return false
end
function _a18.item.activeBuffs(_a789)
local _a790 = _a45()
local _a791 = _a790 and rawget(_a790, _a789)
local _a792 = {}
if type(_a791) == "table" then
for _a793, _a794 in pairs(_a791) do
if type(_a794) == "table" and next(_a794) then _a792[_a793] = true
elseif _a794 then _a792[_a793] = true end
end
end
return _a792
end
local function _a795(_a796, _a797, _a798, _a799)
local _a800 = _a18.item.activeBuffs(_a797)
local _a801 = {}
local _a802 = { total = 0, act = 0, blocked = 0, few = 0, ok = 0 }
for _a803, _a804 in ipairs(_a18.item.stacks(_a796)) do
_a802.total += 1
if _a800[_a804.id] then _a802.act += 1
elseif not _a18.item.itemAllowed(_a804.id) then _a802.blocked += 1
elseif _a804.am <= _a11.ItemKeep then _a802.few += 1
else
_a802.ok += 1
local _a805 = _a801[_a804.id]
local _a806
if not _a805 then _a806 = true
elseif _a11.BuffHighTier then _a806 = _a804.tier > _a805.tier
else _a806 = _a804.tier < _a805.tier end
if _a806 then _a801[_a804.id] = _a804 end
end
end
if _a802.ok == 0 and _a802.total > 0 then
local _a807 = ("%s %d종 중 사용 가능 0 (이미걸림 %d / 제외 %d / 재고부족 %d)")
:format(_a796, _a802.total, _a802.act, _a802.blocked, _a802.few)
if _a18.item.buffSaid ~= _a807 then
_a18.item.buffSaid = _a807
_a5("[아이템] " .. _a807)
end
elseif _a802.ok > 0 then
_a18.item.buffSaid = nil
end
local _a808 = {}
for _a809, _a810 in pairs(_a801) do _a808[#_a808 + 1] = _a810 end
table.sort(_a808, function(_a811, _a812)
if _a811.tier ~= _a812.tier then return _a811.tier > _a812.tier end
return _a811.am > _a812.am
end)
local _a813 = {}
for _a814, _a815 in ipairs(_a808) do
if not _a12.items then break end
if _a799 and _a799.left <= 0 then break end
local _a816 = pcall(function() _a798(_a815.uid, 1) end)
if _a816 then
_a813[#_a813 + 1] = ("%s T%d"):format(_a815.id, _a815.tier)
_a13.items += 1
if _a799 then _a799.left -= 1 end
task.wait(0.12)
end
end
return _a813
end
function _a18.item.cycleItems()
local function _a817()
local _a818 = {}
if _a11.BuffPotion then _a818[#_a818 + 1] = { "Potion", "Potions" } end
if _a11.BuffFruit then _a818[#_a818 + 1] = { "Fruit", "Fruits" } end
if _a11.BuffConsumable then _a818[#_a818 + 1] = { "Consumable", "Consumables" } end
for _a819, _a820 in ipairs(_a818) do
local _a821 = _a18.item.activeBuffs(_a820[2])
for _a822, _a823 in ipairs(_a18.item.stacks(_a820[1])) do
if _a823.am > _a11.ItemKeep and _a18.item.itemAllowed(_a823.id) and not _a821[_a823.id] then
return true
end
end
end
if _a11.BuffUltimate and _a16.R_Ult then
local _a824 = _a45()
local _a825 = _a824 and rawget(_a824, "Ultimates")
if type(_a825) == "table" then
for _a826 in pairs(_a825) do
if _a18.item.itemAllowed(_a826) then
if not (_a16.Ult and rawget(_a16.Ult, "IsCharged")) then return true end
local _a827, _a828 = pcall(_a16.Ult.IsCharged, _a826)
if _a827 and _a828 then return true end
end
end
end
end
return false
end
if not _a817() then return end
if _a11.ItemBestZone then
local _a829 = _a18.move.bestZone()
if _a829 and _a18.move.curZone() ~= _a829 then
if not _a11.ItemTp then
if not _a18.item.itemZoneWarned then
_a18.item.itemZoneWarned = true
_a5(("[아이템] 최고 존(%s)이 아니라 대기 — 현재 %s"):format(
tostring(_a829), tostring(_a18.move.curZone())))
end
return
end
local _a830, _a831 = _a18.move.goToZone(_a829)
if not _a830 then
_a5("[아이템] 최고 존 이동 실패: " .. tostring(_a831))
return
end
_a5("[아이템] 최고 존 " .. tostring(_a829) .. " 에서 사용")
end
_a18.item.itemZoneWarned = false
end
local _a832 = {}
local _a833  = { left = math.max(1, _a11.BuffMaxPotion or 5) }
local _a834 = { left = math.max(1, _a11.BuffMaxOther or 2) }
if _a11.BuffPotion and _a16.R_PotUse then
local _a835 = _a795("Potion", "Potions", function(_a836, _a837)
_a16.R_PotUse:FireServer(_a836, _a837)
end, _a833)
for _a838, _a839 in ipairs(_a835) do _a832[#_a832 + 1] = "포션 " .. _a839 end
end
if _a11.BuffFruit and _a16.R_Fruit then
local _a840 = _a795("Fruit", "Fruits", function(_a841, _a842)
_a16.R_Fruit:FireServer(_a841, _a842)
end, _a834)
for _a843, _a844 in ipairs(_a840) do _a832[#_a832 + 1] = "과일 " .. _a844 end
end
if _a11.BuffConsumable and _a16.R_Cons then
local _a845 = _a795("Consumable", "Consumables", function(_a846, _a847)
_a16.R_Cons:InvokeServer(_a846, _a847)
end, _a834)
for _a848, _a849 in ipairs(_a845) do _a832[#_a832 + 1] = "소모품 " .. _a849 end
end
if _a11.BuffUltimate and _a16.R_Ult then
local _a850 = _a45()
local _a851 = _a850 and rawget(_a850, "Ultimates")
if type(_a851) == "table" then
for _a852 in pairs(_a851) do
if not _a12.items then break end
if _a18.item.itemAllowed(_a852) then
local _a853 = true
if _a16.Ult and rawget(_a16.Ult, "IsCharged") then
local _a854, _a855 = pcall(_a16.Ult.IsCharged, _a852)
_a853 = _a854 and _a855 and true or false
end
if _a853 then
local _a856
pcall(function() _a856 = _a16.R_Ult:InvokeServer(_a852) end)
if _a856 then
_a832[#_a832 + 1] = "얼티밋 " .. tostring(_a852)
_a13.items += 1
task.wait(0.3)
end
end
end
end
end
end
if #_a832 > 0 then
_a18.ctl.setAct("버프 사용", table.concat(_a832, ", "))
_a5("[아이템] " .. table.concat(_a832, ", ") .. " 사용")
end
end
function _a18.mach.slotStatus()
local _a857 = _a45()
if not _a857 then return nil end
local _a858 = tonumber(rawget(_a857, "PetSlotsPurchased")) or 0
local _a859 = tonumber(rawget(_a857, "EggSlotsPurchased")) or 0
local _a860, _a861 = 0, 0
if _a16.RankC then
if rawget(_a16.RankC, "GetMaxPurchasableEquipSlots") then
local _a862, _a863 = pcall(_a16.RankC.GetMaxPurchasableEquipSlots)
if _a862 and tonumber(_a863) then _a860 = tonumber(_a863) end
end
if rawget(_a16.RankC, "GetMaxPurchasableEggSlots") then
local _a864, _a865 = pcall(_a16.RankC.GetMaxPurchasableEggSlots)
if _a864 and tonumber(_a865) then _a861 = tonumber(_a865) end
end
end
local _a866, _a867
if _a858 < _a860 then
_a866 = _a858 + 1
if type(_a16.CalcPetS) == "function" then
local _a868, _a869 = pcall(_a16.CalcPetS, _a866)
if _a868 then _a867 = tonumber(_a869) end
end
end
local _a870, _a871, _a872
if _a859 < _a861 and _a16.RankC and rawget(_a16.RankC, "GetEggBundle") then
local _a873, _a874, _a875 = pcall(_a16.RankC.GetEggBundle, _a859 + 1)
if _a873 and tonumber(_a874) then
_a870, _a871 = tonumber(_a874), tonumber(_a875) or 1
if type(_a16.CalcEggS) == "function" then
local _a876, _a877 = 0, false
for _a878 = _a870 - _a871 + 1, _a870 do
local _a879, _a880 = pcall(_a16.CalcEggS, _a878)
if _a879 and tonumber(_a880) then _a876 += tonumber(_a880) else _a877 = true end
end
if not _a877 then _a872 = _a876 end
end
end
end
local _a881
if _a16.Egg and rawget(_a16.Egg, "GetMaxHatch") then
local _a882, _a883 = pcall(_a16.Egg.GetMaxHatch)
if _a882 then _a881 = tonumber(_a883) end
end
return {
dia = _a53("Diamonds"),
petOwned = _a858, petMax = _a860, petNext = _a866, petCost = _a867,
eggOwned = _a859, eggMax = _a861, eggEnd = _a870, eggSize = _a871, eggCost = _a872,
maxEquip = tonumber(rawget(_a857, "MaxPetsEquipped")), maxHatch = _a881,
}
end
function _a18.move.machinePos(_a884)
local _a885
if _a16.Machine and rawget(_a16.Machine, "GetModels") then
local _a886, _a887 = pcall(_a16.Machine.GetModels, _a884)
if _a886 and type(_a887) == "table" then
for _a888, _a889 in pairs(_a887) do
if typeof(_a889) == "Instance" then _a885 = _a889 break end
end
end
end
if not _a885 then
local _a890, _a891 = pcall(function()
return game:GetService("CollectionService"):GetTagged("Machine")
end)
if _a890 then
for _a892, _a893 in ipairs(_a891) do
if _a893.Name == _a884 then _a885 = _a893 break end
end
end
end
if not _a885 then return nil end
if _a885:IsA("BasePart") then return _a885.Position end
local _a894, _a895 = pcall(function() return _a885:GetPivot() end)
return (_a894 and typeof(_a895) == "CFrame") and _a895.Position or nil
end
function _a18.mach.cycleSlots()
local _a896 = 0
local _a897 = 0
while _a12.slots and not _a18.ctl.stopped() and _a897 < 40 do
_a897 += 1
local _a898 = _a18.mach.slotStatus()
if not _a898 then return end
local _a899 = _a11.SlotPet and _a898.petNext and _a898.petCost
and (_a898.dia - _a11.SlotReserve) >= _a898.petCost
local _a900 = _a11.SlotEgg and _a898.eggEnd and _a898.eggCost
and (_a898.dia - _a11.SlotReserve) >= _a898.eggCost
if _a899 and _a900 then
if _a898.eggCost < _a898.petCost then _a899 = false else _a900 = false end
end
if not (_a899 or _a900) then break end
local _a901, _a902, _a903, _a904
local function _a905()
if _a899 then
pcall(function() _a901, _a902 = _a16.R_PetSlot:InvokeServer(_a898.petNext) end)
else
pcall(function() _a901, _a902 = _a16.R_EggSlot:InvokeServer(_a898.eggEnd) end)
end
end
if _a899 then
_a903 = ("펫 장착 슬롯 #%d (%s 다이아)"):format(_a898.petNext, _a6(_a898.petCost, 0))
_a904 = "EquipSlotsMachine"
else
_a903 = ("알 부화 슬롯 %d칸 → %d (%s 다이아)"):format(
_a898.eggSize, _a898.eggEnd, _a6(_a898.eggCost, 0))
_a904 = "EggSlotsMachine"
end
_a905()
if not _a901 and tostring(_a902):find("far away") then
local _a906 = _a18.move.machinePos(_a904)
if _a906 then
_a18.ctl.setAct("슬롯 머신으로 이동", _a904)
_a18.move.glideTo(_a906)
task.wait(0.25)
_a901, _a902 = nil, nil
_a905()
else
_a902 = "머신 위치를 못 찾음 (" .. _a904 .. ")"
end
end
if _a901 then
_a896 += 1
_a13.mslot += 1
_a18.mach.slotSaid = nil
_a18.ctl.setAct("슬롯 구매", _a903)
_a5("  ⬆ " .. _a903)
task.wait(0.35)
else
local _a907 = _a903 .. " 실패: " .. tostring(_a902)
if _a18.mach.slotSaid ~= _a907 then
_a18.mach.slotSaid = _a907
_a5("[슬롯] " .. _a907)
end
break
end
end
if _a896 > 0 then
local _a908 = _a18.mach.slotStatus()
_a5(("[슬롯] %d개 구매 — 장착 %s / 한번에 %s개 부화 (다이아 %s 남음)"):format(
_a896, tostring(_a908 and _a908.maxEquip), tostring(_a908 and _a908.maxHatch),
_a6(_a53("Diamonds"), 0)))
end
end
function _a18.mach.upgList()
local _a909 = {}
if not _a16.Upg then return _a909 end
local _a910, _a911 = pcall(_a16.Upg.All)
if not (_a910 and type(_a911) == "table") then return _a909 end
for _a912, _a913 in ipairs(_a911) do
local _a914, _a915, _a916 = rawget(_a913, "UpgradeID"), rawget(_a913, "ZoneID"), rawget(_a913, "UpgradeTier")
if _a914 and _a915 and _a916 then
local _a917 = false
if rawget(_a16.Upg, "Owns") then
local _a918, _a919 = pcall(_a16.Upg.Owns, _a914, _a915)
_a917 = _a918 and _a919 and true or false
end
local _a920 = _a18.move.ownsZone(_a915)
local _a921 = _a16.DirUpg and rawget(_a16.DirUpg, _a914)
local _a922 = _a921 and rawget(_a921, "TierCosts")
local _a923 = _a922 and tonumber(_a922[_a916])
local _a924 = "Diamonds"
local _a925 = _a921 and rawget(_a921, "TierCurrencies")
local _a926 = _a925 and _a925[_a916]
if type(_a926) == "table" and rawget(_a926, "_id") then _a924 = rawget(_a926, "_id") end
local _a927 = rawget(_a913, "Model")
local _a928
if typeof(_a927) == "Instance" then
if _a927:IsA("BasePart") then _a928 = _a927.Position
else
local _a929, _a930 = pcall(function() return _a927:GetPivot() end)
if _a929 and _a930 then _a928 = _a930.Position end
end
end
_a909[#_a909 + 1] = {
id = _a914, zone = _a915, tier = _a916, cost = _a923, cur = _a924,
bought = _a917, zoneOwned = _a920,
buyable = _a920 and not _a917,
pos = _a928, model = _a927,
}
end
end
table.sort(_a909, function(_a931, _a932) return (_a931.cost or math.huge) < (_a932.cost or math.huge) end)
return _a909
end
function _a18.mach.cycleUpg()
if not _a16.R_Upg then _a5("[맵업글] Upgrades_Purchase 리모트 없음") return end
local _a933 = _a18.mach.upgList()
if #_a933 == 0 then return end
local _a934 = 0
for _a935, _a936 in ipairs(_a933) do
if not _a12.mapupg then break end
if _a936.buyable and _a936.cost then
local _a937 = _a53(_a936.cur or "Diamonds")
if _a937 - _a11.UpgReserve < _a936.cost then break end
if _a11.UpgTp and _a936.pos and _a936.zone == _a18.move.curZone() then
_a18.move.glideTo(_a936.pos)
end
local _a938, _a939
pcall(function() _a938, _a939 = _a16.R_Upg:InvokeServer(_a936.id, _a936.zone) end)
if _a938 then
_a934 += 1
_a13.mapupg += 1
_a18.ctl.setAct("맵 업글", _a936.id .. " T" .. _a936.tier)
_a5(("  ▲ 맵업글  %s T%d  @%s   (%s 다이아)"):format(
_a936.id, _a936.tier, _a936.zone, _a6(_a936.cost, 0)))
elseif _a939 then
_a5(("[맵업글] %s T%d @%s 실패: %s"):format(
_a936.id, _a936.tier, _a936.zone, tostring(_a939)))
end
task.wait(_a11.ActionGap)
end
end
if _a934 > 0 then
_a5(("[맵업글] %d개 구매  (다이아 %s 남음)"):format(_a934, _a6(_a53("Diamonds"), 0)))
end
end
local function _a940()
local _a941 = _a45()
if not _a941 then return nil end
local _a942 = tonumber(rawget(_a941, "Rebirths")) or 0
local _a943 = _a942 + 1
local _a944
if _a16.Rebirth and rawget(_a16.Rebirth, "GetNextRebirth") then
local _a945, _a946 = pcall(_a16.Rebirth.GetNextRebirth, _a941)
if _a945 then _a944 = _a946 end
end
return { current = _a942, nextN = _a943, def = _a944 }
end
local function _a947()
if not _a16.R_Reb then _a5("[리버스] Rebirth_Request 리모트 없음") return end
local _a948 = _a940()
if not _a948 then
_a18.auto.rebNote = "세이브를 못 읽음"
return
end
local _a949, _a950
pcall(function() _a949, _a950 = _a16.R_Reb:InvokeServer(_a948.nextN) end)
if _a949 then
_a13.mreb += 1
_a18.auto.rebNote, _a18.auto.rebSaid = nil, nil
_a5(("  ★ 리버스 %d → %d"):format(_a948.current, _a948.nextN))
task.wait(0.5)
_a18.screen.dismissRewardScreens(25)
else
_a18.auto.rebNote = ("%d → %d : %s"):format(_a948.current, _a948.nextN,
_a950 and tostring(_a950) or "조건 미달 (리버스 킬/존 요구치)")
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
{ key = "mreb",   label = "리버스",  run = "mreb",  fn = function() _a947() end,
hold = true },
{ key = "zone",   label = "존 해금", run = "zone",  fn = function() _a81() end,
hold = true },
{ key = "quest",  label = "랭크 퀘스트+보상", run = "quest", fn = function()
local _a951 = _a12.farm
_a12.farm = true
pcall(_a63)
_a12.farm = _a951
local _a952 = _a18.quest.cycle()
if not _a952 then
local _a953 = _a18.move.bestZone()
if _a953 then
local _a954, _a955 = _a18.move.goToZone(_a953)
if not _a954 then
if _a955 and _a18.auto.idleMoveSaid ~= tostring(_a955) then
_a18.auto.idleMoveSaid = tostring(_a955)
_a5("[자동] 최고 존 이동 실패: " .. tostring(_a955))
end
else
_a18.auto.idleMoveSaid = nil
end
end
if not _a11.IdleHatch then
_a18.ctl.setAct("파밍 중", ("퀘스트 없음 @%s"):format(tostring(_a18.move.curZone())))
return
end
local _a956 = _a111()
local _a957 = math.max(1, _a11.HatchMinAfford or 10)
if _a956 and _a956.price and _a956.canBuy < _a957 then
_a18.ctl.setAct("돈 버는 중", ("%s  %d/%d개분  개당 %s %s"):format(
tostring(_a18.move.curZone()), _a956.canBuy, _a957,
_a6(_a956.price, 0), tostring(_a956.currency)))
else
_a18.ctl.setAct("대기 중 부화")
local _a958 = _a12.mhatch
_a12.mhatch = true
pcall(_a122)
_a12.mhatch = _a958
end
end
end },
}
_a11.StepOn = {}
for _a959, _a960 in ipairs(_a18.auto.SIDE) do _a11.StepOn[_a960.key] = true end
for _a961, _a962 in ipairs(_a18.auto.STEPS) do _a11.StepOn[_a962.key] = true end
local function _a963(_a964, _a965, _a966, _a967)
if not _a11.StepOn[_a964.key] then
_a967[#_a967 + 1] = ("%-14s 꺼져있음"):format(_a964.label)
return
end
if _a964.hold and _a965 then
_a967[#_a967 + 1] = ("%-14s 보류 (%s)"):format(
_a964.label, _a966 and tostring(_a966.title) or "?")
if _a18.auto.heldMsg ~= _a964.key then
_a18.auto.heldMsg = _a964.key
_a5(("[자동] %s 보류 — best 존이 바뀌면 깨지는 퀘스트 진행 중 (%s)"):format(
_a964.label, _a966 and tostring(_a966.title) or "?"))
end
return
end
if _a964.hold then _a18.auto.heldMsg = nil end
_a18.auto.step = _a964.label
_a18.ctl.now.step = _a964.label
_a18.ctl.setAct("시작", _a964.label)
local _a968 = os.clock()
local _a969 = _a12[_a964.run]
_a12[_a964.run] = true
local _a970, _a971 = pcall(_a964.fn)
_a12[_a964.run] = _a969
local _a972 = os.clock() - _a968
if not _a970 then
_a967[#_a967 + 1] = ("%-14s 오류: %s"):format(_a964.label, tostring(_a971))
_a5("[자동] " .. _a964.label .. " 오류: " .. tostring(_a971))
else
local _a973 = (_a964.key == "zone" and _a18.auto.zoneNote)
or (_a964.key == "mreb" and _a18.auto.rebNote) or nil
_a967[#_a967 + 1] = ("%-14s 실행 %.1f초%s"):format(
_a964.label, _a972, _a973 and ("  → " .. _a973) or "")
end
end
function _a18.auto.master()
local _a974 = {}
_a18.auto.lastTrace = _a974
_a18.auto.lastPassAt = os.clock()
if _a18.screen.rewardScreenUp() then
_a974[#_a974 + 1] = "보상 화면 넘기는 중"
_a18.screen.dismissRewardScreens(15)
end
for _a975, _a976 in ipairs(_a18.auto.SIDE) do
if not _a12.auto or _a18.ctl.stopped() then return end
_a963(_a976, false, nil, _a974)
end
local _a977, _a978 = false, nil
if _a11.HoldZoneForQuest then _a977, _a978 = _a18.quest.bestDepActive() end
for _a979, _a980 in ipairs(_a18.auto.STEPS) do
if not _a12.auto or _a18.ctl.stopped() then break end
_a963(_a980, _a977, _a978, _a974)
end
_a18.auto.step = nil
if not _a18.ctl.lockGoal then
_a18.ctl.now.step = "대기"
_a18.ctl.setAct("다음 바퀴 대기", ("%.0f초 주기"):format(_a11.AutoInterval or 5))
end
local _a981 = {}
for _a982, _a983 in ipairs(_a974) do _a981[#_a981 + 1] = (_a983:gsub("[%d%.]+초", "")) end
_a981 = table.concat(_a981, " | ")
if _a981 ~= _a18.auto.lastSig then
_a18.auto.lastSig = _a981
_a5("[자동] 바퀴 " .. (_a18.auto.passN or 0))
for _a984, _a985 in ipairs(_a974) do _a5("    " .. _a985) end
end
_a18.auto.passN = (_a18.auto.passN or 0) + 1
end
local function _a986()
if not _a10.R_PROMO then _a5("[타워업글] 리모트 없음") return end
local _a987 = _a14()
if not _a987 then return end
local _a988 = _a15(_a987)
table.sort(_a988, function(_a989, _a990) return (_a989.dps or 0) > (_a990.dps or 0) end)
local _a991, _a992 = 0, 0
for _a993, _a994 in ipairs(_a988) do
if not _a12.towerup then break end
if _a994.id then
local _a995
pcall(function() _a995 = _a10.R_PROMO:InvokeServer(_a994.id) end)
if _a995 ~= nil and _a995 ~= false then
_a991 += 1
_a5(("  ▲ 타워업글  %s  Lv%s → Lv%s"):format(tostring(_a994.kind), tostring(_a994.up), tostring((_a994.up or 0) + 1)))
_a992 = 0
task.wait(_a11.ActionGap)
else
_a992 += 1
if _a992 >= 5 then break end
end
end
end
_a5("[타워업글] " .. _a991 .. "건")
end
local _a996 = {}
local _a997 = {}
local function _a998(_a999, _a1000)
local _a1001 = tostring(_a1000)
local _a1002 = _a997[_a999]
if _a1002 and _a1002.msg == _a1001 then
_a1002.n += 1
if _a1002.n % 20 == 0 then
_a5(("[%s 오류] %s   (%d회 반복)"):format(_a999, _a1001, _a1002.n))
end
return
end
_a997[_a999] = { msg = _a1001, n = 1 }
_a5("[" .. _a999 .. " 오류] " .. _a1001)
end
local function _a1003(_a1004, _a1005, _a1006, _a1007)
_a996[_a1004] = (_a996[_a1004] or 0) + 1
local _a1008 = _a996[_a1004]
task.spawn(function()
while _a12[_a1004] and _a996[_a1004] == _a1008 do
local _a1009, _a1010 = pcall(_a1006)
if not _a1009 then _a998(_a1007, _a1010) else _a997[_a1007] = nil end
local _a1011, _a1012 = _a1005(), 0
while _a1012 < _a1011 and _a12[_a1004] and _a996[_a1004] == _a1008 do task.wait(0.1) _a1012 += 0.1 end
end
if _a996[_a1004] == _a1008 then _a5("[" .. _a1007 .. "] 중지") end
end)
end
do
local _a1013 = {
farm   = { function() return _a11.FarmInterval end,      function() _a63() end,      "파밍" },
zone   = { function() return _a11.ZoneInterval end,      function() _a81() end,      "존" },
mhatch = { function() return _a11.MainHatchInterval end, function() _a122() end, "부화" },
}
function _a18.auto.turnOn(_a1014, _a1015)
if _a12.auto then return end
if _a12[_a1014] then return end
local _a1016 = _a1013[_a1014]
if not _a1016 then return end
_a12[_a1014] = true
_a1003(_a1014, _a1016[1], _a1016[2], _a1016[3])
if _a18.auto.refresh then _a18.auto.refresh() end
_a5("[퀘스트] " .. tostring(_a1015) .. " ON")
end
end
_a1.MG, _a1.QS, _a1.saveGet, _a1.currencyAmount, _a1.cycleFarm, _a1.zoneStatus = _a16, _a18, _a45, _a53, _a63, _a77
_a1.cycleZone, _a1.bestMainEgg, _a1.mainHatchStatus, _a1.cycleMainHatch, _a1.mainRebirthStatus, _a1.cycleMainRebirth = _a81, _a86, _a111, _a122, _a940, _a947
_a1.cycleTowerUp, _a1.startLoop = _a986, _a1003
end
