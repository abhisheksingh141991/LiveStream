//
//  CommentCell.swift
//  LiveStream
//
//  Created by Abhishek Kumar Singh on 20/12/24.
//

import UIKit

class CommentCell: UITableViewCell {
    static let identifier = "CommentCell"
    private var usernameLabel = UILabel()
    private var commentLabel = UILabel()
    private var profileImageView = UIImageView()
    
    private let gradientLayer = CAGradientLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        usernameLabel = UILabel()
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        usernameLabel.textColor = .gray
        
        
        commentLabel = UILabel()
        commentLabel.font = UIFont.systemFont(ofSize: 14)
        commentLabel.textColor = .white
        commentLabel.numberOfLines = 0
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(commentLabel)

        setupConstraints()
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),

            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),

            commentLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            commentLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
            commentLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5),
            commentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }

    func configure(with comment: Comment) {
        usernameLabel.text = comment.username
        commentLabel.text = comment.comment
        downloadAndSetProfileImgae(url: comment.picURL)
    }
    
    private func downloadAndSetProfileImgae(url: String) {
        guard let url = URL(string: url) else {
            self.profileImageView.image = UIImage(named: "profile_placeholder")
            return
        }
          
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {
                self.profileImageView.image = UIImage(named: "profile_placeholder")
                return
            }
        
            DispatchQueue.main.async {
                self.profileImageView.image = UIImage(data: data)
            }
        }
    }

}
