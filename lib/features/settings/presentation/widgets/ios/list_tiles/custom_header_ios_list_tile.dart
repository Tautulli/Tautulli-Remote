import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/theme_helper.dart';
import '../../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/registration_headers_bloc.dart';
import '../../../bloc/settings_bloc.dart';
import '../bottom_sheets/edit_custom_http_header_ios_bottom_sheet.dart';
import '../dialogs/delete_ios_dialog.dart';

class CustomHeaderIosListTile extends StatelessWidget {
  final bool forRegistration;
  final String title;
  final String subtitle;
  final String? tautulliId;
  final bool sensitive;

  const CustomHeaderIosListTile({
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
        return CustomNotchedCupertinoListTile(
          title: Text(title),
          subtitle: Text(
            sensitive && state is SettingsSuccess && state.appSettings.maskSensitiveInfo ? LocaleKeys.hidden_message.tr() : subtitle,
          ),
          leading: Icon(
            CupertinoIcons.tag_fill,
            color: ThemeHelper.cupertinoListTileIconColor(),
          ),
          additionalInfo: GestureDetector(
            onTap: () async {
              final result = await showCupertinoDialog(
                context: context,
                builder: (context) => DeleteIosDialog(
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
          onTap: () => showCupertinoSheet(
            context: context,
            pageBuilder: (context) => EditCustomHttpHeaderIosBottomSheet(
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
