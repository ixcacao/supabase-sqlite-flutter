import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_premium_database_switch_supabase_sqlite/bloc/premium_bloc.dart';
import 'package:sample_premium_database_switch_supabase_sqlite/managers/database_manager.dart';

void main() {


  final PremiumBloc premiumBloc = PremiumBloc();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(lazy: false, create: (BuildContext context) => premiumBloc),],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ///such bad practice qaq
    final DatabaseManager databaseManager = DatabaseManager(false);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page', databaseManager: databaseManager,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.databaseManager});


  final String title;
  final DatabaseManager databaseManager;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _money = 0;
  @override
  void initState() async {
    // TODO: implement initState
    List temp = await widget.databaseManager.queryAll('money');
    _money = temp[0]['amount'];
    super.initState();
  }


  void _incrementMoney() {

    widget.databaseManager.update('money', {'user_id': 'nyehe', 'id': 1, 'amount': _money++});
    setState(() {
      _money;
    });
  }
  void _setPremium() {
    BlocProvider.of<PremiumBloc>(context).add(SetPremium());
  }

  void _removePremium(){
    BlocProvider.of<PremiumBloc>(context).add(RemovePremium());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocBuilder<PremiumBloc, PremiumState>(builder: (_, state){
              if(state is Premium){
                return Text("State: Premium");
              } else {
                return Text("State: NOT Premium");
              }
            }),

            const Text(
              'Money:',
            ),
            Text(
              '$_money',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(onPressed: _setPremium, child: Text("Set Premium")),
            ElevatedButton(onPressed: _removePremium, child: Text("Remove Premium"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementMoney,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
