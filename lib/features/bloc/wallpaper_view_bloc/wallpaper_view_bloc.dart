import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:wallpaper_app/constrain/widget.dart';

part 'wallpaper_view_event.dart';
part 'wallpaper_view_state.dart';

class WallpaperViewBloc extends Bloc<WallpaperViewEvent, WallpaperViewState> {
  WallpaperViewBloc() : super(WallpaperViewInitial()) {
    on<WallpaperSaveEvent>(wallpaperSaveEvent);
    on<WallpaperApplyHomeScreenEvent>(wallpaperApplyHomeScreenEvent);
    on<WallpaperApplyLockScreenEvent>(wallpaperApplyLockScreenEvent);
  }

  FutureOr<void> wallpaperSaveEvent(
      WallpaperSaveEvent event, Emitter<WallpaperViewState> emit) {
    GallerySaver.saveImage(event.imageUrl).then((value) =>
        ConstrainWidget.mySnacbar(event.context, 'Save Successfully'));
  }

  FutureOr<void> wallpaperApplyHomeScreenEvent(
      WallpaperApplyHomeScreenEvent event, Emitter<WallpaperViewState> emit) {
    var mq = MediaQuery.of(event.context).size;
    var imageStream = Wallpaper.imageDownloadProgress(event.imageUrl);
    imageStream.listen((events) {
      if (events == '100%') {
        ScaffoldMessenger.of(event.context)
            .showSnackBar(const SnackBar(content: Text('Apply Successfully')));
      }
    }, onDone: () {
      Wallpaper.homeScreen(
        width: mq.width,
        height: mq.height,
        options: RequestSizeOptions.RESIZE_FIT,
      );
    }, onError: (e) {
      ConstrainWidget.mySnacbar(event.context, '$e');
    });
  }

  FutureOr<void> wallpaperApplyLockScreenEvent(
      WallpaperApplyLockScreenEvent event, Emitter<WallpaperViewState> emit) {
    var mq = MediaQuery.of(event.context).size;
    Wallpaper.imageDownloadProgress(event.imageUrl).listen((ev) {
      if (ev == '100%') {
        event.child;
      }
    }, onDone: () {
      Wallpaper.lockScreen(
          height: mq.height,
          width: mq.width,
          options: RequestSizeOptions.RESIZE_FIT);
    }, onError: (e) {
      ConstrainWidget.mySnacbar(event.context, '$e');
    });
  }
}
