import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../../../core/helpers/theme_helper.dart';
import '../../../../../core/pages/ios/status_ios_page.dart';
import '../../../../../core/widgets/ios/custom_cupertino_list_section.dart';
import '../../../../../core/widgets/ios/custom_cupertino_navigation_bar_back_button.dart';
import '../../../../../core/widgets/ios/custom_notched_cupertino_list_tile.dart';
import '../../../../../core/widgets/ios/page_scaffold_cupertino.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../widgets/ios/donate_heading_ios_card.dart';

class DonateIosPage extends StatelessWidget {
  final String? previousPageTitle;

  const DonateIosPage({
    super.key,
    this.previousPageTitle,
  });

  static const routeName = '/donate';

  @override
  Widget build(BuildContext context) {
    return DonateIosView(
      previousPageTitle: previousPageTitle,
    );
  }
}

class DonateIosView extends StatefulWidget {
  final String? previousPageTitle;

  const DonateIosView({
    super.key,
    this.previousPageTitle,
  });

  @override
  State<DonateIosView> createState() => _DonateIosViewState();
}

class _DonateIosViewState extends State<DonateIosView> {
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
        _customerInfo = await Purchases.purchasePackage(
          package,
          googleProductChangeInfo: GoogleProductChangeInfo(activeSku),
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

      Fluttertoast.showToast(
        backgroundColor: CupertinoColors.systemPink,
        textColor: CupertinoColors.black,
        toastLength: Toast.LENGTH_LONG,
        msg: LocaleKeys.donate_thanks_snackbar_message.tr(),
      );
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        // User cancelled
      } else {
        Fluttertoast.showToast(
          backgroundColor: CupertinoColors.destructiveRed,
          textColor: CupertinoColors.black,
          toastLength: Toast.LENGTH_LONG,
          msg: LocaleKeys.error_snackbar_message.tr(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffoldCupertino(
      leading: CustomCupertinoNavigationBarBackButton(
        previousPageTitle: widget.previousPageTitle,
      ),
      middle: const Text(LocaleKeys.donate_title).tr(),
      child: Column(
        children: [
          const DonateHeadingIosCard(),
          Expanded(
            child: Builder(
              builder: (context) {
                if (_offerings == null) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else if (_offerings!.all.isNotEmpty) {
                  return ListView(
                    children: [
                      CustomCupertinoListSection(
                        headerText: LocaleKeys.donate_onetime_title.tr(),
                        children: [
                          CustomNotchedCupertinoListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.iceCream,
                              color: ThemeHelper.cupertinoListTileIconColor(),
                              size: 23,
                            ),
                            trailing: const CupertinoListTileChevron(),
                            title: Text(LocaleKeys.donate_cone_title.tr()),
                            subtitle: Text(_offerings!.getOffering('default')!.getPackage('ice_cream')!.storeProduct.priceString),
                            onTap: () => _buyProduct(
                              _offerings!.getOffering('default')!.getPackage('ice_cream')!,
                            ),
                          ),
                          CustomNotchedCupertinoListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.pizzaSlice,
                              color: ThemeHelper.cupertinoListTileIconColor(),
                              size: 23,
                            ),
                            trailing: const CupertinoListTileChevron(),
                            title: Text(LocaleKeys.donate_slice_title.tr()),
                            subtitle: Text(_offerings!.getOffering('default')!.getPackage('pizza')!.storeProduct.priceString),
                            onTap: () => _buyProduct(
                              _offerings!.getOffering('default')!.getPackage('pizza')!,
                            ),
                          ),
                          CustomNotchedCupertinoListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.burger,
                              color: ThemeHelper.cupertinoListTileIconColor(),
                              size: 23,
                            ),
                            trailing: const CupertinoListTileChevron(),
                            title: Text(LocaleKeys.donate_burger_title.tr()),
                            subtitle: Text(_offerings!.getOffering('default')!.getPackage('hamburger')!.storeProduct.priceString),
                            onTap: () => _buyProduct(
                              _offerings!.getOffering('default')!.getPackage('hamburger')!,
                            ),
                          ),
                          CustomNotchedCupertinoListTile(
                            leading: Icon(
                              Icons.fastfood_rounded,
                              color: ThemeHelper.cupertinoListTileIconColor(),
                            ),
                            trailing: const CupertinoListTileChevron(),
                            title: Text(LocaleKeys.donate_meal_title.tr()),
                            subtitle: Text(_offerings!.getOffering('default')!.getPackage('meal')!.storeProduct.priceString),
                            onTap: () => _buyProduct(
                              _offerings!.getOffering('default')!.getPackage('meal')!,
                            ),
                          ),
                        ],
                      ),
                      CustomCupertinoListSection(
                        headerText: LocaleKeys.donate_recurring_title.tr(),
                        children: [
                          CustomNotchedCupertinoListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.circleDollarToSlot,
                              color: _customerInfo!.activeSubscriptions.contains('subscription_tier_1')
                                  ? CupertinoColors.activeGreen
                                  : ThemeHelper.cupertinoListTileIconColor(),
                              size: 23,
                            ),
                            trailing: const CupertinoListTileChevron(),
                            title: Text(LocaleKeys.donate_tip_jar_title.tr()),
                            subtitle: Text(
                              '${_offerings!.getOffering('default')!.getPackage('subscription_tier_1')!.storeProduct.priceString}/${LocaleKeys.month.tr()}',
                            ),
                            onTap: () => _buyProduct(
                              _offerings!.getOffering('default')!.getPackage('subscription_tier_1')!,
                            ),
                          ),
                          CustomNotchedCupertinoListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.circleDollarToSlot,
                              color: _customerInfo!.activeSubscriptions.contains('subscription_tier_2')
                                  ? CupertinoColors.activeGreen
                                  : ThemeHelper.cupertinoListTileIconColor(),
                              size: 23,
                            ),
                            trailing: const CupertinoListTileChevron(),
                            title: Text(LocaleKeys.donate_big_tip_title.tr()),
                            subtitle: Text(
                              '${_offerings!.getOffering('default')!.getPackage('subscription_tier_2')!.storeProduct.priceString}/${LocaleKeys.month.tr()}',
                            ),
                            onTap: () => _buyProduct(
                              _offerings!.getOffering('default')!.getPackage('subscription_tier_2')!,
                            ),
                          ),
                          CustomNotchedCupertinoListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.circleDollarToSlot,
                              color: _customerInfo!.activeSubscriptions.contains('subscription_tier_3')
                                  ? CupertinoColors.activeGreen
                                  : ThemeHelper.cupertinoListTileIconColor(),
                              size: 23,
                            ),
                            trailing: const CupertinoListTileChevron(),
                            title: Text(LocaleKeys.donate_supporter_title.tr()),
                            subtitle: Text(
                              '${_offerings!.getOffering('default')!.getPackage('subscription_tier_3')!.storeProduct.priceString}/${LocaleKeys.month.tr()}',
                            ),
                            onTap: () => _buyProduct(
                              _offerings!.getOffering('default')!.getPackage('subscription_tier_3')!,
                            ),
                          ),
                          CustomNotchedCupertinoListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.circleDollarToSlot,
                              color: _customerInfo!.activeSubscriptions.contains('subscription_tier_4')
                                  ? CupertinoColors.activeGreen
                                  : ThemeHelper.cupertinoListTileIconColor(),
                              size: 23,
                            ),
                            trailing: const CupertinoListTileChevron(),
                            title: Text(LocaleKeys.donate_patron_title.tr()),
                            subtitle: Text(
                              '${_offerings!.getOffering('default')!.getPackage('subscription_tier_4')!.storeProduct.priceString}/${LocaleKeys.month.tr()}',
                            ),
                            onTap: () => _buyProduct(
                              _offerings!.getOffering('default')!.getPackage('subscription_tier_4')!,
                            ),
                          ),
                        ],
                      ),
                      CupertinoButton(
                        child: const Text(
                          LocaleKeys.donate_restore_title,
                          style: TextStyle(color: CupertinoColors.systemGrey2),
                        ).tr(),
                        onPressed: () async {
                          try {
                            CustomerInfo restoredInfo = await Purchases.restorePurchases();
                            setState(() {
                              _customerInfo = restoredInfo;
                            });
                            Fluttertoast.showToast(
                              toastLength: Toast.LENGTH_LONG,
                              msg: LocaleKeys.donate_restored_snackbar_message.tr(),
                            );
                          } on PlatformException catch (_) {
                            Fluttertoast.showToast(
                              backgroundColor: CupertinoColors.destructiveRed,
                              textColor: CupertinoColors.black,
                              toastLength: Toast.LENGTH_LONG,
                              msg: LocaleKeys.error_snackbar_message.tr(),
                            );
                          }
                        },
                      ),
                    ],
                  );
                }

                return StatusIosPage(
                  message: LocaleKeys.donate_load_failed_message.tr(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
