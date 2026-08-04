import 'package:flutter/widgets.dart';

import '../../../../../core/helpers/palette_helper.dart';
import '../../../data/models/library_table_model.dart';

class LibraryDetailsIcon extends StatefulWidget {
  final LibraryTableModel libraryTableModel;
  final Widget libraryIcon;
  final Color cardColor;

  const LibraryDetailsIcon({
    super.key,
    required this.libraryTableModel,
    required this.libraryIcon,
    required this.cardColor,
  });

  @override
  State<LibraryDetailsIcon> createState() => _LibraryDetailsIconState();
}

class _LibraryDetailsIconState extends State<LibraryDetailsIcon> {
  late Future getColorFuture;

  @override
  void initState() {
    super.initState();
    getColorFuture = getDominantColor(widget.libraryTableModel.backgroundUri.toString());
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
                      color: color ?? widget.cardColor,
                    ),
                    if (color != null)
                      Container(
                        color: const Color(0x1F000000),
                      ),
                  ],
                );
              },
            ),
          ),
          Center(
            child: widget.libraryIcon,
          ),
        ],
      ),
    );
  }
}
