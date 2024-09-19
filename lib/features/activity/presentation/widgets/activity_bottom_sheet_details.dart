import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:quiver/strings.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/helpers/data_unit_helper.dart';
import '../../../../core/helpers/ip_address_helper.dart';
import '../../../../core/helpers/string_helper.dart';
import '../../../../core/types/bloc_status.dart';
import '../../../../core/types/tautulli_types.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../geo_ip/data/models/geo_ip_model.dart';
import '../../../geo_ip/presentation/bloc/geo_ip_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';
import '../../data/models/activity_model.dart';

class ActivityBottomSheetDetails extends StatefulWidget {
  final ServerModel server;
  final ActivityModel activity;

  const ActivityBottomSheetDetails({
    super.key,
    required this.server,
    required this.activity,
  });

  @override
  State<ActivityBottomSheetDetails> createState() => _ActivityBottomSheetDetailsState();
}

class _ActivityBottomSheetDetailsState extends State<ActivityBottomSheetDetails> {
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
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
              child: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, settingsState) {
                  settingsState as SettingsSuccess;

                  return Column(
                    children: [
                      _ItemRow(
                        title: LocaleKeys.product_title.tr(),
                        item: Text(
                          widget.activity.product ?? '',
                        ),
                      ),
                      _ItemRow(
                        title: LocaleKeys.player_title.tr(),
                        item: Text(
                          settingsState.appSettings.maskSensitiveInfo ? LocaleKeys.hidden_message.tr() : widget.activity.player ?? '',
                        ),
                      ),
                      _ItemRow(
                        title: LocaleKeys.quality_title.tr(),
                        item: Builder(
                          builder: (context) {
                            String formattedBitrate = '';
                            late String finalText;

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
                                finalText = '${LocaleKeys.transcode_title.tr()} (${LocaleKeys.speed_title.tr()}: ${widget.activity.transcodeSpeed})';
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
                                        WidgetSpan(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                            child: FaIcon(
                                              FontAwesomeIcons.rightLong,
                                              size: 16,
                                              color: Theme.of(context).colorScheme.onSurface,
                                            ),
                                          ),
                                        ),
                                        TextSpan(text: '${widget.activity.streamContainer?.toUpperCase()}'),
                                      ],
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurface,
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
                                              text: '${widget.activity.videoCodec?.toUpperCase()}$hwD ${widget.activity.videoFullResolution}$videoDynamicRange',
                                            ),
                                            WidgetSpan(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                                child: FaIcon(
                                                  FontAwesomeIcons.rightLong,
                                                  size: 16,
                                                  color: Theme.of(context).colorScheme.onSurface,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${widget.activity.streamVideoCodec?.toUpperCase()}$hwE ${widget.activity.streamVideoFullResolution}$streamVideoDynamicRange',
                                            ),
                                          ],
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.onSurface,
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
                                                  '${audioLanguageEmpty ? "Unknown" : widget.activity.audioLanguage} - ${widget.activity.audioCodec?.toUpperCase()} ${StringHelper.capitalize(widget.activity.audioChannelLayout!.split("(")[0])}',
                                            ),
                                          WidgetSpan(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 5),
                                              child: FaIcon(
                                                FontAwesomeIcons.rightLong,
                                                size: 16,
                                                color: Theme.of(context).colorScheme.onSurface,
                                              ),
                                            ),
                                          ),
                                          if (widget.activity.streamAudioChannelLayout != null)
                                            TextSpan(
                                              text:
                                                  '${widget.activity.streamAudioCodec?.toUpperCase()} ${StringHelper.capitalize(widget.activity.streamAudioChannelLayout!.split("(")[0])}',
                                            ),
                                        ],
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else if (widget.activity.streamAudioDecision == StreamDecision.copy) {
                                if (widget.activity.streamAudioChannelLayout != null) {
                                  return Text(
                                    '${audioLanguageEmpty ? "Unknown" : widget.activity.audioLanguage} - ${LocaleKeys.direct_stream_title.tr()} (${widget.activity.streamAudioCodec?.toUpperCase()} ${StringHelper.capitalize(widget.activity.streamAudioChannelLayout!.split("(")[0])})',
                                  );
                                }
                              } else {
                                if (widget.activity.streamAudioChannelLayout != null) {
                                  return Text(
                                    '${audioLanguageEmpty ? "Unknown" : widget.activity.audioLanguage} - ${LocaleKeys.direct_play_title.tr()} (${widget.activity.streamAudioCodec?.toUpperCase()} ${StringHelper.capitalize(widget.activity.streamAudioChannelLayout!.split("(")[0])})',
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
                                                  '${subtitleLanguageEmpty ? "Unknown" : widget.activity.subtitleLanguage} - ${widget.activity.subtitleCodec?.toUpperCase()}',
                                            ),
                                            WidgetSpan(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                                child: FaIcon(
                                                  FontAwesomeIcons.rightLong,
                                                  size: 16,
                                                  color: Theme.of(context).colorScheme.onSurface,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text: widget.activity.streamSubtitleCodec?.toUpperCase(),
                                            ),
                                          ],
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (widget.activity.streamSubtitleDecision == SubtitleDecision.copy) {
                                  return Text(
                                    '${LocaleKeys.direct_stream_title.tr()} (${subtitleLanguageEmpty ? "Unknown" : widget.activity.subtitleLanguage} - ${widget.activity.subtitleCodec?.toUpperCase()})',
                                  );
                                } else if (widget.activity.streamSubtitleDecision == SubtitleDecision.burn) {
                                  return Text(
                                    '${LocaleKeys.burn_title.tr()} (${subtitleLanguageEmpty ? "Unknown" : widget.activity.subtitleLanguage} - ${widget.activity.subtitleCodec?.toUpperCase()})',
                                  );
                                } else {
                                  return Text(
                                    '${LocaleKeys.direct_play_title.tr()} (${subtitleLanguageEmpty ? "Unknown" : widget.activity.subtitleLanguage} - ${widget.activity.streamSubtitleCodec?.toUpperCase()})',
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
                              child: FaIcon(
                                widget.activity.secure == true ? FontAwesomeIcons.lock : FontAwesomeIcons.lockOpen,
                                size: 14,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                settingsState.appSettings.maskSensitiveInfo
                                    ? LocaleKeys.hidden_message.tr()
                                    : '${widget.activity.location?.apiValue().toUpperCase()}: ${widget.activity.ipAddress}',
                              ),
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
                              } else if (settingsState.appSettings.maskSensitiveInfo) {
                                return const Text(LocaleKeys.hidden_message).tr();
                              } else if (geoIpState.status == BlocStatus.success) {
                                return Text('$city, $region $code');
                              } else if (geoIpState.status == BlocStatus.failure) {
                                return const Text(
                                  LocaleKeys.location_lookup_failed_message,
                                ).tr();
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    bottom: 8,
                                  ),
                                  child: SizedBox(
                                    width: 130,
                                    child: LinearProgressIndicator(
                                      color: Theme.of(context).colorScheme.onSurface,
                                      backgroundColor: Colors.transparent,
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
          ),
        ),
      ],
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
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        // CrossAxisAlignment.baseline can't actually calculate any intrinsics sizes here because baseline metrics are
        // only available after layout (and the intrinsics are explicitly not doing a full layout).

        // As a result we cannot precisely align the bottom of the text inside an IntrinsicHeight.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
          const Gap(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                item,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
