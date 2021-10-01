import 'package:boilerplate_flutter/config/styles/default_button_style.dart';
import 'package:boilerplate_flutter/config/theme.dart';
import 'package:boilerplate_flutter/modules/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';


class LoginForm extends StatefulWidget {
  LoginForm(this.state, this.formKey);

  final Idle state;
  final GlobalKey formKey;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool focusEmail = false;
  bool focusPassword = false;
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 0),
      child: Column(
        children: [
          Image.asset(
            'assets/images/logo.png',
          ),
          SizedBox(height: 40),
          Row(
            children: [
              Text(
                'Entrar',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 2,
                  color: RideColors.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: 40),
          Form(
            key: widget.formKey,
            child: Column(
              children: [
                Focus(
                  onFocusChange: (hasFocus) {
                    setState(() {
                      focusEmail = hasFocus;
                    });
                  },
                  child: TextFormField(
                    controller: widget.state.emailFieldState.controller,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: RideColors.primaryColor),
                        ),
                        border: OutlineInputBorder(),
                        labelText: 'Digite seu idUFSC',
                        prefixIcon: Icon(
                          Icons.account_circle,
                          color: focusEmail
                              ? RideColors.primaryColor
                              : Color(0xFF666362),
                        ),
                        prefixIconConstraints: BoxConstraints(
                          minHeight: 16,
                          minWidth: 40,
                        ),
                        errorText: widget.state.emailFieldState.error),
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (email) {
                      context.read<LoginBloc>().add(OnFormChanged());
                    },
                  ),
                ),
                SizedBox(height: 20),
                Focus(
                  onFocusChange: (hasFocus) {
                    setState(() {
                      focusPassword = hasFocus;
                    });
                  },
                  child: TextFormField(
                    controller: widget.state.passwordFieldState.controller,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: RideColors.primaryColor),
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Digite sua senha',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: focusPassword
                            ? RideColors.primaryColor
                            : Color(0xFF666362),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minHeight: 16,
                        minWidth: 40,
                      ),
                      errorText: widget.state.passwordFieldState.error,
                      suffixIcon: ButtonTheme(
                        padding: EdgeInsets.all(0),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minWidth: 0,
                        height: 0,
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          child: SvgPicture.asset(
                            'assets/icons/ic_eye.svg',
                            width: 20,
                            color: focusPassword
                                ? RideColors.primaryColor
                                : RideColors.white[64],
                          ),
                        ),
                      ),
                    ),
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: hidePassword,
                    onChanged: (password) {
                      context.read<LoginBloc>().add(OnFormChanged());
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: getDefaultButtonStyle(),
                    child: Text(
                      'Entrar',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    onPressed: widget.state.isLoginButtonEnabled
                        ? () {
                            context
                                .read<LoginBloc>()
                                .add(OnLoginButtonClicked());
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
