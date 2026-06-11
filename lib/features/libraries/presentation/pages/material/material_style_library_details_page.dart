import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/time_helper.dart';
import '../../../../../core/pages/material/material_style_tabbed_icon_details_page.dart';
import '../../../../../core/types/section_type.dart';
import '../../../../../core/widgets/base/image_gradient_background.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../history/presentation/bloc/library_history_bloc.dart';
import '../../../../recently_added/presentation/bloc/library_recently_added_bloc.dart';
import '../../../../settings/data/models/custom_header_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/library_table_model.dart';
import '../../bloc/library_media_bloc.dart';
import '../../bloc/library_statistics_bloc.dart';
import '../../widgets/base/library_details_icon.dart';
import '../../widgets/material/material_style_library_details_history_tab.dart';
import '../../widgets/material/material_style_library_details_media_tab.dart';
import '../../widgets/material/material_style_library_details_new_tab.dart';
import '../../widgets/material/material_style_library_details_stats_tab.dart';
import '../../widgets/material/material_style_library_icon.dart';

class MaterialStyleLibraryDetailsPage extends StatelessWidget {
  final LibraryTableModel libraryTableModel;
  const MaterialStyleLibraryDetailsPage({
    super.key,
    required this.libraryTableModel,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<LibraryHistoryBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<LibraryRecentlyAddedBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<LibraryStatisticsBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<LibraryMediaBloc>(),
        ),
      ],
      child: MaterialStyleLibraryDetailsView(
        libraryTableModel: libraryTableModel,
      ),
    );
  }
}

class MaterialStyleLibraryDetailsView extends StatefulWidget {
  final LibraryTableModel libraryTableModel;

  const MaterialStyleLibraryDetailsView({
    super.key,
    required this.libraryTableModel,
  });

  @override
  State<MaterialStyleLibraryDetailsView> createState() => _MaterialStyleLibraryDetailsViewState();
}

class _MaterialStyleLibraryDetailsViewState extends State<MaterialStyleLibraryDetailsView> {
  late ServerModel server;

  @override
  void initState() {
    super.initState();
    final settingsBloc = context.read<SettingsBloc>();
    final settingsState = settingsBloc.state as SettingsSuccess;
    server = settingsState.appSettings.activeServer;

    context.read<LibraryHistoryBloc>().add(
      LibraryHistoryFetched(
        server: server,
        sectionId: widget.libraryTableModel.sectionId!,
        settingsBloc: settingsBloc,
      ),
    );

    context.read<LibraryRecentlyAddedBloc>().add(
      LibraryRecentlyAddedFetched(
        tautulliId: server.tautulliId,
        sectionId: widget.libraryTableModel.sectionId ?? 0,
        settingsBloc: settingsBloc,
      ),
    );

    context.read<LibraryStatisticsBloc>().add(
      LibraryStatisticsFetched(
        server: server,
        sectionId: widget.libraryTableModel.sectionId ?? 0,
        settingsBloc: settingsBloc,
      ),
    );

    context.read<LibraryMediaBloc>().add(
      LibraryMediaFetched(
        server: server,
        sectionId: widget.libraryTableModel.sectionId ?? 0,
        refresh: false,
        fullRefresh: false,
        settingsBloc: settingsBloc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaterialStyleTabbedIconDetailsPage(
        background: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return ImageGradientBackground(
              imageUri: widget.libraryTableModel.backgroundUri,
              httpHeaders: {
                for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders)
                  headerModel.key: headerModel.value,
              },
            );
          },
        ),
        icon: LibraryDetailsIcon(
          libraryTableModel: widget.libraryTableModel,
          libraryIcon: MaterialStyleLibraryIcon(
            library: widget.libraryTableModel,
          ),
          cardColor: Theme.of(context).cardColor,
        ),
        title: widget.libraryTableModel.sectionName ?? '',
        subtitle: widget.libraryTableModel.sectionType == SectionType.photo
            ? const Text('')
            : RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: LocaleKeys.last_streamed_title.tr()),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: widget.libraryTableModel.lastAccessed != null
                          ? TimeHelper.moment(widget.libraryTableModel.lastAccessed)
                          : LocaleKeys.never.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
        tabs: [
          if (widget.libraryTableModel.sectionType != SectionType.photo)
            Tab(
              text: LocaleKeys.stats_title.tr(),
            ),
          if (![SectionType.live, SectionType.photo].contains(widget.libraryTableModel.sectionType))
            Tab(
              text: LocaleKeys.new_title.tr(),
            ),
          if (widget.libraryTableModel.sectionType != SectionType.photo)
            Tab(
              text: LocaleKeys.history_title.tr(),
            ),
          if (widget.libraryTableModel.sectionType != SectionType.live)
            Tab(
              text: LocaleKeys.media_title.tr(),
            ),
        ],
        tabChildren: [
          if (widget.libraryTableModel.sectionType != SectionType.photo)
            MaterialStyleLibraryDetailsStatsTab(
              server: server,
              libraryTableModel: widget.libraryTableModel,
            ),
          if (![SectionType.live, SectionType.photo].contains(widget.libraryTableModel.sectionType))
            MaterialStyleLibraryDetailsNewTab(
              server: server,
              libraryTableModel: widget.libraryTableModel,
            ),
          if (widget.libraryTableModel.sectionType != SectionType.photo)
            MaterialStyleLibraryDetailsHistoryTab(
              server: server,
              libraryTableModel: widget.libraryTableModel,
            ),
          if (widget.libraryTableModel.sectionType != SectionType.live)
            MaterialStyleLibraryDetailsMediaTab(
              server: server,
              libraryTableModel: widget.libraryTableModel,
            ),
        ],
      ),
    );
  }
}
