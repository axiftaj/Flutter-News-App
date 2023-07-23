import 'package:flutter_news_app/model/all_news_model.dart';
import 'package:flutter_news_app/model/modelBbcNews.dart';
import 'package:flutter_news_app/services/services.dart';

class NewsListViewModel {
  Future<AllNewsModel> fetchNews(String category) async {
    final myApiResult = await MyService().fetchAllNews(category);

    return myApiResult;
  }

  Future<ModelBbcNews> fetchBBcNews(String newChannel) async {
    final bbcApi = await MyService().fetchBBCNews(newChannel);

    return bbcApi;
  }
}
