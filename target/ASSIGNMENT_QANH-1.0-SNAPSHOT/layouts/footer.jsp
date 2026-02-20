<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

</main>
<!-- End of Main Content -->

<footer>
    <div class="footer-container">
        <div class="footer-section">
            <h3>📰 NEWS</h3>
            <p>Website tin tức cập nhật mới nhất về công nghệ, sản phẩm, tiêu dùng và nhiều lĩnh vực khác.</p>
        </div>
        <div class="footer-section">
            <h3>Thông tin liên hệ</h3>
            <p>
                <strong>Trường:</strong> Cao đẳng FPT Polytechnic<br>
                <strong>Địa chỉ:</strong> Số 13, Trịnh Văn Bô, Nam Từ Liêm, Hà Nội<br>
                <strong>Email:</strong> <a href="mailto:anhptqth05962@gmail.com">anhptqth05962@gmail.com</a>
            </p>
        </div>

    </div>
    <div class="copyright">
        <p>©2025 NEWS. Toàn bộ bản quyền thuộc về Anhptqth05962</p>
        <p style="margin-top: 10px; font-size: 12px;">
            Made with 🤡️ by FPT Polytechnic Students
        </p>
    </div>
</footer>

<style>

    footer {
        background: #0a0a0a;
        border-top: 2px solid #222;
        padding: 40px 20px 20px;
        margin-top: auto;
    }

    .footer-container {
        max-width: 1400px;
        margin: 0 auto;
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 40px;
        margin-bottom: 30px;
    }

    .footer-section h3 {
        font-size: 18px;
        margin-bottom: 15px;
        color: #ffffff;
    }

    .footer-section p {
        color: #999;
        line-height: 1.8;
        font-size: 14px;
    }

    .footer-section strong {
        color: #cccccc;
    }

    .footer-section a {
        color: #cccccc;
        text-decoration: none;
        transition: color 0.3s;
    }

    .footer-section a:hover {
        color: #ffffff;
    }

    .copyright {
        text-align: center;
        padding-top: 20px;
        border-top: 1px solid #222;
        color: #666;
        font-size: 14px;
    }

    .copyright p {
        margin: 0;
    }

    @media (max-width: 768px) {
        .footer-container {
            grid-template-columns: 1fr;
            gap: 30px;
        }

        .footer-section {
            text-align: center;
        }
    }
</style>

</body>
</html>