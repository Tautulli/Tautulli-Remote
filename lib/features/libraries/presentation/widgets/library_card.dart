import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/icon_card.dart';
import '../../../settings/data/models/custom_header_model.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/library_table_model.dart';
import '../pages/library_details_page.dart';
import 'library_icon.dart';

class LibraryCard extends StatelessWidget {
  final LibraryTableModel library;
  final Widget details;

  const LibraryCard({
    super.key,
    required this.library,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return IconCard(
      background: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
            ),
          ),
          Positioned.fill(
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                state as SettingsSuccess;

                return CachedNetworkImage(
                  imageUrl: library.backgroundUri.toString(),
                  httpHeaders: {
                    for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders)
                      headerModel.key: headerModel.value,
                  },
                  imageBuilder: (context, imageProvider) => DecoratedBox(
                    position: DecorationPosition.foreground,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                    ),
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: 25,
                        sigmaY: 25,
                        tileMode: TileMode.decal,
                      ),
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: 25,
                      sigmaY: 25,
                      tileMode: TileMode.decal,
                    ),
                    child: Image.asset(
                      'assets/images/art_fallback.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  errorWidget: (context, url, error) => ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: 25,
                      sigmaY: 25,
                      tileMode: TileMode.decal,
                    ),
                    child: Image.asset(
                      'assets/images/art_fallback.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      icon: Hero(
        tag: ValueKey(library.sectionId),
        child: LibraryIcon(library: library),
      ),
      details: details,
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LibraryDetailsPage(
              libraryTableModel: library,
            ),
          ),
        );
      },
    );
  }
}
