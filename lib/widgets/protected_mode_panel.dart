import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../providers/app_state.dart';
import '../utils/theme.dart';

class ProtectedModePanel extends StatefulWidget {
  final VoidCallback onClose;

  const ProtectedModePanel({
    super.key,
    required this.onClose,
  });

  @override
  State<ProtectedModePanel> createState() => _ProtectedModePanelState();
}

class _ProtectedModePanelState extends State<ProtectedModePanel> {
  final TextEditingController _updateDataController = TextEditingController();
  final TextEditingController _personalityNameController = TextEditingController();
  final TextEditingController _personalityConfigController = TextEditingController();
  
  bool _isUpdating = false;
  String _updateStatus = '';

  @override
  void dispose() {
    _updateDataController.dispose();
    _personalityNameController.dispose();
    _personalityConfigController.dispose();
    super.dispose();
  }

  Future<void> _performAutoUpdate() async {
    if (_updateDataController.text.trim().isEmpty) {
      setState(() {
        _updateStatus = 'Error: No hay datos para actualizar';
      });
      return;
    }

    setState(() {
      _isUpdating = true;
      _updateStatus = 'Iniciando auto-actualización...';
    });

    try {
      final updateData = json.decode(_updateDataController.text);
      final appState = context.read<AppState>();
      
      await appState.performAutoUpdate(updateData);
      
      setState(() {
        _updateStatus = 'Auto-actualización completada exitosamente';
      });
      
      // Limpiar el campo después de una actualización exitosa
      _updateDataController.clear();
      
    } catch (e) {
      setState(() {
        _updateStatus = 'Error durante la actualización: $e';
      });
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  Future<void> _addCustomPersonality() async {
    if (_personalityNameController.text.trim().isEmpty || 
        _personalityConfigController.text.trim().isEmpty) {
      return;
    }

    try {
      final config = json.decode(_personalityConfigController.text);
      final appState = context.read<AppState>();
      
      await appState.addCustomPersonality(
        _personalityNameController.text.trim(),
        config,
      );
      
      _personalityNameController.clear();
      _personalityConfigController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Personalidad personalizada agregada'),
          backgroundColor: Colors.green,
        ),
      );
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al agregar personalidad: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: SafeArea(
        child: Column(
          children: [
            // Barra superior
            _buildTopBar(),
            
            // Contenido
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Estado del modo protegido
                    _buildStatusSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Botones rápidos
                    _buildQuickActionsSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Auto-actualización simplificada
                    _buildSimpleUpdateSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Personalidades personalizadas
                    _buildCustomPersonalitiesSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Configuración avanzada
                    _buildAdvancedConfigSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: Colors.red.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: widget.onClose,
            icon: const Icon(Icons.close, color: Colors.white),
          ),
          
          const SizedBox(width: 12),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'MODO PROTEGIDO',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          
          const Spacer(),
          
          IconButton(
            onPressed: () {
              context.read<AppState>().logoutProtectedMode();
              widget.onClose();
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Card(
          color: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.security,
                      color: Colors.green,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Estado del Modo Protegido',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                _buildStatusItem('Autenticado', appState.isAuthenticated, Colors.green),
                _buildStatusItem('Modo Activo', appState.isProtectedMode, Colors.blue),
                _buildStatusItem('Personalidades Personalizadas', appState.customPersonalities.length, Colors.orange),
                _buildStatusItem('Configuraciones Avanzadas', appState.advancedConfig.length, Colors.purple),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusItem(String label, dynamic value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color),
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Card(
          color: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.speed,
                      color: Colors.yellow,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Acciones Rápidas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                if (appState.isProtectedMode) ...[
                  _buildQuickActionButton(
                    'Desactivar Modo Protegido',
                    Icons.lock_open,
                    Colors.red,
                    () {
                      appState.logoutProtectedMode();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Modo Protegido desactivado'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  ),
                ] else ...[
                  _buildQuickActionButton(
                    'Activar Modo Protegido',
                    Icons.lock,
                    Colors.green,
                    () {
                      appState.loginProtectedMode();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Modo Protegido activado'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),
                ],
                
                const SizedBox(height: 12),
                
                _buildQuickActionButton(
                  'Actualizar Configuraciones',
                  Icons.system_update,
                  Colors.blue,
                  () {
                    // This action is handled by the simple update section
                  },
                ),
                
                const SizedBox(height: 12),
                
                _buildQuickActionButton(
                  'Agregar Personalidad',
                  Icons.psychology,
                  Colors.orange,
                  () {
                    // This action is handled by the custom personalities section
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(label),
      ),
    );
  }

  Widget _buildSimpleUpdateSection() {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.system_update,
                  color: Colors.blue,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Auto-Actualización Simplificada',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            TextField(
              controller: _updateDataController,
              maxLines: 8,
              style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
              decoration: InputDecoration(
                hintText: 'Pega aquí los datos JSON para auto-actualización...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[600]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                filled: true,
                fillColor: Colors.grey[800],
              ),
            ),
            
            const SizedBox(height: 12),
            
            if (_updateStatus.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _updateStatus.contains('Error') 
                    ? Colors.red.withOpacity(0.2)
                    : Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _updateStatus.contains('Error') 
                      ? Colors.red 
                      : Colors.green,
                  ),
                ),
                child: Text(
                  _updateStatus,
                  style: TextStyle(
                    color: _updateStatus.contains('Error') 
                      ? Colors.red 
                      : Colors.green,
                  ),
                ),
              ),
            
            const SizedBox(height: 12),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isUpdating ? null : _performAutoUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isUpdating
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Actualizando...'),
                        ],
                      )
                    : const Text('Ejecutar Auto-Actualización'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomPersonalitiesSection() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Card(
          color: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.psychology,
                      color: Colors.orange,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Personalidades Personalizadas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Lista de personalidades personalizadas
                if (appState.customPersonalities.isNotEmpty) ...[
                  ...appState.customPersonalities.map((personality) => 
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.orange),
                      title: Text(
                        personality,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          appState.removeCustomPersonality(personality);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Agregar nueva personalidad
                TextField(
                  controller: _personalityNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Nombre de la personalidad',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[800],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                TextField(
                  controller: _personalityConfigController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
                  decoration: InputDecoration(
                    labelText: 'Configuración JSON',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    hintText: '{"name": "Nombre", "description": "Descripción", ...}',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[800],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addCustomPersonality,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Agregar Personalidad'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdvancedConfigSection() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Card(
          color: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Colors.purple,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Configuración Avanzada',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                if (appState.advancedConfig.isNotEmpty) ...[
                  ...appState.advancedConfig.entries.map((entry) => 
                    ListTile(
                      leading: const Icon(Icons.settings, color: Colors.purple),
                      title: Text(
                        entry.key,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        entry.value.toString(),
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ),
                  ),
                ] else ...[
                  const Text(
                    'No hay configuraciones avanzadas',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProtectedSettingsSection() {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Card(
          color: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lock,
                      color: Colors.red,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Configuraciones Protegidas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                if (appState.protectedSettings.isNotEmpty) ...[
                  ...appState.protectedSettings.entries.map((entry) => 
                    ListTile(
                      leading: const Icon(Icons.lock, color: Colors.red),
                      title: Text(
                        entry.key,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        entry.value.toString(),
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ),
                  ),
                ] else ...[
                  const Text(
                    'No hay configuraciones protegidas',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}