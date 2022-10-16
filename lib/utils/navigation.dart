import 'package:flutter/cupertino.dart';

class Navigate{

  Future navigateTo(BuildContext context, screen, {bool? withRoot}){
    return Future.microtask(() => Navigator.of(context,rootNavigator: withRoot ?? true).push(
        CupertinoPageRoute(
            builder: (BuildContext context) => screen)));
  }
  Future navigateAndReplace(BuildContext context, screen, {bool? withRoot}){
    return Future.microtask(() => Navigator.of(context,rootNavigator: withRoot ?? true).pushReplacement(
        CupertinoPageRoute(
            builder: (BuildContext context) => screen)));
  }
  navigateAndRemoveUntil(BuildContext context, screen){
    Future.microtask(() => Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(
            builder: (BuildContext context) => screen),(route)=> false));
  }

}