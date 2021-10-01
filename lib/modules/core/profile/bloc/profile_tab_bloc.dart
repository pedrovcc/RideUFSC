import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/config/app_routes.dart';
import 'package:boilerplate_flutter/config/theme.dart';
import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:boilerplate_flutter/modules/core/profile/components/menu_item.dart';
import 'package:equatable/equatable.dart';

part 'profile_tab_event.dart';

part 'profile_tab_state.dart';

class ProfileTabBloc extends Bloc<ProfileTabEvent, ProfileTabState> {
  ProfileTabBloc(
    AccountRepository accountRepository,
  )   : _accountRepository = accountRepository,
        super(Loading()) {
    add(OnScreenResumed());
  }

  final AccountRepository _accountRepository;
  final List<MenuItemDescriptor> _menuItems = [
    MenuItemDescriptor(
        title: 'Perfil',
        iconFileName: 'ic_account',
        iconColor: RideColors.primaryColor,
        actionId: AppRoutes.editProfile),
    MenuItemDescriptor(
        title: 'Sair',
        iconFileName: 'ic_exit',
        iconColor: RideColors.primaryColor,
        actionId: AppRoutes.appRestart),
  ];

  @override
  Stream<ProfileTabState> mapEventToState(ProfileTabEvent event) async* {
    yield _mapEventToState(event);
  }

  @override
  Future<void> close() {
    return super.close();
  }

  ProfileTabState _mapEventToState(ProfileTabEvent event) {
    if (event is ItemClicked) {
      return _mapItemClickedEventToState(event);
    } else if (event is OnScreenResumed) {
      return _mapOnScreenResumed();
    }
    return state;
  }

  ProfileTabState _mapItemClickedEventToState(ItemClicked event) {
    ProfileTabState localState = state;
    if (localState is Idle) {
      return Idle(
        menuItemDescriptors: _menuItems,
        nextRoute: event.actionId,
      );
    } else {
      return state;
    }
  }

  ProfileTabState _mapOnScreenResumed() {
    return Idle(
      menuItemDescriptors: _menuItems,
      nextRoute: null,
    );
  }
}
