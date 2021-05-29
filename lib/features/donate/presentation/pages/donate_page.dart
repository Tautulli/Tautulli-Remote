import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../../core/helpers/color_palette_helper.dart';
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
        title: const Text('Donate'),
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
              const Text('Thank you for your donation!'),
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
            content: const Text('Something went wrong.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            children: const [
              Text(
                'Tautulli Remote is free and open source.',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'However, any contributions you can make towards the app are appreciated!',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
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
                        const DonateHeader(text: 'One-Time Donations'),
                        Card(
                          child: ListTile(
                            title: const Text('Buy Me A Cone'),
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
                            title: const Text('Buy Me A Slice'),
                            subtitle: const Text('\$3.49'),
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
                            title: const Text('Buy Me A Burger'),
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
                            title: const Text('Buy Me A Meal'),
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
                        const DonateHeader(text: 'Recurring Donations'),
                        Card(
                          child: ListTile(
                            title: const Text('Tip Jar'),
                            subtitle: const Text('\$0.99/month'),
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
                            title: const Text('Big Tip'),
                            subtitle: const Text('\$1.99/month'),
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
                            title: const Text('Supporter'),
                            subtitle: const Text('\$4.99/month'),
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
                            title: const Text('Patron'),
                            subtitle: const Text('\$9.99/month'),
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
    );
  }
}
