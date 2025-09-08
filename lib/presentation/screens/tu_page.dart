// lib/presentation/screens/tu_page.dart
import 'package:flutter/material.dart';

class TuPage extends StatelessWidget { // ✅ OPTIMIZED: StatelessWidget for better performance
  const TuPage({super.key}); // ✅ FIXED: Using super.key parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC), // ✅ IMPROVED: Consistent with app theme
      appBar: AppBar(
        title: const Text(
          'Tu Día Espiritual',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF8D6E63),
        elevation: 2,
        centerTitle: true,
      ),
      body: SingleChildScrollView( // ✅ ADDED: Scrollable for better UX
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            // ✅ ENHANCED: Beautiful hero section
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8D6E63), Color(0xFF5D4037)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.self_improvement,
                    size: 80,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  Text(
                    '🌅 Tu Camino Espiritual',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Un espacio dedicado a tu crecimiento en la fe',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // ✅ ADDED: Feature preview cards
            _buildFeatureCard(
              icon: Icons.auto_stories,
              title: 'Devocionales Diarios',
              description: 'Reflexiones bíblicas personalizadas para cada día',
              color: const Color(0xFF4CAF50),
            ),
            
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              icon: Icons.trending_up,
              title: 'Progreso Espiritual',
              description: 'Seguimiento de tu crecimiento en la fe y oración',
              color: const Color(0xFF2196F3),
            ),
            
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              icon: Icons.calendar_today,
              title: 'Plan de Lectura',
              description: 'Programa personalizado para leer la Biblia',
              color: const Color(0xFFFF9800),
            ),
            
            const SizedBox(height: 32),
            
            // ✅ ADDED: Coming soon message
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF8D6E63).withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.construction,
                    color: Color(0xFF8D6E63),
                    size: 24,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Próximamente',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5D4037),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Estamos trabajando en estas increíbles funciones para enriquecer tu experiencia espiritual.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF8D6E63),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ✅ ADDED: Reusable feature card widget
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D4037),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
