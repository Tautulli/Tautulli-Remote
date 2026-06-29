import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/base/sensitive_text.dart';
import '../material_style_bottom_sheet_scaffold.dart';
import '../../../../features/users/presentation/bloc/users_bloc.dart';
import '../../../../translations/locale_keys.g.dart';

class MaterialStyleUserFilterBottomSheet extends StatelessWidget {
  final int initialValue;

  const MaterialStyleUserFilterBottomSheet({
    super.key,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return MaterialStyleBottomSheetScaffold(
      title: LocaleKeys.filter_user_title.tr(),
      child: BlocBuilder<UsersBloc, UsersState>(
        buildWhen: (previous, current) => previous.users != current.users,
        builder: (context, state) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _UserTile(
                  title: LocaleKeys.all_users_title.tr(),
                  selected: initialValue == -1,
                  onTap: () => Navigator.of(context).pop(-1),
                ),
                ...state.users.map(
                  (user) => _UserTile(
                    title: user.friendlyName ?? '',
                    sensitive: true,
                    selected: initialValue == user.userId,
                    onTap: () => Navigator.of(context).pop(user.userId),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final String title;
  final bool sensitive;
  final bool selected;
  final VoidCallback onTap;

  const _UserTile({
    required this.title,
    this.sensitive = false,
    required this.selected,
    required this.onTap,
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
        title: Text(title).sensitive(enabled: sensitive),
        trailing: selected
            ? Icon(
                Icons.check_rounded,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
