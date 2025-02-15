part of 'categories_list_bloc.dart';

class CategoriesListState  {}

class CategoriesListInitial extends CategoriesListState {}

class CategoriesListLoading extends CategoriesListState {}

class CategoriesListLoaded extends CategoriesListState {
  CategoriesListLoaded({
    required this.tagsList,
  });

  final List<TagModel> tagsList;
}

class CategoriesListLoadingFailure extends CategoriesListState {
  CategoriesListLoadingFailure({
    this.exception,
  });

  final Object? exception;
}