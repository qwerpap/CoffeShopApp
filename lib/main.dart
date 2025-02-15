import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/src/app.dart';
import 'package:flutter_course/src/features/menu/bloc/selected_products/selected_products_list_bloc.dart';
import 'package:flutter_course/src/repositories/menu_categories/abstract_categories.dart';
import 'package:flutter_course/src/repositories/menu_categories/menu_categories_api.dart';
import 'package:get_it/get_it.dart';

void main() {
  GetIt.I.registerLazySingleton<AbstractMenuCategoriesAPI>(() => MenuCategoriesAPI(dio: Dio()));
  GetIt.I.registerLazySingleton<SelectedProductsListBloc>(
          () => SelectedProductsListBloc(GetIt.I<AbstractMenuCategoriesAPI>())
  );
  runZonedGuarded(() => runApp(const CoffeeShopApp()), (error, stack) {
    log(error.toString(), name: 'App Error', stackTrace: stack);
  });
}
