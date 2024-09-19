import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final connection = await connectivity.checkConnectivity();

    if (connection.length == 1 && connection[0] == ConnectivityResult.none) {
      return Future.value(false);
    }

    return Future.value(true);
  }
}
