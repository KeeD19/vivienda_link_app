import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EstadoSelectorDialog extends StatefulWidget {
  final String initialEstado;
  final String file;

  const EstadoSelectorDialog({Key? key, required this.initialEstado, required this.file}) : super(key: key);

  @override
  _EstadoSelectorDialogState createState() => _EstadoSelectorDialogState();
}

class _EstadoSelectorDialogState extends State<EstadoSelectorDialog> {
  String? selectedEstado;
  String? _imageBase64;
  final ImagePicker _picker = ImagePicker(); // Inicializa el selector de imágenes

  @override
  void initState() {
    super.initState();
    selectedEstado = widget.initialEstado;
    _imageBase64 = widget.file;
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBase64 = base64Encode(bytes);
      });
    }
  }

  Future<void> _takePhoto() async {
    try {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tomar Foto'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Elegir de la Galería'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      debugPrint("Error al abrir la cámara: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Selecciona un estado'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: selectedEstado,
            isExpanded: true,
            items: [
              'Pendiente',
              'En Progreso',
              'Completada',
            ].map((String estado) {
              return DropdownMenuItem<String>(
                value: estado,
                child: Text(estado),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedEstado = newValue;
              });
            },
          ),
          const SizedBox(height: 20),
          _imageBase64 != null
              ? Column(
                  children: [
                    Image.memory(
                      base64Decode(_imageBase64!),
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    // Image.file(_imageBase64!, height: 150, fit: BoxFit.cover),
                    const SizedBox(height: 10),
                  ],
                )
              : const Text('No se ha tomado evidencia.'),
          ElevatedButton.icon(
            onPressed: _takePhoto,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Tomar Foto'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cierra sin devolver nada
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop({
              'estado': selectedEstado,
              'evidencia': _imageBase64, // Devuelve la imagen capturada
            });
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
