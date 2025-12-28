# SMASHING-iOS
SMASHING iOS 레포입니다 🏓

# 프로젝트 설명

# 구성원 소개

# 사용할 라이브러리

# Coding Convention

### 파일명

- 약어 사용하지 않음 ⇒ 너무 길경우 팀원과 논의 후 결정

### **변수, 상수**

- **lowerCamelCase** 사용

### **열거형**

- 각 case에는 **lowerCamelCase** 사용

---

### 클래스 / 구조체

- 이름: **UpperCamelCase**
- 접두사 사용 금지 (un-fair, in-activate)

```swift
class SomeClass {}
struct SomeStructure {}
```

### 함수

- 이름: **lowerCamelCase**
- 액션 함수: `주어 + 동사 + 목적어`
- `tap` → `.touchUpInside`, `press` → `.touchDown`

```swift
func backButtonDidTap() {}
```

### 변수 / 상수

- 모두 **lowerCamelCase**

```swift
let maximumNumberOfLines = 3
```

### 열거형

- enum 이름: **UpperCamelCase**
- case 이름: **lowerCamelCase**

```swift
enum Result {
  case success
  case failure
}
```

### 프로토콜

- 이름: **UpperCamelCase**
- 채택 시 콜론 뒤 공백

```swift
protocol SomeProtocol {}
class SomeClass: SomeProtocol {}
extension UIViewController: SomeProtocol {}
```

### 약어

- 시작 시 소문자, 중간/끝은 대문자

```swift
let html: String?
let websiteURL: URL?
```

### Delegate

- 프로토콜명 + 행 위로 네임스페이스 구분

```swift
protocol UserCellDelegate {
  func userCellDidSetProfileImage(_ cell: UserCell)
}
```

### 클로저

- 빈 클로저: `() -> Void`
- 파라미터 괄호 생략
- 타입 생략 가능
- 마지막 클로저는 파라미터명 생략 (trailing closure)

```swift
UIView.animate(withDuration: 0.3) {
  // doSomething
}
```

### 기타

- 내부에서는 `self` 명시
- 구조체 생성 시 Swift 문법 사용

```swift
let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
```

- 컬렉션 타입은 `[]` 표기

```swift
var messages: [String]
var names: [Int: String]
```

# Git Flow

## 🌳 Branch Strategy

main: 최종 제출 및 릴리즈 (배포용)

develop: 개발 중심 브랜치 (Default)

tag/#이슈번호: 세부 기능 개발

## 🏷️ tag 종류

`feat` : 새로운 기능 구현 시 사용

`fix` : 버그나 오류 해결 시 사용

`docs` : README, 템플릿 등 프로젝트 내 문서 수정 시 사용

`setting` : 프로젝트 관련 설정 변경 시 사용

`add` : 사진 등 에셋이나 라이브러리 추가 시 사용

`refactor` : 기존 코드를 리팩토링하거나 수정할 시 사용

`chore` : 별로 중요한 수정이 아닐 시 사용


## 🔄 Work Process

Branch: develop에서 각자 이슈 번호에 맞는 feature 브랜치 생성

PR: 작업 완료 후 develop 브랜치로 Pull Request 생성

Review: 작성자 제외 팀원 전원 승인(Approve) 필수

수정 요청 시 반영 완료 후 다시 Approve

Merge: 모든 승인이 완료되면 develop으로 머지


# 프로젝트 폴더링

```
📦 SMASHING
 ┣ 📂 Applications
 ┃ ┣ 📄 AppDelegate.swift
 ┃ ┗ 📄 SceneDelegate.swift
 ┣ 📂 Global
 ┃ ┣ 📂 Base                            # BaseView, BaswViewController 등
 ┃ ┣ 📂 Components                      # 공통 UI 컴포넌트
 ┃ ┣ 📂 Extensions
 ┃ ┗ 📂 Resource
 ┃   ┣ 🖼️ Assets.xcassets
 ┃   ┗ ⚙️ Info.plist
 ┣ 📂 Network
 ┃ ┣ 📂 API                             # API Endpoint 정의
 ┃ ┣ 📂 Base                            # 네트워크 통신 기초 설계
 ┃ ┣ 📂 DTO                             # Data Transfer Object
 ┃ ┗ 📂 Service                         # 네트워크 비즈니스 로직
 ┗ 📂 Presentation
   ┣ 📂 Core
   ┃ ┗ 📄 ViewModelType.swift           # I/O 패턴을 위한 공통 프로토콜
   ┣ 📂 Main (Feature)
   ┃ ┣ 📄 MainViewController.swift
   ┃ ┣ 📄 MainViewModel.swift           # Input/Output 구조체 포함
   ┃ ┗ 📄 MainView.swift                # UI 코드가 길 경우 분리
   ┗ 📂 Search (Feature)
     ┣ 📄 SearchViewController.swift
     ┗ 📄 SearchViewModel.swift
```
