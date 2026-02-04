# SMASHING-iOS
SMASHING iOS 레포입니다 🏓

# 프로젝트 설명

> 스매싱은 지역 기반 경쟁을 통해 본인의 실력을 확인하고 경쟁을 즐기는 스포츠인들을 위해 탄생한 서비스입니다.

# 구성원 소개

| 이승준 | 홍준범 | 이진재 |
| :----: | :----: | :----: |

| <img src="https://github.com/user-attachments/assets/aaeaa04c-6e4d-4912-91ed-cb3b0aa37da4" width="180" height="280" /> | <img src="https://github.com/user-attachments/assets/a6db8aa7-ae6f-41a1-b0ff-8ef37ba6b911" width="180" height="280" /> | <img src="https://github.com/user-attachments/assets/17863acd-7f48-4a11-b063-b0adc5b038cf" width="180" height="280" /> |

| `iOS Lead` | `iOS Developer` | `iOS Developer` |

# 사용할 라이브러리 및 기술스택
| 영역 | 기술 | 비고 |
|:---:|:---:|---|
| UI 프레임워크 | **UIKit** | 안정적이고 풍부한 레퍼런스, 실무 적합성 |
| 아키텍처 | **MVVM + InputOutput Pattern** | UI, 도메인, 데이터 계층 분리로 유지보수 용이 |
| 네트워킹 | **CombineMoya**	| CTargetType 기반 API 추상화 및 Publisher를 활용한 반응형 비동기 처리 |
| 비동기/반응형 | **Combine** | 데이터 흐름의 선언적 처리, 상태 바인딩 최적화 |
| 이미지 처리 | **Kingfisher** | 이미지 캐싱 및 네트워크 병목 방지 |
| 의존성 주입 | **DIContainer** | 모듈 간 결합도 최소화, 테스트 편의성 확보 |
| 패키지 관리 및 모듈화 | **SPM** | Swift Package Manager 기반 외부 라이브러리 관리 |
| 버전 관리 | **Git, GitHub** | 브랜치 전략 기반 협업, PR 및 코드리뷰 활용 |
| 협업 도구 | **Figma, Notion** | 디자인 및 기능 흐름 시각화, 문서화 기반 협업 |

# Conventions

<details>
  <summary><b>Coding Convention</b></summary>
  <div markdown="1">

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

  </div>
</details>

<details>
  <summary><b>Git Flow</b></summary>
  <div markdown="1">

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

  </div>
</details>


# 프로젝트 폴더링

```
📦 SMASHING
 ┣ 📂 Applications
 ┃ ┣ 📄 AppDelegate.swift
 ┃ ┗ 📄 SceneDelegate.swift
 ┣ 📂 Global
 ┃ ┣ 📂 DIContainer                     # 의존성 주입 관리 (Dependency Injection)
 ┃ ┣ 📂 Base                            # BaseView, BaswViewController 등
 ┃ ┣ 📂 Utility
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
   ┃ ┣ 📂 Factories
   ┃ ┗ 📄 ViewModelType.swift           # I/O 패턴을 위한 공통 프로토콜
   ┣ 📂 Main (Feature)
     ┣ 📄 MainViewController.swift
     ┣ 📄 MainViewModel.swift           # Input/Output 구조체 포함
     ┗ 📄 MainView.swift                # UI 코드가 길 경우 분리
```

# 역할 분담

승준 : 온보딩, 지역 설정, 전적 페이지, 티어 스크롤 팝다운, 티어 설명, 알림

준범 : 홈화면, 랭킹 페이지, 매칭 현황, 결과 입력 화면, 결과 확인

진재 : 매칭 (탭), 유저 검색 화면, 매칭 관리 (탭), 프로필 (상대, 본인)


# 트러블 슈팅 (승준)

## 1. 문제 요약

- **발생 일시:** 2026-01-17
- **문제 설명:** 프로젝트 규모가 커짐에 따라 ViewModel의 `Output` 구조체가 비대해졌으며, ViewController가 처리할 UI 데이터와 Coordinator가 처리할 화면 전환 로직이 한곳에 뒤섞여 유지보수 효율이 저하되는 현상이 발생했습니다.

---

## 2. 상세 내용

- **현상:** ViewModel의 `Output` 내부에 10개 이상의 프로퍼티가 쌓이게 되었고, Coordinator는 오직 화면 전환 관련 스트림만 필요함에도 불구하고 UI 업데이트용 데이터까지 포함된 거대한 `Output` 전체를 관찰해야 하는 상황이 발생했습니다.

