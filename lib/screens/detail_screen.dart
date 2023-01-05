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
        appBar:
          AppBar(
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
              style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w600,
              ),
            )
          ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 250,
                clipBehavior: Clip.hardEdge,
                /**
                 * Flutter는 이제 몇 가지 특수 위젯(예: ClipRect)을 제외하고 기본적으로 자르지 않습니다. 클립 없음 기본값을 재정의하려면 위젯 구성에서 clipBehavior를 명시적으로 설정하십시오.
                    Clip은 Flutter의 속도 저하의 한 요인이며, saveLayer를 각각의 Clip에 호출함으로(간단한 직사각형임에도 불구하고) offscreen render target을 생성하고 렌더 타켓 전환에 약 1ms가 소요 될 수 있기에 특히 구형 장치에서 비용이 많이 발생 됨.

                    saveLayer 호출을 제외하고도 클립은 복원 될 때까지 모든 후속 그리기에 적용되기 때문에 지속적인 비용을 증가 시킴. 따라서 단일 클립은 수백번의 그리기 작업에서 성능을 저하시킴.

                    또한 성능적 문제 이외에도 Flutter는 Clip이 한 곳에서 관리 되지 않아 정확한 위치에 saveLayer가 삽입되지 못하고 아무런 bleeding edge artifacs를 고치지 못한채 비용만 증가시킴.

                    따라서 이 문제를 해결하고자 clipBehavior 컨트롤을 통합함.
                    다음 위젯을 제외하고 성능을 절약하기 위해 대부분의 위젯에 대한 기본 ClipBehavior은 Clip.none으로 설정함.

                    적용 방식

                    콘텐츠를 자를 필요 없을 경우 그대로. -> 앱의 성능에 긍정적인 영향
                    작은 곡선이 필요하다면 Clip.hardEdge -> 대부분의 일반적인 경우
                    부드러운 곡선이 필요하다면 -> Clip.antiAlias 약간 높은 비용으로 더 매끈한 곡선을 만듬
                 */
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        offset: Offset(10, 10),
                        color: Colors.black.withOpacity(0.5),
                      )
                    ]),
                child: Image.network(thumb),
              ),
            ],
          ),
        ],
      )
    );
  }
}
