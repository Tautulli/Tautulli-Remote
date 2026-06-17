import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator_master/palette_generator_master.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/time_helper.dart';
import '../../../../../core/pages/material/material_style_tabbed_icon_details_page.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/types/user_icon_size.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../history/presentation/bloc/user_history_bloc.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/user_model.dart';
import '../../bloc/user_individual_bloc.dart';
import '../../bloc/user_statistics_bloc.dart';
import '../../widgets/material/material_style_user_details_history_tab.dart';
import '../../widgets/material/material_style_user_details_stats_tab.dart';
import '../../widgets/material/material_style_user_icon.dart';

class MaterialStyleUserDetailsPage extends StatelessWidget {
  final ServerModel server;
  final UserModel user;
  final Color? backgroundColor;
  final bool fetchUser;

  const MaterialStyleUserDetailsPage({
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
          create: (context) => di.sl<UserIndividualBloc>(param1: context.read<SettingsBloc>()),
        ),
        BlocProvider(
          create: (context) => di.sl<UserStatisticsBloc>(param1: context.read<SettingsBloc>()),
        ),
        BlocProvider(
          create: (context) => di.sl<UserHistoryBloc>(param1: context.read<SettingsBloc>()),
        ),
      ],
      child: MaterialStyleUserDetailsView(
        server: server,
        user: user,
        backgroundColor: backgroundColor,
        fetchUser: fetchUser,
      ),
    );
  }
}

class MaterialStyleUserDetailsView extends StatefulWidget {
  final ServerModel server;
  final UserModel user;
  final Color? backgroundColor;
  final bool fetchUser;

  const MaterialStyleUserDetailsView({
    super.key,
    required this.server,
    required this.user,
    this.backgroundColor,
    this.fetchUser = false,
  });

  @override
  State<MaterialStyleUserDetailsView> createState() => _MaterialStyleUserDetailsViewState();
}

class _MaterialStyleUserDetailsViewState extends State<MaterialStyleUserDetailsView> {
  late Future getColorFuture;
  late bool hasNetworkImage;
  late UserHistoryBloc _userHistoryBloc;

  @override
  void initState() {
    super.initState();
    hasNetworkImage = _hasNetworkImage(widget.user);
    getColorFuture = _getColor(widget.user.userThumb);

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
    return Scaffold(
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          settingsState as SettingsSuccess;

          return MaterialStyleTabbedIconDetailsPage(
            sensitive: settingsState.appSettings.maskSensitiveInfo,
            background: widget.backgroundColor != null
                ? DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color.alphaBlend(
                        Colors.black.withValues(alpha: 0.6),
                        widget.backgroundColor!,
                      ),
                    ),
                  )
                : BlocBuilder<UserIndividualBloc, UserIndividualState>(
                    builder: (context, state) {
                      return FutureBuilder(
                        future: hasNetworkImage && !widget.fetchUser ? getColorFuture : _getColor(state.user.userThumb),
                        builder: (context, snapshot) {
                          Color? color;

                          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                            color = snapshot.data as Color;
                          }

                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: color != null
                                  ? Color.alphaBlend(
                                      Colors.black.withValues(alpha: 0.6),
                                      color,
                                    )
                                  : null,
                            ),
                          );
                        },
                      );
                    },
                  ),
            icon: BlocBuilder<UserIndividualBloc, UserIndividualState>(
              builder: (context, state) {
                return MaterialStyleUserIcon(
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
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              },
            ),
            tabs: [
              Tab(text: LocaleKeys.stats_title.tr()),
              Tab(text: LocaleKeys.history_title.tr()),
            ],
            tabChildren: [
              MaterialStyleUserDetailsStatsTab(
                server: widget.server,
                user: widget.user,
              ),
              MaterialStyleUserDetailsHistoryTab(
                server: widget.server,
                user: widget.user,
              ),
            ],
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

  final palette = await PaletteGeneratorMaster.fromImageProvider(
    CachedNetworkImageProvider(url),
    maximumColorCount: 1,
  );

  return palette.dominantColor?.color;
}
