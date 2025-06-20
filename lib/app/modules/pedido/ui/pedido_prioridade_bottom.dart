import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_prioridade_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/app_drop_down.dart';
import 'package:aco_plus/app/core/components/app_text_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/enums/fill.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Future<PedidoModel?> showPedidoPrioridadeBottom(PedidoModel pedido) async =>
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: contextGlobal,
      isScrollControlled: true,
      builder: (_) => PedidoPrioridadeBottom(pedido),
      isDismissible: false,
    );

class PedidoPrioridadeBottom extends StatefulWidget {
  final PedidoModel pedido;
  const PedidoPrioridadeBottom(this.pedido, {super.key});

  @override
  State<PedidoPrioridadeBottom> createState() => _PedidoPrioridadeBottomState();
}

class _PedidoPrioridadeBottomState extends State<PedidoPrioridadeBottom> {
  @override
  void initState() {
    pedidoCtrl.onInitPrioridade(widget.pedido);
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
      builder: (context) => Container(
        height: 500,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            const H(16),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: IconButton(
                  style: ButtonStyle(
                    padding: const WidgetStatePropertyAll(EdgeInsets.all(16)),
                    backgroundColor: WidgetStatePropertyAll(AppColors.white),
                    foregroundColor: WidgetStatePropertyAll(AppColors.black),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.keyboard_backspace),
                ),
              ),
            ),
            Expanded(
              child: StreamOut(
                stream: pedidoCtrl.formPrioridadeStream.listen,
                builder: (context, form) {
                  final pedidoSelected = form.pedidos.firstWhere(
                    (e) => e.id == widget.pedido.id,
                  );
                  return ListView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    children: [
                      Text('Prioridade', style: AppCss.largeBold),
                      const H(16),
                      AppDropDown<PedidoPrioridadeTipo?>(
                        label: 'Tipo',
                        item: pedidoSelected.prioridade?.tipo,
                        itens: PedidoPrioridadeTipo.values,
                        itemLabel: (e) => e?.getLabel() ?? 'Selecione',
                        onSelect: (e) {
                          if (e != null) {
                            pedidoCtrl.onSelectPrioridadeTipo(
                              widget.pedido,
                              e,
                            );
                          }
                        },
                      ),
                      Gap(16),
                      Text('Posição:*', style: AppCss.smallBold),
                      const H(4),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.neutralLight),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        width: double.infinity,
                        height: 300,
                        child: ReorderableListView.builder(
                          buildDefaultDragHandles: false,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          cacheExtent: 200,
                          itemCount: form.pedidos.length,
                          onReorder: (oldIndex, newIndex) {
                            if (newIndex > oldIndex) {
                              newIndex = newIndex - 1;
                            }
                            final step = form.pedidos.removeAt(oldIndex);
                            form.pedidos.insert(newIndex, step);
                            pedidoCtrl.onReorderPrioridade(form.pedidos);
                            pedidoCtrl.formPrioridadeStream.update();
                          },
                          itemBuilder: (_, i) =>
                              form.pedidos[i].id == widget.pedido.id
                              ? ReorderableDragStartListener(
                                  key: ValueKey(form.pedidos[i].id),
                                  index: i,
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.move,
                                    child: _itemPedidoPrioridadeWidget(
                                      i,
                                      form.pedidos[i],
                                    ),
                                  ),
                                )
                              : Container(
                                  key: ValueKey(form.pedidos[i].id),
                                  child: _itemPedidoPrioridadeWidget(
                                    i,
                                    form.pedidos[i],
                                  ),
                                ),
                        ),
                      ),
                      const H(16),
                      AppTextButton(
                        label: 'Confirmar',
                        onPressed: () => pedidoCtrl.onConfirmarPrioridade(
                          context,
                          widget.pedido,
                        ),
                      ),
                      if (widget.pedido.prioridade != null) ...[
                        Gap(12),
                        AppTextButton(
                          label: 'Remover',
                          fill: Fill.outlined,
                          onPressed: () => pedidoCtrl.onRemoverPrioridade(
                            context,
                            widget.pedido,
                          ),
                        ),
                      ],
                        Gap(12),
                        AppTextButton(
                          label: 'Apenas voltar',
                          fill: Fill.outlined,
                          onPressed: () => Navigator.pop(context),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemPedidoPrioridadeWidget(int index, PedidoModel pedido) {
    bool isSelected = widget.pedido.id == pedido.id;
    return Container(
      decoration: BoxDecoration(
        color: widget.pedido.id == pedido.id
            ? AppColors.primaryLightest
            : Colors.grey[200],
        border: Border(bottom: BorderSide(color: AppColors.neutralLight)),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Gap(8),
          Text('${index + 1}º', style: AppCss.mediumBold),
          Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pedido.localizador, style: AppCss.mediumBold),
                Text(
                  pedido.produtos
                      .map((e) => '${'${e.produto.descricao} - ${e.qtde}'}Kg')
                      .join(', '),
                  overflow: TextOverflow.clip,
                  style: AppCss.minimumRegular
                      .setSize(11)
                      .setColor(AppColors.black)
                      .copyWith(overflow: TextOverflow.clip),
                ),
              ],
            ),
          ),
          if (isSelected) ...[
            Gap(16),
            Icon(Icons.drag_handle, color: Colors.black),
          ],
          Gap(16),
        ],
      ),
    );
  }
}
