import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../core/helpers/color_palette_helper.dart';

final List<String> productIds = ['ice_cream', 'pizza', 'hamburger', 'meal'];

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
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  List<ProductDetails> _products = [];
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    final _isAvailable = await _connection.isAvailable();

    if (_isAvailable) {
      await _getProducts();
    }

    _subscription =
        _connection.purchaseUpdatedStream.listen((purchaseDetailsList) {
      purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) {
        if (purchaseDetails.status == PurchaseStatus.purchased) {
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
        }
      });
    });
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from(productIds);
    ProductDetailsResponse response =
        await _connection.queryProductDetails(ids);

    setState(() {
      _products = response.productDetails;
    });
  }

  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _connection.buyConsumable(purchaseParam: purchaseParam);
  }

  @override
  Widget build(BuildContext context) {
    final bool _hasProducts = _products.length > 0;

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
            children: [
              const Text(
                'Tautulli Remote is free and open source.',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
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
          child: _hasProducts
              ? ListView(
                  children: [
                    Card(
                      child: ListTile(
                        title: const Text('Buy Me A Cone'),
                        subtitle: const Text('\$2.00'),
                        trailing: const FaIcon(
                          FontAwesomeIcons.iceCream,
                          color: TautulliColorPalette.not_white,
                        ),
                        onTap: () => _buyProduct(
                          _products.firstWhere((productDetails) =>
                              productDetails.id == 'ice_cream'),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text('Buy Me A Slice'),
                        subtitle: const Text('\$3.50'),
                        trailing: const FaIcon(
                          FontAwesomeIcons.pizzaSlice,
                          color: TautulliColorPalette.not_white,
                        ),
                        onTap: () => _buyProduct(
                          _products.firstWhere(
                              (productDetails) => productDetails.id == 'pizza'),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text('Buy Me A Burger'),
                        subtitle: const Text('\$5.00'),
                        trailing: const FaIcon(
                          FontAwesomeIcons.hamburger,
                          color: TautulliColorPalette.not_white,
                        ),
                        onTap: () => _buyProduct(
                          _products.firstWhere((productDetails) =>
                              productDetails.id == 'hamburger'),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text('Buy Me A Meal'),
                        subtitle: const Text('\$10.00'),
                        trailing: const Icon(
                          Icons.fastfood,
                          color: TautulliColorPalette.not_white,
                          size: 26,
                        ),
                        onTap: () => _buyProduct(
                          _products.firstWhere(
                              (productDetails) => productDetails.id == 'meal'),
                        ),
                      ),
                    ),
                  ],
                )
              : const Text(
                  'Donation items could not be loaded from the Google Play Store.',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }
}
