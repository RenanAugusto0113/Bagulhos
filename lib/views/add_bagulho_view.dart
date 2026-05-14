import 'package:flutter/material.dart';
import '../models/bagulho_model.dart';
import '../services/api_service.dart';

class AddBagulhoView extends StatefulWidget {
  const AddBagulhoView({super.key});

  @override
  State<AddBagulhoView> createState() => _AddBagulhoViewState();
}

class _AddBagulhoViewState extends State<AddBagulhoView> {
  final _nameController = TextEditingController();
  final _tagController = TextEditingController();
  final _avatarController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _carregando = false;

  void _salvar() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O nome do bagulho é obrigatório!')),
      );
      return;
    }

    setState(() => _carregando = true);

    final novo = Bagulho(
      name: _nameController.text,
      tag: _tagController.text,
      avatar: _avatarController.text.isEmpty
          ? null // Quando null, o home_view.dart mostra o ícone padrão
          : _avatarController.text,
    );

    try {
      await _apiService.addBagulho(novo);
      if (mounted) Navigator.pop(context); // Volta para a Home
    } catch (e) {
      // Mostra um erro caso algo dê errado na API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Bagulho')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Bagulho',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tagController,
              decoration: const InputDecoration(
                labelText: 'Tag (Ex: Games, Músicas, Filmes, etc.)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.label),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _avatarController,
              decoration: const InputDecoration(
                labelText: 'Link[URL] do Avatar (Opcional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.image),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height:50,
              child: _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    onPressed: _salvar,
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.green[800]),
                    child: const Text('Salvar Bagulho', style: TextStyle(color: Colors.white)),
                  ),
            )
          ],
        ),
      ),
    );
  }
}