<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Nộp Bài Tập: ${assignment.title}</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <style>
            :root {
                --primary: #1C3A27;
                --primary-hover: #264D35;
                --background: #f8fafc;
                --surface: #ffffff;
                --text-main: #0f172a;
                --text-muted: #64748b;
                --border: #e2e8f0;
                --success: #10b981;
                --warning: #f59e0b;
                --danger: #ef4444;
                --info-bg: #eff6ff;
                --info-border: #bfdbfe;
                --info-text: #1e40af;
            }

            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
                font-family: 'Inter', sans-serif;
            }

            body {
                background-color: var(--background);
                color: var(--text-main);
                line-height: 1.5;
                padding: 40px 20px;
            }

            .container {
                max-width: 800px;
                margin: 0 auto;
            }

            .card {
                background: var(--surface);
                border: 1px solid var(--border);
                border-radius: 12px;
                padding: 32px;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
                margin-bottom: 24px;
            }

            h2 {
                font-size: 24px;
                font-weight: 700;
                margin-bottom: 8px;
                color: var(--primary);
            }

            .assignment-meta {
                color: var(--text-muted);
                font-size: 14px;
                margin-bottom: 24px;
                display: flex;
                gap: 16px;
                flex-wrap: wrap;
            }

            .meta-item {
                display: flex;
                align-items: center;
                gap: 6px;
            }

            .description-box {
                background: #fafafa;
                border-left: 4px solid var(--primary);
                padding: 16px;
                border-radius: 0 8px 8px 0;
                margin-bottom: 24px;
                font-size: 15px;
            }

            /* Thống báo trạng thái */
            .toast-box {
                padding: 14px 16px;
                border-radius: 8px;
                font-weight: 500;
                margin-bottom: 24px;
                font-size: 14px;
            }

            .toast-success {
                background-color: #ecfdf5;
                border: 1px solid #a7f3d0;
                color: #065f46;
            }

            .toast-danger {
                background-color: #fef2f2;
                border: 1px solid #fca5a5;
                color: #991b1b;
            }

            .status-banner {
                padding: 14px 16px;
                border-radius: 8px;
                font-weight: 500;
                margin-bottom: 24px;
                font-size: 14px;
            }

            .status-overdue {
                background-color: #fef2f2;
                border: 1px solid #fca5a5;
                color: #991b1b;
            }

            .status-waiting {
                background-color: var(--info-bg);
                border: 1px solid var(--info-border);
                color: var(--info-text);
            }

            /* Form */
            .form-group {
                margin-bottom: 20px;
            }

            label {
                display: block;
                font-weight: 600;
                margin-bottom: 8px;
                font-size: 14px;
            }

            textarea {
                width: 100%;
                min-height: 140px;
                padding: 12px;
                border: 1px solid var(--border);
                border-radius: 8px;
                font-size: 15px;
                resize: vertical;
                outline: none;
                transition: border-color 0.2s;
            }

            textarea:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(28, 58, 39, 0.1);
            }

            input[type="file"] {
                display: block;
                width: 100%;
                padding: 10px;
                border: 1px dashed var(--border);
                border-radius: 8px;
                background: #fafafa;
                cursor: pointer;
            }

            .btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                padding: 10px 20px;
                font-size: 15px;
                font-weight: 500;
                border-radius: 8px;
                border: none;
                cursor: pointer;
                transition: all 0.2s;
                text-decoration: none;
            }

            .btn-primary {
                background: var(--primary);
                color: white;
            }

            .btn-primary:hover {
                background: var(--primary-hover);
            }

            .btn-secondary {
                background: transparent;
                border: 1px solid var(--border);
                color: var(--text-main);
                margin-right: 12px;
            }

            .btn-secondary:hover {
                background: #f1f5f9;
            }

            .btn:disabled {
                background: #cbd5e0;
                color: #718096;
                cursor: not-allowed;
            }

            .file-info {
                background: #f1f5f9;
                padding: 10px 14px;
                border-radius: 6px;
                font-size: 14px;
                margin-top: 8px;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .file-link {
                color: #3182ce;
                font-weight: 600;
                text-decoration: none;
            }

            .file-link:hover {
                text-decoration: underline;
            }

            /* CSS hiệu ứng quay tròn khi bấm nộp bài */
            .spinner {
                display: inline-block;
                width: 16px;
                height: 16px;
                border: 2px solid rgba(255, 255, 255, 0.3);
                border-radius: 50%;
                border-top-color: white;
                animation: spin 0.8s linear infinite;
                margin-right: 8px;
                vertical-align: middle;
            }
            @keyframes spin {
                to { transform: rotate(360deg); }
            }
        </style>
    </head>
    <body>

        <!-- NHÚNG HEADER HỆ THỐNG -->
        <jsp:include page="/common/header.jsp" />

        <div class="container">
            <div class="card">

                <!-- HIỂN THỊ THÔNG BÁO TOAST TRÊN ĐẦU TRANG NẾU CÓ -->
                <c:if test="${not empty sessionScope.toastMessage}">
                    <div class="toast-box toast-success">
                        🎉 ${sessionScope.toastMessage}
                    </div>
                    <c:remove var="toastMessage" scope="session" />
                </c:if>
                <c:if test="${not empty sessionScope.toastError}">
                    <div class="toast-box toast-danger">
                        ✕ ${sessionScope.toastError}
                    </div>
                    <c:remove var="toastError" scope="session" />
                </c:if>

                <h2>${assignment.title}</h2>

                <div class="assignment-meta">
                    <div class="meta-item">
                        📅 Hạn nộp: <fmt:formatDate value="${assignment.deadline}" pattern="dd/MM/yyyy HH:mm"/>
                    </div>
                    <div class="meta-item">
                        💯 Điểm tối đa: ${assignment.totalScore}
                    </div>
                </div>

                <div class="description-box">
                    <strong>Yêu cầu bài tập:</strong><br>
                    <c:out value="${assignment.description}"/>
                </div>

                <!-- HIỂN THỊ BANNER TRẠNG THÁI NỘP BÀI -->
                <c:choose>
                    <c:when test="${isOverdue}">
                        <div class="status-banner status-overdue">
                            ✕ Hệ thống đã khóa: Hạn nộp bài tập này đã kết thúc!
                        </div>
                    </c:when>
                    <c:when test="${not empty submission}">
                        <div class="status-banner status-waiting">
                            ⏳ Trạng thái: Bạn đã nộp bài tập này. Bạn vẫn có thể cập nhật bài làm mới trước khi hết hạn.
                        </div>
                    </c:when>
                </c:choose>

                <!-- FORM GỬI DỮ LIỆU ĐẾN SERVLET -->
                <form action="${pageContext.request.contextPath}/assignmentsubmit" 
                      method="POST" 
                      enctype="multipart/form-data" 
                      onsubmit="handleSubmit(this)">
                    
                    <input type="hidden" name="assignmentId" value="${assignment.assignmentId}">

                    <div class="form-group">
                        <label for="comments">Nội dung / Ghi chú bài nộp</label>
                        <textarea id="comments" name="comments" placeholder="Nhập câu trả lời bằng văn bản hoặc ghi chú gửi đến giảng viên..." ${isOverdue ? 'disabled' : ''}><c:out value="${submission.comments}"/></textarea>
                    </div>

                    <div class="form-group">
                        <label for="file">Tệp tin đính kèm</label>
                        <input type="file" id="file" name="file" ${isOverdue ? 'disabled' : ''}>

                        <c:if test="${not empty submission.fileUrl}">
                            <div class="file-info">
                                <span>📂 Bài làm hiện tại: 
                                    <a class="file-link" href="${pageContext.request.contextPath}/${submission.fileUrl}" target="_blank">
                                        Xem tài liệu đã nộp
                                    </a>
                                </span>
                                <c:if test="${!isOverdue}">
                                    <small style="color: var(--text-muted);">(Tải lên tệp mới sẽ thay thế tệp cũ này)</small>
                                </c:if>
                            </div>
                        </c:if>
                    </div>

                    <div style="margin-top: 32px; display: flex; justify-content: flex-end; align-items: center;">
                        <!-- Đã điều hướng chính xác về assignmentlibrary -->
                        <a href="${pageContext.request.contextPath}/assignmentlibrary" class="btn btn-secondary">Quay lại thư viện</a>
                        
                        <button type="submit" id="submitBtn" class="btn btn-primary" ${isOverdue ? 'disabled' : ''}>
                            ${not empty submission ? 'Cập nhật bài làm' : 'Nộp bài tập'}
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- NHÚNG FOOTER HỆ THỐNG -->
        <jsp:include page="/common/footer.jsp" />

        <script>
            function handleSubmit(form) {
                const submitBtn = document.getElementById('submitBtn');
                if (submitBtn) {
                    // Tránh click nhiều lần khi đang upload các file dung lượng lớn
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<span class="spinner"></span> Đang tải bài làm lên...';
                }
            }
        </script>
    </body>
</html>