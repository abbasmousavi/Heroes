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
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var messagesLabel: UILabel!
    @IBOutlet var retryButton: UIButton!
    weak var delegate: StateIndicatorProtocol?

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
        isHidden = true
    }

    @IBAction func retry(_: Any) {
        delegate?.userDidRequestRetry()
    }

    func startLoading() {
        activityIndicator.startAnimating()
        messagesLabel.isHidden = true
        retryButton.isHidden = true
        isHidden = false
    }

    func stopLoading() {
        activityIndicator.stopAnimating()
        messagesLabel.text = nil
        messagesLabel.isHidden = true
        retryButton.isHidden = true
        isHidden = true
    }

    func stopLoading(message: String) {
        activityIndicator.stopAnimating()
        messagesLabel.text = message
        messagesLabel.isHidden = false
        retryButton.isHidden = true
        isHidden = false
    }

    func stopLoading(error: Error) {
        activityIndicator.stopAnimating()
        messagesLabel.text = error.localizedDescription
        messagesLabel.isHidden = false
        retryButton.isHidden = false
        isHidden = false
    }
}
