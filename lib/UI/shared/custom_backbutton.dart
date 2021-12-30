import 'package:flutter/material.dart';
import 'package:lr_challenge/utils/images.dart';

class CustomBackButton extends StatelessWidget {
  final Function()? onPressed;
  const CustomBackButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      icon: Image(
        image: AssetImage(Images.backIcon),
        color: Theme.of(context).primaryColor.withOpacity(.5),
      ),
    );
  }
}
