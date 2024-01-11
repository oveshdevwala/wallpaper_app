import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/features/bloc/page_provider.dart';
import 'package:wallpaper_app/features/bloc/search_bloc/search_bloc.dart';

class ConstrainWidget {
  static mySnacbar(BuildContext context, String content) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content)));
  }
}

Widget stackedButton(
    {required String btName,
    required VoidCallback onTap,
    required Widget child}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        style: IconButton.styleFrom(
            highlightColor: const Color(0xff3f64f5),
            padding: const EdgeInsets.all(14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Colors.grey.withOpacity(0.4)),
        icon: child,
        onPressed: onTap,
      ),
      const SizedBox(height: 4),
      Text(
        btName,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10)
    ],
  );
}

Center errorStateMsg({double fs = 12}) {
  return Center(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        // state.errMsg,
        'Check Network',
        style: TextStyle(
            fontSize: fs, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      const SizedBox(height: 10),
      const Icon(Icons.restart_alt_rounded),
    ],
  ));
}

Padding wallpaperPageRow(
    {required BuildContext context,
    required PageProvider provider,
    required String query,
    color,
    required ScrollController myScrollController}) {
  var page = provider.pageIndex;
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
            onPressed: () {
              if (page > 1) {
                context.read<SearchBloc>().add(
                    SearchWallEvent(query: query, color: color, page: page));
                provider.goToPreviousPage(myScrollController);
              }
            },
            child: const Text('< Previous Page ')),
        Consumer<PageProvider>(
          builder: (context, value, child) {
            return CircleAvatar(child: Text(value.pageIndex.toString()));
          },
        ),
        TextButton(
            onPressed: () {
              provider.goToNextPage(myScrollController);
              context
                  .read<SearchBloc>()
                  .add(SearchWallEvent(query: query, color: color, page: page));
            },
            child: const Text('Next Page >')),
      ],
    ),
  );
}
