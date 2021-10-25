import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:teacher_helper/controllers/app_controller.dart';

// Estrutura padrão das páginas do APP - Não é obrigatório utilizar
// #Parâmetros
// - title : Uma String com o texto que será colocado na AppBar;
// - body : O widget que será colocado no corpo da página;
// - floatingButton: Um FloatActionButton para ser adicionado na página;
// Esse widget não é obrigatório usar na página, mas ele deixa todas as páginas
// dentro do mesmo padrão de cor, botões e menus.

class BodyMask extends StatefulWidget {
  final String title;
  final Widget body;
  final Widget? floatingButton;
  final FloatingActionButtonLocation? floatingButtonLocation;
  const BodyMask(
      {Key? key,
      required this.body,
      required this.title,
      this.floatingButton,
      this.floatingButtonLocation})
      : super(key: key);

  @override
  State<BodyMask> createState() => _BodyMaskState();
}

class _BodyMaskState extends State<BodyMask> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _redirectTo,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: AppController.instance.isLeftHanded
              ? const MenuButtonWidget()
              : null,
          actions: AppController.instance.isLeftHanded
              ? []
              : [const MenuButtonWidget()],
        ),
        // drawer: AppController.instance.isLeftHanded ? MenuPage() : null,
        // endDrawer: AppController.instance.isLeftHanded ? null : MenuPage(),
        body: widget.body,
        floatingActionButton: widget.floatingButton,
        floatingActionButtonLocation:
            widget.floatingButtonLocation ?? _floatButtonPosition(),
      ),
    );
  }

  Future<bool> _redirectTo() async {
    if (ModalRoute.of(context) != null &&
        ModalRoute.of(context)!.settings.name != '/home') {
      Navigator.of(context).popAndPushNamed('/');
    }
    return false;
  }

  _floatButtonPosition() {
    return AppController.instance.isLeftHanded
        ? FloatingActionButtonLocation.endFloat
        : FloatingActionButtonLocation.endFloat;
  }
}

class MenuButtonWidget extends StatelessWidget {
  const MenuButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        ZoomDrawer.of(context)!.open();
      },
    );
  }
}
