// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:wallpaper_app/constrain/widget.dart';
import 'package:wallpaper_app/features/bloc/wallpaper_view_bloc/wallpaper_view_bloc.dart';

class WallpaperView extends StatefulWidget {
  WallpaperView({super.key, required this.imageUrl});
  String imageUrl;

  @override
  State<WallpaperView> createState() => _WallpaperViewState();
}

class _WallpaperViewState extends State<WallpaperView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image.network(widget.imageUrl, fit: BoxFit.cover)),
          backButton(context),
          functionButtons(context)
        ],
      ),
    );
  }

  Widget functionButtons(BuildContext context) {
    var blocPath = context.read<WallpaperViewBloc>();
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            stackedButton(
                btName: 'Info',
                onTap: () {},
                child: const Icon(Icons.info, color: Colors.white)),
            stackedButton(
                btName: 'Save',
                onTap: () {
                  blocPath.add(WallpaperSaveEvent(
                      context: context, imageUrl: widget.imageUrl));
                },
                child: const Icon(Icons.save_alt_rounded, color: Colors.white)),
            stackedApplyButtons(context, blocPath),
          ],
        ),
      ),
    );
  }

  Widget stackedApplyButtons(BuildContext context, WallpaperViewBloc blocPath) {
    return stackedButton(
        btName: 'Apply',
        onTap: () {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    actionsPadding: const EdgeInsets.all(10),
                    actionsAlignment: MainAxisAlignment.start,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13)),
                    title: const Text(
                      'Where You Want To Apply This Wallpaper',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    backgroundColor: Colors.white,
                    actions: [
                      Wrap(
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                applyWallpaper(context, home: true);
                              },
                              child: const Text('Home ',
                                  style: TextStyle(color: Colors.black))),
                          TextButton(
                              onPressed: () {
                                applyWallpaper(context, lock: true);
                                Navigator.pop(context);
                              },
                              child: const Text('Lock ',
                                  style: TextStyle(color: Colors.black))),
                          TextButton(
                              onPressed: () {
                                applyWallpaper(context, both: true);
                                Navigator.pop(context);
                              },
                              child: const Text('Lock & Home',
                                  style: TextStyle(color: Colors.black))),
                        ],
                      ),
                    ],
                  ));
        },
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ));
  }

  void applyWallpaper(BuildContext context,
      {bool home = false, bool lock = false, bool both = false}) {
    var mq = MediaQuery.of(context).size;
    var imageStream = Wallpaper.imageDownloadProgress(widget.imageUrl);
    imageStream.listen((events) {
      if (events == '100%') {
        ConstrainWidget.mySnacbar(context, 'Apply Successfully');
      }
    }, onDone: () {
      if (home) {
        Wallpaper.homeScreen(
          width: mq.width,
          height: mq.height,
          options: RequestSizeOptions.RESIZE_FIT,
        );
      } else if (lock) {
        Wallpaper.lockScreen(
          width: mq.width,
          height: mq.height,
          options: RequestSizeOptions.RESIZE_FIT,
        );
      } else if (both) {
        Wallpaper.bothScreen(
          width: mq.width,
          height: mq.height,
          options: RequestSizeOptions.RESIZE_FIT,
        );
      }
    }, onError: (e) {
      ConstrainWidget.mySnacbar(context, '$e');
    });
  }

  Positioned backButton(BuildContext context) {
    return Positioned(
        top: 60,
        left: 30,
        child: SizedBox(
          height: 50,
          width: 50,
          child: IconButton(
              style: IconButton.styleFrom(
                highlightColor: const Color(0xff3f64f5),
                backgroundColor: Colors.grey.withOpacity(0.4),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(CupertinoIcons.back, color: Colors.white)),
        ));
  }
}
