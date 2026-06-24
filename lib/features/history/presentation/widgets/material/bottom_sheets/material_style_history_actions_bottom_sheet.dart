import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../core/types/bloc_status.dart';
import '../../../../../../core/widgets/material/material_style_bottom_sheet_scaffold.dart';
import '../../../../../../features/users/presentation/bloc/users_bloc.dart';
import '../../../../../../translations/locale_keys.g.dart';

class MaterialStyleHistoryActionsBottomSheet extends StatelessWidget {
  final int? userId;
  final bool filterApplied;

  const MaterialStyleHistoryActionsBottomSheet({
    super.key,
    required this.userId,
    required this.filterApplied,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialStyleBottomSheetScaffold(
      title: LocaleKeys.history_actions_title.tr(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<UsersBloc, UsersState>(
                  builder: (context, state) {
                    final enabled = state.status == BlocStatus.success;
                    return _ActionTile(
                      icon: FaIcon(
                        state.status == BlocStatus.failure ? FontAwesomeIcons.userSlash : FontAwesomeIcons.solidUser,
                        size: 18,
                        color: enabled
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      title: LocaleKeys.select_user_title.tr(),
                      enabled: enabled,
                      trailing: Builder(
                        builder: (context) {
                          if (userId != null && userId != -1) {
                            return Icon(
                              Icons.circle,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            );
                          }
                          if ([BlocStatus.initial, BlocStatus.inProgress].contains(state.status)) {
                            return SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            );
                          }
                          if (state.status == BlocStatus.failure) {
                            return Icon(
                              Icons.warning_rounded,
                              color: Theme.of(context).colorScheme.error,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      onTap: state.status == BlocStatus.success ? () => Navigator.of(context).pop('user') : null,
                    );
                  },
                ),
                _ActionTile(
                  icon: FaIcon(
                    FontAwesomeIcons.filter,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  title: LocaleKeys.filter_history_title.tr(),
                  trailing: filterApplied
                      ? Icon(
                          Icons.circle,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : const SizedBox.shrink(),
                  onTap: () => Navigator.of(context).pop('filter'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _ActionTile(
              icon: FaIcon(
                FontAwesomeIcons.xmark,
                size: 18,
                color: Theme.of(context).colorScheme.error,
              ),
              title: LocaleKeys.clear_filters_title.tr(),
              titleColor: Theme.of(context).colorScheme.error,
              onTap: () => Navigator.of(context).pop('clear'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final Color? titleColor;
  final Widget? trailing;
  final bool enabled;
  final VoidCallback? onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    this.titleColor,
    this.trailing,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ElevationOverlay.applySurfaceTint(
        Theme.of(context).colorScheme.surface,
        Theme.of(context).colorScheme.surfaceTint,
        1,
      ),
      child: ListTile(
        enabled: enabled,
        leading: icon,
        title: Text(
          title,
          style: titleColor != null ? TextStyle(color: titleColor) : null,
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
