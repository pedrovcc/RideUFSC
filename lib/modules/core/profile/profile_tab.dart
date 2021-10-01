import 'dart:ui';

import 'package:boilerplate_flutter/config/app_routes.dart';
import 'package:boilerplate_flutter/data/repositories/account_repository.dart';
import 'package:boilerplate_flutter/config/theme.dart';
import 'package:boilerplate_flutter/modules/core/profile/bloc/profile_tab_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/menu_item.dart';

class ProfileTab extends StatefulWidget {
  ProfileTab({
    required AccountRepository accountRepository,
    required this.routeObserver,
  }) : _accountRepository = accountRepository;

  final AccountRepository _accountRepository;
  final RouteObserver routeObserver;

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> with RouteAware {
  ProfileTabBloc? bloc;
  ScrollController _scrollController = ScrollController(initialScrollOffset: 0);
  double roundedBottomHeight = 0;
  double sliverAppBarFontScalingFactor = 1.25;
  bool expandedAppBar = false;
  double offset = 0;

  List<Widget> widgetsList(
          BuildContext context, List<MenuItemDescriptor> descriptors) =>
      descriptors
          .map(
            (descriptor) => MenuItem(
              menuItemDescriptor: descriptor,
              onPressed: () {
                context
                    .read<ProfileTabBloc>()
                    .add(ItemClicked(descriptor.actionId));
              },
            ),
          )
          .toList();

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
  void didPopNext() {
    setState(() {
      print('Reset scroll controller');
      _scrollController = ScrollController(initialScrollOffset: 0);
    });
    bloc?.add(OnScreenResumed());
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileTabBloc>(
      create: (BuildContext context) {
        ProfileTabBloc tempBloc = ProfileTabBloc(widget._accountRepository);
        bloc = tempBloc;
        return tempBloc;
      },
      child: BlocConsumer<ProfileTabBloc, ProfileTabState>(
        listener: (context, state) {
          if (state is Idle) {
            String? localNextRoute = state.nextRoute;
            if (localNextRoute != null) {
              if (localNextRoute == AppRoutes.appRestart) {
                widget._accountRepository.logout();
              }
              Navigator.of(context, rootNavigator: true)
                  .pushNamed(localNextRoute);
              context.read<ProfileTabBloc>().add(OnScreenResumed());
            }
          }
        },
        builder: (BuildContext context, ProfileTabState state) {
          return NotificationListener<ScrollUpdateNotification>(
            onNotification: (ScrollUpdateNotification notification) {
              if (_scrollController.hasClients &&
                  _scrollController.offset > 190 &&
                  roundedBottomHeight == 24) {
                setState(() {
                  roundedBottomHeight = 24;
                  offset = _scrollController.offset;
                });
              } else {
                setState(() {
                  roundedBottomHeight = 24;
                  offset = _scrollController.offset;
                });
              }

              return true;
            },
            child: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    backgroundColor: RideColors.primaryColor,
                    floating: false,
                    centerTitle: false,
                    titleSpacing: 0,
                    expandedHeight: 256,
                    pinned: true,
                    elevation: 0,
                    bottom: PreferredSize(
                      preferredSize: Size.zero,
                      child: Builder(builder: (context) {
                        return Container(
                          width: double.infinity,
                          height: _scrollController.hasClients && offset < 190
                              ? 24
                              : 0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 1,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(24),
                              topLeft: Radius.circular(24),
                            ),
                          ),
                        );
                      }),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      titlePadding: EdgeInsets.symmetric(horizontal: 24),
                      background: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/logo.png',
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.0)),
                          ),
                        ),
                      ),
                      title: Container(
                        margin: EdgeInsets.only(
                          bottom: _scrollController.hasClients && offset > 190
                              ? 0
                              : 24,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.cover,
                                    child: Text(
                                      widget._accountRepository.currentUser
                                              ?.firstCharToUpper(widget
                                                      ._accountRepository
                                                      .currentUser
                                                      ?.name ??
                                                  '') ??
                                          '',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            20 / sliverAppBarFontScalingFactor,
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.cover,
                                    child: Text(
                                      widget._accountRepository.currentUser
                                              ?.idUFSC ??
                                          '',
                                      style: TextStyle(
                                        color: RideColors.white[88],
                                        fontSize:
                                            16 / sliverAppBarFontScalingFactor,
                                      ),
                                      textScaleFactor: 0.85,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              body: Builder(
                builder: (BuildContext context) {
                  return _getBody(context, state);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getBody(BuildContext context, ProfileTabState state) {
    if (state is Idle) {
      List<Widget> list = widgetsList(context, state.menuItemDescriptors);
      return CustomScrollView(
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) => list[index],
              childCount: list.length,
            ),
          )
        ],
      );
    }
    return Center(child: CircularProgressIndicator());
  }
}
