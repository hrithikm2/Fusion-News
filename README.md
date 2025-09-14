# Fusion News - Live Streaming News App

A modern Flutter application that combines news consumption with live streaming capabilities, built using clean architecture principles and GetX state management.

## 🚀 Features

### 📰 News Features
- **Reel-like News Interface**: TikTok-style vertical scrolling for news articles
- **Real-time News Updates**: Fetch latest news from NewsAPI
- **Search Functionality**: Search through news articles
- **Bookmark System**: Save articles for later reading
- **Like & Share**: Interactive engagement features
- **Offline Support**: Cached articles for offline reading

### 📺 Live Streaming Features
- **Live Broadcasting**: Start and manage live streams using Agora SDK
- **Live Viewing**: Join and watch live streams
- **Real-time Controls**: Camera, audio, and stream management
- **Viewer Interaction**: Like, share, and comment on streams
- **Stream Analytics**: View stream statistics and performance

### 🏗️ Architecture Features
- **Clean Architecture**: Feature-based folder structure
- **GetX State Management**: Reactive state management
- **Dependency Injection**: Proper dependency management
- **Error Handling**: Comprehensive error handling with custom failures
- **Network Management**: Online/offline state handling
- **Caching**: Local data persistence

## 📁 Project Structure

```
lib/
├── core/                           # Core functionality
│   ├── constants/                  # App constants
│   ├── errors/                     # Custom error classes
│   ├── network/                    # Network utilities
│   └── utils/                      # Utility functions
├── features/                       # Feature-based modules
│   ├── news/                       # News feature
│   │   ├── data/                   # Data layer
│   │   │   ├── datasources/        # Remote & local data sources
│   │   │   ├── models/             # Data models
│   │   │   └── repositories/       # Repository implementations
│   │   ├── domain/                 # Domain layer
│   │   │   ├── entities/           # Business entities
│   │   │   └── repositories/       # Repository interfaces
│   │   └── presentation/           # Presentation layer
│   │       ├── controllers/        # GetX controllers
│   │       ├── pages/              # UI pages
│   │       └── widgets/            # Reusable widgets
│   ├── livestream/                 # Live streaming feature
│   │   ├── data/                   # Data layer
│   │   ├── domain/                 # Domain layer
│   │   └── presentation/           # Presentation layer
│   └── shared/                     # Shared components
│       └── presentation/           # Shared UI components
└── main.dart                       # App entry point
```

## 🛠️ Technology Stack

### Core Technologies
- **Flutter**: Cross-platform mobile development
- **Dart**: Programming language
- **GetX**: State management, routing, and dependency injection

### Live Streaming
- **Agora RTC Engine**: Real-time communication SDK
- **Agora Video SDK**: Video streaming capabilities

### Networking & Data
- **Dio**: HTTP client for API calls
- **SharedPreferences**: Local data storage
- **Cached Network Image**: Image caching and loading

