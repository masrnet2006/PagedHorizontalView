//
//  PagedHorizontalView.swift
//  PagedHorizontalView
//
//  Created by mohamede1945 on 6/20/15.
//  Copyright (c) 2015 Varaw. All rights reserved.
//

import UIKit

/**
Represents the paged horizontal view class.

@author mohamede1945

@version 1.0
*/
public class PagedHorizontalView: UIView {

    @IBOutlet public weak var pageControl: UIPageControl? {
        didSet {
            pageControl?.addTarget(self, action: "pageChanged:", forControlEvents: .ValueChanged)
        }
    }

    @IBOutlet public weak var nextButton: UIButton? {
        didSet {
            nextButton?.addTarget(self, action: "goToNextPage:", forControlEvents: .TouchUpInside)
        }
    }

    @IBOutlet public weak var previousButton: UIButton? {
        didSet {
            previousButton?.addTarget(self, action: "goToPreviousPage:", forControlEvents: .TouchUpInside)
        }
    }

    @IBOutlet public weak var collectionView: UICollectionView! {
        didSet {
            let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.scrollDirection = .Horizontal
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0

            collectionView.pagingEnabled = true
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.delegate = self
        }
    }

    /// whether or not dragging has ended
    private var endDragging = false

    /// the current page
    public dynamic var currentIndex: Int = 0 {
        didSet {
            pageControl?.currentPage = currentIndex
            nextButton?.enabled = currentIndex < collectionView.numberOfItemsInSection(0) - 1
            previousButton?.enabled = currentIndex > 0
        }
    }

    /**
    Currnet page changed.

    :param: sender the page control of the action.
    */
    @IBAction public func pageChanged(sender: UIPageControl) {
        moveToPage(sender.currentPage, animated: true)
    }

    /**
    Go to next page.

    :param: sender The sender of the action parameter.
    */
    @IBAction public func goToNextPage(sender: AnyObject) {
        moveToPage(currentIndex + 1, animated: true)
    }

    /**
    Go to previous page.

    :param: sender The sender of the action parameter.
    */
    @IBAction public func goToPreviousPage(sender: AnyObject) {
        moveToPage(currentIndex - 1, animated: true)
    }

    public func moveToPage(page: Int, animated: Bool) {
        // outside the range
        if page < 0 || page >= collectionView.numberOfItemsInSection(0) {
            return
        }

        currentIndex = page
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: currentIndex, inSection: 0),
            atScrollPosition: .Left, animated: animated)
    }
}


extension PagedHorizontalView : UICollectionViewDelegateFlowLayout {

    /**
    size of the collection view

    :param: collectionView the collection view
    :param: collectionViewLayout the collection view flow layout
    :param: indexPath the index path
    */
    public func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return collectionView.bounds.size
    }

    /**
    scroll view did end dragging

    :param: scrollView the scroll view
    :param: decelerate wether the view is decelerating or not.
    */
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            endScrolling(scrollView)
        } else {
            endDragging = true
        }
    }

    /**
    Scroll view did end decelerating
    */
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if endDragging {
            endDragging = false
            endScrolling(scrollView)
        }
    }

    /**
    end scrolling
    */
    private func endScrolling(scrollView: UIScrollView) {
        let width = scrollView.bounds.width
        let page = (scrollView.contentOffset.x + (0.5 * width)) / width
        currentIndex = Int(page)
    }
    

}