import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/time_helper.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/widgets/material/dialogs/material_style_failure_alert_dialog.dart';
import '../../../../../core/widgets/material/material_style_poster_details_page.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../../../media/data/models/media_model.dart';
import '../../../../media/presentation/pages/material/material_style_media_page.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../../users/data/models/user_model.dart';
import '../../../../users/presentation/pages/material/material_style_user_details_page.dart';
import '../../../data/models/activity_model.dart';
import '../../bloc/activity_bloc.dart';
import '../../bloc/terminate_stream_bloc.dart';
import '../../widgets/base/activity_details_page_details.dart';
import '../../widgets/base/activity_details_progress.dart';
import '../../widgets/base/progress_bar.dart';
import '../../widgets/material/dialogs/material_style_terminate_stream_dialog.dart';

class MaterialStyleActivityDetailsPage extends StatelessWidget {
  final ServerModel server;
  final ActivityModel activity;

  const MaterialStyleActivityDetailsPage({
    super.key,
    required this.server,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<TerminateStreamBloc>(param1: context.read<SettingsBloc>()),
      child: MaterialStyleActivityDetailsView(
        server: server,
        activity: activity,
      ),
    );
  }
}

class MaterialStyleActivityDetailsView extends StatefulWidget {
  final ServerModel server;
  final ActivityModel activity;

  const MaterialStyleActivityDetailsView({
    super.key,
    required this.server,
    required this.activity,
  });

  @override
  State<MaterialStyleActivityDetailsView> createState() => _MaterialStyleActivityDetailsViewState();
}

class _MaterialStyleActivityDetailsViewState extends State<MaterialStyleActivityDetailsView> {
  late ActivityModel _activity;
  late Uri? _posterUri;

  @override
  void initState() {
    super.initState();
    _activity = widget.activity;
    _setPosterUri();
  }

  void _setPosterUri() {
    switch (_activity.mediaType) {
      case (MediaType.episode):
        _posterUri = _activity.grandparentImageUri;
        break;
      default:
        _posterUri = _activity.imageUri;
    }
  }

  String _getItemTitle() {
    switch (_activity.mediaType) {
      case (MediaType.episode):
        return _activity.grandparentTitle ?? '';
      default:
        return _activity.title ?? '';
    }
  }

  String? _getItemSubtitle() {
    switch (_activity.mediaType) {
      case (MediaType.episode):
        return _activity.title;
      case (MediaType.clip):
        return _activity.subType != null ? '(${_activity.subType})' : null;
      case (MediaType.track):
        return _activity.grandparentTitle;
      default:
        return null;
    }
  }

