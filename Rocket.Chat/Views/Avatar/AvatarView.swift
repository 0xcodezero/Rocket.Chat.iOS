//
//  AvatarView.swift
//  Rocket.Chat
//
//  Created by Rafael K. Streit on 10/09/16.
//  Copyright © 2016 Rocket.Chat. All rights reserved.
//

import UIKit

let avatarColors: [UInt] = [
    0xF44336, 0xE91E63, 0x9C27B0, 0x673AB7, 0x3F51B5,
    0x2196F3, 0x03A9F4, 0x00BCD4, 0x009688, 0x4CAF50,
    0x8BC34A, 0xCDDC39, 0xFFC107, 0xFF9800, 0xFF5722,
    0x795548, 0x9E9E9E, 0x607D8B]

final class AvatarView: UIView {

    var imageURL: URL? {
        didSet {
            updateAvatar()
        }
    }

    var user: User? {
        didSet {
            updateAvatar()
        }
    }

    var subscription: Subscription? {
        didSet {
            imageView?.image = nil
            updateAvatar()
        }
    }

    @IBOutlet weak var labelInitials: UILabel!
    var labelInitialsFontSize: CGFloat? {
        didSet {
            labelInitials?.font = UIFont.systemFont(ofSize: labelInitialsFontSize ?? 16)
        }
    }

    @IBOutlet weak var imageView: UIImageView!

    internal func updateAvatar(completion: VoidCompletion? = nil) {
        setAvatarWithInitials()

        var imageURL: URL?
        if let avatar = self.imageURL {
            imageURL = avatar
        } else {
            imageURL = user?.avatarURL()
        }

        if let imageURL = imageURL {
            imageView?.sd_setImage(with: imageURL, completed: { [weak self] (_, error, _, _) in
                guard error == nil else {
                    self?.setAvatarWithInitials()
                    completion?()
                    return
                }

                self?.labelInitials.text = ""
                self?.backgroundColor = UIColor.clear
                completion?()
            })
        }
    }

    internal func initialsFor(_ username: String) -> String {
        guard username.count > 0 else {
            return "?"
        }

        let strings = username.components(separatedBy: ".")

        if let first = strings.first, let last = strings.last {
            if first.isEmpty || last.isEmpty {
                return "?"
            }

            let lastOffset = strings.count > 1 ? 1 : 2
            let indexFirst = first.index(first.startIndex, offsetBy: 1)
            let firstString = first[..<indexFirst]

            var lastString: Substring = ""
            if last.count >= lastOffset {
                let indexLast = last.index(last.startIndex, offsetBy: lastOffset)
                lastString = last[..<indexLast]

                if lastOffset == 2 {
                    let endIndex = lastString.index(lastString.startIndex, offsetBy: 1)
                    lastString = lastString[endIndex...]
                }
            }

            return "\(firstString)\(lastString)".uppercased()
        }

        return ""
    }

    private func setAvatarWithInitials() {
        let subscription = self.subscription?.displayName() ?? "?"
        let username = self.user?.username ?? "?"
        let text = subscription == "?" ? username : subscription

        let username = user.username ?? "?"
        var initials = ""
        var color: UInt = 0x000000

        if text == "?" {
            initials = text
            color = 0x000000
        } else {
            let position = text.characters.count % avatarColors.count
            color = avatarColors[position]
            initials = initialsFor(text)
        }

        labelInitials?.text = initials.uppercased()
        backgroundColor = UIColor(rgb: color, alphaVal: 1)
    }

}
