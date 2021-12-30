import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lr_challenge/utils/adapt.dart';

class CustomTextField extends StatefulWidget {
  final String? hint;
  final String? errorText;
  final bool obscureText;
  final bool enabled;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final Function? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;

  CustomTextField({
    this.errorText,
    this.hint,
    this.onEditingComplete,
    this.inputFormatters,
    this.onChanged,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.enabled = true,
    this.obscureText = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool obscure;

  @override
  void initState() {
    obscure = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Adapt.px(12)),
      child: TextField(
        enabled: widget.enabled,
        inputFormatters: widget.inputFormatters,
        onEditingComplete: widget.onEditingComplete as void Function()?,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        autocorrect: true,
        onChanged: widget.onChanged,
        controller: widget.controller,
        style: Theme.of(context).textTheme.headline1!.copyWith(color: Colors.black, fontSize: Adapt.px(15)),
        obscureText: obscure,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          errorText: widget.errorText,
          labelText: widget.hint,
          contentPadding: EdgeInsets.all(Adapt.px(6)),
          errorStyle: Theme.of(context).textTheme.headline1!.copyWith(fontSize: Adapt.px(12), color: Colors.red),
          labelStyle: Theme.of(context)
              .textTheme
              .headline1!
              .copyWith(fontSize: Adapt.px(12), color: Theme.of(context).hintColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(Adapt.px(8))),
            borderSide: BorderSide(
              color: Theme.of(context).hintColor,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(Adapt.px(8))),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(Adapt.px(8))),
            borderSide: BorderSide(
              color: Theme.of(context).hintColor,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(Adapt.px(8))),
            borderSide: BorderSide(
              color: Theme.of(context).hintColor,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