```swift
// 문제의 비대한 Output 구조체 예시
struct Output {
    // View 전용
    let userInfo: AnyPublisher<User, Never>
    let isFetching: AnyPublisher<Bool, Never>
    let errorMessage: AnyPublisher<String?, Never>
    
    // Coordinator 전용 (Navigation)
    let showDetailView: AnyPublisher<Int, Never>
    let popToRoot: AnyPublisher<Void, Never>
}
```

---

## 4. 시도한 해결 방법

### 1차 시도: Protocol과 associatedType을 이용한 분리

- **내용:** `InputOutputProtocol`을 정의하고 내부에 `NavigationEvent`라는 연관 타입을 추가하여 코디네이터 전용 이벤트를 분리했습니다.
- **결과:** * **장점:** 타입 레벨에서 UI 출력과 네비게이션 출력이 명확히 구분되어 가독성이 높아졌습니다.
    - **단점:** 매번 새로운 ViewModel을 만들 때마다 연관 타입을 정의해야 하는 보일러플레이트 코드가 증가하고, 프로토콜 구조가 복잡해졌습니다.

### 2차 시도 (최종) : 네이밍 컨벤션을 통한 구분

- **내용:** `Output` 내부에서 `toView_`, `toCoord_` 등의 접두어를 사용하여 역할을 구분했습니다.
- **결과:** * **장점:** 별도의 공수 없이 이름만으로 빠르게 구분이 가능했습니다.
    - **단점:** 근본적으로는 하나의 `Output` 구조체 안에서 관리되므로 인터페이스 분리 원칙(ISP)을 완벽히 지키지 못했으며, 스트림 구독 시 불필요한 데이터에 접근할 수 있는 여지가 남았습니다.

## 5. 스프린트 개선사항

```swift
struct Output { 
    // 오직 UI 업데이트용 데이터만 포함
    let items: AnyPublisher<[Item], Never>
}

// Coordinator를 위한 별도의 통로 분리
enum Action {
    case presentDetail(id: Int)
    case dismiss
}
```

`struct` : `Output`의 스트림을 분리하여 관리하여 관심사를 분리할 수 있습니다.

`enum` : `Coordinator` 에서만 관심이 있으므로 굳이 관심사를 분리하지 않아도 되며 `switch-case` 로 관리할 수 있다는 장점이 있습니다. (`case`가 추가될 때마다 컴파일 단계에서 알아낼 수 있음)


## 트러블 슈팅 (진재)

## Troubleshooting — 상대 프로필 조회 404 (USER_SPORT_PROFILE_NOT_FOUND)

### 문제
- 매칭 탐색에서 **상대 프로필 진입 시 404** 발생
- 에러 메시지는 “상대 프로필이 존재하지 않음”처럼 보였지만, **실제 원인은 `sportCode` 불일치**였다.

---

### 원인 분석
- 상대 프로필 조회 API는 **`userId + sportCode` 조합**이 필요함
- `sportCode`를 전역으로 공유하는 경로가 없어 **기본값(BM)으로 요청되는 경우**가 발생
- `MyProfile` 응답의 `activeProfile.sportCode`를 **Keychain에 저장하지 않던 시점**에는 항상 `fallback(BM)`로 요청되어 404가 발생할 수 있었음

---

### 해결 방향
- userId를 keychain에 저장을 하고나서 userId를 가지고 sportCode를 가져옴**
- 상대 프로필 진입 시 **Keychain 값을 읽어 동일한 `sportCode`로 요청**하도록 변경

<img width="1016" height="518" alt="Image" src="https://github.com/user-attachments/assets/29efc507-57c4-4fd3-b26f-893539678a9f" />

<img width="591" height="121" alt="Image" src="https://github.com/user-attachments/assets/4f658a72-9258-45a9-9fed-c1e0e0addb55" />

---

### 구현 요약

#### 1) 저장 위치
- `MyProfileViewModel.swift`
- `fetchMyProfiles()` 응답 처리에서 `storeSportsCode(from:)` 호출하여 저장

#### 2) 사용 위치
- `MatchingSearchCoordinator.swift`
- Keychain에서 `sportsCode.{userId}` 값을 읽어 `UserProfileViewModel`에 주입  
  → 상대 프로필 조회 시 동일한 `sportCode`로 요청되도록 보장

---

