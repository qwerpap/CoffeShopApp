part of 'products_list_bloc.dart';

abstract class ProductsListEvent {}

class LoadProductsList extends ProductsListEvent {
  LoadProductsList({
    required this.categoryID,
    this.completer,
  });
  final int categoryID;
  // ignore: strict_raw_type
  final Completer? completer;

}