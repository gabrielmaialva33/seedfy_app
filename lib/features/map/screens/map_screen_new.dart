import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/auth_provider.dart';
import '../widgets/garden_grid.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<BedData> _beds = [
    const BedData(
      id: '1',
      x: 1,
      y: 1,
      widthM: 1.2,
      heightM: 2.0,
      cropName: 'Alface',
      status: BedStatus.healthy,
      daysUntilHarvest: 25,
    ),
    const BedData(
      id: '2',
      x: 3,
      y: 1,
      widthM: 1.0,
      heightM: 1.5,
      cropName: 'Tomate',
      status: BedStatus.warning,
      daysUntilHarvest: 15,
    ),
    const BedData(
      id: '3',
      x: 1,
      y: 4,
      widthM: 2.0,
      heightM: 1.0,
      cropName: 'Cenoura',
      status: BedStatus.critical,
      daysUntilHarvest: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa da Horta'),
        backgroundColor: theme.colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddBedDialog,
            tooltip: 'Adicionar Canteiro',
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Text('Exportar CSV'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Configurações'),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Sair'),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'logout':
                  context.read<AuthProvider>().signOut();
                  break;
                case 'export':
                  _exportToCsv();
                  break;
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.surfaceContainer,
            child: Row(
              children: [
                _buildStatusLegend('Saudável', Colors.green),
                const SizedBox(width: 16),
                _buildStatusLegend('Atenção', Colors.orange),
                const SizedBox(width: 16),
                _buildStatusLegend('Crítico', Colors.red),
                const SizedBox(width: 16),
                _buildStatusLegend('Vazio', Colors.grey),
              ],
            ),
          ),
          Expanded(
            child: GardenGrid(
              plotLength: 6.0,
              plotWidth: 8.0,
              pathGap: 0.4,
              beds: _beds,
              onBedTapped: _handleBedTapped,
              onAddBed: _handleAddBed,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBedDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatusLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  void _handleBedTapped(BedData bed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Canteiro: ${bed.cropName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Posição: (${bed.x}, ${bed.y})'),
            Text('Tamanho: ${bed.widthM}m x ${bed.heightM}m'),
            Text('Área: ${(bed.widthM * bed.heightM).toStringAsFixed(1)}m²'),
            if (bed.daysUntilHarvest >= 0)
              Text('Dias para colheita: ${bed.daysUntilHarvest}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Abrir editor do canteiro
            },
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  void _handleAddBed(Offset position) {
    // Converter posição do pixel para coordenadas do grid
    const scale = 50.0;
    final gridX = (position.dx / scale).round();
    final gridY = (position.dy / scale).round();
    
    // TODO: Implementar adição de canteiro
    debugPrint('Add bed at grid position: ($gridX, $gridY)');
  }

  void _showAddBedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Canteiro'),
        content: const Text('Funcionalidade em desenvolvimento'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _exportToCsv() {
    // TODO: Implementar exportação CSV
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exportação CSV em desenvolvimento'),
      ),
    );
  }
}