import 'dart:async';
import 'dart:ui';

import '../../../core/widgets/default_screen/default_screen.dart';
import '../../../core/widgets/default_screen/sync_chain_selector.dart';
import '../../../core/widgets/toast.dart';
import '../../../core/widgets/token_selector/matic_stock_selector_screen/matic_stock_selector_screen.dart';
import '../../../data_source/sync_data/matic_stock_data.dart';
import '../../../models/swap/crypto_currency.dart';
import '../../../models/swap/gas.dart';
import '../../../models/synthetics/stock.dart';
import '../../confirm_gas/confirm_gas.dart';
import '../synthetics_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';

import '../../../core/widgets/filled_gradient_selection_button.dart';
import '../../../core/widgets/selection_button.dart';
import '../../../core/widgets/svg.dart';
import '../../../core/widgets/swap_field.dart';
import '../../../data_source/currency_data.dart';
import '../../../models/transaction_status.dart';
import '../../../service/ethereum_service.dart';
import '../../../statics/my_colors.dart';
import '../../../statics/styles.dart';
import '../market_timer.dart';
import 'cubit/matic_synthetics_cubit.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as provider;

class MaticSyntheticsScreen extends StatefulWidget {
  static const route = '/matic_synthethics';

  @override
  _MaticSyntheticsScreenState createState() => _MaticSyntheticsScreenState();
}

class _MaticSyntheticsScreenState extends State<MaticSyntheticsScreen> {
  @override
  void initState() {
    context.read<MaticSyntheticsCubit>().init();
    super.initState();
  }

  @override
  void deactivate() {
    context.read<MaticSyntheticsCubit>().dispose();
    super.deactivate();
  }

  Widget _buildTransactionPending(TransactionStatus transactionStatus) {
    return Container(
      child: Toast(
        label: transactionStatus.label,
        message: transactionStatus.message,
        color: MyColors.ToastGrey,
        onPressed: () {
          if (transactionStatus.hash != "") {
            _launchInBrowser(transactionStatus.transactionUrl(chainId: 97)!);
          }
        },
        onClosed: () {
          context.read<MaticSyntheticsCubit>().closeToast();
        },
      ),
    );
  }

  Widget _buildTransactionSuccessFul(TransactionStatus transactionStatus) {
    return Container(
      child: Toast(
        label: transactionStatus.label,
        message: transactionStatus.message,
        color: MyColors.ToastGreen,
        onPressed: () {
          _launchInBrowser(transactionStatus.transactionUrl(chainId: 1)!);
        },
        onClosed: () {
          context.read<MaticSyntheticsCubit>().closeToast();
        },
      ),
    );
  }

