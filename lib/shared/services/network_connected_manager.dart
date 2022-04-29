import 'package:chat_app/shared/components/shared_components.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkConnectionManager {
  static final Connectivity _connectivity = Connectivity();
  static ConnectivityResult? _connectivityResult;

  static init() async {
    _connectivityResult = await _connectivity.checkConnectivity();
  }

  late String message;

  static bool checkConnection(
      {bool showErrorMsg = true, String? customErrorMsg}) {
    switch (_connectivityResult) {
      case ConnectivityResult.wifi:
        return true;
      case ConnectivityResult.mobile:
        return false;
      case ConnectivityResult.ethernet:
        return false;
      case ConnectivityResult.bluetooth:
        return false;
      case ConnectivityResult.none:
        return false;
      default:
        return false;
    }
  }
}
// if (showErrorMsg) {
// toastMessage(message: customErrorMsg ?? "internet connection failed");
// }
