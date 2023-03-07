import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/helpers/quick_actions_helper.dart';
import '../../../../core/pages/status_page.dart';
import '../../../../core/widgets/custom_list_tile.dart';
import '../../../../core/widgets/list_tile_group.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/scaffold_with_inner_drawer.dart';
import '../../../../translations/locale_keys.g.dart';
import '../widgets/donate_heading_card.dart';

class DonatePage extends StatelessWidget {
  final bool showDrawer;

  const DonatePage({
    super.key,
    this.showDrawer = true,
  });

  static const routeName = '/donate';

  @override
  Widget build(BuildContext context) {
    if (showDrawer) {
      return ScaffoldWithInnerDrawer(
        title: const Text(LocaleKeys.donate_title).tr(),
        body: const DonateView(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text(LocaleKeys.donate_title).tr(),
        ),
        body: const PageBody(
          child: DonateView(),
        ),
      );
    }
  }
}

class DonateView extends StatefulWidget {
  const DonateView({super.key});

  @override
  State<DonateView> createState() => _DonateViewState();
}

class _DonateViewState extends State<DonateView> {
  final QuickActions quickActions = const QuickActions();

  CustomerInfo? _customerInfo;
  Offerings? _offerings;

  @override
  void initState() {
    super.initState();
    initalizeQuickActions(context, quickActions);
    _initialize();
  }

  Future<void> _initialize() async {
    await Purchases.setDebugLogsEnabled(false);
    // Update to app-specific api keys
    await Purchases.configure(PurchasesConfiguration('WsDdfMkeAPioBSKeFnrlusHzuWOeAOLv'));

    CustomerInfo customerInfo;
    Offerings offerings;

    customerInfo = await Purchases.getCustomerInfo();
    offerings = await Purchases.getOfferings();

    if (!mounted) return;

    setState(() {
      _customerInfo = customerInfo;
      _offerings = offerings;
    });
  }

