import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:techni_quick/core/constant.dart';
import 'package:techni_quick/core/common/slider.dart';

import '../../model/slider.dart';

class AdsCard extends StatefulWidget {
  const AdsCard({
    Key? key,
  }) : super(key: key);
  @override
  State<AdsCard> createState() => _AdsCardState();
}

class _AdsCardState extends State<AdsCard> {
  int currentIndex = 0;
  final CarouselController carouselController = CarouselController();
  // List<String> sliders = [sliderImage, sliderImage, sliderImage];
  @override
  Widget build(BuildContext context) {
    // final sliders = context.watch<HomeInfoCubit>().sliders;
    return StreamBuilder<List<AppSlider>>(
        stream: SlidersController.getSliders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          return Column(
            children: [
              if (snapshot.data!.isNotEmpty)
                CarouselSlider.builder(
                  itemCount: snapshot.data!.length,
                  carouselController: carouselController,
                  options: CarouselOptions(
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 5),
                      height: 150,
                      scrollDirection: Axis.horizontal,
                      scrollPhysics: const BouncingScrollPhysics(),
                      autoPlayCurve: Curves.easeInOut,
                      viewportFraction: .96,
                      disableCenter: true,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.scale),
                  itemBuilder: (context, index, realIdx) {
                    return HomeProductCard(image: snapshot.data![index].image);
                  },
                ),
              if (snapshot.data!.length > 1)
                const SizedBox(
                  height: 15,
                ),
              if (snapshot.data!.length > 1)
                AnimatedSmoothIndicator(
                  activeIndex: currentIndex,
                  count: snapshot.data!.length,
                  onDotClicked: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                    carouselController.animateToPage(currentIndex);
                  },
                  effect: const WormEffect(
                      dotHeight: 10, dotWidth: 10, activeDotColor: mainColor),
                ),
            ],
          );
        });
  }
}

class HomeProductCard extends StatelessWidget {
  final String image;
  const HomeProductCard({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: const BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
                offset: Offset(1, 1), blurRadius: 3, color: Colors.black54)
          ],
          borderRadius: BorderRadius.all(Radius.circular(22.0)),
          // border: Border.all(
          //   color: primary,
          // ),
        ),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(22.0)),
            child: Image.network(
              image,
              fit: BoxFit.fill,
            )),
      ),
    );
  }
}
