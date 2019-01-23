//
//  MyAnimator.swift
//  Animated-Set-Concentration
//
//  Created by Arnab Sen on 22/01/19.
//  Copyright © 2019 Arnab Sen. All rights reserved.
//

import UIKit

class MyBehaviour: UIDynamicBehavior {
    
    lazy private var collisionBehavior : UICollisionBehavior = {
        let coll = UICollisionBehavior()
        coll.translatesReferenceBoundsIntoBoundary = true
        coll.collisionMode = [.boundaries]
        return coll
    }()
    
    lazy private var itemBehaviour : UIDynamicItemBehavior = {
       let ib = UIDynamicItemBehavior()
        ib.elasticity = 1.0
        ib.resistance = 0.5
        ib.allowsRotation = true
        return ib
    }()
    
    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = (CGFloat(200.arc4random) / 100.0) * CGFloat.pi
        push.action = { [unowned push, weak self] in
                self?.removeChildBehavior(push)
        }
        push.magnitude = 7.0
        addChildBehavior(push)
    }
    func addItem(_ item: UIDynamicItem) {
        itemBehaviour.addItem(item)
        collisionBehavior.addItem(item)
        push(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehaviour)
    }
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}

