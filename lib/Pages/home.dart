import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Início'),
      ),
      body: Container(
        child: Column(
          children: const [
            Center(child: Text('Aqui virão as ações iniciais')),
          ],
        ),
      ),
    );
  }
}
