import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../core/helpers/data_unit_format_helper.dart';
import '../../../../core/helpers/string_format_helper.dart';
import '../../../../core/widgets/media_type_icon.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../domain/entities/synced_item.dart';

class SyncedItemsDetails extends StatelessWidget {
  final SyncedItem syncedItem;
  final bool maskSensitiveInfo;

  const SyncedItemsDetails({
    Key key,
    @required this.syncedItem,
    @required this.maskSensitiveInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                syncedItem.syncTitle,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                maskSensitiveInfo
                    ? '*${LocaleKeys.masked_info_user.tr()}*'
                    : syncedItem.user,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                syncedItem.deviceName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${StringFormatHelper.capitalize(syncedItem.state)}${syncedItem.itemCompleteCount > 0 ? " · " : ""}${syncedItem.itemCompleteCount > 0 ? syncedItem.itemCompleteCount : ""} ${syncedItem.itemCompleteCount <= 0 ? "" : syncedItem.itemCompleteCount == 1 ? "item" : "items"}${syncedItem.totalSize > 0 ? " · " : ""}${syncedItem.totalSize > 0 ? DataUnitFormatHelper.prettyFilesize(syncedItem.totalSize) : ""}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  MediaTypeIcon(
                    mediaType: syncedItem.syncMediaType ?? syncedItem.mediaType,
                    iconColor: TautulliColorPalette.not_white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
