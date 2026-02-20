package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import repository.NewRepository;

import java.io.IOException;

@WebServlet("/news-lock")
public class NewsLockServlet extends HttpServlet {
    private NewRepository newRepository = new NewRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra đăng nhập và quyền admin
        if (!isAdmin(req)) {
            resp.sendRedirect("login");
            return;
        }

        try {
            String idParam = req.getParameter("id");

            if (idParam != null) {
                int id = Integer.parseInt(idParam);
                newRepository.deleteById(id);
            }

            resp.sendRedirect("news-list");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            resp.sendRedirect("news-list");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("news-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return false;
        }

        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        return isAdmin != null && isAdmin;
    }
}