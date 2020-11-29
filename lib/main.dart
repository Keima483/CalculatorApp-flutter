import 'package:eval_ex/expression.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

bool _darkModeEnabled = false;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]) ;
  runApp(HomeScreen());
}


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String output = '0' ;

  bool isTheExpressionCorrect() {
    String string = output ;
    bool isStatementCorrect = true ;
    List<String> list = [] ;
    String number = '' ;
    for(int i = 0 ; i < string.length ; i++) {
      if(string[i] == '+' || string[i] == '-' || string[i] == '*' || string[i] == '/' ) {
        if(number != '') {
          list.add(number) ;
        }
        if(list[list.length -1] == '+' || list[list.length -1] == '-' || list[list.length -1] == '*' || list[list.length -1] == '/' ) {
          isStatementCorrect = false ;
        } else {
          list.add(string[i]);
          number = '' ;
        }
      } else {
        if(string[i]=='.') {
          if(number.contains('.')) {
            isStatementCorrect = false ;
          } else {
            number += string[i] ;
          }
        } else {
          number += string[i] ;
        }
      }
    }
    if(number != '') {
      list.add(number) ;
    }
    if(list[list.length -1] == '+' || list[list.length -1] == '-' || list[list.length -1] == '*' || list[list.length -1] == '/' ) {
      list.removeAt(list.length-1) ;
      isStatementCorrect = false ;
    }
    String calc = '';
    for(String str in list) {
      calc += str ;
    }
    if(!isStatementCorrect) {
      setState(() {
        output = calc ;
      });
    }
    return isStatementCorrect ;
  }

  void alertWindow(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: Text('Expression cant be executes'),
      content: Text('Either your expression is wrong or its not allowed'),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog ;
      }
    );
  }

  void onButtonClick(String buttonText) {
    if(buttonText == 'CLEAR') {
      setState(() {
        output = '0' ;
      });
    } else if(buttonText == "DEL") {
      setState(() {
        if(output != '') {
          output = output.substring(0,output.length-1) ;
          if(output == '') {
            output = '0' ;
          }
        }
      });
    } else {
      if(output.length <= 25 || buttonText == '=') {
        if(buttonText != '/' && buttonText != '*' && buttonText != '-'  && buttonText != '+' && buttonText != '=') {
          setState(() {
            if (output != '0') {
              output += buttonText;
            } else {
              output = buttonText;
            }
          });
        } else if (buttonText == '=') {
          if(isTheExpressionCorrect()) {
            setState(() {
              try{
                Expression exp = Expression(output);
                output = exp.eval().toString();
              } catch(s) {
                output = '0' ;
              }
            });
          } else {
            // this doesn't need to be written it already executed in isTheExpressionCorrect
          }
        } else {
          setState(() {
            output += buttonText;
          });
        }
      }
    }
  }

  Widget calculatorButton(String buttonText) {
    return Expanded(
        child: FlatButton(
          onPressed: (){
            onButtonClick(buttonText) ;
          },
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
    ) ;
  }

  Widget coloredCalculatorButton(String buttonText, {Color textColor = Colors.white, Color buttonColor = Colors.grey}) {
    return Expanded(
        child: Padding(
          padding: EdgeInsets.all(7),
          child: MaterialButton(
            onPressed: (){
              onButtonClick(buttonText) ;
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(27.0),
            ),
            color: buttonColor,
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ),
        )
    ) ;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: (_darkModeEnabled) ? Brightness.dark : Brightness.light,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("MyCalculator")),
          actions: [
            IconButton(
              icon: (_darkModeEnabled) ? Icon(Icons.brightness_5) : Icon(Icons.brightness_4) ,
              onPressed: () {
                if(_darkModeEnabled) {
                  setState(() {
                    _darkModeEnabled = false ;
                  });
                } else{
                  setState(() {
                    _darkModeEnabled = true ;
                  });
                }
              },
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 20,
                ),
                child: Text(
                  output,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50.0,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: Row(
                      children: [
                        coloredCalculatorButton("CLEAR", buttonColor: Colors.red),
                        coloredCalculatorButton("DEL", buttonColor: Colors.grey[400]),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Row(
                      children: [
                        calculatorButton("7"),
                        calculatorButton("8"),
                        calculatorButton("9"),
                        coloredCalculatorButton("/", buttonColor: Colors.orange),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Row(
                      children: [
                        calculatorButton("4"),
                        calculatorButton("5"),
                        calculatorButton("6"),
                        coloredCalculatorButton("*", buttonColor: Colors.orange),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Row(
                      children: [
                        calculatorButton("1"),
                        calculatorButton("2"),
                        calculatorButton("3"),
                        coloredCalculatorButton("-", buttonColor: Colors.orange),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Row(
                      children: [
                        calculatorButton("."),
                        calculatorButton("0"),
                        calculatorButton("="),
                        coloredCalculatorButton("+", buttonColor: Colors.orange),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}

