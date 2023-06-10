# Handwriting Recognition iOS App

This project is an iOS application that uses Google's MLKit's Digital Ink Recognition capabilities to identify handwritten text. It includes a custom UIView subclass that serves as a writing canvas. The UIView includes a grid layout for structured input.


<p align="center">
 <img src="https://github.com/Sumayya07/SadarHandloomAssignment/assets/95580926/9588ccea-10c3-4d4f-8b9a-0a4a7dd6475b.png" width="27.3%">
 <img width="1440" alt="Screenshot 2023-06-11 at 2 38 48 AM" src="https://github.com/Sumayya07/SadarHandloomAssignment/assets/95580926/7b3ddc58-dcf6-48df-9269-0ae308907f17">

</p>


## Features

- **Handwriting input**: Users can input handwriting using their finger or a stylus. The input is captured in a custom UIView that includes gridlines for structure.
- **Handwriting recognition**: The app uses Google's MLKit's Digital Ink Recognition to process the handwriting input and convert it into digital text.

## Setup

To run this project, you will need to:

1. Clone the repo: git clone https://github.com/your-repo/handwriting-recognition.git
2. Open the `.xcworkspace` file in Xcode.
3. Ensure that you have CocoaPods installed. If not, you can install it with 
4. Install the necessary pods with `pod install`.
5. Build and run the project in Xcode.

## Usage

To use the app:

1. Tap anywhere in the grid to start writing.
2. Lift your finger or stylus to finish a stroke.
3. When you finish writing, the app automatically processes your input and converts it into digital text.

## Dependencies

This app uses the following third-party libraries:

- `MLKit`: This library is used for handwriting recognition.

## Contributing

Contributions to this project are welcome. Please open an issue to discuss your proposed changes before making a pull request.

## License

This project is licensed under the terms of the MIT license. See `LICENSE` for more information.
