import 'dart:io';

/// Network connectivity information service
///
/// This service provides methods to check network connectivity
/// and handle network-related operations.
abstract class NetworkInfo {
  /// Check if the device is connected to the internet
  Future<bool> get isConnected;

  /// Check if the device is connected to WiFi
  Future<bool> get isConnectedToWifi;

  /// Check if the device is connected to mobile data
  Future<bool> get isConnectedToMobile;
}

/// Implementation of NetworkInfo using InternetAddress
class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Future<bool> get isConnectedToWifi async {
    // This is a simplified implementation
    // In a real app, you might want to use connectivity_plus package
    // to get more detailed network information
    return await isConnected;
  }

  @override
  Future<bool> get isConnectedToMobile async {
    // This is a simplified implementation
    // In a real app, you might want to use connectivity_plus package
    // to get more detailed network information
    return await isConnected;
  }
}
