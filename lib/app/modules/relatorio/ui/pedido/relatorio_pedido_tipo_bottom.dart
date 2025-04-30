import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/relatorio/view_models/relatorio_pedido_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

Future<RelatorioPedidoTipo?> showRelatorioPedidoTipoBottom() async =>
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: contextGlobal,
      isScrollControlled: true,
      builder: (_) => const RelatorioPedidoTipoBottom(),
    );

class RelatorioPedidoTipoBottom extends StatefulWidget {
  const RelatorioPedidoTipoBottom({super.key});

  @override
  State<RelatorioPedidoTipoBottom> createState() =>
      _RelatorioPedidoTipoBottomState();
}

class _RelatorioPedidoTipoBottomState extends State<RelatorioPedidoTipoBottom> {
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
                          Text(
                            'Selecione o Tipo de Relatório',
                            style: AppCss.largeBold,
                          ),
                          const H(16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              for (var tipo in RelatorioPedidoTipo.values)
                                ListTile(
                                  title: Text(tipo.label),
                                  onTap: () => Navigator.pop(context, tipo),
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
