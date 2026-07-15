<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Kết Quả Bài Tập: ${assignment.title}</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
                --success-bg: #f0fdf4;
                --warning: #f59e0b;
                --warning-bg: #fffbeb;
                --info-bg: #eff6ff;
                --info-border: #bfdbfe;
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

            .header-title {
                font-size: 24px;
                font-weight: 700;
                color: var(--primary);
                margin-bottom: 8px;
            }

            .assignment-meta {
                color: var(--text-muted);
                font-size: 14px;
                margin-bottom: 24px;
                display: flex;
                gap: 16px;
            }

            .result-section {
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 24px;
                border: 1px solid var(--border);
            }

            .result-graded {
                background-color: var(--success-bg);
                border-color: #bbf7d0;
            }

            .result-waiting {
                background-color: var(--warning-bg);
                border-color: #fef3c7;
            }

            .score-display {
                font-size: 36px;
                font-weight: 800;
                color: #047857;
                margin-top: 8px;
            }

            .submission-details {
                margin-top: 24px;
                padding-top: 20px;
                border-top: 1px dashed var(--border);
            }

            .detail-item {
                margin-bottom: 16px;
            }

            .detail-label {
                font-weight: 600;
                font-size: 14px;
                color: var(--text-muted);
                margin-bottom: 4px;
            }

            .detail-content {
                font-size: 15px;
                background: #fafafa;
                padding: 12px;
                border-radius: 6px;
                border: 1px solid #f1f5f9;
            }

            .btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                padding: 10px 20px;
                font-size: 15px;
                font-weight: 500;
                border-radius: 8px;
                border: 1px solid var(--border);
                cursor: pointer;
                transition: all 0.2s;
                text-decoration: none;
                color: var(--text-main);
                background: var(--surface);
            }

            .btn:hover {
                background: #f1f5f9;
            }

            .file-link {
                color: #2563eb;
                text-decoration: none;
                font-weight: 600;
            }

            .file-link:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>

        <jsp:include page="/common/header.jsp" />

        <div class="container">
            <div class="card">
                <h2 class="header-title">${assignment.title}</h2>
                <div class="assignment-meta">
                    <span>💯 Điểm tối đa: ${assignment.totalScore}</span>
                    <span>📅 Hạn nộp: <fmt:formatDate value="${assignment.deadline}" pattern="dd/MM/yyyy HH:mm"/></span>
                </div>

                <c:choose>
                    <%-- TRƯỜNG HỢP 1: CHƯA CÓ BÀI NỘP --%>
                    <c:when test="${empty submission}">
                        <div class="result-section result-waiting">
                            <h3>⚠️ Chưa tìm thấy bài nộp</h3>
                            <p style="margin-top: 8px; color: #92400e;">Bạn chưa tiến hành nộp câu trả lời cho bài tập này trên hệ thống.</p>
                        </div>
                    </c:when>

                    <%-- TRƯỜNG HỢP 2: ĐÃ NỘP VÀ ĐÃ ĐƯỢC CHẤM ĐIỂM (Result tồn tại trong Database) --%>
                    <c:when test="${not empty result}">
                        <div class="result-section result-graded">
                            <h3>🎉 Kết quả đánh giá</h3>
                            <div class="score-display">
                                ${result.score} <span style="font-size: 18px; font-weight: 500; color: var(--text-muted);">/ ${assignment.totalScore}</span>
                            </div>

                            <div style="margin-top: 16px;">
                                <strong>Nhận xét từ giảng viên:</strong>
                                <p style="margin-top: 4px; color: #1f2937; font-style: italic;">
                                    <c:choose>
                                        <c:when test="${not empty result.feedback}">
                                            <c:out value="${result.feedback}"/>
                                        </c:when>
                                        <c:otherwise>Giảng viên không để lại nhận xét thêm.</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                    </c:when>

                    <%-- TRƯỜNG HỢP 3: ĐÃ NỘP NHƯNG CHƯA ĐƯỢC CHẤM ĐIỂM (Chưa có bản ghi Result) --%>
                    <c:otherwise>
                        <div class="result-section result-waiting">
                            <h3>⏳ Đang chờ chấm điểm</h3>
                            <p style="margin-top: 8px; color: #92400e;">Hệ thống đã ghi nhận bài làm của bạn. Vui lòng đợi giảng viên chấm điểm và phản hồi sau.</p>
                        </div>
                    </c:otherwise>
                </c:choose>

                <%-- CHI TIẾT BÀI LÀM ĐÃ GỬI (NẾU CÓ) --%>
                <c:if test="${not empty submission}">
                    <div class="submission-details">
                        <h3 style="margin-bottom: 16px; font-size: 18px;">Chi tiết bài làm đã nộp</h3>

                        <div class="detail-item">
                            <div class="detail-label">Thời gian nộp bài:</div>
                            <div>
                                <fmt:formatDate value="${submission.submittedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                            </div>
                        </div>

                        <div class="detail-item">
                            <div class="detail-label">Nội dung bài làm của bạn:</div>
                            <div class="detail-content">
                                <c:choose>
                                    <c:when test="${not empty submission.content}">
                                        <c:out value="${submission.content}"/>
                                    </c:when>
                                    <c:otherwise><span style="color: var(--text-muted)">Không có nội dung văn bản đính kèm.</span></c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <c:if test="${not empty submission.fileUrl}">
                            <div class="detail-item">
                                <div class="detail-label">Tài liệu đã đính kèm:</div>
                                <div class="detail-content" style="background: #eff6ff; border-color: #dbeafe;">
                                    <i class="fa-solid fa-file-pdf" style="color: #ef4444; margin-right: 6px;"></i>
                                    <a class="file-link" href="${pageContext.request.contextPath}/${submission.fileUrl}" target="_blank">
                                        Tải xuống / Xem bài làm
                                    </a>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </c:if>

                <div style="margin-top: 32px; display: flex; justify-content: flex-end;">
                    <a href="${pageContext.request.contextPath}/assignmentlibrary" class="btn">
                        <i class="fa-solid fa-arrow-left" style="margin-right: 8px;"></i> Quay lại danh sách
                    </a>
                </div>
            </div>
        </div>

        <jsp:include page="/common/footer.jsp" />

    </body>
</html>