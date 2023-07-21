import 'dart:math';

import 'package:calculator/data/models/button_type.dart';
import 'package:calculator/data/repositories/button_items.dart';
import 'package:calculator/data/repositories/db_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/button_item.dart';

class HomeState with ChangeNotifier {
  HomeState(this._saver) {
    _saver.openDb();
  }

  final DbSaver _saver;

  static final NumberFormat format = NumberFormat('#,##0.###');

  String display = '';

  String _memory = '';

  String operator = '';

  bool _shouldClear = false;

  var _expression = '';

  var isShowingResultPane = true;

  List<Map<String, Object?>> history = [];

  changePane() {
    isShowingResultPane = !isShowingResultPane;
    if (!isShowingResultPane) {
      getHistory();
    }
    notifyListeners();
  }

  _reset() {
    display = '';
    _memory = '';
    operator = '';
    _shouldClear = false;
    _expression = '';
  }

  Map<int, List<ButtonItem>> getButtons(bool isLandscape) {
    final allButtons = <int, List<ButtonItem>>{};
    var index = 0;
    for (var i = 0;
        i < (isLandscape ? landscapeButtons.length : portraitButtons.length);
        i++) {
      if (i != 0 && i % (isLandscape ? 6 : 4) == 0) {
        index++;
      }
      if (allButtons[index] == null) {
        allButtons[index] = [
          isLandscape ? landscapeButtons[i] : portraitButtons[i]
        ];
      } else {
        allButtons[index]
            ?.add(isLandscape ? landscapeButtons[i] : portraitButtons[i]);
      }
    }
    return allButtons;
  }

  getHistory() {
    _saver.getHistory().then((response) {
      if (response != null && response.isNotEmpty) {
        history.clear();
        history.addAll(response);
        notifyListeners();
      }
    });
  }

  onClickButton(ButtonItem item) {
    switch (item.type) {
      case ButtonType.unaryOperator:
        if (item.label == 'AC') {
          _reset();
        } else if (item.label == '<=' && display.isNotEmpty) {
          display = display.substring(0, display.length - 1);
          _expression = _expression.substring(0, _expression.length - 1);
        } else if (display.isNotEmpty) {
          _expression = '$_expression${item.label}';
          display = _performOperation(num.parse(display), null, item.label)
              .toString();
        }
        break;
      case ButtonType.binaryOperator:
        _expression = '$_expression${item.label}';
        if (item.label == '=' &&
            _memory.isNotEmpty &&
            display.isNotEmpty &&
            operator.isNotEmpty) {
          display = format.format(_performOperation(
              format.parse(_memory), format.parse(display), operator));
          _memory = '';
          operator = '';
          _shouldClear = true;
          _saver.getHistory().then((history) {
            if (history != null) {
              _saver.addToHistory({
                'id': const Uuid().v4(),
                'expression': _expression,
                'result': format.parse(display),
                'date': DateTime.now().toIso8601String()
              }).then((res) {
                _expression = '';
                if (res) {
                  getHistory();
                }
              });
            }
          });
        } else if (item.label != '=') {
          if (operator.isEmpty) {
            operator = item.label;
            _memory = display;
          } else {
            if (_memory.isEmpty) {
              _memory = display;
            } else {
              _memory = format.format(_performOperation(
                  format.parse(_memory), format.parse(display), operator));
            }
            operator = item.label;
          }
          _shouldClear = true;
        }
        break;
      case ButtonType.digit:
        _expression = '$_expression${item.label}';
        if (_shouldClear) {
          display = item.label;
          _shouldClear = false;
        } else {
          display = '$display${item.label}';
        }

        break;
    }
    notifyListeners();
  }

  num _performOperation(num num1, num? num2, String operator) {
    switch (operator) {
      case '+':
        return num1 + (num2 ?? 0);
      case '-':
        return num1 - (num2 ?? 0);
      case '*':
        return num1 * (num2 ?? 1);
      case '/':
        return num1 / (num2 ?? 1);
      case '%':
        return num1 % (num2 ?? 1);
      case 'v2':
        return sqrt(num1);
      case 'x2':
        return pow(num1, 2);
      case 'tan':
        return tan(num1);
      case 'sin':
        return sin(num1);
      case 'cos':
        return cos(num1);
      case '+/-':
        return -num1;
      default:
        throw ArgumentError('Invalid operator: $operator');
    }
  }
}
