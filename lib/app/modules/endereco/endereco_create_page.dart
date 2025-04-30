import 'package:aco_plus/app/core/components/app_field.dart';
import 'package:aco_plus/app/core/components/app_scaffold.dart';
import 'package:aco_plus/app/core/components/done_button.dart';
import 'package:aco_plus/app/core/components/h.dart';
import 'package:aco_plus/app/core/components/stream_out.dart';
import 'package:aco_plus/app/core/components/w.dart';
import 'package:aco_plus/app/core/models/endereco_model.dart';
import 'package:aco_plus/app/core/utils/app_colors.dart';
import 'package:aco_plus/app/core/utils/app_css.dart';
import 'package:aco_plus/app/core/utils/global_resource.dart';
import 'package:aco_plus/app/modules/endereco/endereco_controller.dart';
import 'package:flutter/material.dart';

class EnderecoCreatePage extends StatefulWidget {
  final EnderecoModel? endereco;
  const EnderecoCreatePage({this.endereco, super.key});

  @override
  State<EnderecoCreatePage> createState() => _EnderecoCreatePageState();
}

class _EnderecoCreatePageState extends State<EnderecoCreatePage> {
  @override
  void initState() {
    enderecoCtrl.onInitEndereco(widget.endereco);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeAvoid: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => pop(context),
          icon: Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: Text(
          '${enderecoCtrl.form.isEdit ? 'Editar' : 'Adicionar'} Endereco',
          style: AppCss.largeBold.setColor(AppColors.white),
        ),
        actions: [
          IconLoadingButton(() async => await enderecoCtrl.onConfirm(context)),
        ],
        backgroundColor: AppColors.primaryMain,
      ),
      body: StreamOut(
        stream: enderecoCtrl.enderecoCreateStream.listen,
        builder: (_, form) => body(form),
      ),
    );
  }

  Widget body(EnderecoCreateModel form) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppField(
          label: 'CEP',
          type: TextInputType.number,
          controller: form.cep,
          hint: form.cep.mask!,
          onChanged: (value) {
            if (value.length == 9) {
              enderecoCtrl.onSearchCEP(value);
            }
            enderecoCtrl.enderecoCreateStream.update();
          },
        ),
        const H(16),
        AppField(
          label: 'Logradouro',
          controller: form.logradouro,
          onChanged: (_) => enderecoCtrl.enderecoCreateStream.update(),
        ),
        const H(16),
        AppField(
          label: 'Bairro',
          controller: form.bairro,
          onChanged: (_) => enderecoCtrl.enderecoCreateStream.update(),
        ),
        const H(16),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: AppField(
                label: 'Localidade',
                controller: form.localidade,
                onChanged: (_) => enderecoCtrl.enderecoCreateStream.update(),
              ),
            ),
            const W(8),
            Expanded(
              flex: 2,
              child: AppField(
                label: 'UF',
                controller: form.estado,
                onChanged: (_) => enderecoCtrl.enderecoCreateStream.update(),
              ),
            ),
          ],
        ),
        const H(16),
        Row(
          children: [
            Expanded(
              child: AppField(
                label: 'Número',
                type: TextInputType.number,
                controller: form.numero,
                onChanged: (_) => enderecoCtrl.enderecoCreateStream.update(),
              ),
            ),
            const W(8),
            Expanded(
              flex: 2,
              child: AppField(
                label: 'Complemento',
                required: false,
                controller: form.complemento,
                onChanged: (_) => enderecoCtrl.enderecoCreateStream.update(),
              ),
            ),
          ],
        ),
        const H(16),
        Row(
          children: [
            Expanded(
              child: AppField(
                label: 'Latitude',
                controller: form.lat,
                type: TextInputType.number,
                onChanged: (_) => enderecoCtrl.enderecoCreateStream.update(),
              ),
            ),
            const W(8),
            Expanded(
              child: AppField(
                label: 'Longitude',
                type: TextInputType.number,
                controller: form.lon,
                onChanged: (_) => enderecoCtrl.enderecoCreateStream.update(),
              ),
            ),
          ],
        ),
        const H(16),
      ],
    );
  }
}
