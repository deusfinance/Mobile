import '../stock_selector.dart';
import '../../../../data_source/sync_data/stock_data.dart';
import '../../../../models/synthetics/stock.dart';

import '../token_selector.dart';
import 'package:flutter/material.dart';

class StockSelectorScreen extends StatefulWidget {
  static const url = '/MainnetAssetSelector';
  final StockData stockData;

  StockSelectorScreen(this.stockData);

  @override
  _StockSelectorScreenState createState() => _StockSelectorScreenState();
}

class _StockSelectorScreenState extends State<StockSelectorScreen> {
  TextEditingController searchController = new TextEditingController();
  late List<Stock> stocks;

  @override
  void initState() {
    stocks = widget.stockData.conductedStocks;
    searchController.addListener(search);
    super.initState();
  }

  @override
  void dispose() {
    searchController.removeListener(search);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TokenSelector(
        selector: StockSelector(stocks, widget.stockData),
        title: 'Asset',
        showSearchBar: true,
        searchController: searchController,
      ),
    );
  }

  void search() async {
    final String pattern = searchController.text;
    stocks = await Future.sync(() {
      return widget.stockData.conductedStocks
          .where((element) =>
              element.symbol.toLowerCase().contains(pattern) ||
              element.name.toLowerCase().contains(pattern))
          .toList();
    });
    setState(() {});
  }
}
