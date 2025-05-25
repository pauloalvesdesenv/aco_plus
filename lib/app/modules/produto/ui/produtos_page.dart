import 'package:aco_plus/app/core/client/firestore/collections/produto/produto_model.dart';
import 'package:aco_plus/app/core/client/firestore/firestore_client.dart';
import 'package:aco_plus/app/core/components/app_drawer.dart';
import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/divisor.dart';
import 'package:aco_plus/app/core/components/empty_data.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/base/base_controller.dart';
import 'package:aco_plus/app/modules/produto/produto_controller.dart';
import 'package:aco_plus/app/modules/produto/produto_view_model.dart';
import 'package:aco_plus/app/modules/produto/ui/produto_create_page.dart';
import 'package:flutter/material.dart';

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  @override
  void initState() {
    FirestoreClient.produtos.fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => baseCtrl.key.currentState!.openDrawer(),
          icon: Icon(Icons.menu, color: AppColors.white),
        ),
        title: Text(
          'Produtos',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => push(context, const ProdutoCreatePage()),
            icon: Icon(Icons.add, color: AppColors.white),
          ),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut<List<ProdutoModel>>(
        stream: FirestoreClient.produtos.dataStream.listen,
        builder: (_, __) => StreamOut<ProdutoUtils>(
          stream: produtoCtrl.utilsStream.listen,
          builder: (_, utils) {
            final produtos = produtoCtrl
                .getProdutoesFiltered(utils.search.text, __)
                .toList();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppField(
                    hint: 'Pesquisar',
                    controller: utils.search,
                    suffixIcon: Icons.search,
                    onChanged: (_) => produtoCtrl.utilsStream.update(),
                  ),
                ),
                Expanded(
                  child: produtos.isEmpty
                      ? const EmptyData()
                      : RefreshIndicator(
                          onRefresh: () async =>
                              FirestoreClient.produtos.fetch(),
                          child: ListView.separated(
                            itemCount: produtos.length,
                            separatorBuilder: (_, i) => const Divisor(),
                            itemBuilder: (_, i) =>
                                _itemProdutoWidget(produtos[i]),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  ListTile _itemProdutoWidget(ProdutoModel produto) {
    return ListTile(
      onTap: () => push(ProdutoCreatePage(produto: produto)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(produto.nome, style: AppCss.mediumBold),
      subtitle: Text(produto.descricao),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: AppColors.neutralMedium,
      ),
    );
  }
}
