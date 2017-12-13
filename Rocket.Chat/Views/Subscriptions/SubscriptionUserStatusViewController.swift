//
//  SubscriptionUserStatusView.swift
//  Rocket.Chat
//
//  Created by Rafael Kellermann Streit on 13/02/17.
//  Copyright © 2017 Rocket.Chat. All rights reserved.
//

import UIKit

protocol SubscriptionUserStatusViewProtocol: class {
    func userDidPressedOption()
}

final class SubscriptionUserStatusViewController: UIViewController {

    weak var delegate: SubscriptionUserStatusViewProtocol?
    weak var parentController: UIViewController?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBOutlet weak var buttonOnline: UIButton!
    @IBOutlet weak var labelOnline: UILabel! {
        didSet {
            labelOnline.text = localized("user_menu.online")
        }
    }

    @IBOutlet weak var buttonAway: UIView!
    @IBOutlet weak var labelAway: UILabel! {
        didSet {
            labelAway.text = localized("user_menu.away")
        }
    }

    @IBOutlet weak var buttonBusy: UIView!
    @IBOutlet weak var labelBusy: UILabel! {
        didSet {
            labelBusy.text = localized("user_menu.busy")
        }
    }

    @IBOutlet weak var buttonInvisible: UIView!
    @IBOutlet weak var labelInvisible: UILabel! {
        didSet {
            labelInvisible.text = localized("user_menu.invisible")
        }
    }

    @IBOutlet weak var buttonSettings: UIView!
    @IBOutlet weak var labelSettings: UILabel! {
        didSet {
            labelSettings.text = localized("user_menu.settings")
        }
    }

    @IBOutlet weak var imageViewSettings: UIImageView! {
        didSet {
            imageViewSettings.image = imageViewSettings.image?.imageWithTint(.RCLightBlue())
        }
    }

    @IBOutlet weak var buttonLogout: UIView!
    @IBOutlet weak var labelLogout: UILabel! {
        didSet {
            labelLogout.text = localized("user_menu.logout")
        }
    }

    @IBOutlet weak var imageViewLogout: UIImageView! {
        didSet {
            imageViewLogout.image = imageViewLogout.image?.imageWithTint(.RCLightBlue())
        }
    }

    // MARK: View Controller

    override func viewDidLoad() {
        super.viewDidLoad()

        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        view.insertSubview(blurEffectView, at: 0)
        view.backgroundColor = .clear
    }

    // MARK: IBAction

    @IBAction func buttonOnlineDidPressed(_ sender: Any) {
        UserManager.setUserStatus(status: .online) { [weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func buttonAwayDidPressed(_ sender: Any) {
        UserManager.setUserStatus(status: .away) { [weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func buttonBusyDidPressed(_ sender: Any) {
        UserManager.setUserStatus(status: .busy) { [weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func buttonInvisibleDidPressed(_ sender: Any) {
        UserManager.setUserStatus(status: .offline) { [weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func buttonSettingsDidPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Settings", bundle: Bundle.main)

        if let controller = storyboard.instantiateInitialViewController() {
            controller.modalPresentationStyle = .formSheet
            present(controller, animated: true, completion: nil)
        }
    }

    @IBAction func buttonLogoutDidPressed(_ sender: Any) {
        // RKS NOTE: I know that this isn't the best place, but we need to fix
        // this crash ASAP. In the future we may have a centered place for all
        // database notifications.
        MainChatViewController.shared?.logout()
    }

}