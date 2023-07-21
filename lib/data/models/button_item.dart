import 'package:calculator/data/models/button_type.dart';

class ButtonItem {
  const ButtonItem({required this.label, required this.type});

  final String label;
  final ButtonType type;
}
