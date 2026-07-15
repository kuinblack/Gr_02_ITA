<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Flashcard Practice"/>
</jsp:include>

<style>
    .page {
        max-width: 600px;
        margin: 40px auto;
        padding: 0 24px;
        text-align: center;
    }

    .progress-text {
        font-weight: 600;
        color: #6b7280;
        margin-bottom: 15px;
        font-size: 16px;
    }

    /* Vùng không gian 3D cho thẻ */
    .flashcard-container {
        perspective: 1000px;
        width: 100%;
        height: 350px;
        margin: 20px auto;
        display: none; /* Ẩn các thẻ chưa học */
    }

    .flashcard-container.active {
        display: block; /* Chỉ hiện thẻ ở vị trí hiện tại */
    }

    .flashcard-inner {
        position: relative;
        width: 100%;
        height: 100%;
        text-align: center;
        transition: transform 0.6s;
        transform-style: preserve-3d;
        cursor: pointer;
    }

    /* Kích hoạt trạng thái xoay lật mặt */
    .flashcard-inner.flipped {
        transform: rotateY(180deg);
    }

    /* Định hình chung cho 2 mặt của tấm thẻ */
    .card-face {
        position: absolute;
        width: 100%;
        height: 100%;
        -webkit-backface-visibility: hidden;
        backface-visibility: hidden;
        border-radius: 24px;
        border: 1px solid #E3E5E0;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        padding: 30px;
        box-sizing: border-box;
    }

    /* Mặt trước */
    .card-front {
        background-color: #fff;
        color: #1C3A27;
        font-size: 26px;
        font-weight: 700;
    }

    /* Mặt sau (Đã lật sẵn 180 độ ở trục Y) */
    .card-back {
        background-color: #fcfdfb;
        color: #333;
        font-size: 20px;
        transform: rotateY(180deg);
    }

    .hint-text {
        font-size: 13px;
        color: #888;
        margin-top: 24px;
        font-weight: 400;
    }

    /* Cụm nút điều hướng */
    .controls-wrapper {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 16px;
        margin-top: 30px;
    }

    .btn {
        padding: 12px 24px;
        border: none;
        border-radius: 12px;
        cursor: pointer;
        background: #1C3A27;
        color: #fff;
        font-weight: 600;
        transition: background 0.2s;
    }

    .btn:hover {
        background: #13271a;
    }

    .btn-secondary {
        background: #e5e7eb;
        color: #374151;
    }

    .btn-secondary:hover {
        background: #d1d5db;
    }

    .nav-bottom {
        margin-top: 40px;
        text-align: left;
    }

    .link {
        text-decoration: none;
        color: #1C3A27;
        font-weight: 600;
    }
</style>

<div class="page">

    <!-- Hiển thị số thứ tự thẻ đang học -->
    <div class="progress-text" id="progressNumber">0 / 0</div>

    <!-- Vòng lặp in toàn bộ thẻ sang cấu trúc lật lướt -->
    <c:forEach items="${cards}" var="card" varStatus="status">
        <div class="flashcard-container" data-index="${status.index}">
            <div class="flashcard-inner" onclick="flipCard(this)">

                <!-- Mặt Trước (Câu hỏi/Thuật ngữ) -->
                <div class="card-face card-front">
                    <div><c:out value="${card.frontContent}"/></div>
                    <div class="hint-text">💡 Bấm vào thẻ để xem đáp án</div>
                </div>

                <!-- Mặt Sau (Giải nghĩa/Đáp án) -->
                <div class="card-face card-back">
                    <div><c:out value="${card.backContent}"/></div>
                    <div class="hint-text">💡 Bấm để lật lại mặt trước</div>
                </div>

            </div>
        </div>
    </c:forEach>

    <!-- Bộ điều khiển lướt câu hỏi -->
    <div class="controls-wrapper">
        <button class="btn btn-secondary" onclick="changeCard(-1)" id="btnPrev">Quay lại</button>
        <button class="btn" onclick="changeCard(1)" id="btnNext">Tiếp theo</button>
    </div>

    <div class="nav-bottom">
        <!-- Quay lại module cũ với đúng courseId để tránh bị lỗi trống tham số -->
        <a class="link" href="${pageContext.request.contextPath}/flashcardview?courseId=${courseId}">
            ← Quay lại danh sách Module
        </a>
    </div>
</div>

<script>
    let currentIndex = 0;
    const cards = document.querySelectorAll('.flashcard-container');
    const totalCards = cards.length;

    function updateCardVisibility() {
        if (totalCards === 0) {
            document.getElementById('progressNumber').innerText = "0 / 0";
            return;
        }

        // Ẩn tất cả và đưa tất cả thẻ quay về mặt trước khi đổi câu
        cards.forEach(card => {
            card.classList.remove('active');
            const inner = card.querySelector('.flashcard-inner');
            if (inner)
                inner.classList.remove('flipped');
        });

        // Hiển thị thẻ hiện tại
        cards[currentIndex].classList.add('active');

        // Cập nhật text tiến trình học
        document.getElementById('progressNumber').innerText = (currentIndex + 1) + " / " + totalCards;

        // Xử lý ẩn nút quay lại nếu đang ở câu đầu tiên
        document.getElementById('btnPrev').style.visibility = (currentIndex === 0) ? 'hidden' : 'visible';

        // Đổi chữ nút Tiếp theo ở câu cuối cùng
        const nextBtn = document.getElementById('btnNext');
        if (currentIndex === totalCards - 1) {
            nextBtn.innerText = "Hoàn thành";
        } else {
            nextBtn.innerText = "Tiếp theo";
        }
    }

    // Hàm lật mặt thẻ khi click
    function flipCard(innerElement) {
        innerElement.classList.toggle('flipped');
    }

    // Hàm xử lý lướt thẻ sang câu khác
    function changeCard(step) {
        let newIndex = currentIndex + step;

        if (newIndex >= 0 && newIndex < totalCards) {
            currentIndex = newIndex;
            updateCardVisibility();
        } else if (newIndex >= totalCards) {
            alert("Chúc mừng! Bạn đã hoàn thành việc ôn tập các thẻ trong module này.");
            window.location.href = "${pageContext.request.contextPath}/flashcardview?courseId=${courseId}";
                    }
                }

                // Chạy kích hoạt hiển thị thẻ đầu tiên khi tải xong cấu trúc DOM
                document.addEventListener("DOMContentLoaded", function () {
                    updateCardVisibility();
                });
</script>

<jsp:include page="/common/footer.jsp"/>