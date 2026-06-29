import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/strings.dart';
import 'package:validators/validators.dart';

import '../../../../../../core/database/data/models/server_model.dart';
import '../../../../../../core/widgets/cupertino/cupertino_style_modal_popup_scaffold.dart';
import '../../../../../../core/widgets/cupertino/buttons/cupertino_style_bottom_sheet_cancel_button.dart';
import '../../../../../../core/widgets/cupertino/buttons/cupertino_style_bottom_sheet_save_button.dart';
import '../../../../../../translations/locale_keys.g.dart';
import '../../../bloc/settings_bloc.dart';

class CupertinoStyleServerConnectionAddressBottomSheet extends StatefulWidget {
  final bool primary;
  final ServerModel server;
  final String title;

  const CupertinoStyleServerConnectionAddressBottomSheet({
    super.key,
    required this.primary,
    required this.server,
    required this.title,
  });

  @override
  State<CupertinoStyleServerConnectionAddressBottomSheet> createState() =>
      _CupertinoStyleServerConnectionAddressBottomSheetState();
}

class _CupertinoStyleServerConnectionAddressBottomSheetState
    extends State<CupertinoStyleServerConnectionAddressBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    if (widget.primary) {
      _controller.text = widget.server.primaryConnectionAddress;
    }
    if (!widget.primary && widget.server.secondaryConnectionAddress != null) {
      _controller.text = widget.server.secondaryConnectionAddress!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return Form(
      key: _formKey,
      child: CupertinoStyleModalPopupScaffold(
        middleText: widget.title,
        leading: const CupertinoStyleBottomSheetCancelButton(),
        trailing: CupertinoStyleBottomSheetSaveButton(
          onPressed: () {
            if (_formKey.currentState != null && _formKey.currentState!.validate()) {
              context.read<SettingsBloc>().add(
                SettingsUpdateConnectionInfo(
                  primary: widget.primary,
                  connectionAddress: _controller.text,
                  server: widget.server,
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
                controller: _controller,
                autofocus: true,
                validator: (value) {
                  bool validUrl = isURL(
                    value,
                    protocols: ['http', 'https'],
                    requireProtocol: true,
                    allowUnderscore: true,
                  );
                  if ((widget.primary && validUrl == false) ||
                      (!widget.primary && isNotBlank(_controller.text) && validUrl == false)) {
                    return widget.primary
                        ? LocaleKeys.server_connection_address_dialog_primary_validation.tr()
                        : LocaleKeys.server_connection_address_dialog_secondary_validation.tr();
                  }
                  return null;
                },
                placeholder: widget.primary
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
