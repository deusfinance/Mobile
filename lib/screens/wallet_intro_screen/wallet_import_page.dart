import '../../core/widgets/default_screen/custom_app_bar.dart';
import '../../routes/navigation_service.dart';
import '../swap/swap_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../infrastructure/wallet_setup/wallet_setup_provider.dart';
import '../../locator.dart';
import '../../models/wallet/wallet_setup.dart';
import 'widgets/import_wallet_form.dart';

class WalletImportPage extends HookWidget {
  static const String url = '/importWallet';

  WalletImportPage(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final store = useWalletSetup(context);
    return Scaffold(
        appBar: CustomAppBar(title: title),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 12, left: 12, right: 12, bottom: 30),
                  child: Text(
                    "You can choose if you want to import your wallet with your seed phrase or with your private key.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8), fontSize: 15),
                  ),
                ),
              ),
              ImportWalletForm(
                errors: store.state.errors!.toList(),
                onImport: !store.state.loading
                    ? (type, value) async {
                        switch (type) {
                          case WalletImportType.mnemonic:
                            if (!await store.importFromMnemonic(value)) return;
                            break;
                          case WalletImportType.privateKey:
                            if (!await store.importFromPrivateKey(value))
                              return;

                            break;
                          default:
                            break;
                        }
                        await locator<NavigationService>().navigateTo(
                            SwapScreen.route, context,
                            replaceAll: true);
                      }
                    : null,
              ),
            ],
          ),
        ));
  }
}
