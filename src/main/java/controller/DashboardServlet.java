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
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private NewRepository newRepository = new NewRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        try {
            String action = req.getParameter("action");
            String category = req.getParameter("category");
            List<New> newsList = new ArrayList<>();
            String pageTitle = "📰 Trang chủ";

            if ("category".equals(action) && category != null && !category.isEmpty()) {
                // Lọc theo danh mục
                newsList = newRepository.getByCategory(category);
                pageTitle = "📂 " + category;

            } else if ("trending".equals(action)) {
                // Hiển thị tin trending
                newsList = newRepository.getTrending();
                pageTitle = "🔥 Xu hướng";

            } else if ("recommended".equals(action)) {
                // Hiển thị tin gợi ý dựa trên danh mục bài vừa xem
                RecommendationResult result = getRecommendedNews(req);
                newsList = result.newsList;
                pageTitle = result.title;

                if (result.isEmpty) {
                    req.setAttribute("message", result.message);
                }

            } else {
                // Trang chủ - hiển thị tất cả
                newsList = newRepository.getAll();
                pageTitle = "📰 Trang chủ";
            }

            req.setAttribute("newsList", newsList);
            req.setAttribute("pageTitle", pageTitle);
            req.getRequestDispatcher("/views/dashboard.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        try {
            String searchQuery = req.getParameter("search");
            List<New> newsList = new ArrayList<>();
            String pageTitle = "🔍 Kết quả lọc";

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                // Lọc theo từ khóa
                List<New> allNews = newRepository.getAll();
                String query = searchQuery.toLowerCase().trim();

                newsList = allNews.stream()
                        .filter(news ->
                                news.getTitle().toLowerCase().contains(query) ||
                                        news.getContent().toLowerCase().contains(query) ||
                                        news.getCategory().toLowerCase().contains(query) ||
                                        news.getAuthor().toLowerCase().contains(query)
                        )
                        .collect(Collectors.toList());

                pageTitle = "🔍 Kết quả lọc: \"" + searchQuery + "\"";
            } else {
                newsList = newRepository.getAll();
                pageTitle = "📰 Trang chủ";
            }

            req.setAttribute("newsList", newsList);
            req.setAttribute("pageTitle", pageTitle);
            req.getRequestDispatcher("/views/dashboard.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("dashboard");
        }
    }

    /**
     * Class để trả về kết quả gợi ý
     */
    private static class RecommendationResult {
        List<New> newsList;
        String title;
        String message;
        boolean isEmpty;

        RecommendationResult(List<New> newsList, String title, String message, boolean isEmpty) {
            this.newsList = newsList;
            this.title = title;
            this.message = message;
            this.isEmpty = isEmpty;
        }
    }

    /**
     * Gợi ý tin tức dựa trên danh mục bài vừa xem
     *
     * Logic đơn giản:
     * 1. Nếu chưa xem bài nào -> Trả về empty với thông báo
     * 2. Lấy danh mục của bài vừa xem gần nhất
     * 3. Gợi ý TẤT CẢ bài trong danh mục đó (loại trừ bài đang xem)
     * 4. Khi chuyển sang xem bài danh mục khác -> Tự động gợi ý bài của danh mục mới
     */
    private RecommendationResult getRecommendedNews(HttpServletRequest req) throws Exception {
        HttpSession session = req.getSession();

        // Lấy danh mục bài vừa xem gần nhất từ session
        String lastViewedCategory = (String) session.getAttribute("lastViewedCategory");
        Integer lastViewedNewsId = (Integer) session.getAttribute("lastViewedNewsId");

        // ✅ Nếu chưa xem bài nào -> Trả về empty
        if (lastViewedCategory == null || lastViewedCategory.isEmpty()) {
            return new RecommendationResult(
                    new ArrayList<>(),
                    "⭐ Gợi ý theo hành vi",
                    "Bạn chưa đọc bài viết nào. Hãy đọc một bài để nhận gợi ý các bài liên quan!",
                    true
            );
        }

        // ✅ Lấy TẤT CẢ bài trong danh mục của bài vừa xem
        List<New> categoryNews = newRepository.getByCategory(lastViewedCategory);

        // Loại bỏ bài đang/vừa xem
        if (lastViewedNewsId != null) {
            int currentId = lastViewedNewsId;
            categoryNews = categoryNews.stream()
                    .filter(news -> news.getId() != currentId)
                    .collect(Collectors.toList());
        }

        // Sắp xếp: Trending trước, sau đó theo views giảm dần
        categoryNews.sort((a, b) -> {
            if (a.isTrending() && !b.isTrending()) return -1;
            if (!a.isTrending() && b.isTrending()) return 1;
            return Integer.compare(b.getViews(), a.getViews());
        });

        // Tạo title và message
        String title = "⭐ Gợi ý: " + lastViewedCategory;
        String message = categoryNews.isEmpty()
                ? "Không còn bài nào khác trong danh mục này"
                : "Các bài viết khác trong danh mục " + lastViewedCategory;

        return new RecommendationResult(
                categoryNews,
                title,
                message,
                categoryNews.isEmpty()
        );
    }
}