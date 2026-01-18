//  ProfileTestViewController.swift
import UIKit
import Combine

final class ProfileTestViewController: UIViewController {
    
    private let profileService: ProfileUserServiceType = ProfileUserService()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        setupButtons()
    }
    
    private func setupLayout() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func setupButtons() {
        addButton(title: "1. 내 티어 정보 조회 (Tier)", action: #selector(testFetchMyProfileTier))
        addButton(title: "2. 내 전체 프로필 조회 (List)", action: #selector(testFetchMyProfiles))
        addButton(title: "3. 새 프로필 생성 (탁구)", action: #selector(testCreateProfile))
        addButton(title: "4. 활성 프로필 변경", action: #selector(testUpdateActiveProfile))
        addButton(title: "5. 타 유저 프로필 조회", action: #selector(testFetchOtherUserProfile))
        // 6번 버튼 새로 추가
        addButton(title: "6. 내 지역 업데이트", action: #selector(testUpdateRegion))
    }
    
    private func addButton(title: String, action: Selector) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: action, for: .touchUpInside)
        stackView.addArrangedSubview(button)
    }
}

// MARK: - Test Methods
extension ProfileTestViewController {
    
    @objc private func testFetchMyProfileTier() {
        print("🚀 [TEST] 내 티어 정보 조회 시작...")
        profileService.fetchMyProfileTier()
            .sink { [weak self] completion in
                self?.handleCompletion(completion, label: "내 티어 조회")
            } receiveValue: { [weak self] response in
                print("✅ [SUCCESS] 닉네임: \(response.nickname)")
                self?.printProfileDetail(profile: response.activeProfile, nickname: response.nickname)
            }
            .store(in: &cancellables)
    }
    
    @objc private func testFetchMyProfiles() {
        print("🚀 [TEST] 내 전체 프로필 목록 조회 시작...")
        profileService.fetchMyProfiles()
            .sink { [weak self] completion in
                self?.handleCompletion(completion, label: "전체 프로필 조회")
            } receiveValue: { response in
                print("✅ [SUCCESS] 성별: \(response.gender.displayName), 프로필 개수: \(response.allProfiles.count)개")
            }
            .store(in: &cancellables)
    }
    
    @objc private func testCreateProfile() {
        print("🚀 [TEST] 프로필 생성 시작 (탁구, 6개월 미만)...")
        profileService.createProfile(sport: .tableTennis, experience: .lt6Months)
            .sink { [weak self] completion in
                self?.handleCompletion(completion, label: "프로필 생성")
            } receiveValue: { _ in
                print("✅ [SUCCESS] 프로필 생성 성공!")
            }
            .store(in: &cancellables)
    }
    
    @objc private func testUpdateActiveProfile() {
        let dummyProfileId = "0P77FQGQH2RN8"
        print("🚀 [TEST] 활성 프로필 변경 시작 (ID: \(dummyProfileId))...")
        profileService.updateActiveProfile(profileId: dummyProfileId)
            .sink { [weak self] completion in
                self?.handleCompletion(completion, label: "활성 프로필 변경")
            } receiveValue: { _ in
                print("✅ [SUCCESS] 활성 프로필 변경 성공!")
            }
            .store(in: &cancellables)
    }
    
    @objc private func testFetchOtherUserProfile() {
        let dummyUserId = "0KGFXTJE1ECZT"
        print("🚀 [TEST] 타 유저 프로필 조회 시작 (ID: \(dummyUserId), 테니스)...")
        profileService.fetchOtherUserProfile(userId: dummyUserId, sport: .tennis)
            .sink { [weak self] completion in
                self?.handleCompletion(completion, label: "타 유저 프로필 조회")
            } receiveValue: { [weak self] response in
                print("✅ [SUCCESS] 상대방 닉네임: \(response.nickname)")
                self?.printProfileDetail(profile: response.selectedProfile, nickname: response.nickname)
            }
            .store(in: &cancellables)
    }

    // 6. 지역 업데이트 테스트 함수 추가
    @objc private func testUpdateRegion() {
        let testRegion = "서울 특별시 도봉구"
        print("🚀 [TEST] 지역 업데이트 시작 (지역: \(testRegion))...")
        
        profileService.updateRegion(region: testRegion)
            .sink { [weak self] completion in
                self?.handleCompletion(completion, label: "지역 업데이트")
            } receiveValue: { _ in
                print("✅ [SUCCESS] 지역 업데이트 성공!")
            }
            .store(in: &cancellables)
    }
    
    private func handleCompletion(_ completion: Subscribers.Completion<NetworkError>, label: String) {
        switch completion {
        case .finished:
            print("🏁 [FINISHED] \(label) 요청 완료")
        case .failure(let error):
            print("❌ [FAILURE] \(label) 에러 발생: \(error)")
        }
    }
}

private extension ProfileTestViewController {
    
    func printProfileDetail(profile: ActiveProfile, nickname: String) {
        let tierInfo = Tier.from(tierCode: profile.tierCode)
        let sportName = profile.sportCode.displayName
        
        print("""
        -----------------------------------------
        👤 사용자: \(nickname)
        🏀 종목: \(sportName)
        🏆 티어: \(tierInfo?.displayName ?? "정보 없음") (\(tierInfo?.simpleDisplayName ?? ""))
        📊 점수: \(profile.lp) LP (범위: \(profile.minLp) ~ \(profile.maxLp))
        ⚔️ 전적: \(profile.wins)승 \(profile.losses)패 (승률: \(calculateWinRate(wins: profile.wins, losses: profile.losses))%)
        💬 리뷰: \(profile.reviews ?? 0)개
        -----------------------------------------
        """)
    }
    
    func calculateWinRate(wins: Int, losses: Int) -> String {
        let total = wins + losses
        guard total > 0 else { return "0" }
        let winRate = Double(wins) / Double(total) * 100
        return String(format: "%.1f", winRate)
    }
}
