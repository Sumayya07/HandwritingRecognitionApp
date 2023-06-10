//
//  RecognitionCandidatesView.swift
//  SadarHandloomAssignment
//
//  Created by Sumayya Siddiqui on 10/06/23.
//

import UIKit

protocol RecognitionCandidatesViewDelegate: AnyObject {
    func recognitionCandidatesView(_ view: RecognitionCandidatesView, didSelectCandidate candidate: String)
}

class RecognitionCandidatesView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let candidatesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    weak var delegate: RecognitionCandidatesViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupGestureRecognizers()
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(candidatesStackView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        candidatesStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor), // Centers horizontally
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20), // 20 points from the top, adjust as needed

            candidatesStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            candidatesStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            candidatesStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            candidatesStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    
    func displayRecognitionResult(_ title: String, candidates: [String]) {
        titleLabel.text = title
        
        candidatesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for candidate in candidates {
            let candidateLabel = UILabel()
            candidateLabel.text = candidate
            candidatesStackView.addArrangedSubview(candidateLabel)
        }
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCandidateSelection(_:)))
        candidatesStackView.arrangedSubviews.forEach { candidateLabel in
            candidateLabel.isUserInteractionEnabled = true
            candidateLabel.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func handleCandidateSelection(_ sender: UITapGestureRecognizer) {
        guard let selectedLabel = sender.view as? UILabel,
              let selectedCandidate = selectedLabel.text else {
            return
        }
        delegate?.recognitionCandidatesView(self, didSelectCandidate: selectedCandidate)
    }
}

