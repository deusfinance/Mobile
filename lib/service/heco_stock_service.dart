import 'dart:math';

import 'package:deus_mobile/models/swap/gas.dart';
import 'package:deus_mobile/models/synthetics/contract_input_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

import 'ethereum_service.dart';

class HecoStockService {
  final EthereumService ethService;
  final String privateKey;
  String marketMaker;
  String husd;
  HecoStockService({@required this.ethService, @required this.privateKey}) {
    _init();
  }

  _init() async {
    this.husd = "0x0298c2b32eae4da002a15f36fdf7615bea3da047";

    if (ethService.chainId == 128) {
      this.marketMaker = "0x3b62F3820e0B035cc4aD602dECe6d796BC325325";
    } else {
      this.marketMaker = "0xeF0500F9B82E72f045499932F0925C6393A5BD77";
    }
  }

  Future<Credentials> get credentials =>
      ethService.credentialsForKey(privateKey);

  Future<EthereumAddress> get address async =>
      (await credentials).extractAddress();

  bool checkWallet() {
    return ethService != null && this.privateKey != null;
  }

  Future<String> getAllowances(tokenAddress) async {
    if (!checkWallet()) {
      return "0";
    }
    if (tokenAddress != this.husd) {
      return "1000000000000000";
    }
    DeployedContract tokenContract =
        await ethService.loadContractWithGivenAddress(
            "token", EthereumAddress.fromHex(tokenAddress));
    final res = await ethService.query(tokenContract, "allowance",
        [await address, EthereumAddress.fromHex(marketMaker)]);

    return EthereumService.fromWei(res.single);
  }

  Future<String> approve(tokenAddress, gas) async {
    if (!checkWallet()) {
      return "0";
    }
    var amount = "10000000000000000000000000000";
    DeployedContract tokenContract =
        await ethService.loadContractWithGivenAddress(
            "token", EthereumAddress.fromHex(tokenAddress));

    var res = ethService.submit(await credentials, tokenContract, "approve",
        [EthereumAddress.fromHex(marketMaker), EthereumService.getWei(amount)], gas: gas);
    return res;
  }

  Future<Transaction> makeApproveTransaction(tokenAddress) async {
    if (!checkWallet()) {
      return null;
    }
    var amount = "10000000000000000000000000000";
    DeployedContract tokenContract =
    await ethService.loadContractWithGivenAddress(
        "token", EthereumAddress.fromHex(tokenAddress));
    var res = ethService.makeTransaction(await credentials, tokenContract, "approve",
        [EthereumAddress.fromHex(marketMaker), EthereumService.getWei(amount)]);
    return res;
  }

  Future<String> getTokenBalance(tokenAddress) async {
    if (!checkWallet()) return "0";

    DeployedContract tokenContract =
        await ethService.loadContractWithGivenAddress(
            "token", EthereumAddress.fromHex(tokenAddress));

    final res =
        await ethService.query(tokenContract, "balanceOf", [await address]);
    if (tokenAddress == this.husd) {
      return EthereumService.fromWei(res.single, "usd");
    }
    return EthereumService.fromWei(res.single);
  }

  Future<String> buy(
      tokenAddress, String amount, List<ContractInputData> oracles, Gas gas) async {
    try {
      if (!checkWallet()) return "0";

      DeployedContract contract = await ethService.loadContractWithGivenAddress(
          "bscSynchronizer", EthereumAddress.fromHex(this.marketMaker));
      ContractInputData info = oracles[0];

      return await ethService.submit(
        await credentials,
        contract,
        "buyFor",
        [
          await address,
          info.getMultiplier(),
          EthereumAddress.fromHex(tokenAddress),
          EthereumService.getWei(amount),
          info.getFee(),
          [oracles[0].getBlockNo(), oracles[1].getBlockNo()],
          [oracles[0].getPrice(), oracles[1].getPrice()],
          [oracles[0].signs['buy'].getV(), oracles[1].signs['buy'].getV()],
          [oracles[0].signs['buy'].getR(), oracles[1].signs['buy'].getR()],
          [oracles[0].signs['buy'].getS(), oracles[1].signs['buy'].getS()],
        ],
        gas: gas
      );
    } on Exception catch (error) {
      return "";
    }
  }

