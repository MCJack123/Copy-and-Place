import UIKit
import PlaygroundSupport

class PlaygroundView: UIView, PlaygroundLiveViewSafeAreaContainer {}

class ARViewController: UIViewController {
    override func loadView() {
        view = PlaygroundView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        let errorLabel = UILabel(frame: CGRect(x: 0, y: (view.frame.height - 18) / 2, width: 100, height: 18))
        errorLabel.text = "Press \"Run My Code\" to start."
        errorLabel.textColor = .black
        errorLabel.textAlignment = .center
        errorLabel.clipsToBounds = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.topAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.bottomAnchor)
            ])
    }
}

class ErrorView: UIViewController {
    override func loadView() {
        view = PlaygroundView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .black
        let errorLabel = UILabel(frame: CGRect(x: 0, y: (view.frame.height - 18) / 2, width: 100, height: 18))
        errorLabel.text = "Please select the object to use before running this page."
        errorLabel.textColor = .white
        errorLabel.textAlignment = .center
        errorLabel.clipsToBounds = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.topAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: (view as! PlaygroundView).liveViewSafeAreaGuide.bottomAnchor)
            ])
    }
}

var vc: UIViewController = ErrorView()
if let val = PlaygroundKeyValueStore.current["objectName"] {
    if case let .string(s) = val {
        vc = ARViewController()
    }
}
PlaygroundPage.current.liveView = vc
