import 'package:flutter/material.dart';
import 'package:projeto_controle_financeiro/components/components.dart';
import 'package:projeto_controle_financeiro/services/services.dart';
import 'package:provider/provider.dart';

class DespesasWidget extends StatelessWidget {
  const DespesasWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // definindo margens por porcentagem
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    //Obtendo valores do service
    List<Map<String, dynamic>> despesas =
        context.watch<DespesasService>().despesas;
    bool isLoading = context.watch<DespesasService>().isLoading;

    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: DateSelectWidget(),
          ),
          if (isLoading)
            const CircularProgressIndicator()
          else
            for (final despesa in despesas)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: height * 0.1,
                      width: width * 0.98,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.money_off),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      despesa['titulo'],
                                      style: const TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'R\$ ${despesa['valor']}',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    color: Colors.red[400],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  despesa['data'],
                                  style: const TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    color: Colors.black38,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                  // title: Text(despesa['titulo']),
                  // subtitle: Text('R\$ ${despesa['valor']}'),
                  // leading: const Icon(Icons.battery_full),
                  // trailing: const Icon(Icons.star),
                ),
              ),
        ],
      ),
    );
  }
}