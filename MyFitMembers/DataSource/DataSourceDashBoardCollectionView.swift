//
//  DataSourceDashBoardCollectionView.swift
//  MyFitMembers
//
//  Created by cbl24 on 06/12/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class DataSourceDashBoardCollectionView:  DataSourceCollectionView{

    func collectionView(collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                                                          atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            guard let headerView =
                collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                                                                      withReuseIdentifier: "MyOdersReusableView",
                                                                      forIndexPath: indexPath)
                    
                    as? MyOdersReusableView else {return UICollectionReusableView()}
            headerView.delegate = self
            headerView.labelMessage.text = message
//            headerView.tapOnBaner()
            return headerView
            
        case UICollectionElementKindSectionFooter:
            guard let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "CollectionReusableView", forIndexPath: indexPath) as? CollectionReusableView else {return UICollectionReusableView()}
            return footerView
            
        default:
            return UICollectionReusableView()
//            assert(false, "Unexpected element kind")
        }
        
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSizeMake(self.collectionView?.bounds.size.width ?? 0 , bannerHeight ?? 0.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeMake(self.collectionView?.bounds.size.width ?? 0 , 16.0 ?? 0.0)
    }
}
