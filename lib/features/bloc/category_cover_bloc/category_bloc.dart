import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wallpaper_app/data_source/remote/api_helper.dart';
import 'package:wallpaper_app/data_source/remote/app_exception.dart';
import 'package:wallpaper_app/data_source/remote/urls.dart';
import 'package:wallpaper_app/features/models/api_model.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  ApiHelper apiHelper;
  CategoryBloc({required this.apiHelper}) : super(CategoryInitial()) {
    on<CategoryCoverEvent>(categoryCoverEvent);
  }

  FutureOr<void> categoryCoverEvent(
      CategoryCoverEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoadingState());
    try {
      var rowData = await apiHelper.getApi(
          url: '${Urls.searchUrl}?query=popupar-searches');
      var category = WallpaperDataModel.fromJson(rowData);
      emit(CategoryLoadedState(data: category));
    } catch (e) {
      emit(CategoryErrorState(errMsg: (e as AppExecption).toErrorMassage()));
    }
  }
}
