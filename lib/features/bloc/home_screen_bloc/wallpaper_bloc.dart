import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wallpaper_app/data_source/remote/api_helper.dart';
import 'package:wallpaper_app/data_source/remote/app_exception.dart';
import 'package:wallpaper_app/data_source/remote/urls.dart';
import 'package:wallpaper_app/features/models/api_model.dart';

part 'wallpaper_event.dart';
part 'wallpaper_state.dart';

class WallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {
  ApiHelper apiHelper;
  WallpaperBloc({required this.apiHelper}) : super(WallpaperInitial()) {
    on<GetTrendingWallpeper>(getTrendingWallpeper);
    // on<GetSearchWallpeper>(getSearchWallpeper);
    // on<GetColorWallpaper>(getColorWallpaper);
  }

  FutureOr<void> getTrendingWallpeper(
      GetTrendingWallpeper event, Emitter<WallpaperState> emit) async {
    emit(wallpaperLoadingState());
    try {
      var rowData = await apiHelper.getApi(url: Urls.curatedUrl);
      var trending = WallpaperDataModel.fromJson(rowData);
      emit(wallpaperLoadedState(data: trending));
    } catch (e) {
      emit(wallpaperErrorState(errorMsg: (e as AppExecption).toErrorMassage()));
    }
  }

  FutureOr<void> getSearchWallpeper(
      GetSearchWallpeper event, Emitter<WallpaperState> emit) async {
    emit(wallpaperLoadingState());
    try {
      var rowData = await apiHelper.getApi(
          url: '${Urls.searchUrl}?query=${event.query}');
      var search = WallpaperDataModel.fromJson(rowData);
      emit(wallpaperLoadedState(data: search));
    } catch (e) {
      emit(wallpaperErrorState(errorMsg: (e as AppExecption).toErrorMassage()));
    }
  }

  FutureOr<void> getColorWallpaper(
      GetColorWallpaper event, Emitter<WallpaperState> emit) async {
    emit(wallpaperLoadingState());
    try {
      var rowData =
          await apiHelper.getApi(url: '${Urls.searchUrl}?query=${event.color}');
      var search = WallpaperDataModel.fromJson(rowData);
      emit(wallpaperLoadedState(data: search));
    } catch (e) {
      emit(wallpaperErrorState(errorMsg: (e as AppExecption).toErrorMassage()));
    }
  }
}
