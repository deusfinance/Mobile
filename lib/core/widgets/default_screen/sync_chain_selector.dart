import 'dart:ui';

import 'package:deus_mobile/core/util/responsive.dart';
import 'package:deus_mobile/core/widgets/svg.dart';
import 'package:deus_mobile/locator.dart';
import 'package:deus_mobile/routes/navigation_service.dart';
import 'package:deus_mobile/screens/swap/swap_screen.dart';
import 'package:deus_mobile/screens/synthetics/bsc_synthetics/bsc_synthetics_screen.dart';
import 'package:deus_mobile/screens/synthetics/heco_synthetics/heco_synthetics_screen.dart';
import 'package:deus_mobile/screens/synthetics/mainnet_synthetics/mainnet_synthetics_screen.dart';
import 'package:deus_mobile/screens/synthetics/matic_synthetics/matic_synthetics_screen.dart';
import 'package:deus_mobile/screens/synthetics/xdai_synthetics/xdai_synthetics_screen.dart';
import 'package:deus_mobile/screens/wallet_settings_screen/wallet_settings_screen.dart';
import 'package:deus_mobile/statics/my_colors.dart';
import 'package:deus_mobile/statics/styles.dart';
import 'package:flutter/material.dart';

enum SyncChains { xDAI, MAINNET, BSC, HECO, MATIC }

class SyncChainSelector extends StatefulWidget {
  SyncChains selectedChain;
  SyncChainSelector(this.selectedChain);

  @override
  _SyncChainSelectorState createState() => _SyncChainSelectorState();
}

class _SyncChainSelectorState extends State<SyncChainSelector> {
  @override
  Widget build(BuildContext context) {
    return _buildChainContainer();
  }

  Widget _buildChainContainer() {
    return InkWell(
      onTap: () {
        showChainSelectDialog();
      },
      child: Container(
          width: 120,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Color(MyColors.kAddressBackground).withOpacity(0.5)),
              color: Color(MyColors.kAddressBackground).withOpacity(0.25),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Row(
              children: [
                Expanded(
                  child: Text(
                    getChainName(widget.selectedChain),
                    style: MyStyles.whiteSmallTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Spacer(),
                PlatformSvg.asset('images/icons/chevron_down.svg'),
              ],
            ),),
    );
  }

  String getChainName(SyncChains chain) {
    switch (chain) {
      case SyncChains.xDAI:
        return "xDai";
      case SyncChains.MAINNET:
        return "ETH";
      case SyncChains.BSC:
        return "BSC";
      case SyncChains.HECO:
        return "Heco";
      case SyncChains.MATIC:
        return "Matic(Polygon) (SOON)";
    }
  }

  void showChainSelectDialog() {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black38,
      barrierLabel: "Barrier",
      pageBuilder: (_, __, ___) => Align(
        alignment: Alignment.center,
        child: Material(
          child: Container(
            width: getScreenWidth(context) - 50,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color(MyColors.kAddressBackground).withOpacity(0.5)),
                  color: Color(MyColors.kAddressBackground).withOpacity(0.25),
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    child:Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Select your Network',
                          style: MyStyles.whiteSmallTextStyle,
                        ),
                      ),
                  ),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: (){
                      locator<NavigationService>().navigateTo(XDaiSyntheticsScreen.route, context, replaceAll: true);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: widget.selectedChain == SyncChains.xDAI?MyColors.greenToBlueGradient:null,
                          border: Border.all(color: Colors.white)
                      ),
                      padding: EdgeInsets.all(8),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            getChainName(SyncChains.xDAI),
                            style: widget.selectedChain == SyncChains.xDAI?MyStyles.blackMediumTextStyle:MyStyles.whiteMediumTextStyle,
                          ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  // Divider(height: 10, thickness: 2, color: Color(MyColors.kAddressBackground).withOpacity(0.5),),
                  InkWell(
                    onTap: (){
                      locator<NavigationService>().navigateTo(MainnetSyntheticsScreen.route, context, replaceAll: true);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: widget.selectedChain == SyncChains.MAINNET?MyColors.greenToBlueGradient:null,
                          border: Border.all(color: Colors.white)
                      ),
                      padding: EdgeInsets.all(8),

                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            getChainName(SyncChains.MAINNET),
                            style: widget.selectedChain == SyncChains.MAINNET?MyStyles.blackMediumTextStyle:MyStyles.whiteMediumTextStyle,
                          ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  // Divider(height: 10, thickness: 2, color: Color(MyColors.kAddressBackground).withOpacity(0.5),),
                  InkWell(
                    onTap: (){
                      locator<NavigationService>().navigateTo(BscSyntheticsScreen.route, context, replaceAll: true);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: widget.selectedChain == SyncChains.BSC?MyColors.greenToBlueGradient:null,
                          border: Border.all(color: Colors.white)
                      ),
                      padding: EdgeInsets.all(8),

                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            getChainName(SyncChains.BSC),
                            style: widget.selectedChain == SyncChains.BSC?MyStyles.blackMediumTextStyle:MyStyles.whiteMediumTextStyle,
                          ),
                        ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  // Divider(height: 10, thickness: 2, color: Color(MyColors.kAddressBackground).withOpacity(0.5),),
                  InkWell(
                    onTap: (){
                      locator<NavigationService>().navigateTo(HecoSyntheticsScreen.route, context, replaceAll: true);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: widget.selectedChain == SyncChains.HECO?MyColors.greenToBlueGradient:null,
                          border: Border.all(color: Colors.white)
                      ),
                      padding: EdgeInsets.all(8),

                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            getChainName(SyncChains.HECO),
                            style: widget.selectedChain == SyncChains.HECO?MyStyles.blackMediumTextStyle:MyStyles.whiteMediumTextStyle,
                          ),
                        ),
                      ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  // Divider(height: 10, thickness: 2, color: Color(MyColors.kAddressBackground).withOpacity(0.5),),
                  InkWell(
                    onTap: (){
                      // locator<NavigationService>().goBack(context);
                      // locator<NavigationService>().navigateTo(MaticSyntheticsScreen.route, context, replace: true);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: widget.selectedChain == SyncChains.MATIC?MyColors.greenToBlueGradient:null,
                          border: Border.all(color: Colors.white)
                      ),
                      padding: EdgeInsets.all(8),

                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            getChainName(SyncChains.MATIC),
                            style: widget.selectedChain == SyncChains.MATIC?MyStyles.blackMediumTextStyle:MyStyles.whiteMediumTextStyle,
                          ),
                        ),
                    ),
                  ),
                ],
              )),
        ),
      ),
      barrierDismissible: true,
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
        child: FadeTransition(
          child: child,
          opacity: anim1,
        ),
      ),
      transitionDuration: Duration(milliseconds: 10),
    );
  }
}
