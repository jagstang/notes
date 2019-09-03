//
//  NoteEditViewController.swift
//  Notes
//
//  Created by Jag Stang on 12/07/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

class NoteEditViewController: UIViewController {
    
    private let defaultCustomColor = "#76EEFFFF"
    private let contentPlaceholder = "Enter content"
    
    var presenter: NoteEditPresenterProtocol!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var colorStackView: UIStackView!
    
    @IBOutlet weak var dateTopPadding: NSLayoutConstraint!
    @IBOutlet weak var dateBottomPadding: NSLayoutConstraint!
    @IBOutlet weak var dateHeight: NSLayoutConstraint!
    
    @IBAction func dateSwitchChanged(_ sender: UISwitch) {
        updateDatePickerUi()
    }
    
    private var dateHeightOnStart: CGFloat?
    private var selectedColor: Int = 0
    private var gradientColorView: GradientColorView?
    private var customColorView: ColorSelectorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animateAlongsideTransition(in: nil, animation: nil, completion: {
            [weak self] _ in
            guard let self = self else { return }

            self.textViewDidChange(self.contentTextView)
        })
    }
}

extension NoteEditViewController: NoteEditViewProtocol {
    
    func setupViews() {
        initTabBar()
        initTextViewAndKeyboard()
        initDateSelection()
        initColorSelection()
    }
    
    public func load(note: Note) {
        titleField.text = note.title
        contentTextView.text = note.content
        textViewDidChange(contentTextView)
        if let date = note.selfDestructionDate {
            datePicker.date = date
            dateSwitch.isOn = true
            updateDatePickerUi()
        }
        
        for (index, subview) in colorStackView.subviews.enumerated() {
            if let subview = subview as? ColorSelectorView {
                if subview.backgroundColor?.hex == note.color.hex {
                    updateSelectedColor(index: index)
                    return
                }
            }
        }
        
        updateCustomColor(note.color)
    }
    
    func getCurrentCustomColor() -> UIColor {
        if let view = customColorView {
            if !view.isHidden {
                if let color = view.backgroundColor {
                    return color
                }
            }
        }
        
        return UIColor(hex: self.defaultCustomColor)!
    }
    
    func updateCustomColor(_ color: UIColor) {
        guard let gradientView = gradientColorView,
            let customView = customColorView,
            let customId = customView.id else {
                return
        }
        
        customView.backgroundColor = color
        
        if customView.isHidden {
            customView.isHidden = false
            gradientView.isHidden = true
        }
        
        selectedColor = customId
        
        updateColorSelectorSelected()
    }
    
    private func initTabBar() {
        self.title = ""
        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(tapSave))
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(tapCancel))
        navigationItem.rightBarButtonItem = save
        navigationItem.leftBarButtonItem = cancel
    }
    
    private func initTextViewAndKeyboard() {
        contentTextView.delegate = self
        contentTextView.isScrollEnabled = false
        textViewDidChange(contentTextView)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func initDateSelection() {
        dateHeightOnStart = dateHeight.constant
        dateSwitch.isOn = false
        updateDatePickerUi()
    }
    
    private func updateDatePickerUi() {
        guard let dateHeightOnStart = self.dateHeightOnStart else {
            return
        }
        
        if dateSwitch.isOn {
            dateTopPadding.constant *= 2
            dateBottomPadding.constant *= 2
            dateHeight.constant = dateHeightOnStart
            datePicker.isHidden = false
        } else {
            dateTopPadding.constant /= 2
            dateBottomPadding.constant /= 2
            dateHeight.constant = 0
            datePicker.isHidden = true
        }
    }
    
    private func initColorSelection() {
        for (index, subview) in colorStackView.subviews.enumerated() {
            subview.layer.borderWidth = 1
            subview.layer.borderColor = UIColor.black.cgColor
            
            if let subview = subview as? ColorSelectorView {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorSelected))
                subview.addGestureRecognizer(tapGesture)
                subview.id = index
                if subview.isHidden {
                    addLongPressGesture(subview)
                    self.customColorView = subview
                }
            }
            
            if let gradientView = subview as? GradientColorView {
                addLongPressGesture(gradientView)
                self.gradientColorView = gradientView
            }
        }
        updateColorSelectorSelected()
    }
    
    private func addLongPressGesture(_ view: UIView) {
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(customColorSelected(_:)))
        tapGesture.minimumPressDuration = 0.2
        tapGesture.delaysTouchesBegan = true
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    private func updateColorSelectorSelected() {
        for subview in colorStackView.subviews {
            if let colorSelector = subview as? ColorSelectorView {
                if let id = colorSelector.id {
                    colorSelector.isSelected = id == selectedColor
                }
            }
        }
    }
    
    private func getSelectedColor() -> UIColor? {
        for subview in colorStackView.subviews {
            if let colorSelector = subview as? ColorSelectorView {
                if let id = colorSelector.id {
                    if id == selectedColor {
                        return colorSelector.backgroundColor
                    }
                }
            }
        }
        
        return nil
    }
}

// Mark: - content TextView interaction
extension NoteEditViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}

// Mark: - keyboard interaction
extension NoteEditViewController {
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = self.view.convert(keyboardScreenEndFrame, from: self.view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardViewEndFrame.height - self.view.safeAreaInsets.bottom,
                right: 0
            )
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    @objc func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIApplication.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

// Mark: - color selection
extension NoteEditViewController: UIGestureRecognizerDelegate {
    @objc func colorSelected(_ sender: UITapGestureRecognizer? = nil) {
        if let selector = sender?.view as? ColorSelectorView,
            let id = selector.id {
            updateSelectedColor(index: id)
        }
    }
    
    @objc func customColorSelected(_ sender: UILongPressGestureRecognizer? = nil) {
        guard let sender = sender else {
            return
        }
        
        if sender.state == UIGestureRecognizer.State.began {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            
            presenter.didTapOpenCustomColor()
        }
    }
    
    func updateSelectedColor(index: Int) {
        selectedColor = index
        updateColorSelectorSelected()
    }
}

// Mark: - note model work
extension NoteEditViewController {
    @objc public func tapSave() {
        if titleField.text == nil || titleField.text!.count == 0 {
            titleField.becomeFirstResponder()
            return
        }
        
        var date: Date? = nil
        if dateSwitch.isOn {
            date = datePicker.date
        }
        
        presenter.didTapSaveNote(
            title: titleField.text ?? "",
            content: contentTextView.text ?? "",
            color: getSelectedColor(),
            date: date
        )
    }
    
    @objc public func tapCancel() {
        presenter.didTapCancel()
    }
}

