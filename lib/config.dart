import 'package:flutter/foundation.dart';

class AppConfig {
  /// The currently selected config.
  ///
  /// Can be used to switch between development and production mode easily
  static const selectedConfig = AppConfig.production();

  const AppConfig.testing()
      : this.params = const AppConfigParams(chainId: 4),
        this.showDebugMessages = true;
  const AppConfig.production()
      : this.params = const AppConfigParams(chainId: 1),
        this.showDebugMessages = false;

  final bool showDebugMessages;
  final AppConfigParams params;
}

class AppConfigParams {
  const AppConfigParams({@required this.chainId});

  /// 4 = Rinkeby
  /// 1 = Mainnet
  ///
  /// See [EthereumService.NETWORK_NAMES]
  final int chainId;
}
