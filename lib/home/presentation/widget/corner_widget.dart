
import 'package:flutter/material.dart';

import '../../../core/theme/newsly_theme_data.dart';

class CornerWidget extends StatelessWidget {
  bool horizontal;
  CornerWidget({
    Key? key,
    required this.horizontal
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color:
          NewslyThemeData.borderCornerColor,
          borderRadius: BorderRadius.all(
              Radius.circular(50))),
      width: horizontal?40:5,
      height: horizontal?5:40,
    );
  }
}
