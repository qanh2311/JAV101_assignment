package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import repository.UserRepository;

import java.io.IOException;

@WebServlet("/user-add")
public class UserAddServlet extends HttpServlet {
    private UserRepository userRepository = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra session
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect("login?error=session_expired");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRole() != 2) {
            resp.sendRedirect("dashboard?error=access_denied");
            return;
        }

        req.getRequestDispatcher("/views/user-add.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // Kiểm tra session
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect("login?error=session_expired");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRole() != 2) {
            resp.sendRedirect("dashboard?error=access_denied");
            return;
        }

        try {
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            int role = Integer.parseInt(req.getParameter("role"));
            boolean active = "1".equals(req.getParameter("active"));

            // ❌ Không cho tạo Super Admin (role = 2)
            if (role == 2) {
                resp.sendRedirect("user-add?error=cannot_create_superadmin");
                return;
            }

            // ✅ Chỉ cho phép tạo User (0) hoặc Admin (1)
            if (role != 0 && role != 1) {
                resp.sendRedirect("user-add?error=invalid_role");
                return;
            }

            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setRole(role);
            user.setActive(active);

            userRepository.add(user);

            resp.sendRedirect("user-list?success=added");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("user-add?error=unknown");
        }
    }
}