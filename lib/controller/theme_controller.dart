import 'package:flutter/cupertino.dart';

class ThemeController extends ChangeNotifier{
  bool IsTheme=false;

  int theme=1;

  setIstheme(){
    print(IsTheme);
    if(IsTheme)
      {
        IsTheme=false;
      }
    else{
      IsTheme=true;
    }

  }

  settheme(int t){
    theme=t;
    notifyListeners();
  }
}