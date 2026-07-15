<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Google Fonts: Đảm bảo đã nhúng font chữ hiện đại -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;1,600&display=swap" rel="stylesheet">

<style>
    :root {
        --footer-bg: #0B1911;
        --footer-bg-gradient: linear-gradient(180deg, #10251A 0%, #08120C 100%);
        --text-primary: #FFFFFF;
        --text-muted: #A3B8AC;
        --accent-color: #81D8D0;
        --border-color: rgba(255, 255, 255, 0.07);
        --transition-smooth: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .site-footer {
        background: var(--footer-bg);
        background: var(--footer-bg-gradient);
        color: var(--text-muted);
        margin-top: 100px;
        font-family: 'Plus Jakarta Sans', sans-serif;
        position: relative;
        overflow: hidden;
    }

    /* Điểm nhấn vòng tròn mờ nhẹ ở góc nền tạo hiệu ứng chiều sâu */
    .site-footer::before {
        content: '';
        position: absolute;
        top: -150px;
        right: -150px;
        width: 400px;
        height: 400px;
        border-radius: 50%;
        background: radial-gradient(circle, rgba(129,216,208,0.03) 0%, rgba(0,0,0,0) 70%);
        pointer-events: none;
    }

    .footer-container {
        max-width: 1300px;
        margin: 0 auto;
        padding: 0 24px;
    }

    .footer-top {
        padding: 80px 0 50px;
    }

    .footer-grid {
        display: grid;
        grid-template-columns: 1.8fr 1fr 1fr 1.2fr;
        gap: 50px;
    }

    .footer-brand {
        padding-right: 20px;
    }

    .footer-brand h3 {
        font-family: 'Playfair Display', serif;
        font-size: 36px;
        font-weight: 700;
        margin: 0 0 18px 0;
        color: var(--text-primary);
        letter-spacing: -0.5px;
    }

    .footer-brand h3 span {
        color: var(--accent-color);
    }

    .footer-brand p {
        color: var(--text-muted);
        line-height: 1.8;
        font-size: 14px;
        margin: 0;
    }

    .footer-title {
        color: var(--text-primary);
        font-size: 13px;
        font-weight: 800;
        margin-bottom: 24px;
        text-transform: uppercase;
        letter-spacing: 1.5px;
        position: relative;
    }

    /* Thanh gạch chân nhỏ dưới tiêu đề danh mục */
    .footer-title::after {
        content: '';
        position: absolute;
        bottom: -6px;
        left: 0;
        width: 24px;
        height: 2px;
        background-color: var(--accent-color);
        border-radius: 2px;
    }

    .footer-links {
        list-style: none;
        margin: 0;
        padding: 0;
    }

    .footer-links li {
        margin-bottom: 14px;
    }

    .footer-links a {
        color: var(--text-muted);
        text-decoration: none;
        font-size: 14px;
        font-weight: 500;
        display: inline-flex;
        align-items: center;
        position: relative;
        transition: var(--transition-smooth);
    }

    /* Hiệu ứng hover dịch chuyển chữ và đổi màu */
    .footer-links a:hover {
        color: var(--accent-color);
        transform: translateX(6px);
    }

    .footer-contact {
        display: flex;
        flex-direction: column;
        gap: 16px;
    }

    .contact-item {
        display: flex;
        align-items: flex-start;
        gap: 12px;
        font-size: 14px;
        line-height: 1.5;
    }

    .contact-item svg {
        width: 18px;
        height: 18px;
        fill: none;
        stroke: var(--accent-color);
        stroke-width: 2;
        stroke-linecap: round;
        stroke-linejoin: round;
        flex-shrink: 0;
        margin-top: 2px;
        transition: var(--transition-smooth);
    }

    .contact-item:hover svg {
        transform: scale(1.15);
    }

    .footer-bottom-wrapper {
        border-top: 1px solid var(--border-color);
        background: rgba(0, 0, 0, 0.15);
    }

    .footer-bottom {
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 20px;
        padding: 26px 0;
        font-size: 13px;
        color: #7E9588;
    }

    .footer-bottom-links {
        display: flex;
        gap: 24px;
    }

    .footer-bottom a {
        color: #7E9588;
        text-decoration: none;
        transition: var(--transition-smooth);
        position: relative;
    }

    .footer-bottom a:hover {
        color: var(--text-primary);
    }

    /* ================= Responsive Breakpoints ================= */
    @media(max-width: 1024px) {
        .footer-grid {
            grid-template-columns: 1.2fr 1fr 1fr;
            gap: 40px;
        }
        .footer-brand {
            grid-column: span 3;
            padding-right: 0;
            margin-bottom: 20px;
        }
    }

    @media(max-width: 768px) {
        .footer-top {
            padding: 60px 0 40px;
        }
        .footer-grid {
            grid-template-columns: 1fr 1fr;
            gap: 35px;
        }
        .footer-brand {
            grid-column: span 2;
        }
    }

    @media(max-width: 550px) {
        .footer-grid {
            grid-template-columns: 1fr;
            gap: 30px;
        }
        .footer-brand {
            grid-column: span 1;
        }
        .footer-bottom {
            flex-direction: column-reverse;
            text-align: center;
            padding: 30px 0;
        }
        .footer-bottom-links {
            justify-content: center;
            gap: 16px;
        }
    }
</style>

<footer class="site-footer">

    <div class="footer-container footer-top">
        <div class="footer-grid">

            <!-- Cột thương hiệu -->
            <div class="footer-brand">
                <h3>EduNexus<span>.</span></h3>
                <p>
                    An AI-powered Learning Management System crafted to enrich the academic matrix. 
                    Empowering students through tailored dynamic analytics, unified assignment control, 
                    and highly interactive modular core structures.
                </p>
            </div>

            <!-- Cột Học tập (Student) -->
            <div>
                <div class="footer-title">Learning</div>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/studentdashboard">Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/courseview">My Courses</a></li>
                    <li><a href="${pageContext.request.contextPath}/assignmentlibrary">Assignments</a></li>
                    <li><a href="${pageContext.request.contextPath}/personalprogress">Learning Progress</a></li>
                </ul>
            </div>

            <!-- Cột Hỗ trợ -->
            <div>
                <div class="footer-title">Support</div>
                <ul class="footer-links">
                    <li><a href="#">Help Center</a></li>
                    <li><a href="#">User Guide</a></li>
                    <li><a href="#">FAQs</a></li>
                    <li><a href="#">Contact Support</a></li>
                </ul>
            </div>

            <!-- Cột Liên hệ với Icon SVG -->
            <div>
                <div class="footer-title">Contact Us</div>
                <div class="footer-contact">
                    <div class="contact-item">
                        <svg viewBox="0 0 24 24"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg>
                        <span>support@edunexus.edu</span>
                    </div>
                    <div class="contact-item">
                        <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><line x1="2" y1="12" x2="22" y2="12"></line><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"></path></svg>
                        <span>www.edunexus.edu</span>
                    </div>
                    <div class="contact-item">
                        <svg viewBox="0 0 24 24"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                        <span>High-Tech Zone, Hoa Lac,<br>FPT University, Hanoi</span>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- Thanh bản quyền chân trang -->
    <div class="footer-bottom-wrapper">
        <div class="footer-container footer-bottom">
            <div>
                &copy; 2026 EduNexus LMS Platform. Engineered for excellence.
            </div>
            <div class="footer-bottom-links">
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
                <a href="#">Help Center</a>
            </div>
        </div>
    </div>

</footer>

</body>
</html>