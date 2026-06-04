import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/strings.dart';
import 'package:validators/validators.dart';

import '../../../../../../core/database/data/models/server_model.dart';
import '../../../../../../core/widgets/ios/cupertino_modal_popup_scaffold.dart';
import '../../../../../../core/widgets/ios/ios_bottom_sheet_cancel_button.dart';
import '../../../../../../core/widgets/ios/ios_bottom_sheet_save_button.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class ServerConnectionAddressIosBottomSheet extends StatelessWidget {
  final bool primary;
  final ServerModel server;
  final String title;

  const ServerConnectionAddressIosBottomSheet({
    super.key,
    required this.primary,
    required this.server,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();

    if (primary) {
      controller.text = server.primaryConnectionAddress;
    }
    if (!primary && server.secondaryConnectionAddress != null) {
      controller.text = server.secondaryConnectionAddress!;
    }

    return Form(
      key: formKey,
      child: CupertinoModalPopupScaffold(
        middleText: title,
        leading: const IosBottomSheetCancelButton(),
        trailing: IosBottomSheetSaveButton(
          onPressed: () {
            if (formKey.currentState != null && formKey.currentState!.validate()) {
              if (isEmpty(controller.text) && server.primaryActive != true) {
                context.read<SettingsBloc>().add(
                  SettingsUpdatePrimaryActive(
                    tautulliId: server.tautulliId,
                    primaryActive: true,
                  ),
                );
              }

              context.read<SettingsBloc>().add(
                SettingsUpdateConnectionInfo(
                  primary: primary,
                  connectionAddress: controller.text,
                  server: server,
                ),
              );
              Navigator.of(context).pop();
            }
          },
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CupertinoFormSection.insetGrouped(
            backgroundColor: CupertinoColors.transparent,
            children: [
              CupertinoTextFormFieldRow(
                controller: controller,
                autofocus: true,
                validator: (value) {
                  bool validUrl = isURL(
                    value,
                    protocols: ['http', 'https'],
                    requireProtocol: true,
                    allowUnderscore: true,
                  );
                  if ((primary && validUrl == false) ||
                      (!primary && isNotBlank(controller.text) && validUrl == false)) {
                    return primary
                        ? LocaleKeys.server_connection_address_dialog_primary_validation.tr()
                        : LocaleKeys.server_connection_address_dialog_secondary_validation.tr();
                  }
                  return null;
                },
                placeholder: primary
                    ? LocaleKeys.primary_connection_address_hint.tr()
                    : LocaleKeys.secondary_connection_address_hint.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
