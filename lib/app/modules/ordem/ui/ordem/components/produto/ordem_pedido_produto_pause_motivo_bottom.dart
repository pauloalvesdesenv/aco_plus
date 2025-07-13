import 'package:aco_plus/app/core/components/app_text_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:flutter/material.dart';

enum OrdemPedidoProdutoPauseMotivo { cafe, almoco, fimExpediente, outro }

extension OrdemPedidoProdutoPauseMotivoExtension
    on OrdemPedidoProdutoPauseMotivo {
  String get name => switch (this) {
    OrdemPedidoProdutoPauseMotivo.cafe => 'Café',
    OrdemPedidoProdutoPauseMotivo.almoco => 'Almoço',
    OrdemPedidoProdutoPauseMotivo.fimExpediente => 'Fim de Expediente',
    OrdemPedidoProdutoPauseMotivo.outro => 'Outro',
  };

}

Future<String?> showOrdemPedidoProdutoPauseMotivoBottom() async =>
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: contextGlobal,
      isScrollControlled: true,
      builder: (_) => OrdemPedidoProdutoPauseMotivoBottom(),
    );

class OrdemPedidoProdutoPauseMotivoBottom extends StatefulWidget {
  const OrdemPedidoProdutoPauseMotivoBottom({super.key});

  @override
  State<OrdemPedidoProdutoPauseMotivoBottom> createState() =>
      _OrdemPedidoProdutoPauseMotivoBottomState();
}

class _OrdemPedidoProdutoPauseMotivoBottomState
    extends State<OrdemPedidoProdutoPauseMotivoBottom> {
  OrdemPedidoProdutoPauseMotivo? currentMotivo;
  final TextEditingController motivoController = TextEditingController();

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
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selecione o motivo', style: AppCss.largeBold),
                    const H(16),
                    Expanded(
                      child: ListView(
                        children: [
                          for (var motivo
                              in OrdemPedidoProdutoPauseMotivo.values)
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: AppColors.primaryMain,
                                ),
                              ),
                              child:
                                  RadioListTile<OrdemPedidoProdutoPauseMotivo>(
                                    title: Text(
                                      motivo.name,
                                      style: AppCss.mediumRegular,
                                    ),
                                    value: motivo,
                                    groupValue: currentMotivo,
                                    onChanged: (value) {
                                      setState(() {
                                        currentMotivo = value!;
                                      });
                                    },
                                  ),
                            ),
                        ],
                      ),
                    ),
                    const H(16),
                    AppTextButton(
                      label: 'Confirmar',
                      onPressed: () =>
                          Navigator.pop(context, currentMotivo?.name),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
