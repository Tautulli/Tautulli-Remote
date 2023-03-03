import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/data/models/server_model.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../geo_ip/presentation/bloc/geo_ip_bloc.dart';
import '../../data/models/history_model.dart';
import 'history_bottom_sheet.dart';
import 'history_card_details.dart';

class HistoryCard extends StatefulWidget {
  final ServerModel server;
  final HistoryModel history;
  final bool showUser;
  final bool viewUserEnabled;
  final bool viewMediaEnabled;

  const HistoryCard({
    super.key,
    required this.server,
    required this.history,
    this.showUser = true,
    this.viewUserEnabled = true,
    this.viewMediaEnabled = true,
  });

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  late GeoIpBloc _geoIpBloc;

  @override
  void initState() {
    super.initState();
    _geoIpBloc = context.read<GeoIpBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return PosterCard(
      mediaType: widget.history.mediaType,
      uri: widget.history.posterUri,
      details: HistoryCardDetails(
        history: widget.history,
        showUser: widget.showUser,
      ),
      onTap: () => showModalBottomSheet(
        context: context,
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        isScrollControlled: true,
        builder: (context) {
          return BlocProvider.value(
            value: _geoIpBloc,
            child: HistoryBottomSheet(
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
