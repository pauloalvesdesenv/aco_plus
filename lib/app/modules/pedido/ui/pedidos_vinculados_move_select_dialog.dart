import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/models/step_model.dart';
import 'package:aco_plus/app/core/components/app_text_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/pedido/ui/components/pedido_item_widget.dart';
import 'package:flutter/material.dart';

/// Dialog para seleção de pedidos vinculados que serão movidos para um step específico.
///
/// Uso:
/// ```dart
/// final List<PedidoModel>? pedidosSelecionados = await showDialog<List<PedidoModel>>(
///   context: context,
///   builder: (context) => PedidosVinculadosMoveSelectDialog(
///     pedido: pedidoAtual,
///     step: stepDestino,
///   ),
/// );
///
/// if (pedidosSelecionados != null && pedidosSelecionados.isNotEmpty) {
///   // Mover os pedidos selecionados para o step
///   for (final pedido in pedidosSelecionados) {
///     // Lógica para mover o pedido
///   }
/// }
/// ```

Future<List<PedidoModel>?> showPedidosVinculadosMoveSelectDialog(
  PedidoModel pedido,
  StepModel step,
) async {
  return await showDialog(
    context: contextGlobal,
    builder: (context) =>
        PedidosVinculadosMoveSelectDialog(pedido: pedido, step: step),
  );
}

class PedidosVinculadosMoveSelectDialog extends StatefulWidget {
  final PedidoModel pedido;
  final StepModel step;

  const PedidosVinculadosMoveSelectDialog({
    super.key,
    required this.pedido,
    required this.step,
  });

  @override
  State<PedidosVinculadosMoveSelectDialog> createState() =>
      _PedidosVinculadosMoveSelectDialogState();
}

class _PedidosVinculadosMoveSelectDialogState
    extends State<PedidosVinculadosMoveSelectDialog> {
  late List<PedidoModel> pedidosVinculados;
  late Set<String> selecionados;

  @override
  void initState() {
    super.initState();
    pedidosVinculados = widget.pedido.getPedidosVinculados();
    selecionados = <String>{};
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        height: 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryMain,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'MOVER PEDIDOS VINCULADOS',
                      style: AppCss.mediumRegular.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                // Step info
                            Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.step.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.step.color.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: widget.step.color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const W(8),
                    Text(
                      'Mover para: ${widget.step.name}',
                      style: AppCss.mediumBold.copyWith(color: widget.step.color),
                    ),
                  ],
                ),
                            ),
                            const H(16),

                            // Lista de pedidos
                            Expanded(
                child: pedidosVinculados.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.link_off,
                              size: 48,
                              color: AppColors.neutralMedium,
                            ),
                            const H(16),
                            Text(
                              'Nenhum pedido vinculado',
                              style: AppCss.mediumRegular.copyWith(
                                color: AppColors.neutralDark,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: pedidosVinculados.length,
                        separatorBuilder: (context, index) => const H(8),
                        itemBuilder: (context, index) {
                          final pedido = pedidosVinculados[index];
                          final isSelected = selecionados.contains(pedido.id);

                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryMain
                                    : AppColors.neutralLight,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: isSelected
                                  ? AppColors.primaryMain.withValues(alpha: 0.05)
                                  : Colors.white,
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selecionados.remove(pedido.id);
                                  } else {
                                    selecionados.add(pedido.id);
                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  // Checkbox
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primaryMain
                                            : Colors.white,
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primaryMain
                                              : AppColors.neutralMedium,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              size: 14,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                  ),

                                  // Pedido item
                                  Expanded(
                                    child: PedidoItemWidget(
                                      pedido: pedido,
                                      info: PedidoItemInfo.minified,
                                      onTap: (_) {
                                        setState(() {
                                          if (isSelected) {
                                            selecionados.remove(pedido.id);
                                          } else {
                                            selecionados.add(pedido.id);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                            ),

                            const H(16),
                  ],
                ),
              ),
            ),



            // Footer com botões
            Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppTextButton.outlined(
                      label: 'Cancelar',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const W(12),
                  Expanded(
                    child: AppTextButton(
                      label: 'Confirmar (${selecionados.length})',
                      onPressed: () {
                        final pedidosSelecionados = pedidosVinculados
                            .where((pedido) => selecionados.contains(pedido.id))
                            .toList();
                        Navigator.of(context).pop(pedidosSelecionados);
                      },
                      isEnable: selecionados.isNotEmpty,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
