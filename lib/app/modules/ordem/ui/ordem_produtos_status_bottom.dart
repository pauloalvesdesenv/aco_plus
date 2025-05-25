import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

Future<PedidoProdutoStatus?> showOrdemProdutosStatusBottom() async =>
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: contextGlobal,
      isScrollControlled: true,
      builder: (_) => const OrdemProdutosStatusBottom(),
    );

class OrdemProdutosStatusBottom extends StatefulWidget {
  const OrdemProdutosStatusBottom({super.key});

  @override
  State<OrdemProdutosStatusBottom> createState() =>
      _OrdemProdutosStatusBottomState();
}

class _OrdemProdutosStatusBottomState extends State<OrdemProdutosStatusBottom> {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) => KeyboardVisibilityBuilder(
        builder: (context, isVisible) {
          return Container(
            height: 360,
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
                      Text('Selecione o Status', style: AppCss.largeBold),
                      Text(
                        'Todos os produtos serão alterados para o status selecionado',
                        style: AppCss.minimumRegular,
                      ),
                      const H(16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (var status in pedidoProdutoStatusValues)
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: status.color),
                                color: status.color.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: ListTile(
                                onTap: () => Navigator.pop(context, status),
                                title: Text(
                                  status.label,
                                  style: AppCss.mediumRegular,
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: status.color.withValues(alpha: 0.3),
                                    border: Border.all(color: status.color),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: status.color,
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
