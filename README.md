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

## 🛠 How to Use

FireRest 🔥 separates the **Core Protocols** (installed via SPM) from the **Network Logic** (which you choose).

### 1. Choose a Transport
You need an implementation to send requests.
* **Ready-made:** Copy files from the **[Implementations folder](Implementations)** (REST or Firebase).
* **Custom:** Create your own class conforming to `NetworkTransport` (e.g., for Alamofire or Mocks).

### 2. See Examples
For setup, request definitions, and usage:
👉 **[Check the Examples folder](Examples)**

---

## 📦 Installation

### Swift Package Manager

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/OSTAPMARCHENKO/FireRest.git", from: "1.0.0")
]```

---

## 🤝 Contributing

We welcome contributions! Whether you're fixing a bug, adding a new feature, or improving documentation, your help is appreciated.

### How to Contribute:

1.  **Open an Issue:** Before starting any significant work (like a new Transport implementation or a major feature), please open an Issue first. This helps us discuss the proposed changes and avoid duplicated work.
2.  **Fork the Repository:** Fork the `FireRest` repository to your own GitHub account.
3.  **Create a Feature Branch:** Always create a new branch for your changes (e.g., `git checkout -b feature/alamofire-transport`).
4.  **Commit and Push:** Commit your changes and push your branch to your Fork.
5.  **Open a Pull Request (PR):** Target the `main` branch of the original `FireRest` repository. Please provide a clear description of the changes in the PR body.

### Standards:

* **Style:** Please maintain the existing coding style and English documentation/comments.
* **Testing:** If you add complex logic, please include Unit Tests if possible.
