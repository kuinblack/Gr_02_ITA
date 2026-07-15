<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AI Question Staging - EduNexus</title>
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
                --accent-orange: #D96B43;
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
                max-width: 1400px;
                margin: 0 auto;
                box-sizing: border-box;
            }

            /* Topbar điều hướng */
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

            /* Grid Layout phân tách vùng làm việc khoa học */
            .workspace-grid {
                display: grid;
                grid-template-columns: 420px 1fr;
                gap: 32px;
                align-items: start;
            }

            @media (max-width: 1024px) {
                .workspace-grid {
                    grid-template-columns: 1fr;
                }
            }

            /* Thẻ Card dùng chung */
            .panel-card {
                background: var(--white-clean);
                border: 1px solid var(--border-color);
                border-radius: 16px;
                padding: 28px;
                box-shadow: var(--shadow-sm);
            }

            .form-group {
                margin-bottom: 24px;
            }

            .form-group label {
                display: block;
                font-size: 13px;
                font-weight: 700;
                color: var(--primary-deep);
                margin-bottom: 8px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            /* Ô nhập liệu */
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

            textarea.form-control {
                resize: vertical;
                line-height: 1.6;
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

            /* Nút bấm */
            .btn-action {
                width: 100%;
                background-color: var(--primary-deep);
                color: var(--white-clean);
                border: 1px solid var(--primary-deep);
                padding: 14px;
                border-radius: 10px;
                font-weight: 600;
                font-size: 14px;
                cursor: pointer;
                display: inline-flex;
                justify-content: center;
                align-items: center;
                gap: 8px;
                transition: all 0.2s;
                box-shadow: var(--shadow-sm);
            }

            .btn-action:hover {
                background-color: var(--primary-accent);
                border-color: var(--primary-accent);
                transform: translateY(-1px);
                box-shadow: var(--shadow-md);
            }

            .btn-approve {
                width: auto;
                padding: 12px 32px;
                background-color: var(--primary-deep);
                color: white;
            }

            /* Khối Banner thông tin AI */
            .ai-badge-banner {
                background: linear-gradient(135deg, rgba(217, 107, 67, 0.06) 0%, rgba(28, 58, 39, 0.03) 100%);
                border: 1px solid rgba(217, 107, 67, 0.2);
                padding: 16px;
                border-radius: 12px;
                margin-bottom: 24px;
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .ai-badge-banner span {
                background: var(--accent-orange);
                color: white;
                font-size: 11px;
                font-weight: 700;
                padding: 4px 8px;
                border-radius: 6px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .ai-badge-banner p {
                margin: 0;
                font-size: 13px;
                color: var(--dark-text);
                line-height: 1.4;
            }

            /* Cấu trúc Table Review cao cấp */
            .review-title {
                font-size: 18px;
                color: var(--primary-deep);
                margin: 0 0 20px 0;
                font-weight: 600;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .table-container {
                border: 1px solid var(--border-color);
                border-radius: 12px;
                overflow: hidden;
                margin-bottom: 24px;
            }

            .table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                text-align: left;
            }

            .table th {
                background-color: var(--bg-cream);
                color: var(--primary-deep);
                font-size: 12px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.75px;
                padding: 14px 20px;
                border-bottom: 1px solid var(--border-color);
            }

            .table td {
                padding: 16px 20px;
                border-bottom: 1px solid var(--border-color);
                background-color: var(--white-clean);
                vertical-align: middle;
            }

            .table tr:last-child td {
                border-bottom: none;
            }

            /* Checkbox Custom */
            .checkbox-wrapper input[type="checkbox"] {
                width: 18px;
                height: 18px;
                accent-color: var(--primary-deep);
                cursor: pointer;
            }

            .table textarea.form-control {
                background-color: var(--bg-cream);
                border-color: var(--border-color);
                font-size: 13.5px;
            }

            .table textarea.form-control:focus {
                background-color: var(--white-clean);
            }
        </style>
    </head>
    <body>

        <div class="dashboard">

            <c:set var="active" value="questions"/>
            <jsp:include page="/common/sme_sidebar.jsp"/>

            <main class="main">

                <div class="topbar">
                    <div>
                        <a href="${pageContext.request.contextPath}/questionbank" class="btn-back">
                            ← Back to Question Bank
                        </a>
                        <h1>✨ AI Question Staging</h1>
                        <p>Không gian xử lý đệm, phân tích bài giảng để khởi tạo câu hỏi trắc nghiệm tự động bằng AI.</p>
                    </div>
                </div>

                <div class="workspace-grid">

                    <div class="panel-card">
                        <div class="ai-badge-banner">
                            <span>GenAI Agent</span>
                            <p>Hệ thống tự động quét từ vựng và thuật ngữ bài học để kết xuất câu hỏi kiểm tra.</p>
                        </div>

                        <form method="post" action="${pageContext.request.contextPath}/aiquestionstaging">
                            <input type="hidden" name="action" value="generate">

                            <div class="form-group">
                                <label for="moduleId">Module ID mục tiêu</label>
                                <input type="number" id="moduleId" name="moduleId" class="form-control" 
                                       value="${moduleId}" placeholder="Nhập ID Module cần chèn câu hỏi..." required>
                            </div>

                            <div class="form-group">
                                <label for="inputText">Nội dung bài học thô (Lesson Content)</label>
                                <textarea id="inputText" name="inputText" class="form-control" rows="12" 
                                          placeholder="Sao chép nội dung bài văn, giáo án rich-text hoặc tài liệu thô vào đây để GenAI tiến hành trích xuất..." required>${inputText}</textarea>
                            </div>

                            <button type="submit" class="btn-action">
                                🚀 Generate Questions with AI
                            </button>
                        </form>
                    </div>

                    <div class="panel-card" style="min-height: 480px;">
                        <c:choose>
                            <c:when test="${not empty stagedQuestions}">
                                <div class="review-title">
                                    <h2>Duyệt danh sách câu hỏi đề xuất</h2>
                                    <span style="font-size: 13px; color: var(--muted-text); font-weight: normal;">
                                        Phát hiện: <strong>${stagedQuestions.size()}</strong> câu hỏi nháp
                                    </span>
                                </div>

                                <form method="post" action="${pageContext.request.contextPath}/aiquestionstaging">
                                    <input type="hidden" name="action" value="approve">
                                    <input type="hidden" name="moduleId" value="${moduleId}">

                                    <div class="table-container">
                                        <table class="table">
                                            <thead>
                                                <tr>
                                                    <th style="width: 60px; text-align: center;">Duyệt</th>
                                                    <th>Nội dung câu hỏi (Có thể sửa)</th>
                                                    <th style="width: 160px;">Loại câu hỏi</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${stagedQuestions}" var="q" varStatus="s">
                                                    <tr>
                                                        <td style="text-align: center;" class="checkbox-wrapper">
                                                            <input type="checkbox" name="selectedQuestion" value="${s.index}" checked>
                                                        </td>

                                                        <td>
                                                            <textarea name="content" class="form-control" rows="3" placeholder="Chỉnh sửa lại câu từ nếu AI sinh chưa mượt mà...">${q.content}</textarea>
                                                        </td>

                                                        <td>
                                                            <select name="questionType" class="form-control">
                                                                <option value="MCQ" ${q.questionType == 'MCQ' ? 'selected' : ''}>MCQ</option>
                                                                <option value="Essay" ${q.questionType == 'Essay' || empty q.questionType ? 'selected' : ''}>Essay</option>
                                                                <option value="TrueFalse" ${q.questionType == 'TrueFalse' ? 'selected' : ''}>True/False</option>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <div style="text-align: right;">
                                        <button type="submit" class="btn-action btn-approve">
                                            ✓ Approve & Save to Bank
                                        </button>
                                    </div>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100%; min-height: 380px; color: var(--muted-text); text-align: center;">
                                    <span style="font-size: 48px; margin-bottom: 16px;">✨</span>
                                    <h3 style="margin: 0 0 8px 0; color: var(--primary-deep); font-size: 16px; font-weight: 600;">Vùng chờ duyệt câu hỏi trống</h3>
                                    <p style="margin: 0; font-size: 13.5px; max-width: 400px; line-height: 1.5;">Hãy điền Module ID và nhập học liệu ở bảng bên trái, sau đó nhấn "Generate" để kích hoạt mô hình AI sinh câu hỏi.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </div>

            </main>
        </div>

    </body>
</html>