import '../../core/widgets/default_screen/custom_app_bar.dart';
import '../../routes/navigation_service.dart';
import '../swap/swap_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../infrastructure/wallet_setup/wallet_setup_provider.dart';
import '../../locator.dart';
import '../../models/wallet/wallet_setup.dart';
import 'widgets/confirm_mnemonic.dart';
import 'widgets/display_mnemonic.dart';

class WalletCreatePage extends HookWidget {
  static const String url = '/createWallet';

  WalletCreatePage(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final store = useWalletSetup(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        // leading: BackButtonWithText(
        //   onPressed: store.state.step == WalletCreateSteps.display
        //       ? () => locator<NavigationService>().goBack(context)
        //       : () => store.goto(WalletCreateSteps.display),
        // ),
      ),
      body: store.state.step == WalletCreateSteps.display
          ? DisplayMnemonic(
              mnemonic: store.state.mnemonic!,
              onNext: () async {
                store.goto(WalletCreateSteps.confirm);
              },
            )
          : ConfirmMnemonic(
              mnemonic: store.state.mnemonic!,
              errors: store.state.errors!.toList(),
              onConfirm: !store.state.loading
                  ? (confirmedMnemonic) async {
                      if (await store.confirmMnemonic(confirmedMnemonic)) {
                        await locator<NavigationService>().navigateTo(
                            SwapScreen.route, context,
                            replaceAll: true);
                      }
                    }
                  : null,
              onGenerateNew: !store.state.loading
                  ? () async {
                      store.generateMnemonic();
                      store.goto(WalletCreateSteps.display);
                    }
                  : null,
            ),
    );
  }
}
