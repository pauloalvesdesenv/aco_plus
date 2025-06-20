import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_prioridade_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/app_text_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/enums/fill.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Future<List<PedidoModel>?> showDashboardPedidoPrioridadeBottom(
  PedidoPrioridadeTipo tipo,
  List<PedidoModel> pedidos,
) async => showModalBottomSheet(
  backgroundColor: AppColors.white,
  context: contextGlobal,
  isScrollControlled: true,
  isDismissible: false,
  builder: (_) => DashboardPedidoPrioridadeBottom(tipo, pedidos),
);

class DashboardPedidoPrioridadeBottom extends StatefulWidget {
  final PedidoPrioridadeTipo tipo;
  final List<PedidoModel> pedidos;
  const DashboardPedidoPrioridadeBottom(this.tipo, this.pedidos, {super.key});

  @override
  State<DashboardPedidoPrioridadeBottom> createState() =>
      _DashboardPedidoPrioridadeBottomState();
}

class _DashboardPedidoPrioridadeBottomState
    extends State<DashboardPedidoPrioridadeBottom> {
  late List<PedidoModel> pedidos;

  @override
  void initState() {
    pedidos = widget.pedidos.map((e) => e.copyWith()).toList();
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
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                children: [
                  Text(
                    'Pedidos com prioridade em ${widget.tipo.getLabel()}:',
                    style: AppCss.largeBold,
                  ),
                  const H(16),
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
                      itemCount: pedidos.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex = newIndex - 1;
                          }
                          final step = pedidos.removeAt(oldIndex);
                          pedidos.insert(newIndex, step);
                          for (var i = 0; i < pedidos.length; i++) {
                            pedidos[i].prioridade!.index = i;
                          }
                        });
                      },
                      itemBuilder: (_, i) =>
                          _itemDashboardPedidoPrioridadeWidget(i, pedidos[i]),
                    ),
                  ),
                  const H(16),
                  AppTextButton(
                    label: 'Confirmar',
                    onPressed: () => Navigator.pop(context, pedidos),
                  ),
                  Gap(12),
                  AppTextButton(
                    label: 'Apenas voltar',
                    fill: Fill.outlined,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemDashboardPedidoPrioridadeWidget(int index, PedidoModel pedido) {
    return ReorderableDragStartListener(
      index: index,
      key: ValueKey(pedido.id),
      child: MouseRegion(
        cursor: SystemMouseCursors.move,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
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
                          .map(
                            (e) => '${'${e.produto.descricao} - ${e.qtde}'}Kg',
                          )
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
              Gap(16),
              Icon(Icons.drag_handle, color: Colors.black),
              Gap(16),
            ],
          ),
        ),
      ),
    );
  }
}