  String? _getItemDetail() {
    final mediaType = _activity.mediaType;

    if (mediaType == MediaType.movie && _activity.year != null) {
      return _activity.year.toString();
    }

    if (mediaType == MediaType.episode &&
        _activity.live == true &&
        _activity.mediaIndex == null &&
        _activity.originallyAvailableAt != null) {
      return TimeHelper.cleanDateTime(_activity.originallyAvailableAt!, dateOnly: true);
    }

    if (mediaType == MediaType.episode && (_activity.parentMediaIndex != null || _activity.mediaIndex != null)) {
      return '${_activity.parentMediaIndex != null ? "S${_activity.parentMediaIndex}" : ""}${_activity.parentMediaIndex != null && _activity.mediaIndex != null ? " • " : ""}${_activity.mediaIndex != null ? "E${_activity.mediaIndex}" : ""}';
    }

    if (mediaType == MediaType.track) {
      return _activity.parentTitle;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return MultiBlocListener(
      listeners: [
        BlocListener<ActivityBloc, ActivityState>(
          listener: (context, state) {
            try {
              final activityList = state.serverActivityList
                  .firstWhere((server) => server.tautulliId == widget.server.tautulliId)
                  .activityList;
              final item = activityList.firstWhere(
                (item) => item.sessionId == _activity.sessionId && item.sessionKey == _activity.sessionKey,
              );
              setState(() {
                _activity = item;
              });
            } catch (_) {
              Navigator.of(context).pop();
            }
          },
        ),
        BlocListener<TerminateStreamBloc, TerminateStreamState>(
          listener: (context, state) {
            if (state is TerminateStreamSuccess) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(LocaleKeys.termination_request_sent_message).tr(),
                  action: SnackBarAction(
                    label: LocaleKeys.learn_more_title.tr(),
                    onPressed: () async {
                      await launchUrlString(
                        'https://github.com/Tautulli/Tautulli-Remote/wiki/Features#termination_caveats',
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),
                ),
              );
            }
            if (state is TerminateStreamFailure) {
              showFailureAlertDialog(context: context, failure: state.failure);
            }
          },
        ),
      ],
      child: MaterialStylePosterDetailsPage(
        itemTitle: _getItemTitle(),
        itemSubtitle: _getItemSubtitle(),
        itemDetail: _getItemDetail(),
        posterUri: _posterUri,
        mediaType: _activity.mediaType,
        activityState: _activity.state,
        appBarActions: _buildAppBarActions(context),
        body: Column(
          children: [
            ProgressBar(
              activity: _activity,
              backgroundColor: Colors.black26,
              transcodeColor: textColor,
              progressColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            ActivityDetailsProgress(activity: _activity),
            const Gap(8),
            ActivityDetailsPageDetails(
              server: widget.server,
              activity: _activity,
              arrowIcon: FaIcon(FontAwesomeIcons.rightLong, size: 16, color: textColor),
              iconColor: textColor,
              titleColor: Theme.of(context).colorScheme.onSurfaceVariant,
              lockIcon: FaIcon(
                _activity.secure == true ? FontAwesomeIcons.lock : FontAwesomeIcons.lockOpen,
                size: 14,
                color: textColor,
              ),
              loadingIndicator: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  width: 130,
                  child: LinearProgressIndicator(
                    color: textColor,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    return [
      IconButton(
        icon: FaIcon(
          FontAwesomeIcons.solidUser,
          size: 20,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: () {
          final user = UserModel(
            friendlyName: _activity.friendlyName,
            userId: _activity.userId,
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MaterialStyleUserDetailsPage(
                server: widget.server,
                user: user,
                fetchUser: true,
              ),
            ),
          );
        },
      ),
      IconButton(
        icon: FaIcon(
          FontAwesomeIcons.circleInfo,
          size: 20,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: () {
          final media = MediaModel(
            grandparentRatingKey: _activity.grandparentRatingKey,
            grandparentTitle: _activity.grandparentTitle,
            imageUri: _posterUri,
            live: _activity.live,
            mediaIndex: _activity.mediaIndex,
            mediaType: _activity.mediaType,
            parentMediaIndex: _activity.parentMediaIndex,
            parentRatingKey: _activity.parentRatingKey,
            parentTitle: _activity.parentTitle,
            ratingKey: _activity.ratingKey,
            title: _activity.title,
            year: _activity.year,
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MaterialStyleMediaPage(
                server: widget.server,
                media: media,
              ),
            ),
          );
        },
      ),
      if (widget.server.plexPass == true && _activity.mediaType != MediaType.photo)
        BlocBuilder<TerminateStreamBloc, TerminateStreamState>(
          builder: (context, state) {
            return IconButton(
              icon: FaIcon(
                FontAwesomeIcons.solidCircleXmark,
                size: 20,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: () async {
                final TextEditingController controller = TextEditingController();
                final bool confirm = await showTerminateSessionDialog(
                  activity: _activity,
                  controller: controller,
                  context: context,
                );
                if (confirm && context.mounted) {
                  context.read<TerminateStreamBloc>().add(
                    TerminateStreamStarted(
                      server: widget.server,
                      sessionId: _activity.sessionId,
                      sessionKey: _activity.sessionKey,
                      message: controller.text,
                    ),
                  );
                }
              },
            );
          },
        ),
    ];
  }
}
