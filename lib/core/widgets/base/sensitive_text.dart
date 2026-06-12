import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/settings/presentation/bloc/settings_bloc.dart';

extension RedactedTextExtension on Text {
  Widget sensitive({
    bool enabled = true,
  }) {
    if (!enabled) return this;

    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) {
        if (previous is SettingsSuccess && current is SettingsSuccess) {
          return previous.appSettings.maskSensitiveInfo != current.appSettings.maskSensitiveInfo;
        }
        return true;
      },
      builder: (context, state) {
        state as SettingsSuccess;

        if (state.appSettings.maskSensitiveInfo) {
          return Text(
            redactedString,
            key: key,
            style: style,
            strutStyle: strutStyle,
            textAlign: textAlign,
            textDirection: textDirection,
            locale: locale,
            softWrap: softWrap,
            overflow: overflow,
            textScaler: textScaler,
            maxLines: maxLines,
            semanticsLabel: semanticsLabel,
            textWidthBasis: textWidthBasis,
            textHeightBehavior: textHeightBehavior,
            selectionColor: selectionColor,
          );
        }
        return this;
      },
    );
  }
}

extension SensitiveStringExtension on String {
  String sensitive({bool enabled = true}) => redactedString;
}

extension SensitiveNullableStringExtension on String? {
  String sensitive({bool enabled = true}) => redactedString;
}

extension SensitiveTextSpanExtension on TextSpan {
  TextSpan sensitive({bool enabled = true}) {
    assert(children == null, 'sensitive() cannot be used on a TextSpan with children set.');
    if (!enabled) return this;
    return TextSpan(
      text: redactedString,
      style: style,
      recognizer: recognizer,
      mouseCursor: mouseCursor,
      onEnter: onEnter,
      onExit: onExit,
      semanticsLabel: semanticsLabel,
      locale: locale,
      spellOut: spellOut,
    );
  }
}

const redactedString = '●●●●●●●●●●';
