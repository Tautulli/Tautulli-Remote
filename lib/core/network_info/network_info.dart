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

    if (connection != ConnectivityResult.none) {
      return Future.value(true);
    }

    return Future.value(false);
  }
}
