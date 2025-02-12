import 'navigation_item.dart';
import 'package:flutter/material.dart';

class NavigationService {
  NavigationItem selectedNavItem;
  NavigationService({required this.selectedNavItem});

  bool canGoBack(BuildContext context) => Navigator.canPop(context);

  bool isSelected(NavigationItem item) => selectedNavItem == item;

  Future<Object?>? navigateTo(String routeName, BuildContext context,
      {bool replace = false, bool replaceAll = false, Object? arguments}) {
    if (replace)
      Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
    else if (replaceAll)
      Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false,
          arguments: arguments);
    else
      return Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  void goBack(BuildContext context, [dynamic result]) {
    Navigator.pop(context, result);
  }
}
