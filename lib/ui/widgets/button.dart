import 'package:calculator/data/models/button_item.dart';
import 'package:calculator/data/models/button_type.dart';
import 'package:calculator/ui/screens/home_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Button extends StatelessWidget {
  const Button({super.key, required this.item});

  final ButtonItem item;

  void onClickButton(BuildContext context) {
    Provider.of<HomeState>(context, listen: false).onClickButton(item);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onClickButton(context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: item.label == 'AC'
                ? const BorderRadius.only(topLeft: Radius.circular(32.0))
                : item.label == '/'
                    ? const BorderRadius.only(topRight: Radius.circular(32.0))
                    : null,
            border: Border.all(
                color: Theme.of(context).colorScheme.outline, width: 0.5),
            color: item.type == ButtonType.binaryOperator &&
                    Provider.of<HomeState>(
                          context,
                        ).operator ==
                        item.label
                ? Theme.of(context).colorScheme.primaryContainer
                : item.type == ButtonType.digit
                    ? Theme.of(context).colorScheme.primary
                    : item.label == '='
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.secondary,
          ),
          child: Center(
              child: Text(
            item.label,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: item.type == ButtonType.binaryOperator &&
                          Provider.of<HomeState>(
                                context,
                              ).operator ==
                              item.label
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : item.type == ButtonType.digit
                          ? Theme.of(context).colorScheme.onPrimary
                          : item.label == '='
                              ? Theme.of(context).colorScheme.onTertiary
                              : Theme.of(context).colorScheme.onSecondary,
                ),
          )),
        ));
  }
}
