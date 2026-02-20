package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.New;
import model.User;
import repository.NewRepository;

import java.io.IOException;
import java.util.List;

@WebServlet("/news-list")
public class NewsListServlet extends HttpServlet {
    private NewRepository newRepository = new NewRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // Kiểm tra quyền truy cập
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

        // Chỉ Admin (role=1) và Super Admin (role=2) mới được vào
        if (currentUser.getRole() < 1) {
            resp.sendRedirect("dashboard?error=access_denied");
            return;
        }

        try {
            // Lấy tất cả tin tức
            List<New> newsList = newRepository.getAll();

            // Set attribute
            req.setAttribute("newsList", newsList);

            // Forward đến trang news-list.jsp
            req.getRequestDispatcher("/views/news-list.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("dashboard?error=unknown");
        }
    }
}