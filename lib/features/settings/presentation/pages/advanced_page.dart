import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/types/bloc_status.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../../translations/locale_keys.g.dart';
import '../bloc/clear_tautulli_image_cache_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../widgets/groups/advanced_group.dart';
import '../widgets/groups/operations_group.dart';

class AdvancedPage extends StatelessWidget {
  const AdvancedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ClearTautulliImageCacheBloc>(),
      child: const AdvancedView(),
    );
  }
}

class AdvancedView extends StatelessWidget {
  const AdvancedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(LocaleKeys.advanced_title).tr(),
      ),
      body: BlocListener<ClearTautulliImageCacheBloc,
          ClearTautulliImageCacheState>(
        listener: (context, state) {
          if (state.server != null) {
            if (state.status == BlocStatus.success) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    LocaleKeys
                        .clear_tautulli_image_cache_success_snackbar_message,
                  ).tr(args: [state.server!.plexName]),
                ),
              );

              context.read<SettingsBloc>().add(SettingsClearCache());
            }

            if (state.status == BlocStatus.failure) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  content: const Text(
                    LocaleKeys
                        .clear_tautulli_image_cache_failure_snackbar_message,
                  ).tr(args: [state.server!.plexName]),
                ),
              );
            }
          }
        },
        child: PageBody(
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: const [
              AdvancedGroup(),
              Gap(8),
              OperationsGroup(),
            ],
          ),
        ),
      ),
    );
  }
}
