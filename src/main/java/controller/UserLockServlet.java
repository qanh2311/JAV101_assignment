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

@WebServlet("/user-lock")
public class UserLockServlet extends HttpServlet {
    private UserRepository userRepository = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // Lấy user đang đăng nhập
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect("login?error=session_expired");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            resp.sendRedirect("login?error=unauthorized");
            return;
        }

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendRedirect("user-list?error=invalid_id");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            User targetUser = userRepository.getUserById(id);

            if (targetUser == null) {
                resp.sendRedirect("user-list?error=user_not_found");
                return;
            }

            // ❌ Không cho tự khóa chính mình
            if (targetUser.getId() == currentUser.getId()) {
                resp.sendRedirect("user-list?error=cannot_lock_yourself");
                return;
            }

            // ✅ Super Admin (role=2) có thể khóa Admin (role=1) và User (role=0)
            // Chỉ cần kiểm tra không cho khóa chính mình là đủ
            userRepository.lockUserById(id);

            resp.sendRedirect("user-list?success=locked");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            resp.sendRedirect("user-list?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("user-list?error=unknown");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}