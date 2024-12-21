//
//  ViewController.swift
//  LiveStream
//
//  Created by Abhishek Kumar Singh on 20/12/24.
//

import UIKit

final class LiveStreamViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let mockViewModel = MockDataViewModel()
    private var videos: [Video] = []
    private var comments: [Comment] = []
    private var previousIndex = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadMockData()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: VideoCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        view.addSubview(collectionView)
    }

    private func loadMockData() {
        mockViewModel.loadMockVideoData { [weak self] result in
            if let result = result {
                self?.videos = result.videos
            }
        }

        mockViewModel.loadCommentMockData { [weak self] result in
            if let result = result {
                self?.comments = result.comments
            }
        }
 
        collectionView.reloadData()
        
        collectionView.performBatchUpdates {
            if let firstCell = self.collectionView.cellForItem(at: IndexPath(item: self.previousIndex, section: 0)) as? VideoCell {
                firstCell.playVideo()
            }
        }
    }
    
    func calculateCurrentPage(for collectionView: UICollectionView) -> Int {
        let pageHeight = collectionView.frame.height
        return Int((collectionView.contentOffset.y + (pageHeight / 2)) / pageHeight)
    }
    
    private func playVideo(at index: Int) {
        if let previousCell = collectionView.cellForItem(at: IndexPath(item: previousIndex, section: 0)) as? VideoCell {
            previousCell.pauseVideo()
        }
         
        if let visibleCell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? VideoCell {
            visibleCell.playVideo()
        }
        
        previousIndex = index
    }
}

extension LiveStreamViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.identifier, for: indexPath) as! VideoCell
        let video = videos[indexPath.item]
        cell.configure(with: video)
        cell.comments = comments
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = calculateCurrentPage(for: collectionView)
        playVideo(at: currentPage)
    }
}

