import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/time_helper.dart';
import '../../../../../core/pages/ios/tabbed_icon_details_ios_page.dart';
import '../../../../../core/types/section_type.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../history/presentation/bloc/library_history_bloc.dart';
import '../../../../recently_added/presentation/bloc/library_recently_added_bloc.dart';
import '../../../../settings/data/models/custom_header_model.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/library_table_model.dart';
import '../../bloc/library_media_bloc.dart';
import '../../bloc/library_statistics_bloc.dart';
import '../../widgets/ios/library_details_history_ios_tab.dart';
import '../../widgets/ios/library_details_ios_icon.dart';
import '../../widgets/ios/library_details_media_ios_tab.dart';
import '../../widgets/ios/library_details_new_ios_tab.dart';
import '../../widgets/ios/library_details_stats_ios_tab.dart';

class LibraryDetailsIosPage extends StatelessWidget {
  final LibraryTableModel libraryTableModel;

  const LibraryDetailsIosPage({
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
      child: LibraryDetailsIosView(
        libraryTableModel: libraryTableModel,
      ),
    );
  }
}

class LibraryDetailsIosView extends StatefulWidget {
  final LibraryTableModel libraryTableModel;

  const LibraryDetailsIosView({
    super.key,
    required this.libraryTableModel,
  });

  @override
  State<LibraryDetailsIosView> createState() => _LibraryDetailsIosViewState();
}

class _LibraryDetailsIosViewState extends State<LibraryDetailsIosView> {
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
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        settingsState as SettingsSuccess;

        return TabbedIconDetailsIosPage(
          previousPageTitle: LocaleKeys.libraries_title.tr(),
          background: CachedNetworkImage(
            imageUrl: widget.libraryTableModel.backgroundUri.toString(),
            httpHeaders: {
              for (CustomHeaderModel headerModel in settingsState.appSettings.activeServer.customHeaders)
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
            errorWidget: (context, url, error) => Image.asset('assets/images/art_error.png'),
          ),
          icon: LibraryDetailsIosIcon(libraryTableModel: widget.libraryTableModel),
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
                  ),
                ),
          segments: {
            if (widget.libraryTableModel.sectionType != SectionType.photo) 0: const Text(LocaleKeys.stats_title).tr(),
            if (![SectionType.live, SectionType.photo].contains(widget.libraryTableModel.sectionType))
              1: const Text(LocaleKeys.new_title).tr(),
            if (widget.libraryTableModel.sectionType != SectionType.photo) 2: const Text(LocaleKeys.history_title).tr(),
            if (widget.libraryTableModel.sectionType != SectionType.live) 3: const Text(LocaleKeys.media_title).tr(),
          },
          segmentChildren: [
            if (widget.libraryTableModel.sectionType != SectionType.photo)
              LibraryDetailsStatsIosTab(
                server: server,
                libraryTableModel: widget.libraryTableModel,
              ),
            if (![SectionType.live, SectionType.photo].contains(widget.libraryTableModel.sectionType))
              LibraryDetailsNewIosTab(
                server: server,
                libraryTableModel: widget.libraryTableModel,
              ),
            if (widget.libraryTableModel.sectionType != SectionType.photo)
              LibraryDetailsHistoryIosTab(
                server: server,
                libraryTableModel: widget.libraryTableModel,
              ),
            if (widget.libraryTableModel.sectionType != SectionType.live)
              LibraryDetailsMediaIosTab(
                server: server,
                libraryTableModel: widget.libraryTableModel,
                currentPageTitle: widget.libraryTableModel.sectionName,
              ),
          ],
        );
      },
    );
  }
}
