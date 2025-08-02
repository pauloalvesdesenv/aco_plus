import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/enums/materia_prima_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/models/materia_prima_model.dart';
import 'package:aco_plus/app/core/components/app_text_button.dart';
import 'package:aco_plus/app/core/components/archive/ui/archive_widget.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

Future<MateriaPrimaModel?> showMateriaPrimaBottom(MateriaPrimaModel materiaPrima) async =>
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: contextGlobal,
      isScrollControlled: true,
      builder: (_) => MateriaPrimaBottom(materiaPrima),
    );

class MateriaPrimaBottom extends StatefulWidget {
  final MateriaPrimaModel materiaPrima;
  const MateriaPrimaBottom(this.materiaPrima, {super.key});

  @override
  State<MateriaPrimaBottom> createState() => _MateriaPrimaBottomState();
}

class _MateriaPrimaBottomState extends State<MateriaPrimaBottom> {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) => KeyboardVisibilityBuilder(
        builder: (context, isVisible) {
          return Container(
            height: 600,
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
                      // Título principal
                      Text(
                        'Detalhes da Matéria Prima',
                        style: AppCss.largeBold.setColor(AppColors.black),
                      ),
                      const H(24),

                      // Informações do fabricante
                      _buildInfoSection(
                        'Fabricante',
                        widget.materiaPrima.fabricanteModel.nome,
                        Icons.business,
                      ),
                      const H(16),

                      // Informações do produto
                      _buildInfoSection(
                        'Produto',
                        widget.materiaPrima.produto.labelMinified,
                        Icons.inventory,
                      ),
                      const H(16),

                      // Corrida/Lote
                      _buildInfoSection(
                        'Corrida/Lote',
                        widget.materiaPrima.corridaLote,
                        Icons.tag,
                      ),
                      const H(16),

                      // Status
                      _buildStatusSection(),
                      const H(16),

                      // Anexos
                      if (widget.materiaPrima.anexos.isNotEmpty) ...[
                        _buildAnexosSection(),
                        const H(16),
                      ],

                      // Botão de ação
                      AppTextButton(
                        label: 'Editar Matéria Prima',
                        onPressed: () {
                          Navigator.pop(context, widget.materiaPrima);
                          // Aqui você pode adicionar a navegação para edição
                        },
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

  Widget _buildInfoSection(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutralLightest,
        borderRadius: AppCss.radius12,
        border: Border.all(color: AppColors.neutralMedium, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryMain,
              borderRadius: AppCss.radius8,
            ),
            child: Icon(icon, color: AppColors.white, size: 20),
          ),
          const W(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppCss.minimumRegular.setColor(AppColors.neutralDark),
                ),
                const H(2),
                Text(value, style: AppCss.smallBold.setColor(AppColors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.neutralLightest,
        borderRadius: AppCss.radius12,
        border: Border.all(color: AppColors.neutralMedium, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.materiaPrima.status.color,
              borderRadius: AppCss.radius8,
            ),
            child: Icon(
              widget.materiaPrima.status.icon,
              color: AppColors.white,
              size: 20,
            ),
          ),
          const W(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status',
                  style: AppCss.minimumRegular.setColor(AppColors.neutralDark),
                ),
                const H(2),
                Text(
                  widget.materiaPrima.status.label,
                  style: AppCss.smallBold.setColor(
                    widget.materiaPrima.status.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnexosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Anexos', style: AppCss.smallBold.setColor(AppColors.black)),
        const H(8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.neutralLightest,
            borderRadius: AppCss.radius12,
            border: Border.all(color: AppColors.neutralMedium, width: 1),
          ),
          child: Column(
            children: widget.materiaPrima.anexos.map((anexo) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ArchiveWidget(anexo, inList: false),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
