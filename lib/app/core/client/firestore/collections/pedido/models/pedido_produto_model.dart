import 'dart:convert';

import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/models/materia_prima_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/ordem_history_type_enum.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_despausada_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_pausada_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_status_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/enums/obra_status.dart';
import 'package:aco_plus/app/core/services/hash_service.dart';
import 'package:collection/collection.dart';

class PedidoProdutoTurno {
  final String produtoId;
  final String pedidoId;
  final String pedidoProdutoId;
  final String ordemId;
  final Duration duration;
  final PedidoProdutoHistory start;
  final PedidoProdutoHistory? end;

  PedidoProdutoTurno({
    required this.produtoId,
    required this.pedidoId,
    required this.pedidoProdutoId,
    required this.ordemId,
    required this.start,
    required this.duration,
    this.end,
  });
}

enum PedidoProdutoHistoryType {
  pause,
  unpause;

  String get label {
    switch (this) {
      case PedidoProdutoHistoryType.pause:
        return 'Iniciado ás';
      case PedidoProdutoHistoryType.unpause:
        return 'Finalizado ás';
    }
  }
}

class PedidoProdutoHistory {
  final PedidoProdutoHistoryType type;
  final DateTime date;

  PedidoProdutoHistory({required this.type, required this.date});
}

class PedidoProdutoModel {
  final String id;
  final String pedidoId;
  final String clienteId;
  final String obraId;
  final ProdutoModel produto;
  final List<PedidoProdutoStatusModel> statusess;
  final double qtde;
  bool isSelected = true;
  bool isAvailable = true;
  bool isPaused = false;
  MateriaPrimaModel? materiaPrima;

  List<PedidoProdutoTurno> getTurnos(OrdemModel ordem) {
    final turnos = <PedidoProdutoTurno>[];

    final alteracoesStatus =
        ordem.history
            .where(
              (e) =>
                  e.type == OrdemHistoryTypeEnum.statusProdutoAlterada ||
                  e.type == OrdemHistoryTypeEnum.pausada ||
                  e.type == OrdemHistoryTypeEnum.despausada,
            )
            .where((e) {
              switch (e.type) {
                case OrdemHistoryTypeEnum.statusProdutoAlterada:
                  final data = e.data as OrdemHistoryTypeStatusProdutoModel;
                  return data.statusProdutos.produtos.any((e) => e.id == id);
                case OrdemHistoryTypeEnum.pausada:
                  final data = e.data as OrdemHistoryTypePausadaModel;
                  return data.pedidoProdutoId == id;
                case OrdemHistoryTypeEnum.despausada:
                  final data = e.data as OrdemHistoryTypeDespausadaModel;
                  return data.pedidoProdutoId == id;
                default:
                  return false;
              }
            })
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    // Variáveis para controlar o estado atual
    DateTime? inicioTurnoAtual;
    bool estaProduzindo = false;
    bool estaPausado = false;

    for (final evento in alteracoesStatus) {
      switch (evento.type) {
        case OrdemHistoryTypeEnum.statusProdutoAlterada:
          final data = evento.data as OrdemHistoryTypeStatusProdutoModel;
          final novoStatus = data.statusProdutos.status;

          // Verifica se o produto está começando a produzir
          if (novoStatus == PedidoProdutoStatus.produzindo && !estaProduzindo) {
            // Início de novo turno
            inicioTurnoAtual = evento.createdAt;
            estaProduzindo = true;
            estaPausado = false;
          }
          // Verifica se o produto ficou pronto
          else if (novoStatus == PedidoProdutoStatus.pronto && estaProduzindo) {
            // Fim do turno atual
            if (inicioTurnoAtual != null) {
              final duracao = evento.createdAt.difference(inicioTurnoAtual);

              turnos.add(
                PedidoProdutoTurno(
                  duration: duracao,
                  start: PedidoProdutoHistory(
                    type: PedidoProdutoHistoryType.pause,
                    date: inicioTurnoAtual,
                  ),
                  end: PedidoProdutoHistory(
                    type: PedidoProdutoHistoryType.unpause,
                    date: evento.createdAt,
                  ),
                  produtoId: produto.id,
                  pedidoId: pedidoId,
                  pedidoProdutoId: id,
                  ordemId: ordem.id,
                ),
              );
            }

            // Reset do estado
            inicioTurnoAtual = null;
            estaProduzindo = false;
            estaPausado = false;
          }
          // Verifica se saiu do status produzindo para outro status que não seja pronto
          else if (estaProduzindo &&
              novoStatus != PedidoProdutoStatus.produzindo &&
              novoStatus != PedidoProdutoStatus.pronto) {
            // Produto saiu de produzindo sem ficar pronto - interrompe o turno atual
            estaProduzindo = false;
            inicioTurnoAtual = null;
            estaPausado = false;
          }

          break;

        case OrdemHistoryTypeEnum.pausada:
          if (estaProduzindo && !estaPausado) {
            // Pausa durante a produção - finaliza o turno atual
            if (inicioTurnoAtual != null) {
              final duracao = evento.createdAt.difference(inicioTurnoAtual);

              turnos.add(
                PedidoProdutoTurno(
                  duration: duracao,
                  start: PedidoProdutoHistory(
                    type: PedidoProdutoHistoryType.pause,
                    date: inicioTurnoAtual,
                  ),
                  end: PedidoProdutoHistory(
                    type: PedidoProdutoHistoryType.unpause,
                    date: evento.createdAt,
                  ),
                  produtoId: produto.id,
                  pedidoId: pedidoId,
                  pedidoProdutoId: id,
                  ordemId: ordem.id,
                ),
              );
            }

            estaPausado = true;
            inicioTurnoAtual = null;
          }
          break;

        case OrdemHistoryTypeEnum.despausada:
          if (estaProduzindo && estaPausado) {
            // Despausa durante a produção - inicia novo turno
            inicioTurnoAtual = evento.createdAt;
            estaPausado = false;
          }
          break;

        default:
          break;
      }
    }

    // Se ainda está produzindo, adiciona o turno em andamento
    if (estaProduzindo && inicioTurnoAtual != null && !estaPausado) {
      final duracao = DateTime.now().difference(inicioTurnoAtual);

      turnos.add(
        PedidoProdutoTurno(
          duration: duracao,
          start: PedidoProdutoHistory(
            type: PedidoProdutoHistoryType.pause,
            date: inicioTurnoAtual,
          ),
          // end é null para indicar que ainda está em andamento
          produtoId: produto.id,
          pedidoId: pedidoId,
          pedidoProdutoId: id,
          ordemId: ordem.id,
        ),
      );
    }

    return turnos;
  }