  Widget _buildTransactionFailed(TransactionStatus transactionStatus) {
    return Container(
      child: Toast(
        label: transactionStatus.label,
        message: transactionStatus.message,
        color: MyColors.ToastRed,
        onPressed: () {
          _launchInBrowser(transactionStatus.transactionUrl(chainId: 1)!);
        },
        onClosed: () {
          context.read<MaticSyntheticsCubit>().closeToast();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      child: BlocBuilder<MaticSyntheticsCubit, SyntheticsState>(
          builder: (context, state) {
        if (state is SyntheticsLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SyntheticsErrorState) {
          return Center(
            child: Icon(Icons.refresh, color: MyColors.White),
          );
        }
        return _buildBody(state);
      }),
      chainSelector: SyncChainSelector(SyncChains.MATIC),
    );
  }

  Future<Gas?> showConfirmGasFeeDialog(Transaction transaction) async {
    final Gas? res = await showGeneralDialog(
      context: context,
      barrierColor: Colors.black38,
      barrierLabel: "Barrier",
      pageBuilder: (_, __, ___) => Align(
          alignment: Alignment.center,
          child: ConfirmGasScreen(
              transaction: transaction, network: Network.MATIC)),
      barrierDismissible: true,
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
        child: FadeTransition(
          child: child,
          opacity: anim1,
        ),
      ),
      transitionDuration: const Duration(milliseconds: 10),
    );
    return res;
  }

  Widget _buildBody(SyntheticsState state) {
    return SmartRefresher(
      enablePullDown: true,
      controller: state.refreshController,
      onRefresh: context.read<MaticSyntheticsCubit>().refresh,
      header: BezierHeader(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
          child: Center(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Release to Refresh",
                  style: MyStyles.lightWhiteSmallTextStyle,
                ),
                const Icon(Icons.refresh_sharp),
              ],
            ),
          )),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(MyStyles.mainPadding * 1.5),
        decoration: BoxDecoration(color: MyColors.Main_BG_Black),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(child: _buildUserInput(state)),
                _buildMarketTimer(state)
              ],
            ),
            _buildToastWidget(state),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInput(SyntheticsState state) {
    final SwapField fromField = new SwapField(
        direction: Direction.from,
        initialToken: state.fromToken,
        syncData: state.syncData as MaticStockData,
        selectAssetRoute: MaticStockSelectorScreen.url,
        controller: state.fromFieldController,
        tokenSelected: (selectedToken) async {
          await context
              .read<MaticSyntheticsCubit>()
              .fromTokenChanged(selectedToken);
        });

    // context.read<MaticSyntheticsCubit>().addListenerToFromField();

    final SwapField toField = new SwapField(
      direction: Direction.to,
      initialToken: state.toToken,
      controller: state.toFieldController,
      syncData: state.syncData as MaticStockData,
      selectAssetRoute: MaticStockSelectorScreen.url,
      tokenSelected: (selectedToken) {
        context.read<MaticSyntheticsCubit>().toTokenChanged(selectedToken);
      },
    );
    return Column(
      children: [
        fromField,
        const SizedBox(height: 12),
        InkWell(
            onTap: () {
              context.read<MaticSyntheticsCubit>().reverseSync();
            },
            child: Center(
                child: PlatformSvg.asset('images/icons/arrow_down.svg'))),
        const SizedBox(height: 12),
        toField,
        const SizedBox(height: 18),
        _buildModeButtons(state),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Price",
              style: MyStyles.whiteSmallTextStyle,
            ),
            Row(
              children: [
                Text(
                  state.isPriceRatioForward
                      // ignore: unnecessary_null_comparison
                      ? "${context.read<MaticSyntheticsCubit>().getPriceRatio()} ${state.fromToken != null ? state.fromToken.symbol : "asset name"} per ${state.toToken != null ? state.toToken!.symbol : "asset name"}"
                      // ignore: unnecessary_null_comparison
                      : "${context.read<MaticSyntheticsCubit>().getPriceRatio()} ${state.toToken != null ? state.toToken!.symbol : "asset name"} per ${state.fromToken != null ? state.fromToken.symbol : "asset name"}",
                  style: MyStyles.whiteSmallTextStyle,
                ),
                InkWell(
                  onTap: () {
                    context.read<MaticSyntheticsCubit>().reversePriceRatio();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 4.0),
                    child: PlatformSvg.asset("images/icons/exchange.svg",
                        width: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Opacity(
            opacity: state.isInProgress ? 0.5 : 1,
            child: _buildMainButton(state)),
        const SizedBox(
          height: 16,
        ),
        _buildRemainingCapacity(state),
      ],
    );
  }

  Widget _buildMainButton(SyntheticsState state) {
    if (state.marketClosed) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16.0),
        decoration: MyStyles.darkWithNoBorderDecoration,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "MARKETS ARE CLOSED",
            style: MyStyles.lightWhiteMediumTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (state is SyntheticsSelectAssetState) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16.0),
        decoration: MyStyles.darkWithNoBorderDecoration,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "SELECT ASSET",
            style: MyStyles.lightWhiteMediumTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (!state.approved) {
      return FilledGradientSelectionButton(
        label: 'Approve',
        onPressed: () async {
          final Transaction? transaction = await context
              .read<MaticSyntheticsCubit>()
              .makeApproveTransaction();
          WidgetsBinding.instance!.focusManager.primaryFocus?.unfocus();
          if (transaction != null) {
            final Gas? gas = await showConfirmGasFeeDialog(transaction);
            await context.read<MaticSyntheticsCubit>().approve(gas);
          }
        },
        gradient: MyColors.blueToPurpleGradient,
      );
    }

    if (state.fromFieldController.text == "" ||
        (double.tryParse(state.fromFieldController.text) != null &&
            double.tryParse(state.fromFieldController.text) == 0)) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16.0),
        decoration: MyStyles.darkWithNoBorderDecoration,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "ENTER AN AMOUNT",
            style: MyStyles.lightWhiteMediumTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    BigInt balance = BigInt.zero;
    if (state.fromToken is CryptoCurrency) {
      balance = (state.fromToken as CryptoCurrency).getBalance();
    } else {
      balance = (state.fromToken as Stock).getBalance()!;
    }
    if (balance <
        EthereumService.getWei(
            state.fromFieldController.text, state.fromToken.getTokenName())) {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16.0),
        decoration: MyStyles.darkWithNoBorderDecoration,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "INSUFFICIENT BALANCE",
            style: MyStyles.lightWhiteMediumTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return FilledGradientSelectionButton(
      label: state.fromToken == CurrencyData.dai ? 'Buy' : 'Sell',
      onPressed: () async {
        if (state.fromToken == CurrencyData.dai) {
          final Transaction? transaction =
              await context.read<MaticSyntheticsCubit>().makeBuyTransaction();
          WidgetsBinding.instance!.focusManager.primaryFocus?.unfocus();
          if (transaction != null) {
            final Gas? gas = await showConfirmGasFeeDialog(transaction);
            await context.read<MaticSyntheticsCubit>().buy(gas);
          }
        } else {
          final Transaction? transaction =
              await context.read<MaticSyntheticsCubit>().makeSellTransaction();
          WidgetsBinding.instance!.focusManager.primaryFocus?.unfocus();
          if (transaction != null) {
            final Gas? gas = await showConfirmGasFeeDialog(transaction);
            await context.read<MaticSyntheticsCubit>().sell(gas);
          }
        }
      },
      gradient: MyColors.blueToPurpleGradient,
    );
  }

  Container _buildModeButtons(SyntheticsState state) {
    return Container(
      child: Row(children: [
        Expanded(child: _buildLongButton(state)),
        const SizedBox(width: 8),
        Expanded(child: _buildShortButton(state)),
      ]),
    );
  }

  Widget _buildMarketTimer(SyntheticsState state) {
    return SizedBox(
//      width: getScreenWidth(context) - (SynchronizerScreen.kPadding * 2),
      child: MarketTimer(
        timerColor: state.marketTimerClosed
            ? const Color(0xFFD40000)
            : const Color(0xFF00D16C),
        onEnd: context.read<MaticSyntheticsCubit>().marketTimerFinished(),
        label: state.marketTimerClosed
            ? 'UNTIL TRADING OPENS'
            : 'UNTIL TRADING CLOSES',
        end: context.read<MaticSyntheticsCubit>().marketStatusChanged(),
      ),
    );
  }

  Widget _buildShortButton(SyntheticsState state) {
    return SelectionButton(
      label: 'SHORT',
      onPressed: (bool selected) {
        context.read<MaticSyntheticsCubit>().setMode(Mode.SHORT);
      },
      selected: state.mode == Mode.SHORT,
      gradient: MyColors.blueToPurpleGradient,
    );
  }

  Widget _buildLongButton(SyntheticsState state) {
    return SelectionButton(
      label: 'LONG',
      onPressed: (bool selected) {
        context.read<MaticSyntheticsCubit>().setMode(Mode.LONG);
      },
      selected: state.mode == Mode.LONG,
      gradient: MyColors.blueToPurpleGradient,
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildToastWidget(SyntheticsState state) {
    if (state is SyntheticsTransactionPendingState && state.showingToast) {
      return Align(
          alignment: Alignment.bottomCenter,
          child: _buildTransactionPending(state.transactionStatus));
    } else if (state is SyntheticsTransactionFinishedState &&
        state.showingToast) {
      if (state.transactionStatus.status == Status.PENDING) {
        return Align(
            alignment: Alignment.bottomCenter,
            child: _buildTransactionPending(state.transactionStatus));
      } else if (state.transactionStatus.status == Status.SUCCESSFUL) {
        return Align(
            alignment: Alignment.bottomCenter,
            child: _buildTransactionSuccessFul(state.transactionStatus));
      } else if (state.transactionStatus.status == Status.FAILED) {
        return Align(
            alignment: Alignment.bottomCenter,
            child: _buildTransactionFailed(state.transactionStatus));
      }
    }
    return Container();
  }

  _buildRemainingCapacity(SyntheticsState state) {
    return Row(children: [
      Text(
        "Remaining Synchronize Capacity",
        style: MyStyles.lightWhiteSmallTextStyle,
      ),
      const Spacer(),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
              radius: 12,
              backgroundImage:
                  provider.Svg("assets/images/currencies/usdc.svg")),
          const SizedBox(
            width: 6,
          ),
          FutureBuilder(
              future: context.read<MaticSyntheticsCubit>().getRemCap(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Text(
                    EthereumService.formatDouble(snapshot.data.toString(), 2),
                    overflow: TextOverflow.clip,
                    style: MyStyles.lightWhiteSmallTextStyle,
                  );
                } else {
                  return Text(
                    "---",
                    style: MyStyles.lightWhiteSmallTextStyle,
                  );
                }
              })
        ],
      ),
    ]);
  }
}
