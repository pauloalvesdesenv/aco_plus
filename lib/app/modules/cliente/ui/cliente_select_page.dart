import 'package:aco_plus/app/core/client/firestore/collections/cliente/cliente_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/empty_data.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/cliente/cliente_controller.dart';
import 'package:aco_plus/app/modules/cliente/cliente_view_model.dart';
import 'package:aco_plus/app/modules/cliente/ui/cliente_create_page.dart';
import 'package:flutter/material.dart';

class ClienteSelectPage extends StatefulWidget {
  const ClienteSelectPage({super.key});

  @override
  State<ClienteSelectPage> createState() => _ClienteSelectPageState();
}

class _ClienteSelectPageState extends State<ClienteSelectPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'Clientees',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => push(context, const ClienteCreatePage()),
            icon: Icon(Icons.add, color: AppColors.white),
          ),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut<List<ClienteModel>>(
        stream: FirestoreClient.clientes.dataStream.listen,
        builder: (_, __) => StreamOut<ClienteUtils>(
          stream: clienteCtrl.utilsStream.listen,
          builder: (_, utils) {
            final clientes = clienteCtrl
                .getClienteesFiltered(utils.search.text, __)
                .toList();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppField(
                    hint: 'Pesquisar',
                    controller: utils.search,
                    suffixIcon: Icons.search,
                    onChanged: (_) => clienteCtrl.utilsStream.update(),
                  ),
                ),
                Expanded(
                  child: clientes.isEmpty
                      ? const EmptyData()
                      : ListView.separated(
                          itemCount: clientes.length,
                          separatorBuilder: (_, i) => const Divisor(),
                          itemBuilder: (_, i) =>
                              _itemClienteWidget(clientes[i]),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  ListTile _itemClienteWidget(ClienteModel cliente) {
    return ListTile(
      onTap: () => Navigator.pop(context, cliente),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(cliente.nome, style: AppCss.mediumBold),
      subtitle: Text(
        'Tel: ${cliente.telefone} - Endereço: ${cliente.endereco} - Qtd. Obras: ${cliente.obras.length}',
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: AppColors.neutralMedium,
      ),
    );
  }
}
