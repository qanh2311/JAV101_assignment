package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.New;
import repository.NewRepository;

import java.io.IOException;

@WebServlet("/news-detail")
public class NewsDetailServlet extends HttpServlet {
    private NewRepository newRepository = new NewRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        try {
            String idParam = req.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                resp.sendRedirect("dashboard");
                return;
            }

            int newsId = Integer.parseInt(idParam);
            New news = newRepository.getNewById(newsId);

            if (news == null) {
                resp.sendRedirect("dashboard");
                return;
            }

            // Tăng view count
            news.setViews(news.getViews() + 1);
            newRepository.update(news);

            // Lấy lại để có view count mới
            news = newRepository.getNewById(newsId);

            // LƯU DANH MỤC BÀI VỪA XEM VÀO SESSION
            HttpSession session = req.getSession();
            session.setAttribute("lastViewedCategory", news.getCategory());
            session.setAttribute("lastViewedNewsId", news.getId());

            req.setAttribute("news", news);
            req.getRequestDispatcher("/views/news-detail.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");

        if ("track".equals(action)) {
            // Xử lý tracking (nếu cần cho tương lai)
            try {
                int newsId = Integer.parseInt(req.getParameter("newsId"));
                String category = req.getParameter("category");

                HttpSession session = req.getSession();
                session.setAttribute("lastViewedCategory", category);
                session.setAttribute("lastViewedNewsId", newsId);

                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().write("OK");

            } catch (Exception e) {
                e.printStackTrace();
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        }
    }
}