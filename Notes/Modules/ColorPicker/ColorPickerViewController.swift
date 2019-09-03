//
//  ColorPickerViewController.swift
//  Notes
//
//  Created by Jag Stang on 10/07/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import UIKit

class ColorPickerViewController: UIViewController {

    var presenter: ColorPickerPresenterProtocol!
    
    @IBOutlet weak var colorPreview: UIView!
    @IBOutlet weak var colorCode: UILabel!
    @IBOutlet weak var colorCodeContainer: UIView!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var colorPicker: GradientColorView!
    
    var colorAim: ColorAimView?
    
    @IBAction func doneTap(_ sender: UIButton) {
        if let color = self.colorPreview.backgroundColor {
            presenter.didTapDone(color: color)
        }
    }
    
    @IBAction func brightnessChanged(_ sender: UISlider, _ event: UIEvent) {
        colorPicker.brightness = CGFloat(sender.value)
        
        if let colorAim = colorAim {
            updateSelectedColor(in: colorAim.center)
        }
        return
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewDidAppear()
    }
}

extension ColorPickerViewController: ColorPickerViewProtocol {
    func setupViews(color: UIColor) {
        initColorPicker()
        initColorPreview()
        initColorAim()
        
        initColor(color)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapColorPicker))
        colorPicker.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panColorPicker))
        colorPicker.addGestureRecognizer(panGesture)
    }
    
    func initAimPosition(color: UIColor) {
        if let point = colorPicker.updateBy(color: color) {
            colorAim?.center = point
        }
    }
    
    private func initColorPicker() {
        colorPicker.layer.borderWidth = 1
        colorPicker.layer.borderColor = UIColor.black.cgColor
    }
    
    private func initColorPreview() {
        colorPreview.layer.borderWidth = 1
        colorPreview.layer.borderColor = UIColor.black.cgColor
        colorPreview.clipsToBounds = true
        colorPreview.layer.cornerRadius = 5
        colorPreview.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        colorCodeContainer.layer.borderWidth = 1
        colorCodeContainer.layer.borderColor = UIColor.black.cgColor
        colorCodeContainer.clipsToBounds = true
        colorCodeContainer.layer.cornerRadius = 5
        colorCodeContainer.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    private func initColorAim() {
        let size = 30
        let colorAim = ColorAimView()
        colorAim.backgroundColor = .clear
        colorAim.frame = CGRect(x: -size, y: -size, width: size, height: size)
        colorPicker.addSubview(colorAim)
        self.colorAim = colorAim
    }
    
    private func initColor(_ color: UIColor) {
        colorPreview.backgroundColor = color
        colorCode.text = getLabel(from: color)
        
        let _ = colorPicker.updateBy(color: color)
        brightnessSlider.value = Float(colorPicker.brightness)
    }
    
    private func getLabel(from color: UIColor) -> String {
        let hex = color.hex
        let end = hex.index(hex.endIndex, offsetBy: -2)
        
        return String(hex[..<end])
    }
    
    private func updateSelectedColor(in point: CGPoint) {
        guard let color = colorPicker.getColorBy(point: point) else { return }
        
        colorPreview.backgroundColor = color
        colorCode.text = getLabel(from: color)
    }
}

// Mark: - aim position
extension ColorPickerViewController {
    @objc func tapColorPicker(_ sender: UITapGestureRecognizer? = nil) {
        guard let sender = sender else { return }
        
        let point = sender.location(in: colorPicker)
        colorAim?.center = point
        
        updateSelectedColor(in: point)
    }
    
    @objc func panColorPicker(_ sender: UIPanGestureRecognizer? = nil) {
        guard let sender = sender else { return }
        
        var point = sender.location(in: colorPicker)
        point.x = max(point.x, 0)
        point.x = min(point.x, colorPicker.frame.size.width)
        point.y = max(point.y, 0)
        point.y = min(point.y, colorPicker.frame.size.height)
        
        colorAim?.center = point
        
        updateSelectedColor(in: point)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        colorAim?.isHidden = true
        
        coordinator.animateAlongsideTransition(in: nil, animation: nil, completion: {
            [weak self] _ in
            guard let self = self else { return }
            
            self.colorAim?.isHidden = false
            
            if let color = self.colorPreview.backgroundColor,
                let point = self.colorPicker.updateBy(color: color) {
                self.colorAim?.center = point
            }
        })
    }
}

