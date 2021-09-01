// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/strings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validators/validators.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../bloc/settings_bloc.dart';

class ServerSettingsPage extends StatelessWidget {
  final int id;
  final String plexName;
  final bool maskSensitiveInfo;

  const ServerSettingsPage({
    Key key,
    @required this.id,
    @required this.plexName,
    @required this.maskSensitiveInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>();
    final _primaryConnectionAddressController = TextEditingController();
    final _secondaryConnectionAddressController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('$plexName ${LocaleKeys.settings_page_title.tr()}'),
        actions: <Widget>[
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.trashAlt,
              color: TautulliColorPalette.not_white,
            ),
            onPressed: () async {
              bool delete = await _showDeleteServerDialog(
                context: context,
                plexName: plexName,
              );
              if (delete) {
                settingsBloc.add(
                  SettingsDeleteServer(
                    id: id,
                    plexName: plexName,
                  ),
                );
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoadSuccess) {
            try {
              final ServerModel server =
                  state.serverList.firstWhere((item) => item.id == id);
              return ListView(
                children: <Widget>[
                  ListTile(
                    title: const Text(
                            LocaleKeys.settings_primary_connection_address)
                        .tr(),
                    subtitle: isEmpty(server.primaryConnectionAddress)
                        ? const Text(LocaleKeys.settings_required).tr()
                        : isNotEmpty(server.primaryConnectionAddress) &&
                                !maskSensitiveInfo
                            ? Text(server.primaryConnectionAddress)
                            : Text(
                                '*${LocaleKeys.masked_info_connection_address.tr()}*',
                              ),
                    trailing: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.5,
                          color: server.primaryActive
                              ? Theme.of(context).accentColor
                              : Colors.grey[700],
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Text(
                        isNotEmpty(server.primaryConnectionAddress) &&
                                server.primaryActive
                            ? LocaleKeys.settings_active.tr()
                            : isNotEmpty(server.primaryConnectionAddress)
                                ? LocaleKeys.settings_passive.tr()
                                : LocaleKeys.settings_disabled.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: server.primaryActive
                              ? Theme.of(context).accentColor
                              : Colors.grey[700],
                        ),
                      ),
                    ),
                    onTap: () {
                      _buildPrimaryConnectionAddressSettingsDialog(
                        context: context,
                        id: server.id,
                        plexName: plexName,
                        primaryConnectionAddress:
                            server.primaryConnectionAddress,
                        controller: _primaryConnectionAddressController,
                        settingsBloc: settingsBloc,
                      );
                    },
                    onLongPress: () {
                      if (isNotEmpty(server.primaryConnectionAddress)) {
                        Clipboard.setData(
                          ClipboardData(text: server.primaryConnectionAddress),
                        );
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: PlexColorPalette.shark,
                            content:
                                const Text(LocaleKeys.settings_copied).tr(),
                          ),
                        );
                      }
                    },
                  ),
                  ListTile(
                    title: const Text(
                            LocaleKeys.settings_secondary_connection_address)
                        .tr(),
                    subtitle: isEmpty(server.secondaryConnectionAddress)
                        ? const Text(LocaleKeys.settings_not_configured).tr()
                        : isNotEmpty(server.secondaryConnectionAddress) &&
                                !maskSensitiveInfo
                            ? Text(server.secondaryConnectionAddress)
                            : Text(
                                '*${LocaleKeys.masked_info_connection_address.tr()}*',
                              ),
                    trailing: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.5,
                          color: !server.primaryActive
                              ? Theme.of(context).accentColor
                              : Colors.grey[700],
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Text(
                        isEmpty(server.secondaryConnectionAddress)
                            ? LocaleKeys.settings_disabled.tr()
                            : !server.primaryActive
                                ? LocaleKeys.settings_active.tr()
                                : LocaleKeys.settings_passive.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: !server.primaryActive
                              ? Theme.of(context).accentColor
                              : Colors.grey[700],
                        ),
                      ),
                    ),
                    onTap: () {
                      _buildSecondaryConnectionAddressSettingsDialog(
                        context: context,
                        id: server.id,
                        plexName: plexName,
                        secondaryConnectionAddress:
                            server.secondaryConnectionAddress,
                        controller: _secondaryConnectionAddressController,
                        settingsBloc: settingsBloc,
                      );
                    },
                    onLongPress: () {
                      if (isNotEmpty(server.secondaryConnectionAddress)) {
                        Clipboard.setData(
                          ClipboardData(
                              text: server.secondaryConnectionAddress),
                        );
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: PlexColorPalette.shark,
                            content:
                                const Text(LocaleKeys.settings_copied).tr(),
                          ),
                        );
                      }
                    },
                  ),
                  ListTile(
                    title: const Text(
                      LocaleKeys.settings_device_token,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ).tr(),
                    subtitle: Text(
                      maskSensitiveInfo
                          ? '*${LocaleKeys.masked_device_token.tr()}*'
                          : server.deviceToken,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: PlexColorPalette.shark,
                          content: const Text(
                                  LocaleKeys.settings_copy_device_token_message)
                              .tr(),
                          action: SnackBarAction(
                            label: LocaleKeys.button_learn_more.tr(),
                            onPressed: () async {
                              await launch(
                                'https://github.com/Tautulli/Tautulli-Remote/wiki/Settings#device_tokens',
                              );
                            },
                            textColor: TautulliColorPalette.not_white,
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      if (isNotEmpty(server.deviceToken)) {
                        Clipboard.setData(
                          ClipboardData(text: server.deviceToken),
                        );
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: PlexColorPalette.shark,
                            content:
                                const Text(LocaleKeys.settings_copied).tr(),
                          ),
                        );
                      }
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  ListTile(
                    title: const Text(LocaleKeys.settings_open_server).tr(
                      args: [server.plexName],
                    ),
                    trailing: const FaIcon(
                      FontAwesomeIcons.externalLinkAlt,
                      color: TautulliColorPalette.not_white,
                      size: 20,
                    ),
                    onTap: () async {
                      if (server.primaryActive) {
                        await launch(server.primaryConnectionAddress);
                      } else {
                        await launch(server.secondaryConnectionAddress);
                      }
                    },
                  ),
                ],
              );
            } catch (error) {
              return const Text(
                LocaleKeys.settings_server_error,
              ).tr(args: [error]);
            }
          }
          return const Text('Bloc error');
        },
      ),
    );
  }
}

