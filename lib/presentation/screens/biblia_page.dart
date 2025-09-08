// lib/presentation/screens/biblia_page.dart
import 'package:flutter/material.dart';

class BibliaPage extends StatelessWidget { // ✅ OPTIMIZED: StatelessWidget for better performance
  const BibliaPage({super.key}); // ✅ FIXED: Using super.key parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC), // ✅ IMPROVED: Consistent with app theme
      appBar: AppBar(
        title: const Text(
          'Sagradas Escrituras',
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
            const SizedBox(height: 20),
            
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
                    Icons.menu_book,
                    size: 80,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  Text(
                    '📖 Sagradas Escrituras',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'La Palabra de Dios al alcance de tus manos',
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
            
            // ✅ ADDED: Search bar preview
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
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
                  Icon(Icons.search, color: Color(0xFF8D6E63), size: 24),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Buscar versículos, capítulos...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Icon(Icons.mic_none, color: Color(0xFF8D6E63), size: 24),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // ✅ ADDED: Feature cards
            _buildFeatureCard(
              icon: Icons.library_books,
              title: 'Múltiples Versiones',
              description: 'Reina-Valera, NVI, Biblia de Jerusalén y más',
              color: const Color(0xFF4CAF50),
            ),
            
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              icon: Icons.highlight,
              title: 'Resaltado y Notas',
              description: 'Marca tus versículos favoritos y añade reflexiones',
              color: const Color(0xFFFF9800),
            ),
            
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              icon: Icons.bookmark,
              title: 'Favoritos',
              description: 'Guarda y organiza los versículos más importantes',
              color: const Color(0xFF2196F3),
            ),
            
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              icon: Icons.volume_up,
              title: 'Audio Bíblico',
              description: 'Escucha la Palabra de Dios en español',
              color: const Color(0xFF9C27B0),
            ),
            
            const SizedBox(height: 32),
            
            // ✅ ADDED: Bible books preview
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_stories, color: Color(0xFF8D6E63), size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Libros de la Biblia',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D4037),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Acceso rápido a todos los libros sagrados:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8D6E63),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Book categories preview
                  Row(
                    children: [
                      Expanded(
                        child: _buildBookCategory(
                          'Antiguo\nTestamento',
                          '39 libros',
                          Icons.book,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildBookCategory(
                          'Nuevo\nTestamento',
                          '27 libros',
                          Icons.auto_stories,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
                          'Estamos preparando una experiencia completa de estudio bíblico con todas estas funciones y más.',
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

  // ✅ ADDED: Book category widget
  Widget _buildBookCategory(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF8D6E63).withValues(alpha: 0.1),
            const Color(0xFF5D4037).withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF8D6E63),
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5D4037),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
