import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/time_helper.dart';
import '../../../../core/widgets/sliver_tabbed_details.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../history/presentation/bloc/library_history_bloc.dart';
import '../../../recently_added/presentation/bloc/library_recently_added_bloc.dart';
import '../../../settings/data/models/custom_header_model.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/library_table_model.dart';
import '../bloc/library_media_bloc.dart';
import '../bloc/library_statistics_bloc.dart';
import '../widgets/library_details_history_tab.dart';
import '../widgets/library_details_icon.dart';
import '../widgets/library_details_media_tab.dart';
import '../widgets/library_details_new_tab.dart';
import '../widgets/library_details_stats_tab.dart';

class LibraryDetailsPage extends StatelessWidget {
  final LibraryTableModel libraryTableModel;
  const LibraryDetailsPage({
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
      child: LibraryDetailsView(
        libraryTableModel: libraryTableModel,
      ),
    );
  }
}

class LibraryDetailsView extends StatefulWidget {
  final LibraryTableModel libraryTableModel;

  const LibraryDetailsView({
    super.key,
    required this.libraryTableModel,
  });

  @override
  State<LibraryDetailsView> createState() => _LibraryDetailsViewState();
}

class _LibraryDetailsViewState extends State<LibraryDetailsView> {
  @override
  void initState() {
    super.initState();
    final settingsBloc = context.read<SettingsBloc>();
    final settingsState = settingsBloc.state as SettingsSuccess;
    final tautulliId = settingsState.appSettings.activeServer.tautulliId;

    context.read<LibraryHistoryBloc>().add(
          LibraryHistoryFetched(
            tautulliId: tautulliId,
            sectionId: widget.libraryTableModel.sectionId!,
            settingsBloc: settingsBloc,
          ),
        );

    context.read<LibraryRecentlyAddedBloc>().add(
          LibraryRecentlyAddedFetched(
            tautulliId: tautulliId,
            sectionId: widget.libraryTableModel.sectionId ?? 0,
            settingsBloc: settingsBloc,
          ),
        );

    context.read<LibraryStatisticsBloc>().add(
          LibraryStatisticsFetched(
            tautulliId: tautulliId,
            sectionId: widget.libraryTableModel.sectionId ?? 0,
            settingsBloc: settingsBloc,
          ),
        );

    context.read<LibraryMediaBloc>().add(
          LibraryMediaFetched(
            tautulliId: tautulliId,
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
      body: SliverTabbedDetails(
        background: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            state as SettingsSuccess;

            return CachedNetworkImage(
              imageUrl: widget.libraryTableModel.backgroundUri.toString(),
              httpHeaders: {
                for (CustomHeaderModel headerModel in state.appSettings.activeServer.customHeaders)
                  headerModel.key: headerModel.value,
              },
              imageBuilder: (context, imageProvider) => ImageFiltered(
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
              placeholder: (context, url) => Image.asset('assets/images/art_fallback.png'),
              errorWidget: (context, url, error) => Image.asset('assets/images/art_fallback.png'),
            );
          },
        ),
        icon: LibraryDetailsIcon(libraryTableModel: widget.libraryTableModel),
        title: widget.libraryTableModel.sectionName ?? '',
        subtitle: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: LocaleKeys.last_streamed_title.tr()),
              const TextSpan(text: ' '),
              TextSpan(
                text: widget.libraryTableModel.lastAccessed != null
                    ? TimeHelper.moment(widget.libraryTableModel.lastAccessed)
                    : LocaleKeys.never.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 13,
                  color: Colors.grey[200],
                ),
              ),
            ],
          ),
        ),
        tabs: [
          Tab(
            text: LocaleKeys.stats_title.tr(),
          ),
          Tab(
            text: LocaleKeys.new_title.tr(),
          ),
          Tab(
            text: LocaleKeys.history_title.tr(),
          ),
          Tab(
            text: LocaleKeys.media_title.tr(),
          ),
        ],
        tabChildren: [
          LibraryDetailsStatsTab(libraryTableModel: widget.libraryTableModel),
          LibraryDetailsNewTab(libraryTableModel: widget.libraryTableModel),
          LibraryDetailsHistoryTab(libraryTableModel: widget.libraryTableModel),
          LibraryDetailsMediaTab(libraryTableModel: widget.libraryTableModel),
        ],
      ),
    );
  }
}
