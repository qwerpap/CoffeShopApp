class CardModel{
  const CardModel({
    required this.id,
    required this.ico,
    required this.name,
    required this.description,
    required this.price,
    required this.priceType,
  });

  final int id;
  final String ico;
  final String name;
  final String description;
  final num price;
  final String priceType;
}