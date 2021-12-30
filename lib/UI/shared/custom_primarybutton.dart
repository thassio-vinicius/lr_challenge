import 'package:flutter/material.dart';
import 'package:lr_challenge/utils/adapt.dart';

class CustomPrimaryButton extends StatelessWidget {
  final Function? onPressed;
  final String? label;
  final bool loading;
  final bool enabled;
  const CustomPrimaryButton({
    required this.onPressed,
    required this.label,
    this.enabled = true,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Center(
        child: loading
            ? CircularProgressIndicator(color: Theme.of(context).primaryColor)
            : FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  label!,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(color: Colors.white.withOpacity(enabled ? 1 : 0.9)),
                ),
              ),
      ),
      onPressed: loading
          ? null
          //To avoid the call of the onPressed method even with the button disabled
          : enabled
              ? onPressed as void Function()?
              : () {
                  print("button disabled");
                },
      color: Theme.of(context).primaryColor.withOpacity(enabled ? 1 : 0.5),
      height: Adapt().hp(8),
      shape:
          RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(Adapt.px(8)))),
    );
  }
}
