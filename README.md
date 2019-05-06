# XYRefresh
An easy way to use pull-to-refresh


## Requirements

- iOS 10.0+
- Xcode 10.1+
- Swift 4.2+

## Installation

- Installation with [Carthage](https://github.com/Carthage/Carthage):
```
github "RayJiang16/XYRefresh"
```

- Installation with [CocoaPods](https://cocoapods.org/):
```
pod 'XYRefresh'
```

## Usage
**Quick Start**
```swift
import XYRefresh

final class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refresh.header = RefreshNormalHeader { [weak self] in
            self?.tableView.refresh.header?.endRefreshing()
        }
        tableView.refresh.footer = RefreshAutoStateFooter { [weak self] in
            self?.tableView.refresh.footer?.endRefreshing()
        }
    }
}
```


## License

**XYRefresh** is under MIT license. See the [LICENSE](LICENSE) file for more info.
