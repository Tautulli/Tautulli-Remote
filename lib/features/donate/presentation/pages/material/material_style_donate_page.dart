import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../core/device_info/device_info.dart';
import '../../../../../core/pages/material/material_style_status_page.dart';
import '../../../../../core/widgets/material/material_style_list_tile.dart';
import '../../../../../core/widgets/material/material_style_list_tile_group.dart';
import '../../../../../core/widgets/material/material_style_page_body.dart';
import '../../../../../core/widgets/material/material_style_scaffold_with_inner_drawer.dart';
import '../../../../../dependency_injection.dart' as di;
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/material/material_style_donate_heading_card.dart';

class MaterialStyleDonatePage extends StatelessWidget {
  final bool showDrawer;

  const MaterialStyleDonatePage({
    super.key,
    this.showDrawer = true,
  });

  static const routeName = '/donate';

  @override
  Widget build(BuildContext context) {
    if (showDrawer) {
      return MaterialStyleScaffoldWithInnerDrawer(
        title: const Text(LocaleKeys.donate_title).tr(),
        body: const MaterialStyleDonateView(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text(LocaleKeys.donate_title).tr(),
        ),
        body: const MaterialStylePageBody(
          child: MaterialStyleDonateView(),
        ),
      );
    }
  }
}

class MaterialStyleDonateView extends StatefulWidget {
  const MaterialStyleDonateView({super.key});

  @override
  State<MaterialStyleDonateView> createState() => _MaterialStyleDonateViewState();
}

class _MaterialStyleDonateViewState extends State<MaterialStyleDonateView> {
  CustomerInfo? _customerInfo;
  Offerings? _offerings;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await Purchases.setLogLevel(LogLevel.error);
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
        _customerInfo = (await Purchases.purchase(
          PurchaseParams.package(
            package,
            productChangeInfo: StoreProductChangeInfo(activeSku),
          ),
        )).customerInfo;
        setState(() {
          _customerInfo!.activeSubscriptions.remove(activeSku);
        });
      } else {
        _customerInfo = (await Purchases.purchase(PurchaseParams.package(package))).customerInfo;
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
            content: Text(
              LocaleKeys.error_snackbar_message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onError,
              ),
            ).tr(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const MaterialStyleDonateHeadingCard(),
          const Gap(8),
          Expanded(
            child: _offerings == null
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  )
                : _offerings!.all.isNotEmpty
                ? ListView(
                    children: [
                      MaterialStyleListTileGroup(
                        heading: LocaleKeys.donate_onetime_title.tr(),
                        listTiles: [
                          MaterialStyleListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.iceCream,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            title: LocaleKeys.donate_cone_title.tr(),
                            subtitle: _offerings!
                                .getOffering('default')!
                                .getPackage('ice_cream')!
                                .storeProduct
                                .priceString,
                            onTap: () => _buyProduct(
                              _offerings!.getOffering('default')!.getPackage('ice_cream')!,
                            ),
                          ),
                          MaterialStyleListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.pizzaSlice,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            title: LocaleKeys.donate_slice_title.tr(),
                            subtitle: _offerings!.getOffering('default')!.getPackage('pizza')!.storeProduct.priceString,
                            onTap: () => _buyProduct(
                              _offerings!.getOffering('default')!.getPackage('pizza')!,
                            ),
                          ),
                          MaterialStyleListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.burger,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            title: LocaleKeys.donate_burger_title.tr(),
                            subtitle: _offerings!
                                .getOffering('default')!
                                .getPackage('hamburger')!
                                .storeProduct
                                .priceString,
                            onTap: () => _buyProduct(
                              _offerings!.getOffering('default')!.getPackage('hamburger')!,
                            ),
                          ),
                          MaterialStyleListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.utensils,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            title: LocaleKeys.donate_meal_title.tr(),
                            subtitle: _offerings!.getOffering('default')!.getPackage('meal')!.storeProduct.priceString,
                            onTap: () => _buyProduct(
                              _offerings!.getOffering('default')!.getPackage('meal')!,
                            ),
                          ),
                        ],
                      ),
                      const Gap(8),
                      MaterialStyleListTileGroup(
                        heading: LocaleKeys.donate_recurring_title.tr(),
                        listTiles: [
                          MaterialStyleListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.circleDollarToSlot,
                              color: _customerInfo!.activeSubscriptions.contains('subscription_tier_1')
                                  ? Colors.green[700]
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                            title: LocaleKeys.donate_tip_jar_title.tr(),
                            // subtitle: '0.99 USD/${LocaleKeys.month.tr()}',
                            subtitle:
                                '${_offerings!.getOffering('default')!.getPackage('subscription_tier_1')!.storeProduct.priceString}/${LocaleKeys.month.tr()}',
                            onTap: () => _buyProduct(
                              _offerings!.getOffering('default')!.getPackage('subscription_tier_1')!,
                            ),
                          ),
                          MaterialStyleListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.circleDollarToSlot,
                              color: _customerInfo!.activeSubscriptions.contains('subscription_tier_2')
                                  ? Colors.green[700]
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                            title: LocaleKeys.donate_big_tip_title.tr(),
                            subtitle:
                                '${_offerings!.getOffering('default')!.getPackage('subscription_tier_2')!.storeProduct.priceString}/${LocaleKeys.month.tr()}',
                            onTap: () => _buyProduct(
                              _offerings!.getOffering('default')!.getPackage('subscription_tier_2')!,
                            ),
                          ),
                          MaterialStyleListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.circleDollarToSlot,
                              color: _customerInfo!.activeSubscriptions.contains('subscription_tier_3')
                                  ? Colors.green[700]
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                            title: LocaleKeys.donate_supporter_title.tr(),
                            subtitle:
                                '${_offerings!.getOffering('default')!.getPackage('subscription_tier_3')!.storeProduct.priceString}/${LocaleKeys.month.tr()}',
                            onTap: () => _buyProduct(
                              _offerings!.getOffering('default')!.getPackage('subscription_tier_3')!,
                            ),
                          ),
                          MaterialStyleListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.circleDollarToSlot,
                              color: _customerInfo!.activeSubscriptions.contains('subscription_tier_4')
                                  ? Colors.green[700]
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                            title: LocaleKeys.donate_patron_title.tr(),
                            subtitle:
                                '${_offerings!.getOffering('default')!.getPackage('subscription_tier_4')!.storeProduct.priceString}/${LocaleKeys.month.tr()}',
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
                            style: TextButton.styleFrom(
                              foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            child: const Text(LocaleKeys.donate_restore_title).tr(),
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
                                    content: Text(
                                      LocaleKeys.error_snackbar_message,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.onError,
                                      ),
                                    ).tr(),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const Gap(8),
                      if (di.sl<DeviceInfo>().platform == 'ios')
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
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ).tr(),
                          ),
                        ),
                      if (di.sl<DeviceInfo>().platform == 'ios') const Gap(4),
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
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ).tr(),
                        ),
                      ),
                    ],
                  )
                : MaterialStyleStatusPage(
                    message: LocaleKeys.donate_load_failed_message.tr(),
                  ),
          ),
        ],
      ),
    );
  }
}
