import 'package:flutter/material.dart';

import '../pages/splash_screen.dart'; //封面
import '../pages/group_list.dart'; //群組列表
import '../pages/group_add.dart'; //群組列表
import '../pages/tabs.dart'; //bottomnavigationbar
import '../pages/tabs/add.dart';
import '../pages/tabs/list/spend_detail.dart';
import '../pages/tabs/list/transfer_detail.dart';

//路由配置
final Map<String, Function> routes = {
  '/': (context, {arguments}) => const Home(),
  '/groupList': (context, {arguments}) => const GroupList(),
  '/groupAdd': (context, {arguments}) => const GroupAdd(),
  '/tabs': (context, {arguments}) => Tabs(arguments: arguments),
  '/add': (context, {arguments}) => BillAdd(arguments: arguments),
  '/spendDetail': (context, {arguments}) => SpendDetail(arguments: arguments),
  '/transferDetail': (context, {arguments}) =>
      TransferDetail(arguments: arguments),
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
  return null;
};
