void main() {
  String string = '22+3+4-221.5++6-10..0.434.3--2879387-434-132' ;
  print(isTheExpressionCorrect(string)) ;
}

bool isTheExpressionCorrect(String string) {

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
  list.add(number) ;
  print(list) ;
  String calc = '';
  for(String str in list) {
    calc += str ;
  }
  print(calc) ;
  return isStatementCorrect ;
}




