//
//  DashBoardCollectionViewDataSource.swift
//  MyFitMembers
//
//  Created by cbl24 on 16/11/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//
//
//import UIKit
//
//class DashBoardCollectionViewDataSource: collectionViewDataSource {
//
//    func collectionView(collectionView: UICollectionView,
//                        viewForSupplementaryElementOfKind kind: String,
//                                                          atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        
//        guard let headerView =
//            collectionView.dequeueReusableSupplementaryViewOfKind(kind,
//                                                                  withReuseIdentifier: "MyOdersReusableView",
//                                                                  forIndexPath: indexPath)
//                
//                as? MyOdersReusableView else {return UICollectionReusableView()}
//        
//        headerView.labelMessage.text = message
//        return headerView
//        
//    }
//}
