// ignore_for_file: must_be_immutable, library_prefixes

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as httpClient;
import 'package:wallpaper_app/constrain/variables.dart';
import 'package:wallpaper_app/features/models/api_model.dart';

class SearchScreenFutureBuilder extends StatefulWidget {
  SearchScreenFutureBuilder({super.key, required this.upComingsearch});
  String? upComingsearch;
  @override
  State<SearchScreenFutureBuilder> createState() => _SearchScreenFutureBuilderState();
}

class _SearchScreenFutureBuilderState extends State<SearchScreenFutureBuilder> {
  Future<WallpaperDataModel?>? searchModel;
  var searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    searchModel = getAllSearchResults(search: '${widget.upComingsearch}');

    
    searchController.text = widget.upComingsearch.toString();
  }

  Future<WallpaperDataModel?> getAllSearchResults(
      {required String search, String myColor = ''}) async {
    var apiKey = " WuSQl2o2WCR4yEHwD4fijNKVEptdFzfuFSAqPcRlie2uNuvZQnhBDMRC";
    var uri = Uri.parse(
        'https://api.pexels.com/v1/search?query=$search&color=${myColor.toString()}');
    var response =
        await httpClient.get(uri, headers: {"Authorization": apiKey});
    if (response.statusCode == 200) {
      var rowData = jsonDecode(response.body);
      var data = WallpaperDataModel.fromJson(rowData);
      setState(() {});
      return data;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Search Photos'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              mySearchTextField(),
              const SizedBox(height: 20),
              myColorList(),
              const SizedBox(height: 20),
              FutureBuilder<WallpaperDataModel?>(
                future: searchModel,
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  } else {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                            'Network Error : ${snapshot.error.toString()}'),
                      );
                    } else if (snapshot.hasData) {
                      return snapshot.data != null &&
                              snapshot.data!.photos!.isNotEmpty
                          ? searchPhotosGridView(snapshot)
                          : const Center(
                              child: Text('Search Not Found'),
                            );
                    }
                  }
                  return const SizedBox();
                },
              )
            ]),
          ),
        ));
  }

  SizedBox myColorList() {
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
                        searchModel = getAllSearchResults(
                            search: searchController.text.toString(),
                            //     myColor: 'F44336');
                            myColor: listColorModel[index]
                                .colorValue
                                .toString());
                        setState(() {});
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

  TextField mySearchTextField() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              searchModel =
                  getAllSearchResults(search: searchController.text.toString());
              setState(() {});
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

  GridView searchPhotosGridView(AsyncSnapshot<WallpaperDataModel?> snap) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: snap.data!.photos!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 2,
          childAspectRatio: 1.2 / 2),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(
            //   builder: (context) {
            //     return WallpaperView(
            //       image: snap.data!.photos![index].src!.portrait.toString(),
            //     );
            //   },
            // ));
          },
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        '${snap.data!.photos![index].src!.landscape}'),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(12),
                color: Colors.green),
            height: 120,
          ),
        );
      },
    );
  }
}
