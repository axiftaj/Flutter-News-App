import 'package:flutter_news_app/model/all_news_model.dart';
import 'package:flutter_news_app/model/news_channel_model.dart';

import '../repository/news_repository.dart';

class NewsListViewModel {
  Future<AllNewsModel> fetchNews(String category) async {
    final myApiResult = await NewReposiotry().fetchAllNews(category);

    return myApiResult;
  }

  Future<NewsChannelHeadlinesModel> fetchBBcNews(String newChannel) async {
    final bbcApi = await NewReposiotry().fetchNewsChannelHeadlinesApi(newChannel);

    return bbcApi;
  }
}
