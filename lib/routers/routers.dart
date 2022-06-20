import 'package:flutter/material.dart';

import '../pages/splashScreen.dart'; //封面
import '../pages/groupList.dart'; //群組列表
import '../pages/groupAdd.dart'; //群組列表
import '../pages/tabs.dart'; //bottomnavigationbar

import '../pages/tabs/add.dart';
import '../pages/tabs/add/payerEdit.dart';
import '../pages/tabs/add/sharerEdit.dart';

import '../pages/tabs/debt/transferEdit.dart';

import '../pages/tabs/list/spendDetail.dart';
import '../pages/tabs/list/transferDetail.dart';
import '../pages/tabs/list/spend/delete.dart';
import '../pages/tabs/list/spend/edit.dart';
import '../pages/tabs/list/spend/sharerEdit.dart';
import '../pages/tabs/list/spend/payerEdit.dart';
import '../pages/tabs/list/transfer/Delete.dart';
import '../pages/tabs/list/transfer/Edit.dart';

//路由配置
final Map<String, Function> routes = {
  '/': (context, {arguments}) => const Home(),
  '/groupList': (context, {arguments}) => const GroupList(),
  '/groupAdd': (context, {arguments}) => const GroupAdd(),
  '/tabs': (context, {arguments}) => Tabs(groupIndex: arguments),
  '/add': (context, {arguments}) => BillAdd(groupIndex: arguments),
  '/spendDetail': (context, {arguments}) => SpendDetail(arguments:arguments),
  '/addPayerEdit': (context, {arguments}) => const AddPayerEdit(),
  '/addSharerEdit': (context, {arguments}) => const AddSharerEdit(),
  //
  // '/debtTransferEdit': (context, {arguments}) => DebtTransferEdit(arguments:arguments),
  //
  // '/listSpendDetail': (context, {arguments}) => ListSpendDetail(arguments:arguments),
  // '/listTransferDetail': (context, {arguments}) =>ListTransferDetail(arguments:arguments),
  // '/spendDelete': (context, {arguments}) => SpendDelete(arguments:arguments),
  // '/spendEdit': (context, {arguments}) => SpendEdit(arguments:arguments),
  // '/spendSharerEdit': (context, {arguments}) => SpendSharerEdit(arguments:arguments),
  // '/spendPayerEdit': (context, {arguments}) => SpendPayerEdit(arguments:arguments),
  // '/transferDelete': (context, {arguments}) => TransferDelete(arguments:arguments),
  // '/transferEdit': (context, {arguments}) => TransferEdit(arguments:arguments),
};

//路由傳參
var onGenerateRoute = (RouteSettings settings) {
  final String? name = settings.name;

  final Function? pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
