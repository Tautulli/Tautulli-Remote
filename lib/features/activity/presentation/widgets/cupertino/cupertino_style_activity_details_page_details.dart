import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:quiver/strings.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/helpers/data_unit_helper.dart';
import '../../../../../core/helpers/ip_address_helper.dart';
import '../../../../../core/helpers/string_helper.dart';
import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/helpers/time_helper.dart';
import '../../../../../core/types/bloc_status.dart';
import '../../../../../core/types/media_type.dart';
import '../../../../../core/types/stream_decision.dart';
import '../../../../../core/types/subtitle_decision.dart';
import '../../../../../core/widgets/base/sensitive_text.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../geo_ip/data/models/geo_ip_model.dart';
import '../../../../geo_ip/presentation/bloc/geo_ip_bloc.dart';
import '../../../../settings/presentation/bloc/settings_bloc.dart';
import '../../../data/models/activity_model.dart';

class CupertinoStyleActivityDetailsPageDetails extends StatefulWidget {
  final ServerModel server;
  final ActivityModel activity;

  const CupertinoStyleActivityDetailsPageDetails({
    super.key,
    required this.server,
    required this.activity,
  });

  @override
  State<CupertinoStyleActivityDetailsPageDetails> createState() => _ActivityBottomSheetDetailsState();
}

