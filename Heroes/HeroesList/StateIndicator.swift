//
//  ErrorsAndMessagesView.swift
//  Heroes
//
//  Created by Abbas Mousavi on 8/3/18.
//  Copyright © 2018 Abbas Mousavi. All rights reserved.
//

import UIKit

protocol StateIndicatorProtocol: class {

    func userDidRequestRetry()
}

class StateIndicator: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var messagesLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    private weak var delegate: StateIndicatorProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
    
    Bundle.main.loadNibNamed("StateIndicator", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.isHidden = true
        
    }
    
    @IBAction func retry(_ sender: Any) {
        delegate?.userDidRequestRetry()
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
        messagesLabel.isHidden = true
        retryButton.isHidden = true
        self.isHidden = false
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        messagesLabel.text = nil
        messagesLabel.isHidden = true
        retryButton.isHidden = true
        self.isHidden = true
    }
    
    func stopLoading(message: String) {
        activityIndicator.stopAnimating()
        messagesLabel.text = message
        messagesLabel.isHidden = false
        retryButton.isHidden = true
        self.isHidden = false
    }
    
    func stopLoading(error: NSError) {
        activityIndicator.stopAnimating()
        messagesLabel.text = error.localizedDescription
        messagesLabel.isHidden = false
        retryButton.isHidden = false
        self.isHidden = false
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
