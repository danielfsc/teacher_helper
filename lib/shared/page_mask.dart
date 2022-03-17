import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:teacher_helper/shared/menu.dart';
import 'package:teacher_helper/shared/body_mask.dart';
import 'package:teacher_helper/shared/modelos/opcao_menu.dart';

class PageMask extends StatefulWidget {
  final String title;
  final Widget body;
  final Widget? floatingButton;
  final FloatingActionButtonLocation? floatingButtonLocation;
  const PageMask(
      {Key? key,
      required this.body,
      required this.title,
      this.floatingButton,
      this.floatingButtonLocation})
      : super(key: key);
  @override
  _PageMaskState createState() => _PageMaskState();
}

class _PageMaskState extends State<PageMask> {
  final _zoomController = ZoomDrawerController();

  final OpcaoMenu inicial =
      OpcaoMenu(Icons.home, 'Início', '/home', true, Colors.black);

  @override
  void initState() {
    // Authentication.alreadyLogged(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _zoomController,
      mainScreenScale: 0.15,
      showShadow: true,
      slideWidth: MediaQuery.of(context).size.width * 0.5 > 350
          ? 350
          : MediaQuery.of(context).size.width * 0.55,
      style: DrawerStyle.Style1,
      angle: MediaQuery.of(context).size.width * 0.5 > 350 ? 0 : -5,
      backgroundColor: Colors.orangeAccent,
      openCurve: Curves.easeInCirc,
      closeCurve: Curves.easeOutCirc,
      menuScreen: const MenuPage(),
      mainScreen: BodyMask(
        title: widget.title,
        body: widget.body,
        floatingButton: widget.floatingButton,
        floatingButtonLocation: widget.floatingButtonLocation,
      ),
    );
  }
}