  Future<String> sell(
      tokenAddress, String amount, List<ContractInputData> oracles, Gas gas) async {
    if (!checkWallet()) return "0";
    DeployedContract contract = await ethService.loadContractWithGivenAddress(
        "bscSynchronizer", EthereumAddress.fromHex(this.marketMaker));
    ContractInputData info = oracles[0];

    return ethService.submit(await credentials, contract, "sellFor", [
      await address,
      info.getMultiplier(),
      EthereumAddress.fromHex(tokenAddress),
      EthereumService.getWei(amount),
      info.getFee(),
      [oracles[0].getBlockNo(), oracles[1].getBlockNo()],
      [oracles[0].getPrice(), oracles[1].getPrice()],
      [oracles[0].signs['sell'].getV(), oracles[1].signs['sell'].getV()],
      [oracles[0].signs['sell'].getR(), oracles[1].signs['sell'].getR()],
      [oracles[0].signs['sell'].getS(), oracles[1].signs['sell'].getS()],
    ],
    gas: gas);
  }

  Future getUsedCap() async {
    DeployedContract contract = await ethService.loadContractWithGivenAddress(
        "bscSynchronizer", EthereumAddress.fromHex(this.marketMaker));
    final res = await ethService.query(contract, "remainingDollarCap", []);
    return EthereumService.fromWei(res.single, "usd");
  }

  Future<Transaction> makeBuyTransaction(String tokenAddress, String amount,
      List<ContractInputData> oracles) async {
    try {
      if (!checkWallet()) return null;

      DeployedContract contract = await ethService.loadContractWithGivenAddress(
          "bscSynchronizer", EthereumAddress.fromHex(this.marketMaker));
      ContractInputData info = oracles[0];

      return await ethService.makeTransaction(
        await credentials,
        contract,
        "buyFor",
        [
          await address,
          info.getMultiplier(),
          EthereumAddress.fromHex(tokenAddress),
          EthereumService.getWei(amount),
          info.getFee(),
          [oracles[0].getBlockNo(), oracles[1].getBlockNo()],
          [oracles[0].getPrice(), oracles[1].getPrice()],
          [oracles[0].signs['buy'].getV(), oracles[1].signs['buy'].getV()],
          [oracles[0].signs['buy'].getR(), oracles[1].signs['buy'].getR()],
          [oracles[0].signs['buy'].getS(), oracles[1].signs['buy'].getS()],
        ],
      );
    } on Exception catch (error) {
      return null;
    }
  }

  Future<Transaction> makeSellTransaction(
      tokenAddress, String amount, List<ContractInputData> oracles) async {
    try {
      if (!checkWallet()) return null;
      DeployedContract contract = await ethService.loadContractWithGivenAddress(
          "bscSynchronizer", EthereumAddress.fromHex(this.marketMaker));
      ContractInputData info = oracles[0];

      return ethService
          .makeTransaction(await credentials, contract, "sellFor", [
        await address,
        info.getMultiplier(),
        EthereumAddress.fromHex(tokenAddress),
        EthereumService.getWei(amount),
        info.getFee(),
        [oracles[0].getBlockNo(), oracles[1].getBlockNo()],
        [oracles[0].getPrice(), oracles[1].getPrice()],
        [oracles[0].signs['sell'].getV(), oracles[1].signs['sell'].getV()],
        [oracles[0].signs['sell'].getR(), oracles[1].signs['sell'].getR()],
        [oracles[0].signs['sell'].getS(), oracles[1].signs['sell'].getS()],
      ]);
    } on Exception catch (error) {
      return null;
    }
  }
}
