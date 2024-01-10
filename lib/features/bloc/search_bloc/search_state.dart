// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'search_bloc.dart';

@immutable
sealed class SearchState {}

final class ColorInitial extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchLoadedState extends SearchState {
  WallpaperDataModel data;
  SearchLoadedState({
    required this.data,
  });
}

class SearchErrorState extends SearchState {
  String errorMsg;
  SearchErrorState({
    required this.errorMsg,
  });
}
