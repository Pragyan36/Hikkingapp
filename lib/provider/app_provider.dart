import 'package:flutter/material.dart';
import 'package:hikkingapp/constant/theme.dart';
import 'package:hikkingapp/provider/controller/dashboard_state.dart';
import 'package:hikkingapp/provider/controller/group_state.dart';
import 'package:hikkingapp/provider/controller/login_state.dart';
import 'package:hikkingapp/provider/controller/user_state.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> getProviders() {
  return [
    ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
    ),
    ChangeNotifierProvider(lazy: false, create: (context) => LoginState()),
    ChangeNotifierProvider(
        lazy: false, create: (context) => UserdetailsState()),
    ChangeNotifierProvider(lazy: false, create: (context) => DashboardState()),
    ChangeNotifierProvider(lazy: false, create: (context) => GroupState()),
  ];
}
