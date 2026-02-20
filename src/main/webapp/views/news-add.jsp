<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Include Header -->
<jsp:include page="/layouts/header.jsp">
    <jsp:param name="pageTitle" value="Thêm bài viết" />
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

    .form-group:nth-child(1) { animation-delay: 0.1s; }
    .form-group:nth-child(2) { animation-delay: 0.15s; }
    .form-group:nth-child(3) { animation-delay: 0.2s; }
    .form-group:nth-child(4) { animation-delay: 0.25s; }
    .form-group:nth-child(5) { animation-delay: 0.3s; }
    .form-group:nth-child(6) { animation-delay: 0.35s; }

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

    select option {
        background: #0a0a0a;
        color: #ffffff;
        padding: 10px;
    }

    /* File Upload Styling */
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

    .preview-container {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
        gap: 15px;
        margin-top: 15px;
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
        background: linear-gradient(135deg, #ffffff 0%, #e0e0e0 100%);
        color: #000000;
        border-color: #ffffff;
    }

    .btn-submit:hover {
        background: #000000;
        color: #ffffff;
        transform: translateY(-3px);
        box-shadow: 0 6px 20px rgba(255, 255, 255, 0.3);
    }

    .btn-submit:active {
        transform: translateY(-1px);
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

    /* Loading State */
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
        border-top-color: #000000;
        border-radius: 50%;
        animation: spin 0.8s linear infinite;
        right: 20px;
    }

    @keyframes spin {
        to { transform: rotate(360deg); }
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

        input[type="text"],
        textarea,
        select {
            font-size: 16px;
        }
    }
</style>

<div class="form-container">
    <h2 class="page-title">
        <span>Thêm bài viết mới</span>
    </h2>

    <div class="form-box">
        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="error-message">
                <span style="font-size: 20px;"></span>
                <span>${error}</span>
            </div>
        </c:if>

        <form action="news-add" method="POST" enctype="multipart/form-data" id="newsForm">
            <div class="form-group">
                <label for="title">
                    <span>Tiêu đề</span>
                    <span class="required">*</span>
                </label>
                <input type="text"
                       id="title"
                       name="title"
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
                          oninput="updateCharCount('content', 'contentCount', 5000)"></textarea>
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
                    <option value="">-- Chọn danh mục --</option>
                    <option value="Công nghệ">Công nghệ</option>
                    <option value="Thể thao">Thể thao</option>
                    <option value="Giải trí">Giải trí</option>
                    <option value="Kinh tế">Kinh tế</option>
                    <option value="Giáo dục">Giáo dục</option>
                    <option value="Sức khỏe">Sức khỏe</option>
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
                       required
                       maxlength="100"
                       placeholder="Nhập tên tác giả...">
            </div>

            <div class="form-group">
                <label for="images">
                    <span>Hình ảnh</span>
                </label>
                <input type="file"
                       id="images"
                       name="images"
                       accept="image/*"
                       multiple
                       onchange="previewImages(event)">
                <div class="form-hint">
                    Có thể chọn nhiều ảnh. Nếu không chọn, hệ thống sẽ dùng ảnh mặc định theo danh mục
                </div>
                <div id="preview" class="preview-container"></div>
            </div>

            <div class="form-group">
                <label for="trending">
                    <span>Trạng thái</span>
                </label>
                <select name="trending" id="trending">
                    <option value="1">HOT - Xu hướng</option>
                    <option value="0" selected>Bình thường</option>
                </select>
                <div class="form-hint">
                    Bài viết HOT sẽ được hiển thị nổi bật trên trang chủ
                </div>
            </div>

            <div class="button-group">
                <button type="submit" class="btn btn-submit" id="submitBtn">
                    <span>Thêm bài viết</span>
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

    function previewImages(event) {
        const preview = document.getElementById('preview');
        const files = Array.from(event.target.files);

        // Add new files to selected files
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

    function updateCharCount(inputId, counterId, maxLength) {
        const input = document.getElementById(inputId);
        const counter = document.getElementById(counterId);
        const length = input.value.length;
        counter.textContent = length;

        // Change color when near limit
        if (length > maxLength * 0.9) {
            counter.style.color = '#ef4444';
        } else if (length > maxLength * 0.7) {
            counter.style.color = '#fbbf24';
        } else {
            counter.style.color = '#666';
        }
    }

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
        submitBtn.querySelector('span:last-child').textContent = 'Đang xử lý...';
    });


    window.addEventListener('DOMContentLoaded', function() {
        updateCharCount('title', 'titleCount', 200);
        updateCharCount('content', 'contentCount', 5000);
    });
</script>


<jsp:include page="/layouts/footer.jsp" />