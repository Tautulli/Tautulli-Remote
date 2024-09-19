import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/pages/status_page.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/scaffold_with_inner_drawer.dart';
import '../../../../translations/locale_keys.g.dart';
import '../bloc/announcements_bloc.dart';
import '../widgets/announcement_card.dart';

class AnnouncementsView extends StatelessWidget {
  const AnnouncementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnnouncementsPage();
  }
}

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  static const routeName = '/announcements';

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then(
      (_) {
        final announcementsBloc = context.read<AnnouncementsBloc>();

        if (announcementsBloc.state is AnnouncementsSuccess) {
          final currentState = announcementsBloc.state as AnnouncementsSuccess;
          if (currentState.unread) {
            context.read<AnnouncementsBloc>().add(
                  AnnouncementsMarkRead(),
                );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithInnerDrawer(
      title: const Text(LocaleKeys.announcements_title).tr(),
      body: BlocBuilder<AnnouncementsBloc, AnnouncementsState>(
        builder: (context, state) {
          if (state is AnnouncementsSuccess) {
            return PageBody(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: state.filteredList.length,
                separatorBuilder: (context, index) => const Gap(8),
                itemBuilder: (context, index) {
                  final announcement = state.filteredList[index];
                  return AnnouncementCard(
                    announcement: announcement,
                    lastReadAnnouncementId: state.lastReadAnnouncementId,
                  );
                },
              ),
            );
          }
          if (state is AnnouncementsFailure) {
            return StatusPage(message: state.message);
          }

          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          );
        },
      ),
    );
  }
}
