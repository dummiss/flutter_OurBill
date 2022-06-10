import 'package:flutter/material.dart';
import 'routers/routers.dart'; //路由
import 'pages/splashScreen.dart';
import 'routers/routers.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() => runApp(MyApp());
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          // brightness: Brightness.light,
          primarySwatch: createMaterialColor(Colors.white70),
          //appbar color
          scaffoldBackgroundColor:
              const Color.fromARGB(255, 230, 230, 230), //背景
          inputDecorationTheme: const InputDecorationTheme(
            //TextField樣式
            hintStyle: TextStyle(color: Colors.black26),
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 220, 122, 0))),
            prefixStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          )),
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
    );
  }
}

//將顏色轉成MaterialColor給primarySwatch用
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
