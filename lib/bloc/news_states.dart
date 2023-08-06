
import 'package:equatable/equatable.dart';

import '../model/all_news_model.dart';
import '../model/news_channel_model.dart';

enum Status { initial, success, failure }

class NewsState extends Equatable {


   NewsState({
     this.status = Status.initial,
     this.message = '',
     NewsChannelHeadlinesModel? newsList  ,
   })  :  newsList = newsList ?? NewsChannelHeadlinesModel();

  final Status status;
  final NewsChannelHeadlinesModel? newsList;
  final String message;

  NewsState copyWith({
    Status? status,
    NewsChannelHeadlinesModel? newsList,
    String? message,
  }) {
    return NewsState(
      status: status ?? this.status,
      newsList: newsList ??  this.newsList,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $message,}''';
  }

  @override
  List<Object?> get props => [status, newsList, message,identityHashCode(this) ];
}
