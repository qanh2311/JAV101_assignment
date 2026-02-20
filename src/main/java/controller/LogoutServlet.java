package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handleLogout(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        handleLogout(req, resp);
    }

    private void handleLogout(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            // ⭐ BẮT BUỘC: XÓA COOKIE KHI LOGOUT (để có thể đăng nhập tài khoản khác)
            Cookie[] cookies = req.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("rememberedUsername".equals(cookie.getName()) ||
                            "rememberedPassword".equals(cookie.getName())) {
                        cookie.setMaxAge(0); // Xóa cookie ngay lập tức
                        cookie.setPath("/");
                        cookie.setValue(""); // Xóa giá trị
                        resp.addCookie(cookie);
                    }
                }
            }

            // Xóa session
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }

            // Chuyển về trang login (không còn cookie → không auto-login)
            resp.sendRedirect("login");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("login");
        }
    }
}