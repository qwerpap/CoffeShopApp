import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/src/features/menu/bloc/categories/categories_list_bloc.dart';
import 'package:flutter_course/src/features/menu/bloc/selected_products/selected_products_list_bloc.dart';
import 'package:flutter_course/src/features/menu/data/text_styles.dart';
import 'package:flutter_course/src/features/menu/view/widgets/bottom_sheet.dart';
import 'package:flutter_course/src/features/menu/view/widgets/category.dart';
import 'package:flutter_course/src/repositories/menu_categories/abstract_categories.dart';
import 'package:flutter_course/src/theme/app_colors.dart';
import 'package:get_it/get_it.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  @override
  _MenuScreenState createState() => _MenuScreenState();
}
class _MenuScreenState extends State<MenuScreen> {

  static ButtonStyle button_style = ElevatedButton.styleFrom(
    elevation: 0,
    alignment: Alignment.center,
    backgroundColor: AppColors.mainColor,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    padding: EdgeInsets.zero,
  );

  final itemListener = ItemPositionsListener.create();

  bool playingAnimation = false;
  int current = 0;
  void setCurrent(int newCurrent) {
      setState(() {
        current = newCurrent;
      });
  }

  final itemController = ItemScrollController();
  void scrollToItem(int ind) async {
    playingAnimation = true;
    itemController.scrollTo(
        index: ind,
      duration: const Duration(milliseconds: 200),
    );
    // ignore: inference_failure_on_instance_creation
    await Future.delayed(const Duration(milliseconds: 200));
    playingAnimation = false;
  }

  final barItemController = ItemScrollController();
  void barScrollToItem(int ind) async {
    barItemController.scrollTo(
        index: ind,
        duration: const Duration(milliseconds: 120),
    );
  }

  bool onBottom = false;

  final _categoriesListBloc = CategoriesListBloc(GetIt.I<AbstractMenuCategoriesAPI>());
  int listTagsLength = 0;
  @override
  void initState() {
    super.initState();

    _categoriesListBloc.add(LoadCategoriesList());

    itemListener.itemPositions.addListener(() {
      final fullVisible = itemListener.itemPositions.value
          .where((item) {
            final isTopVisible = item.itemLeadingEdge >= 0;
            final isBottomVisible = item.itemTrailingEdge < 1.02;
            return isTopVisible && isBottomVisible;
      }).map((item) => item.index).toList();

      if(fullVisible.length == 2) {
        if ((fullVisible[1] == listTagsLength - 1) &&
            playingAnimation != true) {
          if(fullVisible[1] != current)
            {
              onBottom = true;
              setCurrent(fullVisible[1]);
              barScrollToItem(fullVisible[1]);
            }
        }
        else onBottom = false;
      }
      else onBottom = false;
      if(fullVisible.isNotEmpty) {
        if (((fullVisible[0] != current) && playingAnimation != true) &&
            onBottom == false) {
          setCurrent(fullVisible[0]);
          barScrollToItem(fullVisible[0]);
        }
      }
    });
  }

  final _selected_productsListBloc = GetIt.I<SelectedProductsListBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: Colors.transparent,
        title: PreferredSize(
          preferredSize: const Size.fromHeight((60)),
          child: SizedBox(
            height: 60,
            child: BlocBuilder<CategoriesListBloc, CategoriesListState>(
              bloc: _categoriesListBloc,
              builder: (context, state){
                if(state is CategoriesListLoaded) return
                ScrollablePositionedList.separated(
                  scrollDirection: Axis.horizontal,
                  itemScrollController: barItemController,
                  separatorBuilder: (context, _) => const SizedBox(width: 16),
                  itemCount: state.tagsList.length,
                  itemBuilder: (context, index) =>
                      Container(
                        height: 32,
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () => {
                            setCurrent(index),
                            scrollToItem(index),
                            barScrollToItem(index),
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 10,
                            alignment: Alignment.center,
                            backgroundColor: index == current? AppColors.mainColor : AppColors.white,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          ),
                          child: Text(
                            state.tagsList[index].tag,
                            style: index == current? AppTextStyles.chipActive : AppTextStyles.chip,
                          ),
                        ),
                      ),
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<CategoriesListBloc, CategoriesListState>(
        bloc: _categoriesListBloc,
        builder: (context, state){
          if(state is CategoriesListLoaded) {
            listTagsLength = state.tagsList.length;
            return Padding(
              padding: const EdgeInsets.only(left: 16),
              child: ScrollablePositionedList.separated(
                separatorBuilder: (context, _) => const SizedBox(height: 16),
                itemCount: state.tagsList.length,
                itemScrollController: itemController,
                itemPositionsListener: itemListener,
                itemBuilder: (context, index) => Category(
                  data: state.tagsList[index],
                ),
              ),
            );
          }
          if(state is CategoriesListLoadingFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Что-то пошло не так',
                  ),
                  const Text(
                    'попробуйте позже',
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      _categoriesListBloc.add(LoadCategoriesList());
                    },
                    child: const Text('Try again'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton:
          BlocBuilder<SelectedProductsListBloc, SelectedProductsListState>(
              bloc: _selected_productsListBloc,
              builder: (context, state){
                return state.cards.isNotEmpty ? SizedBox(
                    height: 45,
                    width: 120,
                    child: TextButton(
                        onPressed: () {
                          // ignore: inference_failure_on_function_invocation
                          showModalBottomSheet(
                            context: context,
                            elevation: 0,
                            showDragHandle: true,
                            backgroundColor: Colors.white,
                            builder: (context) => const MenuBottomSheet(),
                          );
                        },
                        style: button_style,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Image(
                              image: AssetImage('lib/src/assets/images/buy_image.png'),
                              height: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${state.counter.toStringAsFixed(2)} ₽',
                              style: AppTextStyles.price,
                            ),
                          ],
                        ),

                    ),
                ) : Container();
              },
          ),
    );
  }

}