import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:teacher_helper/shared/menu.dart';
import 'package:teacher_helper/shared/body_mask.dart';

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
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _zoomController,
      mainScreenScale: 0.15,
      showShadow: true,
      slideWidth: MediaQuery.of(context).size.width * 0.55,
      style: DrawerStyle.Style1,
      angle: 0,
      backgroundColor: Colors.grey,
      // backgroundColor: Theme.of(context).primaryColor,
      menuScreen: SafeArea(child: MenuPage()),
      mainScreen: BodyMask(
        title: widget.title,
        body: widget.body,
        floatingButton: widget.floatingButton,
        floatingButtonLocation: widget.floatingButtonLocation,
      ),
    );
  }
}
