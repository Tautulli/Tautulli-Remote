import 'package:purchases_flutter/purchases_flutter.dart';

Future<({CustomerInfo customerInfo, Offerings offerings})> loadDonateData() async {
  await Purchases.setLogLevel(LogLevel.error);
  // Update to app-specific api keys
  await Purchases.configure(PurchasesConfiguration('WsDdfMkeAPioBSKeFnrlusHzuWOeAOLv'));

  return (
    customerInfo: await Purchases.getCustomerInfo(),
    offerings: await Purchases.getOfferings(),
  );
}

Future<CustomerInfo> purchaseDonatePackage(CustomerInfo currentInfo, Package package) async {
  if (currentInfo.activeSubscriptions.isNotEmpty) {
    return (await Purchases.purchase(
      PurchaseParams.package(
        package,
        productChangeInfo: StoreProductChangeInfo(currentInfo.activeSubscriptions[0]),
      ),
    )).customerInfo;
  }

  return (await Purchases.purchase(PurchaseParams.package(package))).customerInfo;
}