  void _buyProduct(Package package) async {
    try {
      if (_customerInfo!.activeSubscriptions.isNotEmpty) {
        String activeSku = _customerInfo!.activeSubscriptions[0];
        _customerInfo = await Purchases.purchasePackage(
          package,
          upgradeInfo: UpgradeInfo(activeSku),
        );
        setState(() {
          _customerInfo!.activeSubscriptions.remove(activeSku);
        });
      } else {
        _customerInfo = await Purchases.purchasePackage(package);
      }
      setState(() {
        _customerInfo!.activeSubscriptions.add(package.identifier);
      });

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 6),
          content: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: FaIcon(
                  FontAwesomeIcons.solidHeart,
                  color: Colors.red,
                ),
              ),
              const Text(LocaleKeys.donate_thanks_snackbar_message).tr(),
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
            content: const Text(LocaleKeys.error_snackbar_message).tr(),
          ),
        );
      }
    }
  }

  //TODO: Update displayed price to be based on local currency
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                            heading: LocaleKeys.donate_onetime_title.tr(),
                            listTiles: [
                              CustomListTile(
                                leading: const FaIcon(
                                  FontAwesomeIcons.iceCream,
                                ),
                                title: LocaleKeys.donate_cone_title.tr(),
                                subtitle: '1.99 USD',
                                onTap: () => _buyProduct(
                                  _offerings!.getOffering('default')!.getPackage('ice_cream')!,
                                ),
                              ),
                              CustomListTile(
                                leading: const FaIcon(
                                  FontAwesomeIcons.pizzaSlice,
                                ),
                                title: LocaleKeys.donate_slice_title.tr(),
                                subtitle: '2.99 USD',
                                onTap: () => _buyProduct(
                                  _offerings!.getOffering('default')!.getPackage('pizza')!,
                                ),
                              ),
                              CustomListTile(
                                leading: const FaIcon(
                                  FontAwesomeIcons.burger,
                                ),
                                title: LocaleKeys.donate_burger_title.tr(),
                                subtitle: '4.99 USD',
                                onTap: () => _buyProduct(
                                  _offerings!.getOffering('default')!.getPackage('hamburger')!,
                                ),
                              ),
                              CustomListTile(
                                leading: const Icon(
                                  Icons.fastfood_rounded,
                                  size: 26,
                                ),
                                title: LocaleKeys.donate_meal_title.tr(),
                                subtitle: '9.99 USD',
                                onTap: () => _buyProduct(
                                  _offerings!.getOffering('default')!.getPackage('meal')!,
                                ),
                              ),
                            ],
                          ),
                          const Gap(8),
                          ListTileGroup(
                            heading: LocaleKeys.donate_recurring_title.tr(),
                            listTiles: [
                              CustomListTile(
                                leading: FaIcon(
                                  FontAwesomeIcons.circleDollarToSlot,
                                  color: _customerInfo!.activeSubscriptions.contains('subscription_tier_1')
                                      ? Colors.green
                                      : Theme.of(context).iconTheme.color,
                                ),
                                title: LocaleKeys.donate_tip_jar_title.tr(),
                                subtitle: '0.99 USD/${LocaleKeys.month.tr()}',
                                onTap: () => _buyProduct(
                                  _offerings!.getOffering('default')!.getPackage('subscription_tier_1')!,
                                ),
                              ),
                              CustomListTile(
                                leading: FaIcon(
                                  FontAwesomeIcons.circleDollarToSlot,
                                  color: _customerInfo!.activeSubscriptions.contains('subscription_tier_2')
                                      ? Colors.green
                                      : Theme.of(context).iconTheme.color,
                                ),
                                title: LocaleKeys.donate_big_tip_title.tr(),
                                subtitle: '1.99 USD/${LocaleKeys.month.tr()}',
                                onTap: () => _buyProduct(
                                  _offerings!.getOffering('default')!.getPackage('subscription_tier_2')!,
                                ),
                              ),
                              CustomListTile(
                                leading: FaIcon(
                                  FontAwesomeIcons.circleDollarToSlot,
                                  color: _customerInfo!.activeSubscriptions.contains('subscription_tier_3')
                                      ? Colors.green
                                      : Theme.of(context).iconTheme.color,
                                ),
                                title: LocaleKeys.donate_supporter_title.tr(),
                                subtitle: '4.99 USD/${LocaleKeys.month.tr()}',
                                onTap: () => _buyProduct(
                                  _offerings!.getOffering('default')!.getPackage('subscription_tier_3')!,
                                ),
                              ),
                              CustomListTile(
                                leading: FaIcon(
                                  FontAwesomeIcons.circleDollarToSlot,
                                  color: _customerInfo!.activeSubscriptions.contains('subscription_tier_4')
                                      ? Colors.green
                                      : Theme.of(context).iconTheme.color,
                                ),
                                title: LocaleKeys.donate_patron_title.tr(),
                                subtitle: '9.99 USD/${LocaleKeys.month.tr()}',
                                onTap: () => _buyProduct(
                                  _offerings!.getOffering('default')!.getPackage('subscription_tier_4')!,
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
                                  LocaleKeys.donate_restore_title,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ).tr(),
                                onPressed: () async {
                                  try {
                                    CustomerInfo restoredInfo = await Purchases.restorePurchases();
                                    setState(() {
                                      _customerInfo = restoredInfo;
                                    });
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          LocaleKeys.donate_restored_snackbar_message,
                                        ).tr(),
                                      ),
                                    );
                                  } on PlatformException catch (_) {
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Theme.of(context).colorScheme.error,
                                        content: const Text(
                                          LocaleKeys.error_snackbar_message,
                                        ).tr(),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          const Gap(8),
                          if (Platform.isIOS)
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  launchUrlString(
                                    mode: LaunchMode.externalApplication,
                                    'https://tautulli.com/tautulli_remote_ios_terms_and_conditions',
                                  );
                                },
                                child: Text(
                                  LocaleKeys.terms_of_use_title,
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.titleSmall!.color,
                                    decoration: TextDecoration.underline,
                                  ),
                                ).tr(),
                              ),
                            ),
                          if (Platform.isIOS) const Gap(4),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                launchUrlString(
                                  mode: LaunchMode.externalApplication,
                                  'https://tautulli.com/tautulli_remote_privacy',
                                );
                              },
                              child: Text(
                                LocaleKeys.privacy_policy_title,
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.titleSmall!.color,
                                  decoration: TextDecoration.underline,
                                ),
                              ).tr(),
                            ),
                          ),
                        ],
                      )
                    : StatusPage(
                        message: LocaleKeys.donate_load_failed_message.tr(),
                      ),
          ),
        ],
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text(LocaleKeys.donate_title).tr(),
    //   ),
    //   body: PageBody(
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Column(
    //         children: [
    //           const DonateHeadingCard(),
    //           Expanded(
    //             child: _offerings == null
    //                 ? const Center(
    //                     child: CircularProgressIndicator(),
    //                   )
    //                 : _offerings!.all.isNotEmpty
    //                     ? ListView(
    //                         children: [
    //                           ListTileGroup(
    //                             heading: LocaleKeys.donate_onetime_title.tr(),
    //                             listTiles: [
    //                               CustomListTile(
    //                                 leading: const FaIcon(
    //                                   FontAwesomeIcons.iceCream,
    //                                 ),
    //                                 title: LocaleKeys.donate_cone_title.tr(),
    //                                 subtitle: '1.99 USD',
    //                                 onTap: () => _buyProduct(
    //                                   _offerings!
    //                                       .getOffering('default')!
    //                                       .getPackage('ice_cream')!,
    //                                 ),
    //                               ),
    //                               CustomListTile(
    //                                 leading: const FaIcon(
    //                                   FontAwesomeIcons.pizzaSlice,
    //                                 ),
    //                                 title: LocaleKeys.donate_slice_title.tr(),
    //                                 subtitle: '2.99 USD',
    //                                 onTap: () => _buyProduct(
    //                                   _offerings!
    //                                       .getOffering('default')!
    //                                       .getPackage('pizza')!,
    //                                 ),
    //                               ),
    //                               CustomListTile(
    //                                 leading: const FaIcon(
    //                                   FontAwesomeIcons.hamburger,
    //                                 ),
    //                                 title: LocaleKeys.donate_burger_title.tr(),
    //                                 subtitle: '4.99 USD',
    //                                 onTap: () => _buyProduct(
    //                                   _offerings!
    //                                       .getOffering('default')!
    //                                       .getPackage('hamburger')!,
    //                                 ),
    //                               ),
    //                               CustomListTile(
    //                                 leading: const Icon(
    //                                   Icons.fastfood_rounded,
    //                                   size: 26,
    //                                 ),
    //                                 title: LocaleKeys.donate_meal_title.tr(),
    //                                 subtitle: '9.99 USD',
    //                                 onTap: () => _buyProduct(
    //                                   _offerings!
    //                                       .getOffering('default')!
    //                                       .getPackage('meal')!,
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                           const Gap(8),
    //                           ListTileGroup(
    //                             heading: LocaleKeys.donate_recurring_title.tr(),
    //                             listTiles: [
    //                               CustomListTile(
    //                                 leading: FaIcon(
    //                                   FontAwesomeIcons.donate,
    //                                   color: _customerInfo!.activeSubscriptions
    //                                           .contains('subscription_tier_1')
    //                                       ? Colors.green
    //                                       : Theme.of(context).iconTheme.color,
    //                                 ),
    //                                 title: LocaleKeys.donate_tip_jar_title.tr(),
    //                                 subtitle:
    //                                     '0.99 USD/${LocaleKeys.month.tr()}',
    //                                 onTap: () => _buyProduct(
    //                                   _offerings!
    //                                       .getOffering('default')!
    //                                       .getPackage('subscription_tier_1')!,
    //                                 ),
    //                               ),
    //                               CustomListTile(
    //                                 leading: FaIcon(
    //                                   FontAwesomeIcons.donate,
    //                                   color: _customerInfo!.activeSubscriptions
    //                                           .contains('subscription_tier_2')
    //                                       ? Colors.green
    //                                       : Theme.of(context).iconTheme.color,
    //                                 ),
    //                                 title: LocaleKeys.donate_big_tip_title.tr(),
    //                                 subtitle:
    //                                     '1.99 USD/${LocaleKeys.month.tr()}',
    //                                 onTap: () => _buyProduct(
    //                                   _offerings!
    //                                       .getOffering('default')!
    //                                       .getPackage('subscription_tier_2')!,
    //                                 ),
    //                               ),
    //                               CustomListTile(
    //                                 leading: FaIcon(
    //                                   FontAwesomeIcons.donate,
    //                                   color: _customerInfo!.activeSubscriptions
    //                                           .contains('subscription_tier_3')
    //                                       ? Colors.green
    //                                       : Theme.of(context).iconTheme.color,
    //                                 ),
    //                                 title:
    //                                     LocaleKeys.donate_supporter_title.tr(),
    //                                 subtitle:
    //                                     '4.99 USD/${LocaleKeys.month.tr()}',
    //                                 onTap: () => _buyProduct(
    //                                   _offerings!
    //                                       .getOffering('default')!
    //                                       .getPackage('subscription_tier_3')!,
    //                                 ),
    //                               ),
    //                               CustomListTile(
    //                                 leading: FaIcon(
    //                                   FontAwesomeIcons.donate,
    //                                   color: _customerInfo!.activeSubscriptions
    //                                           .contains('subscription_tier_4')
    //                                       ? Colors.green
    //                                       : Theme.of(context).iconTheme.color,
    //                                 ),
    //                                 title: LocaleKeys.donate_patron_title.tr(),
    //                                 subtitle:
    //                                     '9.99 USD/${LocaleKeys.month.tr()}',
    //                                 onTap: () => _buyProduct(
    //                                   _offerings!
    //                                       .getOffering('default')!
    //                                       .getPackage('subscription_tier_4')!,
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                           const Gap(8),
    //                           Row(
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             children: [
    //                               TextButton(
    //                                 child: Text(
    //                                   LocaleKeys.donate_restore_title,
    //                                   style:
    //                                       Theme.of(context).textTheme.subtitle2,
    //                                 ).tr(),
    //                                 onPressed: () async {
    //                                   try {
    //                                     PurchaserInfo restoredInfo =
    //                                         await Purchases
    //                                             .restoreTransactions();
    //                                     setState(() {
    //                                       _customerInfo = restoredInfo;
    //                                     });
    //                                     ScaffoldMessenger.of(context)
    //                                         .hideCurrentSnackBar();
    //                                     ScaffoldMessenger.of(context)
    //                                         .showSnackBar(
    //                                       SnackBar(
    //                                         content: const Text(
    //                                           LocaleKeys
    //                                               .donate_restored_snackbar_message,
    //                                         ).tr(),
    //                                       ),
    //                                     );
    //                                   } on PlatformException catch (_) {
    //                                     ScaffoldMessenger.of(context)
    //                                         .hideCurrentSnackBar();
    //                                     ScaffoldMessenger.of(context)
    //                                         .showSnackBar(
    //                                       SnackBar(
    //                                         backgroundColor: Theme.of(context)
    //                                             .colorScheme
    //                                             .error,
    //                                         content: const Text(
    //                                           LocaleKeys.error_snackbar_message,
    //                                         ).tr(),
    //                                       ),
    //                                     );
    //                                   }
    //                                 },
    //                               ),
    //                             ],
    //                           ),
    //                           if (Platform.isIOS) const Gap(8),
    //                           if (Platform.isIOS)
    //                             Center(
    //                               child: Column(
    //                                 mainAxisSize: MainAxisSize.min,
    //                                 children: [
    //                                   GestureDetector(
    //                                     onTap: () {
    //                                       launch(
    //                                         'https://tautulli.com/tautulli_remote_ios_terms_and_conditions',
    //                                       );
    //                                     },
    //                                     child: Text(
    //                                       LocaleKeys.terms_of_use_title,
    //                                       style: TextStyle(
    //                                         color: Theme.of(context)
    //                                             .textTheme
    //                                             .subtitle2!
    //                                             .color,
    //                                         decoration:
    //                                             TextDecoration.underline,
    //                                       ),
    //                                     ).tr(),
    //                                   ),
    //                                   const Gap(4),
    //                                   GestureDetector(
    //                                     onTap: () {
    //                                       launch(
    //                                         'https://tautulli.com/tautulli_remote_privacy',
    //                                       );
    //                                     },
    //                                     child: Text(
    //                                       LocaleKeys.privacy_policy_title,
    //                                       style: TextStyle(
    //                                         color: Theme.of(context)
    //                                             .textTheme
    //                                             .subtitle2!
    //                                             .color,
    //                                         decoration:
    //                                             TextDecoration.underline,
    //                                       ),
    //                                     ).tr(),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ),
    //                         ],
    //                       )
    //                     : StatusPage(
    //                         message: LocaleKeys.donate_load_failed_message.tr(),
    //                       ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
