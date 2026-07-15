<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Question List"/>
</jsp:include>
<!-- Nhúng Bootstrap 5 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Nhúng Bootstrap Icons để hiển thị các biểu tượng (search, play, collection...) -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">


<style>
    :root{
        --primary:#2563eb;
        --primary-light:#dbeafe;
        --success:#16a34a;
        --success-light:#dcfce7;
        --warning:#ca8a04;
        --warning-light:#fef3c7;
        --info:#0891b2;
        --info-light:#cffafe;
        --danger:#dc2626;
        --border:#e2e8f0;
        --text:#0f172a;
        --muted:#64748b;
        --bg:#f8fafc;
    }

    body{
        background:var(--bg);
        font-family:'Inter',sans-serif;
    }

    .main-container{
        max-width:1280px;
        margin:30px auto;
        padding:0 18px;
    }

    /* ================= HEADER ================= */

    .page-header{
        background:white;
        border-radius:20px;
        padding:28px;
        border:1px solid var(--border);
        box-shadow:0 10px 30px rgba(0,0,0,.04);
        margin-bottom:25px;
    }

    .page-title{
        font-weight:800;
        color:var(--text);
        margin-bottom:5px;
    }

    .page-subtitle{
        color:var(--muted);
        margin-bottom:0;
    }

    .breadcrumb{
        margin-bottom:8px;
    }

    .breadcrumb-item a{
        text-decoration:none;
        color:var(--muted);
    }

    .btn-practice-main{
        background:linear-gradient(135deg,#2563eb,#1d4ed8);
        color:white;
        border:none;
        padding:12px 28px;
        border-radius:12px;
        font-weight:700;
        transition:.25s;
    }

    .btn-practice-main:hover{
        transform:translateY(-2px);
        box-shadow:0 12px 24px rgba(37,99,235,.25);
        color: white;
    }

    /* ================= STATS ================= */

    .stat-card{
        background:white;
        border-radius:18px;
        border:1px solid var(--border);
        padding:20px;
        cursor:pointer;
        transition:.25s;
        height:100%;
    }

    .stat-card:hover{
        transform:translateY(-4px);
        box-shadow:0 12px 25px rgba(0,0,0,.05);
    }

    .stat-card.active{
        border:2px solid var(--primary);
    }

    .stat-icon{
        width:52px;
        height:52px;
        border-radius:14px;
        display:flex;
        align-items:center;
        justify-content:center;
        font-size:22px;
    }

    .card-all .stat-icon{
        background:var(--primary-light);
        color:var(--primary);
    }

    .card-mcq .stat-icon{
        background:var(--success-light);
        color:var(--success);
    }

    .card-tf .stat-icon{
        background:var(--info-light);
        color:var(--info);
    }

    .card-essay .stat-icon{
        background:var(--warning-light);
        color:var(--warning);
    }

    .stat-title{
        color:var(--muted);
        font-size:13px;
        font-weight:600;
    }

    .stat-value{
        font-size:28px;
        font-weight:800;
        color:var(--text);
    }

    /* ================= TABLE ================= */

    .table-card{
        background:white;
        border-radius:20px;
        border:1px solid var(--border);
        box-shadow:0 10px 30px rgba(0,0,0,.04);
        overflow:hidden;
    }

    .table-toolbar{
        padding:18px 25px;
        border-bottom:1px solid var(--border);
        background:#fbfdff;
    }

    .custom-table{
        margin:0;
    }

    .custom-table thead th{
        background:#f8fafc;
        color:#475569;
        border:none;
        font-size:12px;
        font-weight:700;
        letter-spacing:.5px;
        text-transform:uppercase;
        padding:18px;
    }

    .custom-table tbody td{
        padding:18px;
        border-top:1px solid #f1f5f9;
    }

    .custom-table tbody tr:hover{
        background:#f8fbff;
    }

    /* ================= BADGE ================= */

    .badge-type{
        padding:7px 14px;
        border-radius:50px;
        font-size:12px;
        font-weight:700;
    }

    .badge-mcq{
        background:var(--success-light);
        color:var(--success);
    }

    .badge-tf{
        background:var(--info-light);
        color:var(--info);
    }

    .badge-essay{
        background:var(--warning-light);
        color:var(--warning);
    }

    /* ================= BUTTON ================= */

    .btn-practice{
        border-radius:10px;
        font-weight:600;
        padding:8px 18px;
        border:1.5px solid var(--primary);
        color:var(--primary);
        transition:.2s;
        text-decoration:none;
    }

    .btn-practice:hover{
        background:var(--primary);
        color:white;
    }

    .question-content{
        display:-webkit-box;
        -webkit-line-clamp:2;
        -webkit-box-orient:vertical;
        overflow:hidden;
        font-size:15px;
        color:#334155;
    }

    .empty-box{
        padding:70px;
        text-align:center;
    }

    .empty-box i{
        font-size:70px;
        color:#cbd5e1;
    }

    .empty-box h4{
        margin-top:15px;
        color:#475569;
    }

    .empty-box p{
        color:#94a3b8;
    }
</style>

<div class="main-container">

    <!-- ================= HERO ================= -->
    <div class="page-header">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/courseview">My Courses</a>
                        </li>
                        <li class="breadcrumb-item active">
                            ${module.moduleTitle}
                        </li>
                    </ol>
                </nav>
                <h2 class="page-title">
                    <i class="bi bi-patch-question-fill text-primary me-2"></i>
                    Question Bank
                </h2>
                <p class="page-subtitle">
                    Practice questions before taking the real examination.
                </p>
            </div>
            <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                <a class="btn btn-practice-main"
                   href="${pageContext.request.contextPath}/studentquestionpractice?moduleId=${module.moduleId}">
                    <i class="bi bi-play-fill"></i>
                    Start Random Practice
                </a>
            </div>
        </div>
    </div>

    <!-- ================= SEARCH ================= -->
    <div class="row mb-4">
        <div class="col-lg-6">
            <div class="input-group">
                <span class="input-group-text bg-white">
                    <i class="bi bi-search"></i>
                </span>
                <input
                    id="searchBox"
                    class="form-control"
                    type="text"
                    placeholder="Search question..."
                    onkeyup="searchQuestion()">
            </div>
        </div>
        <div class="col-lg-6 text-lg-end mt-3 mt-lg-0">
            <span class="badge bg-primary px-3 py-2 fs-6">
                ${totalCount} Questions
            </span>
        </div>
    </div>

    <!-- ================= STATISTICS ================= -->
    <div class="row g-3 mb-4">
        <!-- ALL -->
        <div class="col-lg-3 col-md-6">
            <div class="stat-card card-all ${selectedType == 'All' ? 'active' : ''}"
                 onclick="location.href = '?moduleId=${module.moduleId}&type=All'">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="stat-title">All Questions</div>
                        <div class="stat-value">${totalCount}</div>
                    </div>
                    <div class="stat-icon">
                        <i class="bi bi-collection"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- MCQ -->
        <div class="col-lg-3 col-md-6">
            <div class="stat-card card-mcq ${selectedType == 'MCQ' ? 'active' : ''}"
                 onclick="location.href = '?moduleId=${module.moduleId}&type=MCQ'">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="stat-title">Multiple Choice</div>
                        <div class="stat-value">${mcqCount}</div>
                    </div>
                    <div class="stat-icon">
                        <i class="bi bi-ui-checks-grid"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- TRUE FALSE -->
        <div class="col-lg-3 col-md-6">
            <div class="stat-card card-tf ${selectedType == 'True/False' ? 'active' : ''}"
                 onclick="location.href = '?moduleId=${module.moduleId}&type=True/False'">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="stat-title">True / False</div>
                        <div class="stat-value">${tfCount}</div>
                    </div>
                    <div class="stat-icon">
                        <i class="bi bi-check2-square"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- ESSAY -->
        <div class="col-lg-3 col-md-6">
            <div class="stat-card card-essay ${selectedType == 'Essay' ? 'active' : ''}"
                 onclick="location.href = '?moduleId=${module.moduleId}&type=Essay'">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <div class="stat-title">Essay</div>
                        <div class="stat-value">${essayCount}</div>
                    </div>
                    <div class="stat-icon">
                        <i class="bi bi-journal-text"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ================= TABLE & LIST ================= -->
    <div class="table-card">
        <div class="table-toolbar d-flex justify-content-between align-items-center">
            <div>
                <strong>${selectedType}</strong>
            </div>
            <div class="text-muted">
                Showing <strong>${questionList.size()}</strong> questions
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty questionList}">
                <div class="table-responsive">
                    <table class="table custom-table align-middle">
                        <thead>
                            <tr>
                                <th width="8%">#</th>
                                <th width="58%">Question</th>
                                <th width="15%">Type</th>
                                <th width="9%">Time</th>
                                <th width="10%">Action</th>
                            </tr>
                        </thead>
                        <tbody id="questionTable">
                            <c:forEach items="${questionList}" var="q" varStatus="s">
                                <tr>
                                    <td class="fw-semibold text-secondary">
                                        ${s.index + 1}
                                    </td>
                                    <td>
                                        <div class="question-content" title="${q.content}">
                                            ${q.content}
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${q.questionType == 'MCQ'}">
                                                <span class="badge-type badge-mcq">
                                                    <i class="bi bi-ui-checks-grid me-1"></i> MCQ
                                                </span>
                                            </c:when>
                                            <c:when test="${q.questionType == 'Essay'}">
                                                <span class="badge-type badge-essay">
                                                    <i class="bi bi-pencil-square me-1"></i> Essay
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-type badge-tf">
                                                    <i class="bi bi-check2-square me-1"></i> True / False
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="text-muted">~2 mins</span>
                                    </td>
                                    <td>
                                        <a class="btn btn-sm btn-practice"
                                           href="${pageContext.request.contextPath}/studentquestionpractice?moduleId=${module.moduleId}&startFrom=${q.questionId}">
                                            <i class="bi bi-play-fill"></i> Practice
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-box">
                    <i class="bi bi-folder2-open"></i>
                    <h4>No Questions Found</h4>
                    <p>There are currently no questions available for this module.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/common/footer.jsp"/>

<!-- ================= LOCAL SEARCH SCRIPT ================= -->
<script>
    function searchQuestion() {
        const input = document.getElementById('searchBox').value.toLowerCase().trim();
        const rows = document.querySelectorAll('#questionTable tr');

        rows.forEach(row => {
            const questionText = row.querySelector('.question-content').textContent.toLowerCase();
            if (questionText.includes(input)) {
                row.style.setProperty('display', '', 'important');
            } else {
                row.style.setProperty('display', 'none', 'important');
            }
        });
    }
</script>