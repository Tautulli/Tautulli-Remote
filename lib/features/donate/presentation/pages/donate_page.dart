// @dart=2.9

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/color_palette_helper.dart';
import '../../../../translations/locale_keys.g.dart';
import '../widgets/donate_header.dart';

PurchaserInfo _purchaserInfo;

class DonatePage extends StatelessWidget {
  const DonatePage({Key key}) : super(key: key);

  static const routeName = '/donate';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          LocaleKeys.donate_page_title.tr(),
        ),
      ),
      body: const DonatePageContent(),
    );
  }
}

class DonatePageContent extends StatefulWidget {
  const DonatePageContent({Key key}) : super(key: key);

  @override
  _DonatePageContentState createState() => _DonatePageContentState();
}

class _DonatePageContentState extends State<DonatePageContent> {
  Offerings _offerings;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await Purchases.setDebugLogsEnabled(false);
    await Purchases.setup('WsDdfMkeAPioBSKeFnrlusHzuWOeAOLv');

    PurchaserInfo purchaserInfo;
    try {
      purchaserInfo = await Purchases.getPurchaserInfo();
    } on PlatformException catch (e) {
      print(e);
    }

    Offerings offerings;
    try {
      offerings = await Purchases.getOfferings();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _purchaserInfo = purchaserInfo;
      _offerings = offerings;
    });
  }

  void _buyProduct(Package package) async {
    try {
      if (_purchaserInfo.activeSubscriptions.isNotEmpty) {
        String activeSku = _purchaserInfo.activeSubscriptions[0];
        _purchaserInfo = await Purchases.purchasePackage(
          package,
          upgradeInfo: UpgradeInfo(activeSku),
        );
        setState(() {
          _purchaserInfo.activeSubscriptions.remove(activeSku);
        });
      } else {
        _purchaserInfo = await Purchases.purchasePackage(package);
      }
      setState(() {
        _purchaserInfo.activeSubscriptions.add(package.identifier);
      });

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: PlexColorPalette.shark,
          content: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FaIcon(
                  FontAwesomeIcons.solidHeart,
                  color: Colors.red[400],
                ),
              ),
              const Text(LocaleKeys.donate_thank_you_alert).tr(),
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
            backgroundColor: Theme.of(context).errorColor,
            content: const Text(LocaleKeys.donate_error_alert).tr(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Divider(
            indent: 50,
            endIndent: 50,
            height: 50,
            color: PlexColorPalette.gamboge,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                const Text(
                  LocaleKeys.donate_message_title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ).tr(),
                const SizedBox(height: 8),
                const Text(
                  LocaleKeys.donate_message_body,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ).tr(),
              ],
            ),
          ),
          const Divider(
            indent: 50,
            endIndent: 50,
            height: 50,
            color: PlexColorPalette.gamboge,
          ),
          Expanded(
            child: _offerings == null
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).accentColor,
                    ),
                  )
                : _offerings.all.isNotEmpty
                    ? ListView(
                        children: [
                          DonateHeader(
                            text: LocaleKeys.donate_one_time_heading.tr(),
                          ),
                          Card(
                            child: ListTile(
                              title: const Text(LocaleKeys.donate_cone).tr(),
                              subtitle: const Text('\$1.99'),
                              trailing: const FaIcon(
                                FontAwesomeIcons.iceCream,
                                color: TautulliColorPalette.not_white,
                              ),
                              onTap: () => _buyProduct(
                                _offerings
                                    .getOffering('default')
                                    .getPackage('ice_cream'),
                              ),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              title: const Text(LocaleKeys.donate_slice).tr(),
                              subtitle: const Text('\$2.99'),
                              trailing: const FaIcon(
                                FontAwesomeIcons.pizzaSlice,
                                color: TautulliColorPalette.not_white,
                              ),
                              onTap: () => _buyProduct(
                                _offerings
                                    .getOffering('default')
                                    .getPackage('pizza'),
                              ),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              title: const Text(LocaleKeys.donate_burger).tr(),
                              subtitle: const Text('\$4.99'),
                              trailing: const FaIcon(
                                FontAwesomeIcons.hamburger,
                                color: TautulliColorPalette.not_white,
                              ),
                              onTap: () => _buyProduct(
                                _offerings
                                    .getOffering('default')
                                    .getPackage('hamburger'),
                              ),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              title: const Text(LocaleKeys.donate_meal).tr(),
                              subtitle: const Text('\$9.99'),
                              trailing: const Icon(
                                Icons.fastfood,
                                color: TautulliColorPalette.not_white,
                                size: 26,
                              ),
                              onTap: () => _buyProduct(
                                _offerings
                                    .getOffering('default')
                                    .getPackage('meal'),
                              ),
                            ),
                          ),
                          const Divider(
                            indent: 50,
                            endIndent: 50,
                            height: 50,
                            color: PlexColorPalette.gamboge,
                          ),
                          DonateHeader(
                            text: LocaleKeys.donate_recurring_heading.tr(),
                          ),
                          Card(
                            child: ListTile(
                              title: const Text(LocaleKeys.donate_tip_jar).tr(),
                              subtitle: Text(
                                '\$0.99/${LocaleKeys.donate_month.tr()}',
                              ),
                              trailing: FaIcon(
                                FontAwesomeIcons.donate,
                                color: _purchaserInfo.activeSubscriptions
                                        .contains('subscription_tier_1')
                                    ? PlexColorPalette.atlantis
                                    : TautulliColorPalette.not_white,
                                size: 26,
                              ),
                              onTap: () => _buyProduct(
                                _offerings
                                    .getOffering('default')
                                    .getPackage('subscription_tier_1'),
                              ),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              title: const Text(LocaleKeys.donate_big_tip).tr(),
                              subtitle: Text(
                                '\$1.99/${LocaleKeys.donate_month.tr()}',
                              ),
                              trailing: FaIcon(
                                FontAwesomeIcons.donate,
                                color: _purchaserInfo.activeSubscriptions
                                        .contains('subscription_tier_2')
                                    ? PlexColorPalette.atlantis
                                    : TautulliColorPalette.not_white,
                                size: 26,
                              ),
                              onTap: () => _buyProduct(
                                _offerings
                                    .getOffering('default')
                                    .getPackage('subscription_tier_2'),
                              ),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              title:
                                  const Text(LocaleKeys.donate_supporter).tr(),
                              subtitle: Text(
                                '\$4.99/${LocaleKeys.donate_month.tr()}',
                              ),
                              trailing: FaIcon(
                                FontAwesomeIcons.donate,
                                color: _purchaserInfo.activeSubscriptions
                                        .contains('subscription_tier_3')
                                    ? PlexColorPalette.atlantis
                                    : TautulliColorPalette.not_white,
                                size: 26,
                              ),
                              onTap: () => _buyProduct(
                                _offerings
                                    .getOffering('default')
                                    .getPackage('subscription_tier_3'),
                              ),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              title: const Text(LocaleKeys.donate_patron).tr(),
                              subtitle: Text(
                                '\$9.99/${LocaleKeys.donate_month.tr()}',
                              ),
                              trailing: FaIcon(
                                FontAwesomeIcons.donate,
                                color: _purchaserInfo.activeSubscriptions
                                        .contains('subscription_tier_4')
                                    ? PlexColorPalette.atlantis
                                    : TautulliColorPalette.not_white,
                                size: 26,
                              ),
                              onTap: () => _buyProduct(
                                _offerings
                                    .getOffering('default')
                                    .getPackage('subscription_tier_4'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      PurchaserInfo restoredInfo =
                                          await Purchases.restoreTransactions();
                                      setState(() {
                                        _purchaserInfo = restoredInfo;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          backgroundColor:
                                              PlexColorPalette.shark,
                                          content: Text('Donations restored.'),
                                        ),
                                      );
                                    } on PlatformException catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor:
                                              Theme.of(context).errorColor,
                                          content: const Text(
                                                  LocaleKeys.donate_error_alert)
                                              .tr(),
                                        ),
                                      );
                                    }
                                  },
                                  child:
                                      const Text('Manually Restore Donations'),
                                ),
                              ],
                            ),
                          ),
                          if (Platform.isIOS)
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8,
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        launch(
                                          'https://tautulli.com/tautulli_remote_ios_terms_and_conditions',
                                        );
                                      },
                                      child: const Text(
                                        'Terms of Use',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    GestureDetector(
                                      onTap: () {
                                        launch(
                                          'https://tautulli.com/tautulli_remote_privacy',
                                        );
                                      },
                                      child: const Text(
                                        'Privacy Policy',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      )
                    : const Text(
                        'Failed to load donation items.',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
          ),
        ],
      ),
    );
  }
}
