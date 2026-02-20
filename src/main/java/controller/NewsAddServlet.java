package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.New;
import model.User;
import repository.NewRepository;
import service.EmailService;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

@WebServlet("/news-add")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class NewsAddServlet extends HttpServlet {
    private NewRepository newRepository = new NewRepository();
    private static final String UPLOAD_DIRECTORY = "images";

    private static final String[] NOTIFICATION_EMAILS = {
            "anhqp1123@gmail.com"
    };

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // ✅ CHỈ Admin và Super Admin mới được thêm tin
        if (!hasAdminAccess(req)) {
            resp.sendRedirect("login?error=unauthorized");
            return;
        }
        req.getRequestDispatcher("/views/news-add.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        if (!hasAdminAccess(req)) {
            resp.sendRedirect("login?error=unauthorized");
            return;
        }

        try {
            String title = req.getParameter("title");
            String content = req.getParameter("content");
            String category = req.getParameter("category");
            String author = req.getParameter("author");
            String trendingParam = req.getParameter("trending");

            if (title == null || title.trim().isEmpty() ||
                    content == null || content.trim().isEmpty() ||
                    category == null || category.trim().isEmpty() ||
                    author == null || author.trim().isEmpty()) {

                req.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
                req.getRequestDispatcher("/views/news-add.jsp").forward(req, resp);
                return;
            }

            boolean trending = "1".equals(trendingParam);

            New news = new New();
            news.setTitle(title.trim());
            news.setContent(content.trim());
            news.setCategory(category.trim());
            news.setAuthor(author.trim());
            news.setViews(0);
            news.setTrending(trending);

            List<String> imagePaths = uploadImages(req);

            if (imagePaths.isEmpty()) {
                String defaultImage = getDefaultImageByCategory(category.trim());
                imagePaths.add(defaultImage);
            }

            news.setImagePaths(imagePaths);

            int result = newRepository.add(news);

            if (result > 0) {
                sendEmailNotification(title.trim(), category.trim(), author.trim());
                resp.sendRedirect("news-list?success=added");
            } else {
                req.setAttribute("error", "Không thể thêm bài viết. Vui lòng thử lại!");
                req.getRequestDispatcher("/views/news-add.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            req.getRequestDispatcher("/views/news-add.jsp").forward(req, resp);
        }
    }

    private void sendEmailNotification(String title, String category, String author) {
        new Thread(() -> {
            try {
                System.out.println("📧 Sending email notifications...");
                EmailService.sendBulkEmails(title, category, author, NOTIFICATION_EMAILS);
                System.out.println("✅ Email notifications sent successfully!");
            } catch (Exception e) {
                System.err.println("❌ Failed to send email notifications: " + e.getMessage());
                e.printStackTrace();
            }
        }).start();
    }

    private List<String> uploadImages(HttpServletRequest req) throws IOException, ServletException {
        List<String> imagePaths = new ArrayList<>();
        String applicationPath = req.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIRECTORY;

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        Collection<Part> parts = req.getParts();

        for (Part part : parts) {
            if (part.getName().equals("images") && part.getSize() > 0) {
                String fileName = extractFileName(part);
                String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                String filePath = uploadPath + File.separator + uniqueFileName;

                part.write(filePath);

                String relativePath = req.getContextPath() + "/" + UPLOAD_DIRECTORY + "/" + uniqueFileName;
                imagePaths.add(relativePath);
            }
        }

        return imagePaths;
    }

    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] items = contentDisposition.split(";");

        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf("=") + 2, item.length() - 1);
            }
        }

        return "";
    }

    private String getDefaultImageByCategory(String category) {
        String imageName;

        switch (category.toLowerCase()) {
            case "công nghệ":
                imageName = "technology.jpg";
                break;
            case "thể thao":
                imageName = "sports.jpg";
                break;
            case "giải trí":
                imageName = "entertainment.jpg";
                break;
            case "kinh tế":
                imageName = "economy.jpg";
                break;
            case "giáo dục":
                imageName = "education.jpg";
                break;
            case "sức khỏe":
                imageName = "health.jpg";
                break;
            case "mỹ phẩm":
                imageName = "cosmetics.jpg";
                break;
            case "gia dụng":
                imageName = "household.jpg";
                break;
            default:
                imageName = "default.jpg";
        }

        return "/images/" + imageName;
    }

    // ✅ Kiểm tra quyền Admin hoặc Super Admin
    private boolean hasAdminAccess(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return false;
        }

        User user = (User) session.getAttribute("user");
        return user != null && user.hasAdminAccess(); // role >= 1
    }
}