### 재발 방지
- 종목 변경 시 즉시 반영 필요  
  → `activeProfile` 변경 API **성공 시점에도 Keychain 갱신**
- Keychain 값이 없거나 invalid하면 fallback이 발생할 수 있음  
  → 재진입 시 `MyProfile` 재조회/재저장 흐름으로 **회복 가능**하게 설계

---

### 확인 포인트
- `MyProfile` 응답의 `activeProfile.sportCode`와 **Keychain 저장 값이 일치**하는지 확인
- `UserProfile` 요청에 전달된 `sportCode`가 **일관적으로 유지**되는지 확인




## Troubleshooting: 보낸요청 탭 데이터 미갱신 이슈

### 1. 문제 요약

- **발생 일시:** 2026-01-21 22:30  
- **문제 설명:**  
  경쟁 신청 후 **“바로가기” 버튼**을 통해 `매칭관리 > 보낸요청` 탭으로 이동하면, **방금 새로 보낸 요청이 리스트에 반영되지 않는 현상**이 발생했다.

  기존에는 `viewWillAppear`에서 화면 진입 시 데이터를 새로 받아오도록 되어 있었는데, 이번 흐름은 **같은 화면 흐름 내(나갔다 다시 들어오지 않음)** 에서도 최신 데이터 패칭이 필요했다.

---

### 2. 상세 내용

#### 현상 (재현 방법 포함)
1. `UserProfile` 화면에서 경쟁 신청 완료  
2. **바로가기** 버튼 클릭  
3. `TabBarCoordinator`를 통해 `매칭관리`로 이동 + `보낸요청` 탭 선택  
4. **기대:** 방금 보낸 요청이 `보낸요청` 리스트 최상단에 표시  
5. **실제:** 리스트가 갱신되지 않고 이전 상태 그대로 보임  

---

### 3. 시도 방법

#### 1차 시도: `viewWillAppear`에서만 데이터 패칭 유지
- **방법:** 기존 방식대로 화면 진입 시점에만 갱신되도록 유지  
- **결과:**  
  `매칭관리(보낸요청)` → `검색화면` 이동 → 경쟁 신청 → 다시 돌아오는 흐름에서  
  `viewWillAppear`가 호출되지 않아 최신 데이터 패칭이 되지 않음  
- **결론:** 화면 진입 기반 갱신만으로는 요구사항 충족 불가

---

#### 2차 시도: refresh 이벤트 체인 구축 (Coordinator → VC → VM)
- **방법:**  
  `challengeConfirmed` 이후 `refreshSentRequests` 이벤트를 발행하고,  
  Coordinator/VC를 타고 `SentRequestViewModel.fetchFirstPage()`까지 호출되도록 연결
- **결과:**  
  로그 기준으로 `MatchingSearchCoordinator`에서 `refreshSenReuqestAction()` 함수가 호출되지 않음  

<img width="1264" height="702" alt="Image" src="https://github.com/user-attachments/assets/59ab5754-44f4-498c-8a97-7a9dfc010541" />

- **결론:** 이벤트 체인 자체가 예상한 흐름으로 타지 않아 refresh 트리거가 누락됨

---

#### 3차 시도: `navToManage` 이벤트 흐름에서 `refresh`를 함께 호출
- **방법:**  
  화면 전환을 위해 만든 `navToManage` output을 활용하여,  
  **화면 이동과 데이터 갱신을 동일한 이벤트 흐름에서 보장**하도록 구성

<img width="2180" height="336" alt="Image" src="https://github.com/user-attachments/assets/04ae5ae5-3560-4da5-ab87-0682dd248706" />

<img width="1714" height="424" alt="Image" src="https://github.com/user-attachments/assets/6566efd2-2dc4-4096-b9a7-63e63ef16b1c" />

- **최종 Flow**
  - `UserProfileViewModel.challengeConfirmed`  
    → `navToManage` 이벤트 발행  
    → `TabBarCoordinator.refreshSentRequests()`  
    → `MatchingManageViewController.refreshSentRequests()`  
    → `SentRequestViewController.refresh()`  
    → `SentRequestViewModel.fetchFirstPage()`  


- **결과:**  
  위 flow로 `보낸요청` 탭 진입 시 최신 데이터 패칭이 함께 수행되어 문제 상황을 해결

# 트러블 슈팅 (준범)

## 1. 문제 요약

**발생 일시: 2026-01-20**

