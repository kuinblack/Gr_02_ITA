<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
    .sidebar{
        width:270px;
        background:#14532d;
        color:white;
        display:flex;
        flex-direction:column;
        min-height:100vh;
    }

    .sidebar-header{
        padding:24px;
        border-bottom:1px solid rgba(255,255,255,.12);
    }

    .brand{
        display:flex;
        align-items:center;
        gap:14px;
    }

    .brand-logo{
        width:52px;
        height:52px;
        border-radius:16px;
        background:linear-gradient(135deg,#22c55e,#4ade80);
        color:#052e16;
        display:flex;
        align-items:center;
        justify-content:center;
        font-size:28px;
        font-weight:800;
    }

    .brand-text h2{
        margin:0;
        font-size:24px;
        font-weight:800;
    }

    .brand-text span{
        color:#bbf7d0;
        font-size:12px;
        font-weight:700;
        letter-spacing:1px;
        text-transform:uppercase;
    }

    .menu-section{
        padding:16px 16px 6px;
        color:#bbf7d0;
        font-size:11px;
        font-weight:700;
        text-transform:uppercase;
        letter-spacing:1px;
    }

    .sidebar-menu{
        display:flex;
        flex-direction:column;
        padding:0 12px;
        gap:4px;
    }

    .sidebar-menu a{
        text-decoration:none;
        color:#ecfdf5;
        padding:12px 14px;
        border-radius:12px;
        transition:.2s;
        display:flex;
        align-items:center;
        gap:10px;
        font-weight:500;
    }

    .sidebar-menu a:hover{
        background:#166534;
    }

    .sidebar-menu a.active{
        background:#22c55e;
        color:#052e16;
        font-weight:700;
    }

    .sidebar-footer{
        margin-top:auto;
        padding:16px;
        border-top:1px solid rgba(255,255,255,.12);
    }

    .logout-btn{
        display:block;
        text-decoration:none;
        text-align:center;
        background:#dc2626;
        color:white;
        padding:12px;
        border-radius:12px;
        font-weight:700;
        transition:.2s;
    }

    .logout-btn:hover{
        background:#b91c1c;
    }
</style>

<aside class="sidebar">

    <div class="sidebar-header">
        <div class="brand">
            <div class="brand-logo">E</div>

            <div class="brand-text">
                <h2>EduNexus</h2>
                <span>SME Workspace</span>
            </div>
        </div>
    </div>

    <div class="menu-section">Workspace</div>

    <nav class="sidebar-menu">

        <a class="${active eq 'dashboard' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/smedashboard">
            🏠 Dashboard
        </a>

        <a class="${active eq 'courses' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/courselist">
            📚 My Courses
        </a>

        <a class="${active eq 'lessons' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/lessonlist">
            📝 Lessons
        </a>

    </nav>

    <div class="menu-section">Assessment</div>

    <nav class="sidebar-menu">

        <a class="${active eq 'assignments' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/assignmentlist">
            📄 Assignments
        </a>

        <a class="${active eq 'flashcards' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/flashcardlibrary">
            🃏 Flashcards
        </a>

        <a class="${active eq 'questions' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/questionbank">
            ❓ Question Bank
        </a>

    </nav>

    <div class="menu-section">AI Workspace</div>

    <nav class="sidebar-menu">

        <a class="${active eq 'ailesson' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/ailesson">
            ✨ AI Lesson Staging
        </a>

        <a class="${active eq 'extract' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/lessontextextract">
            📺 Lesson Text Extract
        </a>

        <a class="${active eq 'drafts' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/aidrafts">
            🕘 AI Draft Queue
        </a>

        <a class="${active eq 'aiflashcards' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/aiflashcardstaging">
            🤖 AI Flashcards
        </a>

        <a class="${active eq 'aiquestions' ? 'active' : ''}"
           href="${pageContext.request.contextPath}/aiquestionstaging">
            🧠 AI Questions
        </a>

    </nav>

    <div class="sidebar-footer">
        <a class="logout-btn"
           href="${pageContext.request.contextPath}/logout">
            🚪 Logout
        </a>
    </div>

</aside>