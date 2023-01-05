
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://webtoon-crawler.nomadcoders.workers.dev";
  final String today = "today";

  void getTodaysToons()async {
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);
    /**
     * 비동기(async)프로그래밍으로 서버 응답에 대한 정보를 받아오기
     * 정보를 받아올 때까지 지연시간을 가지고 다음 코드로 넘어가도록 만듬
     * await를 사용해서 구현할 수 있으나 반드시 async 함수 내에서만 사용가능
     *
     * get은 Future<Response>타입으로 이루어짐.
     * 현재가 아닌 미래(Future)에 받아올 데이터의 타입이 Response가 되는 것.
     * */
    if (response.statusCode == 200) { // 200은 요청이 성공됐을 경우임
      print(response.body);
      return;
    }
    throw Error();
  }
}