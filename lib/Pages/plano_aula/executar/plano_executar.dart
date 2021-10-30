import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:teacher_helper/shared/modelos/plano_model.dart';

class PlanoExecutar extends StatefulWidget {
  final PlanoAula plano;
  const PlanoExecutar({Key? key, required this.plano}) : super(key: key);

  @override
  _PlanoExecutarState createState() => _PlanoExecutarState();
}

class _PlanoExecutarState extends State<PlanoExecutar> {
  List atividades = [];
  int _index = 0;
  StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromMinute(0),
    onEnded: () {},
  );

  @override
  void initState() {
    _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: StopWatchTimer.getMilliSecFromMinute(0),
      onEnded: () => changeIndex(1, continua: true),
    );

    atividades = widget.plano.atividades;
    defineAtividade();
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plano.titulo),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              verticalButton(icon: Icons.fast_rewind_rounded, step: -1),
              _body(),
              verticalButton(icon: Icons.fast_forward_rounded, step: 1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              atividades[_index]['titulo'],
              style: const TextStyle(fontSize: 40),
            ),
            _stopwatch(),
            descricaoAtividade(),
            _controles(),
          ],
        ),
      ),
    );
  }

  Widget _stopwatch() {
    return StreamBuilder<int>(
      stream: _stopWatchTimer.rawTime,
      initialData: _stopWatchTimer.rawTime.value,
      builder: (context, snap) {
        final value = snap.data!;
        final displayTime = StopWatchTimer.getDisplayTime(
          value,
          hours: false,
          milliSecond: false,
        );
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                displayTime,
                style: const TextStyle(
                    fontSize: 100,
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget descricaoAtividade() {
    return Text(
      atividades[_index]['descricao'],
      style: const TextStyle(fontSize: 20),
    );
  }

  Widget _controles() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            defineAtividade();
          },
          icon: const Icon(Icons.restore),
          iconSize: 60,
        ),
        IconButton(
          onPressed: () {
            _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
          },
          icon: const Icon(Icons.stop),
          iconSize: 60,
        ),
        IconButton(
          onPressed: () {
            _stopWatchTimer.onExecute.add(StopWatchExecute.start);
          },
          icon: const Icon(Icons.play_arrow_rounded),
          iconSize: 60,
        ),
      ],
    );
  }

  Widget verticalButton({required IconData icon, required int step}) {
    return InkWell(
      onTap: () {
        changeIndex(step);
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  defineAtividade({bool continua = false}) {
    final time =
        StopWatchTimer.getMilliSecFromMinute(atividades[_index]['duracao']);
    _stopWatchTimer.clearPresetTime();
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    _stopWatchTimer.setPresetTime(mSec: time);
    if (continua) {
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    }
  }

  changeIndex(int sum, {bool continua = false}) {
    if (_index + sum >= 0 && _index + sum < atividades.length) {
      setState(() {
        _index += sum;
        defineAtividade(continua: continua);
      });
    }
  }
}
