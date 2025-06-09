import 'dart:typed_data';

import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/components/pdf_divisor.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/relatorio/relatorio_controller.dart';
import 'package:aco_plus/app/modules/relatorio/ui/ordem/relatorio_ordens_pdf_exportar_tipo_bottom.dart';
import 'package:aco_plus/app/modules/relatorio/view_models/relatorio_ordem_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class RelatorioOrdemPdfStatusPage {
  final RelatorioOrdemModel model;
  final RelatorioOrdensPdfExportarTipo tipo;
  RelatorioOrdemPdfStatusPage(this.model, this.tipo);

  pw.Page build(Uint8List bytes) => pw.MultiPage(
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    pageFormat: PdfPageFormat.a4,
    build: (pw.Context context) => [
      pw.Image(pw.MemoryImage(bytes), width: 60, height: 60),
      pw.SizedBox(height: 24),
      pw.Text(
        'RELATÓRIO DE BITOLA POR STATUS${model.dates != null ? ' E PERÍODO' : empty}',
      ),
      pw.SizedBox(height: 16),
      _itemHeader(model),
      pw.SizedBox(height: 24),
      for (final pedido in model.ordens) _itemRelatorio(pedido),
    ],
  );

  pw.Widget _itemRelatorio(OrdemModel ordem) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(Colors.white.value),
        border: pw.Border.all(
          color: PdfColor.fromInt(Colors.grey[700]!.value),
          width: 1,
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Text(
                  ordem.localizator,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(AppColors.black.value),
                  ),
                ),
              ),
              pw.Text(
                DateFormat(
                  "'Criado 'dd/MM/yyyy' às 'HH:mm",
                ).format(ordem.createdAt),
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.normal,
                  color: PdfColor.fromInt(AppColors.black.value),
                ),
              ),
            ],
          ),
          _itemInfo('Bitola', '${ordem.produto.descricaoReplaced}mm'),
                 if (ordem.materiaPrima != null ||
              tipo == RelatorioOrdensPdfExportarTipo.completo)
          PdfDivisor.build(),
          if (ordem.materiaPrima != null) ...[
            _itemInfo(
              'Materia Prima',
              '${ordem.materiaPrima!.fabricanteModel.nome} - ${ordem.materiaPrima!.corridaLote}',
            ),
            if (tipo == RelatorioOrdensPdfExportarTipo.completo) PdfDivisor.build(),
          ],
          if (tipo == RelatorioOrdensPdfExportarTipo.completo) ...[
            for (final produto in ordem.produtos)
              pw.Column(
                children: [
                  _itemInfo(
                    '${produto.pedido.localizador} - ${produto.cliente.nome} - ${produto.obra.descricao}',
                    '${produto.qtde} kg',
                  ),
                  if (produto.pedido.deliveryAt == null)
                    PdfDivisor.build(color: Colors.grey[200]),
                  if (produto.pedido.deliveryAt != null) ...[
                    _itemInfo(
                      'Previsão de Entrega',
                      '${produto.pedido.deliveryAt?.text()}',
                    ),
                    PdfDivisor.build(color: Colors.grey[200]),
                  ],
                  if (produto.materiaPrima != null &&
                      produto.materiaPrima?.id != ordem.materiaPrima?.id) ...[
                    _itemInfo(
                      'Materia Prima',
                      '${produto.materiaPrima?.fabricanteModel.nome} - ${produto.materiaPrima?.corridaLote}',
                    ),
                    PdfDivisor.build(color: Colors.grey[200]),
                  ],
                ],
              ),
          ],
        ],
      ),
    );
  }

  pw.Widget _itemHeader(RelatorioOrdemModel relatorio) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(Colors.white.value),
        border: pw.Border.all(
          color: PdfColor.fromInt(Colors.grey[700]!.value),
          width: 1,
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            relatorio.status.map((e) => e.label).join(', '),
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.normal,
              color: PdfColor.fromInt(AppColors.black.value),
            ),
          ),
          pw.SizedBox(height: 8),
          _itemInfo(
            'Data Criação Relatório',
            DateFormat(
              "dd/MM/yyyy' ás 'HH:mm",
            ).format(relatorio.createdAt).toString(),
          ),
          PdfDivisor.build(color: Colors.grey[200]),
          if (relatorio.dates != null)
            _itemInfo(
              'Período',
              '${DateFormat("dd/MM/yyyy").format(relatorio.dates!.start)} - ${DateFormat("dd/MM/yyyy").format(relatorio.dates!.end)}',
            ),
          PdfDivisor.build(color: Colors.grey[200]),
          for (final produto in relatorioCtrl.getOrdemTotalProduto())
            pw.Column(
              children: [
                _itemInfo(
                  'Quantidade Total Bitola ${produto.produto.descricao}',
                  '${produto.qtde} Kg',
                ),
                PdfDivisor.build(color: Colors.grey[200]),
              ],
            ),
          _itemInfo(
            'Quantidade Total Bitolas',
            '${relatorioCtrl.getOrdemTotal()} Kg',
          ),
        ],
      ),
    );
  }

  pw.Widget _itemInfo(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromInt(Colors.grey[800]!.value),
              ),
            ),
          ),
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.normal,
                color: PdfColor.fromInt(Colors.grey[800]!.value),
              ),
              textAlign: pw.TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
