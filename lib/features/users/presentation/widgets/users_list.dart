import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/pages/status_page.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/themed_refresh_indicator.dart';
import '../../data/models/user_model.dart';
import '../bloc/users_bloc.dart';
import 'user_card.dart';

class UsersList extends StatelessWidget {
  final bool loading;
  final bool displayMessage;
  final List<UserModel> users;
  final String tautulliId;
  final String orderColumn;
  final String orderDir;

  const UsersList({
    Key? key,
    required this.loading,
    this.displayMessage = true,
    required this.users,
    required this.tautulliId,
    required this.orderColumn,
    required this.orderDir,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageBody(
      loading: loading,
      child: ThemedRefreshIndicator(
        onRefresh: () {
          context.read<UsersBloc>().add(
                UsersFetch(
                  tautulliId: tautulliId,
                  orderColumn: orderColumn,
                  orderDir: orderDir,
                ),
              );

          return Future.value(null);
        },
        child: users.isEmpty && displayMessage
            ? const StatusPage(
                scrollable: true,
                message: 'No users found.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: users.length,
                separatorBuilder: (context, index) => const Gap(8),
                itemBuilder: (context, index) => UserCard(
                  key: ValueKey(users[index].userId!),
                  user: users[index],
                ),
              ),
      ),
    );
  }
}
