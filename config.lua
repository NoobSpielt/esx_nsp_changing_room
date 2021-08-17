Config = {}
Config.Locale = {},{} -- dont touch thanks

Config.Locale = 'en'

Config.DrawDistance = 100.0
Config.MarkerSize   = {x = 1.5, y = 1.5, z = 1.0}
Config.MarkerColor  = {r = 102, g = 102, b = 204}
Config.MarkerType   = 27

Config.Zones = {}

Config.Rooms = {
  {x=4817.49,    y=-5038.54, z=32.3},

}

for i=1, #Config.Rooms, 1 do

	Config.Zones['Rooms_' .. i] = {
	 	Pos   = Config.Rooms[i],
	 	Size  = Config.MarkerSize,
	 	Color = Config.MarkerColor,
	 	Type  = Config.MarkerType
  }

end
