import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/widgets/ios/ios_poster_card.dart';
import '../../../../geo_ip/presentation/bloc/geo_ip_bloc.dart';
import '../../../data/models/history_model.dart';
import 'history_ios_bottom_sheet.dart';
import 'history_ios_card_details.dart';

class HistoryIosCard extends StatefulWidget {
  final ServerModel server;
  final HistoryModel history;
  final bool showUser;
  final bool viewUserEnabled;
  final bool viewMediaEnabled;

  const HistoryIosCard({
    super.key,
    required this.server,
    required this.history,
    this.showUser = true,
    this.viewUserEnabled = true,
    this.viewMediaEnabled = true,
  });

  @override
  State<HistoryIosCard> createState() => _HistoryIosCardState();
}

class _HistoryIosCardState extends State<HistoryIosCard> {
  late GeoIpBloc _geoIpBloc;

  @override
  void initState() {
    super.initState();
    _geoIpBloc = context.read<GeoIpBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return IosPosterCard(
      mediaType: widget.history.mediaType,
      uri: widget.history.posterUri,
      details: HistoryIosCardDetails(history: widget.history),
      onTap: () => showCupertinoSheet(
        context: context,
        builder: (context) {
          return BlocProvider.value(
            value: _geoIpBloc,
            child: HistoryIosBottomSheet(
              server: widget.server,
              history: widget.history,
              viewUserEnabled: widget.viewUserEnabled,
              viewMediaEnabled: widget.viewMediaEnabled,
            ),
          );
        },
      ),
    );
  }
}
