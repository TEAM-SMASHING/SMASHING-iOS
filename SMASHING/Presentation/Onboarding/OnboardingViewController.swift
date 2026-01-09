//
//  OnboardingView.swift
//  SMASHING
//
//  Created by 이승준 on 1/7/26.
//

import UIKit

import SnapKit
import Then

enum OnboardingType: Int, CaseIterable {
    case nickname, gender, chat, sports, tier, area
    
    var mainTitle: String {
        switch self {
        case .nickname:
            "사용하실 닉네임을 입력해주세요"
        case .gender:
            "성별을 선택해주세요"
        case .chat:
            "카카오톡 오픈채팅 링크를 입력해주세요"
        case .sports:
            "주 스포츠 1개를 선택해주세요"
        case .tier:
            "배드민턴의 실력을 설정해주세요"
        case .area:
            "활동 지역을 설정해주세요"
        }
    }
    
    var subTitle: String {
        switch self {
        case .nickname:
            "특수문자를 제외한 한글, 영어, 숫자만 가능해요 "
        case .gender:
            "매칭 시 성별을 보여드리기 위함이에요"
        case .chat:
            "매칭 시 상대방에게 공개돼요"
        case .sports:
            "회원가입 이후 스포츠 종목을 더 추가할 수 있어요"
        case .tier:
            "구력을 통해 임시 티어가 결정돼요!"
        case .area:
            "설정한 지역 내에서 라이벌을 찾아드려요"
        }
    }
    
    var background: UIColor {
        switch self {
        case .nickname:
                .systemRed
        case .gender:
                .systemOrange
        case .chat:
                .systemYellow
        case .sports:
                .systemGreen
        case .tier:
                .systemBlue
        case .area:
                .systemPurple
        }
    }
}

class OnboardingViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let containerView = OnboardingContainerView()
    private var currentStep: OnboardingType = .nickname
    
    // private var viewModel: OnboardingViewModel
    
    // MARK: - Life Cycle
    
//    init(viewModel: OnboardingViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func loadView() {
        self.view = containerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .Background.canvas
        setupActions()
        showStep(.nickname)
    }
    
    private func setupActions() {
        containerView.navigationBar.setLeftButton { [weak self] in
            self?.backButtonTapped()
        }
        
        containerView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func nextButtonTapped() {
        let nextIndex = currentStep.rawValue + 1
        if nextIndex < OnboardingType.allCases.count {
            guard let nextStep = OnboardingType(rawValue: nextIndex) else { return }
            currentStep = nextStep
            showStep(currentStep)
        } else {
            finishOnboarding()
        }
    }
    
    private func backButtonTapped() {
        let beforeIndex = currentStep.rawValue - 1
        if beforeIndex > -1 {
            guard let nextStep = OnboardingType(rawValue: beforeIndex) else { return }
            currentStep = nextStep
            showStep(currentStep)
        } else {
            // 로그인 화면으로 pop 혹은 dismiss 처리
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func showStep(_ step: OnboardingType) {
        for child in children {
            child.willMove(toParent: nil)   // 1. 자식에게 제거될 것임을 알림
            child.view.removeFromSuperview() // 2. 뷰 제거
            child.removeFromParent()        // 3. 부모-자식 관계 해제
        }
        
        // 1. UI 상태 업데이트 (View에 직접 접근)
        containerView.mainTitleLabel.text = step.mainTitle
        containerView.subTitleLabel.text = step.subTitle
        
        let totalSteps = Float(OnboardingType.allCases.count)
        let currentProgress = Float(step.rawValue + 1) / totalSteps
        containerView.progressBar.setProgress(currentProgress, animated: true)
        
        // 2. 새로운 Child VC 생성 및 전환
        let nextVC = makeChildViewController(for: step)
        addChild(nextVC)
        containerView.containerView.addSubview(nextVC.view)
        
        nextVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nextVC.didMove(toParent: self)
        
        let buttonTitle = (step == OnboardingType.allCases.last) ? "완료" : "다음"
        containerView.nextButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func makeChildViewController(for step: OnboardingType) -> UIViewController {
        
        let vc = UIViewController()
        
        switch step {
        case .nickname:
            return NicknameViewController()
        case .gender:
            return GenderViewController()
        case .chat:
            return OpenChatCheckViewController()
        case .sports:
            return SportsSelectionViewController()
        default:
            vc.view.backgroundColor = step.background
            return vc
        }
    }
    
    private func finishOnboarding() {
        print("온보딩 프로세스 완료")
    }
}



import Combine

protocol OnboardingViewModelProtocol: AnyObject {
    associatedtype Input
    associatedtype Output
    
    var store: OnboardingObject{get}
    
    func transform(input: AnyPublisher<Input, Never>) -> Output
}

final class OnboardingViewModel: OnboardingViewModelProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    
    var store = OnboardingObject()
    
    enum Input {
        case hitNext // buttonEnabled.send(false) -> 만약 데이터 있으면 : buttonEnabled.send(true)
        case hitBack
        
        case complete
        
        case nicknameTyped(String) // N/10, 중복확인 버튼 활성화
        case checkNicknameDuplication(String) // 이 String이 true면, 저장하기
        
        case genderTapped(Gender) // 저장하기
        case kakaoOpenChatLinkTyped(String) // 버튼 비활성화!! & Debouncing -> 결과에 따라
        case sportsTapped(Sports) // 저장하기
        case tierTapped(Tier) // 저장하기
        case areaTapped // 뷰 띄우기
    }

    struct Output {
        let buttonEnabled = CurrentValueSubject<Bool, Never>(false)
        
        let currentStep = CurrentValueSubject<OnboardingType, Never>(.nickname)
        // 처음 / 진행 / 마지막 나누어서 각각 동작이 달라질 수 있다.
        
        let dismissOnboarding: PassthroughSubject<Void, Never> = .init()
        // 마지막이어서 가입 API 호출
        
        let checkNicknameDuplicationEnabled: PassthroughSubject<Bool, Never> = .init()
        // 1 글자라도 있으면
        
        let nicknameDuplicationResult: PassthroughSubject<Bool, Never> = .init()
        //
        
        let checkKakaoOpenChatLinkEnabled: PassthroughSubject<Bool, Never> = .init()
        // 가능하면 저장하기
        
        let showMapSearchViewController: PassthroughSubject<Void, Never> = .init()
        // Coordinator Pattern 쓰면 되는거 아님?
    }

    let output = Output()
    
    func transform(input: AnyPublisher<Input, Never>) -> Output {

        input
            .compactMap { input -> String? in
                guard case let .kakaoOpenChatLinkTyped(keyword) = input else { return nil }
                return keyword
            }
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] keyword in
                guard let self = self else { return }
                // 카카오 오픈채팅 유효성 검사 API 연동
            }
            .store(in: &cancellables)

        input
            .sink { [weak self] input in
                guard let self = self else { return }
                switch input {
                case .hitNext:
                    // 다음 페이지 개산해서 반환
                    // ViewModel을 주입하고 store를 확인한다.
                    // store의 값으로 뷰를 그린다.
                    // 값이 있으면, buttonEnabled.send(true)
                    // 값이 없으면, buttonEnabled.send(false)
                    return
                case .hitBack:
                    if output.currentStep.value == .nickname {
                        output.dismissOnboarding.send()
                    } else {
                        // 이전 페이지 계산해서 알려주기
                    }
                case .complete:
                    // API 호출
                    // 결과에 따라, switch -> main
                    return
                case .nicknameTyped(let string):
                    // 중복확인 버튼 활성화
                    output.checkNicknameDuplicationEnabled.send(!string.isEmpty)
                case .checkNicknameDuplication(let string):
                    // API 호출
                    return
                case .genderTapped(let gender):
                    store.gender = gender
                    output.buttonEnabled.send(true)
                case .sportsTapped(let sports):
                    store.sports = sports
                    output.buttonEnabled.send(true)
                case .tierTapped(let tier):
                    store.tier = tier
                    output.buttonEnabled.send(true)
                case .areaTapped:
                    return
                default :
                    return
                }
            }
            .store(in: &cancellables)
        return output
    }
}

