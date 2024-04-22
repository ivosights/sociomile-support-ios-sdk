//
//  VideoViewController.swift
//  scm-sdk-ios
//
//  Created by Meynisa on 13/03/24.
//

import UIKit
import AVKit

@available(iOS 13.0, *)
class VideoViewController: BaseViewController {
    private var videoURL: URL
    
    lazy var playerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var player: AVPlayer?
    var playerViewController: AVPlayerViewController?
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Video Player"
        view.backgroundColor = .systemGray6
        
        playerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(playerView)
        
        self.player = AVPlayer(url: videoURL)
        self.playerViewController = AVPlayerViewController()
        self.playerViewController?.player = self.player
        self.playerViewController?.view.frame = self.playerView.frame
        self.playerViewController?.player?.play()
        self.playerViewController?.view.backgroundColor = .systemGray6
        self.playerView.addSubview((playerViewController?.view)!)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingToParent{
            try? FileManager.default.removeItem(at: videoURL)
        }
    }
}
