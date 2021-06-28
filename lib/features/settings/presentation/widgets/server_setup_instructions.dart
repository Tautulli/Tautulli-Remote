import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/text_list.dart';
import '../../../../translations/locale_keys.g.dart';

class ServerSetupInstructions extends StatelessWidget {
  final bool showWarning;
  final double fontSize;

  const ServerSetupInstructions({
    Key key,
    this.showWarning = true,
    this.fontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (showWarning)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              LocaleKeys.settings_setup_instructions_warning,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ).tr(),
          ),
        Text(
          LocaleKeys.settings_setup_instructions_line_1,
          style: TextStyle(fontSize: fontSize),
        ).tr(),
        const SizedBox(height: 4),
        TextList(
          numberedList: true,
          textItems: [
            LocaleKeys.settings_setup_instructions_line_2.tr(),
            LocaleKeys.settings_setup_instructions_line_3.tr(),
            LocaleKeys.settings_setup_instructions_line_4.tr(),
            LocaleKeys.settings_setup_instructions_line_5.tr(),
          ],
          fontSize: 16,
        ),
      ],
    );
  }
}
