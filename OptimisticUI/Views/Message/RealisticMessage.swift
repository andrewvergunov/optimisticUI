//
//  RealisticMessage.swift
//  OptimisticUI
//
//  Created by Andrew Vergunov on 4/24/17.
//  Copyright © 2017 NIX. All rights reserved.
//

import Foundation
import UIKit

class RealisticMessage: Message {
    var contentView : UIView?
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var messageTopSpace: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        contentView = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        contentView!.frame = bounds
        
        // Make the view stretch with containing view
        contentView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(contentView!)
    }
    
    override func layoutSubviews() {
        self.messageTopSpace.constant = self.bounds.height
    }
    
    func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    override func show(message: String) {
        self.messageTopSpace.constant = self.bounds.height  
        self.layoutIfNeeded()
        
        self.indicator.startAnimating()
        
        let deadlineTime = DispatchTime.now() + .seconds(3)
        
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.messageTopSpace.constant = 0
            self.indicator.stopAnimating()

            UIView.animate(withDuration: 0.2, animations: { 
                self.layoutIfNeeded()
            })
            
        }
    }
}
