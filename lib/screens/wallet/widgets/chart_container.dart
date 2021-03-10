import 'package:deus_mobile/core/widgets/chart/util.dart';
import 'package:deus_mobile/core/widgets/custom_chart.dart';
import 'package:deus_mobile/models/chart_data_point.dart';
import 'package:deus_mobile/models/value_locked_chart_data.dart';
import 'package:deus_mobile/statics/my_colors.dart';
import 'package:deus_mobile/statics/styles.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ChartContainer extends StatefulWidget {
  final Future<List<ChartDataPoint>> chartPoints;

  ChartContainer({this.chartPoints});

  @override
  _ChartContainerState createState() => _ChartContainerState();
}

class _ChartContainerState extends State<ChartContainer> {
  Future<ValueLockedChartData> futureData;
  String timeSpanOfChart = 'Past Week';
  Duration _displayedChartDuration;

  SizedBox _bigHeightDivider = SizedBox(
    height: 20,
  );
  SizedBox _midHeightDivider = SizedBox(
    height: 10,
  );
  SizedBox _smallHeightDivider = SizedBox(
    height: 5,
  );

  Future<ValueLockedChartData> _getFutureChartData(Duration duration) async {
    ValueLockedChartData _randomTestData = ValueLockedChartData(
        lockedInCash: 563008.67,
        lockedInCrypto: 478.939,
        absoluteChange: 140355.32,
        relativeChange: 25.42,
        chartDataPoints: List.generate(
            100,
            (index) => ChartDataPoint(
                dateTime: DateTime.now().subtract(duration),
                value: Random().nextInt(500) / 100)));
    // _randomTestData.chartDataPoints.removeWhere((value) {
    //   return DateTime.now().difference(value.dateTime) >= duration;
    // });
    await Future.delayed(Duration(seconds: 5));
    return _randomTestData;
  }




  void _onTimeSelected(Duration dur) {
    setState(() {
      _displayedChartDuration = dur;
      timeSpanOfChart = durationTimeSpan[dur];
      futureData = _getFutureChartData(dur);
    });
  }

  @override
  void initState() {
    super.initState();
    futureData = _getFutureChartData(Duration(days: 7));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ValueLockedChartData>(
        future: futureData,
        builder: (context, snap) {
          return Column(children: [
            _buildChangeIndicator(snap),
            _midHeightDivider,
            _buildBody(snap),
          ]);
        });
  }

  Container _buildBody(AsyncSnapshot<ValueLockedChartData> snap) {
    final valueLockedData = snap.data;
    return Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            padding: EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color(MyColors.kWalletFillChart),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: MyColors.HalfBlack)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                snap.connectionState == ConnectionState.done
                    ? _buildHeader(
                    valueLockedData.lockedInCash,
                    valueLockedData.lockedInCrypto,
                    valueLockedData.absoluteChange,
                    valueLockedData.relativeChange,
                        snap.connectionState == ConnectionState.done)
                    : _buildHeader(
                        null, null, null, null, snap.connectionState == ConnectionState.done),
                _bigHeightDivider,
                snap.connectionState == ConnectionState.done
                    ? CustomChart(valueLockedData.chartDataPoints, _onTimeSelected)
                    : Center(
                        child: CircularProgressIndicator(),
                      )
              ],
            ),
          );
  }

  Container _buildChangeIndicator(AsyncSnapshot<ValueLockedChartData> snap) {
    return Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            width: double.infinity,
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 40),
            decoration: BoxDecoration(
                color: Color(MyColors.kWalletFillChart),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: MyColors.HalfBlack)),
            child: Center(
              child: Text(
                snap.connectionState == ConnectionState.done
                    ? 'TVL: ${snap.data.lockedInCrypto} ETH (\$${snap.data.lockedInCash})'
                    : 'TVL: --------- ETH(\$---------)', //TODO: Crypto kürzel

                style: MyStyles.whiteSmallTextStyle,
              ),
            ),
          );
  }

  Column _buildHeader(
      double lockedInCash,
      double lockedInCrypto,
      double absoluteChange,
      double relativeChange,
      bool isLoaded) {
    return Column(
      children: [
        Text(
          'YOUR VALUE LOCKED',
          style: MyStyles.lightWhiteSmallTextStyle,
        ),
        _midHeightDivider,
        Text(
          isLoaded
              ? '\$$lockedInCash / Ξ$lockedInCrypto'
              : '\$----- / -----',
          style: MyStyles.whiteMediumTextStyle,
        ),
        _midHeightDivider,
        Text(
          isLoaded
              ? '+$relativeChange% ($absoluteChange) $timeSpanOfChart'
              : '+--.--% (------) $timeSpanOfChart',
          style: MyStyles.greenSmallTextStyle,
        ),
      ],
    );
  }
}
