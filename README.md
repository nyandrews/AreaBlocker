# AreaBlocker

A SwiftUI iOS app that blocks unwanted calls and text notifications from specific area codes.

## Features

- **Area Code Blocking**: Block calls and text notifications from specific area codes (e.g., 771, 773)
- **Call Directory Extension**: Uses CallKit to automatically block calls at the system level
- **Call Logging**: Track blocked and allowed calls with detailed logs
- **Modern UI**: Clean, responsive interface built with SwiftUI
- **Performance Optimized**: Fast startup with lazy loading and background processing

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/AreaBlocker.git
   ```

2. Open `AreaCodeBlocker.xcodeproj` in Xcode

3. Select your development team in the project settings

4. Build and run on your device or simulator

## Usage

1. **Add Area Codes**: Navigate to the "Area Codes" tab and add the area codes you want to block
2. **View Statistics**: Check the Dashboard to see how many calls have been blocked today
3. **Review Logs**: Use the "Call Log" tab to see detailed information about blocked and allowed calls
4. **Configure Settings**: Adjust notification preferences in the Settings tab

## Architecture

- **SwiftUI**: Modern declarative UI framework
- **Core Data**: Local data persistence for area codes and call logs
- **CallKit**: System-level call blocking functionality
- **Call Directory Extension**: Background service for call blocking

## Project Structure

```
AreaCodeBlocker/
├── AreaCodeBlocker/           # Main app target
│   ├── Views/                 # SwiftUI views
│   ├── Managers/              # Business logic managers
│   ├── Core/                  # Core Data stack
│   └── Info.plist
├── AreaCodeBlockerExtension/  # Call Directory Extension
└── AreaCodeBlockerModel.xcdatamodeld  # Core Data model
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Privacy

AreaBlocker respects your privacy:
- All data is stored locally on your device
- No data is sent to external servers
- Call blocking is handled entirely by iOS system services