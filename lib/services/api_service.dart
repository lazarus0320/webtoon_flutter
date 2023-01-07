
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webtoon_flutter/models/webtoon_detail_model.dart';
import 'package:webtoon_flutter/models/webtoon_episode_model.dart';
import 'package:webtoon_flutter/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl = "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  static Future<List<WebtoonModel>> getTodaysToons() async { //반환되는 것이 List형태이면서 비동기인 async를 사용하는 메서드이므로 Future...List형태로 감쌈.
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url); //get으로 받아오는 타입이 String이기 때문에 Json으로 바꿔 줘야함
    /**
     * 비동기(async)프로그래밍으로 서버 응답에 대한 정보를 받아오기
     * 정보를 받아올 때까지 지연시간을 가지고 다음 코드로 넘어가도록 만듬
     * await를 사용해서 구현할 수 있으나 반드시 async 함수 내에서만 사용가능
     *
     * get은 Future<Response>타입으로 이루어짐.
     * 현재가 아닌 미래(Future)에 받아올 데이터의 타입이 Response가 되는 것.
     * */
    if (response.statusCode == 200) { // 200은 요청이 성공됐을 경우임
      final List<dynamic> webtoons = jsonDecode(response.body); // jsonDecode 타입은 dynamic
      for (var webtoon in webtoons){
        webtoonInstances.add(WebtoonModel.fromJson(webtoon)); //json으로 변환된 것을 WebtoonModel 모듈에 클래스화하고 리스트에 넣기
      }
      return webtoonInstances;
    }

    throw Error();
  }

  static Future<WebtoonDetailModel>  getToonById(String id) async{
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);
    if(response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>>  getLatestEpisodesById(String id) async{
    List<WebtoonEpisodeModel> episodesInstances = [];
    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);
    if(response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }
}