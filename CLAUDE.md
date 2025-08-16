# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

"Fly to You" is a SwiftUI-based iOS app that allows users to send themed paper airplanes to each other in a relay fashion. Users can create paper airplanes with topics and content, send them to others, receive airplanes and relay them forward, and track flight paths on a map.

## Architecture

### Clean Architecture Implementation
The project follows Clean Architecture with clear separation of concerns:

- **Application Layer**: App entry point, DI container setup, and scene component factories
- **Presentation Layer**: SwiftUI views, ViewModels, and UI components
- **Domain Layer**: Business logic, use cases, domain models, and service interfaces
- **Data Layer**: Repository implementations, DTOs, and data persistence

### Dependency Injection
- Uses custom DI container pattern with scene-specific containers
- Each scene has its own DIContainer (MainSceneDIContainer, AuthSceneDIContainer, etc.)
- Factories create ViewModels and other dependencies for each scene
- Components coordinate between factories and views

### Key Directory Structure
```
Fly to You/
├── Application/          # App setup and DI components
├── Core/                 # DI containers and logging
├── Data/                 # Repositories, DTOs, persistence
├── Domain/               # Use cases, models, service interfaces
├── Presentation/         # Views, ViewModels, UI components
└── Resource/             # Assets, fonts, GIFs
```

## Build and Development Commands

### iOS Project
- **Build**: Use Xcode or `xcodebuild` command
- **Run Tests**: `xcodebuild test -workspace "Fly to You.xcworkspace" -scheme "Fly to You" -destination "platform=iOS Simulator,name=iPhone 15"`
- **Dependencies**: Uses CocoaPods - run `pod install` when dependencies change

### Backend (Firebase Functions)
Located in `Fly to You - Backend/functions/`:
- **Install dependencies**: `pip install -r requirements.txt`
- **Deploy**: Use Firebase CLI commands
- **Local development**: Firebase Functions emulator

## Testing Framework

Uses XCTest for unit testing:
- Test files in `Fly to YouTests/` directory
- Mock objects in `Fly to YouTests/Mock/` directory
- Current tests cover:
  - BlockLetterUseCase business logic
  - DateUtil utility functions
- UI tests in `Fly to YouUITests/` directory

## Key Architectural Patterns

### Domain Services
The project includes domain services for business logic:
- `FlightAnalysisService`: Calculates participation counts and flight analytics
- `FlightCalculator`: Pure calculation utilities for flight data

### Repository Pattern
Domain interfaces defined in `Domain/Interfaces/`:
- `FlightRepo`, `LetterRepo`, `UserRepo`, `SignUpRepo`
- Implementations in `Data/Repository/`

### Use Case Pattern
Business operations encapsulated in use cases:
- Auth: `SignUpUseCase`
- Flight: `FetchFlightsUseCase`
- Letter: `BlockLetterUseCase`, `DeleteLetterUseCase`, `EditLetterUseCase`, etc.

## Technology Stack

- **Frontend**: SwiftUI with MVVM pattern
- **Backend**: Firebase Functions (Python)
- **Database**: Firestore
- **Authentication**: Firebase Auth
- **Push Notifications**: Firebase Messaging
- **Networking**: Alamofire
- **Dependency Management**: CocoaPods

## Design System
Custom design system components in `Presentation/Utils/DesignSystem/`:
- Consistent spacing, colors, and typography
- Reusable UI components in `Presentation/Component/`

## Firebase Integration
- `GoogleService-Info.plist` for iOS configuration
- Firebase configuration in `Fly to You - Backend/` for cloud functions
- Firestore rules and indexes defined in backend directory

## Key Models
- `FlightModel`: Represents a paper airplane's journey
- `ReceiveLetterModel`: Individual messages/letters in flights
- `User`: User profile and authentication data

## Development Notes
- The app uses Korean localization (`ko_KR`)
- Custom fonts: Pretendard family and decorative fonts
- GIF animations for enhanced UX
- Keychain storage for sensitive data
- UserDefaults for user preferences and session data