import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/MensajesModel.dart';
import '../../utils/Colors_Utils.dart';
import '../../utils/SpinnerLoader.dart';
import '../../utils/chat_bubble.dart';
import '../../utils/my_text_field.dart';
import '../../providers/Orders_provider.dart';

class ChatViewPage extends StatefulWidget {
  final int idProveedor;
  final String proveedor;

  const ChatViewPage(
      {super.key, required this.idProveedor, required this.proveedor});

  @override
  State<ChatViewPage> createState() => _ChatViewPageState();
}

class _ChatViewPageState extends State<ChatViewPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late OrdersProvider ordersProvider;
  late int _idProveedor;
  // final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    _idProveedor = widget.idProveedor;
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    ordersProvider.getChat(
        _idProveedor); // Llamar al método getOrders al iniciar la pantalla
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
        final spiner = Spinner();
        return Scaffold(
            appBar: AppBar(
                title: Text(
                  widget.proveedor,
                  style: const TextStyle(
                    color: AppColors.blueSecondColor,
                  ),
                ),
                backgroundColor: AppColors.backgroundColor,
                iconTheme: const IconThemeData(
                  color: AppColors.blueSecondColor,
                )),
            body: ordersProvider.isLoading
                ? Center(child: spiner)
                : Column(
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
    var alignment = (data.identificador == "Cliente")
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data.identificador == "Cliente")
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: (data.identificador == "Cliente")
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            ChatBubble(
                message: data.contenido,
                color: data.identificador == "Cliente" ? "send" : "received"),
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
              hintText: "Enter message",
              obscureText: false,
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.send,
              size: 40,
            ),
            color: AppColors.bluePrimaryColor,
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
        idCliente: 0,
        idProveedor: _idProveedor,
        created_at: "",
        identificador: "Cliente",
        status: "Enviado",
        // Añade otros atributos si es necesario
      );
      await ordersProvider.saveMessage(
          widget.idProveedor, _messageController.text);
      setState(() {
        ordersProvider.dataChatMessagge.add(nuevoMensaje);
      });
      _messageController.clear();
      // _scrollToBottom();
      // Provider.of<OrdersProvider>(context, listen: false).getChat(_idProveedor);
    }
  }
}
