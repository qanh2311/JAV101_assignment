package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import repository.UserRepository;

import java.io.IOException;
import java.util.List;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserRepository userRepository = new UserRepository();

    // Cookie name constants
    private static final String COOKIE_USERNAME = "rememberedUsername";
    private static final String COOKIE_PASSWORD = "rememberedPassword";
    private static final int COOKIE_AGE = 7 * 24 * 60 * 60; // 7 ngày

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // Xử lý đổi ngôn ngữ
        String lang = req.getParameter("lang");
        HttpSession session = req.getSession();
        if (lang != null) {
            session.setAttribute("lang", lang);
        }
        if (session.getAttribute("lang") == null) {
            session.setAttribute("lang", "vi");
        }

        // Nếu đã đăng nhập trong session → chuyển vào dashboard
        if (session.getAttribute("user") != null) {
            resp.sendRedirect("dashboard");
            return;
        }

        // ✅ KIỂM TRA COOKIE - TỰ ĐỘNG ĐĂNG NHẬP NẾU CÓ
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            String savedUsername = null;
            String savedPassword = null;

            for (Cookie cookie : cookies) {
                if (COOKIE_USERNAME.equals(cookie.getName())) {
                    savedUsername = cookie.getValue();
                } else if (COOKIE_PASSWORD.equals(cookie.getName())) {
                    savedPassword = cookie.getValue();
                }
            }

            // 🔥 Nếu có cả username và password → Tự động đăng nhập
            if (savedUsername != null && !savedUsername.isEmpty()
                    && savedPassword != null && !savedPassword.isEmpty()) {

                User autoLoginUser = authenticateUser(savedUsername, savedPassword);

                if (autoLoginUser != null && autoLoginUser.isActive()) {
                    createUserSession(session, autoLoginUser);
                    resp.sendRedirect("dashboard");
                    return;
                }
            }
        }

        // Hiển thị trang login
        req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String rememberMe = req.getParameter("rememberMe");

        HttpSession session = req.getSession();
        String lang = (String) session.getAttribute("lang");
        if (lang == null) lang = "vi";

        // Kiểm tra input
        if (username == null || password == null ||
                username.trim().isEmpty() || password.trim().isEmpty()) {

            String errorMsg = "en".equals(lang)
                    ? "Please enter username and password!"
                    : "Vui lòng nhập tên đăng nhập và mật khẩu!";
            req.setAttribute("error", errorMsg);
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        try {
            User authenticatedUser = authenticateUser(username.trim(), password);

            if (authenticatedUser != null) {

                // Kiểm tra tài khoản bị khóa
                if (!authenticatedUser.isActive()) {
                    String errorMsg = "en".equals(lang)
                            ? "Your account has been locked. Please contact administrator!"
                            : "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên!";
                    req.setAttribute("error", errorMsg);
                    req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
                    return;
                }

                // 🔥 XỬ LÝ COOKIE
                if ("on".equals(rememberMe)) {
                    // ✅ CÓ TICK → LƯU COOKIE
                    Cookie usernameCookie = new Cookie(COOKIE_USERNAME, username.trim());
                    Cookie passwordCookie = new Cookie(COOKIE_PASSWORD, password);

                    usernameCookie.setMaxAge(COOKIE_AGE);
                    passwordCookie.setMaxAge(COOKIE_AGE);

                    usernameCookie.setPath("/");
                    passwordCookie.setPath("/");

                    usernameCookie.setHttpOnly(true);
                    passwordCookie.setHttpOnly(true);

                    resp.addCookie(usernameCookie);
                    resp.addCookie(passwordCookie);

                } else {
                    // ❌ KHÔNG TICK → XÓA COOKIE
                    clearLoginCookies(resp);
                }

                // Tạo session
                createUserSession(session, authenticatedUser);

                resp.sendRedirect("dashboard");

            } else {
                String errorMsg = "en".equals(lang)
                        ? "Invalid username or password!"
                        : "Tên đăng nhập hoặc mật khẩu không đúng!";
                req.setAttribute("error", errorMsg);
                req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = "en".equals(lang)
                    ? "An error occurred. Please try again later."
                    : "Đã có lỗi xảy ra. Vui lòng thử lại sau.";
            req.setAttribute("error", errorMsg);
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
        }
    }

    private void createUserSession(HttpSession session, User user) {
        session.setAttribute("user", user);
        session.setAttribute("username", user.getUsername());
        session.setAttribute("userRole", user.getRole());
        session.setAttribute("roleName", user.getRoleName());
        session.setAttribute("isUser", user.isUser());
        session.setAttribute("isAdmin", user.isAdmin());
        session.setAttribute("isSuperAdmin", user.isSuperAdmin());
        session.setAttribute("hasAdminAccess", user.hasAdminAccess());
        session.setMaxInactiveInterval(30 * 60); // 30 phút
    }

    private void clearLoginCookies(HttpServletResponse resp) {
        Cookie usernameCookie = new Cookie(COOKIE_USERNAME, "");
        Cookie passwordCookie = new Cookie(COOKIE_PASSWORD, "");

        usernameCookie.setMaxAge(0);
        passwordCookie.setMaxAge(0);

        usernameCookie.setPath("/");
        passwordCookie.setPath("/");

        resp.addCookie(usernameCookie);
        resp.addCookie(passwordCookie);
    }

    private User authenticateUser(String username, String password) {
        try {
            List<User> userList = userRepository.getAll();
            for (User user : userList) {
                if (user.getUsername().equals(username) &&
                        user.getPassword().equals(password)) {
                    return user;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}