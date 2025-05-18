import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String _input = ''; 
  String _result = '';  
  bool _isResult = false;  

  void _buttonPressed(String value) {
    setState(() {
      if (value == 'AC') {
        
        _input = '';
        _result = '';
        _isResult = false;
      } else if (value == '⌫') {
        
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else if (value == '=') {

        try {
          String processedInput = _input
              .replaceAll('×', '*')
              .replaceAll('÷', '/')
              .replaceAll('√', 'sqrt');
          
          
          Parser p = Parser();
          Expression exp = p.parse(processedInput);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);

          _result = eval.toString();  
          _input = _result;  
          _isResult = true;  
        } catch (e) {
          _result = 'Error';  
        }
      } else {
        
        if (_isResult) {
          _input = _result + value; 
          _result = '';  
          _isResult = false;
        } else {
          _input += value; 
        }
      }
    });
  }

  int _factorial(int n) {
    if (n < 0) throw Exception('Negative factorial');
    return n == 0 ? 1 : n * _factorial(n - 1);
  }

  Widget _buildButton(String text, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? const Color.fromARGB(255, 211, 235, 254),
            padding: EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          onPressed: () => _buttonPressed(text),
          child: Text(
            text,
            style: TextStyle(fontSize: 30, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      children: buttons
          .map((text) => _buildButton(
                text,
                color: (text == '='
                    ? const Color.fromARGB(255, 155, 238, 158)
                    : text == 'AC'
                        ? const Color.fromARGB(255, 248, 234, 247)
                        : text == '⌫'
                            ? Colors.orange
                            : null),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Advanced Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Text(
                  _input, 
                  style: TextStyle(fontSize: 40),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            SizedBox(height: 80),
            
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Text(
                  _result, 
                  style: TextStyle(fontSize: 50, color: Colors.grey),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            SizedBox(height: 30),
            
            _buildButtonRow(['(', ')', '√', '^']),
            _buildButtonRow(['7', '8', '9', '÷']),
            _buildButtonRow(['4', '5', '6', '×']),
            _buildButtonRow(['1', '2', '3', '-']),
            _buildButtonRow(['0', '.', '%', '+']),
            _buildButtonRow(['!', '⌫', 'AC', '=']),
          ],
        ),
      ),
    );
  }
}
