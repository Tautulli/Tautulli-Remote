import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/time_helper.dart';
import '../../../../../core/pages/ios/tabbed_icon_details_ios_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/types/user_icon_size.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../history/presentation/bloc/user_history_bloc.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/user_model.dart';
import '../../bloc/user_individual_bloc.dart';
import '../../bloc/user_statistics_bloc.dart';
import '../../widgets/ios/user_details_history_ios_tab.dart';
import '../../widgets/ios/user_details_stats_ios_tab.dart';
import '../../widgets/ios/user_ios_icon.dart';

class UserDetailsIosPage extends StatelessWidget {
  final ServerModel server;
  final UserModel user;
  final Color? backgroundColor;
  final bool fetchUser;

  const UserDetailsIosPage({
    super.key,
    required this.server,
    required this.user,
    this.backgroundColor,
    this.fetchUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<UserIndividualBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<UserStatisticsBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<UserHistoryBloc>(),
        ),
      ],
      child: UserDetailsIosView(
        server: server,
        user: user,
        backgroundColor: backgroundColor,
        fetchUser: fetchUser,
      ),
    );
  }
}

class UserDetailsIosView extends StatefulWidget {
  final ServerModel server;
  final UserModel user;
  final Color? backgroundColor;
  final bool fetchUser;

  const UserDetailsIosView({
    super.key,
    required this.server,
    required this.user,
    this.backgroundColor,
    this.fetchUser = false,
  });

  @override
  State<UserDetailsIosView> createState() => _UserDetailsIosViewState();
}

class _UserDetailsIosViewState extends State<UserDetailsIosView> {
  late Future getColorFuture;
  late bool hasNetworkImage;
  late UserHistoryBloc _userHistoryBloc;
  Color? _backgroundColor;

  @override
  void initState() {
    super.initState();
    hasNetworkImage = _hasNetworkImage(widget.user);
    getColorFuture = _getColor(widget.user.userThumb);

    final settingsBloc = context.read<SettingsBloc>();
    _userHistoryBloc = context.read<UserHistoryBloc>();

    _resolveBackgroundColor();

    if (widget.fetchUser) {
      context.read<UserIndividualBloc>().add(
        UserIndividualFetched(
          server: widget.server,
          userId: widget.user.userId!,
          settingsBloc: settingsBloc,
        ),
      );
    }

    _userHistoryBloc.add(
      UserHistoryFetched(
        server: widget.server,
        userId: widget.user.userId!,
        settingsBloc: settingsBloc,
      ),
    );
    context.read<UserStatisticsBloc>().add(
      UserStatisticsFetched(
        server: widget.server,
        userId: widget.user.userId!,
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
          previousPageTitle: LocaleKeys.users_title.tr(),
          sensitive: settingsState.appSettings.maskSensitiveInfo,
          background: Container(
            //TODO: Use this method elsewhere instead of a stack of 2 colors?
            color: _backgroundColor != null
                ? Color.alphaBlend(
                    CupertinoColors.black.withValues(alpha: 0.6),
                    _backgroundColor!,
                  )
                : null,
          ),
          icon: BlocBuilder<UserIndividualBloc, UserIndividualState>(
            builder: (context, state) {
              return UserIosIcon(
                user: widget.fetchUser && state.user.userId != null ? state.user : widget.user,
                size: UserIconSize.large,
              );
            },
          ),
          title: widget.user.friendlyName ?? 'name missing',
          subtitle: BlocBuilder<UserIndividualBloc, UserIndividualState>(
            builder: (context, state) {
              return RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: LocaleKeys.streamed_title.tr(),
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const TextSpan(
                      text: ' ',
                    ),
                    TextSpan(
                      text: widget.user.lastSeen != null && !widget.fetchUser
                          ? TimeHelper.moment(widget.user.lastSeen)
                          : widget.fetchUser && state.user.lastSeen != null
                          ? TimeHelper.moment(state.user.lastSeen)
                          : widget.fetchUser && state.status == BlocStatus.initial
                          ? ''
                          : LocaleKeys.never.tr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          segments: {
            0: const Text(LocaleKeys.stats_title).tr(),
            1: const Text(LocaleKeys.history_title).tr(),
          },
          segmentChildren: [
            UserDetailsStatsIosTab(
              server: widget.server,
              user: widget.user,
            ),
            UserDetailsHistoryIosTab(
              server: widget.server,
              user: widget.user,
            ),
          ],
        );
      },
    );
  }

  Future<void> _resolveBackgroundColor() async {
    if (widget.backgroundColor != null) {
      setState(() {
        _backgroundColor = widget.backgroundColor;
      });

      return;
    }

    if (hasNetworkImage && !widget.fetchUser) {
      final color = await _getColor(widget.user.userThumb);

      setState(() {
        _backgroundColor = color;
      });
    }
  }
}

bool _hasNetworkImage(UserModel user) {
  if (user.userThumb != null) {
    return user.userThumb!.startsWith('http');
  }
  return false;
}

Future<Color?> _getColor(String? url) async {
  if (url == null || !url.startsWith('http')) return null;

  final palette = await PaletteGenerator.fromImageProvider(
    CachedNetworkImageProvider(url),
    maximumColorCount: 1,
  );

  return palette.dominantColor?.color;
}
