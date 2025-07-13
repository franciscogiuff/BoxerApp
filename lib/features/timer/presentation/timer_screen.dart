import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Asegurate de agregar provider en pubspec.yaml
import '../../../core/utils/time_formatter.dart';
import '../../final/final_screen.dart';
import '../controller/timer_controller.dart';

class IntervalTimerScreen extends StatelessWidget {
  final int trabajoSeg;
  final int descansoSeg;
  final int rounds;

  const IntervalTimerScreen({
    super.key,
    required this.trabajoSeg,
    required this.descansoSeg,
    required this.rounds,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TimerController(
        trabajoSeg: trabajoSeg,
        descansoSeg: descansoSeg,
        rounds: rounds,
        onFinalizado: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const FinalScreen()),
          );
        },
      ),
      child: const TimerScreenView(),
    );
  }
}

class TimerScreenView extends StatelessWidget {
  const TimerScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TimerController>();

    final textoEstado = controller.roundActual > controller.rounds
        ? "Finalizado"
        : controller.esTrabajo
        ? "¡A trabajar!"
        : "Descanso";

    return Scaffold(
      appBar: AppBar(title: const Text("Temporizador")),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: controller.esTrabajo ? Colors.green[200] : Colors.red[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(textoEstado, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 16),
              Text(
                formatTime(controller.tiempoRestante),
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                "Round ${controller.roundActual > controller.rounds ? controller.rounds : controller.roundActual} de ${controller.rounds}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: controller.togglePausa,
                    icon: Icon(controller.enPausa ? Icons.play_arrow : Icons.pause),
                    label: Text(controller.enPausa ? "Reanudar" : "Pausar"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      controller.cancelar();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.home),
                    label: const Text("Menú"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
