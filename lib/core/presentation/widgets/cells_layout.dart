import 'package:flutter/material.dart';

class Cell extends LayoutId {
  final int posX;
  final int posY;
  final int xSize;
  final int ySize;

  Cell(
      {super.key,
      required this.posX,
      required this.posY,
      this.xSize = 1,
      this.ySize = 1,
      required super.child})
      : super(id: (posX, posY));

  (int, int) get position => (posX, posY);
}

enum StripLayoutRuleType { fixed, fraction, spacer }

abstract class StripLayoutRule {
  StripLayoutRuleType get type;
}

class SLFixed implements StripLayoutRule {
  final double size;

  SLFixed({required this.size});

  @override
  StripLayoutRuleType get type => StripLayoutRuleType.fixed;
}

class SLFraction implements StripLayoutRule {
  final double fraction;
  SLFraction({required this.fraction});

  @override
  StripLayoutRuleType get type => StripLayoutRuleType.fraction;
}

class SLSpacer implements StripLayoutRule {
  final int flex;
  SLSpacer({required this.flex});
  @override
  StripLayoutRuleType get type => StripLayoutRuleType.spacer;
}

class CellsLayoutDelegate extends MultiChildLayoutDelegate {
  final List<StripLayoutRule> columnRules;
  final List<StripLayoutRule> rowRules;
  final int spaceBetweenRows;
  final int spaceBetweenColumns;
  final List<Cell> cells;

  CellsLayoutDelegate(
      {required this.columnRules,
      required this.rowRules,
      this.spaceBetweenColumns = 0,
      this.spaceBetweenRows = 0,
      required this.cells});

  // Perform layout will be called when re-layout is needed.
  @override
  void performLayout(Size size) {
    List<(double, double)>? calculateStripSizes(
        {required List<StripLayoutRule> stripRules,
        required double size,
        required int spaceBetweenRules}) {
      List<(double, double)> stripWidths = [];
      double stripFixedSize = spaceBetweenRules * (stripRules.length - 1);
      int totalSpacerFlexs = 0;
      // Calculate Strip fixed size and Spacers flexs sum
      for (var stripRule in stripRules) {
        switch (stripRule.type) {
          case StripLayoutRuleType.fixed:
            stripFixedSize += (stripRule as SLFixed).size;
            break;
          case StripLayoutRuleType.fraction:
            stripFixedSize += (stripRule as SLFraction).fraction * size;
            break;
          case StripLayoutRuleType.spacer:
            totalSpacerFlexs += (stripRule as SLSpacer).flex;
            break;
        }
      }
      if (stripFixedSize > size) {
        return null;
      } else {
        double spacersFlexSize = (size - stripFixedSize) / totalSpacerFlexs;
        double endOfLastRule = 0;
        double currentRuleOffset;
        for (var stripRule in stripRules) {
          switch (stripRule.type) {
            case StripLayoutRuleType.fixed:
              currentRuleOffset = (stripRule as SLFixed).size;
              break;
            case StripLayoutRuleType.fraction:
              currentRuleOffset = (stripRule as SLFraction).fraction * size;
              break;
            case StripLayoutRuleType.spacer:
              currentRuleOffset =
                  (stripRule as SLSpacer).flex * spacersFlexSize;

              break;
          }
          stripWidths.add((endOfLastRule, endOfLastRule + currentRuleOffset));
          endOfLastRule += currentRuleOffset;
        }
        return stripWidths;
      }
    }

    Rect calculateCellLimits(Cell cell, List<(double, double)> columnStripSizes,
        List<(double, double)> rowStripSizes) {
      double left, top, right, bottom;
      (left, _) = columnStripSizes[cell.posX];
      (_, right) = columnStripSizes[cell.posX + cell.xSize - 1];
      (top, _) = rowStripSizes[cell.posY];
      (_, bottom) = rowStripSizes[cell.posY + cell.ySize - 1];
      return Rect.fromLTRB(left, top, right, bottom);
    }

    List<(double, double)>? columnStripSizes = calculateStripSizes(
        stripRules: columnRules,
        size: size.width,
        spaceBetweenRules: spaceBetweenColumns);
    if (columnStripSizes == null) {
      throw 'Available space is smaller than required columns size';
    }
    List<(double, double)>? rowStripSizes = calculateStripSizes(
        stripRules: rowRules,
        size: size.height,
        spaceBetweenRules: spaceBetweenRows);
    if (rowStripSizes == null) {
      throw 'Available space is smaller than required columns size';
    }
    for (final Cell cell in cells) {
      Rect cellLimits =
          calculateCellLimits(cell, columnStripSizes, rowStripSizes);
      layoutChild(
        (cell.posX, cell.posY),
        BoxConstraints(
            maxHeight: cellLimits.height, maxWidth: cellLimits.width),
      );

      positionChild(
          (cell.posX, cell.posY), Offset(cellLimits.left, cellLimits.top));
    }
  }

  // shouldRelayout is called to see if the delegate has changed and requires a
  // layout to occur. Should only return true if the delegate state itself
  // changes: changes in the CustomMultiChildLayout attributes will
  // automatically cause a relayout, like any other widget.
  @override
  bool shouldRelayout(CellsLayoutDelegate oldDelegate) {
    return this == oldDelegate;
  }
}

class CellsLayout extends StatelessWidget {
  final List<StripLayoutRule> columnRules;
  final List<StripLayoutRule> rowRules;
  final int spaceBetweenRows;
  final int spaceBetweenColumns;
  final List<Cell> cells;

  const CellsLayout(
      {super.key,
      required this.columnRules,
      required this.rowRules,
      this.spaceBetweenColumns = 0,
      this.spaceBetweenRows = 0,
      required this.cells});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return CustomMultiChildLayout(
          delegate: CellsLayoutDelegate(
              columnRules: columnRules, rowRules: rowRules, cells: cells),
          children: cells);
    });
  }
}
