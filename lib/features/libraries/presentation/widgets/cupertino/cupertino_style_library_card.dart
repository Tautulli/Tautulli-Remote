import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/cupertino/cupertino_style_icon_card.dart';
import '../../../../settings/data/models/custom_header_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/library_table_model.dart';
import '../../pages/cupertino/cupertino_style_library_details_page.dart';
import 'cupertino_style_library_icon.dart';

class CupertinoStyleLibraryCard extends StatelessWidget {
  final LibraryTableModel library;
  final Widget details;

  const CupertinoStyleLibraryCard({
    super.key,
    required this.library,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoStyleIconCard(
      background: BlocBuilder<SettingsBloc, SettingsState>(
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
                color: CupertinoColors.black.withValues(alpha: 0.4),
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
                'assets/images/art_error.png',
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
      icon: CupertinoStyleLibraryIcon(library: library),
      details: details,
      onTap: () => Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => CupertinoStyleLibraryDetailsPage(
            libraryTableModel: library,
          ),
        ),
      ),
    );
  }
}
