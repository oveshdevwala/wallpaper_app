// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'category_bloc.dart';

@immutable
sealed class CategoryEvent {}

class CategorySearchEvent extends CategoryEvent {
  String category;
  CategorySearchEvent({
    required this.category,
  });
}

class CategoryCoverEvent extends CategoryEvent {}



