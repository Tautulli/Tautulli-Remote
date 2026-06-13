import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../donate/presentation/pages/material/material_style_donate_page.dart';
import '../../../data/datasources/changelog_data_source.dart';
import '../../widgets/material/material_style_changelog_item.dart';

class MaterialStyleChangelogPage extends StatelessWidget {
  const MaterialStyleChangelogPage({super.key});

  static const routeName = '/changelog';

  @override
  Widget build(BuildContext context) {
    return const MaterialStyleChangelogView();
  }
}

class MaterialStyleChangelogView extends StatefulWidget {
  const MaterialStyleChangelogView({super.key});

  @override
  State<MaterialStyleChangelogView> createState() => _MaterialStyleChangelogViewState();
}

class _MaterialStyleChangelogViewState extends State<MaterialStyleChangelogView> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(LocaleKeys.changelog_title).tr(),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const MaterialStyleDonatePage(
                    showDrawer: false,
                  ),
                ),
              );
            },
            icon: const FaIcon(
              FontAwesomeIcons.solidHeart,
              color: Colors.red,
              size: 18,
            ),
            label: const Text(LocaleKeys.donate_title).tr(),
          ),
        ],
      ),
      body: MaterialStylePageBody(
        child: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: _buildChangelogEntries(changelog['data']),
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget> _buildChangelogEntries(List<Map<String, dynamic>> data) {
  List<Widget> entries = [];

  for (int i = 0; i < data.length; i++) {
    entries.add(
      MaterialStyleChangelogItem(
        data[i],
        bottomPadding: i < data.length - 1,
      ),
    );
  }

  return entries;
}
