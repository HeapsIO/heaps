package hxd.snd.effect;

class ReverbPreset {
	public var room              : Float;
	public var roomHF            : Float;
	public var roomRolloffFactor : Float;
	public var decayTime         : Float;
	public var decayHFRatio      : Float;
	public var reflections       : Float;
	public var reflectionsDelay  : Float;
	public var reverb            : Float;
	public var reverbDelay       : Float;
	public var diffusion         : Float;
	public var density           : Float;
	public var hfReference       : Float;

	public function new( 
		room              : Float,
		roomHF            : Float,
		roomRolloffFactor : Float,
		decayTime         : Float,
		decayHFRatio      : Float,
		reflections       : Float,
		reflectionsDelay  : Float,
		reverb            : Float,
		reverbDelay       : Float,
		diffusion         : Float,
		density           : Float,
		hfReference       : Float
	) {
		this.room              = room;
		this.roomHF            = roomHF;
		this.roomRolloffFactor = roomRolloffFactor;
		this.decayTime         = decayTime;
		this.decayHFRatio      = decayHFRatio;
		this.reflections       = reflections;
		this.reflectionsDelay  = reflectionsDelay;
		this.reverb            = reverb;
		this.reverbDelay       = reverbDelay;
		this.diffusion         = diffusion;
		this.density           = density;
		this.hfReference       = hfReference;
	}

	public static var DEFAULT                   = new ReverbPreset(-1000,  -100, 0.0,  1.49, 0.83,  -2602, 0.007,   200, 0.011, 100.0, 100.0,  5000.0);
	public static var GENERIC                   = new ReverbPreset(-1000,  -100, 0.0,  1.49, 0.83,  -2602, 0.007,   200, 0.011, 100.0, 100.0,  5000.0);
	public static var PADDEDCELL                = new ReverbPreset(-1000, -6000, 0.0,  0.17, 0.10,  -1204, 0.001,   207, 0.002, 100.0, 100.0,  5000.0);
	public static var ROOM                      = new ReverbPreset(-1000,  -454, 0.0,  0.40, 0.83,  -1646, 0.002,    53, 0.003, 100.0, 100.0,  5000.0);
	public static var BATHROOM                  = new ReverbPreset(-1000, -1200, 0.0,  1.49, 0.54,   -370, 0.007,  1030, 0.011, 100.0,  60.0,  5000.0);
	public static var LIVINGROOM                = new ReverbPreset(-1000, -6000, 0.0,  0.50, 0.10,  -1376, 0.003, -1104, 0.004, 100.0, 100.0,  5000.0);
	public static var STONEROOM                 = new ReverbPreset(-1000,  -300, 0.0,  2.31, 0.64,   -711, 0.012,    83, 0.017, 100.0, 100.0,  5000.0);
	public static var AUDITORIUM                = new ReverbPreset(-1000,  -476, 0.0,  4.32, 0.59,   -789, 0.020,  -289, 0.030, 100.0, 100.0,  5000.0);
	public static var CONCERTHALL               = new ReverbPreset(-1000,  -500, 0.0,  3.92, 0.70,  -1230, 0.020,    -2, 0.029, 100.0, 100.0,  5000.0);
	public static var CAVE                      = new ReverbPreset(-1000,     0, 0.0,  2.91, 1.30,   -602, 0.015,  -302, 0.022, 100.0, 100.0,  5000.0);
	public static var ARENA                     = new ReverbPreset(-1000,  -698, 0.0,  7.24, 0.33,  -1166, 0.020,    16, 0.030, 100.0, 100.0,  5000.0);
	public static var HANGAR                    = new ReverbPreset(-1000, -1000, 0.0, 10.05, 0.23,   -602, 0.020,   198, 0.030, 100.0, 100.0,  5000.0);
	public static var CARPETEDHALLWAY           = new ReverbPreset(-1000, -4000, 0.0,  0.30, 0.10,  -1831, 0.002, -1630, 0.030, 100.0, 100.0,  5000.0);
	public static var HALLWAY                   = new ReverbPreset(-1000,  -300, 0.0,  1.49, 0.59,  -1219, 0.007,   441, 0.011, 100.0, 100.0,  5000.0);
	public static var STONECORRIDOR             = new ReverbPreset(-1000,  -237, 0.0,  2.70, 0.79,  -1214, 0.013,   395, 0.020, 100.0, 100.0,  5000.0);
	public static var ALLEY                     = new ReverbPreset(-1000,  -270, 0.0,  1.49, 0.86,  -1204, 0.007,    -4, 0.011, 100.0, 100.0,  5000.0);
	public static var FOREST                    = new ReverbPreset(-1000, -3300, 0.0,  1.49, 0.54,  -2560, 0.162,  -613, 0.088,  79.0, 100.0,  5000.0);
	public static var CITY                      = new ReverbPreset(-1000,  -800, 0.0,  1.49, 0.67,  -2273, 0.007, -2217, 0.011,  50.0, 100.0,  5000.0);
	public static var MOUNTAINS                 = new ReverbPreset(-1000, -2500, 0.0,  1.49, 0.21,  -2780, 0.300, -2014, 0.100,  27.0, 100.0,  5000.0);
	public static var QUARRY                    = new ReverbPreset(-1000, -1000, 0.0,  1.49, 0.83, -10000, 0.061,   500, 0.025, 100.0, 100.0,  5000.0);
	public static var PLAIN                     = new ReverbPreset(-1000, -2000, 0.0,  1.49, 0.50,  -2466, 0.179, -2514, 0.100,  21.0, 100.0,  5000.0);
	public static var PARKINGLOT                = new ReverbPreset(-1000,     0, 0.0,  1.65, 1.50,  -1363, 0.008, -1153, 0.012, 100.0, 100.0,  5000.0);
	public static var SEWERPIPE                 = new ReverbPreset(-1000, -1000, 0.0,  2.81, 0.14,    429, 0.014,   648, 0.021,  80.0,  60.0,  5000.0);
	public static var UNDERWATER                = new ReverbPreset(-1000, -4000, 0.0,  1.49, 0.10,   -449, 0.007,  1700, 0.011, 100.0, 100.0,  5000.0);

