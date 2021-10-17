import '../../core/widgets/coming_soon_screen.dart';
import 'package:flutter/material.dart';

class BlurredStakeLockScreen extends StatelessWidget {
  static const url = '/blurred-stake-lock';
  @override
  Widget build(BuildContext context) {
    return const ComingSoonScreen(
      imgPath: 'assets/blur_screens/lock_stake.jpg',
    );
  }
}
