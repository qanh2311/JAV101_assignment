<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Include Header -->
<jsp:include page="/layouts/header.jsp">
    <jsp:param name="pageTitle" value="Quản lý tin tức" />
</jsp:include>

<style>
    @keyframes fadeInDown {
        from {
            opacity: 0;
            transform: translateY(-20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
        animation: fadeInDown 0.6s ease;
    }

    .page-title {
        color: #ffffff;
        font-size: 32px;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .btn-add {
        padding: 14px 28px;
        background: linear-gradient(135deg, #ffffff 0%, #e0e0e0 100%);
        color: #000000;
        text-decoration: none;
        border-radius: 8px;
        font-weight: bold;
        border: 2px solid #ffffff;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: all 0.3s;
    }

    .btn-add:hover {
        background: #000000;
        color: #ffffff;
        transform: translateY(-3px);
        box-shadow: 0 6px 20px rgba(255, 255, 255, 0.3);
    }

    .stats-cards {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
        animation: fadeInUp 0.6s ease 0.2s both;
    }

    .stat-card {
        background: linear-gradient(135deg, #1a1a1a 0%, #0a0a0a 100%);
        padding: 25px;
        border-radius: 10px;
        border: 1px solid #333;
        text-align: center;
        transition: all 0.3s;
    }

    .stat-card:hover {
        transform: translateY(-5px);
        border-color: #ffffff;
        box-shadow: 0 10px 30px rgba(255, 255, 255, 0.1);
    }

    .stat-icon {
        font-size: 36px;
        margin-bottom: 10px;
    }

    .stat-value {
        font-size: 32px;
        color: #ffffff;
        font-weight: bold;
        margin-bottom: 5px;
    }

    .stat-label {
        color: #999;
        font-size: 14px;
    }

    .news-table-container {
        background: linear-gradient(135deg, #0a0a0a 0%, #1a1a1a 100%);
        border-radius: 12px;
        border: 1px solid #222;
        overflow: hidden;
        animation: fadeInUp 0.6s ease 0.4s both;
    }

    .table-header {
        padding: 20px 25px;
        border-bottom: 2px solid #333;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .table-title {
        color: #ffffff;
        font-size: 20px;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .search-box {
        display: flex;
        gap: 10px;
    }

    .search-box input {
        padding: 10px 15px;
        background: #0a0a0a;
        border: 2px solid #333;
        color: #ffffff;
        border-radius: 6px;
        width: 250px;
        transition: all 0.3s;
    }

    .search-box input:focus {
        outline: none;
        border-color: #ffffff;
        background: #1a1a1a;
    }

    .table-wrapper {
        overflow-x: auto;
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    thead {
        background: #1a1a1a;
    }

    th {
        padding: 18px 15px;
        text-align: left;
        color: #ffffff;
        font-weight: 600;
        font-size: 14px;
        border-bottom: 2px solid #333;
        white-space: nowrap;
    }

    td {
        padding: 18px 15px;
        color: #cccccc;
        border-bottom: 1px solid #222;
        font-size: 14px;
    }

    tbody tr {
        transition: all 0.3s;
    }

    tbody tr:hover {
        background: #1a1a1a;
    }

    .news-title-cell {
        max-width: 300px;
    }

    .news-title-link {
        color: #ffffff;
        text-decoration: none;
        font-weight: 600;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        transition: color 0.3s;
    }

    .news-title-link:hover {
        color: #64b5f6;
    }

    .category-badge {
        display: inline-block;
        padding: 6px 12px;
        background: #2a2a2a;
        color: #ffffff;
        border-radius: 6px;
        font-size: 12px;
        font-weight: 600;
        white-space: nowrap;
    }

    .trending-badge {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        padding: 6px 12px;
        background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%);
        color: #000000;
        border-radius: 6px;
        font-size: 11px;
        font-weight: bold;
    }

    .action-buttons {
        display: flex;
        gap: 8px;
    }

    .btn-action {
        padding: 8px 16px;
        border-radius: 6px;
        text-decoration: none;
        font-size: 13px;
        font-weight: 600;
        border: 2px solid;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        transition: all 0.3s;
        white-space: nowrap;
    }

    .btn-view {
        background: #0a0a0a;
        color: #64b5f6;
        border-color: #64b5f6;
    }

    .btn-view:hover {
        background: #64b5f6;
        color: #000000;
        transform: translateY(-2px);
    }

    .btn-edit {
        background: #0a0a0a;
        color: #fbbf24;
        border-color: #fbbf24;
    }

    .btn-edit:hover {
        background: #fbbf24;
        color: #000000;
        transform: translateY(-2px);
    }

    .btn-delete {
        background: #0a0a0a;
        color: #ef4444;
        border-color: #ef4444;
    }

    .btn-delete:hover {
        background: #ef4444;
        color: #ffffff;
        transform: translateY(-2px);
    }

    .empty-state {
        text-align: center;
        padding: 80px 20px;
        color: #666;
    }

    .empty-icon {
        font-size: 80px;
        margin-bottom: 20px;
        opacity: 0.5;
    }

    .empty-title {
        color: #ffffff;
        font-size: 24px;
        margin-bottom: 10px;
    }

    .empty-text {
        color: #999;
        font-size: 16px;
    }

    .toast {
        position: fixed;
        bottom: -100px;
        right: 30px;
        background: #0a0a0a;
        color: #ffffff;
        padding: 16px 24px;
        border-radius: 8px;
        border: 1px solid #ffffff;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
        z-index: 9999;
        transition: bottom 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        display: flex;
        align-items: center;
        gap: 12px;
        max-width: 350px;
    }

    .toast.show {
        bottom: 30px;
    }

    .toast.success {
        border-color: #10b981;
    }

    .toast.error {
        border-color: #ef4444;
    }

    @media (max-width: 768px) {
        .page-header {
            flex-direction: column;
            gap: 20px;
            align-items: flex-start;
        }

        .search-box {
            width: 100%;
        }

        .search-box input {
            width: 100%;
        }

        .table-wrapper {
            overflow-x: scroll;
        }

        .action-buttons {
            flex-direction: column;
        }

        .stats-cards {
            grid-template-columns: 1fr;
        }
    }
</style>

<div class="page-header">
    <h2 class="page-title">

        <span>Quản lý tin tức</span>
    </h2>
    <a href="news-add" class="btn-add">

        <span>Thêm bài viết</span>
    </a>
</div>

<!-- Stats Cards -->
<div class="stats-cards">
    <div class="stat-card">

        <div class="stat-value">
            <c:choose>
                <c:when test="${not empty newsList}">
                    ${fn:length(newsList)}
                </c:when>
                <c:otherwise>
                    0
                </c:otherwise>
            </c:choose>
        </div>
        <div class="stat-label">Tổng bài viết</div>
    </div>

    <div class="stat-card">
        <div class="stat-value">
            <c:set var="hotCount" value="0"/>
            <c:forEach items="${newsList}" var="news">
                <c:if test="${news.trending}">
                    <c:set var="hotCount" value="${hotCount + 1}"/>
                </c:if>
            </c:forEach>
            ${hotCount}
        </div>
        <div class="stat-label">Bài HOT</div>
    </div>

    <div class="stat-card">
        <div class="stat-value">
            <c:set var="totalViews" value="0"/>
            <c:forEach items="${newsList}" var="news">
                <c:set var="totalViews" value="${totalViews + news.views}"/>
            </c:forEach>
            ${totalViews}
        </div>
        <div class="stat-label">Tổng lượt xem</div>
    </div>
</div>

<!-- News Table -->
<div class="news-table-container">
    <div class="table-header">
        <div class="table-title">
            <span>Danh sách bài viết</span>
        </div>
        <div class="search-box">
            <input type="text" id="searchInput" placeholder="🔍 Tìm kiếm bài viết..." onkeyup="filterNews()">
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty newsList}">
            <div class="table-wrapper">
                <table id="newsTable">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tiêu đề</th>
                        <th>Danh mục</th>
                        <th>Tác giả</th>
                        <th>Lượt xem</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${newsList}" var="news">
                        <tr>
                            <td><strong>#${news.id}</strong></td>
                            <td class="news-title-cell">
                                <a href="news-detail?id=${news.id}" class="news-title-link">
                                        ${news.title}
                                </a>
                            </td>
                            <td>
                                <span class="category-badge">${news.category}</span>
                            </td>
                            <td>${news.author}</td>
                            <td>${news.views}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${news.trending}">
                                            <span class="trending-badge">

                                                <span>HOT</span>
                                            </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #666;">Bình thường</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <a href="news-detail?id=${news.id}" class="btn-action btn-view">

                                        <span>Xem</span>
                                    </a>
                                    <a href="news-edit?id=${news.id}" class="btn-action btn-edit">

                                        <span>Sửa</span>
                                    </a>
                                    <a href="javascript:void(0)"
                                       onclick="confirmDelete(${news.id}, '${news.title}')"
                                       class="btn-action btn-delete">
                                        <span>Xóa</span>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <h3 class="empty-title">Chưa có bài viết nào</h3>
                <p class="empty-text">Hãy thêm bài viết đầu tiên của bạn!</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Toast Notification -->
<div class="toast" id="toast">
    <span class="toast-icon" id="toastIcon">✅</span>
    <span class="toast-message" id="toastMessage"></span>
</div>

<script>
    // Show toast notification
    function showToast(message, type = 'success') {
        const toast = document.getElementById('toast');
        const toastMessage = document.getElementById('toastMessage');
        const toastIcon = document.getElementById('toastIcon');

        toast.className = 'toast ' + type;

        if (type === 'success') {
            toastIcon.textContent = '✅';
        } else if (type === 'error') {
            toastIcon.textContent = '❌';
        }

        toastMessage.textContent = message;
        toast.classList.add('show');

        setTimeout(() => {
            toast.classList.remove('show');
        }, 3000);
    }

    // Check for success/error messages from URL
    window.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const success = urlParams.get('success');
        const error = urlParams.get('error');

        if (success === 'added') {
            showToast('Đã thêm bài viết thành công!', 'success');
        } else if (success === 'updated') {
            showToast('Đã cập nhật bài viết thành công!', 'success');
        } else if (success === 'deleted') {
            showToast('Đã xóa bài viết thành công!', 'success');
        } else if (error === 'delete_failed') {
            showToast('Không thể xóa bài viết!', 'error');
        } else if (error === 'not_found') {
            showToast('Không tìm thấy bài viết!', 'error');
        } else if (error === 'unauthorized') {
            showToast('Bạn không có quyền thực hiện thao tác này!', 'error');
        }
    });

    // Search filter
    function filterNews() {
        const input = document.getElementById('searchInput');
        const filter = input.value.toLowerCase();
        const table = document.getElementById('newsTable');
        const rows = table.getElementsByTagName('tr');

        for (let i = 1; i < rows.length; i++) {
            const cells = rows[i].getElementsByTagName('td');
            let found = false;

            for (let j = 0; j < cells.length; j++) {
                const cellText = cells[j].textContent || cells[j].innerText;
                if (cellText.toLowerCase().indexOf(filter) > -1) {
                    found = true;
                    break;
                }
            }

            rows[i].style.display = found ? '' : 'none';
        }
    }

    // Confirm delete
    function confirmDelete(id, title) {
        if (confirm('Bạn có chắc chắn muốn xóa bài viết:\n"' + title + '"?\n\nHành động này không thể hoàn tác!')) {
            window.location.href = 'news-delete?id=' + id;
        }
    }
</script>

<!-- Include Footer -->
<jsp:include page="/layouts/footer.jsp" />