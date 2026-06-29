import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/cupertino/cupertino_style_list_section.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../data/models/custom_header_model.dart';
import '../../bloc/registration_headers_bloc.dart';
import 'bottom_sheets/cupertino_style_custom_http_header_bottom_sheet.dart';
import 'list_tiles/cupertino_style_custom_header_list_tile.dart';

class CupertinoStyleServerRegistrationStepThree extends StatelessWidget {
  const CupertinoStyleServerRegistrationStepThree({super.key});

  @override
  Widget build(BuildContext context) {
    context.locale; // Re-run translations in place on a language change.
    return BlocBuilder<RegistrationHeadersBloc, RegistrationHeadersState>(
      builder: (context, state) {
        return Column(
          children: [
            CupertinoStyleListSection(
              decoration: BoxDecoration(color: CupertinoColors.systemBackground.darkElevatedColor),
              headerText: '${LocaleKeys.step_title.tr()} 3',
              children: [
                if (state is RegistrationHeadersLoaded && state.headers.isNotEmpty)
                  ...state.headers.map(
                    (header) => CupertinoStyleCustomHeaderListTile(
                      forRegistration: true,
                      title: header.key,
                      subtitle: header.value,
                    ),
                  ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CupertinoButton.filled(
                child: const Text(LocaleKeys.add_custom_http_header_title).tr(),
                onPressed: () => showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoStyleCustomHttpHeaderBottomSheet(
                    forRegistration: true,
                    currentHeaders: state is RegistrationHeadersLoaded
                        ? state.headers
                              .map(
                                (header) => CustomHeaderModel(
                                  key: header.key,
                                  value: header.value,
                                ),
                              )
                              .toList()
                        : [],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
