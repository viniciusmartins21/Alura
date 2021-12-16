// import 'dart:ffi';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_fonts/google_fonts.dart';

void main() => runApp(
      MaterialApp(
        themeMode: ThemeMode.dark,
        home: ListaTransferencias(),
      ),
    );

// ------- Classes de refarotação --------
class ListaTransferencias extends StatefulWidget {
  final List<Transferencia> _transferencias = [];

  @override
  State<StatefulWidget> createState() {
    return ListaTransferenciaState();
  }
}

class ListaTransferenciaState extends State<ListaTransferencias> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // alteração teste na animação
        title: Text(
          'Transferencias',
          style: GoogleFonts.aBeeZee(),
        ),
      ),
      body: ListView.builder(
        itemCount: widget._transferencias.length,
        itemBuilder: (context, indice) {
          final transferencia = widget._transferencias[indice];
          return ItemTransferencia(transferencia);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_sharp),
        onPressed: () {
          final Future future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioTransferencia();
          }));
          // ignore: non_constant_identifier_names
          future.then((transferenciaRecebida) {
            Future.delayed(
                Duration(
                  seconds: 1,
                ), () {
              debugPrint('chegou no then do future');
              debugPrint('$transferenciaRecebida');
              if (transferenciaRecebida != null) {
                setState(() {
                  widget._transferencias.add(transferenciaRecebida);
                });
              }
            });
          });
        },
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on_outlined),
        title: Text(_transferencia.valor.toString()),
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
  }
}

class FormularioTransferencia extends StatefulWidget {
  @override
  State<FormularioTransferencia> createState() =>
      _FormularioTransferenciaState();
}

class _FormularioTransferenciaState extends State<FormularioTransferencia> {
  @override
  Widget build(BuildContext context) {
    // Controlers
    final TextEditingController _controladorCampoNumeroconta =
        TextEditingController();

    final TextEditingController _controladorCampoValor =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Criando uma transferência',
          style: GoogleFonts.aBeeZee(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // field de numero da conta
            Editor(
              controlador: _controladorCampoNumeroconta,
              dica: '0000',
              rotulo: 'Número da conta',
            ),

            Editor(
              controlador: _controladorCampoValor,
              dica: '0.00',
              rotulo: 'Valor',
              icone: Icons.monetization_on,
            ),
            // botao de confirmar transação
            ElevatedButton(
              child: Text('Confirmar'),
              onPressed: () => _criaTransferencia(
                _controladorCampoNumeroconta,
                _controladorCampoValor,
                context,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _criaTransferencia(TextEditingController _controladorCampoNumeroconta,
      TextEditingController _controladorCampoValor, BuildContext context) {
    final int numeroConta = int.parse(_controladorCampoNumeroconta.text);
    final double valor = double.parse(_controladorCampoValor.text);

    if (numeroConta != null && valor != null) {
      final transferenciaCriada = Transferencia(valor, numeroConta);
      debugPrint('criando transferencia');
      debugPrint('$transferenciaCriada');
      Navigator.pop(context, transferenciaCriada);

      // Snack bar para avisar q deu certo indicando verde em uma linha na tela
      // ignore: deprecated_member_use
      // Scaffold.of(context).showSnackBar(
      //   SnackBar(
      //     content: Row(
      //       children: [
      //         Icon(Icons.check_circle),
      //         Text('$transferenciaCriada'),
      //       ],
      //     ),
      //     backgroundColor: Colors.green,
      //   ),
      // );
    }
  }
}

class Editor extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final IconData? icone;

  // ignore: use_key_in_widget_constructors
  Editor(
      {required this.controlador,
      required this.rotulo,
      required this.dica,
      this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: TextField(
        controller: controlador,
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: 'Caveat-Variable',
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          icon: icone != null ? Icon(icone) : null,
          labelText: rotulo,
          hintText: dica,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}

class Transferencia {
  final double valor;
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta);

  @override
  String toString() {
    return 'Transferencia{valor: $valor, numeroConta: $numeroConta';
  }
}
