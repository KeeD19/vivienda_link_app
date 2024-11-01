import 'package:flutter/material.dart';
import 'package:vivienda_link_app/utils/Colors_Utils.dart';

class QualificationEmergent extends StatefulWidget {
  final void Function(int rating, String comment) onSubmitted;

  const QualificationEmergent({super.key, required this.onSubmitted});

  @override
  _QualificationEmergentState createState() => _QualificationEmergentState();
}

class _QualificationEmergentState extends State<QualificationEmergent> {
  int selectedRating = 0;
  TextEditingController commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _error = false;
  String _errorField = "";

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Califica al proveedor',
        style: TextStyle(color: AppColors.backgroundColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Selecciona una calificación:',
            style: TextStyle(
                color:
                    _error ? AppColors.errorColor : AppColors.backgroundColor),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < selectedRating ? Icons.star : Icons.star_border,
                  color: Colors.yellow[700],
                ),
                onPressed: () {
                  setState(() {
                    selectedRating = index + 1;
                    _error = false;
                  });
                },
              );
            }),
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: commentController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: _errorField == "" ? 'Comentario' : _errorField,
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
              if (selectedRating != 0) {
                if (commentController.text.isNotEmpty) {
                  widget.onSubmitted(selectedRating, commentController.text);
                  Navigator.pop(context);
                } else {
                  _errorField = "Ingrese un comentario";
                }
              } else {
                _error = true;
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
