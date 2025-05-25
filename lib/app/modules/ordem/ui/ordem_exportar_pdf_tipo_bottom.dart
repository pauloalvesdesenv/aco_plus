import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/ordem/view_models/ordem_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

Future<OrdemExportarPdfTipo?> showOrdemExportarPdfTipoBottom() async =>
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: contextGlobal,
      isScrollControlled: true,
      builder: (_) => const OrdemExportarPdfTipoBottom(),
    );

class OrdemExportarPdfTipoBottom extends StatefulWidget {
  const OrdemExportarPdfTipoBottom({super.key});

  @override
  State<OrdemExportarPdfTipoBottom> createState() =>
      _OrdemExportarPdfTipoBottomState();
}

class _OrdemExportarPdfTipoBottomState
    extends State<OrdemExportarPdfTipoBottom> {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) => KeyboardVisibilityBuilder(
        builder: (context, isVisible) {
          return Container(
            height: 250,
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
                        'Selecione o modo de exportação',
                        style: AppCss.largeBold,
                      ),
                      const H(16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (var tipo in OrdemExportarPdfTipo.values)
                            ListTile(
                              leading: Icon(tipo.icon),
                              title: Text(tipo.label),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: Colors.grey,
                              ),
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
