ESX = nil
local GUI, CurrentActionData = {}, {}
GUI.Time = 0
local LastZone, CurrentAction, CurrentActionMsg
local HasPayed, HasLoadCloth, HasAlreadyEnteredMarker = false, false, false

Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function _L(str)
    if not Locales then return "Locale error" end
    if not Locales[Config.Locale] then return "Invalid locale" end
    if not Locales[Config.Locale][str] then return "Invalid string" end
    return Locales[Config.Locale][str]
end

function OpenDressingMenu()
  local elements = {}

  table.insert(elements, {label = _U('player_clothes'), value = 'player_dressing'})
  table.insert(elements, {label = _U('delete_cloth'), value = 'delete_cloth'})

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dressing_main', {
      title    = _U('clothes_main_menu'),
      align    = 'top-left',
      elements = elements,
    }, function(data, menu)
	menu.close()


      if data.current.value == 'player_dressing' then
		
        ESX.TriggerServerCallback('esx_nsp_changing_room:getPlayerDressing', function(dressing)
          local elements = {}

          for i=1, #dressing, 1 do
            table.insert(elements, {label = dressing[i], value = i})
          end

          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
              title    = _U('player_clothes'),
              align    = 'top-left',
              elements = elements,
            }, function(data, menu)

              TriggerEvent('skinchanger:getSkin', function(skin)

                ESX.TriggerServerCallback('esx_nsp_changing_room:getPlayerOutfit', function(clothes)

                  TriggerEvent('skinchanger:loadClothes', skin, clothes)
                  TriggerEvent('esx_skin:setLastSkin', skin)

                  TriggerEvent('skinchanger:getSkin', function(skin)
                    TriggerServerEvent('esx_skin:save', skin)
                  end)
				  
 ESX.ShowNotification(_L("clothes_changed")) 

				  HasLoadCloth = true
                end, data.current.value)
              end)
            end, function(data, menu)
              menu.close()
			  
			  CurrentAction     = 'clothes_menu'
			  CurrentActionMsg  = _U('press_menu')
			  CurrentActionData = {}
            end
          )
        end)
      end
	  if data.current.value == 'delete_cloth' then
		ESX.TriggerServerCallback('esx_nsp_changing_room:getPlayerDressing', function(dressing)
			local elements = {}

			for i=1, #dressing, 1 do
				table.insert(elements, {label = dressing[i], value = i})
			end
			
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'supprime_cloth', {
              title    = _U('delete_cloth'),
              align    = 'top-left',
              elements = elements,
            }, function(data, menu)
			menu.close()
				TriggerServerEvent('esx_nsp_changing_room:deleteOutfit', data.current.value)
 ESX.ShowNotification(_L("deleted_cloth")) 
            end, function(data, menu)
              menu.close()
			  
			  CurrentAction     = 'clothes_menu'
			  CurrentActionMsg  = _U('press_menu')
			  CurrentActionData = {}
            end)
		end)
	  end
    end, function(data, menu)

      menu.close()

      CurrentAction     = 'room_menu'
      CurrentActionMsg  = _U('press_menu')
      CurrentActionData = {}
    end)
end

AddEventHandler('esx_nsp_changing_room:hasEnteredMarker', function(zone)
	CurrentAction     = 'clothes_menu'
	CurrentActionMsg  = _U('press_menu')
	CurrentActionData = {}
end)

Citizen.CreateThread(function()
	while true do

		Wait(0)

		local coords = GetEntityCoords(GetPlayerPed(-1))

		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do

		Wait(0)

		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_nsp_changing_room:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_nsp_changing_room:hasExitedMarker', LastZone)
		end
	end
end)

Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlPressed(0,  38) and (GetGameTimer() - GUI.Time) > 300 then

				if CurrentAction == 'clothes_menu' then
					OpenDressingMenu()
				end

				CurrentAction = nil
				GUI.Time      = GetGameTimer()
			end
		end
	end
end)
