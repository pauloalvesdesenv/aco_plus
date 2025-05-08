import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/components/app_text_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

Future<PedidoStatus?> showPedidoStatusBottom(PedidoModel pedido) async =>
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: contextGlobal,
      isScrollControlled: true,
      builder: (_) => PedidoStatusBottom(pedido),
    );

class PedidoStatusBottom extends StatefulWidget {
  final PedidoModel pedido;
  const PedidoStatusBottom(this.pedido, {super.key});

  @override
  State<PedidoStatusBottom> createState() => _PedidoStatusBottomState();
}

class _PedidoStatusBottomState extends State<PedidoStatusBottom> {
  late PedidoStatus currentStatus;

  @override
  void initState() {
    currentStatus = widget.pedido.statusess.last.status;
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
                          Text('Selecione o Status', style: AppCss.largeBold),
                          const H(16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              for (var status in getPedidosStatusByPedido(
                                widget.pedido,
                              ))
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: status.color.withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: RadioListTile<PedidoStatus>(
                                    title: Text(
                                      status.label,
                                      style: AppCss.mediumRegular,
                                    ),
                                    value: status,
                                    groupValue: currentStatus,
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
                                onPressed:
                                    () => Navigator.pop(context, currentStatus),
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
