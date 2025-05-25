import 'package:aco_plus/app/core/client/firestore/collections/fabricante/fabricante_model.dart';
import 'package:aco_plus/app/core/client/firestore/collections/materia_prima/enums/materia_prima_status.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/components/archive/archive_model.dart';

class MateriaPrimaModel {
  final String id;
  final FabricanteModel fabricanteModel;
  final ProdutoModel produto;
  final String corridaLote;
  final List<ArchiveModel> anexos;
  MateriaPrimaStatus status;

  MateriaPrimaModel({
    required this.id,
    required this.fabricanteModel,
    required this.produto,
    required this.corridaLote,
    required this.anexos,
    required this.status,
  });

  String get label => '${fabricanteModel.nome} - $corridaLote';

  static MateriaPrimaModel empty() => MateriaPrimaModel(
    id: 'register_unavailable',
    fabricanteModel: FabricanteModel.empty(),
    produto: ProdutoModel.empty(),
    corridaLote: 'Não especificado',
    anexos: [],
    status: MateriaPrimaStatus.disponivel,
  );

  factory MateriaPrimaModel.fromMap(Map<String, dynamic> map) {
    return MateriaPrimaModel(
      id: map['id'] as String,
      fabricanteModel: FabricanteModel.fromMap(map['fabricanteModel']),
      produto: ProdutoModel.fromMap(map['produto']),
      corridaLote: map['corridaLote'] as String,
      anexos:
          map['anexos'] != null
              ? (map['anexos'] as List<dynamic>)
                  .map((e) => ArchiveModel.fromMap(e))
                  .toList()
              : [],
      status: MateriaPrimaStatus.values[map['status']],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fabricanteModel': fabricanteModel.toMap(),
      'produto': produto.toMap(),
      'corridaLote': corridaLote,
      'anexos': anexos.map((e) => e.toMap()).toList(),
      'status': status.index,
    };
  }

  @override
  String toString() {
    return '${produto.labelMinified.replaceAll(' - ', ' ').replaceAll('Bitola ', '')} - ${fabricanteModel.nome} - $corridaLote';
  }
}
