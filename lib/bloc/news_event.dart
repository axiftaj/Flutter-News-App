import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchNewsChannelHeadlines extends NewsEvent {
  final String channelId ;
  FetchNewsChannelHeadlines(this.channelId);
}


class NewsCategories extends NewsEvent {
  final String category ;
  NewsCategories(this.category);
}
