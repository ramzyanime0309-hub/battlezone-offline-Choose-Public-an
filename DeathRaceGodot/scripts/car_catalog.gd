extends RefCounted
class_name DeathRaceCarCatalog

# Performance numbers are game-balance values, not claimed factory specifications.
const CARS: Array[Dictionary] = [
	{
		"id": "lamborghini_veneno",
		"manufacturer": "Lamborghini",
		"model": "Veneno",
		"display_name": "Lamborghini Veneno",
		"category": "V12 track hypercar",
		"top_speed_kmh": 355,
		"acceleration_rating": 95,
		"handling_rating": 84,
		"nitro_rating": 88,
		"body_color": "#b82432",
		"description": "An extreme wedge-shaped V12 hypercar built for dramatic track presence."
	},
	{
		"id": "lamborghini_egoista",
		"manufacturer": "Lamborghini",
		"model": "Egoista",
		"display_name": "Lamborghini Egoista",
		"category": "Single-seat concept",
		"top_speed_kmh": 350,
		"acceleration_rating": 92,
		"handling_rating": 87,
		"nitro_rating": 86,
		"body_color": "#d46a20",
		"description": "A radical single-seat concept with a fighter-jet-inspired cockpit silhouette."
	},
	{
		"id": "lamborghini_terzo_millennio",
		"manufacturer": "Lamborghini",
		"model": "Terzo Millennio",
		"display_name": "Lamborghini Terzo Millennio",
		"category": "Electric hypercar concept",
		"top_speed_kmh": 360,
		"acceleration_rating": 98,
		"handling_rating": 91,
		"nitro_rating": 94,
		"body_color": "#20a6a0",
		"description": "A futuristic electric-hypercar concept with aggressive aerodynamic proportions."
	},
	{
		"id": "apollo_intensa_emozione",
		"manufacturer": "Apollo",
		"model": "Intensa Emozione",
		"display_name": "Apollo Intensa Emozione",
		"category": "Track-only V12 hypercar",
		"top_speed_kmh": 335,
		"acceleration_rating": 91,
		"handling_rating": 94,
		"nitro_rating": 90,
		"body_color": "#d9d9d2",
		"description": "A track-focused V12 machine with dramatic, high-downforce bodywork."
	},
	{
		"id": "apollo_arrow",
		"manufacturer": "Apollo",
		"model": "Arrow",
		"display_name": "Apollo Arrow",
		"category": "Road-going supercar",
		"top_speed_kmh": 350,
		"acceleration_rating": 90,
		"handling_rating": 88,
		"nitro_rating": 85,
		"body_color": "#b5b9c4",
		"description": "A road-focused mid-engine supercar concept with a clean, low silhouette."
	},
	{
		"id": "apollo_evo",
		"manufacturer": "Apollo",
		"model": "Evo",
		"display_name": "Apollo Evo",
		"category": "High-downforce hypercar",
		"top_speed_kmh": 365,
		"acceleration_rating": 97,
		"handling_rating": 92,
		"nitro_rating": 90,
		"body_color": "#a8b8c8",
		"description": "A modern high-downforce Apollo hypercar entry tuned for fast circuit driving."
	}
]

static func all_cars() -> Array[Dictionary]:
	return CARS.duplicate(true)

static func get_car_by_id(car_id: String) -> Dictionary:
	for definition in CARS:
		if String(definition.get("id", "")) == car_id:
			return definition.duplicate(true)
	return {}
