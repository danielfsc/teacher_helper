import 'package:flutter/material.dart';
import 'package:teacher_helper/controllers/app_controller.dart';
import 'menu.dart';

class PageMask extends StatefulWidget {
  final String title;
  final Widget body;
  final Widget? floatingButton;
  const PageMask(
      {Key? key, required this.body, required this.title, this.floatingButton})
      : super(key: key);

  @override
  State<PageMask> createState() => _PageMaskState();
}

class _PageMaskState extends State<PageMask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: AppController.instance.isLeftHanded ? const MenuPage() : null,
      endDrawer: AppController.instance.isLeftHanded ? null : const MenuPage(),
      body: widget.body,
      floatingActionButton: widget.floatingButton,
    );
  }
}

// class MenuButton extends StatelessWidget {
//   const MenuButton({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//         onPressed: () {
//           if (AppController.instance.isLeftHanded) {
//             Scaffold.of(context).openDrawer();
//           } else {
//             Scaffold.of(context).openEndDrawer();
//           }
//         },
//         icon: const Icon(Icons.menu));
//   }
// }
