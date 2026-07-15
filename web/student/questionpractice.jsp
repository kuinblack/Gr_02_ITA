<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Question Practice"/>
</jsp:include>

<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<!-- Bootstrap Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>
    :root {
        --primary: #3b82f6;
        --primary-hover: #2563eb;
        --primary-light: #eff6ff;
        --primary-soft: #dbeafe;
        --border: #e2e8f0;
        --border-focus: #cbd5e1;
        --text-dark: #0f172a;
        --text-muted: #64748b;
        --bg: #f8fafc;
        --success: #10b981;
        --success-light: #ecfdf5;
        --success-border: #a7f3d0;
        --danger: #ef4444;
        --danger-light: #fef2f2;
        --danger-border: #fecaca;
        --card-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.05), 0 4px 6px -2px rgba(0, 0, 0, 0.02);
    }

    body {
        background: var(--bg);
        font-family: 'Inter', sans-serif;
        color: var(--text-dark);
        -webkit-font-smoothing: antialiased;
    }

    .main-container {
        max-width: 1200px;
        margin: 40px auto;
        padding: 0 24px;
    }

    .progress-wrapper {
        background: #e2e8f0;
        height: 8px;
        border-radius: 100px;
        overflow: hidden;
        margin-bottom: 30px;
        box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.05);
    }
    .progress-bar-fill {
        background: linear-gradient(90deg, var(--primary), #60a5fa);
        height: 100%;
        width: 0%;
        transition: width 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        border-radius: 100px;
    }

    .practice-layout {
        display: grid;
        grid-template-columns: 1fr 340px;
        gap: 30px;
        align-items: start;
    }

    @media (max-width: 992px) {
        .practice-layout {
            grid-template-columns: 1fr;
        }
    }

    .question-box {
        background: white;
        border-radius: 24px;
        padding: 40px;
        border: 1px solid rgba(226, 232, 240, 0.8);
        box-shadow: var(--card-shadow);
        min-height: 450px;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }

    .question-header {
        border-bottom: 1px solid var(--border);
        padding-bottom: 20px;
        margin-bottom: 30px;
    }

    .question-title {
        font-size: 20px;
        font-weight: 600;
        color: var(--text-dark);
        line-height: 1.6;
        margin-bottom: 25px;
    }

    .option-card {
        display: flex;
        align-items: center;
        padding: 18px 24px;
        margin-bottom: 16px;
        border: 1.5px solid var(--border);
        border-radius: 16px;
        cursor: pointer;
        transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        background: white;
        position: relative;
    }

    .option-card:hover {
        border-color: var(--primary);
        background-color: var(--primary-light);
        transform: translateY(-1px);
    }

    .option-card.selected {
        border-color: var(--primary);
        background-color: var(--primary-light);
        box-shadow: 0 4px 15px rgba(37, 99, 235, 0.06);
    }

    .option-card input[type="radio"] {
        display: none;
    }

    .option-badge {
        width: 36px;
        height: 36px;
        border-radius: 10px;
        background: #f1f5f9;
        color: var(--text-muted);
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 700;
        margin-right: 18px;
        flex-shrink: 0;
        transition: all 0.2s;
        border: 1px solid rgba(0, 0, 0, 0.03);
    }

    .option-card:hover .option-badge {
        background: var(--primary-soft);
        color: var(--primary-hover);
    }

    .option-card.selected .option-badge {
        background: var(--primary);
        color: white;
        border-color: var(--primary);
    }

    .option-text {
        font-size: 15px;
        font-weight: 500;
        color: var(--text-dark);
        line-height: 1.5;
    }

    .tf-container {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
        margin-top: 15px;
    }

    .tf-card {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 30px;
        border: 1.5px solid var(--border);
        border-radius: 20px;
        cursor: pointer;
        transition: all 0.25s ease;
        background: white;
    }

    .tf-card input[type="radio"] {
        display: none;
    }

    .tf-true-choice:hover {
        border-color: var(--success);
        background-color: var(--success-light);
        transform: translateY(-2px);
    }

    .tf-false-choice:hover {
        border-color: var(--danger);
        background-color: var(--danger-light);
        transform: translateY(-2px);
    }

    .tf-card.selected.tf-true-choice {
        border-color: var(--success);
        background-color: var(--success-light);
        box-shadow: 0 8px 20px rgba(16, 185, 129, 0.12);
    }

    .tf-card.selected.tf-false-choice {
        border-color: var(--danger);
        background-color: var(--danger-light);
        box-shadow: 0 8px 20px rgba(239, 68, 68, 0.12);
    }

    .tf-icon {
        font-size: 36px;
        margin-bottom: 12px;
        color: var(--text-muted);
        transition: color 0.2s, transform 0.2s;
    }

    .tf-card:hover .tf-icon {
        transform: scale(1.1);
    }

    .tf-true-choice:hover .tf-icon,
    .tf-true-choice.selected .tf-icon {
        color: var(--success);
    }

    .tf-false-choice:hover .tf-icon,
    .tf-false-choice.selected .tf-icon {
        color: var(--danger);
    }

    .tf-text {
        font-weight: 700;
        font-size: 16px;
        letter-spacing: 0.5px;
    }

    .essay-textarea {
        border: 1.5px solid var(--border);
        border-radius: 16px;
        padding: 22px;
        font-size: 15px;
        line-height: 1.6;
        resize: none;
        transition: all 0.2s;
        background: #fafafa;
    }

    .essay-textarea:focus {
        background: white;
        border-color: var(--primary);
        box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.15);
        outline: none;
    }

    .sidebar-card {
        background: white;
        border-radius: 24px;
        border: 1px solid rgba(226, 232, 240, 0.8);
        padding: 30px;
        box-shadow: var(--card-shadow);
        position: sticky;
        top: 30px;
    }

    .grid-nav {
        display: grid;
        grid-template-columns: repeat(5, 1fr);
        gap: 12px;
        margin-top: 20px;
    }

    .btn-nav-num {
        width: 100%;
        aspect-ratio: 1;
        border: 1.5px solid var(--border);
        background: white;
        color: var(--text-muted);
        border-radius: 12px;
        font-weight: 700;
        font-size: 14px;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .btn-nav-num:hover {
        border-color: var(--primary);
        color: var(--primary);
        background: var(--primary-light);
    }

    .btn-nav-num.active {
        background: var(--primary);
        color: white !important;
        border-color: var(--primary);
        box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
    }

    .btn-nav-num.answered {
        background: var(--primary-light);
        border-color: var(--primary-soft);
        color: var(--primary);
    }
    
    .btn-nav-num.answered.active {
        background: var(--primary);
        color: white !important;
        border-color: var(--primary);
    }

    .score-banner {
        background: linear-gradient(135deg, #059669, #10b981);
        color: white;
        border-radius: 20px;
        padding: 30px;
        text-align: center;
        margin-bottom: 30px;
        box-shadow: 0 10px 25px -5px rgba(16, 185, 129, 0.2);
    }

    .btn-custom-action {
        font-weight: 600;
        border-radius: 12px;
        padding: 12px 24px;
        transition: all 0.2s;
    }
</style>

<!-- LOGIC TÌM INDEX CỦA CÂU HỎI ĐƯỢC CHỌN TỪ TRANG NGOÀI -->
<c:set var="startIndex" value="0" />
<c:if test="${not empty param.questionId}">
    <c:forEach items="${questionList}" var="q" varStatus="s">
        <c:if test="${q.questionId == param.questionId}">
            <c:set var="startIndex" value="${s.index}" />
        </c:if>
    </c:forEach>
</c:if>

<div class="main-container">

    <div class="d-flex justify-content-between align-items-center mb-5">
        <div>
            <span class="text-uppercase tracking-wider fs-12 fw-bold text-primary" style="letter-spacing: 1.5px;">Practice Workspace</span>
            <h2 class="fw-extrabold text-dark m-0 mt-1" style="letter-spacing: -0.5px;">Module Practice</h2>
        </div>
        <a href="${pageContext.request.contextPath}/studentquestionlist?moduleId=${moduleId}" class="btn btn-light border px-4 py-2 rounded-3 shadow-sm text-secondary fw-semibold">
            <i class="bi bi-box-arrow-left me-2"></i> Exit Practice
        </a>
    </div>

    <c:if test="${submitted}">
        <div class="score-banner">
            <h1 class="fw-extrabold m-0" style="font-size: 32px;">Your Score: ${score} / ${total}</h1>
            <p class="m-0 mt-2 opacity-90 fw-medium">Great effort! Click the question numbers below to review your answers.</p>
        </div>
    </c:if>

    <!-- Progress Bar -->
    <div class="progress-wrapper">
        <div class="progress-bar-fill" id="progressBar"></div>
    </div>

    <!-- EXAM FORM -->
    <form method="post" id="examForm">
        <input type="hidden" name="moduleId" value="${moduleId}">

        <div class="practice-layout">

            <!-- Left Side -->
            <div class="workspace-area">
                <c:forEach items="${questionList}" var="q" varStatus="s">
                    <!-- Đã thay đổi hiển thị theo 'startIndex' thay vì mặc định chỉ hiển thị câu index = 0 -->
                    <div class="question-box" id="questionBox-${s.index}" style="display: ${s.index == startIndex ? 'flex' : 'none'};">

                        <div>
                            <div class="question-header d-flex justify-content-between align-items-center">
                                <span class="badge bg-light text-primary border border-primary-soft px-3 py-2 rounded-pill fw-semibold">
                                    Question ${s.index + 1} of ${questionList.size()}
                                </span>
                                <span class="text-muted fw-bold small tracking-wider" style="font-size: 11px;">
                                    <c:choose>
                                        <c:when test="${q.questionType == 'MCQ'}">MULTIPLE CHOICE</c:when>
                                        <c:when test="${q.questionType == 'TrueFalse'}">TRUE / FALSE</c:when>
                                        <c:otherwise>ESSAY WRITING</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <p class="question-title">${q.content}</p>

                            <div class="mt-4">
                                <c:choose>

                                    <%-- MCQ --%>
                                    <c:when test="${q.questionType == 'MCQ'}">
                                        <div class="options-group">
                                            <c:forEach items="${q.options}" var="o">
                                                <label class="option-card" onclick="selectOption(this, ${s.index})">
                                                    <input type="radio" 
                                                           name="q${q.questionId}" 
                                                           value="${o.optionId}"
                                                           <c:if test="${param['q'.concat(q.questionId)] == o.optionId}">checked</c:if>>
                                                    <span class="option-badge">${o.optionLabel}</span>
                                                    <span class="option-text">${o.optionContent}</span>
                                                </label>
                                            </c:forEach>
                                        </div>
                                    </c:when>

                                    <%-- TRUE / FALSE --%>
                                    <c:when test="${q.questionType == 'TrueFalse'}">
                                        <div class="tf-container">
                                            <c:forEach items="${q.options}" var="o">
                                                <c:set var="isTrue" value="${o.optionContent == 'True'}" />
                                                <label class="tf-card ${isTrue ? 'tf-true-choice' : 'tf-false-choice'}" onclick="selectOption(this, ${s.index})">
                                                    <input type="radio" 
                                                           name="q${q.questionId}" 
                                                           value="${o.optionId}"
                                                           <c:if test="${param['q'.concat(q.questionId)] == o.optionId}">checked</c:if>>
                                                    <i class="bi ${isTrue ? 'bi-check-circle-fill' : 'bi-x-circle-fill'} tf-icon"></i>
                                                    <span class="tf-text" style="color: ${isTrue ? 'var(--success)' : 'var(--danger)'};">
                                                        ${o.optionContent.toUpperCase()}
                                                    </span>
                                                </label>
                                            </c:forEach>
                                        </div>
                                    </c:when>

                                    <%-- ESSAY --%>
                                    <c:otherwise>
                                        <textarea name="q${q.questionId}" 
                                                  class="form-control essay-textarea" 
                                                  rows="7" 
                                                  placeholder="Type your analytical response here..."
                                                  oninput="updateTextState(this, ${s.index})">${param['q'.concat(q.questionId)]}</textarea>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Card Action Buttons -->
                        <div class="d-flex justify-content-between align-items-center mt-5 pt-4 border-top">
                            <button type="button" class="btn btn-outline-secondary btn-custom-action px-4" onclick="prevQuestion()" id="btnPrev">
                                <i class="bi bi-chevron-left me-2"></i> Previous
                            </button>
                            <button type="button" class="btn btn-primary btn-custom-action px-4" onclick="nextQuestion()" id="btnNext">
                                Next <i class="bi bi-chevron-right ms-2"></i>
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Right Side: Sidebar Navigation Grid -->
            <div class="navigation-sidebar">
                <div class="sidebar-card">
                    <h5 class="fw-bold text-dark mb-1" style="letter-spacing: -0.3px;">Navigation Board</h5>
                    <p class="text-muted small mb-4">Select any number to jump directly to that question.</p>

                    <div class="grid-nav" id="gridNav">
                        <c:forEach items="${questionList}" var="q" varStatus="s">
                            <!-- Nút điều hướng của câu đang hiển thị sẽ nhận class 'active' -->
                            <button type="button" 
                                    class="btn-nav-num ${s.index == startIndex ? 'active' : ''}" 
                                    id="navNum-${s.index}"
                                    onclick="jumpToQuestion(${s.index})">
                                ${s.index + 1}
                            </button>
                        </c:forEach>
                    </div>

                    <div class="mt-4 pt-4 border-top">
                        <button type="submit" class="btn btn-success w-100 py-3 fw-bold rounded-3 shadow-sm border-0" style="background: var(--success); transition: background-color 0.2s;">
                            <i class="bi bi-send-fill me-2"></i> Submit Practice
                        </button>
                    </div>
                </div>
            </div>

        </div>
    </form>
</div>

<jsp:include page="/common/footer.jsp"/>

<script>
    // Đã thay đổi khởi tạo từ 0 sang index động nhận từ JSTL
    let currentIdx = ${startIndex};
    const totalQuestions = ${questionList.size()};

    document.addEventListener("DOMContentLoaded", function () {
        syncSelectedClasses();
        updateProgressBar();
        updateNavigationButtons();
    });

    // Handle Option Selection (MCQ / TF)
    function selectOption(element, qIdx) {
        const container = element.parentElement;
        container.querySelectorAll('.option-card, .tf-card').forEach(card => {
            card.classList.remove('selected');
        });

        element.classList.add('selected');

        const navBtn = document.getElementById(`navNum-${qIdx}`);
        if (navBtn) {
            navBtn.classList.add('answered');
        }

        updateProgressBar();
    }

    // Handle Text Input (Essay)
    function updateTextState(textarea, qIdx) {
        const navBtn = document.getElementById(`navNum-${qIdx}`);
        if (navBtn) {
            if (textarea.value.trim().length > 0) {
                navBtn.classList.add('answered');
            } else {
                navBtn.classList.remove('answered');
            }
        }
        updateProgressBar();
    }

    // Jump to question index
    function jumpToQuestion(idx) {
        if (idx < 0 || idx >= totalQuestions)
            return;

        const currentBox = document.getElementById(`questionBox-${currentIdx}`);
        const currentNav = document.getElementById(`navNum-${currentIdx}`);
        if (currentBox)
            currentBox.style.display = 'none';
        if (currentNav)
            currentNav.classList.remove('active');

        currentIdx = idx;

        const nextBox = document.getElementById(`questionBox-${currentIdx}`);
        const nextNav = document.getElementById(`navNum-${currentIdx}`);
        if (nextBox)
            nextBox.style.display = 'flex';
        if (nextNav)
            nextNav.classList.add('active');

        updateNavigationButtons();
    }

    function prevQuestion() {
        if (currentIdx > 0)
            jumpToQuestion(currentIdx - 1);
    }

    function nextQuestion() {
        if (currentIdx < totalQuestions - 1)
            jumpToQuestion(currentIdx + 1);
    }

    // Update bottom Action Buttons
    function updateNavigationButtons() {
        const prevBtn = document.getElementById('btnPrev');
        const nextBtn = document.getElementById('btnNext');

        if (!prevBtn || !nextBtn)
            return;

        // Previous button state
        if (currentIdx === 0) {
            prevBtn.disabled = true;
            prevBtn.classList.add('opacity-50');
        } else {
            prevBtn.disabled = false;
            prevBtn.classList.remove('opacity-50');
        }

        // Next / Submit button state
        if (currentIdx === totalQuestions - 1) {
            nextBtn.innerHTML = `Submit Practice <i class="bi bi-send-fill ms-2" style="font-size: 14px;"></i>`;
            nextBtn.classList.replace('btn-primary', 'btn-success');
            nextBtn.style.backgroundColor = 'var(--success)';
            nextBtn.onclick = function () {
                document.getElementById('examForm').submit();
            };
        } else {
            nextBtn.innerHTML = `Next <i class="bi bi-chevron-right ms-2"></i>`;
            nextBtn.classList.replace('btn-success', 'btn-primary');
            nextBtn.style.backgroundColor = '';
            nextBtn.onclick = nextQuestion;
        }
    }

    // Update progress bar percentage
    function updateProgressBar() {
        const totalAnswered = document.querySelectorAll('.grid-nav .btn-nav-num.answered').length;
        const percent = totalQuestions > 0 ? (totalAnswered / totalQuestions) * 100 : 0;
        const progressBar = document.getElementById('progressBar');
        if (progressBar) {
            progressBar.style.width = percent + '%';
        }
    }

    // Sync UI elements on load
    function syncSelectedClasses() {
        document.querySelectorAll('input[type="radio"]:checked').forEach(radio => {
            const parentLabel = radio.closest('.option-card, .tf-card');
            if (parentLabel) {
                parentLabel.classList.add('selected');
            }
        });

        for (let i = 0; i < totalQuestions; i++) {
            const box = document.getElementById(`questionBox-${i}`);
            if (box) {
                const radioChecked = box.querySelector('input[type="radio"]:checked');
                const textVal = box.querySelector('textarea');

                if (radioChecked || (textVal && textVal.value.trim().length > 0)) {
                    const navBtn = document.getElementById(`navNum-${i}`);
                    if (navBtn)
                        navBtn.classList.add('answered');
                }
            }
        }
    }
</script>