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
while _a134() == 0 and not _a18.ctl.stopped() and (os.clock() - _a155) < 2.5 do
task.wait(0.05)
end
local _a156 = os.clock()
local _a157 = _a11.HatchClickAfter
while _a134() > 0 and not _a18.ctl.stopped() and (os.clock() - _a156) < 20 do
_a18.ctl.setAct("알 마무리", ("%s  마지막 %d개 까는 중"):format(_a127.id, _a131))
if _a11.HatchClick and (os.clock() - _a156) > _a157 then
_a18.egg.clickOnce()
_a157 += 0.3
if (os.clock() - _a156) > 3 and not _a18.egg._finRe then
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
local function _a158()
local _a159 = _a45()
if not _a159 then return nil end
local _a160 = tonumber(rawget(_a159, "Rank")) or 1
local _a161 = tonumber(rawget(_a159, "RankStars")) or 0
local _a162 = rawget(_a159, "RedeemedRankRewards") or {}
local _a163
if _a16.RanksU and rawget(_a16.RanksU, "RankIDFromNumber") then
local _a164, _a165 = pcall(_a16.RanksU.RankIDFromNumber, _a160)
if _a164 then _a163 = _a165 end
end
local _a166 = _a163 and _a16.DirRanks and rawget(_a16.DirRanks, _a163)
if type(_a166) ~= "table" then
return { rankNum = _a160, stars = _a161, rankId = _a163, rewards = {} }
end
local _a167, _a168 = {}, 0
for _a169, _a170 in ipairs(rawget(_a166, "Rewards") or {}) do
_a168 += (tonumber(rawget(_a170, "StarsRequired")) or 0)
local _a171 = _a168 <= _a161
local _a172 = _a162[tostring(_a169)] ~= nil
_a167[#_a167 + 1] = {
index = _a169, need = _a168, earned = _a171, redeemed = _a172,
claimable = _a171 and not _a172,
}
end
return { rankNum = _a160, stars = _a161, rankId = _a163, rewards = _a167 }
end
local function _a173()
if not _a16.R_Rank then _a5("[랭크] Ranks_ClaimReward 리모트 없음") return end
local _a174 = _a158()
if not _a174 then return end
local _a175 = 0
for _a176, _a177 in ipairs(_a174.rewards) do
if not _a12.rank then break end
if _a177.claimable then
pcall(function() _a16.R_Rank:FireServer(_a177.index) end)
_a175 += 1
_a13.rank += 1
task.wait(0.1)
end
end
if _a175 > 0 then
_a5(("[랭크] 보상 %d개 수령  (Rank %d, ★%d)"):format(_a175, _a174.rankNum, _a174.stars))
end
end
function _a18.move.hrp()
local _a178 = _a4.Character
return _a178 and _a178:FindFirstChild("HumanoidRootPart"),
_a178 and _a178:FindFirstChildOfClass("Humanoid")
end
function _a18.egg.autoHatchOn(_a179, _a180)
if not _a11.UseAutoHatch then return end
if _a18.egg._ahEgg == _a179 and _a18.egg._ahAt and (os.clock() - _a18.egg._ahAt) < 15 then return end
_a18.egg._ahEgg, _a18.egg._ahAt = _a179, os.clock()
local _a181 = _a16.DirEggs and rawget(_a16.DirEggs, _a179)
if _a16.Hatch and _a181 and rawget(_a16.Hatch, "SetupEgg") then
local _a182, _a183 = pcall(_a16.Hatch.SetupEgg, _a181, _a180 or 1)
if not _a182 and not _a18.egg._ahWarn then
_a18.egg._ahWarn = true
_a5("[부화] SetupEgg 실패: " .. tostring(_a183) .. "  → 클릭 대체 사용")
end
end
if _a16.R_AHTog then pcall(function() _a16.R_AHTog:FireServer(true) end) end
if _a16.R_AHOn then pcall(function() _a16.R_AHOn:FireServer(_a179, _a180 or 1) end) end
if _a16.Hatch and rawget(_a16.Hatch, "IsHatching") then
local _a184, _a185 = pcall(_a16.Hatch.IsHatching)
_a18.egg._ahLive = _a184 and _a185 and true or false
end
end
function _a18.egg.autoHatchOff()
_a18.egg._ahEgg, _a18.egg._ahAt, _a18.egg._ahLive = nil, nil, nil
if _a16.Hatch and rawget(_a16.Hatch, "StopHatching") then pcall(_a16.Hatch.StopHatching) end
if _a16.R_AHOff then pcall(function() _a16.R_AHOff:FireServer() end) end
end
function _a18.egg.clickOnce()
if _a18.ctl.moving then return false end
local _a186 = _a18.screen.signal("egg")
if not _a186 then _a186 = _a18.screen.pressInGame({ "Egg Opening" }) end
if not _a186 and not _a18.egg._eggSigWarn then
_a18.egg._eggSigWarn = true
_a5("[부화] 게임 내 방법이 다 막힘 — SetupEgg 에만 의존합니다")
end
return _a186
end
function _a18.egg.watchStuck()
local _a187 = _a16.Vars
if not _a187 then return end
local _a188 = tonumber(rawget(_a187, "OpeningEgg")) or 0
if _a188 <= 0 then
_a18.egg.stuckSince, _a18.egg.stuckSaid = nil, nil
return
end
_a18.egg.stuckSince = _a18.egg.stuckSince or os.clock()
local _a189 = os.clock() - _a18.egg.stuckSince
if _a189 < 3 then return end
if not _a11.HatchClick then return end
if _a18.ctl.moving then _a18.screen.signal("egg") else _a18.egg.clickOnce() end
if _a189 > 6 and not _a18.egg.stuckSaid then
_a18.egg.stuckSaid = true
_a5("[부화] 까는 화면에서 멈춰 있어 계속 넘기는 중")
end
end
function _a18.item.applyPetSpeed()
local _a190 = _a16.PlayerPet
if not (_a190 and rawget(_a190, "GetByPlayer")) then return 0, "PlayerPet 없음" end
local _a191, _a192 = pcall(_a190.GetByPlayer, _a4)
if not (_a191 and type(_a192) == "table") then return 0, "펫 목록 못 읽음" end
local _a193 = math.max(1, tonumber(_a11.PetSpeedMult) or 50)
local _a194 = math.max(0.05, tonumber(_a11.PetSpeedBase) or 4)
local _a195 = 0
for _a196, _a197 in pairs(_a192) do
if type(_a197) == "table" then
local _a198 = rawget(_a197, "cpet")
if _a198 then
_a197.speedMult = _a193
pcall(function() _a198:Broadcast("petSpeedMult", _a193) end)
pcall(function() _a198:Broadcast("petSpeed", _a194) end)
_a195 += 1
end
end
end
return _a195
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
function _a18.screen.findSignalFns(_a199)
local _a200 = _a18.screen.SIGNAL[_a199]
if not _a200 then return {} end
_a18.screen._sig = _a18.screen._sig or {}
local _a201 = _a18.screen._sig[_a199]
if _a201 and (os.clock() - _a201.at) < (#_a201.fns > 0 and 20 or 3) then return _a201.fns end
local _a202 = {}
_a18.screen._sig[_a199] = { at = os.clock(), fns = _a202 }
if type(getgc) ~= "function" or type(debug) ~= "table"
or type(debug.info) ~= "function" or type(debug.getupvalue) ~= "function" then
return _a202
end
local _a203 = {}
for _a204, _a205 in ipairs({ true, false }) do
local _a206, _a207 = pcall(getgc, _a205)
if _a206 and type(_a207) == "table" then
for _a208, _a209 in ipairs(_a207) do _a203[#_a203 + 1] = _a209 end
end
end
if #_a203 == 0 then return _a202 end
for _a210, _a211 in ipairs(_a203) do
if type(_a211) == "function" then
local _a212, _a213 = pcall(debug.info, _a211, "s")
if _a212 and type(_a213) == "string" then
local _a214 = false
for _a215, _a216 in ipairs(_a200.pats) do
if _a213:find(_a216, 1, true) then _a214 = true break end
end
if _a214 then
local _a217, _a218 = pcall(debug.info, _a211, "a")
if _a217 then
local _a219, _a220 = {}, 0
for _a221 = 1, 16 do
local _a222, _a223 = pcall(debug.getupvalue, _a211, _a221)
if not _a222 then break end
_a220 = _a221
_a219[_a221] = type(_a223)
end
local _a224 = table.concat(_a219, ",")
local _a225 = false
for _a226, _a227 in ipairs(_a200.sigs or {}) do
if _a218 == _a227.np and _a224 == _a227.t then
_a202[#_a202 + 1] = { fn = _a211, sig = _a224, n = _a220, np = _a218,
src = _a213, set = _a227.set }
_a225 = true
break
end
end
if not _a225 and _a200.sigs then
local _a228 = {}
for _a229, _a230 in ipairs(_a219) do
if _a230 == "boolean" then _a228[#_a228 + 1] = _a229 end
end
if #_a228 > 0 then
_a202[#_a202 + 1] = { fn = _a211, idx = _a228, sig = _a224, n = _a220,
np = _a218, src = _a213, loose = true }
end
end
if not _a225 and not _a200.sigs and _a218 == 0 then
local _a231 = 0
for _a232, _a233 in ipairs(_a219) do if _a233 == "boolean" then _a231 += 1 end end
if _a231 >= (_a200.minBools or 1) then
local _a234 = {}
for _a235, _a236 in ipairs(_a219) do
if _a236 == "boolean" then _a234[#_a234 + 1] = _a235 end
end
_a202[#_a202 + 1] = { fn = _a211, idx = _a234, sig = _a224, n = _a220, src = _a213 }
end
end
end
end
end
end
end
return _a202
end
function _a18.screen.signal(_a237)
if type(debug) ~= "table" or type(debug.setupvalue) ~= "function" then return false, 0 end
local _a238 = _a18.screen.findSignalFns(_a237)
local _a239 = 0
for _a240, _a241 in ipairs(_a238) do
if _a241.set then
for _a242, _a243 in ipairs(_a241.set) do
if pcall(debug.setupvalue, _a241.fn, _a243[1], _a243[2]) then _a239 += 1 end
end
elseif not _a241.loose then
for _a244, _a245 in ipairs(_a241.idx or {}) do
if pcall(debug.setupvalue, _a241.fn, _a245, true) then _a239 += 1 end
end
end
end
if _a239 == 0 then
for _a246, _a247 in ipairs(_a238) do
if _a247.loose then
for _a248, _a249 in ipairs(_a247.idx or {}) do
if pcall(debug.setupvalue, _a247.fn, _a249, true) then _a239 += 1 end
end
end
end
end
return _a239 > 0, _a239
end
function _a18.screen.pressInGame(_a250)
local _a251, _a252 = pcall(function() return game:GetService("UserInputService") end)
if not (_a251 and _a252) then return false end
local _a253 = {
UserInputType  = Enum.UserInputType.MouseButton1,
UserInputState = Enum.UserInputState.Begin,
KeyCode        = Enum.KeyCode.Unknown,
Position       = Vector3.new(),
Delta          = Vector3.new(),
}
local _a254 = 0
if type(getconnections) == "function" then
local _a255, _a256 = pcall(getconnections, _a252.InputBegan)
if _a255 and type(_a256) == "table" then
for _a257, _a258 in ipairs(_a256) do
local _a259 = ""
local _a260 = _a258.Function
if _a260 and type(debug) == "table" and type(debug.info) == "function" then
local _a261, _a262 = pcall(debug.info, _a260, "s")
if _a261 and _a262 then _a259 = tostring(_a262) end
end
local _a263 = false
for _a264, _a265 in ipairs(_a250) do
if _a259 ~= "" and _a259:find(_a265, 1, true) then _a263 = true break end
end
if _a263 then
if _a260 and pcall(_a260, _a253, false) then _a254 += 1
elseif _a258.Fire and pcall(function() _a258:Fire(_a253, false) end) then _a254 += 1
elseif _a258.Defer and pcall(function() _a258:Defer(_a253, false) end) then _a254 += 1 end
end
end
end
end
if _a254 == 0 and type(firesignal) == "function" then
if pcall(firesignal, _a252.InputBegan, _a253, false) then _a254 += 1 end
end
return _a254 > 0
end
function _a18.screen.realClick(_a266)
if not _a11.ScreenRealClick then return false end
local _a267 = workspace.CurrentCamera
local _a268 = (_a267 and _a267.ViewportSize) or Vector2.new(1280, 720)
local _a269, _a270 = _a268.X * 0.5, _a268.Y * 0.45
local _a271 = {}
local function _a272(_a273, _a274)
local _a275 = pcall(_a274)
_a271[#_a271 + 1] = _a273 .. (_a275 and "=OK" or "=X")
return _a275
end
local _a276 = false
if not _a276 and type(mouse1click) == "function" then
_a276 = _a272("mouse1click", function() mouse1click() end)
end
if not _a276 and type(mouse1press) == "function" then
_a276 = _a272("mouse1press", function()
mouse1press() task.wait(0.05)
if type(mouse1release) == "function" then mouse1release() end
end)
end
if not _a276 then
_a276 = _a272("VirtualUser", function()
local _a277 = game:GetService("VirtualUser")
_a277:Button1Down(Vector2.new(_a269, _a270), _a267 and _a267.CFrame or CFrame.new())
task.wait(0.05)
_a277:Button1Up(Vector2.new(_a269, _a270), _a267 and _a267.CFrame or CFrame.new())
end)
end
if not _a276 then
_a276 = _a272("VirtualInputManager", function()
local _a278 = game:GetService("VirtualInputManager")
_a278:SendMouseButtonEvent(_a269, _a270, 0, true, game, 1)
task.wait(0.05)
_a278:SendMouseButtonEvent(_a269, _a270, 0, false, game, 1)
end)
end
if _a266 then _a5("    " .. table.concat(_a271, " / ")) end
return _a276
end
function _a18.screen.rewardScreenUp()
if not _a4 then
if not _a18.screen.noLP then
_a18.screen.noLP = true
_a5("[화면] LocalPlayer 를 못 잡았습니다 — 화면 감시를 건너뜁니다")
end
return false
end
local _a279 = _a4:FindFirstChildOfClass("PlayerGui")
if _a279 then
for _a280, _a281 in ipairs(_a18.screen.BLOCKERS) do
local _a282 = _a279:FindFirstChild(_a281[1])
if _a282 and _a282:IsA("ScreenGui") and _a282.Enabled then return true, _a281[2], _a281[3] end
end
end
local _a283 = _a16.Vars
if _a283 then
if rawget(_a283, "IsRebirthing") then return true, "리버스", "reward" end
if rawget(_a283, "IsRankingUp") then return true, "랭크업", "reward" end
end
return false
end
function _a18.screen.dismissRewardScreens(_a284)
if _a18.screen.dismissBusy then return end
_a18.screen.dismissBusy = true
local _a285, _a286 = pcall(_a18.screen.dismissInner, _a284)
_a18.screen.dismissBusy = false
if not _a285 then _a5("[화면] 오류: " .. tostring(_a286)) end
end
function _a18.screen.dismissInner(_a287)
local _a288 = _a16.Vars
if not _a288 then return end
local _a289 = os.clock()
local _a290, _a291 = false, nil
local _a292 = 0
local _a293 = math.max(3, _a11.ScreenTryMax or 8)
while os.clock() - _a289 < (_a287 or 120) do
local _a294, _a295, _a296 = _a18.screen.rewardScreenUp()
if not _a294 then break end
_a290, _a291 = true, _a295
_a292 += 1
_a18.ctl.setAct("보상 화면 넘기는 중",
("%s (%d회%s)"):format(tostring(_a295), _a292,
_a292 <= 6 and " · 첫 화면 대기" or ""))
local _a297 = _a18.screen.SIGNAL[_a296 or "reward"]
local _a298 = (_a297 and _a297.pats) or { "Rebirth", "Rank Up" }
local _a299 = _a18.screen.signal(_a296 or "reward")
if not _a299 then
for _a300 in pairs(_a18.screen.SIGNAL) do
if _a18.screen.signal(_a300) then _a299 = true end
end
end
local _a301 = false
if not _a299 or _a292 >= 2 then
_a301 = _a18.screen.pressInGame(_a298)
end
if _a292 >= 3 then
if _a18.screen.realClick() then
_a301 = true
if not _a18.screen._realSaid then
_a18.screen._realSaid = true
_a5("[화면] 실제 클릭까지 같이 씁니다 (Roblox 창이 켜져 있어야 먹습니다)")
end
end
end
if (_a299 or _a301) and not _a18.screen._sigSaid then
_a18.screen._sigSaid = true
_a5("[화면] " .. (_a299 and "upvalue 신호" or "게임 내 입력 발동") .. " 로 넘깁니다")
end
if _a292 >= _a293 and (os.clock() - _a289) >= 12 then
if _a18.screen.giveUpSaid ~= _a295 then
_a18.screen.giveUpSaid = _a295
_a5(("[화면] %s 화면을 못 넘김 — 그냥 두고 자동화는 계속합니다"):format(tostring(_a295)))
_a5("        (이 화면은 UI만 가릴 뿐 리모트 호출은 막지 않습니다)")
end
_a18.screen.screenGaveUp = os.clock()
return
end
task.wait(0.8)
end
if _a290 then
if not _a18.screen.rewardScreenUp() then
_a18.screen.lastBlocker = nil
_a18.screen.screenGaveUp = nil
_a5(("[화면] %s 넘김 완료 (%d회)"):format(tostring(_a291), _a292))
end
end
end
function _a18.egg.eggUnlocked(_a302)
_a302 = tonumber(_a302)
if not _a302 then return false end
local _a303 = _a45()
local _a304 = _a303 and rawget(_a303, "UnlockedEggs")
if type(_a304) == "table" then
for _a305, _a306 in pairs(_a304) do
if tonumber(_a306) == _a302 then return true end
end
return false
end
return _a302 <= 1
end
function _a18.egg.lockedEggs()
local _a307 = {}
if not _a16.DirEggs then return _a307, 0, 0 end
local _a308 = _a45()
local _a309 = tonumber(_a308 and rawget(_a308, "MaximumAvailableEgg")) or 1
local _a310 = 0
local _a311 = _a308 and rawget(_a308, "UnlockedEggs")
if type(_a311) == "table" then
for _a312, _a313 in pairs(_a311) do
local _a314 = tonumber(_a313)
if _a314 and _a314 > _a310 then _a310 = _a314 end
end
end
for _a315, _a316 in pairs(_a16.DirEggs) do
if type(_a316) == "table" and not rawget(_a316, "isCustomEgg") then
local _a317 = tonumber(rawget(_a316, "eggNumber"))
if _a317 and _a317 <= _a309 and not _a18.egg.eggUnlocked(_a317) then
_a307[#_a307 + 1] = { id = _a315, num = _a317 }
end
end
end
table.sort(_a307, function(_a318, _a319) return _a318.num < _a319.num end)
return _a307, _a309, _a310
end
function _a18.egg.unlockEggs(_a320)
if not _a16.R_EggUn then return 0, "Eggs_RequestUnlock 리모트 없음" end
local _a321 = _a18.egg.lockedEggs()
if #_a321 == 0 then return 0 end
local _a322, _a323 = 0, nil
for _a324, _a325 in ipairs(_a321) do
if not _a18.egg.eggUnlocked(_a325.num) then
local _a326, _a327
pcall(function() _a326, _a327 = _a16.R_EggUn:InvokeServer(_a325.id) end)
if not _a326 and _a11.HatchAutoTp then
local _a328 = _a18.egg.tpEgg(_a325.id)
if _a328 then
task.wait(0.3)
pcall(function() _a326, _a327 = _a16.R_EggUn:InvokeServer(_a325.id) end)
end
end
if _a326 then
_a322 += 1
_a18.ctl.setAct("알 해금", ("#%d %s"):format(_a325.num, _a325.id))
_a5(("  🔓 알 해금  #%d %s"):format(_a325.num, _a325.id))
task.wait(0.15)
else
_a323 = _a327
if _a320 then
_a5(("[해금] #%d %s 실패: %s"):format(_a325.num, _a325.id, tostring(_a327)))
end
end
end
end
return _a322, _a323
end
function _a18.move.curZone()
if _a16.Map and rawget(_a16.Map, "GetCurrentZone") then
local _a329, _a330 = pcall(_a16.Map.GetCurrentZone)
if _a329 then return _a330 end
end
return nil
end
function _a18.move.zone1()
if not _a16.DirZones then return nil end
local _a331, _a332 = nil, math.huge
for _a333, _a334 in pairs(_a16.DirZones) do
if type(_a334) == "table" and _a18.move.ownsZone(_a333) then
local _a335 = tonumber(rawget(_a334, "ZoneNumber")) or math.huge
if _a335 < _a332 then _a331, _a332 = _a333, _a335 end
end
end
return _a331
end
function _a18.move.realZone(_a336) return _a336 end
function _a18.move.resolvableZone(_a337)
if _a337 then
local _a338 = _a18.move.zonePos(_a337)
if _a338 then return _a337, _a338 end
end
if not _a16.DirZones then return nil end
local _a339 = {}
for _a340, _a341 in pairs(_a16.DirZones) do
if type(_a341) == "table" and _a18.move.ownsZone(_a340) then
_a339[#_a339 + 1] = { id = _a340, n = tonumber(rawget(_a341, "ZoneNumber")) or 0 }
end
end
table.sort(_a339, function(_a342, _a343) return _a342.n > _a343.n end)
for _a344, _a345 in ipairs(_a339) do
if _a345.id ~= _a337 then
local _a346 = _a18.move.zonePos(_a345.id)
if _a346 then
if _a18.move.fallZone ~= _a345.id then
_a18.move.fallZone = _a345.id
_a5(("[TP] %s 좌표를 못 구해서 %s 로 대신 감 (로드 안 된 존)"):format(
tostring(_a337), tostring(_a345.id)))
end
return _a345.id, _a346
end
end
end
return nil
end
function _a18.move.bestZone()
if _a16.Zone and rawget(_a16.Zone, "GetMaxOwnedZone") then
local _a347, _a348, _a349 = pcall(_a16.Zone.GetMaxOwnedZone)
if _a347 and _a348 then return _a348, _a349 end
end
return _a18.move.zone1()
end
function _a18.move.ownsZone(_a350)
local _a351 = _a45()
local _a352 = _a351 and rawget(_a351, "UnlockedZones")
return (type(_a352) == "table" and _a352[_a350] ~= nil) or false
end
function _a18.move.zoneByNumber(_a353)
if not (_a16.DirZones and _a353) then return nil end
for _a354, _a355 in pairs(_a16.DirZones) do
if type(_a355) == "table" and tonumber(rawget(_a355, "ZoneNumber")) == tonumber(_a353) then
return _a354, _a355
end
end
return nil
end
local function _a356(_a357, _a358)
local _a359 = rawget(_a357, "Breakables")
local _a360 = type(_a359) == "table" and rawget(_a359, "Main") or nil
local _a361 = type(_a360) == "table" and rawget(_a360, "Data") or nil
if type(_a361) ~= "table" then return false end
for _a362, _a363 in pairs(_a361) do
local _a364 = type(_a363) == "table" and rawget(_a363, "Type") or nil
if _a364 and tostring(_a364):lower():find(_a358, 1, true) then return true end
end
return false
end
function _a18.move.zoneForBreakable(_a365)
if not (_a16.DirZones and _a365) then return nil end
local _a366 = tostring(_a365):lower()
local _a367 = _a18.move.bestZone()
if _a367 then
local _a368 = rawget(_a16.DirZones, _a367)
if type(_a368) == "table" and _a356(_a368, _a366) then return _a367 end
end
local _a369, _a370 = nil, -1
for _a371, _a372 in pairs(_a16.DirZones) do
if type(_a372) == "table" and _a371 ~= "Spawn" and _a18.move.ownsZone(_a371) then
local _a373 = rawget(_a372, "Breakables")
local _a374 = type(_a373) == "table" and rawget(_a373, "Main") or nil
local _a375 = type(_a374) == "table" and rawget(_a374, "Data") or nil
if type(_a375) == "table" then
for _a376, _a377 in pairs(_a375) do
local _a378 = type(_a377) == "table" and rawget(_a377, "Type") or nil
if _a378 and tostring(_a378):lower():find(_a366, 1, true) then
local _a379 = tonumber(rawget(_a372, "ZoneNumber")) or 0
if _a379 > _a370 then _a369, _a370 = _a371, _a379 end
break
end
end
end
end
end
return _a369
end
function _a18.move.tpZone(_a380)
if not _a380 then return false, "존 id 없음" end
if _a18.move.curZone() == _a380 then return true end
if not _a11.TpGameFallback then
_a5("[TP] 게임 정식 TP 차단됨 (" .. tostring(_a380) .. ")\n" .. debug.traceback("", 2))
return false, "게임 TP 꺼져 있음"
end
local _a381 = _a16.R_Tp
if _a16.Inst and rawget(_a16.Inst, "IsInInstance") then
local _a382, _a383 = pcall(_a16.Inst.IsInInstance)
if _a382 and _a383 and _a16.R_TpI then _a381 = _a16.R_TpI end
end
if not _a381 then return false, "텔레포트 리모트 없음" end
local _a384 = os.clock() - (_a18.move.lastTp or 0)
if _a384 < _a11.TpCooldown then task.wait(_a11.TpCooldown - _a384) end
_a18.move.lastTp = os.clock()
local _a385, _a386
pcall(function() _a385, _a386 = _a381:InvokeServer(_a380) end)
if not _a385 then return false, _a386 end
local _a387 = os.clock()
while os.clock() - _a387 < 5 do
if _a18.move.curZone() == _a380 then break end
task.wait(0.05)
end
task.wait(0.15)
return true
end
function _a18.move.glideTo(_a388)
if _a18.ctl.stopped() then return false, "정지됨" end
if _a18.ctl.moving and (os.clock() - _a18.ctl.moving) < 30 then
return false, "이미 이동 중 (다른 이동이 아직 안 끝남)"
end
_a18.ctl.moving = os.clock()
local _a389, _a390, _a391 = pcall(_a18.move.glideRaw, _a388)
_a18.ctl.moving = nil
if not _a389 then return false, tostring(_a390) end
return _a390, _a391
end
function _a18.move.glideRaw(_a392)
local _a393, _a394 = _a18.move.hrp()
if not _a393 then return false, "캐릭터 없음" end
if _a11.TpMode == "instant" then
local _a395 = _a392 + Vector3.new(0, 4, 0)
for _a396 = 1, 3 do
local _a397 = _a4.Character
local _a398, _a399 = _a18.move.hrp()
if not (_a397 and _a398) then return false, "캐릭터 없음" end
local _a400 = _a398.CFrame - _a398.CFrame.Position
pcall(function() _a397:PivotTo(CFrame.new(_a395) * _a400) end)
_a398.AssemblyLinearVelocity = Vector3.zero
for _a401 = 1, 6 do _a3.Heartbeat:Wait() end
if _a399 then
pcall(function()
_a399:Move(Vector3.new(0.3, 0, 0), false)
end)
task.wait(0.1)
pcall(function() _a399:Move(Vector3.zero, false) end)
end
task.wait(0.15)
_a398 = _a18.move.hrp()
if _a398 and (_a398.Position - _a395).Magnitude <= 30 then
local _a402 = os.clock()
while os.clock() - _a402 < 1.5 do
if _a18.move.inDottedBox() ~= false then break end
task.wait(0.05)
end
return true
end
if _a396 < 3 then task.wait(0.15) end
end
return false, "순간이동이 되돌려짐"
end
if _a11.TpMode == "walk" then
if not _a394 then return false, "Humanoid 없음" end
local _a403 = os.clock()
while os.clock() - _a403 < 45 do
local _a404 = _a393.Position
if (Vector3.new(_a404.X, 0, _a404.Z) - Vector3.new(_a392.X, 0, _a392.Z)).Magnitude < 8 then
return true
end
_a394:MoveTo(_a392)
task.wait(0.5)
end
return false, "걸어가다 시간초과"
end
if (_a393.Position - _a392).Magnitude <= (_a11.ArriveDist or 12) then return true end
local _a405 = math.max(16, tonumber(_a11.TpSpeed) or 90)
local _a406 = math.max(0, tonumber(_a11.TpHeight) or 0)
local function _a407(_a408, _a409)
local _a410 = 0
while _a410 < 2000 do
if _a18.ctl.stopped() then return false end
_a410 += 1
local _a411 = _a18.move.hrp()
if not _a411 then return false end
local _a412 = _a411.Position
local _a413 = _a408 - _a412
local _a414 = _a413.Magnitude
if _a414 < 2.5 then return true end
local _a415 = _a3.Heartbeat:Wait()
local _a416 = math.min(_a414, _a405 * math.min(_a415, 0.1))
local _a417 = _a409 and (Vector3.new(_a408.X, _a412.Y, _a408.Z)) or nil
if _a417 and (_a417 - _a412).Magnitude > 1 then
_a411.CFrame = CFrame.lookAt(_a412 + _a413.Unit * _a416, _a417)
else
_a411.CFrame = CFrame.new(_a412 + _a413.Unit * _a416) * (_a411.CFrame - _a411.Position)
end
_a411.AssemblyLinearVelocity = Vector3.zero
end
return false
end
if _a406 > 0 then
local _a418 = _a393.Position
local _a419 = math.max(_a418.Y, _a392.Y) + _a406
_a407(Vector3.new(_a418.X, _a419, _a418.Z), false)
_a407(Vector3.new(_a392.X, _a419, _a392.Z), true)
end
_a407(_a392 + Vector3.new(0, 3, 0), true)
local _a420 = _a18.move.hrp()
if _a420 then _a420.AssemblyLinearVelocity = Vector3.zero end
return true
end
local function _a421(_a422)
local _a423 = #_a422
if _a423 == 0 then return nil, 0 end
local _a424, _a425 = math.huge, -math.huge
local _a426, _a427 = math.huge, -math.huge
local _a428 = 0
for _a429, _a430 in ipairs(_a422) do
if _a430.X < _a424 then _a424 = _a430.X end
if _a430.X > _a425 then _a425 = _a430.X end
if _a430.Z < _a426 then _a426 = _a430.Z end
if _a430.Z > _a427 then _a427 = _a430.Z end
_a428 += _a430.Y
end
return Vector3.new((_a424 + _a425) / 2, _a428 / _a423, (_a426 + _a427) / 2), _a423
end
function _a18.move.breakCenter(_a431)
local _a432 = _a18.move.hrp()
if not _a432 then return nil, 0 end
local _a433 = workspace:FindFirstChild("__THINGS")
if not _a433 then return nil, 0 end
local _a434 = _a432.Position
local _a435 = {}
for _a436, _a437 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a438 = _a433:FindFirstChild(_a437)
if _a438 then
for _a439, _a440 in ipairs(_a438:GetChildren()) do
local _a441
if _a440:IsA("BasePart") then _a441 = _a440.Position
elseif _a440:IsA("Model") then
local _a442, _a443 = pcall(function() return _a440:GetPivot() end)
if _a442 and typeof(_a443) == "CFrame" then _a441 = _a443.Position end
end
if _a441 and (_a441 - _a434).Magnitude <= (_a431 or 400) then
_a435[#_a435 + 1] = _a441
end
end
end
end
return _a421(_a435)
end
function _a18.move.groundY(_a444, _a445, _a446)
_a446 = tonumber(_a446) or 0
local _a447 = RaycastParams.new()
_a447.FilterType = Enum.RaycastFilterType.Exclude
local _a448 = {}
if _a4.Character then _a448[#_a448 + 1] = _a4.Character end
local _a449 = workspace:FindFirstChild("__THINGS")
if _a449 then _a448[#_a448 + 1] = _a449 end
_a447.FilterDescendantsInstances = _a448
local _a450 = Vector3.new(_a444, _a446 + 12, _a445)
local _a451, _a452 = pcall(function()
return workspace:Raycast(_a450, Vector3.new(0, -160, 0), _a447)
end)
if _a451 and _a452 then
local _a453 = _a452.Position.Y
if math.abs(_a453 - _a446) <= 80 then return _a453 + 4 end
end
return nil
end
function _a18.move.zonePos(_a454, _a455)
if not _a454 then return nil, "존 id 없음" end
_a454 = _a18.move.realZone(_a454)
local _a456 = _a16.DirZones and rawget(_a16.DirZones, _a454)
local _a457 = _a456 and rawget(_a456, "ZoneFolder")
local _a458 = {}
do
local _a459 = workspace:FindFirstChild("__THINGS")
for _a460, _a461 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a462 = _a459 and _a459:FindFirstChild(_a461)
if _a462 then
for _a463, _a464 in ipairs(_a462:GetChildren()) do
local _a465
if _a464:IsA("BasePart") then _a465 = _a464.Position
elseif _a464:IsA("Model") then
local _a466, _a467 = pcall(function() return _a464:GetPivot() end)
if _a466 and typeof(_a467) == "CFrame" then _a465 = _a467.Position end
end
if _a465 then _a458[#_a458 + 1] = _a465 end
end
end
end
end
local _a468 = {}
local function _a469(_a470, _a471)
if not _a470 then return end
local _a472, _a473 = pcall(function() return _a470:GetDescendants() end)
if _a470:IsA("BasePart") then _a468[#_a468 + 1] = { p = _a470.Position, why = _a471 } end
if _a472 then
for _a474, _a475 in ipairs(_a473) do
if _a475:IsA("BasePart") then
_a468[#_a468 + 1] = { p = _a475.Position, why = _a471 .. "/" .. _a475.Name }
end
end
end
end
if _a16.ZonesU then
for _a476, _a477 in ipairs({ "GetBreakableZones", "GetBreakableSpawns" }) do
local _a478 = rawget(_a16.ZonesU, _a477)
if type(_a478) == "function" then
local _a479, _a480 = pcall(_a478, _a454)
if _a479 and _a480 then _a469(_a480, _a477) end
end
end
end
if _a457 then
for _a481, _a482 in ipairs({ "BREAK_ZONES", "BREAKABLE_SPAWNS" }) do
local _a483, _a484 = pcall(function() return _a457:FindFirstChild(_a482, true) end)
if _a483 and _a484 then _a469(_a484, "ZoneFolder/" .. _a482) end
end
end
local _a485, _a486, _a487
for _a488, _a489 in ipairs(_a468) do
local _a490 = 0
for _a491, _a492 in ipairs(_a458) do
if (_a492 - _a489.p).Magnitude <= 150 then _a490 += 1 end
end
if not _a486 or _a490 > _a486 then _a485, _a486, _a487 = _a489.p, _a490, _a489.why end
end
local _a493, _a494
if _a485 and (_a486 or 0) >= 1 then
_a493, _a494 = _a485, ("%s (브레이커블 %d개)"):format(tostring(_a487), _a486)
end
if not _a493 and _a485 then
_a493, _a494 = _a485, tostring(_a487) .. " (브레이커블 없음)"
end
if not _a493 and _a16.ZonesU and rawget(_a16.ZonesU, "GetTeleportPartLocation") then
local _a495, _a496 = pcall(_a16.ZonesU.GetTeleportPartLocation, _a454)
if _a495 and typeof(_a496) == "CFrame" then
_a493, _a494 = _a496.Position, "PERSISTENT/Teleport (스트리밍 대기)"
end
end
if not _a493 then return nil, "브레이커블 위치를 못 찾음" end
local _a497 = _a18.move.groundY(_a493.X, _a493.Z, _a493.Y)
if _a497 then
_a493 = Vector3.new(_a493.X, _a497, _a493.Z)
_a494 = _a494 .. " +지면"
else
_a493 = Vector3.new(_a493.X, _a493.Y + 5, _a493.Z)
end
return _a493, _a494
end
function _a18.move.goToZone(_a498, _a499, _a500, _a501)
_a498 = _a18.move.realZone(_a498)
if not _a498 then return false, "존 id 없음" end
local _a502, _a503 = _a18.move.zonePos(_a498)
if not _a502 then
if _a11.TpGameFallback and _a18.move.curZone() ~= _a498 then
local _a504, _a505 = _a18.move.tpZone(_a498)
if not _a504 then return false, _a505 end
task.wait(0.3)
_a502, _a503 = _a18.move.zonePos(_a498)
end
if not _a502 then
local _a506, _a507 = _a18.move.resolvableZone(_a498)
if _a506 and _a507 then
if _a501 then
return false, ("%s 가 로드되지 않음"):format(tostring(_a498))
end
_a498, _a502, _a503 = _a506, _a507, "대체 존 " .. tostring(_a506)
else
if _a18.move.zoneFailSaid ~= _a498 then
_a18.move.zoneFailSaid = _a498
_a5(("[TP] %s 좌표 실패: %s (갈 수 있는 존이 없음)"):format(
tostring(_a498), tostring(_a503)))
end
return false, _a503
end
end
end
local _a508 = _a18.move.hrp()
if not _a500 and _a508 and _a18.move.curZone() == _a498 then
local _a509 = _a18.move.inDottedBox()
local _a510
if _a509 ~= nil then
_a510 = _a509
else
_a510 = (_a508.Position - _a502).Magnitude <= (_a11.ZoneArriveDist or 90)
end
if _a510 then
if _a499 then _a5("[TP] 이미 " .. _a498 .. " 사냥터 안에 있음") end
return true
end
end
if _a499 then
_a5(("[TP] %s 내부 좌표 %s → (%.0f, %.0f, %.0f)"):format(
_a498, tostring(_a503), _a502.X, _a502.Y, _a502.Z))
end
local _a511, _a512 = _a18.move.glideTo(_a502)
local _a513 = _a18.move.hrp()
if _a513 and (_a513.Position - _a502).Magnitude > math.max(40, _a11.ArriveDist or 12) then
task.wait(0.2)
_a18.ctl.moving = nil
_a18.move.glideTo(_a502)
local _a514 = _a18.move.hrp()
local _a515 = _a514 and (_a514.Position - _a502).Magnitude or -1
if _a515 > math.max(40, _a11.ArriveDist or 12) then
local _a516 = _a11.TpMode
_a11.TpMode = "glide"
_a18.ctl.moving = nil
_a18.move.glideTo(_a502)
_a11.TpMode = _a516
local _a517 = _a18.move.hrp()
_a515 = _a517 and (_a517.Position - _a502).Magnitude or -1
if _a515 > math.max(40, _a11.ArriveDist or 12) then
_a5(("[TP] %s 이동 실패 — %.0f스터드 남음 (순간이동·glide 둘 다)"):format(
tostring(_a498), _a515))
return false, "이동이 되돌려짐"
end
_a5("[TP] 순간이동이 막혀서 glide 로 이동함: " .. tostring(_a498))
end
end
do
local _a518 = _a18.move.hrp()
if _a518 and (_a518.Position.Y - _a502.Y) > 25 then
_a5(("[TP] 목표보다 %.0f 높은 곳에 얹힘 — 내려감"):format(_a518.Position.Y - _a502.Y))
_a18.ctl.moving = nil
_a18.move.glideTo(Vector3.new(_a502.X, _a502.Y, _a502.Z))
end
end
if tostring(_a503):find("스트리밍", 1, true) then
task.wait(1.2)
local _a519, _a520 = _a18.move.zonePos(_a498)
if _a519 and not tostring(_a520):find("스트리밍", 1, true) then
if _a499 then
_a5("[TP] 스트리밍 로드됨 → 사냥터로 (" .. tostring(_a520) .. ")")
end
_a18.ctl.moving = nil
_a18.move.glideTo(_a519)
_a502, _a503 = _a519, _a520
end
end
if _a18.move.inDottedBox() == false then
task.wait(0.2)
local _a521, _a522 = _a18.move.breakCenter(400)
if _a521 and _a522 >= 3 then
if _a499 then
_a5(("[TP] 네모 밖 → 주변 브레이커블 %d개 중심으로 보정"):format(_a522))
end
_a18.ctl.moving = nil
_a18.move.glideTo(_a521)
_a502 = _a521
end
if _a18.move.inDottedBox() == false then
local _a523 = _a18.move.zonePos(_a498)
if _a523 and (_a523 - _a502).Magnitude > 5 then
if _a499 then _a5("[TP] 아직 네모 밖 → 좌표 재계산 후 재시도") end
_a18.ctl.moving = nil
_a18.move.glideTo(_a523)
_a502 = _a523
end
end
if _a18.move.inDottedBox() == false and _a499 then
_a5(("[TP] %s 네모 안으로 못 들어감 (좌표 %s)"):format(_a498, tostring(_a503)))
end
end
local function _a524()
if _a18.move.inDottedBox() == true then return false end
local _a525, _a526 = _a18.move.breakCenter(400)
if (_a526 or 0) >= 1 then return false end
task.wait(0.6)
if _a18.move.inDottedBox() == true then return false end
local _a527, _a528 = _a18.move.breakCenter(400)
return (_a528 or 0) < 1
end
if _a524() and (os.clock() - (_a18.move.lastRecover or -999)) > 30 then
_a18.move.lastRecover = os.clock()
_a5(("[TP] %s 근처에 브레이커블이 없음 (%s) — 좌표 확인 필요"):format(
tostring(_a498), tostring(_a503)))
end
_a18.move.zoneFailSaid = nil
_a18.move.arrivedZone = _a498
do
local _a529 = _a18.move.hrp()
local _a530 = _a529 and (_a529.Position - _a502).Magnitude or 0
if _a530 > math.max(60, _a11.ArriveDist or 12) then
_a5(("[TP] %s 도착 실패 — %.0f스터드 남음 (되돌려짐)"):format(tostring(_a498), _a530))
return false, "이동이 되돌려짐"
end
end
local _a531 = _a18.move.hrp()
if _a499 and _a531 then
_a5(("[TP] 도착. 목표까지 %.0f스터드 / 존 %s / 네모안 %s"):format(
(_a531.Position - _a502).Magnitude, tostring(_a18.move.curZone()), tostring(_a18.move.inDottedBox())))
end
return true
end
function _a18.egg.tpEgg(_a532)
if not _a532 then return false, "알 id 없음" end
for _a533, _a534 in ipairs(_a18.egg.eggStands()) do
if _a534.id == _a532 then
if _a534.dist <= _a11.EggRange then return true, _a532 end
local _a535, _a536 = _a18.move.glideTo(_a534.pos)
return _a535, _a535 and _a532 or _a536
end
end
if _a11.TpGameFallback then
local _a537 = _a16.DirEggs and rawget(_a16.DirEggs, _a532)
local _a538 = _a537 and select(1, _a18.move.zoneByNumber(rawget(_a537, "zoneNumber")))
if _a538 and _a18.move.curZone() ~= _a538 then
local _a539, _a540 = _a18.move.tpZone(_a538)
if not _a539 then return false, _a540 end
task.wait(0.5)
_a18.egg._standsAt = nil
for _a541, _a542 in ipairs(_a18.egg.eggStands()) do
if _a542.id == _a532 then return _a18.move.glideTo(_a542.pos), _a532 end
end
end
end
return false, "알 받침대를 못 찾음 (" .. tostring(_a532) .. ")"
end
function _a18.item.stacks(_a543)
local _a544 = _a45()
local _a545 = _a544 and rawget(_a544, "Inventory")
local _a546 = _a545 and rawget(_a545, _a543)
if type(_a546) ~= "table" then return {} end
local _a547 = {}
for _a548, _a549 in pairs(_a546) do
if type(_a549) == "table" then
_a547[#_a547 + 1] = {
uid = _a548,
id = tostring(rawget(_a549, "id")),
tier = tonumber(rawget(_a549, "tn")) or 1,
am = tonumber(rawget(_a549, "_am")) or 1,
}
end
end
return _a547
end
_a18.item.PERTIER = {
Potion  = { 3, 3, 4, 5, 5, 5, 5, 5, 7, 7, 7 },
Enchant = { 5, 5, 5, 7, 7, 7, 7, 7, 10, 10 },
}
function _a18.item.perTier(_a550, _a551)
_a551 = tonumber(_a551)
local _a552 = _a16.Bal and rawget(_a16.Bal,
_a550 == "Potion" and "CalcPotionsPerTierRequired" or "CalcEnchantsPerTierRequired")
if type(_a552) == "function" then
local _a553, _a554 = pcall(_a552, _a551)
_a554 = _a553 and tonumber(_a554) or nil
if _a554 and _a554 > 0 then return _a554 end
if not _a553 and not _a18.item.perTierWarned then
_a18.item.perTierWarned = true
_a5("[퀘스트] 재료 수량 함수 막힘 → 기본표로 계산 (" .. tostring(_a554) .. ")")
end
end
local _a555 = _a18.item.PERTIER[_a550]
local _a556 = _a555 and _a551 and _a555[_a551]
return (_a556 and _a556 > 0) and _a556 or nil
end
function _a18.item.upgradeTo(_a557, _a558)
local _a559 = (_a557 == "Potion") and _a16.R_PotUp or _a16.R_EncUp
if not _a559 then return 0, (_a557 .. " 업글 리모트 없음") end
local _a560 = math.max(1, (tonumber(_a558) or 2) - 1)
local _a561 = _a18.item.perTier(_a557, _a560)
if not _a561 then return 0, ("T%d 재료 수량을 못 읽음"):format(_a560) end
local _a562, _a563 = {}, 0
for _a564, _a565 in ipairs(_a18.item.stacks(_a557)) do
if _a565.tier == _a560 then
local _a566 = math.floor(_a565.am / _a561)
if _a566 > 0 then _a562[_a565.uid] = _a566 _a563 += _a566 end
end
end
if _a563 < 1 then return 0, ("T%d 재료 부족 (T%d %d개당 1개)"):format(_a560, _a560, _a561) end
local _a567, _a568
pcall(function() _a567, _a568 = _a559:InvokeServer(_a562) end)
if not _a567 then return 0, tostring(_a568) end
return _a563
end
function _a18.item.usePotion(_a569, _a570)
if not _a16.R_PotUse then return 0, "Potions: Consume 리모트 없음" end
_a569 = tonumber(_a569) or 1
local _a571 = {}
for _a572, _a573 in ipairs(_a18.item.stacks("Potion")) do
if _a573.tier >= _a569 and _a573.am >= 1 then _a571[#_a571 + 1] = _a573 end
end
if #_a571 == 0 then return 0, ("T%d 이상 포션 없음"):format(_a569) end
table.sort(_a571, function(_a574, _a575) return _a574.tier < _a575.tier end)
local _a576, _a577 = _a570, 0
for _a578, _a579 in ipairs(_a571) do
for _a580 = 1, math.min(_a576, _a579.am) do
if _a576 < 1 or not _a12.quest then break end
pcall(function() _a16.R_PotUse:FireServer(_a579.uid, 1) end)
_a577 += 1
_a576 -= 1
task.wait(0.12)
end
if _a576 < 1 then break end
end
return _a577
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
local function _a581(_a582)
if typeof(_a582) == "Vector3" then return _a582 end
if typeof(_a582) == "CFrame" then return _a582.Position end
if type(_a582) == "table" then
local _a583, _a584, _a585 = tonumber(_a582.X or _a582.x or _a582[1]), tonumber(_a582.Y or _a582.y or _a582[2]), tonumber(_a582.Z or _a582.z or _a582[3])
if _a583 and _a584 and _a585 then return Vector3.new(_a583, _a584, _a585) end
end
return nil
end
function _a18.ev.events()
local _a586
if _a16.Rand and rawget(_a16.Rand, "GetActive") then
local _a587, _a588 = pcall(_a16.Rand.GetActive)
if _a587 and type(_a588) == "table" and next(_a588) then _a586 = _a588 end
end
if not _a586 and _a16.R_Events then
local _a589, _a590 = pcall(function() return _a16.R_Events:InvokeServer() end)
if _a589 and type(_a590) == "table" then _a586 = _a590 end
end
if type(_a586) ~= "table" then return {} end
local _a591 = workspace:GetServerTimeNow()
local _a592 = {}
for _a593, _a594 in pairs(_a586) do
if type(_a594) == "table" then
local _a595 = tostring(rawget(_a594, "id") or "")
local _a596 = _a595:match("|%s*(%S+)%s*$") or _a595
local _a597 = tonumber(rawget(_a594, "started")) or 0
local _a598 = tonumber(rawget(_a594, "duration")) or 0
_a592[#_a592 + 1] = {
uid = rawget(_a594, "uid"),
id = _a595,
kind = _a596,
name = rawget(_a594, "name") or _a596,
zone = rawget(_a594, "parentID"),
pos = _a581(rawget(_a594, "origin")),
left = math.max(0, _a598 - (_a591 - _a597)),
}
end
end
table.sort(_a592, function(_a599, _a600) return _a599.left > _a600.left end)
return _a592
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
local _a601, _a602 = pcall(_a16.Map.IsInDottedBox)
if _a601 then return _a602 and true or false end
end
return nil
end
function _a18.ev.spawnItems(_a603)
local _a604 = _a18.ev.SPAWN[_a603]
if not _a604 then return {} end
local _a605 = {}
for _a606, _a607 in ipairs({ "Misc", "Consumable", "Lootbox" }) do
for _a608, _a609 in ipairs(_a18.item.stacks(_a607)) do
local _a610 = _a609.id:lower()
if _a610:find(_a604.key, 1, true) then
local _a611 = 99
if _a604.order then
for _a612, _a613 in ipairs(_a604.order) do
if _a610:find(_a613, 1, true) then _a611 = _a612 break end
end
end
_a609.rank = _a611
_a605[#_a605 + 1] = _a609
end
end
end
table.sort(_a605, function(_a614, _a615)
if _a614.rank ~= _a615.rank then return _a614.rank < _a615.rank end
return _a614.tier < _a615.tier
end)
return _a605
end
function _a18.ev.spawnEvent(_a616)
local _a617 = _a18.ev.SPAWN[_a616]
if not _a617 then return 0, "소환 불가 종류" end
local _a618 = _a9:FindFirstChild(_a617.rem)
if not _a618 then return 0, _a617.rem .. " 리모트 없음" end
local _a619 = _a18.ev.spawnItems(_a616)
if #_a619 == 0 then return 0, _a616 .. " 아이템 없음" end
local _a620 = _a18.move.inDottedBox()
if _a620 == false then return 0, "점선 네모 안이 아님" end
local _a621, _a622 = 0, nil
for _a623, _a624 in ipairs(_a619) do
if _a621 >= (_a11.SpawnPerCycle or 1) or not _a12.quest then break end
local _a625, _a626
pcall(function() _a625, _a626 = _a618:InvokeServer(_a624.uid) end)
if _a625 then
_a621 += 1
_a18.ctl.setAct("소환", _a616 .. " · " .. _a624.id)
_a5(("  🎁 %s 소환  (%s)"):format(_a616, _a624.id))
task.wait(0.4)
else
_a622 = _a626
break
end
end
return _a621, _a622
end
function _a18.ev.findEvent(_a627, _a628)
local _a629 = _a628 and _a18.move.bestZone() or nil
local _a630
for _a631, _a632 in ipairs(_a18.ev.events()) do
if _a632.kind == _a627 and _a632.left > 15 then
if not _a628 or _a632.zone == _a629 then
if not _a630 or (_a632.zone == _a18.move.curZone() and _a630.zone ~= _a18.move.curZone()) then
_a630 = _a632
end
end
end
end
return _a630
end
function _a18.ev.findChest(_a633, _a634)
local _a635 = workspace:FindFirstChild("__THINGS")
if not _a635 then return nil end
local _a636 = tostring(_a633):lower():find("superior") ~= nil
local _a637 = _a18.move.hrp()
local _a638 = _a637 and _a637.Position
local _a639, _a640, _a641, _a642
for _a643, _a644 in ipairs(_a635:GetChildren()) do
if tostring(_a644.Name):lower():find("chest", 1, true) then
for _a645, _a646 in ipairs(_a644:GetChildren()) do
local _a647
if _a646:IsA("BasePart") then _a647 = _a646.Position
elseif _a646:IsA("Model") then
local _a648, _a649 = pcall(function() return _a646:GetPivot() end)
if _a648 and typeof(_a649) == "CFrame" then _a647 = _a649.Position end
end
if _a647 then
local _a650 = _a638 and (_a647 - _a638).Magnitude or 0
local _a651 = (tostring(_a646.Name) .. tostring(_a644.Name)):lower()
:find("superior", 1, true) ~= nil
if not _a642 or _a650 < _a642 then _a641, _a642 = _a647, _a650 end
if _a651 == _a636 and (not _a640 or _a650 < _a640) then
_a639, _a640 = _a647, _a650
end
end
end
end
end
if _a639 then return _a639, _a640 end
return _a641, _a642
end
_a18.quest.SKIP = { [4] = true, [5] = true, [40] = true, [41] = true }
_a18.quest.WHERE = {
[21]="bestzone", [9]="bestzone", [37]="bestzone", [38]="bestzone", [39]="bestzone",
[43]="bestzone", [44]="bestzone", [76]="bestzone", [30]="bestzone", [8]="bestzone",
[20]="bestegg",  [42]="bestegg",
[1]="breakable", [81]="zoneid",
}
function _a18.item.petStacks()
local _a652 = _a45()
local _a653 = _a652 and rawget(_a652, "Inventory")
local _a654 = _a653 and rawget(_a653, "Pet")
local _a655 = {}
if type(_a654) ~= "table" then return _a655 end
for _a656, _a657 in pairs(_a654) do
if type(_a657) == "table" then
_a655[#_a655 + 1] = {
uid = _a656,
id = tostring(rawget(_a657, "id")),
pt = tonumber(rawget(_a657, "pt")) or 0,
am = tonumber(rawget(_a657, "_am")) or 1,
}
end
end
return _a655
end
function _a18.item.bestEggPets()
local _a658 = _a86()
local _a659 = _a658 and _a16.DirEggs and rawget(_a16.DirEggs, _a658)
local _a660 = _a659 and rawget(_a659, "pets")
local _a661 = {}
if type(_a660) == "table" then
for _a662, _a663 in pairs(_a660) do
local _a664 = type(_a663) == "table" and _a663[1] or _a663
if _a664 then _a661[tostring(_a664)] = true end
end
end
return _a661, _a658
end
function _a18.item.makeVariant(_a665, _a666)
local _a667 = (_a665 == "gold") and _a16.R_Gold or _a16.R_Rain
if not _a667 then return 0, (_a665 .. " 머신 리모트 없음") end
local _a668 = (_a665 == "gold") and 0 or 1
local _a669
if _a666 then
local _a670, _a671 = _a18.item.bestEggPets()
if not next(_a670) then return 0, "최고 알(" .. tostring(_a671) .. ") 펫 목록을 못 읽음" end
_a669 = _a670
end
local _a672, _a673 = 0, nil
for _a674, _a675 in ipairs(_a18.item.petStacks()) do
if not _a12.quest then break end
if _a675.pt == _a668 and _a675.am >= 10 and (not _a669 or _a669[_a675.id]) then
local _a676 = math.floor(_a675.am / 10)
if _a676 > 0 then
local _a677, _a678
pcall(function() _a677, _a678 = _a667:InvokeServer(_a675.uid, _a676) end)
if _a677 then
_a672 += _a676
_a5(("  ✨ %s 제작  %s x%d"):format(
_a665 == "gold" and "골드" or "레인보우", _a675.id, _a676))
task.wait(0.4)
else
_a673 = _a678
end
end
end
end
return _a672, _a673
end
function _a18.item.useFlag(_a679)
if not _a16.R_Flag then return 0, "FlexibleFlags_Consume 리모트 없음" end
local _a680, _a681 = 0, nil
for _a682, _a683 in ipairs(_a18.item.stacks("Misc")) do
if _a680 >= (_a679 or 1) then break end
if _a683.id:lower():find("flag", 1, true) and _a683.am >= 1 and _a18.item.itemAllowed(_a683.id) then
local _a684, _a685
pcall(function() _a684, _a685 = _a16.R_Flag:InvokeServer(_a683.id, _a683.uid, 1) end)
if _a684 then _a680 += 1 task.wait(0.4) else _a681 = _a685 end
end
end
return _a680, _a681
end
function _a18.item.useFruit(_a686)
if not _a16.R_Fruit then return 0, "Fruits: Consume 리모트 없음" end
local _a687 = _a18.item.activeBuffs("Fruits")
local _a688 = 0
for _a689, _a690 in ipairs(_a18.item.stacks("Fruit")) do
if _a688 >= (_a686 or 1) then break end
if _a690.am >= 1 and _a18.item.itemAllowed(_a690.id) and not _a687[_a690.id] then
pcall(function() _a16.R_Fruit:FireServer(_a690.uid, 1) end)
_a688 += 1
task.wait(0.4)
end
end
return _a688
end
function _a18.quest.status()
local _a691 = _a45()
if not _a691 then return nil end
local _a692 = rawget(_a691, "Goals")
if type(_a692) ~= "table" then return { list = {} } end
local _a693 = {}
for _a694, _a695 in pairs(_a692) do
if type(_a695) == "table" then
local _a696 = tonumber(rawget(_a695, "Type")) or -1
local _a697
if _a16.Quest and rawget(_a16.Quest, "MakeTitle") then
local _a698, _a699 = pcall(_a16.Quest.MakeTitle, _a695)
if _a698 then _a697 = _a699 end
end
_a693[#_a693 + 1] = {
slot = _a694,
uid = tostring(rawget(_a695, "UID")),
type = _a696,
how = _a17[_a696],
title = _a697 or ("Type " .. _a696),
amount = tonumber(rawget(_a695, "Amount")) or 0,
progress = tonumber(rawget(_a695, "Progress")) or 0,
stars = tonumber(rawget(_a695, "Stars")) or 0,
potionTier = tonumber(rawget(_a695, "PotionTier")),
enchantTier = tonumber(rawget(_a695, "EnchantTier")),
breakable = rawget(_a695, "BreakableType") or rawget(_a695, "BreakableDirID"),
zoneId = rawget(_a695, "ZoneID"),
where = _a18.quest.WHERE[_a696] or (_a17[_a696] == "farm" and "bestzone" or nil),
event = _a18.ev.EVENTKIND[_a696],
chest = _a18.ev.CHESTKIND[_a696],
bestOnly = _a18.ev.BESTONLY[_a696] or false,
ignored = _a18.quest.IGNORE[_a696],
}
end
end
table.sort(_a693, function(_a700, _a701) return _a700.stars > _a701.stars end)
return { list = _a693, rank = tonumber(rawget(_a691, "Rank")) or 1,
rankStars = tonumber(rawget(_a691, "RankStars")) or 0 }
end
_a18.quest.BESTDEP = {
[20]=true, [21]=true, [37]=true, [38]=true, [39]=true,
[43]=true, [44]=true, [76]=true,
}
function _a18.quest.bestDepActive()
local _a702 = _a18.ctl.lockGoal and _a18.ctl.lockGoal.q
if not _a702 then return false end
if _a18.quest.IGNORE[_a702.type] then return false end
if not _a18.quest.BESTDEP[_a702.type] then return false end
local _a703 = _a18.quest.findQuest(_a702.uid)
if not _a703 or _a703.progress >= _a703.amount then return false end
return true, _a703
end
function _a18.quest.canDo(_a704, _a705)
if _a704.how == "hatch" or _a704.where == "bestegg" then
local _a706 = _a111()
if not _a706 then return false, "알 정보를 못 읽음" end
if not _a706.price then return true end
if not _a705 then
if _a706.canBuy < 1 then
return false, ("돈 부족 — %s 개당 %s %s / 보유 %s"):format(
tostring(_a706.id), _a6(_a706.price, 0), tostring(_a706.currency), _a6(_a706.have, 0))
end
return true
end
local _a707 = math.max(1, (_a704.amount or 1) - (_a704.progress or 0))
local _a708 = _a707
if _a704.type == 2 or _a704.type == 42 or _a704.type == 47 then
_a708 = math.max(_a707, _a11.HatchMinAfford or 10)
end
if _a706.canBuy < _a708 then
_a18.quest.moneyUntil = os.clock() + math.max(0, _a11.MoneyDwell or 60)
return false, ("돈 모으는 중 — %d개분 필요 / 지금 %d개분 (개당 %s %s)"):format(
_a708, _a706.canBuy, _a6(_a706.price, 0), tostring(_a706.currency))
end
if _a18.quest.moneyUntil and os.clock() < _a18.quest.moneyUntil then
return false, ("조금 더 벌고 감 (%.0f초 남음)"):format(_a18.quest.moneyUntil - os.clock())
end
_a18.quest.moneyUntil = nil
end
return true
end
function _a18.quest.findQuest(_a709)
local _a710 = _a18.quest.status()
for _a711, _a712 in ipairs(_a710 and _a710.list or {}) do
if _a712.uid == _a709 then return _a712 end
end
return nil
end
function _a18.quest.pursue(_a713)
local _a714, _a715
if _a713.how == "hatch" then _a714, _a715 = _a122, "mhatch"
elseif _a713.how == "zone" then _a714, _a715 = _a81, "zone"
elseif _a713.how == "gold" or _a713.how == "rainbow" then
local _a716 = (_a713.type == 40 or _a713.type == 41)
_a715 = "quest"
_a714 = function()
local _a717 = _a18.item.makeVariant("gold", _a716) or 0
if _a713.how == "rainbow" then
_a717 += (_a18.item.makeVariant("rainbow", _a716) or 0)
end
if _a717 > 0 then
_a18.ctl.setAct(_a713.how == "gold" and "골드 합성" or "레인보우 합성", _a717 .. "마리")
return
end
_a18.ctl.setAct("재료 모으는 중", "최고 알 부화")
local _a718 = _a12.mhatch
_a12.mhatch = true
pcall(_a122)
_a12.mhatch = _a718
end
end
local _a719 = _a713.progress
local _a720 = os.clock()
_a18.ctl.setGoal(_a713.title, ("%d/%d"):format(_a713.progress, _a713.amount))
local function _a721()
if not _a713.event then return end
local _a722 = _a18.ev.findEvent(_a713.event, _a713.bestOnly)
if _a722 then
_a18.ctl.setAct(_a713.event .. " 진행 중", ("%d초 남음"):format(_a722.left))
if _a722.pos then
local _a723 = _a18.move.hrp()
if _a723 and (_a723.Position - _a722.pos).Magnitude > (_a11.EventStayDist or 45) then
_a18.move.glideTo(_a722.pos)
end
end
return
end
local _a724, _a725 = _a18.ev.spawnEvent(_a713.event)
if _a724 > 0 then
_a18.ctl.setAct("소환", _a713.event)
task.wait(0.5)
elseif _a725 and _a18.ev.spawnErr ~= tostring(_a725) then
_a18.ev.spawnErr = tostring(_a725)
_a5("[퀘스트] " .. _a713.event .. " 소환 실패: " .. tostring(_a725))
end
end
local _a726, _a727 = pcall(function()
while _a12.quest and not _a18.ctl.stopped() do
local _a728, _a729 = _a18.quest.canDo(_a713, false)
if not _a728 then
_a5(("[퀘스트] %s → 다른 퀘스트 먼저 (%s)"):format(tostring(_a713.title), tostring(_a729)))
return
end
_a721()
if _a714 then
local _a730 = _a12[_a715]
_a12[_a715] = true
local _a731, _a732 = pcall(_a714)
_a12[_a715] = _a730
if not _a731 then error(_a732, 0) end
elseif _a713.event then
task.wait(0.4)
else
task.wait(2)
end
local _a733 = _a18.quest.findQuest(_a713.uid)
if not _a733 then
_a5("[퀘스트] 완료 — " .. tostring(_a713.title))
return
end
_a18.ctl.setGoal(_a733.title, ("%d/%d"):format(_a733.progress, _a733.amount))
if _a733.progress >= _a733.amount then
_a5(("[퀘스트] 달성 %d/%d — %s"):format(_a733.progress, _a733.amount, tostring(_a733.title)))
return
end
if _a733.progress > _a719 then
_a720 = os.clock()
_a5(("[퀘스트] %d/%d  %s"):format(_a733.progress, _a733.amount, tostring(_a733.title)))
end
_a719 = _a733.progress
local _a734 = os.clock() - _a720
if _a734 >= math.max(10, _a11.PursueStallSec or 60) then
_a5(("[퀘스트] %.0f초째 진행 없음 (%d/%d) — 다음 단계로: %s"):format(
_a734, _a733.progress, _a733.amount, tostring(_a733.title)))
return
end
task.wait(0.2)
end
end)
if not _a726 then _a5("[퀘스트] " .. tostring(_a713.how) .. " 오류: " .. tostring(_a727)) end
_a18.ctl.lockGoal = nil
_a18.ctl.setGoal(nil)
end
function _a18.quest.cycle()
do
local _a735 = _a12.rank
_a12.rank = true
pcall(_a173)
_a12.rank = _a735
end
local _a736 = _a18.quest.status()
if not _a736 then return end
local _a737, _a738, _a739 = false, false, false
local _a740 = {}
local _a741 = nil
for _a742, _a743 in ipairs(_a736.list) do
if not _a12.quest then break end
local _a744, _a745 = true, nil
if not _a743.ignored and _a743.progress < _a743.amount then
_a744, _a745 = _a18.quest.canDo(_a743, true)
end
if _a743.ignored then
if _a743.progress < _a743.amount then
_a740[#_a740 + 1] = tostring(_a743.title) .. "  — " .. _a743.ignored
end
elseif not _a744 then
local _a746 = tostring(_a743.uid) .. tostring(_a745)
if _a18.item.skipSaid ~= _a746 then
_a18.item.skipSaid = _a746
_a5(("[퀘스트] 건너뜀: %s   (%s)"):format(tostring(_a743.title), tostring(_a745)))
end
elseif _a743.progress < _a743.amount then
local _a747 = _a743.where
if _a743.event then
if not _a741 or _a741.rank > 0 then _a741 = { rank = 0, kind = "event", q = _a743 } end
elseif _a743.chest then
if not _a741 or _a741.rank > 1 then _a741 = { rank = 1, kind = "chest", q = _a743 } end
elseif _a747 == "bestegg" then
if not _a741 or _a741.rank > 1 then _a741 = { rank = 1, kind = "egg", q = _a743 } end
elseif _a747 == "breakable" and _a743.breakable then
if not _a741 or _a741.rank > 2 then _a741 = { rank = 2, kind = "breakable", q = _a743 } end
elseif _a747 == "zoneid" and _a743.zoneId then
if not _a741 or _a741.rank > 2 then _a741 = { rank = 2, kind = "zoneid", q = _a743 } end
elseif _a747 == "bestzone" or _a747 == "breakable" then
if not _a741 then _a741 = { rank = 3, kind = "bestzone", q = _a743 } end
end
if _a743.how == "farm" then
_a737 = true
elseif _a743.how == "hatch" then
_a738 = true
elseif _a743.how == "zone" then
_a739 = true
elseif _a743.how == "potup" and _a11.QuestUpgrade then
local _a748, _a749 = _a18.item.upgradeTo("Potion", _a743.potionTier or 2)
if _a748 > 0 then
_a13.potup += _a748
_a13.quest += 1
_a5(("[퀘스트] 포션 T%d %d개 제작  (%s)"):format(_a743.potionTier or 2, _a748, _a743.title))
elseif _a749 and not tostring(_a749):find("부족") then
if _a18.item.potUpSaid ~= tostring(_a749) then
_a18.item.potUpSaid = tostring(_a749)
_a5("[퀘스트] 포션 업글 실패: " .. tostring(_a749))
end
end
elseif _a743.how == "encup" and _a11.QuestUpgrade then
local _a750, _a751 = _a18.item.upgradeTo("Enchant", _a743.enchantTier or 2)
if _a750 > 0 then
_a13.potup += _a750
_a13.quest += 1
_a5(("[퀘스트] 인챈트 T%d %d개 제작  (%s)"):format(_a743.enchantTier or 2, _a750, _a743.title))
elseif _a751 and not tostring(_a751):find("부족") then
if _a18.item.encUpSaid ~= tostring(_a751) then
_a18.item.encUpSaid = tostring(_a751)
_a5("[퀘스트] 인챈트 업글 실패: " .. tostring(_a751))
end
end
elseif _a743.how == "potuse" and _a11.QuestUsePotion then
_a18.item.lastUse = _a18.item.lastUse or {}
local _a752 = _a18.item.lastUse[_a743.uid]
if _a752 and _a752.used > 0 and _a743.progress <= _a752.progress then
if not _a752.gaveUp then
_a752.gaveUp = true
_a5("[퀘스트] 포션을 마셔도 진행도가 안 올라서 중단: " .. tostring(_a743.title))
end
else
local _a753 = math.min(_a11.QuestUseMax, math.max(1, _a743.amount - _a743.progress))
local _a754, _a755 = _a18.item.usePotion(_a743.potionTier or 1, _a753)
_a18.item.lastUse[_a743.uid] = { used = _a754, progress = _a743.progress }
if _a754 > 0 then
_a13.potuse += _a754
_a13.quest += 1
_a5(("[퀘스트] 포션 %d개 사용  (%s)"):format(_a754, _a743.title))
elseif _a755 and not tostring(_a755):find("없음") then
_a5("[퀘스트] 포션 사용 실패: " .. tostring(_a755))
end
end
elseif _a743.how == "gold" or _a743.how == "rainbow" then
local _a756, _a757 = _a18.item.makeVariant(_a743.how, _a743.type == 40 or _a743.type == 41)
if _a756 > 0 then
_a13.quest += 1
_a5(("[퀘스트] %s 펫 %d마리 제작  (%s)"):format(
_a743.how == "gold" and "골드" or "레인보우", _a756, _a743.title))
elseif _a757 then
_a5("[퀘스트] " .. _a743.how .. " 실패: " .. tostring(_a757))
end
elseif _a743.how == "fruituse" then
local _a758 = _a18.item.useFruit(math.max(1, _a743.amount - _a743.progress))
if _a758 > 0 then
_a13.quest += 1
_a5(("[퀘스트] 과일 %d개 사용  (%s)"):format(_a758, _a743.title))
end
elseif _a743.how == "flaguse" then
local _a759, _a760 = _a18.item.useFlag(math.max(1, _a743.amount - _a743.progress))
if _a759 > 0 then
_a13.quest += 1
_a5(("[퀘스트] 깃발 %d개 사용  (%s)"):format(_a759, _a743.title))
elseif _a760 then
_a5("[퀘스트] 깃발 실패: " .. tostring(_a760))
end
elseif not _a743.how then
_a740[#_a740 + 1] = _a743.title
end
end
end
if _a11.QuestLock and _a18.ctl.lockGoal then
local _a761
for _a762, _a763 in ipairs(_a736.list) do
if _a763.uid == _a18.ctl.lockGoal.q.uid and _a763.progress < _a763.amount then _a761 = _a763 break end
end
if _a761 then
_a18.ctl.lockGoal.q = _a761
_a741 = _a18.ctl.lockGoal
else
if _a18.ctl.lockGoal.q then
_a5("[퀘스트] 완료/교체됨 → 다음 목표로: " .. tostring(_a18.ctl.lockGoal.q.title))
end
_a18.ctl.lockGoal = nil
end
end
if _a11.QuestLock and _a741 then _a18.ctl.lockGoal = _a741 end
if _a11.QuestTp and _a741 and _a12.quest then
local _a764, _a765, _a766
if _a741.kind == "event" then
local _a767 = _a18.ev.findEvent(_a741.q.event, _a741.q.bestOnly)
if _a767 then
_a766 = ("%s @%s (%d초 남음)"):format(_a767.name, tostring(_a767.zone), _a767.left)
if _a767.pos then _a764, _a765 = _a18.move.glideTo(_a767.pos)
else _a764, _a765 = _a18.move.goToZone(_a767.zone) end
else
local _a768 = _a741.q.bestOnly and _a18.move.bestZone() or (_a18.move.curZone() or _a18.move.bestZone())
_a766 = _a741.q.event .. " 소환용 " .. tostring(_a768)
local _a769 = _a18.move.inDottedBox()
_a764, _a765 = _a18.move.goToZone(_a768, false, _a769 == false, _a741.q.bestOnly)
if _a764 then
local _a770, _a771 = _a18.ev.spawnEvent(_a741.q.event)
if _a770 < 1 and tostring(_a771):find("점선") then
_a18.move.goToZone(_a768, false, true)
task.wait(0.2)
_a770, _a771 = _a18.ev.spawnEvent(_a741.q.event)
end
if _a770 > 0 then
_a766 = ("%s %d개 소환 @%s"):format(_a741.q.event, _a770, tostring(_a768))
else
_a765 = _a771
_a764 = false
end
end
end
elseif _a741.kind == "chest" then
local _a772 = _a741.q.bestOnly and _a18.move.bestZone() or _a18.move.curZone()
local _a773, _a774 = _a18.ev.findChest(_a741.q.chest, _a772)
_a766 = _a741.q.chest .. " @" .. tostring(_a772)
if _a773 then
if not _a774 or _a774 > 20 then _a18.move.glideTo(_a773) end
_a764 = true
else
_a764, _a765 = _a18.move.goToZone(_a772)
_a766 = _a766 .. " (상자 없음 → 존 가운데)"
end
elseif _a741.kind == "egg" then
local _a775 = _a86()
_a766 = "최고 알 " .. tostring(_a775)
if _a775 then _a764, _a765 = _a18.egg.tpEgg(_a775) else _a765 = "최고 알을 못 찾음" end
elseif _a741.kind == "breakable" then
local _a776 = _a18.move.zoneForBreakable(_a741.q.breakable)
_a766 = tostring(_a741.q.breakable) .. " 나오는 존 " .. tostring(_a776)
if _a776 then _a764, _a765 = _a18.move.goToZone(_a776, true) else _a765 = "그 브레이커블이 나오는 존이 없음" end
elseif _a741.kind == "zoneid" then
_a766 = "존 " .. tostring(_a741.q.zoneId)
_a764, _a765 = _a18.move.goToZone(_a741.q.zoneId)
else
local _a777 = _a18.move.bestZone()
local _a778 = _a741.q.bestOnly or _a18.quest.BESTDEP[_a741.q.type] or false
if _a777 then _a764, _a765 = _a18.move.goToZone(_a777, true, false, _a778)
else _a765 = "최고 존을 못 찾음" end
_a766 = "최고 존 " .. tostring(_a18.move.arrivedZone or _a777)
if not _a764 then _a765 = _a777 end
end
if _a764 then
if _a18.quest.lastGoal ~= _a766 then
_a18.quest.lastGoal = _a766
_a5("[퀘스트] " .. _a766 .. " 으로 이동  (" .. tostring(_a741.q.title) .. ")")
end
_a18.quest.pursue(_a741.q)
else
local _a779 = _a765 and tostring(_a765) or "이유 불명"
if _a18.quest.lastFail ~= _a779 then
_a18.quest.lastFail = _a779
_a5(("[퀘스트] 진행 못 함: %s   (%s / %s)"):format(
_a779, tostring(_a741.kind), tostring(_a741.q.title)))
_a5(("           현재 존 %s / 최고 존 %s / 점선네모 %s"):format(
tostring(_a18.move.curZone()), tostring(_a18.move.bestZone()), tostring(_a18.move.inDottedBox())))
end
end
end
if _a11.QuestDrive and _a18.auto.turnOn then
if _a737  then _a18.auto.turnOn("farm",   "파밍 퀘스트 → 자동 파밍") end
if _a739  then _a18.auto.turnOn("zone",   "존 퀘스트 → 자동 존 해금") end
if _a738 then _a18.auto.turnOn("mhatch", "부화 퀘스트 → 자동 부화") end
end
if #_a740 > 0 and not _a18.quest.manualWarned then
_a18.quest.manualWarned = true
_a5("[퀘스트] 수동으로 해야 하는 것:")
for _a780, _a781 in ipairs(_a740) do _a5("    · " .. tostring(_a781)) end
elseif #_a740 == 0 then
_a18.quest.manualWarned = false
end
return _a741 ~= nil
end
local function _a782(_a783)
local _a784 = {}
for _a785 in tostring(_a783 or ""):gmatch("[^,]+") do
_a785 = _a785:match("^%s*(.-)%s*$")
if _a785 ~= "" then _a784[#_a784 + 1] = _a785:lower() end
end
return _a784
end
function _a18.item.itemAllowed(_a786)
local _a787 = tostring(_a786):lower()
for _a788, _a789 in ipairs(_a782(_a11.ItemBlock)) do
if _a787:find(_a789, 1, true) then return false end
end
local _a790 = _a782(_a11.ItemAllow)
if #_a790 == 0 then return true end
for _a791, _a792 in ipairs(_a790) do
if _a787:find(_a792, 1, true) then return true end
end
return false
end
function _a18.item.activeBuffs(_a793)
local _a794 = _a45()
local _a795 = _a794 and rawget(_a794, _a793)
local _a796 = {}
if type(_a795) == "table" then
for _a797, _a798 in pairs(_a795) do
if type(_a798) == "table" and next(_a798) then _a796[_a797] = true
elseif _a798 then _a796[_a797] = true end
end
end
return _a796
end
local function _a799(_a800, _a801, _a802, _a803)
local _a804 = _a18.item.activeBuffs(_a801)
local _a805 = {}
local _a806 = { total = 0, act = 0, blocked = 0, few = 0, ok = 0 }
for _a807, _a808 in ipairs(_a18.item.stacks(_a800)) do
_a806.total += 1
if _a804[_a808.id] then _a806.act += 1
elseif not _a18.item.itemAllowed(_a808.id) then _a806.blocked += 1
elseif _a808.am <= _a11.ItemKeep then _a806.few += 1
else
_a806.ok += 1
local _a809 = _a805[_a808.id]
local _a810
if not _a809 then _a810 = true
elseif _a11.BuffHighTier then _a810 = _a808.tier > _a809.tier
else _a810 = _a808.tier < _a809.tier end
if _a810 then _a805[_a808.id] = _a808 end
end
end
if _a806.ok == 0 and _a806.total > 0 then
local _a811 = ("%s %d종 중 사용 가능 0 (이미걸림 %d / 제외 %d / 재고부족 %d)")
:format(_a800, _a806.total, _a806.act, _a806.blocked, _a806.few)
if _a18.item.buffSaid ~= _a811 then
_a18.item.buffSaid = _a811
_a5("[아이템] " .. _a811)
end
elseif _a806.ok > 0 then
_a18.item.buffSaid = nil
end
local _a812 = {}
for _a813, _a814 in pairs(_a805) do _a812[#_a812 + 1] = _a814 end
table.sort(_a812, function(_a815, _a816)
if _a815.tier ~= _a816.tier then return _a815.tier > _a816.tier end
return _a815.am > _a816.am
end)
local _a817 = {}
for _a818, _a819 in ipairs(_a812) do
if not _a12.items then break end
if _a803 and _a803.left <= 0 then break end
local _a820 = pcall(function() _a802(_a819.uid, 1) end)
if _a820 then
_a817[#_a817 + 1] = ("%s T%d"):format(_a819.id, _a819.tier)
_a13.items += 1
if _a803 then _a803.left -= 1 end
task.wait(0.12)
end
end
return _a817
end
function _a18.item.cycleItems()
local function _a821()
local _a822 = {}
if _a11.BuffPotion then _a822[#_a822 + 1] = { "Potion", "Potions" } end
if _a11.BuffFruit then _a822[#_a822 + 1] = { "Fruit", "Fruits" } end
if _a11.BuffConsumable then _a822[#_a822 + 1] = { "Consumable", "Consumables" } end
for _a823, _a824 in ipairs(_a822) do
local _a825 = _a18.item.activeBuffs(_a824[2])
for _a826, _a827 in ipairs(_a18.item.stacks(_a824[1])) do
if _a827.am > _a11.ItemKeep and _a18.item.itemAllowed(_a827.id) and not _a825[_a827.id] then
return true
end
end
end
if _a11.BuffUltimate and _a16.R_Ult then
local _a828 = _a45()
local _a829 = _a828 and rawget(_a828, "Ultimates")
if type(_a829) == "table" then
for _a830 in pairs(_a829) do
if _a18.item.itemAllowed(_a830) then
if not (_a16.Ult and rawget(_a16.Ult, "IsCharged")) then return true end
local _a831, _a832 = pcall(_a16.Ult.IsCharged, _a830)
if _a831 and _a832 then return true end
end
end
end
end
return false
end
if not _a821() then return end
if _a11.ItemBestZone then
local _a833 = _a18.move.bestZone()
if _a833 and _a18.move.curZone() ~= _a833 then
if not _a11.ItemTp then
if not _a18.item.itemZoneWarned then
_a18.item.itemZoneWarned = true
_a5(("[아이템] 최고 존(%s)이 아니라 대기 — 현재 %s"):format(
tostring(_a833), tostring(_a18.move.curZone())))
end
return
end
local _a834, _a835 = _a18.move.goToZone(_a833)
if not _a834 then
_a5("[아이템] 최고 존 이동 실패: " .. tostring(_a835))
return
end
_a5("[아이템] 최고 존 " .. tostring(_a833) .. " 에서 사용")
end
_a18.item.itemZoneWarned = false
end
local _a836 = {}
local _a837  = { left = math.max(1, _a11.BuffMaxPotion or 5) }
local _a838 = { left = math.max(1, _a11.BuffMaxOther or 2) }
if _a11.BuffPotion and _a16.R_PotUse then
local _a839 = _a799("Potion", "Potions", function(_a840, _a841)
_a16.R_PotUse:FireServer(_a840, _a841)
end, _a837)
for _a842, _a843 in ipairs(_a839) do _a836[#_a836 + 1] = "포션 " .. _a843 end
end
if _a11.BuffFruit and _a16.R_Fruit then
local _a844 = _a799("Fruit", "Fruits", function(_a845, _a846)
_a16.R_Fruit:FireServer(_a845, _a846)
end, _a838)
for _a847, _a848 in ipairs(_a844) do _a836[#_a836 + 1] = "과일 " .. _a848 end
end
if _a11.BuffConsumable and _a16.R_Cons then
local _a849 = _a799("Consumable", "Consumables", function(_a850, _a851)
_a16.R_Cons:InvokeServer(_a850, _a851)
end, _a838)
for _a852, _a853 in ipairs(_a849) do _a836[#_a836 + 1] = "소모품 " .. _a853 end
end
if _a11.BuffUltimate and _a16.R_Ult then
local _a854 = _a45()
local _a855 = _a854 and rawget(_a854, "Ultimates")
if type(_a855) == "table" then
for _a856 in pairs(_a855) do
if not _a12.items then break end
if _a18.item.itemAllowed(_a856) then
local _a857 = true
if _a16.Ult and rawget(_a16.Ult, "IsCharged") then
local _a858, _a859 = pcall(_a16.Ult.IsCharged, _a856)
_a857 = _a858 and _a859 and true or false
end
if _a857 then
local _a860
pcall(function() _a860 = _a16.R_Ult:InvokeServer(_a856) end)
if _a860 then
_a836[#_a836 + 1] = "얼티밋 " .. tostring(_a856)
_a13.items += 1
task.wait(0.3)
end
end
end
end
end
end
if #_a836 > 0 then
_a18.ctl.setAct("버프 사용", table.concat(_a836, ", "))
_a5("[아이템] " .. table.concat(_a836, ", ") .. " 사용")
end
end
function _a18.mach.slotStatus()
local _a861 = _a45()
if not _a861 then return nil end
local _a862 = tonumber(rawget(_a861, "PetSlotsPurchased")) or 0
local _a863 = tonumber(rawget(_a861, "EggSlotsPurchased")) or 0
local _a864, _a865 = 0, 0
if _a16.RankC then
if rawget(_a16.RankC, "GetMaxPurchasableEquipSlots") then
local _a866, _a867 = pcall(_a16.RankC.GetMaxPurchasableEquipSlots)
if _a866 and tonumber(_a867) then _a864 = tonumber(_a867) end
end
if rawget(_a16.RankC, "GetMaxPurchasableEggSlots") then
local _a868, _a869 = pcall(_a16.RankC.GetMaxPurchasableEggSlots)
if _a868 and tonumber(_a869) then _a865 = tonumber(_a869) end
end
end
local _a870, _a871
if _a862 < _a864 then
_a870 = _a862 + 1
if type(_a16.CalcPetS) == "function" then
local _a872, _a873 = pcall(_a16.CalcPetS, _a870)
if _a872 then _a871 = tonumber(_a873) end
end
end
local _a874, _a875, _a876
if _a863 < _a865 and _a16.RankC and rawget(_a16.RankC, "GetEggBundle") then
local _a877, _a878, _a879 = pcall(_a16.RankC.GetEggBundle, _a863 + 1)
if _a877 and tonumber(_a878) then
_a874, _a875 = tonumber(_a878), tonumber(_a879) or 1
if type(_a16.CalcEggS) == "function" then
local _a880, _a881 = 0, false
for _a882 = _a874 - _a875 + 1, _a874 do
local _a883, _a884 = pcall(_a16.CalcEggS, _a882)
if _a883 and tonumber(_a884) then _a880 += tonumber(_a884) else _a881 = true end
end
if not _a881 then _a876 = _a880 end
end
end
end
local _a885
if _a16.Egg and rawget(_a16.Egg, "GetMaxHatch") then
local _a886, _a887 = pcall(_a16.Egg.GetMaxHatch)
if _a886 then _a885 = tonumber(_a887) end
end
return {
dia = _a53("Diamonds"),
petOwned = _a862, petMax = _a864, petNext = _a870, petCost = _a871,
eggOwned = _a863, eggMax = _a865, eggEnd = _a874, eggSize = _a875, eggCost = _a876,
maxEquip = tonumber(rawget(_a861, "MaxPetsEquipped")), maxHatch = _a885,
}
end
function _a18.move.machinePos(_a888)
local _a889
if _a16.Machine and rawget(_a16.Machine, "GetModels") then
local _a890, _a891 = pcall(_a16.Machine.GetModels, _a888)
if _a890 and type(_a891) == "table" then
for _a892, _a893 in pairs(_a891) do
if typeof(_a893) == "Instance" then _a889 = _a893 break end
end
end
end
if not _a889 then
local _a894, _a895 = pcall(function()
return game:GetService("CollectionService"):GetTagged("Machine")
end)
if _a894 then
for _a896, _a897 in ipairs(_a895) do
if _a897.Name == _a888 then _a889 = _a897 break end
end
end
end
if not _a889 then return nil end
if _a889:IsA("BasePart") then return _a889.Position end
local _a898, _a899 = pcall(function() return _a889:GetPivot() end)
return (_a898 and typeof(_a899) == "CFrame") and _a899.Position or nil
end
function _a18.mach.cycleSlots()
local _a900 = 0
local _a901 = 0
while _a12.slots and not _a18.ctl.stopped() and _a901 < 40 do
_a901 += 1
local _a902 = _a18.mach.slotStatus()
if not _a902 then return end
local _a903 = _a11.SlotPet and _a902.petNext and _a902.petCost
and (_a902.dia - _a11.SlotReserve) >= _a902.petCost
local _a904 = _a11.SlotEgg and _a902.eggEnd and _a902.eggCost
and (_a902.dia - _a11.SlotReserve) >= _a902.eggCost
if _a903 and _a904 then
if _a902.eggCost < _a902.petCost then _a903 = false else _a904 = false end
end
if not (_a903 or _a904) then break end
local _a905, _a906, _a907, _a908
local function _a909()
if _a903 then
pcall(function() _a905, _a906 = _a16.R_PetSlot:InvokeServer(_a902.petNext) end)
else
pcall(function() _a905, _a906 = _a16.R_EggSlot:InvokeServer(_a902.eggEnd) end)
end
end
if _a903 then
_a907 = ("펫 장착 슬롯 #%d (%s 다이아)"):format(_a902.petNext, _a6(_a902.petCost, 0))
_a908 = "EquipSlotsMachine"
else
_a907 = ("알 부화 슬롯 %d칸 → %d (%s 다이아)"):format(
_a902.eggSize, _a902.eggEnd, _a6(_a902.eggCost, 0))
_a908 = "EggSlotsMachine"
end
_a909()
if not _a905 and tostring(_a906):find("far away") then
local _a910 = _a18.move.machinePos(_a908)
if _a910 then
_a18.ctl.setAct("슬롯 머신으로 이동", _a908)
_a18.move.glideTo(_a910)
task.wait(0.25)
_a905, _a906 = nil, nil
_a909()
else
_a906 = "머신 위치를 못 찾음 (" .. _a908 .. ")"
end
end
if _a905 then
_a900 += 1
_a13.mslot += 1
_a18.mach.slotSaid = nil
_a18.ctl.setAct("슬롯 구매", _a907)
_a5("  ⬆ " .. _a907)
task.wait(0.35)
else
local _a911 = _a907 .. " 실패: " .. tostring(_a906)
if _a18.mach.slotSaid ~= _a911 then
_a18.mach.slotSaid = _a911
_a5("[슬롯] " .. _a911)
end
break
end
end
if _a900 > 0 then
local _a912 = _a18.mach.slotStatus()
_a5(("[슬롯] %d개 구매 — 장착 %s / 한번에 %s개 부화 (다이아 %s 남음)"):format(
_a900, tostring(_a912 and _a912.maxEquip), tostring(_a912 and _a912.maxHatch),
_a6(_a53("Diamonds"), 0)))
end
end
function _a18.mach.upgList()
local _a913 = {}
if not _a16.Upg then return _a913 end
local _a914, _a915 = pcall(_a16.Upg.All)
if not (_a914 and type(_a915) == "table") then return _a913 end
for _a916, _a917 in ipairs(_a915) do
local _a918, _a919, _a920 = rawget(_a917, "UpgradeID"), rawget(_a917, "ZoneID"), rawget(_a917, "UpgradeTier")
if _a918 and _a919 and _a920 then
local _a921 = false
if rawget(_a16.Upg, "Owns") then
local _a922, _a923 = pcall(_a16.Upg.Owns, _a918, _a919)
_a921 = _a922 and _a923 and true or false
end
local _a924 = _a18.move.ownsZone(_a919)
local _a925 = _a16.DirUpg and rawget(_a16.DirUpg, _a918)
local _a926 = _a925 and rawget(_a925, "TierCosts")
local _a927 = _a926 and tonumber(_a926[_a920])
local _a928 = "Diamonds"
local _a929 = _a925 and rawget(_a925, "TierCurrencies")
local _a930 = _a929 and _a929[_a920]
if type(_a930) == "table" and rawget(_a930, "_id") then _a928 = rawget(_a930, "_id") end
local _a931 = rawget(_a917, "Model")
local _a932
if typeof(_a931) == "Instance" then
if _a931:IsA("BasePart") then _a932 = _a931.Position
else
local _a933, _a934 = pcall(function() return _a931:GetPivot() end)
if _a933 and _a934 then _a932 = _a934.Position end
end
end
_a913[#_a913 + 1] = {
id = _a918, zone = _a919, tier = _a920, cost = _a927, cur = _a928,
bought = _a921, zoneOwned = _a924,
buyable = _a924 and not _a921,
pos = _a932, model = _a931,
}
end
end
table.sort(_a913, function(_a935, _a936) return (_a935.cost or math.huge) < (_a936.cost or math.huge) end)
return _a913
end
function _a18.mach.cycleUpg()
if not _a16.R_Upg then _a5("[맵업글] Upgrades_Purchase 리모트 없음") return end
local _a937 = _a18.mach.upgList()
if #_a937 == 0 then return end
local _a938 = 0
for _a939, _a940 in ipairs(_a937) do
if not _a12.mapupg then break end
if _a940.buyable and _a940.cost then
local _a941 = _a53(_a940.cur or "Diamonds")
if _a941 - _a11.UpgReserve < _a940.cost then break end
if _a11.UpgTp and _a940.pos and _a940.zone == _a18.move.curZone() then
_a18.move.glideTo(_a940.pos)
end
local _a942, _a943
pcall(function() _a942, _a943 = _a16.R_Upg:InvokeServer(_a940.id, _a940.zone) end)
if _a942 then
_a938 += 1
_a13.mapupg += 1
_a18.ctl.setAct("맵 업글", _a940.id .. " T" .. _a940.tier)
_a5(("  ▲ 맵업글  %s T%d  @%s   (%s 다이아)"):format(
_a940.id, _a940.tier, _a940.zone, _a6(_a940.cost, 0)))
elseif _a943 then
_a5(("[맵업글] %s T%d @%s 실패: %s"):format(
_a940.id, _a940.tier, _a940.zone, tostring(_a943)))
end
task.wait(_a11.ActionGap)
end
end
if _a938 > 0 then
_a5(("[맵업글] %d개 구매  (다이아 %s 남음)"):format(_a938, _a6(_a53("Diamonds"), 0)))
end
end
local function _a944()
local _a945 = _a45()
if not _a945 then return nil end
local _a946 = tonumber(rawget(_a945, "Rebirths")) or 0
local _a947 = _a946 + 1
local _a948
if _a16.Rebirth and rawget(_a16.Rebirth, "GetNextRebirth") then
local _a949, _a950 = pcall(_a16.Rebirth.GetNextRebirth, _a945)
if _a949 then _a948 = _a950 end
end
return { current = _a946, nextN = _a947, def = _a948 }
end
local function _a951()
if not _a16.R_Reb then _a5("[리버스] Rebirth_Request 리모트 없음") return end
local _a952 = _a944()
if not _a952 then
_a18.auto.rebNote = "세이브를 못 읽음"
return
end
local _a953, _a954
pcall(function() _a953, _a954 = _a16.R_Reb:InvokeServer(_a952.nextN) end)
if _a953 then
_a13.mreb += 1
_a18.auto.rebNote, _a18.auto.rebSaid = nil, nil
_a5(("  ★ 리버스 %d → %d"):format(_a952.current, _a952.nextN))
task.wait(0.5)
_a18.screen.dismissRewardScreens(25)
else
_a18.auto.rebNote = ("%d → %d : %s"):format(_a952.current, _a952.nextN,
_a954 and tostring(_a954) or "조건 미달 (리버스 킬/존 요구치)")
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
{ key = "mreb",   label = "리버스",  run = "mreb",  fn = function() _a951() end,
hold = true },
{ key = "zone",   label = "존 해금", run = "zone",  fn = function() _a81() end,
hold = true },
{ key = "quest",  label = "랭크 퀘스트+보상", run = "quest", fn = function()
local _a955 = _a12.farm
_a12.farm = true
pcall(_a63)
_a12.farm = _a955
local _a956 = _a18.quest.cycle()
if not _a956 then
local _a957 = _a18.move.bestZone()
if _a957 then
local _a958, _a959 = _a18.move.goToZone(_a957)
if not _a958 then
if _a959 and _a18.auto.idleMoveSaid ~= tostring(_a959) then
_a18.auto.idleMoveSaid = tostring(_a959)
_a5("[자동] 최고 존 이동 실패: " .. tostring(_a959))
end
else
_a18.auto.idleMoveSaid = nil
end
end
if not _a11.IdleHatch then
_a18.ctl.setAct("파밍 중", ("퀘스트 없음 @%s"):format(tostring(_a18.move.curZone())))
return
end
local _a960 = _a111()
local _a961 = math.max(1, _a11.HatchMinAfford or 10)
if _a960 and _a960.price and _a960.canBuy < _a961 then
_a18.ctl.setAct("돈 버는 중", ("%s  %d/%d개분  개당 %s %s"):format(
tostring(_a18.move.curZone()), _a960.canBuy, _a961,
_a6(_a960.price, 0), tostring(_a960.currency)))
else
_a18.ctl.setAct("대기 중 부화")
local _a962 = _a12.mhatch
_a12.mhatch = true
pcall(_a122)
_a12.mhatch = _a962
end
end
end },
}
_a11.StepOn = {}
for _a963, _a964 in ipairs(_a18.auto.SIDE) do _a11.StepOn[_a964.key] = true end
for _a965, _a966 in ipairs(_a18.auto.STEPS) do _a11.StepOn[_a966.key] = true end
local function _a967(_a968, _a969, _a970, _a971)
if not _a11.StepOn[_a968.key] then
_a971[#_a971 + 1] = ("%-14s 꺼져있음"):format(_a968.label)
return
end
if _a968.hold and _a969 then
_a971[#_a971 + 1] = ("%-14s 보류 (%s)"):format(
_a968.label, _a970 and tostring(_a970.title) or "?")
if _a18.auto.heldMsg ~= _a968.key then
_a18.auto.heldMsg = _a968.key
_a5(("[자동] %s 보류 — best 존이 바뀌면 깨지는 퀘스트 진행 중 (%s)"):format(
_a968.label, _a970 and tostring(_a970.title) or "?"))
end
return
end
if _a968.hold then _a18.auto.heldMsg = nil end
_a18.auto.step = _a968.label
_a18.ctl.now.step = _a968.label
_a18.ctl.setAct("시작", _a968.label)
local _a972 = os.clock()
local _a973 = _a12[_a968.run]
_a12[_a968.run] = true
local _a974, _a975 = pcall(_a968.fn)
_a12[_a968.run] = _a973
local _a976 = os.clock() - _a972
if not _a974 then
_a971[#_a971 + 1] = ("%-14s 오류: %s"):format(_a968.label, tostring(_a975))
_a5("[자동] " .. _a968.label .. " 오류: " .. tostring(_a975))
else
local _a977 = (_a968.key == "zone" and _a18.auto.zoneNote)
or (_a968.key == "mreb" and _a18.auto.rebNote) or nil
_a971[#_a971 + 1] = ("%-14s 실행 %.1f초%s"):format(
_a968.label, _a976, _a977 and ("  → " .. _a977) or "")
end
end
function _a18.auto.master()
local _a978 = {}
_a18.auto.lastTrace = _a978
_a18.auto.lastPassAt = os.clock()
if _a18.screen.rewardScreenUp() then
_a978[#_a978 + 1] = "보상 화면 넘기는 중"
_a18.screen.dismissRewardScreens(15)
end
for _a979, _a980 in ipairs(_a18.auto.SIDE) do
if not _a12.auto or _a18.ctl.stopped() then return end
_a967(_a980, false, nil, _a978)
end
local _a981, _a982 = false, nil
if _a11.HoldZoneForQuest then _a981, _a982 = _a18.quest.bestDepActive() end
for _a983, _a984 in ipairs(_a18.auto.STEPS) do
if not _a12.auto or _a18.ctl.stopped() then break end
_a967(_a984, _a981, _a982, _a978)
end
_a18.auto.step = nil
if not _a18.ctl.lockGoal then
_a18.ctl.now.step = "대기"
_a18.ctl.setAct("다음 바퀴 대기", ("%.0f초 주기"):format(_a11.AutoInterval or 5))
end
local _a985 = {}
for _a986, _a987 in ipairs(_a978) do _a985[#_a985 + 1] = (_a987:gsub("[%d%.]+초", "")) end
_a985 = table.concat(_a985, " | ")
if _a985 ~= _a18.auto.lastSig then
_a18.auto.lastSig = _a985
_a5("[자동] 바퀴 " .. (_a18.auto.passN or 0))
for _a988, _a989 in ipairs(_a978) do _a5("    " .. _a989) end
end
_a18.auto.passN = (_a18.auto.passN or 0) + 1
end
local function _a990()
if not _a10.R_PROMO then _a5("[타워업글] 리모트 없음") return end
local _a991 = _a14()
if not _a991 then return end
local _a992 = _a15(_a991)
table.sort(_a992, function(_a993, _a994) return (_a993.dps or 0) > (_a994.dps or 0) end)
local _a995, _a996 = 0, 0
for _a997, _a998 in ipairs(_a992) do
if not _a12.towerup then break end
if _a998.id then
local _a999
pcall(function() _a999 = _a10.R_PROMO:InvokeServer(_a998.id) end)
if _a999 ~= nil and _a999 ~= false then
_a995 += 1
_a5(("  ▲ 타워업글  %s  Lv%s → Lv%s"):format(tostring(_a998.kind), tostring(_a998.up), tostring((_a998.up or 0) + 1)))
_a996 = 0
task.wait(_a11.ActionGap)
else
_a996 += 1
if _a996 >= 5 then break end
end
end
end
_a5("[타워업글] " .. _a995 .. "건")
end
local _a1000 = {}
local _a1001 = {}
local function _a1002(_a1003, _a1004)
local _a1005 = tostring(_a1004)
local _a1006 = _a1001[_a1003]
if _a1006 and _a1006.msg == _a1005 then
_a1006.n += 1
if _a1006.n % 20 == 0 then
_a5(("[%s 오류] %s   (%d회 반복)"):format(_a1003, _a1005, _a1006.n))
end
return
end
_a1001[_a1003] = { msg = _a1005, n = 1 }
_a5("[" .. _a1003 .. " 오류] " .. _a1005)
end
local function _a1007(_a1008, _a1009, _a1010, _a1011)
_a1000[_a1008] = (_a1000[_a1008] or 0) + 1
local _a1012 = _a1000[_a1008]
task.spawn(function()
while _a12[_a1008] and _a1000[_a1008] == _a1012 do
local _a1013, _a1014 = pcall(_a1010)
if not _a1013 then _a1002(_a1011, _a1014) else _a1001[_a1011] = nil end
local _a1015, _a1016 = _a1009(), 0
while _a1016 < _a1015 and _a12[_a1008] and _a1000[_a1008] == _a1012 do task.wait(0.1) _a1016 += 0.1 end
end
if _a1000[_a1008] == _a1012 then _a5("[" .. _a1011 .. "] 중지") end
end)
end
do
local _a1017 = {
farm   = { function() return _a11.FarmInterval end,      function() _a63() end,      "파밍" },
zone   = { function() return _a11.ZoneInterval end,      function() _a81() end,      "존" },
mhatch = { function() return _a11.MainHatchInterval end, function() _a122() end, "부화" },
}
function _a18.auto.turnOn(_a1018, _a1019)
if _a12.auto then return end
if _a12[_a1018] then return end
local _a1020 = _a1017[_a1018]
if not _a1020 then return end
_a12[_a1018] = true
_a1007(_a1018, _a1020[1], _a1020[2], _a1020[3])
if _a18.auto.refresh then _a18.auto.refresh() end
_a5("[퀘스트] " .. tostring(_a1019) .. " ON")
end
end
_a1.MG, _a1.QS, _a1.saveGet, _a1.currencyAmount, _a1.cycleFarm, _a1.zoneStatus = _a16, _a18, _a45, _a53, _a63, _a77
_a1.cycleZone, _a1.bestMainEgg, _a1.mainHatchStatus, _a1.cycleMainHatch, _a1.mainRebirthStatus, _a1.cycleMainRebirth = _a81, _a86, _a111, _a122, _a944, _a951
_a1.cycleTowerUp, _a1.startLoop = _a990, _a1007
end
