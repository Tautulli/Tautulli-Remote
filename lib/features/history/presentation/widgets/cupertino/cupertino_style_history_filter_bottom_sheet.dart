import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/ios/cupertino_modal_popup_scaffold.dart';
import '../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../core/widgets/ios/ios_bottom_sheet_cancel_button.dart';
import '../../../../../core/widgets/ios/ios_bottom_sheet_save_button.dart';
import '../../../../../translations/locale_keys.g.dart';

class CupertinoStyleHistoryFilterBottomSheet extends StatefulWidget {
  final Map<String, bool> filterMap;

  const CupertinoStyleHistoryFilterBottomSheet({
    super.key,
    required this.filterMap,
  });

  @override
  State<CupertinoStyleHistoryFilterBottomSheet> createState() => _CupertinoStyleHistoryFilterBottomSheetState();
}

class _CupertinoStyleHistoryFilterBottomSheetState extends State<CupertinoStyleHistoryFilterBottomSheet> {
  late Map<String, bool> _unalteredFilterMap;
  late Map<String, bool> _filterMap;

  @override
  void initState() {
    super.initState();

    _unalteredFilterMap = Map.from(widget.filterMap);
    _filterMap = widget.filterMap;
  }

  void changeValue({required String key}) {
    setState(() {
      if (_filterMap[key] == null) {
        _filterMap[key] = false;
      } else {
        _filterMap[key] = !_filterMap[key]!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoModalPopupScaffold(
      //TODO: Add translation string
      middleText: 'Filter History',
      leading: const IosBottomSheetCancelButton(),
      trailing: IosBottomSheetSaveButton(
        onPressed: () {
          final bool filterMapUnchanged =
              (_unalteredFilterMap['movie'] == _filterMap['movie']) &&
              (_unalteredFilterMap['episode'] == _filterMap['episode']) &&
              (_unalteredFilterMap['track'] == _filterMap['track']) &&
              (_unalteredFilterMap['live'] == _filterMap['live']) &&
              (_unalteredFilterMap['directPlay'] == _filterMap['directPlay']) &&
              (_unalteredFilterMap['directStream'] == _filterMap['directStream']) &&
              (_unalteredFilterMap['transcode'] == _filterMap['transcode']);

          Navigator.of(context).pop(filterMapUnchanged);
        },
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomCupertinoListSection(
              hasLeading: false,
              children: [
                CustomNotchedCupertinoListTile(
                  onTap: () => changeValue(key: 'movie'),
                  titleText: LocaleKeys.movies_title.tr(),
                  trailing: _filterMap['movie'] != false ? const Icon(CupertinoIcons.checkmark_alt) : null,
                ),
                CustomNotchedCupertinoListTile(
                  onTap: () => changeValue(key: 'episode'),
                  titleText: LocaleKeys.tv_title.tr(),
                  trailing: _filterMap['episode'] != false ? const Icon(CupertinoIcons.checkmark_alt) : null,
                ),
                CustomNotchedCupertinoListTile(
                  onTap: () => changeValue(key: 'track'),
                  titleText: LocaleKeys.music_title.tr(),
                  trailing: _filterMap['track'] != false ? const Icon(CupertinoIcons.checkmark_alt) : null,
                ),
                CustomNotchedCupertinoListTile(
                  onTap: () => changeValue(key: 'live'),
                  titleText: LocaleKeys.live_tv_title.tr(),
                  trailing: _filterMap['live'] != false ? const Icon(CupertinoIcons.checkmark_alt) : null,
                ),
              ],
            ),
            CustomCupertinoListSection(
              hasLeading: false,
              children: [
                CustomNotchedCupertinoListTile(
                  onTap: () => changeValue(key: 'directPlay'),
                  titleText: LocaleKeys.direct_play_title.tr(),
                  trailing: _filterMap['directPlay'] != false ? const Icon(CupertinoIcons.checkmark_alt) : null,
                ),
                CustomNotchedCupertinoListTile(
                  onTap: () => changeValue(key: 'directStream'),
                  titleText: LocaleKeys.direct_stream_title.tr(),
                  trailing: _filterMap['directStream'] != false ? const Icon(CupertinoIcons.checkmark_alt) : null,
                ),
                CustomNotchedCupertinoListTile(
                  onTap: () => changeValue(key: 'transcode'),
                  titleText: LocaleKeys.transcode_title.tr(),
                  trailing: _filterMap['transcode'] != false ? const Icon(CupertinoIcons.checkmark_alt) : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
