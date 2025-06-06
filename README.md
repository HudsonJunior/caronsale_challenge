## Architecture

The project follows a Repository Pattern approach from Android along with the MVVM pattern (using bloc):

- Sources: Responsible for communicating with external sources, handle errors and data parsing.
- Repositories: Responsible for managing multiple sources. It is also used as the single source of truth.
- Cubit: Business/Ui logic. The view model of the MVVM.

I've done what I thought was enough for a small application like this. I haven't used abstract classes (dependency inversion principle) as I thought it was not needed for this usecase. I tried to kept it simple and at the same time robust.

### Core Layer
- **api/**: Contains API client and base configurations
- **utils/**: Utility functions and constants
- **widgets/**: Reusable UI components

### Features Layer
- **auth/**: Authentication feature
  - Cubits for state management
  - Repositories for data handling
  - Sources for API and local storage
- **vehicle/**: Vehicle management feature
  - Cubits for state management
  - Repositories for data handling
  - Sources for API and local storage


## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

## Testing

The project includes tests for:
- Repositories
- Cubits

Run tests using:
```bash
flutter test
```

## Project Structure

```
lib/
├── core/
│   ├── api/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── auth/
│   │   ├── cubits/
│   │   ├── repositories/
│   │   └── sources/
│   └── vehicle/
│       ├── cubits/
│       ├── repositories/
│       └── sources/
└── main.dart
```

## State Management

The application uses BLoC pattern with Cubits for state management. Each feature has its own Cubit that handles the business logic and state updates.

## Data Flow

1. UI triggers an action
2. Cubit processes the action
3. Repository is called to handle data operations
4. Source (API/Local) performs the actual data operation
5. Data flows back up through the same chain
6. UI updates based on the new state
