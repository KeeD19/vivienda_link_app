import 'package:flutter/material.dart';
import 'package:vivienda_link_app/utils/Colors_Utils.dart';

class ReportEmergent extends StatefulWidget {
  final void Function(String motivoReporte) onSubmitted;

  const ReportEmergent({super.key, required this.onSubmitted});

  @override
  _ReportEmergentState createState() => _ReportEmergentState();
}

class _ReportEmergentState extends State<ReportEmergent> {
  TextEditingController motivoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _errorField = "";

  @override
  void dispose() {
    motivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Reporta al proveedor',
        style: TextStyle(color: AppColors.backgroundColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              controller: motivoController,
              maxLines: 10,
              decoration: InputDecoration(
                labelText: _errorField == "" ? 'Reporte' : _errorField,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return _errorField;
                }
                return null;
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              AppColors.errorColor,
            ),
          ),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              if (motivoController.text.isNotEmpty) {
                widget.onSubmitted(motivoController.text);
                Navigator.pop(context);
              } else {
                _errorField = "Ingrese el reporte";
              }
            });
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              AppColors.backgroundColor,
            ),
          ),
          child: const Text(
            'Enviar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
