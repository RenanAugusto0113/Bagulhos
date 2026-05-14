import 'package:flutter/material.dart';
import '../models/bagulho_model.dart';
import '../services/api_service.dart';

class EditBagulhoView extends StatefulWidget {
  final Bagulho bagulho;
  const EditBagulhoView({super.key, required this.bagulho});

  @override
  State<EditBagulhoView> createState() => _EditBagulhoViewState();
}

class _EditBagulhoViewState extends State<EditBagulhoView> {
  late TextEditingController _nameController;
  late TextEditingController _tagController;
  late TextEditingController _avatarController;
  final ApiService _apiService = ApiService();
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.bagulho.name);
    _tagController = TextEditingController(text: widget.bagulho.tag);
    _avatarController = TextEditingController(text: widget.bagulho.avatar);
  }

  void _atualizar() async {
    setState(() => _carregando = true);
    final bagulhoAtualizado = Bagulho(
      id: widget.bagulho.id,
      name: _nameController.text,
      tag: _tagController.text,
      avatar: _avatarController.text,
    );

    try {
      await _apiService.updateBagulho(bagulhoAtualizado);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      setState(() => _carregando = false);
    }
  }

  void _excluir() async {
    // Confirmação antes de excluir
    bool confirmar = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Excluir Bagulho?"),
        content: const Text("Essa ação não pode ser desfeita."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancelar")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Excluir", style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (confirmar) {
      setState(() => _carregando = true);
      try {
        await _apiService.deleteBagulho(widget.bagulho.id!);
        if (mounted) Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao excluir: $e')));
      } finally {
        setState(() => _carregando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Bagulho"),
        automaticallyImplyLeading: false,
        actions: [
          // O "X" para fechar sem salvar no canto superior direito
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nome')),
            TextField(controller: _tagController, decoration: const InputDecoration(labelText: 'Tag')),
            TextField(controller: _avatarController, decoration: const InputDecoration(labelText: 'URL do Avatar')),
            const SizedBox(height: 30),
            if (_carregando) 
              const CircularProgressIndicator()
            else ...[
              ElevatedButton(
                onPressed: _atualizar, 
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.green[800]),
                child: const Text("Salvar Alterações", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: _excluir, 
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text("Excluir Bagulho", style: TextStyle(color: Colors.red)),
              ),
            ]
          ],
        ),
      ),
    );
  }
}