//
//  TimePlanerCollectionViewLayout.swift
//  SchoolManager
//
//  Created by Peter Sypek on 26.01.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import UIKit

class TimePlanerCollectionViewLayout: UICollectionViewLayout {
    
    // Used for calculating each cells CGRect on screen.
    // CGRect will define the Origin and Size of the cell.
    var CELL_HEIGHT = 80.0
    var CELL_WIDTH = 120.0
    let HEADER_CELL_WIDTH = 50.0
    let HEADER_CELL_HEIGHT = 40.0
    let STATUS_BAR = UIApplication.shared.statusBarFrame.height
    var contentWidth:Double!
    var contentHeight:Double!
    
    // Dictionary to hold the UICollectionViewLayoutAttributes for
    // each cell. The layout attribtues will define the cell's size
    // and position (x, y, and z index). I have found this process
    // to be one of the heavier parts of the layout. I recommend
    // holding onto this data after it has been calculated in either
    // a dictionary or data store of some kind for a smooth performance.
    var cellAttrsDictionary = Dictionary<NSIndexPath, UICollectionViewLayoutAttributes>()
    
    // Defines the size of the area the user can move around in
    // within the collection view.
    var contentSize = CGSize.zero
    
    // Used to determine if a data source update has occured.
    // Note: The data source would be responsible for updating
    // this value if an update was performed.
    var dataSourceDidUpdate = true
    
    func collectionViewContentSize() -> CGSize {
        return self.contentSize
    }
    
    override func prepare() {
        super.prepare()
        
        // Only update header cells.
        if !dataSourceDidUpdate {
            
            // Determine current content offsets.
            let xOffset = collectionView!.contentOffset.x
            let yOffset = collectionView!.contentOffset.y
            
            if collectionView?.numberOfSections > 0 {
                for section in 0...collectionView!.numberOfSections-1 {
                    // Confirm the section has items.
                    if collectionView?.numberOfItemsInSection(section) > 0 {
                        
                        // Update all items in the first row.
                        if section == 0 {
                            for item in 0...collectionView!.numberOfItems(inSection: section)-1 {
                                
                                // Build indexPath to get attributes from dictionary.
                                let indexPath = NSIndexPath(forItem: item, inSection: section)
                                
                                // Update y-position to follow user.
                                if let attrs = cellAttrsDictionary[indexPath] {
                                    var frame = attrs.frame
                                    
                                    // Also update x-position for corner cell.
                                    if item == 0 {
                                        print(xOffset)
                                        frame.origin.x = xOffset
                                    }
                                    print(yOffset)
                                    if section == 0{
                                        frame.origin.y = yOffset
                                    }
                                    attrs.frame = frame
                                }
                                
                            }
                            
                            // For all other sections, we only need to update
                            // the x-position for the fist item.
                        } else {
                            
                            // Build indexPath to get attributes from dictionary.
                            let indexPath = NSIndexPath(forItem: 0, inSection: section)
                            
                            // Update y-position to follow user.
                            if let attrs = cellAttrsDictionary[indexPath] {
                                var frame = attrs.frame
                                frame.origin.x = xOffset
                                attrs.frame = frame
                            }
                            
                        }
                    }
                }
            }
            
            // Do not run attribute generation code
            // unless data source has been updated.
            return
        }
        
        // Acknowledge data source change, and disable for next time.
        dataSourceDidUpdate = false
        var xPos:Double = 0.0
        var yPos:Double = 0.0
        // Cycle through each section of the data source.
        if collectionView?.numberOfSections > 0 {
            for section in 0...collectionView!.numberOfSections-1 {
                if section == 0{
                    CELL_HEIGHT = HEADER_CELL_HEIGHT
                    yPos = 0.0
                } else if section == 1 {
                    self.CELL_HEIGHT = 80.0
                    yPos += CELL_HEIGHT - 40
                } else {
                    self.CELL_HEIGHT = 80.0
                    yPos += CELL_HEIGHT

                }
                
                // Cycle through each item in the section.
                if collectionView?.numberOfItemsInSection(section) > 0 {
                    for item in 0...collectionView!.numberOfItems(inSection: section)-1 {
                        if item == 0{
                            CELL_WIDTH = self.HEADER_CELL_WIDTH
                            xPos = -70
                        }else{
                            CELL_WIDTH = 120
                            xPos += CELL_WIDTH
                        }
                        
                        // Build the UICollectionVieLayoutAttributes for the cell.
                        let cellIndex = NSIndexPath(forItem: item, inSection: section)
//                        let xPos = Double(item) * CELL_WIDTH
//                        let yPos = Double(section) * CELL_HEIGHT
                        
                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: cellIndex as IndexPath)
                        cellAttributes.frame = CGRect(x: xPos, y: yPos, width: CELL_WIDTH, height: CELL_HEIGHT)
                        
                        // Determine zIndex based on cell type.
                        if section == 0 && item == 0 {
                            cellAttributes.zIndex = 4
                        } else if section == 0 {
                            cellAttributes.zIndex = 3
                        } else if item == 0 {
                            cellAttributes.zIndex = 2
                        } else {
                            cellAttributes.zIndex = 1
                        }
                        
                        // Save the attributes.
                        cellAttrsDictionary[cellIndex] = cellAttributes
                    }
                }
            }
            // Update content size.
            contentWidth = Double(collectionView!.numberOfItems(inSection: 0)) * CELL_WIDTH
            contentHeight = Double(collectionView!.numberOfSections) * CELL_HEIGHT
        } else {
            contentWidth = CELL_WIDTH
            contentHeight = CELL_HEIGHT
        }       
        
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        // Create an array to hold all elements found in our current view.
        var attributesInRect = [UICollectionViewLayoutAttributes]()
        
        // Check each element to see if it should be returned.
        for cellAttributes in cellAttrsDictionary.values {
            if rect.intersects(cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }
        
        // Return list of elements.
        return attributesInRect
    }
    
    func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary[indexPath]!
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
