import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wallpaper_app/data_source/remote/api_helper.dart';
import 'package:wallpaper_app/data_source/remote/app_exception.dart';
import 'package:wallpaper_app/data_source/remote/urls.dart';
import 'package:wallpaper_app/features/models/api_model.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  ApiHelper apiHelper;
  SearchBloc({required this.apiHelper}) : super(ColorInitial()) {
    on<SearchWallEvent>((event, emit) async {
      emit(SearchLoadingState());
      try {
        var rowData;
        if (event.color != '' && event.query == '') {
          rowData = await apiHelper.getApi(
              url: '${Urls.searchUrl}?query=${event.color}&page=${event.page}&per_page=20');
        } else if (event.query != '' && event.color == '') {
          rowData = await apiHelper.getApi(
              url:
                  '${Urls.searchUrl}?query=${event.query}&page=${event.page}&per_page=20');
        } else {
          rowData = await apiHelper.getApi(
              url:
                  '${Urls.searchUrl}?query=${event.query}&color=${event.color}&page=${event.page}&per_page=20');
        }

        var colorData = WallpaperDataModel.fromJson(rowData);
        emit(SearchLoadedState(data: colorData));
      } catch (e) {
        emit(SearchErrorState(errorMsg: (e as AppExecption).toErrorMassage()));
      }
    });


    
  }
}
