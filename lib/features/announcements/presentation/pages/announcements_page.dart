// @dart=2.9

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/error_message.dart';
import '../../../../translations/locale_keys.g.dart';
import '../bloc/announcements_bloc.dart';
import '../widgets/announcement_card.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({Key key}) : super(key: key);

  static const routeName = '/announcements';

  @override
  _AnnouncementsPageState createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AnnouncementsBloc>().add(AnnouncementsMarkRead());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          LocaleKeys.announcements_page_title.tr(),
        ),
      ),
      body: BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
        builder: (context, state) {
          if (state is AnnouncementsInProgress) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).accentColor,
              ),
            );
          }
          if (state is AnnouncementsFailure) {
            return Center(
              child: ErrorMessage(
                failure: state.failure,
                message: state.message,
                suggestion: state.suggestion,
              ),
            );
          }
          if (state is AnnouncementsSuccess) {
            if (state.announcementList.isNotEmpty) {
              return ListView.builder(
                itemCount: state.announcementList.length,
                itemBuilder: (context, index) {
                  final announcement = state.announcementList[index];

                  return AnnouncementCard(
                    actionUrl: announcement.actionUrl,
                    body: announcement.body,
                    date: announcement.date,
                    id: announcement.id,
                    lastReadAnnouncementId: state.lastReadAnnouncementId,
                    title: announcement.title,
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  'No announcements found.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              );
            }
          }
          return const SizedBox(height: 0, width: 0);
        },
      ),
    );
  }
}
