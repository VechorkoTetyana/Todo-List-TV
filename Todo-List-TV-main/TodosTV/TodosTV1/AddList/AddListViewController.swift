import Foundation
import UIKit

class AddListViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var imageBackground: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var saveBtnBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageBackground.setCornerRadius(20)
        saveBtn.setCornerRadius(14)
        
        subscribeToKeyboard()
        setupHideKeyBoardGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    private func setupHideKeyBoardGesture() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyBoard)
        )
        
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyBoard() {
        view.endEditing(true)
    }
    
    private func subscribeToKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        
        guard let userInfo = notification.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        if endFrame.origin.y >= UIScreen.main.bounds.size.height {
            saveBtnBottomConstraint.constant = 0
        } else {
            let buttonBottomMargin = 16 + endFrame.height - view.safeAreaInsets.bottom
            saveBtnBottomConstraint.constant = buttonBottomMargin
        }
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
    }
}
