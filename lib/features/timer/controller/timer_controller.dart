import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class TimerController extends ChangeNotifier {
  final int trabajoSeg;
  final int descansoSeg;
  final int rounds;
  final VoidCallback onFinalizado;

  late int tiempoRestante;
  late int roundActual;
  late bool esTrabajo;
  late bool enPausa;

  Timer? _timer;
  final _player = AudioPlayer();
  bool _hizoBeep = false;

  TimerController({
    required this.trabajoSeg,
    required this.descansoSeg,
    required this.rounds,
    required this.onFinalizado,
  }) {
    _inicializar();
  }

  void _inicializar() {
    roundActual = 1;
    esTrabajo = true;
    enPausa = false;
    tiempoRestante = trabajoSeg;
    _iniciarTemporizador();
  }

  void _iniciarTemporizador() {
    _timer?.cancel();
    _player.play(AssetSource('sounds/bell.mp3'));

    _timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (enPausa) return;

      final duracionActual = esTrabajo ? trabajoSeg : descansoSeg;

      if (tiempoRestante > 0) {
        tiempoRestante--;

        if (duracionActual >= 10 && tiempoRestante == 10 && !_hizoBeep) {
          _player.play(AssetSource('sounds/beep.mp3'));
          _hizoBeep = true;
        }
      } else {
        if (esTrabajo && roundActual == rounds) {
          _finalizar();
          return;
        }

        if (!esTrabajo) roundActual++;

        esTrabajo = !esTrabajo;
        tiempoRestante = esTrabajo ? trabajoSeg : descansoSeg;
        _hizoBeep = false;

        _player.play(AssetSource('sounds/bell.mp3'));
      }

      notifyListeners();
    });
  }

  void togglePausa() {
    enPausa = !enPausa;
    notifyListeners();
  }

  void _finalizar() {
    _timer?.cancel();
    _player.dispose();
    onFinalizado();
  }

  void cancelar() {
    _timer?.cancel();
    _player.dispose();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    super.dispose();
  }
}
