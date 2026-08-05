return function(_a1)
local _a2, _a3, _a4, _a5, _a6, _a7 = _a1.UIS, _a1.RunService, _a1.LP, _a1.log, _a1.num, _a1.req
local _a8, _a9, _a10, _a11, _a12, _a13 = _a1.LB, _a1.NET, _a1.RM, _a1.CFG, _a1.RUN, _a1.STAT
local _a14, _a15, _a16 = _a1.ctx, _a1.placedTowers, _a1.eggCost
local _a17 = {
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
local _a18 = {
[1]="farm", [9]="farm", [21]="farm", [7]="farm", [99]="farm", [8]="farm",
[30]="farm", [31]="farm", [32]="farm", [37]="farm", [38]="farm", [39]="farm",
[43]="farm", [44]="farm", [66]="farm", [67]="farm", [75]="farm", [76]="farm",
[14]="farm", [15]="farm", [64]="farm", [65]="farm", [63]="farm",
[2]="hatch", [3]="hatch", [20]="hatch", [42]="hatch", [47]="hatch",
[6]="zone", [81]="zone",
[34]="potuse",
[35]="fruituse", [33]="flaguse",
}
local _a19 = {}
_a19.IGNORE = {
[4]  = "골드 펫 만들기 (합성 필요)",
[5]  = "레인보우 펫 만들기 (합성 필요)",
[40] = "best egg 골드 펫 (뽑기+합성 필요)",
[41] = "best egg 레인보우 펫 (뽑기+2단 합성 필요)",
[12] = "포션 업글 (업글 머신으로 이동 필요)",
[13] = "인챈트 업글 (업글 머신으로 이동 필요)",
}
_a19.abort = false
function _a19.stopped() return _a19.abort == true end
function _a19.stopAll()
_a19.abort = true
for _a20 in pairs(_a12) do
if _a20 ~= "petspd" and _a20 ~= "rewatch" then _a12[_a20] = false end
end
_a19.lockGoal = nil
_a19.moving = nil
_a19.now.step = "정지"
_a19.setAct("정지됨")
end
_a19.now = { step = "-", act = "-", detail = "", goal = "-", prog = "" }
function _a19.setAct(_a21, _a22)
_a19.now.act = _a21 or "-"
_a19.now.detail = _a22 and tostring(_a22) or ""
_a19.now.at = os.clock()
end
function _a19.setGoal(_a23, _a24)
_a19.now.goal = _a23 and tostring(_a23) or "-"
_a19.now.prog = _a24 and tostring(_a24) or ""
end
function _a19.eggStands()
local _a25 = os.clock()
if _a19._standsAt and (_a25 - _a19._standsAt) < 2 and _a19._stands then
local _a26 = _a4.Character
local _a27 = _a26 and _a26:FindFirstChild("HumanoidRootPart")
if _a27 then
for _a28, _a29 in ipairs(_a19._stands) do
_a29.dist = (_a29.pos - _a27.Position).Magnitude
end
table.sort(_a19._stands, function(_a30, _a31) return _a30.dist < _a31.dist end)
end
return _a19._stands
end
local _a32 = {}
local _a33 = workspace:FindFirstChild("__THINGS")
local _a34 = _a33 and _a33:FindFirstChild("Eggs")
if not _a34 then return _a32 end
local _a35 = _a4.Character
local _a36 = _a35 and _a35:FindFirstChild("HumanoidRootPart")
for _a37, _a38 in ipairs(_a34:GetDescendants()) do
if _a38:IsA("Model") and _a38.PrimaryPart then
local _a39 = tonumber(tostring(_a38.Name):match("%d+"))
if _a39 then
local _a40
if _a17.EggsU and rawget(_a17.EggsU, "GetByNumber") then
local _a41, _a42 = pcall(_a17.EggsU.GetByNumber, _a39)
if _a41 then _a40 = _a42 end
end
local _a43 = _a40 and (rawget(_a40, "_id") or rawget(_a40, "name"))
if _a43 then
_a32[#_a32 + 1] = {
id = _a43, def = _a40, num = _a39,
pos = _a38.PrimaryPart.Position,
dist = _a36 and (_a38.PrimaryPart.Position - _a36.Position).Magnitude or 9e9,
unlocked = _a38:GetAttribute("Unlocked") and true or false,
}
end
end
end
end
table.sort(_a32, function(_a44, _a45) return _a44.dist < _a45.dist end)
_a19._stands, _a19._standsAt = _a32, os.clock()
return _a32
end
local function _a46()
if not _a8.Save then return nil end
local _a47, _a48 = pcall(_a8.Save.Get)
return (_a47 and type(_a48) == "table") and _a48 or nil
end
local function _a49(_a50, _a51)
if _a17.Currency and rawget(_a17.Currency, "CanAfford") then
local _a52, _a53 = pcall(_a17.Currency.CanAfford, _a50, _a51)
if _a52 then return _a53 and true or false end
end
return false
end
local function _a54(_a55)
if _a17.Currency and rawget(_a17.Currency, "Get") then
local _a56, _a57 = pcall(_a17.Currency.Get, _a55)
if _a56 and tonumber(_a57) then return tonumber(_a57) end
end
return 0
end
local function _a58()
if _a17.AutoFarm and rawget(_a17.AutoFarm, "IsEnabled") then
local _a59, _a60 = pcall(_a17.AutoFarm.IsEnabled)
if _a59 then return _a60 and true or false end
end
return false
end
local function _a61()
if _a17.AutoFarm and rawget(_a17.AutoFarm, "GetTargetParentId") then
local _a62, _a63 = pcall(_a17.AutoFarm.GetTargetParentId)
if _a62 then return _a63 end
end
return nil
end
local function _a64()
if not _a17.R_Farm then _a5("[파밍] AutoFarm_Enable 리모트 없음") return end
local _a65 = _a58()
_a19.farmZone, _a19.hereZone = _a61(), _a19.curZone()
if _a65 then
local _a66, _a67 = _a61(), _a19.curZone()
if _a66 and _a67 and _a66 ~= _a67 then
_a5(("[파밍] 대상이 %s 인데 지금은 %s — 다시 켬"):format(
tostring(_a66), tostring(_a67)))
if _a17.R_FarmOff then pcall(function() _a17.R_FarmOff:InvokeServer() end) end
if _a17.AutoFarm and rawget(_a17.AutoFarm, "ForceDisable") then
pcall(_a17.AutoFarm.ForceDisable)
end
task.wait(0.3)
_a65 = false
end
end
if _a65 then return end
local _a68, _a69
pcall(function() _a68, _a69 = _a17.R_Farm:InvokeServer() end)
if _a68 then
_a13.farm += 1
_a19.farmSaid = nil
_a5("[파밍] 자동 파밍 ON  (대상 " .. tostring(_a61() or _a19.curZone()) .. ")")
elseif _a69 and _a19.farmSaid ~= tostring(_a69) then
_a19.farmSaid = tostring(_a69)
_a5("[파밍] 실패: " .. tostring(_a69))
end
end
local function _a70()
if not (_a17.Zone and rawget(_a17.Zone, "GetNextZone")) then return nil end
local _a71, _a72, _a73 = pcall(_a17.Zone.GetNextZone)
if not _a71 then return nil end
return _a73 or _a72
end
local function _a74(_a75)
if not (_a17.Bal and rawget(_a17.Bal, "CalcGatePrice")) then return nil end
local _a76, _a77 = pcall(_a17.Bal.CalcGatePrice, _a75)
return (_a76 and tonumber(_a77)) or nil
end
local function _a78()
local _a79 = _a70()
if not _a79 then return nil end
local _a80 = _a74(_a79)
local _a81 = rawget(_a79, "Currency")
return {
zone = _a79, id = rawget(_a79, "_id"), price = _a80, currency = _a81,
have = _a81 and _a54(_a81) or 0,
ok = (_a80 and _a81) and _a49(_a81, _a80) or false,
}
end
local function _a82()
if not _a17.R_Zone then _a5("[존] Zones_RequestPurchase 리모트 없음") return end
local _a83 = 0
while _a12.zone and not _a19.stopped() and _a83 < 20 do
_a83 += 1
local _a84 = _a78()
if not _a84 then
_a19.zoneNote = "다음 존을 못 구함 (GetNextZone 실패 / 존 퀘스트 미완료?)"
if _a19.zoneSaid ~= _a19.zoneNote then
_a19.zoneSaid = _a19.zoneNote
_a5("[존] " .. _a19.zoneNote)
end
return
end
if not _a84.ok then
_a19.zoneNote = ("%s  %s %s / 보유 %s — 부족"):format(
tostring(_a84.id), _a6(_a84.price or 0, 0), tostring(_a84.currency), _a6(_a84.have, 0))
if _a19.zoneSaid ~= _a19.zoneNote then
_a19.zoneSaid = _a19.zoneNote
_a5("[존] " .. _a19.zoneNote)
end
return
end
_a19.zoneSaid = nil
local _a85, _a86
pcall(function() _a85, _a86 = _a17.R_Zone:InvokeServer(_a84.id) end)
task.wait(0.5)
if _a85 then
_a13.zone += 1
_a5(("  ▶ 존 해금  %s   (%s %s)"):format(
tostring(_a84.id), _a6(_a84.price or 0, 0), tostring(_a84.currency)))
else
if _a86 then _a5("[존] 실패: " .. tostring(_a86)) end
return
end
task.wait(_a11.ActionGap)
end
end
local function _a87()
local _a88 = _a19.eggStands()
local _a89 = (_a11.MainEggId and _a11.MainEggId ~= "") and _a11.MainEggId or nil
if _a89 then
for _a90, _a91 in ipairs(_a88) do
if _a91.id == _a89 then return _a91.id, _a91.def, _a91.dist end
end
local _a92 = _a17.DirEggs and rawget(_a17.DirEggs, _a89)
if _a92 then return _a89, _a92, nil, (_a88[1] and _a88[1].dist) end
return nil
end
if not _a17.DirEggs then return nil end
local _a93, _a94, _a95 = nil, nil, -1
for _a96, _a97 in pairs(_a17.DirEggs) do
if type(_a97) == "table" and not rawget(_a97, "isCustomEgg") then
local _a98 = tonumber(rawget(_a97, "eggNumber"))
if _a98 and _a98 > _a95 and _a19.eggUnlocked(_a98) then
_a93, _a94, _a95 = _a96, _a97, _a98
end
end
end
if not _a93 then return nil end
local _a99, _a100
for _a101, _a102 in ipairs(_a88) do
if not _a100 then _a100 = _a102.dist end
if _a102.id == _a93 then _a99 = _a102.dist break end
end
if _a99 and _a99 <= _a11.EggRange then
return _a93, _a94, _a99
end
return _a93, _a94, nil, _a99 or _a100
end
local function _a103(_a104)
if type(_a17.CalcEgg) == "function" then
local _a105, _a106 = pcall(_a17.CalcEgg, _a104)
if _a105 and tonumber(_a106) then return tonumber(_a106) end
if not _a105 and not _a19.priceWarned then
_a19.priceWarned = true
_a5("[부화] CalcEggPricePlayer 막힘 → 기본가로 계산: " .. tostring(_a106))
end
end
if type(_a17.CalcEggB) == "function" then
local _a107, _a108 = pcall(_a17.CalcEggB, _a104)
if _a107 and tonumber(_a108) then return tonumber(_a108) end
end
for _a109, _a110 in ipairs({ "price", "Price", "cost", "Cost" }) do
local _a111 = tonumber(rawget(_a104, _a110))
if _a111 then return _a111 end
end
return nil
end
local function _a112()
local _a113, _a114, _a115, _a116 = _a87()
if not _a113 then return nil end
local _a117 = _a103(_a114)
local _a118 = rawget(_a114, "currency") or "Coins"
local _a119 = 1
if _a17.Egg and rawget(_a17.Egg, "GetMaxHatch") then
local _a120, _a121 = pcall(_a17.Egg.GetMaxHatch, _a114)
if _a120 and tonumber(_a121) then _a119 = math.max(1, math.floor(tonumber(_a121))) end
end
local _a122 = _a54(_a118)
return {
id = _a113, def = _a114, price = _a117, currency = _a118, maxN = _a119, have = _a122,
dist = _a115, nearest = _a116, inRange = _a115 ~= nil,
canBuy = (_a117 and _a117 > 0) and math.floor(math.max(0, _a122 - _a11.MainHatchReserve) / _a117) or 0,
}
end
local function _a123()
if not _a10.R_EGG then _a5("[부화] Eggs_RequestPurchase 리모트 없음") return end
if _a11.AutoUnlockEgg then
local _a124, _a125, _a126 = _a19.lockedEggs()
if _a125 > _a126 then
local _a127 = _a19.unlockEggs()
if _a127 > 0 then _a5(("[부화] 알 %d개 해금 (해금가능 #%d)"):format(_a127, _a125)) end
end
end
local _a128 = _a112()
if not _a128 then _a5("[부화] 알을 못 찾음") return end
if not _a128.inRange then
if _a11.HatchAutoTp then
local _a129, _a130 = _a19.tpEgg(_a128.id)
if not _a129 then
if not _a19.hatchWarned then
_a19.hatchWarned = true
_a5("[부화] 알로 이동 실패: " .. tostring(_a130))
end
return
end
_a5("[부화] " .. _a128.id .. " 로 이동")
_a128 = _a112()
if not (_a128 and _a128.inRange) then return end
else
if not _a19.hatchWarned then
_a19.hatchWarned = true
_a5(("[부화] 알 근처로 가주세요 (가장 가까운 알까지 %s스터드, 인식 %d)"):format(
_a128.nearest and ("%.0f"):format(_a128.nearest) or "?", _a11.EggRange))
end
return
end
end
_a19.hatchWarned = false
local _a131 = math.min(_a128.maxN, _a11.MainHatchMax)
local _a132 = _a128.price and math.min(_a128.canBuy, _a131) or _a131
if _a132 < 1 then return end
local _a133, _a134 = 0, 0
local function _a135()
return tonumber(_a17.Vars and rawget(_a17.Vars, "OpeningEgg")) or 0
end
local _a136 = _a17.Vars and rawget(_a17.Vars, "OpeningEgg") ~= nil
local _a137 = 2.5
if _a17.Egg and rawget(_a17.Egg, "ComputeDebounce") then
local _a138, _a139 = pcall(_a17.Egg.ComputeDebounce)
if _a138 and tonumber(_a139) then _a137 = tonumber(_a139) end
end
_a19.autoHatchOn(_a128.id, _a132)
local _a140 = false
local _a141 = _a19.lockGoal and _a19.lockGoal.q
local _a142 = _a141 and (_a141.how == "hatch" or _a141.where == "bestegg") or false
local _a143 = _a142 and math.huge
or (os.clock() + math.max(3, _a11.HatchBudget or 25))
local _a144 = _a142 and 100000 or 400
while _a12.mhatch and not _a19.stopped() and _a132 >= 1 and _a134 < _a144 and os.clock() < _a143 do
if _a142 and (_a134 % 5 == 0) then
local _a145 = _a19.findQuest(_a141.uid)
if not _a145 or _a145.progress >= _a145.amount then break end
end
_a134 += 1
if _a136 then
local _a146 = os.clock()
local _a147 = _a11.HatchClickAfter
local _a148 = false
while _a135() > 0 and _a12.mhatch and not _a19.stopped()
and (os.clock() - _a146) < 20 do
if _a11.HatchClick and (os.clock() - _a146) > _a147 then
_a19.clickOnce()
_a147 += 0.3
if (os.clock() - _a146) > 3 and not _a148 then
_a148 = true
_a19._ahEgg = nil
_a19.autoHatchOn(_a128.id, _a132)
_a5("[부화] 화면이 안 넘어가서 오토해치 재설정")
end
end
task.wait(0.03)
end
if _a135() > 0 then
if _a19.hatchStuck ~= _a128.id then
_a19.hatchStuck = _a128.id
_a5("[부화] " .. tostring(_a128.id) .. " 까는 화면에서 멈춤 — 이번 회차 중단")
end
_a140 = true
break
end
_a19.hatchStuck = nil
else
local _a149 = os.clock() - (_a19.lastHatch or 0)
if _a149 < _a137 then task.wait(_a137 - _a149) end
end
_a19.lastHatch = os.clock()
_a19.setAct("알 까는 중", ("%s x%d  (총 %d)"):format(_a128.id, _a132, _a133))
local _a150, _a151
local _a152 = pcall(function() _a150, _a151 = _a10.R_EGG:InvokeServer(_a128.id, _a132) end)
if _a150 then
_a133 += _a132
_a13.mhatch += _a132
_a19.hatchErr = nil
if _a128.price then
local _a153 = _a54(_a128.currency)
local _a154 = math.floor(math.max(0, _a153 - _a11.MainHatchReserve) / _a128.price)
if _a154 < 1 then break end
_a132 = math.min(_a154, _a131)
end
else
local _a155 = _a152 and tostring(_a151) or "호출 자체 실패"
if _a155:find("quickly") or _a155:find("fast") then
task.wait(0.25)
elseif _a155:find("far away") then
if _a11.HatchAutoTp then _a19.tpEgg(_a128.id) task.wait(0.2)
else _a5("[부화] 알에서 너무 멈") break end
elseif _a132 > 1 then
_a132 = math.floor(_a132 / 2)
else
if _a19.hatchErr ~= _a155 then
_a19.hatchErr = _a155
_a5("[부화] 실패: " .. _a155 .. "   (알 " .. tostring(_a128.id)
.. " / 개수 " .. _a132 .. " / 거리 "
.. (_a128.dist and ("%.0f"):format(_a128.dist) or "?") .. ")")
end
break
end
end
end
if _a136 and _a133 > 0 and not _a140 then
local _a156 = os.clock()
local _a157 = _a11.HatchClickAfter
while _a135() > 0 and not _a19.stopped() and (os.clock() - _a156) < 20 do
_a19.setAct("알 마무리", ("%s  마지막 %d개 까는 중"):format(_a128.id, _a132))
if _a11.HatchClick and (os.clock() - _a156) > _a157 then
_a19.clickOnce()
_a157 += 0.3
if (os.clock() - _a156) > 3 and not _a19._finRe then
_a19._finRe = true
_a19._ahEgg = nil
_a19.autoHatchOn(_a128.id, _a132)
end
end
task.wait(0.03)
end
_a19._finRe = nil
if _a135() > 0 then
_a5("[부화] 마지막 알이 20초 넘게 안 끝남 — 그대로 두고 진행합니다")
end
end
_a19.autoHatchOff()
if _a133 > 0 then
_a19.hatchErr = nil
_a5(("[부화] %s × %d%s  (개당 %s %s)"):format(
_a128.id, _a133, _a142 and " (목표까지)" or "",
_a128.price and _a6(_a128.price, 0) or "?", tostring(_a128.currency)))
end
end
local function _a158()
local _a159 = _a46()
if not _a159 then return nil end
local _a160 = tonumber(rawget(_a159, "Rank")) or 1
local _a161 = tonumber(rawget(_a159, "RankStars")) or 0
local _a162 = rawget(_a159, "RedeemedRankRewards") or {}
local _a163
if _a17.RanksU and rawget(_a17.RanksU, "RankIDFromNumber") then
local _a164, _a165 = pcall(_a17.RanksU.RankIDFromNumber, _a160)
if _a164 then _a163 = _a165 end
end
local _a166 = _a163 and _a17.DirRanks and rawget(_a17.DirRanks, _a163)
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
if not _a17.R_Rank then _a5("[랭크] Ranks_ClaimReward 리모트 없음") return end
local _a174 = _a158()
if not _a174 then return end
local _a175 = 0
for _a176, _a177 in ipairs(_a174.rewards) do
if not _a12.rank then break end
if _a177.claimable then
pcall(function() _a17.R_Rank:FireServer(_a177.index) end)
_a175 += 1
_a13.rank += 1
task.wait(0.1)
end
end
if _a175 > 0 then
_a5(("[랭크] 보상 %d개 수령  (Rank %d, ★%d)"):format(_a175, _a174.rankNum, _a174.stars))
end
end
function _a19.hrp()
local _a178 = _a4.Character
return _a178 and _a178:FindFirstChild("HumanoidRootPart"),
_a178 and _a178:FindFirstChildOfClass("Humanoid")
end
function _a19.autoHatchOn(_a179, _a180)
if not _a11.UseAutoHatch then return end
if _a19._ahEgg == _a179 and _a19._ahAt and (os.clock() - _a19._ahAt) < 15 then return end
_a19._ahEgg, _a19._ahAt = _a179, os.clock()
local _a181 = _a17.DirEggs and rawget(_a17.DirEggs, _a179)
if _a17.Hatch and _a181 and rawget(_a17.Hatch, "SetupEgg") then
local _a182, _a183 = pcall(_a17.Hatch.SetupEgg, _a181, _a180 or 1)
if not _a182 and not _a19._ahWarn then
_a19._ahWarn = true
_a5("[부화] SetupEgg 실패: " .. tostring(_a183) .. "  → 클릭 대체 사용")
end
end
if _a17.R_AHTog then pcall(function() _a17.R_AHTog:FireServer(true) end) end
if _a17.R_AHOn then pcall(function() _a17.R_AHOn:FireServer(_a179, _a180 or 1) end) end
if _a17.Hatch and rawget(_a17.Hatch, "IsHatching") then
local _a184, _a185 = pcall(_a17.Hatch.IsHatching)
_a19._ahLive = _a184 and _a185 and true or false
end
end
function _a19.autoHatchOff()
_a19._ahEgg, _a19._ahAt, _a19._ahLive = nil, nil, nil
if _a17.Hatch and rawget(_a17.Hatch, "StopHatching") then pcall(_a17.Hatch.StopHatching) end
if _a17.R_AHOff then pcall(function() _a17.R_AHOff:FireServer() end) end
end
function _a19.clickOnce()
if _a19.moving then return false end
local _a186 = _a19.signal("egg")
if not _a186 then _a186 = _a19.pressInGame({ "Egg Opening" }) end
if not _a186 and not _a19._eggSigWarn then
_a19._eggSigWarn = true
_a5("[부화] 게임 내 방법이 다 막힘 — SetupEgg 에만 의존합니다")
end
return _a186
end
function _a19.applyPetSpeed()
local _a187 = _a17.PlayerPet
if not (_a187 and rawget(_a187, "GetByPlayer")) then return 0, "PlayerPet 없음" end
local _a188, _a189 = pcall(_a187.GetByPlayer, _a4)
if not (_a188 and type(_a189) == "table") then return 0, "펫 목록 못 읽음" end
local _a190 = math.max(1, tonumber(_a11.PetSpeedMult) or 50)
local _a191 = math.max(0.05, tonumber(_a11.PetSpeedBase) or 4)
local _a192 = 0
for _a193, _a194 in pairs(_a189) do
if type(_a194) == "table" then
local _a195 = rawget(_a194, "cpet")
if _a195 then
_a194.speedMult = _a190
pcall(function() _a195:Broadcast("petSpeedMult", _a190) end)
pcall(function() _a195:Broadcast("petSpeed", _a191) end)
_a192 += 1
end
end
end
return _a192
end
_a19.SIGNAL = {
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
_a19.BLOCKERS = {
{ "Rebirth",     "리버스",   "reward" },
{ "RankUp",      "랭크업",   "reward" },
{ "MasteryPerk", "마스터리", "mastery" },
{ "Card",        "카드",     "card" },
}
function _a19.findSignalFns(_a196)
local _a197 = _a19.SIGNAL[_a196]
if not _a197 then return {} end
_a19._sig = _a19._sig or {}
local _a198 = _a19._sig[_a196]
if _a198 and (os.clock() - _a198.at) < (#_a198.fns > 0 and 20 or 3) then return _a198.fns end
local _a199 = {}
_a19._sig[_a196] = { at = os.clock(), fns = _a199 }
if type(getgc) ~= "function" or type(debug) ~= "table"
or type(debug.info) ~= "function" or type(debug.getupvalue) ~= "function" then
return _a199
end
local _a200 = {}
for _a201, _a202 in ipairs({ true, false }) do
local _a203, _a204 = pcall(getgc, _a202)
if _a203 and type(_a204) == "table" then
for _a205, _a206 in ipairs(_a204) do _a200[#_a200 + 1] = _a206 end
end
end
if #_a200 == 0 then return _a199 end
for _a207, _a208 in ipairs(_a200) do
if type(_a208) == "function" then
local _a209, _a210 = pcall(debug.info, _a208, "s")
if _a209 and type(_a210) == "string" then
local _a211 = false
for _a212, _a213 in ipairs(_a197.pats) do
if _a210:find(_a213, 1, true) then _a211 = true break end
end
if _a211 then
local _a214, _a215 = pcall(debug.info, _a208, "a")
if _a214 then
local _a216, _a217 = {}, 0
for _a218 = 1, 16 do
local _a219, _a220 = pcall(debug.getupvalue, _a208, _a218)
if not _a219 then break end
_a217 = _a218
_a216[_a218] = type(_a220)
end
local _a221 = table.concat(_a216, ",")
local _a222 = false
for _a223, _a224 in ipairs(_a197.sigs or {}) do
if _a215 == _a224.np and _a221 == _a224.t then
_a199[#_a199 + 1] = { fn = _a208, sig = _a221, n = _a217, np = _a215,
src = _a210, set = _a224.set }
_a222 = true
break
end
end
if not _a222 and _a197.sigs then
local _a225 = {}
for _a226, _a227 in ipairs(_a216) do
if _a227 == "boolean" then _a225[#_a225 + 1] = _a226 end
end
if #_a225 > 0 then
_a199[#_a199 + 1] = { fn = _a208, idx = _a225, sig = _a221, n = _a217,
np = _a215, src = _a210, loose = true }
end
end
if not _a222 and not _a197.sigs and _a215 == 0 then
local _a228 = 0
for _a229, _a230 in ipairs(_a216) do if _a230 == "boolean" then _a228 += 1 end end
if _a228 >= (_a197.minBools or 1) then
local _a231 = {}
for _a232, _a233 in ipairs(_a216) do
if _a233 == "boolean" then _a231[#_a231 + 1] = _a232 end
end
_a199[#_a199 + 1] = { fn = _a208, idx = _a231, sig = _a221, n = _a217, src = _a210 }
end
end
end
end
end
end
end
return _a199
end
function _a19.signal(_a234)
if type(debug) ~= "table" or type(debug.setupvalue) ~= "function" then return false, 0 end
local _a235 = _a19.findSignalFns(_a234)
local _a236 = 0
for _a237, _a238 in ipairs(_a235) do
if _a238.set then
for _a239, _a240 in ipairs(_a238.set) do
if pcall(debug.setupvalue, _a238.fn, _a240[1], _a240[2]) then _a236 += 1 end
end
elseif not _a238.loose then
for _a241, _a242 in ipairs(_a238.idx or {}) do
if pcall(debug.setupvalue, _a238.fn, _a242, true) then _a236 += 1 end
end
end
end
if _a236 == 0 then
for _a243, _a244 in ipairs(_a235) do
if _a244.loose then
for _a245, _a246 in ipairs(_a244.idx or {}) do
if pcall(debug.setupvalue, _a244.fn, _a246, true) then _a236 += 1 end
end
end
end
end
return _a236 > 0, _a236
end
function _a19.pressInGame(_a247)
local _a248, _a249 = pcall(function() return game:GetService("UserInputService") end)
if not (_a248 and _a249) then return false end
local _a250 = {
UserInputType  = Enum.UserInputType.MouseButton1,
UserInputState = Enum.UserInputState.Begin,
KeyCode        = Enum.KeyCode.Unknown,
Position       = Vector3.new(),
Delta          = Vector3.new(),
}
local _a251 = 0
if type(getconnections) == "function" then
local _a252, _a253 = pcall(getconnections, _a249.InputBegan)
if _a252 and type(_a253) == "table" then
for _a254, _a255 in ipairs(_a253) do
local _a256 = ""
local _a257 = _a255.Function
if _a257 and type(debug) == "table" and type(debug.info) == "function" then
local _a258, _a259 = pcall(debug.info, _a257, "s")
if _a258 and _a259 then _a256 = tostring(_a259) end
end
local _a260 = false
for _a261, _a262 in ipairs(_a247) do
if _a256 ~= "" and _a256:find(_a262, 1, true) then _a260 = true break end
end
if _a260 then
if _a257 and pcall(_a257, _a250, false) then _a251 += 1
elseif _a255.Fire and pcall(function() _a255:Fire(_a250, false) end) then _a251 += 1
elseif _a255.Defer and pcall(function() _a255:Defer(_a250, false) end) then _a251 += 1 end
end
end
end
end
if _a251 == 0 and type(firesignal) == "function" then
if pcall(firesignal, _a249.InputBegan, _a250, false) then _a251 += 1 end
end
return _a251 > 0
end
function _a19.realClick(_a263)
if not _a11.ScreenRealClick then return false end
local _a264 = workspace.CurrentCamera
local _a265 = (_a264 and _a264.ViewportSize) or Vector2.new(1280, 720)
local _a266, _a267 = _a265.X * 0.5, _a265.Y * 0.45
local _a268 = {}
local function _a269(_a270, _a271)
local _a272 = pcall(_a271)
_a268[#_a268 + 1] = _a270 .. (_a272 and "=OK" or "=X")
return _a272
end
local _a273 = false
if not _a273 and type(mouse1click) == "function" then
_a273 = _a269("mouse1click", function() mouse1click() end)
end
if not _a273 and type(mouse1press) == "function" then
_a273 = _a269("mouse1press", function()
mouse1press() task.wait(0.05)
if type(mouse1release) == "function" then mouse1release() end
end)
end
if not _a273 then
_a273 = _a269("VirtualUser", function()
local _a274 = game:GetService("VirtualUser")
_a274:Button1Down(Vector2.new(_a266, _a267), _a264 and _a264.CFrame or CFrame.new())
task.wait(0.05)
_a274:Button1Up(Vector2.new(_a266, _a267), _a264 and _a264.CFrame or CFrame.new())
end)
end
if not _a273 then
_a273 = _a269("VirtualInputManager", function()
local _a275 = game:GetService("VirtualInputManager")
_a275:SendMouseButtonEvent(_a266, _a267, 0, true, game, 1)
task.wait(0.05)
_a275:SendMouseButtonEvent(_a266, _a267, 0, false, game, 1)
end)
end
if _a263 then _a5("    " .. table.concat(_a268, " / ")) end
return _a273
end
function _a19.rewardScreenUp()
local _a276 = _a4:FindFirstChildOfClass("PlayerGui")
if _a276 then
for _a277, _a278 in ipairs(_a19.BLOCKERS) do
local _a279 = _a276:FindFirstChild(_a278[1])
if _a279 and _a279:IsA("ScreenGui") and _a279.Enabled then return true, _a278[2], _a278[3] end
end
end
local _a280 = _a17.Vars
if _a280 then
if rawget(_a280, "IsRebirthing") then return true, "리버스", "reward" end
if rawget(_a280, "IsRankingUp") then return true, "랭크업", "reward" end
end
return false
end
function _a19.dismissRewardScreens(_a281)
if _a19.dismissBusy then return end
_a19.dismissBusy = true
local _a282, _a283 = pcall(_a19.dismissInner, _a281)
_a19.dismissBusy = false
if not _a282 then _a5("[화면] 오류: " .. tostring(_a283)) end
end
function _a19.dismissInner(_a284)
local _a285 = _a17.Vars
if not _a285 then return end
local _a286 = os.clock()
local _a287, _a288 = false, nil
local _a289 = 0
local _a290 = math.max(3, _a11.ScreenTryMax or 8)
while os.clock() - _a286 < (_a284 or 120) do
local _a291, _a292, _a293 = _a19.rewardScreenUp()
if not _a291 then break end
_a287, _a288 = true, _a292
_a289 += 1
_a19.setAct("보상 화면 넘기는 중",
("%s (%d회%s)"):format(tostring(_a292), _a289,
_a289 <= 6 and " · 첫 화면 대기" or ""))
local _a294 = _a19.SIGNAL[_a293 or "reward"]
local _a295 = (_a294 and _a294.pats) or { "Rebirth", "Rank Up" }
local _a296 = _a19.signal(_a293 or "reward")
if not _a296 then
for _a297 in pairs(_a19.SIGNAL) do
if _a19.signal(_a297) then _a296 = true end
end
end
local _a298 = false
if not _a296 or _a289 >= 2 then
_a298 = _a19.pressInGame(_a295)
end
if _a289 >= 3 then
if _a19.realClick() then
_a298 = true
if not _a19._realSaid then
_a19._realSaid = true
_a5("[화면] 실제 클릭까지 같이 씁니다 (Roblox 창이 켜져 있어야 먹습니다)")
end
end
end
if (_a296 or _a298) and not _a19._sigSaid then
_a19._sigSaid = true
_a5("[화면] " .. (_a296 and "upvalue 신호" or "게임 내 입력 발동") .. " 로 넘깁니다")
end
if _a289 >= _a290 and (os.clock() - _a286) >= 12 then
if _a19.giveUpSaid ~= _a292 then
_a19.giveUpSaid = _a292
_a5(("[화면] %s 화면을 못 넘김 — 그냥 두고 자동화는 계속합니다"):format(tostring(_a292)))
_a5("        (이 화면은 UI만 가릴 뿐 리모트 호출은 막지 않습니다)")
end
_a19.screenGaveUp = os.clock()
return
end
task.wait(0.8)
end
if _a287 then
if not _a19.rewardScreenUp() then
_a19.lastBlocker = nil
_a19.screenGaveUp = nil
_a5(("[화면] %s 넘김 완료 (%d회)"):format(tostring(_a288), _a289))
end
end
end
function _a19.eggUnlocked(_a299)
_a299 = tonumber(_a299)
if not _a299 then return false end
local _a300 = _a46()
local _a301 = _a300 and rawget(_a300, "UnlockedEggs")
if type(_a301) == "table" then
for _a302, _a303 in pairs(_a301) do
if tonumber(_a303) == _a299 then return true end
end
return false
end
return _a299 <= 1
end
function _a19.lockedEggs()
local _a304 = {}
if not _a17.DirEggs then return _a304, 0, 0 end
local _a305 = _a46()
local _a306 = tonumber(_a305 and rawget(_a305, "MaximumAvailableEgg")) or 1
local _a307 = 0
local _a308 = _a305 and rawget(_a305, "UnlockedEggs")
if type(_a308) == "table" then
for _a309, _a310 in pairs(_a308) do
local _a311 = tonumber(_a310)
if _a311 and _a311 > _a307 then _a307 = _a311 end
end
end
for _a312, _a313 in pairs(_a17.DirEggs) do
if type(_a313) == "table" and not rawget(_a313, "isCustomEgg") then
local _a314 = tonumber(rawget(_a313, "eggNumber"))
if _a314 and _a314 <= _a306 and not _a19.eggUnlocked(_a314) then
_a304[#_a304 + 1] = { id = _a312, num = _a314 }
end
end
end
table.sort(_a304, function(_a315, _a316) return _a315.num < _a316.num end)
return _a304, _a306, _a307
end
function _a19.unlockEggs(_a317)
if not _a17.R_EggUn then return 0, "Eggs_RequestUnlock 리모트 없음" end
local _a318 = _a19.lockedEggs()
if #_a318 == 0 then return 0 end
local _a319, _a320 = 0, nil
for _a321, _a322 in ipairs(_a318) do
if not _a19.eggUnlocked(_a322.num) then
local _a323, _a324
pcall(function() _a323, _a324 = _a17.R_EggUn:InvokeServer(_a322.id) end)
if not _a323 and _a11.HatchAutoTp then
local _a325 = _a19.tpEgg(_a322.id)
if _a325 then
task.wait(0.3)
pcall(function() _a323, _a324 = _a17.R_EggUn:InvokeServer(_a322.id) end)
end
end
if _a323 then
_a319 += 1
_a19.setAct("알 해금", ("#%d %s"):format(_a322.num, _a322.id))
_a5(("  🔓 알 해금  #%d %s"):format(_a322.num, _a322.id))
task.wait(0.15)
else
_a320 = _a324
if _a317 then
_a5(("[해금] #%d %s 실패: %s"):format(_a322.num, _a322.id, tostring(_a324)))
end
end
end
end
return _a319, _a320
end
function _a19.curZone()
if _a17.Map and rawget(_a17.Map, "GetCurrentZone") then
local _a326, _a327 = pcall(_a17.Map.GetCurrentZone)
if _a326 then return _a327 end
end
return nil
end
function _a19.zone1()
if not _a17.DirZones then return nil end
local _a328, _a329 = nil, math.huge
for _a330, _a331 in pairs(_a17.DirZones) do
if type(_a331) == "table" and _a19.ownsZone(_a330) then
local _a332 = tonumber(rawget(_a331, "ZoneNumber")) or math.huge
if _a332 < _a329 then _a328, _a329 = _a330, _a332 end
end
end
return _a328
end
function _a19.realZone(_a333) return _a333 end
function _a19.resolvableZone(_a334)
if _a334 then
local _a335 = _a19.zonePos(_a334)
if _a335 then return _a334, _a335 end
end
if not _a17.DirZones then return nil end
local _a336 = {}
for _a337, _a338 in pairs(_a17.DirZones) do
if type(_a338) == "table" and _a19.ownsZone(_a337) then
_a336[#_a336 + 1] = { id = _a337, n = tonumber(rawget(_a338, "ZoneNumber")) or 0 }
end
end
table.sort(_a336, function(_a339, _a340) return _a339.n > _a340.n end)
for _a341, _a342 in ipairs(_a336) do
if _a342.id ~= _a334 then
local _a343 = _a19.zonePos(_a342.id)
if _a343 then
if _a19.fallZone ~= _a342.id then
_a19.fallZone = _a342.id
_a5(("[TP] %s 좌표를 못 구해서 %s 로 대신 감 (로드 안 된 존)"):format(
tostring(_a334), tostring(_a342.id)))
end
return _a342.id, _a343
end
end
end
return nil
end
function _a19.bestZone()
if _a17.Zone and rawget(_a17.Zone, "GetMaxOwnedZone") then
local _a344, _a345, _a346 = pcall(_a17.Zone.GetMaxOwnedZone)
if _a344 and _a345 then return _a345, _a346 end
end
return _a19.zone1()
end
function _a19.ownsZone(_a347)
local _a348 = _a46()
local _a349 = _a348 and rawget(_a348, "UnlockedZones")
return (type(_a349) == "table" and _a349[_a347] ~= nil) or false
end
function _a19.zoneByNumber(_a350)
if not (_a17.DirZones and _a350) then return nil end
for _a351, _a352 in pairs(_a17.DirZones) do
if type(_a352) == "table" and tonumber(rawget(_a352, "ZoneNumber")) == tonumber(_a350) then
return _a351, _a352
end
end
return nil
end
local function _a353(_a354, _a355)
local _a356 = rawget(_a354, "Breakables")
local _a357 = type(_a356) == "table" and rawget(_a356, "Main") or nil
local _a358 = type(_a357) == "table" and rawget(_a357, "Data") or nil
if type(_a358) ~= "table" then return false end
for _a359, _a360 in pairs(_a358) do
local _a361 = type(_a360) == "table" and rawget(_a360, "Type") or nil
if _a361 and tostring(_a361):lower():find(_a355, 1, true) then return true end
end
return false
end
function _a19.zoneForBreakable(_a362)
if not (_a17.DirZones and _a362) then return nil end
local _a363 = tostring(_a362):lower()
local _a364 = _a19.bestZone()
if _a364 then
local _a365 = rawget(_a17.DirZones, _a364)
if type(_a365) == "table" and _a353(_a365, _a363) then return _a364 end
end
local _a366, _a367 = nil, -1
for _a368, _a369 in pairs(_a17.DirZones) do
if type(_a369) == "table" and _a368 ~= "Spawn" and _a19.ownsZone(_a368) then
local _a370 = rawget(_a369, "Breakables")
local _a371 = type(_a370) == "table" and rawget(_a370, "Main") or nil
local _a372 = type(_a371) == "table" and rawget(_a371, "Data") or nil
if type(_a372) == "table" then
for _a373, _a374 in pairs(_a372) do
local _a375 = type(_a374) == "table" and rawget(_a374, "Type") or nil
if _a375 and tostring(_a375):lower():find(_a363, 1, true) then
local _a376 = tonumber(rawget(_a369, "ZoneNumber")) or 0
if _a376 > _a367 then _a366, _a367 = _a368, _a376 end
break
end
end
end
end
end
return _a366
end
function _a19.tpZone(_a377)
if not _a377 then return false, "존 id 없음" end
if _a19.curZone() == _a377 then return true end
if not _a11.TpGameFallback then
_a5("[TP] 게임 정식 TP 차단됨 (" .. tostring(_a377) .. ")\n" .. debug.traceback("", 2))
return false, "게임 TP 꺼져 있음"
end
local _a378 = _a17.R_Tp
if _a17.Inst and rawget(_a17.Inst, "IsInInstance") then
local _a379, _a380 = pcall(_a17.Inst.IsInInstance)
if _a379 and _a380 and _a17.R_TpI then _a378 = _a17.R_TpI end
end
if not _a378 then return false, "텔레포트 리모트 없음" end
local _a381 = os.clock() - (_a19.lastTp or 0)
if _a381 < _a11.TpCooldown then task.wait(_a11.TpCooldown - _a381) end
_a19.lastTp = os.clock()
local _a382, _a383
pcall(function() _a382, _a383 = _a378:InvokeServer(_a377) end)
if not _a382 then return false, _a383 end
local _a384 = os.clock()
while os.clock() - _a384 < 5 do
if _a19.curZone() == _a377 then break end
task.wait(0.05)
end
task.wait(0.15)
return true
end
function _a19.glideTo(_a385)
if _a19.stopped() then return false, "정지됨" end
if _a19.moving and (os.clock() - _a19.moving) < 30 then
return false, "이미 이동 중 (다른 이동이 아직 안 끝남)"
end
_a19.moving = os.clock()
local _a386, _a387, _a388 = pcall(_a19.glideRaw, _a385)
_a19.moving = nil
if not _a386 then return false, tostring(_a387) end
return _a387, _a388
end
function _a19.glideRaw(_a389)
local _a390, _a391 = _a19.hrp()
if not _a390 then return false, "캐릭터 없음" end
if _a11.TpMode == "instant" then
local _a392 = _a389 + Vector3.new(0, 4, 0)
for _a393 = 1, 3 do
local _a394 = _a4.Character
local _a395, _a396 = _a19.hrp()
if not (_a394 and _a395) then return false, "캐릭터 없음" end
local _a397 = _a395.CFrame - _a395.CFrame.Position
pcall(function() _a394:PivotTo(CFrame.new(_a392) * _a397) end)
_a395.AssemblyLinearVelocity = Vector3.zero
for _a398 = 1, 6 do _a3.Heartbeat:Wait() end
if _a396 then
pcall(function()
_a396:Move(Vector3.new(0.3, 0, 0), false)
end)
task.wait(0.1)
pcall(function() _a396:Move(Vector3.zero, false) end)
end
task.wait(0.15)
_a395 = _a19.hrp()
if _a395 and (_a395.Position - _a392).Magnitude <= 30 then
local _a399 = os.clock()
while os.clock() - _a399 < 1.5 do
if _a19.inDottedBox() ~= false then break end
task.wait(0.05)
end
return true
end
if _a393 < 3 then task.wait(0.15) end
end
return false, "순간이동이 되돌려짐"
end
if _a11.TpMode == "walk" then
if not _a391 then return false, "Humanoid 없음" end
local _a400 = os.clock()
while os.clock() - _a400 < 45 do
local _a401 = _a390.Position
if (Vector3.new(_a401.X, 0, _a401.Z) - Vector3.new(_a389.X, 0, _a389.Z)).Magnitude < 8 then
return true
end
_a391:MoveTo(_a389)
task.wait(0.5)
end
return false, "걸어가다 시간초과"
end
if (_a390.Position - _a389).Magnitude <= (_a11.ArriveDist or 12) then return true end
local _a402 = math.max(16, tonumber(_a11.TpSpeed) or 90)
local _a403 = math.max(0, tonumber(_a11.TpHeight) or 0)
local function _a404(_a405, _a406)
local _a407 = 0
while _a407 < 2000 do
if _a19.stopped() then return false end
_a407 += 1
local _a408 = _a19.hrp()
if not _a408 then return false end
local _a409 = _a408.Position
local _a410 = _a405 - _a409
local _a411 = _a410.Magnitude
if _a411 < 2.5 then return true end
local _a412 = _a3.Heartbeat:Wait()
local _a413 = math.min(_a411, _a402 * math.min(_a412, 0.1))
local _a414 = _a406 and (Vector3.new(_a405.X, _a409.Y, _a405.Z)) or nil
if _a414 and (_a414 - _a409).Magnitude > 1 then
_a408.CFrame = CFrame.lookAt(_a409 + _a410.Unit * _a413, _a414)
else
_a408.CFrame = CFrame.new(_a409 + _a410.Unit * _a413) * (_a408.CFrame - _a408.Position)
end
_a408.AssemblyLinearVelocity = Vector3.zero
end
return false
end
if _a403 > 0 then
local _a415 = _a390.Position
local _a416 = math.max(_a415.Y, _a389.Y) + _a403
_a404(Vector3.new(_a415.X, _a416, _a415.Z), false)
_a404(Vector3.new(_a389.X, _a416, _a389.Z), true)
end
_a404(_a389 + Vector3.new(0, 3, 0), true)
local _a417 = _a19.hrp()
if _a417 then _a417.AssemblyLinearVelocity = Vector3.zero end
return true
end
local function _a418(_a419)
local _a420 = #_a419
if _a420 == 0 then return nil, 0 end
local _a421, _a422 = math.huge, -math.huge
local _a423, _a424 = math.huge, -math.huge
local _a425 = 0
for _a426, _a427 in ipairs(_a419) do
if _a427.X < _a421 then _a421 = _a427.X end
if _a427.X > _a422 then _a422 = _a427.X end
if _a427.Z < _a423 then _a423 = _a427.Z end
if _a427.Z > _a424 then _a424 = _a427.Z end
_a425 += _a427.Y
end
return Vector3.new((_a421 + _a422) / 2, _a425 / _a420, (_a423 + _a424) / 2), _a420
end
function _a19.breakCenter(_a428)
local _a429 = _a19.hrp()
if not _a429 then return nil, 0 end
local _a430 = workspace:FindFirstChild("__THINGS")
if not _a430 then return nil, 0 end
local _a431 = _a429.Position
local _a432 = {}
for _a433, _a434 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a435 = _a430:FindFirstChild(_a434)
if _a435 then
for _a436, _a437 in ipairs(_a435:GetChildren()) do
local _a438
if _a437:IsA("BasePart") then _a438 = _a437.Position
elseif _a437:IsA("Model") then
local _a439, _a440 = pcall(function() return _a437:GetPivot() end)
if _a439 and typeof(_a440) == "CFrame" then _a438 = _a440.Position end
end
if _a438 and (_a438 - _a431).Magnitude <= (_a428 or 400) then
_a432[#_a432 + 1] = _a438
end
end
end
end
return _a418(_a432)
end
function _a19.groundY(_a441, _a442, _a443)
_a443 = tonumber(_a443) or 0
local _a444 = RaycastParams.new()
_a444.FilterType = Enum.RaycastFilterType.Exclude
local _a445 = {}
if _a4.Character then _a445[#_a445 + 1] = _a4.Character end
local _a446 = workspace:FindFirstChild("__THINGS")
if _a446 then _a445[#_a445 + 1] = _a446 end
_a444.FilterDescendantsInstances = _a445
local _a447 = Vector3.new(_a441, _a443 + 12, _a442)
local _a448, _a449 = pcall(function()
return workspace:Raycast(_a447, Vector3.new(0, -160, 0), _a444)
end)
if _a448 and _a449 then
local _a450 = _a449.Position.Y
if math.abs(_a450 - _a443) <= 80 then return _a450 + 4 end
end
return nil
end
function _a19.zonePos(_a451, _a452)
if not _a451 then return nil, "존 id 없음" end
_a451 = _a19.realZone(_a451)
local _a453 = _a17.DirZones and rawget(_a17.DirZones, _a451)
local _a454 = _a453 and rawget(_a453, "ZoneFolder")
local _a455 = {}
do
local _a456 = workspace:FindFirstChild("__THINGS")
for _a457, _a458 in ipairs({ "Breakables", "AnimatedBreakables" }) do
local _a459 = _a456 and _a456:FindFirstChild(_a458)
if _a459 then
for _a460, _a461 in ipairs(_a459:GetChildren()) do
local _a462
if _a461:IsA("BasePart") then _a462 = _a461.Position
elseif _a461:IsA("Model") then
local _a463, _a464 = pcall(function() return _a461:GetPivot() end)
if _a463 and typeof(_a464) == "CFrame" then _a462 = _a464.Position end
end
if _a462 then _a455[#_a455 + 1] = _a462 end
end
end
end
end
local _a465 = {}
local function _a466(_a467, _a468)
if not _a467 then return end
local _a469, _a470 = pcall(function() return _a467:GetDescendants() end)
if _a467:IsA("BasePart") then _a465[#_a465 + 1] = { p = _a467.Position, why = _a468 } end
if _a469 then
for _a471, _a472 in ipairs(_a470) do
if _a472:IsA("BasePart") then
_a465[#_a465 + 1] = { p = _a472.Position, why = _a468 .. "/" .. _a472.Name }
end
end
end
end
if _a17.ZonesU then
for _a473, _a474 in ipairs({ "GetBreakableZones", "GetBreakableSpawns" }) do
local _a475 = rawget(_a17.ZonesU, _a474)
if type(_a475) == "function" then
local _a476, _a477 = pcall(_a475, _a451)
if _a476 and _a477 then _a466(_a477, _a474) end
end
end
end
if _a454 then
for _a478, _a479 in ipairs({ "BREAK_ZONES", "BREAKABLE_SPAWNS" }) do
local _a480, _a481 = pcall(function() return _a454:FindFirstChild(_a479, true) end)
if _a480 and _a481 then _a466(_a481, "ZoneFolder/" .. _a479) end
end
end
local _a482, _a483, _a484
for _a485, _a486 in ipairs(_a465) do
local _a487 = 0
for _a488, _a489 in ipairs(_a455) do
if (_a489 - _a486.p).Magnitude <= 150 then _a487 += 1 end
end
if not _a483 or _a487 > _a483 then _a482, _a483, _a484 = _a486.p, _a487, _a486.why end
end
local _a490, _a491
if _a482 and (_a483 or 0) >= 1 then
_a490, _a491 = _a482, ("%s (브레이커블 %d개)"):format(tostring(_a484), _a483)
end
if not _a490 and _a482 then
_a490, _a491 = _a482, tostring(_a484) .. " (브레이커블 없음)"
end
if not _a490 and _a17.ZonesU and rawget(_a17.ZonesU, "GetTeleportPartLocation") then
local _a492, _a493 = pcall(_a17.ZonesU.GetTeleportPartLocation, _a451)
if _a492 and typeof(_a493) == "CFrame" then
_a490, _a491 = _a493.Position, "PERSISTENT/Teleport (스트리밍 대기)"
end
end
if not _a490 then return nil, "브레이커블 위치를 못 찾음" end
local _a494 = _a19.groundY(_a490.X, _a490.Z, _a490.Y)
if _a494 then
_a490 = Vector3.new(_a490.X, _a494, _a490.Z)
_a491 = _a491 .. " +지면"
else
_a490 = Vector3.new(_a490.X, _a490.Y + 5, _a490.Z)
end
return _a490, _a491
end
function _a19.goToZone(_a495, _a496, _a497, _a498)
_a495 = _a19.realZone(_a495)
if not _a495 then return false, "존 id 없음" end
local _a499, _a500 = _a19.zonePos(_a495)
if not _a499 then
if _a11.TpGameFallback and _a19.curZone() ~= _a495 then
local _a501, _a502 = _a19.tpZone(_a495)
if not _a501 then return false, _a502 end
task.wait(0.3)
_a499, _a500 = _a19.zonePos(_a495)
end
if not _a499 then
local _a503, _a504 = _a19.resolvableZone(_a495)
if _a503 and _a504 then
if _a498 then
return false, ("%s 가 로드되지 않음"):format(tostring(_a495))
end
_a495, _a499, _a500 = _a503, _a504, "대체 존 " .. tostring(_a503)
else
if _a19.zoneFailSaid ~= _a495 then
_a19.zoneFailSaid = _a495
_a5(("[TP] %s 좌표 실패: %s (갈 수 있는 존이 없음)"):format(
tostring(_a495), tostring(_a500)))
end
return false, _a500
end
end
end
local _a505 = _a19.hrp()
if not _a497 and _a505 and _a19.curZone() == _a495 then
local _a506 = _a19.inDottedBox()
local _a507
if _a506 ~= nil then
_a507 = _a506
else
_a507 = (_a505.Position - _a499).Magnitude <= (_a11.ZoneArriveDist or 90)
end
if _a507 then
if _a496 then _a5("[TP] 이미 " .. _a495 .. " 사냥터 안에 있음") end
return true
end
end
if _a496 then
_a5(("[TP] %s 내부 좌표 %s → (%.0f, %.0f, %.0f)"):format(
_a495, tostring(_a500), _a499.X, _a499.Y, _a499.Z))
end
local _a508, _a509 = _a19.glideTo(_a499)
local _a510 = _a19.hrp()
if _a510 and (_a510.Position - _a499).Magnitude > math.max(40, _a11.ArriveDist or 12) then
task.wait(0.2)
_a19.moving = nil
_a19.glideTo(_a499)
local _a511 = _a19.hrp()
local _a512 = _a511 and (_a511.Position - _a499).Magnitude or -1
if _a512 > math.max(40, _a11.ArriveDist or 12) then
local _a513 = _a11.TpMode
_a11.TpMode = "glide"
_a19.moving = nil
_a19.glideTo(_a499)
_a11.TpMode = _a513
local _a514 = _a19.hrp()
_a512 = _a514 and (_a514.Position - _a499).Magnitude or -1
if _a512 > math.max(40, _a11.ArriveDist or 12) then
_a5(("[TP] %s 이동 실패 — %.0f스터드 남음 (순간이동·glide 둘 다)"):format(
tostring(_a495), _a512))
return false, "이동이 되돌려짐"
end
_a5("[TP] 순간이동이 막혀서 glide 로 이동함: " .. tostring(_a495))
end
end
do
local _a515 = _a19.hrp()
if _a515 and (_a515.Position.Y - _a499.Y) > 25 then
_a5(("[TP] 목표보다 %.0f 높은 곳에 얹힘 — 내려감"):format(_a515.Position.Y - _a499.Y))
_a19.moving = nil
_a19.glideTo(Vector3.new(_a499.X, _a499.Y, _a499.Z))
end
end
if tostring(_a500):find("스트리밍", 1, true) then
task.wait(1.2)
local _a516, _a517 = _a19.zonePos(_a495)
if _a516 and not tostring(_a517):find("스트리밍", 1, true) then
if _a496 then
_a5("[TP] 스트리밍 로드됨 → 사냥터로 (" .. tostring(_a517) .. ")")
end
_a19.moving = nil
_a19.glideTo(_a516)
_a499, _a500 = _a516, _a517
end
end
if _a19.inDottedBox() == false then
task.wait(0.2)
local _a518, _a519 = _a19.breakCenter(400)
if _a518 and _a519 >= 3 then
if _a496 then
_a5(("[TP] 네모 밖 → 주변 브레이커블 %d개 중심으로 보정"):format(_a519))
end
_a19.moving = nil
_a19.glideTo(_a518)
_a499 = _a518
end
if _a19.inDottedBox() == false then
local _a520 = _a19.zonePos(_a495)
if _a520 and (_a520 - _a499).Magnitude > 5 then
if _a496 then _a5("[TP] 아직 네모 밖 → 좌표 재계산 후 재시도") end
_a19.moving = nil
_a19.glideTo(_a520)
_a499 = _a520
end
end
if _a19.inDottedBox() == false and _a496 then
_a5(("[TP] %s 네모 안으로 못 들어감 (좌표 %s)"):format(_a495, tostring(_a500)))
end
end
local function _a521()
if _a19.inDottedBox() == true then return false end
local _a522, _a523 = _a19.breakCenter(400)
if (_a523 or 0) >= 1 then return false end
task.wait(0.6)
if _a19.inDottedBox() == true then return false end
local _a524, _a525 = _a19.breakCenter(400)
return (_a525 or 0) < 1
end
if _a521() and (os.clock() - (_a19.lastRecover or -999)) > 30 then
_a19.lastRecover = os.clock()
_a5(("[TP] %s 근처에 브레이커블이 없음 (%s) — 좌표 확인 필요"):format(
tostring(_a495), tostring(_a500)))
end
_a19.zoneFailSaid = nil
_a19.arrivedZone = _a495
do
local _a526 = _a19.hrp()
local _a527 = _a526 and (_a526.Position - _a499).Magnitude or 0
if _a527 > math.max(60, _a11.ArriveDist or 12) then
_a5(("[TP] %s 도착 실패 — %.0f스터드 남음 (되돌려짐)"):format(tostring(_a495), _a527))
return false, "이동이 되돌려짐"
end
end
local _a528 = _a19.hrp()
if _a496 and _a528 then
_a5(("[TP] 도착. 목표까지 %.0f스터드 / 존 %s / 네모안 %s"):format(
(_a528.Position - _a499).Magnitude, tostring(_a19.curZone()), tostring(_a19.inDottedBox())))
end
return true
end
function _a19.tpEgg(_a529)
if not _a529 then return false, "알 id 없음" end
for _a530, _a531 in ipairs(_a19.eggStands()) do
if _a531.id == _a529 then
if _a531.dist <= _a11.EggRange then return true, _a529 end
local _a532, _a533 = _a19.glideTo(_a531.pos)
return _a532, _a532 and _a529 or _a533
end
end
if _a11.TpGameFallback then
local _a534 = _a17.DirEggs and rawget(_a17.DirEggs, _a529)
local _a535 = _a534 and select(1, _a19.zoneByNumber(rawget(_a534, "zoneNumber")))
if _a535 and _a19.curZone() ~= _a535 then
local _a536, _a537 = _a19.tpZone(_a535)
if not _a536 then return false, _a537 end
task.wait(0.5)
_a19._standsAt = nil
for _a538, _a539 in ipairs(_a19.eggStands()) do
if _a539.id == _a529 then return _a19.glideTo(_a539.pos), _a529 end
end
end
end
return false, "알 받침대를 못 찾음 (" .. tostring(_a529) .. ")"
end
function _a19.stacks(_a540)
local _a541 = _a46()
local _a542 = _a541 and rawget(_a541, "Inventory")
local _a543 = _a542 and rawget(_a542, _a540)
if type(_a543) ~= "table" then return {} end
local _a544 = {}
for _a545, _a546 in pairs(_a543) do
if type(_a546) == "table" then
_a544[#_a544 + 1] = {
uid = _a545,
id = tostring(rawget(_a546, "id")),
tier = tonumber(rawget(_a546, "tn")) or 1,
am = tonumber(rawget(_a546, "_am")) or 1,
}
end
end
return _a544
end
_a19.PERTIER = {
Potion  = { 3, 3, 4, 5, 5, 5, 5, 5, 7, 7, 7 },
Enchant = { 5, 5, 5, 7, 7, 7, 7, 7, 10, 10 },
}
function _a19.perTier(_a547, _a548)
_a548 = tonumber(_a548)
local _a549 = _a17.Bal and rawget(_a17.Bal,
_a547 == "Potion" and "CalcPotionsPerTierRequired" or "CalcEnchantsPerTierRequired")
if type(_a549) == "function" then
local _a550, _a551 = pcall(_a549, _a548)
_a551 = _a550 and tonumber(_a551) or nil
if _a551 and _a551 > 0 then return _a551 end
if not _a550 and not _a19.perTierWarned then
_a19.perTierWarned = true
_a5("[퀘스트] 재료 수량 함수 막힘 → 기본표로 계산 (" .. tostring(_a551) .. ")")
end
end
local _a552 = _a19.PERTIER[_a547]
local _a553 = _a552 and _a548 and _a552[_a548]
return (_a553 and _a553 > 0) and _a553 or nil
end
function _a19.upgradeTo(_a554, _a555)
local _a556 = (_a554 == "Potion") and _a17.R_PotUp or _a17.R_EncUp
if not _a556 then return 0, (_a554 .. " 업글 리모트 없음") end
local _a557 = math.max(1, (tonumber(_a555) or 2) - 1)
local _a558 = _a19.perTier(_a554, _a557)
if not _a558 then return 0, ("T%d 재료 수량을 못 읽음"):format(_a557) end
local _a559, _a560 = {}, 0
for _a561, _a562 in ipairs(_a19.stacks(_a554)) do
if _a562.tier == _a557 then
local _a563 = math.floor(_a562.am / _a558)
if _a563 > 0 then _a559[_a562.uid] = _a563 _a560 += _a563 end
end
end
if _a560 < 1 then return 0, ("T%d 재료 부족 (T%d %d개당 1개)"):format(_a557, _a557, _a558) end
local _a564, _a565
pcall(function() _a564, _a565 = _a556:InvokeServer(_a559) end)
if not _a564 then return 0, tostring(_a565) end
return _a560
end
function _a19.usePotion(_a566, _a567)
if not _a17.R_PotUse then return 0, "Potions: Consume 리모트 없음" end
_a566 = tonumber(_a566) or 1
local _a568 = {}
for _a569, _a570 in ipairs(_a19.stacks("Potion")) do
if _a570.tier >= _a566 and _a570.am >= 1 then _a568[#_a568 + 1] = _a570 end
end
if #_a568 == 0 then return 0, ("T%d 이상 포션 없음"):format(_a566) end
table.sort(_a568, function(_a571, _a572) return _a571.tier < _a572.tier end)
local _a573, _a574 = _a567, 0
for _a575, _a576 in ipairs(_a568) do
for _a577 = 1, math.min(_a573, _a576.am) do
if _a573 < 1 or not _a12.quest then break end
pcall(function() _a17.R_PotUse:FireServer(_a576.uid, 1) end)
_a574 += 1
_a573 -= 1
task.wait(0.12)
end
if _a573 < 1 then break end
end
return _a574
end
_a19.EVENTKIND = {
[31]="CoinJar",    [37]="CoinJar",    [68]="CoinJar",
[32]="Comet",      [38]="Comet",      [69]="Comet",
[66]="Pinata",     [43]="Pinata",     [70]="Pinata",
[67]="LuckyBlock", [44]="LuckyBlock", [71]="LuckyBlock",
}
_a19.BESTONLY = { [37]=true, [38]=true, [43]=true, [44]=true, [39]=true, [76]=true }
_a19.CHESTKIND = { [8]="MiniChests", [39]="MiniChests", [72]="MiniChests",
[75]="SuperiorMiniChests", [76]="SuperiorMiniChests", [77]="SuperiorMiniChests" }
local function _a578(_a579)
if typeof(_a579) == "Vector3" then return _a579 end
if typeof(_a579) == "CFrame" then return _a579.Position end
if type(_a579) == "table" then
local _a580, _a581, _a582 = tonumber(_a579.X or _a579.x or _a579[1]), tonumber(_a579.Y or _a579.y or _a579[2]), tonumber(_a579.Z or _a579.z or _a579[3])
if _a580 and _a581 and _a582 then return Vector3.new(_a580, _a581, _a582) end
end
return nil
end
function _a19.events()
local _a583
if _a17.Rand and rawget(_a17.Rand, "GetActive") then
local _a584, _a585 = pcall(_a17.Rand.GetActive)
if _a584 and type(_a585) == "table" and next(_a585) then _a583 = _a585 end
end
if not _a583 and _a17.R_Events then
local _a586, _a587 = pcall(function() return _a17.R_Events:InvokeServer() end)
if _a586 and type(_a587) == "table" then _a583 = _a587 end
end
if type(_a583) ~= "table" then return {} end
local _a588 = workspace:GetServerTimeNow()
local _a589 = {}
for _a590, _a591 in pairs(_a583) do
if type(_a591) == "table" then
local _a592 = tostring(rawget(_a591, "id") or "")
local _a593 = _a592:match("|%s*(%S+)%s*$") or _a592
local _a594 = tonumber(rawget(_a591, "started")) or 0
local _a595 = tonumber(rawget(_a591, "duration")) or 0
_a589[#_a589 + 1] = {
uid = rawget(_a591, "uid"),
id = _a592,
kind = _a593,
name = rawget(_a591, "name") or _a593,
zone = rawget(_a591, "parentID"),
pos = _a578(rawget(_a591, "origin")),
left = math.max(0, _a595 - (_a588 - _a594)),
}
end
end
table.sort(_a589, function(_a596, _a597) return _a596.left > _a597.left end)
return _a589
end
_a19.SPAWN = {
CoinJar    = { rem = "CoinJar_Spawn",           key = "coin jar",
order = { "basic", "giant", "magic" } },
Comet      = { rem = "Comet_Spawn",             key = "comet" },
Pinata     = { rem = "MiniPinata_Consume",      key = "pinata" },
LuckyBlock = { rem = "MiniLuckyBlock_Consume",  key = "lucky block" },
}
function _a19.inDottedBox()
if _a17.Map and rawget(_a17.Map, "IsInDottedBox") then
local _a598, _a599 = pcall(_a17.Map.IsInDottedBox)
if _a598 then return _a599 and true or false end
end
return nil
end
function _a19.spawnItems(_a600)
local _a601 = _a19.SPAWN[_a600]
if not _a601 then return {} end
local _a602 = {}
for _a603, _a604 in ipairs({ "Misc", "Consumable", "Lootbox" }) do
for _a605, _a606 in ipairs(_a19.stacks(_a604)) do
local _a607 = _a606.id:lower()
if _a607:find(_a601.key, 1, true) then
local _a608 = 99
if _a601.order then
for _a609, _a610 in ipairs(_a601.order) do
if _a607:find(_a610, 1, true) then _a608 = _a609 break end
end
end
_a606.rank = _a608
_a602[#_a602 + 1] = _a606
end
end
end
table.sort(_a602, function(_a611, _a612)
if _a611.rank ~= _a612.rank then return _a611.rank < _a612.rank end
return _a611.tier < _a612.tier
end)
return _a602
end
function _a19.spawnEvent(_a613)
local _a614 = _a19.SPAWN[_a613]
if not _a614 then return 0, "소환 불가 종류" end
local _a615 = _a9:FindFirstChild(_a614.rem)
if not _a615 then return 0, _a614.rem .. " 리모트 없음" end
local _a616 = _a19.spawnItems(_a613)
if #_a616 == 0 then return 0, _a613 .. " 아이템 없음" end
local _a617 = _a19.inDottedBox()
if _a617 == false then return 0, "점선 네모 안이 아님" end
local _a618, _a619 = 0, nil
for _a620, _a621 in ipairs(_a616) do
if _a618 >= (_a11.SpawnPerCycle or 1) or not _a12.quest then break end
local _a622, _a623
pcall(function() _a622, _a623 = _a615:InvokeServer(_a621.uid) end)
if _a622 then
_a618 += 1
_a19.setAct("소환", _a613 .. " · " .. _a621.id)
_a5(("  🎁 %s 소환  (%s)"):format(_a613, _a621.id))
task.wait(0.4)
else
_a619 = _a623
break
end
end
return _a618, _a619
end
function _a19.findEvent(_a624, _a625)
local _a626 = _a625 and _a19.bestZone() or nil
local _a627
for _a628, _a629 in ipairs(_a19.events()) do
if _a629.kind == _a624 and _a629.left > 15 then
if not _a625 or _a629.zone == _a626 then
if not _a627 or (_a629.zone == _a19.curZone() and _a627.zone ~= _a19.curZone()) then
_a627 = _a629
end
end
end
end
return _a627
end
function _a19.findChest(_a630, _a631)
local _a632 = workspace:FindFirstChild("__THINGS")
if not _a632 then return nil end
local _a633 = tostring(_a630):lower():find("superior") ~= nil
local _a634 = _a19.hrp()
local _a635 = _a634 and _a634.Position
local _a636, _a637, _a638, _a639
for _a640, _a641 in ipairs(_a632:GetChildren()) do
if tostring(_a641.Name):lower():find("chest", 1, true) then
for _a642, _a643 in ipairs(_a641:GetChildren()) do
local _a644
if _a643:IsA("BasePart") then _a644 = _a643.Position
elseif _a643:IsA("Model") then
local _a645, _a646 = pcall(function() return _a643:GetPivot() end)
if _a645 and typeof(_a646) == "CFrame" then _a644 = _a646.Position end
end
if _a644 then
local _a647 = _a635 and (_a644 - _a635).Magnitude or 0
local _a648 = (tostring(_a643.Name) .. tostring(_a641.Name)):lower()
:find("superior", 1, true) ~= nil
if not _a639 or _a647 < _a639 then _a638, _a639 = _a644, _a647 end
if _a648 == _a633 and (not _a637 or _a647 < _a637) then
_a636, _a637 = _a644, _a647
end
end
end
end
end
if _a636 then return _a636, _a637 end
return _a638, _a639
end
_a19.SKIP = { [4] = true, [5] = true, [40] = true, [41] = true }
_a19.WHERE = {
[21]="bestzone", [9]="bestzone", [37]="bestzone", [38]="bestzone", [39]="bestzone",
[43]="bestzone", [44]="bestzone", [76]="bestzone", [30]="bestzone", [8]="bestzone",
[20]="bestegg",  [42]="bestegg",
[1]="breakable", [81]="zoneid",
}
function _a19.petStacks()
local _a649 = _a46()
local _a650 = _a649 and rawget(_a649, "Inventory")
local _a651 = _a650 and rawget(_a650, "Pet")
local _a652 = {}
if type(_a651) ~= "table" then return _a652 end
for _a653, _a654 in pairs(_a651) do
if type(_a654) == "table" then
_a652[#_a652 + 1] = {
uid = _a653,
id = tostring(rawget(_a654, "id")),
pt = tonumber(rawget(_a654, "pt")) or 0,
am = tonumber(rawget(_a654, "_am")) or 1,
}
end
end
return _a652
end
function _a19.bestEggPets()
local _a655 = _a87()
local _a656 = _a655 and _a17.DirEggs and rawget(_a17.DirEggs, _a655)
local _a657 = _a656 and rawget(_a656, "pets")
local _a658 = {}
if type(_a657) == "table" then
for _a659, _a660 in pairs(_a657) do
local _a661 = type(_a660) == "table" and _a660[1] or _a660
if _a661 then _a658[tostring(_a661)] = true end
end
end
return _a658, _a655
end
function _a19.makeVariant(_a662, _a663)
local _a664 = (_a662 == "gold") and _a17.R_Gold or _a17.R_Rain
if not _a664 then return 0, (_a662 .. " 머신 리모트 없음") end
local _a665 = (_a662 == "gold") and 0 or 1
local _a666
if _a663 then
local _a667, _a668 = _a19.bestEggPets()
if not next(_a667) then return 0, "최고 알(" .. tostring(_a668) .. ") 펫 목록을 못 읽음" end
_a666 = _a667
end
local _a669, _a670 = 0, nil
for _a671, _a672 in ipairs(_a19.petStacks()) do
if not _a12.quest then break end
if _a672.pt == _a665 and _a672.am >= 10 and (not _a666 or _a666[_a672.id]) then
local _a673 = math.floor(_a672.am / 10)
if _a673 > 0 then
local _a674, _a675
pcall(function() _a674, _a675 = _a664:InvokeServer(_a672.uid, _a673) end)
if _a674 then
_a669 += _a673
_a5(("  ✨ %s 제작  %s x%d"):format(
_a662 == "gold" and "골드" or "레인보우", _a672.id, _a673))
task.wait(0.4)
else
_a670 = _a675
end
end
end
end
return _a669, _a670
end
function _a19.useFlag(_a676)
if not _a17.R_Flag then return 0, "FlexibleFlags_Consume 리모트 없음" end
local _a677, _a678 = 0, nil
for _a679, _a680 in ipairs(_a19.stacks("Misc")) do
if _a677 >= (_a676 or 1) then break end
if _a680.id:lower():find("flag", 1, true) and _a680.am >= 1 and _a19.itemAllowed(_a680.id) then
local _a681, _a682
pcall(function() _a681, _a682 = _a17.R_Flag:InvokeServer(_a680.id, _a680.uid, 1) end)
if _a681 then _a677 += 1 task.wait(0.4) else _a678 = _a682 end
end
end
return _a677, _a678
end
function _a19.useFruit(_a683)
if not _a17.R_Fruit then return 0, "Fruits: Consume 리모트 없음" end
local _a684 = _a19.activeBuffs("Fruits")
local _a685 = 0
for _a686, _a687 in ipairs(_a19.stacks("Fruit")) do
if _a685 >= (_a683 or 1) then break end
if _a687.am >= 1 and _a19.itemAllowed(_a687.id) and not _a684[_a687.id] then
pcall(function() _a17.R_Fruit:FireServer(_a687.uid, 1) end)
_a685 += 1
task.wait(0.4)
end
end
return _a685
end
function _a19.status()
local _a688 = _a46()
if not _a688 then return nil end
local _a689 = rawget(_a688, "Goals")
if type(_a689) ~= "table" then return { list = {} } end
local _a690 = {}
for _a691, _a692 in pairs(_a689) do
if type(_a692) == "table" then
local _a693 = tonumber(rawget(_a692, "Type")) or -1
local _a694
if _a17.Quest and rawget(_a17.Quest, "MakeTitle") then
local _a695, _a696 = pcall(_a17.Quest.MakeTitle, _a692)
if _a695 then _a694 = _a696 end
end
_a690[#_a690 + 1] = {
slot = _a691,
uid = tostring(rawget(_a692, "UID")),
type = _a693,
how = _a18[_a693],
title = _a694 or ("Type " .. _a693),
amount = tonumber(rawget(_a692, "Amount")) or 0,
progress = tonumber(rawget(_a692, "Progress")) or 0,
stars = tonumber(rawget(_a692, "Stars")) or 0,
potionTier = tonumber(rawget(_a692, "PotionTier")),
enchantTier = tonumber(rawget(_a692, "EnchantTier")),
breakable = rawget(_a692, "BreakableType") or rawget(_a692, "BreakableDirID"),
zoneId = rawget(_a692, "ZoneID"),
where = _a19.WHERE[_a693] or (_a18[_a693] == "farm" and "bestzone" or nil),
event = _a19.EVENTKIND[_a693],
chest = _a19.CHESTKIND[_a693],
bestOnly = _a19.BESTONLY[_a693] or false,
ignored = _a19.IGNORE[_a693],
}
end
end
table.sort(_a690, function(_a697, _a698) return _a697.stars > _a698.stars end)
return { list = _a690, rank = tonumber(rawget(_a688, "Rank")) or 1,
rankStars = tonumber(rawget(_a688, "RankStars")) or 0 }
end
_a19.BESTDEP = {
[20]=true, [21]=true, [37]=true, [38]=true, [39]=true,
[43]=true, [44]=true, [76]=true,
}
function _a19.bestDepActive()
local _a699 = _a19.lockGoal and _a19.lockGoal.q
if not _a699 then return false end
if _a19.IGNORE[_a699.type] then return false end
if not _a19.BESTDEP[_a699.type] then return false end
local _a700 = _a19.findQuest(_a699.uid)
if not _a700 or _a700.progress >= _a700.amount then return false end
return true, _a700
end
function _a19.canDo(_a701, _a702)
if _a701.how == "hatch" or _a701.where == "bestegg" then
local _a703 = _a112()
if not _a703 then return false, "알 정보를 못 읽음" end
if not _a703.price then return true end
if not _a702 then
if _a703.canBuy < 1 then
return false, ("돈 부족 — %s 개당 %s %s / 보유 %s"):format(
tostring(_a703.id), _a6(_a703.price, 0), tostring(_a703.currency), _a6(_a703.have, 0))
end
return true
end
local _a704 = math.max(1, (_a701.amount or 1) - (_a701.progress or 0))
local _a705 = _a704
if _a701.type == 2 or _a701.type == 42 or _a701.type == 47 then
_a705 = math.max(_a704, _a11.HatchMinAfford or 10)
end
if _a703.canBuy < _a705 then
_a19.moneyUntil = os.clock() + math.max(0, _a11.MoneyDwell or 60)
return false, ("돈 모으는 중 — %d개분 필요 / 지금 %d개분 (개당 %s %s)"):format(
_a705, _a703.canBuy, _a6(_a703.price, 0), tostring(_a703.currency))
end
if _a19.moneyUntil and os.clock() < _a19.moneyUntil then
return false, ("조금 더 벌고 감 (%.0f초 남음)"):format(_a19.moneyUntil - os.clock())
end
_a19.moneyUntil = nil
end
return true
end
function _a19.findQuest(_a706)
local _a707 = _a19.status()
for _a708, _a709 in ipairs(_a707 and _a707.list or {}) do
if _a709.uid == _a706 then return _a709 end
end
return nil
end
function _a19.pursue(_a710)
local _a711, _a712
if _a710.how == "hatch" then _a711, _a712 = _a123, "mhatch"
elseif _a710.how == "zone" then _a711, _a712 = _a82, "zone"
elseif _a710.how == "gold" or _a710.how == "rainbow" then
local _a713 = (_a710.type == 40 or _a710.type == 41)
_a712 = "quest"
_a711 = function()
local _a714 = _a19.makeVariant("gold", _a713) or 0
if _a710.how == "rainbow" then
_a714 += (_a19.makeVariant("rainbow", _a713) or 0)
end
if _a714 > 0 then
_a19.setAct(_a710.how == "gold" and "골드 합성" or "레인보우 합성", _a714 .. "마리")
return
end
_a19.setAct("재료 모으는 중", "최고 알 부화")
local _a715 = _a12.mhatch
_a12.mhatch = true
pcall(_a123)
_a12.mhatch = _a715
end
end
local _a716 = _a710.progress
local _a717 = os.clock()
_a19.setGoal(_a710.title, ("%d/%d"):format(_a710.progress, _a710.amount))
local function _a718()
if not _a710.event then return end
local _a719 = _a19.findEvent(_a710.event, _a710.bestOnly)
if _a719 then
_a19.setAct(_a710.event .. " 진행 중", ("%d초 남음"):format(_a719.left))
if _a719.pos then
local _a720 = _a19.hrp()
if _a720 and (_a720.Position - _a719.pos).Magnitude > (_a11.EventStayDist or 45) then
_a19.glideTo(_a719.pos)
end
end
return
end
local _a721, _a722 = _a19.spawnEvent(_a710.event)
if _a721 > 0 then
_a19.setAct("소환", _a710.event)
task.wait(0.5)
elseif _a722 and _a19.spawnErr ~= tostring(_a722) then
_a19.spawnErr = tostring(_a722)
_a5("[퀘스트] " .. _a710.event .. " 소환 실패: " .. tostring(_a722))
end
end
local _a723, _a724 = pcall(function()
while _a12.quest and not _a19.stopped() do
local _a725, _a726 = _a19.canDo(_a710, false)
if not _a725 then
_a5(("[퀘스트] %s → 다른 퀘스트 먼저 (%s)"):format(tostring(_a710.title), tostring(_a726)))
return
end
_a718()
if _a711 then
local _a727 = _a12[_a712]
_a12[_a712] = true
local _a728, _a729 = pcall(_a711)
_a12[_a712] = _a727
if not _a728 then error(_a729, 0) end
elseif _a710.event then
task.wait(0.4)
else
task.wait(2)
end
local _a730 = _a19.findQuest(_a710.uid)
if not _a730 then
_a5("[퀘스트] 완료 — " .. tostring(_a710.title))
return
end
_a19.setGoal(_a730.title, ("%d/%d"):format(_a730.progress, _a730.amount))
if _a730.progress >= _a730.amount then
_a5(("[퀘스트] 달성 %d/%d — %s"):format(_a730.progress, _a730.amount, tostring(_a730.title)))
return
end
if _a730.progress > _a716 then
_a717 = os.clock()
_a5(("[퀘스트] %d/%d  %s"):format(_a730.progress, _a730.amount, tostring(_a730.title)))
end
_a716 = _a730.progress
local _a731 = os.clock() - _a717
if _a731 >= math.max(10, _a11.PursueStallSec or 60) then
_a5(("[퀘스트] %.0f초째 진행 없음 (%d/%d) — 다음 단계로: %s"):format(
_a731, _a730.progress, _a730.amount, tostring(_a730.title)))
return
end
task.wait(0.2)
end
end)
if not _a723 then _a5("[퀘스트] " .. tostring(_a710.how) .. " 오류: " .. tostring(_a724)) end
_a19.lockGoal = nil
_a19.setGoal(nil)
end
function _a19.cycle()
do
local _a732 = _a12.rank
_a12.rank = true
pcall(_a173)
_a12.rank = _a732
end
local _a733 = _a19.status()
if not _a733 then return end
local _a734, _a735, _a736 = false, false, false
local _a737 = {}
local _a738 = nil
for _a739, _a740 in ipairs(_a733.list) do
if not _a12.quest then break end
local _a741, _a742 = true, nil
if not _a740.ignored and _a740.progress < _a740.amount then
_a741, _a742 = _a19.canDo(_a740, true)
end
if _a740.ignored then
if _a740.progress < _a740.amount then
_a737[#_a737 + 1] = tostring(_a740.title) .. "  — " .. _a740.ignored
end
elseif not _a741 then
local _a743 = tostring(_a740.uid) .. tostring(_a742)
if _a19.skipSaid ~= _a743 then
_a19.skipSaid = _a743
_a5(("[퀘스트] 건너뜀: %s   (%s)"):format(tostring(_a740.title), tostring(_a742)))
end
elseif _a740.progress < _a740.amount then
local _a744 = _a740.where
if _a740.event then
if not _a738 or _a738.rank > 0 then _a738 = { rank = 0, kind = "event", q = _a740 } end
elseif _a740.chest then
if not _a738 or _a738.rank > 1 then _a738 = { rank = 1, kind = "chest", q = _a740 } end
elseif _a744 == "bestegg" then
if not _a738 or _a738.rank > 1 then _a738 = { rank = 1, kind = "egg", q = _a740 } end
elseif _a744 == "breakable" and _a740.breakable then
if not _a738 or _a738.rank > 2 then _a738 = { rank = 2, kind = "breakable", q = _a740 } end
elseif _a744 == "zoneid" and _a740.zoneId then
if not _a738 or _a738.rank > 2 then _a738 = { rank = 2, kind = "zoneid", q = _a740 } end
elseif _a744 == "bestzone" or _a744 == "breakable" then
if not _a738 then _a738 = { rank = 3, kind = "bestzone", q = _a740 } end
end
if _a740.how == "farm" then
_a734 = true
elseif _a740.how == "hatch" then
_a735 = true
elseif _a740.how == "zone" then
_a736 = true
elseif _a740.how == "potup" and _a11.QuestUpgrade then
local _a745, _a746 = _a19.upgradeTo("Potion", _a740.potionTier or 2)
if _a745 > 0 then
_a13.potup += _a745
_a13.quest += 1
_a5(("[퀘스트] 포션 T%d %d개 제작  (%s)"):format(_a740.potionTier or 2, _a745, _a740.title))
elseif _a746 and not tostring(_a746):find("부족") then
if _a19.potUpSaid ~= tostring(_a746) then
_a19.potUpSaid = tostring(_a746)
_a5("[퀘스트] 포션 업글 실패: " .. tostring(_a746))
end
end
elseif _a740.how == "encup" and _a11.QuestUpgrade then
local _a747, _a748 = _a19.upgradeTo("Enchant", _a740.enchantTier or 2)
if _a747 > 0 then
_a13.potup += _a747
_a13.quest += 1
_a5(("[퀘스트] 인챈트 T%d %d개 제작  (%s)"):format(_a740.enchantTier or 2, _a747, _a740.title))
elseif _a748 and not tostring(_a748):find("부족") then
if _a19.encUpSaid ~= tostring(_a748) then
_a19.encUpSaid = tostring(_a748)
_a5("[퀘스트] 인챈트 업글 실패: " .. tostring(_a748))
end
end
elseif _a740.how == "potuse" and _a11.QuestUsePotion then
_a19.lastUse = _a19.lastUse or {}
local _a749 = _a19.lastUse[_a740.uid]
if _a749 and _a749.used > 0 and _a740.progress <= _a749.progress then
if not _a749.gaveUp then
_a749.gaveUp = true
_a5("[퀘스트] 포션을 마셔도 진행도가 안 올라서 중단: " .. tostring(_a740.title))
end
else
local _a750 = math.min(_a11.QuestUseMax, math.max(1, _a740.amount - _a740.progress))
local _a751, _a752 = _a19.usePotion(_a740.potionTier or 1, _a750)
_a19.lastUse[_a740.uid] = { used = _a751, progress = _a740.progress }
if _a751 > 0 then
_a13.potuse += _a751
_a13.quest += 1
_a5(("[퀘스트] 포션 %d개 사용  (%s)"):format(_a751, _a740.title))
elseif _a752 and not tostring(_a752):find("없음") then
_a5("[퀘스트] 포션 사용 실패: " .. tostring(_a752))
end
end
elseif _a740.how == "gold" or _a740.how == "rainbow" then
local _a753, _a754 = _a19.makeVariant(_a740.how, _a740.type == 40 or _a740.type == 41)
if _a753 > 0 then
_a13.quest += 1
_a5(("[퀘스트] %s 펫 %d마리 제작  (%s)"):format(
_a740.how == "gold" and "골드" or "레인보우", _a753, _a740.title))
elseif _a754 then
_a5("[퀘스트] " .. _a740.how .. " 실패: " .. tostring(_a754))
end
elseif _a740.how == "fruituse" then
local _a755 = _a19.useFruit(math.max(1, _a740.amount - _a740.progress))
if _a755 > 0 then
_a13.quest += 1
_a5(("[퀘스트] 과일 %d개 사용  (%s)"):format(_a755, _a740.title))
end
elseif _a740.how == "flaguse" then
local _a756, _a757 = _a19.useFlag(math.max(1, _a740.amount - _a740.progress))
if _a756 > 0 then
_a13.quest += 1
_a5(("[퀘스트] 깃발 %d개 사용  (%s)"):format(_a756, _a740.title))
elseif _a757 then
_a5("[퀘스트] 깃발 실패: " .. tostring(_a757))
end
elseif not _a740.how then
_a737[#_a737 + 1] = _a740.title
end
end
end
if _a11.QuestLock and _a19.lockGoal then
local _a758
for _a759, _a760 in ipairs(_a733.list) do
if _a760.uid == _a19.lockGoal.q.uid and _a760.progress < _a760.amount then _a758 = _a760 break end
end
if _a758 then
_a19.lockGoal.q = _a758
_a738 = _a19.lockGoal
else
if _a19.lockGoal.q then
_a5("[퀘스트] 완료/교체됨 → 다음 목표로: " .. tostring(_a19.lockGoal.q.title))
end
_a19.lockGoal = nil
end
end
if _a11.QuestLock and _a738 then _a19.lockGoal = _a738 end
if _a11.QuestTp and _a738 and _a12.quest then
local _a761, _a762, _a763
if _a738.kind == "event" then
local _a764 = _a19.findEvent(_a738.q.event, _a738.q.bestOnly)
if _a764 then
_a763 = ("%s @%s (%d초 남음)"):format(_a764.name, tostring(_a764.zone), _a764.left)
if _a764.pos then _a761, _a762 = _a19.glideTo(_a764.pos)
else _a761, _a762 = _a19.goToZone(_a764.zone) end
else
local _a765 = _a738.q.bestOnly and _a19.bestZone() or (_a19.curZone() or _a19.bestZone())
_a763 = _a738.q.event .. " 소환용 " .. tostring(_a765)
local _a766 = _a19.inDottedBox()
_a761, _a762 = _a19.goToZone(_a765, false, _a766 == false, _a738.q.bestOnly)
if _a761 then
local _a767, _a768 = _a19.spawnEvent(_a738.q.event)
if _a767 < 1 and tostring(_a768):find("점선") then
_a19.goToZone(_a765, false, true)
task.wait(0.2)
_a767, _a768 = _a19.spawnEvent(_a738.q.event)
end
if _a767 > 0 then
_a763 = ("%s %d개 소환 @%s"):format(_a738.q.event, _a767, tostring(_a765))
else
_a762 = _a768
_a761 = false
end
end
end
elseif _a738.kind == "chest" then
local _a769 = _a738.q.bestOnly and _a19.bestZone() or _a19.curZone()
local _a770, _a771 = _a19.findChest(_a738.q.chest, _a769)
_a763 = _a738.q.chest .. " @" .. tostring(_a769)
if _a770 then
if not _a771 or _a771 > 20 then _a19.glideTo(_a770) end
_a761 = true
else
_a761, _a762 = _a19.goToZone(_a769)
_a763 = _a763 .. " (상자 없음 → 존 가운데)"
end
elseif _a738.kind == "egg" then
local _a772 = _a87()
_a763 = "최고 알 " .. tostring(_a772)
if _a772 then _a761, _a762 = _a19.tpEgg(_a772) else _a762 = "최고 알을 못 찾음" end
elseif _a738.kind == "breakable" then
local _a773 = _a19.zoneForBreakable(_a738.q.breakable)
_a763 = tostring(_a738.q.breakable) .. " 나오는 존 " .. tostring(_a773)
if _a773 then _a761, _a762 = _a19.goToZone(_a773, true) else _a762 = "그 브레이커블이 나오는 존이 없음" end
elseif _a738.kind == "zoneid" then
_a763 = "존 " .. tostring(_a738.q.zoneId)
_a761, _a762 = _a19.goToZone(_a738.q.zoneId)
else
local _a774 = _a19.bestZone()
local _a775 = _a738.q.bestOnly or _a19.BESTDEP[_a738.q.type] or false
if _a774 then _a761, _a762 = _a19.goToZone(_a774, true, false, _a775)
else _a762 = "최고 존을 못 찾음" end
_a763 = "최고 존 " .. tostring(_a19.arrivedZone or _a774)
if not _a761 then _a762 = _a774 end
end
if _a761 then
if _a19.lastGoal ~= _a763 then
_a19.lastGoal = _a763
_a5("[퀘스트] " .. _a763 .. " 으로 이동  (" .. tostring(_a738.q.title) .. ")")
end
_a19.pursue(_a738.q)
else
local _a776 = _a762 and tostring(_a762) or "이유 불명"
if _a19.lastFail ~= _a776 then
_a19.lastFail = _a776
_a5(("[퀘스트] 진행 못 함: %s   (%s / %s)"):format(
_a776, tostring(_a738.kind), tostring(_a738.q.title)))
_a5(("           현재 존 %s / 최고 존 %s / 점선네모 %s"):format(
tostring(_a19.curZone()), tostring(_a19.bestZone()), tostring(_a19.inDottedBox())))
end
end
end
if _a11.QuestDrive and _a19.turnOn then
if _a734  then _a19.turnOn("farm",   "파밍 퀘스트 → 자동 파밍") end
if _a736  then _a19.turnOn("zone",   "존 퀘스트 → 자동 존 해금") end
if _a735 then _a19.turnOn("mhatch", "부화 퀘스트 → 자동 부화") end
end
if #_a737 > 0 and not _a19.manualWarned then
_a19.manualWarned = true
_a5("[퀘스트] 수동으로 해야 하는 것:")
for _a777, _a778 in ipairs(_a737) do _a5("    · " .. tostring(_a778)) end
elseif #_a737 == 0 then
_a19.manualWarned = false
end
return _a738 ~= nil
end
local function _a779(_a780)
local _a781 = {}
for _a782 in tostring(_a780 or ""):gmatch("[^,]+") do
_a782 = _a782:match("^%s*(.-)%s*$")
if _a782 ~= "" then _a781[#_a781 + 1] = _a782:lower() end
end
return _a781
end
function _a19.itemAllowed(_a783)
local _a784 = tostring(_a783):lower()
for _a785, _a786 in ipairs(_a779(_a11.ItemBlock)) do
if _a784:find(_a786, 1, true) then return false end
end
local _a787 = _a779(_a11.ItemAllow)
if #_a787 == 0 then return true end
for _a788, _a789 in ipairs(_a787) do
if _a784:find(_a789, 1, true) then return true end
end
return false
end
function _a19.activeBuffs(_a790)
local _a791 = _a46()
local _a792 = _a791 and rawget(_a791, _a790)
local _a793 = {}
if type(_a792) == "table" then
for _a794, _a795 in pairs(_a792) do
if type(_a795) == "table" and next(_a795) then _a793[_a794] = true
elseif _a795 then _a793[_a794] = true end
end
end
return _a793
end
local function _a796(_a797, _a798, _a799, _a800)
local _a801 = _a19.activeBuffs(_a798)
local _a802 = {}
local _a803 = { total = 0, act = 0, blocked = 0, few = 0, ok = 0 }
for _a804, _a805 in ipairs(_a19.stacks(_a797)) do
_a803.total += 1
if _a801[_a805.id] then _a803.act += 1
elseif not _a19.itemAllowed(_a805.id) then _a803.blocked += 1
elseif _a805.am <= _a11.ItemKeep then _a803.few += 1
else
_a803.ok += 1
local _a806 = _a802[_a805.id]
local _a807
if not _a806 then _a807 = true
elseif _a11.BuffHighTier then _a807 = _a805.tier > _a806.tier
else _a807 = _a805.tier < _a806.tier end
if _a807 then _a802[_a805.id] = _a805 end
end
end
if _a803.ok == 0 and _a803.total > 0 then
local _a808 = ("%s %d종 중 사용 가능 0 (이미걸림 %d / 제외 %d / 재고부족 %d)")
:format(_a797, _a803.total, _a803.act, _a803.blocked, _a803.few)
if _a19.buffSaid ~= _a808 then
_a19.buffSaid = _a808
_a5("[아이템] " .. _a808)
end
elseif _a803.ok > 0 then
_a19.buffSaid = nil
end
local _a809 = {}
for _a810, _a811 in pairs(_a802) do _a809[#_a809 + 1] = _a811 end
table.sort(_a809, function(_a812, _a813)
if _a812.tier ~= _a813.tier then return _a812.tier > _a813.tier end
return _a812.am > _a813.am
end)
local _a814 = {}
for _a815, _a816 in ipairs(_a809) do
if not _a12.items then break end
if _a800 and _a800.left <= 0 then break end
local _a817 = pcall(function() _a799(_a816.uid, 1) end)
if _a817 then
_a814[#_a814 + 1] = ("%s T%d"):format(_a816.id, _a816.tier)
_a13.items += 1
if _a800 then _a800.left -= 1 end
task.wait(0.12)
end
end
return _a814
end
function _a19.cycleItems()
local function _a818()
local _a819 = {}
if _a11.BuffPotion then _a819[#_a819 + 1] = { "Potion", "Potions" } end
if _a11.BuffFruit then _a819[#_a819 + 1] = { "Fruit", "Fruits" } end
if _a11.BuffConsumable then _a819[#_a819 + 1] = { "Consumable", "Consumables" } end
for _a820, _a821 in ipairs(_a819) do
local _a822 = _a19.activeBuffs(_a821[2])
for _a823, _a824 in ipairs(_a19.stacks(_a821[1])) do
if _a824.am > _a11.ItemKeep and _a19.itemAllowed(_a824.id) and not _a822[_a824.id] then
return true
end
end
end
if _a11.BuffUltimate and _a17.R_Ult then
local _a825 = _a46()
local _a826 = _a825 and rawget(_a825, "Ultimates")
if type(_a826) == "table" then
for _a827 in pairs(_a826) do
if _a19.itemAllowed(_a827) then
if not (_a17.Ult and rawget(_a17.Ult, "IsCharged")) then return true end
local _a828, _a829 = pcall(_a17.Ult.IsCharged, _a827)
if _a828 and _a829 then return true end
end
end
end
end
return false
end
if not _a818() then return end
if _a11.ItemBestZone then
local _a830 = _a19.bestZone()
if _a830 and _a19.curZone() ~= _a830 then
if not _a11.ItemTp then
if not _a19.itemZoneWarned then
_a19.itemZoneWarned = true
_a5(("[아이템] 최고 존(%s)이 아니라 대기 — 현재 %s"):format(
tostring(_a830), tostring(_a19.curZone())))
end
return
end
local _a831, _a832 = _a19.goToZone(_a830)
if not _a831 then
_a5("[아이템] 최고 존 이동 실패: " .. tostring(_a832))
return
end
_a5("[아이템] 최고 존 " .. tostring(_a830) .. " 에서 사용")
end
_a19.itemZoneWarned = false
end
local _a833 = {}
local _a834  = { left = math.max(1, _a11.BuffMaxPotion or 5) }
local _a835 = { left = math.max(1, _a11.BuffMaxOther or 2) }
if _a11.BuffPotion and _a17.R_PotUse then
local _a836 = _a796("Potion", "Potions", function(_a837, _a838)
_a17.R_PotUse:FireServer(_a837, _a838)
end, _a834)
for _a839, _a840 in ipairs(_a836) do _a833[#_a833 + 1] = "포션 " .. _a840 end
end
if _a11.BuffFruit and _a17.R_Fruit then
local _a841 = _a796("Fruit", "Fruits", function(_a842, _a843)
_a17.R_Fruit:FireServer(_a842, _a843)
end, _a835)
for _a844, _a845 in ipairs(_a841) do _a833[#_a833 + 1] = "과일 " .. _a845 end
end
if _a11.BuffConsumable and _a17.R_Cons then
local _a846 = _a796("Consumable", "Consumables", function(_a847, _a848)
_a17.R_Cons:InvokeServer(_a847, _a848)
end, _a835)
for _a849, _a850 in ipairs(_a846) do _a833[#_a833 + 1] = "소모품 " .. _a850 end
end
if _a11.BuffUltimate and _a17.R_Ult then
local _a851 = _a46()
local _a852 = _a851 and rawget(_a851, "Ultimates")
if type(_a852) == "table" then
for _a853 in pairs(_a852) do
if not _a12.items then break end
if _a19.itemAllowed(_a853) then
local _a854 = true
if _a17.Ult and rawget(_a17.Ult, "IsCharged") then
local _a855, _a856 = pcall(_a17.Ult.IsCharged, _a853)
_a854 = _a855 and _a856 and true or false
end
if _a854 then
local _a857
pcall(function() _a857 = _a17.R_Ult:InvokeServer(_a853) end)
if _a857 then
_a833[#_a833 + 1] = "얼티밋 " .. tostring(_a853)
_a13.items += 1
task.wait(0.3)
end
end
end
end
end
end
if #_a833 > 0 then
_a19.setAct("버프 사용", table.concat(_a833, ", "))
_a5("[아이템] " .. table.concat(_a833, ", ") .. " 사용")
end
end
function _a19.slotStatus()
local _a858 = _a46()
if not _a858 then return nil end
local _a859 = tonumber(rawget(_a858, "PetSlotsPurchased")) or 0
local _a860 = tonumber(rawget(_a858, "EggSlotsPurchased")) or 0
local _a861, _a862 = 0, 0
if _a17.RankC then
if rawget(_a17.RankC, "GetMaxPurchasableEquipSlots") then
local _a863, _a864 = pcall(_a17.RankC.GetMaxPurchasableEquipSlots)
if _a863 and tonumber(_a864) then _a861 = tonumber(_a864) end
end
if rawget(_a17.RankC, "GetMaxPurchasableEggSlots") then
local _a865, _a866 = pcall(_a17.RankC.GetMaxPurchasableEggSlots)
if _a865 and tonumber(_a866) then _a862 = tonumber(_a866) end
end
end
local _a867, _a868
if _a859 < _a861 then
_a867 = _a859 + 1
if type(_a17.CalcPetS) == "function" then
local _a869, _a870 = pcall(_a17.CalcPetS, _a867)
if _a869 then _a868 = tonumber(_a870) end
end
end
local _a871, _a872, _a873
if _a860 < _a862 and _a17.RankC and rawget(_a17.RankC, "GetEggBundle") then
local _a874, _a875, _a876 = pcall(_a17.RankC.GetEggBundle, _a860 + 1)
if _a874 and tonumber(_a875) then
_a871, _a872 = tonumber(_a875), tonumber(_a876) or 1
if type(_a17.CalcEggS) == "function" then
local _a877, _a878 = 0, false
for _a879 = _a871 - _a872 + 1, _a871 do
local _a880, _a881 = pcall(_a17.CalcEggS, _a879)
if _a880 and tonumber(_a881) then _a877 += tonumber(_a881) else _a878 = true end
end
if not _a878 then _a873 = _a877 end
end
end
end
local _a882
if _a17.Egg and rawget(_a17.Egg, "GetMaxHatch") then
local _a883, _a884 = pcall(_a17.Egg.GetMaxHatch)
if _a883 then _a882 = tonumber(_a884) end
end
return {
dia = _a54("Diamonds"),
petOwned = _a859, petMax = _a861, petNext = _a867, petCost = _a868,
eggOwned = _a860, eggMax = _a862, eggEnd = _a871, eggSize = _a872, eggCost = _a873,
maxEquip = tonumber(rawget(_a858, "MaxPetsEquipped")), maxHatch = _a882,
}
end
function _a19.machinePos(_a885)
local _a886
if _a17.Machine and rawget(_a17.Machine, "GetModels") then
local _a887, _a888 = pcall(_a17.Machine.GetModels, _a885)
if _a887 and type(_a888) == "table" then
for _a889, _a890 in pairs(_a888) do
if typeof(_a890) == "Instance" then _a886 = _a890 break end
end
end
end
if not _a886 then
local _a891, _a892 = pcall(function()
return game:GetService("CollectionService"):GetTagged("Machine")
end)
if _a891 then
for _a893, _a894 in ipairs(_a892) do
if _a894.Name == _a885 then _a886 = _a894 break end
end
end
end
if not _a886 then return nil end
if _a886:IsA("BasePart") then return _a886.Position end
local _a895, _a896 = pcall(function() return _a886:GetPivot() end)
return (_a895 and typeof(_a896) == "CFrame") and _a896.Position or nil
end
function _a19.cycleSlots()
local _a897 = 0
local _a898 = 0
while _a12.slots and not _a19.stopped() and _a898 < 40 do
_a898 += 1
local _a899 = _a19.slotStatus()
if not _a899 then return end
local _a900 = _a11.SlotPet and _a899.petNext and _a899.petCost
and (_a899.dia - _a11.SlotReserve) >= _a899.petCost
local _a901 = _a11.SlotEgg and _a899.eggEnd and _a899.eggCost
and (_a899.dia - _a11.SlotReserve) >= _a899.eggCost
if _a900 and _a901 then
if _a899.eggCost < _a899.petCost then _a900 = false else _a901 = false end
end
if not (_a900 or _a901) then break end
local _a902, _a903, _a904, _a905
local function _a906()
if _a900 then
pcall(function() _a902, _a903 = _a17.R_PetSlot:InvokeServer(_a899.petNext) end)
else
pcall(function() _a902, _a903 = _a17.R_EggSlot:InvokeServer(_a899.eggEnd) end)
end
end
if _a900 then
_a904 = ("펫 장착 슬롯 #%d (%s 다이아)"):format(_a899.petNext, _a6(_a899.petCost, 0))
_a905 = "EquipSlotsMachine"
else
_a904 = ("알 부화 슬롯 %d칸 → %d (%s 다이아)"):format(
_a899.eggSize, _a899.eggEnd, _a6(_a899.eggCost, 0))
_a905 = "EggSlotsMachine"
end
_a906()
if not _a902 and tostring(_a903):find("far away") then
local _a907 = _a19.machinePos(_a905)
if _a907 then
_a19.setAct("슬롯 머신으로 이동", _a905)
_a19.glideTo(_a907)
task.wait(0.25)
_a902, _a903 = nil, nil
_a906()
else
_a903 = "머신 위치를 못 찾음 (" .. _a905 .. ")"
end
end
if _a902 then
_a897 += 1
_a13.mslot += 1
_a19.slotSaid = nil
_a19.setAct("슬롯 구매", _a904)
_a5("  ⬆ " .. _a904)
task.wait(0.35)
else
local _a908 = _a904 .. " 실패: " .. tostring(_a903)
if _a19.slotSaid ~= _a908 then
_a19.slotSaid = _a908
_a5("[슬롯] " .. _a908)
end
break
end
end
if _a897 > 0 then
local _a909 = _a19.slotStatus()
_a5(("[슬롯] %d개 구매 — 장착 %s / 한번에 %s개 부화 (다이아 %s 남음)"):format(
_a897, tostring(_a909 and _a909.maxEquip), tostring(_a909 and _a909.maxHatch),
_a6(_a54("Diamonds"), 0)))
end
end
function _a19.upgList()
local _a910 = {}
if not _a17.Upg then return _a910 end
local _a911, _a912 = pcall(_a17.Upg.All)
if not (_a911 and type(_a912) == "table") then return _a910 end
for _a913, _a914 in ipairs(_a912) do
local _a915, _a916, _a917 = rawget(_a914, "UpgradeID"), rawget(_a914, "ZoneID"), rawget(_a914, "UpgradeTier")
if _a915 and _a916 and _a917 then
local _a918 = false
if rawget(_a17.Upg, "Owns") then
local _a919, _a920 = pcall(_a17.Upg.Owns, _a915, _a916)
_a918 = _a919 and _a920 and true or false
end
local _a921 = _a19.ownsZone(_a916)
local _a922 = _a17.DirUpg and rawget(_a17.DirUpg, _a915)
local _a923 = _a922 and rawget(_a922, "TierCosts")
local _a924 = _a923 and tonumber(_a923[_a917])
local _a925 = "Diamonds"
local _a926 = _a922 and rawget(_a922, "TierCurrencies")
local _a927 = _a926 and _a926[_a917]
if type(_a927) == "table" and rawget(_a927, "_id") then _a925 = rawget(_a927, "_id") end
local _a928 = rawget(_a914, "Model")
local _a929
if typeof(_a928) == "Instance" then
if _a928:IsA("BasePart") then _a929 = _a928.Position
else
local _a930, _a931 = pcall(function() return _a928:GetPivot() end)
if _a930 and _a931 then _a929 = _a931.Position end
end
end
_a910[#_a910 + 1] = {
id = _a915, zone = _a916, tier = _a917, cost = _a924, cur = _a925,
bought = _a918, zoneOwned = _a921,
buyable = _a921 and not _a918,
pos = _a929, model = _a928,
}
end
end
table.sort(_a910, function(_a932, _a933) return (_a932.cost or math.huge) < (_a933.cost or math.huge) end)
return _a910
end
function _a19.cycleUpg()
if not _a17.R_Upg then _a5("[맵업글] Upgrades_Purchase 리모트 없음") return end
local _a934 = _a19.upgList()
if #_a934 == 0 then return end
local _a935 = 0
for _a936, _a937 in ipairs(_a934) do
if not _a12.mapupg then break end
if _a937.buyable and _a937.cost then
local _a938 = _a54(_a937.cur or "Diamonds")
if _a938 - _a11.UpgReserve < _a937.cost then break end
if _a11.UpgTp and _a937.pos and _a937.zone == _a19.curZone() then
_a19.glideTo(_a937.pos)
end
local _a939, _a940
pcall(function() _a939, _a940 = _a17.R_Upg:InvokeServer(_a937.id, _a937.zone) end)
if _a939 then
_a935 += 1
_a13.mapupg += 1
_a19.setAct("맵 업글", _a937.id .. " T" .. _a937.tier)
_a5(("  ▲ 맵업글  %s T%d  @%s   (%s 다이아)"):format(
_a937.id, _a937.tier, _a937.zone, _a6(_a937.cost, 0)))
elseif _a940 then
_a5(("[맵업글] %s T%d @%s 실패: %s"):format(
_a937.id, _a937.tier, _a937.zone, tostring(_a940)))
end
task.wait(_a11.ActionGap)
end
end
if _a935 > 0 then
_a5(("[맵업글] %d개 구매  (다이아 %s 남음)"):format(_a935, _a6(_a54("Diamonds"), 0)))
end
end
local function _a941()
local _a942 = _a46()
if not _a942 then return nil end
local _a943 = tonumber(rawget(_a942, "Rebirths")) or 0
local _a944 = _a943 + 1
local _a945
if _a17.Rebirth and rawget(_a17.Rebirth, "GetNextRebirth") then
local _a946, _a947 = pcall(_a17.Rebirth.GetNextRebirth, _a942)
if _a946 then _a945 = _a947 end
end
return { current = _a943, nextN = _a944, def = _a945 }
end
local function _a948()
if not _a17.R_Reb then _a5("[리버스] Rebirth_Request 리모트 없음") return end
local _a949 = _a941()
if not _a949 then
_a19.rebNote = "세이브를 못 읽음"
return
end
local _a950, _a951
pcall(function() _a950, _a951 = _a17.R_Reb:InvokeServer(_a949.nextN) end)
if _a950 then
_a13.mreb += 1
_a19.rebNote, _a19.rebSaid = nil, nil
_a5(("  ★ 리버스 %d → %d"):format(_a949.current, _a949.nextN))
task.wait(0.5)
_a19.dismissRewardScreens(25)
else
_a19.rebNote = ("%d → %d : %s"):format(_a949.current, _a949.nextN,
_a951 and tostring(_a951) or "조건 미달 (리버스 킬/존 요구치)")
if _a19.rebSaid ~= _a19.rebNote then
_a19.rebSaid = _a19.rebNote
_a5("[리버스] " .. _a19.rebNote)
end
end
end
_a19.SIDE = {
{ key = "unlock", label = "알 해금",   run = "mhatch", fn = function() _a19.unlockEggs() end },
{ key = "slots",  label = "슬롯 머신", run = "slots",  fn = function() _a19.cycleSlots() end },
{ key = "mapupg", label = "맵 업그레이드", run = "mapupg", fn = function() _a19.cycleUpg() end },
{ key = "items",  label = "버프 유지",     run = "items",  fn = function() _a19.cycleItems() end },
}
_a19.STEPS = {
{ key = "mreb",   label = "리버스",  run = "mreb",  fn = function() _a948() end,
hold = true },
{ key = "zone",   label = "존 해금", run = "zone",  fn = function() _a82() end,
hold = true },
{ key = "quest",  label = "랭크 퀘스트+보상", run = "quest", fn = function()
local _a952 = _a12.farm
_a12.farm = true
pcall(_a64)
_a12.farm = _a952
local _a953 = _a19.cycle()
if not _a953 then
local _a954 = _a19.bestZone()
if _a954 then
local _a955, _a956 = _a19.goToZone(_a954)
if not _a955 then
if _a956 and _a19.idleMoveSaid ~= tostring(_a956) then
_a19.idleMoveSaid = tostring(_a956)
_a5("[자동] 최고 존 이동 실패: " .. tostring(_a956))
end
else
_a19.idleMoveSaid = nil
end
end
if not _a11.IdleHatch then
_a19.setAct("파밍 중", ("퀘스트 없음 @%s"):format(tostring(_a19.curZone())))
return false
end
local _a957 = _a112()
local _a958 = math.max(1, _a11.HatchMinAfford or 10)
if _a957 and _a957.price and _a957.canBuy < _a958 then
_a19.setAct("돈 버는 중", ("%s  %d/%d개분  개당 %s %s"):format(
tostring(_a19.curZone()), _a957.canBuy, _a958,
_a6(_a957.price, 0), tostring(_a957.currency)))
else
_a19.setAct("대기 중 부화")
local _a959 = _a12.mhatch
_a12.mhatch = true
pcall(_a123)
_a12.mhatch = _a959
end
end
end },
}
_a11.StepOn = {}
for _a960, _a961 in ipairs(_a19.SIDE) do _a11.StepOn[_a961.key] = true end
for _a962, _a963 in ipairs(_a19.STEPS) do _a11.StepOn[_a963.key] = true end
local function _a964(_a965, _a966, _a967, _a968)
if not _a11.StepOn[_a965.key] then
_a968[#_a968 + 1] = ("%-14s 꺼져있음"):format(_a965.label)
return
end
if _a965.hold and _a966 then
_a968[#_a968 + 1] = ("%-14s 보류 (%s)"):format(
_a965.label, _a967 and tostring(_a967.title) or "?")
if _a19.heldMsg ~= _a965.key then
_a19.heldMsg = _a965.key
_a5(("[자동] %s 보류 — best 존이 바뀌면 깨지는 퀘스트 진행 중 (%s)"):format(
_a965.label, _a967 and tostring(_a967.title) or "?"))
end
return
end
if _a965.hold then _a19.heldMsg = nil end
_a19.step = _a965.label
_a19.now.step = _a965.label
_a19.setAct("시작", _a965.label)
local _a969 = os.clock()
local _a970 = _a12[_a965.run]
_a12[_a965.run] = true
local _a971, _a972 = pcall(_a965.fn)
_a12[_a965.run] = _a970
local _a973 = os.clock() - _a969
if not _a971 then
_a968[#_a968 + 1] = ("%-14s 오류: %s"):format(_a965.label, tostring(_a972))
_a5("[자동] " .. _a965.label .. " 오류: " .. tostring(_a972))
else
local _a974 = (_a965.key == "zone" and _a19.zoneNote)
or (_a965.key == "mreb" and _a19.rebNote) or nil
_a968[#_a968 + 1] = ("%-14s 실행 %.1f초%s"):format(
_a965.label, _a973, _a974 and ("  → " .. _a974) or "")
end
end
function _a19.master()
local _a975 = {}
_a19.lastTrace = _a975
_a19.lastPassAt = os.clock()
if _a19.rewardScreenUp() then
_a975[#_a975 + 1] = "보상 화면 넘기는 중"
_a19.dismissRewardScreens(15)
end
for _a976, _a977 in ipairs(_a19.SIDE) do
if not _a12.auto or _a19.stopped() then return end
_a964(_a977, false, nil, _a975)
end
local _a978, _a979 = false, nil
if _a11.HoldZoneForQuest then _a978, _a979 = _a19.bestDepActive() end
for _a980, _a981 in ipairs(_a19.STEPS) do
if not _a12.auto or _a19.stopped() then break end
_a964(_a981, _a978, _a979, _a975)
end
_a19.step = nil
if not _a19.lockGoal then
_a19.now.step = "대기"
_a19.setAct("다음 바퀴 대기", ("%.0f초 주기"):format(_a11.AutoInterval or 5))
end
end
local function _a982()
if not _a10.R_PROMO then _a5("[타워업글] 리모트 없음") return end
local _a983 = _a14()
if not _a983 then return end
local _a984 = _a15(_a983)
table.sort(_a984, function(_a985, _a986) return (_a985.dps or 0) > (_a986.dps or 0) end)
local _a987, _a988 = 0, 0
for _a989, _a990 in ipairs(_a984) do
if not _a12.towerup then break end
if _a990.id then
local _a991
pcall(function() _a991 = _a10.R_PROMO:InvokeServer(_a990.id) end)
if _a991 ~= nil and _a991 ~= false then
_a987 += 1
_a5(("  ▲ 타워업글  %s  Lv%s → Lv%s"):format(tostring(_a990.kind), tostring(_a990.up), tostring((_a990.up or 0) + 1)))
_a988 = 0
task.wait(_a11.ActionGap)
else
_a988 += 1
if _a988 >= 5 then break end
end
end
end
_a5("[타워업글] " .. _a987 .. "건")
end
local _a992 = {}
local function _a993(_a994, _a995, _a996, _a997)
_a992[_a994] = (_a992[_a994] or 0) + 1
local _a998 = _a992[_a994]
task.spawn(function()
while _a12[_a994] and _a992[_a994] == _a998 do
local _a999, _a1000 = pcall(_a996)
if not _a999 then _a5("[" .. _a997 .. " 오류] " .. tostring(_a1000)) end
local _a1001, _a1002 = _a995(), 0
while _a1002 < _a1001 and _a12[_a994] and _a992[_a994] == _a998 do task.wait(0.1) _a1002 += 0.1 end
end
if _a992[_a994] == _a998 then _a5("[" .. _a997 .. "] 중지") end
end)
end
do
local _a1003 = {
farm   = { function() return _a11.FarmInterval end,      function() _a64() end,      "파밍" },
zone   = { function() return _a11.ZoneInterval end,      function() _a82() end,      "존" },
mhatch = { function() return _a11.MainHatchInterval end, function() _a123() end, "부화" },
}
function _a19.turnOn(_a1004, _a1005)
if _a12.auto then return end
if _a12[_a1004] then return end
local _a1006 = _a1003[_a1004]
if not _a1006 then return end
_a12[_a1004] = true
_a993(_a1004, _a1006[1], _a1006[2], _a1006[3])
if _a19.refresh then _a19.refresh() end
_a5("[퀘스트] " .. tostring(_a1005) .. " ON")
end
end
_a1.MG, _a1.QS, _a1.saveGet, _a1.currencyAmount, _a1.cycleFarm, _a1.zoneStatus = _a17, _a19, _a46, _a54, _a64, _a78
_a1.cycleZone, _a1.bestMainEgg, _a1.mainHatchStatus, _a1.cycleMainHatch, _a1.mainRebirthStatus, _a1.cycleMainRebirth = _a82, _a87, _a112, _a123, _a941, _a948
_a1.cycleTowerUp, _a1.startLoop = _a982, _a993
end
