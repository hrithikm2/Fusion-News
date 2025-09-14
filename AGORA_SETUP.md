# Agora Live Streaming Setup Guide

## Overview
This guide explains how to configure Agora live streaming using **App ID only mode** in your Fusion News app.

## Current Configuration

### App Constants
- **App ID**: `28a1636492f647bf839ba6aff58e92c5`
- **App Certificate**: `113764fe95e04502b1ad6a43cd231699` (stored for reference, not used in App ID only mode)

## Authentication Mode: App ID Only

### How App ID Only Mode Works
- **No tokens required** - authentication is handled by Agora using only the App ID
- **Primary Certificate must be disabled** in your Agora Console
- **Simplified setup** - no backend token server needed
- **Suitable for development and testing** environments

### Agora Console Configuration

1. **Log into your Agora Console** (https://console.agora.io/)
2. **Navigate to your project** with App ID: `28a1636492f647bf839ba6aff58e92c5`
3. **Go to Project Management > Authentication**
4. **Disable the Primary Certificate** - this enables App ID only mode
5. **Save the configuration**

### Flutter Implementation

The Flutter app is already configured to use App ID only mode:

```dart
await eng.joinChannel(
  token: "", // Empty string for App ID only mode
  channelId: "demoLive",
  uid: 0,
  options: const ChannelMediaOptions(),
);
```

## Flutter App Integration

### Current Implementation
The Flutter app is configured to:
1. Use the App ID for engine initialization
2. Pass empty string ("") as token parameter
3. No token renewal needed (App ID only mode)

### Usage Examples

#### Start Broadcasting
```dart
await liveStreamController.startBroadcast('my_channel');
```

#### Join as Viewer
```dart
await liveStreamController.joinAsViewer('my_channel');
```

#### Leave Channel
```dart
await liveStreamController.leave();
```

## Testing
1. Ensure Primary Certificate is disabled in Agora Console
2. Test live streaming functionality
3. Verify both broadcaster and audience roles work
4. Test multiple users joining the same channel

## Troubleshooting
- **Authentication errors**: Ensure Primary Certificate is disabled in Agora Console
- **Connection issues**: Check your internet connection and App ID
- **Permission errors**: Ensure camera and microphone permissions are granted
- **Channel issues**: Verify channel names are valid (alphanumeric, no spaces)
