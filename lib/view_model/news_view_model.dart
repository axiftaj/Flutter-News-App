import 'package:flutter_news_app/model/all_news_model.dart';
import 'package:flutter_news_app/model/news_channel_headlines_model.dart';

import '../repository/news_repository.dart';

class NewsViewModel {


  Future<AllNewsModel> fetchNews(String category) async {
    final myApiResult = await NewsRepository().fetchAllNews(category);

    return myApiResult;
  }

  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi(String newChannel) async {
    final bbcApi = await NewsRepository().fetchNewsChannelHeadlinesApi(newChannel);

    return bbcApi;
  }
}
