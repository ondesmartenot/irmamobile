import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/screens/change_pin/models/change_pin_bloc.dart';
import 'package:irmamobile/src/screens/change_pin/models/change_pin_state.dart';
import 'package:irmamobile/src/screens/change_pin/widgets/cancel_button.dart';
import 'package:irmamobile/src/theme/theme.dart';
import 'package:irmamobile/src/widgets/irma_text_button.dart';
import 'package:irmamobile/src/widgets/pin_field.dart';

class ChoosePin extends StatelessWidget {
  static const String routeName = 'change_pin/choose_pin';

  final void Function(BuildContext, String) chooseNewPin;
  final void Function() toggleLongPin;
  final void Function() cancel;
  final FocusNode pinFocusNode;

  const ChoosePin(
      {@required this.pinFocusNode, @required this.chooseNewPin, @required this.toggleLongPin, @required this.cancel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: IrmaTheme.of(context).grayscale85,
        leading: CancelButton(cancel: cancel),
        title: Text(
          FlutterI18n.translate(context, 'change_pin.choose_pin.title'),
          style: IrmaTheme.of(context).textTheme.display2,
        ),
      ),
      body: BlocBuilder<ChangePinBloc, ChangePinState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: IrmaTheme.of(context).defaultSpacing,
                    right: IrmaTheme.of(context).defaultSpacing,
                    top: IrmaTheme.of(context).hugeSpacing,
                    bottom: IrmaTheme.of(context).mediumSpacing
                  ),
                  child: Text(
                    FlutterI18n.translate(context, 'change_pin.choose_pin.instruction'),
                    style: IrmaTheme.of(context).textTheme.body1,
                    textAlign: TextAlign.center,
                  ),
                ),
                PinField(
                  focusNode: pinFocusNode,
                  maxLength: state.longPin ? 16 : 5,
                  onSubmit: (String pin) => chooseNewPin(context, pin),
                ),
                SizedBox(height: IrmaTheme.of(context).smallSpacing),
                IrmaTextButton(
                  onPressed: () {
                    toggleLongPin();
                  },
                  label: state.longPin ? 'change_pin.choose_pin.switch_short' : 'change_pin.choose_pin.switch_long',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
