// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'wallpaper_view_bloc.dart';

@immutable
sealed class WallpaperViewEvent {}

class WallpaperSaveEvent extends WallpaperViewEvent {
  String imageUrl;
  BuildContext context;

  WallpaperSaveEvent({
    required this.context,
    required this.imageUrl,
  });
}

class WallpaperApplyHomeScreenEvent extends WallpaperViewEvent {
  var imageUrl;
  BuildContext context;
  Widget child;
  WallpaperApplyHomeScreenEvent({
    required this.context,
    required this.imageUrl,
    required this.child,
  });
}

class WallpaperApplyLockScreenEvent extends WallpaperViewEvent {
  String imageUrl;
  BuildContext context;
  Widget child;
  WallpaperApplyLockScreenEvent({
    required this.context,
    required this.imageUrl,
    required this.child,
  });
}
