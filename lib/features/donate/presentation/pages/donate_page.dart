import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/pages/status_page.dart';
import '../../../../core/widgets/custom_list_tile.dart';
import '../../../../core/widgets/list_tile_group.dart';
import '../../../../core/widgets/page_body.dart';
import '../widgets/donate_heading_card.dart';

class DonatePage extends StatelessWidget {
  const DonatePage({Key? key}) : super(key: key);

  static const routeName = '/donate';

  @override
  Widget build(BuildContext context) {
    return const DonateView();
  }
}

class DonateView extends StatefulWidget {
  const DonateView({Key? key}) : super(key: key);

  @override
  State<DonateView> createState() => _DonateViewState();
}

class _DonateViewState extends State<DonateView> {
  PurchaserInfo? _purchaserInfo;
  Offerings? _offerings;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await Purchases.setDebugLogsEnabled(false);
    // Update to app-specific api keys
    await Purchases.setup('WsDdfMkeAPioBSKeFnrlusHzuWOeAOLv');

    PurchaserInfo purchaserInfo;
    Offerings offerings;

    purchaserInfo = await Purchases.getPurchaserInfo();
    offerings = await Purchases.getOfferings();

    if (!mounted) return;

    setState(() {
      _purchaserInfo = purchaserInfo;
      _offerings = offerings;
    });
  }

  void _buyProduct(Package package) async {
    try {
      if (_purchaserInfo!.activeSubscriptions.isNotEmpty) {
        String activeSku = _purchaserInfo!.activeSubscriptions[0];
        _purchaserInfo = await Purchases.purchasePackage(
          package,
          upgradeInfo: UpgradeInfo(activeSku),
        );
        setState(() {
          _purchaserInfo!.activeSubscriptions.remove(activeSku);
        });
      } else {
        _purchaserInfo = await Purchases.purchasePackage(package);
      }
      setState(() {
        _purchaserInfo!.activeSubscriptions.add(package.identifier);
      });

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 6),
          content: Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: FaIcon(
                  FontAwesomeIcons.solidHeart,
                  color: Colors.red,
                ),
              ),
              Text('Thank you for your donation'),
            ],
          ),
        ),
      );
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        // User cancelled
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.error,
            content: const Text('Something went wrong'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donate'),
      ),
      body: PageBody(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const DonateHeadingCard(),
              Expanded(
                child: _offerings == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _offerings!.all.isNotEmpty
                        ? ListView(
                            children: [
                              ListTileGroup(
                                heading: 'One-Time Donations',
                                listTiles: [
                                  CustomListTile(
                                    leading: const FaIcon(
                                      FontAwesomeIcons.iceCream,
                                    ),
                                    title: 'Buy Me A Cone',
                                    subtitle: '\$1.99',
                                    onTap: () => _buyProduct(
                                      _offerings!
                                          .getOffering('default')!
                                          .getPackage('ice_cream')!,
                                    ),
                                  ),
                                  CustomListTile(
                                    leading: const FaIcon(
                                      FontAwesomeIcons.pizzaSlice,
                                    ),
                                    title: 'Buy Me A Slice',
                                    subtitle: '\$2.99',
                                    onTap: () => _buyProduct(
                                      _offerings!
                                          .getOffering('default')!
                                          .getPackage('pizza')!,
                                    ),
                                  ),
                                  CustomListTile(
                                    leading: const FaIcon(
                                      FontAwesomeIcons.hamburger,
                                    ),
                                    title: 'Buy Me A Burger',
                                    subtitle: '\$4.99',
                                    onTap: () => _buyProduct(
                                      _offerings!
                                          .getOffering('default')!
                                          .getPackage('hamburger')!,
                                    ),
                                  ),
                                  CustomListTile(
                                    leading: const Icon(
                                      Icons.fastfood_rounded,
                                      size: 26,
                                    ),
                                    title: 'Buy Me A Meal',
                                    subtitle: '\$9.99',
                                    onTap: () => _buyProduct(
                                      _offerings!
                                          .getOffering('default')!
                                          .getPackage('meal')!,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(8),
                              ListTileGroup(
                                heading: 'Recurring Donations',
                                listTiles: [
                                  CustomListTile(
                                    leading: FaIcon(
                                      FontAwesomeIcons.donate,
                                      color: _purchaserInfo!.activeSubscriptions
                                              .contains('subscription_tier_1')
                                          ? Colors.green
                                          : Theme.of(context).iconTheme.color,
                                    ),
                                    title: 'Tip Jar',
                                    subtitle: '\$0.99/month',
                                    onTap: () => _buyProduct(
                                      _offerings!
                                          .getOffering('default')!
                                          .getPackage('subscription_tier_1')!,
                                    ),
                                  ),
                                  CustomListTile(
                                    leading: FaIcon(
                                      FontAwesomeIcons.donate,
                                      color: _purchaserInfo!.activeSubscriptions
                                              .contains('subscription_tier_2')
                                          ? Colors.green
                                          : Theme.of(context).iconTheme.color,
                                    ),
                                    title: 'Big Tip',
                                    subtitle: '\$1.99/month',
                                    onTap: () => _buyProduct(
                                      _offerings!
                                          .getOffering('default')!
                                          .getPackage('subscription_tier_2')!,
                                    ),
                                  ),
                                  CustomListTile(
                                    leading: FaIcon(
                                      FontAwesomeIcons.donate,
                                      color: _purchaserInfo!.activeSubscriptions
                                              .contains('subscription_tier_3')
                                          ? Colors.green
                                          : Theme.of(context).iconTheme.color,
                                    ),
                                    title: 'Supporter',
                                    subtitle: '\$4.99/month',
                                    onTap: () => _buyProduct(
                                      _offerings!
                                          .getOffering('default')!
                                          .getPackage('subscription_tier_3')!,
                                    ),
                                  ),
                                  CustomListTile(
                                    leading: FaIcon(
                                      FontAwesomeIcons.donate,
                                      color: _purchaserInfo!.activeSubscriptions
                                              .contains('subscription_tier_4')
                                          ? Colors.green
                                          : Theme.of(context).iconTheme.color,
                                    ),
                                    title: 'Patron',
                                    subtitle: '\$9.99/month',
                                    onTap: () => _buyProduct(
                                      _offerings!
                                          .getOffering('default')!
                                          .getPackage('subscription_tier_4')!,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    child: Text(
                                      'Manually Restore Donations',
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                    onPressed: () async {
                                      try {
                                        PurchaserInfo restoredInfo =
                                            await Purchases
                                                .restoreTransactions();
                                        setState(() {
                                          _purchaserInfo = restoredInfo;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Donations restored'),
                                          ),
                                        );
                                      } on PlatformException catch (_) {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .error,
                                            content: const Text(
                                              'Something went wrong',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              if (Platform.isIOS) const Gap(8),
                              if (Platform.isIOS)
                                Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          launch(
                                            'https://tautulli.com/tautulli_remote_ios_terms_and_conditions',
                                          );
                                        },
                                        child: Text(
                                          'Terms of Use',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .color,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                      const Gap(4),
                                      GestureDetector(
                                        onTap: () {
                                          launch(
                                            'https://tautulli.com/tautulli_remote_privacy',
                                          );
                                        },
                                        child: Text(
                                          'Privacy Policy',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .color,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          )
                        : const StatusPage(
                            message: 'Failed to load donation items.',
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
