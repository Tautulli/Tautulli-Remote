import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/database/data/models/server_model.dart';
import '../../../../../core/widgets/material/material_style_poster_card.dart';
import '../../../../geo_ip/presentation/bloc/geo_ip_bloc.dart';
import '../../../data/models/history_model.dart';
import '../base/history_card_details.dart';
import '../base/history_details_title_row.dart';
import 'bottom_sheets/material_style_history_bottom_sheet.dart';

class MaterialStyleHistoryCard extends StatefulWidget {
  final ServerModel server;
  final HistoryModel history;
  final bool showUser;
  final bool viewUserEnabled;
  final bool viewMediaEnabled;

  const MaterialStyleHistoryCard({
    super.key,
    required this.server,
    required this.history,
    this.showUser = true,
    this.viewUserEnabled = true,
    this.viewMediaEnabled = true,
  });

  @override
  State<MaterialStyleHistoryCard> createState() => _MaterialStyleHistoryCardState();
}

class _MaterialStyleHistoryCardState extends State<MaterialStyleHistoryCard> {
  late GeoIpBloc _geoIpBloc;

  @override
  void initState() {
    super.initState();
    _geoIpBloc = context.read<GeoIpBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialStylePosterCard(
      mediaType: widget.history.mediaType,
      uri: widget.history.posterUri,
      details: HistoryCardDetails(
        history: widget.history,
        iconColor: Theme.of(context).colorScheme.onSurface,
        titleRow: HistoryDetailsTitleRow(
          history: widget.history,
          fontSize: 17,
        ),

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
            child: MaterialStyleHistoryBottomSheet(
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
