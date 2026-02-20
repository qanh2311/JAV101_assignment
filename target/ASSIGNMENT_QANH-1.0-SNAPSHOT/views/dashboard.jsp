<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Include Header -->
<jsp:include page="/layouts/header.jsp">
    <jsp:param name="pageTitle" value="${pageTitle}" />
</jsp:include>

<style>
    /* Page Title */
    .page-title {
        font-size: 32px;
        margin-bottom: 30px;
        text-align: center;
        color: #ffffff;
        animation: fadeInDown 0.6s ease;
    }

    .page-subtitle {
        font-size: 16px;
        text-align: center;
        color: #999;
        margin-top: -20px;
        margin-bottom: 30px;
        animation: fadeInDown 0.6s ease 0.1s both;
    }

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

    /* News Grid */
    .news-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
        gap: 25px;
        animation: fadeInUp 0.6s ease 0.2s both;
    }

    .news-card {
        background: #0a0a0a;
        border: 1px solid #222;
        border-radius: 12px;
        overflow: hidden;
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        cursor: pointer;
        display: flex;
        flex-direction: column;
        position: relative;
    }

    .news-card::after {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: linear-gradient(135deg, rgba(255,255,255,0.05) 0%, transparent 100%);
        opacity: 0;
        transition: opacity 0.3s;
        pointer-events: none;
    }

    .news-card:hover {
        transform: translateY(-8px);
        border-color: #ffffff;
        box-shadow: 0 15px 40px rgba(255, 255, 255, 0.15);
    }

    .news-card:hover::after {
        opacity: 1;
    }

    .news-image-container {
        width: 100%;
        height: 200px;
        overflow: hidden;
        position: relative;
        background: #1a1a1a;
    }

    .news-image-container::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: linear-gradient(to bottom, transparent 0%, rgba(0,0,0,0.3) 100%);
        z-index: 1;
        opacity: 0;
        transition: opacity 0.3s;
    }

    .news-card:hover .news-image-container::before {
        opacity: 1;
    }

    .news-image {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.5s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .news-card:hover .news-image {
        transform: scale(1.08);
    }

    .news-content {
        padding: 24px;
        flex: 1;
        display: flex;
        flex-direction: column;
        background: #0a0a0a;
        position: relative;
    }

    .news-title {
        font-size: 18px;
        margin-bottom: 12px;
        color: #ffffff;
        line-height: 1.4;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        font-weight: 600;
        transition: color 0.3s;
    }

    .news-card:hover .news-title {
        color: #cccccc;
    }

    .news-meta {
        display: flex;
        gap: 15px;
        margin-bottom: 12px;
        font-size: 12px;
        color: #999;
        flex-wrap: wrap;
    }

    .news-meta span {
        display: flex;
        align-items: center;
        gap: 4px;
        transition: color 0.3s;
    }

    .news-card:hover .news-meta span {
        color: #bbb;
    }

    .news-excerpt {
        color: #cccccc;
        line-height: 1.6;
        font-size: 14px;
        display: -webkit-box;
        -webkit-line-clamp: 3;
        -webkit-box-orient: vertical;
        overflow: hidden;
        flex: 1;
        margin-bottom: 12px;
    }

    .trending-badge {
        display: inline-block;
        padding: 6px 12px;
        background: linear-gradient(135deg, #ffffff 0%, #e0e0e0 100%);
        color: #000000;
        border-radius: 6px;
        font-size: 11px;
        font-weight: bold;
        margin-bottom: 12px;
        box-shadow: 0 2px 8px rgba(255, 255, 255, 0.2);
        animation: pulse 2s infinite;
    }

    @keyframes pulse {
        0%, 100% {
            box-shadow: 0 2px 8px rgba(255, 255, 255, 0.2);
        }
        50% {
            box-shadow: 0 2px 15px rgba(255, 255, 255, 0.4);
        }
    }

    .read-more {
        color: #ffffff;
        font-size: 13px;
        font-weight: 600;
        display: inline-flex;
        align-items: center;
        gap: 5px;
        opacity: 0;
        transform: translateX(-10px);
        transition: all 0.3s;
    }

    .news-card:hover .read-more {
        opacity: 1;
        transform: translateX(0);
    }

    .read-more::after {
        content: '→';
        transition: transform 0.3s;
    }

    .news-card:hover .read-more::after {
        transform: translateX(5px);
    }

    /* Empty State */
    .empty-message {
        text-align: center;
        padding: 80px 20px;
        color: #666;
        font-size: 18px;
        animation: fadeInUp 0.6s ease;
    }

    .empty-message-icon {
        font-size: 80px;
        margin-bottom: 25px;
        animation: float 3s ease-in-out infinite;
    }

    @keyframes float {
        0%, 100% {
            transform: translateY(0);
        }
        50% {
            transform: translateY(-15px);
        }
    }

    .empty-message h3 {
        color: #ffffff;
        margin-bottom: 15px;
        font-size: 28px;
    }

    .empty-message p {
        color: #999;
        font-size: 16px;
        line-height: 1.6;
        max-width: 500px;
        margin: 0 auto 30px;
    }

    .empty-message .btn {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 14px 30px;
        background: #ffffff;
        color: #000000;
        text-decoration: none;
        border-radius: 8px;
        font-weight: bold;
        transition: all 0.3s;
        border: 2px solid #ffffff;
        font-size: 15px;
    }

    .empty-message .btn:hover {
        background: #000000;
        color: #ffffff;
        transform: translateY(-3px);
        box-shadow: 0 6px 20px rgba(255, 255, 255, 0.3);
    }

    /* Loading State */
    .loading-container {
        display: none;
        text-align: center;
        padding: 60px 20px;
    }

    .loading-spinner {
        width: 50px;
        height: 50px;
        border: 3px solid #222;
        border-top-color: #ffffff;
        border-radius: 50%;
        animation: spin 1s linear infinite;
        margin: 0 auto 20px;
    }

    @keyframes spin {
        to {
            transform: rotate(360deg);
        }
    }

    /* Toast Notification */
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

    .toast-icon {
        font-size: 24px;
    }

    .toast-message {
        font-size: 14px;
        font-weight: 500;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .news-grid {
            grid-template-columns: 1fr;
        }

        .page-title {
            font-size: 24px;
        }

        .toast {
            right: 15px;
            left: 15px;
            max-width: none;
        }

        .empty-message-icon {
            font-size: 64px;
        }

        .empty-message h3 {
            font-size: 22px;
        }
    }
</style>


<h2 class="page-title">${pageTitle}</h2>
<c:if test="${not empty message}">
    <p class="page-subtitle">${message}</p>
</c:if>


<div class="loading-container" id="loadingContainer">
    <div class="loading-spinner"></div>
    <p style="color: #999;">Đang tải dữ liệu...</p>
</div>


<c:choose>
    <c:when test="${not empty newsList}">
        <div class="news-grid">
            <c:forEach items="${newsList}" var="news">
                <div class="news-card" onclick="navigateToDetail(${news.id})">
                    <div class="news-image-container">
                        <img src="${not empty news.imagePaths && fn:length(news.imagePaths) > 0 ? news.imagePaths[0] : 'https://via.placeholder.com/400x250/1a1a1a/cccccc?text='.concat(news.category)}"
                             alt="${news.title}"
                             class="news-image"
                             onerror="this.src='https://via.placeholder.com/400x250/1a1a1a/cccccc?text=NEWS'">
                    </div>
                    <div class="news-content">
                        <c:if test="${news.trending}">
                            <span class="trending-badge">HOT</span>
                        </c:if>
                        <h3 class="news-title">${news.title}</h3>
                        <div class="news-meta">
                            <span>${news.category}</span>
                            <span>${news.author}</span>
                            <span>${news.views}</span>
                        </div>
                        <p class="news-excerpt">
                            <c:choose>
                                <c:when test="${fn:length(news.content) > 120}">
                                    ${fn:substring(news.content, 0, 120)}...
                                </c:when>
                                <c:otherwise>
                                    ${news.content}
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <span class="read-more">Đọc tiếp</span>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:when>
    <c:otherwise>
        <div class="empty-message">
            <div class="empty-message-icon">📚</div>
            <h3>Chưa có gợi ý cho bạn</h3>
            <p>
                <c:choose>
                    <c:when test="${not empty message}">
                        ${message}
                    </c:when>
                    <c:otherwise>
                        Không có bài viết nào. Hãy thử tìm kiếm với từ khóa khác hoặc quay lại trang chủ.
                    </c:otherwise>
                </c:choose>
            </p>
            <a href="dashboard" class="btn">
                <span>Khám phá tin tức</span>
            </a>
        </div>
    </c:otherwise>
</c:choose>


<div class="toast" id="toast">
    <span class="toast-message" id="toastMessage"></span>
</div>

<script>
    // Navigate to detail page with loading animation
    function navigateToDetail(newsId) {
        document.getElementById('loadingContainer').style.display = 'block';
        window.location.href = 'news-detail?id=' + newsId;
    }

    // Show toast notification
    function showToast(message, icon = '✔') {
        const toast = document.getElementById('toast');
        const toastMessage = document.getElementById('toastMessage');
        const toastIcon = toast.querySelector('.toast-icon');

        toastIcon.textContent = icon;
        toastMessage.textContent = message;
        toast.classList.add('show');

        setTimeout(() => {
            toast.classList.remove('show');
        }, 3000);
    }

    // Check for success messages from URL parameters
    window.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const success = urlParams.get('success');

        if (success === 'added') {
            showToast('Đã thêm bài viết thành công!', '✅');
        } else if (success === 'updated') {
            showToast('Đã cập nhật bài viết thành công!', '✅');
        } else if (success === 'deleted') {
            showToast('Đã xóa bài viết thành công!', '✅');
        }
    });

    // Add stagger animation to news cards
    window.addEventListener('DOMContentLoaded', function() {
        const cards = document.querySelectorAll('.news-card');
        cards.forEach((card, index) => {
            card.style.animation = `fadeInUp 0.6s ease ${0.1 * index}s both`;
        });
    });
</script>

<!-- Include Footer -->
<jsp:include page="/layouts/footer.jsp" />