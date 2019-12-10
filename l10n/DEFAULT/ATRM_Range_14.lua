
local function range_14()
  range_14_menu:Remove()
  range_14_menu_sam_menu = MENU_MISSION_COMMAND:New("Activate Anti Air at Range 14",range_root_menu13_18,range_14_SAMs)
  local direction = math.random(1,2)
  local firstinterval = math.random(60,180)

  range14_eastenemies =
    {
      "T14_1_EAST_OPT_1",
      "T14_1_EAST_OPT_2",
      "T14_1_EAST_OPT_3",
      "T14_1_EAST_OPT_4",
      "T14_1_EAST_OPT_5",
    }

  function range_14_eastspawner()
    env.info("tableindex is "..#range14_eastenemies)
    if #range14_eastenemies == 0
    then
      eastspawn_scheduler:Stop()
    end
    local optionenemyeast = math.random(1,#range14_eastenemies)
    for i,template in ipairs(range14_eastenemies) do
      if i ==  optionenemyeast and #range14_eastenemies >0 then
        SPAWN:New(template):Spawn()
        env.info("spawning "..template)
        table.remove(range14_eastenemies,optionenemyeast)
      end
    end
  end
  if direction == 1 then
    range14_northenemies =
      {"T14_1_NORTH_OPT_1",
        "T14_1_NORTH_OPT_2",
        "T14_1_NORTH_OPT_3",
        "T14_1_NORTH_OPT_4",
        "T14_1_NORTH_OPT_5",
        "T14_1_NORTH_OPT_6",
        "T14_1_NORTH_OPT_7",
        "T14_1_NORTH_OPT_8",
      }

    function range_14_northspawner()
      env.info("tableindex is "..#range14_northenemies)
      if #range14_northenemies == 0
      then
        northspawn_scheduler:Stop()
      end
      local optionenemynorth = math.random(1,#range14_northenemies)
      for i,template in ipairs(range14_northenemies) do
        if i ==  optionenemynorth and #range14_northenemies >0 then
          local _group = SPAWN:New(template)
          if template=="T14_1_NORTH_OPT_4"
          then
            _group:OnSpawnGroup(function(_group)
              local _unit = _group:GetUnit(1)
              local explosiontester = SCHEDULER:New(nil,function()
                env.info("checking for zone")
                local R14_FOB = ZONE:New("R14_FOB")
                if _group:IsCompletelyInZone(R14_FOB)
                then
                  _unit:Explode(1000)
                end
              end,{},10*60,10)
            end)
          end
          _group:Spawn()
          env.info("spawning "..template)
          table.remove(range14_northenemies,optionenemynorth)
        end
      end
    end
  else

    range14_southenemies =
      {"T14_1_SOUTH_OPT_1",
        "T14_1_SOUTH_OPT_2",
        "T14_1_SOUTH_OPT_3",
        "T14_1_SOUTH_OPT_4",
        "T14_1_SOUTH_OPT_5",
        "T14_1_SOUTH_OPT_6",
      }

    function range_14_southspawner()
      env.info("tableindex is "..#range14_southenemies)
      if #range14_southenemies == 0
      then
        southspawn_scheduler:Stop()
      end
      local optionenemysouth = math.random(1,#range14_southenemies)
      for i,template in ipairs(range14_southenemies) do

        if i ==  optionenemysouth and #range14_southenemies >0 then
          local _group = SPAWN:New(template)
          if template=="T14_1_SOUTH_OPT_6"
          then
            _group:OnSpawnGroup(function(_group)
              local _unit = _group:GetUnit(1)
              local explosiontester = SCHEDULER:New(nil,function()
                local R14_FOB = ZONE:New("R14_FOB")
                if _group:IsCompletelyInZone(R14_FOB)
                then
                  _unit:Explode(1000)
                end
              end,{},10*60,10)
            end)
          end
          _group:Spawn()
          env.info("spawning "..template)
          table.remove(range14_southenemies,optionenemysouth)
        end
      end
    end
  end

  local firstspawn = math.random(60,180)
  local firstspawn_east = math.random(90,250)
  local followingspawns = math.random(150,500)
  friendlyspawn = math.random(240,1500)
  eastspawn_scheduler = SCHEDULER:New(nil,range_14_eastspawner,{},firstspawn_east,followingspawns)
  local followingspawns = math.random(150,560)
  local firstspawn = math.random(30,180)
  if direction == 1 then direction = "North"
    friendlysouthscheduler = SCHEDULER:New(nil, function()
      SPAWN:New("T14_1_FR_SOUTH"):Spawn()
      friendlysouthscheduler:Stop()
    end, {},friendlyspawn, 120)

    friendlysouthscheduler:Start()
    northspawn_scheduler = SCHEDULER:New(nil,range_14_northspawner,{},firstspawn,followingspawns)
  else direction = "South"
    friendlynorthscheduler = SCHEDULER:New(nil, function()
      SPAWN:New("T14_1_FR_NORTH"):Spawn()
      friendlynorthscheduler:Stop()
    end, {},friendlyspawn, 120)
    friendlynorthscheduler:Start()
    southspawn_scheduler = SCHEDULER:New(nil,range_14_southspawner,{},firstspawn,followingspawns)
  end
  env.info("Direction of Enemy advancing is "..direction)
end

function range_14_SAMs()
  range_14_menu_sam_menu:Remove()
  local range_14_SAMs_option = math.random(1,3)
  if range_14_SAMs_option == 1 then
    SPAWN:New("Threat_site_14"):Spawn()
  elseif range_14_SAMs_option == 2 then
    SPAWN:New("Threat_site_13"):Spawn()
  elseif range_14_SAMs_option == 3 then
    SPAWN:New("Threat_site_15"):Spawn()
  end
end

range_14_menu = MENU_MISSION_COMMAND:New("Activate Range 14",range_root_menu13_18,range_14)