  factory PedidoProdutoModel.empty(PedidoModel pedido) => PedidoProdutoModel(
    id: HashService.get,
    pedidoId: pedido.id,
    clienteId: pedido.cliente.id,
    obraId: pedido.obra.id,
    produto: ProdutoModel.empty(),
    statusess: [PedidoProdutoStatusModel.empty()],
    qtde: 0,
    isPaused: false,
  );
  PedidoModel get pedido => FirestoreClient.pedidos.getById(pedidoId);
  bool get isAvailableToChanges => status.status.index < 2;
  bool get hasOrder => statusess.last.status == PedidoProdutoStatus.separado;

  ClienteModel get cliente => FirestoreClient.clientes.getById(clienteId);
  ObraModel get obra =>
      cliente.obras.firstWhereOrNull((e) => e.id == obraId) ??
      ObraModel(
        id: id,
        descricao: 'Indefinida',
        telefoneFixo: '',
        endereco: null,
        status: ObraStatus.emAndamento,
      );

  PedidoProdutoStatusModel get status => statusess.isNotEmpty
      ? statusess.last
      : PedidoProdutoStatusModel.create(PedidoProdutoStatus.pronto);

  PedidoProdutoStatusModel get statusView => status.copyWith(
    status: status.status == PedidoProdutoStatus.separado
        ? PedidoProdutoStatus.aguardandoProducao
        : status.status,
  );

  PedidoProdutoModel({
    required this.id,
    required this.pedidoId,
    required this.clienteId,
    required this.obraId,
    required this.produto,
    required this.statusess,
    required this.qtde,
    this.isAvailable = true,
    this.isSelected = true,
    this.materiaPrima,
    this.isPaused = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pedidoId': pedidoId,
      'clienteId': clienteId,
      'obraId': obraId,
      'produto': produto.toMap(),
      'statusess': statusess.map((x) => x.toMap()).toList(),
      'qtde': qtde,
      'materiaPrima': materiaPrima?.toMap(),
      'isPaused': isPaused,
    };
  }

  factory PedidoProdutoModel.fromMap(Map<String, dynamic> map) {
    return PedidoProdutoModel(
      id: map['id'] ?? '',
      pedidoId: map['pedidoId'] ?? '',
      clienteId: map['clienteId'] ?? '',
      obraId: map['obraId'] ?? '',
      produto: ProdutoModel.fromMap(map['produto']),
      statusess: List<PedidoProdutoStatusModel>.from(
        map['statusess']?.map((x) => PedidoProdutoStatusModel.fromMap(x)),
      ),
      qtde: map['qtde'] != null ? double.parse(map['qtde'].toString()) : 0.0,
      materiaPrima: map['materiaPrima'] != null
          ? MateriaPrimaModel.fromMap(map['materiaPrima'])
          : null,
      isPaused: map['isPaused'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory PedidoProdutoModel.fromJson(String source) =>
      PedidoProdutoModel.fromMap(json.decode(source));

  PedidoProdutoModel copyWith({
    String? id,
    String? pedidoId,
    String? clienteId,
    String? obraId,
    ProdutoModel? produto,
    List<PedidoProdutoStatusModel>? statusess,
    double? qtde,
    bool? isAvailable,
    bool? isSelected,
    MateriaPrimaModel? materiaPrima,
    bool? isPaused,
  }) {
    return PedidoProdutoModel(
      id: id ?? this.id,
      pedidoId: pedidoId ?? this.pedidoId,
      clienteId: clienteId ?? this.clienteId,
      obraId: obraId ?? this.obraId,
      produto: produto ?? this.produto,
      statusess: statusess ?? this.statusess,
      qtde: qtde ?? this.qtde,
      isAvailable: isAvailable ?? this.isAvailable,
      isSelected: isSelected ?? this.isSelected,
      materiaPrima: materiaPrima ?? this.materiaPrima,
      isPaused: isPaused ?? this.isPaused,
    );
  }
}
