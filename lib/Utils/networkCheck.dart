import 'package:connectivity_plus/connectivity_plus.dart';

class netMessage {
  bool netAnswer;
  netMessage(this.netAnswer);
}

Future<netMessage> network() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    print("mobil nete bağlı");
    return netMessage(true);
  } else if (connectivityResult == ConnectivityResult.wifi) {
    print("wifi bağlı");
    return netMessage(true);
  } else {
    print("bağlı değil");
    return netMessage(false);
  }
}
