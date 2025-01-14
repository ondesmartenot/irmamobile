// This code is not null safe yet.
// @dart=2.11

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/theme/irma_icons.dart';

class IrmaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Icon leadingIcon;
  final void Function() leadingAction;
  final void Function() leadingCancel;
  final String leadingTooltip;
  final List<Widget> actions;
  final bool noLeading;

  const IrmaAppBar(
      {this.title,
      this.leadingIcon,
      this.leadingAction,
      this.leadingTooltip,
      this.leadingCancel,
      this.noLeading = false,
      this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      key: const Key('irma_app_bar'),
      centerTitle: true,
      leading: noLeading
          ? null
          : IconButton(
              key: const Key('irma_app_bar_leading'),
              icon: leadingIcon ??
                  Icon(
                    IrmaIcons.arrowBack,
                    semanticLabel: FlutterI18n.translate(context, "accessibility.back"),
                    size: 18.0,
                  ),
              tooltip: leadingTooltip,
              onPressed: () {
                if (leadingCancel != null) {
                  leadingCancel();
                }
                if (leadingAction == null) {
                  Navigator.of(context).pop();
                } else {
                  leadingAction();
                }
              }),
      title: title,
      actions: actions,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
