import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:techni_quick/core/constant.dart';

class CustomRating extends StatelessWidget {
  const CustomRating({super.key, this.rate});
  final double? rate;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: RatingBar(
        ignoreGestures: true,
        initialRating: rate!,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        unratedColor: Colors.amber,
        tapOnlyMode: true,
        itemCount: 5,
        itemSize: 45.r,
        itemPadding: EdgeInsets.only(left: 2.0.w),
        ratingWidget: RatingWidget(
          full: const Icon(Icons.star, color: Colors.amber),
          empty: const Icon(Icons.star_border, color: white),
          half: const Icon(Icons.star_half, color: Colors.amber),
        ),
        onRatingUpdate: (rating) {},
        updateOnDrag: false,
      ),
    );
  }
}
