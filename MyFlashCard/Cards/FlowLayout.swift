//
//  FlowLayout.swift
//  MyFlashCard
//
//  Created by Tatsunori on 2020/07/14.
//  Copyright © 2020 Tatsunori. All rights reserved.
//

import UIKit

final class FlowLayout: UICollectionViewFlowLayout {

    private var layoutAttributesForPaging: [UICollectionViewLayoutAttributes]?
    private var index: Int = 0
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        guard let targetAttributes = layoutAttributesForPaging else { return proposedContentOffset }

        let nextAttributes: UICollectionViewLayoutAttributes?
        if velocity.x == 0 {
            // スワイプせずに指を離した場合は、画面中央から一番近い要素を取得する
            nextAttributes = layoutAttributesForNearbyCenterX(in: targetAttributes, collectionView: collectionView)
        } else if velocity.x > 0 {
            // 左スワイプの場合は、最後の要素を取得する
            nextAttributes = targetAttributes.last
        } else {
            // 右スワイプの場合は、先頭の要素を取得する
            nextAttributes = targetAttributes.first
        }
        guard let attributes = nextAttributes else { return proposedContentOffset }
        index = attributes.indexPath.row
        
        // 画面左端からセルのマージンを引いた座標を返し、画面中央に表示されるようにする
        let cellLeftMargin = (collectionView.bounds.width - attributes.bounds.width) * 0.5
        return CGPoint(x: attributes.frame.minX - cellLeftMargin, y: collectionView.contentOffset.y)
    }
    
    // 画面中央に一番近いセルの attributes を取得する
    private func layoutAttributesForNearbyCenterX(in attributes: [UICollectionViewLayoutAttributes], collectionView: UICollectionView) -> UICollectionViewLayoutAttributes? {
        let screenCenterX = collectionView.contentOffset.x + collectionView.bounds.width * 0.5
        let result = attributes.reduce((attributes: nil as UICollectionViewLayoutAttributes?, distance: CGFloat.infinity)) { result, attributes in
            let distance = attributes.frame.midX - screenCenterX
            return abs(distance) < abs(result.distance) ? (attributes, distance) : result
        }
        return result.attributes
    }

    // UIScrollViewDelegate scrollViewWillBeginDragging から呼ぶ
    func prepareForPaging() {
        // 1ページずつページングさせるために、あらかじめ表示されている attributes の配列を取得しておく
        guard let collectionView = collectionView else { return }
        let expansionMargin = sectionInset.left + sectionInset.right
        let expandedVisibleRect = CGRect(x: collectionView.contentOffset.x - expansionMargin,
                                         y: 0,
                                         width: collectionView.bounds.width + (expansionMargin * 2),
                                         height: collectionView.bounds.height)
        layoutAttributesForPaging = layoutAttributesForElements(in: expandedVisibleRect)?.sorted { $0.frame.minX < $1.frame.minX }
    }
    
    var currentIndex: Int {
        get {
            return self.index
        }
        set {
            if newValue <= 0 {
                self.index = 0
            } else {
                self.index = newValue
            }
        }
    }
}

