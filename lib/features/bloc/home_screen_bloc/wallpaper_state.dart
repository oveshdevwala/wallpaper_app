// ignore_for_file: public_member_api_docs, sort_constructors_first, camel_case_types, must_be_immutable
part of 'wallpaper_bloc.dart';

@immutable
sealed class WallpaperState {}

final class WallpaperInitial extends WallpaperState {}

class wallpaperLoadingState extends WallpaperState {}

class wallpaperLoadedState extends WallpaperState {
  WallpaperDataModel data;
  wallpaperLoadedState({
    required this.data,
  });
}

class wallpaperErrorState extends WallpaperState {
  String errorMsg;
  wallpaperErrorState({required this.errorMsg});
}
