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
  String _input = '';  // Stores the user input.
  String _result = '';  // Stores the result after calculation.
  bool _isResult = false;  // Flag to track if result is being shown.

  void _buttonPressed(String value) {
    setState(() {
      if (value == 'AC') {
        // Clear everything when AC is pressed.
        _input = '';
        _result = '';
        _isResult = false;
      } else if (value == '⌫') {
        // Remove the last character when backspace is pressed.
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
      } else if (value == '=') {
        // Evaluate the expression when '=' is pressed.
        try {
          String processedInput = _input
              .replaceAll('×', '*')
              .replaceAll('÷', '/')
              .replaceAll('√', 'sqrt');
          
          // Use the math_expressions library to parse and evaluate the expression.
          Parser p = Parser();
          Expression exp = p.parse(processedInput);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);

          _result = eval.toString();  // Store the result of the calculation.
          _input = _result;  // Set the result as the new input for further operations.
          _isResult = true;  // Flag to indicate result is available for further calculations.
        } catch (e) {
          _result = 'Error';  // Handle error in expression evaluation.
        }
      } else {
        // If result is already shown, treat the result as the new first operand for the next operation.
        if (_isResult) {
          _input = _result + value;  // Start fresh with the result and the new operator.
          _result = '';  // Reset the result because new calculation has started.
          _isResult = false;
        } else {
          _input += value;  // Append the value of the pressed button to the input.
        }
      }
    });
  }

  // Function to calculate factorial.
  int _factorial(int n) {
    if (n < 0) throw Exception('Negative factorial');
    return n == 0 ? 1 : n * _factorial(n - 1);
  }

  // Function to build a button.
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

  // Function to build a row of buttons.
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
            // Input section that shows the current expression.
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Text(
                  _input, // Shows the current input including operator and number.
                  style: TextStyle(fontSize: 40),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            SizedBox(height: 80),
            // Result section that shows the result after calculation.
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Text(
                  _result, // Shows the result of the operation.
                  style: TextStyle(fontSize: 50, color: Colors.grey),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            SizedBox(height: 30),
            // Buttons for the calculator
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
