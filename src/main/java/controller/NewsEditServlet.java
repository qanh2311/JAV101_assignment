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

import java.io.File;
import java.io.IOException;
import java.util.*;

@WebServlet("/news-edit")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class NewsEditServlet extends HttpServlet {
    private NewRepository newRepository = new NewRepository();

    // Thư mục lưu ảnh upload
    private static final String UPLOAD_DIRECTORY = "images";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra đăng nhập và quyền admin
        if (!isAdmin(req)) {
            resp.sendRedirect("login?error=unauthorized");
            return;
        }

        try {
            String idParam = req.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                resp.sendRedirect("news-list?error=invalid_id");
                return;
            }

            int id = Integer.parseInt(idParam);
            New news = newRepository.getNewById(id);

            if (news != null) {
                req.setAttribute("news", news);
                req.getRequestDispatcher("/views/news-edit.jsp").forward(req, resp);
            } else {
                resp.sendRedirect("news-list?error=not_found");
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
        // Đặt encoding để xử lý tiếng Việt
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // Kiểm tra đăng nhập và quyền admin
        if (!isAdmin(req)) {
            resp.sendRedirect("login?error=unauthorized");
            return;
        }

        try {
            // Lấy dữ liệu từ form
            String idParam = req.getParameter("id");
            String title = req.getParameter("title");
            String content = req.getParameter("content");
            String category = req.getParameter("category");
            String author = req.getParameter("author");
            String keepOldImages = req.getParameter("keepOldImages"); // "true" hoặc null

            // Validate dữ liệu
            if (idParam == null || idParam.trim().isEmpty() ||
                    title == null || title.trim().isEmpty() ||
                    content == null || content.trim().isEmpty() ||
                    category == null || category.trim().isEmpty() ||
                    author == null || author.trim().isEmpty()) {

                req.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
                req.getRequestDispatcher("/views/news-edit.jsp").forward(req, resp);
                return;
            }

            int id = Integer.parseInt(idParam);

            // Lấy tin hiện tại để giữ nguyên views
            New existingNews = newRepository.getNewById(id);
            if (existingNews == null) {
                resp.sendRedirect("news-list?error=not_found");
                return;
            }

            // GIỮ NGUYÊN views từ database, KHÔNG cho phép chỉnh sửa
            int views = existingNews.getViews();

            // TỰ ĐỘNG xác định trending dựa trên views
            boolean trending = (views >= 1000);

            // Tạo đối tượng News với thông tin mới
            New news = new New();
            news.setId(id);
            news.setTitle(title.trim());
            news.setContent(content.trim());
            news.setCategory(category.trim());
            news.setAuthor(author.trim());
            news.setViews(views);
            news.setTrending(trending);

            // Xử lý ảnh
            List<String> imagePaths = new ArrayList<>();

            // Nếu user chọn "Giữ ảnh cũ"
            if ("true".equals(keepOldImages)) {
                imagePaths = existingNews.getImagePaths();
            } else {
                // Upload ảnh mới
                List<String> uploadedImages = uploadImages(req);

                if (!uploadedImages.isEmpty()) {
                    // Có ảnh mới được upload
                    imagePaths = uploadedImages;

                    // Xóa ảnh cũ nếu không phải ảnh mặc định
                    deleteOldImages(existingNews.getImagePaths());
                } else {
                    // Không có ảnh mới, giữ ảnh cũ
                    imagePaths = existingNews.getImagePaths();
                }
            }

            news.setImagePaths(imagePaths);

            // Update vào database
            int result = newRepository.update(news);

            if (result > 0) {
                resp.sendRedirect("news-list?success=updated");
            } else {
                req.setAttribute("error", "Không thể cập nhật bài viết!");
                req.setAttribute("news", news);
                req.getRequestDispatcher("/views/news-edit.jsp").forward(req, resp);
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            req.setAttribute("error", "ID không hợp lệ!");
            req.getRequestDispatcher("/views/news-edit.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            req.getRequestDispatcher("/views/news-edit.jsp").forward(req, resp);
        }
    }

    // Upload ảnh và trả về danh sách đường dẫn
    private List<String> uploadImages(HttpServletRequest req) throws IOException, ServletException {
        List<String> imagePaths = new ArrayList<>();

        // Lấy đường dẫn thực tế của thư mục webapp
        String applicationPath = req.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIRECTORY;

        // Tạo thư mục nếu chưa tồn tại
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // Lấy tất cả các file được upload
        Collection<Part> parts = req.getParts();

        for (Part part : parts) {
            // Chỉ xử lý các part có tên là "images"
            if (part.getName().equals("images") && part.getSize() > 0) {
                String fileName = extractFileName(part);

                // Tạo tên file unique để tránh trùng lặp
                String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                String filePath = uploadPath + File.separator + uniqueFileName;

                // Lưu file
                part.write(filePath);

                // Lưu đường dẫn tương đối
                String relativePath = "/images/" + uniqueFileName;
                imagePaths.add(relativePath);

                System.out.println("Uploaded image: " + relativePath);
            }
        }

        return imagePaths;
    }

    // Trích xuất tên file từ Part
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

    // Xóa ảnh cũ (chỉ xóa ảnh upload, không xóa ảnh mặc định)
    private void deleteOldImages(List<String> imagePaths) {
        if (imagePaths == null || imagePaths.isEmpty()) {
            return;
        }

        // Danh sách ảnh mặc định không được xóa
        List<String> defaultImages = Arrays.asList(
                "/images/technology.jpg",
                "/images/sports.jpg",
                "/images/entertainment.jpg",
                "/images/economy.jpg",
                "/images/education.jpg",
                "/images/health.jpg",
                "/images/cosmetics.jpg",
                "/images/household.jpg",
                "/images/default.jpg"
        );

        for (String imagePath : imagePaths) {
            // Chỉ xóa ảnh upload, không xóa ảnh mặc định
            if (!defaultImages.contains(imagePath)) {
                try {
                    // Lấy đường dẫn thực tế
                    String realPath = imagePath.replace("/images/", "");
                    String applicationPath = getServletContext().getRealPath("");
                    String fullPath = applicationPath + File.separator + UPLOAD_DIRECTORY + File.separator + realPath;

                    File file = new File(fullPath);
                    if (file.exists()) {
                        file.delete();
                        System.out.println("Deleted old image: " + fullPath);
                    }
                } catch (Exception e) {
                    System.err.println("Error deleting image: " + imagePath);
                    e.printStackTrace();
                }
            }
        }
    }

    // Kiểm tra quyền admin
    // Kiểm tra quyền admin
    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return false;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return false;
        }

        // Giả sử: 0 = user thường, 1 = admin, 2 = role mới có quyền như admin
        int role = user.getRole();
        return role == 1 || role == 2;   // nếu chỉ muốn 1 role được sửa tin, thì đổi lại cho phù hợp
    }

}