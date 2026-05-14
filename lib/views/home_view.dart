import 'package:flutter/material.dart';
import '../models/bagulho_model.dart';
import '../services/api_service.dart';
import '../views/add_bagulho_view.dart';
import '../views/edit_bagulho_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ApiService apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<Bagulho> todosBagulhos = [];
  List<Bagulho> bagulhosFiltrados = [];
  bool carregando = true;
  String query = "";

  @override
  void initState() {
    super.initState();
    _carregarBagulhos();
  }

  Future<void> _carregarBagulhos() async {
    try {
      final bagulhos = await apiService.getBagulhos();
      setState(() {
        todosBagulhos = bagulhos;
        bagulhosFiltrados = bagulhos; // Inicialmente, mostra todos
        _filtrar(_searchController.text); // Aplica o filtro se já houver texto
        carregando = false;
      });
    } catch (e) {
      setState(() => carregando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar bagulhos: $e')),
      );
    }
  }

  void _filtrar(String texto) {
    setState(() {
      query = texto;
      bagulhosFiltrados = todosBagulhos.where((item) {
        final nameSub = item.name.toLowerCase();
        final tagSub = (item.tag ?? '').toLowerCase();
        final busca = texto.toLowerCase();
        return nameSub.contains(busca) || tagSub.contains(busca);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.black),
          onChanged: _filtrar,
          decoration: InputDecoration(
            hintText: 'Buscar por nome ou categoria...',
            hintStyle: const TextStyle(color: Colors.black),
            border: InputBorder.none,
            icon: const Icon(Icons.search, color: Colors.black),
            suffixIcon: query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.black),
                    onPressed: () {
                      // Limpa a barra de pesquisa e mostra todos os bagulhos novamente
                      setState(() {
                        query = "";
                        _searchController.clear();
                        bagulhosFiltrados = todosBagulhos;
                      });
                    },
                  )
                : null,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_by_alpha),
            onPressed: () {
              setState(() {
                bagulhosFiltrados.sort((a, b) => a.name.compareTo(b.name));
              });
            },
          ),
        ],
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : _construirLista(),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBagulhoView()),
          );
/* Tempo para garantir que a API tenha processado o novo bagulho antes de recarregar a lista
caso o usuario tenha hardware muito recente ou conexão lenta */
          await Future.delayed(const Duration(milliseconds: 400));
          _carregarBagulhos(); // Recarrega a lista após adicionar um novo bagulho
        },
        backgroundColor: Colors.green[400],
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _construirLista() {
    if (bagulhosFiltrados.isEmpty) {
      return const Center(child: Text("Nenhum bagulho encontrado :("));
    }
    return ListView.builder(
      itemCount: bagulhosFiltrados.length,
      itemBuilder: (context, index) {
        final item = bagulhosFiltrados[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            title: Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Categoria: ${item.tag ?? ''}"),
                if (item.criadoEm != null)
                  Text(
                    "Criado em: ${item.criadoEm!.day}/${item.criadoEm!.month}/${item.criadoEm!.year}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),    
              ],
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            leading: CircleAvatar(
              backgroundColor: Colors.black87,
              child: (item.avatar == null || item.avatar!.isEmpty)
                  ? Icon(Icons.inventory_2, color: Colors.white)
                  : null,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async{
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditBagulhoView(bagulho: item),
                ),
              );
              _carregarBagulhos(); // Recarrega a lista após editar um bagulho
            },
          ),
        );
      },
    );
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}