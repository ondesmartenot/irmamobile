import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:irmamobile/src/screens/enrollment/models/enrollment_bloc.dart';
import 'package:irmamobile/src/screens/enrollment/models/enrollment_state.dart';
import 'package:irmamobile/src/screens/enrollment/widgets/choose_pin.dart';
import 'package:irmamobile/src/screens/enrollment/widgets/provide_email_actions.dart';
import 'package:irmamobile/src/screens/enrollment/widgets/welcome.dart';
import 'package:irmamobile/src/theme/theme.dart';
import 'package:irmamobile/src/widgets/irma_app_bar.dart';
import 'package:irmamobile/src/widgets/loading_indicator.dart';

class ProvideEmail extends StatefulWidget {
  static const String routeName = 'provide_email';

  final void Function() submitEmail;
  final void Function() skipEmail;
  final void Function(String) changeEmail;
  final void Function() cancel;

  const ProvideEmail({
    @required this.submitEmail,
    @required this.changeEmail,
    @required this.skipEmail,
    @required this.cancel,
  });

  @override
  _ProvideEmailState createState() => _ProvideEmailState();
}

class _ProvideEmailState extends State<ProvideEmail> {
  FocusNode inputFocusNode;

  @override
  void initState() {
    super.initState();
    inputFocusNode = FocusNode();
  }

  @override
  void dispose() {
    inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IrmaAppBar(
        title: Text(
          FlutterI18n.translate(context, 'enrollment.provide_email.title'),
        ),
        cancel: widget.cancel,
        iconAction: () {
          Navigator.of(context).popUntil(
              (route) => route.settings.name == ChoosePin.routeName || route.settings.name == Welcome.routeName);
        },
        iconTooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      ),
      body: BlocBuilder<EnrollmentBloc, EnrollmentState>(
        builder: (context, state) {
          String error;

          if (state.emailValid == false && state.showEmailValidation) {
            error = FlutterI18n.translate(context, 'enrollment.provide_email.error');
          }

          if (state.isSubmitting) {
            _hideKeyboard(context);
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(IrmaTheme.of(context).defaultSpacing),
                          child: Column(
                            children: <Widget>[
                              Text(
                                FlutterI18n.translate(context, 'enrollment.provide_email.instruction'),
                                style: IrmaTheme.of(context).textTheme.body1,
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: IrmaTheme.of(context).defaultSpacing),
                              TextField(
                                autofocus: true,
                                focusNode: inputFocusNode,
                                decoration: InputDecoration(
                                  labelStyle: IrmaTheme.of(context).textTheme.overline,
                                  errorText: error,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: widget.changeEmail,
                                onEditingComplete: widget.submitEmail,
                              ),
                            ],
                          ),
                        ),
                        if (state.isSubmitting)
                          LoadingIndicator()
                        else
                          ProvideEmailActions(
                            submitEmail: widget.submitEmail,
                            skipEmail: widget.skipEmail,
                            enterEmail: () {
                              FocusScope.of(context).requestFocus(inputFocusNode);
                            },
                          )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void _hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}
