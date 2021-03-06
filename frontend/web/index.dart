import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:frontend/index_main.dart';
// ignore: uri_has_not_been_generated
import './index.template.dart' as self;

@GenerateInjector(
  routerProvidersHash // TODO: Use routerProviders to URLs without #
)
final InjectorFactory injector = self.injector$Injector;

Future<Null> main() => indexMain(injector);
