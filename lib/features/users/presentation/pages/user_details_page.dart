import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../../core/helpers/time_helper.dart';
import '../../../../core/pages/status_page.dart';
import '../../../../core/widgets/sliver_tabbed_details.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/user_model.dart';
import '../bloc/user_statistics_bloc.dart';
import '../widgets/user_details_stats_tab.dart';
import '../widgets/user_icon.dart';

class UserDetailsPage extends StatelessWidget {
  final UserModel user;
  final Color? backgroundColor;

  const UserDetailsPage({
    super.key,
    required this.user,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<UserStatisticsBloc>(),
      child: UserDetailsView(
        user: user,
        backgroundColor: backgroundColor,
      ),
    );
  }
}

class UserDetailsView extends StatefulWidget {
  final UserModel user;
  final Color? backgroundColor;

  const UserDetailsView({
    super.key,
    required this.user,
    this.backgroundColor,
  });

  @override
  State<UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  late Future getColorFuture;
  late bool hasNetworkImage;

  @override
  void initState() {
    super.initState();
    hasNetworkImage = widget.user.userThumb != null
        ? widget.user.userThumb!.startsWith('http')
        : false;
    getColorFuture = _getColor(widget.user.userThumb);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          state as SettingsSuccess;

          return SliverTabbedDetails(
            sensitive: state.appSettings.maskSensitiveInfo,
            background: widget.backgroundColor != null
                ? DecoratedBox(
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                    ),
                  )
                : FutureBuilder(
                    future: getColorFuture,
                    builder: (context, snapshot) {
                      Color? color;

                      if (snapshot.connectionState == ConnectionState.done &&
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
              user: widget.user,
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
                    text: widget.user.lastSeen != null
                        ? TimeHelper.moment(widget.user.lastSeen)
                        : LocaleKeys.never.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            tabs: const [
              Tab(text: 'Stats'),
              Tab(text: 'History'),
            ],
            tabSlivers: [
              UserDetailsStatsTab(user: widget.user),
              StatusPage(
                message:
                    LocaleKeys.feature_not_yet_available_snackbar_message.tr(),
              ),
            ],
          );
        },
      ),
    );
  }
}

Future<Color?> _getColor(String? url) async {
  if (url == null || !url.startsWith('http')) return null;

  final palette = await PaletteGenerator.fromImageProvider(
    NetworkImage(url),
    maximumColorCount: 1,
  );

  return palette.dominantColor?.color;
}
