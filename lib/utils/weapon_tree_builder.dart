import 'package:mhwilds_app/models/weapon.dart';
import 'package:mhwilds_app/providers/weapons_provider.dart';

class TreeNode {
  final Weapon weapon;
  final List<TreeNode> children;
  final TreeNode? parent;

  TreeNode({
    required this.weapon,
    List<TreeNode>? children,
    this.parent,
  }) : children = children ?? [];
}

class WeaponTreeBuilder {
  /// Builds a tree from a starting weapon by finding its root, and then recursively mapping its branches.
  static TreeNode? buildTree(Weapon startingWeapon, WeaponsProvider provider) {
    // 1. Find root weapon
    Weapon current = startingWeapon;
    // We use a set to prevent infinite loops in case of circular references (shouldn't happen, but safe)
    Set<int> visitedIds = {current.id};

    while (current.crafting.previous != null) {
      Weapon? previousWeapon = provider.getWeaponById(current.crafting.previous!.id);
      if (previousWeapon == null) {
        // Cannot trace further back, consider current as root.
        break;
      }
      if (visitedIds.contains(previousWeapon.id)) {
        // Circular loop detected
        break;
      }
      visitedIds.add(previousWeapon.id);
      current = previousWeapon;
    }

    Weapon rootWeapon = current;

    // 2. Build tree from root
    return _buildNode(rootWeapon, provider, null, {});
  }

  static TreeNode _buildNode(Weapon weapon, WeaponsProvider provider, TreeNode? parent, Set<int> visitedInBranch) {
    final node = TreeNode(weapon: weapon, parent: parent);
    
    // Create a new visited set for this branch path to prevent circular branches
    final newVisited = Set<int>.from(visitedInBranch)..add(weapon.id);

    if (weapon.crafting.branches.isNotEmpty) {
      for (final branchRef in weapon.crafting.branches) {
        if (newVisited.contains(branchRef.id)) continue;

        final branchWeapon = provider.getWeaponById(branchRef.id);
        if (branchWeapon != null) {
          final childNode = _buildNode(branchWeapon, provider, node, newVisited);
          node.children.add(childNode);
        }
      }
    }

    return node;
  }

  /// Flattens the tree into a list, useful for drawing linear tables
  static List<Weapon> flattenTree(TreeNode root) {
    final List<Weapon> list = [];
    _flattenHelper(root, list);
    return list;
  }

  static void _flattenHelper(TreeNode node, List<Weapon> list) {
    list.add(node.weapon);
    for (final child in node.children) {
      _flattenHelper(child, list);
    }
  }
}
