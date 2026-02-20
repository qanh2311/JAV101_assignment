<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.pageTitle != null ? param.pageTitle : '📰 NEWS'}</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #000000;
            color: #ffffff;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        header {
            background: #0a0a0a;
            border-bottom: 2px solid #222;
            padding: 20px 0;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.5);
        }

        .header-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .logo-section h1 {
            font-size: 28px;
            color: #ffffff;
            cursor: pointer;
            transition: color 0.3s;
        }

        .logo-section h1:hover {
            color: #cccccc;
        }

        .nav-section {
            display: flex;
            align-items: center;
            gap: 30px;
            flex: 1;
            justify-content: center;
        }

        .menu {
            position: relative;
        }

        .menu ul {
            display: flex;
            list-style: none;
            gap: 15px;
            align-items: center;
        }

        .menu li {
            position: relative;
        }

        .menu a, .menu .dropdown-toggle {
            color: #cccccc;
            text-decoration: none;
            font-weight: 500;
            padding: 8px 15px;
            border-radius: 20px;
            background: #1a1a1a;
            display: flex;
            align-items: center;
            gap: 6px;
            text-align: center;
            font-size: 15px;
            transition: all 0.3s ease;
            cursor: pointer;
            border: none;
            white-space: nowrap;
        }

        .menu a:hover, .menu .dropdown-toggle:hover {
            color: #ffffff;
            background: #333333;
            transform: translateY(-1px);
        }

        /* Dropdown Menu Styles */
        .dropdown {
            position: relative;
        }

        .dropdown-menu {
            position: absolute;
            top: calc(100% + 10px);
            left: 0;
            background: #0a0a0a;
            border: 1px solid #333;
            border-radius: 8px;
            min-width: 200px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.8);
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .dropdown.active .dropdown-menu {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .dropdown-menu a {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 12px 16px;
            color: #cccccc;
            text-decoration: none;
            border-radius: 0;
            background: transparent;
            font-size: 14px;
            transition: all 0.2s;
            white-space: nowrap;
        }

        .dropdown-menu a:first-child {
            border-radius: 8px 8px 0 0;
        }

        .dropdown-menu a:last-child {
            border-radius: 0 0 8px 8px;
        }

        .dropdown-menu a:hover {
            background: #1a1a1a;
            color: #ffffff;
            transform: translateX(5px);
        }

        .dropdown-toggle::after {
            content: '▼';
            font-size: 10px;
            transition: transform 0.3s;
        }

        .dropdown.active .dropdown-toggle::after {
            transform: rotate(180deg);
        }

        .user-section {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .user-info {
            color: #cccccc;
            font-weight: 500;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        /* Badges cho roles */
        .super-admin-badge {
            background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%);
            color: #000000;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: bold;
            box-shadow: 0 2px 8px rgba(251, 191, 36, 0.3);
            animation: glow 2s infinite;
        }

        @keyframes glow {
            0%, 100% {
                box-shadow: 0 2px 8px rgba(251, 191, 36, 0.3);
            }
            50% {
                box-shadow: 0 2px 12px rgba(251, 191, 36, 0.6);
            }
        }

        .admin-badge {
            background: linear-gradient(135deg, #ffffff 0%, #e0e0e0 100%);
            color: #000000;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: bold;
        }

        .user-badge {
            background: #1a1a1a;
            color: #ffffff;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: bold;
            border: 1px solid #444;
        }

        .btn {
            padding: 8px 16px;
            background: #ffffff;
            color: #000000;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
            transition: all 0.3s;
            border: 2px solid #ffffff;
            font-size: 13px;
            display: inline-block;
            white-space: nowrap;
        }

        .btn:hover {
            background: #000000;
            color: #ffffff;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: #1a1a1a;
            color: #ffffff;
            border-color: #444;
        }

        .btn-secondary:hover {
            background: #ffffff;
            color: #000000;
            border-color: #ffffff;
        }

        main {
            flex: 1;
            max-width: 1400px;
            width: 100%;
            margin: 0 auto;
            padding: 50px 30px 60px 30px;
            min-height: calc(100vh - 200px);
        }

        .content-wrapper {
            width: 100%;
            max-width: 100%;
        }

        .menu-toggle {
            display: none;
            background: none;
            border: none;
            color: #ffffff;
            font-size: 24px;
            cursor: pointer;
        }

        @media (max-width: 1024px) {
            .nav-section {
                flex-direction: column;
                gap: 15px;
                width: 100%;
            }

            main {
                padding: 40px 25px 50px 25px;
            }
        }

        @media (max-width: 768px) {
            .header-container {
                flex-direction: column;
                align-items: flex-start;
            }

            .nav-section {
                width: 100%;
                display: none;
            }

            .nav-section.active {
                display: flex;
            }

            .menu ul {
                flex-direction: column;
                gap: 5px;
                width: 100%;
            }

            .menu li {
                width: 100%;
            }

            .menu a, .menu .dropdown-toggle {
                width: 100%;
                text-align: left;
                padding: 10px 20px;
                background: #222222;
                justify-content: flex-start;
            }

            .dropdown-menu {
                position: static;
                opacity: 1;
                visibility: visible;
                transform: none;
                box-shadow: none;
                border: none;
                border-left: 2px solid #444;
                margin-left: 20px;
                margin-top: 5px;
            }

            .dropdown-menu a {
                padding: 10px 20px;
            }

            .menu-toggle {
                display: block;
                position: absolute;
                right: 20px;
                top: 20px;
            }

            .user-section {
                width: 100%;
                justify-content: flex-start;
            }

            main {
                padding: 30px 20px 40px 20px;
            }
        }

        @media (max-width: 480px) {
            main {
                padding: 25px 15px 35px 15px;
            }

            .header-container {
                padding: 0 15px;
            }
        }
    </style>
</head>
<body>

<header>
    <div class="header-container">
        <div class="logo-section">
            <h1 onclick="window.location.href='dashboard'">NEWS</h1>
        </div>

        <button class="menu-toggle" onclick="toggleMenu()">☰</button>

        <div class="nav-section" id="navSection">
            <nav class="menu">
                <ul>
                    <li><a href="dashboard">Trang chủ</a></li>

                    <!-- Dropdown Danh mục -->
                    <li class="dropdown" id="categoryDropdown">
                        <button class="dropdown-toggle" onclick="toggleDropdown('categoryDropdown')">
                            Danh mục
                        </button>
                        <div class="dropdown-menu">
                            <a href="dashboard?action=category&category=Công nghệ">Công nghệ</a>
                            <a href="dashboard?action=category&category=Thể thao">Thể thao</a>
                            <a href="dashboard?action=category&category=Giải trí">Giải trí</a>
                            <a href="dashboard?action=category&category=Kinh tế">Kinh tế</a>
                            <a href="dashboard?action=category&category=Giáo dục">Giáo dục</a>
                            <a href="dashboard?action=category&category=Sức khỏe">Sức khỏe</a>
                        </div>
                    </li>

                    <li><a href="dashboard?action=trending">Xu hướng</a></li>
                    <li><a href="dashboard?action=recommended">⭐ Gợi ý theo hành vi</a></li>
                </ul>
            </nav>
        </div>

        <div class="user-section">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <span class="user-info">
                        ${sessionScope.user.username}

                        <c:choose>
                            <c:when test="${sessionScope.user.role == 2}">
                                <span class="super-admin-badge">SUPER ADMIN</span>
                            </c:when>
                            <c:when test="${sessionScope.user.role == 1}">
                                <span class="admin-badge">⚡ ADMIN</span>
                            </c:when>
                            <c:otherwise>
                                <span class="user-badge">USER</span>
                            </c:otherwise>
                        </c:choose>
                    </span>

                    <c:if test="${sessionScope.user.role >= 1}">
                        <a href="news-list" class="btn btn-secondary">Quản lý tin</a>

                        <c:if test="${sessionScope.user.role == 2}">
                            <a href="user-list" class="btn btn-secondary">Quản lý user</a>
                        </c:if>
                    </c:if>

                    <a href="logout" class="btn">Đăng xuất</a>
                </c:when>

                <c:otherwise>
                    <span class="user-info">
                        Khách
                        <span class="user-badge">GUEST</span>
                    </span>
                    <a href="login" class="btn">Đăng nhập</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<script>
    function toggleMenu() {
        const navSection = document.getElementById('navSection');
        navSection.classList.toggle('active');
    }

    function toggleDropdown(dropdownId) {
        const dropdown = document.getElementById(dropdownId);
        const allDropdowns = document.querySelectorAll('.dropdown');


        allDropdowns.forEach(d => {
            if (d.id !== dropdownId) {
                d.classList.remove('active');
            }
        });

        // Toggle dropdown hiện tại
        dropdown.classList.toggle('active');
    }

    // Đóng dropdown khi click bên ngoài
    document.addEventListener('click', function(event) {
        const dropdowns = document.querySelectorAll('.dropdown');
        const isClickInsideDropdown = event.target.closest('.dropdown');

        if (!isClickInsideDropdown) {
            dropdowns.forEach(dropdown => {
                dropdown.classList.remove('active');
            });
        }
    });
</script>