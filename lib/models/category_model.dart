class Category {
  final int id;
  final String name;

  Category(this.id, this.name);
  @override
  String toString() {
    return 'Categoria(id: $id)';
  }
}

List<Category> categories = [
  Category(0, 'All'),
  Category(1, 'Hogar'),
  Category(2, 'Niñera'),
  Category(3, 'Limpieza'),
  Category(4, 'Construcción'),
  Category(5, 'Educación'),
  Category(6, 'Alimentos'),
];
