# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SMASHING is an iOS application for sports enthusiasts to compete and verify their skills through location-based competition. Built with UIKit and MVVM architecture using the Input-Output pattern.

## Tech Stack

- **UI Framework**: UIKit (programmatic UI, no Storyboards)
- **Architecture**: MVVM + Input-Output Pattern
- **Networking**: Moya (BaseTargetType pattern)
- **Reactive Programming**: **Combine** (primary framework for all reactive data flow)
- **Image Loading**: Kingfisher
- **Auto Layout**: SnapKit
- **Dependency Injection**: DIContainer (custom implementation)
- **Package Manager**: Swift Package Manager (SPM)

**Important**: This project uses **Combine extensively** for reactive programming. All data binding, event handling, and asynchronous operations should use Combine publishers and subscribers.

## Build and Development Commands

### Building the Project
```bash
# Build for simulator
xcodebuild -project SMASHING.xcodeproj -scheme SMASHING -sdk iphonesimulator -configuration Debug build

# Build for device
xcodebuild -project SMASHING.xcodeproj -scheme SMASHING -sdk iphoneos -configuration Debug build

# Clean build folder
xcodebuild clean -project SMASHING.xcodeproj -scheme SMASHING
```

### Opening the Project
```bash
# Open in Xcode
open SMASHING.xcodeproj
```

## Key Architecture Patterns

### Base Classes
All view controllers and views inherit from base classes:
- `BaseViewController`: Auto-hides navigation bar, provides `setUI()` and `setLayout()` template methods
- `BaseUIView`: Programmatic view base with same template method pattern
- Base classes for cells: `BaseUICollectionViewCell`, `BaseUITableViewCell`, `BaseUICollectionReusableView`

### Network Layer Architecture
The networking is structured with a custom abstraction over Moya:

1. **BaseTargetType**: Protocol extending Moya's `TargetType`
   - Centralizes `baseURL` from `Environment.baseURL`
   - Provides default headers (`Content-Type: application/json`)

2. **NetworkProvider<API>**: Generic provider for API calls
   - Static method: `request(_:type:completion:)`
   - Handles status codes (200-299 success, 401/403/404/500s mapped to `NetworkError`)
   - Includes `NetworkLogger` plugin for debugging
   - Decodes response into `Decodable` types

3. **GenericResponse<T>**: Standard API response wrapper
   ```swift
   struct GenericResponse<T: Decodable>: Decodable {
       let isSuccess: Bool
       let code: String
       let message: String
       let result: T
   }
   ```

4. **NetworkError**: Enum for all network error cases
   - `decoding`, `unauthorized`, `forbidden`, `notFound`, `serverError(String)`, `networkFail`, `unknown`

### Environment Configuration
**Critical**: API keys and base URLs are stored in `.xcconfig` files (gitignored) and accessed via `Info.plist`:
- `Environment.baseURL`: Server base URL
- `Environment.kakaoAPPKey`: Kakao Map API key

**Never hardcode these values**. They are injected from build settings via `$(KAKAO_APP_Key)` and `$(BaseURL)` in Info.plist.

### MVVM + Input-Output Pattern with Combine
**This is a core pattern used throughout the app.** ViewModels follow the Input-Output structure:

```swift
// Example structure (to be implemented in ViewModelType.swift)
protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
```

**Pattern:**
- **Input**: User actions as Combine publishers (button taps, text changes, lifecycle events)
  - Example: `PassthroughSubject<Void, Never>` for button taps
  - Example: `CurrentValueSubject<String, Never>` for text field input
- **Output**: Data streams for UI updates as Combine publishers
  - Example: `AnyPublisher<[Model], Never>` for data lists
  - Example: `AnyPublisher<Bool, Never>` for loading states
- **ViewControllers**:
  - Create Input publishers from UI events
  - Call `viewModel.transform(input: input)` to get Output
  - Bind Output publishers to UI using `.sink()` or `.assign(to:)`
  - Store subscriptions in `Set<AnyCancellable>`

**Always use Combine for reactive data flow**, not RxSwift (which exists in dependencies but is not the primary choice).

### Dependency Injection with DIContainer
**Critical**: All dependencies must be managed through the custom DIContainer implementation.

**File Location**: `SMASHING/Applications/DIContainer.swift`

#### DIScope Types
- `.singleton` (default): Creates one instance and reuses it across the app
- `.transient`: Creates a new instance every time it's resolved

#### Usage Rules

**1. Protocol-Based Registration (Required)**
- Always register and resolve using **protocol types**, not concrete types
- Protocol naming: Use `~Protocol` suffix (e.g., `NetworkServiceProtocol`)

```swift
// ✅ Correct
protocol NetworkServiceProtocol { }
class NetworkService: NetworkServiceProtocol { }

DIContainer.shared.register(type: NetworkServiceProtocol.self, scope: .singleton) { container in
    NetworkService()
}

let service = DIContainer.shared.resolve(type: NetworkServiceProtocol.self)
```

```swift
// ❌ Wrong - Type mismatch will crash
DIContainer.shared.register(type: NetworkService.self, scope: .singleton) { _ in NetworkService() }
let service = DIContainer.shared.resolve(type: NetworkServiceProtocol.self) // 💥 Crash
```

