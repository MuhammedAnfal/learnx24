import 'package:flutter/widgets.dart';

import '../../../../utils/palette.dart';

class TcircularContainer extends StatelessWidget {
  const TcircularContainer({
    super.key,
    this.height,
    this.width,
    this.radius = 20,
    this.padding,
    this.child,
    this.backgroudColor,
    this.margin,
    this.borderColor = Palette.grey,
    this.showBorder = true,
  });

  final double? height;
  final double? width;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final Color? backgroudColor;
  final Color borderColor;
  final EdgeInsetsGeometry? margin;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: backgroudColor,
          border: showBorder ? Border.all(color: borderColor) : null),
      child: child,
    );
  }
}
