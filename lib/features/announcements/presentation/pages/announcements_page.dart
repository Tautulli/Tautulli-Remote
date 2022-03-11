import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/pages/status_page.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../translations/locale_keys.g.dart';
import '../bloc/announcements_bloc.dart';
import '../widgets/announcement_card.dart';

class AnnouncementsView extends StatelessWidget {
  const AnnouncementsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AnnouncementsPage();
  }
}

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({Key? key}) : super(key: key);

  static const routeName = '/announcements';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(LocaleKeys.announcements_title).tr(),
      ),
      body: BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
        builder: (context, state) {
          if (state is AnnouncementsSuccess) {
            return WillPopScope(
              onWillPop: () {
                if (state.unread) {
                  context
                      .read<AnnouncementsBloc>()
                      .add(AnnouncementsMarkRead());
                }
                return Future.value(true);
              },
              child: PageBody(
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: state.announcementList.length,
                  separatorBuilder: (context, index) => const Gap(8),
                  itemBuilder: (context, index) {
                    final announcement = state.announcementList[index];
                    return Card(
                      child: AnnouncementCard(
                        announcement: announcement,
                        lastReadAnnouncementId: state.lastReadAnnouncementId,
                      ),
                    );
                  },
                ),
              ),
            );
          }
          if (state is AnnouncementsFailure) {
            return StatusPage(message: state.message);
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
