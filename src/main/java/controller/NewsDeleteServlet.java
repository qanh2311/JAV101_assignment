package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import repository.NewRepository;

import java.io.IOException;

@WebServlet("/news-delete")
public class NewsDeleteServlet extends HttpServlet {
    private NewRepository newRepository = new NewRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra đăng nhập và quyền được phép xóa
        if (!isAdmin(req)) {
            resp.sendRedirect("login?error=unauthorized");
            return;
        }

        try {
            String idParam = req.getParameter("id");

            if (idParam != null && !idParam.trim().isEmpty()) {
                int id = Integer.parseInt(idParam);

                // Kiểm tra xem bài viết có tồn tại không
                if (newRepository.getNewById(id) != null) {
                    // Xóa bài viết
                    int result = newRepository.deleteById(id);

                    if (result > 0) {
                        // Redirect với thông báo thành công
                        resp.sendRedirect("news-list?success=deleted");
                    } else {
                        resp.sendRedirect("news-list?error=delete_failed");
                    }
                } else {
                    resp.sendRedirect("news-list?error=not_found");
                }
            } else {
                resp.sendRedirect("news-list?error=invalid_id");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            resp.sendRedirect("news-list?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("news-list?error=unknown");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    // Kiểm tra quyền được phép xóa bài viết
    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return false;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return false;
        }

        // Giả sử: 0 = user thường, 1 = admin, 2 = role mới (cũng được xóa)
        int role = user.getRole();
        return role == 1 || role == 2;  // tùy hệ thống, bạn đổi số cho đúng mapping
    }
}
