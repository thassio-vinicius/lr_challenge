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
  final void Function()? onSuffixPressed;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final double radius;
  final bool searchBar;

  CustomTextField({
    this.errorText,
    this.hint,
    this.onEditingComplete,
    this.inputFormatters,
    this.onChanged,
    this.controller,
    this.onSuffixPressed,
    this.radius = 8,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.searchBar = false,
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
        style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: Adapt.px(15)),
        obscureText: obscure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          suffixIcon: widget.searchBar
              ? IconButton(
                  icon: Transform.rotate(
                    angle: 70,
                    child: Icon(
                      Icons.add_circle,
                      color: Theme.of(context).primaryColor.withOpacity(.5),
                    ),
                  ),
                  onPressed: widget.onSuffixPressed)
              : null,
          filled: true,
          fillColor: Theme.of(context).cardColor,
          prefixIcon: widget.searchBar
              ? Icon(
                  CupertinoIcons.search,
                  color: Theme.of(context).hintColor,
                  size: Adapt.px(16),
                )
              : null,
          errorText: widget.errorText,
          hintText: widget.hint,
          contentPadding: EdgeInsets.all(Adapt.px(6)),
          errorStyle: Theme.of(context).textTheme.headline1!.copyWith(fontSize: Adapt.px(12), color: Colors.red),
          hintStyle: Theme.of(context)
              .textTheme
              .headline1!
              .copyWith(fontSize: Adapt.px(12), color: Theme.of(context).hintColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(Adapt.px(widget.radius))),
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(Adapt.px(widget.radius))),
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(Adapt.px(widget.radius))),
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 0,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(Adapt.px(widget.radius))),
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(Adapt.px(widget.radius))),
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(Adapt.px(widget.radius))),
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 0,
            ),
          ),
        ),
      ),
    );
  }
}
