import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,  // 가운데 정렬
        elevation: 2, // 그림자
        foregroundColor: Colors.green,  // 글자색
        backgroundColor: Colors.white,  // appBar 배경색
        title: const Text(
          "오늘의 웹툰",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600,),
        ),
      ),
    );  // Scaffold : screen을 위한 기본적인 레이아웃, 설정을 제공
  }
}
