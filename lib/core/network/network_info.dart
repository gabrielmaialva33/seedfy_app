import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;

  Stream<bool> get connectionStream;
}

@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final results = await connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none) && results.isNotEmpty;
  }

  @override
  Stream<bool> get connectionStream {
    return connectivity.onConnectivityChanged.map(
      (results) =>
          !results.contains(ConnectivityResult.none) && results.isNotEmpty,
    );
  }
}
