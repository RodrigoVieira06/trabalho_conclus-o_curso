import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:projeto_controle_financeiro/components/components.dart';
import 'package:projeto_controle_financeiro/models/models.dart';
import 'package:projeto_controle_financeiro/screens/movimentacoes/components/components.dart';
import 'package:projeto_controle_financeiro/screens/movimentacoes/stores/stores.dart';
import 'package:projeto_controle_financeiro/utils/utils.dart';

class FaturamentosWidget extends StatelessWidget {
  const FaturamentosWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateselectStore dateselectStore = DateselectStore();
    final FaturamentosStore faturamentosStore = FaturamentosStore();
    final Conversoes conversoes = Conversoes();

    // definindo margens por porcentagem
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          ScopedBuilder<DateselectStore, Exception, DateTime>(
            store: dateselectStore,
            onLoading: (context) => const CircularProgressIndicator(),
            onError: (context, error) => Text('$error'),
            onState: (context, DateTime selectedDate) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: projectTheme.primaryColor,
                        ),
                        child: const Icon(Icons.arrow_left_rounded),
                        onPressed: () async {
                          dateselectStore.decrementMonth(selectedDate);
                          DateTime newDate =
                              selectedDate.subtract(const Duration(days: 31));
                          await faturamentosStore.getFaturamentos(
                            selectedDate: newDate,
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: projectTheme.primaryColor,
                      ),
                      child: Text(
                          '${conversoes.convertMonth(selectedDate.month)} - ${selectedDate.year}'),
                      onPressed: () async {
                        DateTime? newDate = await showMonthPicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (newDate == null) return;
                        dateselectStore.setDate(newDate);
                        await faturamentosStore.getFaturamentos(
                          selectedDate: newDate,
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: projectTheme.primaryColor,
                        ),
                        child: const Icon(Icons.arrow_right_rounded),
                        onPressed: () async {
                          dateselectStore.incrementMonth(selectedDate);
                          DateTime newDate =
                              selectedDate.add(const Duration(days: 31));
                          await faturamentosStore.getFaturamentos(
                            selectedDate: newDate,
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          ),
          ScopedBuilder<FaturamentosStore, Exception, List<Faturamento>>(
            store: faturamentosStore,
            onLoading: (context) => const LoadingWidget(),
            onError: (context, error) => Text('$error'),
            onState: (context, List<Faturamento> faturamentos) {
              if (faturamentos.isEmpty) {
                return const ListaVaziaWidget();
              } else {
                return Column(
                  children: [
                    for (final faturamento in faturamentos)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return FaturamentosFormWidget(
                                      faturamentoId: faturamento.id,
                                    );
                                  },
                                );
                              },
                              child: Container(
                                height: height * 0.1,
                                width: width * 0.95,
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.attach_money,
                                                color: Colors.blue[400],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                faturamento.titulo,
                                                style: const TextStyle(
                                                  fontFamily: 'Lato',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'R\$ ${faturamento.valor.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 14,
                                              color: Colors.blue[400],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            DateFormat('dd/MM/yyyy').format(
                                              DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                faturamento.data
                                                    .millisecondsSinceEpoch,
                                              ),
                                            ),
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
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
