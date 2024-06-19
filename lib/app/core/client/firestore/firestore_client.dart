import 'package:aco_plus/app/core/client/firestore/collections/checklist/checklist_collection.dart';
import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_collection.dart';
import 'package:aco_plus/app/core/client/firestore/collections/ordem/ordem_collection.dart';
import 'package:aco_plus/app/core/client/firestore/collections/pedido/pedido_collection.dart';
import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_collection.dart';
import 'package:aco_plus/app/core/client/firestore/collections/step/step_collection.dart';
import 'package:aco_plus/app/core/client/firestore/collections/tag/tag_collection.dart';
import 'package:aco_plus/app/core/client/firestore/collections/usuario/usuario_collection.dart';
import 'package:aco_plus/app/core/client/firestore/collections/version/version_collection.dart';

class FirestoreClient {
  static VersionCollection version = VersionCollection();
  static UsuarioCollection usuarios = UsuarioCollection();
  static ClienteCollection clientes = ClienteCollection();
  static StepCollection steps = StepCollection();
  static TagCollection tags = TagCollection();
  static ChecklistCollection checklists = ChecklistCollection();
  static ProdutoCollection produtos = ProdutoCollection();
  static PedidoCollection pedidos = PedidoCollection();
  static OrdemCollection ordens = OrdemCollection();

  static init() async {
    await version.start();
    await usuarios.start();
    await steps.start();
    await produtos.start();
    await tags.start();
    await checklists.start();
    await clientes.start();
    await pedidos.start();
    await ordens.start();

    await version.listen();
    await usuarios.listen();
    await steps.listen();
    await produtos.listen();
    await tags.listen();
    await checklists.listen();
    await clientes.listen();
    await pedidos.listen();
    await ordens.listen();
  }
}
