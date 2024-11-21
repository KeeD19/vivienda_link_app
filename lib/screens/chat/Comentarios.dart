import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/Colors_Utils.dart';
import '../../utils/chat_bubble.dart';
import '../../utils/my_text_field.dart';
import '../../models/ComentariosModel.dart';
import '../../providers/Orders_provider.dart';

class ComentariosPage extends StatefulWidget {
  final List<Comentarios?> comentarios;
  final int idOrden;
  final int receverUserId;

  const ComentariosPage({super.key, required this.comentarios, required this.receverUserId, required this.idOrden});

  @override
  State<ComentariosPage> createState() => _ComentariosPageState();
}

class _ComentariosPageState extends State<ComentariosPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late OrdersProvider ordersProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Comentarios",
            style: TextStyle(
              color: AppColors.blueSecondColor,
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          iconTheme: const IconThemeData(
            color: AppColors.blueSecondColor,
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
      ),
    );
  }

  Widget _buildMessageList() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.comentarios.length,
      itemBuilder: (context, index) {
        var comentario = widget.comentarios[index];
        return _buildMessageItem(comentario!);
      },
    );
  }

  Widget _buildMessageItem(Comentarios data) {
    var alignment = (data.idUsuario == widget.receverUserId) ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data.idUsuario == widget.receverUserId) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: (data.idUsuario == widget.receverUserId) ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            ChatBubble(message: data.comentario, color: data.idUsuario == widget.receverUserId ? "send" : "received"),
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
      await ordersProvider.saveComent(widget.receverUserId, widget.idOrden, _messageController.text);
      // Crea un nuevo comentario localmente
      final nuevoComentario = Comentarios(
        idComentario: widget.idOrden,
        identificador: "Cliente",
        idTrabajo: widget.idOrden,
        idUsuario: widget.receverUserId,
        comentario: _messageController.text,
        // Agrega cualquier otro campo necesario para el objeto Comentarios
      );

      // Agrega el comentario a la lista local
      setState(() {
        widget.comentarios.add(nuevoComentario);
      });
      _messageController.clear();
      _scrollToBottom();
    }
  }
}
