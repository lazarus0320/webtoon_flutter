import 'package:webtoon_flutter/screens/home_screen.dart';
import 'package:webtoon_flutter/services/api_service.dart';
import 'package:flutter/material.dart';
void main() {
  ApiService().getTodaysToons();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key}); // 위젯을 식별하기 위한 ID를 보낸다고 이해하자

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}