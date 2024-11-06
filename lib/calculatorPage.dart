import 'package:calculator_app/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expressions/expressions.dart';
class Calculatorpage extends StatefulWidget {
  const Calculatorpage({super.key});

  @override
  State<Calculatorpage> createState() => _CalculatorpageState();
}

class _CalculatorpageState extends State<Calculatorpage> {
  bool themebtnclick = true;
  String _displayText = "";
  String _operation = "";
  double num1 = 0.0;
  double num2 = 0.0;
  
void buttonPressed(String buttonText){
  setState(() {
  if(buttonText == "AC"){
  _displayText  = "";
  }
  else if (buttonText == "⌫") {
    if (_displayText.length > 1) {
          _displayText = _displayText.substring(0, _displayText.length - 1);
        } else {
          _displayText = "0";
        }
  }
  else if (buttonText == ".") {
    if (_displayText == "." || _displayText == "0.") {
      return;
        } else {
          _displayText += buttonText;
        }
  }
  else if (buttonText == "0") {
    if (_displayText == "0") {
      _displayText = "0";
        } else {
          _displayText += buttonText;
        }
  }
  else if(buttonText == "="){
    evaluateExpression();
  }
  else{
    _displayText += buttonText;
  }
  });
}
void evaluateExpression(){
  try{
    final expression = Expression.parse(_displayText.replaceAll('×', '*').replaceAll('÷', '/'));
    const evaluator = ExpressionEvaluator();
    var result = evaluator.eval(expression, {});
    _displayText = result.toString();
    if (result is double && result == result.toInt()) {
        _displayText = result.toInt().toString();
      }
  }
  catch(e){
  _displayText = "Typing Error";
  }
}

Widget numsButton(String buttonText){
  return Expanded(
    child: RawMaterialButton(
      onPressed: (){
      buttonPressed(buttonText);
    },
    elevation: 2.0,
    fillColor: Colors.white,
      padding: const EdgeInsets.all(16.0),
      shape: const CircleBorder(),
    child: Text(buttonText,
    style: const TextStyle (
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      color: Colors.black),
      ),
    )
    );
}

Widget actionButton(String buttonText ){
  return Expanded(
    child: RawMaterialButton(
      onPressed: (){
      buttonPressed(buttonText);
    },
    elevation: 2.0,
    fillColor: Colors.grey.shade400,
      padding: const EdgeInsets.all(16.0),
      shape: const CircleBorder(),
    child: Text(buttonText,
    style: const TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      color: Colors.black),
      ),
    )
    );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Calculator"),
        actions: [IconButton(onPressed: (){
            setState(() {
              themebtnclick = !themebtnclick;
            });
            
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          }, icon:Icon((themebtnclick == false)? Icons.light_mode : Icons.dark_mode))

        ],),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Text(
                  _operation.isNotEmpty ? "$num1 $_operation $_displayText" : _displayText,
                  style: const TextStyle(
                    fontSize: 42.0,
                    fontWeight: FontWeight.bold,),
                ),
              ),
            ),
            const SizedBox(height: 60,),
            Row(
              children: [
                actionButton("AC"),
                actionButton("%"),
                actionButton("÷"),
                actionButton("⌫"),
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              
              children: [
                numsButton("7"),
                numsButton("8"),
                numsButton("9"),
                actionButton("×"),
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              children: [
                numsButton("4"),
                numsButton("5"),
                numsButton("6"),
                actionButton("-"),
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              children: [
                numsButton("1"),
                numsButton("2"),
                numsButton("3"),
                actionButton("+"),
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              children: [
                numsButton("00"),
                numsButton("0"),
                numsButton("."),
                RawMaterialButton(
                  onPressed: () {
                    buttonPressed("=");
                },
                elevation: 2.0,
                fillColor: const Color(0xff98725B),
                padding: const EdgeInsets.all(16.0),
                shape: const CircleBorder(),
                child: const Text("=",
                  style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
                  ),
                  ),
              ],
            ),
          ],
        ),
      ) 
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
}
