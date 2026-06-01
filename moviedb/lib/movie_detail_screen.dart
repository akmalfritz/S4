import 'package:flutter/material.dart';
import 'movie_model.dart';

class MovieDetailScreen extends StatelessWidget {
  final MovieModel movie;

  const MovieDetailScreen({super.key, required this.movie});

  static const String _posterBase = 'https://image.tmdb.org/t/p/w500';
  static const String _backdropBase = 'https://image.tmdb.org/t/p/w780';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderRow(context),
                  const SizedBox(height: 20),
                  _buildStatsRow(),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Deskripsi',
                    child: Text(
                      movie.overview != null && movie.overview!.isNotEmpty
                          ? movie.overview!
                          : 'Deskripsi tidak tersedia untuk film ini.',
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.75,
                        color: Color(0xFF444444),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Informasi',
                    child: _buildInfoTable(),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: const Color(0xFF1A1A2E),
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: movie.backdropPath != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    '$_backdropBase${movie.backdropPath}',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _backdropPlaceholder(),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xCC1A1A2E)],
                      ),
                    ),
                  ),
                ],
              )
            : _backdropPlaceholder(),
      ),
    );
  }

  Widget _backdropPlaceholder() {
    return Container(
      color: const Color(0xFF1A1A2E),
      child: const Center(
        child: Icon(Icons.movie, size: 80, color: Colors.white24),
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Poster
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: movie.posterPath != null
              ? Image.network(
                  '$_posterBase${movie.posterPath}',
                  width: 110,
                  height: 165,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _posterPlaceholder(),
                )
              : _posterPlaceholder(),
        ),
        const SizedBox(width: 16),
        // Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title ?? 'Tanpa Judul',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              _buildRatingBadge(),
              const SizedBox(height: 8),
              Text(
                'Rilis: ${movie.releaseDate ?? 'Tidak diketahui'}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF888888),
                ),
              ),
              const SizedBox(height: 6),
              if (movie.voteCount != null)
                Text(
                  '${movie.voteCount} ulasan',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF888888),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _posterPlaceholder() {
    return Container(
      width: 110,
      height: 165,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.image_not_supported,
          color: Color(0xFFAAAAAA), size: 36),
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFE5A100), size: 18),
          const SizedBox(width: 4),
          Text(
            movie.ratingFormatted,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7A5500),
            ),
          ),
          const Text(
            ' / 10',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF7A5500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _statCard(
          icon: Icons.star_outline_rounded,
          label: 'Rating',
          value: movie.ratingFormatted,
          color: const Color(0xFFFF9800),
        ),
        const SizedBox(width: 12),
        _statCard(
          icon: Icons.calendar_today_outlined,
          label: 'Tahun',
          value: movie.releaseYear,
          color: const Color(0xFF2196F3),
        ),
        const SizedBox(width: 12),
        _statCard(
          icon: Icons.how_to_vote_outlined,
          label: 'Voters',
          value: movie.voteCount != null
              ? _formatCount(movie.voteCount!)
              : 'N/A',
          color: const Color(0xFF4CAF50),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF888888),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 36,
          height: 3,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 14),
        child,
      ],
    );
  }

  Widget _buildInfoTable() {
    final rows = [
      _InfoRow(label: 'Judul', value: movie.title ?? '-'),
      _InfoRow(label: 'Tanggal Rilis', value: movie.releaseDate ?? '-'),
      _InfoRow(label: 'Rating', value: '${movie.ratingFormatted} / 10'),
      _InfoRow(
        label: 'Jumlah Voter',
        value: movie.voteCount != null
            ? '${movie.voteCount} orang'
            : '-',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final isLast = entry.key == rows.length - 1;
          final row = entry.value;
          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(
                      bottom: BorderSide(color: Color(0xFFF0F0F0)),
                    ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 110,
                  child: Text(
                    row.label,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF888888),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    row.value,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}

class _InfoRow {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});
}