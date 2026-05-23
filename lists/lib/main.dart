import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'item_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventaris Ku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
      ),
      home: const ItemListPage(),
    );
  }
}

// ─── Warna & Konstanta ───────────────────────────────────────────────
const kBg = Color(0xFF0F0E17);
const kSurface = Color(0xFF1A1928);
const kCard = Color(0xFF222136);
const kPrimary = Color(0xFF6C63FF);
const kAccent = Color(0xFFFF6584);
const kGreen = Color(0xFF43D9AD);
const kYellow = Color(0xFFFFD166);
const kTextPrimary = Color(0xFFF0EFF8);
const kTextSecondary = Color(0xFF9896B0);

const kCategories = ['Semua', 'Elektronik', 'Furnitur', 'Pakaian', 'Makanan', 'Umum'];

const kCategoryColors = {
  'Elektronik': Color(0xFF6C63FF),
  'Furnitur': Color(0xFF43D9AD),
  'Pakaian': Color(0xFFFF6584),
  'Makanan': Color(0xFFFFD166),
  'Umum': Color(0xFF9896B0),
};

// ─── Halaman Utama ───────────────────────────────────────────────────
class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage>
    with SingleTickerProviderStateMixin {
  List<ItemModel> _items = [];
  List<ItemModel> _filtered = [];
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _selectedNewCategory = 'Umum';
  late AnimationController _fabAnim;

  final List<ItemModel> _dummyItems = [
    ItemModel(id: 1, name: 'MacBook Pro', description: 'Laptop kerja utama', category: 'Elektronik'),
    ItemModel(id: 2, name: 'Mouse Logitech', description: 'Mouse wireless ergonomis', category: 'Elektronik'),
    ItemModel(id: 3, name: 'Keyboard Mechanical', description: 'Switch brown, RGB', category: 'Elektronik'),
    ItemModel(id: 4, name: 'Meja Belajar', description: 'Meja kayu minimalis 120cm', category: 'Furnitur'),
    ItemModel(id: 5, name: 'Kemeja Putih', description: 'Bahan katun, slim fit', category: 'Pakaian'),
    ItemModel(id: 6, name: 'Snack Coklat', description: 'Persediaan camilan mingguan', category: 'Makanan'),
  ];

  @override
  void initState() {
    super.initState();
    _fabAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _fabAnim.dispose();
    _searchController.dispose();
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _applyFilter();
    });
  }

  void _applyFilter() {
    _filtered = _items.where((item) {
      final matchSearch = item.name.toLowerCase().contains(_searchQuery) ||
          item.description.toLowerCase().contains(_searchQuery);
      final matchCategory =
          _selectedCategory == 'Semua' || item.category == _selectedCategory;
      return matchSearch && matchCategory;
    }).toList();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsString = prefs.getString('items_list');
    if (itemsString != null) {
      final List<dynamic> decoded = json.decode(itemsString);
      setState(() {
        _items = decoded.map((e) => ItemModel.fromMap(e)).toList();
        _applyFilter();
      });
    } else {
      setState(() {
        _items = List.from(_dummyItems);
        _applyFilter();
      });
      await _saveData();
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_items.map((e) => e.toMap()).toList());
    await prefs.setString('items_list', encoded);
  }

  Future<void> _addItem() async {
    if (_nameController.text.isEmpty || _descController.text.isEmpty) {
      _showSnack('Nama dan deskripsi tidak boleh kosong', isError: true);
      return;
    }
    final newId = _items.isNotEmpty ? _items.last.id + 1 : 1;
    final newItem = ItemModel(
      id: newId,
      name: _nameController.text,
      description: _descController.text,
      category: _selectedNewCategory,
    );
    setState(() {
      _items.add(newItem);
      _applyFilter();
    });
    await _saveData();
    _nameController.clear();
    _descController.clear();
    _selectedNewCategory = 'Umum';
    if (mounted) {
      Navigator.pop(context);
      _showSnack('Item berhasil ditambahkan ✓');
    }
  }

  Future<void> _deleteItem(int id) async {
    setState(() {
      _items.removeWhere((item) => item.id == id);
      _applyFilter();
    });
    await _saveData();
    _showSnack('Item dihapus');
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: kTextPrimary)),
        backgroundColor: isError ? kAccent : kGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddDialog() {
    _selectedNewCategory = 'Umum';
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setLocalState) {
          return Dialog(
            backgroundColor: kCard,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header dialog
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: kPrimary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.add_box_rounded,
                            color: kPrimary, size: 22),
                      ),
                      const SizedBox(width: 12),
                      const Text('Tambah Item Baru',
                          style: TextStyle(
                              color: kTextPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildDialogField(
                    controller: _nameController,
                    label: 'Nama Item',
                    icon: Icons.label_rounded,
                  ),
                  const SizedBox(height: 14),
                  _buildDialogField(
                    controller: _descController,
                    label: 'Deskripsi',
                    icon: Icons.notes_rounded,
                  ),
                  const SizedBox(height: 14),
                  // Dropdown kategori
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: kSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kPrimary.withOpacity(0.3)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedNewCategory,
                        dropdownColor: kCard,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded,
                            color: kPrimary),
                        items: kCategories
                            .where((c) => c != 'Semua')
                            .map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c,
                                      style: const TextStyle(
                                          color: kTextPrimary, fontSize: 14)),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setLocalState(() => _selectedNewCategory = val!);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: kTextSecondary,
                            side: BorderSide(color: kTextSecondary.withOpacity(0.4)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            elevation: 0,
                          ),
                          onPressed: _addItem,
                          child: const Text('Simpan',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildDialogField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: kTextPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: kTextSecondary, fontSize: 13),
        prefixIcon: Icon(icon, color: kPrimary, size: 20),
        filled: true,
        fillColor: kSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPrimary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildCategoryFilter(),
            _buildStats(),
            Expanded(child: _buildList()),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(parent: _fabAnim, curve: Curves.elasticOut),
        child: FloatingActionButton.extended(
          onPressed: _showAddDialog,
          backgroundColor: kPrimary,
          foregroundColor: Colors.white,
          elevation: 4,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Tambah Item',
              style: TextStyle(fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Inventaris Ku',
                  style: TextStyle(
                      color: kTextPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5)),
              Text('${_items.length} item tersimpan',
                  style: const TextStyle(color: kTextSecondary, fontSize: 13)),
            ],
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [kPrimary, Color(0xFF9B8FFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.inventory_2_rounded,
                color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }

  // ── Search Bar ───────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Container(
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _searchQuery.isNotEmpty
                ? kPrimary.withOpacity(0.5)
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: kPrimary.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: kTextPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Cari nama atau deskripsi item...',
            hintStyle: const TextStyle(color: kTextSecondary, fontSize: 14),
            prefixIcon:
                const Icon(Icons.search_rounded, color: kPrimary, size: 22),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded,
                        color: kTextSecondary, size: 20),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
      ),
    );
  }

  // ── Category Filter Chips ────────────────────────────────────────────
  Widget _buildCategoryFilter() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: SizedBox(
        height: 38,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: kCategories.length,
          itemBuilder: (ctx, i) {
            final cat = kCategories[i];
            final isSelected = _selectedCategory == cat;
            final color = cat == 'Semua'
                ? kPrimary
                : (kCategoryColors[cat] ?? kPrimary);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = cat;
                    _applyFilter();
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? color : kSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? color : color.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? Colors.white : color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Stats Row ────────────────────────────────────────────────────────
  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 6),
      child: Row(
        children: [
          Text(
            _filtered.isEmpty
                ? 'Tidak ada hasil'
                : 'Menampilkan ${_filtered.length} dari ${_items.length} item',
            style:
                const TextStyle(color: kTextSecondary, fontSize: 12),
          ),
          const Spacer(),
          if (_searchQuery.isNotEmpty || _selectedCategory != 'Semua')
            GestureDetector(
              onTap: () {
                setState(() {
                  _searchController.clear();
                  _selectedCategory = 'Semua';
                  _applyFilter();
                });
              },
              child: const Row(
                children: [
                  Icon(Icons.filter_alt_off_rounded,
                      color: kAccent, size: 14),
                  SizedBox(width: 4),
                  Text('Reset filter',
                      style: TextStyle(color: kAccent, fontSize: 12)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ── List ─────────────────────────────────────────────────────────────
  Widget _buildList() {
    if (_filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isNotEmpty
                  ? Icons.search_off_rounded
                  : Icons.inbox_rounded,
              size: 64,
              color: kTextSecondary.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Tidak ditemukan hasil\nuntuk "$_searchQuery"'
                  : 'Belum ada item.\nTambahkan item baru!',
              textAlign: TextAlign.center,
              style: const TextStyle(color: kTextSecondary, fontSize: 14, height: 1.6),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      itemCount: _filtered.length,
      itemBuilder: (ctx, index) {
        final item = _filtered[index];
        return _buildItemCard(item, index);
      },
    );
  }

  Widget _buildItemCard(ItemModel item, int index) {
    final catColor = kCategoryColors[item.category] ?? kPrimary;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + index * 60),
      curve: Curves.easeOutCubic,
      builder: (ctx, val, child) {
        return Opacity(
          opacity: val,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - val)),
            child: child,
          ),
        );
      },
      child: Dismissible(
        key: Key('item_${item.id}'),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: kAccent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: kAccent.withOpacity(0.3)),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete_outline_rounded, color: kAccent, size: 26),
              SizedBox(height: 4),
              Text('Hapus',
                  style: TextStyle(color: kAccent, fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        confirmDismiss: (dir) async {
          return await _confirmDelete(item);
        },
        onDismissed: (_) => _deleteItem(item.id),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: catColor.withOpacity(0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            leading: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: catColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: catColor.withOpacity(0.3)),
              ),
              alignment: Alignment.center,
              child: Text(
                item.name.isNotEmpty ? item.name[0].toUpperCase() : '?',
                style: TextStyle(
                  color: catColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
            title: Text(
              item.name,
              style: const TextStyle(
                color: kTextPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 3),
                Text(item.description,
                    style: const TextStyle(
                        color: kTextSecondary, fontSize: 12, height: 1.4)),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: catColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.category,
                    style: TextStyle(
                        color: catColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3),
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline_rounded,
                  color: kAccent, size: 22),
              onPressed: () async {
                final confirmed = await _confirmDelete(item);
                if (confirmed) _deleteItem(item.id);
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(ItemModel item) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: kCard,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Hapus Item?',
                style:
                    TextStyle(color: kTextPrimary, fontWeight: FontWeight.w700)),
            content: Text(
              'Item "${item.name}" akan dihapus secara permanen.',
              style: const TextStyle(color: kTextSecondary, fontSize: 13),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Batal',
                    style: TextStyle(color: kTextSecondary)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Hapus',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ) ??
        false;
  }
}