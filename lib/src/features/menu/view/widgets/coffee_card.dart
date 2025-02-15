import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/src/features/menu/bloc/selected_products/selected_products_list_bloc.dart';
import 'package:flutter_course/src/features/menu/models/card_model.dart';
import 'package:flutter_course/src/theme/app_colors.dart';
import 'package:flutter_course/src/features/menu/data/text_styles.dart';
import 'package:get_it/get_it.dart';

class CoffeeCard extends StatefulWidget {

  const CoffeeCard({super.key, required this.data});
  final CardModel data;

  @override
  _CoffeeCardState createState() => _CoffeeCardState();
}

class _CoffeeCardState extends State<CoffeeCard> {

  final _selected_productsListBloc = GetIt.I<SelectedProductsListBloc>(); //= SelectedProductsListBloc(GetIt.I<AbstractMenuCategoriesAPI>());

  int _counter = 0;

  void _incrementCounter() {
    if(_counter < 10)
      setState(() {
        _selected_productsListBloc.add(AddToCategoriesList(card: widget.data));
        _counter++;
      });
  }
  void _decrementCounter() {
    if(_counter > 0)
      setState(() {
        _selected_productsListBloc.add(RemoveFromCategoriesList(card: widget.data));
        _counter--;
      });
  }

  void _setCounterZero() {
    setState(() {
      _counter = 0;
    });
  }

  static ButtonStyle button_style = ElevatedButton.styleFrom(
      elevation: 10,
      alignment: Alignment.center,
      backgroundColor: AppColors.mainColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.zero,
  );
  static ButtonStyle unactive_button_style = ElevatedButton.styleFrom(
    elevation: 10,
    alignment: Alignment.center,
    backgroundColor: AppColors.unactiveMainColor,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    padding: EdgeInsets.zero,
  );

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectedProductsListBloc, SelectedProductsListState>(
      bloc: _selected_productsListBloc,
      listener: (context, state) {
        setState(() {
          if( (state.counter == 0) && (_counter != 0)) _setCounterZero();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical:  16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: widget.data.ico,
              height: 100,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                    child: CircularProgressIndicator(value: downloadProgress.progress),
                  ),
              errorWidget: (context, url, error) =>
              const Image(
                  image: AssetImage('lib/src/assets/images/outdate_image.png'),
                  height: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                widget.data.name,
                style: AppTextStyles.subtitle,
              ),
            ),
            SizedBox(
              height: 24,
              width: 116,
              child: _counter == 0? TextButton(
                  onPressed: _incrementCounter,
                  style: button_style,
                  child: Text(
                    '${widget.data.price} ${widget.data.priceType}',
                    style: AppTextStyles.price,
                  ),
              )
                  :
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 24,
                    child: TextButton(
                      onPressed: _decrementCounter,
                      style: button_style,
                      child: const Text(
                        '-',
                        style: AppTextStyles.priceChange,
                      ),
                    ),
                  ),
                  Container(
                      width: 52,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$_counter',
                        style: AppTextStyles.price,
                      ),
                  ),
                  SizedBox(
                    width: 24,
                    child: TextButton(
                      onPressed: _incrementCounter,
                      style: _counter == 10? unactive_button_style : button_style,
                      child: const Text(
                        '+',
                        style: AppTextStyles.priceChange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
