import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/MensajesModel.dart';
import '../../providers/Auth_provider.dart';
import '../../providers/Provedor_provider.dart';
import '../../utils/Colors_Utils.dart';
import '../../utils/SpinnerLoader.dart';
import '../../utils/chat_bubble.dart';
import '../../utils/my_text_field.dart';
import '../../providers/Orders_provider.dart';

class ChatViewPage extends StatefulWidget {
  final int idProveedor;
  final int idCliente;
  final String proveedor;

  const ChatViewPage({super.key, required this.idProveedor, required this.idCliente, required this.proveedor});

  @override
  State<ChatViewPage> createState() => _ChatViewPageState();
}

class _ChatViewPageState extends State<ChatViewPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late OrdersProvider ordersProvider;
  late int _idProveedor;
  late int _idCliente;
  late String _identificador;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    _idProveedor = widget.idProveedor;
    _idCliente = widget.idCliente;
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    authProvider.getTypeUser();
    if (authProvider.typeUser == 3) {
      _identificador = "Cliente";
      ordersProvider.getChat(_idProveedor, _idCliente, "Cliente");
    } else {
      _identificador = "Proveedor";
      ordersProvider.getChat(_idProveedor, _idCliente, "Proveedor");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrdersProvider>(
      builder: (context, ordersProvider, child) {
        // const spiner = Spinner();
        return Scaffold(
            appBar: AppBar(
                title: Text(
                  widget.proveedor,
                  style: const TextStyle(
                    color: AppColors.white,
                  ),
                ),
                backgroundColor: AppColors.backgroundColor,
                iconTheme: const IconThemeData(
                  color: AppColors.white,
                )),
            body: Column(
              children: [
                Expanded(
                  child: _buildMessageList(),
                ),
                _buildMessageInput(),
                const SizedBox(
                  height: 25,
                )
              ],
            ));
      },
    );
  }

  Widget _buildMessageList() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    return ListView.builder(
      controller: _scrollController,
      itemCount: ordersProvider.dataChatMessagge.length,
      itemBuilder: (context, index) {
        var mensaje = ordersProvider.dataChatMessagge[index];
        return _buildMessageItem(mensaje);
      },
    );
  }

  Widget _buildMessageItem(Mensajes data) {
    var alignment = (data.identificador == _identificador) ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data.identificador == _identificador) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: (data.identificador == _identificador) ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            ChatBubble(message: data.contenido, color: data.identificador == _identificador ? "send" : "received"),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Escribe un mensaje",
              obscureText: false,
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.send,
              size: 45,
            ),
            color: AppColors.orangeColor,
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final nuevoMensaje = Mensajes(
        idMensajes: 0,
        contenido: _messageController.text,
        idCliente: _idCliente,
        idProveedor: _idProveedor,
        created_at: "",
        identificador: _identificador,
        status: "Enviado",
        // Añade otros atributos si es necesario
      );
      await ordersProvider.saveMessage(widget.idProveedor, widget.idCliente, _messageController.text, _identificador);
      setState(() {
        ordersProvider.dataChatMessagge.add(nuevoMensaje);
      });
      _messageController.clear();
      // _scrollToBottom();
      // Provider.of<OrdersProvider>(context, listen: false).getChat(_idProveedor);
    }
  }
}
