// ignore_for_file: library_prefixes, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/constrain/widget.dart';
import 'package:wallpaper_app/features/bloc/page_provider.dart';
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
  String query, color;
  int selectedIndex;
  WallpaperDataModel? wallpaperDataModel;
  ScrollController? myScrollController;
  int page = 1;

  @override
  Widget build(BuildContext context) {
    context.read<SearchBloc>().add(SearchWallEvent(query: query, color: color));
    var provider = context.read<PageProvider>();
    myScrollController = ScrollController()..addListener(() {});
    return Scaffold(
        appBar: AppBar(
          title: Text(
            isCategory
                ? listCategory[selectedIndex]
                : listColorModel[selectedIndex].name.toString(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          controller: myScrollController,
          child: Column(
            children: [
              categoryImageWallpaper(),
              wallpaperPageRow(context, provider),
              const SizedBox(height: 20)
            ],
          ),
        ));
  }

  Widget wallpaperPageRow(BuildContext context, PageProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: 130,
          child: TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.grey.shade200,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(12)))),
              onPressed: () {
                if (page > 1) {
                  context.read<SearchBloc>().add(SearchWallEvent(
                      query: query, color: color, page: provider.pageIndex));

                  provider.goToPreviousPage(myScrollController!);
                }
              },
              child: const Text('Previous Page')),
        ),
        Consumer<PageProvider>(
          builder: (context, value, child) {
            return CircleAvatar(
                backgroundColor: Colors.grey.withOpacity(0.4),
                child: Text(
                  value.pageIndex.toString(),
                  style: const TextStyle(color: Colors.black),
                ));
          },
        ),
        SizedBox(
          width: 130,
          child: TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.grey.shade200,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(12)))),
              onPressed: () {
                provider.goToNextPage(myScrollController!);
                context.read<SearchBloc>().add(SearchWallEvent(
                    query: query, color: color, page: provider.pageIndex));
              },
              child: const Text(
                'Next Page',
                textAlign: TextAlign.center,
              )),
        ),
      ],
    );
  }

  Widget categoryImageWallpaper() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoadingState) {
          return GridView.builder(
            itemCount: 20,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 5,
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade200),
                  ));
            },
          );
        }
        if (state is SearchErrorState) {
          return GridView.builder(
            itemCount: 20,
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3 / 5,
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  context
                      .read<SearchBloc>()
                      .add(SearchWallEvent(query: query, color: color));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade300),
                  child: errorStateMsg(fs: 15),
                ),
              );
            },
          );
        }

        if (state is SearchLoadedState) {
          wallpaperDataModel = state.data;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
                            imageUrl: wallpaperDataModel!
                                .photos![selectedIndex].src!.portrait
                                .toString());
                      },
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
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
