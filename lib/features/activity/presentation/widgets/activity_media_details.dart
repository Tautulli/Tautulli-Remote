import 'package:flutter/material.dart';

import '../../../../core/helpers/clean_data_helper.dart';
import '../../domain/entities/activity.dart';
import '../../domain/entities/geo_ip.dart';

class ActivityMediaDetails extends StatelessWidget {
  final BoxConstraints constraints;
  final ActivityItem activity;
  final GeoIpItem geoIp;

  const ActivityMediaDetails({
    Key key,
    @required this.constraints,
    @required this.activity,
    @required this.geoIp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cleanDetails = ActivityMediaDetailsCleanerImpl();
    return ListView(
      children: _buildList(
        constraints: constraints,
        activity: activity,
        geoIp: geoIp,
        cleanDetails: cleanDetails,
      ),
    );
  }
}

List<Widget> _buildList({
  @required BoxConstraints constraints,
  @required ActivityMediaDetailsCleanerImpl cleanDetails,
  @required ActivityItem activity,
  @required GeoIpItem geoIp,
}) {
  List<Widget> rows = [];

  rows.add(
    SizedBox(
      height: 15,
    ),
  );

  _buildRows(
    constraints: constraints,
    rowLists: cleanDetails.product(activity),
  ).forEach((row) {
    rows.add(row);
  });

  _buildRows(
    constraints: constraints,
    rowLists: cleanDetails.player(activity),
  ).forEach((row) {
    rows.add(row);
  });

  _buildRows(
    constraints: constraints,
    rowLists: cleanDetails.quality(activity),
  ).forEach((row) {
    rows.add(row);
  });

  if (activity.optimizedVersion == 1) {
    _buildRows(
      constraints: constraints,
      rowLists: cleanDetails.optimized(activity),
    ).forEach((row) {
      rows.add(row);
    });
  }

  if (activity.syncedVersion == 1) {
    _buildRows(
      constraints: constraints,
      rowLists: cleanDetails.synced(activity),
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
    rowLists: cleanDetails.stream(activity),
  ).forEach((row) {
    rows.add(row);
  });

  _buildRows(
    constraints: constraints,
    rowLists: cleanDetails.container(activity),
  ).forEach((row) {
    rows.add(row);
  });

  if (activity.mediaType != 'track') {
    _buildRows(
      constraints: constraints,
      rowLists: cleanDetails.video(activity),
    ).forEach((row) {
      rows.add(row);
    });
  }

  if (activity.mediaType != 'photo') {
    _buildRows(
      constraints: constraints,
      rowLists: cleanDetails.audio(activity),
    ).forEach((row) {
      rows.add(row);
    });
  }

  if (activity.mediaType != 'track' && activity.mediaType != 'photo') {
    _buildRows(
      constraints: constraints,
      rowLists: cleanDetails.subtitles(activity),
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
    rowLists: cleanDetails.location(activity),
  ).forEach((row) {
    rows.add(row);
  });

  if (activity.relayed == 1) {
    _buildRows(
      constraints: constraints,
      rowLists: cleanDetails.locationDetails(type: 'relay'),
    ).forEach((row) {
      rows.add(row);
    });
  }

  if (activity.relayed == 0 && geoIp != null && geoIp.code != 'ZZ') {
    _buildRows(
      constraints: constraints,
      rowLists: cleanDetails.locationDetails(
        type: 'ip',
        city: geoIp.city,
        region: geoIp.region,
        code: geoIp.code,
      ),
    ).forEach((row) {
      rows.add(row);
    });
  }

  _buildRows(
    constraints: constraints,
    rowLists: cleanDetails.bandwidth(activity),
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
      Padding(
        padding: const EdgeInsets.only(
          left: 5,
          right: 5,
          bottom: 5,
        ),
        child: Column(
          children: <Widget>[
            IntrinsicHeight(
              child: Row(
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
                              row[0],
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
                          row[1],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  });
  return rows;
}