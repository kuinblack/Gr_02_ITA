<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Question Detail - EduNexus</title>
        <!-- Font chữ Plus Jakarta Sans & Playfair Display -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400..900;1,400..900&family=Plus+Jakarta+Sans:wght@300..800&display=swap" rel="stylesheet">

        <style>
            :root {
                --primary-deep: #1C3A27;
                --primary-accent: #2E5A3E;
                --bg-cream: #FAF9F5;
                --white-clean: #FFFFFF;
                --border-color: #E2E4E0;
                --dark-text: #2A2E2B;
                --muted-text: #6E7570;
                --danger-red: #C0392B;
                --danger-bg: #FFF5F5;
                --shadow-sm: 0 2px 8px rgba(28, 58, 39, 0.04);
                --shadow-md: 0 8px 24px rgba(28, 58, 39, 0.06);
            }

            body {
                margin: 0;
                padding: 0;
                background-color: var(--bg-cream);
                font-family: 'Plus Jakarta Sans', sans-serif;
                color: var(--dark-text);
                -webkit-font-smoothing: antialiased;
            }

            .dashboard {
                display: flex;
                min-height: 100vh;
            }

            .main {
                flex: 1;
                padding: 40px;
                max-width: 1000px; /* Bóp nhỏ chiều rộng một chút để điền form cân đối hơn */
                margin: 0 auto;
                box-sizing: border-box;
            }

            /* Header góc trên */
            .topbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 32px;
                padding-bottom: 24px;
                border-bottom: 1px solid var(--border-color);
            }

            .topbar h1 {
                font-family: 'Playfair Display', serif;
                font-size: 32px;
                color: var(--primary-deep);
                margin: 0 0 8px 0;
                font-weight: 700;
            }

            .topbar p {
                color: var(--muted-text);
                font-size: 14px;
                margin: 0;
            }

            .btn-back {
                text-decoration: none;
                font-size: 14px;
                font-weight: 600;
                color: var(--muted-text);
                display: inline-flex;
                align-items: center;
                gap: 6px;
                transition: color 0.2s;
            }

            .btn-back:hover {
                color: var(--primary-deep);
            }

            /* Khối Form lớn (Content Card) */
            .form-card {
                background: var(--white-clean);
                border: 1px solid var(--border-color);
                border-radius: 16px;
                padding: 32px;
                box-shadow: var(--shadow-sm);
            }

            .form-group {
                margin-bottom: 24px;
            }

            .form-group label {
                display: block;
                font-size: 14px;
                font-weight: 700;
                color: var(--primary-deep);
                margin-bottom: 8px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            /* Định dạng các ô nhập liệu Input, Select, Textarea */
            .form-control {
                width: 100%;
                padding: 12px 16px;
                border: 1px solid var(--border-color);
                border-radius: 10px;
                font-family: inherit;
                font-size: 14px;
                color: var(--dark-text);
                background-color: var(--white-clean);
                box-sizing: border-box;
                transition: all 0.2s;
            }

            .form-control:focus {
                outline: none;
                border-color: var(--primary-accent);
                box-shadow: 0 0 0 3px rgba(46, 90, 62, 0.1);
            }

            select.form-control {
                cursor: pointer;
                appearance: none;
                background-image: url("data:image/svg+xml;charset=UTF-8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='%236E7570' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: right 16px center;
                background-size: 16px;
                padding-right: 40px;
            }

            textarea.form-control {
                resize: vertical;
                line-height: 1.6;
            }

            /* Khu vực chứa các nút bấm */
            .actions-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: 32px;
                padding-top: 24px;
                border-top: 1px solid var(--border-color);
            }

            .btn-save {
                background-color: var(--primary-deep);
                color: var(--white-clean);
                border: 1px solid var(--primary-deep);
                padding: 12px 32px;
                border-radius: 10px;
                font-weight: 600;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.2s;
                box-shadow: var(--shadow-sm);
            }

            .btn-save:hover {
                background-color: var(--primary-accent);
                border-color: var(--primary-accent);
                transform: translateY(-1px);
                box-shadow: var(--shadow-md);
            }

            .btn-delete {
                background-color: transparent;
                border: 1px solid rgba(192, 57, 43, 0.2);
                color: var(--danger-red);
                padding: 12px 24px;
                border-radius: 10px;
                font-weight: 600;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.15s ease;
            }

            .btn-delete:hover {
                background-color: var(--danger-bg);
                border-color: var(--danger-red);
                transform: translateY(-1px);
            }
        </style>
    </head>
    <body>

        <div class="dashboard">

            <!-- Đồng bộ sidebar đang chọn mục câu hỏi -->
            <c:set var="active" value="questions"/>
            <jsp:include page="/common/sme_sidebar.jsp"/>

            <main class="main">

                <!-- Tiêu đề và nút quay lại điều hướng -->
                <div class="topbar">
                    <div>
                        <a href="${pageContext.request.contextPath}/questionbank" class="btn-back">
                            ← Back to Question Bank
                        </a>
                        <h2 style="margin: 12px 0 0 0; font-family: 'Playfair Display', serif; font-size: 32px; color: var(--primary-deep);">
                            <c:choose>
                                <c:when test="${not empty question.questionId}">Edit Question #${question.questionId}</c:when>
                                <c:otherwise>Create New Question</c:otherwise>
                            </c:choose>
                        </h2>
                    </div>
                </div>

                <!-- Thẻ chứa cấu trúc Form nhập liệu -->
                <div class="form-card">
                    <form method="post" action="${pageContext.request.contextPath}/questiondetail">

                        <input type="hidden" name="action" value="save">
                        <input type="hidden" name="questionId" value="${question.questionId}">

                        <!-- Module ID -->
                        <div class="form-group">
                            <label for="moduleId">Module ID</label>
                            <input type="number" id="moduleId" name="moduleId" class="form-control"
                                   value="${question.moduleId}" placeholder="Nhập ID của Module chứa câu hỏi này..." required>
                        </div>

                        <!-- Question Type -->
                        <div class="form-group">
                            <label for="questionType">Question Type</label>
                            <select id="questionType" name="questionType" class="form-control" required>
                                <option value="MCQ" ${question.questionType == 'MCQ' ? 'selected' : ''}>MCQ (Multiple Choice)</option>
                                <option value="Essay" ${question.questionType == 'Essay' ? 'selected' : ''}>Essay</option>
                                <option value="TrueFalse" ${question.questionType == 'TrueFalse' ? 'selected' : ''}>True / False</option>
                            </select>
                        </div>

                        <!-- Content -->
                        <div class="form-group">
                            <label for="content">Question Content</label>
                            <textarea id="content" name="content" class="form-control" rows="6" 
                                      placeholder="Nhập nội dung chi tiết câu hỏi tại đây..." required>${question.content}</textarea>
                        </div>

                        <!-- Thanh chứa các nút chức năng Save và Delete sắp xếp gọn gàng -->
                        <div class="actions-bar">
                            <div>
                                <button type="submit" class="btn-save">💾 Save Question</button>
                            </div>
                    </form>

                    <!-- Form Delete độc lập được đặt bên phải của thanh công cụ -->
                    <c:if test="${not empty question.questionId}">
                        <form method="post" action="${pageContext.request.contextPath}/questiondetail"
                              onsubmit="return confirm('Bạn có chắc chắn muốn xóa câu hỏi này khỏi ngân hàng câu hỏi không?')"
                              style="margin: 0;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="questionId" value="${question.questionId}">
                            <button type="submit" class="btn-delete">🗑️ Delete Question</button>
                        </form>
                    </c:if>
                </div>
        </div>

    </main>
</div>

</body>
</html>