<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Include Header -->
<jsp:include page="/layouts/header.jsp">
    <jsp:param name="pageTitle" value="Quản lý người dùng" />
</jsp:include>

<style>
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
        flex-wrap: wrap;
        gap: 20px;
    }

    .page-title {
        font-size: 32px;
        color: #ffffff;
    }

    .btn-add {
        padding: 12px 24px;
        background: #ffffff;
        color: #000000;
        text-decoration: none;
        border-radius: 6px;
        font-weight: bold;
        transition: all 0.3s;
        border: 2px solid #ffffff;
    }

    .btn-add:hover {
        background: #000000;
        color: #ffffff;
        transform: translateY(-2px);
    }

    .table-container {
        background: #0a0a0a;
        border-radius: 12px;
        overflow: hidden;
        border: 1px solid #222;
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    thead {
        background: #1a1a1a;
    }

    th {
        padding: 16px;
        text-align: left;
        color: #ffffff;
        font-weight: 600;
        border-bottom: 2px solid #333;
        text-transform: uppercase;
        font-size: 13px;
        letter-spacing: 0.5px;
    }

    td {
        padding: 16px;
        border-bottom: 1px solid #222;
        color: #cccccc;
    }

    tbody tr {
        transition: all 0.3s;
    }

    tbody tr:hover {
        background: #1a1a1a;
    }

    tbody tr:last-child td {
        border-bottom: none;
    }

    /* Highlight row của chính mình */
    tbody tr.current-user {
        background: #1a2a1a;
    }

    tbody tr.current-user:hover {
        background: #1f3f1f;
    }

    .role-badge,
    .status-badge {
        display: inline-block;
        padding: 5px 12px;
        border-radius: 4px;
        font-size: 12px;
        font-weight: bold;
    }

    .role-super-admin {
        background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%);
        color: #000000;
        box-shadow: 0 2px 8px rgba(251, 191, 36, 0.3);
    }

    .role-admin {
        background: #ffffff;
        color: #000000;
    }

    .role-user {
        background: #333;
        color: #999;
    }

    .status-active {
        background: #4ade80;
        color: #000000;
    }

    .status-locked {
        background: #ef4444;
        color: #ffffff;
    }

    .actions {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
    }

    .actions a,
    .actions span {
        padding: 6px 12px;
        background: #1a1a1a;
        color: #ffffff;
        text-decoration: none;
        border-radius: 4px;
        font-size: 13px;
        border: 1px solid #333;
        transition: all 0.3s;
    }

    .actions a:hover {
        background: #ffffff;
        color: #000000;
        border-color: #ffffff;
    }

    .actions span {
        color: #666;
        cursor: not-allowed;
    }

    .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: #666;
    }

    .note-protected {
        color: #999;
        font-size: 12px;
        font-style: italic;
    }

    @media (max-width: 768px) {
        .table-container {
            overflow-x: auto;
        }

        table {
            min-width: 700px;
        }

        .page-header {
            flex-direction: column;
            align-items: flex-start;
        }
    }
</style>

<div class="page-header">
    <h2 class="page-title">Quản lý người dùng</h2>
    <a href="user-add" class="btn-add">Thêm người dùng</a>
</div>

<div class="table-container">
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Tài khoản</th>
            <th>Vai trò</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${not empty userList}">
                <c:forEach var="user" items="${userList}">
                    <tr class="${user.id == currentUserId ? 'current-user' : ''}">
                        <td>${user.id}</td>
                        <td>
                            ${user.username}
                            <c:if test="${user.id == currentUserId}">
                                <span style="color: #4ade80; font-weight: bold;"> (Bạn)</span>
                            </c:if>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${user.role == 2}">
                                    <span class="role-badge role-super-admin">Super Admin</span>
                                </c:when>
                                <c:when test="${user.role == 1}">
                                    <span class="role-badge role-admin">Admin</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="role-badge role-user">User</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <span class="status-badge ${user.active ? 'status-active' : 'status-locked'}">
                                    ${user.active ? 'Hoạt động' : 'Đã khóa'}
                            </span>
                        </td>
                        <td>
                            <div class="actions">
                                <c:choose>
                                    <c:when test="${user.id == currentUserId}">
                                        <span class="note-protected">Không thể tự chỉnh sửa</span>
                                    </c:when>

                                    <c:otherwise>
                                        <a href="user-edit?id=${user.id}">Sửa</a>

                                        <c:choose>
                                            <c:when test="${user.active}">
                                                <a href="user-lock?id=${user.id}"
                                                   onclick="return confirm('Bạn có chắc muốn khóa người dùng ${user.username}?')">
                                                    Khóa
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span>Đã khóa</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr>
                    <td colspan="5" class="empty-state">
                        Chưa có người dùng nào
                    </td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>


<jsp:include page="/layouts/footer.jsp" />