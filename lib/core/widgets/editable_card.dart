import 'package:flutter/material.dart';

class EditableCard extends StatefulWidget {
  final String title;
  final String label;
  final TextEditingController controller;
  final String hint;
  final bool showTimeSwitch;
  final ValueChanged<bool>? onTimeUnitChanged;

  const EditableCard({
    super.key,
    required this.title,
    required this.label,
    required this.controller,
    required this.hint,
    this.showTimeSwitch = false,
    this.onTimeUnitChanged,
  });

  @override
  State<EditableCard> createState() => _EditableCardState();
}

class _EditableCardState extends State<EditableCard> {
  bool _isMinutes = false;

  void _onTimeUnitChanged(bool value) {
    setState(() {
      _isMinutes = value;
      // Convertir el valor si hay texto en el controlador
      if (widget.controller.text.isNotEmpty) {
        final currentValue = int.tryParse(widget.controller.text) ?? 0;
        if (value) {
          // Convertir a minutos (segundos / 60)
          widget.controller.text = (currentValue / 60).round().toString();
        } else {
          // Convertir a segundos (minutos * 60)
          widget.controller.text = (currentValue * 60).round().toString();
        }
      }
      // Llamar al callback si existe
      if (widget.onTimeUnitChanged != null) {
        widget.onTimeUnitChanged!(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.label, style: const TextStyle(fontWeight: FontWeight.bold)),
                if (widget.showTimeSwitch)
                  Row(
                    children: [
                      const Text('Seg'),
                      Switch(
                        value: _isMinutes,
                        onChanged: _onTimeUnitChanged,
                        activeColor: Colors.indigo,
                      ),
                      const Text('Min'),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(widget.title),
            const SizedBox(height: 8),
            TextField(
              controller: widget.controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: widget.hint,
                border: const OutlineInputBorder(),
                isDense: true,
                suffixText: _isMinutes ? 'min' : 'seg',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
