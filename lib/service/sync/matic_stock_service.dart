import '../../models/swap/gas.dart';
import '../../models/synthetics/contract_input_data.dart';
import 'sync_service.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

import '../ethereum_service.dart';

class MaticStockService extends SyncService {
  static String usdc = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174";
  String marketMaker = "0x3b62F3820e0B035cc4aD602dECe6d796BC325325";

  MaticStockService({required ethService, required privateKey})
      : super(ethService, privateKey);

  @override
  Future<String> getAllowances(String tokenAddress) async {
    if (tokenAddress != MaticStockService.usdc) {
      return "1000000000000000";
    }
    final DeployedContract tokenContract =
        await ethService.loadContractWithGivenAddress(
            "token", EthereumAddress.fromHex(tokenAddress));
    final res = await ethService.query(tokenContract, "allowance",
        [await address, EthereumAddress.fromHex(marketMaker)]);

    return EthereumService.fromWei(res.single);
  }

  @override
  Future<String> approve(String tokenAddress, Gas gas) async {
    const amount = "10000000000000000000000000000";
    final DeployedContract tokenContract =
        await ethService.loadContractWithGivenAddress(
            "token", EthereumAddress.fromHex(tokenAddress));

    final res = ethService.submit(await credentials, tokenContract, "approve",
        [EthereumAddress.fromHex(marketMaker), EthereumService.getWei(amount)],
        gas: gas);
    return res;
  }

  @override
  Future<Transaction> makeApproveTransaction(String tokenAddress) async {
    const amount = "10000000000000000000000000000";
    final DeployedContract tokenContract =
        await ethService.loadContractWithGivenAddress(
            "token", EthereumAddress.fromHex(tokenAddress));
    final res = ethService.makeTransaction(
        await credentials,
        tokenContract,
        "approve",
        [EthereumAddress.fromHex(marketMaker), EthereumService.getWei(amount)]);
    return res;
  }

  @override
  Future<String> getTokenBalance(String tokenAddress) async {
    final DeployedContract tokenContract =
        await ethService.loadContractWithGivenAddress(
            "token", EthereumAddress.fromHex(tokenAddress));

    final res =
        await ethService.query(tokenContract, "balanceOf", [await address]);
    if (tokenAddress == MaticStockService.usdc) {
      return EthereumService.fromWei(res.single, "usdc");
    }
    return EthereumService.fromWei(res.single);
  }

  @override
  Future<String> buy(String tokenAddress, String amount,
      List<ContractInputData> oracles, Gas gas,
      {String? maxPrice}) async {
    final DeployedContract contract =
        await ethService.loadContractWithGivenAddress(
            "bscSynchronizer", EthereumAddress.fromHex(this.marketMaker));
    final ContractInputData info = oracles[0];

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
          [oracles[0].signs['buy']!.getV(), oracles[1].signs['buy']!.getV()],
          [oracles[0].signs['buy']!.getR(), oracles[1].signs['buy']!.getR()],
          [oracles[0].signs['buy']!.getS(), oracles[1].signs['buy']!.getS()],
        ],
        gas: gas);
  }

  @override
  Future<String> sell(String tokenAddress, String amount,
      List<ContractInputData> oracles, Gas gas) async {
    final DeployedContract contract =
        await ethService.loadContractWithGivenAddress(
            "bscSynchronizer", EthereumAddress.fromHex(this.marketMaker));
    final ContractInputData info = oracles[0];

    return ethService.submit(
        await credentials,
        contract,
        "sellFor",
        [
          await address,
          info.getMultiplier(),
          EthereumAddress.fromHex(tokenAddress),
          EthereumService.getWei(amount),
          info.getFee(),
          [oracles[0].getBlockNo(), oracles[1].getBlockNo()],
          [oracles[0].getPrice(), oracles[1].getPrice()],
          [oracles[0].signs['sell']!.getV(), oracles[1].signs['sell']!.getV()],
          [oracles[0].signs['sell']!.getR(), oracles[1].signs['sell']!.getR()],
          [oracles[0].signs['sell']!.getS(), oracles[1].signs['sell']!.getS()],
        ],
        gas: gas);
  }

  @override
  Future<String> getUsedCap() async {
    final DeployedContract contract =
        await ethService.loadContractWithGivenAddress(
            "bscSynchronizer", EthereumAddress.fromHex(this.marketMaker));
    final res = await ethService.query(contract, "remainingDollarCap", []);
    return EthereumService.fromWei(res.single, "usdc");
  }

  @override
  Future<Transaction> makeBuyTransaction(
      String tokenAddress, String amount, List<ContractInputData> oracles,
      {String? maxPrice}) async {
    final DeployedContract contract =
        await ethService.loadContractWithGivenAddress(
            "bscSynchronizer", EthereumAddress.fromHex(this.marketMaker));
    final ContractInputData info = oracles[0];

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
        [oracles[0].signs['buy']!.getV(), oracles[1].signs['buy']!.getV()],
        [oracles[0].signs['buy']!.getR(), oracles[1].signs['buy']!.getR()],
        [oracles[0].signs['buy']!.getS(), oracles[1].signs['buy']!.getS()],
      ],
    );
  }

  @override
  Future<Transaction> makeSellTransaction(String tokenAddress, String amount,
      List<ContractInputData> oracles) async {
    final DeployedContract contract =
        await ethService.loadContractWithGivenAddress(
            "bscSynchronizer", EthereumAddress.fromHex(this.marketMaker));
    final ContractInputData info = oracles[0];

    return ethService.makeTransaction(await credentials, contract, "sellFor", [
      await address,
      info.getMultiplier(),
      EthereumAddress.fromHex(tokenAddress),
      EthereumService.getWei(amount),
      info.getFee(),
      [oracles[0].getBlockNo(), oracles[1].getBlockNo()],
      [oracles[0].getPrice(), oracles[1].getPrice()],
      [oracles[0].signs['sell']!.getV(), oracles[1].signs['sell']!.getV()],
      [oracles[0].signs['sell']!.getR(), oracles[1].signs['sell']!.getR()],
      [oracles[0].signs['sell']!.getS(), oracles[1].signs['sell']!.getS()],
    ]);
  }
}