	// converted from EFX
	public static var DRUGGED                   = new ReverbPreset(-1000,     0, 0.0,  8.39, 1.39,   -115, 0.002,   985, 0.03,   50.0, 42.87,  5000.0);
	public static var DIZZY                     = new ReverbPreset(-1000,  -400, 0.0, 17.23, 0.56,  -1713,  0.02,  -613, 0.03,   60.0, 36.45,  5000.0);
	public static var PSYCHOTIC                 = new ReverbPreset(-1000,  -151, 0.0,  7.56, 0.91,   -626,  0.02,   774, 0.03,   50.0,  6.25,  5000.0);
	public static var CASTLE_SMALLROOM          = new ReverbPreset(-1000,  -800, 0.0,  1.22, 0.83,   -100, 0.022,   600, 0.011,  89.0, 100.0,  5168.6);
	public static var CASTLE_SHORTPASSAGE       = new ReverbPreset(-1000, -1000, 0.0,  2.32, 0.83,   -100, 0.007,   200, 0.023,  89.0, 100.0,  5168.6);
	public static var CASTLE_MEDIUMROOM         = new ReverbPreset(-1000, -1100, 0.0,  2.04, 0.83,   -400, 0.022,   400, 0.011,  93.0, 100.0,  5168.6);
	public static var CASTLE_LARGEROOM          = new ReverbPreset(-1000, -1100, 0.0,  2.53, 0.83,   -700, 0.034,   200, 0.016,  82.0, 100.0,  5168.6);
	public static var CASTLE_LONGPASSAGE        = new ReverbPreset(-1000,  -800, 0.0,  3.42, 0.83,   -100, 0.007,   300, 0.023,  89.0, 100.0,  5168.6);
	public static var CASTLE_HALL               = new ReverbPreset(-1000, -1100, 0.0,  3.14, 0.79,  -1500, 0.056,   100, 0.024,  81.0, 100.0,  5168.6);
	public static var CASTLE_CUPBOARD           = new ReverbPreset(-1000, -1100, 0.0,  0.67, 0.87,    300,  0.01,  1100, 0.007,  89.0, 100.0,  5168.6);
	public static var CASTLE_COURTYARD          = new ReverbPreset(-1000,  -700, 0.0,  2.13, 0.61,  -1300,  0.16,  -300, 0.036,  42.0, 100.0,  5000.0);
	public static var CASTLE_ALCOVE             = new ReverbPreset(-1000,  -600, 0.0,  1.64, 0.87,      0, 0.007,   300, 0.034,  89.0, 100.0,  5168.6);
	public static var FACTORY_SMALLROOM         = new ReverbPreset(-1000,  -200, 0.0,  1.72, 0.65,   -300,  0.01,   500, 0.024,  82.0, 36.45,  3762.6);
	public static var FACTORY_SHORTPASSAGE      = new ReverbPreset(-1200,  -200, 0.0,  2.53, 0.65,    0.0,  0.01,   200, 0.038,  64.0, 36.45,  3762.6);
	public static var FACTORY_MEDIUMROOM        = new ReverbPreset(-1200,  -200, 0.0,  2.76, 0.65,  -1100, 0.022,   300, 0.023,  82.0, 42.87,  3762.6);
	public static var FACTORY_LARGEROOM         = new ReverbPreset(-1200,  -300, 0.0,  4.24, 0.51,  -1500, 0.039,   100, 0.023,  75.0, 42.87,  3762.6);
	public static var FACTORY_LONGPASSAGE       = new ReverbPreset(-1200,  -200, 0.0,  4.06, 0.65,      0,  0.02,   200, 0.037,  64.0, 36.45,  3762.6);
	public static var FACTORY_HALL              = new ReverbPreset(-1000,  -300, 0.0,  7.43, 0.51,  -2400, 0.073,  -100, 0.027,  75.0, 42.87,  3762.6);
	public static var FACTORY_CUPBOARD          = new ReverbPreset(-1200,  -200, 0.0,  0.49, 0.65,    200,  0.01,   600, 0.032,  63.0, 30.71,  3762.6);
	public static var FACTORY_COURTYARD         = new ReverbPreset(-1000, -1000, 0.0,  2.32, 0.29,  -1300,  0.14,  -800, 0.039,  57.0, 30.71,  3762.6);
	public static var FACTORY_ALCOVE            = new ReverbPreset(-1200,  -200, 0.0,  3.14, 0.65,    300,  0.01,     0, 0.038,  59.0, 36.45,  3762.6);
	public static var ICEPALACE_SMALLROOM       = new ReverbPreset(-1000,  -500, 0.0,  1.51, 1.53,   -100,  0.01,   300, 0.011,  84.0, 100.0, 12428.5);
	public static var ICEPALACE_SHORTPASSAGE    = new ReverbPreset(-1000,  -500, 0.0,  1.79, 1.46,   -600,  0.01,   100, 0.019,  75.0, 100.0, 12428.5);
	public static var ICEPALACE_MEDIUMROOM      = new ReverbPreset(-1000,  -500, 0.0,  2.22, 1.53,   -800, 0.039,   100, 0.027,  87.0, 100.0, 12428.5);
	public static var ICEPALACE_LARGEROOM       = new ReverbPreset(-1000,  -500, 0.0,  3.14, 1.53,  -1200, 0.039,     0, 0.027,  81.0, 100.0, 12428.5);
	public static var ICEPALACE_LONGPASSAGE     = new ReverbPreset(-1000,  -500, 0.0,  3.01, 1.46,   -200, 0.012,   200, 0.025,  77.0, 100.0, 12428.5);
	public static var ICEPALACE_HALL            = new ReverbPreset(-1000,  -700, 0.0,  5.49, 1.53,  -1900, 0.054,  -400, 0.052,  76.0, 100.0, 12428.5);
	public static var ICEPALACE_CUPBOARD        = new ReverbPreset(-1000,  -600, 0.0,  0.76, 1.53,    100, 0.012,   600, 0.016,  83.0, 100.0, 12428.5);
	public static var ICEPALACE_COURTYARD       = new ReverbPreset(-1000, -1100, 0.0,  2.04, 1.2,   -1000, 0.173, -1000, 0.043,  59.0, 100.0, 12428.5);
	public static var ICEPALACE_ALCOVE          = new ReverbPreset(-1000,  -500, 0.0,  2.76, 1.46,    100,  0.01,  -100,  0.03,  84.0, 100.0, 12428.5);
	public static var SPACESTATION_SMALLROOM    = new ReverbPreset(-1000,  -300, 0.0,  1.72, 0.82,   -200, 0.007,   300, 0.013,  70.0, 21.09,  3316.1);
	public static var SPACESTATION_SHORTPASSAGE = new ReverbPreset(-1000,  -400, 0.0,  3.57, 0.5,       0, 0.012,   100, 0.016,  87.0, 21.09,  3316.1);
	public static var SPACESTATION_MEDIUMROOM   = new ReverbPreset(-1000,  -400, 0.0,  3.01, 0.5,    -800, 0.034,   100, 0.035,  75.0, 21.09,  3316.1);
	public static var SPACESTATION_LARGEROOM    = new ReverbPreset(-1000,  -400, 0.0,  3.89, 0.38,  -1000, 0.056,  -100, 0.035,  81.0, 36.45,  3316.1);
	public static var SPACESTATION_LONGPASSAGE  = new ReverbPreset(-1000,  -400, 0.0,  4.62, 0.62,      0, 0.012,   200, 0.031,  82.0, 42.87,  3316.1);
	public static var SPACESTATION_HALL         = new ReverbPreset(-1000,  -400, 0.0,  7.11, 0.38,  -1500,   0.1,  -400, 0.047,  87.0, 42.87,  3316.1);
	public static var SPACESTATION_CUPBOARD     = new ReverbPreset(-1000,  -300, 0.0,  0.79, 0.81,    300, 0.007,   500, 0.018,  56.0, 17.15,  3316.1);
	public static var SPACESTATION_ALCOVE       = new ReverbPreset(-1000,  -300, 0.0,  1.16, 0.81,    300, 0.007,     0, 0.018,  78.0, 21.09,  3316.1);
	public static var WOODEN_SMALLROOM          = new ReverbPreset(-1000, -1900, 0.0,  0.79, 0.32,      0, 0.032,  -100, 0.029, 100.0, 100.0,  4705.0);
	public static var WOODEN_SHORTPASSAGE       = new ReverbPreset(-1000, -1800, 0.0,  1.75, 0.5,    -100, 0.012,  -400, 0.024, 100.0, 100.0,  4705.0);
	public static var WOODEN_MEDIUMROOM         = new ReverbPreset(-1000, -2000, 0.0,  1.47, 0.42,   -100, 0.049,  -100, 0.029, 100.0, 100.0,  4705.0);
	public static var WOODEN_LARGEROOM          = new ReverbPreset(-1000, -2100, 0.0,  2.65, 0.33,   -100, 0.066,  -200, 0.049, 100.0, 100.0,  4705.0);
	public static var WOODEN_LONGPASSAGE        = new ReverbPreset(-1000, -2000, 0.0,  1.99, 0.4,       0,  0.02,  -700, 0.036, 100.0, 100.0,  4705.0);
	public static var WOODEN_HALL               = new ReverbPreset(-1000, -2200, 0.0,  3.45, 0.3,    -100, 0.088,  -200, 0.063, 100.0, 100.0,  4705.0);
	public static var WOODEN_CUPBOARD           = new ReverbPreset(-1000, -1700, 0.0,  0.56, 0.46,    100, 0.012,   100, 0.028, 100.0, 100.0,  4705.0);
	public static var WOODEN_COURTYARD          = new ReverbPreset(-1000, -2200, 0.0,  1.79, 0.35,   -500, 0.123, -2000, 0.032,  65.0, 100.0,  4705.0);
	public static var WOODEN_ALCOVE             = new ReverbPreset(-1000, -1800, 0.0,  1.22, 0.62,    100, 0.012,  -300, 0.024, 100.0, 100.0,  4705.0);
	public static var SPORT_EMPTYSTADIUM        = new ReverbPreset(-1000,  -700, 0.0,  6.26, 0.51,  -2400, 0.183,  -800, 0.038, 100.0, 100.0,  5000.0);
	public static var SPORT_SQUASHCOURT         = new ReverbPreset(-1000, -1000, 0.0,  2.22, 0.91,   -700, 0.007,  -200, 0.011,  75.0, 100.0,  7176.9);
	public static var SPORT_SMALLSWIMMINGPOOL   = new ReverbPreset(-1000,  -200, 0.0,  2.76, 1.25,   -400,  0.02,  -200, 0.03,   70.0, 100.0,  5000.0);
	public static var SPORT_LARGESWIMMINGPOOL   = new ReverbPreset(-1000,  -200, 0.0,  5.49, 1.31,   -700, 0.039,  -600, 0.049,  82.0, 100.0,  5000.0);
	public static var SPORT_GYMNASIUM           = new ReverbPreset(-1000,  -700, 0.0,  3.14, 1.06,   -800, 0.029,  -500, 0.045,  81.0, 100.0,  7176.9);
	public static var SPORT_FULLSTADIUM         = new ReverbPreset(-1000, -2300, 0.0,  5.25, 0.17,  -2000, 0.188, -1100, 0.038, 100.0, 100.0,  5000.0);
	public static var SPORT_STADIUMTANNOY       = new ReverbPreset(-1000,  -500, 0.0,  2.53, 0.88,  -1100,  0.23,  -600, 0.063,  78.0, 100.0,  5000.0);
	public static var PREFAB_WORKSHOP           = new ReverbPreset(-1000, -1700, 0.0,  0.76,  1.0,      0, 0.012,   100, 0.012, 100.0, 42.87,  5000.0);
	public static var PREFAB_SCHOOLROOM         = new ReverbPreset(-1000,  -400, 0.0,  0.98, 0.45,    300, 0.017,   300, 0.015,  69.0, 40.22,  7176.9);
	public static var PREFAB_PRACTISEROOM       = new ReverbPreset(-1000,  -800, 0.0,  1.12, 0.56,    200,  0.01,   300, 0.011,  87.0, 40.22,  7176.9);
	public static var PREFAB_OUTHOUSE           = new ReverbPreset(-1000, -1900, 0.0,  1.38, 0.38,   -100, 0.024,  -400, 0.044,  82.0, 100.0,  2854.4);
	public static var PREFAB_CARAVAN            = new ReverbPreset(-1000, -2100, 0.0,  0.43, 1.5,       0, 0.012,   600, 0.012, 100.0, 100.0,  5000.0);
	public static var DOME_TOMB                 = new ReverbPreset(-1000,  -900, 0.0,  4.18, 0.21,   -825,  0.03,   450, 0.022,  79.0, 100.0,  2854.4);
	public static var PIPE_SMALL                = new ReverbPreset(-1000,  -900, 0.0,  5.04, 0.1,    -600, 0.032,   800, 0.015, 100.0, 100.0,  2854.4);
	public static var DOME_SAINTPAULS           = new ReverbPreset(-1000,  -900, 0.0, 10.48, 0.19,  -1500,  0.09,   200, 0.042,  87.0, 100.0,  2854.4);
	public static var PIPE_LONGTHIN             = new ReverbPreset(-1000,  -700, 0.0,  9.21, 0.18,   -300,  0.01,  -300, 0.022,  91.0,  25.6,  2854.4);
	public static var PIPE_LARGE                = new ReverbPreset(-1000,  -900, 0.0,  8.45, 0.1,    -800, 0.046,   400, 0.032, 100.0, 100.0,  2854.4);
	public static var PIPE_RESONANT             = new ReverbPreset(-1000,  -700, 0.0,  6.81, 0.18,   -300,  0.01,     0, 0.022,  91.0, 13.73,  2854.4);
	public static var OUTDOORS_BACKYARD         = new ReverbPreset(-1000, -1200, 0.0,  1.12, 0.34,   -700, 0.069,  -300, 0.023,  45.0, 100.0,  4399.1);
	public static var OUTDOORS_ROLLINGPLAINS    = new ReverbPreset(-1000, -3902, 0.0,  2.13, 0.21,  -1500,   0.3,  -700, 0.019,   0.0, 100.0,  4399.1);
	public static var OUTDOORS_DEEPCANYON       = new ReverbPreset(-1000, -1500, 0.0,  3.89, 0.21,  -1000, 0.223,  -900, 0.019,  74.0, 100.0,  4399.1);
	public static var OUTDOORS_CREEK            = new ReverbPreset(-1000, -1500, 0.0,  2.13, 0.21,   -800, 0.115, -1400, 0.031,  35.0, 100.0,  4399.1);
	public static var OUTDOORS_VALLEY           = new ReverbPreset(-1000, -3100, 0.0,  2.88, 0.26,  -1700, 0.263,  -800,   0.1,  28.0, 100.0,  2854.4);
	public static var MOOD_HEAVEN               = new ReverbPreset(-1000,  -200, 0.0,  5.04, 1.12,  -1230,  0.02,   200, 0.029,  94.0, 100.0,  5000.0);
	public static var MOOD_HELL                 = new ReverbPreset(-1000,  -900, 0.0,  3.57, 0.49, -10000,  0.02,   300,  0.03,  57.0, 100.0,  5000.0);
	public static var MOOD_MEMORY               = new ReverbPreset(-1000,  -400, 0.0,  4.06, 0.82,  -2800,   0.0,   100,   0.0,  85.0, 100.0,  5000.0);
	public static var DRIVING_COMMENTATOR       = new ReverbPreset(-1000,  -500, 0.0,  2.42, 0.88,  -1400, 0.093, -1200, 0.017,   0.0, 100.0,  5000.0);
	public static var DRIVING_PITGARAGE         = new ReverbPreset(-1000,  -300, 0.0,  1.72, 0.93,   -500,   0.0,   200, 0.016,  59.0, 42.87,  5000.0);
	public static var DRIVING_INCAR_RACER       = new ReverbPreset(-1000,     0, 0.0,  0.17, 2.0,     500, 0.007,  -300, 0.015,  80.0,  8.32, 10268.2);
	public static var DRIVING_INCAR_SPORTS      = new ReverbPreset(-1000,  -400, 0.0,  0.17, 0.75,      0,  0.01,  -500,   0.0,  80.0,  8.32, 10268.2);
	public static var DRIVING_INCAR_LUXURY      = new ReverbPreset(-1000, -2000, 0.0,  0.13, 0.41,   -200,  0.01,   400,  0.01, 100.0,  25.6, 10268.2);
	public static var DRIVING_FULLGRANDSTAND    = new ReverbPreset(-1000, -1100, 0.0,  3.01, 1.37,   -900,  0.09, -1500, 0.049, 100.0, 100.0, 10420.2);
	public static var DRIVING_EMPTYGRANDSTAND   = new ReverbPreset(-1000,     0, 0.0,  4.62, 1.75,  -1363,  0.09, -1200, 0.049, 100.0, 100.0, 10420.2);
	public static var DRIVING_TUNNEL            = new ReverbPreset(-1000,  -800, 0.0,  3.42, 0.94,   -300, 0.051,  -300, 0.047,  81.0, 100.0,  5000.0);
	public static var CITY_STREETS              = new ReverbPreset(-1000,  -300, 0.0,  1.79, 1.12,  -1100, 0.046, -1400, 0.028,  78.0, 100.0,  5000.0);
	public static var CITY_SUBWAY               = new ReverbPreset(-1000,  -300, 0.0,  3.01, 1.23,   -300, 0.046,   200, 0.028,  74.0, 100.0,  5000.0);
	public static var CITY_MUSEUM               = new ReverbPreset(-1000, -1500, 0.0,  3.28, 1.4,   -1200, 0.039,  -100, 0.034,  82.0, 100.0,  2854.4);
	public static var CITY_LIBRARY              = new ReverbPreset(-1000, -1100, 0.0,  2.76, 0.89,   -900, 0.029,  -100,  0.02,  82.0, 100.0,  2854.4);
	public static var CITY_UNDERPASS            = new ReverbPreset(-1000,  -700, 0.0,  3.57, 1.12,   -800, 0.059,  -100, 0.037,  82.0, 100.0,  5000.0);
	public static var CITY_ABANDONED            = new ReverbPreset(-1000,  -200, 0.0,  3.28, 1.17,   -700, 0.044, -1100, 0.024,  69.0, 100.0,  5000.0);
	public static var DUSTYROOM                 = new ReverbPreset(-1000,  -200, 0.0,  1.79, 0.38,   -600, 0.002,   200, 0.006,  56.0, 36.45, 13046.0);
	public static var CHAPEL                    = new ReverbPreset(-1000,  -500, 0.0,  4.62, 0.64,   -700, 0.032,  -200, 0.049,  84.0, 100.0,  5000.0);
	public static var SMALLWATERROOM            = new ReverbPreset(-1000,  -698, 0.0,  1.51, 1.25,   -100,  0.02,   300,  0.03,  70.0, 100.0,  5000.0);
}