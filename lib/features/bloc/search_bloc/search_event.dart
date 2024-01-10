// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

class SearchWallEvent extends SearchEvent {
  String color;
  String query;
  
  SearchWallEvent({
     this.color ='',
   required this.query,
  });
}
