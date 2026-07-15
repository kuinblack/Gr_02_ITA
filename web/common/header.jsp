<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>${empty param.title ? 'EduNexus' : param.title}</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">

        <style>
            :root{
                --primary:#1C3A27;
                --primary-hover:#264D35;
                --accent:#81D8D0;
                --bg:#F4F3EE;
                --white:#FFFFFF;
                --text:#1F2937;
                --muted:#6B7280;
                --border:#E5E7EB;
            }

            *{
                box-sizing:border-box;
            }

            body{
                margin:0;
                font-family:'Plus Jakarta Sans',sans-serif;
                background:var(--bg);
                color:var(--text);
            }

            .container{
                max-width:1280px;
                margin:0 auto;
                padding:0 24px;
            }

            .navbar{
                position:sticky;
                top:0;
                z-index:1000;
                background:rgba(255,255,255,.92);
                backdrop-filter:blur(14px);
                border-bottom:1px solid var(--border);
            }

            .navbar-inner{
                height:78px;
                display:flex;
                align-items:center;
                justify-content:space-between;
                gap:24px;
            }

            .logo{
                text-decoration:none;
                font-family:'Playfair Display',serif;
                font-size:30px;
                color:var(--primary);
                font-weight:700;
                white-space:nowrap;
            }

            .logo span{
                color:var(--accent);
            }

            .nav-menu{
                display:flex;
                align-items:center;
                gap:6px;
                list-style:none;
                margin:0;
                padding:0;
            }

            .nav-menu a{
                text-decoration:none;
                color:var(--text);
                padding:10px 16px;
                border-radius:12px;
                font-size:14px;
                font-weight:700;
                transition:.2s;
            }

            .nav-menu a:hover{
                background:#EEF3EF;
                color:var(--primary);
            }

            .search-box{
                flex:1;
                max-width:380px;
                position:relative;
            }

            .search-box input{
                width:100%;
                padding:12px 16px 12px 42px;
                border-radius:14px;
                border:1px solid var(--border);
                background:#fff;
                outline:none;
                font-size:14px;
            }

            .search-icon{
                position:absolute;
                left:14px;
                top:50%;
                transform:translateY(-50%);
                color:#9CA3AF;
            }

            .nav-right{
                display:flex;
                align-items:center;
                gap:16px;
            }

            .notification{
                width:42px;
                height:42px;
                border-radius:12px;
                background:#fff;
                border:1px solid var(--border);
                display:flex;
                align-items:center;
                justify-content:center;
            }

            .user{
                display:flex;
                align-items:center;
                gap:12px;
            }

            .avatar{
                width:44px;
                height:44px;
                border-radius:50%;
                background:var(--primary);
                color:#fff;
                display:flex;
                align-items:center;
                justify-content:center;
                font-weight:800;
            }

            .user-info{
                display:flex;
                flex-direction:column;
                line-height:1.2;
            }

            .user-info b{
                font-size:14px;
            }

            .role-badge{
                display:inline-flex;
                align-items:center;
                width:max-content;
                margin-top:4px;
                padding:3px 10px;
                border-radius:999px;
                background:#E8F5EE;
                color:#166534;
                font-size:11px;
                font-weight:800;
            }

            .logout-btn{
                text-decoration:none;
                color:#DC2626;
                font-weight:700;
                font-size:13px;
                padding:10px 14px;
                border-radius:10px;
            }

            .logout-btn:hover{
                background:#FEF2F2;
            }

            .guest-actions{
                display:flex;
                align-items:center;
                gap:12px;
            }

            .btn-outline{
                text-decoration:none;
                color:var(--primary);
                border:1px solid var(--border);
                padding:10px 16px;
                border-radius:12px;
                font-weight:700;
                background:#fff;
            }

            .btn-primary{
                text-decoration:none;
                background:var(--primary);
                color:#fff;
                padding:10px 18px;
                border-radius:12px;
                font-weight:700;
            }

            @media(max-width:1100px){
                .search-box{
                    display:none;
                }
            }

            @media(max-width:992px){
                .nav-menu{
                    display:none;
                }
            }
        </style>
    </head>
    <body>

        <nav class="navbar">
            <div class="container navbar-inner">

                <a class="logo" href="${pageContext.request.contextPath}/home.jsp">
                    EduNexus<span>.</span>
                </a>

                <c:if test="${not empty sessionScope.account}">

                    <ul class="nav-menu">

                        <!-- STUDENT -->
                        <c:if test="${sessionScope.account.roleId == 3}">
                            <li><a href="${pageContext.request.contextPath}/studentdashboard">Dashboard</a></li>
                            <li><a href="${pageContext.request.contextPath}/courseview">Courses</a></li>
                            </c:if>

                        <!-- SME -->
                        <c:if test="${sessionScope.account.roleId == 2}">
                            <li><a href="${pageContext.request.contextPath}/smedashboard">Dashboard</a></li>
                            <li><a href="${pageContext.request.contextPath}/courselist">Courses</a></li>
                            <li><a href="${pageContext.request.contextPath}/lessonlist">Lessons</a></li>
                            <li><a href="${pageContext.request.contextPath}/flashcardlibrary">Flashcards</a></li>
                            <li><a href="${pageContext.request.contextPath}/questionbank">Question Bank</a></li>
                            <li><a href="${pageContext.request.contextPath}/assignmentlist">Assignments</a></li>
                            </c:if>

                    </ul>

                    <div class="search-box">
                        <span class="search-icon">🔍</span>
                        <input type="text" placeholder="Search courses, lessons, flashcards...">
                    </div>

                </c:if>

                <div class="nav-right">

                    <c:choose>

                        <c:when test="${not empty sessionScope.account}">

                            <div class="notification">🔔</div>

                            <div class="user">

                                <div class="user-info">
                                    <b>${sessionScope.account.fullName}</b>

                                    <span class="role-badge">
                                        <c:choose>
                                            <c:when test="${sessionScope.account.roleId == 2}">
                                                SME
                                            </c:when>
                                            <c:otherwise>
                                                Student
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <div class="avatar">
                                    ${fn:substring(sessionScope.account.fullName,0,1)}
                                </div>

                            </div>

                            <a class="logout-btn"
                               href="${pageContext.request.contextPath}/logout">
                                Sign out
                            </a>

                        </c:when>

                        <c:otherwise>

                            <div class="guest-actions">
                                <a class="btn-primary"
                                   href="${pageContext.request.contextPath}/login">
                                    Sign In
                                </a>
                            </div>

                        </c:otherwise>

                    </c:choose>

                </div>

            </div>
        </nav>