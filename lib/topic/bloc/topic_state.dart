import 'package:quizlet_frontend/topic/TopicModel.dart';

class TopicListState {
  final List<TopicModel> topics;
  final bool isLoading;
  final bool isError;

  const TopicListState(
      {this.topics = const [], this.isLoading = false, this.isError = false});

  TopicListState copyWith(
      {List<TopicModel>? topics, bool? isLoading, bool? isError}) {
    return TopicListState(
        topics: topics ?? this.topics,
        isLoading: isLoading ?? this.isLoading,
        isError: isError ?? this.isError);
  }

  @override
  String toString() {
    return "TopicListState(topics: ${topics.map((e) => e.toString())}, isLoading: $isLoading, isError: $isError)";
  }
}
