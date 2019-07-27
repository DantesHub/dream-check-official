import 'package:flutter/material.dart';
import 'home_page.dart';
import 'category_page.dart';
import 'package:vision_check_test/DreamTitleMakerPage.dart';
import 'package:vision_check_test/StepMakerPage.dart';
import 'step_builder.dart';
import 'package:vision_check_test/RepeatPage.dart';
import 'login/login_page.dart';
import 'login/register_page.dart';
import 'login/welcome_page.dart';
import 'settings_page.dart';
import 'components/route_generator.dart';
import 'restart_widget.dart';

//sup mr mascolo
void main() {
  runApp(
    new RestartWidget(
      child: new MaterialApp(
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    ),
  );
}
