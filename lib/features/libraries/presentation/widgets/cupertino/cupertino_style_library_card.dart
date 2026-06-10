import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/base/image_gradient_background.dart';
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

          return ImageGradientBackground(
            imageUri: library.backgroundUri,
            httpHeaders: {
              for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders)
                headerModel.key: headerModel.value,
            },
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
