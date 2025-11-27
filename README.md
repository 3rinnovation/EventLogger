# EventLogger

iOS 터치 이벤트와 키보드(외장) 이벤트를 로깅하는 Swift 라이브러리

## 요구사항

- iOS 16.0+
- Swift 5.9+

## 설치

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/3rinnovation/EventLogger", from: "1.0.0")
]
```

## 사용법

### 1. TouchesWindow 설정

`SceneDelegate.swift`에서 `TouchesWindow`를 설정합니다:

```swift
import UIKit
import EventLogger

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = TouchesWindow(windowScene: windowScene)
        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
    }
}
```

### 2. 로그 데이터 불러오기

#### 터치 이벤트 로그

```swift
import EventLogger

// DIRECT 터치 (손가락)
if let data = TouchEvent.loadFromFile(type: .direct) {
    let logString = String(data: data, encoding: .utf8)
    print(logString)
}

// TRACKPAD 터치
if let data = TouchEvent.loadFromFile(type: .trackpad) {
    // ...
}

// PENCIL 터치
if let data = TouchEvent.loadFromFile(type: .pencil) {
    // ...
}
```

#### 키보드 이벤트 로그

```swift
import EventLogger

if let data = KeyboardEvent.loadFromFile() {
    let logString = String(data: data, encoding: .utf8)
    print(logString)
}
```

### 3. 로그 파일 삭제

```swift
// 터치 이벤트 로그 삭제
TouchEvent.deleteFile(type: .direct)
TouchEvent.deleteFile(type: .trackpad)
TouchEvent.deleteFile(type: .pencil)

// 키보드 이벤트 로그 삭제
KeyboardEvent.deleteFile()
```

## 이벤트 타입

### TouchType

- `.direct` - 손가락 터치
- `.trackpad` - 트랙패드 터치
- `.pencil` - Apple Pencil 터치

### TouchPhase

- `.began` - 터치 시작
- `.moved` - 터치 이동
- `.stationary` - 터치 정지
- `.ended` - 터치 종료
- `.cancelled` - 터치 취소
- `.regionEntered` - 영역 진입
- `.regionMoved` - 영역 내 이동
- `.regionExited` - 영역 나감

## 저장 위치

모든 로그는 앱의 Documents Directory에 저장됩니다:

- 터치 이벤트: `touch_events_DIRECT.json`, `touch_events_TRACKPAD.json`, `touch_events_PENCIL.json`
- 키보드 이벤트: `keyboard_events.log`

## 라이선스

MIT
