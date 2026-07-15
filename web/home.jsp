<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<jsp:include page="/common/header.jsp" />

<style>
    /* Hero Section - Giới thiệu hoành tráng phong cách Premium */
    .welcome-hero {
        text-align: center;
        padding: 80px 20px;
        background: linear-gradient(180deg, rgba(255,255,255,0.8) 0%, rgba(244,243,238,0.4) 100%);
        border-radius: 24px;
        margin-top: 20px;
        margin-bottom: 50px;
        border: 1px solid var(--border-color);
    }
    
    .welcome-hero .tagline {
        font-size: 12px;
        text-transform: uppercase;
        letter-spacing: 2px;
        color: var(--primary-accent);
        font-weight: 700;
        margin-bottom: 16px;
        display: inline-block;
        background: rgba(28, 58, 39, 0.06);
        padding: 6px 16px;
        border-radius: 20px;
    }

    .welcome-hero h1 {
        font-family: 'Playfair Display', serif;
        font-size: 48px;
        color: var(--primary-deep);
        margin: 0 0 20px 0;
        line-height: 1.2;
    }

    .welcome-hero p {
        font-size: 16px;
        color: var(--muted-text);
        max-width: 640px;
        margin: 0 auto 32px;
        line-height: 1.6;
    }

    .cta-group {
        display: flex;
        justify-content: center;
        gap: 16px;
    }

    .btn-primary {
        background-color: var(--primary-deep);
        color: var(--white-clean);
        padding: 14px 32px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 600;
        font-size: 15px;
        box-shadow: 0 4px 14px rgba(28, 58, 39, 0.2);
        transition: all 0.2s;
    }

    .btn-primary:hover {
        background-color: var(--primary-accent);
        transform: translateY(-2px);
    }

    .btn-secondary {
        background-color: transparent;
        color: var(--primary-deep);
        padding: 14px 32px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 600;
        font-size: 15px;
        border: 1px solid var(--primary-deep);
        transition: all 0.2s;
    }

    .btn-secondary:hover {
        background-color: rgba(28, 58, 39, 0.04);
    }

    /* Bố cục lưới hệ thống tính năng */
    .module-showcase {
        margin-bottom: 60px;
    }

    .module-block {
        margin-bottom: 50px;
    }

    .module-header {
        font-family: 'Playfair Display', serif;
        font-size: 24px;
        color: var(--primary-deep);
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 12px;
        border-bottom: 1px solid var(--border-color);
        padding-bottom: 12px;
    }

    .module-header span {
        font-family: 'Plus Jakarta Sans', sans-serif;
        font-size: 12px;
        text-transform: uppercase;
        color: var(--muted-text);
        margin-left: auto;
        letter-spacing: 0.5px;
    }

    .grid-features {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 20px;
    }

    /* Thẻ tính năng ở trạng thái giới thiệu (Public View) */
    .showcase-card {
        background: var(--white-clean);
        border: 1px solid var(--border-color);
        border-radius: 12px;
        padding: 24px;
        position: relative;
        transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        min-height: 140px;
    }

    .showcase-card:hover {
        border-color: #CCD9CE;
        box-shadow: 0 8px 20px rgba(0,0,0,0.03);
    }

    .card-top h3 {
        margin: 0 0 8px 0;
        font-size: 16px;
        font-weight: 600;
        color: var(--dark-text);
    }

    .card-top p {
        margin: 0;
        font-size: 13px;
        color: var(--muted-text);
        line-height: 1.5;
    }

    .card-bottom {
        margin-top: 16px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    /* Badge phân loại đối tượng sử dụng */
    .role-tag {
        font-size: 10px;
        font-weight: 700;
        padding: 3px 8px;
        border-radius: 4px;
        text-transform: uppercase;
        letter-spacing: 0.3px;
    }
    
    .tag-student {
        background-color: #EAF5EE;
        color: #1C5A35;
    }
    
    .tag-sme {
        background-color: #EBF3F5;
        color: #2B5866;
    }

    .tag-common {
        background-color: #F1F2ED;
        color: #494D4A;
    }

    .lock-indicator {
        font-size: 12px;
        color: #A3A8A3;
        display: flex;
        align-items: center;
        gap: 4px;
    }
</style>

<div class="container">
    <!-- Hero Banner Chào Mừng -->
    <div class="welcome-hero">
        <span class="tagline">Hệ thống học tập thế hệ mới thông minh độc lập</span>
        <h1>Khám phá Không gian Tri thức EduNexus</h1>
        <p>Hệ sinh thái tích hợp Trí tuệ nhân tạo (GenAI) đột phá, kết nối toàn diện hoạt động giảng dạy của chuyên gia và lộ trình phát triển tư duy cá nhân của học viên.</p>
        <div class="cta-group">
            <a href="${pageContext.request.contextPath}/login" class="btn-primary">Đăng nhập trải nghiệm</a>
            <a href="#features" class="btn-secondary">Tìm hiểu tính năng</a>
        </div>
    </div>

    <!-- Phân hệ tính năng giới thiệu tổng quan -->
    <div class="portal-grid" id="features">
        
        <!-- 1. PHÂN HỆ CHUNG & CORE -->
        <div class="module-block">
            <div class="module-header">
                🔑 Phân hệ Cốt lõi & Định danh (Core & Identity)
                <span>Chức năng hệ thống</span>
            </div>
            <div class="grid-features">
                <div class="showcase-card">
                    <div class="card-top">
                        <h3>Google Authentication</h3>
                        <p>Đăng nhập bảo mật tức thì qua tài khoản Google dành cho học viên và giảng viên.</p>
                    </div>
                    <div class="card-bottom">
                        <span class="role-tag tag-common">Common</span>
                        <span class="lock-indicator">🔒 Đăng nhập</span>
                    </div>
                </div>
                <div class="showcase-card">
                    <div class="card-top">
                        <h3>Student Dashboard</h3>
                        <p>Trung tâm điều khiển của học viên: Theo dõi danh sách lớp học, các khóa học đã đăng ký.</p>
                    </div>
                    <div class="card-bottom">
                        <span class="role-tag tag-student">Student</span>
                        <span class="lock-indicator">🔒 Đăng nhập</span>
                    </div>
                </div>
                <div class="showcase-card">
                    <div class="card-top">
                        <h3>Personal Progress</h3>
                        <p>Báo cáo trực quan chi tiết về trạng thái học tập, điểm số và tiến trình hoàn thành mục tiêu cá nhân.</p>
                    </div>
                    <div class="card-bottom">
                        <span class="role-tag tag-student">Student</span>
                        <span class="lock-indicator">🔒 Đăng nhập</span>
                    </div>
                </div>
                <div class="showcase-card">
                    <div class="card-top">
                        <h3>Course Matrix</h3>
                        <p>Quản lý toàn diện cấu trúc cây danh mục: Phân chia Module, Lessons, Flashcards và Assignment logic.</p>
                    </div>
                    <div class="card-bottom">
                        <span class="role-tag tag-sme">SME Expert</span>
                        <span class="lock-indicator">🔒 Đăng nhập</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 2. PHÂN HỆ BÀI HỌC (LESSON WORKSPACE) -->
        <div class="module-block">
            <div class="module-header">
                📖 Phân hệ Bài giảng & Học liệu (Lesson Workspace)
                <span>Module: Lesson</span>
            </div>
            <div class="grid-features">
                <div class="showcase-card">
                    <div class="card-top">
                        <h3>Lesson Editor</h3>
                        <p>Trình biên tập tài liệu Rich-text cao cấp kết hợp viết Markdown, nhúng video bài giảng trực quan.</p>
                    </div>
                    <div class="card-bottom">
                        <span class="role-tag tag-sme">SME Expert</span>
                        <span class="lock-indicator">🔒 Đăng nhập</span>
                    </div>
                </div>
                <div class="showcase-card">
                    <div class="card-top">
                        <h3>AI Lesson Staging</h3>
                        <p>Sử dụng trí tuệ nhân tạo tạo bản nháp học liệu thông minh từ ý tưởng thô giúp SME tối ưu thời gian.</p>
                    </div>
                    <div class="card-bottom">
                        <span class="role-tag tag-sme">SME Expert</span>
                        <span class="lock-indicator">🔒 Đăng nhập</span>
                    </div>
                </div>
                <div class="showcase-card">
                    <div class="card-top">
                        <h3>Lesson Text Extract</h3>
                        <p>Trích xuất transcript tự động từ Youtube API, dùng GenAI tóm tắt cô đọng kiến thức trọng tâm.</p>
                    </div>
                    <div class="card-bottom">
                        <span class="role-tag tag-sme">SME Expert</span>
                        <span class="lock-indicator">🔒 Đăng nhập</span>
                    </div>
                </div>
                <div class="showcase-card">
                    <div class="card-top">
                        <h3>Lesson View</h3>
                        <p>Giao diện học tập phẳng, giúp sinh viên tập trung tối đa vào nội dung bài giảng và video.</p>
                    </div>
                    <div class="card-bottom">
                        <span class="role-tag tag-student">Student</span>
                        <span class="lock-indicator">🔒 Đăng nhập</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 3. PHÂN HỆ BÀI TẬP LỚN (ASSIGNMENT & RUBRIC) -->
        <div class="module-block">
            <div class="module-header">
                📤 Phân hệ Khảo thí & Đánh giá (Assignment Workspace)
                <span>Module: Assignment</span>
            </div>
            <div class="grid-features">
                <div class="showcase-card">
                    <div class="card-top">
                        <h3>Assignment Management</h3>
                        <p>Quản lý toàn bộ danh sách, thiết lập kỳ hạn bài tập lớn tập trung theo từng lớp học phụ trách.</p>
                    </div>
                    <div class="card-bottom">
                        <span class="role-tag tag-sme">SME Expert</span>
                        <span class="lock-indicator">🔒 Đăng nhập</span>
                    </div>
                </div>
                <div class="showcase-card">
                    <div class="card-top">
                        <h3>Rubric Configuration</h3>
                        <p>Cấu hình barem điểm (Rubric) chi tiết theo từng tiêu chí khoa học phục vụ chấm điểm tự động.</p>
                    </div>
                    <div class="card-bottom">
                        <span class="role-tag tag-sme">SME Expert</span>
                        <span class="lock-indicator">🔒 Đăng nhập</span>
                    </div>
                </div>
                <div class="showcase-card">
                    <div class="card-top">
                        <h3>Asynchronous AI Submit</h3>
                        <p>Cổng nộp bài tập trực tuyến dành cho sinh viên. Tích hợp AI chấm bài và đánh giá bất đồng bộ.</p>
                    </div>
                    <div class="card-bottom">
                        <span class="role-tag tag-student">Student</span>
                        <span class="lock-indicator">🔒 Đăng nhập</span>
                    </div>
                </div>
                <div class="showcase-card">
                    <div class="card-top">
                        <h3>AI Feedback & Results</h3>
                        <p>Xem điểm số và nhận xét phản hồi chi tiết từ AI theo từng tiêu chí Rubric rõ ràng, công tâm.</p>
                    </div>
                    <div class="card-bottom">
                        <span class="role-tag tag-student">Student</span>
                        <span class="lock-indicator">🔒 Đăng nhập</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 4. PHÂN HỆ THẺ GHI NHỚ (FLASHCARD ENGINE) -->
        <div class="module-block">
            <div class="module-header">
                🧠 Phân hệ Phản xạ Thẻ ghi nhớ (Flashcard Engine)
                <span>Module: Flashcard</span>
            </div>
            <div class="grid-features">
                <div class="showcase-card">
                    <div class="card-top">
                        <h3>Flashcard Editor</h3>
                        <p>Công cụ thiết kế, biên tập thủ công các thuật ngữ cốt lõi đi kèm hình ảnh minh họa sinh động.</p>
                    </div>
                    <div class="card-bottom">
                        <span class="role-tag tag-sme">SME Expert</span>
                        <span class="lock-indicator">🔒 Đăng nhập</span>
                    </div>
                </div>
                <div class="showcase-card">
                    <div class="card-top">
                        <h3>AI Flashcard Staging</h3>
                        <p>Tự động quét nội dung bài học để sinh ra các cặp thẻ ghi nhớ thông minh hoàn toàn bằng AI.</p>
                    </div>
                    <div class="card-bottom">
                        <span class="role-tag tag-sme">SME Expert</span>
                        <span class="lock-indicator">🔒 Đăng nhập</span>
                    </div>
                </div>
                <div class="showcase-card">
                    <div class="card-top">
                        <h3>Flashcard Library</h3>
                        <p>Kho lưu trữ hệ thống các bộ từ vựng, thuật ngữ được sắp xếp khoa học theo bài học.</p>
                    </div>
                    <div class="card-bottom">
                        <span class="role-tag tag-student">Student</span>
                        <span class="lock-indicator">🔒 Đăng nhập</span>
                    </div>
                </div>
                <div class="showcase-card">
                    <div class="card-top">
                        <h3>Active Practice</h3>
                        <p>Chế độ luyện tập tương tác lật thẻ ngẫu nhiên tăng cường khả năng phản xạ và ghi nhớ sâu.</p>
                    </div>
                    <div class="card-bottom">
                        <span class="role-tag tag-student">Student</span>
                        <span class="lock-indicator">🔒 Đăng nhập</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 5. PHÂN HỆ NGÂN HÀNG CÂU HỎI (QUESTION BANK WORKSPACE) -->
        <div class="module-block">
            <div class="module-header">
                🏦 Phân hệ Ngân hàng Đề & Câu hỏi (Question Workspace)
                <span>Module: Question</span>
            </div>
            <div class="grid-features">
                <div class="showcase-card">
                    <div class="card-top">
                        <h3>Question Bank Control</h3>
                        <p>Kho dữ liệu chứa hàng nghìn câu hỏi trắc nghiệm được phân tách nghiêm ngặt theo độ khó.</p>
                    </div>
                    <div class="card-bottom">
                        <span class="role-tag tag-sme">SME Expert</span>
                        <span class="lock-indicator">🔒 Đăng nhập</span>
                    </div>
                </div>
                <div class="showcase-card">
                    <div class="card-top">
                        <h3>AI Question Generation</h3>
                        <p>GenAI phân tích giáo án để đề xuất các bộ câu hỏi trắc nghiệm khách quan đa lựa chọn bám sát thực tế.</p>
                    </div>
                    <div class="card-bottom">
                        <span class="role-tag tag-sme">SME Expert</span>
                        <span class="lock-indicator">🔒 Đăng nhập</span>
                    </div>
                </div>
                <div class="showcase-card">
                    <div class="card-top">
                        <h3>Bulk Question Import</h3>
                        <p>Tính năng nhập liệu hàng loạt câu hỏi chuẩn hóa từ cấu trúc tệp Excel vào hệ thống chỉ trong vài giây.</p>
                    </div>
                    <div class="card-bottom">
                        <span class="role-tag tag-sme">SME Expert</span>
                        <span class="lock-indicator">🔒 Đăng nhập</span>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<jsp:include page="/common/footer.jsp" />