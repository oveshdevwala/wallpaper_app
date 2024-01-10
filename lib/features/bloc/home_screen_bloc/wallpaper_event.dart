// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'wallpaper_bloc.dart';

@immutable
abstract class WallpaperEvent {}

class GetTrendingWallpeper extends WallpaperEvent {}

class GetSearchWallpeper extends WallpaperEvent {
  String query;
  String color;
  GetSearchWallpeper({required this.query, this.color = ''});
}

class GetColorWallpaper extends WallpaperEvent {
  String color;
  GetColorWallpaper({required this.color});
}
