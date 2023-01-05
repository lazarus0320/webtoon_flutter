import 'package:flutter/material.dart';
import 'package:webtoon_flutter/models/webtoon_model.dart';
import 'package:webtoon_flutter/services/api_service.dart';
import 'package:webtoon_flutter/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

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
          title: const Text(
            "오늘의 웹툰",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: FutureBuilder(
          // StatelessWidget에서 비동기 방식을 처리하는 방법
          future: webtoons, // FuterBuilder가 알아서 await기능을 수행해줌
          builder: (context, snapshot) {
            //snapshot : Future의 상태 진단
            /**
             * BuildContext : Widget tree에서 현재 Widget의 위치를 알 수 있는 정보로, 이를 통해 계층 구조를 만들어나감
             * 각각의 위젯은 고유의 BuildContext를 가짐.
             */
            if (snapshot.hasData) {
              // return ListView.builder(  // 기존 ListView의 최적화 문제를 보완해줌.
              //   /**
              //    * 사용자가 보고 있는 아이템만 build하고 안보면 해당 아이템을 메모리에서 지우도록 구현해보자.
              //    */
              //   scrollDirection: Axis.horizontal,
              //   itemCount: snapshot.data!.length,
              //   itemBuilder: (context, index) { // index 값을 print해보면 스크롤된 화면에 따라 유동적으로 아이템 값을 불러온다는 것을 확인할 수 있음.
              //     // print(index);
              //     var webtoon = snapshot.data![index];
              //     return Text(webtoon.title);
              //   },
              return Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Expanded(child: makeList(snapshot))
                  // child로 온 값에 대한 빈 공간을 꽉 채움.
                ],
              );
            }
            /**
             * !를 붙이는 이유 : 없애면 nullable에러가 발생한다.
             * 그러나 조건문에 snapshot.hasData가 true일 경우에만 실행되도록 했기 때문에
             * null이 발생할 수 없는 상태이다. 따라서 !를 붙여서 확실하게 데이터가 존재한다는 것을 컴파일러에게 알려준다.
             */
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        )); // Scaffold : screen을 위한 기본적인 레이아웃, 설정을 제공
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      // 불러와진 리스트 아이템 사이사이에 위젯을 추가해서 분리해줌.
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        return Webtoon(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 40),
    );
  }
}