**문제 설명: 매칭 결과 작성하고 확인하는 플로우가 있는데, 경우의 수가**

1. 내가 매칭 결과 & 리뷰 작성하고 상대한테 토스 ⇒ 상대가 확인 후 리뷰 작성
2. 내가 매칭 결과 & 리뷰 작성하고 상대한테 토스 ⇒ 상대가 반려 후 내가 다시 받아서 수정 후 상대가 리뷰 작성 후 확정
3. 내가 매칭 결과 & 리뷰 작성하고 상대한테 토스 ⇒ 상대가 반려 후 내가 다시 받아서 수정 후 상대가 다시 반려
4. 상대가 매칭 결과 & 리뷰 작성하고 내가 확인 후 리뷰 작성 ⇒ 상대 리뷰 확인
5. 상대가 매칭 결과 & 리뷰 작성하고 내가 반려 후 상대가 재제출 후 내가 리뷰 작성 ⇒ 상대 리뷰 확인
6. 상대가 매칭 결과 & 리뷰 작성하고 내가 반려 후 상대가 재제출 후 내가 반려

경우의 수(결과 작성 & 확인 플로우 캡쳐)

<img width="1876" height="740" alt="Image" src="https://github.com/user-attachments/assets/e808673a-dedc-415a-b996-f45c7730866a" />

<img width="1864" height="714" alt="Image" src="https://github.com/user-attachments/assets/22633b55-8032-499b-b8ba-15a061eec4fb" />

<img width="1916" height="812" alt="Image" src="https://github.com/user-attachments/assets/9a094f08-37d2-4fc9-a615-4474fbe11bc8" />

<img width="2080" height="850" alt="Image" src="https://github.com/user-attachments/assets/ee940596-d132-400d-bd45-41e9e1e84418" />

<img width="1882" height="804" alt="Image" src="https://github.com/user-attachments/assets/647cc53a-0806-4e2c-abcb-5769429e0a84" />

<img width="1810" height="740" alt="Image" src="https://github.com/user-attachments/assets/5a39a509-3ce0-45d9-8619-3e8111da0d95" />


위와 같이 복잡하고 많은 플로우의 동작이 있어서 분기처리 하느라 고생을 했습니다.

### 2. 상세 내용

> 어떠한 문제가 발생했는지를 구체적으로 작성해주세요. 아래와 같은 형식을 통해서 작성하면 됩니다
> 

**현상:** 

**이번 이슈는 특정 어떤 오류가 발생했다기 보다는 분기처리가 복잡한데 같은 뷰를 재사용해야했고, 그 재사용하는 뷰안에서도 컴포넌트(ex. 버튼, 팝업)가 조금씩 달라져야 하며, 호출되어야 하는 api도 다르고, 같은 api 더라도 바디 파라미터나 리스폰스가 다른 경우가 있어서 어떻게 해야할지 막막하기도 했고, 했는데도 적용이 안되고 해서 어려움을 겪었습니다.**

즉, 복잡한 분기 구조 속에서 화면과 로직이 점점 꼬여가는 문제에 직면했습니다.

핵심적으로 어려웠던 부분은

- 같은 view(결과 작성/확인 화면, 리뷰 작성 화면)를 여러 플로우에서 재사용
- 재사용되는 View 안에서도
    - 버튼 노출 여부
    - 버튼 타이틀
    - 버튼 색상
    - 팝업 문구
    - 호출해야 하는 API
    - API body 파라미터
    - 응답 처리 방식
- 심지어 같은 API 에서도
    - 최초 제출
    - 재제출
    - 확인
    - 반려
    
    에 따라 의미와 흐름이 모두 달라졌습니다.
    
    그 결과 다음과 같은 문제가 반복적으로 발생했습니다
    

- 특정 분기에서 다음 화면으로 넘어가지 않음
- 버튼이 보이지만 터치가 동작하지 않음
- UI는 변경됐지만 API만 호출되고 화면은 그대로 (UI만 변경되고 기능이 오작동)
- 실제 상태와 맞지 않는 잘못된 버튼 / 팝업 노출

예를들어, 결과 작성을 

1. 결과 작성할 때
2. 상대가 작성한 결과를 확인할 때
3. 결과 작성 후 상대가 확인 후 반려했을 때 이전 내가 작성했던 기록을 보여주면서 수정할 수 있게 할 때

이렇게 세가지경우에서 사용하고,

리뷰 작성을

