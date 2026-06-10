import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:palette_generator_master/palette_generator_master.dart';

import '../../../data/models/library_table_model.dart';
import 'cupertino_style_library_icon.dart';

class CupertinoStyleLibraryDetailsIcon extends StatefulWidget {
  final LibraryTableModel libraryTableModel;

  const CupertinoStyleLibraryDetailsIcon({
    super.key,
    required this.libraryTableModel,
  });

  @override
  State<CupertinoStyleLibraryDetailsIcon> createState() => _CupertinoStyleLibraryDetailsIconState();
}

class _CupertinoStyleLibraryDetailsIconState extends State<CupertinoStyleLibraryDetailsIcon> {
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

                return Container(
                  color: color != null
                      ? Color.alphaBlend(
                          CupertinoColors.black.withValues(alpha: 0.3),
                          color,
                        )
                      : CupertinoColors.systemBackground.darkElevatedColor,
                );
              },
            ),
          ),
          Center(
            child: CupertinoStyleLibraryIcon(library: widget.libraryTableModel),
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

  final palette = await PaletteGeneratorMaster.fromImageProvider(
    CachedNetworkImageProvider(url),
    maximumColorCount: 1,
  );

  return palette.dominantColor?.color;
}
