// ignore_for_file: must_be_immutable, prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Calculator();
}

class _Calculator extends State<Calculator> {
  final int lightgreyC = 0xffbdbdbd;
  final int orangeC = 0xffffab00;
  final int blackC = 0xff000000;
  final int whiteC = 0xffffffff;
  int button1 = 0xffffab00;
  int button2 = 0xffffab00;
  int button3 = 0xffffab00;
  int button4 = 0xffffab00;
  int text1 = 0xffffffff;
  int text2 = 0xffffffff;
  int text3 = 0xffffffff;
  int text4 = 0xffffffff;
  String input = '0';
  String ch = '';
  String clr = 'AC';
  bool news = false;
  bool neg = false;
  bool hasDelete = false;
  bool isFirst = true;
  double result = 0.0;
  double var1 = 0.0;
  double var2 = 0.0;

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        input = '0';
        ch = '';
        clr = 'AC';
        news = false;
        isFirst = false;
        result = 0.0;
        var1 = 0.0;
        neg = false;
        var2 = 0.0;
        formatColors();
      } else if (buttonText == 'C') {
        clr = 'AC';
        input = '0';
      } else if (buttonText == '±') {
        var2 = parseFormattedNumber(input);
        if (var2 < 0) {
          neg = false;
        } else {
          neg = true;
        }

        input = formatType(var2);
      } else if (buttonText == '%') {
        var1 = parseFormattedNumber(input);
        result = var1 / 100;
        news = true;
        input = formatNumber(result);
      } else if (buttonText == '÷') {
        var1 = parseFormattedNumber(input);
        ch = '/';
        isFirst = true;
        formatColors();
        button1 = whiteC;
        text1 = orangeC;
      } else if (buttonText == 'x') {
        var1 = parseFormattedNumber(input);
        ch = '*';
        isFirst = true;
        formatColors();
        button2 = whiteC;
        text2 = orangeC;
      } else if (buttonText == '-') {
        var1 = parseFormattedNumber(input);
        ch = '-';
        isFirst = true;
        formatColors();
        button3 = whiteC;
        text3 = orangeC;
      } else if (buttonText == '+') {
        var1 = parseFormattedNumber(input);
        ch = '+';
        isFirst = true;
        formatColors();
        button4 = whiteC;
        text4 = orangeC;
        neg = false;
      } else if (buttonText == ',') {
        input += ',';
      } else if (buttonText == '=') {
        neg = false;
        try {
          if (ch == '+') {
            var1 = var1 + parseFormattedNumber(input);
            input = formatNumber(var1);
          } else if (ch == '-') {
            var1 = var1 - parseFormattedNumber(input);
            input = formatNumber(var1);
          } else if (ch == '*') {
            var1 = var1 * parseFormattedNumber(input);
            input = formatNumber(var1);
          } else if (ch == '/') {
            var1 = var1 / parseFormattedNumber(input);
            input = formatNumber(var1);
          } else {
            input = 'Error';
          }
          news = true;
          formatColors();
        } catch (e) {
          formatColors();
          input = 'Error';
          news = true;
        }
      } else {
        clr = 'C';
        if (input == '0' || news || isFirst) {
          input = '';
          input += buttonText;
          var2 = parseFormattedNumber(input);
          input = formatNumber(var2);
          news = false;
          isFirst = false;
        } else {
          input += buttonText;
          var2 = parseFormattedNumber(input);
          input = formatNumber(var2);
        }
      }
    });
  }

  void formatColors() {
    button1 = orangeC;
    button2 = orangeC;
    button3 = orangeC;
    button4 = orangeC;
    text1 = whiteC;
    text2 = whiteC;
    text3 = whiteC;
    text4 = whiteC;
  }

  double parseFormattedNumber(String formattedNumber) {
    formattedNumber = formattedNumber
        .replaceAll('.', '_')
        .replaceAll(',', '.')
        .replaceAll('_', ',');
    String cleanedText = formattedNumber.replaceAll(RegExp(r'[^0-9.-]'), '');
    return double.parse(cleanedText);
  }

  String formatNumber(double number) {
    final format = NumberFormat("#,###.##", "en_US");
    String res = format.format(number);
    res = res.replaceAll('.', '_').replaceAll(',', '.').replaceAll('_', ',');
    return res;
  }

  String formatType(double number) {
    final format = NumberFormat("#,###.##", "en_US");
    String res = format.format(number);
    if (!neg) {
      res = res.substring(1);
    } else {
      if (number < 0) {
        res = res;
      } else {
        res = '-$res';
      }
    }
    res = res.replaceAll('.', '_').replaceAll(',', '.').replaceAll('_', ',');
    return res;
  }

  String checkInt(String inss) {
    double var3 = parseFormattedNumber(inss);
    String str = var3.toString();
    if (str.contains('.')) {
      return inss;
    } else {
      return var3.toInt().toString();
    }
  }

  void _deleteLast(DragUpdateDetails details) {
    if (!hasDelete) {
      setState(() {
        if (input != '0') {
          if (input.length != 1) {
            String var3 = checkInt(input);
            var3 = var3.substring(0, var3.length - 1);
            double var4 = parseFormattedNumber(var3);
            input = formatNumber(var4);
          } else {
            input = '0';
          }
        }
        hasDelete = true;
      });
    }
  }

  void _resetHasDelete(DragEndDetails details) {
    setState(() {
      hasDelete = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onPanUpdate: _deleteLast,
              onPanEnd: _resetHasDelete,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(18.0),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 20,
                        maxHeight: double.infinity),
                    color: Colors.black,
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        input,
                        style: TextStyle(
                            fontSize: 80,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CalculatorButton(
                    text: clr,
                    hexCode: lightgreyC,
                    colorCode: blackC,
                    onPressed: _onButtonPressed),
                CalculatorButton(
                    text: '±',
                    hexCode: lightgreyC,
                    colorCode: blackC,
                    onPressed: _onButtonPressed),
                CalculatorButton(
                    text: '%',
                    hexCode: lightgreyC,
                    colorCode: blackC,
                    onPressed: _onButtonPressed),
                CalculatorButton(
                    text: '÷',
                    hexCode: button1,
                    colorCode: text1,
                    onPressed: _onButtonPressed),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CalculatorButton(text: '7', onPressed: _onButtonPressed),
                CalculatorButton(text: '8', onPressed: _onButtonPressed),
                CalculatorButton(text: '9', onPressed: _onButtonPressed),
                CalculatorButton(
                    text: 'x',
                    hexCode: button2,
                    colorCode: text2,
                    onPressed: _onButtonPressed),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CalculatorButton(text: '4', onPressed: _onButtonPressed),
                CalculatorButton(text: '5', onPressed: _onButtonPressed),
                CalculatorButton(text: '6', onPressed: _onButtonPressed),
                CalculatorButton(
                    text: '-',
                    hexCode: button3,
                    colorCode: text3,
                    onPressed: _onButtonPressed),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CalculatorButton(text: '1', onPressed: _onButtonPressed),
                CalculatorButton(text: '2', onPressed: _onButtonPressed),
                CalculatorButton(text: '3', onPressed: _onButtonPressed),
                CalculatorButton(
                    text: '+',
                    hexCode: button4,
                    colorCode: text4,
                    onPressed: _onButtonPressed),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CalculatorButton(
                    text: '0', wWeight: 170, onPressed: _onButtonPressed),
                CalculatorButton(text: ',', onPressed: _onButtonPressed),
                CalculatorButton(
                  text: '=',
                  hexCode: orangeC,
                  onPressed: _onButtonPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  int hexCode;
  int colorCode;
  double hHeight;
  double wWeight;
  double sizeText;
  bool selectedItem;
  Function(String) onPressed;
  CalculatorButton(
      {required this.text,
      required this.onPressed,
      this.selectedItem = false,
      this.hexCode = 0xff424242,
      this.colorCode = 0xffffffff,
      this.wWeight = 80,
      this.hHeight = 80,
      this.sizeText = 50});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () => onPressed(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(hexCode),
          fixedSize: Size(wWeight, hHeight),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: sizeText,
              color: Color(colorCode),
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
