<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Import Questions - EduNexus</title>
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
                max-width: 1000px;
                margin: 0 auto;
                box-sizing: border-box;
            }

            /* Header điều hướng */
            .topbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 32px;
                padding-bottom: 24px;
                border-bottom: 1px solid var(--border-color);
            }

            .topbar h2 {
                font-family: 'Playfair Display', serif;
                font-size: 32px;
                color: var(--primary-deep);
                margin: 12px 0 0 0;
                font-weight: 700;
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

            /* Khối nội dung Form (Content Card) */
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

            /* Định dạng Input & Textarea */
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

            /* Khối thông báo hướng dẫn */
            .info-note {
                background-color: rgba(217, 107, 67, 0.05);
                border: 1px dashed rgba(217, 107, 67, 0.3);
                border-radius: 10px;
                padding: 14px 18px;
                margin-bottom: 24px;
                color: var(--dark-text);
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .info-note strong {
                color: var(--accent-orange);
            }

            /* Nút hành động */
            .actions-bar {
                display: flex;
                justify-content: flex-start;
                margin-top: 24px;
                padding-top: 24px;
                border-top: 1px solid var(--border-color);
            }

            .btn-import {
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
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .btn-import:hover {
                background-color: var(--primary-accent);
                border-color: var(--primary-accent);
                transform: translateY(-1px);
                box-shadow: var(--shadow-md);
            }
        </style>
    </head>
    <body>

        <div class="dashboard">

            <!-- Đồng bộ sidebar đang chọn mục câu hỏi -->
            <c:set var="active" value="questions"/>
            <jsp:include page="/common/sme_sidebar.jsp"/>

            <main class="main">

                <!-- Tiêu đề & Điều hướng quay lại -->
                <div class="topbar">
                    <div>
                        <a href="${pageContext.request.contextPath}/questionbank" class="btn-back">
                            ← Back to Question Bank
                        </a>
                        <h2>📥 Import Questions Hàng Loạt</h2>
                    </div>
                </div>

                <!-- Thẻ Form chính -->
                <div class="form-card">

                    <!-- Khối ghi chú định dạng nhập liệu -->
                    <div class="info-note">
                        💡 <span>Mỗi dòng nội dung văn bản được nhập phía dưới sẽ được hệ thống tự động khởi tạo thành một câu hỏi loại <strong>MCQ</strong> riêng biệt.</span>
                    </div>

                    <form method="post" action="${pageContext.request.contextPath}/questionimport">

                        <!-- Module ID -->
                        <div class="form-group">
                            <label for="moduleId">Module ID</label>
                            <input type="number" id="moduleId" name="moduleId" class="form-control" 
                                   placeholder="Nhập ID của Module áp dụng..." required>
                        </div>

                        <!-- Bulk Content (Một câu hỏi mỗi dòng) -->
                        <div class="form-group">
                            <label for="bulkContent">Questions (One per line)</label>
                            <textarea id="bulkContent" name="bulkContent" class="form-control" rows="12"
                                      placeholder="Nội dung câu hỏi thứ nhất&#10;Nội dung câu hỏi thứ hai&#10;Nội dung câu hỏi thứ ba" required></textarea>
                        </div>

                        <!-- Thanh nút chức năng xử lý lệnh gửi dữ liệu -->
                        <div class="actions-bar">
                            <button type="submit" class="btn-import">📥 Tiến hành Import</button>
                        </div>

                    </form>
                </div>

            </main>
        </div>

    </body>
</html>