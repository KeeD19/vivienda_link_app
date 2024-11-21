import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vivienda_link_app/utils/Colors_Utils.dart';

class FilterOptionsEmergent extends StatefulWidget {
  final void Function(String pais, String estado, String municipio, String presupuesto) onSubmitted;

  const FilterOptionsEmergent({super.key, required this.onSubmitted});

  @override
  _FilterOptionsEmergentState createState() => _FilterOptionsEmergentState();
}

class _FilterOptionsEmergentState extends State<FilterOptionsEmergent> {
  TextEditingController paisController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController municipioController = TextEditingController();
  TextEditingController presupuestoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _errorpais = "";
  String _errorEstado = "";
  String _errorMunicipio = "";
  String _errorPresupuesto = "";

  @override
  void dispose() {
    paisController.dispose();
    estadoController.dispose();
    municipioController.dispose();
    presupuestoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Filtro de busqueda',
        style: TextStyle(color: AppColors.backgroundColor),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: paisController,
                      // maxLines: 5,
                      decoration: InputDecoration(
                        labelText: _errorpais == "" ? 'País' : _errorpais,
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: _errorpais == "" ? const BorderSide(color: AppColors.bluePrimaryColor) : const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return _errorpais;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: estadoController,
                      // maxLines: 5,
                      decoration: InputDecoration(
                        labelText: _errorEstado == "" ? 'Estado' : _errorEstado,
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: _errorEstado == "" ? const BorderSide(color: AppColors.bluePrimaryColor) : const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return _errorEstado;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: municipioController,
                      // maxLines: 5,
                      decoration: InputDecoration(
                        labelText: _errorMunicipio == "" ? 'Municipio' : _errorMunicipio,
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: _errorMunicipio == "" ? const BorderSide(color: AppColors.bluePrimaryColor) : const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return _errorMunicipio;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: presupuestoController,
                      keyboardType: TextInputType.number, // Activa el teclado numérico
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // Solo permite dígitos (números)
                      ],
                      decoration: InputDecoration(
                        labelText: _errorPresupuesto == "" ? 'Presupuesto' : _errorPresupuesto,
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: _errorPresupuesto == "" ? const BorderSide(color: AppColors.bluePrimaryColor) : const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return _errorPresupuesto;
                        }
                        return null;
                      },
                    ),
                  ],
                )),
          ],
        ),
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
              if (paisController.text.isNotEmpty) {
                if (estadoController.text.isNotEmpty) {
                  if (municipioController.text.isNotEmpty) {
                    if (presupuestoController.text.isNotEmpty) {
                      widget.onSubmitted(paisController.text, estadoController.text, municipioController.text, presupuestoController.text);
                      Navigator.pop(context);
                    } else {
                      _errorPresupuesto = "Ingrese un presupuesto";
                    }
                  } else {
                    _errorMunicipio = "ingrese municipio";
                  }
                } else {
                  _errorEstado = "Ingrese un estado";
                }
              } else {
                _errorpais = "Ingresa la dirección";
              }
            });
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              AppColors.backgroundColor,
            ),
          ),
          child: const Text(
            'Buscar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
