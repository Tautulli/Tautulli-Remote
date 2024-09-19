import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tautulli_remote/core/widgets/notice_card.dart';
// import 'package:flutter/services.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:gap/gap.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// import '../../../../core/device_info/device_info.dart';
// import '../../../../core/pages/status_page.dart';
// import '../../../../core/widgets/custom_list_tile.dart';
// import '../../../../core/widgets/list_tile_group.dart';
import '../../../../core/widgets/page_body.dart';
import '../../../../core/widgets/scaffold_with_inner_drawer.dart';
// import '../../../../dependency_injection.dart' as di;
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
  // CustomerInfo? _customerInfo;
  // Offerings? _offerings;

  // @override
  // void initState() {
  //   super.initState();
  //   _initialize();
  // }

  // Future<void> _initialize() async {
  //   await Purchases.setLogLevel(LogLevel.error);
  //   // Update to app-specific api keys
  //   await Purchases.configure(PurchasesConfiguration('WsDdfMkeAPioBSKeFnrlusHzuWOeAOLv'));

  //   CustomerInfo customerInfo;
  //   Offerings offerings;

  //   customerInfo = await Purchases.getCustomerInfo();
  //   offerings = await Purchases.getOfferings();

  //   if (!mounted) return;

  //   setState(() {
  //     _customerInfo = customerInfo;
  //     _offerings = offerings;
  //   });
  // }

  // void _buyProduct(Package package) async {
  //   try {
  //     if (_customerInfo!.activeSubscriptions.isNotEmpty) {
  //       String activeSku = _customerInfo!.activeSubscriptions[0];
  //       _customerInfo = await Purchases.purchasePackage(
  //         package,
  //         googleProductChangeInfo: GoogleProductChangeInfo(activeSku),
  //       );
  //       setState(() {
  //         _customerInfo!.activeSubscriptions.remove(activeSku);
  //       });
  //     } else {
  //       _customerInfo = await Purchases.purchasePackage(package);
  //     }
  //     setState(() {
  //       _customerInfo!.activeSubscriptions.add(package.identifier);
  //     });

  //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         duration: const Duration(seconds: 6),
  //         content: Row(
  //           children: [
  //             const Padding(
  //               padding: EdgeInsets.only(right: 8),
  //               child: FaIcon(
  //                 FontAwesomeIcons.solidHeart,
  //                 color: Colors.red,
  //               ),
  //             ),
  //             const Text(LocaleKeys.donate_thanks_snackbar_message).tr(),
  //           ],
  //         ),
  //       ),
  //     );
  //   } on PlatformException catch (e) {
  //     var errorCode = PurchasesErrorHelper.getErrorCode(e);
  //     if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
  //       // User cancelled
  //     } else {
  //       ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           backgroundColor: Theme.of(context).colorScheme.error,
  //           content: Text(
  //             LocaleKeys.error_snackbar_message,
  //             style: TextStyle(
  //               color: Theme.of(context).colorScheme.onError,
  //             ),
  //           ).tr(),
  //         ),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          DonateHeadingCard(),
          NoticeCard(
            leading: FaIcon(
              FontAwesomeIcons.triangleExclamation,
            ),
            title: 'Donations Temporarily Disabled',
            content:
                'There is currently a compatibility issue between the donation and notification packages used by Tautulli Remote.\n\nIn order to ensure continued notification functionality, new donations have been temporarily disabled.\n\nPlease consider donating in the future when this issue is resolved.',
          ),
          // Expanded(
          //   child: _offerings == null
          //       ? Center(
          //           child: CircularProgressIndicator(
          //             color: Theme.of(context).colorScheme.onBackground,
          //           ),
          //         )
          //       : _offerings!.all.isNotEmpty
          //           ? ListView(
          //               children: [
          //                 ListTileGroup(
          //                   heading: LocaleKeys.donate_onetime_title.tr(),
          //                   listTiles: [
          //                     CustomListTile(
          //                       leading: FaIcon(
          //                         FontAwesomeIcons.iceCream,
          //                         color: Theme.of(context).colorScheme.onSurface,
          //                       ),
          //                       title: LocaleKeys.donate_cone_title.tr(),
          //                       subtitle: _offerings!.getOffering('default')!.getPackage('ice_cream')!.storeProduct.priceString,
          //                       onTap: () => _buyProduct(
          //                         _offerings!.getOffering('default')!.getPackage('ice_cream')!,
          //                       ),
          //                     ),
          //                     CustomListTile(
          //                       leading: FaIcon(
          //                         FontAwesomeIcons.pizzaSlice,
          //                         color: Theme.of(context).colorScheme.onSurface,
          //                       ),
          //                       title: LocaleKeys.donate_slice_title.tr(),
          //                       subtitle: _offerings!.getOffering('default')!.getPackage('pizza')!.storeProduct.priceString,
          //                       onTap: () => _buyProduct(
          //                         _offerings!.getOffering('default')!.getPackage('pizza')!,
          //                       ),
          //                     ),
          //                     CustomListTile(
          //                       leading: FaIcon(
          //                         FontAwesomeIcons.burger,
          //                         color: Theme.of(context).colorScheme.onSurface,
          //                       ),
          //                       title: LocaleKeys.donate_burger_title.tr(),
          //                       subtitle: _offerings!.getOffering('default')!.getPackage('hamburger')!.storeProduct.priceString,
          //                       onTap: () => _buyProduct(
          //                         _offerings!.getOffering('default')!.getPackage('hamburger')!,
          //                       ),
          //                     ),
          //                     CustomListTile(
          //                       leading: Icon(
          //                         Icons.fastfood_rounded,
          //                         color: Theme.of(context).colorScheme.onSurface,
          //                         size: 26,
          //                       ),
          //                       title: LocaleKeys.donate_meal_title.tr(),
          //                       subtitle: _offerings!.getOffering('default')!.getPackage('meal')!.storeProduct.priceString,
          //                       onTap: () => _buyProduct(
          //                         _offerings!.getOffering('default')!.getPackage('meal')!,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //                 const Gap(8),
          //                 ListTileGroup(
          //                   heading: LocaleKeys.donate_recurring_title.tr(),
          //                   listTiles: [
          //                     CustomListTile(
          //                       leading: FaIcon(
          //                         FontAwesomeIcons.circleDollarToSlot,
          //                         color: _customerInfo!.activeSubscriptions.contains('subscription_tier_1')
          //                             ? Colors.green[700]
          //                             : Theme.of(context).colorScheme.onSurface,
          //                       ),
          //                       title: LocaleKeys.donate_tip_jar_title.tr(),
          //                       // subtitle: '0.99 USD/${LocaleKeys.month.tr()}',
          //                       subtitle:
          //                           '${_offerings!.getOffering('default')!.getPackage('subscription_tier_1')!.storeProduct.priceString}/${LocaleKeys.month.tr()}',
          //                       onTap: () => _buyProduct(
          //                         _offerings!.getOffering('default')!.getPackage('subscription_tier_1')!,
          //                       ),
          //                     ),
          //                     CustomListTile(
          //                       leading: FaIcon(
          //                         FontAwesomeIcons.circleDollarToSlot,
          //                         color: _customerInfo!.activeSubscriptions.contains('subscription_tier_2')
          //                             ? Colors.green[700]
          //                             : Theme.of(context).colorScheme.onSurface,
          //                       ),
          //                       title: LocaleKeys.donate_big_tip_title.tr(),
          //                       subtitle:
          //                           '${_offerings!.getOffering('default')!.getPackage('subscription_tier_2')!.storeProduct.priceString}/${LocaleKeys.month.tr()}',
          //                       onTap: () => _buyProduct(
          //                         _offerings!.getOffering('default')!.getPackage('subscription_tier_2')!,
          //                       ),
          //                     ),
          //                     CustomListTile(
          //                       leading: FaIcon(
          //                         FontAwesomeIcons.circleDollarToSlot,
          //                         color: _customerInfo!.activeSubscriptions.contains('subscription_tier_3')
          //                             ? Colors.green[700]
          //                             : Theme.of(context).colorScheme.onSurface,
          //                       ),
          //                       title: LocaleKeys.donate_supporter_title.tr(),
          //                       subtitle:
          //                           '${_offerings!.getOffering('default')!.getPackage('subscription_tier_3')!.storeProduct.priceString}/${LocaleKeys.month.tr()}',
          //                       onTap: () => _buyProduct(
          //                         _offerings!.getOffering('default')!.getPackage('subscription_tier_3')!,
          //                       ),
          //                     ),
          //                     CustomListTile(
          //                       leading: FaIcon(
          //                         FontAwesomeIcons.circleDollarToSlot,
          //                         color: _customerInfo!.activeSubscriptions.contains('subscription_tier_4')
          //                             ? Colors.green[700]
          //                             : Theme.of(context).colorScheme.onSurface,
          //                       ),
          //                       title: LocaleKeys.donate_patron_title.tr(),
          //                       subtitle:
          //                           '${_offerings!.getOffering('default')!.getPackage('subscription_tier_4')!.storeProduct.priceString}/${LocaleKeys.month.tr()}',
          //                       onTap: () => _buyProduct(
          //                         _offerings!.getOffering('default')!.getPackage('subscription_tier_4')!,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //                 const Gap(8),
          //                 Row(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     TextButton(
          //                       style: TextButton.styleFrom(
          //                         foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
          //                       ),
          //                       child: const Text(LocaleKeys.donate_restore_title).tr(),
          //                       onPressed: () async {
          //                         try {
          //                           CustomerInfo restoredInfo = await Purchases.restorePurchases();
          //                           setState(() {
          //                             _customerInfo = restoredInfo;
          //                           });
          //                           ScaffoldMessenger.of(context).hideCurrentSnackBar();
          //                           ScaffoldMessenger.of(context).showSnackBar(
          //                             SnackBar(
          //                               content: const Text(
          //                                 LocaleKeys.donate_restored_snackbar_message,
          //                               ).tr(),
          //                             ),
          //                           );
          //                         } on PlatformException catch (_) {
          //                           ScaffoldMessenger.of(context).hideCurrentSnackBar();
          //                           ScaffoldMessenger.of(context).showSnackBar(
          //                             SnackBar(
          //                               backgroundColor: Theme.of(context).colorScheme.error,
          //                               content: Text(
          //                                 LocaleKeys.error_snackbar_message,
          //                                 style: TextStyle(
          //                                   color: Theme.of(context).colorScheme.onError,
          //                                 ),
          //                               ).tr(),
          //                             ),
          //                           );
          //                         }
          //                       },
          //                     ),
          //                   ],
          //                 ),
          //                 const Gap(8),
          //                 if (di.sl<DeviceInfo>().platform == 'ios')
          //                   Center(
          //                     child: GestureDetector(
          //                       onTap: () {
          //                         launchUrlString(
          //                           mode: LaunchMode.externalApplication,
          //                           'https://tautulli.com/tautulli_remote_ios_terms_and_conditions',
          //                         );
          //                       },
          //                       child: Text(
          //                         LocaleKeys.terms_of_use_title,
          //                         style: TextStyle(
          //                           color: Theme.of(context).colorScheme.onSurfaceVariant,
          //                         ),
          //                       ).tr(),
          //                     ),
          //                   ),
          //                 if (di.sl<DeviceInfo>().platform == 'ios') const Gap(4),
          //                 Center(
          //                   child: GestureDetector(
          //                     onTap: () {
          //                       launchUrlString(
          //                         mode: LaunchMode.externalApplication,
          //                         'https://tautulli.com/tautulli_remote_privacy',
          //                       );
          //                     },
          //                     child: Text(
          //                       LocaleKeys.privacy_policy_title,
          //                       style: TextStyle(
          //                         color: Theme.of(context).colorScheme.onSurfaceVariant,
          //                       ),
          //                     ).tr(),
          //                   ),
          //                 ),
          //               ],
          //             )
          //           : StatusPage(
          //               message: LocaleKeys.donate_load_failed_message.tr(),
          //             ),
          // ),
        ],
      ),
    );
  }
}
