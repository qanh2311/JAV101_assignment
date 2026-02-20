<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khóa Người Dùng</title>
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
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .message-box {
            background: #0a0a0a;
            padding: 50px 40px;
            border-radius: 12px;
            border: 1px solid #222;
            text-align: center;
            max-width: 500px;
            width: 100%;
        }

        .icon {
            font-size: 64px;
            margin-bottom: 20px;
        }

        h2 {
            color: #ffffff;
            font-size: 28px;
            margin-bottom: 20px;
        }

        p {
            color: #cccccc;
            line-height: 1.6;
            margin-bottom: 30px;
            font-size: 16px;
        }

        .btn-back {
            display: inline-block;
            padding: 14px 28px;
            background: #ffffff;
            color: #000000;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
            transition: all 0.3s;
            border: 2px solid #ffffff;
        }

        .btn-back:hover {
            background: #000000;
            color: #ffffff;
            transform: translateY(-2px);
        }

        @media (max-width: 768px) {
            .message-box {
                padding: 40px 30px;
            }
        }
    </style>
</head>
<body>
<div class="message-box">
    <div class="icon"></div>
    <h2>Người Dùng Đã Bị Khóa</h2>
    <p>Người dùng này đã bị khóa và không thể thực hiện bất kỳ hành động nào trên hệ thống.</p>
    <a href="user-list.jsp" class="btn-back">🔙 Quay lại danh sách</a>
</div>
</body>
</html>