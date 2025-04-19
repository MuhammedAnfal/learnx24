import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../../main.dart';
import '../../../../utils/palette.dart';
import '../../controllers/home_controller.dart';
import 'circular_container.dart';

class HomeCarousel extends StatelessWidget {
  const HomeCarousel({super.key, required this.banners, this.height, this.widht, this.margin});

  final List<String> banners;
  final height;
  final widht;
  final margin;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Column(
      children: [
        Container(
          margin: margin,
          height: height,
          width: widht,
          child: CarouselSlider(
            items: banners
                .map(
                  (e) => Container(
                    height: h * 0.2,
                    width: w * 0.9,
                    margin: EdgeInsets.all(w * 0.01),
                    padding: EdgeInsets.all(w * 0.035),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.black,
                            blurStyle: BlurStyle.normal,

                            blurRadius: 10,
                            offset: Offset(0, 0)
                        )
                      ],
                      color: Palette.primaryColor,
                      border: Border.all(color: Palette.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        e,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
                .toList(),
            options: CarouselOptions(
              onPageChanged: (index, reason) {
                controller.carouselindex.value = index;
              },
              viewportFraction: 1,
              autoPlay: true,
            ),
          ),
        ),
        SizedBox(
          height: h * 0.02,
        ),
        Center(
          child: Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < banners.length; i++)
                  TcircularContainer(
                    margin: EdgeInsets.only(left: w * 0.02),
                    height: h * 0.006,
                    width: w * 0.04,
                    backgroudColor: controller.carouselindex.value == i ? Palette.grey.withOpacity(0.8) : Palette.darkerGrey,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
