import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webtoon_flutter/models/webtoon_detail_model.dart';
import 'package:webtoon_flutter/models/webtoon_episode_model.dart';
import 'package:webtoon_flutter/services/api_service.dart';

import '../widgets/episode_widget.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // 여기서는 getToonById에 특정 id를 매개변수로 주는 경우임. home_screen.dart와 비교해서 보기 바람.
  // 이 경우에는 바로 값을 할당하지 못해서 late로 선언만 해놓고 initState에서 값을 할당해주는 방식을 이용함.
  late Future<WebtoonDetailModel> webtoon; // late는 나중에 define하도록 해줌.
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences
        .getInstance(); // 간단한 데이터를 저장하고 로드하는 기능을 구현하도록 도와주는 라이브러리
    final likedToons =
        prefs.getStringList('likedToons'); // 사용자가 좋아요를 누른 웹툰 id 목록
    if (likedToons != null) {
      // 사용자가 지금 보고 있는 webtoon의 ID가 likedToons 안에 있는지 확인
      if (likedToons.contains(widget.id) == true) {
        setState(() {
          isLiked = true;
        });
      }
    } else {
      await prefs.setStringList(
          'likedToons', []); // 최초 실행시 저장소에 아무것도 없을 것이므로 빈 리스트를 만든다.
    }
  }

  @override
  void initState() {
    // build보다 먼저 호출됨(단 한번만 호출)
    // TODO: implement initState
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
    initPrefs();
  }

  onHeartTap() async {
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.id);
      } else {
        likedToons.add(widget.id);
      }
      await prefs.setStringList('likedToons', likedToons);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, // 하단 오버플로우 문제를 해결하기 위해 사용
        backgroundColor: Colors.white,
        appBar: AppBar(
            centerTitle: true,
            // 가운데 정렬
            actions: [
              IconButton(
                onPressed: onHeartTap,
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_outline,
                  color: Colors.red,
                ),
              )
            ],
            elevation: 2,
            // 그림자
            foregroundColor: Colors.green,
            // 글자색
            backgroundColor: Colors.white,
            // appBar 배경색
            title: Text(
              widget.title,
              // StatefulWidget 내에 있는 필드 값을 받아오기 위한 방법. widget은 결국 detailScreen을 의미함.
              /**
               * StatelessWidget의 필드 변수를 쓰기 위해서는 그것의
               * build 메서드에서는 필드 변수명 그대로 사용하면 되지만,
               * StatefulWidget의 필드 변수를 쓰기 위해서는 State의
               * build 메서드에서 widget.필드 변수명으로 사용해야 한다.
               */
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w600,
              ),
            )),
        body: SingleChildScrollView(
            // 하단 오버플로우 문제를 해결하기 위해 사용
            child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // 수평방향으로 가운데 정렬
                children: [
                  Hero(
                    tag: widget.id,
                    child: Container(
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
                      child:
                          Image.network(widget.thumb), // 인터넷 주소의 이미지를 불러오는 방법
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              FutureBuilder(
                future: webtoon,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          '${snapshot.data!.genre} / ${snapshot.data!.age}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    );
                  }
                  return const Text("...");
                },
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                  future: episodes,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          for (var episode in snapshot.data!)
                            Episode(episode: episode, webtoonId: widget.id)
                        ],
                      );
                    } // episodes 데이터가 있는 경우 렌더링하기. 개수가 적다면 Column을, 리스트의 개수를 모르면 ListView가 좋음.
                    return Container();
                  })
            ],
          ),
        )));
  }
}