final class OnboardingObject {
    var nickname: String = ""
    var gender: Gender? = nil
    var kakaoOpenChatLink: String? = nil
    var sports: Sports? = nil
    var tier: Tier? = nil
}

enum Gender: String, Codable {
    case male
    case female

    enum CodingKeys: String, CodingKey {
        case male = "MALE"
        case female = "FEMALE"
    }

    var name: String {
        switch self {
        case .male:
            "남성"
        case .female:
            "여성"
        }
    }

    var imageLg: UIImage {
        switch self {
        case .male:
            .icManLg
        case .female:
            .icWomanLg
        }
    }

    var imageSm: UIImage {
        switch self {
        case .male:
            .icManSm
        case .female:
            .icWomanSm
        }
    }
}

enum Sports: String, Codable {
    case tableTennis = "탁구"
    case tennis = "테니스"
    case badminton = "배드민턴"
    
    enum CodingKeys: String, CodingKey {
        case tableTennis = "TT"
        case tennis = "TN"
        case badminton = "BM"
    }
    
    var image: UIImage {
        switch self {
        case .tableTennis:
            .icPingpong
        case .tennis:
            .icTennis
        case .badminton:
            .icBadminton
        }
    }
}

enum Tier: Codable {
    case iron
    case bronze3
    case bronze2
    case bronze1
    case silver3
    case silver2
    case silver1
    case gold3
    case gold2
    case gold1
    case platinum3
    case platinum2
    case platinum1
    case diamond3
    case diamond2
    case diamond1
    case challenger

    enum CodingKeys: String, CodingKey {
        case iron = "IRON"
        case bronze3 = "BRONZE_3"
        case bronze2 = "BRONZE_2"
        case bronze1 = "BRONZE_1"
        case silver3 = "SILVER_3"
        case silver2 = "SILVER_2"
        case silver1 = "SILVER_1"
        case gold3 = "GOLD_3"
        case gold2 = "GOLD_2"
        case gold1 = "GOLD_1"
        case platinum3 = "PLATINUM_3"
        case platinum2 = "PLATINUM_2"
        case platinum1 = "PLATINUM_1"
        case diamond3 = "DIAMOND_3"
        case diamond2 = "DIAMOND_2"
        case diamond1 = "DIAMOND_1"
        case challenger = "CHALLENGER"
    }
}

extension Tier {
    var order: Int {
        switch self {
        case .iron: return 1
        case .bronze3: return 2
        case .bronze2: return 3
        case .bronze1: return 4
        case .silver3: return 5
        case .silver2: return 6
        case .silver1: return 7
        case .gold3: return 8
        case .gold2: return 9
        case .gold1: return 10
        case .platinum3: return 11
        case .platinum2: return 12
        case .platinum1: return 13
        case .diamond3: return 14
        case .diamond2: return 15
        case .diamond1: return 16
        case .challenger: return 17
        }
    }
}
