import '../../models/wallet/wallet.dart';
import '../../service/address_service.dart';
import '../../service/config_service.dart';
import '../../service/ethereum_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'wallet_state.dart';

//TODO: Use cubit instead of Hooks.
class WalletHandler {
  WalletHandler(
    this._store,
    this._addressService,
    this._ethereumService,
    this._configurationService,
  );

  final Store<Wallet, WalletAction> _store;
  final AddressService _addressService;
  final ConfigurationService _configurationService;
  final EthereumService _ethereumService;

  Wallet get state => _store.state;

  Future<void> initialise() async {
    final entropyMnemonic = _configurationService.getMnemonic();
    final privateKey = _configurationService.getPrivateKey();

    if (entropyMnemonic != null && entropyMnemonic.isNotEmpty) {
      await _initialiseFromMnemonic(entropyMnemonic);
      return;
    }

    await _initialiseFromPrivateKey(privateKey!);
  }

  Future<void> _initialiseFromMnemonic(String entropyMnemonic) async {
    final mnemonic = _addressService.entropyToMnemonic(entropyMnemonic);
    final privateKey = _addressService.getPrivateKey(mnemonic);
    final address = await _addressService.getPublicAddress(privateKey);

    _store.dispatch(InitialiseWallet(address.toString(), privateKey!));

    await _initialise();
  }

  Future<void> _initialiseFromPrivateKey(String privateKey) async {
    final address = await _addressService.getPublicAddress(privateKey);

    _store.dispatch(InitialiseWallet(address.toString(), privateKey));

    await _initialise();
  }

  Future<void> _initialise() async {
    await this.fetchOwnBalance();

    // _ethereumService.listenTransfer((from, to, value) async {
    //   final bool fromMe = from.toString() == state.address;
    //   final bool toMe = to.toString() == state.address;

    //   if (!fromMe && !toMe) {
    //     return;
    //   }
    //   // TODO (@kazemghareghani): We need a listener that updates whenever a Transfer occurs.
    //   // maybe you can take a look at the ether_wallet_flutter repo on my github and get a quick overview into the contract service?
    //   // You should find everything you need in there.
    //   print('======= balance updated =======');

    //   await fetchOwnBalance();
    // });
  }

  Future<void> fetchOwnBalance() async {
    _store.dispatch(UpdatingBalance());

    final ethBalance = await _ethereumService.getEtherBalance(
        await _ethereumService.credentialsForKey(state.privateKey!));

    _store.dispatch(BalanceUpdated(ethBalance.getInWei));
  }

  Future<void> resetWallet() async {
    await _configurationService.setMnemonic("");
    await _configurationService.setPrivateKey("");
    await _configurationService.setupDone(false);
  }
}
