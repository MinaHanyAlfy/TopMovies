# TopMovies 🎬

A simple iOS app that displays movies from The Movie Database (TMDb) API with a native tab bar for browsing Now Playing, Popular, and Upcoming movies.

## Quick Start

### Prerequisites
- iOS 17.0+, Xcode 15.0+, Swift 5.9+
- [TMDb API Key](https://www.themoviedb.org/settings/api)

### Setup

1. **Clone & Open**
   ```bash
   git clone <repository-url>
   open TopMovies.xcodeproj
   ```

2. **Configure API Key**
   - Create `TopMovies/Secrets.plist`:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>API_BEARER_TOKEN</key>
       <string>YOUR_TMDB_BEARER_TOKEN_HERE</string>
   </dict>
   </plist>
   ```
   - Add to `.gitignore`: `echo "TopMovies/Secrets.plist" >> .gitignore`

3. **Build & Run**
   - Select iOS 17+ simulator
   - Press `Cmd + R`

## Features

- **3-Tab Navigation** - Native UITabBarController with Now Playing, Popular, Upcoming categories
- **Movie List** - Displays title, release date, poster image, and vote rating
- **Movie Details** - Shows overview, genres, runtime, vote count with back button
- **Offline Support** - SwiftData caching for browsing without internet
- **Error Handling** - Network failures display cached data with user-friendly messages
- **Pagination** - Load more movies by scrolling

## Architecture

**Clean Architecture + MVVM + DDD**

```
Presentation (UIViewController, ViewModel, UITabBarController)
    ↓
Domain (Use Cases, Repositories, Entities)
    ↓
Data (Repository Implementations, DTOs, DataSources)
    ↓
Infrastructure (NetworkClient, SwiftData, DI Container)
```

**No Third-Party Dependencies** - Uses only native iOS frameworks (no CocoaPods/SPM)

## Project Structure

```
TopMovies/
├── Core/                    # Infrastructure (Network, DI, Logger)
├── Domain/                  # Business logic (UseCases, Repositories, Entities)
├── Data/                    # Data access (DTOs, Repository Implementations)
├── Presentation/            # UI (ViewControllers, ViewModels, Coordinators)
├── Assets.xcassets/         # Images and colors
└── Base.lproj/              # Storyboards

TopMoviesTests/              # Unit tests
├── DTOTests/                # JSON parsing tests
├── MapperTests/             # Entity conversion tests
├── RepositoryTests/         # Data layer tests
├── UseCaseTests/            # Business logic tests
└── Mocks/                   # Test doubles
```

## Key Layers

### Presentation Layer
- ViewControllers with ViewModels handling state
- Native UITabBarController for 3 tabs
- Coordinators for navigation

### Domain Layer
- Use Cases: `FetchNowPlayingUseCase`, `FetchPopularUseCase`, `FetchUpcomingUseCase`, `FetchMovieDetailsUseCase`
- Repository Protocols: `MoviesRepository`, `ImageRepository`
- Domain Entities: `MovieEntity`, `MovieDetailsEntity`

### Data Layer
- Repository Implementations combining network + local sources
- DTOs: `MovieDTO`, `MovieDetailsDTO`, `PageResponse`
- Local DataSources with SwiftData persistence

### Infrastructure Layer
- `NetworkClient` - URLSession wrapper with bearer token auth
- `DependencyContainer` - Centralized DI
- `NetworkMonitor` - Connectivity detection
- `Configuration` - API token management

## TMDb API Integration

Endpoints used:
- `GET /movie/now_playing` - Now playing movies with pagination
- `GET /movie/popular` - Popular movies with pagination
- `GET /movie/upcoming` - Upcoming movies with pagination
- `GET /movie/{movie_id}` - Movie details

**Base URL**: `https://api.themoviedb.org`  
**Auth**: Bearer token in request headers

## Caching & Offline

- **In-Memory Cache** - Fast access during session
- **Disk Cache (SwiftData)** - Persistent storage
- **Offline Fallback** - Shows cached data when offline

When network unavailable: "No internet connection. Showing cached data."

## Error Handling

- Network errors display user-friendly messages
- Failed requests fall back to cached data
- Retry button on error screens
- Real-time network connectivity monitoring

## Testing

Run tests: `Cmd + U`

**Test Coverage:**
- DTOs and JSON parsing
- Entity mapping and transformations
- Repository implementations (local + remote)
- Use case business logic
- ViewModel state management

**Test Mocks:**
- `MockNetworkClient` - Network request simulation
- `MockMoviesRepository` - Repository implementation mock
- `MockMoviesLocalDataSource` - SwiftData mock

## Code Standards

- **Naming**: Protocols are nouns, implementations end with `Impl`, DTOs end with `DTO`
- **Organization**: One class per file, MARK comments for sections
- **Patterns**: Dependency Injection, Repository Pattern, MVVM
- **Testing**: Unit tests for all layers with mocked dependencies

## Git Workflow

Commit format:
```
feat: Add movie detail screen
fix: Handle network timeout
test: Add repository tests
docs: Update README
```

Atomic commits describing "why" not just "what"

---
