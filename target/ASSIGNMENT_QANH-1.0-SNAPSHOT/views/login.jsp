<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="lang" value="${sessionScope.lang != null ? sessionScope.lang : 'vi'}" />

<!DOCTYPE html>
<html lang="${lang}">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${lang == 'en' ? 'Login' : 'Đăng nhập'} - NEWS</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #000;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        .form-box {
            background: #1a1a1a;
            padding: 40px;
            border-radius: 12px;
            border: 2px solid #333;
            width: 100%;
            max-width: 400px;
            color: white;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.6);
            position: relative;
        }

        .language-switcher {
            position: absolute;
            top: 15px;
            right: 15px;
            display: flex;
            gap: 8px;
        }

        .lang-btn {
            padding: 6px 12px;
            background: #2a2a2a;
            border: 1px solid #444;
            color: #ccc;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .lang-btn:hover {
            background: #333;
            color: #fff;
            border-color: #666;
        }

        .lang-btn.active {
            background: #ffffff;
            color: #000;
            border-color: #ffffff;
            font-weight: bold;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: white;
            font-size: 28px;
        }

        .error-message {
            background: #ff4444;
            color: white;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 14px;
            display: none;
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .error-message.show {
            display: block;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #ccc;
            font-weight: 500;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px 15px;
            background: #2a2a2a;
            border: 1px solid #444;
            color: white;
            border-radius: 8px;
            outline: none;
            margin-bottom: 20px;
            font-size: 14px;
            transition: all 0.3s;
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            border-color: #666;
            background: #333;
        }

        /* Checkbox "Remember Me" */
        .remember-me {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            gap: 8px;
        }

        .remember-me input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            margin: 0;
        }

        .remember-me label {
            margin: 0;
            cursor: pointer;
            font-size: 14px;
            color: #ccc;
        }

        button {
            width: 100%;
            padding: 12px 15px;
            background: #ffffff;
            border: none;
            color: #000000;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.3s;
        }

        button:hover {
            background: #cccccc;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 255, 255, 0.2);
        }

        .back-link {
            text-align: center;
            margin-top: 20px;
        }

        .back-link a {
            color: #cccccc;
            text-decoration: none;
            transition: color 0.3s;
        }

        .back-link a:hover {
            color: #ffffff;
        }

        @media (max-width: 480px) {
            .form-box {
                padding: 30px 20px;
            }

            h2 {
                font-size: 24px;
            }
        }

        .login-hint-bottom {
            margin-top: 12px;
            font-size: 12px;
            color: #aaa;
            text-align: center;
            line-height: 1.6;
        }

        .login-hint-bottom strong {
            color: #fff;
        }

        .login-hint-bottom .open {
            color: #4caf50;
            margin-left: 4px;
        }

        .login-hint-bottom .locked {
            color: #ff5252;
            text-decoration: line-through;
        }
    </style>
</head>
<body>
<div class="form-box">
    <!-- Language Switcher -->
    <div class="language-switcher">
        <a href="login?lang=vi" class="lang-btn ${lang == 'vi' ? 'active' : ''}">VI</a>
        <a href="login?lang=en" class="lang-btn ${lang == 'en' ? 'active' : ''}">EN</a>
    </div>

    <h2>
        📰
        <c:choose>
            <c:when test="${lang == 'en'}">Login</c:when>
            <c:otherwise>Đăng nhập</c:otherwise>
        </c:choose>
    </h2>

    <c:if test="${not empty error}">
        <div class="error-message show">${error}</div>
    </c:if>

    <form action="login" method="POST" accept-charset="UTF-8">
        <label for="username">
            <c:choose>
                <c:when test="${lang == 'en'}">Username:</c:when>
                <c:otherwise>Tên đăng nhập:</c:otherwise>
            </c:choose>
        </label>
        <input type="text"
               id="username"
               name="username"
               required
               autocomplete="username">

        <label for="password">
            <c:choose>
                <c:when test="${lang == 'en'}">Password:</c:when>
                <c:otherwise>Mật khẩu:</c:otherwise>
            </c:choose>
        </label>
        <input type="password"
               id="password"
               name="password"
               required
               autocomplete="current-password">

        <!-- Checkbox "Remember Me" -->
        <div class="remember-me">
            <input type="checkbox" id="rememberMe" name="rememberMe">
            <label for="rememberMe">
                <c:choose>
                    <c:when test="${lang == 'en'}">Remember me</c:when>
                    <c:otherwise>Ghi nhớ đăng nhập</c:otherwise>
                </c:choose>
            </label>
        </div>

        <button type="submit">
            <c:choose>
                <c:when test="${lang == 'en'}">Login</c:when>
                <c:otherwise>Đăng nhập</c:otherwise>
            </c:choose>
        </button>
    </form>

    <div class="back-link">
        <a href="dashboard">
            <c:choose>
                <c:when test="${lang == 'en'}">← Back to home</c:when>
                <c:otherwise>← Quay lại trang chủ</c:otherwise>
            </c:choose>
        </a>
    </div>

    <div class="login-hint-bottom">
        <c:choose>
            <c:when test="${lang == 'en'}">
                <span><strong>Super Admin</strong>: admin | admin</span>
                <span class="open">• Unlocked</span>
                <br>
                <span><strong>Admin</strong>: manager | 123</span>
                <span class="open">• Unlocked</span>
                <br>
                <span><strong>User1</strong>: user1 | 123</span>
                <span class="open">• Unlocked</span>
                <br>
                <span class="locked"><strong>User2</strong>: user2 | 123 • Locked</span>
            </c:when>
            <c:otherwise>
                <span><strong>Super Admin</strong>: admin | admin</span>
                <span class="open">• Mở khóa</span>
                <br>
                <span><strong>Admin</strong>: manager | 123</span>
                <span class="open">• Mở khóa</span>
                <br>
                <span><strong>User1</strong>: user1 | 123</span>
                <span class="open">• Mở khóa</span>
                <br>
                <span class="locked"><strong>User2</strong>: user2 | 123 • Đã khóa</span>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    // Tự động focus vào username
    window.addEventListener('DOMContentLoaded', function() {
        document.getElementById('username').focus();
    });
</script>
</body>
</html>