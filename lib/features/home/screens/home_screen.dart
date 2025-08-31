import 'package:flutter/material.dart';

import '../../../features/shared/widgets/main_navigation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainNavigation(initialIndex: 0);
  }
}