### Development Tools
- **JSON Serializable**: Code generation for JSON serialization
- **Build Runner**: Code generation runner
- **Flutter Lints**: Code quality and style enforcement

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.0 or higher)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd fusion_news
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Keys**
   
   Update the following in `lib/core/constants/app_constants.dart`:
   ```dart
   static const String apiKey = 'YOUR_NEWS_API_KEY';
   static const String agoraAppId = 'YOUR_AGORA_APP_ID';
   static const String agoraToken = 'YOUR_AGORA_TOKEN';
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### API Configuration

#### NewsAPI Setup
1. Visit [NewsAPI](https://newsapi.org/)
2. Sign up for a free account
3. Get your API key
4. Update `AppConstants.apiKey`

#### Agora Setup
1. Visit [Agora Console](https://console.agora.io/)
2. Create a new project
3. Get your App ID
4. Generate a temporary token for testing
5. Update `AppConstants.agoraAppId` and `AppConstants.agoraToken`

## 📱 Usage

### News Features
1. **Browse News**: Swipe vertically through news articles
2. **Search**: Use the search functionality to find specific articles
3. **Bookmark**: Tap the bookmark icon to save articles
4. **Like & Share**: Engage with articles using like and share buttons

### Live Streaming Features
1. **Start Streaming**: Tap "Start Live" to begin broadcasting
2. **Join Streams**: Tap on live streams to join as a viewer
3. **Stream Controls**: Use camera, audio, and other controls while streaming
4. **Viewer Interaction**: Like, share, and comment on live streams

## 🏗️ Architecture Details

### Clean Architecture Principles
- **Separation of Concerns**: Each layer has a specific responsibility
- **Dependency Inversion**: High-level modules don't depend on low-level modules
- **Single Responsibility**: Each class has one reason to change
- **Open/Closed**: Open for extension, closed for modification

### GetX State Management
- **Reactive Programming**: Automatic UI updates when data changes
- **Dependency Injection**: Easy dependency management
- **Route Management**: Simple and powerful navigation
- **Performance**: Minimal rebuilds and efficient memory usage

### Error Handling
- **Custom Failure Classes**: Type-safe error handling
- **Network Error Handling**: Proper handling of network issues
- **Fallback Mechanisms**: Graceful degradation when services fail
- **User-Friendly Messages**: Clear error messages for users

## 🔧 Development

### Code Generation
Run the following command to generate JSON serialization code:
```bash
flutter packages pub run build_runner build
```

### Testing
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

## 📦 Dependencies

### Main Dependencies
- `get: ^4.6.6` - State management and routing
- `agora_rtc_engine: ^6.3.2` - Live streaming SDK
- `dio: ^5.4.0` - HTTP client
- `cached_network_image: ^3.3.1` - Image caching
- `shared_preferences: ^2.2.2` - Local storage
- `permission_handler: ^11.2.0` - Permission management

### Dev Dependencies
- `json_serializable: ^6.7.1` - JSON code generation
- `build_runner: ^2.4.7` - Code generation runner
- `flutter_lints: ^5.0.0` - Code quality

## 🎯 Key Features Implementation

### News Reel Interface
- **PageView**: Vertical scrolling with smooth transitions
- **Lazy Loading**: Efficient memory usage with pagination
- **Image Optimization**: Cached network images with placeholders
- **Interactive Elements**: Bookmark, like, and share functionality

### Live Streaming
- **Agora Integration**: Professional-grade streaming capabilities
- **Real-time Controls**: Camera, audio, and stream management
- **Viewer Experience**: Smooth video playback and interaction
- **Stream Analytics**: Performance monitoring and statistics

### State Management
- **Reactive UI**: Automatic updates when data changes
- **Efficient Rebuilds**: Minimal widget rebuilds for performance
- **Memory Management**: Proper disposal of resources
- **Error States**: Comprehensive error handling and user feedback

## 🚀 Performance Optimizations

- **Lazy Loading**: Load content as needed
- **Image Caching**: Efficient image loading and caching
- **Memory Management**: Proper disposal of controllers and streams
- **Network Optimization**: Efficient API calls and caching
- **UI Optimization**: Minimal rebuilds and smooth animations

## 🔒 Security Considerations

- **API Key Management**: Secure storage of API keys
- **Token Management**: Proper handling of authentication tokens
- **Permission Handling**: Appropriate permission requests
- **Data Validation**: Input validation and sanitization

## 📈 Future Enhancements

- **Push Notifications**: Real-time notifications for news and streams
- **User Authentication**: User accounts and profiles
- **Social Features**: Following, comments, and social interactions
- **Analytics**: User behavior tracking and analytics
- **Offline Mode**: Enhanced offline functionality
- **Multi-language Support**: Internationalization
- **Dark/Light Theme**: Theme customization
- **Accessibility**: Enhanced accessibility features

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support and questions, please contact the development team or create an issue in the repository.

---

**Built with ❤️ using Flutter and Clean Architecture principles**