import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'package:provider/single_child_widget.dart';
import 'package:web_socket_channel/io.dart';

import '../config.dart';
import 'address_service.dart';
import 'config_service.dart';

Future<List<SingleChildWidget>> createProviders(
    AppConfigParams params) async {
  final client = Web3Client(params.web3HttpUrl, Client(), socketConnector: () {
    return IOWebSocketChannel.connect(params.web3RdpUrl).cast<String>();
  });

  final sharedPrefs = await SharedPreferences.getInstance();

  final configurationService = ConfigurationService(sharedPrefs);
  final addressService = AddressService(configurationService);


  return [
    Provider.value(value: addressService),
 
    Provider.value(value: configurationService),
  ];
}
