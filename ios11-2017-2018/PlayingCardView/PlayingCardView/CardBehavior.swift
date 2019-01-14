//
//  CardBehavior.swift
//  PlayingCardView
//
//  Created by Abdoulaye Diallo on 1/12/19.
//  Copyright © 2019 Abdoulaye Diallo. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    
    lazy var collisionBehavior : UICollisionBehavior  = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0
        behavior.resistance = 0.0
        return behavior
        
    }()
    
    private func push( _ item: UIDynamicItem ){
        let push =  UIPushBehavior(items: [item], mode: .instantaneous)
        if let referenceBounds =  dynamicAnimator?.referenceView?.bounds {
            let center =  CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
            switch (item.center.x, item.center.y) {
                
            case  let (x, y) where x < center.x && y < center.y:
                push.angle = CGFloat(Float((CGFloat.pi / 2)).arc4random)
            case  let (x, y) where x > center.x && y < center.y:
                push.angle = CGFloat( Float.pi - Float((CGFloat.pi / 2)).arc4random)
            case  let (x, y) where x < center.x && y > center.y:
                push.angle = -CGFloat(Float((CGFloat.pi / 2)).arc4random)
            case  let (x, y) where x > center.x && y > center.y:
                push.angle = CGFloat( Float.pi + Float((CGFloat.pi / 2)).arc4random)
            default:
                push.angle = CGFloat(( 2 * Float.pi).arc4random)
                
            }
        }
        push.magnitude = CGFloat(Float(1.0 + 2.0 ).arc4random)
        addChildBehavior(push)
        push.action = {
            [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
    }
    
    
    
    
    
    func addItem(_ item: UIDynamicItem){
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    func removeItem(_ item: UIDynamicItem){
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}
