import 'package:boilerplate_flutter/config/styles/default_button_style.dart';
import 'package:boilerplate_flutter/config/theme.dart';
import 'package:boilerplate_flutter/data/repositories/ride_repository.dart';
import 'package:boilerplate_flutter/modules/createRide/bloc/create_ride_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateRideScreen extends StatefulWidget {
  const CreateRideScreen({
    required RideRepository rideRepository,
    required this.routeObserver,
  }) : _rideRepository = rideRepository;

  final RideRepository _rideRepository;
  final RouteObserver routeObserver;

  @override
  CreateRideScreenState createState() => CreateRideScreenState();
}

class CreateRideScreenState extends State<CreateRideScreen> with RouteAware {
  bool focusReferenciaDestino = false;
  bool focusReferenciaPartida = false;
  DateTime? _dateTime;
  TimeOfDay? _time;
  final _formKey = GlobalKey<FormState>();
  CreateRideBloc? bloc;

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
    return BlocProvider<CreateRideBloc>(
      create: (BuildContext context) {
        CreateRideBloc tempBloc = CreateRideBloc(widget._rideRepository);
        bloc = tempBloc;
        return tempBloc;
      },
      child: BlocConsumer<CreateRideBloc, CreateRideState>(
        listener: (context, state) {
          if (state is IdleCreateRide && state.nextRoute != null) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        },
        builder: (BuildContext context, CreateRideState state) {
          return SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                shadowColor: Colors.transparent,
                leading: BackButton(
                  color: Colors.black,
                ),
                title: Text(
                  'Criar viagem',
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

  Widget _getBody(BuildContext context, CreateRideState state) {
    if (state is IdleCreateRide) {
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ponto de partida'),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black38),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: state.fromLocation,
                              icon: Icon(Icons.keyboard_arrow_down),
                              items: state.itemsLocation.map((String items) {
                                return DropdownMenuItem(
                                    value: items, child: Text(items));
                              }).toList(),
                              onChanged: (newValue) {
                                context.read<CreateRideBloc>().add(
                                    FromLocationChanged(newValue.toString()));
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Focus(
                      onFocusChange: (hasFocus) {
                        setState(() {
                          focusReferenciaPartida = hasFocus;
                        });
                      },
                      child: TextFormField(
                        controller: state.partidaRefFieldState.controller,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: RideColors.primaryColor),
                            ),
                            border: OutlineInputBorder(),
                            labelText: 'Referência',
                            prefixIconConstraints: BoxConstraints(
                              minHeight: 16,
                              minWidth: 40,
                            ),
                            hintText: "Ex: Proxímo ao ctc",
                            errorText: state.partidaRefFieldState.error),
                        keyboardType: TextInputType.text,
                        onChanged: (email) {
                          context.read<CreateRideBloc>().add(OnFormChanged());
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Destino'),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black38),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: state.toLocation,
                              icon: Icon(Icons.keyboard_arrow_down),
                              items: state.itemsLocation.map((String items) {
                                return DropdownMenuItem(
                                    value: items, child: Text(items));
                              }).toList(),
                              onChanged: (newValue) {
                                context.read<CreateRideBloc>().add(
                                    ToLocationChanged(newValue.toString()));
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Focus(
                      onFocusChange: (hasFocus) {
                        setState(() {
                          focusReferenciaDestino = hasFocus;
                        });
                      },
                      child: TextFormField(
                        controller: state.destinoRefFieldState.controller,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: RideColors.primaryColor),
                            ),
                            border: OutlineInputBorder(),
                            labelText: 'Referência',
                            prefixIconConstraints: BoxConstraints(
                              minHeight: 16,
                              minWidth: 40,
                            ),
                            hintText: "Ex: Proxímo ao ctc",
                            errorText: state.destinoRefFieldState.error),
                        keyboardType: TextInputType.text,
                        onChanged: (email) {
                          context.read<CreateRideBloc>().add(OnFormChanged());
                        },
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black38),
                      ),
                      child: ListTile(
                        title: Text(state.date.isEmpty
                            ? "Calêndario"
                            : state.date),
                        trailing: Icon(Icons.event),
                        onTap: () {
                          showDatePicker(
                                  initialEntryMode:
                                      DatePickerEntryMode.calendarOnly,
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2023))
                              .then((date) {
                            setState(() {
                              _dateTime = date!;
                            });
                            DateTime? localDate = _dateTime;
                            if (localDate != null) {
                              context
                                  .read<CreateRideBloc>()
                                  .add(DateChanged(localDate));
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black38),
                      ),
                      child: ListTile(
                        title: Text(state.hour.isEmpty ? "Hora" : state.hour),
                        trailing: Icon(Icons.access_time),
                        onTap: () {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((time) {
                            setState(() {
                              _time = time!;
                            });
                            TimeOfDay? localTime = _time;
                            if (localTime != null) {
                              context
                                  .read<CreateRideBloc>()
                                  .add(HourChanged(localTime));
                            }
                          });
                        },
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
                context.read<CreateRideBloc>().add(OnFormChanged());
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

  Widget? _getSaveButton(BuildContext context, CreateRideState state) {
    if (state is IdleCreateRide) {
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
                    bloc?.add(CreateRideClicked());
                  }
                : null,
          ),
        ),
      );
    }
    return null;
  }
}
