import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/tag/models/tag_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

Future<TagModel?> showPedidoTagBottom(PedidoModel pedido) async =>
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: contextGlobal,
      isScrollControlled: true,
      builder: (_) => TagModelBottom(pedido),
    );

class TagModelBottom extends StatefulWidget {
  final PedidoModel pedido;
  const TagModelBottom(this.pedido, {super.key});

  @override
  State<TagModelBottom> createState() => _TagModelBottomState();
}

class _TagModelBottomState extends State<TagModelBottom> {
  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder:
          (context) => KeyboardVisibilityBuilder(
            builder: (context, isVisible) {
              return Container(
                height: 390,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: ListView(
                  children: [
                    const H(16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: IconButton(
                          style: ButtonStyle(
                            padding: const WidgetStatePropertyAll(
                              EdgeInsets.all(16),
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              AppColors.white,
                            ),
                            foregroundColor: WidgetStatePropertyAll(
                              AppColors.black,
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.keyboard_backspace),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Adicionar Etiqueta', style: AppCss.largeBold),
                          const H(16),
                          Wrap(
                            runSpacing: 8,
                            spacing: 8,
                            children: [
                              for (var tag
                                  in FirestoreClient.tags.data
                                      .where(
                                        (e) =>
                                            !pedido.tags
                                                .map((e) => e.id)
                                                .contains(e.id),
                                      )
                                      .toList())
                                InkWell(
                                  onTap: () => Navigator.pop(context, tag),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: tag.color.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      tag.nome,
                                      style: AppCss.mediumRegular.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: tag.color,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }
}
