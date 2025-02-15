part of 'products_list_bloc.dart';

class ProductsListState  {}

class ProductsListInitial extends ProductsListState {}

class ProductsListLoading extends ProductsListState {}

class ProductsListLoaded extends ProductsListState {
  ProductsListLoaded({
    required this.productsList,
  });

  final List<CardModel> productsList;
}

class ProductsListLoadingFailure extends ProductsListState {
  ProductsListLoadingFailure({
    this.exception,
  });

  final Object? exception;
}