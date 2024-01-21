//
//  SavedCollectionViewLayout.swift
//  AnimalBrowser
//
//  Created by @gunantosteven https://github.com/gunantosteven
//  Modified by Samuel Napitupulu on 19/01/24.

import UIKit

class SavedCollectionViewLayout: UICollectionViewLayout {
    private let columnsCount = 18 // 18 type columns
    private let numberOfColumns = CGFloat(3.0)
    private let minimumLineSpacing: CGFloat = 2
    private let minimumInteritemSpacing: CGFloat = 2
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    private var columnWidth: CGFloat {
        return contentWidth / numberOfColumns
    }

    override func prepare() {
        guard
            cache.isEmpty,
            let collectionView = collectionView
            else {
                return
        }

        var yOffsetNext = CGFloat(0.0)

        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            var xOffset = CGFloat(0.0), yOffset = CGFloat(yOffsetNext)

            let rowColumn = indexPath.row % columnsCount

            // handle x position
            if (rowColumn == 1) || (rowColumn == 4) || (rowColumn == 7) || (rowColumn == 13)
                || (rowColumn == 16) {
                xOffset = CGFloat(columnWidth)
            } else if (rowColumn == 5) || (rowColumn == 8) || (rowColumn == 10) || (rowColumn == 11)
                || (rowColumn == 14) || (rowColumn == 17) {
                xOffset = CGFloat(columnWidth * 2)
            }

            // handle y position for the next column
            if (rowColumn == 1) || (rowColumn == 2) || (rowColumn == 5) || (rowColumn == 8)
                || (rowColumn == 10) || (rowColumn == 11) || (rowColumn == 14) || (rowColumn == 17) {
                yOffsetNext += columnWidth + minimumLineSpacing
            }

            // handle width and height
            let size = getSizeColumn(indexPath: indexPath)

            let frame = CGRect(x: xOffset,
                               y: yOffset,
                               width: size.width,
                               height: size.height)

            contentHeight = max(contentHeight, frame.maxY)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            print("INDEX PATH \(indexPath.row)")
            return cache[indexPath.item]
    }

    func emptyCache() {
        self.cache.removeAll()
    }

    func getSizeColumn(indexPath: IndexPath) -> CGSize {
        let rowColumn = indexPath.row % columnsCount
        var height = CGFloat(0.0), width = CGFloat(0.0)
        if rowColumn == 1 {
            width = CGFloat(columnWidth * 2)
            height = CGFloat(columnWidth * 2) + minimumLineSpacing
        } else if (rowColumn == 5) || (rowColumn == 8) || (rowColumn == 10)
            || (rowColumn == 11) || (rowColumn == 14) || (rowColumn == 17) {
            width = CGFloat(columnWidth)
            height = CGFloat(columnWidth)
        } else if rowColumn == 9 {
            width = CGFloat(columnWidth * 2) - minimumInteritemSpacing
            height = CGFloat(columnWidth * 2) + minimumLineSpacing
        } else {
            width = CGFloat(columnWidth) - minimumInteritemSpacing
            height = CGFloat(columnWidth)
        }
        return CGSize(width: width, height: height)
    }
}
