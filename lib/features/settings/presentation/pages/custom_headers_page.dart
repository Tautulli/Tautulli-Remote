// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/database/data/models/custom_header_model.dart';
import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/delete_dialog.dart';
import '../widgets/header_type_dialog.dart';

class CustomHeadersPage extends StatelessWidget {
  // final ServerModel server;
  final String tautulliId;

  const CustomHeadersPage({
    Key key,
    // @required this.server,
    @required this.tautulliId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text(LocaleKeys.settings_server_custom_http_headers).tr(),
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.plus,
              color: TautulliColorPalette.not_white,
            ),
            onPressed: () {
              return showDialog(
                context: context,
                builder: (context) => HeaderTypeDialog(
                  tautulliId: tautulliId,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoadSuccess) {
            final ServerModel server = state.serverList
                .firstWhere((server) => server.tautulliId == tautulliId);
            return server.customHeaders.isNotEmpty
                ? ListView(
                    children: _buildHeaderWidgetList(
                      context: context,
                      tautulliId: tautulliId,
                      maskSensitiveInfo: state.maskSensitiveInfo,
                      headers: server.customHeaders,
                    ),
                  )
                : Center(
                    child: const Text(
                      LocaleKeys.settings_custom_headers_missing,
                      style: TextStyle(fontSize: 18),
                    ).tr(),
                  );
          }
          return const Center(
            child: Text('Error loading settings'),
          );
        },
      ),
    );
  }
}

List<ListTile> _buildHeaderWidgetList({
  @required BuildContext context,
  @required String tautulliId,
  @required bool maskSensitiveInfo,
  @required List<CustomHeaderModel> headers,
}) {
  headers.sort((a, b) => a.key.compareTo(b.key));

  List<ListTile> headerWidgets = [];

  headers.forEach((header) {
    headerWidgets.add(
      ListTile(
        title: Text(header.key),
        subtitle: Text(
          !maskSensitiveInfo
              ? header.value
              : '*${LocaleKeys.masked_header_key.tr()}*',
        ),
        trailing: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.trashAlt,
            color: TautulliColorPalette.not_white,
          ),
          onPressed: () async {
            final delete = await _showDeleteHeaderDialog(
              context: context,
              headerKey: header.key,
            );

            if (delete) {
              context.read<SettingsBloc>().add(
                    SettingsRemoveCustomHeader(
                      tautulliId: tautulliId,
                      key: header.key,
                    ),
                  );
            }
          },
        ),
      ),
    );
  });

  return headerWidgets;
}

Future<bool> _showDeleteHeaderDialog({
  @required BuildContext context,
  @required String headerKey,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return DeleteDialog(
        titleWidget: const Text(
          LocaleKeys.settings_header_delete_alert_title,
        ).tr(
          args: [headerKey],
        ),
      );
    },
  );
}
