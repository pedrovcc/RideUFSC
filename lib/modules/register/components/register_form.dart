import 'package:boilerplate_flutter/config/theme.dart';
import 'package:boilerplate_flutter/modules/register/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm(this.state, this.formKey);

  final IdleRegister state;
  final GlobalKey formKey;

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool focusEmail = false;
  bool focusName = false;
  bool focusPassword = false;
  bool focusMotorista = false;
  bool focusCarModel = false;
  bool focusAssentos = false;
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
      child: Form(
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
                      borderSide: BorderSide(color: RideColors.primaryColor),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Digite seu idUFSC',
                    // contentPadding: EdgeInsets.only(top: 15, bottom: 8),
                    prefixIconConstraints: BoxConstraints(
                      minHeight: 16,
                      minWidth: 40,
                    ),
                    errorText: widget.state.emailFieldState.error),
                keyboardType: TextInputType.emailAddress,
                onChanged: (email) {
                  context.read<RegisterBloc>().add(OnFormChanged());
                },
              ),
            ),
            SizedBox(height: 20),
            Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  focusName = hasFocus;
                });
              },
              child: TextFormField(
                controller: widget.state.nameFieldState.controller,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: RideColors.primaryColor),
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Digite seu Nome',
                    prefixIconConstraints: BoxConstraints(
                      minHeight: 16,
                      minWidth: 40,
                    ),
                    errorText: widget.state.nameFieldState.error),
                keyboardType: TextInputType.text,
                onChanged: (email) {
                  context.read<RegisterBloc>().add(OnFormChanged());
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
                  labelText: 'Digite uma senha',
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
                  context.read<RegisterBloc>().add(OnFormChanged());
                },
              ),
            ),
            SizedBox(height: 20),
            Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  focusMotorista = hasFocus;
                });
              },
              child: CheckboxListTile(
                contentPadding: EdgeInsets.all(0),
                value: widget.state.isMotorista,
                onChanged: (value) {
                  context.read<RegisterBloc>().add(OnChangeMotorista());
                },
                title: new Text('Deseja ser motorista'),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: RideColors.primaryColor,
              ),
            ),
            if (widget.state.isMotorista) SizedBox(height: 20),
            if (widget.state.isMotorista)
              Focus(
                onFocusChange: (hasFocus) {
                  setState(() {
                    focusCarModel = hasFocus;
                  });
                },
                child: TextFormField(
                  controller: widget.state.carModelFieldState.controller,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: RideColors.primaryColor),
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Digite o modelo do carro',
                      prefixIconConstraints: BoxConstraints(
                        minHeight: 16,
                        minWidth: 40,
                      ),
                      errorText: widget.state.carModelFieldState.error),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (email) {
                    context.read<RegisterBloc>().add(OnFormChanged());
                  },
                ),
              ),
            if (widget.state.isMotorista) SizedBox(height: 20),
            if (widget.state.isMotorista)
              Focus(
                onFocusChange: (hasFocus) {
                  setState(() {
                    focusAssentos = hasFocus;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      color: RideColors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            child: Container(
                              color: RideColors.primaryColor,
                              child: Icon(
                                Icons.add,
                                color: RideColors.white,
                                size: 30,
                              ),
                            ),
                            onTap: () {
                              context
                                  .read<RegisterBloc>()
                                  .add(CountChanged(widget.state.countSeats, true));
                            },
                          ),
                          SizedBox(width: 20),
                          Text(
                            '${widget.state.countSeats}',
                            style: Theme.of(context).textTheme.headline3?.apply(
                                  color: RideColors.white[24],
                                ),
                          ),
                          SizedBox(width: 20),
                          InkWell(
                            child: Container(
                              color: RideColors.primaryColor,
                              child: Icon(
                                Icons.remove,
                                color: RideColors.white,
                                size: 30,
                              ),
                            ),
                            onTap: () {
                              context
                                  .read<RegisterBloc>()
                                  .add(CountChanged(widget.state.countSeats, false));
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Assentos disponiveis no carro', style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
