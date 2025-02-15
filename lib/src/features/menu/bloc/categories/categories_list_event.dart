part of 'categories_list_bloc.dart';

abstract class CategoriesListEvent {}

class LoadCategoriesList extends CategoriesListEvent {
  LoadCategoriesList({
    this.completer,
  });

  // ignore: strict_raw_type
  final Completer? completer;

}