import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:vivienda_link_app/models/CoberturasModel.dart';
import 'package:vivienda_link_app/models/ServiciosModel.dart';
import 'package:vivienda_link_app/utils/AddSolicitudEmergent.dart';
import 'package:vivienda_link_app/utils/Colors_Utils.dart';
import '../models/FilterOptionsModel.dart';
import '../models/ServiciosPopularModel.dart';
import 'ScaffoldMessengerUtil.dart';
import 'SquareInfo.dart';
// import '../providers/Orders_provider.dart';

class DetailsPopularOption extends StatefulWidget {
  // final void Function(String status) onSubmitted;
  final ServiciosPopularModel options;
  const DetailsPopularOption({super.key, required this.options});

  @override
  // ignore: library_private_types_in_public_api
  _DetailsPopularOptionState createState() => _DetailsPopularOptionState();
}

class _DetailsPopularOptionState extends State<DetailsPopularOption> {
  CoberturasModel? _coberturaSelect;
  String _error = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _generarPeticion(ServiciosPopularModel option, ServiciosModel service, CoberturasModel cobertura) {
    debugPrint('Cobertura: ${cobertura.estado}');
    FilterOptionsModel filtro = FilterOptionsModel(
        idServicio: service.id,
        nombreServicio: service.nombreServicio,
        monto: service.monto,
        idProveedor: option.idProveedor,
        nombreProvedor: option.nombreProvedor,
        selfie: option.selfie,
        minHoras: option.minHoras,
        precioTotal: option.minHoras * service.monto,
        estrellas: option.estrellas,
        cobertura: {"idCobertura": cobertura.idCobertura, "pais": cobertura.pais, "estado": cobertura.estado, "municipio": cobertura.municipio});
    try {
      debugPrint('termino el mapeo: $filtro');
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AddSolicitudEmergent(
            onSubmitted: (status) async {},
            options: filtro,
          );
        },
      );
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _selectCobertura(CoberturasModel cobertura) {
    _coberturaSelect = cobertura;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondColor,
      appBar: AppBar(
        title: const Text(
          // 'Detalles de: ${widget.options.nombreProvedor}',
          'Detalles de:',
          style: TextStyle(
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: squareInfo(icon: Icons.monetization_on, title: "Proveedor:", desc: widget.options.nombreProvedor, type: "Selfie", selfie: widget.options.selfie),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: squareInfo(icon: Icons.star, title: "Calificación:", desc: widget.options.estrellas.toStringAsFixed(2), type: "Icon", selfie: ""),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: squareInfo(icon: Icons.timer, title: "Tiempo minimo de trabajo:", desc: '${widget.options.minHoras} horas', type: "Icon", selfie: ""),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Cobertura(s): ",
                style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.options.cobertura.length,
                itemBuilder: (context, index) {
                  final opcion = widget.options.cobertura[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppColors.border),
                    ),
                    color: AppColors.white,
                    child: ListTile(
                      title: Text(
                        "${opcion.municipio}, ${opcion.estado}, ${opcion.pais}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(opcion.cp),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        setState(() {
                          _selectCobertura(opcion);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            // SizedBox(
            //   height: 200,
            //   child: ListView.builder(
            //     itemCount: widget.options.cobertura.length,
            //     itemBuilder: (context, index) {
            //       final opcion = widget.options.cobertura[index];
            //       // return Text("${opcion.municipio}, ${opcion.estado}, ${opcion.pais}, ${opcion.cp}", style: const TextStyle(fontSize: 14));
            //       return Card(
            //         margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(AppColors.border),
            //         ),
            //         color: AppColors.white,
            //         child: ListTile(
            //           title: Text("${opcion.municipio}, ${opcion.estado}, ${opcion.pais}", style: const TextStyle(fontSize: 14)),
            //           subtitle: Text(opcion.cp),
            //           trailing: const Icon(Icons.arrow_forward_ios, size: 15, color: Colors.grey),
            //           onTap: () {
            //             setState(() {
            //               setState(() {
            //                 _selectCobertura(opcion);
            //               });
            //             });
            //           },
            //         ),
            //       );
            //     },
            //   ),
            // ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Servicio(s): ",
                style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.options.servicios.length,
                itemBuilder: (context, index) {
                  final opcion = widget.options.servicios[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    color: AppColors.white,
                    child: ListTile(
                      title: Text(opcion.nombreServicio, style: const TextStyle(fontSize: 14)),
                      subtitle: Text("Precio por trabajo: \$${opcion.monto * widget.options.minHoras}"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 15, color: Colors.grey),
                      onTap: () {
                        setState(() {
                          setState(() {
                            if (_coberturaSelect?.idCobertura != null) {
                              _generarPeticion(widget.options, opcion, _coberturaSelect!);
                            } else {
                              showCustomSnackBar(context, "Seleccione una cobertura", isError: true);
                              // _error = "Seleccione un lugar de servicio";
                            }
                          });
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
