//
//  CollectionViewDataSource.swift
//  Whatashadi
//
//  Created by Night Reaper on 29/10/15.
//  Copyright © 2015 Gagan. All rights reserved.
//


import UIKit

typealias ScrollViewScrolled = (UIScrollView) -> ()

class CollectionViewDataSource: NSObject  {
    
    var items : Array<AnyObject>?
    var cellIdentifier : String?
    var headerIdentifier : String?
    var collectionView  : UICollectionView?
    var cellHeight : CGFloat = 0.0
    var cellWidth : CGFloat = 0.0
    var cellSpacing : CGFloat = 0.0
    var scrollViewListener : ScrollViewScrolled?
    var configureCellBlock : ListCellConfigureBlock?
    var aRowSelectedListener : DidSelectedRow?
    
    init (items : Array<AnyObject>?  , collectionView : UICollectionView? , cellIdentifier : String? , headerIdentifier : String? , cellHeight : CGFloat , cellWidth : CGFloat  ,cellSpacing : CGFloat , configureCellBlock : ListCellConfigureBlock  , aRowSelectedListener : DidSelectedRow , scrollViewListener : ScrollViewScrolled)  {
        
        self.collectionView = collectionView
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.headerIdentifier = headerIdentifier
        self.cellWidth = cellWidth
        self.cellSpacing = cellSpacing
        self.cellHeight = cellHeight
        self.configureCellBlock = configureCellBlock
        self.aRowSelectedListener = aRowSelectedListener
        self.scrollViewListener = scrollViewListener
        
    }
    
    override init() {
        super.init()
    }
    
}

extension CollectionViewDataSource : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        guard let identifier = cellIdentifier else{
            fatalError("Cell identifier not provided")
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier ,
                                                                         forIndexPath: indexPath) as UICollectionViewCell
        if let block = self.configureCellBlock , item: AnyObject = self.items?[indexPath.row]{
            block(cell: cell , item: item , indexpath:indexPath)
        }
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let block = self.aRowSelectedListener{
            block(indexPath: indexPath)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
            if let block = scrollViewListener {
                block(scrollView)
            }
        }

}


extension CollectionViewDataSource : UICollectionViewDelegateFlowLayout{
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        return CGSizeMake(cellWidth, cellHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        
        return cellSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        
        return cellSpacing/2
    }
    
   
    
}


