import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';

class DetailScreen extends StatelessWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        centerTitle: true,
        // 가운데 정렬
        elevation: 2,
        // 그림자
        foregroundColor: Colors.green,
        // 글자색
        backgroundColor: Colors.white,
        // appBar 배경색
        title: Text(
        title,
        style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
    ),)
    ),);
  }
}