1. 첫 결과 작성 때 결과 입력 후
2. 상대방이 작성한 결과 (반려 X) 확인 후

이렇게 두가지 경우에서 사용을 했습니다.

그렇다보니 리뷰작성이 결과 작성한 데이터를 받아와야 할 때도 있고, 그냥 확인만 하고 리뷰 데이터만 가지고 있어야할 때도 있어서, 같은 화면이라도 진입 시에 상태에 따라 달라졌기 때문에 어려웠습니다. 

**에러 메시지:**

명확한 에러메시지는 없었으나

- 상태가 꼬이는 케이스에서
    - API 호출은 성공
    - 하지만 UI가 갱신되지 않음
    - 이전 상태가 그대로 남아 있는 현상이 반복적으로 발생했습니다.
    

**관련 코드: 문제가 발생한 코드 스니펫 또는 함수**

> 단순히 이 방법으로 해결했습니다! 라고 결론이 안 나오셨을거에요.
해당 문제를 해결하기 위해 시도했던 다양한 방법을 꼼꼼하게 기록해주세요 (도움이 많이 될것입니다)
> 
> 
> ### 4. 시도한 해결 방법
> 

**1차 시도:** 

일단 첫번째로, 맨 처음에 기능과 뷰 역할을 분배할 때 아예 다른 플로우라고 생각을 하여서

1. 매칭 결과 작성, 매칭 리뷰 작성
2. 매칭 결과 확인

이 두개를 각각 다른 사람이 맡기로 했었습니다. 근데 나중에 개발을 하다보니 시간도 서로 부족하고, 막상 두개가 완전 연관이 깊은 화면이라는 것을 알게 되어서 제가 맡게되었습니다.

그래서 애초부터 두개를 함께할 생각으로 코드를 작성했다면, 그리고 좀 더 뷰를 재사용하기 쉽게 만들어두었다면 편했을 것 같습니다.

1차로 시도한 방법은 일단 최대한 공통되는 부분을 컴포넌트로 재사용하는게 좋을 것 같다고 판단했습니다.

결과 작성 & 결과 확인 & 결과 제재출

<img width="486" height="404" alt="Image" src="https://github.com/user-attachments/assets/762579da-8f36-4ad0-a2ee-8a71610b1bee" />

<img width="490" height="396" alt="Image" src="https://github.com/user-attachments/assets/ce00f17f-3ed6-4da5-a5b2-d2716086e5ca" />

후기 작성, 후기 확인

 그래서 위와 같은 컴포넌트들을 재사용할 수 있게 다시 만들었습니다.

**2차 시도: 시도한 해결 방법과 그 결과**

View는 재사용 했지만 로직은 여전히 너무 여기저기 분산되어있었습니다

- 상태 판단을 하는 곳이 총
    - ViewController
    - ViewModel
    - Coordinator
    - View
    - Cell

이렇게 여러군데 흩어져있었고,

조건이 늘어날 수록

- ‘이 조건은 여기서’
- ‘저 조건은 저기서’

처리하게 되다보니 너무 뒤죽박죽 되었던 것 같습니다.

하지만 그래도, 저희가 디자인패턴으로 MVVM + C 에 Combine을 활용한 Input/Output 패턴을 적용을 했는데,

먼저 Input과 Output을 생각해놓고 같은 input에 대해 output을 분기처리 하는 방식으로 가져가니 그나마 좀 수월했던 것 같습니다.

예시로는 

**`case** nextButtonTapped` input에 대하여

**`let** navToReviewCreate = PassthroughSubject<(MatchingConfirmedGameDTO, MatchResultData, String), Never>()` , **`let** navToHome = PassthroughSubject<Void, Never>()` 두개로 분기를 하는 등의 방법을 사용했습니다.

### 5. 원인 분석

> 해결 과정을 통해서 어떤 원인때문에 이 문제가 일어났는지를 정확히 파악하고,
그 문제의 원인을 알게 된 자료들을 첨부해주세요
> 

**원인: 문제의 근본 원인** 

<aside>
💡

일단 문제의 근본 원인은 이렇게 복잡한 플로우를 개발해 볼 일이 없다보니까 너무 무턱대고 시작한 게 문제였던 것 같습니다.

일단 노트같은 걸 펴서 어느 시점에 분기가 일어나야 하고, 어떤 뷰를 어디서 재사용 해야하며, 서버에서 주는 response값을 분기처리에 어떻게 매칭해야할지 설계를 좀 하고 들어갔어야 했다는 후회를 많이 했습니다.

