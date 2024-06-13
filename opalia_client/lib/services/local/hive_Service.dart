import 'package:hive/hive.dart';

class HiveService {
  static final boxFavorite = Hive.box('favoriteBox');
  static Future<void> writeDataFavorite(
    Map<String, dynamic> newsitem,
  ) async {
    try {
      if (boxFavorite.containsKey(newsitem['isnews'])) {
        print("aleardy exists");
      } else {
        await boxFavorite.add(newsitem);
      }
      print('sucess adding hive ${newsitem}');
    } catch (e) {
      print('hive ${e}');
    }
  }

  static List<Map<String, dynamic>> refrechFavoriteItem() {
    final data = boxFavorite.keys.map((key) {
      final item = boxFavorite.get(key);
      return {
        "key": key,
        "namenews": item["namenews"],
        "isnews": item["isnews"],
        "newsImage": item["newsImage"],
        "newsDate": item["newsDate"],
        "random": item["random"],
        "favorite": item["favorite"]
      };
    }).toList();
    return data;
  }

  static Future<void> deleteDataFavoriteone(isnews) async {
    try {
      await boxFavorite.delete(isnews);
      print('sucess deleting favorite');
    } catch (e) {
      print('hive delete ${e}');
    }
  }

  static bool itemExists(dynamic isnews) {
    return boxFavorite.containsKey(isnews);
  }
}
