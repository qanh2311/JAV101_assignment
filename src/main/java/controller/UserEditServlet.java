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

@WebServlet("/user-edit")
public class UserEditServlet extends HttpServlet {
    private UserRepository userRepository = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // Kiểm tra session
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

            // ❌ Không cho sửa chính mình
            if (targetUser.getId() == currentUser.getId()) {
                resp.sendRedirect("user-list?error=cannot_edit_yourself");
                return;
            }

            req.setAttribute("user", targetUser);
            req.getRequestDispatcher("/views/user-edit.jsp").forward(req, resp);

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
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // Kiểm tra session
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
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String roleParam = req.getParameter("role");
        String activeParam = req.getParameter("active");

        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendRedirect("user-list?error=invalid_id");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            int role = Integer.parseInt(roleParam);
            boolean active = "1".equals(activeParam);

            User targetUser = userRepository.getUserById(id);
            if (targetUser == null) {
                resp.sendRedirect("user-list?error=user_not_found");
                return;
            }

            // ❌ Không cho sửa chính mình
            if (targetUser.getId() == currentUser.getId()) {
                resp.sendRedirect("user-list?error=cannot_edit_yourself");
                return;
            }

            targetUser.setUsername(username);
            targetUser.setPassword(password);
            targetUser.setRole(role);
            targetUser.setActive(active);

            userRepository.update(targetUser);

            resp.sendRedirect("user-list?success=updated");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            resp.sendRedirect("user-list?error=invalid_number");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("user-list?error=unknown");
        }
    }
}