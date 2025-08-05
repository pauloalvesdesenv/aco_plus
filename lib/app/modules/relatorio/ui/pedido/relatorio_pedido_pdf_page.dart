import 'dart:typed_data';

import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/models/materia_prima_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/enums/pedido_tipo.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/pdf_divisor.dart';
import 'package:aco_plus/app/core/extensions/date_ext.dart';
import 'package:aco_plus/app/core/extensions/double_ext.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/modules/pedido/pedido_controller.dart';
import 'package:aco_plus/app/modules/relatorio/relatorio_controller.dart';
import 'package:aco_plus/app/modules/relatorio/view_models/relatorio_pedido_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

enum RelatorioPedidoQuantidade { todos, unico }

class RelatorioPedidoPdfPage {
  final RelatorioPedidoModel model;
  final RelatorioPedidoQuantidade quantidade;
  RelatorioPedidoPdfPage(
    this.model, {
    this.quantidade = RelatorioPedidoQuantidade.todos,
  });

  pw.Page build(Uint8List bytes) => pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    build: (pw.Context context) => [
      pw.Image(pw.MemoryImage(bytes), width: 60, height: 60),
      pw.SizedBox(height: 24),
      pw.Text('RELATÓRIO DE PEDIDOS POR CLIENTE E STATUS'),
      pw.SizedBox(height: 16),
      _itemHeader(model),
      if ([
        RelatorioPedidoTipo.totais,
        RelatorioPedidoTipo.totaisPedidos,
      ].contains(model.tipo)) ...[
        pw.SizedBox(height: 24),
        _itemTotalGeral(model),
        pw.SizedBox(height: 24),
        _itemTotalStatus(model),
        pw.SizedBox(height: 24),
        _itemTotalBitolasStatus(model),
      ],
      if ([
        RelatorioPedidoTipo.pedidos,
        RelatorioPedidoTipo.totaisPedidos,
      ].contains(model.tipo)) ...[
        pw.SizedBox(height: 24),
        for (final pedido in model.pedidos)
          pedido.produtos.isEmpty ? pw.SizedBox() : _itemRelatorio(pedido),
      ],
    ],
  );

  pw.Widget _itemRelatorio(PedidoModel pedido) {
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
                  pedido.localizador,
                  style: pw.TextStyle(
                    fontSize: 14,
                    font: pw.Font.times(),
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(AppColors.black.value),
                  ),
                ),
              ),
              pw.Text(
                DateFormat(
                  "'Criado 'dd/MM/yyyy' às 'HH:mm",
                ).format(pedido.createdAt),
                style: pw.TextStyle(
                  fontSize: 11,
                  font: pw.Font.times(),
                  fontWeight: pw.FontWeight.normal,
                  color: PdfColor.fromInt(AppColors.black.value),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          _itemInfo('Cliente', pedido.cliente.nome),
          PdfDivisor.build(color: Colors.grey[200]),
          _itemInfo('Descrição', pedido.descricao),
          PdfDivisor.build(color: Colors.grey[200]),
          _itemInfo(
            'Data de Entrega',
            pedido.deliveryAt != null
                ? pedido.deliveryAt!.text()
                : 'Não definida',
          ),
          PdfDivisor.build(color: Colors.grey[200]),
          _itemInfo('Tipo', pedido.tipo.label),
          PdfDivisor.build(color: Colors.grey[200]),
          for (final produto in pedido.produtos)
            pw.Builder(
              builder: (context) {
                return produto.qtde <= 0
                    ? pw.SizedBox()
                    : pw.Column(
                        children: [
                          pw.Builder(
                            builder: (context) {
                              final ordem = pedidoCtrl.getOrdemByProduto(produto, true);
                              return _itemInfo(
                                '${produto.produto.descricaoReplaced}mm',
                                '(${produto.status.status.label}) ${produto.qtde}Kg',
                                color: PdfColor.fromInt(
                                  produto.status.status.color
                                      .withValues(alpha: 0.06)
                                      .hashCode,
                                ).shade(0.03),
                                ordem:
                                    produto.status.status ==
                                        PedidoProdutoStatus.pronto
                                    ? ordem
                                    : null,
                                materiaPrima:
                                    produto.status.status ==
                                        PedidoProdutoStatus.pronto
                                    ? produto.materiaPrima
                                    : null,
                              );
                            },
                          ),
                          PdfDivisor.build(color: Colors.grey[200]),
                          if (produto.produto.id !=
                              pedido.produtos.last.produto.id)
                            PdfDivisor.build(color: Colors.grey[200]),
                        ],
                      );
              },
            ),
          PdfDivisor.build(color: Colors.grey[200]),
          _itemInfo('Total de Kgs', pedido.getQtdeTotal().toKg()),
        ],
      ),
    );
  }

  pw.Widget _itemHeader(RelatorioPedidoModel relatorio) {
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
                  relatorio.cliente?.nome ?? 'Todos os clientes',
                  style: pw.TextStyle(
                    fontSize: 14,
                    font: pw.Font.times(),
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromInt(AppColors.black.value),
                  ),
                ),
              ),
              pw.Text(
                relatorio.status.map((e) => e.label).join(', '),
                style: pw.TextStyle(
                  fontSize: 11,
                  font: pw.Font.times(),
                  fontWeight: pw.FontWeight.normal,
                  color: PdfColor.fromInt(AppColors.black.value),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          _itemInfo(
            'Bitolas',
            relatorio.produtos.map((e) => e.descricao).join(', '),
          ),
          PdfDivisor.build(color: Colors.grey[200]),
          _itemInfo(
            'Data Criação Relatório',
            DateFormat(
              "dd/MM/yyyy' ás 'HH:mm",
            ).format(relatorio.createdAt).toString(),
          ),
          PdfDivisor.build(color: Colors.grey[200]),
          _itemInfo(
            'Quantidade de Pedidos',
            relatorio.pedidos.length.toString(),
          ),
          PdfDivisor.build(color: Colors.grey[200]),
          _itemInfo(
            'Quantidade Total de Kilos',
            "${relatorio.pedidos.fold<double>(0, (a, b) => a + (b.produtos.fold(0, (c, d) => c + d.qtde))).toStringAsFixed(2)} kg",
          ),
          PdfDivisor.build(color: Colors.grey[200]),
        ],
      ),
    );
  }

  pw.Widget _itemTotalGeral(RelatorioPedidoModel relatorio) {
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
          pw.Builder(
            builder: (context) {
              final qtde = relatorioCtrl.getPedidosTotal();
              return qtde <= 0
                  ? pw.SizedBox()
                  : pw.Column(
                      children: [
                        _itemHeaderInfo('Total Geral', qtde.toKg()),
                        PdfDivisor.build(),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }

  pw.Widget _itemTotalStatus(RelatorioPedidoModel relatorio) {
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
            'Totais por status',
            style: pw.TextStyle(
              fontSize: 14,
              font: pw.Font.times(),
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromInt(AppColors.black.value),
            ),
          ),
          pw.SizedBox(height: 16),
          for (final status in PedidoProdutoStatus.values)
            pw.Builder(
              builder: (context) {
                final qtde = relatorioCtrl.getPedidosTotalPorStatus(status);
                return qtde <= 0
                    ? pw.SizedBox()
                    : pw.Column(
                        children: [
                          _itemInfo(
                            status.label,
                            qtde.toKg(),
                            color: PdfColor.fromInt(
                              status.color.withValues(alpha: 0.06).hashCode,
                            ).shade(0.03),
                          ),
                          PdfDivisor.build(),
                        ],
                      );
              },
            ),
        ],
      ),
    );
  }

  pw.Widget _itemTotalBitolasStatus(RelatorioPedidoModel relatorio) {
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
            'Totais por bitola',
            style: pw.TextStyle(
              fontSize: 14,
              font: pw.Font.times(),
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromInt(AppColors.black.value),
            ),
          ),
          pw.SizedBox(height: 16),
          for (final produto in FirestoreClient.produtos.data)
            pw.Builder(
              builder: (context) {
                bool hasQtde = PedidoProdutoStatus.values
                    .map(
                      (e) => relatorioCtrl.getPedidosTotalPorBitolaStatus(
                        produto,
                        e,
                      ),
                    )
                    .toList()
                    .any((e) => e > 0);
                return !hasQtde
                    ? pw.SizedBox()
                    : pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(16),
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                  child: pw.Text(
                                    'Bitola ${produto.descricaoReplaced}mm',
                                    style: pw.TextStyle(
                                      fontSize: 12,
                                      font: pw.Font.times(),
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColor.fromInt(
                                        AppColors.black.value,
                                      ),
                                    ),
                                  ),
                                ),
                                pw.Text(
                                  relatorioCtrl
                                      .getPedidosTotalPorBitola(produto)
                                      .toKg(),
                                  style: pw.TextStyle(
                                    fontSize: 12,
                                    font: pw.Font.times(),
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColor.fromInt(
                                      AppColors.black.value,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          for (final status in PedidoProdutoStatus.values)
                            pw.Builder(
                              builder: (context) {
                                final qtde = relatorioCtrl
                                    .getPedidosTotalPorBitolaStatus(
                                      produto,
                                      status,
                                    );
                                return qtde <= 0
                                    ? pw.SizedBox()
                                    : pw.Column(
                                        children: [
                                          _itemInfo(
                                            status.label,
                                            qtde.toKg(),
                                            color: PdfColor.fromInt(
                                              status.color
                                                  .withValues(alpha: 0.06)
                                                  .hashCode,
                                            ).shade(0.03),
                                          ),
                                          PdfDivisor.build(),
                                        ],
                                      );
                              },
                            ),
                          PdfDivisor.build(color: Colors.grey[600]!),
                        ],
                      );
              },
            ),
        ],
      ),
    );
  }

  pw.Widget _itemInfo(
    String label,
    String value, {
    PdfColor? color,
    OrdemModel? ordem,
    MateriaPrimaModel? materiaPrima,
    pw.EdgeInsets? padding,
  }) {
    return pw.Container(
      color: color,
      child: pw.Padding(
        padding: padding ?? const pw.EdgeInsets.symmetric(vertical: 8),
        child: pw.Column(
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Text(
                    label,
                    style: pw.TextStyle(
                      font: pw.Font.times(),
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
                      font: pw.Font.times(),
                      fontSize: 12,
                      fontWeight: pw.FontWeight.normal,
                      color: PdfColor.fromInt(Colors.grey[800]!.value),
                    ),
                    textAlign: pw.TextAlign.end,
                  ),
                ),
              ],
            ),
            if (ordem != null) ...[
              pw.SizedBox(height: 4),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 16),
                child: PdfDivisor.build(color: Colors.grey[200]),
              ),
              pw.SizedBox(height: 4),
              _itemInfo(
                'Ordem',
                ordem.localizator,
                padding: pw.EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              ),
            ],
            if (materiaPrima != null) ...[
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 16),
                child: PdfDivisor.build(color: Colors.grey[200]),
              ),
              _itemInfo(
                'Materia Prima',
                '${materiaPrima.corridaLote} - ${materiaPrima.fabricanteModel.nome}'
                    .toUpperCase(),
                padding: pw.EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              ),
              pw.Builder(
                builder: (context) {
                  if (materiaPrima.anexos.isEmpty ||
                      materiaPrima.anexos.first.bytes == null) {
                    return pw.SizedBox();
                  }
                  return pw.Row(
                    children: [
                      pw.Spacer(),
                      pw.Image(
                        pw.MemoryImage(
                          materiaPrima.anexos.first.bytes ?? Uint8List(0),
                        ),
                        width: 100,
                        height: 100,
                      ),
                      pw.SizedBox(width: 16),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  pw.Widget _itemHeaderInfo(String label, String value, {PdfColor? color}) {
    return pw.Container(
      color: color,
      child: pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 8),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Text(
                label,
                style: pw.TextStyle(
                  fontSize: 14,
                  font: pw.Font.times(),
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromInt(AppColors.black.value),
                ),
              ),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                value,
                style: pw.TextStyle(
                  font: pw.Font.times(),
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromInt(Colors.grey[800]!.value),
                ),
                textAlign: pw.TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
