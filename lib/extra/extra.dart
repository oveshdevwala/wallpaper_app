  // getPhotosCurated() async {
  //   var apiKey = "WuSQl2o2WCR4yEHwD4fijNKVEptdFzfuFSAqPcRlie2uNuvZQnhBDMRC";
  //   var uri = Uri.parse('https://api.pexels.com/v1/curated');
  //   var response =
  //       await httpClient.get(uri, headers: {"Authorization": apiKey});
  //   if (response.statusCode == 200) {
  //     var rowData = jsonDecode(response.body);
  //     wallpaperDataModel = WallpaperDataModel.fromJson(rowData);
  //     setState(() {});
  //   }
  // }

  // getPhotosByCategory(String category) async {
  //   var apiKey = " WuSQl2o2WCR4yEHwD4fijNKVEptdFzfuFSAqPcRlie2uNuvZQnhBDMRC";
  //   var uri = Uri.parse('https://api.pexels.com/v1/search?query=$category');
  //   var response =
  //       await httpClient.get(uri, headers: {"Authorization": apiKey});
  //   if (response.statusCode == 200) {
  //     var rowData = jsonDecode(response.body);
  //     categoryDataModel = WallpaperDataModel.fromJson(rowData);
  //     setState(() {});
  //   }
  // }


    //   getPhotosByCategory(String category) async {
  // //   var apiKey = " WuSQl2o2WCR4yEHwD4fijNKVEptdFzfuFSAqPcRlie2uNuvZQnhBDMRC";
  //   var uri = Uri.parse('https://api.pexels.com/v1/search?query=$category');
  //   var response =
  //       await httpClient.get(uri, headers: {"Authorization": apiKey});
  //   if (response.statusCode == 200) {
  //     var rowData = jsonDecode(response.body);
  //     wallpaperDataModel = WallpaperDataModel.fromJson(rowData);
  //     setState(() {});
  //   }
  // }




  // apply and save function
  //   void applyWallpaper(BuildContext context) {
  //   var mq = MediaQuery.of(context).size;
  //   var imageStream = Wallpaper.imageDownloadProgress(widget.imageUrl);
  //   imageStream.listen((events) {
  //     if (events == '100%') {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Apply Successfully')));
  //     }
  //   }, onDone: () async {
  //     var check = await Wallpaper.homeScreen(
  //       width: mq.width,
  //       height: mq.height,
  //       options: RequestSizeOptions.RESIZE_FIT,
  //     );
  //   }, onError: (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
  //   });
  // }

  // void saveWallpaper() {
  //   GallerySaver.saveImage(widget.imageUrl).then((value) =>
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(const SnackBar(content: Text('Saved Successfully'))));
  // }