import 'package:boilerplate_flutter/config/app_routes.dart';
import 'package:boilerplate_flutter/config/styles/default_button_style.dart';
import 'package:boilerplate_flutter/config/theme.dart';
import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:boilerplate_flutter/modules/login/bloc/login_bloc.dart';
import 'package:boilerplate_flutter/modules/login/components/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    required RouteObserver routeObserver,
    required AccountRepository accountRepository,
  })  : _routeObserver = routeObserver,
        _accountRepository = accountRepository;

  final RouteObserver _routeObserver;
  final AccountRepository _accountRepository;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with RouteAware {
  LoginBloc? bloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ModalRoute? route = ModalRoute.of(context);
    if (route != null) {
      widget._routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    widget._routeObserver.unsubscribe(this);
    bloc = null;
    super.dispose();
  }

  @override
  void didPopNext() {
    bloc?.add(OnScreenResumed());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (BuildContext context) {
        LoginBloc tempBloc = LoginBloc(widget._accountRepository);
        bloc = tempBloc;
        return tempBloc;
      },
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (BuildContext context, LoginState state) {
          if (state is Idle) {
            String? localNextRoute = state.nextRoute;
            if (localNextRoute != null && localNextRoute == AppRoutes.core) {
              Navigator.of(context, rootNavigator: true)
                  .pushNamedAndRemoveUntil(localNextRoute, (route) {
                return false;
              });
            } else if (localNextRoute != null) {
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(localNextRoute);
            }
          }
        },
        builder: (BuildContext context, LoginState state) {
          return Scaffold(
            backgroundColor: RideColors.primaryColor[50],
            body: SafeArea(
              child: _getBody(context, state),
            ),
          );
        },
      ),
    );
  }

  Widget _getBody(BuildContext context, LoginState state) {
    if (state is Idle) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginForm(state, _formKey),
            TextButton(
              child: Text(
                'Registrar',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
              ),
              onPressed: () {
                context.read<LoginBloc>().add(OnRegisterClicked());
              },
            ),
          ],
        ),
      );
    }  else if (state is Error) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                'assets/images/warning.png',
                width: 150,
                height: 150,
              ),
            ),
            Text(state.error.toString(), textAlign: TextAlign.center,),
            ElevatedButton(
              onPressed: () {
                context.read<LoginBloc>().add(OnFormChanged());
              },
              style: getDefaultButtonStyle(),
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}
