import 'package:calculator/ui/screens/home_state.dart';
import 'package:calculator/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonsPad extends StatelessWidget {
  const ButtonsPad({
    super.key,
    required this.isLandscape,
  });

  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeState>(builder: (_, state, __) {
      return Column(
        children: [
          for (var row = 0;
              row < state.getButtons(isLandscape).keys.length;
              row++)
            Expanded(
              child: Row(
                children: state
                    .getButtons(isLandscape)[row]!
                    .map((e) => Expanded(
                        flex: !isLandscape
                            ? e.label == '='
                                ? 2
                                : 1
                            : 1,
                        child: Button(
                          item: e,
                        )))
                    .toList(),
              ),
            ),
        ],
      );
    });
  }
}
