import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'screens/auth/loginScreen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings){
  switch (routeSettings.name){
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (_) => LoginScreen());

    default:
      return MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text("Page is not Exist"))));

  }


}