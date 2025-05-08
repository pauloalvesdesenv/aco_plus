import 'package:aco_plus/app/core/client/firestore/collections/usuario/models/usuario_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_avatar.dart';
import 'package:aco_plus/app/core/components/app_text_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';

class CommentAddWidget extends StatefulWidget {
  final void Function(String, List<UsuarioModel>) onSave;
  const CommentAddWidget({required this.onSave, super.key});

  @override
  State<CommentAddWidget> createState() => _CommentAddWidgetState();
}

class _CommentAddWidgetState extends State<CommentAddWidget> {
  bool _isEditing = false;
  GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();
  final FocusNode focusNode = FocusNode();
  String get getText => key.currentState?.controller?.text ?? '';

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () {
      focusNode.requestFocus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppAvatar(name: usuario.nome),
        const W(16),
        Expanded(child: _isEditing ? _editingWidget() : _noEditingWidget()),
      ],
    );
  }

  Widget _editingWidget() {
    return StreamOut(
      stream: FirestoreClient.usuarios.dataStream.listen,
      builder:
          (context, usuarios) => Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PortalEntry(
                portalAnchor: Alignment.topCenter,
                childAnchor: Alignment.bottomCenter,
                visible: false,
                child: FlutterMentions(
                  key: key,
                  autofocus: true,
                  focusNode: focusNode,
                  suggestionPosition: SuggestionPosition.Top,
                  enableInteractiveSelection: true,
                  enableSuggestions: true,
                  maxLines: 5,
                  minLines: 1,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Escreva um comentário...',
                  ),
                  onChanged: (value) => setState(() {}),
                  suggestionListDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  mentions: [
                    Mention(
                      suggestionBuilder:
                          (data) => Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Text(data['display']),
                          ),
                      trigger: '@',
                      matchAll: true,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      data:
                          usuarios
                              .where((e) => e.id != usuario.id)
                              .map((e) => e.toMention())
                              .toList(),
                    ),
                  ],
                ),
              ),
              const H(8),
              SizedBox(
                width: 100,
                child: AppTextButton(
                  isEnable: getText.isNotEmpty,
                  onPressed: () {
                    setState(() {
                      List<UsuarioModel> mentioneds = [];
                      for (var users in FirestoreClient.usuarios.data.where(
                        (e) => e.id != usuario.id,
                      )) {
                        if (getText.contains('@${users.nome}')) {
                          mentioneds.add(users);
                        }
                      }
                      widget.onSave(getText, mentioneds);
                      _isEditing = false;
                    });
                  },
                  label: 'Salvar',
                ),
              ),
            ],
          ),
    );
  }

  Widget _noEditingWidget() => InkWell(
    onTap:
        () => setState(() {
          _isEditing = true;
        }),
    child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.maxFinite,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'Escrever um comentário...',
        style: AppCss.mediumRegular.copyWith(fontSize: 16),
      ),
    ),
  );
}