class _ActivityBottomSheetDetailsState extends State<CupertinoStyleActivityDetailsPageDetails> {
  @override
  void initState() {
    super.initState();

    final settingsBloc = context.read<SettingsBloc>();

    if (widget.activity.ipAddress != null) {
      context.read<GeoIpBloc>().add(
        GeoIpFetched(
          server: widget.server,
          ipAddress: widget.activity.ipAddress!,
          settingsBloc: settingsBloc,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            settingsState as SettingsSuccess;

            return Column(
              children: [
                _ItemRow(
                  title: LocaleKeys.user_title.tr(),
                  item: Text(
                    widget.activity.friendlyName ?? '',
                  ).sensitive(),
                ),
                if (widget.activity.live != true &&
                    widget.activity.duration != null &&
                    widget.activity.viewOffset != null &&
                    widget.activity.duration != null)
                  _ItemRow(
                    title: LocaleKeys.eta_title.tr(),
                    item: Text(
                      TimeHelper.eta(
                        widget.activity.duration!,
                        widget.activity.progressPercent,
                        widget.server.timeFormat,
                      ),
                    ),
                  ),
                const Gap(8),
                _ItemRow(
                  title: LocaleKeys.product_title.tr(),
                  item: Text(
                    widget.activity.product ?? '',
                  ),
                ),
                _ItemRow(
                  title: LocaleKeys.player_title.tr(),
                  item: Text(widget.activity.player ?? '').sensitive(),
                ),
                _ItemRow(
                  title: LocaleKeys.quality_title.tr(),
                  item: Builder(
                    builder: (context) {
                      String formattedBitrate = '';
                      String finalText = '';

                      if (widget.activity.mediaType != MediaType.photo && widget.activity.qualityProfile != 'Unknown') {
                        if (widget.activity.streamBitrate != null) {
                          if (widget.activity.streamBitrate! > 1000) {
                            formattedBitrate = '${(widget.activity.streamBitrate! / 1000).toStringAsFixed(1)} Mbps';
                          } else {
                            formattedBitrate = '${widget.activity.streamBitrate} kbps';
                          }
                        }
                      }

                      if (widget.activity.qualityProfile != null) {
                        if (isNotBlank(formattedBitrate)) {
                          finalText = '${widget.activity.qualityProfile} ($formattedBitrate)';
                        } else {
                          finalText = widget.activity.qualityProfile!;
                        }
                      }

                      return Text(finalText);
                    },
                  ),
                ),
                if (widget.activity.optimizedVersion == true)
                  _ItemRow(
                    title: LocaleKeys.optimized_title.tr(),
                    item: Text(
                      '${widget.activity.optimizedVersionProfile} ${widget.activity.optimizedVersionTitle}',
                    ),
                  ),
                //TODO: Add a section for downloads if that ever gets supported
                const Gap(8),
                _ItemRow(
                  title: LocaleKeys.stream_title.tr(),
                  item: Builder(
                    builder: (context) {
                      String finalText;

                      if (widget.activity.transcodeDecision == StreamDecision.transcode) {
                        if (widget.activity.transcodeThrottled == true) {
                          finalText = '${LocaleKeys.transcode_title.tr()} (${LocaleKeys.throttled_title.tr()})';
                        } else {
                          finalText =
                              '${LocaleKeys.transcode_title.tr()} (${LocaleKeys.speed_title.tr()}: ${widget.activity.transcodeSpeed})';
                        }
                      } else if (widget.activity.transcodeDecision == StreamDecision.copy) {
                        finalText = LocaleKeys.direct_stream_title.tr();
                      } else {
                        finalText = LocaleKeys.direct_play_title.tr();
                      }

                      return Text(finalText);
                    },
                  ),
                ),
                _ItemRow(
                  title: LocaleKeys.container_title.tr(),
                  item: Builder(
                    builder: (context) {
                      if (widget.activity.streamContainerDecision == StreamDecision.transcode) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(LocaleKeys.converting_title).tr(),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: '${widget.activity.container?.toUpperCase()}'),
                                  const WidgetSpan(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: Icon(
                                        CupertinoIcons.arrow_right,
                                        size: 17,
                                        color: ThemeHelper.cupertinoBottomSheetTextColor,
                                      ),
                                    ),
                                  ),
                                  TextSpan(text: '${widget.activity.streamContainer?.toUpperCase()}'),
                                ],
                                style: const TextStyle(
                                  color: ThemeHelper.cupertinoBottomSheetTextColor,
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return Text(
                        '${LocaleKeys.direct_play_title.tr()} (${widget.activity.streamContainer?.toUpperCase()})',
                      );
                    },
                  ),
                ),
                if (widget.activity.mediaType != MediaType.track)
                  _ItemRow(
                    title: LocaleKeys.video_title.tr(),
                    item: Builder(
                      builder: (context) {
                        String videoDynamicRange = '';
                        String streamVideoDynamicRange = '';
                        String hwD = '';
                        String hwE = '';

                        if ([
                              MediaType.movie,
                              MediaType.episode,
                              MediaType.clip,
                            ].contains(widget.activity.mediaType) &&
                            widget.activity.streamVideoDecision != null) {
                          if (widget.activity.videoDynamicRange != 'SDR') {
                            videoDynamicRange = ' ${widget.activity.videoDynamicRange}';
                            streamVideoDynamicRange = ' ${widget.activity.streamVideoDynamicRange}';
                          }

                          if (widget.activity.streamVideoDecision == StreamDecision.transcode) {
                            if (widget.activity.transcodeHwDecoding == true) {
                              hwD = ' (HW)';
                            }
                            if (widget.activity.transcodeHwEncoding == true) {
                              hwE = ' (HW)';
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(LocaleKeys.transcode_title).tr(),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            '${widget.activity.videoCodec?.toUpperCase()}$hwD ${widget.activity.videoFullResolution}$videoDynamicRange',
                                      ),
                                      const WidgetSpan(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                          child: Icon(
                                            CupertinoIcons.arrow_right,
                                            size: 17,
                                            color: ThemeHelper.cupertinoBottomSheetTextColor,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '${widget.activity.streamVideoCodec?.toUpperCase()}$hwE ${widget.activity.streamVideoFullResolution}$streamVideoDynamicRange',
                                      ),
                                    ],
                                    style: const TextStyle(
                                      color: ThemeHelper.cupertinoBottomSheetTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if (widget.activity.streamVideoDecision == StreamDecision.copy) {
                            return Text(
                              '${LocaleKeys.direct_stream_title.tr()} (${widget.activity.streamVideoCodec?.toUpperCase()} ${widget.activity.streamVideoFullResolution}$streamVideoDynamicRange)',
                            );
                          } else {
                            return Text(
                              '${LocaleKeys.direct_play_title.tr()} (${widget.activity.streamVideoCodec?.toUpperCase()} ${widget.activity.streamVideoFullResolution}$streamVideoDynamicRange)',
                            );
                          }
                        } else if (widget.activity.mediaType == MediaType.photo) {
                          return Text(
                            '${LocaleKeys.direct_play_title.tr()} (${widget.activity.width}x${widget.activity.height})',
                          );
                        }

                        return const Text('');
                      },
                    ),
                  ),
                if (widget.activity.mediaType != MediaType.photo)
                  _ItemRow(
                    title: LocaleKeys.audio_title.tr(),
                    item: Builder(
                      builder: (context) {
                        final bool audioLanguageEmpty = isEmpty(widget.activity.audioLanguage);

                        if (widget.activity.streamAudioDecision == StreamDecision.transcode) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(LocaleKeys.transcode_title).tr(),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    if (widget.activity.audioChannelLayout != null)
                                      TextSpan(
                                        text:
                                            '${audioLanguageEmpty ? LocaleKeys.unknown_title.tr() : widget.activity.audioLanguage} - ${widget.activity.audioCodec?.toUpperCase()} ${StringHelper.capitalize(widget.activity.audioChannelLayout!.split("(")[0])}',
                                      ),
                                    const WidgetSpan(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 5),
                                        child: Icon(
                                          CupertinoIcons.arrow_right,
                                          size: 17,
                                          color: ThemeHelper.cupertinoBottomSheetTextColor,
                                        ),
                                      ),
                                    ),
                                    if (widget.activity.streamAudioChannelLayout != null)
                                      TextSpan(
                                        text:
                                            '${widget.activity.streamAudioCodec?.toUpperCase()} ${StringHelper.capitalize(widget.activity.streamAudioChannelLayout!.split("(")[0])}',
                                      ),
                                  ],
                                  style: const TextStyle(
                                    color: ThemeHelper.cupertinoBottomSheetTextColor,
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (widget.activity.streamAudioDecision == StreamDecision.copy) {
                          if (widget.activity.streamAudioChannelLayout != null) {
                            return Text(
                              '${audioLanguageEmpty ? LocaleKeys.unknown_title.tr() : widget.activity.audioLanguage} - ${LocaleKeys.direct_stream_title.tr()} (${widget.activity.streamAudioCodec?.toUpperCase()} ${StringHelper.capitalize(widget.activity.streamAudioChannelLayout!.split("(")[0])})',
                            );
                          }
                        } else {
                          if (widget.activity.streamAudioChannelLayout != null) {
                            return Text(
                              '${audioLanguageEmpty ? LocaleKeys.unknown_title.tr() : widget.activity.audioLanguage} - ${LocaleKeys.direct_play_title.tr()} (${widget.activity.streamAudioCodec?.toUpperCase()} ${StringHelper.capitalize(widget.activity.streamAudioChannelLayout!.split("(")[0])})',
                            );
                          }
                        }

                        return const Text('');
                      },
                    ),
                  ),
                if (![MediaType.track, MediaType.photo].contains(widget.activity.mediaType))
                  _ItemRow(
                    title: LocaleKeys.subtitle_title.tr(),
                    item: Builder(
                      builder: (context) {
                        if (widget.activity.subtitles == true) {
                          final bool subtitleLanguageEmpty = isEmpty(widget.activity.subtitleLanguage);

                          if (widget.activity.streamSubtitleDecision == SubtitleDecision.transcode) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(LocaleKeys.transcode_title).tr(),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            '${subtitleLanguageEmpty ? LocaleKeys.unknown_title.tr() : widget.activity.subtitleLanguage} - ${widget.activity.subtitleCodec?.toUpperCase()}',
                                      ),
                                      const WidgetSpan(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                          child: Icon(
                                            CupertinoIcons.arrow_right,
                                            size: 17,
                                            color: ThemeHelper.cupertinoBottomSheetTextColor,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: widget.activity.streamSubtitleCodec?.toUpperCase(),
                                      ),
                                    ],
                                    style: const TextStyle(
                                      color: ThemeHelper.cupertinoBottomSheetTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if (widget.activity.streamSubtitleDecision == SubtitleDecision.copy) {
                            return Text(
                              '${LocaleKeys.direct_stream_title.tr()} (${subtitleLanguageEmpty ? LocaleKeys.unknown_title.tr() : widget.activity.subtitleLanguage} - ${widget.activity.subtitleCodec?.toUpperCase()})',
                            );
                          } else if (widget.activity.streamSubtitleDecision == SubtitleDecision.burn) {
                            return Text(
                              '${LocaleKeys.burn_title.tr()} (${subtitleLanguageEmpty ? LocaleKeys.unknown_title.tr() : widget.activity.subtitleLanguage} - ${widget.activity.subtitleCodec?.toUpperCase()})',
                            );
                          } else {
                            return Text(
                              '${LocaleKeys.direct_play_title.tr()} (${subtitleLanguageEmpty ? LocaleKeys.unknown_title.tr() : widget.activity.subtitleLanguage} - ${widget.activity.streamSubtitleCodec?.toUpperCase()})',
                            );
                          }
                        } else {
                          return const Text(LocaleKeys.none_title).tr();
                        }
                      },
                    ),
                  ),
                const Gap(8),
                _ItemRow(
                  title: LocaleKeys.ip_address_title.tr(),
                  item: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Icon(
                          widget.activity.secure == true ? CupertinoIcons.lock_fill : CupertinoIcons.lock_open_fill,
                          size: 17,
                          color: ThemeHelper.cupertinoBottomSheetTextColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '${widget.activity.location?.apiValue().toUpperCase()}: ${widget.activity.ipAddress}',
                        ).sensitive(),
                      ),
                    ],
                  ),
                ),
                if (widget.activity.ipAddress != null && IpAddressHelper.isPublic(widget.activity.ipAddress!))
                  _ItemRow(
                    title: LocaleKeys.location_title.tr(),
                    item: BlocBuilder<GeoIpBloc, GeoIpState>(
                      builder: (context, geoIpState) {
                        GeoIpModel? geoIpItem = geoIpState.geoIpMap[widget.activity.ipAddress];
                        String? city = geoIpItem?.city;
                        String? region = geoIpItem?.region;
                        String? code = geoIpItem?.code;

                        if (widget.activity.relay == true) {
                          return const Text(LocaleKeys.plex_relay_message).tr();
                        } else if (geoIpState.status == BlocStatus.success) {
                          return Text('$city, $region $code').sensitive();
                        } else if (geoIpState.status == BlocStatus.failure) {
                          return const Text(
                            LocaleKeys.location_lookup_failed_message,
                          ).tr();
                        } else {
                          return const Padding(
                            padding: EdgeInsets.only(
                              top: 2,
                              bottom: 2,
                            ),
                            child: SizedBox(
                              width: 130,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: CupertinoActivityIndicator(radius: 8),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                _ItemRow(
                  title: LocaleKeys.bandwidth_title.tr(),
                  item: Builder(
                    builder: (context) {
                      if (widget.activity.mediaType != MediaType.photo) {
                        return Text(
                          DataUnitHelper.bitrate(
                            widget.activity.bandwidth ?? 0,
                          ),
                        );
                      }

                      return const Text(LocaleKeys.unknown_title).tr();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final String title;
  final Widget item;

  const _ItemRow({
    required this.title,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: ThemeHelper.cupertinoBottomSheetHeadingColor,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          const Gap(8),
          Expanded(child: item),
        ],
      ),
    );
  }
}
