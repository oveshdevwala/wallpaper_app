// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper_app/features/bloc/category_cover_bloc/category_bloc.dart';
import 'package:wallpaper_app/features/bloc/home_screen_bloc/wallpaper_bloc.dart';
import 'package:wallpaper_app/features/screens/category_screen.dart';
import 'package:wallpaper_app/features/models/api_model.dart';
import 'package:wallpaper_app/features/screens/search_screen.dart';
import 'package:wallpaper_app/constrain/variables.dart';
import 'package:wallpaper_app/features/screens/wallpaper_view.dart';

class MyHomeScreen extends StatelessWidget {
  MyHomeScreen({super.key});
  WallpaperDataModel? wallpaperDataModel;

  TextEditingController searchController = TextEditingController();

  WallpaperDataModel? categoryDataModel;

  @override
  Widget build(BuildContext context) {
    context.read<WallpaperBloc>().add(GetTrendingWallpeper());
    context.read<CategoryBloc>().add(CategoryCoverEvent());
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Wallpaper App')),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              homeScreenSearchTextField(context),
              bestofMonthTitle(),
              bestofMonthView(),
              theColorToneTitle(),
              theColorTone(context),
              categoryTitle(),
              categoryView()
            ],
          ),
        ));
  }

  Padding homeScreenSearchTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return SearchScreen(
                      color:'' ,query:searchController.text.toString() ,
                    );
                  },
                ));
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
      ),
    );
  }

  Padding categoryTitle() {
    return const Padding(
        padding: EdgeInsets.all(12),
        child: Text('Categories',
            style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold)));
  }

  Widget categoryView() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoadingState) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (state is CategoryErrorState) {
          return Center(child: Text(state.errMsg));
        }
        if (state is CategoryLoadedState) {
          categoryDataModel = state.data;
          return SingleChildScrollView(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categoryDataModel!.photos!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 3 / 2),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return CategoryScreen(
                            isCategory: true,
                            selectedIndex: index,
                            color: '',
                            query: listCategory[index],
                          );
                        },
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  '${categoryDataModel!.photos![index].src!.landscape}'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.green),
                      height: 120,
                      child: Center(
                          child: Text(
                        listCategory[index],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )),
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  BlocBuilder bestofMonthView() {
    return BlocBuilder<WallpaperBloc, WallpaperState>(
      builder: (_, state) {
        if (state is wallpaperLoadingState) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (state is wallpaperErrorState) {
          return Center(child: Text(state.errorMsg));
        }
        if (state is wallpaperLoadedState) {
          var wallpaperDataModel = state.data;
          return Container(
            height: 220,
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: wallpaperDataModel.photos!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.9 / 1.19,
                    crossAxisCount: 1),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return WallpaperView(
                            image: wallpaperDataModel
                                .photos![index].src!.portrait
                                .toString(),
                          );
                        },
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green.shade200,
                          image: DecorationImage(
                              image: NetworkImage(
                                  '${wallpaperDataModel.photos![index].src!.portrait}'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Padding theColorToneTitle() {
    return const Padding(
      padding: EdgeInsets.all(12.0),
      child: Text(
        'The color Tone',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Padding bestofMonthTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        'Best of the month',
        style: TextStyle(
            fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  SingleChildScrollView bestOFTheMonth() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: wallpaperDataModel!.photos!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.9 / 1.19,
              crossAxisCount: 1),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.green.shade200,
                  image: DecorationImage(
                      image: NetworkImage(
                          '${wallpaperDataModel!.photos![index].src!.portrait}'),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(12)),
            );
          },
        ),
      ),
    );
  }

  GridView bestOFMonthGridView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: wallpaperDataModel!.photos!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.9 / 1.19,
          crossAxisCount: 1),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.green.shade200,
              image: DecorationImage(
                  image: NetworkImage(
                      '${wallpaperDataModel!.photos![index].src!.portrait}'),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(12)),
        );
      },
    );
  }
}

SizedBox theColorTone(BuildContext context) {
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryScreen(
                              selectedIndex: index,
                                isCategory: false,
                                color: listColorModel[index].name.toString(),
                                query: ''),
                          ));
                    },
                    child: Container(
                        width: 65,
                        decoration: BoxDecoration(
                            border: listColorModel[index].color == Colors.white
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
