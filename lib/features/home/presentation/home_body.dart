import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/widgets/editable_card.dart';
import '../../timer/presentation/timer_screen.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final TextEditingController trabajoController = TextEditingController();
  final TextEditingController descansoController = TextEditingController();
  final TextEditingController roundsController = TextEditingController();

  void _abrirLinkedIn() async {
    final url = Uri.parse("https://www.linkedin.com/in/francisco-giuffrida/");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo abrir el enlace de LinkedIn")),
      );
    }
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
        EditableCard(
          title: "Trabajo en segundos",
          label: "Tiempo de trabajo",
          controller: trabajoController,
          hint: "Ej: 5",
        ),
        EditableCard(
          title: "Tiempo de descanso en segundos",
          label: "Tiempo de descanso",
          controller: descansoController,
          hint: "Ej: 2",
        ),
        EditableCard(
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
            foregroundColor: Colors.white,
          ),
          child: const Text(
            "Comenzar",
            style: TextStyle(fontSize: 18),
          ),
        ),
        const Spacer(),
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.indigo),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _abrirLinkedIn,
                child: const FaIcon(
                  FontAwesomeIcons.linkedin,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Desarrollado por Francisco Giuffrida",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
