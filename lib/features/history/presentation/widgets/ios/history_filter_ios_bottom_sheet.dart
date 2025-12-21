import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../core/widgets/ios/ios_bottom_sheet_cancel_button.dart';
import '../../../../../core/widgets/ios/ios_bottom_sheet_save_button.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';

class HistoryFilterIosBottomSheet extends StatefulWidget {
  final Map<String, bool> filterMap;

  const HistoryFilterIosBottomSheet({
    super.key,
    required this.filterMap,
  });

  @override
  State<HistoryFilterIosBottomSheet> createState() => _HistoryFilterIosBottomSheetState();
}

class _HistoryFilterIosBottomSheetState extends State<HistoryFilterIosBottomSheet> {
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
    return PageScaffoldCupertino(
      //TODO: Add translation string
      middle: const Text('Filter History'),
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
                  title: const Text(LocaleKeys.movies_title).tr(),
                  trailing: _filterMap['movie'] != false ? const Icon(CupertinoIcons.checkmark_alt) : null,
                ),
                CustomNotchedCupertinoListTile(
                  onTap: () => changeValue(key: 'episode'),
                  title: const Text(LocaleKeys.tv_title).tr(),
                  trailing: _filterMap['episode'] != false ? const Icon(CupertinoIcons.checkmark_alt) : null,
                ),
                CustomNotchedCupertinoListTile(
                  onTap: () => changeValue(key: 'track'),
                  title: const Text(LocaleKeys.music_title).tr(),
                  trailing: _filterMap['track'] != false ? const Icon(CupertinoIcons.checkmark_alt) : null,
                ),
                CustomNotchedCupertinoListTile(
                  onTap: () => changeValue(key: 'live'),
                  title: const Text(LocaleKeys.live_tv_title).tr(),
                  trailing: _filterMap['live'] != false ? const Icon(CupertinoIcons.checkmark_alt) : null,
                ),
              ],
            ),
            CustomCupertinoListSection(
              hasLeading: false,
              children: [
                CustomNotchedCupertinoListTile(
                  onTap: () => changeValue(key: 'directPlay'),
                  title: const Text(LocaleKeys.direct_play_title).tr(),
                  trailing: _filterMap['directPlay'] != false ? const Icon(CupertinoIcons.checkmark_alt) : null,
                ),
                CustomNotchedCupertinoListTile(
                  onTap: () => changeValue(key: 'directStream'),
                  title: const Text(LocaleKeys.direct_stream_title).tr(),
                  trailing: _filterMap['directStream'] != false ? const Icon(CupertinoIcons.checkmark_alt) : null,
                ),
                CustomNotchedCupertinoListTile(
                  onTap: () => changeValue(key: 'transcode'),
                  title: const Text(LocaleKeys.transcode_title).tr(),
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
