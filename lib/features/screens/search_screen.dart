// ignore_for_file: must_be_immutable, library_prefixes

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/constrain/variables.dart';
import 'package:wallpaper_app/features/bloc/search_bloc/search_bloc.dart';
import 'package:wallpaper_app/features/models/api_model.dart';
import 'package:wallpaper_app/features/screens/wallpaper_view.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key, required this.color, required this.query});

  String query;
  String color;
  WallpaperDataModel? searchModel;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // print('Home search Build Function Called!!!');
    searchController.text = query;
    context.read<SearchBloc>().add(SearchWallEvent(query: query, color: color));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Search Photos'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              mySearchTextField(context),
              const SizedBox(height: 20),
              myColorList(context),
              const SizedBox(height: 20),
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child:
                          SingleChildScrollView(child: searchPhotosGridView())))
            ],
          ),
        ));
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

  Widget searchPhotosGridView() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (_, state) {
        if (state is SearchLoadingState) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (state is SearchErrorState) {
          return Center(child: Text(state.errorMsg));
        }
        if (state is SearchLoadedState) {
          searchModel = state.data;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: searchModel!.photos!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        image: searchModel!.photos![index].src!.portrait
                            .toString(),
                      );
                    },
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              '${searchModel!.photos![index].src!.landscape}'),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.green),
                  height: 120,
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
