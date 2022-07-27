import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../data/models/library_table_model.dart';
import 'library_icon.dart';

class LibraryDetailsIcon extends StatefulWidget {
  final LibraryTableModel libraryTableModel;

  const LibraryDetailsIcon({
    super.key,
    required this.libraryTableModel,
  });

  @override
  State<LibraryDetailsIcon> createState() => _LibraryDetailsIconState();
}

class _LibraryDetailsIconState extends State<LibraryDetailsIcon> {
  late Future getColorFuture;
  late bool hasNetworkImage;

  @override
  void initState() {
    super.initState();
    hasNetworkImage = _hasNetworkImage(widget.libraryTableModel);
    getColorFuture = _getColor(widget.libraryTableModel.backgroundUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            child: FutureBuilder(
              future: getColorFuture,
              builder: (context, snapshot) {
                Color? color;

                if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                  color = snapshot.data as Color;
                }

                return Stack(
                  children: [
                    Container(
                      color: color ?? Theme.of(context).cardColor,
                    ),
                    if (color != null)
                      Container(
                        color: Colors.black12,
                      ),
                  ],
                );
              },
            ),
          ),
          Center(
            child: Hero(
              tag: ValueKey(widget.libraryTableModel.sectionId),
              child: LibraryIcon(library: widget.libraryTableModel),
            ),
          ),
        ],
      ),
    );
  }
}

bool _hasNetworkImage(LibraryTableModel library) {
  if (library.backgroundUri != null) {
    return library.backgroundUri.toString().startsWith('http');
  }
  return false;
}

Future<Color?> _getColor(String? url) async {
  if (url == null || !url.startsWith('http')) return null;

  final palette = await PaletteGenerator.fromImageProvider(
    CachedNetworkImageProvider(url),
    maximumColorCount: 1,
  );

  return palette.dominantColor?.color;
}
