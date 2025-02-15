import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/src/features/menu/models/tag_model.dart';
import 'package:flutter_course/src/repositories/menu_categories/abstract_categories.dart';
import 'dart:async';

part 'categories_list_event.dart';
part 'categories_list_state.dart';

class CategoriesListBloc extends Bloc<CategoriesListEvent, CategoriesListState> {
  CategoriesListBloc(this.categoriesRepository) : super(CategoriesListInitial()) {
    on<LoadCategoriesList>(_load);
  }

  final AbstractMenuCategoriesAPI categoriesRepository;

  Future<void> _load(
      LoadCategoriesList event,
      Emitter<CategoriesListState> emit,
      ) async {
    try {
      if (state is! CategoriesListLoaded) {
        emit(CategoriesListLoading());
      }
      final tagsList = await categoriesRepository.getCategoriesTagsList();
      emit(CategoriesListLoaded(tagsList: tagsList));
    } catch (e) {
      emit(CategoriesListLoadingFailure(exception: e));
    } finally {
      event.completer?.complete();
    }
  }
}