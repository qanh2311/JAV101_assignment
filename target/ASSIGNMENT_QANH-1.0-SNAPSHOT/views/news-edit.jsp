<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Include Header -->
<jsp:include page="/layouts/header.jsp">
    <jsp:param name="pageTitle" value="Chỉnh sửa bài viết" />
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

    .form-container {
        max-width: 900px;
        margin: 0 auto;
        animation: fadeInUp 0.6s ease;
    }

    .page-title {
        color: #ffffff;
        font-size: 32px;
        margin-bottom: 30px;
        text-align: center;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12px;
        animation: fadeInDown 0.6s ease;
    }

    .form-box {
        background: linear-gradient(135deg, #0a0a0a 0%, #1a1a1a 100%);
        padding: 40px;
        border-radius: 12px;
        border: 1px solid #222;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
    }

    .form-group {
        margin-bottom: 24px;
        animation: fadeInUp 0.6s ease;
    }

    label {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 10px;
        color: #ffffff;
        font-weight: 600;
        font-size: 15px;
    }

    .required {
        color: #ef4444;
        font-size: 14px;
    }

    input[type="text"],
    input[type="file"],
    textarea,
    select {
        width: 100%;
        padding: 14px 18px;
        background: #0a0a0a;
        border: 2px solid #333;
        color: #ffffff;
        border-radius: 8px;
        font-size: 14px;
        font-family: inherit;
        transition: all 0.3s ease;
    }

    input:focus,
    textarea:focus,
    select:focus {
        outline: none;
        border-color: #ffffff;
        background: #1a1a1a;
        box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.1);
    }

    textarea {
        min-height: 180px;
        resize: vertical;
        line-height: 1.6;
    }

    select {
        cursor: pointer;
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23ffffff' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 16px center;
        padding-right: 40px;
    }

    input[type="file"] {
        padding: 12px;
        cursor: pointer;
    }

    input[type="file"]::file-selector-button {
        padding: 10px 20px;
        background: linear-gradient(135deg, #4a8aca 0%, #2a6aaa 100%);
        color: #ffffff;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-weight: bold;
        margin-right: 15px;
        transition: all 0.3s;
    }

    input[type="file"]::file-selector-button:hover {
        background: linear-gradient(135deg, #5a9ada 0%, #3a7aba 100%);
        transform: translateY(-2px);
    }

    .current-images {
        margin-top: 15px;
    }

    .current-images-title {
        color: #64b5f6;
        font-size: 14px;
        font-weight: 600;
        margin-bottom: 10px;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .preview-container {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
        gap: 15px;
        margin-top: 10px;
    }

    .preview-item {
        position: relative;
        border-radius: 8px;
        overflow: hidden;
        border: 2px solid #333;
        background: #0a0a0a;
    }

    .preview-item img {
        width: 100%;
        height: 150px;
        object-fit: cover;
    }

    .preview-item .remove-btn {
        position: absolute;
        top: 5px;
        right: 5px;
        background: #ef4444;
        color: #ffffff;
        border: none;
        border-radius: 50%;
        width: 25px;
        height: 25px;
        cursor: pointer;
        font-size: 16px;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s;
    }

    .preview-item .remove-btn:hover {
        background: #dc2626;
        transform: scale(1.1);
    }

    .image-options {
        display: flex;
        gap: 15px;
        margin-top: 15px;
        padding: 15px;
        background: #1a1a1a;
        border-radius: 8px;
        border: 2px solid #333;
    }

    .image-option {
        flex: 1;
    }

    .image-option input[type="radio"] {
        width: auto;
        margin-right: 8px;
    }

    .image-option label {
        margin: 0;
        cursor: pointer;
        font-size: 14px;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .char-counter {
        text-align: right;
        font-size: 12px;
        color: #666;
        margin-top: 5px;
    }

    .error-message {
        background: linear-gradient(135deg, #5a1a1a 0%, #3a0a0a 100%);
        color: #ff6b6b;
        padding: 16px 20px;
        border-radius: 8px;
        margin-bottom: 24px;
        border: 1px solid #8a2a2a;
        display: flex;
        align-items: center;
        gap: 12px;
        animation: shake 0.5s ease;
    }

    @keyframes shake {
        0%, 100% { transform: translateX(0); }
        25% { transform: translateX(-10px); }
        75% { transform: translateX(10px); }
    }

    .info-box {
        background: linear-gradient(135deg, #1a3a5a 0%, #0a2a4a 100%);
        padding: 16px 20px;
        border-radius: 8px;
        margin-bottom: 24px;
        border: 1px solid #2a5a8a;
        display: flex;
        align-items: center;
        gap: 12px;
        color: #64b5f6;
    }

    .warning-box {
        background: linear-gradient(135deg, #5a4a1a 0%, #3a2a0a 100%);
        padding: 16px 20px;
        border-radius: 8px;
        margin-bottom: 24px;
        border: 1px solid #8a6a2a;
        display: flex;
        align-items: center;
        gap: 12px;
        color: #fbbf24;
    }

    .button-group {
        display: flex;
        gap: 15px;
        margin-top: 35px;
        animation: fadeInUp 0.6s ease 0.4s both;
    }

    .btn {
        flex: 1;
        padding: 16px;
        border: 2px solid;
        border-radius: 8px;
        cursor: pointer;
        font-size: 16px;
        font-weight: bold;
        transition: all 0.3s ease;
        text-decoration: none;
        text-align: center;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
    }

    .btn-submit {
        background: linear-gradient(135deg, #4a8aca 0%, #2a6aaa 100%);
        color: #ffffff;
        border-color: #4a8aca;
    }

    .btn-submit:hover {
        background: linear-gradient(135deg, #5a9ada 0%, #3a7aba 100%);
        transform: translateY(-3px);
        box-shadow: 0 6px 20px rgba(74, 138, 202, 0.4);
    }

    .btn-back {
        background: #0a0a0a;
        color: #ffffff;
        border-color: #444;
    }

    .btn-back:hover {
        background: #ffffff;
        color: #000000;
        border-color: #ffffff;
        transform: translateY(-3px);
        box-shadow: 0 6px 20px rgba(255, 255, 255, 0.2);
    }

    .form-hint {
        font-size: 13px;
        color: #999;
        margin-top: 6px;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .btn-submit.loading {
        pointer-events: none;
        opacity: 0.7;
        position: relative;
    }

    .btn-submit.loading::after {
        content: '';
        position: absolute;
        width: 16px;
        height: 16px;
        border: 2px solid transparent;
        border-top-color: #ffffff;
        border-radius: 50%;
        animation: spin 0.8s linear infinite;
        right: 20px;
    }

    @keyframes spin {
        to { transform: rotate(360deg); }
    }

    .auto-hot-badge {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 6px 12px;
        background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%);
        color: #000000;
        border-radius: 6px;
        font-size: 12px;
        font-weight: bold;
    }

    @media (max-width: 768px) {
        .form-box {
            padding: 30px 20px;
        }

        .page-title {
            font-size: 24px;
        }

        .button-group {
            flex-direction: column;
        }

        .image-options {
            flex-direction: column;
        }
    }
</style>

<div class="form-container">
    <h2 class="page-title">
        <span>Chỉnh sửa bài viết</span>
    </h2>

    <div class="form-box">
        <!-- Info Box -->
        <div class="info-box">
            <span>Đang chỉnh sửa bài viết #${news.id}: <strong>${news.title}</strong></span>
        </div>


        <c:if test="${news.views >= 1000}">
            <div class="warning-box">
                <span>Bài viết này có <strong>${news.views}</strong> lượt xem (≥1000) nên được tự động đánh dấu <span class="auto-hot-badge">🔥 HOT</span></span>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="error-message">
                <span>${error}</span>
            </div>
        </c:if>

        <form action="news-edit" method="POST" enctype="multipart/form-data" id="newsForm">
            <input type="hidden" name="id" value="${news.id}">

            <div class="form-group">
                <label for="title">
                    <span>Tiêu đề</span>
                    <span class="required">*</span>
                </label>
                <input type="text"
                       id="title"
                       name="title"
                       value="${news.title}"
                       required
                       maxlength="200"
                       placeholder="Nhập tiêu đề hấp dẫn cho bài viết..."
                       oninput="updateCharCount('title', 'titleCount', 200)">
                <div class="char-counter">
                    <span id="titleCount">0</span>/200 ký tự
                </div>
            </div>

            <div class="form-group">
                <label for="content">
                    <span>Nội dung</span>
                    <span class="required">*</span>
                </label>
                <textarea id="content"
                          name="content"
                          required
                          maxlength="5000"
                          placeholder="Nhập nội dung chi tiết cho bài viết..."
                          oninput="updateCharCount('content', 'contentCount', 5000)">${news.content}</textarea>
                <div class="char-counter">
                    <span id="contentCount">0</span>/5000 ký tự
                </div>
            </div>

            <div class="form-group">
                <label for="category">
                    <span>Danh mục</span>
                    <span class="required">*</span>
                </label>
                <select id="category" name="category" required>
                    <option value="Công nghệ" ${news.category == 'Công nghệ' ? 'selected' : ''}>💻 Công nghệ</option>
                    <option value="Thể thao" ${news.category == 'Thể thao' ? 'selected' : ''}>⚽ Thể thao</option>
                    <option value="Giải trí" ${news.category == 'Giải trí' ? 'selected' : ''}>🎬 Giải trí</option>
                    <option value="Kinh tế" ${news.category == 'Kinh tế' ? 'selected' : ''}>💰 Kinh tế</option>
                    <option value="Giáo dục" ${news.category == 'Giáo dục' ? 'selected' : ''}>📚 Giáo dục</option>
                    <option value="Sức khỏe" ${news.category == 'Sức khỏe' ? 'selected' : ''}>🏥 Sức khỏe</option>
                </select>
            </div>

            <div class="form-group">
                <label for="author">
                    <span>Tác giả</span>
                    <span class="required">*</span>
                </label>
                <input type="text"
                       id="author"
                       name="author"
                       value="${news.author}"
                       required
                       maxlength="100"
                       placeholder="Nhập tên tác giả...">
            </div>

            <div class="form-group">
                <label>
                    <span>Hình ảnh</span>
                </label>

                <c:if test="${not empty news.imagePaths}">
                    <div class="current-images">
                        <div class="current-images-title">
                            <span>Ảnh hiện tại:</span>
                        </div>
                        <div class="preview-container">
                            <c:forEach var="image" items="${news.imagePaths}">
                                <div class="preview-item">
                                    <img src="${pageContext.request.contextPath}${image}"
                                         alt="Current Image"
                                         onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'">
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <div class="image-options">
                    <div class="image-option">
                        <label>
                            <input type="radio" name="imageAction" value="keep" checked onchange="toggleImageUpload()">
                            <span>Giữ ảnh cũ</span>
                        </label>
                    </div>
                    <div class="image-option">
                        <label>
                            <input type="radio" name="imageAction" value="change" onchange="toggleImageUpload()">
                            <span>Thay đổi ảnh</span>
                        </label>
                    </div>
                </div>

                <!-- Upload ảnh mới (ẩn mặc định) -->
                <div id="uploadSection" style="display: none; margin-top: 15px;">
                    <input type="file"
                           id="images"
                           name="images"
                           accept="image/*"
                           multiple
                           onchange="previewImages(event)">
                    <div class="form-hint">
                        Chọn ảnh mới để thay thế. Ảnh cũ sẽ bị xóa
                    </div>
                    <div id="newPreview" class="preview-container"></div>
                </div>

                <input type="hidden" id="keepOldImages" name="keepOldImages" value="true">
            </div>

            <div class="form-group">
                <label>
                    <span>Lượt xem</span>
                </label>
                <div style="background: #1a1a1a; padding: 14px 18px; border: 2px solid #333; border-radius: 8px; color: #ffffff;">
                    <strong>${news.views}</strong> lượt xem
                </div>
                <div class="form-hint">
                    Số lượt xem được tự động cập nhật khi người dùng xem bài viết
                </div>
            </div>

            <div class="form-group">
                <label>
                    <span>Trạng thái</span>
                </label>
                <div style="background: #1a1a1a; padding: 14px 18px; border: 2px solid #333; border-radius: 8px; color: #ffffff;">
                    <c:choose>
                        <c:when test="${news.views >= 1000}">
                            <span style="display: inline-flex; align-items: center; gap: 8px;">
                                <strong style="color: #fbbf24;">HOT - Xu hướng</strong>
                                <span style="color: #999; font-size: 13px;">(Tự động vì views ≥ 1000)</span>
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span style="display: inline-flex; align-items: center; gap: 8px;">
                                <strong>Bình thường</strong>
                                <span style="color: #999; font-size: 13px;">(Cần ${1000 - news.views} views nữa để HOT)</span>
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="form-hint">
                    Trạng thái tự động: Views ≥ 1000 → HOT, Views < 1000 → Bình thường
                </div>
            </div>

            <div class="button-group">
                <button type="submit" class="btn btn-submit" id="submitBtn">
                    <span>Cập nhật</span>
                </button>
                <a href="news-list" class="btn btn-back">
                    <span>Quay lại</span>
                </a>
            </div>
        </form>
    </div>
</div>

<script>
    let selectedFiles = [];

    // Toggle image upload section
    function toggleImageUpload() {
        const action = document.querySelector('input[name="imageAction"]:checked').value;
        const uploadSection = document.getElementById('uploadSection');
        const keepOldImagesInput = document.getElementById('keepOldImages');

        if (action === 'change') {
            uploadSection.style.display = 'block';
            keepOldImagesInput.value = 'false';
        } else {
            uploadSection.style.display = 'none';
            keepOldImagesInput.value = 'true';
            // Clear selected files
            document.getElementById('images').value = '';
            document.getElementById('newPreview').innerHTML = '';
            selectedFiles = [];
        }
    }

    // Preview new images
    function previewImages(event) {
        const preview = document.getElementById('newPreview');
        const files = Array.from(event.target.files);

        selectedFiles = [...selectedFiles, ...files];
        preview.innerHTML = '';

        selectedFiles.forEach((file, index) => {
            const reader = new FileReader();

            reader.onload = function(e) {
                const div = document.createElement('div');
                div.className = 'preview-item';
                div.innerHTML = `
                    <img src="${e.target.result}" alt="Preview">
                    <button type="button" class="remove-btn" onclick="removeImage(${index})">×</button>
                `;
                preview.appendChild(div);
            };

            reader.readAsDataURL(file);
        });
    }

    function removeImage(index) {
        selectedFiles.splice(index, 1);
        const dt = new DataTransfer();
        selectedFiles.forEach(file => dt.items.add(file));
        document.getElementById('images').files = dt.files;

        const event = { target: { files: selectedFiles } };
        previewImages(event);
    }

    // Update character count
    function updateCharCount(inputId, counterId, maxLength) {
        const input = document.getElementById(inputId);
        const counter = document.getElementById(counterId);
        const length = input.value.length;
        counter.textContent = length;

        if (length > maxLength * 0.9) {
            counter.style.color = '#ef4444';
        } else if (length > maxLength * 0.7) {
            counter.style.color = '#fbbf24';
        } else {
            counter.style.color = '#666';
        }
    }

    // Form validation and loading state
    document.getElementById('newsForm').addEventListener('submit', function(e) {
        const submitBtn = document.getElementById('submitBtn');
        const title = document.getElementById('title').value.trim();
        const content = document.getElementById('content').value.trim();
        const category = document.getElementById('category').value;
        const author = document.getElementById('author').value.trim();

        if (!title || !content || !category || !author) {
            e.preventDefault();
            alert('Vui lòng điền đầy đủ thông tin!');
            return;
        }

        submitBtn.classList.add('loading');
        submitBtn.querySelector('span:last-child').textContent = 'Đang cập nhật...';
    });

    // Initialize
    window.addEventListener('DOMContentLoaded', function() {
        updateCharCount('title', 'titleCount', 200);
        updateCharCount('content', 'contentCount', 5000);
    });
</script>

<!-- Include Footer -->
<jsp:include page="/layouts/footer.jsp" />