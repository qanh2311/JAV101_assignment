<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Include Header -->
<jsp:include page="/layouts/header.jsp">
    <jsp:param name="pageTitle" value="Chỉnh sửa người dùng" />
</jsp:include>

<style>
    .container {
        max-width: 600px;
        margin: 0 auto;
    }

    h2 {
        color: #ffffff;
        font-size: 32px;
        margin-bottom: 30px;
        text-align: center;
    }

    .form-box {
        background: #0a0a0a;
        padding: 40px;
        border-radius: 12px;
        border: 1px solid #222;
    }

    label {
        display: block;
        margin-bottom: 8px;
        color: #cccccc;
        font-weight: 500;
        font-size: 14px;
    }

    input[type="text"],
    input[type="password"],
    input[type="hidden"],
    select {
        width: 100%;
        padding: 12px 16px;
        background: #1a1a1a;
        border: 1px solid #333;
        color: #ffffff;
        border-radius: 6px;
        font-size: 14px;
        margin-bottom: 20px;
        font-family: inherit;
        transition: all 0.3s;
    }

    input:focus,
    select:focus {
        outline: none;
        border-color: #666;
        background: #222;
    }

    select {
        cursor: pointer;
    }

    select option {
        background: #1a1a1a;
        color: #ffffff;
        padding: 10px;
    }

    .button-group {
        display: flex;
        gap: 15px;
        margin-top: 30px;
    }

    input[type="submit"],
    .btn-back {
        flex: 1;
        padding: 14px;
        border: 2px solid #ffffff;
        border-radius: 6px;
        cursor: pointer;
        font-size: 16px;
        font-weight: bold;
        transition: all 0.3s;
        text-decoration: none;
        text-align: center;
        display: inline-block;
    }

    input[type="submit"] {
        background: #ffffff;
        color: #000000;
    }

    input[type="submit"]:hover {
        background: #000000;
        color: #ffffff;
        transform: translateY(-2px);
    }

    .btn-back {
        background: #1a1a1a;
        color: #ffffff;
    }

    .btn-back:hover {
        background: #ffffff;
        color: #000000;
        transform: translateY(-2px);
    }

    .info-note {
        background: #1a1a1a;
        border-left: 4px solid #f59e0b;
        padding: 12px 16px;
        margin-bottom: 20px;
        border-radius: 4px;
        color: #cccccc;
        font-size: 14px;
    }

    @media (max-width: 768px) {
        .form-box {
            padding: 30px 20px;
        }

        .button-group {
            flex-direction: column;
        }
    }
</style>

<div class="container">
    <h2>Chỉnh Sửa Người Dùng</h2>

    <div class="form-box">
        <div class="info-note">
             <strong>Lưu ý:</strong> Không thể chỉnh sửa vai trò thành Super Admin.
        </div>

        <form action="user-edit" method="POST">
            <input type="hidden" name="id" value="${user.id}">

            <label for="username">Tài Khoản:</label>
            <input type="text" id="username" name="username" value="${user.username}" required>

            <label for="password">Mật Khẩu:</label>
            <input type="password" id="password" name="password" value="${user.password}" required>


            <label for="role">Vai Trò:</label>
            <select name="role" id="role">
                <option value="0" ${user.role == 0 ? 'selected' : ''}>👤 User</option>
                <option value="1" ${user.role == 1 ? 'selected' : ''}>⚡ Admin</option>
            </select>

            <label for="active">Trạng Thái:</label>
            <select name="active" id="active">
                <option value="1" ${user.active ? 'selected' : ''}>Hoạt động</option>
                <option value="0" ${user.active ? '' : 'selected'}>Khóa</option>
            </select>

            <div class="button-group">
                <input type="submit" value="💾 Cập Nhật">
                <a href="user-list" class="btn-back">Quay lại</a>
            </div>
        </form>
    </div>
</div>


<jsp:include page="/layouts/footer.jsp" />