import 'dart:convert';

import 'package:flutter_news_app/model/all_news_model.dart';
import 'package:flutter_news_app/model/modelBbcNews.dart';
import 'package:http/http.dart' as http;

class MyService {


  Future<AllNewsModel> fetchAllNews(String category) async {
    String newsUrl =
        'https://newsapi.org/v2/everything?q=$category&apiKey=8a5ec37e26f845dcb4c2b78463734448';
    final response = await http.get(Uri.parse(newsUrl));
    if (response.statusCode == 200) {
      final jsonResponce = jsonDecode(response.body);

      return AllNewsModel.fromJson(jsonResponce);
    } else {
      throw Exception('Error');
    }
  }

  Future<ModelBbcNews> fetchBBCNews(String newsChannel) async {
    String newsUrl = 'https://newsapi.org/v2/top-headlines?sources=${newsChannel}&apiKey=8a5ec37e26f845dcb4c2b78463734448';
    final response = await http.get(Uri.parse(newsUrl));
    if (response.statusCode == 200) {
      final jsonResponce = jsonDecode(response.body);
      return ModelBbcNews.fromJson(jsonResponce);
    } else {
      throw Exception('Error');
    }
  }
}
