import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/base/image_gradient_background.dart';
import '../../../../../core/widgets/material/material_style_icon_card.dart';
import '../../../../settings/data/models/custom_header_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/library_table_model.dart';
import '../../pages/material/material_style_library_details_page.dart';
import 'material_style_library_icon.dart';

class MaterialStyleLibraryCard extends StatelessWidget {
  final LibraryTableModel library;
  final Widget details;

  const MaterialStyleLibraryCard({
    super.key,
    required this.library,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialStyleIconCard(
      background: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
          Positioned.fill(
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                state as SettingsSuccess;

                return ImageGradientBackground(
                  imageUri: library.backgroundUri,
                  httpHeaders: {
                    for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders)
                      headerModel.key: headerModel.value,
                  },
                );
              },
            ),
          ),
        ],
      ),
      icon: Hero(
        tag: ValueKey(library.sectionId),
        child: MaterialStyleLibraryIcon(library: library),
      ),
      details: details,
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MaterialStyleLibraryDetailsPage(
              libraryTableModel: library,
            ),
          ),
        );
      },
    );
  }
}
