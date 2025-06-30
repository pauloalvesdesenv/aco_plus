import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/models/materia_prima_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/ordem_history_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/ordem_history_type_enum.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_arquivada_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_concluida_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_congelada_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_desarquivada_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_descongelada_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_editada_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_materia_prima_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/history/types/ordem_history_type_status_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_materia_prima_produtos.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/models/ordem_status_produtos.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/models/pedido_produto_status_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/modules/usuario/usuario_controller.dart';

class OrdemTimelineRegister {
  final OrdemModel ordem;

  OrdemTimelineRegister({required this.ordem});

  Future<void> register({
    required String ordemId,
    required OrdemHistoryTypeEnum type,
    required String message,
    required OrdemHistoryDataModel data,
  }) async {
    final history = OrdemHistoryModel(
      type: type,
      message: message,
      createdAt: DateTime.now(),
      data: data,
    );
    ordem.history.add(history);
    await FirestoreClient.ordens.update(ordem);
  }

  static Future<void> editada(OrdemModel now, OrdemModel old) async {
    OrdemTimelineRegister(ordem: now).register(
      ordemId: now.id,
      type: OrdemHistoryTypeEnum.editada,
      message: 'Ordem editada',
      data: OrdemHistoryTypeEditadaModel(
        createdAt: DateTime.now(),
        user: usuario,
        materiaPrimaProdutos: OrdemMateriaPrimaProdutos(
          materiaPrima: now.materiaPrima!,
          produtos: now.produtos
              .where((e) => e.status.status != PedidoProdutoStatus.pronto)
              .toList(),
        ),
        adicionados: now.produtos
            .where((e) => !old.produtos.contains(e))
            .toList(),
        removidos: old.produtos
            .where((e) => !now.produtos.contains(e))
            .toList(),
      ),
    );
  }

  static Future<void> congelada(OrdemModel now) async {
    OrdemTimelineRegister(ordem: now).register(
      ordemId: now.id,
      type: OrdemHistoryTypeEnum.congelada,
      message: 'Ordem congelada',
      data: OrdemHistoryTypeCongeladaModel(
        createdAt: DateTime.now(),
        user: usuario,
      ),
    );
  }

  static Future<void> descongelada(OrdemModel now) async {
    OrdemTimelineRegister(ordem: now).register(
      ordemId: now.id,
      type: OrdemHistoryTypeEnum.descongelada,
      message: 'Ordem descongelada',
      data: OrdemHistoryTypeDescongeladaModel(
        createdAt: DateTime.now(),
        user: usuario,
      ),
    );
  }

  static Future<void> statusProdutoAlterada(
    OrdemModel now,
    OrdemStatusProdutos statusProdutos,
  ) async {
    OrdemTimelineRegister(ordem: now).register(
      ordemId: now.id,
      type: OrdemHistoryTypeEnum.statusProdutoAlterada,
      message: 'Status do produto alterado',
      data: OrdemHistoryTypeStatusProdutoModel(
        createdAt: DateTime.now(),
        user: usuario,
        statusProdutos: statusProdutos,
      ),
    );
  }

  static Future<void> materiaPrimaEditada(
    OrdemModel now,
    MateriaPrimaModel materiaPrima,
    List<PedidoProdutoModel> produtos,
  ) async {
    OrdemTimelineRegister(ordem: now).register(
      ordemId: now.id,
      type: OrdemHistoryTypeEnum.materiaPrimaEditada,
      message: 'Materia prima editada',
      data: OrdemHistoryTypeMateriaPrimaModel(
        createdAt: DateTime.now(),
        user: usuario,
        materiaPrimaProdutos: OrdemMateriaPrimaProdutos(
          materiaPrima: materiaPrima,
          produtos: produtos,
        ),
      ),
    );
  }

  static Future<void> statusOrdem(OrdemModel now) async {
    OrdemTimelineRegister(ordem: now).register(
      ordemId: now.id,
      type: OrdemHistoryTypeEnum.statusOrdem,
      message: 'Ordem concluida',
      data: OrdemHistoryTypeStatusOrdemModel(
        createdAt: DateTime.now(),
        user: usuario,
        status: now.status,
      ),
    );
  }

  static Future<void> arquivada(OrdemModel now) async {
    OrdemTimelineRegister(ordem: now).register(
      ordemId: now.id,
      type: OrdemHistoryTypeEnum.arquivada,
      message: 'Ordem arquivada',
      data: OrdemHistoryTypeArquivadaModel(
        createdAt: DateTime.now(),
        user: usuario,
      ),
    );
  }

  static Future<void> desarquivada(OrdemModel now) async {
    OrdemTimelineRegister(ordem: now).register(
      ordemId: now.id,
      type: OrdemHistoryTypeEnum.desarquivada,
      message: 'Ordem desarquivada',
      data: OrdemHistoryTypeDesarquivadaModel(
        createdAt: DateTime.now(),
        user: usuario,
      ),
    );
  }
}
