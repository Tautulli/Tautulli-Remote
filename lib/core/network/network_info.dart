import 'package:connectivity/connectivity.dart';
import 'package:meta/meta.dart';

abstract class NetworkInfo {
  /// Returns `true` if device has an active network connection.
  ///
  /// Does not check for an active Internet connection.
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivityChecker;

  NetworkInfoImpl({@required this.connectivityChecker});

  @override
  Future<bool> get isConnected async {
    final connection = await connectivityChecker.checkConnectivity();
    if (connection != ConnectivityResult.none) {
      return Future.value(true);
    }
    return Future.value(false);
  }
}
