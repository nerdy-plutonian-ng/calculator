import 'package:calculator/ui/screens/home_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'buttons_pad.dart';
import 'display_pane.dart';

class PaneAndPad extends StatelessWidget {
  const PaneAndPad({super.key, required this.isLandscape});

  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeState>(
      builder: (_, state, __) {
        return Column(
          children: [
            Expanded(flex: isLandscape ? 1 : 2, child: const DisplayPane()),
            Expanded(
                flex: isLandscape ? 1 : 3,
                child: ButtonsPad(
                  isLandscape: isLandscape,
                )),
          ],
        );
      },
    );
  }
}
