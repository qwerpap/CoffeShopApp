import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/src/features/menu/models/card_model.dart';
import 'package:flutter_course/src/repositories/menu_categories/abstract_categories.dart';
import 'dart:async';

part 'products_list_event.dart';
part 'products_list_state.dart';

class ProductsListBloc extends Bloc<ProductsListEvent, ProductsListState> {
  ProductsListBloc(this.categoriesRepository) : super(ProductsListInitial()) {
    on<LoadProductsList>(_load);
  }

  final AbstractMenuCategoriesAPI categoriesRepository;

  Future<void> _load(
      LoadProductsList event,
      Emitter<ProductsListState> emit,
      ) async {
    try {
      if (state is! ProductsListLoaded) {
        emit(ProductsListLoading());
      }
      final productsList = await categoriesRepository.getProductsByCategoryList(event.categoryID);
      emit(ProductsListLoaded(productsList: productsList));
    } catch (e) {
      emit(ProductsListLoadingFailure(exception: e));
    } finally {
      event.completer?.complete();
    }
  }
}