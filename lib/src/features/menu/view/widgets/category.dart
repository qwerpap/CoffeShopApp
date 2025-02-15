import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/src/features/menu/bloc/products/products_list_bloc.dart';
import 'package:flutter_course/src/features/menu/models/tag_model.dart';
import 'package:flutter_course/src/features/menu/view/widgets/coffee_card.dart';
import 'package:flutter_course/src/features/menu/data/text_styles.dart';
import 'package:flutter_course/src/repositories/menu_categories/abstract_categories.dart';
import 'package:get_it/get_it.dart';

class Category extends StatefulWidget {
  const Category({super.key, required this.data});

  final TagModel data;
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category>{

  /*List<CardModel>? cardsList;
  void getProducts(int id) async {
    cardsList = await GetIt.I<AbstractMenuCategoriesAPI>().getProductsByCategoryList(id);
    setState(() {

    });
  }*/


  final _productsListBloc = ProductsListBloc(GetIt.I<AbstractMenuCategoriesAPI>());
  @override
  void initState() {
    super.initState();

    _productsListBloc.add(LoadProductsList(categoryID: widget.data.id));

    //getProducts(widget.data.id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              widget.data.tag,
              style: AppTextStyles.title,
            ),
        ),
        SizedBox(
          height: 200,
          child: BlocBuilder<ProductsListBloc, ProductsListState>(
            bloc: _productsListBloc,
            builder: (context, state){
              if(state is ProductsListLoaded) return
              ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => CoffeeCard(data: state.productsList[index]),
                  separatorBuilder: (context, _) => const SizedBox(width: 16),
                  itemCount: state.productsList.length,
              );
              return const SizedBox(height: 180);
            },
          ),
        ),
      ],
    );

  }
}
