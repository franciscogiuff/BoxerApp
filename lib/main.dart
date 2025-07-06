import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Entrenador de Box'),
    );
  }
}


class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final TextEditingController trabajoController = TextEditingController();
  final TextEditingController descansoController = TextEditingController();
  final TextEditingController roundsController = TextEditingController();

  Widget _buildEditableCard({
    required String title,
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          width: 64,
          height: 64,
          color: Colors.grey[300],
          child: const Icon(Icons.image, size: 32),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: hint,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  void _comenzar() {
    final trabajo = int.tryParse(trabajoController.text) ?? 0;
    final descanso = int.tryParse(descansoController.text) ?? 0;
    final rounds = int.tryParse(roundsController.text) ?? 0;

    if (trabajo > 0 && descanso > 0 && rounds > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => IntervalTimerScreen(
            trabajoSeg: trabajo,
            descansoSeg: descanso,
            rounds: rounds,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingresá todos los valores correctamente")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildEditableCard(
          title: "Trabajo en segundos",
          label: "Tiempo de trabajo",
          controller: trabajoController,
          hint: "Ej: 5",
        ),
        _buildEditableCard(
          title: "Tiempo de descanso en segundos",
          label: "Tiempo de descanso",
          controller: descansoController,
          hint: "Ej: 2",
        ),
        _buildEditableCard(
          title: "Cantidad de rounds",
          label: "Cantidad de rounds",
          controller: roundsController,
          hint: "Ej: 3",
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _comenzar,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            backgroundColor: Colors.indigo,
          ),
          child: const Text(
            "Comenzar",
            style: TextStyle(fontSize: 18),
          ),
        ),
        const Spacer(),
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.indigo),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text("https://www.linkedin.com/in/francisco-giuffrida/"),
        ),
      ],
    );
  }
}

class IntervalTimerScreen extends StatefulWidget {
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
  State<IntervalTimerScreen> createState() => _IntervalTimerScreenState();
}

class _IntervalTimerScreenState extends State<IntervalTimerScreen> {
  late int tiempoRestante;
  late int roundActual;
  bool esTrabajo = true;
  Timer? timer;
  bool enPausa = false;
  final player = AudioPlayer();
  bool hizoBeep = false;

  @override
  void initState() {
    super.initState();
    roundActual = 1;
    tiempoRestante = widget.trabajoSeg;
    iniciarTemporizador();
  }

  void iniciarTemporizador() {
    timer?.cancel();
    player.play(AssetSource('sounds/bell.mp3'));

    timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (!mounted || enPausa) return;

      final duracionActual = esTrabajo ? widget.trabajoSeg : widget.descansoSeg;

      setState(() {
        if (tiempoRestante > 0) {
          tiempoRestante--;

          // 🔔 Beep cuando quedan 10 segundos (solo si la etapa dura 10 segundos o más)
          if (duracionActual >= 10 && tiempoRestante == 10 && !hizoBeep) {
            player.play(AssetSource('sounds/beep.mp3'));
            hizoBeep = true;
          }
        } else {

          if (!esTrabajo && roundActual == widget.rounds) {
            timer?.cancel();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const FinalScreen()),
            );
            return;
          }

          if (!esTrabajo) roundActual++;

          esTrabajo = !esTrabajo;
          tiempoRestante = esTrabajo ? widget.trabajoSeg : widget.descansoSeg;
          hizoBeep = false;

          player.play(AssetSource('sounds/bell.mp3'));
        }
      });
    });
  }



  String formatTime(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  void togglePausa() {
    setState(() {
      enPausa = !enPausa;
    });
  }

  void volverAlMenu() {
    timer?.cancel();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    timer?.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textoEstado = roundActual > widget.rounds
        ? "Finalizado"
        : esTrabajo
        ? "¡A trabajar!"
        : "Descanso";

    return Scaffold(
      appBar: AppBar(title: const Text("Temporizador")),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: esTrabajo ? Colors.green[200] : Colors.red[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(textoEstado, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 16),
              Text(
                formatTime(tiempoRestante),
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                "Round ${roundActual > widget.rounds ? widget.rounds : roundActual} de ${widget.rounds}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: togglePausa,
                    icon: Icon(enPausa ? Icons.play_arrow : Icons.pause),
                    label: Text(enPausa ? "Reanudar" : "Pausar"),
                  ),
                  ElevatedButton.icon(
                    onPressed: volverAlMenu,
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

class FinalScreen extends StatelessWidget {
  const FinalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "¡Terminaste el turno!",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.home),
                label: const Text("Menú"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent  ,
        title: Text(widget.title),
      ),
      body: HomeBody(),
    );
  }
}
