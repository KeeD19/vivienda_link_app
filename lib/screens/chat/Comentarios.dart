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
  final String identificador;

  const ComentariosPage({super.key, required this.comentarios, required this.receverUserId, required this.idOrden, required this.identificador});

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
    var alignment = (data.identificador == widget.identificador) ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data.identificador == widget.identificador) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: (data.identificador == widget.identificador) ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            ChatBubble(message: data.comentario, color: data.identificador == widget.identificador ? "send" : "received"),
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
              hintText: "Escribe un comentario",
              obscureText: false,
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.send,
              size: 40,
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
      await ordersProvider.saveComent(widget.receverUserId, widget.idOrden, _messageController.text, widget.identificador);
      // Crea un nuevo comentario localmente
      final nuevoComentario = Comentarios(
        idComentario: widget.idOrden,
        identificador: widget.identificador,
        idTrabajo: widget.idOrden,
        idUsuario: widget.receverUserId,
        comentario: _messageController.text,
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
