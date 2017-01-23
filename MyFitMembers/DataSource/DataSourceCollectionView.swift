//
//  DataSourceCollectionView.swift
//  NeverMynd
//
//  Created by cbl24 on 7/4/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

typealias ConfigureCollectionViewCellBlock = (cell : AnyObject?,item : AnyObject?,indexPath : NSIndexPath) -> ()
typealias ConfigureCollectionViewDidSelectCellBlock = (cell : AnyObject?,item : AnyObject?,indexPath : NSIndexPath) -> ()

protocol BannerRemoved {
    func removeBanner()
    
}
class DataSourceCollectionView: NSObject, UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout  , RemoveBanner {
    
    //Mark::- Variables
    var collectionView: UICollectionView?
    var cellSize:CGSize?
    var item = [AnyObject]()
    var configureCellBlock : ConfigureCellBlock?
    var configureDidSelectBlock: ConfigureCollectionViewDidSelectCellBlock?
    var identifier: String?
    var cellSpacing : CGFloat = 0.0
    var cellInterItemSpacing: CGFloat = 0.0
    var boolFromClientPager = false
    var message: String?
    var bannerHeight: CGFloat?
    var delegate:BannerRemoved?
    
    //Mark::- Initializer
    init(collectionView:UICollectionView, configureCellBlock : ConfigureCellBlock , configureDidSelectBlock: ConfigureCollectionViewDidSelectCellBlock, cellIdentifier: String) {
        self.collectionView = collectionView
        self.configureCellBlock = configureCellBlock
        self.identifier = cellIdentifier
        self.configureDidSelectBlock = configureDidSelectBlock
    }
    
    //Mark::- CollectionView delegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(item.count)
        return item.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let block = configureCellBlock else { return UICollectionViewCell()}
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier ?? "", forIndexPath: indexPath)
        cell.exclusiveTouch = true
        block(cell: cell, item : item, indexPath: indexPath)
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let block = configureDidSelectBlock else { return }
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        block(cell: cell,item : item, indexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if boolFromClientPager{
            let wish = String(item[indexPath.row])
            let charCount = (wish.characters.count ?? 0) * 4
            let width = charCount + 16
            return CGSize(width: width*2, height: 40)
        }else{
            return cellSize ?? CGSize(width: self.collectionView?.bounds.size.width ?? 0, height: self.collectionView?.bounds.size.height ?? 0)
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return cellSpacing ?? 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return cellInterItemSpacing ?? 0.0
    }
    
    
    
    
    func removeBanner(){
        UIView.animateWithDuration(1.0, delay: 1.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseOut , animations: {
            
        }) { [weak self] (true) in
            self?.bannerHeight = 0.0
            self?.collectionView?.reloadData()
        }
        delegate?.removeBanner()
    }
    
}
