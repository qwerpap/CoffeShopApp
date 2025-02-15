part of 'selected_products_list_bloc.dart';

class SelectedProductsListState {
  final List<CardModel> cards;
  final num counter;

  SelectedProductsListState(this.cards, this.counter);

  SelectedProductsListState copyWith({List<CardModel>? cards, num? counter}) {
    return SelectedProductsListState(
      cards ?? this.cards,
      counter ?? this.counter,
    );
  }

  @override
  String toString() {
    return 'SelectedProductsListState{cards: $cards, counter: $counter}';
  }
}