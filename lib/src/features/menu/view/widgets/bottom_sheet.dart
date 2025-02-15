import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/src/features/menu/bloc/selected_products/selected_products_list_bloc.dart';
import 'package:flutter_course/src/features/menu/data/strings_data.dart';
import 'package:flutter_course/src/features/menu/data/text_styles.dart';
import 'package:flutter_course/src/features/menu/view/widgets/selected_product.dart';
import 'package:flutter_course/src/theme/app_colors.dart';
import 'package:get_it/get_it.dart';

class MenuBottomSheet extends StatefulWidget {
  const MenuBottomSheet({super.key});

  @override
  _MenuBottomSheetState createState() => _MenuBottomSheetState();
}

class _MenuBottomSheetState extends State<MenuBottomSheet> {

  static ButtonStyle trash_button_style  = TextButton.styleFrom(
    elevation: 0,
    alignment: Alignment.center,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    padding: EdgeInsets.zero,
  );

  static ButtonStyle button_style = ElevatedButton.styleFrom(
    elevation: 0,
    alignment: Alignment.center,
    backgroundColor: AppColors.mainColor,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    padding: EdgeInsets.zero,
  );

  final _selected_productsListBloc = GetIt.I<SelectedProductsListBloc>();

  @override
  Widget build(BuildContext context) {
  return DraggableScrollableSheet(
    initialChildSize: 1,
    builder: (_, controller) => Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
           Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      AppStrings.bottomsheetTitle,
                        style: AppTextStyles.bottomsheetTitle,
                    ),
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: TextButton(
                        onPressed: () {
                        _selected_productsListBloc.add(ClearCategoriesList());
                        Navigator.pop(context);
                        },
                        style: trash_button_style,
                        child: const Image(
                            image: AssetImage('lib/src/assets/images/trash_image.png'),
                            height: 18,
                          ),
                      ),
                    ),
                  ],
              ),
          ),
          const Divider(),
          Expanded(
            child: BlocBuilder<SelectedProductsListBloc, SelectedProductsListState>(
              bloc: _selected_productsListBloc,
              builder: (context, state){
                return state.cards.isNotEmpty ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) => SelectedProduct(data: state.cards[index]),
                    itemCount: state.cards.length,
                  ) : const SizedBox();
              },
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 56,
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  _selected_productsListBloc.add(PostCategoriesList(context: context));
                },
                style: button_style,
                child: const Text(
                  AppStrings.bottomsheetMakeAnOrder,
                  style: AppTextStyles.bottomsheetMakeAnOrder,
                ),
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
      ),
  );
  }

}