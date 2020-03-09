{
	"duration": 2.5,
	"loopAnims": true,
	"type": "fx",
	"children": [
		{
			"type": "object",
			"name": "FXRoot",
			"children": [
				{
					"x": 1.3,
					"y": 0.08,
					"z": 2,
					"rotationY": 90,
					"type": "object",
					"name": "BEAM BASE",
					"children": [
						{
							"z": -0.3,
							"scaleX": 8,
							"scaleY": 8,
							"scaleZ": 8,
							"props": {
								"emitRate": 15,
								"emitSurface": true,
								"emitOrientation": "Normal",
								"instSpeed": [
									-1,
									0,
									0
								],
								"maxCount": 15
							},
							"type": "emitter",
							"name": "RAYS INWARD COLOURED",
							"children": [
								{
									"scaleX": 0.3,
									"scaleY": 0.5,
									"debugColor": -1,
									"type": "polygon",
									"name": "polygon",
									"children": [
										{
											"diffuseMap": "ray.jpg",
											"type": "material",
											"name": "material",
											"props": {
												"PBR": {
													"mode": "Overlay",
													"blend": "Add",
													"shadows": false,
													"alphaKill": false,
													"emissive": 1
												}
											}
										},
										{
											"type": "shader",
											"name": "ColorMult",
											"source": "ColorMult.hx",
											"children": [
												{
													"duration": 0,
													"clampMin": 0,
													"clampMax": 0,
													"keyMode": 2,
													"keys": [
														{
															"time": 0,
															"value": 0.3244259080177695,
															"mode": 2
														},
														{
															"time": 0.705,
															"value": 0.8302106712189242,
															"mode": 2
														}
													],
													"type": "curve",
													"name": "color.h"
												},
												{
													"duration": 0,
													"clampMin": 0,
													"clampMax": 1,
													"keyMode": 2,
													"keys": [
														{
															"time": 0,
															"value": 1,
															"mode": 2
														},
														{
															"time": 0.705,
															"value": 1,
															"mode": 2
														}
													],
													"type": "curve",
													"name": "color.s"
												},
												{
													"duration": 0,
													"clampMin": 0,
													"clampMax": 1,
													"keyMode": 2,
													"keys": [
														{
															"time": 0,
															"value": 0.5,
															"mode": 2
														},
														{
															"time": 0.705,
															"value": 0.7823529411764706,
															"mode": 2
														}
													],
													"type": "curve",
													"name": "color.l"
												}
											],
											"props": {
												"color": [
													0.2784313725490196,
													0,
													0.17254901960784313
												],
												"amount": 1
											}
										}
									]
								},
								{
									"duration": 0,
									"clampMin": 0,
									"clampMax": 0,
									"keyMode": 0,
									"keys": [
										{
											"time": -0.014238281249999929,
											"value": 0.5,
											"mode": 1,
											"prevHandle": {
												"dv": 0,
												"dt": -0.5
											},
											"nextHandle": {
												"dv": 0.029166666666666563,
												"dt": 0.3002218308335262
											}
										},
										{
											"time": 0.75,
											"value": 2.951858345170817,
											"mode": 0,
											"prevHandle": {
												"dv": 0.12232030806562909,
												"dt": -0.5298192182332122
											},
											"nextHandle": {
												"dv": -0.04155692110458986,
												"dt": 0.17999999999999994
											}
										},
										{
											"time": 1,
											"value": 0.9571261321504912,
											"mode": 1
										}
									],
									"type": "curve",
									"name": "instStretch.x"
								},
								{
									"duration": 0,
									"clampMin": 0,
									"clampMax": 0,
									"keyMode": 1,
									"keys": [
										{
											"time": -0.014238281249999929,
											"value": 1,
											"mode": 1,
											"prevHandle": {
												"dv": 0,
												"dt": -0.5
											},
											"nextHandle": {
												"dv": 0,
												"dt": 0.16666666666666666
											}
										},
										{
											"time": 0.3985058593750001,
											"value": 12,
											"mode": 1,
											"prevHandle": {
												"dv": 0,
												"dt": -0.16666666666666666
											},
											"nextHandle": {
												"dv": 0,
												"dt": 0.16038302951388955
											}
										},
										{
											"time": 0.5988888888888897,
											"value": 0,
											"mode": 2
										}
									],
									"type": "curve",
									"name": "instSpeed.x"
								},
								{
									"duration": 0,
									"clampMin": 0,
									"clampMax": 0,
									"keyMode": 3,
									"keys": [
										{
											"time": 0.0049999999999999975,
											"value": 2.0272865295410165,
											"mode": 3
										},
										{
											"time": 0.62,
											"value": 2.0047611236572274,
											"mode": 0,
											"prevHandle": {
												"dv": 0,
												"dt": -0.08666666666666667
											},
											"nextHandle": {
												"dv": 0,
												"dt": 0.11666666666666665
											}
										},
										{
											"time": 1.3599999999999999,
											"value": 0.5,
											"mode": 3
										},
										{
											"time": 1.55,
											"value": 0,
											"mode": 3
										}
									],
									"type": "curve",
									"name": "emitRate"
								}
							]
						}
					]
				}
			]
		}
	]
}