//
//  ReactionListView.swift
//  Rocket.Chat
//
//  Created by Matheus Cardoso on 12/14/17.
//  Copyright © 2017 Rocket.Chat. All rights reserved.
//

import Foundation

struct ReactionListViewModel {
    let reactionViewModels: [ReactionViewModel]

    init(reactionViewModels: [ReactionViewModel] = []) {
        self.reactionViewModels = reactionViewModels.sorted { $0.emoji > $1.emoji }
    }
}

class ReactionListView: UIView {
    @IBOutlet var scrollView: UIScrollView! {
        didSet {
            setupScrollView()
        }
    }
    @IBOutlet weak var reactionsStack: UIStackView!

    var model = ReactionListViewModel() {
        didSet {
            map(model)
        }
    }

    var reactionTapRecognized: (ReactionView, UITapGestureRecognizer) -> Void = { _, _ in }

    func map(_ model: ReactionListViewModel) {
        let views = model.reactionViewModels.map { reactionViewModel -> ReactionView in
            let view = ReactionView()
            view.model = reactionViewModel
            return view
        }

        reactionsStack.arrangedSubviews.forEach(reactionsStack.removeArrangedSubview)

        views.forEach { view in
            reactionsStack.addArrangedSubview(view)
            view.tapRecognized = { sender in
                self.reactionTapRecognized(view, sender)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

// MARK: Initialization
extension ReactionListView {
    private func commonInit() {
        Bundle.main.loadNibNamed("ReactionListView", owner: self, options: nil)
    }

    private func setupScrollView() {
        addSubview(scrollView)

        addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "|-0-[view]-0-|", options: [], metrics: nil, views: ["view": scrollView]
            )
        )
        addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": scrollView]
            )
        )

        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
}