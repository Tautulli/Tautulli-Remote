import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/palette_helper.dart';
import '../../../../../core/helpers/time_helper.dart';
import '../../../../../core/pages/cupertino/cupertino_style_tabbed_icon_details_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/types/user_icon_size.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../history/presentation/bloc/user_history_bloc.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/user_model.dart';
import '../../bloc/user_individual_bloc.dart';
import '../../bloc/user_statistics_bloc.dart';
import '../../widgets/cupertino/cupertino_style_user_details_history_tab.dart';
import '../../widgets/cupertino/cupertino_style_user_details_stats_tab.dart';
import '../../widgets/cupertino/cupertino_style_user_icon.dart';

class CupertinoStyleUserDetailsPage extends StatelessWidget {
  final ServerModel server;
  final UserModel user;
  final Color? backgroundColor;
  final bool fetchUser;
  final String? previousPageTitle;

  const CupertinoStyleUserDetailsPage({
    super.key,
    required this.server,
    required this.user,
    this.backgroundColor,
    this.fetchUser = false,
    this.previousPageTitle,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<UserIndividualBloc>(param1: context.read<SettingsBloc>()),
        ),
        BlocProvider(
          create: (context) => di.sl<UserStatisticsBloc>(param1: context.read<SettingsBloc>()),
        ),
        BlocProvider(
          create: (context) => di.sl<UserHistoryBloc>(param1: context.read<SettingsBloc>()),
        ),
      ],
      child: CupertinoStyleUserDetailsView(
        server: server,
        user: user,
        backgroundColor: backgroundColor,
        fetchUser: fetchUser,
        previousPageTitle: previousPageTitle,
      ),
    );
  }
}

class CupertinoStyleUserDetailsView extends StatefulWidget {
  final ServerModel server;
  final UserModel user;
  final Color? backgroundColor;
  final bool fetchUser;
  final String? previousPageTitle;

  const CupertinoStyleUserDetailsView({
    super.key,
    required this.server,
    required this.user,
    this.backgroundColor,
    this.fetchUser = false,
    this.previousPageTitle,
  });

  @override
  State<CupertinoStyleUserDetailsView> createState() => _CupertinoStyleUserDetailsViewState();
}

class _CupertinoStyleUserDetailsViewState extends State<CupertinoStyleUserDetailsView> {
  late Future<Color?> getColorFuture;
  late bool hasNetworkImage;
  late UserHistoryBloc _userHistoryBloc;

  @override
  void initState() {
    super.initState();
    hasNetworkImage = _hasNetworkImage(widget.user);
    getColorFuture = getDominantColor(widget.user.userThumb);

    _userHistoryBloc = context.read<UserHistoryBloc>();

    if (widget.fetchUser) {
      context.read<UserIndividualBloc>().add(
        UserIndividualFetched(
          server: widget.server,
          userId: widget.user.userId!,
        ),
      );
    }

    _userHistoryBloc.add(
      UserHistoryFetched(
        server: widget.server,
        userId: widget.user.userId!,
      ),
    );
    context.read<UserStatisticsBloc>().add(
      UserStatisticsFetched(
        server: widget.server,
        userId: widget.user.userId!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        settingsState as SettingsSuccess;

        return CupertinoStyleTabbedIconDetailsPage(
          previousPageTitle: widget.previousPageTitle,
          sensitive: settingsState.appSettings.maskSensitiveInfo,
          background: widget.backgroundColor != null
              ? Container(
                  color: Color.alphaBlend(
                    CupertinoColors.black.withValues(alpha: 0.6),
                    widget.backgroundColor!,
                  ),
                )
              : BlocBuilder<UserIndividualBloc, UserIndividualState>(
                  builder: (context, state) {
                    return FutureBuilder<Color?>(
                      future: hasNetworkImage && !widget.fetchUser ? getColorFuture : getDominantColor(state.user.userThumb),
                      builder: (context, snapshot) {
                        final color = snapshot.connectionState == ConnectionState.done ? snapshot.data : null;
                        return Container(
                          color: color != null
                              ? Color.alphaBlend(
                                  CupertinoColors.black.withValues(alpha: 0.6),
                                  color,
                                )
                              : null,
                        );
                      },
                    );
                  },
                ),
          icon: BlocBuilder<UserIndividualBloc, UserIndividualState>(
            builder: (context, state) {
              return CupertinoStyleUserIcon(
                user: widget.fetchUser && state.user.userId != null ? state.user : widget.user,
                size: UserIconSize.large,
              );
            },
          ),
          title: widget.user.friendlyName ?? LocaleKeys.name_missing.tr(),
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
                          ? TimeHelper.relativeTime(widget.user.lastSeen, context.locale)
                          : widget.fetchUser && state.user.lastSeen != null
                          ? TimeHelper.relativeTime(state.user.lastSeen, context.locale)
                          : widget.fetchUser && state.status == BlocStatus.initial
                          ? ''
                          : widget.fetchUser && state.status == BlocStatus.failure
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
            CupertinoStyleUserDetailsStatsTab(
              server: widget.server,
              user: widget.user,
            ),
            CupertinoStyleUserDetailsHistoryTab(
              server: widget.server,
              user: widget.user,
            ),
          ],
        );
      },
    );
  }
}

bool _hasNetworkImage(UserModel user) {
  if (user.userThumb != null) {
    return user.userThumb!.startsWith('http');
  }
  return false;
}
