import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/src/features/menu/data/text_styles.dart';
import 'package:flutter_course/src/features/menu/models/card_model.dart';

class SelectedProduct extends StatelessWidget {
  const SelectedProduct({super.key, required this.data});

  final CardModel data;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 6, right: 6, top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CachedNetworkImage(
                    imageUrl: data.ico,
                    height: 55,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) =>
                    const Image(
                        image: AssetImage('lib/src/assets/images/outdate_image.png'),
                        height: 55,
                    ),
                ),
                const SizedBox(width: 16),
                Text(
                    data.name,
                    style: AppTextStyles.bottomsheetProductName,
                ),
              ],
            ),
            Text(
                '${data.price} ${data.priceType}',
                style: AppTextStyles.bottomsheetProductPrice,
            ),
          ],
        ),
    );
  }
}