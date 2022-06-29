import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/icon_card.dart';
import '../../../settings/data/models/custom_header_model.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/library_table_model.dart';
import 'library_card_details.dart';
import 'library_card_icon.dart';

class LibraryCard extends StatelessWidget {
  final LibraryTableModel library;

  const LibraryCard({
    super.key,
    required this.library,
  });

  @override
  Widget build(BuildContext context) {
    return IconCard(
      background: Stack(
        children: [
          Positioned.fill(
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                state as SettingsSuccess;

                return CachedNetworkImage(
                  imageUrl: library.backgroundUri.toString(),
                  httpHeaders: {
                    for (CustomHeaderModel headerModel
                        in state.appSettings.activeServer.customHeaders)
                      headerModel.key: headerModel.value,
                  },
                  imageBuilder: (context, imageProvider) => DecoratedBox(
                    position: DecorationPosition.foreground,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                    ),
                    child: Image(
                      image: imageProvider,
                      fit: BoxFit.fill,
                    ),
                  ),
                  placeholder: (context, url) =>
                      Image.asset('assets/images/art_fallback.png'),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/art_fallback.png'),
                );
              },
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 25,
              sigmaY: 25,
            ),
            child: const SizedBox(),
          ),
        ],
      ),
      icon: LibraryCardIcon(library: library),
      details: LibraryCardDetails(library: library),
      onTap: () {},
    );
  }
}
