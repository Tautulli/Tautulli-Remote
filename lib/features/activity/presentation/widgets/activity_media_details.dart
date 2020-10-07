import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/clean_data_helper.dart';
import '../../domain/entities/activity.dart';
import '../../domain/entities/geo_ip.dart';
import '../bloc/geo_ip_bloc.dart';

class ActivityMediaDetails extends StatefulWidget {
  final BoxConstraints constraints;
  final ActivityItem activity;
  final String tautulliId;

  const ActivityMediaDetails({
    Key key,
    @required this.constraints,
    @required this.activity,
    @required this.tautulliId,
  }) : super(key: key);

  @override
  _ActivityMediaDetailsState createState() => _ActivityMediaDetailsState();
}

class _ActivityMediaDetailsState extends State<ActivityMediaDetails> {
  @override
  void initState() {
    super.initState();
    context.bloc<GeoIpBloc>().add(
          GeoIpLoad(
            tautulliId: widget.tautulliId,
            ipAddress: widget.activity.ipAddress,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildList(
        constraints: widget.constraints,
        activity: widget.activity,
      ),
    );
  }
}

List<Widget> _buildList({
  @required BoxConstraints constraints,
  @required ActivityItem activity,
}) {
  List<Widget> rows = [];

  _buildRows(
    constraints: constraints,
    rowLists: ActivityMediaDetailsCleaner.product(activity),
  ).forEach((row) {
    rows.add(row);
  });

  _buildRows(
    constraints: constraints,
    rowLists: ActivityMediaDetailsCleaner.player(activity),
  ).forEach((row) {
    rows.add(row);
  });

  _buildRows(
    constraints: constraints,
    rowLists: ActivityMediaDetailsCleaner.quality(activity),
  ).forEach((row) {
    rows.add(row);
  });

  if (activity.optimizedVersion == 1) {
    _buildRows(
      constraints: constraints,
      rowLists: ActivityMediaDetailsCleaner.optimized(activity),
    ).forEach((row) {
      rows.add(row);
    });
  }

  if (activity.syncedVersion == 1) {
    _buildRows(
      constraints: constraints,
      rowLists: ActivityMediaDetailsCleaner.synced(activity),
    ).forEach((row) {
      rows.add(row);
    });
  }

  rows.add(
    SizedBox(
      height: 15,
    ),
  );

  _buildRows(
    constraints: constraints,
    rowLists: ActivityMediaDetailsCleaner.stream(activity),
  ).forEach((row) {
    rows.add(row);
  });

  _buildRows(
    constraints: constraints,
    rowLists: ActivityMediaDetailsCleaner.container(activity),
  ).forEach((row) {
    rows.add(row);
  });

  if (activity.mediaType != 'track') {
    _buildRows(
      constraints: constraints,
      rowLists: ActivityMediaDetailsCleaner.video(activity),
    ).forEach((row) {
      rows.add(row);
    });
  }

  if (activity.mediaType != 'photo') {
    _buildRows(
      constraints: constraints,
      rowLists: ActivityMediaDetailsCleaner.audio(activity),
    ).forEach((row) {
      rows.add(row);
    });
  }

  if (activity.mediaType != 'track' && activity.mediaType != 'photo') {
    _buildRows(
      constraints: constraints,
      rowLists: ActivityMediaDetailsCleaner.subtitles(activity),
    ).forEach((row) {
      rows.add(row);
    });
  }

  rows.add(
    SizedBox(
      height: 15,
    ),
  );

  _buildRows(
    constraints: constraints,
    rowLists: ActivityMediaDetailsCleaner.location(activity),
  ).forEach((row) {
    rows.add(row);
  });

  if (activity.relayed == 1) {
    _buildRows(
      constraints: constraints,
      rowLists: ActivityMediaDetailsCleaner.locationDetails(type: 'relay'),
    ).forEach((row) {
      rows.add(row);
    });
  }

  // Build the GeoIP data row
  if (activity.local == 0)
    rows.add(
      BlocBuilder<GeoIpBloc, GeoIpState>(
        builder: (context, state) {
          if (state is GeoIpSuccess) {
            if (state.geoIpMap.containsKey(activity.ipAddress)) {
              GeoIpItem geoIpItem = state.geoIpMap[activity.ipAddress];
              if (activity.relayed == 0 &&
                  geoIpItem != null &&
                  geoIpItem.code != 'ZZ') {
                final List locationDetails =
                    ActivityMediaDetailsCleaner.locationDetails(
                  type: 'ip',
                  city: geoIpItem.city,
                  region: geoIpItem.region,
                  code: geoIpItem.code,
                )[0];

                return _ActivityMediaDetailsRow(
                  constraints: constraints,
                  left: locationDetails[0],
                  right: locationDetails[1],
                );
              }
              return const SizedBox(height: 0, width: 0);
            }
            return _ActivityMediaDetailsRow(
              constraints: constraints,
              left: '',
              right: Row(
                children: [
                  Text('ERROR: IP Address not in GeoIP map'),
                ],
              ),
            );
          }
          return _ActivityMediaDetailsRow(
            constraints: constraints,
            left: '',
            right: Row(
              children: [
                SizedBox(
                  height: 19,
                  width: 19,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text('Loading location data'),
                ),
              ],
            ),
          );
        },
      ),
    );

  _buildRows(
    constraints: constraints,
    rowLists: ActivityMediaDetailsCleaner.bandwidth(activity),
  ).forEach((row) {
    rows.add(row);
  });

  return rows;
}

List<Widget> _buildRows({
  @required BoxConstraints constraints,
  @required List rowLists,
}) {
  List<Widget> rows = [];

  rowLists.forEach((row) {
    rows.add(
      _ActivityMediaDetailsRow(
        constraints: constraints,
        left: row[0],
        right: row[1],
      ),
    );
  });
  return rows;
}

class _ActivityMediaDetailsRow extends StatelessWidget {
  final BoxConstraints constraints;
  final String left;
  final Widget right;

  const _ActivityMediaDetailsRow({
    Key key,
    @required this.constraints,
    this.left,
    @required this.right,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
        right: 5,
        bottom: 5,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: constraints.maxWidth / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          left ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      right,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
