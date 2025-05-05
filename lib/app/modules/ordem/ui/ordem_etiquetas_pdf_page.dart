import 'dart:typed_data';

import 'package:aco_plus/app/core/components/pdf_divisor.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/modules/ordem/view_models/ordem_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class OrdemEtiquetasPdfPage {
  final List<OrdemEtiquetaModel> model;
  OrdemEtiquetasPdfPage(this.model);

  pw.Page build(Uint8List bytes) => pw.MultiPage(
        margin: pw.EdgeInsets.zero,
        orientation: pw.PageOrientation.portrait,
        pageFormat: PdfPageFormat.a6,
        build: (pw.Context context) => [
          for (var etiqueta in model) _etiquetaItem(etiqueta, bytes),
        ],
      );

  pw.Widget _etiquetaItem(OrdemEtiquetaModel etiqueta, Uint8List bytes) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Image(pw.MemoryImage(bytes), width: 60, height: 60),
          ),
          pw.SizedBox(height: 16),
          _itemRelatorio(etiqueta),
        ],
      ),
    );
  }

  pw.Widget _itemRelatorio(OrdemEtiquetaModel etiqueta) {
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
                  etiqueta.ordem.localizator,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(AppColors.black.value),
                  ),
                ),
              ),
              pw.Text(
                DateFormat(
                  "'EMITIDA EM 'dd/MM/yyyy' ÀS 'HH:mm",
                ).format(etiqueta.createdAt),
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.normal,
                  color: PdfColor.fromInt(AppColors.black.value),
                ),
              ),
            ],
          ),
          _itemInfo('QUANTIDADE', etiqueta.ordem.produtos.first.qtde.toKg()),
          PdfDivisor.build(),
          _itemInfo('PEDIDO', etiqueta.pedido.localizador),
          PdfDivisor.build(),
          _itemInfo(
            'MATERIA PRIMA',
            etiqueta.ordem.materiaPrima != null
                ? '${etiqueta.ordem.materiaPrima?.fabricanteModel.nome} - ${etiqueta.ordem.materiaPrima?.corridaLote}'
                    .toUpperCase()
                : 'NÃO ESPECIFICADO',
          ),
          PdfDivisor.build(),
          _itemInfo('BITOLA', '${etiqueta.ordem.produto.descricaoReplaced}mm'),
          PdfDivisor.build(),
          _itemInfo('CLIENTE', etiqueta.pedido.cliente.nome.toUpperCase()),
          PdfDivisor.build(),
          _itemInfo('OBRA', etiqueta.pedido.obra.descricao.toUpperCase()),
          pw.SizedBox(height: 36),
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
