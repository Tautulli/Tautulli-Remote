import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../../core/helpers/time_helper.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/widgets/sliver_tabbed_details.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../history/presentation/bloc/individual_history_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/user_model.dart';
import '../bloc/user_individual_bloc.dart';
import '../bloc/user_statistics_bloc.dart';
import '../widgets/user_details_history_tab.dart';
import '../widgets/user_details_stats_tab.dart';
import '../widgets/user_icon.dart';

class UserDetailsPage extends StatelessWidget {
  final UserModel user;
  final Color? backgroundColor;
  final bool fetchUser;

  const UserDetailsPage({
    super.key,
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
          create: (context) => di.sl<IndividualHistoryBloc>(),
        ),
      ],
      child: UserDetailsView(
        user: user,
        backgroundColor: backgroundColor,
        fetchUser: fetchUser,
      ),
    );
  }
}

class UserDetailsView extends StatefulWidget {
  final UserModel user;
  final Color? backgroundColor;
  final bool fetchUser;

  const UserDetailsView({
    super.key,
    required this.user,
    this.backgroundColor,
    this.fetchUser = false,
  });

  @override
  State<UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  late Future getColorFuture;
  late bool hasNetworkImage;
  late IndividualHistoryBloc _individualHistoryBloc;
  late String _tautulliId;

  @override
  void initState() {
    super.initState();
    hasNetworkImage = _hasNetworkImage(widget.user);
    getColorFuture = _getColor(widget.user.userThumb);

    final settingsBloc = context.read<SettingsBloc>();
    final settingsState = settingsBloc.state as SettingsSuccess;
    _individualHistoryBloc = context.read<IndividualHistoryBloc>();
    _tautulliId = settingsState.appSettings.activeServer.tautulliId;

    if (widget.fetchUser) {
      context.read<UserIndividualBloc>().add(
            UserIndividualFetched(
              tautulliId: settingsState.appSettings.activeServer.tautulliId,
              userId: widget.user.userId!,
              settingsBloc: settingsBloc,
            ),
          );
    }

    _individualHistoryBloc.add(
      IndividualHistoryFetched(
        tautulliId: _tautulliId,
        userId: widget.user.userId!,
        settingsBloc: settingsBloc,
      ),
    );
    context.read<UserStatisticsBloc>().add(
          UserStatisticsFetched(
            tautulliId: _tautulliId,
            userId: widget.user.userId!,
            settingsBloc: settingsBloc,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          settingsState as SettingsSuccess;

          return BlocBuilder<UserIndividualBloc, UserIndividualState>(
            builder: (context, userIndividualState) {
              final fetchedUser = UserModel(
                userId: userIndividualState.user.userId,
                friendlyName: userIndividualState.user.friendlyName,
                userThumb: userIndividualState.user.userThumb,
                isActive: userIndividualState.user.isActive,
                lastSeen: userIndividualState.user.lastSeen,
              );

              return SliverTabbedDetails(
                sensitive: settingsState.appSettings.maskSensitiveInfo,
                background: widget.backgroundColor != null
                    ? DecoratedBox(
                        decoration: BoxDecoration(
                          color: widget.backgroundColor,
                        ),
                      )
                    : FutureBuilder(
                        future: hasNetworkImage && !widget.fetchUser
                            ? getColorFuture
                            : _getColor(fetchedUser.userThumb),
                        builder: (context, snapshot) {
                          Color? color;

                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.data != null) {
                            color = snapshot.data as Color;
                          }

                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: color,
                            ),
                          );
                        },
                      ),
                icon: UserIcon(
                  user: widget.fetchUser && fetchedUser.userId != null
                      ? fetchedUser
                      : widget.user,
                  size: UserIconSize.large,
                ),
                title: widget.user.friendlyName ?? 'name missing',
                subtitle: RichText(
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
                            : widget.fetchUser && fetchedUser.lastSeen != null
                                ? TimeHelper.moment(fetchedUser.lastSeen)
                                : widget.fetchUser &&
                                        userIndividualState.status ==
                                            BlocStatus.initial
                                    ? ''
                                    : LocaleKeys.never.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[200],
                        ),
                      ),
                    ],
                  ),
                ),
                tabs: [
                  Tab(text: LocaleKeys.stats_title.tr()),
                  Tab(text: LocaleKeys.history_title.tr()),
                ],
                tabChildren: [
                  UserDetailsStatsTab(user: widget.user),
                  UserDetailsHistoryTab(user: widget.user),
                ],
              );
            },
          );
        },
      ),
    );
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
    NetworkImage(url),
    maximumColorCount: 1,
  );

  return palette.dominantColor?.color;
}