Future _buildPrimaryConnectionAddressSettingsDialog({
  @required BuildContext context,
  @required int id,
  @required String plexName,
  @required String primaryConnectionAddress,
  @required TextEditingController controller,
  @required SettingsBloc settingsBloc,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      final _primaryConnectionFormKey = GlobalKey<FormState>();

      if (primaryConnectionAddress != null) {
        controller.text = primaryConnectionAddress;
      }
      return AlertDialog(
        title: const Text(LocaleKeys.settings_primary_connection_dialog_title)
            .tr(),
        content: Form(
          key: _primaryConnectionFormKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: LocaleKeys.settings_primary_connection_dialog_hint.tr(),
            ),
            validator: (value) {
              bool validUrl = isURL(
                value,
                protocols: ['http', 'https'],
                requireProtocol: true,
              );
              if (validUrl == false) {
                return LocaleKeys.settings_connection_address_validation_message
                    .tr();
              }
              return null;
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(LocaleKeys.button_close).tr(),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(LocaleKeys.button_save).tr(),
            onPressed: () {
              if (_primaryConnectionFormKey.currentState.validate()) {
                settingsBloc.add(
                  SettingsUpdatePrimaryConnection(
                    id: id,
                    primaryConnectionAddress: controller.text,
                    plexName: plexName,
                  ),
                );
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}

Future _buildSecondaryConnectionAddressSettingsDialog({
  @required BuildContext context,
  @required int id,
  @required String plexName,
  @required String secondaryConnectionAddress,
  @required TextEditingController controller,
  @required SettingsBloc settingsBloc,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      final _secondaryConnectionFormKey = GlobalKey<FormState>();

      if (secondaryConnectionAddress != null) {
        controller.text = secondaryConnectionAddress;
      }
      return AlertDialog(
        title: const Text(LocaleKeys.settings_secondary_connection_dialog_title)
            .tr(),
        content: Form(
          key: _secondaryConnectionFormKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText:
                  LocaleKeys.settings_secondary_connection_dialog_hint.tr(),
            ),
            validator: (value) {
              bool validUrl = isURL(
                value,
                protocols: ['http', 'https'],
                requireProtocol: true,
              );
              if (isNotEmpty(controller.text) && validUrl == false) {
                return LocaleKeys.settings_connection_address_validation_message
                    .tr();
              }
              return null;
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(LocaleKeys.button_close).tr(),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(LocaleKeys.button_save).tr(),
            onPressed: () {
              if (_secondaryConnectionFormKey.currentState.validate()) {
                settingsBloc.add(
                  SettingsUpdateSecondaryConnection(
                    id: id,
                    plexName: plexName,
                    secondaryConnectionAddress: controller.text,
                  ),
                );
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}

Future<bool> _showDeleteServerDialog({
  @required BuildContext context,
  @required String plexName,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          LocaleKeys.settings_server_delete_dialog_title,
        ).tr(args: [plexName]),
        actions: <Widget>[
          TextButton(
            child: const Text(LocaleKeys.button_cancel).tr(),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text(LocaleKeys.button_confirm).tr(),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