그냥 지금까지 세미나에서도 그렇고 평소에도 일단 뷰 만들고 → api 만들고 → 연동하기!

이렇게만 단순히 생각했었는데 복잡해지면 오히려 점점 꼬일 수 있다는걸 깨달았습니다..

추가로, 서버와 소통을 하는게 중요하다고 생각했습니다.

구조를 다 짜고 보니 로직이 이상해서 다시 처음부터 수정을 한 적도 있고,

명세서에는 업데이트가 안되어있어서 시간을 낭비했던 적도 많았던 것 같습니다.

그래서 개발에 들어가기 전 소통을 충분히 하는게 중요하다고 생각했습니다.

나는 프론트고 너는 백이니까~ 이런 태도는 결국 일을 두번 하게 만드는 것 같습니다

</aside>


### 6. 최종 해결 방법

> 결과적으로 해결한 방법 및 그 과정에서 도움을 받은 자료와 개념들을 첨부해주세요
> 

**해결 방법: 문제를 해결한 방법과 그 과정코드** 

**수정: 수정된 코드** 

```Swift
switch status {
        case .pendingResult:
            writeResultButton.backgroundColor = .Button.backgroundPrimaryActive
            writeResultButton.setTitleColor(.Text.emphasis, for: .normal)
        case .resultRejected:
            if canSubmit {
                writeResultButton.backgroundColor = .Button.backgroundRejected
                writeResultButton.setTitleColor(.Button.textRejected, for: .normal)
            } else {
                writeResultButton.backgroundColor = .Button.backgroundPrimaryDisabled
                writeResultButton.setTitleColor(.Button.textPrimaryDisabled, for: .normal)
            }
        case .waitingConfirmation:
            if canConfirm {
                // 상대방이 제출 → 내가 확인해야 함
                writeResultButton.backgroundColor = .Button.backgroundConfirmed
                writeResultButton.setTitleColor(.Button.backgroundSecondaryActive, for: .normal)
            } else {
                writeResultButton.backgroundColor = .Button.backgroundPrimaryDisabled
                writeResultButton.setTitleColor(.Button.textPrimaryDisabled, for: .normal)
            }
            
        case .canceled:
            writeResultButton.backgroundColor = .Button.backgroundPrimaryDisabled
            writeResultButton.setTitleColor(.Button.textPrimaryDisabled, for: .normal)
        case .resultConfirmed:
            break
```
이런식으로 GameResultState와 제출 가능여부를 비교하여 분기처리를 하였다

# 실패 경험 (승준)

UIKit 환경에서 실시간 알림 시스템을 구축하기 위해 SSE(Server-Sent Events) 구현에 도전했으나, 결과적으로 안정적인 연결 상태를 유지하지 못한 채 프로젝트를 마무리했던 점이 가장 큰 실패로 남습니다. 

실시간성 확보를 위해 연결이 끊길 때마다 1초 단위로 재설정을 시도하는 로직을 설계했지만, 이는 네트워크 자원 소모와 안정성 측면을 간과한 판단 미스였습니다.

결과적으로 10분의 구동 시간 중 실제 연결은 5분에 불과했고, 나머지 5분은 끊김이 반복되는 '가동률 50%'라는 불안정한 수치를 기록했습니다. 

실시간 통신은 단순히 데이터를 받는 것을 넘어, 정교한 예외 처리와 효율적인 세션 유지가 매우 어렵다는 것을 뼈저리게 느끼게 된 경험이었습니다.

# 실패 경험 (진재)

### 상황 정리 (Issue Context)

- **제 상황:**  
  경쟁 신청 후 **“바로가기” 버튼**을 누르면 `매칭관리 > 보낸요청` 탭으로 이동하지만,  
  **방금 새로 보낸 요청이 화면에 반영되지 않는 것처럼 보이는 현상**이 발생했다.

---

### 기대 동작 (Expected Flow)

아래 이벤트 체인을 통해 refresh가 트리거되고, 최종적으로 첫 페이지를 다시 패칭해야 한다.

- `UserProfileViewModel.challengeConfirmed`  
  → `refreshSentRequests`를 UserProfileViewModel에서 추가한 다음 이벤트 발행  
  → `TabBarCoordinator.refreshSentRequests()`  
  → `MatchingManageViewController.refreshSentRequests()`  
  → `SentRequestViewController.refresh()`  
  → `SentRequestViewModel.fetchFirstPage()` 호출

