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
  
  // Estado para controlar si los tiempos están en minutos
  bool trabajoEnMinutos = false;
  bool descansoEnMinutos = false;

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

  // Método para limpiar todos los campos
  void _limpiarCampos() {
    setState(() {
      trabajoController.clear();
      descansoController.clear();
      roundsController.clear();
      trabajoEnMinutos = false;
      descansoEnMinutos = false;
    });
  }

  // Método para establecer una configuración predefinida
  void _establecerConfiguracion(int trabajo, int descanso, int rounds, {required bool enMinutos}) {
    setState(() {
      // Establecer los valores directamente (sin conversión, ya vienen en la unidad correcta)
      trabajoController.text = trabajo.toString();
      descansoController.text = descanso.toString();
      roundsController.text = rounds.toString();
      
      // Establecer las unidades según corresponda
      trabajoEnMinutos = enMinutos;
      descansoEnMinutos = enMinutos;
    });
  }

  void _comenzar() {
    // Obtener los valores y convertir a segundos si están en minutos
    int trabajo = int.tryParse(trabajoController.text) ?? 0;
    int descanso = int.tryParse(descansoController.text) ?? 0;
    final rounds = int.tryParse(roundsController.text) ?? 0;
    
    // Convertir a segundos si están en minutos
    if (trabajoEnMinutos) {
      trabajo = trabajo * 60;
    }
    if (descansoEnMinutos) {
      descanso = descanso * 60;
    }

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botones de acción en la parte superior
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _comenzar,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Comenzar", style: TextStyle(fontSize: 16)),
                ),
                ElevatedButton(
                  onPressed: _limpiarCampos,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    backgroundColor: Colors.red[100],
                    foregroundColor: Colors.red[900],
                  ),
                  child: const Text('Borrar', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 20),
        EditableCard(
          title: "Duración del trabajo",
          label: "Tiempo de trabajo",
          controller: trabajoController,
          hint: "Ej: 5",
          showTimeSwitch: true,
          isMinutes: trabajoEnMinutos,
          onTimeUnitChanged: (isMinutes) {
            setState(() {
              trabajoEnMinutos = isMinutes;
            });
          },
        ),
        EditableCard(
          title: "Duración del descanso",
          label: "Tiempo de descanso",
          controller: descansoController,
          hint: "Ej: 2",
          showTimeSwitch: true,
          isMinutes: descansoEnMinutos,
          onTimeUnitChanged: (isMinutes) {
            setState(() {
              descansoEnMinutos = isMinutes;
            });
          },
        ),
        EditableCard(
          title: "Cantidad de rounds",
          label: "Cantidad de rounds",
          controller: roundsController,
          hint: "Ej: 3",
        ),
        const SizedBox(height: 20),
        // Título de configuraciones rápidas
        const Text('Configuraciones rápidas:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        
        // Configuraciones en minutos
        const Text('En minutos:', style: TextStyle(fontStyle: FontStyle.italic)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _establecerConfiguracion(3, 1, 5, enMinutos: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[100],
                foregroundColor: Colors.blue[900],
              ),
              child: const Text('3/1/5'),
            ),
            ElevatedButton(
              onPressed: () => _establecerConfiguracion(2, 1, 10, enMinutos: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[100],
                foregroundColor: Colors.green[900],
              ),
              child: const Text('2/1/10'),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Configuraciones en segundos
        const Text('En segundos:', style: TextStyle(fontStyle: FontStyle.italic)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _establecerConfiguracion(30, 10, 5, enMinutos: false),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[100],
                foregroundColor: Colors.purple[900],
              ),
              child: const Text('30/10/5'),
            ),
            ElevatedButton(
              onPressed: () => _establecerConfiguracion(20, 5, 10, enMinutos: false),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[100],
                foregroundColor: Colors.orange[900],
              ),
              child: const Text('20/5/10'),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        Container(
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
                child: const Row(
                  children: [
                    FaIcon(FontAwesomeIcons.linkedin, size: 20, color: Colors.indigo),
                    SizedBox(width: 8),
                    Text("Francisco Giuffrida", style: TextStyle(color: Colors.indigo)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
