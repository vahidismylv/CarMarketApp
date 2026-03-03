# CarCollection

A UIKit car marketplace demo app built for portfolio use and further product development.

## Stack
- UIKit
- SnapKit
- MVVM
- Programmatic navigation and UI
- Mock repositories with UserDefaults-backed auth and favorites

## Features
- Sign in with email and password
- Home feed with search and filters
- Favorites flow
- Car detail screen
- Profile screen with persisted session state

## Project Structure
- `CarCollection/App`: app startup and dependency wiring
- `CarCollection/Features`: feature screens and view models
- `CarCollection/Data/Repositories`: data access and local persistence
- `CarCollection/Core/Model`: app models and mock data
- `CarCollection/UI`: shared UI components and theme

## Notes
- Apple sign-in is not implemented yet.
- Data is mocked locally for now.
- The project is structured to allow replacing mock repositories with a backend later.

## Run
1. Open `/Users/vahidismylv/Documents/CarCollection/CarCollection.xcodeproj` in Xcode.
2. Select the `CarCollection` scheme.
3. Run on an iPhone simulator.
