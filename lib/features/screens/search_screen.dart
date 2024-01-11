// ignore_for_file: must_be_immutable, library_prefixes

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/constrain/variables.dart';
import 'package:wallpaper_app/constrain/widget.dart';
import 'package:wallpaper_app/features/bloc/page_provider.dart';
import 'package:wallpaper_app/features/bloc/search_bloc/search_bloc.dart';
import 'package:wallpaper_app/features/models/api_model.dart';
import 'package:wallpaper_app/features/screens/wallpaper_view.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key, required this.color, required this.query});

  String query;
  String color;
  WallpaperDataModel? searchModel;
  TextEditingController searchController = TextEditingController();
  ScrollController? myScrollController;
  int page = 1;
  @override
  Widget build(BuildContext context) {
    searchController.text = query;
    context.read<SearchBloc>().add(SearchWallEvent(query: query, color: color));
    myScrollController = ScrollController();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Search Photos'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            controller: myScrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                mySearchTextField(context),
                const SizedBox(height: 20),
                myColorList(context),
                const SizedBox(height: 20),
                searchPhotosGridView(),
                const SizedBox(height: 5),
                pageControllRow(context),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ));
  }

  Widget pageControllRow(BuildContext context) {
    var provider = context.read<PageProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: 130,
          child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(12)))),
              onPressed: () {
                if (provider.pageIndex > 1) {
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

  TextField mySearchTextField(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              context.read<SearchBloc>().add(SearchWallEvent(
                  query: searchController.text.toString(), color: ''));
            },
            icon: const Icon(
              CupertinoIcons.search,
              color: Colors.grey,
              size: 29,
            ),
          ),
          hintText: 'Find Wallpaper...',
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.4)),
          filled: true,
          fillColor: const Color(0xffeef3f5),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none)),
    );
  }

  SizedBox myColorList(BuildContext context) {
    return SizedBox(
        height: 65,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: listColorModel.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        context.read<SearchBloc>().add(SearchWallEvent(
                            query: searchController.text.toString(),
                            color: listColorModel[index].name.toString()));
                      },
                      child: Container(
                          width: 65,
                          decoration: BoxDecoration(
                              border:
                                  listColorModel[index].color == Colors.white
                                      ? Border.all(color: Colors.black)
                                      : null,
                              borderRadius: BorderRadius.circular(12),
                              color: listColorModel[index].color)),
                    ),
                  );
                },
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
        ));
  }

  Widget searchPhotosGridView() {
    return Align(
        alignment: Alignment.center,
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (_, state) {
            if (state is SearchLoadingState) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 20,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: 1.2 / 2),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade300),
                    height: 120,
                  );
                },
              );
            }
            if (state is SearchErrorState) {
              return GridView.builder(
                itemCount: 10,
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.9 / 1.19,
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
              var searchModel = state.data;
              return Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: searchModel.photos!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            crossAxisCount: 2,
                            childAspectRatio: 1.2 / 2),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return WallpaperView(
                                imageUrl: searchModel
                                    .photos![index].src!.portrait
                                    .toString(),
                              );
                            },
                          ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      '${searchModel.photos![index].src!.landscape}'),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade300),
                          height: 120,
                        ),
                      );
                    },
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ));
  }
}
