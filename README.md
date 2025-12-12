# FireRest 🔥

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS-blue.svg)](https://developer.apple.com/swift/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**Unified Network & Storage Transport for Swift.**

FireRest is a protocol-oriented abstraction layer that allows you to seamlessly switch between **REST API** (URLSession) and **Firebase** (Firestore & Storage) without changing your business logic.

## 💡 Why FireRest?

Starting a project with Firebase is fast, but migrating away from it later is painful. FireRest solves this by decoupling your app's logic from the specific backend implementation.

* **Zero Hard Dependencies:** The core package is lightweight. You only add the Firebase SDK if you actually use the Firebase implementation.
* **Unified Storage:** Upload and download files using a common interface, whether you use Firebase Storage or a custom file server.
* **Type-Safe:** Built-in support for generic `Codable` responses and typed errors.
* **Async/Await:** Built purely for modern Swift concurrency.

---

## 📦 Installation

### Swift Package Manager

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/OSTAPMARCHENKO/FireRest.git", from: "1.0.0")
]

🛠 How to Use
1. Get the Transports

FireRest requires you to copy the specific transport implementations into your project to avoid unnecessary dependencies. 👉 Go to Implementations folder and copy the files you need (REST or Firebase).

2. See Code https://www.google.com/search?q=Examples

For full instructions on how to initialize the NetworkManager, define requests, and use them in a ViewModel: 👉 Check the Examples folder
