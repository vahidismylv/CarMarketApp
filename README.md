# 🚗 CarMarketApp

CarMarketApp is a UIKit-based car marketplace application.

This project simulates a real-world marketplace flow: browsing cars, filtering results, viewing detailed information, saving favorites, and handling basic authentication logic.

⸻

✨ Features

🚘 Main Screen
	•	Displays a list of cars
	•	Search by brand, model, and location
	•	Responsive collection layout
	•	Integrated favorites toggle

🔎 Filters
	•	Filter by:
	•	Price range
	•	Year range
	•	Mileage
	•	Fuel type
	•	Transmission
	•	Body type
	•	Filter state persists while navigating back and forth
	•	Filters and search work independently

📄 Car Detail
	•	Image gallery
	•	Detailed specifications:
	•	Engine
	•	Power (HP / kW)
	•	Origin
	•	Mileage
	•	Fuel consumption
	•	Seats
	•	Doors
	•	Color
	•	Seller section
	•	Call action button
	•	Favorite toggle synced with Main screen

❤️ Favorites
	•	Saved cars persist locally
	•	Favorite state synchronized across screens
	•	Uses repository abstraction for storage

👤 Profile & Authentication
	•	Basic login flow (email + password validation)
	•	Email format validation
	•	Password length validation
	•	Local session persistence