**2. Scope Selection Guidelines**

**Use `.singleton` for:**
- NetworkService, DatabaseManager
- UserDefaultsManager, LocationManager
- ImageCacheManager, AuthenticationManager
- Any service that maintains shared state

**Use `.transient` for:**
- ViewModels (each screen needs independent state)
- Repositories, UseCases
- Coordinators, Factories
- Objects that need fresh state each time

```swift
// Singleton example
DIContainer.shared.register(type: NetworkServiceProtocol.self, scope: .singleton) { container in
    NetworkService()
}

// Transient example
DIContainer.shared.register(type: MainViewModel.self, scope: .transient) { container in
    MainViewModel()
}
```

**3. Registration Location**
- Register all dependencies in `AppDelegate` or `SceneDelegate`
- Call registration during `application(_:didFinishLaunchingWithOptions:)`
- Keep all registrations in one centralized location

```swift
// AppDelegate.swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    registerDependencies()
    return true
}

private func registerDependencies() {
    // Network layer
    DIContainer.shared.register(type: NetworkServiceProtocol.self, scope: .singleton) { container in
        NetworkService()
    }

    // Repositories
    DIContainer.shared.register(type: UserRepositoryProtocol.self, scope: .transient) { container in
        UserRepository(
            networkService: container.resolve(type: NetworkServiceProtocol.self)
        )
    }
}
```

**Always use Combine for reactive data flow**, not RxSwift (which exists in dependencies but is not the primary choice).

## Project Structure

```
SMASHING/
├── Applications/          # AppDelegate, SceneDelegate
├── Global/
│   ├── DIContainer/      # Dependency injection (not yet implemented)
│   ├── Base/             # Base classes (BaseViewController, BaseUIView, etc.)
│   ├── Extensions/       # UIKit extensions (ReuseIdentifiable, UIView+, UIStackView+, etc.)
│   ├── Resource/         # Assets.xcassets, Info.plist
│   └── Environment.swift # Configuration from Info.plist
├── Networks/
│   ├── API/              # API endpoint definitions
│   ├── Base/             # BaseTargetType, NetworkProvider, NetworkLogger, GenericResponse, NetworkError
│   ├── DTO/              # Data Transfer Objects
│   └── Service/          # Network service layer
└── Presentation/
    ├── Core/
    │   ├── Factories/    # Factory patterns for object creation
    │   └── ViewModelType.swift (planned)
    └── [Feature]/        # Feature modules (e.g., Main/)
        ├── [Feature]ViewController.swift
        ├── [Feature]ViewModel.swift
        └── [Feature]View.swift (optional, for complex UI)
```

## Installed Dependencies (SPM)

- Moya 15.0.3 (with Alamofire 5.11.0)
- Kingfisher 8.6.2
- SnapKit 5.7.1
- Then 3.0.0
- RxSwift 6.9.1
- ReactiveSwift 6.7.0

**Note**: RxSwift is included in dependencies but **should not be used**. Use **Combine** for all reactive programming needs.

## Git Workflow

### Branch Strategy
- `main`: Production releases
- `develop`: Default development branch
- `tag/#이슈번호`: Feature branches

### Tag Types
- `feat`: New features
- `fix`: Bug fixes
- `docs`: Documentation
- `setting`: Project configuration
- `add`: Assets or library additions
- `refactor`: Code refactoring
- `chore`: Minor changes

### Workflow
1. Create feature branch from `develop`
2. Create PR to `develop` (use [pull_request_template.md](pull_request_template.md))
3. All team members must approve (except author)
4. Author merges after all approvals
5. PRs should be under 500 lines

## Coding Conventions

### Naming
- Files: No abbreviations (discuss if too long)
- Classes/Structs/Protocols: `UpperCamelCase`
- Functions/Variables/Constants: `lowerCamelCase`
- Enum cases: `lowerCamelCase`

### Functions
- Action functions: `주어 + 동사 + 목적어` (e.g., `backButtonDidTap()`)
- `tap` → `.touchUpInside`, `press` → `.touchDown`

### Delegates
- Protocol name + action for namespace: `func userCellDidSetProfileImage(_ cell: UserCell)`

### Closures
- Empty closure: `() -> Void`
- Use trailing closure syntax
- Omit parameter names for last closure when possible

### Other
- Always use `self` explicitly inside classes
- Use Swift syntax for structs: `CGRect(x: 0, y: 0, width: 100, height: 100)`
- Collection types: `[String]`, `[Int: String]` (not `Array<String>`)

## Important Notes

1. **No Storyboards**: All UI is programmatic using SnapKit for Auto Layout
2. **Template Methods**: Override `setUI()` and `setLayout()` in BaseViewController/BaseUIView subclasses
3. **ReuseIdentifiable**: Use the `ReuseIdentifiable` protocol for collection/table view cells
4. **Navigation Bars**: Hidden by default in BaseViewController
5. **Keyboard Dismissal**: BaseViewController handles tap-to-dismiss keyboard
6. **Environment Variables**: Never commit `.xcconfig` files (see `.gitignore` line 134-135)
