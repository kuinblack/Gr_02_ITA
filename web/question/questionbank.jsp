<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Question Bank - EduNexus</title>
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

            /* Topbar đồng bộ */
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

            /* Nhóm nút công cụ phía trên */
            .btn-group {
                display: flex;
                gap: 12px;
                align-items: center;
            }

            .btn-open {
                text-decoration: none;
                padding: 12px 20px;
                border-radius: 10px;
                font-weight: 600;
                font-size: 14px;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
                border: 1px solid var(--border-color);
                background-color: var(--white-clean);
                color: var(--dark-text);
                box-shadow: var(--shadow-sm);
            }

            .btn-open:hover {
                border-color: var(--primary-deep);
                color: var(--primary-deep);
                transform: translateY(-1px);
                box-shadow: var(--shadow-md);
            }

            .btn-primary-custom {
                background-color: var(--primary-deep);
                color: var(--white-clean);
                border-color: var(--primary-deep);
            }

            .btn-primary-custom:hover {
                background-color: var(--primary-accent);
                color: var(--white-clean);
                border-color: var(--primary-accent);
            }

            /* Bộ lọc & Tìm kiếm câu hỏi */
            .filter-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 16px;
                margin-bottom: 20px;
                flex-wrap: wrap;
            }

            .search-box {
                position: relative;
                flex: 1;
                max-width: 400px;
            }

            .search-box input {
                width: 100%;
                padding: 11px 16px 11px 40px;
                border-radius: 10px;
                border: 1px solid var(--border-color);
                background-color: var(--white-clean);
                font-family: inherit;
                font-size: 14px;
                box-sizing: border-box;
                transition: all 0.2s;
            }

            .search-box input:focus {
                outline: none;
                border-color: var(--primary-accent);
                box-shadow: 0 0 0 3px rgba(46, 90, 62, 0.1);
            }

            .search-box::before {
                content: "🔍";
                position: absolute;
                left: 14px;
                top: 50%;
                transform: translateY(-50%);
                font-size: 14px;
                opacity: 0.6;
            }

            .select-custom {
                padding: 10px 16px;
                border-radius: 10px;
                border: 1px solid var(--border-color);
                background-color: var(--white-clean);
                font-family: inherit;
                font-size: 13px;
                font-weight: 600;
                color: var(--dark-text);
                cursor: pointer;
                outline: none;
                transition: all 0.2s;
            }

            .select-custom:focus {
                border-color: var(--primary-accent);
            }

            /* Khối nội dung bảng */
            .content-card {
                background: var(--white-clean);
                border: 1px solid var(--border-color);
                border-radius: 16px;
                padding: 8px;
                box-shadow: var(--shadow-sm);
                overflow-x: auto;
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
                padding: 16px 24px;
                border-bottom: 1px solid var(--border-color);
            }

            .table th:first-child {
                border-top-left-radius: 10px;
                border-bottom-left-radius: 10px;
            }
            .table th:last-child {
                border-top-right-radius: 10px;
                border-bottom-right-radius: 10px;
            }

            .table td {
                padding: 18px 24px;
                border-bottom: 1px solid var(--border-color);
                font-size: 14px;
                color: var(--dark-text);
                vertical-align: middle;
            }

            .table tr:last-child td {
                border-bottom: none;
            }
            .table tr {
                transition: background-color 0.2s;
            }
            .table tr:hover td {
                background-color: rgba(250, 249, 245, 0.8);
            }

            /* Định dạng cột */
            .id-badge {
                font-family: monospace;
                background-color: var(--bg-cream);
                color: var(--primary-accent);
                padding: 4px 8px;
                border-radius: 6px;
                font-weight: 600;
                font-size: 13px;
                border: 1px solid var(--border-color);
            }

            .question-content {
                font-size: 14px;
                line-height: 1.6;
                color: var(--dark-text);
                word-break: break-word;
            }

            .type-tag {
                display: inline-block;
                background-color: rgba(217, 107, 67, 0.06);
                color: var(--accent-orange);
                padding: 6px 12px;
                border-radius: 8px;
                font-size: 12px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                border: 1px solid rgba(217, 107, 67, 0.1);
            }

            .btn-action-edit {
                text-decoration: none;
                font-size: 13px;
                font-weight: 600;
                padding: 8px 14px;
                border-radius: 8px;
                transition: all 0.15s ease;
                border: 1px solid rgba(46, 90, 62, 0.2);
                background-color: var(--white-clean);
                color: var(--primary-accent);
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }

            .btn-action-edit:hover {
                background-color: var(--primary-deep);
                color: var(--white-clean);
                border-color: var(--primary-deep);
                transform: translateY(-1px);
            }
        </style>
    </head>
    <body>

        <div class="dashboard">

            <!-- Cài đặt tab active cho ngân hàng câu hỏi (Ví dụ: questions) -->
            <c:set var="active" value="questions"/>
            <jsp:include page="/common/sme_sidebar.jsp"/>

            <main class="main">

                <!-- Thanh công cụ phía trên -->
                <div class="topbar">
                    <div>
                        <h1>📚 Question Bank</h1>
                        <p>Quản trị kho lưu trữ câu hỏi hệ thống, phân loại định dạng và đồng bộ hóa dữ liệu AI.</p>
                    </div>

                    <div class="btn-group">
                        <a href="${pageContext.request.contextPath}/questiondetail" class="btn-open btn-primary-custom">
                            <span>+</span> New Question
                        </a>

                        <a href="${pageContext.request.contextPath}/questionimport" class="btn-open">
                            📥 Import Questions
                        </a>

                        <a href="${pageContext.request.contextPath}/aiquestionstaging" class="btn-open">
                            ✨ AI Staging
                        </a>
                    </div>
                </div>

                <!-- Thanh tìm kiếm và bộ lọc nhanh -->
                <div class="filter-bar">
                    <div class="search-box">
                        <input type="text" id="questionSearch" onkeyup="filterQuestions()" placeholder="Tìm kiếm nội dung câu hỏi...">
                    </div>
                    <div>
                        <select class="select-custom" id="typeFilter" onchange="filterQuestions()">
                            <option value="">Tất cả loại câu hỏi</option>
                            <option value="Multiple Choice">Multiple Choice</option>
                            <option value="Essay">Essay</option>
                        </select>
                    </div>
                </div>

                <!-- Bảng danh sách câu hỏi -->
                <div class="content-card">
                    <table class="table" id="questionTable">
                        <thead>
                            <tr>
                                <th style="width: 100px;">ID</th>
                                <th>Content</th>
                                <th style="width: 180px;">Type</th>
                                <th style="width: 120px; text-align: right;">Action</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach items="${questionList}" var="q">
                                <tr>
                                    <!-- Cột ID -->
                                    <td>
                                        <span class="id-badge">#${q.questionId}</span>
                                    </td>

                                    <!-- Cột Nội dung câu hỏi -->
                                    <td>
                                        <div class="question-content">${q.content}</div>
                                    </td>

                                    <!-- Cột Loại câu hỏi -->
                                    <td>
                                        <span class="type-tag">${q.questionType}</span>
                                    </td>

                                    <!-- Cột Hành động -->
                                    <td>
                                        <div style="display: flex; justify-content: flex-end;">
                                            <a class="btn-action-edit" href="${pageContext.request.contextPath}/questiondetail?id=${q.questionId}">
                                                ✏️ Edit
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty questionList}">
                                <tr>
                                    <td colspan="4" style="text-align: center; color: var(--muted-text); padding: 48px; font-style: italic;">
                                        Hiện tại chưa có câu hỏi nào trong ngân hàng dữ liệu.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

            </main>
        </div>

        <!-- Script tìm kiếm và lọc dữ liệu client-side -->
        <script>
            function filterQuestions() {
                const searchInput = document.getElementById("questionSearch").value.toLowerCase();
                const typeFilter = document.getElementById("typeFilter").value.toLowerCase();
                const table = document.getElementById("questionTable");
                const tr = table.getElementsByTagName("tr");

                for (let i = 1; i < tr.length; i++) {
                    const row = tr[i];
                    const contentTd = row.getElementsByTagName("td")[1];
                    const typeTag = row.querySelector(".type-tag");

                    if (!contentTd || !typeTag)
                        continue;

                    const contentText = contentTd.textContent.toLowerCase();
                    const typeText = typeTag.textContent.toLowerCase();

                    const matchesSearch = contentText.includes(searchInput);
                    const matchesType = typeFilter === "" || typeText.includes(typeFilter);

                    if (matchesSearch && matchesType) {
                        row.style.display = "";
                    } else {
                        row.style.display = "none";
                    }
                }
            }
        </script>
    </body>
</html>