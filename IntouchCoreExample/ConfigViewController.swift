import UIKit
import CoreLocation
import MapplsIntouchCore

final class ConfigViewController: UIViewController {

    // MARK: - UI Elements

    private let pollingProfileSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Slow", "optimal", "Fast"])
        control.selectedSegmentIndex = 1
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private let allowsBackgroundLocationUpdatesSwitch: UISwitch = {
        let sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
    }()
    
    private let showsBackgroundUpdatesSwitch: UISwitch = {
        let sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
    }()
    

    private let desiredAccuracySegmentedControl: UISegmentedControl = {
        let items = ["Best", "Nearest10m", "HundredMeters", "Kilometer"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private let distanceFilterStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 0
        stepper.maximumValue = 10000
        stepper.stepValue = 10
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()

    private let distanceFilterValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0 m"
        label.textAlignment = .right
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let itemCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Item Count: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let sendingFrequencyLabel: UILabel = {
        let label = UILabel()
        label.text = "Sending Frequency: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "MapplsIntouch Configuration"

        setupLayout()
        setupActions()
        loadConfigurationValues()
    }

    // MARK: - Setup

    private func setupLayout() {
        // Distance filter horizontal stack (label + stepper)
        let distanceFilterStack = UIStackView(arrangedSubviews: [
            UILabel(text: "Distance Filter (m):"),
            distanceFilterValueLabel,
            distanceFilterStepper
        ])
        distanceFilterStack.axis = .horizontal
        distanceFilterStack.alignment = .center
        distanceFilterStack.spacing = 8
        distanceFilterStack.translatesAutoresizingMaskIntoConstraints = false

        // allowsBackgroundLocationUpdates horizontal stack (label + switch)
        let backgroundLocationStack = UIStackView(arrangedSubviews: [
            UILabel(text: "Allows Background Location Updates"),
            allowsBackgroundLocationUpdatesSwitch
        ])
        backgroundLocationStack.axis = .horizontal
        backgroundLocationStack.alignment = .center
        backgroundLocationStack.spacing = 8
        backgroundLocationStack.translatesAutoresizingMaskIntoConstraints = false
        
        
        // allowsBackgroundLocationUpdates horizontal stack (label + switch)
        let showsBackgroundUpdatesStack = UIStackView(arrangedSubviews: [
            UILabel(text: "Show Background Location Updates"),
            showsBackgroundUpdatesSwitch
        ])
        showsBackgroundUpdatesStack.axis = .horizontal
        showsBackgroundUpdatesStack.alignment = .center
        showsBackgroundUpdatesStack.spacing = 8
        showsBackgroundUpdatesStack.translatesAutoresizingMaskIntoConstraints = false

        let pollingProfileLabel = UILabel(text: "Polling Profile")
        let desiredAccuracyLabel = UILabel(text: "Desired Accuracy")

        let mainStack = UIStackView(arrangedSubviews: [
            pollingProfileLabel,
            pollingProfileSegmentedControl,
            backgroundLocationStack,
            showsBackgroundUpdatesStack,
            desiredAccuracyLabel,
            desiredAccuracySegmentedControl,
            distanceFilterStack,
            itemCountLabel,
            sendingFrequencyLabel,
            saveButton
        ])
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.alignment = .fill
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }

    private func setupActions() {
        distanceFilterStepper.addTarget(self, action: #selector(distanceFilterStepperChanged(_:)), for: .valueChanged)
        saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
    }

    // MARK: - Load Configuration

    private func loadConfigurationValues() {
        let config = MapplsIntouchConfiguration.shared

        pollingProfileSegmentedControl.selectedSegmentIndex = pollingProfileSegmentIndex(from: config.pollingProfile)
        allowsBackgroundLocationUpdatesSwitch.isOn = config.allowsBackgroundLocationUpdates
        showsBackgroundUpdatesSwitch.isOn = config.showsBackgroundLocationIndicator
        desiredAccuracySegmentedControl.selectedSegmentIndex = desiredAccuracySegmentIndex(from: config.desiredAccuracy)
        distanceFilterStepper.value = Double(config.distanceFilter)
        distanceFilterValueLabel.text = "\(Int(config.distanceFilter)) m"
        itemCountLabel.text = "Item Count: \(config.itemCount)"
        sendingFrequencyLabel.text = "Sending Frequency: \(config.sendingFrequency) sec"
    }

    // MARK: - Actions

    @objc private func distanceFilterStepperChanged(_ sender: UIStepper) {
        let value = Int(sender.value)
        distanceFilterValueLabel.text = "\(value) m"
    }

    @objc private func saveButtonTapped(_ sender: UIButton) {
        let config = MapplsIntouchConfiguration.shared

        config.setPollingProfile(profile: pollingProfile(from: pollingProfileSegmentedControl.selectedSegmentIndex))
        config.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdatesSwitch.isOn
        config.desiredAccuracy = desiredAccuracy(from: desiredAccuracySegmentedControl.selectedSegmentIndex)
        config.distanceFilter = CLLocationDistance(distanceFilterStepper.value)
        config.showsBackgroundLocationIndicator = showsBackgroundUpdatesSwitch.isOn

        // itemCount and sendingFrequency are read-only, no save here

        if let navigationController = navigationController {
            navigationController.dismiss(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - Helpers for Mapping

    private func pollingProfileSegmentIndex(from profile: PollingProfile) -> Int {
        switch profile {
        case .slow: return 0
        case .optimal: return 1
        case .fast: return 2
        case .significantLocationChanges: return 3
        @unknown default: return 1
        }
    }

    private func pollingProfile(from index: Int) -> PollingProfile {
        switch index {
        case 0: return .slow
        case 1: return .optimal
        case 2: return .fast
        default: return .optimal
        }
    }

    private func desiredAccuracySegmentIndex(from accuracy: CLLocationAccuracy) -> Int {
        switch accuracy {
        case kCLLocationAccuracyBest:
            return 0
        case kCLLocationAccuracyNearestTenMeters:
            return 1
        case kCLLocationAccuracyHundredMeters:
            return 2
        case kCLLocationAccuracyKilometer:
            return 3
        default:
            return 0
        }
    }

    private func desiredAccuracy(from index: Int) -> CLLocationAccuracy {
        switch index {
        case 0: return kCLLocationAccuracyBest
        case 1: return kCLLocationAccuracyNearestTenMeters
        case 2: return kCLLocationAccuracyHundredMeters
        case 3: return kCLLocationAccuracyKilometer
        default: return kCLLocationAccuracyBest
        }
    }
}

private extension UILabel {
    convenience init(text: String) {
        self.init()
        self.text = text
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