---

### 점검 결과 (What I Verified)

로그 기준으로 아래 지점까지 **정상 호출을 확인**했다.

- `SentRequestViewModel.refresh input received`
- `fetchFirstPage start`

**입력/이벤트 전달 체인은 정상적으로 동작**하고 있는 것처럼 보여서 정확히 어디서 흐름을 놓쳤는지 다시 코드를 되돌려보면서 확인해야겠다  

# 실패 경험 (준범)

## **실패 경험: 컴포지셔널 레이아웃에서 툴팁 팝업 구현 실패**

### **상황 (Situation)**

홈 화면의 섹션 헤더에 **정보(Info) 버튼**이 있었고,

사용자가 해당 버튼을 눌렀을 때 **툴팁 형태의 팝업을 띄워주는 기능**을 구현해야 했다.

해당 화면은 **UICollectionView + Compositional Layout**으로 구성되어 있었고,

헤더 역시 UICollectionReusableView로 관리되고 있었다.

### **문제 (Problem)**

헤더 셀의 인포 버튼을 눌렀을 때 툴팁 뷰를 추가했지만,

툴팁이 **정상적으로 보이지 않거나 일부가 잘리는 현상**이 발생했다.

원인을 살펴보니,

- 컴포지셔널 레이아웃 구조상
    - 헤더 뷰는 컬렉션 뷰의 레이아웃 트리 안에 고정되어 있고
    - 해당 뷰의 bounds를 벗어나는 서브뷰는 **클리핑**되었다
- 즉, 헤더 내부에 툴팁 뷰를 추가하는 방식으로는
    
    **레이아웃 바깥 영역에 떠 있는 팝업 UI를 만들기 어려운 구조**였다
    

### **시도한 해결 방법 (Action)**

1. **헤더 뷰 내부에 툴팁 추가**
    - 인포 버튼 클릭 시, 헤더의 contentView에 툴팁을 subview로 추가
    - 결과: 헤더 영역을 벗어나는 부분이 잘려서 정상 동작하지 않음
2. **zPosition을 높이거나 bringSubviewToFront 시도**
    - 레이어 우선순위를 올려보았으나
    - 레이아웃 클리핑 문제는 해결되지 않음
3. **컬렉션 뷰 위에 직접 띄우는 방식 검토**
    - 버튼 위치를 기준으로 좌표 변환 후
    - 컬렉션 뷰 또는 상위 뷰에 툴팁을 올리는 방식이 필요하다는 점까지는 파악
    - 하지만
        - Compositional Layout의 헤더 좌표 변환
        - 스크롤 시 위치 동기화
        - dim 처리 및 dismissal 로직
            
            를 기한 내에 안정적으로 구현하기엔 이해도가 부족하다고 판단
            

결과적으로 **기한 내 완성하지 못하고 기능 구현을 보류**하게 되었다.

### **결과 (Result)**

- 툴팁 UI 기능은 최종 빌드에 포함되지 못함
- 사용자에게 제공하려던 정보 전달 UX를 완성하지 못한 점이 아쉬움으로 남음
- 하지만 단순 UI 문제가 아니라,
    
    **컴포지셔널 레이아웃 구조에 대한 이해 부족이 원인이었다는 점을 명확히 인식**하게 됨
    

### **배운 점 (Learning)**

이번 실패를 통해 다음과 같은 인사이트를 얻었다.

1. **컴포지셔널 레이아웃은 “뷰 계층 구조”보다 “레이아웃 컨텍스트”가 우선**
    - 셀/헤더 내부에 띄우는 팝업 UI는 구조적으로 한계가 있음
    - 떠 있는 UI(툴팁, 토스트, 팝오버)는
        - *항상 레이아웃 바깥(상위 뷰 or window 레벨)**에서 관리해야 함
2. **기술 선택은 UI 요구사항까지 고려해야 한다**
    - 단순히 “섹션 구조가 깔끔하다”는 이유로 컴포지셔널 레이아웃을 선택했지만
    - 이후 등장할 상호작용(UI overlay, tooltip 등)을 충분히 고려하지 못함
3. **익숙하지 않은 기술일수록 ‘완성 전략’을 먼저 세워야 한다**
    - 구현 도중에 구조적 한계를 발견하면
        - 우회 구현
        - 요구사항 조정
        - 또는 기술 변경
            
            중 하나를 빠르게 선택했어야 했다

