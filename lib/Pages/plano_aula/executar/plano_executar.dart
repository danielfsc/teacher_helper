import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class PlanoExecutar extends StatefulWidget {
  final dynamic plano;
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

  // final _scrollController = ScrollController();

  @override
  void initState() {
    _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: StopWatchTimer.getMilliSecFromMinute(0),
      onEnded: () => changeIndex(1, continua: true),
    );

    atividades = widget.plano['atividades'];
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
        title: Text(widget.plano['titulo']),
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

  // Widget lixo() {
  //   return Column(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.all(2),
  //         child: Column(
  //           children: <Widget>[
  //             Padding(
  //               padding: const EdgeInsets.only(bottom: 0),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: <Widget>[
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 4),
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         primary: Colors.lightBlue,
  //                         onPrimary: Colors.white,
  //                         shape: const StadiumBorder(),
  //                       ),
  //                       onPressed: () async {
  //                         _stopWatchTimer.onExecute.add(StopWatchExecute.start);
  //                       },
  //                       child: const Text(
  //                         'Start',
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 4),
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         primary: Colors.green,
  //                         onPrimary: Colors.white,
  //                         shape: const StadiumBorder(),
  //                       ),
  //                       onPressed: () async {
  //                         _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
  //                       },
  //                       child: const Text(
  //                         'Stop',
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 4),
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         primary: Colors.red,
  //                         onPrimary: Colors.white,
  //                         shape: const StadiumBorder(),
  //                       ),
  //                       onPressed: () async {
  //                         _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
  //                       },
  //                       child: const Text(
  //                         'Reset',
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 4),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: <Widget>[
  //                   Padding(
  //                     padding: const EdgeInsets.all(0).copyWith(right: 8),
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         primary: Colors.deepPurpleAccent,
  //                         onPrimary: Colors.white,
  //                         shape: const StadiumBorder(),
  //                       ),
  //                       onPressed: () async {
  //                         _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
  //                       },
  //                       child: const Text(
  //                         'Lap',
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.all(0),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: <Widget>[
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 4),
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         primary: Colors.pinkAccent,
  //                         onPrimary: Colors.white,
  //                         shape: const StadiumBorder(),
  //                       ),
  //                       onPressed: () async {
  //                         _stopWatchTimer.setPresetHoursTime(1);
  //                       },
  //                       child: const Text(
  //                         'Set Hours',
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 4),
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         primary: Colors.pinkAccent,
  //                         onPrimary: Colors.white,
  //                         shape: const StadiumBorder(),
  //                       ),
  //                       onPressed: () async {
  //                         _stopWatchTimer.setPresetMinuteTime(59);
  //                       },
  //                       child: const Text(
  //                         'Set Minute',
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 4),
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         primary: Colors.pinkAccent,
  //                         onPrimary: Colors.white,
  //                         shape: const StadiumBorder(),
  //                       ),
  //                       onPressed: () async {
  //                         _stopWatchTimer.setPresetSecondTime(10);
  //                       },
  //                       child: const Text(
  //                         'Set Second',
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 4),
  //               child: ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   primary: Colors.pinkAccent,
  //                   onPrimary: Colors.white,
  //                   shape: const StadiumBorder(),
  //                 ),
  //                 onPressed: () async {
  //                   _stopWatchTimer.setPresetTime(mSec: 3599 * 1000);
  //                 },
  //                 child: const Text(
  //                   'Set PresetTime',
  //                   style: TextStyle(color: Colors.white),
  //                 ),
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 4),
  //               child: ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                   primary: Colors.pinkAccent,
  //                   onPrimary: Colors.white,
  //                   shape: const StadiumBorder(),
  //                 ),
  //                 onPressed: () async {
  //                   _stopWatchTimer.clearPresetTime();
  //                 },
  //                 child: const Text(
  //                   'Clear PresetTime',
  //                   style: TextStyle(color: Colors.white),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget verticalButton({required IconData icon, required int step}) {
    return InkWell(
      // splashColor: Colors.blue.withAlpha(30),
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
