import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/base/sensitive_text.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/registration_headers_bloc.dart';
import '../../../bloc/settings_bloc.dart';
import '../bottom_sheets/cupertino_style_edit_custom_http_header_bottom_sheet.dart';
import '../dialogs/cupertino_style_delete_dialog.dart';

class CupertinoStyleCustomHeaderListTile extends StatelessWidget {
  final bool forRegistration;
  final String title;
  final String subtitle;
  final String? tautulliId;
  final bool sensitive;

  const CupertinoStyleCustomHeaderListTile({
    super.key,
    required this.forRegistration,
    required this.title,
    required this.subtitle,
    this.tautulliId,
    this.sensitive = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return CupertinoStyleNotchedCupertinoListTile(
          titleText: title,
          subtitleText: subtitle.sensitive(context, enabled: sensitive),
          leading: Icon(
            CupertinoIcons.tag_fill,
            color: ThemeHelper.cupertinoListTileIconColor(),
          ),
          additionalInfo: GestureDetector(
            onTap: () async {
              final result = await showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoStyleDeleteDialog(
                  title: const Text(LocaleKeys.server_delete_dialog_title).tr(args: [title]),
                ),
              );

              if (result) {
                if (forRegistration) {
                  context.read<RegistrationHeadersBloc>().add(
                    RegistrationHeadersDelete(title),
                  );
                } else {
                  if (tautulliId != null) {
                    context.read<SettingsBloc>().add(
                      SettingsDeleteCustomHeader(
                        tautulliId: tautulliId!,
                        title: title,
                      ),
                    );
                  }
                }
              }
            },
            child: Icon(
              CupertinoIcons.clear_circled_solid,
              color: ThemeHelper.cupertinoListTileIconColor(),
            ),
          ),
          trailing: const CupertinoListTileChevron(),
          onTap: () => showCupertinoModalPopup(
            context: context,
            builder: (context) => CupertinoStyleEditCustomHttpHeaderBottomSheet(
              forRegistration: false,
              tautulliId: tautulliId,
              existingKey: title,
              existingValue: subtitle,
            ),
          ),
        );
      },
    );
  }
}
