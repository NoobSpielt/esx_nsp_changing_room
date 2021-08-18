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
{x=118.51, y=-232.19, z=53.62},

{x=-700.57, y=-151.93, z=36.48},

{x=71.23, y=-1387.74, z=28.44},

{x=-170.44, y=-296.6, z=38.79},

{x=429.69, y=-811.49, z=28.55},

{x=-820.05, y=-1067.45, z=10.39},

{x=-1446.49, y=-245.9, z=48.88},

{x=3.89, y=6506.05, z=30.94},

{x=1698.76, y=4818.12, z=41.12},

{x=617.44, y=2774.91, z=41.15},

{x=1201.99, y=2714.27, z=37.27},

{x=-1181.16, y=-764.22, z=16.38},

{x=-3179.21, y=1034.35, z=19.92},

{x=-1100.32, y=2717.35, z=18.17}

}

for i=1, #Config.Rooms, 1 do

	Config.Zones['Rooms_' .. i] = {
	 	Pos   = Config.Rooms[i],
	 	Size  = Config.MarkerSize,
	 	Color = Config.MarkerColor,
	 	Type  = Config.MarkerType
  }

end
