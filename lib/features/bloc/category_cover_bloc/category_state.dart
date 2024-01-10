// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'category_bloc.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategoryLoadedState extends CategoryState {
  WallpaperDataModel data;
  CategoryLoadedState({
    required this.data,
  });
}

class CategoryErrorState extends CategoryState {
  String errMsg;
  CategoryErrorState({
    required this.errMsg,
  });
}
