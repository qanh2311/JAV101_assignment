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
import java.util.List;

@WebServlet("/user-list")
public class UserListServlet extends HttpServlet {
    private UserRepository userRepository = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra session và user hiện tại
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

        // Chỉ Super Admin (role=2) mới được vào trang này
        if (currentUser.getRole() != 2) {
            resp.sendRedirect("dashboard?error=access_denied");
            return;
        }

        try {
            // Lấy tất cả user
            List<User> userList = userRepository.getAll();

            // Truyền thêm currentUser để JSP biết ai đang đăng nhập
            req.setAttribute("userList", userList);
            req.setAttribute("currentUserId", currentUser.getId());

            // Forward đến trang user-list.jsp
            req.getRequestDispatcher("/views/user-list.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("dashboard");
        }
    }
}