// ignore_for_file: library_prefixes, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/features/bloc/search_bloc/search_bloc.dart';
import 'package:wallpaper_app/features/models/api_model.dart';
import 'package:wallpaper_app/constrain/variables.dart';
import 'package:wallpaper_app/features/screens/wallpaper_view.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen(
      {super.key,
      this.isCategory = true,
      required this.selectedIndex,
      required this.color,
      required this.query});
  bool isCategory;
  WallpaperDataModel? wallpaperDataModel;
  String query, color;
  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    context.read<SearchBloc>().add(SearchWallEvent(query: query, color: color));

    return Scaffold(
        appBar: AppBar(
          title: Text(
            isCategory
                ? listCategory[selectedIndex]
                : listColorModel[selectedIndex].name.toString(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        body: categoryImageWallpaper());
  }

  Widget categoryImageWallpaper() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoadingState) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (state is SearchErrorState) {
          return Center(child: Text(state.errorMsg));
        }

        if (state is SearchLoadedState) {
          wallpaperDataModel = state.data;
          return GridView.builder(
            itemCount: wallpaperDataModel!.photos!.length,
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 5,
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(0),
                child: InkWell(
                  onTap: () {
                    var selectedIndex = index;
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return WallpaperView(
                            image: wallpaperDataModel!
                                .photos![selectedIndex].src!.portrait
                                .toString());
                      },
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                            image: NetworkImage(wallpaperDataModel!
                                .photos![index].src!.portrait
                                .toString()),
                            fit: BoxFit.cover)),
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
