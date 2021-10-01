import 'package:boilerplate_flutter/config/styles/default_button_style.dart';
import 'package:boilerplate_flutter/config/theme.dart';
import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'bloc/edit_profile_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    required AccountRepository accountRepository,
    required this.routeObserver,
  }) : _accountRepository = accountRepository;

  final AccountRepository _accountRepository;
  final RouteObserver routeObserver;

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> with RouteAware {
  bool focusName = false;
  bool focusEmail = false;
  bool focusMotorista = false;
  bool focusCarModel = false;
  bool focusAssentos = false;
  final _formKey = GlobalKey<FormState>();
  EditProfileBloc? bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRoute? route = ModalRoute.of(context);
    if (route != null) {
      widget.routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    bloc = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditProfileBloc>(
      create: (BuildContext context) {
        EditProfileBloc tempBloc = EditProfileBloc(widget._accountRepository);
        bloc = tempBloc;
        return tempBloc;
      },
      child: BlocConsumer<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
          if (state is IdleEditProfile && state.nextRoute != null) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        },
        builder: (BuildContext context, EditProfileState state) {
          return SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                shadowColor: Colors.transparent,
                title: Text(
                  'Editar perfil',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              body: _getBody(context, state),
              bottomNavigationBar: _getSaveButton(context, state),
            ),
          );
        },
      ),
    );
  }

  Widget _getBody(BuildContext context, EditProfileState state) {
    if (state is IdleEditProfile) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 40,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    Focus(
                      onFocusChange: (hasFocus) {
                        setState(() {
                          focusName = hasFocus;
                        });
                      },
                      child: TextFormField(
                        controller: state.nameFieldState.controller,
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
                            errorText: state.nameFieldState.error),
                        keyboardType: TextInputType.text,
                        onChanged: (email) {
                          context.read<EditProfileBloc>().add(OnFormChanged());
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
                        value: state.isMotorista,
                        onChanged: (value) {
                          context.read<EditProfileBloc>().add(OnChangeMotorista());
                        },
                        title: new Text('Deseja ser motorista'),
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: RideColors.primaryColor,
                      ),
                    ),
                    if (state.isMotorista) SizedBox(height: 20),
                    if (state.isMotorista)
                      Focus(
                        onFocusChange: (hasFocus) {
                          setState(() {
                            focusCarModel = hasFocus;
                          });
                        },
                        child: TextFormField(
                          controller:
                              state.carModelFieldState.controller,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: RideColors.primaryColor),
                              ),
                              border: OutlineInputBorder(),
                              labelText: 'Digite o modelo do carro',
                              prefixIconConstraints: BoxConstraints(
                                minHeight: 16,
                                minWidth: 40,
                              ),
                              errorText: state.carModelFieldState.error),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (email) {
                            context.read<EditProfileBloc>().add(OnFormChanged());
                          },
                        ),
                      ),
                    if (state.isMotorista) SizedBox(height: 20),
                    if (state.isMotorista)
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                      context.read<EditProfileBloc>().add(
                                          CountChanged(
                                              state.countSeats, true));
                                    },
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                    '${state.countSeats}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3
                                        ?.apply(
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
                                      context.read<EditProfileBloc>().add(
                                          CountChanged(
                                              state.countSeats, false));
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
            ],
          ),
        ),
      );
    } else if (state is ErrorEditUserState) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Text(state.error.toString()),
            ElevatedButton(
              onPressed: () {
                context.read<EditProfileBloc>().add(OnFormChanged());
              },
              style: getDefaultButtonStyle(),
              child: Text(
                'Ok',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      );
    } else {
      return SizedBox.expand(
        child: Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
  }

  Widget? _getSaveButton(BuildContext context, EditProfileState state) {
    if (state is IdleEditProfile) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Container(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            style: getDefaultButtonStyle(),
            child: Text(
              'Salvar alterações',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: (state.isUpdateUserButtonEnabled)
                ? () {
                    bloc?.add(UpdateUserClicked());
                  }
                : null,
          ),
        ),
      );
    }
    return null;
  }
}
