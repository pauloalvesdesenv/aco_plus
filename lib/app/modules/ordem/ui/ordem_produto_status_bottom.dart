import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/components/app_text_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

Future<PedidoProdutoStatus?> showOrdemProdutoStatusBottom(
  PedidoProdutoStatus status,
) async => showModalBottomSheet(
  backgroundColor: AppColors.white,
  context: contextGlobal,
  isScrollControlled: true,
  builder: (_) => OrdemProdutoStatusBottom(status),
);

class OrdemProdutoStatusBottom extends StatefulWidget {
  final PedidoProdutoStatus status;
  const OrdemProdutoStatusBottom(this.status, {super.key});

  @override
  State<OrdemProdutoStatusBottom> createState() =>
      _OrdemProdutoStatusBottomState();
}

class _OrdemProdutoStatusBottomState extends State<OrdemProdutoStatusBottom> {
  late PedidoProdutoStatus currentStatus;

  @override
  void initState() {
    currentStatus = widget.status;
    super.initState();
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) => KeyboardVisibilityBuilder(
        builder: (context, isVisible) {
          return Container(
            height: 400,
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
                      const H(16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (var status in pedidoProdutoStatusValues)
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: status.color.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: RadioListTile<PedidoProdutoStatus>(
                                title: Text(
                                  status.label,
                                  style: AppCss.mediumRegular,
                                ),
                                value: status,
                                groupValue:
                                    currentStatus ==
                                        PedidoProdutoStatus.separado
                                    ? PedidoProdutoStatus.aguardandoProducao
                                    : currentStatus,
                                onChanged: (value) {
                                  setState(() {
                                    currentStatus = value!;
                                  });
                                },
                              ),
                            ),
                          const H(16),
                          AppTextButton(
                            label: 'Confirmar',
                            onPressed: () =>
                                Navigator.pop(context, currentStatus),
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
