import 'package:flutter/material.dart';
import '../pages/groupList.dart'; //群組列表
import 'package:splash_screen_view/SplashScreenView.dart'; //splashscreen第三方套件

//TODO: class的命名跟檔名建議要相符
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreenView(
        navigateRoute: const GroupList(),
        duration: 3000,
        imageSize: 200,
        imageSrc: "images/logo.png",
        text: "Our Bill",
        textType: TextType.TyperAnimatedText,
        textStyle: const TextStyle(
          fontSize: 50.0,
          fontWeight: FontWeight.w900,
          shadows: <Shadow>[
            Shadow(offset: Offset(-5, -5), color: Colors.white), //文字白色部分
          ],
        ),
        backgroundColor: const Color.fromARGB(200, 255, 226, 190),
      ),
    );
  }
}
