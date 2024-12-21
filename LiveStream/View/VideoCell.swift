//
//  VideoCell.swift
//  LiveStream
//
//  Created by Abhishek Kumar Singh on 20/12/24.
//

import UIKit
import AVKit
import Lottie

class VideoCell: UICollectionViewCell {
    static let identifier = "VideoPlayerCell"
    private var heartAnimationView: LottieAnimationView?

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let viewersLabel = UILabel()
    private let likesLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let commentInputField = UITextField()
    private var commentsTableView: UITableView!
    private var autoScrollTimer: Timer?
    
    var comments: [Comment] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupSingleTapGesture()
        setupDoubleTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }

    private func setupSingleTapGesture() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        singleTapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTapGesture)
    }
    
    @objc private func handleSingleTap() {
        guard let player = self.player else { return }
      
        if player.timeControlStatus == .paused {
            player.play()
        } else {
            player.pause()
        }
    }
    
    private func setupDoubleTapGesture() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGesture)
    }

    @objc private func handleDoubleTap() {
        showFloatingHeart()
    }

    private func showFloatingHeart() {
        heartAnimationView = LottieAnimationView(name: "heart_animation")
        heartAnimationView?.frame = CGRect(x: self.bounds.width / 2 - 50, y: self.bounds.height / 2 - 50, width: 200, height: 200)
        heartAnimationView?.loopMode = .playOnce
        heartAnimationView?.animationSpeed = 1.5

        if let heartView = heartAnimationView {
            self.contentView.addSubview(heartView)
            heartView.play { [weak self] _ in
                self?.heartAnimationView?.removeFromSuperview()
            }
        }
    }
    
    private func setupViews() {
        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        addSubview(profileImageView)

        usernameLabel.textColor = .white
        viewersLabel.textColor = .white
        likesLabel.textColor = .white
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        
        addSubview(usernameLabel)
        addSubview(viewersLabel)
        addSubview(likesLabel)
        addSubview(descriptionLabel)

        setupCommentTableView()
        setupCommentText()

        setupConstraints()
    }
    
    private func setupCommentTableView() {
        commentsTableView = UITableView(frame: CGRect(x: 0, y: bounds.height * 0.7, width: bounds.width, height: bounds.height * 0.3))
        commentsTableView.estimatedRowHeight = 60
        commentsTableView.rowHeight = UITableView.automaticDimension
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        commentsTableView.backgroundColor = .clear
        commentsTableView.separatorStyle = .none
        commentsTableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        addSubview(commentsTableView)
    }
    
    private func setupCommentText() {
        commentInputField.delegate = self
        commentInputField.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        commentInputField.textColor = .white
        commentInputField.returnKeyType = .done
        commentInputField.layer.cornerRadius = 5
        commentInputField.placeholder = "  Add a comment..."
        addSubview(commentInputField)
    }

    private func setupConstraints() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        viewersLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        commentsTableView.translatesAutoresizingMaskIntoConstraints = false
        commentInputField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),

            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),

            viewersLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            viewersLabel.topAnchor.constraint(equalTo: topAnchor, constant: 56),

            likesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            likesLabel.topAnchor.constraint(equalTo: viewersLabel.bottomAnchor, constant: 8),

            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),

            commentsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            commentsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            commentsTableView.bottomAnchor.constraint(equalTo: commentInputField.topAnchor, constant: -8),
            commentsTableView.heightAnchor.constraint(equalToConstant: 230),

            commentInputField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            commentInputField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            commentInputField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            commentInputField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func getGradientLayer(frame: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "gradientMaskLayer"
        gradientLayer.frame = frame
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0.0).cgColor,
            UIColor.white.withAlphaComponent(0.2).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.2)
                
        return gradientLayer
    }
    
    private func startAddingMockComments() {
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.addMockComment()
        }
    }

    private func addMockComment() {
        let newComment = Comment(username: "User \(comments.count + 1)", picURL: "", comment: "This is a mock comment.")
        comments.append(newComment)
        commentsTableView.reloadData()
        scrollToLatestComment()
    }

    private func scrollToLatestComment() {
        let lastIndex = IndexPath(row: comments.count - 1, section: 0)
        commentsTableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
    }

    func configure(with video: Video) {
        usernameLabel.text = video.username
        viewersLabel.text = "\(video.viewers) viewers"
        likesLabel.text = "\(video.likes) likes"
        descriptionLabel.text = video.description
        downloadAndSetProfileImgae(url: video.profilePicURL)
        
        playerLayer = AVPlayerLayer()
        guard let playerLayer = playerLayer else { return }
        playerLayer.videoGravity = .resizeAspectFill
        layer.insertSublayer(playerLayer, at: 0)
        
        setupPlayer(url: video.video)
        startAddingMockComments()
    }
    
    private func setupPlayer(url: String) {
        guard let videoURL = URL(string: url), player == nil else { return }
                   
        player = AVPlayer(url: videoURL)
        playerLayer?.player = player
        player?.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { _ in
            self.player?.seek(to: .zero)
            self.player?.play()
        }
    }
    
    func playVideo() {
        player?.play()
    }

    func pauseVideo() {
        player?.pause()
    }
    
    private func downloadAndSetProfileImgae(url: String) {
        if let url = URL(string: url) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.profileImageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    private func addGradientToTopVisibleCell() {
        for cell in commentsTableView.visibleCells {
            cell.contentView.layer.sublayers?.removeAll(where: { $0.name == "gradientMaskLayer" })
            }
        
        guard let topVisibleIndexPath = commentsTableView.indexPathsForVisibleRows?.min(),
        let topVisibleCell = commentsTableView.cellForRow(at: topVisibleIndexPath) else { return }

        let gradientLayer = getGradientLayer(frame: topVisibleCell.contentView.bounds)
        topVisibleCell.contentView.layer.addSublayer(gradientLayer)
    }
}

extension VideoCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as! CommentCell
        cell.backgroundColor = .clear
        cell.configure(with: comments[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        addGradientToTopVisibleCell()
    }
}

extension VideoCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textField.text, !text.isEmpty else { return false }
        let newComment = Comment(username: "You", picURL: "", comment: text)
        comments.append(newComment)
        commentsTableView.reloadData()
        scrollToLatestComment()
        textField.text = ""
        return true
    }
}
