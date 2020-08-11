import 'package:flutter/material.dart';

abstract class INavigationService {
  GlobalKey<NavigatorState> get navigationKey;

  pop(dynamic result);

  Future<dynamic> navigateTo(String routeName, {dynamic arguments, NavType replace: NavType.Push});
}

enum NavType { Replace, ReplaceAll, Push, PopAndPush }
