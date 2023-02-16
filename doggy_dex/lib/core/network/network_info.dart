import 'dart:io';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  Future<bool> getConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return (result.isNotEmpty && result[0].rawAddress.isNotEmpty);
    } on SocketException catch (_) {
      return false;
    }
  }
  
  @override
  Future<bool> get isConnected => getConnection();
}
