import 'package:calculator/ui/widgets/pane_and%20pad.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: LayoutBuilder(
        builder: (_, constraints) {
          return PaneAndPad(
            isLandscape: constraints.maxWidth > 600,
          );
        },
      )),
    );
  }
}
