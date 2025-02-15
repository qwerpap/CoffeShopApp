import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/src/features/menu/data/strings_data.dart';
import 'package:flutter_course/src/features/menu/data/text_styles.dart';
import 'package:flutter_course/src/features/menu/models/card_model.dart';
import 'package:flutter_course/src/repositories/menu_categories/abstract_categories.dart';
import 'dart:async';

import 'package:flutter_course/src/theme/app_colors.dart';

part 'selected_products_list_event.dart';
part 'selected_products_list_state.dart';


class SelectedProductsListBloc extends Bloc<SelectedProductsListEvent, SelectedProductsListState> {
  SelectedProductsListBloc(this.categoriesRepository) : super(SelectedProductsListState([], 0)) {
    on<PostCategoriesList>(_post);
    on<AddToCategoriesList>(_add);
    on<ClearCategoriesList>(_clear);
    on<RemoveFromCategoriesList>(_remove);
  }

  void _add(AddToCategoriesList event, Emitter<SelectedProductsListState> emit) {
    final newState = state.copyWith(
      cards: List.of(state.cards)..add(event.card),
      counter: state.counter + event.card.price,
    );
    emit(newState);
    debugPrint(newState.toString());
  }

  void _clear(ClearCategoriesList event, Emitter<SelectedProductsListState> emit) {
    emit(SelectedProductsListState([], 0));
  }

  void _remove(RemoveFromCategoriesList event, Emitter<SelectedProductsListState> emit) {
    final newState = state.copyWith(
      cards: List.of(state.cards)..remove(event.card),
      counter: state.counter - event.card.price,
    );
    emit(newState);
    debugPrint(newState.toString());
  }

  final AbstractMenuCategoriesAPI categoriesRepository;

  Future<void> _post(PostCategoriesList event, Emitter<SelectedProductsListState> emit) async {
    final postResult = await categoriesRepository.postProductsList(state.cards);
    if(postResult)
      ScaffoldMessenger.of(event.context).showSnackBar(
        const SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.snackBarColor,
            content: Text(
              AppStrings.snackBarSucsessful,
              style: AppTextStyles.snackBarText,
            )
        ),
      );
    else
      ScaffoldMessenger.of(event.context).showSnackBar(
        const SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.snackBarColor,
            content: Text(
              AppStrings.snackBarError,
              style: AppTextStyles.snackBarText,
            )
        ),
      );
    Navigator.pop(event.context);
  }
}

