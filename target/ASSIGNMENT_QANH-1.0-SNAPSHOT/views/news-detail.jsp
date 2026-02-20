<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Include Header -->
<jsp:include page="/layouts/header.jsp">
    <jsp:param name="pageTitle" value="${news.title}" />
</jsp:include>

<style>
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

    @keyframes fadeIn {
        from {
            opacity: 0;
        }
        to {
            opacity: 1;
        }
    }

    .detail-container {
        max-width: 900px;
        margin: 0 auto;
        animation: fadeInUp 0.6s ease;
    }

    .detail-box {
        background: linear-gradient(135deg, #0a0a0a 0%, #1a1a1a 100%);
        padding: 45px;
        border-radius: 12px;
        border: 1px solid #222;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
    }

    .article-title {
        color: #ffffff;
        font-size: 38px;
        margin-bottom: 25px;
        line-height: 1.3;
        font-weight: 700;
        animation: fadeIn 0.8s ease 0.2s both;
    }

    .article-meta {
        display: flex;
        gap: 25px;
        padding: 22px 0;
        border-top: 2px solid #333;
        border-bottom: 2px solid #333;
        margin-bottom: 35px;
        flex-wrap: wrap;
        animation: fadeIn 0.8s ease 0.4s both;
    }

    .meta-item {
        display: flex;
        align-items: center;
        gap: 8px;
        color: #999;
        font-size: 14px;
        transition: color 0.3s;
    }

    .meta-item:hover {
        color: #ffffff;
    }

    .meta-item strong {
        color: #ffffff;
        font-weight: 600;
    }

    .trending-badge-large {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 8px 16px;
        background: linear-gradient(135deg, #ffffff 0%, #e0e0e0 100%);
        color: #000000;
        border-radius: 8px;
        font-size: 14px;
        font-weight: bold;
        box-shadow: 0 4px 15px rgba(255, 255, 255, 0.2);
        animation: pulse 2s infinite;
    }

    @keyframes pulse {
        0%, 100% {
            box-shadow: 0 4px 15px rgba(255, 255, 255, 0.2);
        }
        50% {
            box-shadow: 0 4px 20px rgba(255, 255, 255, 0.4);
        }
    }

    .article-content {
        color: #cccccc;
        line-height: 1.9;
        font-size: 17px;
        margin: 35px 0;
        animation: fadeIn 0.8s ease 0.6s both;
    }

    .article-content p {
        margin-bottom: 18px;
        text-align: justify;
    }

    .images-section {
        margin: 40px 0;
        animation: fadeIn 0.8s ease 0.8s both;
    }

    .section-title {
        color: #ffffff;
        font-size: 22px;
        margin-bottom: 25px;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .image-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
        gap: 20px;
    }

    .image-item {
        border-radius: 10px;
        overflow: hidden;
        border: 1px solid #333;
        background: #0a0a0a;
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        cursor: pointer;
        position: relative;
    }

    .image-item::after {
        content: '🔍';
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%) scale(0);
        font-size: 32px;
        opacity: 0;
        transition: all 0.3s;
        z-index: 2;
    }

    .image-item::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        opacity: 0;
        transition: opacity 0.3s;
        z-index: 1;
    }

    .image-item:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 30px rgba(255, 255, 255, 0.1);
    }

    .image-item:hover::before {
        opacity: 1;
    }

    .image-item:hover::after {
        opacity: 1;
        transform: translate(-50%, -50%) scale(1);
    }

    .image-item img {
        width: 100%;
        height: 220px;
        object-fit: cover;
        transition: transform 0.4s;
    }

    .image-item:hover img {
        transform: scale(1.05);
    }

    .action-buttons {
        display: flex;
        gap: 15px;
        margin-top: 40px;
        flex-wrap: wrap;
        animation: fadeIn 0.8s ease 1s both;
    }

    .btn {
        padding: 14px 28px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: bold;
        transition: all 0.3s ease;
        border: 2px solid;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        font-size: 15px;
    }

    .btn-back {
        background: linear-gradient(135deg, #ffffff 0%, #e0e0e0 100%);
        color: #000000;
        border-color: #ffffff;
        flex: 1;
        min-width: 200px;
    }

    .btn-back:hover {
        background: #000000;
        color: #ffffff;
        transform: translateY(-3px);
        box-shadow: 0 6px 20px rgba(255, 255, 255, 0.3);
    }

    .btn-edit {
        background: linear-gradient(135deg, #4a8aca 0%, #2a6aaa 100%);
        color: #ffffff;
        border-color: #4a8aca;
        flex: 1;
        min-width: 200px;
    }

    .btn-edit:hover {
        background: linear-gradient(135deg, #5a9ada 0%, #3a7aba 100%);
        transform: translateY(-3px);
        box-shadow: 0 6px 20px rgba(74, 138, 202, 0.4);
    }

    .stats-banner {
        background: linear-gradient(135deg, #1a1a1a 0%, #0a0a0a 100%);
        padding: 20px;
        border-radius: 8px;
        margin: 30px 0;
        border: 1px solid #333;
        display: flex;
        justify-content: space-around;
        animation: fadeIn 0.8s ease 0.5s both;
    }

    .stat-item {
        text-align: center;
    }

    .stat-value {
        font-size: 28px;
        color: #ffffff;
        font-weight: bold;
        display: block;
        margin-bottom: 5px;
    }

    .stat-label {
        font-size: 13px;
        color: #999;
    }

    .lightbox {
        display: none;
        position: fixed;
        z-index: 9999;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.95);
        backdrop-filter: blur(10px);
        animation: fadeIn 0.3s ease;
    }

    .lightbox-content {
        position: relative;
        margin: auto;
        max-width: 90%;
        max-height: 90%;
        top: 50%;
        transform: translateY(-50%);
        animation: zoomIn 0.4s ease;
    }

    @keyframes zoomIn {
        from {
            transform: translateY(-50%) scale(0.8);
            opacity: 0;
        }
        to {
            transform: translateY(-50%) scale(1);
            opacity: 1;
        }
    }

    .lightbox-content img {
        width: 100%;
        height: auto;
        border-radius: 8px;
    }

    .lightbox-close {
        position: absolute;
        top: 20px;
        right: 30px;
        color: #ffffff;
        font-size: 40px;
        font-weight: bold;
        cursor: pointer;
        z-index: 10000;
        transition: all 0.3s;
    }

    .lightbox-close:hover {
        color: #ef4444;
        transform: rotate(90deg);
    }

    @media (max-width: 768px) {
        .detail-box {
            padding: 30px 20px;
        }

        .article-title {
            font-size: 28px;
        }

        .article-meta {
            flex-direction: column;
            gap: 12px;
        }

        .image-grid {
            grid-template-columns: 1fr;
        }

        .action-buttons {
            flex-direction: column;
        }

        .btn {
            width: 100%;
            min-width: auto;
        }

        .stats-banner {
            flex-direction: column;
            gap: 15px;
        }

        .lightbox-content {
            max-width: 95%;
        }

        .lightbox-close {
            top: 10px;
            right: 15px;
            font-size: 30px;
        }
    }
</style>

<div class="detail-container">
    <div class="detail-box">
        <h1 class="article-title">${news.title}</h1>

        <div class="article-meta">
            <div class="meta-item">
                <strong>${news.author}</strong>
            </div>
            <div class="meta-item">
                <strong>${news.category}</strong>
            </div>
            <div class="meta-item">
                <strong>${news.views} lượt xem</strong>
            </div>
            <c:if test="${news.trending}">
                <div class="meta-item">
                    <span class="trending-badge-large">
                        <span>HOT</span>
                    </span>
                </div>
            </c:if>
        </div>

        <div class="stats-banner">
            <div class="stat-item">
                <span class="stat-label">Bài viết #${news.id}</span>
            </div>
            <div class="stat-item">
                <span class="stat-value">${news.views}</span>
                <span class="stat-label">Lượt xem</span>
            </div>
            <div class="stat-item">
                <span class="stat-value">
                    <c:choose>
                        <c:when test="${not empty news.imagePaths}">
                            ${news.imagePaths.size()}
                        </c:when>
                        <c:otherwise>
                            0
                        </c:otherwise>
                    </c:choose>
                </span>
                <span class="stat-label">Hình ảnh</span>
            </div>
        </div>

        <div class="article-content">
            <p>${news.content}</p>
        </div>

        <c:if test="${not empty news.imagePaths}">
            <div class="images-section">
                <h2 class="section-title">
                    <span>Hình ảnh</span>
                </h2>
                <div class="image-grid">
                    <c:forEach var="image" items="${news.imagePaths}">
                        <div class="image-item" onclick="openLightbox('${image}')">
                            <img src="${image}" alt="News Image"
                                 onerror="this.src='https://via.placeholder.com/300x200/1a1a1a/cccccc?text=IMAGE'">
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <div class="action-buttons">
            <a href="dashboard" class="btn btn-back">

                <span>Quay lại trang chủ</span>
            </a>
            <%-- CHỈ ADMIN VÀ SUPER ADMIN mới thấy nút chỉnh sửa --%>
            <c:if test="${not empty sessionScope.user && sessionScope.user.role >= 1}">
                <a href="news-edit?id=${news.id}" class="btn btn-edit">
                    <span>Chỉnh sửa</span>
                </a>
            </c:if>
        </div>
    </div>
</div>

<div id="lightbox" class="lightbox" onclick="closeLightbox()">
    <span class="lightbox-close" onclick="closeLightbox()">&times;</span>
    <div class="lightbox-content" onclick="event.stopPropagation()">
        <img id="lightbox-img" src="" alt="Lightbox Image">
    </div>
</div>

<script>
    function openLightbox(imageSrc) {
        const lightbox = document.getElementById('lightbox');
        const lightboxImg = document.getElementById('lightbox-img');
        lightboxImg.src = imageSrc;
        lightbox.style.display = 'block';
        document.body.style.overflow = 'hidden';
    }

    function closeLightbox() {
        const lightbox = document.getElementById('lightbox');
        lightbox.style.display = 'none';
        document.body.style.overflow = 'auto';
    }

    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeLightbox();
        }
    });

    function shareArticle() {
        if (navigator.share) {
            navigator.share({
                title: '${news.title}',
                text: '${news.content}',
                url: window.location.href
            }).catch(err => console.log('Error sharing:', err));
        } else {
            navigator.clipboard.writeText(window.location.href)
                .then(() => alert('Đã sao chép link bài viết!'))
                .catch(err => console.log('Error copying:', err));
        }
    }
</script>

<!-- Include Footer -->
<jsp:include page="/layouts/footer.jsp" />