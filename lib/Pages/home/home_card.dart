import 'package:flutter/material.dart';
import 'package:teacher_helper/shared/data/opcoes.dart';

class HomeCardWidget extends StatelessWidget {
  const HomeCardWidget(this.info, {Key? key}) : super(key: key);
  final OpcoesModelo info;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: AbsorbPointer(
        absorbing: !info.active,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.of(context).pushNamed(info.route);
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.width * 0.35,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    info.icon,
                    size: 42,
                    color: info.active ? info.color : Colors.grey,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    info.title,
                    style: TextStyle(
                      color: info.active ? info.color : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
